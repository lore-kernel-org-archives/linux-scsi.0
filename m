Return-Path: <SRS0=jwuq=XU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFD8C432C2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 12:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D91F2146E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 12:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbfIYMjc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 08:39:32 -0400
Received: from mail.monom.org ([188.138.9.77]:34214 "EHLO mail.monom.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbfIYMjc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Sep 2019 08:39:32 -0400
Received: from mail.monom.org (localhost [127.0.0.1])
        by filter.mynetwork.local (Postfix) with ESMTP id E096E500590;
        Wed, 25 Sep 2019 14:39:28 +0200 (CEST)
Received: from localhost (b9168f76.cgn.dg-w.de [185.22.143.118])
        by mail.monom.org (Postfix) with ESMTPSA id A4D96500114;
        Wed, 25 Sep 2019 14:39:28 +0200 (CEST)
Date:   Wed, 25 Sep 2019 14:39:28 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     qla2xxx-upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: WARN_ON_ONCE in qla2x00_status_cont_entry
Message-ID: <20190925123928.kahpjtnikcmox7ug@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

While testing an update of the qla2xxx driver (10.01.00.19-k) in our
downstream kernel, I noticed that the WARN_ON_ONCE in
qla2x00_status_cont_entry() is triggered. It was introduced by
88263208dd23 ("scsi: qla2xxx: Complain if sp->done() is not called
from the completion path")

This happens also on the current mkp/5.4/scsi-queue kernel
(e74006edd0d4 ("scsi: hisi_sas: Fix the conflict between device gone
and host reset")).


[   29.712117] qla2xxx [0000:13:00.0]-00fb:2: QLogic QLE2742 - QLogic 32Gb 2-port FC to PCIe Gen3 x8 Adapter.
[   29.712126] qla2xxx [0000:13:00.0]-00fc:2: ISP2261: PCIe (8.0GT/s x8) @ 0000:13:00.0 hdma+ host#=2 fw=8.03.04 (d0d5).


[ 5550.093537] qla2xxx [0000:13:00.1]-381c:5: Check condition Sense data, nexus5:0:0 cmd=ffff973310b33148.
[ 5550.093538] qla2xxx [0000:13:00.1]-382b:5: +20    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ 5550.093539] qla2xxx [0000:13:00.1]-382b:5: ----- -----------------------------------------------
[ 5550.093539] qla2xxx [0000:13:00.1]-382b:5: 0000: 70 00 06 00 00 00 00 9e 00 00 00 00 29 00 00 00
[ 5550.093541] qla2xxx [0000:13:00.1]-382b:5: 0010: 00 00 00 00
[ 5550.093542] qla2xxx [0000:13:00.1]-382c:5: +60    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ 5550.093543] qla2xxx [0000:13:00.1]-382c:5: ----- -----------------------------------------------
[ 5550.093543] qla2xxx [0000:13:00.1]-382c:5: 0000: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5550.093544] qla2xxx [0000:13:00.1]-382c:5: 0010: 00 08 01 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5550.093545] qla2xxx [0000:13:00.1]-382c:5: 0020: 00 00 00 00 00 00 00 00 53 56 34 34 39 32 31 39
[ 5550.093546] qla2xxx [0000:13:00.1]-382c:5: 0030: 31 31 20 20 20 20 20 20 08 40 50 00
[ 5550.093555] ------------[ cut here ]------------
[ 5550.093566] WARNING: CPU: 18 PID: 0 at ../drivers/scsi/qla2xxx/qla_isr.c:2841 qla2x00_status_cont_entry.isra.10+0x115/0x1c0 [qla2xxx]
[ 5550.093567] Modules linked in: qla2xxx(E) nvme_fc(E) nvme_fabrics(E) nvme_core(E) nfsv3(E) nfs_acl(E) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) dns_resolver(E) nfs(E) lockd(E) grace(E) fs$
[ 5550.093597]  ipmi_si(E) bnxt_en(E) iscsi_boot_sysfs(E) lpc_ich(E) mei_me(E) ioatdma(E) cryptd(E) hpwdt(E) mfd_core(E) mei(E) devlink(E) hpilo(E) enclosure(E) libphy(E) ipmi_devintf(E) dca($
[ 5550.093625] Supported: No, Unreleased kernel
[ 5550.093627] CPU: 18 PID: 0 Comm: swapper/18 Tainted: G        W   E      4.12.14-0.gcb6ab6c-default #1 SLE15 (unreleased)
[ 5550.093627] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/15/2018
[ 5550.093628] task: ffff9724c3940780 task.stack: ffffabf086350000
[ 5550.093634] RIP: 0010:qla2x00_status_cont_entry.isra.10+0x115/0x1c0 [qla2xxx]
[ 5550.093635] RSP: 0018:ffff972b5fc83e40 EFLAGS: 00010002
[ 5550.093636] RAX: 000000000000003c RBX: ffff973310b332d8 RCX: 0000000000000000
[ 5550.093636] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
[ 5550.093636] RBP: ffff972b54b28860 R08: 0000000000000000 R09: ffffffff8d83a8e2
[ 5550.093637] R10: 0000000000000023 R11: 000000000000000a R12: 0000000000000010
[ 5550.093637] R13: 000000000000003c R14: ffff97334d17c6d0 R15: ffff973310b33148
[ 5550.093638] FS:  0000000000000000(0000) GS:ffff972b5fc80000(0000) knlGS:0000000000000000
[ 5550.093639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5550.093639] CR2: 00007ffe79345e80 CR3: 000000055c00a002 CR4: 00000000007606e0
[ 5550.093640] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5550.093640] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5550.093640] PKRU: 55555554
[ 5550.093641] Call Trace:
[ 5550.093643]  <IRQ>
[ 5550.093649]  qla24xx_process_response_queue+0x5a6/0x8a0 [qla2xxx]
[ 5550.093659]  ? scsi_end_request+0x127/0x210 [scsi_mod]
[ 5550.093664]  qla24xx_msix_rsp_q+0x3e/0xa0 [qla2xxx]
[ 5550.093668]  __handle_irq_event_percpu+0x40/0x190
[ 5550.093670]  handle_irq_event_percpu+0x20/0x50
[ 5550.093671]  handle_irq_event+0x36/0x60
[ 5550.093672]  handle_edge_irq+0x79/0x140
[ 5550.093674]  handle_irq+0x1c/0x30
[ 5550.093676]  do_IRQ+0x41/0xd0
[ 5550.093678]  common_interrupt+0x8f/0x8f
[ 5550.093679]  </IRQ>
[ 5550.093681] RIP: 0010:cpuidle_enter_state+0xa2/0x2e0
[ 5550.093681] RSP: 0018:ffffabf086353eb8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff19
[ 5550.093682] RAX: ffff972b5fca2dc0 RBX: 0000050c3b5a7d07 RCX: 000000000000001f
[ 5550.093683] RDX: 0000050c3b5a7d07 RSI: 00000000357562ba RDI: 0000000000000000
[ 5550.093683] RBP: ffffcbe88b290390 R08: 0000000000000004 R09: 00000000000225c0
[ 5550.093684] R10: ffffabf086353e98 R11: 000000000000012f R12: 0000000000000003
[ 5550.093684] R13: ffffffff8d17adf8 R14: 0000000000000000 R15: 0000050c3b569954
[ 5550.093686]  ? cpuidle_enter_state+0x92/0x2e0
[ 5550.093688]  do_idle+0x183/0x1e0
[ 5550.093689]  cpu_startup_entry+0x5d/0x60
[ 5550.093692]  start_secondary+0x1b3/0x200
[ 5550.093694]  secondary_startup_64+0xa5/0xb0
[ 5550.093695] Code: c7 45 00 00 00 00 00 41 8b b7 80 01 00 00 48 89 df 48 8b 83 80 01 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f e9 4b 25 c8 cb <0f> 0b 48 83 c4 08 5b 5d 41 5c 41 5d 41 $
[ 5550.093713] ---[ end trace 9b09c347f7350dc6 ]---
[ 5550.093714] qla2xxx [0000:13:00.1]-382c:5: +16    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ 5550.093715] qla2xxx [0000:13:00.1]-382c:5: ----- -----------------------------------------------
[ 5550.093715] qla2xxx [0000:13:00.1]-382c:5: 0000: 00 00 00 00 0a 00 00 00 00 00 00 00 00 00 00 00
[ 5550.093721] sd 5:0:0:0: Power-on or device reset occurred
[ 5550.094322] qla2xxx [0000:13:00.1]-381c:5: Check condition Sense data, nexus5:0:0 cmd=ffff97331041f948.
[ 5550.094322] qla2xxx [0000:13:00.1]-382b:5: +20    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ 5550.094323] qla2xxx [0000:13:00.1]-382b:5: ----- -----------------------------------------------
[ 5550.094323] qla2xxx [0000:13:00.1]-382b:5: 0000: 70 00 05 00 00 00 00 9e 00 00 00 00 24 00 00 80
[ 5550.094324] qla2xxx [0000:13:00.1]-382b:5: 0010: 00 02 00 00
[ 5550.094326] qla2xxx [0000:13:00.1]-382c:5: +60    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ 5550.094326] qla2xxx [0000:13:00.1]-382c:5: ----- -----------------------------------------------
[ 5550.094326] qla2xxx [0000:13:00.1]-382c:5: 0000: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 5550.094327] qla2xxx [0000:13:00.1]-382c:5: 0010: 00 78 00 00 9e 1c 01 0a 00 20 00 00 00 00 00 00
[ 5550.094328] qla2xxx [0000:13:00.1]-382c:5: 0020: 00 00 00 00 00 00 00 00 53 56 34 34 39 32 31 39
[ 5550.094329] qla2xxx [0000:13:00.1]-382c:5: 0030: 31 31 20 20 20 20 20 20 08 40 50 00
[ 5550.094333] qla2xxx [0000:13:00.1]-382c:5: +16    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
[ 5550.094333] qla2xxx [0000:13:00.1]-382c:5: ----- -----------------------------------------------
[ 5550.094334] qla2xxx [0000:13:00.1]-382c:5: 0000: 00 00 00 00 0a 00 00 00 00 00 00 00 00 00 00 00                                                                                             

