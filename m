From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 01/29] scsi: aacraid: Fix udev inquiry race condition
Date: Thu, 21 Dec 2017 09:33:52 -0800
Message-ID: <20171221173420.8213-2-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0040.outbound.protection.outlook.com ([104.47.42.40]:15680
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752513AbdLURe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:26 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

When udev requests for a devices inquiry string, it might create multiple
threads causing a race condition on the shared inquiry resource string.

Created a buffer with the string for each thread.

Cc: <stable@vger.kernel.org>
Fixes: 3bc8070fb75b3315 ([SCSI] aacraid: SMC vendor identification)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index af3e4d3..f264515 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -913,8 +913,18 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 	memset(str, ' ', sizeof(*str));
 
 	if (sup_adap_info->adapter_type_text[0]) {
-		char *cp = sup_adap_info->adapter_type_text;
 		int c;
+		char *cp;
+		char *cname = kmalloc(sizeof(sup_adap_info->adapter_type_text),
+								GFP_ATOMIC);
+
+		if (!cname)
+			return;
+
+		cp = cname;
+		memcpy(cname, sup_adap_info->adapter_type_text,
+			sizeof(sup_adap_info->adapter_type_text));
+
 		if ((cp[0] == 'A') && (cp[1] == 'O') && (cp[2] == 'C'))
 			inqstrcpy("SMC", str->vid);
 		else {
@@ -923,7 +933,7 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 				++cp;
 			c = *cp;
 			*cp = '\0';
-			inqstrcpy(sup_adap_info->adapter_type_text, str->vid);
+			inqstrcpy(cname, str->vid);
 			*cp = c;
 			while (*cp && *cp != ' ')
 				++cp;
@@ -937,8 +947,8 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 			cp[sizeof(str->pid)] = '\0';
 		}
 		inqstrcpy (cp, str->pid);
-		if (c)
-			cp[sizeof(str->pid)] = c;
+
+		kfree(cname);
 	} else {
 		struct aac_driver_ident *mp = aac_get_driver_ident(dev->cardtype);
 
-- 
2.9.4
