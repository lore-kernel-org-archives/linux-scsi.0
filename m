Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AD6223324
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761661478; cv=none; b=OUilkke10Iekcowgi7SEICnLXWf27FYx44VblecXG1k7VMgzS414n0nixbJ5d6buEK+CmEmusAxL1A3P61BsrOIKHUZJzgXlofeRrBXxv+mVpw8ixrLetfShG7kiXkVKPJ6A8/CPasoHLsrYq96eIXdDnkikMlceilcFYL4pPGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761661478; c=relaxed/simple;
	bh=zckipcHnpjqBs+M2WFhGvtfsholtks6C9NHB5gSXoBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIDCt0GVaAcx9uLAx9As6hC7ugyRwLL7SbNyZFRkQaCu5Z8L7cBXF1RKnlZS5tlN/CFQRsbg5rqI4Zj+VQmsmqBTwYTKIG1yG/x4T8bC8VG+ipDSBZtxm/kkWUeTm++odhMQExKlBMd6bJsLMPq3+/SWHl4xJvMJFkZJUuhtVUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f0sCXNBG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f0sCXNBG"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SE0JjM023398;
	Tue, 28 Oct 2025 14:24:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TQuNFy3q19hQEsIsC
	KXx9c+hOxWdkfM/2d6mzx2Hve8=; b=f0sCXNBGpNLvRe7X7Ffqn5AdXBAyCNbEe
	zUe75yWfus61E7G+HzwuVpbiZlZpl2uWj8h3in5DHLM+DyWWkC+s1G/xA0keMhVp
	dRe8mKPQjJokLfxh2LrfwqSkI+ftdNoRu3l0KS+PpDYM5bALZbEHpFmMnZB1brSp
	gw72nAnEWAcq3o1J6y7ESMCOaS5v9uBd4LKwMU327UT05OHyWv2vpz1aKBMLFzBz
	DM4DDn8mHT60fvHcxJ9k3/fybHjNvRB+9G98vNLjqoxDSX9wIrXGu1rMS7Sl85uO
	lzVxh8z16kjWqnTe7I/rekSeKXRh4HF0LJ0YhvimjI4uoI4/ZCXng==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0p724brg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 14:24:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBQNQ1022023;
	Tue, 28 Oct 2025 14:24:33 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a18vs3byf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 14:24:33 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SEOVOe23397064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 14:24:31 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7F0D58043;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FE7F58055;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
Received: from smith3.rch.stglabs.ibm.com (unknown [9.5.53.254])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
From: wenxiong@linux.ibm.com
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org
Cc: wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.ibm.com>,
        Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Subject: [PATCH 2/2 V2] scsi/qla2xxx: enable/disable IRQD_NO_BALANCING during reset
Date: Tue, 28 Oct 2025 09:24:27 -0500
Message-ID: <20251028142427.3969819-3-wenxiong@linux.ibm.com>
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
X-Proofpoint-GUID: x8aKQG4citwx4Zf3LBE0AlDD36569-vT
X-Proofpoint-ORIG-GUID: x8aKQG4citwx4Zf3LBE0AlDD36569-vT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAyNCBTYWx0ZWRfXyaIQmIB12DWT
 exXQ4FA7Ct0LH6YMaFTN2YKgss9N6N+AnIncu2he9AON1irS2MPa6OVesIHMW49r0EnwzhJWL63
 lqj+YQuo5CdsuQa4hgKjWe+Voq5vWw4Z6GPkt9NvwO2eTrcVI9EpITFQnsscE6kScGGR1Pj307s
 2KV//b/nc3/F2dAnBrwJawg+vK5aXALtatphuKzGKMQSIK18hZfnZoyiVvBzbL1X8kqStwzAZlS
 mnJ4bzgL/dk+7meH8zLJUL6zY8xBIUZkIooTfI7KLv+EyF+nNIqEadwrYxKZn9Q0CMfb4SVJhNT
 ng1NAMlzMFDIAE1hrYmKH48UI+hpIEAcGAS882ONZCJhReDm2Ml20yyDXCkBEJ8626WnlVWfFbU
 tMS5d5SY1UKo4zIfCzpUViyRJ87m4g==
X-Authority-Analysis: v=2.4 cv=G/gR0tk5 c=1 sm=1 tr=0 ts=6900d222 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=wblshgo6IW4WqGfu3kEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250024

