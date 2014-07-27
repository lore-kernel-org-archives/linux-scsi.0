From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: 3w-9xxx.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 17:11:18 +0200
Message-ID: <1406473878-12715-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:58904 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaG0PJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jul 2014 11:09:52 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so6270743wes.30
        for <linux-scsi@vger.kernel.org>; Sun, 27 Jul 2014 08:09:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And use the sizeof on the to string rather than strlen on the from string.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/3w-9xxx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 0a73253..f4d2331 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -621,7 +621,8 @@ static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed)
 	}
 
 	/* Load rest of compatibility struct */
-	strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION, strlen(TW_DRIVER_VERSION));
+	strlcpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
+		sizeof(tw_dev->tw_compat_info.driver_version));
 	tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
 	tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
 	tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
-- 
1.7.10.4

