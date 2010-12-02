From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Thu, 2 Dec 2010 23:44:03 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED709113B13@inbmail01.lsi.com>
References: <1290971729.2814.13.camel@larosa>
  <alpine.LNX.2.00.1011291857420.7923@kai.makisara.local>
  <1291123886.2181.1347.camel@quux.techfak.uni-bielefeld.de>
  <4CF521DE.7020800@panasas.com>
  <alpine.LNX.2.00.1011301821210.9731@kai.makisara.local>
  <4CF52A03.2000704@panasas.com>
  <alpine.LNX.2.00.1011301853300.9731@kai.makisara.local>
  <4CF53349.10509@panasas.com>
  <alpine.LNX.2.00.1011302139460.9731@kai.makisara.local>
 <1291196400.2814.34.camel@larosa>
 <B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
 <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39101 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab0LBSNx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Dec 2010 13:13:53 -0500
In-Reply-To: <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de>, Boaz Harrosh <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Kai Makisara [mailto:Kai.Makisara@kolumbus.fi]
> Sent: Thursday, December 02, 2010 9:53 PM
> To: Desai, Kashyap
> Cc: Lukas Kolbe; Boaz Harrosh; linux-scsi@vger.kernel.org
> Subject: RE: After memory pressure: can't read from tape anymore
> 
> On Thu, 2 Dec 2010, Desai, Kashyap wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: Lukas Kolbe [mailto:lkolbe@techfak.uni-bielefeld.de]
> > > Sent: Wednesday, December 01, 2010 3:10 PM
> > > To: Kai Makisara
> > > Cc: Boaz Harrosh; linux-scsi@vger.kernel.org; Desai, Kashyap
> > > Subject: Re: After memory pressure: can't read from tape anymore
> > >
> > > Am Dienstag, den 30.11.2010, 21:53 +0200 schrieb Kai Makisara:
> > > > On Tue, 30 Nov 2010, Boaz Harrosh wrote:
> > >
> > > I'm Cc'ing Desay Kashyap from LSI, maybe he can comment on the
> hardware
> > > limitations of the SAS1068E?
> > Lukas,
> >
> > No. it is not limitation from h/w that " CONFIG_FUSION_MAX_SGE" needs
> to be 128.
> > But our code is written such a way that even if you change it more
> than 128, it will fall down to 128 again.
> >
> > To change this value you need to do below changes in mptbase.h
> >
> > --
> > -#define MPT_SCSI_SG_DEPTH     CONFIG_FUSION_MAX_SGE
> > +#define MPT_SCSI_SG_DEPTH       256
> > --
> >
> > 128 is good amount for Scatter gather element. This value is standard
> value for MPT FUSIION, since long.
> >
> > This value will be reflect to sg_tablesize and linux scatter-gather
> module will use this value for creating sg_table for HBA.
> > See: " cat /sys/class/scsi_host/host<x>/sg_tablesize"
> >
> > If single IO is not able to fit into sg_tablesize, then it will be
> converted into multiple IOs for Low Layer Drivers(By "scatter-gather"
> module of linux).
> > So I do not see any problem with
> > CONFIG_FUSION_MAX_SGE value.  Our driver internally convert sglist
> into SGE which understood by LSI H/W.
> >
> You can't convert write of one block into multiple IOs. If someone
> wants
> to write 2 MB blocks, the system must transfer 2 MB in one IO. The
> choices
> are:

I am not sure why single IO cannot be converted into multiple "IO" request.
If you run below commands
" sg_dd if=/dev/zero of=/dev/sdb bs=4800000 count=1"

You will see multiple IOs(requests) are coming to low layer driver. 

> 
> 1. Direct I/O from user space. With 4 kB page size, this means that 513
> s/g segments (512 if the user buffer page is aligned) must be used.
> (Unless there is an IOMMU and an API for an ULD to use it.)
> 
> 2. Use a bounce buffer. Dynamic allocation of the bounce buffer with a
> small number of segments is problematic when the system has been
> running
> for a long time but the buffer can be allocated when the device is
> detected. (This is problematic if the device is detected at run-time.)
> 
> I don't know which alternative is more efficient from the HW point of
> view
> if both are possible. Do you (or someone else) have any opinion on
> this?

Regarding above things, I am not sure too, why this has to be part of Low level driver?
It has to be done my block layer.... 
> 
> Kai