So I after starring on the code I am not sure if the WARN_ON_ONCE is
correct. It assumes that after processing one status continuation,
there is no more work. Though it looks like there is another element
to process. Is it possible that two sense continuation are possible?

I added a counter to the process loop in
qla24xx_process_response_queue() which indicates that this is possible:

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4c26630c1c3e..140f30216cae 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2981,6 +2981,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 {
        struct sts_entry_24xx *pkt;
        struct qla_hw_data *ha = vha->hw;
+       unsigned int cnt = 0;

        if (!ha->flags.fw_started)
                return;
@@ -3014,6 +3015,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
                        qla2x00_status_entry(vha, rsp, pkt);
                        break;
                case STATUS_CONT_TYPE:
+                       printk("qla2xxx - STATUS_CONT_TYPE %d\n", cnt++);
                        qla2x00_status_cont_entry(rsp, (sts_cont_entry_t *)pkt);
                        break;
                case VP_RPT_ID_IOCB_TYPE:


[   37.936117] qla2xxx - STATUS_CONT_TYPE 0
[   37.936136] sd 5:0:0:0: Attached scsi generic sg4 type 0
[   37.936164] WARNING: CPU: 6 PID: 552 at drivers/scsi/qla2xxx/qla_isr.c:2841 qla2x00_status_cont_entry.isra.15+0x115/0x1c0 [qla2xxx]
[   37.936165] Modules linked in: button(E) btrfs(E) libcrc32c(E) xor(E) zstd_decompress(E) zstd_compress(E) uas(E) usb_storage(E) raid6_pq(E) sd_mod(E) mgag200(E) i2c_algo_bit(E) drm_vram_helper(E) ttm(E) qedf(E) qed(E) drm_kms_helper(E) qla2xxx(E) syscopyarea(E) crc8(E) sysfillrect(E) libfcoe(E) nvme_fc(E) ehci_pci(E) sysimgblt(E) xhci_pci(E) smartpqi(E) fb_sys_fops(E) nvme_fabrics(E) ehci_hcd(E) xhci_hcd(E) libfc(E) crc32c_intel(E) scsi_transport_sas(E) nvme_core(E) drm(E) scsi_transport_fc(E) usbcore(E) wmi(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) efivarfs(E) autofs4(E)
[   37.936189] CPU: 6 PID: 552 Comm: kworker/6:1 Tainted: G            E     5.3.0-rc1-default+ #4
[   37.936190] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/15/2018
[   37.936204] Workqueue: qla2xxx_wq qla_do_work [qla2xxx]
[   37.936217] RIP: 0010:qla2x00_status_cont_entry.isra.15+0x115/0x1c0 [qla2xxx]
[   37.936219] Code: 45 00 00 00 00 00 41 8b b7 80 01 00 00 48 89 df 48 8b 83 78 01 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f e9 9b 72 51 f4 <0f> 0b 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 52 04 49
[   37.936220] RSP: 0018:ffffb4424b9f3dc8 EFLAGS: 00010002
[   37.936222] RAX: 000000000000003c RBX: ffff902791884f30 RCX: ffff9026c165b994
[   37.936223] RDX: 000000000000302c RSI: ffff9027997557b8 RDI: 0000000008020000
[   37.936224] RBP: ffff90279efc6560 R08: 000000000000003c R09: 0000000000000030
[   37.936226] R10: 0050400820202020 R11: 0000000000000000 R12: 0000000000000010
[   37.936227] R13: 000000000000003c R14: ffff9026c165b9d0 R15: ffff902791884d98
[   37.936228] FS:  0000000000000000(0000) GS:ffff90279f780000(0000) knlGS:0000000000000000
[   37.936230] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.936230] CR2: 00007f1213a99ca6 CR3: 000000080a9b0003 CR4: 00000000007606e0
[   37.936231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   37.936232] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   37.936233] PKRU: 55555554
[   37.936234] Call Trace:
[   37.936249]  qla24xx_process_response_queue+0x8bc/0x8d0 [qla2xxx]
[   37.936256]  ? __switch_to_asm+0x34/0x70
[   37.936258]  ? __switch_to_asm+0x40/0x70
[   37.936260]  ? __switch_to_asm+0x34/0x70
[   37.936263]  ? __switch_to+0x7a/0x3b0
[   37.936264]  ? __switch_to_asm+0x34/0x70
[   37.936276]  qla_do_work+0x35/0x50 [qla2xxx]
[   37.936281]  process_one_work+0x1f4/0x3e0
[   37.936283]  worker_thread+0x2d/0x3e0
[   37.936285]  ? process_one_work+0x3e0/0x3e0
[   37.936286]  kthread+0x117/0x130
[   37.936288]  ? kthread_create_worker_on_cpu+0x70/0x70
[   37.936290]  ret_from_fork+0x35/0x40
[   37.936292] ---[ end trace 3a815ae24538e1b2 ]---
[   37.936293] qla2xxx - STATUS_CONT_TYPE 1
[   37.936296] sd 5:0:0:0: Power-on or device reset occurred
[   37.936301] qla2xxx - STATUS_CONT_TYPE 2
[   37.941431] qla2xxx - STATUS_CONT_TYPE 0
[   37.941446] qla2xxx - STATUS_CONT_TYPE 1
[   37.941451] qla2xxx - STATUS_CONT_TYPE 2


Thanks,
Daniel
