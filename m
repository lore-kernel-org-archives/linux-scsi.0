Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6EF2580F2
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 20:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760561602; cv=none; b=INC/bgfafLOUh19wBn7sW55LFiTNCuWDrX6+X8nglbAdPuk3fM1Y/5ItRa8OUELljH5f1OSSh33q2y6pU1ICjqyIDGo5bB8nzQvsphF4vhWFxerDeDowzzYp+Um2DTcP6GHDRCPCFaanKRIbOy+EZ/qqyziDw2Qu1RtcAdOGhFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760561602; c=relaxed/simple;
	bh=1/u59SbTP6ezF4fYE+S2ZAaQ0ANXakWnBDM5Tx8sB5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzjWGRXOHzmDs3YcdTd6W/pGtEutfkC/xpw7fj32tUq2V4okEXYyEOMBHub3QsjZL0pDJ/b9yXOBKnoeD6M/zMBCyD6ewpWR5z1ag9o887chYNd0QyLR+SFetXvDJ4wJUA+dgoFp++gqPBzycVtN4T6WToReJS/xIXs6RnV5sRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T6GkEzMh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T6GkEzMh"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FDhEhQ021827;
	Wed, 15 Oct 2025 20:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WVhCrQQ+hDFAF/+i2
	MFFgHBx+6pm+4RXR9Ev3V7Hi7E=; b=T6GkEzMhl/JyRUZKEKNDC93umohwa36mR
	U9h49bPOpL0S//HJH4o3IME3/npAnniuCADHbhGh9azFb6Kj1TT8xnWvPzSfGgDH
	hyVOhhJdMj0tLF5C3NM3JOyS+PrgibNZf/56bKSWyaq5dm2Zs1NgHRCQd1/m+rMV
	35AcYhdcb6qsFXVKyHDBoS5VVEZ+nbp1hykQh9F7Tab2YvlvqJJlYP4tCB+GuiEu
	Z3yKSgaKzTxs/9annpq8VKsaXdPkaDtgcY3f9oWr4qHFe4dDHMxW/OYDbZFW2FS+
	Va8nqcr9l1bacIpTVz9yWwCuq6Tv68GlIgEs/9r7q5TUSHB++6PUQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qey8xwen-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 20:53:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59FK4JDE015190;
	Wed, 15 Oct 2025 20:53:17 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r1jsan79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 20:53:17 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59FKrFvQ27460296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 20:53:15 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 317B858067;
	Wed, 15 Oct 2025 20:53:15 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB13158062;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
Received: from smith3.rch.stglabs.ibm.com (unknown [9.5.53.254])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
From: wenxiong@linux.ibm.com
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org
Cc: wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.ibm.com>,
        Kyle Mahlkuch <Kyle.Mahlkuch@ibm.com>
Subject: [PATCH 2/2] scsi/qla2xxx: enable/disable IRQD_NO_BALANCING during reset
Date: Wed, 15 Oct 2025 15:53:11 -0500
Message-ID: <20251015205311.122963-3-wenxiong@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: dgZrWaWW4mcvhsvYA-J-AN2-DTzV0r2w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMSBTYWx0ZWRfX0WSZo2r/Mu7r
 IAsd5biaKu9tMSIfpiaVXdI+KJbqlG1rtFQaMwFaZWqTxgYKtmUZgeDIGOsqEPXIO3thkDvVfBL
 e0RZUd0aAYCiXLEGArYRjZRHuSPBw4qcV2bbwNvXlKpK93Pp0Bgf5/tOHS7YWs8gei9dDL4Ru85
 28erTxblA53dMbTLUT4HS/Clcm/+AsV0PpD2VPOWAsoH+zSndJcVw6ktmiq9bfctXjUAncBTnV9
 wIpq5CSPWBn6ykJ8KGLnh/f3RrX8M09m032rHOI8TnWPzK+2e05W7Ci90PYHBcBCKmqZWx5MTY1
 iULUp48lPAiwTV32v2NfQT1Drqt+FzkQfOcTIqNBqB+mZNv0KqGU6d+6qNF9yrscIa/Wd0wb/0Q
 7ErDzRL8mtRHZXwD/ALlToPIkxQq/g==
X-Proofpoint-GUID: dgZrWaWW4mcvhsvYA-J-AN2-DTzV0r2w
X-Authority-Analysis: v=2.4 cv=QZ5rf8bv c=1 sm=1 tr=0 ts=68f009be cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=wblshgo6IW4WqGfu3kEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110011

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

Signed-off-by: Kyle Mahlkuch<Kyle.Mahlkuch@ibm.com>
Signed-off-by: Wen Xiong<wenxiong@linux.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5ffd94586652..3dd8637518be 100644
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
+ * @oa_cfg: pci_dev struct for a qla2xxx device
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
+    int irq, i;
+
+    for (i = 0; i < QLA_BASE_VECTORS; i++) {
+        irq = pci_irq_vector(pdev, i);
+
+        if (flag)
+            irq_set_status_flags(irq, IRQ_NO_BALANCING);
+        else
+            irq_clear_status_flags(irq, IRQ_NO_BALANCING);
+    }
+}
+
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
@@ -7789,6 +7815,8 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		goto out;
 	}
 
+    qla2xxx_set_affinity_nobalance(pdev, false);
+
 	switch (state) {
 	case pci_channel_io_normal:
 		qla_pci_set_eeh_busy(vha);
@@ -7930,6 +7958,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
 	    "Slot Reset returning %x.\n", ret);
 
+    qla2xxx_set_affinity_nobalance(pdev, true);
+
 	return ret;
 }
 
-- 
2.47.3

