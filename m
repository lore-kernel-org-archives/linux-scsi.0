From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3] sata: restore sg on setup failure
Date: Sun, 7 Aug 2005 15:17:37 +0900
Message-ID: <20050807061737.GA14913@htj.dyndns.org>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.198]:475 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751127AbVHGGRp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 02:17:45 -0400
Received: by wproxy.gmail.com with SMTP id i20so650697wra
        for <linux-scsi@vger.kernel.org>; Sat, 06 Aug 2005 23:17:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050807054850.GA13335@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>

 I forgot to restore sg->length on setup failure.  This patch adds it.


Signed-off-by: Tejun Heo <htejun@gmail.com>

Index: work/drivers/scsi/libata-core.c
===================================================================
--- work.orig/drivers/scsi/libata-core.c	2005-08-07 15:13:20.000000000 +0900
+++ work/drivers/scsi/libata-core.c	2005-08-07 15:15:27.000000000 +0900
@@ -2401,8 +2401,11 @@ static int ata_sg_setup_one(struct ata_q
 
 	dma_address = dma_map_single(ap->host_set->dev, qc->buf_virt,
 				     sg->length, dir);
-	if (dma_mapping_error(dma_address))
+	if (dma_mapping_error(dma_address)) {
+		/* restore sg */
+		sg->length += qc->pad_len;
 		return -1;
+	}
 
 	sg_dma_address(sg) = dma_address;
 	sg_dma_len(sg) = sg->length;
@@ -2473,8 +2476,11 @@ static int ata_sg_setup(struct ata_queue
 
 	dir = qc->dma_dir;
 	n_elem = dma_map_sg(ap->host_set->dev, sg, qc->n_elem, dir);
-	if (n_elem < 1)
+	if (n_elem < 1) {
+		/* restore last sg */
+		lsg->length += qc->pad_len;
 		return -1;
+	}
 
 	DPRINTK("%d sg elements mapped\n", n_elem);
 
