From: "Barry K. Nathan" <barryn@pobox.com>
Subject: [PATCH] fix microtek.c compile failure
Date: Tue, 19 Apr 2005 05:53:05 -0700
Message-ID: <20050419125305.GB8541@ip68-4-98-123.oc.oc.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orb.pobox.com ([207.8.226.5]:46212 "EHLO orb.pobox.com")
	by vger.kernel.org with ESMTP id S261493AbVDSMxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 08:53:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is with gcc 3.4.3, against linux-2.6 head
9d469ee9f21c680c41dbffe5b0f36ab5010ca8b1 (the latest as of this
writing):

  CC [M]  drivers/usb/image/microtek.o
drivers/usb/image/microtek.c: In function `mts_scsi_abort':
drivers/usb/image/microtek.c:338: error: `FAILURE' undeclared (first use
in this function)
drivers/usb/image/microtek.c:338: error: (Each undeclared identifier is
reported only once
drivers/usb/image/microtek.c:338: error: for each function it appears in.)
make[3]: *** [drivers/usb/image/microtek.o] Error 1
make[2]: *** [drivers/usb/image] Error 2
make[1]: *** [drivers/usb] Error 2
make: *** [drivers] Error 2

This patch fixes the compile error. I don't have this hardware so I
don't think I can actually run this code, however.

Signed-off-by: Barry K. Nathan <barryn@pobox.com>

--- linux-2.6.12-rc2-9d469ee9f21c680c41dbffe5b0f36ab5010ca8b1/drivers/usb/image/microtek.c	2005-04-19 00:46:14.850813676 -0700
+++ linux-2.6.12-rc2-9d469ee9f21c680c41dbffe5b0f36ab5010ca8b1-bkn1/drivers/usb/image/microtek.c	2005-04-19 05:44:28.084118571 -0700
@@ -335,7 +335,7 @@
 
 	mts_urb_abort(desc);
 
-	return FAILURE;
+	return FAILED;
 }
 
 static int mts_scsi_host_reset (Scsi_Cmnd *srb)
