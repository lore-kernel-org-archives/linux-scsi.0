From: Saeed Bishara <Saeed.Bishara@il.marvell.com>
Subject: kernel crash when unloading host with offline device
Date: Wed, 01 Sep 2004 22:36:05 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413624A5.7070501@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shosh.galileo.co.il ([199.203.130.250]:10889 "EHLO
	il.marvell.com") by vger.kernel.org with ESMTP id S267423AbUIATgP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:36:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dougg@torque.net>

Hi,
    I got this crash when trying to unload my scsi driver that has been 
experienced errors that made the scsi error handler to put the device in 
offline mode.
    The problem occurred when reading from the device with sg_dd , but 
didn't happen with dd.
    I succeeded to generate the crash using the scsi_debug with a little 
change that makes it behave like my device, the change it simply to 
timeout all the commands after
    processing 30 commands, this will cause the device to set in offline 
mode.
    here are the system information, my patch to the scsi_debug, the 
system log on crash, and the commands I run.


      system info:

kernel 2.6.9-rc1
sg_utils_1.08
scsi_debug 1.73 (comes with the mentioned kernel) + my patch


      scsi_debug.c patch:

--- /usr/src/linux-2.6.9-rc1/drivers/scsi/scsi_debug.c    2004-08-14 
08:37:15.000000000 +0300
+++ ./scsi_debug.c    2004-09-01 21:20:39.000000000 +0300
@@ -79,9 +79,9 @@
  */
 #define DEF_DELAY   1
 #define DEF_DEV_SIZE_MB   8
-#define DEF_EVERY_NTH   0
+#define DEF_EVERY_NTH   30
 #define DEF_NUM_PARTS   0
-#define DEF_OPTS   0
+#define DEF_OPTS   7
 #define DEF_SCSI_LEVEL   3
 #define DEF_PTYPE   0
 
@@ -323,7 +323,7 @@
 
         if ((scsi_debug_every_nth > 0) &&
             (++scsi_debug_cmnd_count >= scsi_debug_every_nth)) {
-                scsi_debug_cmnd_count =0;
+              //  scsi_debug_cmnd_count =0; /*timeout forever!!!*/
         if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
             return 0; /* ignore command causing timeout */
         else if (SCSI_DEBUG_OPT_RECOVERED_ERR & scsi_debug_opts)


      crash log:

Sep  1 21:57:34 localhost kernel: scsi_debug: cmd 28 00 00 00 07 00 00 
00 80 00
Sep  1 21:57:34 localhost kernel: scsi_debug: cmd 28 00 00 00 07 80 00 
00 80 00
Sep  1 21:57:34 localhost kernel: scsi_debug: cmd 28 00 00 00 08 00 00 
00 80 00
Sep  1 21:57:34 localhost kernel: scsi_debug: cmd 28 00 00 00 08 80 00 
00 80 00
Sep  1 21:58:34 localhost kernel: scsi_debug: abort
Sep  1 21:59:04 localhost last message repeated 5 times
Sep  1 21:59:04 localhost kernel: scsi_debug: device_reset
Sep  1 21:59:14 localhost kernel: scsi_debug: abort
Sep  1 21:59:14 localhost kernel: scsi_debug: bus_reset
Sep  1 21:59:34 localhost kernel: scsi_debug: abort
Sep  1 21:59:54 localhost last message repeated 2 times
Sep  1 21:59:54 localhost kernel: scsi_debug: host_reset
Sep  1 22:00:14 localhost kernel: scsi_debug: abort
Sep  1 22:00:34 localhost last message repeated 2 times
Sep  1 22:00:34 localhost kernel: scsi: Device offlined - not ready 
after error recovery: host 0 channel 0 id 0 lun 0
Sep  1 22:00:34 localhost last message repeated 2 times
Sep  1 22:00:34 localhost kernel: scsi0 (0:0): rejecting I/O to offline 
device
Sep  1 22:00:34 localhost last message repeated 4 times
Sep  1 22:02:11 localhost kernel: Synchronizing SCSI cache for disk sda:
Sep  1 22:02:11 localhost kernel: FAILED
Sep  1 22:02:11 localhost kernel:   status = 0, message = 00, host = 1, 
driver = 00
Sep  1 22:02:11 localhost kernel:   <6>scsi_debug: slave_destroy <0 0 0 0>
Sep  1 22:02:11 localhost kernel: slab error in kmem_cache_destroy(): 
cache `scsi_cmd_cache': Can't free all objects
Sep  1 22:02:11 localhost kernel:  [<c0106ccf>] dump_stack+0x1e/0x22
Sep  1 22:02:11 localhost kernel:  [<c0154b30>] 
kmem_cache_destroy+0xa4/0x12a
Sep  1 22:02:11 localhost kernel:  [<e0a1e9f3>] 
scsi_destroy_command_freelist+0x70/0xa1 [scsi_mod]
Sep  1 22:02:11 localhost kernel:  [<e0a2003b>] 
scsi_host_dev_release+0x38/0xec [scsi_mod]
Sep  1 22:02:11 localhost kernel:  [<c0253bb1>] device_release+0x5a/0x5e
Sep  1 22:02:11 localhost kernel:  [<c01f3bcf>] kobject_cleanup+0x8d/0x8f
Sep  1 22:02:11 localhost kernel:  [<e08b22db>] 
sdebug_driver_remove+0x66/0x8b [scsi_debug]
Sep  1 22:02:11 localhost kernel:  [<c0254de2>] 
device_release_driver+0x62/0x64
Sep  1 22:02:11 localhost kernel:  [<c0255038>] bus_remove_device+0x7e/0xbf
Sep  1 22:02:11 localhost kernel:  [<c0253f1f>] device_del+0x6e/0xa3 
Sep  1 22:02:11 localhost kernel:  [<c0253f68>] device_unregister+0x14/0x22
Sep  1 22:02:11 localhost kernel:  [<e08b2114>] 
sdebug_remove_adapter+0xf1/0x18b [scsi_debug]
Sep  1 22:02:11 localhost kernel:  [<e08b2520>] 
scsi_debug_exit+0x5a/0x61 [scsi_debug]
Sep  1 22:02:11 localhost kernel:  [<c0140a59>] 
sys_delete_module+0x138/0x187
Sep  1 22:02:11 localhost kernel:  [<c0106749>] sysenter_past_esp+0x52/0x71
Sep  1 22:02:11 localhost kernel: scsi_debug: pseudo_0_release() called


      my commands history


    1022  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1023  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1024  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1025  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1026  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1027  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1028  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1029  sg_dd if=/dev/sg0 of=/dev/null bs=512 &
 1030  jobs

  insmod ./scsi_debug.ko
..
 1057  cat /sys/bus/scsi/devices/0\:0\:0\:0/state            /*at this 
point the device was offline*/
 1058  lsmod                                                              
 1059  rmmod sg            /*failed, sg used by zombie sg_dd*/
 1060  jobs
 1061  killall sg_dd           
 1062  jobs
 1063  rmmod sg
 1064  lsmod
 1065  rmmod scsi_debug         /*bummmmm*/



saeed

