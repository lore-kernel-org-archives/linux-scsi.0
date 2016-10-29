From: TomK <tk@mdevsys.com>
Subject: Re: Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more than
 120 seconds.
Date: Sat, 29 Oct 2016 14:10:45 -0400
Message-ID: <6e764083-f3c9-bd15-640b-2833d8ad544d@mdevsys.com>
References: <0f72bb4a-3cdf-ffd0-db75-5c8b303b921c@mdevsys.com>
 <64ef386e-8de2-0b1c-9322-f02530a3e783@mdevsys.com>
 <0851dba9-ad6c-c419-dc92-93c5d7d2f54a@mdevsys.com>
 <1477291017.19735.26.camel@haakon3.risingtidesystems.com>
 <b12c29d1-64a2-16dd-f38e-b4226e606df2@mdevsys.com>
 <58bfd43f-ff17-f724-9adf-ffd1f828a0e9@mdevsys.com>
 <1477466446.19735.113.camel@haakon3.risingtidesystems.com>
 <e1dc6704-e9f6-bb5c-108d-6f2c44501511@mdevsys.com>
 <b9cbfa95-1e57-eece-4327-e3b51fc46834@mdevsys.com>
 <1477727428.19735.192.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:60951 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbcJ2SLO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 29 Oct 2016 14:11:14 -0400
In-Reply-To: <1477727428.19735.192.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>

