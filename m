Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F8DC43381
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A330B239EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbhAVIB2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:01:28 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38098 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbhAVIBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 03:01:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611302484; x=1642838484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+1ir2y+10gofxtVYdchl8MNcaiG9s+2w3chtZ7ND0zE=;
  b=mPSyE6DSwiOC9XLT/r9yMZUf/9JQF7wXjfTQZFcG5h3Fvho6+QtCNLNX
   a8Fi5Om2KeFjsKIjXFJrS2HYQAIw2EFtZ1O5KkHYyKYkakJ+2KQ+X9fO/
   HnJIQ0cpL9MdR3ixbudSFAWXeXJMudZiJGYCt80KiUfKQ+EiC4UtCRGtg
   7UpdKXmrsaJcnFtW1CH4fvWmAKzI5nTQAaw8diq0c8H3aTSHoIrVr2ov4
   Va8r/A4pqEJ9ddUWNbqbBtkpFOBzrR9fVUu0X+bZPuphn9zOcm7fnEXvs
   iKWFoNex4nbNQgD0lM2nY4kJ0ZI+My/0KV5bS45peVyQyZe2x2MdsTDAM
   g==;
IronPort-SDR: txCJWcevvr6XDLIq+lbtOR5yWLILENGgYdaN467DMIFu1WaVnSJgO/vbEQNnC42QQiCtcmoDXM
 NEuKlbs1aerqG/lNHgRQu49nBpRJTSmulFpiby5vxSErszl1RfEyJNwT4hYUYv2+iSncBQ+dqc
 EqF1F7nh31UJ66HwVpngIS5Ir+bHPybYjmfL+sxogqbFHdPqHhYHVXl4PVW3N20Q2fnCFUdMH1
 uTQGA6LKQvlqKPRhLR3sE56sDtuTRme9D8eqyNTyUp3pi84Py/JUl5/pEllhtQeHTqWiHDqKtm
 78g=
X-IronPort-AV: E=Sophos;i="5.79,366,1602518400"; 
   d="scan'208";a="268398847"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2021 16:00:19 +0800
IronPort-SDR: oyoM+izzlOJ39y7kc9iPDZ5ZpmII6xnE/QAleBZEKQEKdtIn5LuyQRrBPVr5ZE1RjwIjSYF+Hb
 RjMk8YY1JV2hrfLDU35DP2roO7+y6xb/8RBYXxXZRG6Oygxz3v3bhgGQzkT+ZZ/vqYiaI8moBP
 PKRcKr0puSvFFdl8QAWTtvecMjOeIpR0ENvZV8RCbDb9ts5ZYm8zdyBS/saAFZdjZcsUNdYTK5
 D7nw6hyVN5x+CSClaSh9zxyXTMVfD49M4GaYFPmCOLt6wFoCVrOjNO1uewS4axAIyHGeTEXuKq
 EEq3HS7sJN8wQboKln2G5vjj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 23:42:51 -0800
IronPort-SDR: WzFa3CIwNou7jEhVGULmqS9NnBhBsd0vUX+hTASBOsOuEQveAhbO+OMENewT3Cr9YHFeIhvcF7
 Usq3ypxVPp5ztjuL243L+zvAamkmU7pfL/TZqus5ue0okFGbDmPqVjdLjGAB0oSEXv4LoXTp8f
 hri725177EKnQ8DU2VSR4IQjOVqdwVVqxpbS5qDp+nVyl+e6ax3vZZ6AXulndmXZcp4MTZB77m
 LXuc+SLKurJL9W4vld+rXCF03FCgAkZAKNcYtJoJK7VPoou9JkPW79lAUQEcxiG0uNZbjLKNpI
 ZLM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Jan 2021 00:00:18 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: [PATCH v3 2/3] block: document zone_append_max_bytes attribute
Date:   Fri, 22 Jan 2021 17:00:13 +0900
Message-Id: <20210122080014.174391-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122080014.174391-1-damien.lemoal@wdc.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The description of the zone_append_max_bytes sysfs queue attribute is
missing from Documentation/block/queue-sysfs.rst. Add it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/queue-sysfs.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index c8bf8bc3c03a..4dc7f0d499a8 100644
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

