From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] FC pass through support - revised III
Date: Tue, 11 Nov 2008 21:25:56 +0900
Message-ID: <20081111212547N.fujita.tomonori@lab.ntt.co.jp>
References: <B125BA56-8293-4C42-AEBC-0C0DCAC365D0@qlogic.com>
	<20081111184216Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55100 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbYKKM01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 07:26:27 -0500
In-Reply-To: <20081111184216Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

On Tue, 11 Nov 2008 18:41:49 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > +	req_sg_cnt = dma_map_sg(&ha->pdev->dev, service->sg_req,
> > +	    service->req_sg_cnt, DMA_TO_DEVICE);
> > +	if (!req_sg_cnt)
> > +		goto pt_error1;
> > +	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, service->sg_rsp,
> > +	    service->rsp_sg_cnt, DMA_FROM_DEVICE);
> > +	if (!rsp_sg_cnt)
> > +		goto pt_error2;
> > +
> > +	copy_size = sg_copy_to_buffer(service->sg_req, req_sg_cnt,
> > +	    els_pkt, 20);
> 
> You need to use service->sg_rsp instead of req_sg_cnt here.

Oops, I meant that you need to use service->req_sg_cnt instead of
req_sg_cnt (the returned value of dma_map_sg).


> sg_copy_to_buffer takes the number entry of scatter gather. dma_map_sg
> returns the number of physical segments mapped. They could be
> different (when IOMMU merges the entries).
