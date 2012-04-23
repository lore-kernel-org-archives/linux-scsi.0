From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 03/12] libata, libsas: introduce sched_eh and end_eh
 port ops
Date: Mon, 23 Apr 2012 09:10:21 +0100
Message-ID: <1335168621.3051.8.camel@dabdike.lan>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	 <20120413233706.8025.56546.stgit@dwillia2-linux.jf.intel.com>
	 <1335115828.13208.31.camel@dabdike.lan> <4F94BF90.4090001@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4F94BF90.4090001@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-04-22 at 22:33 -0400, Jeff Garzik wrote:
> On 04/22/2012 01:30 PM, James Bottomley wrote:
> > On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
> >> When managing shost->host_eh_scheduled libata assumes that there is a
> >> 1:1 shost-to-ata_port relationship.  libsas creates a 1:N relationship
> >> so it needs to manage host_eh_scheduled cumulatively at the host level.
> >> The sched_eh and end_eh port port ops allow libsas to track when domain
> >> devices enter/leave the "eh-pending" state under ha->lock (previously
> >> named ha->state_lock, but it is no longer just a lock for ha->state
> >> changes).
> >>
> >> Since host_eh_scheduled indicates eh without backing commands pinning
> >> the device it can be deallocated at any time.  Move the taking of the
> >> domain_device reference under the port_lock to guarantee that the
> >> ata_port stays around for the duration of eh.
> >
> >> Cc: Tejun Heo<tj@kernel.org>
> >> Acked-by: Jacek Danecki<jacek.danecki@intel.com>
> >
> > Could we standardise on Acked-by, please.  In my book it means the
> > maintainer of a piece of code agrees with the change and lets me take it
> > through my tree.  I'm aware that not everyone uses this definition, so
> > we can use a different standard from my current one, but what does it
> > mean in this case?
> 
> The above, IMO, should be s/Acked-by/Signed-off-by/

Yes, I suspect this too.

> FWIW this also has
> 
> 	Acked-by: Jeff Garzik <jgarzik@redhat.com>
> 
> as noted days ago in another thread.

Understood, will add.

James


