From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: iscsi_trx going into D state
Date: Thu, 12 Jan 2017 14:22:34 -0700
Message-ID: <CAANLjFpRCwGSh=HV12dc_OtFKgcjQqERSPirqxWD1w0N-G_mCg@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <CAANLjFqvtqFu85Aivg6K8XB0rMub03KbBSCq8Kj=Cg+ybxu3pw@mail.gmail.com>
 <CAANLjFpbE9-B8qWtU5nDfg4+t+kD8TSVy0JOfN+zuFYsZ05_Dg@mail.gmail.com>
 <CAANLjFpEpJ4647u9R-7phf68fw--pOfThbp5Sntd4c7DdRSwwQ@mail.gmail.com>
 <CAANLjFooGrt51a9rOy8TKMyXyxBYmGEPm=h1YJm81Nj6YS=5yg@mail.gmail.com>
 <CAANLjFrZrTPUuzP_NjkgG5h_YwwYKEWT-KzVjTvuXZ1d04z6Fg@mail.gmail.com>
 <CAANLjFpSnQ7ApOK5HDRHXQQeQNGWLUv4e+2N=_e-zBeziYm5tw@mail.gmail.com>
 <CAANLjForEkO6RXw7KJYrTJD=f0S8FE73vvwNQcL_ARFdFoDQqg@mail.gmail.com>
 <1030906614.13148012.1483722413675.JavaMail.zimbra@redhat.com> <CAANLjFocE2fbO_oWRiEVCt0=mfmgrLy9qWqqg=TH_jZS3PXn0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33860 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbdALVWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 16:22:36 -0500
Received: by mail-oi0-f66.google.com with SMTP id w144so191324oiw.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 13:22:36 -0800 (PST)
In-Reply-To: <CAANLjFocE2fbO_oWRiEVCt0=mfmgrLy9qWqqg=TH_jZS3PXn0g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Zhu Lingshan <lszhu@suse.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>

I have a crappy patch (sledgehammer approach) that seems to prevent
the D state issue and the connection recovers, but things are possibly
not being cleaned up properly in iSCSI and so it may have issues after
a few recoveries (one test completed with a lot of resets but no iSCSI
errors). Hopefully this will help those smarter than I to understand
what is going on and know how to create a proper fix.

I'm having trouble replicating the D state issue on Infiniband (I was
able to trigger it reliably a couple weeks back, I don't know if OFED
to verify the same results happen there as well.

Patch
----
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8368764..ed36748 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2089,3 +2089,19 @@ void ib_drain_qp(struct ib_qp *qp)
               ib_drain_rq(qp);
}
EXPORT_SYMBOL(ib_drain_qp);
+
+void ib_reset_sq(struct ib_qp *qp)
+{
+       struct ib_qp_attr attr = { .qp_state = IB_QPS_RESET};
+       int ret;
+
+       ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+}
+EXPORT_SYMBOL(ib_reset_sq);
+
+void ib_reset_qp(struct ib_qp *qp)
+{
+       printk("ib_reset_qp calling ib_reset_sq.\n");
+       ib_reset_sq(qp);
+}
+EXPORT_SYMBOL(ib_reset_qp);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f6..619dbc7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2595,10 +2595,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
       isert_conn_terminate(isert_conn);
       mutex_unlock(&isert_conn->mutex);

-       ib_drain_qp(isert_conn->qp);
+       ib_reset_qp(isert_conn->qp);
       isert_put_unsol_pending_cmds(conn);
