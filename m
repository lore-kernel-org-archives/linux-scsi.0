From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 01/30] scsi: aacraid: Fix udev inquiry race condition
Date: Tue, 26 Dec 2017 20:34:22 -0800
Message-ID: <20171227043451.27813-2-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0067.outbound.protection.outlook.com ([104.47.34.67]:23244
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751332AbdL0Ee6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:34:58 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

When udev requests for a devices inquiry string, it might create multiple
threads causing a race condition on the shared inquiry resource string.

Created a buffer with the string for each thread.

Cc: <stable@vger.kernel.org>
Fixes: 3bc8070fb75b3315 ([SCSI] aacraid: SMC vendor identification)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Replaced kmalloc and memcpy adapter_type_text with kmemdup

 drivers/scsi/aacraid/aachba.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index af3e4d3..548a3e7 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -913,8 +913,16 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 	memset(str, ' ', sizeof(*str));
 
 	if (sup_adap_info->adapter_type_text[0]) {
-		char *cp = sup_adap_info->adapter_type_text;
 		int c;
+		char *cp;
+		char *cname = kmemdup(sup_adap_info->adapter_type_text,
+				sizeof(sup_adap_info->adapter_type_text),
+								GFP_ATOMIC);
+
+		if (!cname)
+			return;
+
+		cp = cname;
 		if ((cp[0] == 'A') && (cp[1] == 'O') && (cp[2] == 'C'))
 			inqstrcpy("SMC", str->vid);
 		else {
@@ -923,7 +931,7 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 				++cp;
 			c = *cp;
 			*cp = '\0';
-			inqstrcpy(sup_adap_info->adapter_type_text, str->vid);
+			inqstrcpy(cname, str->vid);
 			*cp = c;
 			while (*cp && *cp != ' ')
 				++cp;
@@ -937,8 +945,8 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
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
