From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] 53c7xx removal fallout
Date: Wed, 24 Oct 2007 18:26:22 +0200
Message-ID: <20071024162622.GI30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60982 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760072AbXJXQZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 12:25:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch does some additional cleanups after the 53c7xx removal.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/dontdiff                |    2 
 Documentation/m68k/kernel-options.txt |   60 --------------------------
 Documentation/scsi/00-INDEX           |    2 
 Documentation/scsi/ncr53c7xx.txt      |   40 -----------------
 drivers/scsi/.gitignore               |    2 
 5 files changed, 106 deletions(-)

cc96ec601a55800f9a6bce6e208c7ff1e2f618fd 
diff --git a/Documentation/dontdiff b/Documentation/dontdiff
index f2d658a..c09a96b 100644
--- a/Documentation/dontdiff
+++ b/Documentation/dontdiff
@@ -46,8 +46,6 @@
 .mailmap
 .mm
 53c700_d.h
-53c7xx_d.h
-53c7xx_u.h
 53c8xx_d.h*
 BitKeeper
 COPYING
diff --git a/Documentation/m68k/kernel-options.txt b/Documentation/m68k/kernel-options.txt
index 248589e..c93bed6 100644
--- a/Documentation/m68k/kernel-options.txt
+++ b/Documentation/m68k/kernel-options.txt
@@ -867,66 +867,6 @@ controller and should be autodetected by the driver. An example is the
 24 bit region which is specified by a mask of 0x00fffffe.
 
 
-5.5) 53c7xx=
-------------
-
-Syntax: 53c7xx=<sub-options...>
-
-These options affect the A4000T, A4091, WarpEngine, Blizzard 603e+,
-and GForce 040/060 SCSI controllers on the Amiga, as well as the
-builtin MVME 16x SCSI controller.
-
-The <sub-options> is a comma-separated list of the sub-options listed
-below.
-
-5.5.1) nosync
--------------
-
-Syntax: nosync:0
-
-  Disables sync negotiation for all devices.  Any value after the
-  colon is acceptable (and has the same effect).
-
-5.5.2) noasync
---------------
-
-[OBSOLETE, REMOVED]
-
-5.5.3) nodisconnect
--------------------
-
-Syntax: nodisconnect:0
-
-  Disables SCSI disconnects.  Any value after the colon is acceptable
-  (and has the same effect).
-
-5.5.4) validids
----------------
-
-Syntax: validids:0xNN
-
-  Specify which SCSI ids the driver should pay attention to.  This is
-  a bitmask (i.e. to only pay attention to ID#4, you'd use 0x10).
-  Default is 0x7f (devices 0-6).
-
-5.5.5) opthi
-5.5.6) optlo
-------------
-
-Syntax: opthi:M,optlo:N
-
-  Specify options for "hostdata->options".  The acceptable definitions
-  are listed in drivers/scsi/53c7xx.h; the 32 high bits should be in
-  opthi and the 32 low bits in optlo.  They must be specified in the
-  order opthi=M,optlo=N.
-
-5.5.7) next
------------
-
-  No argument. Used to separate blocks of keywords when there's more
-  than one 53c7xx host adapter in the system.
-
-
 /* Local Variables: */
 /* mode: text       */
 /* End:             */
diff --git a/Documentation/scsi/00-INDEX b/Documentation/scsi/00-INDEX
index aa1f7e9..c2e18e1 100644
--- a/Documentation/scsi/00-INDEX
+++ b/Documentation/scsi/00-INDEX
@@ -64,8 +64,6 @@ lpfc.txt
 	- LPFC driver release notes
 megaraid.txt
 	- Common Management Module, shared code handling ioctls for LSI drivers
-ncr53c7xx.txt
-	- info on driver for NCR53c7xx based adapters
 ncr53c8xx.txt
 	- info on driver for NCR53c8xx based adapters
 osst.txt
diff --git a/Documentation/scsi/ncr53c7xx.txt b/Documentation/scsi/ncr53c7xx.txt
deleted file mode 100644
index 91e9552..0000000
--- a/Documentation/scsi/ncr53c7xx.txt
+++ /dev/null
@@ -1,40 +0,0 @@
-README for WarpEngine/A4000T/A4091 SCSI kernels.
-
-Use the following options to disable options in the SCSI driver.
-
-Using amiboot for example.....
-
-To disable Synchronous Negotiation....
-
-	amiboot -k kernel 53c7xx=nosync:0	
-
-To disable Disconnection....
-	
-	amiboot -k kernel 53c7xx=nodisconnect:0
-
-To disable certain SCSI devices...
-
-	amiboot -k kernel 53c7xx=validids:0x3F
-
-	this allows only device ID's 0,1,2,3,4 and 5 for linux to handle.
-	(this is a bitmasked field - i.e. each bit represents a SCSI ID)
-
-These commands work on a per controller basis and use the option 'next' to
-move to the next controller in the system.
-
-e.g.
-	amiboot -k kernel 53c7xx=nodisconnect:0,next,nosync:0
-
-	this uses No Disconnection on the first controller and Asynchronous
-	SCSI on the second controller.
-
-Known Issues:
-
-Two devices are known not to function with the default settings of using
-synchronous SCSI. These are the Archive Viper 150 Tape Drive and the 
-SyQuest SQ555 removeable hard drive. When using these devices on a controller
-use the 'nosync:0' option.
-
-Please try these options and post any problems/successes to me.
-
-Alan Hourihane <alanh@fairlite.demon.co.uk>
diff --git a/drivers/scsi/.gitignore b/drivers/scsi/.gitignore
index b385af3..c89ae9a 100644
--- a/drivers/scsi/.gitignore
+++ b/drivers/scsi/.gitignore
@@ -1,3 +1 @@
 53c700_d.h
-53c7xx_d.h
-53c7xx_u.h

