From: "Shi, Harris" <Harris.Shi@lsi.com>
Subject: RE: question on block-layer timeout change
Date: Thu, 18 Dec 2008 15:37:22 -0700
Message-ID: <3568BBCB98C00041A9E622952FD5F24EA13BA20B@cosmail03.lsi.com>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com>
 <20081112072919.GB12192@linux.vnet.ibm.com>
 <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com>
 <20081114171823.GA16575@us.ibm.com>
 <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com>
 <4940F367.506@suse.de>
 <3568BBCB98C00041A9E622952FD5F24EA13B99A3@cosmail03.lsi.com>
 <4948AB47.6090505@suse.de>
 <3568BBCB98C00041A9E622952FD5F24EA13B9EB0@cosmail03.lsi.com>
 <20081218092339.GB812@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:36907 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYLRWhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 17:37:41 -0500
In-Reply-To: <20081218092339.GB812@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, "malahal@us.ibm.com" <malahal@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>

Mike, 

Yes. We do have MPP loaded in SLES11RC1. The mpp modules were cut off by the serial windows. It was actually there. 

The NULL session was causing the problem after controller was place offline. Actually it only took bit more than 15s after controller offline to hit the panic.

Thanks.
Harris
-----Original Message-----
From: Mike Anderson [mailto:andmike@linux.vnet.ibm.com] 
Sent: Thursday, December 18, 2008 3:24 AM
To: Shi, Harris
Cc: Hannes Reinecke; malahal@us.ibm.com; SCSI development list; Mike Christie
Subject: Re: question on block-layer timeout change

Shi, Harris <Harris.Shi@lsi.com> wrote:
> Information from /var/log/messages:
> ===================================
> Dec 17 15:58:14 timon kernel: sd 6:0:0:2: [sdd] Sense Key : Recovered Error [current]
> Dec 17 15:58:14 timon kernel: sd 6:0:0:2: [sdd] <<vendor>> ASC=0x95 ASCQ=0x1ASC=0x95 ASCQ=0x1
> Dec 17 15:58:25 timon kernel:  connection2:0: ping timeout of 15 secs expired, last rx 19237, last ping 20487, now 24237
> Dec 17 15:58:25 timon kernel:  connection2:0: detected conn error (1011)
> Dec 17 15:58:26 timon iscsid: Kernel reported iSCSI connection 2:0 error (1011) state (3)
> 
> 
> 
> Information from Serial output:
> ===============================
> Oops: 0002 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
> Modules linked in: radeon drm agpgart crc32c libcrc32c ib_iser rdma_cm ib_cm nfs iw_cm lockd ib_sa ib_mad nfs_acl ib_core i6
> IP: [<c011a274>] __ticket_spin_lock+0x8/0x19
> *pdpt = 00000000319fe001 *pde = 0000000000000000
> BUG: unable to handle kernel NULL pointer dereference at 00000086
> IP: [<c011a274>] __ticket_spin_lock+0x8/0x19
> *pdpt = 0000000000546001 *pde = 0000000000000000
>  ipv6 af_packet microcode fuse loop dm_mod mptctl e1000 iTCO_wdt sr_mod video iTCO_vendor_support e752x_edac output shpchp ]
> 
> Pid: 0, comm: swapper Not tainted (2.6.28-rc8-test-1-pae #1) PowerEdge 2850
> EIP: 0060:[<c011a274>] EFLAGS: 00010086 CPU: 3
> EIP is at __ticket_spin_lock+0x8/0x19
> EAX: 00000086 EBX: f10f6380 ECX: f20b5400 EDX: 00000100
> ESI: f18223b0 EDI: 00000000 EBP: f38a5e78 ESP: f38a5e78
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=f38a4000 task=f38a2fd0 task.ti=f38a4000)
> Stack:
>  f38a5e80 c0328e0f f38a5e98 f9298389 00000002 f10f6380 f18223b0 00000000
>  f38a5ea4 f7e13396 f11b9300 f38a5eb0 c0212539 f11b9300 f38a5ed4 c02125f2
>  f18225b8 00000282 f389c000 f18224f4 00000100 f389c000 c0212573 f38a5f08
> Call Trace:
>  [<c0328e0f>] ? _spin_lock+0x15/0x18
>  [<f9298389>] ? iscsi_eh_cmd_timed_out+0x24/0xb0 [libiscsi]
>  [<f7e13396>] ? scsi_times_out+0x35/0x61 [scsi_mod]
>  [<c0212539>] ? blk_rq_timed_out+0xc/0x46

I could not match my listing exactly with this output, but it appears that
the session is NULL when we call into iscsi_eh_cmd_timed_out. An addr2line
would help verify the iscsi_eh_cmd_timed_out line.

I added Mike C to the email cc for possible comments on the error messages
displayed above and if that would lead to cleanup of structures referenced
in iscsi_eh_cmd_timed_out.

Question on the system setup. Are you using mpp in this kernel as I did not
see it in the module list?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
