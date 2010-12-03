From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: After memory pressure: can't read from tape anymore
Date: Fri, 3 Dec 2010 20:11:08 +0900
Message-ID: <20101203200758P.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LNX.2.00.1012021807060.9213@kai.makisara.local>
	<20101203191014K.fujita.tomonori@lab.ntt.co.jp>
	<B2FD678A64EAAD45B089B123FDFC3ED709113BDA@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39839 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab0LCLL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Dec 2010 06:11:28 -0500
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED709113BDA@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap.Desai@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, Kai.Makisara@kolumbus.fi, lkolbe@techfak.uni-bielefeld.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org

On Fri, 3 Dec 2010 16:15:34 +0530
"Desai, Kashyap" <Kashyap.Desai@lsi.com> wrote:

> But I see maximum value for " CONFIG_FUSION_MAX_SGE" is 128 only and we can not go beyond this.
> I see scsi_alloc_queue below lines 
> 
>       blk_queue_max_hw_segments(q, shost->sg_tablesize);
>         blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
> 
> both the values play role while selecting max scatter gather elements.. 
> Where max_hw_segements are equal to value of " CONFIG_FUSION_MAX_SGE", but max_phys_segements are limited to  below value
> #define SCSI_MAX_SG_SEGMENTS    128 (defined in scsi.h)

Hmm, max_phys_segements is set to SCSI_MAX_SG_CHAIN_SEGMENTS (not
SCSI_MAX_SG_SEGMENTS).

SCSI_MAX_SG_CHAIN_SEGMENTS can be larger:

#ifdef ARCH_HAS_SG_CHAIN
#define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
#else
#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
#endif

So shost->sg_tablesize (SCSI_MPT2SAS_MAX_SGE) sets the limit here.

btw, max_hw_segments and max_phys_segments were consolidated.

With newer kernels, you can find the following in
__scsi_alloc_queue():

blk_queue_max_segments(q, min_t(unsigned short, shost->sg_tablesize,
			SCSI_MAX_SG_CHAIN_SEGMENTS));
