From: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Subject: RE: [PATCH v2 1/1] be2iscsi: add block valid bit to iBFT flag
Date: Mon, 19 Jan 2015 18:53:04 +0000
Message-ID: <16699bc6-b9b0-474e-ad3e-e325d30460bf@CMEXHTCAS1.ad.emulex.com>
References: <1efcc1ff-0b88-4247-a8c2-5099f9fd0b20@CMEXHTCAS2.ad.emulex.com>
 <54B9AE2D.9020205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:5507 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbbASSxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jan 2015 13:53:33 -0500
In-Reply-To: <54B9AE2D.9020205@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>

>From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
>Sent: Friday, January 16, 2015 4:35 PM
>To: Minh Duc Tran
>Cc: linux-scsi@vger.kernel.org; Jayamohan Kallickal
>Subject: Re: [PATCH v2 1/1] be2iscsi: add block valid bit to iBFT flag

>On 01/16/2015 01:44 PM, Minh Duc Tran wrote:
>>> From: Michael Christie [mailto:michaelc@cs.wisc.edu]
>>> Sent: Friday, January 16, 2015 8:28 AM
>>> To: Minh Duc Tran
>>> Cc: linux-scsi@vger.kernel.org; Jayamohan Kallickal
>>> Subject: Re: [PATCH 1/1] be2iscsi: add block valid bit to iBFT flag
>> 
>>> I think we are misunderstanding each other on my comments. You need to modify your patch so it fixes the problem in a general way for all drivers.
>> 
>> 
>> Ok got it!  This is the new patch with changes for both be2iscsi and qla4xxx.
>> 

>Could you try the attached patch. It is not even compile tested. It will allow ibft and non ibft drivers to export info in the same way. When drivers and userspace supports some of the other things like radius chap, we can add defines for those too.

Compiled error with your original patch.
I've changed patch with last line pasted below and compiled against the sles12 kernel for be2iscsi and qla4xxx, tested boot session with be2iscsi.  It is working now.

diff --git a/include/linux/iscsi_boot_sysfs.h b/include/linux/iscsi_boot_sysfs.h
index 2a8b165..e120c2a 100644
--- a/include/linux/iscsi_boot_sysfs.h
+++ b/include/linux/iscsi_boot_sysfs.h
@@ -16,6 +16,9 @@
 #ifndef _ISCSI_BOOT_SYSFS_
 #define _ISCSI_BOOT_SYSFS_

+#define ISCSI_BOOT_FLAG_VALID                  0x1
+#define ISCSI_BOOT_FLAG_FW_BOOT_SEL            0x2
+
