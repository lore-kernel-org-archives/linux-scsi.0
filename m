From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] sata: fix sata_sx4 dma_prep to not use sg->length
Date: Sun, 7 Aug 2005 14:53:40 +0900
Message-ID: <20050807055340.GB13335@htj.dyndns.org>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.206]:59999 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751107AbVHGFzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Aug 2005 01:55:06 -0400
Received: by rproxy.gmail.com with SMTP id i8so747240rne
        for <linux-scsi@vger.kernel.org>; Sat, 06 Aug 2005 22:55:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20050807054850.GA13335@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>

 sata_sx4 directly references sg->length to calculate total_len in
pdc20621_dma_prep().  This is incorrect as dma_map_sg() could have
merged multiple sg's into one and, in such case, sg->length doesn't
reflect true size of the entry.  This patch makes it use
sg_dma_len(sg).


Signed-off-by: Tejun Heo <htejun@gmail.com>

Index: work/drivers/scsi/sata_sx4.c
===================================================================
--- work.orig/drivers/scsi/sata_sx4.c	2005-08-07 14:07:17.000000000 +0900
+++ work/drivers/scsi/sata_sx4.c	2005-08-07 14:08:25.000000000 +0900
@@ -468,7 +468,7 @@ static void pdc20621_dma_prep(struct ata
 	for (i = 0; i < last; i++) {
 		buf[idx++] = cpu_to_le32(sg_dma_address(&sg[i]));
 		buf[idx++] = cpu_to_le32(sg_dma_len(&sg[i]));
-		total_len += sg[i].length;
+		total_len += sg_dma_len(&sg[i]);
 	}
 	buf[idx - 1] |= cpu_to_le32(ATA_PRD_EOT);
 	sgt_len = idx * 4;
