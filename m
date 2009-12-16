From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: ses: enclosure_unregister oops
Date: Wed, 16 Dec 2009 15:44:31 -0700
Message-ID: <4565AEA676113A449269C2F3A549520F04362D9F@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:38944 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935310AbZLPXEf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 18:04:35 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James -  Is there a way to turn of the enclosure services from the SCSI LLD, command line option, or some other method that doesn't require recompiling the kernel?   The oops we are getting occurs on SLES11(2.6.27) when pulling the cable on certain enclosures.   I see this with a HP and Xyratex enclosure.  I don't see it on Engineo enclosures.   On the enclosures where it hangs, there are no slot subfolders under /sys/class/enclosure.

Apparently you have fixed this issue with the patch's that went into 2.6.32, e.g. 

      ses: update enclosure data on hot add
		http://marc.info/?l=linux-scsi&m=124908744713234&w=2
      ses: add support for enclosure component hot removal 
		http://marc.info/?l=linux-scsi&m=124908728913082&w=2
      ses: fix hotplug with multiple devices and expanders
		http://marc.info/?l=linux-scsi&m=124908718512951&w=2

Here is the sg_ses output

(1) Xyratex; FAILS

  XYRATEX   RS1603-SAS-01     0605
    enclosure services device
Supported diagnostic pages:
  Supported diagnostic pages [0x0]
  Configuration (SES) [0x1]
  Enclosure status/control (SES) [0x2]
  String In/Out (SES) [0x4]
  Threshold In/Out (SES) [0x5]
  Element descriptor (SES) [0x7]
  Additional element status (SES-2) [0xa]
  <unknown> [0x80]
  <unknown> [0x81]
  <unknown> [0x84]
  <unknown> [0x85]
  <unknown> [0x88]
  <unknown> [0x89]

(2)  HP: FAILS

  HP        D2700 SAS AJ941A  0038
    enclosure services device
Supported diagnostic pages:
  Supported diagnostic pages [0x0]
  Configuration (SES) [0x1]
  Enclosure status/control (SES) [0x2]
  Threshold In/Out (SES) [0x5]
  Element descriptor (SES) [0x7]
  Additional element status (SES-2) [0xa]
  Supported SES diagnostic pages (SES-2) [0xd]
  <unknown> [0x11]

(3) Engineo: WORKS

  LSI  DE5300-SAS  0216
    enclosure services device
Supported diagnostic pages:
  Supported diagnostic pages [0x0]
  Configuration (SES) [0x1]
  Enclosure status/control (SES) [0x2]
  String In/Out (SES) [0x4]
  Element descriptor (SES) [0x7]
  Additional element status (SES-2) [0xa]


The backtrace below is from enclosure_unregister, seems its deleting a NULL pointer from device_pm_remove.   


BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff803e576b>] device_pm_remove+0x85/0xa0
Dec 16 15:28:51 PGD 1aac11067 PUD 1ad5fa067 PMD 0
Oops: 0002 [1] SMP
last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
dell2900u kernel
Entering kdb (current=0xffff8801acd64440, pid 5559) on processor 1 Oops: <NULL>
due to oops @ 0xffffffff803e576b
     r15 = 0xffff8801ab42a688      r14 = 0x50014380052c3a7e
     r13 = 0x0000000000000000      r12 = 0xffff880197d8c018
      bp = 0x0000000000000000       bx = 0xffff880197d8c278
     r11 = 0xffffffff8033d3f6      r10 = 0x0000000000000000
      r9 = 0xffffffff80a47910       r8 = 0x0000000000000008
      ax = 0x0000000000000000       cx = 0xffff880197d8c420
      dx = 0x0000000000000000       si = 0x0000000000000040
      di = 0xffffffff806f1310  orig_ax = 0xffffffffffffffff
      ip = 0xffffffff803e576b       cs = 0x0000000000000010
   flags = 0x0000000000010246       sp = 0xffff8801ac5a58e0
      ss = 0x0000000000000018 &regs = 0xffff8801ac5a5848
