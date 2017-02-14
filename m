From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 04/16] aacraid: Prevent E3 lockup when deleting units
Date: Tue, 14 Feb 2017 12:44:34 -0800
Message-ID: <20170214204446.14808-5-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0043.outbound.protection.outlook.com ([104.47.40.43]:62030
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751619AbdBODWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:35 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

Arrconf management utility at times sends fibs with AdapterProcessed set
in its fibs. This causes the controller to panic and lockup.

Fixed by failing the commands that have AdapterProcessed set in its flag.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 6220b47..f7a3bcb 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -522,6 +522,10 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 
 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
 		return -EBUSY;
+
+	if (hw_fib->header.XferState & cpu_to_le32(AdapterProcessed))
+		return -EINVAL;
+
 	/*
 	 *	There are 5 cases with the wait and response requested flags.
 	 *	The only invalid cases are if the caller requests to wait and
-- 
2.7.4
