From: Chetan.Loke@Emulex.Com
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA - V3.
Date: Thu, 3 Sep 2009 15:21:23 -0700
Message-ID: <412A05BA40734D4887DBC67661F433080FF72585@EXMAIL.ad.emulex.com>
References: <1252006675.18725.20.camel@ank32.eng.vmware.com>
 <4AA03A9F.2040500@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:35219 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZICWVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2009 18:21:36 -0400
In-Reply-To: <4AA03A9F.2040500@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com, akataria@vmware.com
Cc: James.Bottomley@suse.de, eike-kernel@sf-tec.de, matthew@wil.cx, rdreier@cisco.com, bvanassche@acm.org, robert.w.love@intel.com, randy.dunlap@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, pv-drivers@vmware.com

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Brian King
> Sent: Thursday, September 03, 2009 5:53 PM
> To: akataria@vmware.com
> Cc: James Bottomley; Rolf Eike Beer; Matthew Wilcox; Roland Dreier; Bart
> Van Assche; Robert Love; Randy Dunlap; Mike Christie; linux-
> scsi@vger.kernel.org; LKML; Andrew Morton; pv-drivers@vmware.com
> Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V3.
> 
> Alok Kataria wrote:
> > +
> > +struct pvscsi_adapter {
> > +	char			*mmioBase;
> > +	unsigned int		irq;
> > +	u8			rev;
> > +	bool			use_msi;
> > +	bool			use_msix;
> > +	bool			use_msg;
> > +
> > +	spinlock_t		hw_lock;
> 
> Why not just use host_lock in the scsi_host structure?
> 

Why not an adapter_resource_lock? Why block everyone @ the scsi-mid layer. 

Alok, 

(This is just a optimization.You don't need it in order to get your code merged upstream.You can always patch it later on)In fact hw_lock should be split into two locks - 

req_path_lock(aka tx_lock) and 
cmpl_path_lock(aka rx_lock).

You can then have a full-duplex channel.

Revised-code - 
	::pvscsi_acquire_context->spin_lock_irqsave(tx_lock)
	::pvscsi_isr->spin_lock_irqsave(rx_lock)
	::some_future_napi_style_pvrx_poll_func->spin_lock_irqsave(rx_lock)
	
	::for aborts synchronize on the rx_lock so that you know what's completed and what's not.

This is the kind of common code that should be provided by the bottom edge of the scsi-layer so that all the scsi-LLDD's can split their tx/rx paths!




> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 


Chetan
