From: Sachin Sant <sachinp@in.ibm.com>
Subject: [Patch]Status_byte() in drivers/scsi/scsi.h
Date: Fri, 20 Jun 2003 14:10:09 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF2C869.F794F1A6@in.ibm.com>
References: <3EF178AC.CEC2C720@in.ibm.com> <3EF17DFC.8030700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:60915 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262445AbTFTIX3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 04:23:29 -0400
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e6.ny.us.ibm.com (8.12.9/8.12.2) with ESMTP id h5K8bTxr158528
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2003 04:37:29 -0400
Received: from in.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h5K8bPkY066258
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2003 04:37:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


According to Dougs comments , here is the patch to include new macros
for SAM status codes . Patch is in drivers/scsi/scsi.h

--- scsi.h	2003-06-19 14:26:54.000000000 +0530
+++ scsi.h.new	2003-06-20 13:54:46.000000000 +0530
@@ -95,6 +95,13 @@
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
  */
+
+/* 
+ * Define a new macro sam_status_value for the status codes
+ * defined for new SCSI Architecture Model SAM 
+ */
+#define sam_status_value(scmd_result) ((scmd_result) & 0x7e)
+
 #define status_byte(result) (((result) >> 1) & 0x1f)
 #define msg_byte(result)    (((result) >> 8) & 0xff)

Any comments are welcome.

Thanks
-Sachin 
-----------------------------------------------------------------------------------

Douglas Gilbert wrote:
> Sachin,
> The status_byte() macro is for SCSI-2 and earlier and
> matches a Linux-specific set of defines that are
> shifted from the "standard" values (e.g. CHECK_CONDITION).
> In those days bit 6 was not in use.
> 
> We are still arguing about the exact form of the macro
> to use that matches the SAM_STAT_ defines show above.
> In the meantime you could use:
>    #define sam_status_value(scmd_result) ((scmd_result) & 0x7e)
> and compare the result with the SAM_STAT_ defines above.
> 
> Doug Gilbert
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
