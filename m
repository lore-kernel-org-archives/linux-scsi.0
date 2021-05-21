Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D148C47078
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 14:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D91E5613E4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 14:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhEUOgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 10:36:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:43392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236812AbhEUOgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 May 2021 10:36:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6BFAAC8F;
        Fri, 21 May 2021 14:34:50 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org,
        Saurav Kashyap <skashyap@marvell.com>,
        Daniel Wagner <dwagner@suse.de>,
        Javed Hasan <jhasan@marvell.com>
Subject: [PATCH] scsi: qedf: Do not put host in qedf_vport_create unconditionally
Date:   Fri, 21 May 2021 16:34:40 +0200
Message-Id: <20210521143440.84816-1-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do not drop reference count on vn_port->host in qedf_vport_create()
unconditionally. Instead drop the reference count in
qedf_vport_destroy().

Reported-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

 refcount_t: underflow; use-after-free.
 WARNING: CPU: 29 PID: 15713 at ../lib/refcount.c:28 refcount_warn_saturate+0x8d/0xf0
 Modules linked in: xt_tcpudp(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) bpfilter(E) af_packet(E) bridge(E) stp(E) llc(E) iscsi_ibft(E) iscsi_boot_sysfs(E) rfkill(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) rpcrdma(E) sunrpc(E) rdma_ucm(E) ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) libiscsi(E) edac_mce_amd(E) scsi_transport_iscsi(E) kvm_amd(E) kvm(E) ipmi_ssif(E) irqbypass(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) qedr(E) aes_x86_64(E) crypto_simd(E) ib_uverbs(E) cryptd(E) glue_helper(E) joydev(E) pcspkr(E) ses(E) enclosure(E) tg3(E) ib_core(E) k10temp(E) ccp(E) i2c_piix4(E) libphy(E) hpwdt(E) hpilo(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E) acpi_cpufreq(E) button(E) fuse(E) configfs(E) xfs(E) libcrc32c(E) uas(E) usb_storage(E) hid_generic(E) usbhid(E) dm_service_time(E) sd_mod(E) crc32c_intel(E) mgag200(E) drm_vram_helper(E) ttm(E) i2c_algo_bit(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) qedf(E)
  smartpqi(E) xhci_pci(E) fb_sys_fops(E) ehci_pci(E) scsi_transport_sas(E) xhci_hcd(E) ehci_hcd(E) qede(E) libfcoe(E) drm(E) usbcore(E) qed(E) libfc(E) crc8(E) scsi_transport_fc(E) wmi(E) dm_mirror(E) dm_region_hash(E) dm_log(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) scsi_mod(E) msr(E) efivarfs(E)
 Supported: No, Unreleased kernel
 CPU: 29 PID: 15713 Comm: bash Kdump: loaded Tainted: G            E       5.3.18-0.g8d8fa3b-default #1 SLE15-SP2 (unreleased)
 Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/17/2020
 RIP: 0010:refcount_warn_saturate+0x8d/0xf0
 Code: 05 3e 8f 17 01 01 e8 62 32 c3 ff 0f 0b c3 80 3d 31 8f 17 01 00 75 ad 48 c7 c7 b0 2c b4 9b c6 05 21 8f 17 01 01 e8 43 32 c3 ff <0f> 0b c3 80 3d 15 8f 17 01 00 75 8e 48 c7 c7 58 2c b4 9b c6 05 05
 RSP: 0018:ffffa3f62386fe08 EFLAGS: 00010282
 RAX: 0000000000000000 RBX: ffff8fd90e0807c8 RCX: 0000000000000006
 RDX: 0000000000000007 RSI: 0000000000000082 RDI: ffff8fe521d99890
 RBP: ffff8fd925780ae0 R08: 00000000000009ee R09: 0000000000000001
 R10: 0000000000000034 R11: 0000000000000001 R12: 0000000000000022
 R13: ffff8fd924f74e48 R14: ffff8fd924f74800 R15: ffff8fe51f4c1160
 FS:  00007f311e174b80(0000) GS:ffff8fe521d80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000556949270788 CR3: 000000044ecdc000 CR4: 00000000003406e0
 Call Trace:
  qedf_vport_destroy+0xae/0xe0 [qedf]
  fc_vport_terminate+0x3e/0x150 [scsi_transport_fc]
  store_fc_host_vport_delete+0x131/0x170 [scsi_transport_fc]
  kernfs_fop_write+0x113/0x1a0
  vfs_write+0xad/0x1b0
  ksys_write+0xa1/0xe0
  do_syscall_64+0x5b/0x1e0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f311d834c03
 Code: 2d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 f3 c3 0f 1f 00 41 54 55 49 89 d4 53 48 89
 RSP: 002b:00007ffcde861258 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 0000000000000022 RCX: 00007f311d834c03
 RDX: 0000000000000022 RSI: 00005569492718a0 RDI: 0000000000000001
 RBP: 00005569492718a0 R08: 000000000000000a R09: 0000000000000000
 R10: 00007f311d74b468 R11: 0000000000000246 R12: 00007f311db13500
 R13: 0000000000000022 R14: 00007f311db13700 R15: 0000000000000022


 drivers/scsi/qedf/qedf_main.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 69f7784233f9..3513f3eabbc0 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1825,22 +1825,20 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 		fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Failed to create vport, "
 			   "WWPN (0x%s) already exists.\n", buf);
-		goto err1;
+		return rc;
 	}
 
 	if (atomic_read(&base_qedf->link_state) != QEDF_LINK_UP) {
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Cannot create vport "
 			   "because link is not up.\n");
-		rc = -EIO;
-		goto err1;
+		return -EIO;
 	}
 
 	vn_port = libfc_vport_create(vport, sizeof(struct qedf_ctx));
 	if (!vn_port) {
 		QEDF_WARN(&(base_qedf->dbg_ctx), "Could not create lport "
 			   "for vport.\n");
-		rc = -ENOMEM;
-		goto err1;
+		return -ENOMEM;
 	}
 
 	fcoe_wwn_to_str(vport->port_name, buf, sizeof(buf));
@@ -1864,7 +1862,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_ERR(&(base_qedf->dbg_ctx), "Could not allocate memory "
 		    "for lport stats.\n");
-		goto err2;
+		goto err;
 	}
 
 	fc_set_wwnn(vn_port, vport->node_name);
@@ -1882,7 +1880,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	if (rc) {
 		QEDF_WARN(&base_qedf->dbg_ctx,
 			  "Error adding Scsi_Host rc=0x%x.\n", rc);
-		goto err2;
+		goto err;
 	}
 
 	/* Set default dev_loss_tmo based on module parameter */
@@ -1923,9 +1921,10 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vport_qedf->dbg_ctx.host_no = vn_port->host->host_no;
 	vport_qedf->dbg_ctx.pdev = base_qedf->pdev;
 
-err2:
+	return 0;
+
+err:
 	scsi_host_put(vn_port->host);
-err1:
 	return rc;
 }
 
@@ -1966,8 +1965,7 @@ static int qedf_vport_destroy(struct fc_vport *vport)
 	fc_lport_free_stats(vn_port);
 
 	/* Release Scsi_Host */
-	if (vn_port->host)
-		scsi_host_put(vn_port->host);
+	scsi_host_put(vn_port->host);
 
 out:
 	return 0;
-- 
2.29.2

