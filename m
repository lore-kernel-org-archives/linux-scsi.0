Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36678C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 21:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiLBVyM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiLBVyL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 16:54:11 -0500
X-Greylist: delayed 474 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 13:54:10 PST
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8135D80CD
        for <linux-scsi@vger.kernel.org>; Fri,  2 Dec 2022 13:54:10 -0800 (PST)
Received: from localhost.biz (unknown [10.81.81.211])
        by gw.red-soft.ru (Postfix) with ESMTPA id 987BC3E4AD7;
        Sat,  3 Dec 2022 00:46:13 +0300 (MSK)
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] scsi: qedf: Fix possible buffer overflow
Date:   Sat,  3 Dec 2022 00:46:07 +0300
Message-Id: <20221202214608.3784761-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.30.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173907 [Dec 02 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;localhost.biz:7.1.1;red-soft.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/02 17:58:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/02 19:57:00 #20639455
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In __qedf_probe() it is possible to overflow buffer host_buf[20]
and form non terminated string as result of passing large enough
(10 digits) number what gives us string of length 21 in sprintf()
function

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index e045c6e25090..bab54fa07dfc 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3287,7 +3287,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	struct Scsi_Host *host;
 	bool is_vf = false;
 	struct qed_ll2_params params;
-	char host_buf[20];
+	char host_buf[21];
 	struct qed_link_params link_params;
 	int status;
 	void *task_start, *task_end;
-- 
2.30.3

