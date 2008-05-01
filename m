From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 23:41:38 +0200
Message-ID: <481A3912.8070507@firstfloor.org>
References: <4819C9DB.60104@panasas.com>	 <1209651854.3067.8.camel@localhost.localdomain>	 <4819DA39.70505@panasas.com>	 <1209655360.3067.14.camel@localhost.localdomain>	 <4819E371.2040403@panasas.com>	 <1209656838.3067.16.camel@localhost.localdomain>	 <4819E8C7.3040808@panasas.com>	 <1209657731.3067.19.camel@localhost.localdomain>	 <4819EEEE.5030205@panasas.com>	 <1209659881.14864.4.camel@localhost.localdomain>	 <4819F894.6020009@panasas.com>	 <1209663229.14864.18.camel@localhost.localdomain>	 <481A087D.10707@panasas.com> <1209673979.14864.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1209673979.14864.23.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


> But most of what you're doing in that patch set doesn't work.  The whole
> reason for separating the sense buffer from the scsi command is the DMA
> problem of cache line interference caused by doing DMA to an area
> embedded in a structure that has host accessed variables in it.  With
> what you're doing embedding the sense buffer in the internal control
> areas, you're re-introducing that bug.

Hmm if that was really a problem it would be trivial to pad it to cache
lines. On what card did you see that? Also I don't think the current
sense pool is cache line aligned anyways, so there is already
potentially this problem with other data.

Anyways from my audit of the ISA drivers I found that very few (only one
or two) do actually DMA to the sense buffer anyways. Most just memcpy
it from somewhere else. DMA is really the oddball case for the ISA
drivers (that is why with the old unchecked_isa_dma there was a lot of
unnecessary work for this)

> Additionally, it really doesn't make sense for every driver to do a roll
> your own allocator.  

It is only a very small number of drivers. And GFP_DMA in the mid layer
has many problems.

> It makes far more sense for them to be allocated
> centrally (and correctly) so there's only one place it needs fixing if
> there's yet another problem discovered.

The main issue with GFP_DMA in the mid layer (that is why i started my
patchkit originally) was that GFP_DMA does not work very well. First it
means different things on different architectures, then on x86 if you go
outside old legacy ISA drivers the drivers with limited DMA masks
typically don't need 24bit but something larger. I think for such
special situations (again we're talking only about a relatively small
number of drivers) it is much better to do the mapping and allocation in
the low level driver who knows far better what it really needs.

-Andi


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
