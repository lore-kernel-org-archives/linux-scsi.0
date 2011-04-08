From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 3/3] scsi_dh_rdac : decide on whether to send mode select or
 not based on operating mode
Date: Fri, 8 Apr 2011 11:39:30 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFAC9628@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:47630 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab1DHRiO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2011 13:38:14 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Arumugam, Anburaja" <Anburaja.Arumugam@lsi.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>

Based on the operating modes, handler decides whether to send mode select or not. Purpose here is to reduce
io-shipping as much as possible whenever there is an option.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Yanling Qi <yanling.qi@lsi.com> 
Reviewed-by: Sudhir Dachepalli <Sudhir.Dachepalli@lis.com>
Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
Reviewed-by: Bob Stankey <Robert.Stankey@lsi.com>
Reviewed-by: Vijay Chauhan <Vijay.Chauhan@lsi.com>

---
--- linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-03-17 16:57:51.000000000 -0500
+++ linux-2.6.38/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-03-17 16:59:11.000000000 -0500
@@ -670,12 +670,27 @@ static int rdac_activate(struct scsi_dev
 {
 	struct rdac_dh_data *h = get_rdac_data(sdev);
 	int err = SCSI_DH_OK;
+	int act = 0;
 
 	err = check_ownership(sdev, h);
 	if (err != SCSI_DH_OK)
 		goto done;
 
-	if (h->lun_state == RDAC_LUN_UNOWNED) {
+	switch (h->mode) {
+	case RDAC_MODE:
+		if (h->lun_state == RDAC_LUN_UNOWNED)
+			act = 1;
+		break;
+	case RDAC_MODE_IOSHIP:
+		if ((h->lun_state == RDAC_LUN_UNOWNED) &&
+		    (h->preferred == RDAC_PREFERRED))
+			act = 1;
+		break;
+	default:
+		break;
+	}
+
+	if (act) {
 		err = queue_mode_select(sdev, fn, data);
 		if (err == SCSI_DH_OK)
 			return 0;


