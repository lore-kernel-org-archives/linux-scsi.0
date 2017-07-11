From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 4/5] target: user: Fix sense data handling
Date: Tue, 11 Jul 2017 09:57:30 +0900
Message-ID: <9690f0df-c935-23b7-6010-cd05db6d6be0@wdc.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
 <20170628055900.22889-5-damien.lemoal@wdc.com>
 <5eb219c5-c4a7-ea75-ff31-d732e10c72ae@redhat.com>
 <1499403018.30628.27.camel@haakon3.risingtidesystems.com>
 <f878e24a-55eb-a8a6-48f6-78ad36954932@wdc.com>
 <1499407500.30628.45.camel@haakon3.risingtidesystems.com>
 <c992e282-1b20-3ed5-320e-7ad39531065e@wdc.com> <5963B8E0.60603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5963B8E0.60603@redhat.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Mike,

On 7/11/17 02:26, Mike Christie wrote:
> On 07/10/2017 12:36 AM, Damien Le Moal wrote:
>> Nicholas, Mike,
>>
>> On 7/7/17 15:05, Nicholas A. Bellinger wrote:
>>> Everything including MNC's #1-6 and your #1-2 be pushed to
>>> target-pending/for-next shortly.
>>>
>>> Please use this as your base for testing.  :)
>>
>> I ran tests this morning with the latest target-pending/for-next branch.
>> I ran libzbc test suite on top of 4 different configurations:
>>
>> 1) ZBC drive + pscsi + loopback -> OK, no problems.
>> 2) ZBC drive + pscsi + iscsi -> OK, no problems.
>> 3) ZBC emulation tcmu-runner handler + loopback -> OK, no problems.
>> 4) ZBC emulation tcmu-runner handler + iscsi -> Crash !
>>
>> Here is the oops for case (4):
>>
>> [  169.545459] scsi host7: iSCSI Initiator over TCP/IP
>> [  169.559013] scsi 7:0:0:0: Direct-Access-ZBC LIO-ORG  TCMU ZBC device
>> 0002 PQ: 0 ANSI: 5
>> [  169.576920] sd 7:0:0:0: Attached scsi generic sg9 type 20
>> [  169.577209] sd 7:0:0:0: [sdi] Host-managed zoned block device
>> [  169.577794] sd 7:0:0:0: [sdi] 20971520 512-byte logical blocks: (10.7
>> GB/10.0 GiB)
>> [  169.577796] sd 7:0:0:0: [sdi] 40 zones of 524288 logical blocks
>> [  169.577980] sd 7:0:0:0: [sdi] Write Protect is off
>> [  169.578329] sd 7:0:0:0: [sdi] Write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>> [  169.590379] sd 7:0:0:0: [sdi] Attached SCSI disk
>> [  240.071464] BUG: unable to handle kernel paging request at
>> ffffc9065db85540
>> [  240.078460] IP: memcpy_erms+0x6/0x10
>> [  240.082044] PGD 7ff0ba067
>> [  240.082045] P4D 7ff0ba067
>> [  240.084766] PUD 0
>> [  240.087486]
>> [  240.091006] Oops: 0002 [#1] PREEMPT SMP
>> [  240.094855] Modules linked in: ip6table_filter ip6_tables
>> rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache
>> iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi sunrpc
>> snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel snd_hda_codec
>> snd_hwdep snd_hda_core snd_seq snd_seq_device x86_pkg_temp_thermal
>> coretemp snd_pcm crc32_pclmul snd_timer iTCO_wdt snd i2c_i801
>> iTCO_vendor_support soundcore i915 iosf_mbi i2c_algo_bit drm_kms_helper
>> syscopyarea sysfillrect sysimgblt fb_sys_fops drm e1000e r8169 mpt3sas
>> mii i2c_core raid_class video
>> [  240.143969] CPU: 0 PID: 1285 Comm: iscsi_trx Not tainted 4.12.0-rc1+ #3
>> [  240.150607] Hardware name: ASUS All Series/H87-PRO, BIOS 2104 10/28/2014
>> [  240.157331] task: ffff8807de4f5800 task.stack: ffffc900047dc000
>> [  240.163270] RIP: 0010:memcpy_erms+0x6/0x10
>> [  240.167377] RSP: 0018:ffffc900047dfc68 EFLAGS: 00010202
>> [  240.172621] RAX: ffffc9065db85540 RBX: ffff8807f7980000 RCX:
>> 0000000000000010
>> [  240.179771] RDX: 0000000000000010 RSI: ffff8807de574fe0 RDI:
>> ffffc9065db85540
>> [  240.186930] RBP: ffffc900047dfd30 R08: ffff8807de41b000 R09:
>> 0000000000000000
>> [  240.194088] R10: 0000000000000040 R11: ffff8807e9b726f0 R12:
>> 00000006565726b0
>> [  240.201246] R13: ffffc90007612ea0 R14: 000000065657d540 R15:
>> 0000000000000000
>> [  240.208397] FS:  0000000000000000(0000) GS:ffff88081fa00000(0000)
>> knlGS:0000000000000000
>> [  240.216510] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  240.222280] CR2: ffffc9065db85540 CR3: 0000000001c0f000 CR4:
>> 00000000001406f0
>> [  240.229430] Call Trace:
>> [  240.231887]  ? tcmu_queue_cmd+0x83c/0xa80
>> [  240.235916]  ? target_check_reservation+0xcd/0x6f0
>> [  240.240725]  __target_execute_cmd+0x27/0xa0
>> [  240.244918]  target_execute_cmd+0x232/0x2c0
>> [  240.249124]  ? __local_bh_enable_ip+0x64/0xa0
>> [  240.253499]  iscsit_execute_cmd+0x20d/0x270
>> [  240.257693]  iscsit_sequence_cmd+0x110/0x190
>> [  240.261985]  iscsit_get_rx_pdu+0x360/0xc80
>> [  240.267565]  ? iscsi_target_rx_thread+0x54/0xd0
>> [  240.273571]  iscsi_target_rx_thread+0x9a/0xd0
>> [  240.279413]  kthread+0x113/0x150
>> [  240.284120]  ? iscsi_target_tx_thread+0x1e0/0x1e0
>> [  240.290297]  ? kthread_create_on_node+0x40/0x40
>> [  240.296297]  ret_from_fork+0x2e/0x40
>> [  240.301332] Code: 90 90 90 90 90 eb 1e 0f 1f 00 48 89 f8 48 89 d1 48
>> c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48
>> 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38
>> [  240.321751] RIP: memcpy_erms+0x6/0x10 RSP: ffffc900047dfc68
>> [  240.328838] CR2: ffffc9065db85540
>> [  240.333667] ---[ end trace b7e5354cfb54d08b ]---
>>
>> I went back to running my initial 5 patch series on top of the current
>> 4.12 kernel and everything is fine, including case (4).
>>
>> A diff of the 2 versions of drivers/target/target_core_user.c did not
>> reveal anything obvious that could result in this... It does look like a
>> race condition on the session command or some memory corruption/bad
>> pointer. Any idea ?
>>
> 
> I have not seen this crash before. You are running these tests:
> 
> https://github.com/hgst/libzbc/tree/master/test
> 
> right?

Yes.

> What test was it? If you need a device that supports zone to run the
> test, do you know what scsi command it crashed on? If not can you send a
> tcmpdump trace and/or enable lio kernel debugging?

It is always crashing on a 4KB write command in test 01.071 (WRITE
sequential zone boundary violation). This test verifies that the drive
fails a write command spanning zones and return correct sense key &
codes for the error. The write crashing the kernel is however not the
last one that should fail, but one in the middle of the zone (filling up
the zone to reach the end and generate the zone spanning write).
So this is not related to ZBC specific commands.

I will rerun with LIO debug and report back (anything in particular you
want or should I just enable everything ?)

I will also try with the regular tcmu-runner file handler to see if the
same problem exists there too.

Best regards.

-- 
Damien Le Moal,
Western Digital
