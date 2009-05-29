From: "John Stoffel" <john@stoffel.org>
Subject: Quiet down "SCSI parity error detected" messages on bootup
Date: Fri, 29 May 2009 15:40:29 -0400
Message-ID: <18976.14893.451617.925871@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:34595 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760704AbZE2Ty1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 15:54:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, linux-scsi@vger.kernel.org


Hi,

This patch helps my system boot faster, esp when using a serial
console, since it ratelimits the "SCSI parity error detected" messages
on bootup.  I've got a dual channel card attached to an old P1000
library with two DLT70000 tape drives installed.  Works great, just
takes forever to bootup when I have tons of message spewing out.

Now they look like this:

  [   66.245351] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   66.327105] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   66.408925] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   66.490753] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   67.061737] scsi 1:0:3:0: ABORT operation started
  [   71.556526] __ratelimit: 11248 callbacks suppressed
  [   71.614935] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   71.696665] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   71.778415] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   71.860242] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae
  [   71.942065] sym0: SCSI parity error detected: SCR2=1 DBC=11000028 SBCL=ae


and it's *much* nicer.  But I'll bet this patch is space damaged when
I send it.   I'll resend it if need be from home.

Thanks.



--- ../2.6.29/drivers/scsi/sym53c8xx_2/sym_hipd.c       2009-05-29
    13:09:50.000000000 -0400
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c 2009-05-21 11:11:17.000000000
    -0400
@@ -2278,8 +2278,9 @@
        int phase       = cmd & 7;
        struct sym_ccb *cp      = sym_ccb_from_dsa(np, dsa);

-       printf("%s: SCSI parity error detected: SCR1=%d DBC=%x
        SBCL=%x\n",
-               sym_name(np), hsts, dbc, sbcl);
+       if (printk_ratelimit())
+               printf("%s: SCSI parity error detected: SCR2=%d DBC=%x SBCL=%x\n",
+                       sym_name(np), hsts, dbc, sbcl);

        /*
         *  Check that the chip is connected to the SCSI BUS.
