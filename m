Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2540BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E05C521D1B
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403789AbhASOlI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:41:08 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:37869 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404588AbhASNUn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 08:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611062442; x=1642598442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gf41tJSgK06B/Ga4VjMMXYqoISVLe/c4wgOY899USOM=;
  b=NX1EGoYyLBeXrAcDiIVX7i3K7Si+K8GMkAgeF8LqNDyohXU0tKRWXyTO
   ZDmHd205vDaWEOTh6L/IWPCI9Fv2Zu91mUnSBSx554T0M36Wu7JvLg2Vw
   /mLvK8XDifRfbX2CAW7zhBs3Rhnu3vIhEjY1Bc8nZlC5Wbm7mwxU8RtVD
   +pLkl3ovtsOECwNazDJIXfYVzktEmFf5MxA7ttPq1KJlUN3OhZRJ0XEGr
   DKGGbBflY4HdCbuzTuifYqQiyOeGbYwlD+Gg9nxKTkZGLASr+8KKOebUS
   nH8FSadQUxgWsogmsuEYCwH69Nex5FY3sugk6lc3glZ0MFa/pcH7WkCKB
   A==;
IronPort-SDR: arQ4yX0E3KpgIdFh1a4i2zFzOLql/PuLWtRN9uLizeNbT36yW7L1olgt7nRvAaYKZhvSv/Cgpo
 GWIgvhWTrMIF0JSED8I6eEOvH+/ldH/3vcwLe1Xni2hSV/KtECK8oGuOxxrhFf6wI3WYcxbfUJ
 gvV0eQxwDhk7d4N7VNz7oCQFZdRQFaGWw3a9ro/tqcC+VYv/OHFkJ+E+L1C/CQ1hyRFKs0h3pg
 LELXtn0pDpcyOGl+zrHsN93kVq+LP+5vzkolPwSKjJtrNgSHWY4gH5Gh9hjuSeQUWN7pN8g8QP
 B14=
X-IronPort-AV: E=Sophos;i="5.79,358,1602518400"; 
   d="scan'208";a="157798233"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 21:17:28 +0800
IronPort-SDR: 1qfK/Ceqgvoot+EhIrtYKddJ81latfgJ+qz1DjRQKkElXaw+o1pXXiGVdY8lvVX0SID8Fqt8Nc
 OVJ7zENACy2+Pmm0g6RhMJnSzRZWS7V0QauxMXIxqGJQVFUDCtMSpLPODFGkY8/sMlmA3HGCbR
 rlKVpt4GztB7KFVvCTUfZu/8moD97Zg4Lfww/M3ZFnfSHkucKfpO/iB2eiBjeUKgVFRbnOifnI
 jkv87CK6ap/qgbwxfleONdv89Xhekvz+TCxG+j75/Qo30mMDsyi0FOWRzh24Z4mBgp2Mej1UmY
 SkanHJA3WIIH2PodJ5vOq72Z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 05:00:04 -0800
IronPort-SDR: bJewGvUGD2sd8RHBZafXHMg0+wubmtkfNYOfD6a8NwTV//wLa0dZzK5OVZJWLVgBZh8rC79oxL
 fQ2sAKgqjO/QrBrBp04+pudSEiVEAaZLu406kcpbTwcvmcIT+psRAv8h2VHNb5I9J3P3rPRpqD
 et/gv50/Xx9x7NTQEPo5ZKAWPmDGqAP55v+sFRdo6skgAaT3o70mEVJCWS1QIKWj1CFe/ZVNJd
 ccayjxo/ErKBQYgIebKl5wXt5IaYTkq8FsceHiYYT3QQqZCZ10D57Po2bWVsHsIecRrmlNhCY8
 15w=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Jan 2021 05:17:28 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: [PATCH v2 2/2] block: document zone_append_max_bytes attribute
Date:   Tue, 19 Jan 2021 22:17:23 +0900
Message-Id: <20210119131723.1637853-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210119131723.1637853-1-damien.lemoal@wdc.com>
References: <20210119131723.1637853-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The description of the zone_append_max_bytes sysfs queue attribute is
missing from Documentation/block/queue-sysfs.rst. Add it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
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

