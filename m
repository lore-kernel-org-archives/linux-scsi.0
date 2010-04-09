From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/12] libfc: bug in erroring out upon FCP_RSP_LEN_VAL in
	fc_fcp_resp
Date: Fri, 09 Apr 2010 14:23:05 -0700
Message-ID: <20100409212305.1968.17031.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39525 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab0DIVXG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:23:06 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

fc_fcp_resp is assuming when FCP_SNS_LEN_VAL is set, the FCP_RSP_LEN_VAL
is not, which is not true. This leads to not copying the sense data and
error out a valid FCP_RSP.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 220c4bc..f99d66f 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -844,8 +844,7 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 					 * exit here
 					 */
 					return;
-				} else
-					goto err;
+				}
 			}
 			if (flags & FCP_SNS_LEN_VAL) {
 				snsl = ntohl(rp_ex->fr_sns_len);

