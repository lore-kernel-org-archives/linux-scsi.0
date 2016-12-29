From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Thu, 29 Dec 2016 16:57:23 -0700
Message-ID: <CAANLjFooGrt51a9rOy8TKMyXyxBYmGEPm=h1YJm81Nj6YS=5yg@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
 <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com>
 <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com> <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
 <1476774332.8490.43.camel@haakon3.risingtidesystems.com> <CAANLjFqXt5r=c9F75vjeK=_zLa8zCS1priLuZo=A1ZSHKZ=1Bw@mail.gmail.com>
 <1476858359.8490.97.camel@haakon3.risingtidesystems.com> <CAANLjFoGEi29goybqsvEg6trystEkurVz52P8SwqGUSNV1jdSw@mail.gmail.com>
 <1477780190.22703.47.camel@haakon3.risingtidesystems.com> <CAANLjFpkEVmO83r5YWh=hCnN=AUf9bvrrCyVJHc-=CRpc3P0vQ@mail.gmail.com>
 <CAANLjFqoHuSq2SsNZ4J2uvAQGPg0F1tpxeJuAQT1oM1hXQ0wew@mail.gmail.com>
 <CAANLjFpYT62G86w-r00+shJUyrPd68BS64y8f9OZemz_5kojzg@mail.gmail.com>
 <CAANLjFon+re7eMriFjnFfR-4SnzxR4LLSb2qcwhfkb7ODbuTwg@mail.gmail.com>
 <CAANLjFpoWruzYEDohQrAKCxp9NSGhZM3mv=x+9+L7x1+fwYN6w@mail.gmail.com>
 <6beeb461-0391-cb29-8cf7-74f4c8feda34@redhat.com> <CAANLjFq2ib0H+W3RFVAdqvWF8_qDOkM5mvmAhVh0x4Usha2dOg@mail.gmail.com>
 <CAANLjFqRskoM7dn_zj_-V=uUb5KYq0OLLdLLuC4Uuba4+mq5Vw@mail.gmail.com>
 <CAANLjFqvtqFu85Aivg6K8XB0rMub03KbBSCq8Kj=Cg+ybxu3pw@mail.gmail.com>
 <CAANLjFpbE9-B8qWtU5nDfg4+t+kD8TSVy0JOfN+zuFYsZ05_Dg@mail.gmail.com> <CAANLjFpEpJ4647u9R-7phf68fw--pOfThbp5Sntd4c7DdRSwwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpEpJ4647u9R-7phf68fw--pOfThbp5Sntd4c7DdRSwwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

OK, I've drilled down a little more and

timeout = action(timeout);

