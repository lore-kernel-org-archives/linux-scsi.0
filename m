From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Date: Thu, 16 Jul 2009 02:26:42 +0100
Message-ID: <20090716012642.GA1269@srcf.ucam.org>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com> <1247706748.8632.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1247706748.8632.3.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 16, 2009 at 01:12:28AM +0000, James Bottomley wrote:
> On Thu, 2009-07-16 at 00:43 +0100, Matthew Garrett wrote:
> > Userspace may wish to make policy decisions based on whether a host
> > supports device hotplug or not - for example, AHCI link power management
> > disables hotplug, so may only be desirable on hotplug ports. Add
> > support for marking hosts as hotpluggable in order to allow userspace to
> > treat them appropriately.
> 
> OK, so I don't really understand what the hotplug flag means.
> 
> You seem to be setting it unconditionally on most sata HBAs.  If it just
> means "bus is hotpluggable", it should be set to 1 at initialisation and
> the few non hot plug busses (like SPI) get to reset it.

It's a tossup. PATA's not hotpluggable (in the general case), so I just 
picked a default and went with it. Inverting it would be easy enough, I 
guess.

> However, by definition SATA (like SAS) is a hotplug bus ... why isn't it
> set for some SATA controllers ... is it because the HBA itself does
> something wrong when a hotplug event comes in?

Some older controllers don't provide direct access to the phy registers, 
so there's no way to interpret hotplug events correctly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
