From: Takayoshi Kochi <t-kochi@bq.jp.nec.com>
Subject: [PATCH] qla1280.c /proc/scsi/qla1280/x reads garbage
Date: Fri, 04 Feb 2005 20:21:10 +0900 (JST)
Message-ID: <20050204.202110.59656828.t-kochi@bq.jp.nec.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Fri_Feb__4_20_21_10_2005_818)--"
Content-Transfer-Encoding: 7bit
Received: from TYO201.gate.nec.co.jp ([202.32.8.214]:23000 "EHLO
	tyo201.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S261638AbVBDLVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 06:21:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jes@wildopensource.com
Cc: linux-scsi@vger.kernel.org

----Next_Part(Fri_Feb__4_20_21_10_2005_818)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Jes,

This is a resent of the same patch I posted a month ago.

In 2.6.11-rc3, reading /proc/scsi/qla1280/0 sometimes spits garbage.
This is because in qla1280_proc_info() the returned pointer to
the buffer isn't what the upper layer expects.

This problem seems already fixed in 2.4 series (I checked 2.4.28).

Why the fix is missing in 2.6?  This can be lead to a security
problem (random kernel memory leaks to userspace).

Patch attached. (compiled and worked for me)

Signed-off-by: Takayoshi Kochi <t-kochi@bq.jp.nec.com>

---
Takayoshi Kochi

----Next_Part(Fri_Feb__4_20_21_10_2005_818)--
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

----Next_Part(Fri_Feb__4_20_21_10_2005_818)----
