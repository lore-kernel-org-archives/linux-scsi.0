Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB00A2D12F5
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 20:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760561603; cv=none; b=kQWUCD8PvEtNobWSdGpOfRLGQNiyJM9vDrqD14uatHhjHPiutj1jPEm/6LNUIO7AvEmWGllpWz3D4RT1Wt5kCAWF8UVBsc2eQ4UznS0Gvma6sX/AEU4k6VuPyYA4nnoYbfxZxQB7v3UtKGI4UUn+HlM6QQPnnq4ISpFFa09txU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760561603; c=relaxed/simple;
	bh=oKu3NRatX+m7pv6epkOO8MCenuQe2bQ6Wan7e9qffgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCRbBlMoRofUNM1KOsUg4lT8aEYvdBPlStMZPa45YMORL/GD6uWbdQE2jPnPnNnZs5+BNVXG9I8PgOYGFjltWaeIz0Sb2SwQ2uCEW2GVMUgt+Crljr5wAUGC/ZtfEXYMOvmgQL5H2i5j1KtPlA2dbVM1XUBGtaGXpKtIBdFh0U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cqdBPF1w; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cqdBPF1w"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FDhB15001256;
	Wed, 15 Oct 2025 20:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5QhWA7OyZMacPEu7E
	cTiVZMBAeivsRQMaFgTU1B7MFI=; b=cqdBPF1wHN8EAacancW0wwXJWyAX2W7D1
	UwJMyFoHmH33QrRJ0dEfzzf3vNuBrpC/85pV6mO4p3iI9NpWpypAeklG1BEenVJH
	ESHLfwfxmi5KQMKSmhawKwN76xhN68cyxx2eoHD8pERKEsr1vn20EVxPpfdeyH5F
	zNqsqggmGOuuLq7mGQFUG8cn/heMPA6mbCFmOq4tWs6bqXuhT8l8yeomcIulFr8x
	8LNDdt+5EcH99QXIgSa54Ge0lSFy0Pw/d5h83a/Tko1XWZL6tbJASnlf8MFD5j5W
	SmkuH7FoqxCvcWu4MoMLMduZiL9CYq2mECZANLhK23MJZ1ri7NdMA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49rfp81qt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 20:53:19 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59FHadtR018894;
	Wed, 15 Oct 2025 20:53:18 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r2jmte9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 20:53:18 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59FKrEL39503330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 20:53:14 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C85AA58066;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73E2858062;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
Received: from smith3.rch.stglabs.ibm.com (unknown [9.5.53.254])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
From: wenxiong@linux.ibm.com
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org
Cc: wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.ibm.com>,
        Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Subject: [PATCH 1/2] scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
Date: Wed, 15 Oct 2025 15:53:10 -0500
Message-ID: <20251015205311.122963-2-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015205311.122963-1-wenxiong@linux.ibm.com>
References: <20251015205311.122963-1-wenxiong@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LhA4sK8lR_8zoSGrZB3ToLdT8b6XJQEo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA4NCBTYWx0ZWRfX8D9NO3uM0aq1
 TOy/oOncYFmJ8x9iYnU3BjZyI3WwUflmo9+KWmVXOEWIbtBZZflZi0W3id/+XLsMcGPs4l/kiGd
 FVCOJSPdciroPKJBfCjACHQu2upAogqE3vSA8ce6+u3JCoRVQ6cE04b6ZYOn4Brdc0ywvws1FB7
 PyTCwd6D9loP6Ko0TUMcHGMdtvi97x70entu03DtBEqgEKCzBk+yMZO7PnZGhHtEai5iLXqn/yN
 ciyTiP6tsBhr2EaH7OlO15UYBtJEaDEhZyHBkrs7z94BxePTsHPwRnrnVMRRoce6NFMGfp4HO2n
 afhjr6O49HkiLreF1hwKM0lKr0kdg6oVyXXV5+vyKXiuyCsLpPOFI+xoMUwgpCFobXUgaHYUI4O
 Cp8xbxG5JYoR3EsoqHhH5VIq9k5x4A==
X-Proofpoint-GUID: LhA4sK8lR_8zoSGrZB3ToLdT8b6XJQEo
X-Authority-Analysis: v=2.4 cv=af5sXBot c=1 sm=1 tr=0 ts=68f009bf cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=qwQndUFV_ZDTNUs8jlYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510120084

