From: akpm@linux-foundation.org
Subject: [patch 05/26] gdth: unmap ccb_phys when scsi_add_host() fails in gdth_eisa_probe_one()
Date: Mon, 24 May 2010 12:22:23 -0700
Message-ID: <201005241922.o4OJMN5J011293@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757200Ab0EXTXN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2010 15:23:13 -0400
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
@@ -4914,7 +4914,7 @@ static int __init gdth_eisa_probe_one(u1
 
 	error = scsi_add_host(shp, NULL);
 	if (error)
-		goto out_free_coal_stat;
+		goto out_free_ccb_phys;
 	list_add_tail(&ha->list, &gdth_instances);
 	gdth_timer_init();
 
_
