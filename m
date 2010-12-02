From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Thu, 2 Dec 2010 18:22:33 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
References: <1290971729.2814.13.camel@larosa>  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>  <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>  <4CF521DE.7020800@panasas.com>  <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
 <4CF52A03.2000704@panasas.com>  <alpine.LNX.2.00.1011301853300.9731@kai.makisara.local>  <4CF53349.10509@panasas.com>  <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local> <1291196400.2814.34.camel@larosa>
 <B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs10.mail.saunalahti.fi ([195.197.172.105]:41193 "EHLO
	vs10.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab0LBQWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 11:22:44 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>, Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2 Dec 2010, Desai, Kashyap wrote:

> 
> 
> > -----Original Message-----
> > From: Lukas Kolbe [mailto:lkolbe@techfak.uni-bielefeld.de]
> > Sent: Wednesday, December 01, 2010 3:10 PM
> > To: Kai Makisara
> > Cc: Boaz Harrosh; linux-scsi@vger.kernel.org; Desai, Kashyap
> > Subject: Re: After memory pressure: can't read from tape anymore
> > 
> > Am Dienstag, den 30.11.2010, 21:53 +0200 schrieb Kai Makisara:
> > > On Tue, 30 Nov 2010, Boaz Harrosh wrote:
> > 
> > I'm Cc'ing Desay Kashyap from LSI, maybe he can comment on the hardware
> > limitations of the SAS1068E?
> Lukas,
> 
> No. it is not limitation from h/w that " CONFIG_FUSION_MAX_SGE" needs to be 128.
> But our code is written such a way that even if you change it more than 128, it will fall down to 128 again.
> 
> To change this value you need to do below changes in mptbase.h
> 
> --
> -#define MPT_SCSI_SG_DEPTH     CONFIG_FUSION_MAX_SGE
> +#define MPT_SCSI_SG_DEPTH       256
> --
> 
> 128 is good amount for Scatter gather element. This value is standard value for MPT FUSIION, since long.
> 
> This value will be reflect to sg_tablesize and linux scatter-gather module will use this value for creating sg_table for HBA.
> See: " cat /sys/class/scsi_host/host<x>/sg_tablesize"
> 
> If single IO is not able to fit into sg_tablesize, then it will be converted into multiple IOs for Low Layer Drivers(By "scatter-gather" module of linux).
> So I do not see any problem with 
> CONFIG_FUSION_MAX_SGE value.  Our driver internally convert sglist into SGE which understood by LSI H/W.
> 
You can't convert write of one block into multiple IOs. If someone wants 
to write 2 MB blocks, the system must transfer 2 MB in one IO. The choices 
are:

1. Direct I/O from user space. With 4 kB page size, this means that 513 
s/g segments (512 if the user buffer page is aligned) must be used. 
(Unless there is an IOMMU and an API for an ULD to use it.)

2. Use a bounce buffer. Dynamic allocation of the bounce buffer with a 
small number of segments is problematic when the system has been running 
for a long time but the buffer can be allocated when the device is 
detected. (This is problematic if the device is detected at run-time.)

I don't know which alternative is more efficient from the HW point of view 
if both are possible. Do you (or someone else) have any opinion on this?

Kai
