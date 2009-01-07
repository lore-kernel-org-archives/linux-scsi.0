From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: question on block-layer timeout change
Date: Wed, 07 Jan 2009 14:46:23 -0600
Message-ID: <4965149F.7010808@cs.wisc.edu>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com> <20081112072919.GB12192@linux.vnet.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com> <20081114171823.GA16575@us.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com> <4940F367.506@suse.de> <3568BBCB98C00041A9E622952FD5F24EA13B99A3@cosmail03.lsi.com> <4948AB47.6090505@suse.de> <3568BBCB98C00041A9E622952FD5F24EA13B9EB0@cosmail03.lsi.com> <20081218092339.GB812@linux.vnet.ibm.com> <4960EDE0.70007@cs.wisc.edu> <3568BBCB98C00041A9E622952FD5F24EA14A0697@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57644 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZAGUqi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2009 15:46:38 -0500
In-Reply-To: <3568BBCB98C00041A9E622952FD5F24EA14A0697@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shi, Harris" <Harris.Shi@lsi.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "malahal@us.ibm.com" <malahal@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Shi, Harris wrote:
> What we did is to sysReboot one controller while I/O is up and running, we expected to have controller failover and did not explicitly run iscsiadm to logout the session in this case. Yes. We got the oop after conn error message. If controller reboot resulted in session gone, that might explain we had a kernel panic. However, MPP has been running on iscsi array for quite a while on SLES10/REHL distribution, it's the first time we got hit by this kernel panic. That's why we had a some concerns on iscsi stack. 
> 

The failover should not have resulted in the session getting destroyed. 
It might depend on what is in SLES though. In older tools if the chap 
values changed (we logged in with one user/pass and the target no wants 
diff values) or for some errors the initiator thought was fatal. For 
this though you should have seen a error in logs indicating that we got 
a fatal login error.

What does the portal return when you were rebooting it if the initiator 
tries to log in? Look at the open-iscsi userspace tools in SLES. Is your 
target returning a error values that 
initiator.c:__check_iscsi_status_class() would destroy the session for? 
Is it now changed upstream?

> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Sunday, January 04, 2009 11:12 AM
> To: Mike Anderson
> Cc: Shi, Harris; Hannes Reinecke; malahal@us.ibm.com; SCSI development list
> Subject: Re: question on block-layer timeout change
> 
> Mike Anderson wrote:
>> Shi, Harris <Harris.Shi@lsi.com> wrote:
>>> Information from /var/log/messages:
>>> ===================================
>>> Dec 17 15:58:14 timon kernel: sd 6:0:0:2: [sdd] Sense Key : Recovered Error [current]
>>> Dec 17 15:58:14 timon kernel: sd 6:0:0:2: [sdd] <<vendor>> ASC=0x95 ASCQ=0x1ASC=0x95 ASCQ=0x1
>>> Dec 17 15:58:25 timon kernel:  connection2:0: ping timeout of 15 secs expired, last rx 19237, last ping 20487, now 24237
>>> Dec 17 15:58:25 timon kernel:  connection2:0: detected conn error (1011)
>>> Dec 17 15:58:26 timon iscsid: Kernel reported iSCSI connection 2:0 error (1011) state (3)
>>>
>>>
>>>
>>> Information from Serial output:
>>> ===============================
>>> Oops: 0002 [#1] SMP
>>> last sysfs file: /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
>>> Modules linked in: radeon drm agpgart crc32c libcrc32c ib_iser rdma_cm ib_cm nfs iw_cm lockd ib_sa ib_mad nfs_acl ib_core i6
>>> IP: [<c011a274>] __ticket_spin_lock+0x8/0x19
>>> *pdpt = 00000000319fe001 *pde = 0000000000000000
>>> BUG: unable to handle kernel NULL pointer dereference at 00000086
>>> IP: [<c011a274>] __ticket_spin_lock+0x8/0x19
>>> *pdpt = 0000000000546001 *pde = 0000000000000000
>>>  ipv6 af_packet microcode fuse loop dm_mod mptctl e1000 iTCO_wdt sr_mod video iTCO_vendor_support e752x_edac output shpchp ]
>>>
>>> Pid: 0, comm: swapper Not tainted (2.6.28-rc8-test-1-pae #1) PowerEdge 2850
>>> EIP: 0060:[<c011a274>] EFLAGS: 00010086 CPU: 3
>>> EIP is at __ticket_spin_lock+0x8/0x19
>>> EAX: 00000086 EBX: f10f6380 ECX: f20b5400 EDX: 00000100
>>> ESI: f18223b0 EDI: 00000000 EBP: f38a5e78 ESP: f38a5e78
>>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>>> Process swapper (pid: 0, ti=f38a4000 task=f38a2fd0 task.ti=f38a4000)
>>> Stack:
>>>  f38a5e80 c0328e0f f38a5e98 f9298389 00000002 f10f6380 f18223b0 00000000
>>>  f38a5ea4 f7e13396 f11b9300 f38a5eb0 c0212539 f11b9300 f38a5ed4 c02125f2
>>>  f18225b8 00000282 f389c000 f18224f4 00000100 f389c000 c0212573 f38a5f08
>>> Call Trace:
>>>  [<c0328e0f>] ? _spin_lock+0x15/0x18
>>>  [<f9298389>] ? iscsi_eh_cmd_timed_out+0x24/0xb0 [libiscsi]
>>>  [<f7e13396>] ? scsi_times_out+0x35/0x61 [scsi_mod]
>>>  [<c0212539>] ? blk_rq_timed_out+0xc/0x46
>> I could not match my listing exactly with this output, but it appears that
>> the session is NULL when we call into iscsi_eh_cmd_timed_out. An addr2line
>> would help verify the iscsi_eh_cmd_timed_out line.
>>
>> I added Mike C to the email cc for possible comments on the error messages
>> displayed above and if that would lead to cleanup of structures referenced
>> in iscsi_eh_cmd_timed_out.
>>
> 
> Sorry for the late reply. I have been on vacation.
> 
> The iscsi error message just indicates that the initiator tried to send 
> a iscsi ping and it did not get a response, so the initiator dropped the 
> session. The error was reported as a generic connection error (1011) and 
> when the error was fired the initiator was in the logged in / full 
> feature phase (this basically means normal old use and nothing special).
> 
> Due to the sles use and MPP driver, I am not sure what exactly is 
> running, but for this code path the iscsi driver does this:
> 
>          cls_session = starget_to_session(scsi_target(scmd->device));
>          session = cls_session->dd_data;
> 
> to get the session in iscsi_eh_cmd_timed_out (we do this in all kernels 
> do that has not changed).
> 
> The session pointers are only changed when a session is destroyed, and 
> that only happens if you do a logout of the session (iscsiadm -m .... 
> -u), and at that time when the session is destroyed we should have 
> flushed all IO.
> 
> Are you guys doing a logout of the session with iscsiadm at this time?
> 
> Does MPP clone commands and is it doing something with the command's 
> pointers to the device?
> 
> Another possibilty is that commands are not getting cleaned up 
> correctly. When you see this "connection2:0: detected conn error 
> (1011)", the driver is going to kill all outstadnding commands and and 
> call scsi_done on them to requeue them with the scsi layer, so we should 
> be getting any commands timed out after you see that message (maybe only 
> in some race case where the session's commands are getting flushed at 
> the exact same time the scsi eh was firing). There was no time stamp on 
> the oops output but I doubt this happened. Did the oops happen after the 
> conn error message though?

