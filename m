From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug [was: scsi_debug issues]
Date: Tue, 19 Oct 2004 08:05:53 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41743E41.8020707@torque.net>
References: <20041015190154.GA3073@us.ibm.com> <4170C505.3000805@torque.net> <1097932370.1962.4.camel@mulgrave> <4173C8DB.8030009@torque.net> <20041018183747.GA3530@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050303070206030003080301"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub1.uq.edu.au ([130.102.148.128]:7431 "EHLO
	mailhub1.uq.edu.au") by vger.kernel.org with ESMTP id S267535AbUJRWHE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 18:07:04 -0400
In-Reply-To: <20041018183747.GA3530@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

This is a multi-part message in MIME format.
--------------050303070206030003080301
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Nishanth Aravamudan wrote:
> On Mon, Oct 18, 2004 at 11:44:59PM +1000, Douglas Gilbert wrote:
> 
>>James Bottomley wrote:
>>
>>>On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
>>>
>>>
>>>>So this problem seems related to highmem.
> 
> 
> <snip>
> 
>>The above required a fair few changes to scsi_debug.
>>Attached is a patch that rolls "kmap" changes with
>>patches I have sent recently for scsi_debug.
>>Attachment is gzipped (due to size) and applies against
>>lk 2.6.8.1 -> lk 2.6.9-rc4 .
>>
>>Nishanth, could you test this with highmem?
> 
> 
> Doug,
> 
> I ran 2.6.9-rc4 with your patch applied and had several dump_stack()s
> occur (complaining about sleeping in an invalid context) and a final
> panic during mkfs :) I think something is still wrong... ;) Output is
> below and attached.

Ok, it looks like kmap_atomic() is needed.
Could you try this additional patch.

Doug Gilbert

--------------050303070206030003080301
Content-Type: text/x-patch;
 name="sdebug269rc4_174b.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug269rc4_174b.diff"

--- linux/drivers/scsi/scsi_debug.c	2004-10-19 07:59:14.966673272 +1000
+++ linux/drivers/scsi/scsi_debug.c174b	2004-10-19 07:58:46.044070176 +1000
@@ -56,7 +56,7 @@
 #include "scsi_debug.h"
 
 #define SCSI_DEBUG_VERSION "1.74"
-static const char * scsi_debug_version_date = "20041018";
+static const char * scsi_debug_version_date = "20041019";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -505,7 +505,8 @@
 	active = 1;
 	for (k = 0, req_len = 0, act_len = 0; k < scp->use_sg; ++k, ++sgpnt) {
 		if (active) {
-			kaddr = (unsigned char *)kmap(sgpnt->page);
+			kaddr = (unsigned char *)
+				kmap_atomic(sgpnt->page, KM_USER0);
 			if (NULL == kaddr)
 				return (DID_ERROR << 16);
 			kaddr = (unsigned char *)kaddr + sgpnt->offset;
@@ -515,7 +516,7 @@
 				len = arr_len - req_len;
 			}
 			memcpy(kaddr, arr + req_len, len);
-			kunmap(sgpnt->page);
+			kunmap_atomic(sgpnt->page, KM_USER0);
 			act_len += len;
 		}
 		req_len += sgpnt->length;
@@ -547,7 +548,7 @@
 	}
 	sgpnt = (struct scatterlist *)scp->request_buffer;
 	for (k = 0, req_len = 0, fin = 0; k < scp->use_sg; ++k, ++sgpnt) {
-		kaddr = (unsigned char *)kmap(sgpnt->page);
+		kaddr = (unsigned char *)kmap_atomic(sgpnt->page, KM_USER0);
 		if (NULL == kaddr)
 			return -1;
 		kaddr = (unsigned char *)kaddr + sgpnt->offset;
@@ -557,7 +558,7 @@
 			fin = 1;
 		}
 		memcpy(arr + req_len, kaddr, len);
-		kunmap(sgpnt->page);
+		kunmap_atomic(sgpnt->page, KM_USER0);
 		if (fin)
 			return req_len + len;
 		req_len += sgpnt->length;

--------------050303070206030003080301--
