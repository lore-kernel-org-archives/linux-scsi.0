From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: [patch] 2.4.23-pre8: link error with both megaraid drivers
Date: Thu, 23 Oct 2003 17:27:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F97F35D.30101@wanadoo.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070706090603000102060209"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070706090603000102060209
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Adrian Bunk wrote:

> The patch below fixes this issue by disalllowing the static inclusion of
> both drivers at the same time.

IMO this patch makes a better job. It only allows one in kernel,
and it allows two modules at same time.

xconfig and menuconfig work ok.

-thanks-
--
HTML mails are going to trash automatically

--------------070706090603000102060209
Content-Type: text/plain;
 name="config-megaraid.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="config-megaraid.diff"

--- linux/drivers/scsi/Config.in	2003-10-23 16:56:13.000000000 +0200
+++ new/drivers/scsi/Config.in	2003-10-23 17:00:51.000000000 +0200
@@ -66,8 +66,14 @@
 dep_tristate 'AdvanSys SCSI support' CONFIG_SCSI_ADVANSYS $CONFIG_SCSI
 dep_tristate 'Always IN2000 SCSI support' CONFIG_SCSI_IN2000 $CONFIG_SCSI
 dep_tristate 'AM53/79C974 PCI SCSI support' CONFIG_SCSI_AM53C974 $CONFIG_SCSI $CONFIG_PCI
-dep_tristate 'AMI MegaRAID support' CONFIG_SCSI_MEGARAID $CONFIG_SCSI
-dep_tristate 'AMI MegaRAID2 support' CONFIG_SCSI_MEGARAID2 $CONFIG_SCSI
+
+if [ "$CONFIG_SCSI_MEGARAID2" != "y" ]; then
+	dep_tristate 'AMI MegaRAID support' CONFIG_SCSI_MEGARAID $CONFIG_SCSI
+fi
+
+if [ "$CONFIG_SCSI_MEGARAID" != "y" ]; then
+	dep_tristate 'AMI MegaRAID2 support' CONFIG_SCSI_MEGARAID2 $CONFIG_SCSI
+fi
 
 dep_tristate 'BusLogic SCSI support' CONFIG_SCSI_BUSLOGIC $CONFIG_SCSI
 if [ "$CONFIG_SCSI_BUSLOGIC" != "n" ]; then


--------------070706090603000102060209--
