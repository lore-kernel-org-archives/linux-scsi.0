From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Fri, 3 Dec 2010 19:13:18 +0900
Message-ID: <20101203191014K.fujita.tomonori@lab.ntt.co.jp>
References: <1291196400.2814.34.camel@larosa>
	<B2FD678A64EAAD45B089B123FDFC3ED709113ABB@inbmail01.lsi.com>
	<alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39393 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab0LCKNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 05:13:43 -0500
In-Reply-To: <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: Kashyap.Desai@lsi.com, lkolbe@techfak.uni-bielefeld.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org

On Thu, 2 Dec 2010 18:22:33 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> > -#define MPT_SCSI_SG_DEPTH     CONFIG_FUSION_MAX_SGE
> > +#define MPT_SCSI_SG_DEPTH       256
> > --
> > 
> > 128 is good amount for Scatter gather element. This value is standard value for MPT FUSIION, since long.
> > 
> > This value will be reflect to sg_tablesize and linux scatter-gather module will use this value for creating sg_table for HBA.
> > See: " cat /sys/class/scsi_host/host<x>/sg_tablesize"
> > 
> > If single IO is not able to fit into sg_tablesize, then it will be converted into multiple IOs for Low Layer Drivers(By "scatter-gather" module of linux).
> > So I do not see any problem with 
> > CONFIG_FUSION_MAX_SGE value.  Our driver internally convert sglist into SGE which understood by LSI H/W.
> > 
> You can't convert write of one block into multiple IOs. If someone wants 
> to write 2 MB blocks, the system must transfer 2 MB in one IO. The choices 
> are:

I'm not sure that Kashyap is talking about multiple IO requests.

SGE is LSI H/W's data structure to describe the set of a dma address
and a transfer length. LSI H/W can chain SGE so if you pass large
scatter-gather to the driver, it leads to single SCSI command with
changed multiple SGEs. I suppose mpt2sas can handle more than 256
scatter gatters.
