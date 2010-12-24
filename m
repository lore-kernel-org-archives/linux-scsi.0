From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_mid_low_api.txt recommend resid usage
Date: Thu, 23 Dec 2010 21:40:37 -0500
Message-ID: <4D140825.6000704@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050005000600020302050008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51484 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0LXCkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2010 21:40:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

This is a multi-part message in MIME format.
--------------050005000600020302050008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As discussed in a thread on this list titled:
    "RFC: short reads on block devices"
this patch adds recommendations for LLDs to set resid
when there might be uncertainty about how much data
has been returned by a device.

This patch inline and attached] is against scsi-misc-2.6.git


Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


diff --git a/Documentation/scsi/scsi_mid_low_api.txt 
b/Documentation/scsi/scsi_mid_low_api.txt
index df322c1..7bcdea7 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1343,7 +1343,7 @@ Members of interest:
                     underruns (overruns should be rare). If possible an LLD
                     should set 'resid' prior to invoking 'done'. The most
                     interesting case is data transfers from a SCSI target
-                   device device (i.e. READs) that underrun.
+                   device (e.g. READs) that underrun.
      underflow    - LLD should place (DID_ERROR << 16) in 'result' if
                     actual number of bytes transferred is less than this
                     figure. Not many LLDs implement this check and some that
@@ -1351,6 +1351,18 @@ Members of interest:
                     report a DID_ERROR. Better for an LLD to implement
                     'resid'.

+It is recommended that a LLD set 'resid' on data transfers from a SCSI
+target device (e.g. READs). It is especially important that 'resid' is set
+when such data transfers have sense keys of MEDIUM ERROR and HARDWARE ERROR
+(and possibly RECOVERED ERROR). In these cases if a LLD is in doubt how much
+data has been received then the safest approach is to indicate no bytes have
+been received. For example: to indicate that no valid data has been received
+a LLD might use these helpers:
+    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
+where 'SCpnt' is a pointer to a scsi_cmnd object. To indicate only three 512
+bytes blocks has been received 'resid' could be set like this:
+    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt) - (3 * 512));
+
  The scsi_cmnd structure is defined in include/scsi/scsi_cmnd.h



--------------050005000600020302050008
Content-Type: text/x-patch;
 name="scsi_mid_low_api_resid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi_mid_low_api_resid.patch"

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index df322c1..7bcdea7 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1343,7 +1343,7 @@ Members of interest:
                    underruns (overruns should be rare). If possible an LLD
                    should set 'resid' prior to invoking 'done'. The most
                    interesting case is data transfers from a SCSI target
-                   device device (i.e. READs) that underrun. 
+                   device (e.g. READs) that underrun. 
     underflow    - LLD should place (DID_ERROR << 16) in 'result' if
                    actual number of bytes transferred is less than this
                    figure. Not many LLDs implement this check and some that
@@ -1351,6 +1351,18 @@ Members of interest:
                    report a DID_ERROR. Better for an LLD to implement
                    'resid'.
 
+It is recommended that a LLD set 'resid' on data transfers from a SCSI
+target device (e.g. READs). It is especially important that 'resid' is set
+when such data transfers have sense keys of MEDIUM ERROR and HARDWARE ERROR
+(and possibly RECOVERED ERROR). In these cases if a LLD is in doubt how much
+data has been received then the safest approach is to indicate no bytes have
+been received. For example: to indicate that no valid data has been received
+a LLD might use these helpers:
+    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
+where 'SCpnt' is a pointer to a scsi_cmnd object. To indicate only three 512
+bytes blocks has been received 'resid' could be set like this:
+    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt) - (3 * 512));
+
 The scsi_cmnd structure is defined in include/scsi/scsi_cmnd.h
 
 

--------------050005000600020302050008--
