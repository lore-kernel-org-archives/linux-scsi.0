From: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
Subject: qla1280.c /proc/scsi/qla1280/x reads garbage
Date: Tue, 28 Dec 2004 16:58:52 +0900 (JST)
Message-ID: <20041228.165852.74724555.t-kochi@bq.jp.nec.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Tue_Dec_28_16_58_52_2004_253)--"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.214]:34481 "EHLO
	tyo201.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S261645AbUL1IAd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2004 03:00:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jes@wildopensource.com
Cc: linux-scsi@vger.kernel.org

----Next_Part(Tue_Dec_28_16_58_52_2004_253)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

With 2.6.10, reading /proc/scsi/qla1280/0 sometimes spits garbage.
This problem seems already fixed in 2.4 series (I checked 2.4.28).

Why the fix is missing in 2.6?
Patch attached. (compiled and worked for me)

Signed-off-by: Takayoshi Kochi <t-kochi@bq.jp.nec.com>

---
Takayoshi Kochi

----Next_Part(Tue_Dec_28_16_58_52_2004_253)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="qla1280.patch"

--- linux-2.6.10.orig/drivers/scsi/qla1280.c	Sat Dec 25 06:35:40 2004
+++ linux-2.6.10/drivers/scsi/qla1280.c	Tue Dec 28 16:53:33 2004
@@ -776,10 +776,11 @@ static int qla1280_proc_info(struct Scsi
 		qla1280_buffer_size = length = 0;
 		*start = NULL;
 	} else {
-		*start = &qla1280_buffer[offset];	/* Start of wanted data */
+		*start = buffer;
 		if (len - offset < length) {
 			length = len - offset;
 		}
+		memcpy(buffer, &qla1280_buffer[offset], length);
 	}
 	return length;
 }

----Next_Part(Tue_Dec_28_16_58_52_2004_253)----
