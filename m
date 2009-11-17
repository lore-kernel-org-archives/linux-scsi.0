From: akpm@linux-foundation.org
Subject: [patch 10/18] gdth: unmap ccb_phys when scsi_add_host() fails in gdth_eisa_probe_one()
Date: Tue, 17 Nov 2009 14:53:20 -0800
Message-ID: <200911172253.nAHMrLVK019947@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355AbZKQWz3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:55:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, achim_leubner@adaptec.com

From: Roel Kluin <roel.kluin@gmail.com>

unmap ccb_phys as well when scsi_add_host() fails

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Achim Leubner <achim_leubner@adaptec.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one
+++ a/drivers/scsi/gdth.c
@@ -4903,7 +4903,7 @@ static int __init gdth_eisa_probe_one(us
 
 	error = scsi_add_host(shp, NULL);
 	if (error)
-		goto out_free_coal_stat;
+		goto out_free_ccb_phys;
 	list_add_tail(&ha->list, &gdth_instances);
 	gdth_timer_init();
 
_
