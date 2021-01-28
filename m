Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FF9C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B3BE64DD9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhA1EtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:49:24 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21969 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhA1EtW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809361; x=1643345361;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nlVDSYPsDiNDIn4MgX4E8oTX+gmER/SxjozWNm4/+I0=;
  b=AC2wC8ob7S7spqukE39AM5m+6snPfo+ftl1PgZQB2+E5TZmxGaT8HB8D
   i2UC4P9CaaLFmahBiWRFN4/qVOj9Ueg5qKzpqXdqCDpoFOEElfoHNSd81
   RYFjKS63rPkSjJTXXsCdby1ZhbhUEzKWMRtGxaPAYpa9qN0xJvRDG8Pcu
   Rm0LsY0LdH4XUdW1ihUqC5RGdhgn813ULLLawd7MZ7eT0mKuZUG57aOqF
   v+4nt6BmPl2+hooTJA7u4ObItaEkiCcSnNRXSBTh6+jZ16eBPZ/ZNAjIm
   mzR2Yiz4CoWBY86a/JSlBIUehkhEy8IUnWlER0QPoBBT67rJjxdReWeV7
   w==;
IronPort-SDR: dvMYoRePYBMgIp4/nNXX1K4pgNepYOHgMYaVVkjMl045+LxL+AEYc7nCpf8JMolBUrEfp2VIKY
 xHF1/hLY5obhwJW5XWqBZ/WM6mTFrLl7PmDBKpRw58p7tcYxORAFhd2sdp6dio0QdiKYE3F+dM
 sEMlWjoHO5ALBaGNbdjTsKoSnM5xsEaHSKv/Fyx6Dg9FpDOxUz1M6GiKbXNDJG0flMEhttIoRJ
 x8uJcyr/xNumQLyVBXtJ7bS9PHqBF+8HJdEkGkomeaSRMEoyS+6V78Y1nBQaUrdYnqAFsYL6VT
 uZ0=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509126"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:37 +0800
IronPort-SDR: jk7I/2Q10HaA7mQHUWqRZsgowiItqCMimrhCIyluGOzKQdhJkMvjzsTa1RTdrys0KiiNvD4Dvp
 GE25Soy67RnBe3TBmEs2WskukWZdtloTORChy9Bd2Lz9bldLslCgx3HMz4O68phbORjOzBtOQE
 WWYQeDAc3t1zVccs1t9AuL686gOVYyTOHjzFjC6TWSF3YlAxbj6uVGVKQx3tQ0rWUxkYyOdRrL
 OWtD/BBdvF5p0VPSYJzELEohX+PTlwEbDDf5rt8IOdBu/dnmJt/MqvAVxWvkf29jFECP3PjrRK
 sQkUDw2T3E5oaX8MhZXv5AVh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:29:56 -0800
IronPort-SDR: Rw4bUzOvN4mJwZLFxFUm6LpJsGwe5YcjBXIX2Ymv9mt+5XHcopn8O27sy142fveBFZy18GIqep
 dvyoGjJpSCtn0JKO6dGlnahV4dhyjT/iii6yhL5o/XGgczi5bC4+HJYI97zt156LnEvC9UlYVk
 OWD50plCdjYBxhJSEehpZDV18NEpG1mFbF301ZIQVHxOfwa450BEWZvJlo/Sadvlt4IBLUHmdk
 /zz5jCgU8+44Juwu2kXXwWCyftM6fkjACRZQfke/V/+xM0bxwwgoMgC2ZAsHUtKWQYOGvuSUoL
 usU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:36 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 1/8] block: document zone_append_max_bytes attribute
Date:   Thu, 28 Jan 2021 13:47:26 +0900
Message-Id: <20210128044733.503606-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The description of the zone_append_max_bytes sysfs queue attribute is
missing from Documentation/block/queue-sysfs.rst. Add it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 Documentation/block/queue-sysfs.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 2638d3446b79..edc6e6960b96 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -261,6 +261,12 @@ For block drivers that support REQ_OP_WRITE_ZEROES, the maximum number of
 bytes that can be zeroed at once. The value 0 means that REQ_OP_WRITE_ZEROES
 is not supported.
 
+zone_append_max_bytes (RO)
+--------------------------
+This is the maximum number of bytes that can be written to a sequential
+zone of a zoned block device using a zone append write operation
+(REQ_OP_ZONE_APPEND). This value is always 0 for regular block devices.
+
 zoned (RO)
 ----------
 This indicates if the device is a zoned block device and the zone model of the
-- 
2.29.2

