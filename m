From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 03/12] libata, libsas: introduce sched_eh and end_eh
 port ops
Date: Mon, 23 Apr 2012 23:22:57 +0100
Message-ID: <1335219777.2749.11.camel@dabdike.lan>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	 <20120413233706.8025.56546.stgit@dwillia2-linux.jf.intel.com>
	 <1335115828.13208.31.camel@dabdike.lan> <4F94BF90.4090001@garzik.org>
	 <1335168621.3051.8.camel@dabdike.lan>
	 <CABE8wwtd2c14dq8vWCtO_rEvk8i8Q8GzJ3NtS_YQVmpTUaF3=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwtd2c14dq8vWCtO_rEvk8i8Q8GzJ3NtS_YQVmpTUaF3=w@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-04-23 at 12:13 -0700, Dan Williams wrote:
> On Mon, Apr 23, 2012 at 1:10 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Sun, 2012-04-22 at 22:33 -0400, Jeff Garzik wrote:
> >> On 04/22/2012 01:30 PM, James Bottomley wrote:
> >> > On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
> >> >> When managing shost->host_eh_scheduled libata assumes that there is a
> >> >> 1:1 shost-to-ata_port relationship.  libsas creates a 1:N relationship
> >> >> so it needs to manage host_eh_scheduled cumulatively at the host level.
> >> >> The sched_eh and end_eh port port ops allow libsas to track when domain
> >> >> devices enter/leave the "eh-pending" state under ha->lock (previously
> >> >> named ha->state_lock, but it is no longer just a lock for ha->state
> >> >> changes).
> >> >>
> >> >> Since host_eh_scheduled indicates eh without backing commands pinning
> >> >> the device it can be deallocated at any time.  Move the taking of the
> >> >> domain_device reference under the port_lock to guarantee that the
> >> >> ata_port stays around for the duration of eh.
> >> >
> >> >> Cc: Tejun Heo<tj@kernel.org>
> >> >> Acked-by: Jacek Danecki<jacek.danecki@intel.com>
> >> >
> >> > Could we standardise on Acked-by, please.  In my book it means the
> >> > maintainer of a piece of code agrees with the change and lets me take it
> >> > through my tree.  I'm aware that not everyone uses this definition, so
> >> > we can use a different standard from my current one, but what does it
> >> > mean in this case?
> >>
> >> The above, IMO, should be s/Acked-by/Signed-off-by/
> >
> > Yes, I suspect this too.
> 
> No, it means:
> 
> "If a person was not directly involved in the preparation or handling of a
> patch but wishes to signify and record their approval of it then they can
> arrange to have an Acked-by: line added to the patch's changelog."

Isn't that tested-by or reviewed-by?

> "Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
> has at least reviewed the patch and has indicated acceptance.  Hence patch
> mergers will sometimes manually convert an acker's "yep, looks good to me"
> into an Acked-by:"

Reviewed-by is the appropriate one for that then.  Acked-by usually
means the person has more involvement in the particular subsystem than
would be implied by reviewed-by.  Like I said, I tend to reserve
acked-by for maintainers of the various elements that have to go through
different trees.

> What's wrong with Acked-by?  Signed-off-by involves co-authorship or
> handled the patch, Reviewed-by is probably better, but maybe not
> everyone is comfortable asserting the "Reviewer's statement of
> oversight".  I'll certainly continue to take Jack's "looks ok to me "
> as Acked-by the pm8001 maintainer for libsas changes that don't touch
> drivers/scsi/pm8001.

Right, so reviewed by or approved by the maintainer == acked-by.

> For internal acks we should probably aim for promoting to Reviewed-by
> or Tested-by... if Acked-by is unwelcome in scsi.

We're just struggling to understand why it's there.  If it's read and
approved the patch, then reviewed-by is the more appropriate.  If it's
actually booted and ran through a set of unit/QA tests, then it should
be tested-by.

James


