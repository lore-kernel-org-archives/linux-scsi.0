From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [BUG] Hang (deadlock?) inside iscsi_if_rx
Date: Tue, 24 Jan 2012 10:29:33 -0600
Message-ID: <4F1EDC6D.1060102@cs.wisc.edu>
References: <1327415447.15015.0.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41853 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab2AXQ3p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 11:29:45 -0500
In-Reply-To: <1327415447.15015.0.camel@lappy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sasha Levin <levinsasha928@gmail.com>
Cc: JBottomley@parallels.com, Dave Jones <davej@redhat.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

On 01/24/2012 08:30 AM, Sasha Levin wrote:
> Hi all,
> 
> I got the following hang when running trinity under KVM tool:
> 
> [ 2520.824250] INFO: task trinity:31986 blocked for more than 120 seconds.
> [ 2520.825513] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2520.826983] trinity         D 0000000000000000  5504 31986   2767 0x00000004
> [ 2520.828416]  ffff88000a21ba98 0000000000000086 ffff88000a3f8000 ffff88000a3f8000
> [ 2520.829892]  00000000001d4340 ffff88000a21bfd8 ffff88000a21a000 00000000001d4340
> [ 2520.831380]  00000000001d4340 00000000001d4340 ffff88000a21bfd8 00000000001d4340
> [ 2520.832838] Call Trace:
> [ 2520.837089]  [<ffffffff8265297a>] schedule+0x3a/0x50
> [ 2520.837983]  [<ffffffff82651049>] __mutex_lock_common+0x209/0x5b0
> [ 2520.839181]  [<ffffffff81af64f3>] ? iscsi_if_rx+0x23/0xa00
> [ 2520.840232]  [<ffffffff81053943>] ? sched_clock+0x13/0x20
> [ 2520.841242]  [<ffffffff81af64f3>] ? iscsi_if_rx+0x23/0xa00
> [ 2520.842271]  [<ffffffff82651430>] mutex_lock_nested+0x40/0x50
> [ 2520.843353]  [<ffffffff81af64f3>] iscsi_if_rx+0x23/0xa00
> [ 2520.844461]  [<ffffffff810dfffd>] ? sub_preempt_count+0x9d/0xd0
> [ 2520.845576]  [<ffffffff82654130>] ? _raw_read_unlock+0x30/0x60
> [ 2520.846705]  [<ffffffff8221632e>] netlink_unicast+0x1ae/0x1f0
> [ 2520.847790]  [<ffffffff82216ae7>] netlink_sendmsg+0x227/0x350
> [ 2520.848884]  [<ffffffff821a490d>] ? sock_update_netprioidx+0xdd/0x1b0
> [ 2520.850105]  [<ffffffff821a4882>] ? sock_update_netprioidx+0x52/0x1b0
> [ 2520.851282]  [<ffffffff8219e376>] sock_aio_write+0x166/0x180
> [ 2520.852317]  [<ffffffff810dfe51>] ? get_parent_ip+0x11/0x50
> [ 2520.853342]  [<ffffffff811d0b1a>] do_sync_write+0xda/0x120
> [ 2520.854347]  [<ffffffff81109c42>] ? lock_release_holdtime+0xb2/0x160
> [ 2520.855533]  [<ffffffff810dfe51>] ? get_parent_ip+0x11/0x50
> [ 2520.856569]  [<ffffffff817914e7>] ? security_file_permission+0x27/0xb0
> [ 2520.857756]  [<ffffffff811d0ccc>] vfs_write+0x16c/0x180
> [ 2520.858713]  [<ffffffff811d0dcf>] sys_write+0x4f/0xa0
> [ 2520.859680]  [<ffffffff826553f9>] system_call_fastpath+0x16/0x1b
> [ 2520.873039] 1 lock held by trinity/31986:
> [ 2520.873801]  #0:  (rx_queue_mutex){+.+...}, at: [<ffffffff81af64f3>] iscsi_if_rx+0x23/0xa00
> [ 2520.875587] Kernel panic - not syncing: hung_task: blocked tasks
> 
> From looking at the logs, there were two instances of the fuzzer blocked on a write() to a netlink socket. There are no iSCSI targets anywhere on the network.
> 

What does the trinity test do? Does it write random junk to netlink
sockets to test the kernel handlers or were you actually stressing the
creation of targets. If the latter what driver were you trying to create
targets with (iscsi_tcp, bnx2i, etc)?
