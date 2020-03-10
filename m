Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED94AC18E5C
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CE224684
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AkI7E4HU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgCJJrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:20 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJJrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833644; x=1615369644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3p7RHEyoePg7i1Mq/5dKs5CFba9Y+OBx37yaWHnJv0Q=;
  b=AkI7E4HUUfq/b+Cv0vdNxENawjiJIQuysdZp3cqR7ENlTWAY77qfPg8J
   XDpL8ybCqcaxpVAGBDclq4jtRQRJM1nBYSpdpOD7UjVr5rLn2DhKhBZCy
   lI9BKi7dKLpetYvNSxiin6ag8C1/tzbLeY0g1t4WQdMdMhtfzx6QxpgmK
   JmBiZX1kggifu//h0ebrUmaMiUPcuNsuvqGgIJB4E2f4ty65WOMPgEcYS
   OtDJVKl/8bKS7KkjmriJzY8jhr/0JAYyislaXE2gO8lmMQXaxYI02cpYw
   NopsdvnoLS4XffeN733X6H/jhnzjx6x5mzNidbNjgT2vA29aVLcKYNceD
   Q==;
IronPort-SDR: jxupdKjoHNP/XsPyzDKKYvH4nwAypI+WGsOk7p1cwK0C2T+7RNjbtRZzp625P8rK3kIRv4zYmj
 yRXBZWaasLjP6htXJe+F+h25hvLMhTEcST63mbYJ9NRHgYl4mCSqk3EaKgyfRreg0mVPyPNMY7
 8YTacxefkGp99qRW/+e/wKWzEPIbkleCu0XqwPpdQTrD2rayNsKeaNRfE6sI6b8A5NYQNbi/kz
 gKJfVesvy7KCRZ2iISchADrs4zDVTPKXtyeYFqA/8aAUx7HeNvqe2mCYYpYq2ANqvg2HnQOKI2
 X90=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082787"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:24 +0800
IronPort-SDR: nqCUm4+6YZ3rQsIBdLBIPOXk525qy3Z7/u6CO1HRKWYzksIns2CvW9okRsFVcfKg1d3qywHCyB
 TjzB9aufHX600q4lam0qEjTESRUlhOCYwf7xwXgHeATazvbT230LfeEHDShWnQV08eyFo64saY
 pkvTTqThARqLBlvUErK1uwpecy86SAxV7/x1V15/Qo1GRw/KwXeT/ITFdmfoVf7cXa34qXW54G
 7tFiBajwP2zbJbnuKOwbNMPRL6s/uV8Nn4y6r59meaLHxHueK511oQ5Lth5JpKuW1PJlg2jvYd
 yEpcmvYqCrBN33Udh7vDEoeT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:38:59 -0700
IronPort-SDR: C7vB4ADhzATcn/BECNcdERi5PCk6AzABilnzyc6cfl/JZd3i4ZkrBjYOYNE6dbQgQ1drHIDRyd
 +KSe83UqI6P9MwF0B0FkHfu4oJsWZ2qN/lwUYoQ8g39c6cDIZebdAuQ27bQOI5pGvZayroRoZV
 yV8uKyimZsQQz2DZ+2IVR4QhH9g1Z8hH0MHdIVCKv+cJprTLNQ8M0bAYL0rmF4Y/ypiEMRTwvX
 Ds2ZrteK0eQhzqOZO5J77g1Gesjj5BviRvNJELRTLU4NXFdCYYpzo4CTINJFknxI6fFIvSXCv9
 UkM=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:18 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 05/11] block: introduce BLK_STS_ZONE_RESOURCE
Date:   Tue, 10 Mar 2020 18:46:47 +0900
Message-Id: <20200310094653.33257-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BLK_STS_ZONE_RESOURCE is returned from the driver to the block layer if
zone related resources are unavailable, but the driver can guarantee the
queue will be rerun in the future once the resources become available
again.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/blk_types.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ae809f07aa27..824ec2d89954 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -63,6 +63,18 @@ typedef u8 __bitwise blk_status_t;
  */
 #define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
 
+/*
+ * BLK_STS_ZONE_RESOURCE is returned from the driver to the block layer if zone
+ * related resources are unavailable, but the driver can guarantee the queue
+ * will be rerun in the future once the resources become available again.
+ *
+ * This is different from BLK_STS_DEV_RESOURCE in that it explicitly references
+ * a zone specific resource and IO to a different zone on the same device could
+ * still be served. Examples of that are zones that are write-locked, but a read
+ * to the same zone could be served.
+ */
+#define BLK_STS_ZONE_RESOURCE	((__force blk_status_t)14)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.24.1

