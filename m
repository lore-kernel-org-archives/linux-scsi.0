From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] gdth buggy page mapping
Date: 23 Nov 2004 12:44:57 -0600
Message-ID: <1101235504.2016.14.camel@mulgrave>
References: <20041123180622.GK13174@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46795 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261500AbUKWSpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 13:45:11 -0500
In-Reply-To: <20041123180622.GK13174@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, achim_leubner@adaptec.com

Actually, this:

On Tue, 2004-11-23 at 12:06, Jens Axboe wrote:
> @@ -2717,8 +2716,8 @@
>      if (scp->use_sg) {
>          sl = (struct scatterlist *)scp->request_buffer;
>  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,13)
> -        sgcnt = pci_map_sg(ha->pdev,sl,scp->use_sg,PCI_DMA_FROMDEVICE);
> -        for (i=0,cpsum=0; i<sgcnt; ++i,++sl) {
> +        for (i=0,cpsum=0; i<scp->use_sg; ++i,++sl) {
> +	    unsigned long flags;
>              cpnow = (ushort)sg_dma_len(sl);

Won't quite work any more.  On most platforms, it will since
sg_dma_len(sl) expands to sl->length which is the correct thing. 
However, on some, like parisc, x86_64, ppc64 it will expand to a
different parameter which won't get filled in if the dma mapping is
never done.  I think all use of the sg_dma_ macros in this driver will
need modifying with this change.

James


