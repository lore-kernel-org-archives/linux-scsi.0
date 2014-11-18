From: Christian =?ISO-8859-1?Q?S=FCnkenberg?=
	<christian.suenkenberg@hfg-karlsruhe.de>
Subject: [PATCH] scsi: Add Intel Multi-Flex to scsi scan blacklist
Date: Tue, 18 Nov 2014 20:23:32 +0100
Message-ID: <1416338612.13492.17.camel@hfg-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.hfg-karlsruhe.de ([193.197.160.26]:49403 "EHLO
	mx0.hfg-karlsruhe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaKRTbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2014 14:31:24 -0500
Received: from postamt.hfg-karlsruhe.de (postamt.hfg-karlsruhe.de [193.197.160.12])
	by mx0.hfg-karlsruhe.de (Postfix) with ESMTP id 9C66D7208C5
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2014 20:23:32 +0100 (CET)
Received: from snkws (unknown [192.168.9.8])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by postamt.hfg-karlsruhe.de (Postfix) with ESMTPSA id 8FC0023C1826
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2014 20:23:32 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

=46rom: Christian S=C3=BCnkenberg <christian.suenkenberg@hfg-karlsruhe.=
de>

Intel Multi-Flex LUNs choke on REPORT SUPPORTED OPERATION CODES
resulting in sd_mod hanging for several minutes on startup.
The issue was introduced with WRITE SAME discovery heuristics.

=46ixes: 5db44863b6eb ("[SCSI] sd: Implement support for WRITE SAME")
Signed-off-by: Christian S=C3=BCnkenberg <christian.suenkenberg@hfg-kar=
lsruhe.de>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 49014a1..c1d04d4 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -202,6 +202,7 @@ static struct {
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
+	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIR=
Y_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
--=20
2.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
