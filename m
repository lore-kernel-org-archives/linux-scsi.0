From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Fix mesh config
Date: Mon, 12 Aug 2002 16:43:33 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020812015102.CD4DB2C246@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, linux-scsi@vger.kernel.org

(Included in 2.4)
From:  Paul Mackerras <paulus@samba.org>

  We need this small change to drivers/scsi/Config.in.  It only affects
  people using powermacs since the MESH hardware only exists on
  powermacs and clones.
  

--- trivial-2.5.31/drivers/scsi/Config.in.orig	2002-08-12 16:14:34.000000000 +1000
+++ trivial-2.5.31/drivers/scsi/Config.in	2002-08-12 16:14:34.000000000 +1000
@@ -221,10 +221,11 @@
 if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
    dep_tristate 'SCSI debugging host simulator (EXPERIMENTAL)' CONFIG_SCSI_DEBUG $CONFIG_SCSI
 fi
-if [ "$CONFIG_PPC" = "y" ]; then
+if [ "$CONFIG_ALL_PPC" = "y" ]; then
    dep_tristate 'MESH (Power Mac internal SCSI) support' CONFIG_SCSI_MESH $CONFIG_SCSI
    if [ "$CONFIG_SCSI_MESH" != "n" ]; then
       int '  maximum synchronous transfer rate (MB/s) (0 = async)' CONFIG_SCSI_MESH_SYNC_RATE 5
+      int '  initial bus reset delay (ms) (0 = no reset)' CONFIG_SCSI_MESH_RESET_DELAY_MS 4000
    fi
    dep_tristate '53C94 (Power Mac external SCSI) support' CONFIG_SCSI_MAC53C94 $CONFIG_SCSI
 fi
-- 
  Don't blame me: the Monkey is driving
  File: Paul Mackerras <paulus@samba.org>: [PATCH] Fix mesh config
