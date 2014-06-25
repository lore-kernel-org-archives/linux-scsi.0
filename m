From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: pm8001: pm80xx_hwi.c:  Cleaning up variable is set more than once
Date: Wed, 25 Jun 2014 16:01:47 +0200
Message-ID: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:53592 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaFYOAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 10:00:51 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so2116673wes.38
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2014 07:00:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xjtuwjp@gmail.com, lindar_liu@usish.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

A struct member variable is set to different values without having used in between.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index d70587f..2698227 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -249,7 +249,6 @@ moreData:
 				sprintf(pm8001_ha->
 					forensic_info.data_buf.direct_data,
 						"%08x ", 4);
-			pm8001_ha->forensic_info.data_buf.read_len = 0xFFFFFFFF;
 			pm8001_ha->forensic_info.data_buf.direct_len =  0;
 			pm8001_ha->forensic_info.data_buf.direct_offset = 0;
 			pm8001_ha->forensic_info.data_buf.read_len = 0;
-- 
1.7.10.4

