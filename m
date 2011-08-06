From: Dan Carpenter <error27@gmail.com>
Subject: [patch] iscsi-target: forever loop in iscsit_attach_ooo_cmdsn()
Date: Sat, 6 Aug 2011 07:32:06 -0700
Message-ID: <20110806143206.GF10373@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1HFOcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Aug 2011 10:32:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

I was looking through the code for something unrelated and noticed
what looks like a forever loop here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I am not familiar with the subsystem and haven't tested this, so
please review carefully.

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 9806507..c4c68da 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -834,7 +834,7 @@ static int iscsit_attach_ooo_cmdsn(
 			 */
 			list_for_each_entry(ooo_tmp, &sess->sess_ooo_cmdsn_list,
 						ooo_list) {
-				while (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
+				if (ooo_tmp->cmdsn < ooo_cmdsn->cmdsn)
 					continue;
 
 				list_add(&ooo_cmdsn->ooo_list,
