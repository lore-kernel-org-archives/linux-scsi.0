Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2632C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7653764E54
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhB1GAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:00:03 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2570 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhB1GAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:00:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492000; x=1646028000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4N5WSLuQ96Pzt5pgUszKyXKekxaJY3GUfENka9g0hdg=;
  b=gkyuiDS0m9OQQXCvz+wsZ3sr34kn3YWW263dqjd2ly8Uw99C9kSfSIKK
   0/157pDK5Uzl9nOuX26fGo9Xy87QGInSbZjvlIER/rXVSNmVw5MiLsYIh
   AZ+J1l3huUH+pVE/qWztMG+2OoegtuHB0l0nTOgtA01nX3E0w0s+32J51
   Y+YPLewJ0A10v6x5KVbe3dnTfkxU0MseVRw6dj84y/oeyXXtB4uLj4OWo
   n18MsK8UitepyUL//mCmDvzRubeDnxOMHYLdId8xwu6WZOOn2OdDkvGVA
   lBNi25eNoGZqFBtoZ1n9qWFBarFDgXF+EN+P7lmly1GBCkyLaAhQ4y6OC
   g==;
IronPort-SDR: nvWrtM774bqnhVdGx5shrf4E/55+vWd1G3HK87SPj8FDaLdjBiLnvLMtvOZVP34hJEAD6xOxfe
 qiC5p4anJm/pWdo8v9yle4QLyKCKzXsqFictUDh1uOgymn9dwibhYmBMMxOKQSZSJSuNbecF/6
 uN7Ikfb8n6hsoqKPxjXDNoVOr1K7QFvg04JgEVwGE+uDvcRvXkrS+Ce4SHAIM8bqzIpovjIrA6
 b15BY9MU98W5hNa5Rxpr9QMGKnKVJo8FZ20vW+NWs52BD/aj98KASAbpZULlGG9uzJqMRsYDhB
 Zi8=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="162152839"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 13:58:55 +0800
IronPort-SDR: 76UZGPDJYsRi8ta8zoZrJANFoBCSM2GCbvMuENzmKMqIT1SZq/OlAvHNaEr4FRj0vMX0+YCEKI
 lE/eLbpCuCngY/AmQZOPGPSnYuyObZCNUGJIUgW6cl8R/FxD+1hmFhSObWzVyRXu/6FfexXjCg
 dJWeETzmnmZAClflMMfyDqbSRaaiYv3xCVhZlzl44x4/FnY958d4kAKTIA9rFXztYzdS5hPuVM
 mTd5dXHvk3l8aab6zfVDIRVSQD9KH2eIv8luVXB55dLum4R0bXr+qSgi9q2vQKcpOKz/kGxq47
 KtmuvhSMq5PK7ojPglRFNiDk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:40:13 -0800
IronPort-SDR: 7B1VclN92M6y6WZsDpdSuD1wzGyCrL2JMWKfEm0LOvIJkAilukmcAMPbkueU18APE/Wl8/aSt/
 D7FeuF+MAiT3iVG4j0uOmiGPeKw/mGwsrlDDpuagllCrIHh97H0iNNAXgsnb005uwc211EP0dn
 mlBxP2N4eYpqjnoRe9vlZCwpw2UxhH6wYABLym9LIWF8rPzHn2YVC2YXcfD+q0cuefOfCVug1R
 DBz6xLTPdRs1IzB5r6maKeYrr2qeQ50l35Ow58sUvdRu57p8PoFu9nCPeeEkZqXgFmgNZ7GNMy
 xuk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 21:58:54 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 13/23] target/configfs: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:35 -0800
Message-Id: <20210228055645.22253-14-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f04352285155..56ea47f5cda9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1494,7 +1494,7 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 {
 	struct t10_wwn *t10_wwn = to_t10_wwn(item);
 	struct se_device *dev = t10_wwn->t10_dev;
-	unsigned char buf[INQUIRY_VPD_SERIAL_LEN];
+	unsigned char buf[INQUIRY_VPD_SERIAL_LEN] = { };
 
 	/*
 	 * If Linux/SCSI subsystem_api_t plugin got a VPD Unit Serial
@@ -1536,7 +1536,6 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 	 * Also, strip any newline added from the userspace
 	 * echo $UUID > $TARGET/$HBA/$STORAGE_OBJECT/wwn/vpd_unit_serial
 	 */
-	memset(buf, 0, INQUIRY_VPD_SERIAL_LEN);
 	snprintf(buf, INQUIRY_VPD_SERIAL_LEN, "%s", page);
 	snprintf(dev->t10_wwn.unit_serial, INQUIRY_VPD_SERIAL_LEN,
 			"%s", strstrip(buf));
-- 
2.22.1

