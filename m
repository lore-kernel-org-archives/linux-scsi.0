From: Zhu Lingshan <lszhu@suse.com>
Subject: Re: Need some pointers to debug a target hang
Date: Mon, 31 Oct 2016 16:51:46 +0800
Message-ID: <c3b4cec7-34bb-3f57-9ed6-7f41e7f88b61@suse.com>
References: <20160902141419.h23stppulnyfrnkz@c203.arch.suse.de>
 <1476770275.8490.10.camel@haakon3.risingtidesystems.com>
 <20161018070134.zhyk4ljaxzmvwfs2@linux-x5ow.site>
 <20161018173522.trhoqrcoeof4mn4w@linux-x5ow.site>
 <1476858567.8490.101.camel@haakon3.risingtidesystems.com>
 <1477781605.22703.62.camel@haakon3.risingtidesystems.com>
 <20161029230301.oflkmvv3epj752it@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:50100 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763305AbcJaIwD (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 31 Oct 2016 04:52:03 -0400
In-Reply-To: <20161029230301.oflkmvv3epj752it@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Nicholas,

(sorry it would be a long mail)

Sorry for the delay, I spent some test and debug work. I find the patch 
http://www.spinics.net/lists/target-devel/msg13530.html can solve two 
issues:
(a). iscsit_stop_session() on the top of iscsi_np stack.
(b).iscsi_check_for_session_reinstatement() on the top of iscsi_np 
stack, it is a must to reboot to recover.

But I also find two more issues.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Please let me explain my setup:
I have a target server, kernel version 4.4.21, it has a SATA HDD as a 
LUN, only one LUN.
I have two initiators, both login to the target.
Create two partitions on the LUN, each initiator mount a certain 
partition. Like initiator1 mount /dev/sdc1, initiator2 mount /dev/sdc2.
looks like this:
lszhu_DEV:~ # lsscsi
[0:0:0:0]    cd/dvd  HL-DT-ST DVD+-RW GHB0N    A1C0  /dev/sr0
[4:0:0:0]    disk    ATA      TOSHIBA DT01ACA2 MX4O  /dev/sda
[9:0:0:0]    disk    LIO-ORG  IBLOCK           4.0   /dev/sdc
lszhu_DEV:~ # lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0   1.8T  0 disk
├─sda1   8:1    0    16G  0 part [SWAP]
├─sda2   8:2    0   200G  0 part /
└─sda3   8:3    0   1.6T  0 part /home
sdc      8:32   0 465.8G  0 disk
├─sdc1   8:33   0   200G  0 part
└─sdc2   8:34   0 265.8G  0 part /mnt
sr0     11:0    1  1024M  0 rom

bj-ha-5:~ # lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 465.8G  0 disk
├─sda1   8:1    0     8G  0 part [SWAP]
├─sda2   8:2    0   100G  0 part /
└─sda3   8:3    0 357.8G  0 part /home
sdb      8:16   0 465.8G  0 disk
sdc      8:32   0 465.8G  0 disk
├─sdc1   8:33   0   200G  0 part /mnt
└─sdc2   8:34   0 265.8G  0 part
sr0     11:0    1  1024M  0 rom

so you can see each initiator will read / write on their own partition 
from the LUN.

mount the partition like this:
mount -o dioread_nolock /dev/sdc1 /mnt,  option dioread_nolock can help 
we reproduce this bug a little quicker.

Then run fio on both initiators like this:
fio -filename=/mnt/file1 -direct=1 -rw=randread -iodepth=64 
-ioengin=libaio -bs=64K -size=5G -numjobs=24 -runtime=60000 -time_based 
-group_reporting -name=init1
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Here are the three more issues I found, kernel version 4.4.21
(1) The first one looks like this, it is quite rare, only once, I failed 
to get stack information for iscsi_trx and hard to reproduce, call stack 
of iscsi_np is here:

bj-ha-3:~ # ps -aux | grep iscsi
root     10501  0.0  0.0      0     0 ?        D    16:45   0:00 [iscsi_np]
root     10519  0.4  0.0      0     0 ?        S    16:49   0:02 [iscsi_ttx]
root     10520  2.2  0.0      0     0 ?        S    16:49   0:14 [iscsi_trx]
root     10533  0.9  0.0      0     0 ?        D    16:54   0:03 [iscsi_trx]
root     10547  0.0  0.0  10508  1552 pts/0    S+   16:59   0:00 grep 
--color=auto iscsi
bj-ha-3:~ # cat /proc/10501/stack
[<ffffffff815334c9>] inet_csk_accept+0x269/0x2e0
[<ffffffff8155f4aa>] inet_accept+0x2a/0x100
[<ffffffff814d2a88>] kernel_accept+0x48/0xa0
[<ffffffffa06fe871>] iscsit_accept_np+0x31/0x230 [iscsi_target_mod]
[<ffffffffa06fefab>] iscsi_target_login_thread+0xeb/0xfd0 [iscsi_target_mod]
[<ffffffff810996bd>] kthread+0xbd/0xe0
[<ffffffff815e15bf>] ret_from_fork+0x3f/0x70
[<ffffffff81099600>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(2) The second issue I found has iscsi_check_for_session_reinstatement() 
on the top of iscsi_np call stack, but different from case (b) we 
mentioned before. In case (b), we must reboot the target to recover, but 
in this case, it will auto recover, here is the details:
dmesg:
[  100.487421] iSCSI/iqn.1996-04.de.suse:01:faad5846cde9: Unsupported 
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  182.582323] ABORT_TASK: Found referenced iSCSI task_tag: 15
[  197.616800] Unexpected ret: -32 send data 48
[  197.712278] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 15
[  263.603305] ABORT_TASK: Found referenced iSCSI task_tag: 268435537
[  278.640172] Unexpected ret: -32 send data 48
[  278.671299] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 
268435537
[  341.584329] ABORT_TASK: Found referenced iSCSI task_tag: 536871038
[  357.423710] Unexpected ret: -32 send data 48
[  373.660476] iSCSI Login timeout on Network Portal 192.168.100.233:3260

call stacks:
bj-ha-3:~ # ps -aux | grep iscsi
root      3063  0.0  0.0      0     0 ?        D    15:36   0:00 [iscsi_np]
root      3073  0.3  0.0      0     0 ?        S    15:36   0:01 [iscsi_ttx]
root      3074  0.4  0.0      0     0 ?        S    15:36   0:01 [iscsi_trx]
root      3094  0.3  0.0      0     0 ?        D    15:39   0:00 [iscsi_trx]
root      3116  0.0  0.0  10508  1616 pts/0    S+   15:42   0:00 grep 
--color=auto iscsi
bj-ha-3:~ # cat /proc/3063/stack
[<ffffffffa03fcd97>] iscsi_check_for_session_reinstatement+0x1d7/0x270 
[iscsi_target_mod]
[<ffffffffa03ff971>] iscsi_target_do_login+0x111/0x5f0 [iscsi_target_mod]
[<ffffffffa0400b17>] iscsi_target_start_negotiation+0x17/0xa0 
[iscsi_target_mod]
[<ffffffffa03fe932>] iscsi_target_login_thread+0xa72/0xfd0 
[iscsi_target_mod]
[<ffffffff810997cd>] kthread+0xbd/0xe0
[<ffffffff815e177f>] ret_from_fork+0x3f/0x70
[<ffffffff81099710>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff
bj-ha-3:~ # cat /proc/3094/stack
[<ffffffffa03adcc6>] transport_generic_free_cmd+0x76/0x110 [target_core_mod]
[<ffffffffa0404917>] iscsit_free_cmd+0x67/0x130 [iscsi_target_mod]
[<ffffffffa040b929>] iscsit_close_connection+0x4a9/0x860 [iscsi_target_mod]
[<ffffffffa040b0b3>] iscsi_target_rx_thread+0x93/0xa0 [iscsi_target_mod]
[<ffffffff810997cd>] kthread+0xbd/0xe0
[<ffffffff815e177f>] ret_from_fork+0x3f/0x70
[<ffffffff81099710>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff

At this moment, we can see IO errors at one initiator side, the other 
will survive. Once we killed the survival side FIO processes or wait a 
moment, the target would auto recover, looks like this:

bj-ha-3:~ # ps -aux | grep iscsi
root      3063  0.0  0.0      0     0 ?        S    15:36   0:00 [iscsi_np]
root      3142  0.0  0.0      0     0 ?        S    15:43   0:00 [iscsi_ttx]
root      3143  0.0  0.0      0     0 ?        S    15:43   0:00 [iscsi_trx]
root      3146  0.6  0.0      0     0 ?        S    15:43   0:00 [iscsi_ttx]
root      3147  0.8  0.0      0     0 ?        S    15:43   0:00 [iscsi_trx]
root      3149  0.0  0.0  10508  1636 pts/0    S+   15:43   0:00 grep 
--color=auto iscsi

dmesg at this moment:
[   90.507364] iSCSI/iqn.1996-04.de.suse:01:4039926d2313: Unsupported 
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  100.487421] iSCSI/iqn.1996-04.de.suse:01:faad5846cde9: Unsupported 
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  182.582323] ABORT_TASK: Found referenced iSCSI task_tag: 15
[  197.616800] Unexpected ret: -32 send data 48
[  197.712278] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 15
[  263.603305] ABORT_TASK: Found referenced iSCSI task_tag: 268435537
[  278.640172] Unexpected ret: -32 send data 48
[  278.671299] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 
268435537
[  341.584329] ABORT_TASK: Found referenced iSCSI task_tag: 536871038
[  357.423710] Unexpected ret: -32 send data 48
[  373.660476] iSCSI Login timeout on Network Portal 192.168.100.233:3260
[  535.852903] Unexpected ret: -32 send data 48
[  535.923803] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 
536871038
[  535.923811] ABORT_TASK: Found referenced iSCSI task_tag: 76
[  535.923815] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 76
[  535.924325] Unexpected ret: -104 send data 360
[  535.924329] tx_data returned -32, expecting 360.
[  535.924489] iSCSI Login negotiation failed.
[  535.924916] Unexpected ret: -104 send data 360
[  535.924918] tx_data returned -32, expecting 360.
[  535.924943] iSCSI Login negotiation failed.
[  535.925424] Unexpected ret: -104 send data 360
[  535.925428] tx_data returned -32, expecting 360.
[  535.925650] iSCSI Login negotiation failed.
[  535.926095] Unexpected ret: -104 send data 360
[  535.926097] tx_data returned -32, expecting 360.
[  535.926132] iSCSI Login negotiation failed.
[  535.926349] Unexpected ret: -104 send data 360
[  535.926351] tx_data returned -32, expecting 360.
[  535.926369] iSCSI Login negotiation failed.
[  535.926576] Unexpected ret: -104 send data 360
[  535.926577] tx_data returned -32, expecting 360.
[  535.926593] iSCSI Login negotiation failed.
[  535.926750] Unexpected ret: -104 send data 360
[  535.926752] tx_data returned -32, expecting 360.
[  535.926768] iSCSI Login negotiation failed.
[  535.926905] Unexpected ret: -104 send data 360
[  535.926906] tx_data returned -32, expecting 360.
[  535.926925] iSCSI Login negotiation failed.
[  535.927064] Unexpected ret: -104 send data 360
[  535.927065] tx_data returned -32, expecting 360.
[  535.927082] iSCSI Login negotiation failed.
[  535.927219] Unexpected ret: -104 send data 360
[  535.927220] tx_data returned -32, expecting 360.
[  535.927237] iSCSI Login negotiation failed.

I am still debugging on this case, I have core dumps, I think the dump 
files are too big for a mail list, I can send it off the list if needed.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(3) In this case, dmesg and call stack looks like this:
bj-ha-3:~ # dmesg
[  803.570868] ABORT_TASK: Found referenced iSCSI task_tag: 96
[  818.584038] Unexpected ret: -32 send data 48
[  818.620210] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 96
[  882.555923] ABORT_TASK: Found referenced iSCSI task_tag: 268435496
[  897.587925] Unexpected ret: -32 send data 48
[  898.845646] Unexpected ret: -32 send data 48
[  898.916090] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 
268435496
[  898.916095] ABORT_TASK: Found referenced iSCSI task_tag: 45
[  898.916377] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 45
[  962.785419] ABORT_TASK: Found referenced iSCSI task_tag: 268435489

bj-ha-3:~ # ps -aux | grep iscsi
root      3063  0.0  0.0      0     0 ?        D    15:36   0:00 [iscsi_np]
root      3296  1.9  0.0      0     0 ?        S    15:49   0:01 [iscsi_ttx]
root      3297  1.9  0.0      0     0 ?        R    15:49   0:01 [iscsi_trx]
root      3299  0.0  0.0      0     0 ?        D    15:49   0:00 [iscsi_trx]
root      3506  0.0  0.0  10508  1516 pts/0    S+   15:51   0:00 grep 
--color=auto iscsi


bj-ha-3:~ # cat /proc/3063/stack
[<ffffffffa03fcd97>] iscsi_check_for_session_reinstatement+0x1d7/0x270 
[iscsi_target_mod]
[<ffffffffa03ff971>] iscsi_target_do_login+0x111/0x5f0 [iscsi_target_mod]
[<ffffffffa0400b17>] iscsi_target_start_negotiation+0x17/0xa0 
[iscsi_target_mod]
[<ffffffffa03fe932>] iscsi_target_login_thread+0xa72/0xfd0 
[iscsi_target_mod]
[<ffffffff810997cd>] kthread+0xbd/0xe0
[<ffffffff815e177f>] ret_from_fork+0x3f/0x70
[<ffffffff81099710>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff
bj-ha-3:~ # cat /proc/3099/stack
[<ffffffffa03ac784>] __transport_wait_for_tasks+0xb4/0x190 [target_core_mod]
[<ffffffffa03ac905>] transport_wait_for_tasks+0x45/0x60 [target_core_mod]
[<ffffffffa03aa034>] core_tmr_abort_task+0xf4/0x160 [target_core_mod]
[<ffffffffa03aca43>] target_tmr_work+0x123/0x140 [target_core_mod]
[<ffffffff81093ace>] process_one_work+0x14e/0x410
[<ffffffff81094326>] worker_thread+0x116/0x490
[<ffffffff810997cd>] kthread+0xbd/0xe0
[<ffffffff815e177f>] ret_from_fork+0x3f/0x70
[<ffffffff81099710>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff

This case is also rare, only once, but I got the core dump files.
-------------------------------------------------------------------------------------------------------------------------------------------------
Sorry again for the delay and send such a long mail, I am still working 
on there cases, I will keep the list update once I find anything new.


Thanks,
BR
Zhu Lingshan


On 10/30/2016 07:03 AM, Johannes Thumshirn wrote:
> On Sat, Oct 29, 2016 at 03:53:25PM -0700, Nicholas A. Bellinger wrote:
>> Hi Johannes & Zhu,
>>
>> On Tue, 2016-10-18 at 23:29 -0700, Nicholas A. Bellinger wrote:
>>> On Tue, 2016-10-18 at 19:35 +0200, Johannes Thumshirn wrote:
>>>> On Tue, Oct 18, 2016 at 09:01:34AM +0200, Johannes Thumshirn wrote:
>>>>
>>>> [...]
>>>>
>>>>>> This is likely the missing SCF_ACK_KREF assignment in >= v4.1.y:
>>>>>>
>>>>>> http://www.spinics.net/lists/target-devel/msg13530.html
>>>> Sorry to disappoint you but it didn't fix my issue. Is there any debug data I
>>>> can give you, or do you have an advice where I could start looking?
>>>>
>>>> I have to admit I only tested the patch on our downstream kernel and not the
>>>> upstream kernel, I'll repeat the tests on 4.8 final tomorrow.
>>>>
>>> Is it possible to generate vmcore to have a look in crash + gdb..?
>>>
>>>
>> Just curious if you've been able to verify the above patch for
>> v4.8.y iscsi-target ports on your specific config(s)..?
>>
>> To confirm, using v4.1.y + patch I've not run into any further
>> se_cmd->cmd_kref leaks and/or hung tasks with iscsi-target ports due to
>> high backend device I/O latency, resulting in host timeouts + ABORT_TASK
>> + session reinstatement to occur while waiting for outstanding se_cmd
>> backend I/O to complete.
> Hi Nic,
>
> I'm sorry I haven't come around to testing it but I do have my test VMs with
> me and I should have time tomorrow to do it. Sorry for not giving you any updates
> on this.
>
> Thanks (and sorry),
>         Johannes

