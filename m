From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] mptfusion: don't allow negative bytes in kbuf_alloc_2_sgl()
Date: Wed, 11 Nov 2015 01:15:24 +0300
Message-ID: <20151110221524.GB30281@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a static checker warning here because "bytes" is controlled by
the user and we cap the upper bound with min() but allow negatives.
Negative bytes will result in some nasty warning messages but are not
super harmful.  Anyway, no one needs negative bytes so let's just check
for it and return NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index fc73937..02b5f69 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1038,6 +1038,10 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 	int		 i, buflist_ent;
 	int		 sg_spill = MAX_FRAGS_SPILL1;
 	int		 dir;
+
+	if (bytes < 0)
+		return NULL;
+
 	/* initialization */
 	*frags = 0;
 	*blp = NULL;