On 10/29/2016 3:50 AM, Nicholas A. Bellinger wrote:
> Hi TomK & Co,
>
> On Fri, 2016-10-28 at 02:01 -0400, TomK wrote:
>> On 10/26/2016 8:08 AM, TomK wrote:
>>> On 10/26/2016 3:20 AM, Nicholas A. Bellinger wrote:
>
> <SNIP>
>
>>>>>>
>>>>>> Right now this is a POC setup so I have lots of room to experiment.
>>>>>>
>>>>>
>>>>> Hey Nicholas,
>>>>>
>>>>> I've done some testing up till now.  With or without the patch above, as
>>>>> long as the faulty disk is removed from the RAID 6 software array,
>>>>> everything works fine with the Target Driver and ESXi hosts.
>>>>
>>>> Thanks again for the extra debug + feedback, and confirming the earlier
>>>> hung task warnings with md disk failure.
>>>>
>>>>>   This is
>>>>> even on a degraded array:
>>>>>
>>>>> [root@mbpc-pc ~]# cat /proc/mdstat
>>>>> Personalities : [raid6] [raid5] [raid4]
>>>>> md0 : active raid6 sdc[1] sda[5] sdd[3] sde[8] sdb[7]
>>>>>        3907045632 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/5]
>>>>> [UUUU_U]
>>>>>        bitmap: 6/8 pages [24KB], 65536KB chunk
>>>>>
>>>>> unused devices: <none>
>>>>> [root@mbpc-pc ~]#
>>>>>
>>>>> So at the moment, the data points to the single failed single disk (
>>>>> /dev/sdf ) as causing the Target Drivers or QLogic cards to throw an
>>>>> exception.
>>>>>
>>>>> Tomorrow I will insert the failed disk back in to see if the a) array
>>>>> takes it back, b) it causes a failure with the patch applied.
>>>>>
>>>>> Looks like the failed disk /dev/sdf was limping along for months and
>>>>> until I removed the power, it didn't collapse on itself.
>>>>>
>>>>
>>>> AFAICT, the list corruption observed is a separate bug from the hung
>>>> tasks during ABORT_TASK w/ TMR_COMPLETE_FUNCTION with explicit target
>>>> shutdown.
>>>>
>>>
>>> Correct, I will be including the fix either way but will take some time
>>> to test out if I can reproduce the failure by reinserting this bad disk
>>> then a new disk.  I want to see if this hang will be reproduced by doing
>>> these actions to the RAID6 Software Raid to determine if this failure is
>>> isolated to a particularly bad disk or any sort of add or remove disk
>>> actions in a RAID6.
>>>
>>
>>
>>
>> 1) As soon as I re-add the bad disk without the patch, I loose the LUN
>> off the ESXi hosts.  Same thing happens with the patch.  No change.  The
>> disk is pulling things down.  Worse, the kernel panics and locks me out
>> of the system (http://microdevsys.com/linux-lio/messages-oct-27-2016.txt) :
>>
>
> So after groking these logs, the point when ata6 failing scsi_device is
> holding outstanding I/O beyond ESX FC host side timeouts, manifests
> itself as ABORT_TASK tag=1122276:
>
> Oct 28 00:42:56 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 077e
> Oct 28 00:42:56 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 077f
> Oct 28 00:42:56 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0780
> Oct 28 00:42:57 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e837:20: ABTS_RECV_24XX: instance 0
> Oct 28 00:42:57 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f811:20: qla_target(0): task abort (s_id=1:5:0, tag=1122276, param=0)
> Oct 28 00:42:57 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f80f:20: qla_target(0): task abort (tag=1122276)
> Oct 28 00:42:57 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx task_tag: 1122276
>
> and eventually:
>
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e837:20: ABTS_RECV_24XX: instance 0
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f811:20: qla_target(0): task abort (s_id=1:5:0, tag=1122276, param=0)
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f881:20: unable to find cmd in driver or LIO for tag 0x111fe4
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f854:20: qla_target(0): __qlt_24xx_handle_abts() failed: -2
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff88010f123a40, status=4
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: ABTS_RESP_24XX: compl_status 31
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e807:20: Sending retry TERM EXCH CTIO7 (ha=ffff88010f110000)
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff88010f123a80, status=0
> Oct 28 00:43:18 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: ABTS_RESP_24XX: compl_status 0
>
> The outstanding se_cmd with tag=1122276 for ata6 completes back to
> target-core, allowing ABORT_TASK + TMR_FUNCTION_COMPLETE status to
> progress:
>
> Oct 28 00:44:25 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Oct 28 00:44:29 mbpc-pc kernel: ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> Oct 28 00:44:29 mbpc-pc kernel: ata6.00: configured for UDMA/133
> Oct 28 00:44:29 mbpc-pc kernel: ata6.00: retrying FLUSH 0xea Emask 0x4
> Oct 28 00:44:29 mbpc-pc kernel: ata6.00: device reported invalid CHS sector 0
> Oct 28 00:44:29 mbpc-pc kernel: ata6: EH complete
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM EXCH CTIO (ha=ffff88010f110000)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f814:20: qla_target(0): terminating exchange for aborted cmd=ffff880099392fa8 (se_cmd=ffff880099392fa8, tag=1122276)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM EXCH CTIO (ha=ffff88010f110000)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e851:20: qla_target(0): Terminating cmd ffff880099392fa8 with incorrect state 2
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f81d:20: Intermediate CTIO received (status 6)
> Oct 28 00:44:30 mbpc-pc kernel: ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 1122276
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f81d:20: Intermediate CTIO received (status 8)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f813:20: TM response mcmd (ffff8800b1e2f0f0) status 0x0 state 0x0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff8800b1e2f300, status=0
> Oct 28 00:44:30 mbpc-pc kernel: ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 1122996
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f813:20: TM response mcmd (ffff8800b1e2f340) status 0x2 state 0x0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff8800b1e2f550, status=2
> Oct 28 00:44:30 mbpc-pc kernel: ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 1122204
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f813:20: TM response mcmd (ffff8800b1e2f590) status 0x2 state 0x0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff8800b1e2f7a0, status=2
> Oct 28 00:44:30 mbpc-pc kernel: ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 1122240
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: ABTS_RESP_24XX: compl_status 0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f813:20: TM response mcmd (ffff8800b1e2f7e0) status 0x2 state 0x0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: ABTS_RESP_24XX: compl_status 31
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e807:20: Sending retry TERM EXCH CTIO7 (ha=ffff88010f110000)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff88010f124280, status=0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20: ABTS_RESP_24XX: compl_status 31
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e807:20: Sending retry TERM EXCH CTIO7 (ha=ffff88010f110000)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff88010f1242c0, status=0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending task mgmt ABTS response (ha=ffff88010f110000, atio=ffff8800b1e2f9f0, status=2
>
> and continues with TMR_TASK_DOES_NOT_EXIST for other oustanding tags..
>
> Until, target-core session release for two tcm_qla2xxx host ports:
>
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f884:20: qlt_free_session_done: se_sess ffff880099a80a80 / sess ffff880111665cc0 from port 21:03:00:1b:32:74:b6:cb loop_id 0x03 s_id 01:05:00 logout 1 keep 1 els_logo 0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20: qlt_free_cmd: se_cmd[ffff8800993849f8] ox_id 0773
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f884:20: qlt_free_session_done: se_sess ffff88009e8f9040 / sess ffff8800abe95480 from port 50:01:43:80:16:77:99:38 loop_id 0x02 s_id 01:00:00 logout 1 keep 1 els_logo 0
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20: qlt_free_cmd: se_cmd[ffff880099199f38] ox_id 05f7
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20: qlt_free_cmd: se_cmd[ffff880099199f38] ox_id 05f7
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4801:20: DPC handler waking up, dpc_flags=0x0.
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2870:20: Async-logout - hdl=2 loop-id=3 portid=010500.
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2870:20: Async-logout - hdl=3 loop-id=2 portid=010000.
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4800:20: DPC handler sleeping.
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM EXCH CTIO (ha=ffff88010f110000)
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM EXCH CTIO (ha=ffff88010f110000)
>
> From there, ELS with unexpected NOTIFY_ACK received start to occur:
>
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4801:20: DPC handler waking up, dpc_flags=0x0.
> Oct 28 00:44:30 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4800:20: DPC handler sleeping.
> Oct 28 00:44:34 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
> Oct 28 00:44:34 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e82e:20: IMMED_NOTIFY ATIO
> Oct 28 00:44:34 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:20: qla_target(0): Port ID: 0x00:00:01 ELS opcode: 0x03
> Oct 28 00:44:34 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM ELS CTIO (ha=ffff88010f110000)
> Oct 28 00:44:34 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f897:20: Linking sess ffff8800abe95480 [0] wwn 50:01:43:80:16:77:99:38 with PLOGI ACK to wwn 50:01:43:80:16:77:99:38 s_id 01:00:00, ref=1
> Oct 28 00:44:34 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e862:20: qla_target(0): Unexpected NOTIFY_ACK received
>
> ELS packets for the same two host ports continue:
>
> Oct 28 00:46:40 mbpc-pc kernel: hpet1: lost 9599 rtc interrupts
> Oct 28 00:46:40 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
> Oct 28 00:46:40 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e82e:20: IMMED_NOTIFY ATIO
> Oct 28 00:46:40 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:20: qla_target(0): Port ID: 0x00:00:01 ELS opcode: 0x03
> Oct 28 00:46:40 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM ELS CTIO (ha=ffff88010f110000)
> Oct 28 00:46:40 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f897:20: Linking sess ffff8800abe95480 [0] wwn 50:01:43:80:16:77:99:38 with PLOGI ACK to wwn 50:01:43:80:16:77:99:38 s_id 01:00:00, ref=1
> Oct 28 00:46:40 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e862:20: qla_target(0): Unexpected NOTIFY_ACK received
> Oct 28 00:46:46 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 05b1
> Oct 28 00:46:46 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818:20: is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=1, cmd->dma_data_direction=1 se_cmd[ffff88009a9977d8]
> Oct 28 00:46:46 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20: qlt_free_cmd: se_cmd[ffff88009a9977d8] ox_id 05b1
> Oct 28 00:46:49 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
> Oct 28 00:46:49 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e82e:20: IMMED_NOTIFY ATIO
> Oct 28 00:46:49 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:20: qla_target(0): Port ID: 0x00:05:01 ELS opcode: 0x03
> Oct 28 00:46:49 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending TERM ELS CTIO (ha=ffff88010f110000)
> Oct 28 00:46:49 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f897:20: Linking sess ffff880111665cc0 [0] wwn 21:03:00:1b:32:74:b6:cb with PLOGI ACK to wwn 21:03:00:1b:32:74:b6:cb s_id 01:05:00, ref=1
> Oct 28 00:46:49 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e862:20: qla_target(0): Unexpected NOTIFY_ACK received
>
> And eventually, the 360 second hung task timeout warnings appear:
>
> Oct 28 00:49:48 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
> Oct 28 00:49:55 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 05ba
> Oct 28 00:49:55 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818:20: is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=1, cmd->dma_data_direction=1 se_cmd[ffff88009a988508]
> Oct 28 00:49:55 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20: qlt_free_cmd: se_cmd[ffff88009a988508] ox_id 05ba
> Oct 28 00:50:16 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20: qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 05bb
> Oct 28 00:50:16 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818:20: is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=1, cmd->dma_data_direction=1 se_cmd[ffff88009a988508]
> Oct 28 00:50:16 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20: qlt_free_cmd: se_cmd[ffff88009a988508] ox_id 05bb
> Jan  3 15:34:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon successfully started
> Oct 28 00:50:33 mbpc-pc kernel: INFO: task kworker/0:2:31731 blocked for more than 360 seconds.
> Oct 28 00:50:33 mbpc-pc kernel:      Not tainted 4.8.4 #2
> Oct 28 00:50:33 mbpc-pc kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 28 00:50:33 mbpc-pc kernel: kworker/0:2     D ffff88011affb968     0 31731      2 0x00000080
> Oct 28 00:50:33 mbpc-pc kernel: Workqueue: events qlt_free_session_done [qla2xxx]
> Oct 28 00:50:33 mbpc-pc kernel: ffff88011affb968 ffff88011affb8d8 ffff880013514940 0000000000000006
> Oct 28 00:50:33 mbpc-pc kernel: ffff8801140fe880 ffffffff81f998c2 0000000000000000 ffff880100000000
> Oct 28 00:50:33 mbpc-pc kernel: ffffffff810bdaaa ffffffff00000000 ffffffff00000051 ffff880100000000
> Oct 28 00:50:33 mbpc-pc kernel: Call Trace:
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff810bdaaa>] ? vprintk_emit+0x27a/0x4d0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8115cc5c>] ? printk+0x46/0x48
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162e7ec>] schedule_timeout+0x9c/0xe0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162cfa0>] wait_for_completion+0xc0/0xf0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff810923e0>] ? try_to_wake_up+0x260/0x260
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff81161d73>] ? mempool_free+0x33/0x90
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffffa08f76ad>] target_wait_for_sess_cmds+0x4d/0x1b0 [target_core_mod]
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffffa00e7188>] ? qla2x00_post_work+0x58/0x70 [qla2xxx]
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffffa0286f69>] tcm_qla2xxx_free_session+0x49/0x90 [tcm_qla2xxx]
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffffa01447e9>] qlt_free_session_done+0xf9/0x3d0 [qla2xxx]
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff81080639>] process_one_work+0x189/0x4e0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8107d915>] ? wq_worker_waking_up+0x15/0x70
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8109eb59>] ? idle_balance+0x79/0x290
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8108150d>] worker_thread+0x16d/0x520
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162bb3d>] ? __schedule+0x2fd/0x6a0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff810813a0>] ? maybe_create_worker+0x110/0x110
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff810813a0>] ? maybe_create_worker+0x110/0x110
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8109130e>] ? schedule_tail+0x1e/0xc0
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff8162f60f>] ret_from_fork+0x1f/0x40
> Oct 28 00:50:33 mbpc-pc kernel: [<ffffffff81085f20>] ? kthread_freezable_should_stop+0x70/0x70
>
>>
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f81d:20:
>> Intermediate CTIO received (status 6)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending
>> TERM EXCH CTIO (ha=ffff88010ecb0000)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f814:20:
>> qla_target(0): terminating exchange for aborted cmd=ffff88009af9f488
>> (se_cmd=ffff88009af9f488, tag=1131312)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending
>> TERM EXCH CTIO (ha=ffff88010ecb0000)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e851:20:
>> qla_target(0): Terminating cmd ffff88009af9f488 with incorrect state 2
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending
>> TERM EXCH CTIO (ha=ffff88010ecb0000)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f81d:20:
>> Intermediate CTIO received (status 6)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f81d:20:
>> Intermediate CTIO received (status 8)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e81c:20: Sending
>> TERM EXCH CTIO (ha=ffff88010ecb0000)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f81d:20:
>> Intermediate CTIO received (status 6)
>> Oct 28 01:19:59 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:20:
>> qlt_free_cmd: se_cmd[ffff88009af9f488] ox_id 0673
>> Oct 28 01:19:59 mbpc-pc kernel: ------------[ cut here ]------------
>> Oct 28 01:19:59 mbpc-pc kernel: kernel BUG at
>> drivers/scsi/qla2xxx/qla_target.c:3319!
>> Oct 28 01:19:59 mbpc-pc kernel: invalid opcode: 0000 [#1] SMP
>> Oct 28 01:19:59 mbpc-pc kernel: Modules linked in: tcm_qla2xxx tcm_fc
>> tcm_loop target_core_file target_core_iblock target_core_pscsi
>> target_core_mod configfs ip6table_filter ip6_tables ebtable_nat ebtables
>> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM
>> iptable_mangle bridge nfsd lockd grace nfs_acl auth_rpcgss autofs4 it87
>> hwmon_vid bnx2fc cnic uio fcoe libfcoe libfc 8021q garp stp llc ppdev
>> parport_pc parport sunrpc cpufreq_ondemand bonding ipv6 crc_ccitt
>> ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables fuse
>> vfat fat xfs vhost_net macvtap macvlan vhost tun uinput raid456
>> async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq
>> libcrc32c joydev sg serio_raw e1000 r8169 mii kvm_amd kvm
>> snd_hda_codec_realtek snd_hda_codec_generic irqbypass pcspkr k10temp
>> snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_seq
>> snd_seq_device snd_pcm snd_timer snd soundcore i2c_piix4 i2c_core wmi
>> shpchp acpi_cpufreq ext4 mbcache jbd2 qla2xxx scsi_transport_fc floppy
>> firewire_ohci f
>> Oct 28 01:19:59 mbpc-pc kernel: irewire_core crc_itu_t sd_mod pata_acpi
>> ata_generic pata_jmicron ahci libahci usb_storage dm_mirror
>> dm_region_hash dm_log dm_mod
>> Oct 28 01:19:59 mbpc-pc kernel: CPU: 0 PID: 296 Comm: kworker/u16:6 Not
>> tainted 4.8.4 #2
>> Oct 28 01:19:59 mbpc-pc kernel: Hardware name: Gigabyte Technology Co.,
>> Ltd. GA-890XA-UD3/GA-890XA-UD3, BIOS FC 08/02/2010
>> Oct 28 01:19:59 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
>> [target_core_mod]
>> Oct 28 01:19:59 mbpc-pc kernel: task: ffff8801109623c0 task.stack:
>> ffff880110968000
>> Oct 28 01:19:59 mbpc-pc kernel: RIP: 0010:[<ffffffffa0143810>]
>> [<ffffffffa0143810>] qlt_free_cmd+0x160/0x180 [qla2xxx]
>> Oct 28 01:19:59 mbpc-pc kernel: RSP: 0018:ffff88011096bb18  EFLAGS: 00010202
>> Oct 28 01:19:59 mbpc-pc kernel: RAX: 0000000000000051 RBX:
>> ffff88009af9f488 RCX: 0000000000000006
>> Oct 28 01:19:59 mbpc-pc kernel: RDX: 0000000000000007 RSI:
>> 0000000000000007 RDI: ffff88011fc0cb40
>> Oct 28 01:19:59 mbpc-pc kernel: RBP: ffff88011096bb48 R08:
>> 0000000000000000 R09: ffffffff81fa4765
>> Oct 28 01:19:59 mbpc-pc kernel: R10: 0000000000000074 R11:
>> 0000000000000002 R12: ffff8801137770c0
>> Oct 28 01:19:59 mbpc-pc kernel: R13: ffff8800a126eaf0 R14:
>> ffff88009af9f510 R15: 0000000000000296
>> Oct 28 01:19:59 mbpc-pc kernel: FS:  0000000000000000(0000)
>> GS:ffff88011fc00000(0000) knlGS:0000000000000000
>> Oct 28 01:19:59 mbpc-pc kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> Oct 28 01:19:59 mbpc-pc kernel: CR2: 00007f8eef58d000 CR3:
>> 00000000cabad000 CR4: 00000000000006f0
>> Oct 28 01:19:59 mbpc-pc kernel: Stack:
>> Oct 28 01:19:59 mbpc-pc kernel: ffff880000000673 ffff88009af9f488
>> ffff8800a126eaf0 ffff88009af9f59c
>> Oct 28 01:19:59 mbpc-pc kernel: ffff88009af9f488 ffff8800a126eaf0
>> ffff88011096bb58 ffffffffa027f7f4
>> Oct 28 01:19:59 mbpc-pc kernel: ffff88011096bbb8 ffffffffa08f758c
>> ffff88009af9f510 ffff88009af9f488
>> Oct 28 01:19:59 mbpc-pc kernel: Call Trace:
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffffa027f7f4>]
>> tcm_qla2xxx_release_cmd+0x14/0x30 [tcm_qla2xxx]
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffffa08f758c>]
>> target_release_cmd_kref+0xac/0x110 [target_core_mod]
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffffa08f7627>]
>> target_put_sess_cmd+0x37/0x70 [target_core_mod]
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffffa08f46f7>]
>> core_tmr_abort_task+0x107/0x160 [target_core_mod]
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffffa08f6aa4>]
>> target_tmr_work+0x154/0x160 [target_core_mod]
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff81080639>]
>> process_one_work+0x189/0x4e0
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff810d060c>] ?
>> del_timer_sync+0x4c/0x60
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff8108131e>] ?
>> maybe_create_worker+0x8e/0x110
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff8108150d>]
>> worker_thread+0x16d/0x520
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff810923f2>] ?
>> default_wake_function+0x12/0x20
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff810a6f06>] ?
>> __wake_up_common+0x56/0x90
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff810813a0>] ?
>> maybe_create_worker+0x110/0x110
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff810813a0>] ?
>> maybe_create_worker+0x110/0x110
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff8109130e>] ?
>> schedule_tail+0x1e/0xc0
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff8162f60f>] ret_from_fork+0x1f/0x40
>> Oct 28 01:19:59 mbpc-pc kernel: [<ffffffff81085f20>] ?
>> kthread_freezable_should_stop+0x70/0x70
>> Oct 28 01:19:59 mbpc-pc kernel: Code: 0d 00 00 48 c7 c7 00 2a 16 a0 e8
>> ac 32 f2 e0 48 83 c4 18 5b 41 5c 41 5d c9 c3 48 8b bb 90 02 00 00 e8 85
>> da 07 e1 e9 30 ff ff ff <0f> 0b eb fe 0f 0b 66 2e 0f 1f 84 00 00 00 00
>> 00 eb f4 66 66 66
>> Oct 28 01:19:59 mbpc-pc kernel: RIP  [<ffffffffa0143810>]
>> qlt_free_cmd+0x160/0x180 [qla2xxx]
>> Oct 28 01:19:59 mbpc-pc kernel: RSP <ffff88011096bb18>
>> Oct 28 01:19:59 mbpc-pc kernel: ---[ end trace 2551bf47a19dbe2e ]---
>>
>
> Mmm.
>
> This BUG_ON is signaling a qla_tgt_cmd descriptor is being freed while
> qlt_handle_cmd_for_atio() has queued it for backend execution, but
> qla_tgt_cmd->work -> __qlt_do_work() has not executed.
>
>>
>>
>> 2) This works with a new disk that's just been inserted.  No issues.
>>
>>
>
> Thanks for verifying this scenario.
>
>>
>>
>> The kernel had the patch in both scenarios.  So appears we can't
>> function on a degraded array that looses 1 (RAID 5 / 6 ) or 2 ( RAID 6 )
>> disks, at the moment, even though the array itself is fine.  Perhaps
>> it's the nature of the failed disk.
>>
>
> AFAICT, the hung task involves ABORT_TASK across tcm_qla2xxx session
> reinstatement, when backend I/O latency is high enough to cause
> ABORT_TASK operations across FC fabric host side session reset.
>
> From logs alone, it's unclear if the failing backend ata6 is leaking I/O
> (indefinitely) when hung task warning happen, but the preceding ata6
> failures + device resets seem to indicate I/O completions are just
> taking a really long time to complete.
>
> Also, it's unclear if the BUG_ON(cmd->cmd_in_wq) in qlt_free_cmd() is a
> side effect of the earlier hung task, or separate tcm_qla2xxx session
> reinstatement bug.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Thanks Nicholas.

Is it possible the RAID 6 array, after attempting to write sectors to a 
bad disk, received an error and returned a status message that the QLA 
could not interpret?  Thereby sending the QLA into a routine expecting a 
recognized message and simply timing out?  All the while the array 
simply 'moved on' along it's merry way.   (For example, a message akin 
to "Unexpected xyz received, ignoring" type of message that should be 
interpreted and actioned on.)  Or perhaps the software RAID 6 isn't 
returning anything meaningful to the QLA driver.  (If it isn't though, 
it can be argued that the QLA / Target Drivers shouldn't have to care if 
the array is working.)

The 100% util on /dev/sdf lasted for less then 30 seconds. Well below 
the 120s default timeout (I've upped this to 360 for the purpose of 
testing this scenario)

I do see these:

http://microdevsys.com/linux-lio/messages-mailing-list
Oct 23 19:50:26 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5811:20: 
Asynchronous PORT UPDATE ignored 0000/0004/0600.

but I don't think it's that one as it doesn't correlate well at all.

If there's another test that I can do to get more info, please feel free 
to suggest.

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.

