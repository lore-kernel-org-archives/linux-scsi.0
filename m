From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] iscsi-target: missing kfree() on error path
Date: Mon, 24 Jun 2013 18:46:57 +0300
Message-ID: <20130624154657.GB31984@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We need to free "payload" before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c1106bb..1e59630 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3426,6 +3426,7 @@ static int iscsit_build_sendtargets_response(struct iscsi_cmd *cmd)
 		if (!text_ptr) {
 			pr_err("Unable to locate '=' string in text_in:"
 			       " %s\n", text_in);
+			kfree(payload);
 			return -EINVAL;
 		}
 		/*