From: Wen Xiong <wenxiong@linux.ibm.com>

Issue is:
Dynamic remove/add of FC Qlogic storage adapters test hits EEH on Powerpc.

EEH: [c00000000004f77c] __eeh_send_failure_event+0x7c/0x160
EEH: [c000000000048464] eeh_dev_check_failure.part.0+0x254/0x660
EEH: [c000000000934e0c] __pci_read_msi_msg+0x1ac/0x280
EEH: [c000000000100f68] pseries_msi_compose_msg+0x28/0x40
EEH: [c00000000020e1cc] irq_chip_compose_msi_msg+0x5c/0x90
EEH: [c000000000214b1c] msi_domain_set_affinity+0xbc/0x100
EEH: [c000000000206be4] irq_do_set_affinity+0x214/0x2c0
EEH: [c000000000206e04] irq_set_affinity_locked+0x174/0x230
EEH: [c000000000207044] irq_set_affinity+0x64/0xa0
EEH: [c000000000212890] write_irq_affinity.constprop.0.isra.0+0x130/0x150
EEH: [c00000000068868c] proc_reg_write+0xfc/0x160
EEH: [c0000000005adb48] vfs_write+0xf8/0x4e0
EEH: [c0000000005ae234] ksys_write+0x84/0x140
EEH: [c00000000002e994] system_call_exception+0x164/0x310
EEH: [c00000000000bfe8] system_call_vectored_common+0xe8/0x278

We see that irqbalance daemon kicks in before invoking qla2xxx->slot_reset
during the EEH recovery process.

irqbalance daemon
->irq_set_affinity()
->msi_domain_set_affinity()
->irq_chip_set_affiinity_parent()
->xive_irq_set_affinity()
->pseries_msi_compose_ms()
->__pci_read_msi_msg()
->irq_chip_compose_msi_msg()

In __pci_read_msi_msg(), we see the first msix vector is set to all F by the
irqbalance daemon.
pci_write_msg_msix: index=0, lo=ffffffff hi=fffffff

We tried disabling the irqbalance daemon, then ran the DLPAR remove/add
test and the test completed succesfully.

We don't need to do irq balance during adapter reset.
This patch enables "IRQ_NO_BALANCING" bit before starting adapter
reset and disables the bit after calling pci_restore_state(). The irqbalance
daemon is disabled for this short period of ~2s.

Thanks,
Kyle

Signed-off-by: Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Signed-off-by: Wen Xiong <wenxiong@linux.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9a2f328200ab..c5e91f5779e8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -17,6 +17,7 @@
 #include <linux/crash_dump.h>
 #include <linux/trace_events.h>
 #include <linux/trace.h>
+#include <linux/irq.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -7771,6 +7772,31 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 }
 
 
+/**
+ * qla2xxx_set_affinity_nobalance
+ * @pdev: pci_dev struct for a qla2xxx device
+ * @flag: bool
+ * true: enable "IRQ_NO_BALANCING" bit for msix interrupt
+ * false: disable "IRQ_NO_BALANCING" bit for msix interrupt
+ * Description: This function will be called to disable/enable
+ * "IRQ_NO_BALANCING" to avoid irqbalance daemon
+ * kicking in during adapter reset.
+ **/
+
+static void qla2xxx_set_affinity_nobalance(struct pci_dev *pdev, bool flag)
+{
+	int irq, i;
+
+	for (i = 0; i < QLA_BASE_VECTORS; i++) {
+		irq = pci_irq_vector(pdev, i);
+
+		if (flag)
+			irq_set_status_flags(irq, IRQ_NO_BALANCING);
+		else
+			irq_clear_status_flags(irq, IRQ_NO_BALANCING);
+	}
+}
+
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
@@ -7789,6 +7815,8 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		goto out;
 	}
 
+	qla2xxx_set_affinity_nobalance(pdev, false);
+
 	switch (state) {
 	case pci_channel_io_normal:
 		qla_pci_set_eeh_busy(vha);
@@ -7935,6 +7963,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
 	    "Slot Reset returning %x.\n", ret);
 
+	qla2xxx_set_affinity_nobalance(pdev, true);
+
 	return ret;
 }
 
-- 
2.47.3

