From: akpm@linux-foundation.org
Subject: [patch 07/23] hptiop: fix type mismatch warning
Date: Wed, 21 Nov 2007 15:12:20 -0800
Message-ID: <200711212312.lALNCKTQ014124@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbXKUXNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:13:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com, linux@highpoint-tech.com

From: Jeff Garzik <jeff@garzik.org>

drivers/scsi/hptiop.c: In function 'hptiop_host_request_callback':
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast
drivers/scsi/hptiop.c:378: warning: comparison of distinct pointer types lacks a cast

Use min_t(size_t, ...) to fix.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hptiop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hptiop.c~hptiop-fix-type-mismatch-warning drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~hptiop-fix-type-mismatch-warning
+++ a/drivers/scsi/hptiop.c
@@ -376,7 +376,7 @@ static void hptiop_host_request_callback
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
 		memcpy(&scp->sense_buffer, &req->sg_list,
-				min(sizeof(scp->sense_buffer),
+				min_t(size_t, sizeof(scp->sense_buffer),
 					le32_to_cpu(req->dataxfer_length)));
 		break;
 
_
