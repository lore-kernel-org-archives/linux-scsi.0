From: Boaz Harrosh <bharrosh@panasas.com>
Subject: gdth new set of patches for 2.6.24 stable
Date: Thu, 14 Feb 2008 20:47:10 +0200
Message-ID: <47B48CAE.2020705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10101 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754646AbYBNSsk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 13:48:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

Submitted are a new set of patches, that fix lots of problems
with the gdth driver.

It fixes the following problems:
- scan for drives on hosts. (Already in mainline)
- truly fixes the exit/reboot problems but does call flush() before
  reboot.
- fix crash when accessing array with icpcon management application.
- fix crash when doing $ cat /proc/sys/gdth/0.
  This one still has the below WARN_ON in messages (see <gdth_info> below)
  So there is one more thing hiding in there.
- use pci_get_device
  One of the testers requested if we can also put the move to pci_get_device 
  patch with removal of dependency on PCI_LEGACY, to the stable release.

The patches are for and based on Linux-2.6.24. here is the list of patches:
  [PATCH 1/5] gdth: update deprecated pci_find_device
  [PATCH 2/5] gdth: scan for scsi devices
  [PATCH 3/5] gdth: bugfix for the at-exit problems
  [PATCH 4/5] gdth: fix to internal commands execution
  [PATCH 5/5] gdth: remove gdth cooked up command accessors

Please all test and report your findings.

Thanks in advance
Boaz

---
<gdth_info>
  WARNING: at arch/x86/kernel/pci-dma_32.c:66 dma_free_coherent()
  Pid: 5501, comm: cat Not tainted 2.6.24 #43
   [<c0107137>] dma_free_coherent+0x93/0x95
   [<c025ef73>] gdth_ioctl_free+0x4c/0x69
   [<c0264a36>] gdth_proc_info+0x165f/0x182c
   [<c0111f7a>] update_curr+0xeb/0xf2
   [<c01132aa>] task_rq_lock+0x29/0x50
   [<c0113706>] try_to_wake_up+0x42/0x342
   [<c0113706>] try_to_wake_up+0x42/0x342
   [<c0111a9f>] __wake_up_common+0x46/0x6d
   [<c0113569>] __wake_up+0x32/0x42
   [<c022dad9>] n_tty_receive_buf+0x2e8/0xe97
   [<c022dad9>] n_tty_receive_buf+0x2e8/0xe97
   [<c0111f0a>] update_curr+0x7b/0xf2
   [<c0112625>] enqueue_task_fair+0x27/0x30
   [<c0111783>] enqueue_task+0xa/0x14
   [<c025e351>] proc_scsi_read+0x29/0x3d
   [<c025e328>] proc_scsi_read+0x0/0x3d
   [<c0189704>] proc_file_read+0x1c6/0x279
   [<c018953e>] proc_file_read+0x0/0x279
   [<c0185eca>] proc_reg_read+0x53/0x71
   [<c0185e77>] proc_reg_read+0x0/0x71
   [<c0159968>] vfs_read+0x85/0x11b
   [<c0159d9d>] sys_read+0x41/0x6a
   [<c0102822>] sysenter_past_esp+0x5f/0x85
 </gdth_info>
