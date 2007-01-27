From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] libsas: fix task attribute
Date: Sun, 28 Jan 2007 01:19:41 +0900
Message-ID: <20070128011941I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:43560 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbXA0QTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jan 2007 11:19:03 -0500
Received: from mfs34.rdh.ecl.ntt.co.jp (mfs34.rdh.ecl.ntt.co.jp [129.60.39.114])
	by tama55.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l0RGJ0vL015244
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2007 01:19:01 +0900 (JST)
Received: from mfs34.rdh.ecl.ntt.co.jp (localhost [127.0.0.1])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id 075BA20AE2B
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2007 01:19:01 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id EE1EC20AE30
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2007 01:18:59 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l0RGIx2M011023
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2007 01:18:59 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Why TASK_ATTR_HOQ?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 22672d5..7ae3997 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -130,7 +130,7 @@ static enum task_attribute sas_scsi_get_
 	if (cmd->request && blk_rq_tagged(cmd->request)) {
 		if (cmd->device->ordered_tags &&
 		    (cmd->request->cmd_flags & REQ_HARDBARRIER))
-			ta = TASK_ATTR_HOQ;
+			ta = TASK_ATTR_ORDERED;
 	}
 	return ta;
 }
-- 
1.4.3.2

