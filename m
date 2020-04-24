Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD446C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF5720728
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:10:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="iCslNW/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgDXMKd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:10:33 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53476 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgDXMKc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:10:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9371C4C080;
        Fri, 24 Apr 2020 12:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:x-mailer:content-type
        :content-type:date:date:from:from:subject:subject:message-id
        :received:received:received; s=mta-01; t=1587730223; x=
        1589544624; bh=7atcya4pCa6zDN4hwfAta045DHU6Vxnbpr78eI3E7WY=; b=i
        CslNW/ZqT+D8crZdvS8NCYvwHLWkciFsMKdwwa7tEjBeTvaYBiaZlNDmbVGCST8F
        920mv2NEDXnUn/rFFK8HwXzqP/kISVf7Ia8gAgIW9r3fQbZdgkweHt5fZXPTfpKd
        o2pr+zHljnH7oJYU7MD4xy0P2/fbPtrai5PRjIA7Pc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KsYONklkbxuY; Fri, 24 Apr 2020 15:10:23 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A1E384C079;
        Fri, 24 Apr 2020 15:10:22 +0300 (MSK)
Received: from vdubeyko-laptop (10.199.0.202) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 24
 Apr 2020 15:10:23 +0300
Message-ID: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
Subject: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
From:   Viacheslav Dubeyko <v.dubeiko@yadro.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux@yadro.com>,
        <r.bolshakov@yadro.com>, <slava@dubeyko.com>
Date:   Fri, 24 Apr 2020 15:10:22 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.199.0.202]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Date: Fri, 10 Apr 2020 11:07:08 +0300
Subject: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset

Currently, FC target reset finishes with the warning
message.

[84010.596893] ------------[ cut here ]------------
[84010.596917] WARNING: CPU: 238 PID: 279973 at ../drivers/scsi/qla2xxx/qla_target.c:6644 qlt_enable_vha+0x1d0/0x260 [qla2xxx]
[84010.596918] Modules linked in: vrf af_packet 8021q garp mrp stp llc netlink_diag target_tatlin_tblock(OEX) dm_ec(OEX) ttln_rdma(OEX) dm_frontend(OEX) nvme_rdma nvmet tcm_qla2xxx iscsi_target_mod target_core_mod at24 nvmem_core pnv_php ipmi_watchdog ipmi_ssif vmx_crypto gf128mul crct10dif_vpmsum qla2xxx rpcrdma nvme_fc powernv_flash(X) nvme_fabrics uio_pdrv_genirq mtd rtc_opal(X) ibmpowernv(X) opal_prd(X) uio scsi_transport_fc i2c_opal(X) ses enclosure ipmi_poweroff ast i2c_algo_bit ttm bmc_mcu(OEX) drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm drm_panel_orientation_quirks agpgart nfsd auth_rpcgss nfs_acl ipmi_powernv(X) lockd ipmi_devintf ipmi_msghandler grace dummy ext4 crc16 jbd2 mbcache sd_mod rdma_ucm ib_iser rdma_cm ib_umad iw_cm ib_ipoib libiscsi scsi_transport_iscsi ib_cm
[84010.596975]  configfs mlx5_ib ib_uverbs ib_core mlx5_core crc32c_vpmsum xhci_pci xhci_hcd mpt3sas(OEX) tg3 usbcore mlxfw tls raid_class libphy scsi_transport_sas devlink ptp pps_core nvme nvme_core sunrpc dm_mirror dm_region_hash dm_log sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod autofs4
[84010.597001] Supported: Yes, External
[84010.597004] CPU: 238 PID: 279973 Comm: bash Tainted: G           OE      4.12.14-197.29-default #1 SLE15-SP1
[84010.597006] task: c000000a104c0000 task.stack: c000000b52188000
[84010.597007] NIP: d00000001ffd7f78 LR: d00000001ffd7f6c CTR: c0000000001676c0
[84010.597008] REGS: c000000b5218b910 TRAP: 0700   Tainted: G           OE       (4.12.14-197.29-default)
[84010.597008] MSR: 900000010282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE,TM[E]>
[84010.597015]   CR: 48242424  XER: 00000000
[84010.597016] CFAR: d00000001ff45d08 SOFTE: 1
               GPR00: d00000001ffd7f6c c000000b5218bb90 d00000002001b228 0000000000000102
               GPR04: 0000000000000001 0000000000000001 00013d91ed0a5e2d 0000000000000000
               GPR08: c000000007793300 0000000000000000 0000000000000000 c000000a086e7818
               GPR12: 0000000000002200 c000000007793300 0000000000000000 000000012bc937c0
               GPR16: 000000012bbf7ed0 0000000000000000 000000012bc3dd10 0000000000000000
               GPR20: 000000012bc4db28 0000010036442810 000000012bc97828 000000012bc96c70
               GPR24: 00000100365b1550 0000000000000000 00000100363f3d80 c000000be20d3080
               GPR28: c000000bda7eae00 c000000be20db7e8 c000000be20d3778 c000000be20db7e8
