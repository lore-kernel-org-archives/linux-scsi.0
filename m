Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252DDC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B28610A1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhJ0CZB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:25:01 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63769 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbhJ0CYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635301348; x=1666837348;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Kpk9pmu0j/hTs2snhgUnLMJlmbZ5hcbx7kUm1MMB89Q=;
  b=ik89gXaE3nJ18pydBQLEK9kWVOoiyuKDUKMc7brsfGlpImJnJ1RIriBm
   y0c4sREm31VVvp+KIbaIbXfNMIvmK9kq6f6ciyae1N+NHZvQr4FRT3jKx
   D8vVbo3PPTNnxtqPIN7SoX6ECxDDuBQR02XbRqCfLMnkxKglO1gKd7Y3A
   G5MjdMSOFHbWYYOV5yvHPGenYYfLWrDHkfOXZzGz3ilAm+HwTQFjC4wu/
   fyzlEI4p+SouC1X0XL7U5uFhj4xz9EIzkdyEkSRoBt8gmBGCeL92o6Kse
   byDxFbg477owzbMEVpRtlnSR8wF5x+LTnaO6OHZqQQWM0Aw1OR0qkVIBN
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="183924740"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:22:28 +0800
IronPort-SDR: 0AfN1BdqzFgWMv8P/Jn39uXaufm2KAxVE1laloaj3bR1rTF1z4oVXRQbLcT5rDVbeCBCj3icqK
 13clqXIJUblrmvpXN4beYXLPFWuEjwmKXZN3udhK2D5b11FIwNTl8HXUOjRIRmIS7B4/m84PJr
 JgO2ej+V8bpPbhnf3fIGZsR1cp/yZ8cmt9C4ckcvTVL3szLMqpbr42Qa8/hxzhaXQ2Kb6X2Y6C
 j1OrfC73SoInOgxPxzNqykS6YLrNC1RrpSn5yNSFmgTO006ELf1v6v/lajm2uVlUax8cNPcqKF
 pID6mU5OFUXf/CcW75ZVgEe5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 18:57:58 -0700
IronPort-SDR: KlGmM717UANSG/dNDa0D3UI6gwkzsUvXXmXHWExEFvaCHOSCLWnJ7AlNnDwzN3bt/sithCSgrn
 qV/vBtGYTCVDjsYxh/7X3aVx9GCn9WMCzxbh/YWgDrc0WY5KBAsNhDOecUkIGPeNOxTTZ+gVjv
 Nxjps9lnLLqL9tYppeCSDVim2QDz8i4EhhOldbVDQ2oLz25F5ec/pUvtApY3X6+Yhla0BQgEQ0
 TxquOGROhcMYtk2MxyCIWsZFjpG/kRdxFI43ZuEa89W6tr+BNyjOzt1AhHTu2J+1vu+DIC7F1a
 vlM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2021 19:22:29 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v9 4/5] doc: document sysfs queue/independent_access_ranges attributes
Date:   Wed, 27 Oct 2021 11:22:22 +0900
Message-Id: <20211027022223.183838-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027022223.183838-1-damien.lemoal@wdc.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the file Documentation/block/queue-sysfs.rst to add a description
of a device queue sysfs entries related to independent access ranges
(e.g. concurrent positioning ranges for multi-actuator hard-disks).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 Documentation/block/queue-sysfs.rst | 31 +++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..b6e8983d8eda 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -286,4 +286,35 @@ sequential zones of zoned block devices (devices with a zoned attributed
 that reports "host-managed" or "host-aware"). This value is always 0 for
 regular block devices.
 
+independent_access_ranges (RO)
+------------------------------
+
+The presence of this sub-directory of the /sys/block/xxx/queue/ directory
+indicates that the device is capable of executing requests targeting
+different sector ranges in parallel. For instance, single LUN multi-actuator
+hard-disks will have an independent_access_ranges directory if the device
+correctly advertizes the sector ranges of its actuators.
+
+The independent_access_ranges directory contains one directory per access
+range, with each range described using the sector (RO) attribute file to
+indicate the first sector of the range and the nr_sectors (RO) attribute file
+to indicate the total number of sectors in the range starting from the first
+sector of the range.  For example, a dual-actuator hard-disk will have the
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
+the actual block size of the device. Independent access ranges do not
+overlap and include all sectors within the device capacity. The access
+ranges are numbered in increasing order of the range start sector,
+that is, the sector attribute of range 0 always has the value 0.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
-- 
2.31.1