-       isert_wait4cmds(conn);
-       isert_wait4logout(isert_conn);
+       cancel_work_sync(&isert_conn->release_work);

       queue_work(isert_release_wq, &isert_conn->release_work);
}
@@ -2607,7 +2606,7 @@ static void isert_free_conn(struct iscsi_conn *conn)
{
       struct isert_conn *isert_conn = conn->context;

-       ib_drain_qp(isert_conn->qp);
+       ib_close_qp(isert_conn->qp);
       isert_put_conn(isert_conn);
}

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..3310c37 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3357,4 +3357,6 @@ int ib_sg_to_pages(struct ib_mr *mr, struct
scatterlist *sgl, int sg_nents,
void ib_drain_rq(struct ib_qp *qp);
void ib_drain_sq(struct ib_qp *qp);
void ib_drain_qp(struct ib_qp *qp);
+void ib_reset_sq(struct ib_qp *qp);
+void ib_reset_qp(struct ib_qp *qp);
#endif /* IB_VERBS_H */


iSCSI Errors (may have many of these)
----

[ 292.444044] ------------[ cut here ]------------
[ 292.444045] WARNING: CPU: 26 PID: 12705 at lib/list_debug.c:59
__list_del_entry+0xa1/0xd0
[ 292.444046] list_del corruption. prev->next should be
ffff8865628c27c0, but was dead000000000100
[ 292.444057] Modules linked in: ib_isert rdma_cm iw_cm ib_cm
target_core_user target_core_pscsi target_core_file target_core_iblock
mlx5_ib ib_core dm_mod 8021q garp mrp iptable_filter sb_edac edac_core
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ext4
ipmi_devintf irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel lrw jbd2 gf128mul mbcache mei_me
glue_helper iTCO_wdt ablk_helper cryptd iTCO_vendor_support mei joydev
sg ioatdma shpchp pcspkr i2c_i801 lpc_ich mfd_core i2c_smbus acpi_pad
wmi ipmi_si ipmi_msghandler acpi_power_meter ip_tables xfs libcrc32c
raid1 sd_mod ast drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm mlx5_core igb ahci ptp drm libahci pps_core mlx4_core
libata dca i2c_algo_bit be2iscsi bnx2i cnic uio qla4xxx
iscsi_boot_sysfs
[ 292.444058] CPU: 26 PID: 12705 Comm: kworker/26:2 Tainted: G W 4.9.0+ #14
[ 292.444058] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
BIOS 1.1 08/03/2015
[ 292.444059] Workqueue: target_completion target_complete_ok_work
[ 292.444060] ffffc90035533ca0 ffffffff8134d45f ffffc90035533cf0
0000000000000000
[ 292.444061] ffffc90035533ce0 ffffffff81083371 0000003b00000202
ffff8865628c27c0
[ 292.444062] ffff887f25f48064 0000000000000001 0000000000000000
0000000000000680
[ 292.444062] Call Trace:
[ 292.444063] [<ffffffff8134d45f>] dump_stack+0x63/0x84
[ 292.444065] [<ffffffff81083371>] __warn+0xd1/0xf0
[ 292.444066] [<ffffffff810833ef>] warn_slowpath_fmt+0x5f/0x80
[ 292.444067] [<ffffffff8136cce1>] __list_del_entry+0xa1/0xd0
[ 292.444067] [<ffffffff8136cd1d>] list_del+0xd/0x30
[ 292.444069] [<ffffffff8150a724>] target_remove_from_state_list+0x64/0x70
[ 292.444070] [<ffffffff8150a829>] transport_cmd_check_stop+0xf9/0x110
[ 292.444071] [<ffffffff8150e6c9>] target_complete_ok_work+0x169/0x360
[ 292.444072] [<ffffffff8109cc02>] process_one_work+0x152/0x400
[ 292.444072] [<ffffffff8109d4f5>] worker_thread+0x125/0x4b0
[ 292.444073] [<ffffffff8109d3d0>] ? rescuer_thread+0x380/0x380
[ 292.444075] [<ffffffff810a3059>] kthread+0xd9/0xf0
[ 292.444076] [<ffffffff810a2f80>] ? kthread_park+0x60/0x60
[ 292.444077] [<ffffffff817732d5>] ret_from_fork+0x25/0x30
[ 292.444078] ---[ end trace 721cfe26853c53b7 ]---
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Fri, Jan 6, 2017 at 12:12 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> Laurence,
>
> Since the summary may be helpful to others, I'm just going to send it
> to the list.
>
> I've been able to reproduce the D state problem on both Infiniband and
> RoCE, but it is much easier to reproduce on RoCE due to another bug
> and doesn't require being at the server to yank the cable (remote
> power control of a switch may work as well). The bug seems to be
> triggered by an abrupt and unexpected break in communications
>
> Common config between both Infiniband and RoCE:
> ====
> * Linux kernel 4.9 (using only inbox drivers, no OFED)
> * Target and initiator both configured on the same subnet
> * 100 GB ram disk exported by iser [1]
> * Iser volume imported on client and the whole block device formatted ext4.
> * FIO run on iser volume on the client [2]
> * Anything not mentioned in this document should be default (it is a
> pretty simple config)
>
> Infiniband specific config:
> ====
> * Any IB cards should work (my config has ConnectX-3, but has also
> been seen on Connect-IB in our environment)
> * Back to back (my config) or connected to a switch
> * OpenSM running on the target (my config), or on a separate host (not
> sure how cutting power to the switch may impact triggering the bug, I
> believe it will still trigger ok)
> * While running the fio job, pull the cable on the initiator side.
> After about 120 seconds the fio job will fail and the iscsi processes
> should be in D state on the target.
>
> RoCE specific config:
> ====
> * Only tested with ConnectX-4-LX cards (I don't know if others will
> trigger the problem, pulling the cable like in the Infiniband section,
> may also trigger the bug if it doesn't trigger automatically)
> * Hosts must be connected by a switch or a Linux bridge that doesn't
> have RoCE offload. I was able to trigger the bugs with a back to back
> connection if the target clamps the speed to 10 Gb [3].
> * Running the fio job should be enough to trigger the RoCE card to
> unexpectedly drop the RDMA connection and that should then cause the
> target iscsci processes to go into D state.
>
> For either the Infiniband or RoCE setup, the bug can be triggered with
> only two hosts connected back to back. If something is still not
> clear, please let me know.
>
> [1] /etc/saveconfig.json
> ```json
> {
>   "fabric_modules": [],
>   "storage_objects": [
>     {
>       "attributes": {
>         "block_size": 512,
>         "emulate_3pc": 1,
>         "emulate_caw": 1,
>         "emulate_dpo": 0,
>         "emulate_fua_read": 0,
>         "emulate_fua_write": 1,
>         "emulate_model_alias": 1,
>         "emulate_rest_reord": 0,
>         "emulate_tas": 1,
>         "emulate_tpu": 0,
>         "emulate_tpws": 0,
>         "emulate_ua_intlck_ctrl": 0,
>         "emulate_write_cache": 0,
>         "enforce_pr_isids": 1,
>         "force_pr_aptpl": 0,
>         "is_nonrot": 1,
>         "max_unmap_block_desc_count": 0,
>         "max_unmap_lba_count": 0,
>         "max_write_same_len": 0,
>         "optimal_sectors": 4294967288,
>         "pi_prot_format": 0,
>         "pi_prot_type": 0,
>         "queue_depth": 128,
>         "unmap_granularity": 0,
>         "unmap_granularity_alignment": 0
>       },
>       "name": "test1",
>       "plugin": "ramdisk",
>       "size": 107374182400,
>       "wwn": "7486ed41-585e-400f-8799-ac605485b221"
>     }
>   ],
>   "targets": [
>     {
>       "fabric": "iscsi",
>       "tpgs": [
>         {
>           "attributes": {
>             "authentication": 0,
>             "cache_dynamic_acls": 1,
>             "default_cmdsn_depth": 64,
>             "default_erl": 0,
>             "demo_mode_discovery": 1,
>             "demo_mode_write_protect": 0,
>             "generate_node_acls": 1,
>             "login_timeout": 15,
>             "netif_timeout": 2,
>             "prod_mode_write_protect": 0,
>             "t10_pi": 0
>           },
>           "enable": true,
>           "luns": [
>             {
>               "index": 0,
>               "storage_object": "/backstores/ramdisk/test1"
>             }
>           ],
>           "node_acls": [],
>           "parameters": {
>             "AuthMethod": "CHAP,None",
>             "DataDigest": "CRC32C,None",
>             "DataPDUInOrder": "Yes",
>             "DataSequenceInOrder": "Yes",
>             "DefaultTime2Retain": "20",
>             "DefaultTime2Wait": "2",
>             "ErrorRecoveryLevel": "0",
>             "FirstBurstLength": "65536",
>             "HeaderDigest": "CRC32C,None",
>             "IFMarkInt": "Reject",
>             "IFMarker": "No",
>             "ImmediateData": "Yes",
>             "InitialR2T": "Yes",
>             "MaxBurstLength": "262144",
>             "MaxConnections": "1",
>             "MaxOutstandingR2T": "1",
>             "MaxRecvDataSegmentLength": "8192",
>             "MaxXmitDataSegmentLength": "262144",
>             "OFMarkInt": "Reject",
>             "OFMarker": "No",
>             "TargetAlias": "LIO Target"
>           },
>           "portals": [
>             {
>               "ip_address": "0.0.0.0",
>               "iser": true,
>               "port": 3260
>             }
>           ],
>           "tag": 1
>         }
>       ],
>       "wwn": "iqn.2016-12.com.betterservers"
>     }
>   ]
> }
> ```
> [2] echo "3" > /proc/sys/vm/drop_caches; fio --rw=read --bs=4K
> --size=1G --numjobs=40 --name=worker.matt --group_reporting
> [3] ethtool -s eth3 speed 10000 advertise 0x80000
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