[1]kdb> bt
Stack traceback for pid 5559
0xffff8801acd64440     5559        2  1    1   R  0xffff8801acd64900 *fw_event0
sp                ip                Function (args)
0xffff8801ac5a58c8 0xffffffff803e576b device_pm_remove+0x85 (0xffff880197d8c278)
kdb_bb: address 0x0000000000010246 not recognised
Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
0xffff8801ac5a5878 0xffffffff8033d3f6 disk_release
0xffff8801ac5a58c8 0xffffffff803e576b device_pm_remove+0x85
0xffff8801ac5a58f8 0xffffffff803dff9a device_del+0x13
0xffff8801ac5a5918 0xffffffff803e018a device_unregister+0x56
0xffff8801ac5a5928 0xffffffffa02e9699 [enclosure]enclosure_unregister+0x6d
0xffff8801ac5a5948 0xffffffff803e0025 device_del+0x9e
0xffff8801ac5a5968 0xffffffff803e018a device_unregister+0x56
0xffff8801ac5a5978 0xffffffffa0025b0d [scsi_mod]__scsi_remove_device+0x33
0xffff8801ac5a5998 0xffffffffa0025b7e [scsi_mod]scsi_remove_device+0x20
0xffff8801ac5a59b8 0xffffffffa0025c1b [scsi_mod]__scsi_remove_target+0x85
0xffff8801ac5a59d0 0xffffffffa0025c97 [scsi_mod]__remove_child
0xffff8801ac5a59d8 0xffffffffa0025cad [scsi_mod]__remove_child+0x16
0xffff8801ac5a59e8 0xffffffff803dfb35 device_for_each_child+0x22
0xffff8801ac5a5a38 0xffffffffa0025c8c [scsi_mod]scsi_remove_target+0x3a
0xffff8801ac5a5a58 0xffffffffa004a7d9 [scsi_transport_sas]sas_rphy_remove+0x29
[1]more>
0xffff8801ac5a5a78 0xffffffffa004a809 [scsi_transport_sas]sas_rphy_delete+0x9
0xffff8801ac5a5a88 0xffffffffa004a834 [scsi_transport_sas]sas_port_delete+0x22
0xffff8801ac5a5ac8 0xffffffffa02d1e81 [mpt2sas]mpt2sas_transport_port_remove+0x180
0xffff8801ac5a5ad8 0xffffffffa001b152 [scsi_mod]scsi_device_put+0x2f
0xffff8801ac5a5b28 0xffffffffa02cc521 [mpt2sas]_scsih_remove_device+0x2f0
0xffff8801ac5a5b68 0xffffffffa02c646e [mpt2sas]_config_request+0x51e
0xffff8801ac5a5c98 0xffffffffa02cb315 [mpt2sas]_scsih_sas_host_refresh+0x10c
0xffff8801ac5a5ce8 0xffffffffa02cf4db [mpt2sas]_mpt2sas_fw_work+0xccc
0xffff8801ac5a5da8 0xffffffff8049794e thread_return+0x3d
0xffff8801ac5a5e80 0xffffffffa02d053a [mpt2sas]_firmware_event_work
0xffff8801ac5a5ea8 0xffffffff8024b08d run_workqueue+0x7a
0xffff8801ac5a5ec8 0xffffffff8024b1eb worker_thread+0xd8
0xffff8801ac5a5ee0 0xffffffff8024e52a autoremove_wake_function
0xffff8801ac5a5f10 0xffffffff8024b113 worker_thread
0xffff8801ac5a5f28 0xffffffff8024e201 kthread+0x47
0xffff8801ac5a5f30 0xffffffff8023991f schedule_tail+0x27
0xffff8801ac5a5f48 0xffffffff8020cf49 child_rip+0xa
[1]kdb>
