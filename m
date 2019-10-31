Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFFFCA9EC3
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F46B2086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfJaFMU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 01:12:20 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:38896 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfJaFMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 01:12:19 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: PmBnkid4LY1OvLdGOD1m1ssXHpjOnnStcdlpnP43IxY3FOnyE22kLYk0zfCXuuI7FhQEG9Bt7e
 icA73465w/orY395VYFWjL3t2PxVIqCcGinTLXJDDMFNYEx3K+WybJUYqYWI19Bi0MrJVW/9Rb
 75XTrgokaLbZWtpnjiOpLziZ3g+gvuOXXZiiTO/ZST88sZw7A7HMoP2ncnzQBY5M7GlWPNPRqP
 Oi+3DnFzqpklGOS7D5wWNEDx3PijHV5Th3mAw1ZCsJVRPBJ/7RuSlvA8SyUFhhRMNiuteqe7QN
 qIQ=
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="53588637"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2019 22:12:18 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Wed, 30 Oct
 2019 22:12:18 -0700
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Wed, 30 Oct
 2019 22:12:17 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH 08/12] pm80xx : Cleanup command when a reset times out.
Date:   Thu, 31 Oct 2019 10:42:37 +0530
Message-ID: <20191031051241.6762-9-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191031051241.6762-1-deepak.ukey@microchip.com>
References: <20191031051241.6762-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: peter chang <dpf@google.com>

Added the fix so the if driver properly sent the abort it try to remove
it from the firmware's list of outstanding commands regardless of the
abort status. This means that the task gets free-ed 'now' rather than
possibly getting free-ed later when the scsi layer thinks it's leaked
but still valid.

Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 50 +++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 4491de8d40fc..b562916a3d3d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1204,8 +1204,8 @@ int pm8001_abort_task(struct sas_task *task)
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	phy_id = pm8001_dev->attached_phy;
-	rc = pm8001_find_tag(task, &tag);
-	if (rc == 0) {
+	ret = pm8001_find_tag(task, &tag);
+	if (ret == 0) {
 		pm8001_printk("no tag for task:%p\n", task);
 		return TMF_RESP_FUNC_FAILED;
 	}
@@ -1243,26 +1243,50 @@ int pm8001_abort_task(struct sas_task *task)
 
 			/* 2. Send Phy Control Hard Reset */
 			reinit_completion(&completion);
+			phy->port_reset_status = PORT_RESET_TMO;
 			phy->reset_success = false;
 			phy->enable_completion = &completion;
 			phy->reset_completion = &completion_reset;
 			ret = PM8001_CHIP_DISP->phy_ctl_req(pm8001_ha, phy_id,
 				PHY_HARD_RESET);
-			if (ret)
-				goto out;
-			PM8001_MSG_DBG(pm8001_ha,
-				pm8001_printk("Waiting for local phy ctl\n"));
-			wait_for_completion(&completion);
-			if (!phy->reset_success)
+			if (ret) {
+				phy->enable_completion = NULL;
+				phy->reset_completion = NULL;
 				goto out;
+			}
 
-			/* 3. Wait for Port Reset complete / Port reset TMO */
+			/* In the case of the reset timeout/fail we still
+			 * abort the command at the firmware. Yhe assumption
+			 * here is that the drive is off doing something so
+			 * that it's not processing requests, and we want to
+			 * avoid getting a completion for this and either
+			 * leaking the task in libsas or losing the race and
+			 * getting a double free.
+			 */
 			PM8001_MSG_DBG(pm8001_ha,
+				pm8001_printk("Waiting for local phy ctl\n"));
+			ret = wait_for_completion_timeout(&completion,
+					PM8001_TASK_TIMEOUT * HZ);
+			if (!ret || !phy->reset_success) {
+				phy->enable_completion = NULL;
+				phy->reset_completion = NULL;
+			} else {
+				/* 3. Wait for Port Reset complete or
+				 * Port reset TMO
+				 */
+				PM8001_MSG_DBG(pm8001_ha,
 				pm8001_printk("Waiting for Port reset\n"));
-			wait_for_completion(&completion_reset);
-			if (phy->port_reset_status) {
-				pm8001_dev_gone_notify(dev);
-				goto out;
+				ret = wait_for_completion_timeout(
+					&completion_reset,
+					PM8001_TASK_TIMEOUT * HZ);
+				if (!ret)
+					phy->reset_completion = NULL;
+				WARN_ON(phy->port_reset_status ==
+						PORT_RESET_TMO);
+				if (phy->port_reset_status == PORT_RESET_TMO) {
+					pm8001_dev_gone_notify(dev);
+					goto out;
+				}
 			}
 
 			/*
-- 
2.16.3

