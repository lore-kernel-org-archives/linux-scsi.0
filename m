Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30622C83019
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDDEF2224C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbgLBN1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:27:34 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729901AbgLBN1b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:27:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DP47I002238
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:26:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=FaMyb90xSQlfEqV4kGWZ9fEoO74qe3PQ7Xob1GTocOs=;
 b=ixqzEjslI0U9MjulEs7pl0w9w6Oj6b3cn3xHKdfXWZvKQmrKt6ZF2eJZQZyG4fNffO1K
 hDJdSWlq3WKBwKmfigriPR3pcIwgA3C3G5Oh29WnZY7Q3l4hOU08qS7bW0KyVVb5K2jz
 RSCbysDqyE07BjUZu6sYQ6h9LIEsiuWap5LBYl+6RjVXDLKgeYhGd68eG8ALgHE98gtu
 6PKsk6xwcx3Y3Z7ShtSkb/ArdjnUqj2pW0Xw+wHX0DtL/sG0hdfEFZtslpAjNwXKHqlN
 Qm6nrXPokfiPmqmrjSzgqe6X+4ZdCj58AfN/QaU3+PvFkbPKD72C4jdNSWeg0IICxEil hQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8g06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:26:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:26:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:26:50 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F09883F703F;
        Wed,  2 Dec 2020 05:26:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DQnCW020066;
        Wed, 2 Dec 2020 05:26:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DQnqf020065;
        Wed, 2 Dec 2020 05:26:49 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 08/15] qla2xxx: Fix FW initialization error on big endian machines
Date:   Wed, 2 Dec 2020 05:23:05 -0800
Message-ID: <20201202132312.19966-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Some fields are not correctly byte swapped causing failure
during initialization. As probe() returns failure, HBAs
will not be claimed when this happens.

qla2xxx [0007:01:00.0]-ffff:3: Secure Flash Update in FW: Supported
qla2xxx [0007:01:00.0]-ffff:3: SCM in FW: Supported
qla2xxx [0007:01:00.0]-00d2:3: Init Firmware **** FAILED ****.
qla2xxx [0007:01:00.0]-00d6:3: Failed to initialize adapter - Adapter flags 2.
qla2xxx 0007:01:00.1: enabling device (0140 -> 0142)
qla2xxx [0007:01:00.1]-011c: : MSI-X vector count: 128.
qla2xxx [0007:01:00.1]-001d: : Found an ISP2289 irq 18 iobase 0xd000080080004000.
qla2xxx 0007:01:00.1: Using 64-bit direct DMA at offset 800000000000000
BUG: Bad page state in process insmod  pfn:67118 page:f00000000168bd40
count:-1 mapcount:0 mapping: (null) index:0x0
page flags: 0x3ffff800000000() page dumped because: nonzero _count
Modules linked in: qla2xxx(OE+) nvme_fc nvme_fabrics
	nvme_core scsi_transport_fc scsi_tgt nls_utf8 isofs ip6t_rpfilter
	ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
	nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat
	nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle
	ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4
	nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
	iptable_security iptable_raw ebtable_filter ebtables ip6table_filter
	ip6_tables iptable_filter nx_crypto ses enclosure scsi_transport_sas
	pseries_rng sg ip_tables xfs libcrc32c sr_mod cdrom sd_mod crc_t10dif
	crct10dif_generic crct10dif_common usb_storage ipr libata tg3 ptp
	pps_core dm_mirror dm_region_hash dm_log dm_mod
CPU: 32 PID: 8560 Comm: insmod Kdump: loaded Tainted: G
	OE  ------------   3.10.0-957.el7.ppc64 #1
Call Trace:
[c0000006dd7caa70] [c00000000001cca8] .show_stack+0x88/0x330 (unreliable)
[c0000006dd7cab30] [c000000000ac3d88] .dump_stack+0x28/0x3c
[c0000006dd7caba0] [c00000000029e48c] .bad_page+0x15c/0x1c0
[c0000006dd7cac40] [c00000000029f938] .get_page_from_freelist+0x11e8/0x1ea0
[c0000006dd7caf40] [c0000000002a1d30] .__alloc_pages_nodemask+0x1c0/0xc70
[c0000006dd7cb140] [c00000000002ba0c] .__dma_direct_alloc_coherent+0x8c/0x170
[c0000006dd7cb1e0] [d000000010a94688] .qla2x00_mem_alloc+0x10f8/0x1370 [qla2xxx]
[c0000006dd7cb2d0] [d000000010a9c790] .qla2x00_probe_one+0xb60/0x22e0 [qla2xxx]
[c0000006dd7cb540] [c0000000005de764] .pci_device_probe+0x204/0x300
[c0000006dd7cb600] [c0000000006ca61c] .driver_probe_device+0x2cc/0x6f0
[c0000006dd7cb6b0] [c0000000006cabec] .__driver_attach+0x10c/0x110
[c0000006dd7cb740] [c0000000006c5f04] .bus_for_each_dev+0x94/0x100
[c0000006dd7cb7e0] [c0000000006c94f4] .driver_attach+0x34/0x50
[c0000006dd7cb860] [c0000000006c8f58] .bus_add_driver+0x298/0x3b0
[c0000006dd7cb900] [c0000000006cb6e0] .driver_register+0xb0/0x1a0
[c0000006dd7cb980] [c0000000005dc474] .__pci_register_driver+0xc4/0xf0
[c0000006dd7cba10] [d000000010b94e20] .qla2x00_module_init+0x2a8/0x328 [qla2xxx]
[c0000006dd7cbaa0] [c00000000000c130] .do_one_initcall+0x130/0x2e0
[c0000006dd7cbb50] [c0000000001b2e8c] .load_module+0x1afc/0x2340
[c0000006dd7cbd40] [c0000000001b3920] .SyS_finit_module+0xd0/0x130
[c0000006dd7cbe30] [c00000000000a284] 	system_call+0x38/0xfc

Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
Fixes: cf3c54fb49a4 ("scsi: qla2xxx: Add SLER and PI control support”)
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 40af7f1524ce..1b4261c3c476 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1129,7 +1129,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		if (ha->flags.scm_supported_a &&
 		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_SCM_SUPPORTED)) {
 			ha->flags.scm_supported_f = 1;
-			ha->sf_init_cb->flags |= BIT_13;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_13);
 		}
 		ql_log(ql_log_info, vha, 0x11a3, "SCM in FW: %s\n",
 		       (ha->flags.scm_supported_f) ? "Supported" :
@@ -1137,9 +1137,9 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 
 		if (vha->flags.nvme2_enabled) {
 			/* set BIT_15 of special feature control block for SLER */
-			ha->sf_init_cb->flags |= BIT_15;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_15);
 			/* set BIT_14 of special feature control block for PI CTRL*/
-			ha->sf_init_cb->flags |= BIT_14;
+			ha->sf_init_cb->flags |= cpu_to_le16(BIT_14);
 		}
 	}
 
-- 
2.19.0.rc0

