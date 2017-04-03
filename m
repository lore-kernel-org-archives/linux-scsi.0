From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] block: Improve error handling verbosity
Date: Mon,  3 Apr 2017 16:03:49 +0400
Message-ID: <1491221029-1609-2-git-send-email-dmonakhov@openvz.org>
References: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34892 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751944AbdDCMD7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 08:03:59 -0400
In-Reply-To: <1491221029-1609-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>

EILSEQ is returned due to internal csum error on disk/fabric,
let's add special message to distinguish it from others. Also dump
original numerical error code.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 071a998..8eab846 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2576,13 +2576,16 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENODATA:
 			error_type = "critical medium";
 			break;
+		case -EILSEQ:
+			error_type = "bad data";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
 			break;
 		}
-		printk_ratelimited(KERN_ERR "%s: %s error, dev %s, sector %llu\n",
-				   __func__, error_type, req->rq_disk ?
+		printk_ratelimited(KERN_ERR "%s: %s error (%d), dev %s, sector %llu\n",
+				   __func__, error_type, error, req->rq_disk ?
 				   req->rq_disk->disk_name : "?",
 				   (unsigned long long)blk_rq_pos(req));
 
-- 
2.9.3
