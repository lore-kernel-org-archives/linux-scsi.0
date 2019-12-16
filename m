Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F42C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 13:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77CAE20684
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 13:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfLPNRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 08:17:25 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:34735 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727653AbfLPNRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 08:17:24 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MA88C-1iZjVc380Y-00BfWR; Mon, 16 Dec 2019 14:17:02 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: lpfc: fix build failure with DEBUGFS disabled
Date:   Mon, 16 Dec 2019 14:16:49 +0100
Message-Id: <20191216131701.3125077-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:muNsOaQMWt/pgvfzkrJbpOqFT5GN9UxG1fJWHJjZeBLFKbF8xfp
 yYlQCzvOEkCpvq2JejmOFD9/vaq7yUpfys1l15/URUlHWQewyx9fudWty+/T1TOEnBSPy7t
 y86BXPNYUBhEBTi8jaZoZT+jKHpS7XEwcrrv3NCt6+xaEKYSi4siJ3QOVyOZE8nHesakQ1I
 CpmdMy0/GkkPS9opsYdgQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:r4lXlfYw3sY=:eBDEz/XTIQGoh0b+8pb1TU
 sQifTHqB+yB4EgWPe3jvYkp3clTkvFkkAthqxhhimxeHTA7ofmGaiwGTQGuZYN/Mk0n62L1iw
 XUPSDox/UTo3J10ByoDooy61vg548vyvZXTAPQWveqdMRjn+cYjUeQR3SLkr85PpqRof8oPOF
 ZzpMUyGB93DXsY1xww+D7hFuaQ20a57RW3rM0+g6ZAkPgTrUX3mWfFEdNwfgdCVlhuKewKGqH
 arEbuP53MbAQL9zDaWY9wR/NHXsBg0i+gV0xIqJKSeor7Qt4yy7w3XZuHl4D9doEKZDvI33zs
 8Kco9v7HRVg6P07UQ+l2mnWoxa4aUaiEpSIDaBES3C5wJpChbdmxJ++qiZFTuKQa5khtjcpWn
 IoelE7YI2pE9x7Q1nyBQFf3V99f7zS7apJPXKi3eXt0rST7RFvvAe8/WeQx3lsA7WdvBykMbb
 JT7APJlx4rtzBppaPZGI/nCkUPwZXq2lbSGHT9sulfFeszLUdyTzwcaOK0j08t9gIm/zfiMNv
 sSJ+2UD2+rWX/sfVKp9SsAVMNdJgFUr/8nNtgAGu5ZQTjOnUKshSIVOYfKyKdclOAq6p6ToNl
 msgVL/mHB2MmsdILy+O35Mg3Kn96TDEDhS/L6hGnTFwVc9mt/Mmqlc84cN/Ee7vyFXo7Mdd8C
 2fqOTkxhjX00MzUbUBGbYYnrl/RJf8PiSWi5SUErqQwQWeKmlsgQw8fL/lXafLFXW0sR7c7mk
 vzWHKI38u8woNdXghUVKEMfCfSHulKIe2xL8o1v9hMHQSTOJ6qyQK7OmPTiB+mUNfMbFVJMgr
 LVA/H5l46kwyQPFNG6aWY+cTL9g58t96PqJtK7xX5J86QacuOCLdKgXleuXI0H38G9rk0nxLh
 mjhdjssjRfyjybr7Ccpw==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A recent change appears to have moved an #endif by accident:

drivers/scsi/lpfc/lpfc_debugfs.c:5393:18: error: 'lpfc_debugfs_dumpHBASlim_open' undeclared here (not in a function); did you mean 'lpfc_debugfs_op_dumpHBASlim'?
drivers/scsi/lpfc/lpfc_debugfs.c:5394:18: error: 'lpfc_debugfs_lseek' undeclared here (not in a function); did you mean 'lpfc_debugfs_nvme_trc'?
drivers/scsi/lpfc/lpfc_debugfs.c:5395:18: error: 'lpfc_debugfs_read' undeclared here (not in a function); did you mean 'lpfc_debug_dump_q'?
drivers/scsi/lpfc/lpfc_debugfs.c:5396:18: error: 'lpfc_debugfs_release' undeclared here (not in a function); did you mean 'lpfc_debugfs_terminate'?
drivers/scsi/lpfc/lpfc_debugfs.c:5402:18: error: 'lpfc_debugfs_dumpHostSlim_open' undeclared here (not in a function); did you mean 'lpfc_debugfs_op_dumpHostSlim'?

Move it back to where it was previously.

Fixes: 95bfc6d8ad86 ("scsi: lpfc: Make FW logging dynamically configurable")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2e6a68d9ea4f..a5ecbce4eda2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5385,7 +5385,6 @@ static const struct file_operations lpfc_debugfs_ras_log = {
 	.read =         lpfc_debugfs_read,
 	.release =      lpfc_debugfs_ras_log_release,
 };
-#endif
 
 #undef lpfc_debugfs_op_dumpHBASlim
 static const struct file_operations lpfc_debugfs_op_dumpHBASlim = {
@@ -5557,7 +5556,7 @@ static const struct file_operations lpfc_idiag_op_extAcc = {
 	.write =        lpfc_idiag_extacc_write,
 	.release =      lpfc_idiag_cmd_release,
 };
-
+#endif
 
 /* lpfc_idiag_mbxacc_dump_bsg_mbox - idiag debugfs dump bsg mailbox command
  * @phba: Pointer to HBA context object.
-- 
2.20.0

