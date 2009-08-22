From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] gdth: unmap ccb_phys when scsi_add_host() fails in gdth_eisa_probe_one()
Date: Sat, 22 Aug 2009 19:05:52 +0200
Message-ID: <4A902570.1080103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:54017 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbZHVRBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 13:01:01 -0400
Received: by ewy3 with SMTP id 3so1372983ewy.18
        for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 10:01:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

unmap ccb_phys as well when scsi_add_host() fails

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Right?

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 185e6bc..3111503 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4903,7 +4903,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 
 	error = scsi_add_host(shp, NULL);
 	if (error)
-		goto out_free_coal_stat;
+		goto out_free_ccb_phys;
 	list_add_tail(&ha->list, &gdth_instances);
 	gdth_timer_init();
 
