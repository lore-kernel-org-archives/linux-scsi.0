From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] hptiop: fix type mismatch warning
Date: Wed, 24 Oct 2007 06:34:09 -0400
Message-ID: <20071024103409.GA31302@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:46302 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbXJXKeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:34:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>


drivers/scsi/hptiop.c: In function 'hptiop_host_request_callback':
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast

Use min_t(size_t, ...) to fix.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 0844331..7fc532b 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -376,7 +376,7 @@ static void hptiop_host_request_callback(struct hptiop_hba *hba, u32 _tag)
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
 		memcpy(&scp->sense_buffer, &req->sg_list,
-				min(sizeof(scp->sense_buffer),
+				min_t(size_t, sizeof(scp->sense_buffer),
 					le32_to_cpu(req->dataxfer_length)));
 		break;
 
