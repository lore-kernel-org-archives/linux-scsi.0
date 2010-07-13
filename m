From: Shyam Iyer <shyam_iyer@dell.com>
Subject: [PATCH] Wait for 15s on doorbell ACK before checking IOC READY state
Date: Tue, 13 Jul 2010 13:04:07 -0400
Message-ID: <4C3C9C87.9050904@dell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030202030905090602000109"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausxippc101.us.dell.com ([143.166.85.207]:36763 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab0GMRET (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2010 13:04:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com

This is a multi-part message in MIME format.
--------------030202030905090602000109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Wait for 15 seconds for Doorbell ACK.

Not waiting 15s results in a few resets and kernel panics.

https://bugzilla.redhat.com/show_bug.cgi?id=594505

This is also logical since we wait for 15 seconds to compare if the 
state really changed.

Signed-off-by: Shyam Iyer<shyam_iyer@dell.com>


--------------030202030905090602000109
Content-Type: text/plain;
 name="0001-Wait-for-15s-on-doorbell-ACK-before-checking-IOC-REA.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Wait-for-15s-on-doorbell-ACK-before-checking-IOC-REA.pa";
 filename*1="tch"

>From a2cfe7cad6c22849d3561a5466760917c1d3b02a Mon Sep 17 00:00:00 2001
From: Shyam Iyer <shyam_iyer@dell.com>
Date: Thu, 8 Jul 2010 15:47:53 -0400
Subject: [PATCH] Wait for 15s on doorbell ACK before checking IOC READY state

Not waiting 15s results in a few resets and kernel panics.

https://bugzilla.redhat.com/show_bug.cgi?id=594505

This is also logical since we wait for 15 seconds to compare if the state really changed.

Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
---
 drivers/message/fusion/mptbase.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a6a5701..e658a53 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4208,7 +4208,7 @@ SendIocReset(MPT_ADAPTER *ioc, u8 reset_type, int sleepFlag)
 	drsprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Sending IOC reset(0x%02x)!\n",
 			ioc->name, reset_type));
 	CHIPREG_WRITE32(&ioc->chip->Doorbell, reset_type<<MPI_DOORBELL_FUNCTION_SHIFT);
-	if ((r = WaitForDoorbellAck(ioc, 5, sleepFlag)) < 0)
+	if ((r = WaitForDoorbellAck(ioc, 15, sleepFlag)) < 0)
 		return r;
 
 	/* FW ACK'd request, wait for READY state
-- 
1.6.6.1


--------------030202030905090602000109--