[84010.597042] NIP [d00000001ffd7f78] qlt_enable_vha+0x1d0/0x260 [qla2xxx]
[84010.597051] LR [d00000001ffd7f6c] qlt_enable_vha+0x1c4/0x260 [qla2xxx]
[84010.597051] Call Trace:
[84010.597061] [c000000b5218bb90] [d00000001ffd7f6c] qlt_enable_vha+0x1c4/0x260 [qla2xxx] (unreliable)
[84010.597064] [c000000b5218bc20] [d000000009820b6c] tcm_qla2xxx_tpg_enable_store+0xc4/0x130 [tcm_qla2xxx]
[84010.597067] [c000000b5218bcb0] [d0000000185d0e68] configfs_write_file+0xd0/0x190 [configfs]
[84010.597072] [c000000b5218bd00] [c0000000003d0edc] __vfs_write+0x3c/0x1e0
[84010.597074] [c000000b5218bd90] [c0000000003d2ea8] vfs_write+0xd8/0x220
[84010.597076] [c000000b5218bde0] [c0000000003d4ddc] SyS_write+0x6c/0x110
[84010.597079] [c000000b5218be30] [c00000000000b188] system_call+0x3c/0x130
[84010.597080] Instruction dump:
[84010.597082] 7d0050a8 7d084b78 7d0051ad 40c2fff4 7fa3eb78 4bf73965 60000000 7fa3eb78
[84010.597086] 4bf6dcd9 60000000 2fa30000 419eff40 <0fe00000> 4bffff38 e95f0058 a12a0180
[84010.597090] ---[ end trace e32abaf6e6fee826 ]---

It is possible to use such path with the goal
to reproduce the issue:

echo 0x7fffffff > /sys/module/qla2xxx/parameters/logging
modprobe target_core_mod
modprobe tcm_qla2xxx
mkdir /sys/kernel/config/target/qla2xxx
mkdir /sys/kernel/config/target/qla2xxx/<port-name>
mkdir /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 0 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable
echo 1 > /sys/kernel/config/target/qla2xxx/<port-name>/tpgt_1/enable

SYSTEM START
kernel: pid 327:drivers/scsi/qla2xxx/qla_init.c:2174 qla2x00_initialize_adapter(): vha->flags.online 0x0
<...>
kernel: pid 327:drivers/scsi/qla2xxx/qla_os.c:3444 qla2x00_probe_one(): vha->flags.online 0x1

echo 1 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:86:a6:2a/tpgt_1/enable
kernel: pid 348:drivers/scsi/qla2xxx/qla_init.c:6641 qla2x00_abort_isp_cleanup(): vha->flags.online 0x0, ISP_ABORT_NEEDED 0x0
<...>
kernel: pid 348:drivers/scsi/qla2xxx/qla_init.c:6998 qla2x00_restart_isp(): vha->flags.online 0x0

echo 0 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:86:a6:2a/tpgt_1/enable
kernel: pid 348:drivers/scsi/qla2xxx/qla_init.c:6641 qla2x00_abort_isp_cleanup(): vha->flags.online 0x0, ISP_ABORT_NEEDED 0x0
<...>
kernel: pid 1404:drivers/scsi/qla2xxx/qla_os.c:1107 qla2x00_wait_for_hba_online(): base_vha->flags.online 0x0

echo 1 > /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:86:a6:2a/tpgt_1/enable
kernel: pid 1404:drivers/scsi/qla2xxx/qla_os.c:1107 qla2x00_wait_for_hba_online(): base_vha->flags.online 0x0
kernel: -----------[ cut here ]-----------
kernel: WARNING: CPU: 1 PID: 1404 at drivers/scsi/qla2xxx/qla_target.c:6654 qlt_enable_vha+0x1e0/0x280 [qla2xxx]

The issue takes place because no real ISP reset is executed.
The qla2x00_abort_isp(scsi_qla_host_t *vha) method expects that
vha->flags.online will be not zero for ISP reset procedure.
This patch sets vha->flags.online to 1 before calling
->abort_isp() for starting the ISP reset.

Signed-off-by: Viacheslav Dubeyko <v.dubeiko@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d9072ea7c42b..0a2286e324af 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6872,6 +6872,7 @@ qla2x00_do_dpc(void *data)
 
 			if (do_reset && !(test_and_set_bit(ABORT_ISP_ACTIVE,
 			    &base_vha->dpc_flags))) {
+				base_vha->flags.online = 1;
 				ql_dbg(ql_dbg_dpc, base_vha, 0x4007,
 				    "ISP abort scheduled.\n");
 				if (ha->isp_ops->abort_isp(base_vha)) {
-- 
2.17.1


