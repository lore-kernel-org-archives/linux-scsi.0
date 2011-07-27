From: Dan Carpenter <error27@gmail.com>
Subject: [patch] target: strlen() doesn't count the terminator
Date: Wed, 27 Jul 2011 14:11:43 +0300
Message-ID: <20110727111143.GN3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58816 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1G0LNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 07:13:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

This test is off by one because the NUL terminator isn't taken into
consideration.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 494bfa4..4793875 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -120,7 +120,7 @@ struct iscsi_tiqn *iscsit_add_tiqn(unsigned char *buf)
 	struct iscsi_tiqn *tiqn = NULL;
 	int ret;
 
-	if (strlen(buf) > ISCSI_IQN_LEN) {
+	if (strlen(buf) >= ISCSI_IQN_LEN) {
 		pr_err("Target IQN exceeds %d bytes\n",
 				ISCSI_IQN_LEN);
 		return ERR_PTR(-EINVAL);
