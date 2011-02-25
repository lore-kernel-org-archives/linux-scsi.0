From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/8] fcoe: precedence bug in fcoe_filter_frames()
Date: Fri, 25 Feb 2011 15:03:23 -0800
Message-ID: <20110225230323.9310.23224.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:03:23 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

Negate has higher precedence than bitwise AND.  FCPHF_CRC_UNCHECKED is
0x1 so the original code is equivalent to: if (!fr_flags(fp)) { ...

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0b5fbb8..0b44d05 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1548,7 +1548,7 @@ static inline int fcoe_filter_frames(struct fc_lport *lport,
 		return -EINVAL;
 	}
 
-	if (!fr_flags(fp) & FCPHF_CRC_UNCHECKED ||
+	if (!(fr_flags(fp) & FCPHF_CRC_UNCHECKED) ||
 	    le32_to_cpu(fr_crc(fp)) == ~crc32(~0, skb->data, skb->len)) {
 		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 		return 0;

