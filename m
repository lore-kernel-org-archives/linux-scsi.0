From: TomK <tk@mdevsys.com>
Subject: Re: CONFIG_TCM_QLA2... no longer in Kernel 4.8.4 as an option.
Date: Sun, 23 Oct 2016 12:30:46 -0400
Message-ID: <99872815-5168-6af9-4c7c-1a4bace74a07@mdevsys.com>
References: <68ab9181-1db9-1111-98d4-ab67387180cb@mdevsys.com>
 <fa97b53d-36c3-f94c-e3df-113d9b035647@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:54531 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752171AbcJWQa4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Oct 2016 12:30:56 -0400
In-Reply-To: <fa97b53d-36c3-f94c-e3df-113d9b035647@mdevsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "tomkcpr@microdevsys.com" <tomkcpr@microdevsys.com>

What's prompting me to upgrade the kernel is these messages from the 
4.1.20 kernel (Seems this was fixed in a later kernel release):

Oct 20 11:03:44 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx 
task_tag: 1162632
Oct 20 11:03:44 mbpc-pc kernel: ABORT_TASK: Sending 
TMR_TASK_DOES_NOT_EXIST for ref_tag: 1162632
Oct 20 11:03:44 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx 
task_tag: 1162668
Oct 20 11:03:44 mbpc-pc kernel: ABORT_TASK: Sending 
TMR_TASK_DOES_NOT_EXIST for ref_tag: 1162668
Oct 20 11:03:57 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx 
task_tag: 1163928
Jan  3 13:26:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon 
successfully started
Oct 20 11:05:11 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Oct 20 11:05:32 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Oct 20 11:05:53 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Jan  3 13:28:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon 
successfully started
Oct 20 11:06:14 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Oct 20 11:06:35 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Oct 20 11:06:56 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Oct 20 11:07:17 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f094:21: sess 
ffff8800048f5340 received double plogi.
Oct 20 11:07:34 mbpc-pc kernel: INFO: task kworker/u16:1:572 blocked for 
more than 120 seconds.
Oct 20 11:07:34 mbpc-pc kernel:      Not tainted 4.1.20 #2
Oct 20 11:07:34 mbpc-pc kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 20 11:07:34 mbpc-pc kernel: kworker/u16:1   D ffff880000063ba8     0 
   572      2 0x00000080
Oct 20 11:07:34 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work 
[target_core_mod]
Oct 20 11:07:34 mbpc-pc kernel: ffff880000063ba8 ffff880060a30310 
ffff88011a824f40 0000000000000000
Oct 20 11:07:34 mbpc-pc kernel: ffff880000060008 ffff880003d99930 
7fffffffffffffff ffff880060a30310
Oct 20 11:07:34 mbpc-pc kernel: 7fffffffffffffff ffff880000063bc8 
ffffffff815d135e ffffffff81d73f01
Oct 20 11:07:34 mbpc-pc kernel: Call Trace:
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff815d135e>] schedule+0x3e/0x90
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff815d3a6d>] 
schedule_timeout+0x13d/0x1f0
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff8109f33f>] ? up+0x2f/0x50
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff81135174>] ? 
irq_work_queue+0xa4/0xc0
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff81072cc9>] ? 
start_flush_work+0x49/0x180
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff815d23c6>] 
wait_for_completion+0xc6/0x100
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff81086f90>] ? 
try_to_wake_up+0x240/0x240
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffffa0ad2963>] 
__transport_wait_for_tasks+0xb3/0x1d0 [target_core_mod]
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff810adf1f>] ? 
vprintk_default+0x1f/0x30
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff815d07ac>] ? printk+0x46/0x48
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffffa0ad2ac4>] 
transport_wait_for_tasks+0x44/0x60 [target_core_mod]
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffffa0acfaf2>] 
core_tmr_abort_task+0x152/0x180 [target_core_mod]
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffffa0ad2722>] 
target_tmr_work+0x152/0x160 [target_core_mod]
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff8107337d>] 
process_one_work+0x14d/0x480
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff810737cf>] 
worker_thread+0x11f/0x3d0
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff815d0d4b>] ? 
__schedule+0x37b/0x810
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff810736b0>] ? 
process_one_work+0x480/0x480
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff810736b0>] ? 
process_one_work+0x480/0x480
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff8107852e>] kthread+0xce/0xf0
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff8104d9ee>] ? 
__do_page_fault+0x17e/0x430
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff81078460>] ? 
kthread_freezable_should_stop+0x70/0x70
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff815d4e12>] ret_from_fork+0x42/0x70
Oct 20 11:07:34 mbpc-pc kernel: [<ffffffff81078460>] ? 
kthread_freezable_should_stop+0x70/0x70
Oct 20 11:07:34 mbpc-pc kernel: INFO: task kworker/3:34:644 blocked for 
more than 120 seconds.
Oct 20 11:07:34 mbpc-pc kernel:      Not tainted 4.1.20 #2





Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.


On 10/23/2016 11:47 AM, TomK wrote:
> Resending because the Triple X get's filtered in subjects
> CONFIG_TCM_QLA2...  (Removed it from the body as well)
>
> Basically these two options are no longer available in the latest stable
> kernel.  Wondering if this option is being deprecated.
>
>          -> QLogic QLA2XXX Fibre Channel Support (SCSI_QLA_FC [=m])
>           -> [m] TCM_QLA2XXX fabric module for Qlogic 2xxx series target
> mode HBAs
>
> Cheers,
> Tom K.
> -------------------------------------------------------------------------------------
>
>
> Living on earth is expensive, but it includes a free trip around the sun.
>
>
> On 10/23/2016 1:05 AM, TomK wrote:
>> Hello,
>>
>> The latest 4.8.4 kernel is missing the following kernel option
>> CONFIG_TCM_QLA2... .  Are there more recent instructions?  Or is this
>> option on it's way out of the kernel?
>>
>> http://linux-iscsi.org/wiki/Downloads
>>
>> QLogic Fibre Channel
>> Optionally, enable the QLogic Fibre Channel target module (qla2xxx.ko),
>> including its SCSI LLD:
>>         Device Drivers --->
>>                  SCSI device support  --->
>>                          [*] SCSI low-level drivers  --->
>>
>>                  --- SCSI low-level drivers
>>                    <M>   QLogic QLA2... Fibre Channel Support
>>                    <M>   TCM_QLA2... fabric module for Qlogic 2xxx
>> series target mode HBAs
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