From: Wen Xiong <wenxiong@linux.ibm.com>

Issue is:
Dynamic remove/add IPR storage adapter test hits EEH on Powerpc.

EEH: [c00000000004f75c] __eeh_send_failure_event+0x7c/0x160
EEH: [c000000000048444] eeh_dev_check_failure.part.0+0x254/0x650
EEH: [c008000001650678] eeh_readl+0x60/0x90 [ipr]
EEH: [c00800000166746c] ipr_cancel_op+0x2b8/0x524 [ipr]
EEH: [c008000001656524] ipr_eh_abort+0x6c/0x130 [ipr]
EEH: [c000000000ab0d20] scmd_eh_abort_handler+0x140/0x440
EEH: [c00000000017e558] process_one_work+0x298/0x590
EEH: [c00000000017eef8] worker_thread+0xa8/0x620
EEH: [c00000000018be34] kthread+0x124/0x130
EEH: [c00000000000cd64] ret_from_kernel_thread+0x5c/0x64

We took a pcie bus trace and found out that a vector of msix is
cleared to 0 by irqbalance daemon.  If we disable irqbalance
daemon, we won't see the issue on both of adapters.

We enabled debug in ipr driver,
[   44.103071] ipr: Entering __ipr_remove
[   44.103083] ipr: Entering ipr_initiate_ioa_bringdown
[   44.103091] ipr: Entering ipr_reset_shutdown_ioa
[   44.103099] ipr: Leaving ipr_reset_shutdown_ioa
[   44.103105] ipr: Leaving ipr_initiate_ioa_bringdown
[   44.149918] ipr: Entering ipr_reset_ucode_download
[   44.149935] ipr: Entering ipr_reset_alert
[   44.150032] ipr: Entering ipr_reset_start_timer
[   44.150038] ipr: Leaving ipr_reset_alert
[   44.244343] scsi 1:2:3:0: alua: Detached
[   44.254300] ipr: Entering ipr_reset_start_bist
[   44.254320] ipr: Entering ipr_reset_start_timer
[   44.254325] ipr: Leaving ipr_reset_start_bist
[   44.364329] scsi 1:2:4:0: alua: Detached
[   45.134341] scsi 1:2:5:0: alua: Detached
[   45.860949] ipr: Entering ipr_reset_shutdown_ioa
[   45.860962] ipr: Leaving ipr_reset_shutdown_ioa
[   45.860966] ipr: Entering ipr_reset_alert
[   45.861028] ipr: Entering ipr_reset_start_timer
[   45.861035] ipr: Leaving ipr_reset_alert
[   45.964302] ipr: Entering ipr_reset_start_bist
[   45.964309] ipr: Entering ipr_reset_start_timer
[   45.964313] ipr: Leaving ipr_reset_start_bist
[   46.264301] ipr: Entering ipr_reset_bist_done
[   46.264309] ipr: Leaving ipr_reset_bist_done

During adapter reset, ipr device driver blocks config space access but
can't block MMIO access for msix entries.
There is very small window: irqbalance daemon kicks in during adapter
reset before ipr driver calls pci_restore_state(pdev) to restore msix
table.

irqbalance daemon reads back all 0 for that msix vector
in __pci_read_msi_msg().

irqbalance daemon:

msi_domain_set_affinity()
->irq_chip_set_affinity_patent()
->xive_irq_set_affinity()
->irq_chip_compose_msi_msg()
  ->pseries_msi_compose_msg()
  ->__pci_read_msi_msg(): read all 0 since didn't call pci_restore_state
->irq_chip_write_msi_msg()
  -> pci_write_msg_msi(): write 0 to the msix vector entry

When ipr driver call pci_restore_state(pdev) in
ipr_reset_restore_cfg_space(), the msix vector entry
has been cleared by irqbalance daemon in pci_write_msg_msix().

pci_restore_state()
->__pci_restore_msix_state()

Below is the MSIX table for ipr adapter after 'irqbalance"
dameon kicked in during adapter reset

