From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mpt fusion: declare some sizes as unsigned
Date: Fri, 1 Nov 2013 13:24:10 +0300
Message-ID: <20131101102410.GD29795@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3KAK1U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2013 06:27:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

In mptctl_do_mpt_command() we cap the upper bound of .maxSenseBytes but
we don't check for negative values:

	if (karg.maxSenseBytes > MPT_SENSE_BUFFER_SIZE)

I've fixed this by making the type unsigned and I changed the
surrounding types to match as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/message/fusion/mptctl.h b/drivers/message/fusion/mptctl.h
index d564cc9..9ea5a18 100644
--- a/drivers/message/fusion/mptctl.h
+++ b/drivers/message/fusion/mptctl.h
@@ -324,11 +324,11 @@ struct mpt_ioctl_command {
 	char		__user *dataInBufPtr;
 	char		__user *dataOutBufPtr;
 	char		__user *senseDataPtr;
-	int		maxReplyBytes;
-	int		dataInSize;
-	int		dataOutSize;
-	int		maxSenseBytes;
-	int		dataSgeOffset;
+	u32		maxReplyBytes;
+	u32		dataInSize;
+	u32		dataOutSize;
+	u32		maxSenseBytes;
+	u32		dataSgeOffset;
 	char		MF[1];
 };
 
@@ -343,11 +343,11 @@ struct mpt_ioctl_command32 {
 	u32	dataInBufPtr;
 	u32	dataOutBufPtr;
 	u32	senseDataPtr;
-	int	maxReplyBytes;
-	int	dataInSize;
-	int	dataOutSize;
-	int	maxSenseBytes;
-	int	dataSgeOffset;
+	u32	maxReplyBytes;
+	u32	dataInSize;
+	u32	dataOutSize;
+	u32	maxSenseBytes;
+	u32	dataSgeOffset;
 	char	MF[1];
 };
 #endif	/*}*/