in do_wait_for_common() in kernel/sched/completion.c is not returning.
I'll have to see if I can make more progress tomorrow.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Dec 29, 2016 at 2:23 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> I know most people are ignoring this thread by now, but I hope someone
> is still reading and can offer some ideas.
>
> It looks like ib_drain_qp_done() is not being called the first time
> that __ib_drain_sq() is called from iscsit_close_connection(). I tried
> to debug wait_for_completion() and friends, but they are called by too
> many things and I don't know how to filter out what I'm looking for.
> My next idea is to copy the completion functions here so that I can
> add debug to only that path. I feel like I'm inching closer to the
> problem, stumbling around in the dark.
>
> [Thu Dec 29 14:02:03 2016] Starting iscsit_close_connection.
> [Thu Dec 29 14:02:03 2016] isert_wait_conn calling ib_drain_qp.
> [Thu Dec 29 14:02:03 2016] ib_drain_qp calling ib_drain_sq.
> [Thu Dec 29 14:02:03 2016] ib_drain_sq calling __ib_drain_sq.
> [Thu Dec 29 14:02:03 2016] Setting up drain callback.
> [Thu Dec 29 14:02:03 2016] Starting init_completion.
> [Thu Dec 29 14:02:03 2016] Calling ib_modify_qp.
> [Thu Dec 29 14:02:03 2016] Calling ib_post_send.
> [Thu Dec 29 14:02:03 2016] Calling wait_for_completion.
> [Thu Dec 29 14:02:03 2016] &sdrain.done->done = 0.
>
> Gets "stuck" here...
>
> [Thu Dec 29 14:02:20 2016] iSCSI Login timeout on Network Portal 0.0.0.0:3260
> [Thu Dec 29 14:02:37 2016] ib_drain_qp calling ib_drain_sq.
> [Thu Dec 29 14:02:37 2016] ib_drain_sq calling __ib_drain_sq.
> [Thu Dec 29 14:02:37 2016] Setting up drain callback.
> [Thu Dec 29 14:02:37 2016] Starting init_completion.
> [Thu Dec 29 14:02:37 2016] Calling ib_modify_qp.
> [Thu Dec 29 14:02:37 2016] Calling ib_post_send.
> [Thu Dec 29 14:02:37 2016] Calling wait_for_completion.
> [Thu Dec 29 14:02:37 2016] ib_drain_qp_done going to call complete.
> [Thu Dec 29 14:02:38 2016] &sdrain.done->done = 1.
> [Thu Dec 29 14:02:38 2016] Returned from wait_for_completion.
> [Thu Dec 29 14:02:38 2016] ib_drain_qp_done going to call complete.
>
> Next time ib_drain_qp is called, ib_drain_qp_done gets called...
>
> [Thu Dec 29 14:02:55 2016] ib_drain_qp calling ib_drain_sq.
> [Thu Dec 29 14:02:55 2016] ib_drain_sq calling __ib_drain_sq.
> [Thu Dec 29 14:02:55 2016] Setting up drain callback.
> [Thu Dec 29 14:02:55 2016] Starting init_completion.
> [Thu Dec 29 14:02:55 2016] Calling ib_modify_qp.
> [Thu Dec 29 14:02:55 2016] Calling ib_post_send.
> [Thu Dec 29 14:02:55 2016] Calling wait_for_completion.
> [Thu Dec 29 14:02:55 2016] ib_drain_qp_done going to call complete.
> [Thu Dec 29 14:02:55 2016] &sdrain.done->done = 1.
> [Thu Dec 29 14:02:55 2016] Returned from wait_for_completion.
> [Thu Dec 29 14:02:55 2016] ib_drain_qp_done going to call complete.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Wed, Dec 28, 2016 at 1:58 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> Good news! I found a 10 Gb switch laying around and put it in place of
>> the Linux router. I'm getting the same failure with the switch, so it
>> is not something funky with the Linux router and easier to replicate.
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Wed, Dec 28, 2016 at 1:39 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>> OK, here is some more info. This is a diagram of my current set up.
>>>
>>>                 +----------------+
>>>                 |  Linux Router  |
>>>                 |   ConnectX-3   |
>>>                 | port 1  port 2 |
>>>                 +----------------+
>>>                      /      \
>>> +---------------+   /        \   +---------------+
>>> |    Host 1     |  / A      A \  |    Host 2     |
>>> | ConnectX-4-LX | /            \ | ConnectX-4-LX |
>>> |        Port 1 |-              -| Port 1        |
>>> |        Port 2 |----------------| Port 2        |
>>> +---------------+        B       +---------------+
>>>
>>> The Linux router has the ConnectX-3 (not PRO) card in Ethernet mode
>>> and is using a breakout cable (port 1 only) to connect to the
>>> ConnectX-4-LX cards at 10 Gb as path 'A'. The second port of the
>>> ConnectX-4-LX cards are connected directly at 25 Gb as path 'B'.
>>>
>>> Running Iser and RoCE on path 'B' seems to run just fine.
>>>
>>> Running Iser and RoCE on path 'A' has issues when the Linux router is
>>> operating as a bridge or a router. Some small operations like mkfs
>>> seem to work just fine, but fio causes iser to want to log out and we
>>> get D state. I can run ib_send_bw 'all' tests through path 'A' and
>>> don't see a problem. It does seem to be load related, though. I have
>>> been trying to run
>>>
>>> echo "3" > /proc/sys/vm/drop_caches; fio --rw=read --bs=4K --size=1G
>>> --numjobs=40 --name=worker.matt --group_reporting
>>>
>>> If I reduce the number of jobs to 10 or less, it seems to work
>>> although I may see some of the debug messages I added in, it doesn't
>>> seem to completely hang and cause the logout lockup.
>>>
>>> Steps to reproduce:
>>> 1. 4.9 kernel
>>> 2. Bridge ports 1 & 2 on the Linux router
>>> 3. Configure port 1 on Host 1 & 2 on the same subnet
>>> 4. Create large ramdisk in targetcli and export from Host 1
>>> 5. Login from Host 2
>>> 6. Create EXT4 file system on imported disk
>>> 7. Mount and cd into mount
>>> 8. Run fio: echo "3" > /proc/sys/vm/drop_caches; fio --rw=read --bs=4K
>>> --size=1G --numjobs=40 --name=worker.matt --group_reporting
>>> 9. After some time, the fio process will report the file system is
>>> read only and the iscsi processes will be in D state on Host 1
>>>
>>> It does seem the problem is in iser and not specific to the generic RDMA stack.
>>>
>>> I'll keep digging and reporting back.
>>> ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>
>>>
>>> On Tue, Dec 27, 2016 at 1:58 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>>> I realized that I did not set the default RoCE mode to v2 and the
>>>> client is on a different subnet, probably why I'm seeing the -110
>>>> error. Iser should not go into D state because of this and should
>>>> handle this gracefully, but may provide an easy way to replicate the
>>>> issue.
>>>> ----------------
>>>> Robert LeBlanc
>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>
>>>>
>>>> On Tue, Dec 27, 2016 at 1:22 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>>>> I looked at this code and it is quiet above my ability. I created this
>>>>> patch, but I don't know how to interrogate the queue to see how many
>>>>> items there are. If you can give me some more direction on what to
>>>>> try, I can keep fumbling around with this until someone smarter than
>>>>> me can figure it out. This is now a blocker for me so I'm going to
>>>>> beat my head on this until it is fixed.
>>>>>
>>>>> Thanks for being patient with me.
>>>>>
>>>>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>>>>> index 8368764..9e5bd4b 100644
>>>>> --- a/drivers/infiniband/core/verbs.c
>>>>> +++ b/drivers/infiniband/core/verbs.c
>>>>> @@ -1954,22 +1954,27 @@ static void __ib_drain_sq(struct ib_qp *qp)
>>>>>                 return;
>>>>>         }
>>>>>
>>>>> +       printk("Setting up drain callback.");
>>>>>         swr.wr_cqe = &sdrain.cqe;
>>>>>         sdrain.cqe.done = ib_drain_qp_done;
>>>>> +       printk("Starting init_completion.");
>>>>>         init_completion(&sdrain.done);
>>>>>
>>>>> +       printk("Calling ib_modify_qp.");
>>>>>         ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
>>>>>         if (ret) {
>>>>>                 WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
>>>>>                 return;
>>>>>         }
>>>>>
>>>>> +       printk("Calling ib_post_send.");
>>>>>         ret = ib_post_send(qp, &swr, &bad_swr);
>>>>>         if (ret) {
>>>>>                 WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
>>>>>                 return;
>>>>>         }
>>>>>
>>>>> +       printk("Starting wait_for_completion.");
>>>>>         wait_for_completion(&sdrain.done);
>>>>>  }
>>>>>
>>>>> I get the same processes in D state (and same backtrace) and this is
>>>>> what shows up in dmesg:
>>>>>
>>>>> [  920.317401] isert: isert_rdma_accept: rdma_accept() failed with: -110
>>>>> [  920.325554] ------------[ cut here ]------------
>>>>> [  920.330188] WARNING: CPU: 11 PID: 705 at
>>>>> drivers/infiniband/core/verbs.c:303 ib_dealloc_pd+0x58/0xa0 [ib_core]
>>>>> [  920.340210] Modules linked in: target_core_user target_core_pscsi
>>>>> target_core_file target_core_iblock 8021q garp mrp rpcrdma sunrpc
>>>>> ib_isert ib_iser ib_srpt ib_srp scsi_transport_srp ib_ipoib
>>>>> iptable_filter rdma_ucm i
>>>>> b_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm sb_edac edac_core
>>>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ext4
>>>>> ipmi_devintf irqbypass crct10dif_pclmul crc32_pclmul
>>>>> ghash_clmulni_intel aesni_intel jbd2 lr
>>>>> w gf128mul glue_helper mbcache iTCO_wdt ablk_helper mei_me
>>>>> iTCO_vendor_support cryptd joydev sg mei i2c_i801 lpc_ich pcspkr
>>>>> mfd_core ioatdma shpchp i2c_smbus ipmi_si wmi ipmi_msghandler
>>>>> acpi_power_meter acpi_pad ip_table
>>>>> s xfs libcrc32c raid1 mlx4_en mlx4_ib mlx5_ib sd_mod ib_core ast
>>>>> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
>>>>> mlx5_core igb mlx4_core
>>>>> [  920.412347]  ahci ptp drm libahci pps_core libata dca i2c_algo_bit
>>>>> be2iscsi bnx2i cnic uio qla4xxx iscsi_boot_sysfs
>>>>> [  920.421744] CPU: 11 PID: 705 Comm: kworker/11:2 Not tainted 4.9.0+ #3
>>>>> [  920.428199] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
>>>>> BIOS 1.1 08/03/2015
>>>>> [  920.436126] Workqueue: ib_cm cm_work_handler [ib_cm]
>>>>> [  920.441113]  ffffc90032a03a40 ffffffff8134d45f 0000000000000000
>>>>> 0000000000000000
>>>>> [  920.448583]  ffffc90032a03a80 ffffffff81083371 0000012fa04a1c4a
>>>>> ffff883f5e886e80
>>>>> [  920.456073]  ffff887f1eaa4400 ffff887f1eaa5800 ffffc90032a03b08
>>>>> 00000000ffffff92
>>>>> [  920.463535] Call Trace:
>>>>> [  920.465993]  [<ffffffff8134d45f>] dump_stack+0x63/0x84
>>>>> [  920.471144]  [<ffffffff81083371>] __warn+0xd1/0xf0
>>>>> [  920.475941]  [<ffffffff810834ad>] warn_slowpath_null+0x1d/0x20
>>>>> [  920.481790]  [<ffffffffa026cf58>] ib_dealloc_pd+0x58/0xa0 [ib_core]
>>>>> [  920.488072]  [<ffffffffa0695000>] isert_device_put+0x50/0xc0 [ib_isert]
>>>>> [  920.494693]  [<ffffffffa069838e>] isert_connect_request+0x68e/0xd40
>>>>> [ib_isert]
>>>>> [  920.501924]  [<ffffffffa0699683>] isert_cma_handler+0xe3/0x3b0 [ib_isert]
>>>>> [  920.508725]  [<ffffffffa042c5d6>] ? cma_new_conn_id+0x276/0x4b0 [rdma_cm]
>>>>> [  920.515521]  [<ffffffffa0427050>] cma_listen_handler+0x20/0x30 [rdma_cm]
>>>>> [  920.522227]  [<ffffffffa042ca05>] cma_req_handler+0x1f5/0x4c0 [rdma_cm]
>>>>> [  920.528851]  [<ffffffffa03fb0f5>] cm_process_work+0x25/0xf0 [ib_cm]
>>>>> [  920.535125]  [<ffffffffa03fba94>] cm_req_handler+0x8d4/0xc70 [ib_cm]
>>>>> [  920.541485]  [<ffffffffa03fc1ce>] cm_work_handler+0x1ce/0x1648 [ib_cm]
>>>>> [  920.548021]  [<ffffffff8109cc02>] process_one_work+0x152/0x400
>>>>> [  920.553861]  [<ffffffff8109d4f5>] worker_thread+0x125/0x4b0
>>>>> [  920.559443]  [<ffffffff8109d3d0>] ? rescuer_thread+0x380/0x380
>>>>> [  920.565284]  [<ffffffff810a3059>] kthread+0xd9/0xf0
>>>>> [  920.570178]  [<ffffffff810a2f80>] ? kthread_park+0x60/0x60
>>>>> [  920.576389]  [<ffffffff817732d5>] ret_from_fork+0x25/0x30
>>>>> [  920.582473] ---[ end trace 1f5a1831f9d2d964 ]---
>>>>> [  920.587907] ------------[ cut here ]------------
>>>>> [  920.593213] WARNING: CPU: 11 PID: 705 at
>>>>> drivers/infiniband/core/cq.c:189 ib_free_cq+0x97/0xc0 [ib_core]
>>>>> [  920.603383] Modules linked in: target_core_user target_core_pscsi
>>>>> target_core_file target_core_iblock 8021q garp mrp rpcrdma sunrpc
>>>>> ib_isert ib_iser ib_srpt ib_srp scsi_transport_srp ib_ipoib
>>>>> iptable_filter rdma_ucm i
>>>>> b_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm sb_edac edac_core
>>>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ext4
>>>>> ipmi_devintf irqbypass crct10dif_pclmul crc32_pclmul
>>>>> ghash_clmulni_intel aesni_intel jbd2 lr
>>>>> w gf128mul glue_helper mbcache iTCO_wdt ablk_helper mei_me
>>>>> iTCO_vendor_support cryptd joydev sg mei i2c_i801 lpc_ich pcspkr
>>>>> mfd_core ioatdma shpchp i2c_smbus ipmi_si wmi ipmi_msghandler
>>>>> acpi_power_meter acpi_pad ip_table
>>>>> s xfs libcrc32c raid1 mlx4_en mlx4_ib mlx5_ib sd_mod ib_core ast
>>>>> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
>>>>> mlx5_core igb mlx4_core
>>>>> [  920.679694]  ahci ptp drm libahci pps_core libata dca i2c_algo_bit
>>>>> be2iscsi bnx2i cnic uio qla4xxx iscsi_boot_sysfs
>>>>> [  920.690579] CPU: 11 PID: 705 Comm: kworker/11:2 Tainted: G        W
>>>>>       4.9.0+ #3
>>>>> [  920.699008] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
>>>>> BIOS 1.1 08/03/2015
>>>>> [  920.707701] Workqueue: ib_cm cm_work_handler [ib_cm]
>>>>> [  920.713438]  ffffc90032a03a18 ffffffff8134d45f 0000000000000000
>>>>> 0000000000000000
>>>>> [  920.721648]  ffffc90032a03a58 ffffffff81083371 000000bd5e886e80
>>>>> ffff887f1eaa6800
>>>>> [  920.729850]  ffff883f5e886e20 ffff883f5e886e18 ffffc90032a03b08
>>>>> 00000000ffffff92
>>>>> [  920.738026] Call Trace:
>>>>> [  920.741188]  [<ffffffff8134d45f>] dump_stack+0x63/0x84
>>>>> [  920.747027]  [<ffffffff81083371>] __warn+0xd1/0xf0
>>>>> [  920.752488]  [<ffffffff810834ad>] warn_slowpath_null+0x1d/0x20
>>>>> [  920.758989]  [<ffffffffa026e037>] ib_free_cq+0x97/0xc0 [ib_core]
>>>>> [  920.765649]  [<ffffffffa0694f88>]
>>>>> isert_free_comps.isra.26+0x38/0x60 [ib_isert]
>>>>> [  920.773609]  [<ffffffffa069500d>] isert_device_put+0x5d/0xc0 [ib_isert]
>>>>> [  920.780868]  [<ffffffffa069838e>] isert_connect_request+0x68e/0xd40
>>>>> [ib_isert]
>>>>> [  920.788734]  [<ffffffffa0699683>] isert_cma_handler+0xe3/0x3b0 [ib_isert]
>>>>> [  920.796157]  [<ffffffffa042c5d6>] ? cma_new_conn_id+0x276/0x4b0 [rdma_cm]
>>>>> [  920.803586]  [<ffffffffa0427050>] cma_listen_handler+0x20/0x30 [rdma_cm]
>>>>> [  920.810916]  [<ffffffffa042ca05>] cma_req_handler+0x1f5/0x4c0 [rdma_cm]
>>>>> [  920.818167]  [<ffffffffa03fb0f5>] cm_process_work+0x25/0xf0 [ib_cm]
>>>>> [  920.825063]  [<ffffffffa03fba94>] cm_req_handler+0x8d4/0xc70 [ib_cm]
>>>>> [  920.832051]  [<ffffffffa03fc1ce>] cm_work_handler+0x1ce/0x1648 [ib_cm]
>>>>> [  920.839208]  [<ffffffff8109cc02>] process_one_work+0x152/0x400
>>>>> [  920.845669]  [<ffffffff8109d4f5>] worker_thread+0x125/0x4b0
>>>>> [  920.851880]  [<ffffffff8109d3d0>] ? rescuer_thread+0x380/0x380
>>>>> [  920.858352]  [<ffffffff810a3059>] kthread+0xd9/0xf0
>>>>> [  920.863857]  [<ffffffff810a2f80>] ? kthread_park+0x60/0x60
>>>>> [  920.869975]  [<ffffffff817732d5>] ret_from_fork+0x25/0x30
>>>>> [  920.876006] ---[ end trace 1f5a1831f9d2d965 ]---
>>>>> [  920.884335] isert: isert_cma_handler: failed handle connect request -110
>>>>> [ 1639.592451] Setting up drain callback.
>>>>> [ 1639.596073] Starting init_completion.
>>>>> [ 1639.600683] Calling ib_modify_qp.
>>>>> [ 1639.602616] Calling ib_post_send.
>>>>> [ 1639.606550] Starting wait_for_completion.
>>>>> [ 1656.976015] iSCSI Login timeout on Network Portal 0.0.0.0:3260
>>>>> [ 1674.254027] Setting up drain callback.
>>>>> [ 1674.257634] Starting init_completion.
>>>>> [ 1674.262107] Calling ib_modify_qp.
>>>>> [ 1674.264011] Calling ib_post_send.
>>>>> [ 1674.267969] Starting wait_for_completion.
>>>>> [ 1691.583888] Setting up drain callback.
>>>>> [ 1691.588490] Starting init_completion.
>>>>> [ 1691.590677] Calling ib_modify_qp.
>>>>> [ 1691.594766] Calling ib_post_send.
>>>>> [ 1691.596607] Starting wait_for_completion.
>>>>> [ 1708.913356] Setting up drain callback.
>>>>> [ 1708.915658] Starting init_completion.
>>>>> [ 1708.920152] Calling ib_modify_qp.
>>>>> [ 1708.922041] Calling ib_post_send.
>>>>> [ 1708.926048] Starting wait_for_completion.
>>>>> [ 1726.244365] Setting up drain callback.
>>>>> [ 1726.248973] Starting init_completion.
>>>>> [ 1726.251165] Calling ib_modify_qp.
>>>>> [ 1726.255189] Calling ib_post_send.
>>>>> [ 1726.257031] Starting wait_for_completion.
>>>>> [ 1743.574751] Setting up drain callback.
>>>>> [ 1743.577044] Starting init_completion.
>>>>> [ 1743.581496] Calling ib_modify_qp.
>>>>> [ 1743.583404] Calling ib_post_send.
>>>>> [ 1743.587346] Starting wait_for_completion.
>>>>> [ 1760.904470] Setting up drain callback.
>>>>> [ 1760.908991] Starting init_completion.
>>>>> [ 1760.911206] Calling ib_modify_qp.
>>>>> [ 1760.915214] Calling ib_post_send.
>>>>> [ 1760.917062] Starting wait_for_completion.
>>>>> [ 1778.230821] Setting up drain callback.
>>>>> [ 1778.233116] Starting init_completion.
>>>>> [ 1778.237510] Calling ib_modify_qp.
>>>>> [ 1778.239413] Calling ib_post_send.
>>>>> .... [keeps repeating]
>>>>> ----------------
>>>>> Robert LeBlanc
>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>>
>>>>>
>>>>> On Thu, Dec 22, 2016 at 12:15 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>> On 12/21/2016 6:39 PM, Robert LeBlanc wrote:
>>>>>>> I hit a new backtrace today, hopefully it adds something.
>>>>>>>
>>>>>>> # cat /proc/19659/stack
>>>>>>> [<ffffffff815304d1>] iscsit_stop_session+0x1b1/0x1c0
>>>>>>> [<ffffffff81521c62>] iscsi_check_for_session_reinstatement+0x1e2/0x270
>>>>>>> [<ffffffff81524660>] iscsi_target_check_for_existing_instances+0x30/0x40
>>>>>>> [<ffffffff815247a8>] iscsi_target_do_login+0x138/0x630
>>>>>>> [<ffffffff815259be>] iscsi_target_start_negotiation+0x4e/0xa0
>>>>>>> [<ffffffff8152355e>] __iscsi_target_login_thread+0x83e/0xf20
>>>>>>> [<ffffffff81523c64>] iscsi_target_login_thread+0x24/0x30
>>>>>>> [<ffffffff810a3059>] kthread+0xd9/0xf0
>>>>>>> [<ffffffff817732d5>] ret_from_fork+0x25/0x30
>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>
>>>>>>> # cat /proc/21342/stack
>>>>>>> [<ffffffffa0292b10>] __ib_drain_sq+0x190/0x1c0 [ib_core]
>>>>>>> [<ffffffffa0292b65>] ib_drain_sq+0x25/0x30 [ib_core]
>>>>>>> [<ffffffffa0292d72>] ib_drain_qp+0x12/0x30 [ib_core]
>>>>>>> [<ffffffffa062c5ff>] isert_wait_conn+0x5f/0x2d0 [ib_isert]
>>>>>>> [<ffffffff815309b7>] iscsit_close_connection+0x157/0x860
>>>>>>> [<ffffffff8151f10b>] iscsit_take_action_for_connection_exit+0x7b/0xf0
>>>>>>> [<ffffffff81530265>] iscsi_target_rx_thread+0x95/0xa0
>>>>>>> [<ffffffff810a3059>] kthread+0xd9/0xf0
>>>>>>> [<ffffffff817732d5>] ret_from_fork+0x25/0x30
>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>
>>>>>>> # ps aux | grep iscsi | grep D
>>>>>>> root     19659  0.0  0.0      0     0 ?        D    16:12   0:00 [iscsi_np]
>>>>>>> root     21342  0.0  0.0      0     0 ?        D    16:29   0:00 [iscsi_trx]
>>>>>>> ----------------
>>>>>>> Robert LeBlanc
>>>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>>>
>>>>>> That looks suspiciously like the __ib_drain_sq is stuck forever waiting
>>>>>> on a completion that never comes.
>>>>>>
>>>>>>>
>>>>>>> On Thu, Dec 15, 2016 at 1:38 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>>>>>>> Nicholas,
>>>>>>>>
>>>>>>>> I've found that the kernels I used were not able to be inspected using
>>>>>>>> crash and I could not build the debug info for them. So I built a new
>>>>>>>> 4.9 kernel and verified that I could inspect the crash. It is located
>>>>>>>> at [1].
>>>>>>>>
>>>>>>>> [1] http://mirrors.betterservers.com/trace/crash2.tar.xz
>>>>>>>> ----------------
>>>>>>>> Robert LeBlanc
>>>>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>>>>>
>>>>>>>>
>>>>>>>> On Mon, Dec 12, 2016 at 4:57 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>>>>>>>> Nicholas,
>>>>>>>>>
>>>>>>>>> After lots of set backs and having to give up trying to get kernel
>>>>>>>>> dumps on our "production" systems, I've been able to work out the
>>>>>>>>> issues we had with kdump and replicate the issue on my dev boxes. I
>>>>>>>>> have dumps from 4.4.30 and 4.9-rc8 (makedumpfile would not dump, so it
>>>>>>>>> is a straight copy of /proc/vmcore from the crash kernel). In each
>>>>>>>>> crash directory, I put a details.txt file that has the process IDs
>>>>>>>>> that were having problems and a brief description of the set-up at the
>>>>>>>>> time. This was mostly replicated by starting fio and pulling the
>>>>>>>>> Infiniband cable until fio gave up. This hardware also has Mellanox
>>>>>>>>> ConnectX4-LX cards and I also replicated the issue over RoCE using 4.9
>>>>>>>>> since it has the drivers in-box. Please let me know if you need more
>>>>>>>>> info, I can test much faster now. The cores/kernels/modules are
>>>>>>>>> located at [1].
>>>>>>>>>
>>>>>>>>> [1] http://mirrors.betterservers.com/trace/crash.tar.xz
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Robert
>>>>>>>>> ----------------
>>>>>>>>> Robert LeBlanc
>>>>>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Fri, Nov 4, 2016 at 3:57 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>>>>>>>>> We hit this yesterday, this time it was on the tx thread (the other
>>>>>>>>>> ones before seem to be on the rx thread). We weren't able to get a
>>>>>>>>>> kernel dump on this. We'll try to get one next time.
>>>>>>>>>>
>>>>>>>>>> # ps axuw | grep "D.*iscs[i]"
>>>>>>>>>> root     12383  0.0  0.0      0     0 ?        D    Nov03   0:04 [iscsi_np]
>>>>>>>>>> root     23016  0.0  0.0      0     0 ?        D    Nov03   0:00 [iscsi_ttx]
>>>>>>>>>> root     23018  0.0  0.0      0     0 ?        D    Nov03   0:00 [iscsi_ttx]
>>>>>>>>>> # cat /proc/12383/stack
>>>>>>>>>> [<ffffffff814f24af>] iscsit_stop_session+0x19f/0x1d0
>>>>>>>>>> [<ffffffff814e3c66>] iscsi_check_for_session_reinstatement+0x1e6/0x270
>>>>>>>>>> [<ffffffff814e6620>] iscsi_target_check_for_existing_instances+0x30/0x40
>>>>>>>>>> [<ffffffff814e6770>] iscsi_target_do_login+0x140/0x640
>>>>>>>>>> [<ffffffff814e7b0c>] iscsi_target_start_negotiation+0x1c/0xb0
>>>>>>>>>> [<ffffffff814e585b>] iscsi_target_login_thread+0xa9b/0xfc0
>>>>>>>>>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>>>>>>>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>>>> # cat /proc/23016/stack
>>>>>>>>>> [<ffffffff814ce0d9>] target_wait_for_sess_cmds+0x49/0x1a0
>>>>>>>>>> [<ffffffffa058b92b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>>>>>>>>> [<ffffffff814f2642>] iscsit_close_connection+0x162/0x870
>>>>>>>>>> [<ffffffff814e110f>] iscsit_take_action_for_connection_exit+0x7f/0x100
>>>>>>>>>> [<ffffffff814f122a>] iscsi_target_tx_thread+0x1aa/0x1d0
>>>>>>>>>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>>>>>>>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>>>> # cat /proc/23018/stack
>>>>>>>>>> [<ffffffff814ce0d9>] target_wait_for_sess_cmds+0x49/0x1a0
>>>>>>>>>> [<ffffffffa058b92b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>>>>>>>>>> [<ffffffff814f2642>] iscsit_close_connection+0x162/0x870
>>>>>>>>>> [<ffffffff814e110f>] iscsit_take_action_for_connection_exit+0x7f/0x100
>>>>>>>>>> [<ffffffff814f122a>] iscsi_target_tx_thread+0x1aa/0x1d0
>>>>>>>>>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>>>>>>>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>>>>>>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>>>>>>>>
>>>>>>>>>> From dmesg:
>>>>>>>>>> [  394.476332] INFO: rcu_sched self-detected stall on CPU
>>>>>>>>>> [  394.476334]  20-...: (23976 ticks this GP)
>>>>>>>>>> idle=edd/140000000000001/0 softirq=292/292 fqs=18788
>>>>>>>>>> [  394.476336]   (t=24003 jiffies g=3146 c=3145 q=0)
>>>>>>>>>> [  394.476337] Task dump for CPU 20:
>>>>>>>>>> [  394.476338] kworker/u68:2   R  running task        0 12906      2 0x00000008
>>>>>>>>>> [  394.476345] Workqueue: isert_comp_wq isert_cq_work [ib_isert]
>>>>>>>>>> [  394.476346]  ffff883f2fe38000 00000000f805705e ffff883f7fd03da8
>>>>>>>>>> ffffffff810ac8ff
>>>>>>>>>> [  394.476347]  0000000000000014 ffffffff81adb680 ffff883f7fd03dc0
>>>>>>>>>> ffffffff810af239
>>>>>>>>>> [  394.476348]  0000000000000015 ffff883f7fd03df0 ffffffff810e1cd0
>>>>>>>>>> ffff883f7fd17b80
>>>>>>>>>> [  394.476348] Call Trace:
>>>>>>>>>> [  394.476354]  <IRQ>  [<ffffffff810ac8ff>] sched_show_task+0xaf/0x110
>>>>>>>>>> [  394.476355]  [<ffffffff810af239>] dump_cpu_task+0x39/0x40
>>>>>>>>>> [  394.476357]  [<ffffffff810e1cd0>] rcu_dump_cpu_stacks+0x80/0xb0
>>>>>>>>>> [  394.476359]  [<ffffffff810e6100>] rcu_check_callbacks+0x540/0x820
>>>>>>>>>> [  394.476360]  [<ffffffff810afe11>] ? account_system_time+0x81/0x110
>>>>>>>>>> [  394.476363]  [<ffffffff810faa60>] ? tick_sched_do_timer+0x50/0x50
>>>>>>>>>> [  394.476364]  [<ffffffff810eb599>] update_process_times+0x39/0x60
>>>>>>>>>> [  394.476365]  [<ffffffff810fa815>] tick_sched_handle.isra.17+0x25/0x60
>>>>>>>>>> [  394.476366]  [<ffffffff810faa9d>] tick_sched_timer+0x3d/0x70
>>>>>>>>>> [  394.476368]  [<ffffffff810ec182>] __hrtimer_run_queues+0x102/0x290
>>>>>>>>>> [  394.476369]  [<ffffffff810ec668>] hrtimer_interrupt+0xa8/0x1a0
>>>>>>>>>> [  394.476372]  [<ffffffff81052c65>] local_apic_timer_interrupt+0x35/0x60
>>>>>>>>>> [  394.476374]  [<ffffffff8172423d>] smp_apic_timer_interrupt+0x3d/0x50
>>>>>>>>>> [  394.476376]  [<ffffffff817224f7>] apic_timer_interrupt+0x87/0x90
>>>>>>>>>> [  394.476379]  <EOI>  [<ffffffff810d71be>] ? console_unlock+0x41e/0x4e0
>>>>>>>>>> [  394.476380]  [<ffffffff810d757c>] vprintk_emit+0x2fc/0x500
>>>>>>>>>> [  394.476382]  [<ffffffff810d78ff>] vprintk_default+0x1f/0x30
>>>>>>>>>> [  394.476384]  [<ffffffff81174dde>] printk+0x5d/0x74
>>>>>>>>>> [  394.476388]  [<ffffffff814bce21>] transport_lookup_cmd_lun+0x1d1/0x200
>>>>>>>>>> [  394.476390]  [<ffffffff814ee8c0>] iscsit_setup_scsi_cmd+0x230/0x540
>>>>>>>>>> [  394.476392]  [<ffffffffa058dbf3>] isert_rx_do_work+0x3f3/0x7f0 [ib_isert]
>>>>>>>>>> [  394.476394]  [<ffffffffa058e174>] isert_cq_work+0x184/0x770 [ib_isert]
>>>>>>>>>> [  394.476396]  [<ffffffff8109740f>] process_one_work+0x14f/0x400
>>>>>>>>>> [  394.476397]  [<ffffffff81097c84>] worker_thread+0x114/0x470
>>>>>>>>>> [  394.476398]  [<ffffffff8171d32a>] ? __schedule+0x34a/0x7f0
>>>>>>>>>> [  394.476399]  [<ffffffff81097b70>] ? rescuer_thread+0x310/0x310
>>>>>>>>>> [  394.476400]  [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>>>>>>>> [  394.476402]  [<ffffffff8109d6f0>] ? kthread_park+0x60/0x60
>>>>>>>>>> [  394.476403]  [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>>>>>>>>>> [  394.476404]  [<ffffffff8109d6f0>] ? kthread_park+0x60/0x60
>>>>>>>>>> [  405.716632] Unexpected ret: -104 send data 360
>>>>>>>>>> [  405.721711] tx_data returned -32, expecting 360.
>>>>>>>>>> ----------------
>>>>>>>>>> Robert LeBlanc
>>>>>>>>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>>>>
>>>>>> When you combine this trace with the newest one, it really makes me
>>>>>> thing there is something of a bad interaction between the new drain cq
>>>>>> API and the iser/isert implementation to use said API.  Sagi, Christoph?
>>>>>>
>>>>>> --
>>>>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>>>>     GPG Key ID: B826A3330E572FDD
>>>>>>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>>>>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
