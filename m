From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: ibmvscsi: ibmvstgt.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun,  3 Aug 2014 01:23:57 +0200
Message-ID: <1407021837-28525-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:58716 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaHBXW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2014 19:22:29 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so5878005wes.22
        for <linux-scsi@vger.kernel.org>; Sat, 02 Aug 2014 16:22:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Rob Herring <robh+dt@kernel.org>, Michael Opdenacker <michael.opdenacker@free-electrons.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 56f8a86..5c16d17 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -340,7 +340,7 @@ int send_adapter_info(struct iu_entry *iue,
 	memset(info, 0, sizeof(*info));
 
 	strcpy(info->srp_version, "16.a");
-	strncpy(info->partition_name, partition_name,
+	strlcpy(info->partition_name, partition_name,
 		sizeof(info->partition_name));
 	info->partition_number = partition_number;
 	info->mad_version = 1;
@@ -938,7 +938,7 @@ static int get_system_info(void)
 
 	name = of_get_property(rootdn, "ibm,partition-name", NULL);
 	if (name)
-		strncpy(partition_name, name, sizeof(partition_name));
+		strlcpy(partition_name, name, sizeof(partition_name));
 
 	num = of_get_property(rootdn, "ibm,partition-no", NULL);
 	if (num)
-- 
1.7.10.4