Dump MSIx table: index=0 address_lo=c800 address_hi=10000000 msg_data=0
Dump MSIx table: index=1 address_lo=c810 address_hi=10000000 msg_data=0
Dump MSIx table: index=2 address_lo=c820 address_hi=10000000 msg_data=0
Dump MSIx table: index=3 address_lo=c830 address_hi=10000000 msg_data=0
Dump MSIx table: index=4 address_lo=c840 address_hi=10000000 msg_data=0
Dump MSIx table: index=5 address_lo=c850 address_hi=10000000 msg_data=0
Dump MSIx table: index=6 address_lo=c860 address_hi=10000000 msg_data=0
Dump MSIx table: index=7 address_lo=c870 address_hi=10000000 msg_data=0
Dump MSIx table: index=8 address_lo=0 address_hi=0 msg_data=0
---------> Hit EEH since msix vector of index=8 are 0

Dump MSIx table: index=9 address_lo=c890 address_hi=10000000 msg_data=0
Dump MSIx table: index=10 address_lo=c8a0 address_hi=10000000 msg_data=0
Dump MSIx table: index=11 address_lo=c8b0 address_hi=10000000 msg_data=0
Dump MSIx table: index=12 address_lo=c8c0 address_hi=10000000 msg_data=0
Dump MSIx table: index=13 address_lo=c8d0 address_hi=10000000 msg_data=0
Dump MSIx table: index=14 address_lo=c8e0 address_hi=10000000 msg_data=0
Dump MSIx table: index=15 address_lo=c8f0 address_hi=10000000 msg_data=0

[   46.264312] ipr: Entering ipr_reset_restore_cfg_space
[   46.267439] ipr: Entering ipr_fail_all_ops
[   46.267447] ipr: Leaving ipr_fail_all_ops
[   46.267451] ipr: Leaving ipr_reset_restore_cfg_space
[   46.267454] ipr: Entering ipr_ioa_bringdown_done
[   46.267458] ipr: Leaving ipr_ioa_bringdown_done
[   46.267467] ipr: Entering ipr_worker_thread
[   46.267470] ipr: Leaving ipr_worker_thread

We don't need to do irq balance during adapter reset.
This patch is enabled "IRQ_NO_BALANCING" bit before starting adapter
reset and disabled it after calling pci_restore_state(). irqbalance
daemon is disabled for this period of short time(~2s);

Thanks,
Wendy

Signed-off-by: Wen Xiong<wenxiong@linux.ibm.com>
Signed-off-by: Kyle Mahlkuch<Kyle.Mahlkuch@ibm.com>
---
 drivers/scsi/ipr.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 44214884deaf..af73085d3f00 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7843,6 +7843,30 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
 	return IPR_RC_JOB_RETURN;
 }
 
+/**
+ * ipr_set_affinity_nobalance
+ * @oa_cfg:	ipr_ioa_cfg struct for an ipr device
+ * @flag:	bool
+ *	true: ensable "IRQ_NO_BALANCING" bit for msix interrupt
+ *	false: disable "IRQ_NO_BALANCING" bit for msix interrupt
+ * Description: This function will be called to disable/enable
+ *	"IRQ_NO_BALANCING" to avoid irqbalance daemon
+ *	kicking in during adapter reset.
+ **/
+static void ipr_set_affinity_nobalance(struct ipr_ioa_cfg *ioa_cfg, bool flag)
+{
+	int irq, i;
+
+	for (i = 0; i < ioa_cfg->nvectors; i++) {
+		irq = pci_irq_vector(ioa_cfg->pdev, i);
+
+		if (flag)
+			irq_set_status_flags(irq, IRQ_NO_BALANCING);
+		else
+			irq_clear_status_flags(irq, IRQ_NO_BALANCING);
+	}
+}
+
 /**
  * ipr_reset_restore_cfg_space - Restore PCI config space.
  * @ipr_cmd:	ipr command struct
@@ -7867,6 +7891,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 		return IPR_RC_JOB_CONTINUE;
 	}
 
+	ipr_set_affinity_nobalance(ioa_cfg, false);
 	ipr_fail_all_ops(ioa_cfg);
 
 	if (ioa_cfg->sis64) {
@@ -7946,6 +7971,7 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 		rc = pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
 
 	if (rc == PCIBIOS_SUCCESSFUL) {
+		ipr_set_affinity_nobalance(ioa_cfg, true);
 		ipr_cmd->job_step = ipr_reset_bist_done;
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc = IPR_RC_JOB_RETURN;
-- 
2.47.3

