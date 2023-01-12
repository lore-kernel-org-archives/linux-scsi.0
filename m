Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B4CC54EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbjALOIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjALOIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:08:10 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9D2574C9;
        Thu, 12 Jan 2023 06:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532285; x=1705068285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYaFDhh8prQmCrmVXggIFHs2nnp6urNckK64rTfhyRc=;
  b=mfVqK6lmLHn/2M8/AszwyPdglTW38OXtpl1UvOgYBQ0PoJ1mwMLxLnrc
   YQW++gdP744qGe2LPFAa1RfaverU+PcI7vVWUGNDnRDlgW2iEZymgj4hF
   0rb+8rdcP97Ev05O3j10bR/MMySecbNT7Kb1csTfjkFVdUDgTU2gSr5Qh
   q30LyBOnfuOvEjtuxEui/x1tlwR5exPkldlBk/UhaSz16B8pJzqZaigYu
   w/1bOY1lPEBMNOdxqVpJ1UrJWjYrxIvVos8CLYBAf0XsGTHEOPFNqEIv8
   K0GqD0datyvz90CGFPDAHXjEQKSo+Pf/7CYnFIYl4UbWCCRRk2HZnUSEM
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632701"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:42 +0800
IronPort-SDR: bqkMKgMXYctnGlNdWc/uu75GW30Yr5+wvazsAOnQoEkUDywWE5Vwh4ZLtNqoKsb9ZEg5eH/xzt
 AiVVCNUJcYRiV2bejKc78ZIxy+qUgmdYryietEr/TKh4lKCDvG3NgIMgQeFZNTTmItv872n7Dn
 DI/SJslnLS2wamYFDUJWhcRky4W2a50RSKKpOgO5j7MTxgXSbiSLD3XaBv8mvsJNkEH2cpKOpM
 2a1lCgNI8bB7OaE1pgLl0bd/7LzW6Q3ZL7bkL4Hzovw2kwB80bhDUe5PIi2v7oVIAg+Y3fW1ZG
 U1M=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:45 -0800
IronPort-SDR: ZqBHdFHrjKoZiTEqVO2HFKZEpYZuinkz+jg66JqGY4RfH02vO+/7/i/tkUczplo1CWpgBHUeCh
 MIvyQ49vxMEjSVQiIvrHIj5QhMs4qL/eB4myEFZQD4EvmgCXMnN15OgFqWzyGe87Z5l88dB3Ab
 vFb+AY4bA4ah58yed8NmcS2wyDE0ARCkCCHt47F2VXkNE6PNM7afv84TBk9Bco3Rl+mb/j0U2L
 oK4HR4Poeyq3TSUY0sj8rVBpu+93pUUqvWVUozqQIYc+1XXnEjZ6De5n29CHEZI1x4hWQ+yXmH
 oMo=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:41 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 08/18] block: introduce BLK_STS_DURATION_LIMIT
Date:   Thu, 12 Jan 2023 15:03:57 +0100
Message-Id: <20230112140412.667308-9-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
report command that failed due to a command duration limit being
exceeded. This new status is mapped to the ETIME error code to allow
users to differentiate "soft" duration limit failures from other more
serious hardware related errors.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 block/blk-core.c          | 3 +++
 include/linux/blk_types.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index b5098355d8b2..67b0b24aa171 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -170,6 +170,9 @@ static const struct {
 	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
 	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
 
+	/* Command duration limit device-side timeout */
+	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..cde997590765 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -166,6 +166,12 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_OFFLINE		((__force blk_status_t)17)
 
+/*
+ * BLK_STS_DURATION_LIMIT is returned from the driver when the target device
+ * aborted the command because it exceeded one of its Command Duration Limits.
+ */
+#define BLK_STS_DURATION_LIMIT	((__force blk_status_t)18)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.39.0

