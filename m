From: Scott O'Connor <soconnor@sanblaze.com>
Subject: 2.4 [PATCH REQUEST] for scsi_scan.c (scan_scsis_single)
Date: Thu, 22 Apr 2004 11:28:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422112841.69638e0a@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lvs00-fl-n02.valueweb.net ([216.219.253.98]:8131 "EHLO
	ams002.ftl.affinity.com") by vger.kernel.org with ESMTP
	id S264138AbUDVPcu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 11:32:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I don't know if this has been proposed before, I just joined this mailing list.

I'm seeing a problem with a USB -> IDE device (SMSC USB97c202) with a DVD
R/W drive connected.  The INQUIRY command with a 255 byte request size is
causing the DVD to go out to lunch.  No data is sent back and the SCSI
subsystem is using what ever data is in the inquiry buffer.

I've noticed in Linux 2.6 that the scsi_scan.c stuff has changed the INQUIRY
data request size to 36.  When I make that change in 2.4, everything works
properly with my device.

Normally, it might be best to change the 36 to a #define, but I didn't know how
much change is allowed in a patch.  I also added memset(.., 0, ..) to the
inq buffer.  When the INQUIRY failed before, the device may have worked
depending on what garbage data was in the scsi_device_types[] field.

Any feedback would be welcomed, I would like to get this included in
the next available 2.4 kernel release.  I've never done Linux patching before,
so any help would be greatly appreciated.

Thanks,
-Scott.


--- linux-2.4.26/drivers/scsi/scsi_scan.c       2004-04-14 09:05:31.000000000 -0400
+++ linux-2.4.26-new/drivers/scsi/scsi_scan.c   2004-04-21 12:00:15.000000000 -0400
@@ -350,7 +350,7 @@
        unsigned int lun;
        unsigned int max_dev_lun;
        unsigned char *scsi_result;
-       unsigned char scsi_result0[256];
+       unsigned char scsi_result0[36];
        Scsi_Device *SDpnt;
        Scsi_Device *SDtail;
        unsigned int sparse_lun;
@@ -380,6 +380,8 @@
                printk("Unable to obtain scsi_result buffer\n");
                goto leave;
        }
+       memset(scsi_result, 0, 36);
+
        /*
         * We must chain ourself in the host_queue, so commands can time out
         */
@@ -616,14 +618,14 @@
                scsi_cmd[1] = 0;        /* SCSI_3 and higher, don't touch */
        scsi_cmd[2] = 0;
        scsi_cmd[3] = 0;
-       scsi_cmd[4] = 255;
+       scsi_cmd[4] = 36;
        scsi_cmd[5] = 0;
        SRpnt->sr_cmd_len = 0;
        SRpnt->sr_data_direction = SCSI_DATA_READ;
  
        scsi_wait_req (SRpnt, (void *) scsi_cmd,
                  (void *) scsi_result,
-                 256, SCSI_TIMEOUT+4*HZ, 3);
+                 36, SCSI_TIMEOUT+4*HZ, 3);
  
        SCSI_LOG_SCAN_BUS(3, printk("scsi: INQUIRY %s with code 0x%x\n",
                SRpnt->sr_result ? "failed" : "successful", SRpnt->sr_result));
