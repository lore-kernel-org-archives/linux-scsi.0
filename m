From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Wed, 18 Jan 2012 11:00:19 -0800
Message-ID: <CAL1RGDXX2FH_MoE-W40WOzymmfyFWVE8vmVoAUtPxufGe408EQ@mail.gmail.com>
References: <4EF2026F.2090506@redhat.com> <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
 <4F1706AD.3080405@redhat.com> <CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
 <CAO+b5-qHGLXr7HtzV9R81sk8=h_L2i9-pR+uZ7yrGiKktsGZUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-qHGLXr7HtzV9R81sk8=h_L2i9-pR+uZ7yrGiKktsGZUQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 18, 2012 at 10:51 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>> cf http://www.spinics.net/lists/linux-scsi/msg56254.html

> With which SCSI low-level diver does that occur and how does the call
> stack look like ? I haven't encountered any such issues while testing
> the srp-ha patch set. However, I have to admit that the issues
> mentioned in the description of commit 3308511 were discovered while
> testing the srp-ha patch set.

I assume you're asking about the crash on hot unplug...

Anyway, I've seen it with mp2tsas, looking like

 [<ffffffff8130078b>] scsi_setup_blk_pc_cmnd+0x2b/0x170
 [<ffffffff8130091d>] scsi_prep_fn+0x4d/0x60
 [<ffffffff81227794>] blk_peek_request+0xb4/0x240
 [<ffffffff813010cd>] scsi_request_fn+0x47d/0x4b0
 [<ffffffff81223bff>] __blk_run_queue+0x1f/0x80
 [<ffffffff8122b808>] blk_execute_rq_nowait+0x68/0xc0

in my case I think there is some SG_IO stuff in flight
for SCSI reservations; the cdrom case I linked to also
has scsi_setup_blk_pc_cmnd in the trace and mentions
an ioctl for medium presence.  So maybe regular block
IO is OK now but not non-IO commands.

 - R.
