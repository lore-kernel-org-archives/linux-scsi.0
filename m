From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 11:53:30 +0200
Message-ID: <519C959A.3090100@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130522093249.GC3466@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 22/05/2013 11:32, Tejun Heo ha scritto:
> On Wed, May 22, 2013 at 08:35:54AM +0200, Paolo Bonzini wrote:
>> I'm not sure what is more ridiculous, whether the seven pings or the
>> lack of review...
> 
> So, ummm, I don't know what Jens is thinking but at this point I'm
> basically waiting for someone else to pick it up as review to return
> ratio is too low to continue.  It doesn't seem like I can get the
> series into a shape I can ack with reasonable amount of effort.

Then please say so.  I didn't find any comment in your review that I missed.

> My memory is kinda hazy now but here are two review points that came
> to my mind before giving up.
> 
> * The response that I got after asking for justification basically
>   boiled down to "it has to".  Whatever that means.

For patches 1-4, it means that you're allowed to write to media when a
file is opened for reading.  The patches fix this.

For patches 5-12, it means that you currently need root-equivalent
privileges (CAP_SYS_RAWIO) to do "regular business" on any SCSI device
that is not a CD-ROM or a tape or a disk.

For patches 13-14, it means that you currently need root-equivalent
privileges (CAP_SYS_RAWIO) to do operations on SCSI devices that require
some level of trust, hence there is no way to confine this to a single
device.

But all this is in the cover letter, I'm just paraphrasing.

> * In the patch series, fixes and feature changes are still mixed in
>   order.  I gave up after this.

Bugfixes are in patch 1-4.  The patches first introduce the new table
format without any semantic change, then they introduce per-class
filters while still leaving the conflicting commands accessible with
O_RDONLY, and finally fix the bug.  If you have any better ideas, please
tell me.  I did try to optimize for reviewability and bisectability, if
I screwed up I'd like to hear why.

Whitelisting of extra commands is in patch 5-10.  Additional related
changes are in patches 11-14.

Again, all this is in the cover letter.

Paolo
