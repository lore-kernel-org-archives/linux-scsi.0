Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C40DC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E4460E08
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 07:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244471AbhH0Hvo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 03:51:44 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42485 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244542AbhH0Hvk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 03:51:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630050651; x=1661586651;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=5rn+rIGZyCcnRoiq+blOYH9u92Uq0PoXUIKA2y3DWbE=;
  b=dD9VhdgPAXmzb+SRyCeEILA0TwOJFiXfSiSUiCp2F1B4whXb4tiXGUdJ
   nbBFKZG2NOPkT3gD+5/qWim8quXizb+t/EWc9ypApWkFsW3/qOcRHRLqk
   1XhG/J3lHrlch8rsw1bjeIiPhBgdgLEcyI9EqiSDv8mkE+HGUrIKoQx/o
   zo1q1td2X42vj2Slgki0iYZmy/9tFyN3QLCTMHr72BqLIMSmDpgZtU4Qa
   hSESpSaaYaoFdcKsjOYxmSUj0+EriQT8pHqyLd+rpVMedEi7wNec7LZkc
   wXrF0XX3pKlOLIYOKsfcO5ursu0Wfxgh+xNjWiUDugloOt3FRTcE+zFI7
   A==;
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="183342793"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2021 15:50:51 +0800
IronPort-SDR: 6yeqTUueLWK8fTGAFvgqxfdS1dcCCEmACs7eMGXK8AXuHUj7lJJDZFLxZbDqqyq6LNp44ZGu/k
 qCKomzk7u6K1zg2tQpW1Xh3Gv6vxT3rYnQhVfmheVCNTct/rNe4C4wKm7+EgP/Kwy1X8eGZlyy
 nsEzGZ0VFv6WbkAlYt37v24g5t3py4qe/5KYRM37N3qpo4LOGl7BVp8/KuD/4N1lgsTMmgdYgg
 wPxLAx/JIEOfutHVnXSEAP4WU2qWYzHtM39hPI6rMxEJBsEbP8eZLRDf/wv3kEPYgr5BRwY1Ug
 gQsZfLjeFwhMo4s30YDN8Y4Y
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:26:03 -0700
IronPort-SDR: rH8ZzW6Fw9EBpZDViIu6Bd2MSQ7YYr1TH6CKslcS3ECk7+QVYLYPUOQusQ0rkc3YJBQ7uDdXsU
 hzZ4e0RZ0usr3sCg4hY+O5Dg1e7DuoPmLN3lq3c+P0+O9c8JRRfDJSq8fjQx67bTWKOeqv2Nj2
 IF/+7shlqiB8ZSmFPEL/5m8N72x9O6ldrd8GI6hrDWRcYsILdjIT4flDv0saNtouKgBs4UIiyp
 YRCEOiYq3+QjVC680iQcsV+6jdboqiQAluzNc/kthECs+BJNN5gBNshs8G+OdNc77iBX5vw4my
 MaE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Aug 2021 00:50:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v6 4/5] doc: document sysfs queue/independent_access_ranges attributes
Date:   Fri, 27 Aug 2021 16:50:43 +0900
Message-Id: <20210827075045.642269-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827075045.642269-1-damien.lemoal@wdc.com>
References: <20210827075045.642269-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the file Documentation/block/queue-sysfs.rst to add a description
of a device queue sysfs entries related to independent access ranges
(e.g. concurrent positioning ranges for multi-actuator hard-disks).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..17eef55434e7 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -286,4 +286,32 @@ sequential zones of zoned block devices (devices with a zoned attributed
 that reports "host-managed" or "host-aware"). This value is always 0 for
 regular block devices.
 
+independent_access_ranges (RO)
+------------------------------
+
+The presence of this sub-directory of the /sys/block/xxx/queue/ directory
+indicates that the device is capable of executing requests targeting
+different sector ranges in parallel. For instance, single LUN multi-actuator
+hard-disks will likely have an independent_access_ranges directory if the
+device correctly advertizes the sector ranges of its actuators.
+
+The independent_access_ranges directory contains one directory per access
+range, with each range described using the sector (RO) attribute file to
+indicate the first sector of the range and the nr_sectors (RO) attribute file
+to indicate the total number of sector in the range starting from the first
+sector of the range.  For example, a dual-actuator hard disk will have the
+following independent_access_ranges entries.::
+
+        $ tree /sys/block/<device>/queue/independent_access_ranges/
+        /sys/block/<device>/queue/independent_access_ranges/
+        |-- 0
+        |   |-- nr_sectors
+        |   `-- sector
+        `-- 1
+            |-- nr_sectors
+            `-- sector
+
+The sector and nr_sectors attributes use 512B sector unit, regardless of
+the actual block size of the device.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
-- 
2.31.1

