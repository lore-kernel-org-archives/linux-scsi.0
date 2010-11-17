From: Hillf Danton <dhillf@gmail.com>
Subject: [patch] fix START_STOP method in HP/COMPAQ MSA Device Handler
Date: Wed, 17 Nov 2010 20:56:01 +0800
Message-ID: <AANLkTikrt4=rKYiX6ndiCKtoqy9dZPj94TjyofdyGWak@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62235 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0KQM4D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 07:56:03 -0500
Received: by wwa36 with SMTP id 36so1986313wwa.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2010 04:56:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When retry encountered, the count of retries is computed incorrectly,
since it is one less.

And a typo is also cleaned.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-11-01
19:54:12.000000000 +0800
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c	2010-11-17
20:57:58.000000000 +0800
@@ -216,7 +216,7 @@ static void start_stop_endio(struct requ
 		err = start_done(h->sdev, h->sense);
 		if (err == SCSI_DH_RETRY) {
 			err = SCSI_DH_IO;
-			if (--h->retry_cnt) {
+			if (h->retry_cnt--) {
 				blk_put_request(req);
 				err = hp_sw_start_stop(h);
 				if (err == SCSI_DH_OK)
@@ -343,7 +343,7 @@ static int hp_sw_bus_attach(struct scsi_
 	if (!scsi_dh_data) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
-		return 0;
+		return -ENOMEM;
 	}

 	scsi_dh_data->scsi_dh = &hp_sw_dh;
