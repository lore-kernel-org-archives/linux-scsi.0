From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Fri, 3 Dec 2010 16:15:34 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED709113BDA@inbmail01.lsi.com>
References: <1291196400.2814.34.camel@larosa>
	<B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
	<alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
 <20101203191014K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39893 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756323Ab0LCKpX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 05:45:23 -0500
In-Reply-To: <20101203191014K.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>
Cc: "lkolbe@techfak.uni-bielefeld.de" <lkolbe@techfak.uni-bielefeld.de>, "bharrosh@panasas.com" <bharrosh@panasas.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> Sent: Friday, December 03, 2010 3:43 PM
> To: Kai.Makisara@kolumbus.fi
> Cc: Desai, Kashyap; lkolbe@techfak.uni-bielefeld.de;
> bharrosh@panasas.com; linux-scsi@vger.kernel.org
> Subject: RE: After memory pressure: can't read from tape anymore
> 
> On Thu, 2 Dec 2010 18:22:33 +0200 (EET)
> Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:
> 
> > > -#define MPT_SCSI_SG_DEPTH     CONFIG_FUSION_MAX_SGE
> > > +#define MPT_SCSI_SG_DEPTH       256
> > > --
> > >
> > > 128 is good amount for Scatter gather element. This value is
> standard value for MPT FUSIION, since long.
> > >
> > > This value will be reflect to sg_tablesize and linux scatter-gather
> module will use this value for creating sg_table for HBA.
> > > See: " cat /sys/class/scsi_host/host<x>/sg_tablesize"
> > >
> > > If single IO is not able to fit into sg_tablesize, then it will be
> converted into multiple IOs for Low Layer Drivers(By "scatter-gather"
> module of linux).
> > > So I do not see any problem with
> > > CONFIG_FUSION_MAX_SGE value.  Our driver internally convert sglist
> into SGE which understood by LSI H/W.
> > >
> > You can't convert write of one block into multiple IOs. If someone
> wants
> > to write 2 MB blocks, the system must transfer 2 MB in one IO. The
> choices
> > are:
> 
> I'm not sure that Kashyap is talking about multiple IO requests.
> 
> SGE is LSI H/W's data structure to describe the set of a dma address
> and a transfer length. LSI H/W can chain SGE so if you pass large
> scatter-gather to the driver, it leads to single SCSI command with
> changed multiple SGEs. I suppose mpt2sas can handle more than 256
> scatter gatters.

Let me add some more input.

I do not see any problem with any parameters in driver is playing role in this issue.
As earlier suggested by Kai, they think changing " CONFIG_FUSION_MAX_SGE" will help.

But I see maximum value for " CONFIG_FUSION_MAX_SGE" is 128 only and we can not go beyond this.
I see scsi_alloc_queue below lines 

      blk_queue_max_hw_segments(q, shost->sg_tablesize);
        blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);

both the values play role while selecting max scatter gather elements.. 
Where max_hw_segements are equal to value of " CONFIG_FUSION_MAX_SGE", but max_phys_segements are limited to  below value
#define SCSI_MAX_SG_SEGMENTS    128 (defined in scsi.h)

Even for mpt2sas " SCSI_MPT2SAS_MAX_SGE" is 128.


