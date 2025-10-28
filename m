Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE61305946
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761661478; cv=none; b=SdanoreTweLnABumLaXxLuGJeIhtk52SIq/kN6C3nsgYcKwb4SQr2Xf/kbAJwByauT7DBXoZGRLBb24m6xHFqjGAv24r0WX86oK5e6TgD0GaiHiT4oiPvVZh3rlfZ/t22N+UiL8ASZf7Gcie+yQX0MA8O30QfS0GSNQYzZKf/Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761661478; c=relaxed/simple;
	bh=73Yvx43vYob5fJsxrOKLuBhx1MjXCvNADDWjIrFH+KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvlHl07ucvoAus2J0MREDECB/XHAOGDFaCh99d4JrjlzBkwExv0gpZhvzMruMrl84cPcKc0le7QjHVEeLdvKM05z/pIfXc2hWD+bz6/VRmQbBdfEILEn9Bpwa0BsYDdIQ4nAOCMdnSIqyZYvtvODonsyDBp3BNX3jLBeJhtYWI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RAx0u3Rl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RAx0u3Rl"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S43CZw012921;
	Tue, 28 Oct 2025 14:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ol3obO7pvb48+Kbyz
	sB/+v8blPCHFoN3oCA30R8+8aQ=; b=RAx0u3RlPweub+JkqKiRNFpQiBQDssHcE
	6r5ns0HGpzTlvfo2q0r4I5fTMbXqKS6kbluXSdEvsRxCsJmT4h/7I2oaAGHUYIQP
	qmxaoATfgzxh6sqmyWdxZjd9H5NdVh+vtRUMi9ZRrciTS7AEzqcNsh2aKMLbkLXg
	cq4Qj0CQtYjZHAR/bMOOgXBiI/7+vB1YbXrqGX7htm0CFp323ulAy3C8eJ9MPFWQ
	aqDBNfTgSYg5SOwegCB8jMN5WlcEu5DtK/lj3Q2oFvHyzeotvOv0U12C5/F4cj72
	aG+mgx9l8uKJX3F4mPYCQTV4DsCzdTL9Gtak6CKKSfk9QbRb1mUJQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0mys4g5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 14:24:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SC1Q0q022923;
	Tue, 28 Oct 2025 14:24:33 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a198xk9qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 14:24:33 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SEOUu714746140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 14:24:30 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DBF55805F;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C43D58055;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
Received: from smith3.rch.stglabs.ibm.com (unknown [9.5.53.254])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
From: wenxiong@linux.ibm.com
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org
Cc: wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.ibm.com>,
        Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Subject: [PATCH 1/2 V2] scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
Date: Tue, 28 Oct 2025 09:24:26 -0500
Message-ID: <20251028142427.3969819-2-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
References: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dybMOwLXik8-ezVA4RWreIH9T91HCHBO
X-Authority-Analysis: v=2.4 cv=ct2WUl4i c=1 sm=1 tr=0 ts=6900d222 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=ZBJG0XUEm_4NwuyEQkcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMCBTYWx0ZWRfX5I08BPMxVXQ4
 7zTwyI00543tCNlpV8knX0Hv0puVReQFazGl6ZZaRoTnSsh1ObnR2kJ7NNdJ1GpBMUsDkyG3tnN
 XGbxbunodY++U1IABdlQbogVjcHVecdVD9lAJzeZ/9DKy4OKQ06Brlmc4V/+hVR3x1yXS7yHiuq
 5+R6sc98g6XyibbMkrfPkhQD4wOKxo5tDiIdIOgyl9aFIb0G0Q9AwnEJqlMkfgve/3lHP40zdb0
 OGS8du7MRl1KYT2DsAP8qg1Y1r93kFDYbbGmT4nMmAoZsmqQ36B9VFLfTvSsZ5nFFnweCI2Z/jz
 y3ZNm/38+Qo3FVfhKVQgsSQvn2z9SvitvvmqKfLEqIDW38uKenDKPcAnzESOkiO/ZPl6GJX8A9e
 DGGJjcH3Jo1Mhhf5HzJ4VJ2unVSIpQ==
X-Proofpoint-GUID: dybMOwLXik8-ezVA4RWreIH9T91HCHBO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 spamscore=0 adultscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250010

From: Wen Xiong <wenxiong@linux.ibm.com>

Issue is:
Dynamic remove/add storage adapter(SCSI IPR and FC Qlogic) test
hits EEH on Powerpc.

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

Signed-off-by: Wen Xiong <wenxiong@linux.ibm.com>
Signed-off-by: Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
---
 drivers/scsi/ipr.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 4fb5654472d8..4eaca8777630 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -61,8 +61,8 @@
 #include <linux/hdreg.h>
 #include <linux/reboot.h>
 #include <linux/stringify.h>
+#include <linux/irq.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/processor.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -7843,6 +7843,30 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ipr_cmd)
 	return IPR_RC_JOB_RETURN;
 }
 
+/**
+ * ipr_set_affinity_nobalance
+ * @ioa_cfg:	ipr_ioa_cfg struct for an ipr device
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

