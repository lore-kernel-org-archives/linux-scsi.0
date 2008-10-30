From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [Bugme-new] [Bug 11898] New: mke2fs hang on AIC79 device.
Date: Thu, 30 Oct 2008 09:05:26 -0500
Message-ID: <1225375526.3250.15.camel@localhost.localdomain>
References: <bug-11898-10286@http.bugzilla.kernel.org/>
	 <20081030015346.ef341e4f.akpm@linux-foundation.org>
	 <F7C8A4D3A9905B45A80E4C194793FA6501C05D627D@PDSMSX501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60268 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172AbYJ3OFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 10:05:30 -0400
In-Reply-To: <F7C8A4D3A9905B45A80E4C194793FA6501C05D627D@PDSMSX501.ccr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shi, Alex" <alex.shi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanming.zhang@intel.com" <yanming.zhang@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>

On Thu, 2008-10-30 at 18:22 +0800, Shi, Alex wrote:
> New panic output is attached after adding softlockup.  New found:
> 1,  "strace mke2fs /dev/sdb1" works well. it just show many write(3, "\377\377...", 4096) =4096 ....
> 2, when system hang, ping this machine is workable. And keyboard input works but cmd has no output.

This doesn't entirely implicate the aic79xx.  The trace shows:

 <IRQ>  [<ffffffff803f99eb>] ? scsi_request_fn+0x31a/0x416
 [<ffffffff803435ad>] ? blk_invoke_request_fn+0x79/0x11d
 [<ffffffff80343b21>] ? __blk_run_queue+0x2a/0x2e
 [<ffffffff803f7def>] ? scsi_run_queue+0x2cd/0x2e4
 [<ffffffff803f8452>] ? scsi_next_command+0x3b/0x4c
 [<ffffffff803f86ef>] ? scsi_end_request+0x97/0xa9
 [<ffffffff803f93b0>] ? scsi_io_completion+0x190/0x3a8
 [<ffffffff803f3a9f>] ? scsi_finish_command+0xb6/0xbf
 [<ffffffff803f96c9>] ? scsi_softirq_done+0x101/0x109
 [<ffffffff803476df>] ? blk_done_softirq+0x68/0x79
 [<ffffffff8023de8c>] ? __do_softirq+0x86/0x14f
 [<ffffffff8020c63c>] ? call_softirq+0x1c/0x28
 [<ffffffff8020dd82>] ? do_softirq+0x39/0x77
 [<ffffffff8023de04>] ? irq_exit+0x44/0x46
 [<ffffffff8020de88>] ? do_IRQ+0xc8/0xe8
 [<ffffffff8020b8f6>] ? ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8021299b>] ? mwait_idle+0x4a/0x4f
 [<ffffffff80209c82>] ? enter_idle+0x27/0x29
 [<ffffffff8020a198>] ? cpu_idle+0x45/0x63
 [<ffffffff804e4d50>] ? start_secondary+0x179/0x17d

So we locked up somehow in the mid-layer trying to feed a new command
from the softirq.  It would greatly help to know what line in scsi_lib.c

scsi_request_fn+0x31a/0x416

The trace implies SCSI is built in, so 

addr2line -e vmlinux -f scsi_request_fn+0x31a

Should tell us (hoping you build with CONFIG_DEBUG_INFO).

James


