From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [set5 PATCH 0/6] scsi, async: asynchronous probing rework /
 fixes
Date: Fri, 29 Jun 2012 10:06:35 +0100
Message-ID: <1340960795.2907.34.camel@dabdike.int.hansenpartnership.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
	 <CAA9_cmejubhZRXkUc_-FYhgD3B0sjR8p4YO3VkgcxWvisd-RWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmejubhZRXkUc_-FYhgD3B0sjR8p4YO3VkgcxWvisd-RWg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-06-28 at 15:22 -0700, Dan Williams wrote:
> On Thu, Jun 21, 2012 at 11:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > Set5 of 5 patchsets to update scsi, libsas, and libata in
> > support of the isci driver.
> >
> > Commit 43a8d39d "[SCSI] fix async probe regression" found that
> > async_synchronize_full() was missing async work that was scheduled to
> > its own domain.  This led James to note:
> >
> >      "My theory is that this is an init problem: The assumption in a lot of
> >       our code is that async_synchronize_full() waits for everything ... even
> >       the domain specific async schedules, which isn't true."
> >
> > ...and this set aims to make that assumption true, but also with the
> > ability to opt-out for "private" async work.
> >
> > The other async probe fix is in the area of unplug events that occur in
> > the scsi async scanning interval.  Essentially scsi_remove_target() can
> > now see semi-initialized scsi_targets that have yet to be added via
> > device_add().
> >
> > If there are no objections I'll put these in -next.  But I expect at
> > least patch1 and patch2 will need an ack from Arjan before the set shows
> > up in scsi.git.
> >
> > ---
> 
> James,
> 
> I caught a couple conflicts with scsi.git/for-next and was able to fix
> them up without rebasing on top of your tree.  I'll resend the series
> after letting these sit in -next for a while, or I can prepare a tag
> for you to pull with the whole pending set.

Ideally, I'd like acks from Arjan as the original async author before we
commit it in stone (which is what effectively happens for a signed tag).

Could you resend the series now and I'll bother him for the two we need
his ack on.

Thanks,

James


> >
> > Dan Williams (6):
> >      async: introduce 'async_domain' type
> 
> dropped the include of async.h
> 
> >      async: make async_synchronize_full() flush all work regardless of domain
> >      scsi: queue async scan work to an async_schedule domain
> >      scsi: cleanup usages of scsi_complete_async_scans
> 
> dropped the changes to scsi_wait_scan.c since that file is deleted in
> your for-next branch.
