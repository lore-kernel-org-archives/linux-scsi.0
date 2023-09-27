Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453B6CE7A8B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 04:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjI0EKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 00:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjI0EJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 00:09:33 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E18448C
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2023 20:36:09 -0700 (PDT)
X-UUID: fb040b625ce611ee8051498923ad61e6-20230927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QY8wTZWBh0Cu35+gt0igMLXPa6Vr9TYelNtjwTezN4Y=;
        b=fHHyxCiIRpD4hP/HyyoPl8N5frakhKuDD+c4a9vFboqRCFk1VWa35DEXN58nVXe71NkITpgqQ3PiqBuHP3J4hPTPOu2B0RAl3b6dEHqiKybVz/1OhWkjdwAlecAx4OpzayPfGPnV0H5s//RvqCQuVPf2aM6L1EdYBAYZ6QJ/W2E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:d4d949a1-d20b-4ceb-b8c5-09f5ab662ba4,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:776e6b14-4929-4845-9571-38c601e9c3c9,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: fb040b625ce611ee8051498923ad61e6-20230927
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 21433892; Wed, 27 Sep 2023 11:36:01 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 27 Sep 2023 11:36:00 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 27 Sep 2023 11:36:00 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
        <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>
Subject: [PATCH v5] ufs: core: wlun send SSU timeout recovery
Date:   Wed, 27 Sep 2023 11:35:57 +0800
Message-ID: <20230927033557.13801-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--1.982800-8.000000
X-TMASE-MatchedRID: txJkgVt2LQAMQLXc2MGSbEKcYi5Qw/RVaN2KuTwsCwIGW3hFnC9N1XVi
        1hAU/d+eLiiu988wpnv6XP0KNPsN+xXfDcvxC40Q0Xw0ILvo/uV+tO36GYDlsruqk4cq52pz8R2
        RsKRNAl33RDlj++r10gG2ORx9EyapKc+6Aaw3enmrVklnbP5Jtn0tCKdnhB58k4rY1r+vswgXvQ
        kGi3tjz/cUt5lc1lLgKIzdZS3ou0W8241FL2hxML1ccGegns0wJiJB6FMX2gKghkaAgQH3kY5Tm
        ctR+5kToOAaijm225g6sj43Zt+ZdH80Ey2I90n2o+mBAiSUmlt5lSmbrC6fdtr/To2FgNrjDLMI
        OOVTHz12N6Rg5qIpOg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.982800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 2380C98A8E4F0699B9DE8648C946633CB6D3CEA3E10ABAAD2EEDD7252CC8FEF52000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

When runtime pm send SSU times out, the SCSI core invokes
eh_host_reset_handler, which hooks function ufshcd_eh_host_reset_handler
schedule eh_work and stuck at wait flush_work(&hba->eh_work).
However, ufshcd_err_handler hangs in wait rpm resume.
Do link recovery only in this case.
Below is IO hang stack dump in kernel-6.1

kworker/4:0     D
<ffffffd7d31f6fb4> __switch_to+0x180/0x344
<ffffffd7d31f779c> __schedule+0x5ec/0xa14
<ffffffd7d31f7c3c> schedule+0x78/0xe0
<ffffffd7d31fefbc> schedule_timeout+0xb0/0x15c
<ffffffd7d31f8120> io_schedule_timeout+0x48/0x70
<ffffffd7d31f8e40> do_wait_for_common+0x108/0x19c
<ffffffd7d31f837c> wait_for_completion_io_timeout+0x50/0x78
<ffffffd7d2876bc0> blk_execute_rq+0x1b8/0x218
<ffffffd7d2b4297c> scsi_execute_cmd+0x148/0x238
<ffffffd7d2da7358> ufshcd_set_dev_pwr_mode+0xe8/0x244
<ffffffd7d2da7e40> __ufshcd_wl_resume+0x1e0/0x45c
<ffffffd7d2da7b28> ufshcd_wl_runtime_resume+0x3c/0x174
<ffffffd7d2b4f290> scsi_runtime_resume+0x7c/0xc8
<ffffffd7d2ae1d48> __rpm_callback+0xa0/0x410
<ffffffd7d2ae0128> rpm_resume+0x43c/0x67c
<ffffffd7d2ae1e98> __rpm_callback+0x1f0/0x410
<ffffffd7d2ae014c> rpm_resume+0x460/0x67c
<ffffffd7d2ae1450> pm_runtime_work+0xa4/0xac
<ffffffd7d22e39ac> process_one_work+0x208/0x598
<ffffffd7d22e3fc0> worker_thread+0x228/0x438
<ffffffd7d22eb038> kthread+0x104/0x1d4
<ffffffd7d22171a0> ret_from_fork+0x10/0x20

scsi_eh_0       D
<ffffffd7d31f6fb4> __switch_to+0x180/0x344
<ffffffd7d31f779c> __schedule+0x5ec/0xa14
<ffffffd7d31f7c3c> schedule+0x78/0xe0
<ffffffd7d31fef50> schedule_timeout+0x44/0x15c
<ffffffd7d31f8e40> do_wait_for_common+0x108/0x19c
<ffffffd7d31f8234> wait_for_completion+0x48/0x64
<ffffffd7d22deb88> __flush_work+0x260/0x2d0
<ffffffd7d22de918> flush_work+0x10/0x20
<ffffffd7d2da4728> ufshcd_eh_host_reset_handler+0x88/0xcc
<ffffffd7d2b41da4> scsi_try_host_reset+0x48/0xe0
<ffffffd7d2b410fc> scsi_eh_ready_devs+0x934/0xa40
<ffffffd7d2b41618> scsi_error_handler+0x168/0x374
<ffffffd7d22eb038> kthread+0x104/0x1d4
<ffffffd7d22171a0> ret_from_fork+0x10/0x20

kworker/u16:5   D
<ffffffd7d31f6fb4> __switch_to+0x180/0x344
<ffffffd7d31f779c> __schedule+0x5ec/0xa14
<ffffffd7d31f7c3c> schedule+0x78/0xe0
<ffffffd7d2adfe00> rpm_resume+0x114/0x67c
<ffffffd7d2adfca8> __pm_runtime_resume+0x70/0xb4
<ffffffd7d2d9cf48> ufshcd_err_handler+0x1a0/0xe68
<ffffffd7d22e39ac> process_one_work+0x208/0x598
<ffffffd7d22e3fc0> worker_thread+0x228/0x438
<ffffffd7d22eb038> kthread+0x104/0x1d4
<ffffffd7d22171a0> ret_from_fork+0x10/0x20

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..0619cefa092e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7716,6 +7716,20 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 
 	hba = shost_priv(cmd->device->host);
 
+	/*
+	 * If runtime pm send SSU and got timeout, scsi_error_handler
+	 * stuck at this function to wait for flush_work(&hba->eh_work).
+	 * And ufshcd_err_handler(eh_work) stuck at wait for runtime pm active.
+	 * Do ufshcd_link_recovery instead schedule eh_work can prevent
+	 * dead lock to happen.
+	 */
+	if (hba->pm_op_in_progress) {
+		if (ufshcd_link_recovery(hba))
+			err = FAILED;
+
+		return err;
+	}
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
 	ufshcd_schedule_eh_work(hba);
-- 
2.18.0

