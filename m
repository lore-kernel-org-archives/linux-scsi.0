From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] fcoe: precedence bug in fcoe_filter_frames()
Date: Wed, 16 Feb 2011 14:10:55 +0300
Message-ID: <20110216111055.GU4384@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34290 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1BPLLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 06:11:17 -0500
Received: by bwz15 with SMTP id 15so491708bwz.19
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 03:11:16 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>, Vasu Dev <vasu.dev@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>

Negate has higher precedence than bitwise AND.  FCPHF_CRC_UNCHECKED is
0x1 so the original code is equivalent to: if (!fr_flags(fp)) { ...

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 495456f..a2875d9 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1546,7 +1546,7 @@ static inline int fcoe_filter_frames(struct fc_lport *lport,
 		return -EINVAL;
 	}
 
-	if (!fr_flags(fp) & FCPHF_CRC_UNCHECKED ||
+	if (!(fr_flags(fp) & FCPHF_CRC_UNCHECKED) ||
 	    le32_to_cpu(fr_crc(fp)) == ~crc32(~0, skb->data, skb->len)) {
 		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 		return 0;
