From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/2] Fix a hard lockup in scsi_remove_target()
Date: Fri, 30 Oct 2015 15:06:42 -0700
Message-ID: <5633E9F2.5080209@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0053.outbound.protection.outlook.com ([157.56.111.53]:29565
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932926AbbJ3WGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 18:06:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On October 2, 2015 Johannes Thumshirn reported the following hard lockup 
(see also http://thread.gmane.org/gmane.linux.kernel/2052359):

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[...]
Call Trace:
  [<ffffffff8100471d>] dump_trace+0x7d/0x2d0
  [<ffffffff81004a04>] show_stack_log_lvl+0x94/0x170
  [<ffffffff81005cc1>] show_stack+0x21/0x50
  [<ffffffff8151aa75>] dump_stack+0x41/0x51
  [<ffffffff8151545a>] panic+0xc8/0x1d7
  [<ffffffff810fbdda>] watchdog_overflow_callback+0xba/0xc0
  [<ffffffff811336c8>] __perf_event_overflow+0x88/0x240
  [<ffffffff8101e3aa>] intel_pmu_handle_irq+0x1fa/0x3e0
  [<ffffffff81522836>] perf_event_nmi_handler+0x26/0x40
  [<ffffffff81521fcd>] nmi_handle.isra.2+0x8d/0x180
  [<ffffffff815221e6>] do_nmi+0x126/0x3c0
  [<ffffffff8152159b>] end_repeat_nmi+0x1a/0x1e
  [<ffffffffa00212e8>] scsi_remove_target+0x68/0x240 [scsi_mod]
  [<ffffffff81072742>] process_one_work+0x172/0x420
  [<ffffffff810733ba>] worker_thread+0x11a/0x3c0
  [<ffffffff81079d34>] kthread+0xb4/0xc0
  [<ffffffff81528cd8>] ret_from_fork+0x58/0x90

The following two patches fix this lockup:
0001-Separate-target-visibility-from-reaped-state-informa.patch
0002-Restart-list-search-after-unlock-in-scsi_remove_targ.patch

These patches have been tested with the SRP initiator (ib_srp).
