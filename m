From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/2] convert libsas to the libata new eh
Date: Wed, 26 Jan 2011 09:08:51 -0500
Message-ID: <1296050931.4893.9.camel@mulgrave.site>
References: <1295797260.3007.118.camel@mulgrave.site>
	 <4D3F1CC6.5080208@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D3F1CC6.5080208@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Robert Jennings <rcj@linux.vnet.ibm.com>, Wayne Boyer <wayneb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-01-25 at 12:56 -0600, Brian King wrote:
> On 01/23/2011 09:41 AM, James Bottomley wrote:
> > The bad news is that this is a pretty horrific conversion.  Because of
> > the amount of control the new eh wants (and the slew of monolithic
> > assumptions it makes), the entire error handler routine has to be sliced
> > apart and sewn back together to make it callable as part of an existing
> > error handler (rather than trying to do everything on its own).
> > 
> > The even worse news is that unless you have an existing strategy
> > handler, you can't make use of this.  That means that ipr is
> > unconvertable in its current form.  Given the two really nasty options:
> > give ipr its own error handler via its own transport class, or attach
> > ipr to libsas and let it do the work, I'd choose the latter.
> 
> I've got a patch set that's been sitting collecting dust for quite some time
> that implements yet another option. The basic idea is that we move away from
> the idea of having a single scsi_host for the entire SAS adapter, but
> rather have one for the SAS devices and one for each SATA rphy.

So, as I said already, I think this is a pretty nasty hack.  A host
represents a single attachment to the bus (usually a card).  We have a
lot of logic that crawls up the device tree looking for the host.  If we
have multiple hosts in the hierarchy, that logic will always find the
dummy one.

> This allows us to use libata's EH pretty much as is, but does introduce
> some issues to solve:
> 
> 1. Adapter queue depth. Since we have multiple scsi_hosts for a single
>    HBA, we lose the adapter queue depth tracking done by scsi core.
>    Anything in block that can help us here?
> 2. Locking gets messy since we have a lock for each sata rphy as well
>    as one for the sas scsi_host.
> 
> There were some other smaller issues as well. I liked the idea of moving
> to multiple scsi_host's since that eliminates the issue of userspace polling an
> empty CD drive causing EH to get invoked and quiescing all SAS I/O as well,
> but it does result in potentially a lot of scsi_hosts getting created.

I think better might be to move the eh thread functionality into block.
What libata really wants is one eh thread per phy.  It gets this by
completely abusing the idea of a host.  There's actually good reasons
why most of our modern HBAs would like one eh per port ... which would
amount to per-phy on ata which can't do wide ports.  If we allowed the
driver to determine the correct level for this, and block to provide the
machinery, everyone should get what they want, and libata could dispense
with its current corruption of multiple SCSI hosts per physical bus
attachment.

James


