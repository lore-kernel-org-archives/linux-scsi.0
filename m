Received: from mail.cybernetics.com (mail.cybernetics.com [173.71.130.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787931C589
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 18:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.71.130.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357417; cv=none; b=H8u/61aZA+QwNKlQ2pPvAirFRk0UbeiasHyqGNB7YWP2dioLlQMNwR+qF1aJMjmbMSf3bjc2ovqTajAwR5bhzWfWKLm2ewI7iIg68A3VfbLH6zUO+kEHSyPOedrOHXPEf6r1WZI8LbYHijK0gZCvz0i4opJ024HFBzUrnwFTvEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357417; c=relaxed/simple;
	bh=ARRb9M+RsIZoRhRWZz6vGb0OTx21D88cMuGN9IS0+y0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Wasxh7N3yJOApcq2oSxULMgeT5txAvUsqIC+870c3uRfiQJBfuzYnM7sjkgSByct8d98TfrMp6jB219I4Y570GdlyEAnFsx+J9tLnOzNXVVoj2u8QnrGRdaI7eJa1zJivH1OF7ydtvawFaHlPjFMYPtyFNSAPWtn9tWtQYceh4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=khk1d1Xm; arc=none smtp.client-ip=173.71.130.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="khk1d1Xm"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id nXuyO1kWQa3juZlS; Mon, 08 Sep 2025 14:50:14 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=hktFZ1r224ixi9BOVjvIwDq8eEQbEpqyMKaK9gIPYTQ=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Cc:To:From:
	Content-Language:Subject:MIME-Version:Date:Message-ID; b=khk1d1XmHWywqTzcJY7T
	gsKTntK+D6hIBgBy5AVVIWC8vdQCh13g09lOeQ7ibUaC40YM9w7mdXu1eJtlTScK2GoLAlWjKNU+k
	6XNp6q4ERHPk52inQ/3a3b+j5vosRNnIe7eQqupyOUXXKqwCpk0Il6Gk6+YnI/eomnrRYrm4j4=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14189123; Mon, 08 Sep 2025 14:50:14 -0400
Message-ID: <3572eea7-a6ef-46b4-8bdc-d0da72fd4b3c@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Mon, 8 Sep 2025 14:50:14 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 03/15] scsi: qla2xxx: fix lost interrupts with
 qlini_mode=disabled
Content-Language: en-US
X-ASG-Orig-Subj: [PATCH 03/15] scsi: qla2xxx: fix lost interrupts with
 qlini_mode=disabled
From: Tony Battersby <tonyb@cybernetics.com>
To: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
In-Reply-To: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1757357414
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 0
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 7250
X-ASG-Debug-ID: 1757357414-1cf43947df30c2d0001-ziuLRu

(target mode)

When qla2xxx is loaded with qlini_mode=disabled,
ha->flags.disable_msix_handshake is used before it is set, resulting in
the wrong interrupt handler being used on certain HBAs
(qla2xxx_msix_rsp_q_hs() is used when qla2xxx_msix_rsp_q() should be
used).  The only difference between these two interrupt handlers is
that the _hs() version writes to a register to clear the "RISC"
interrupt, whereas the other version does not.  So this bug results in
the RISC interrupt being cleared when it should not be.  This
occasionally causes a different interrupt handler
qla24xx_msix_default() for a different vector to see ((stat &
HSRX_RISC_INT) == 0) and ignore its interrupt, which then causes
problems like:

qla2xxx [0000:02:00.0]-d04c:6: MBX Command timeout for cmd 20,
  iocontrol=8 jiffies=1090c0300 mb[0-3]=[0x4000 0x0 0x40 0xda] mb7 0x500
  host_status 0x40000010 hccr 0x3f00
qla2xxx [0000:02:00.0]-101e:6: Mailbox cmd timeout occurred, cmd=0x20,
  mb[0]=0x20. Scheduling ISP abort
(the cmd varies; sometimes it is 0x20, 0x22, 0x54, 0x5a, 0x5d, or 0x6a)

This problem can be reproduced with a 16 or 32 Gbps HBA by loading
qla2xxx with qlini_mode=disabled and running a high IOPS test
while triggering frequent RSCN database change events.

While analyzing the problem I discovered that even with
disable_msix_handshake forced to 0, it is not necessary to clear the
RISC interrupt from qla2xxx_msix_rsp_q_hs() (more below).  So just
completely remove qla2xxx_msix_rsp_q_hs() and the logic for selecting
it, which also fixes the bug with qlini_mode=disabled.

The test below describes the justification for not needing
qla2xxx_msix_rsp_q_hs():

Force disable_msix_handshake to 0:
qla24xx_config_rings():
if (0 && (ha->fw_attributes & BIT_6) && (IS_MSIX_NACK_CAPABLE(ha)) &&
    (ha->flags.msix_enabled)) {

In qla24xx_msix_rsp_q() and qla2xxx_msix_rsp_q_hs(), check:
  (rd_reg_dword(&reg->host_status) & HSRX_RISC_INT)

Count the number of calls to each function with HSRX_RISC_INT set and
the number with HSRX_RISC_INT not set while performing some I/O.

If qla2xxx_msix_rsp_q_hs() clears the RISC interrupt (original code):
qla24xx_msix_rsp_q:    50% of calls have HSRX_RISC_INT set
qla2xxx_msix_rsp_q_hs:  5% of calls have HSRX_RISC_INT set
(# of qla2xxx_msix_rsp_q_hs interrupts) =
    (# of qla24xx_msix_rsp_q interrupts) * 3

If qla2xxx_msix_rsp_q_hs() does not clear the RISC interrupt (patched
code):
qla24xx_msix_rsp_q:    100% of calls have HSRX_RISC_INT set
qla2xxx_msix_rsp_q_hs:   9% of calls have HSRX_RISC_INT set
(# of qla2xxx_msix_rsp_q_hs interrupts) =
    (# of qla24xx_msix_rsp_q interrupts) * 3

In the case of the original code, qla24xx_msix_rsp_q() was seeing
HSRX_RISC_INT set only 50% of the time because qla2xxx_msix_rsp_q_hs()
was clearing it when it shouldn't have been.  In the patched code,
qla24xx_msix_rsp_q() sees HSRX_RISC_INT set 100% of the time, which
makes sense if that interrupt handler needs to clear the RISC interrupt
(which it does).  qla2xxx_msix_rsp_q_hs() sees HSRX_RISC_INT only 9% of
the time, which is just overlap from the other interrupt during the
high IOPS test.

Tested with SCST on:
QLE2742  FW:v9.08.02 (32 Gbps 2-port)
QLE2694L FW:v9.10.11 (16 Gbps 4-port)
QLE2694L FW:v9.08.02 (16 Gbps 4-port)
QLE2672  FW:v8.07.12 (16 Gbps 2-port)
both initiator and target mode

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_gbl.h |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 32 +++-----------------------------
 drivers/scsi/qla2xxx/qla_mid.c |  4 +---
 4 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb95b7b12051..b3265952c4be 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3503,7 +3503,6 @@ struct isp_operations {
 #define QLA_MSIX_RSP_Q			0x01
 #define QLA_ATIO_VECTOR		0x02
 #define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x03
-#define QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS	0x04
 
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 145defc420f2..55d531c19e6b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -766,7 +766,7 @@ extern int qla2x00_dfs_remove(scsi_qla_host_t *);
 
 /* Globa function prototypes for multi-q */
 extern int qla25xx_request_irq(struct qla_hw_data *, struct qla_qpair *,
-	struct qla_msix_entry *, int);
+	struct qla_msix_entry *);
 extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c4c6b5c6658c..a3971afc2dd1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4467,32 +4467,6 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-irqreturn_t
-qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
-{
-	struct qla_hw_data *ha;
-	struct qla_qpair *qpair;
-	struct device_reg_24xx __iomem *reg;
-	unsigned long flags;
-
-	qpair = dev_id;
-	if (!qpair) {
-		ql_log(ql_log_info, NULL, 0x505b,
-		    "%s: NULL response queue pointer.\n", __func__);
-		return IRQ_NONE;
-	}
-	ha = qpair->hw;
-
-	reg = &ha->iobase->isp24;
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	queue_work(ha->wq, &qpair->q_work);
-
-	return IRQ_HANDLED;
-}
-
 /* Interrupt handling helpers. */
 
 struct qla_init_msix_entry {
@@ -4505,7 +4479,6 @@ static const struct qla_init_msix_entry msix_entries[] = {
 	{ "rsp_q", qla24xx_msix_rsp_q },
 	{ "atio_q", qla83xx_msix_atio_q },
 	{ "qpair_multiq", qla2xxx_msix_rsp_q },
-	{ "qpair_multiq_hs", qla2xxx_msix_rsp_q_hs },
 };
 
 static const struct qla_init_msix_entry qla82xx_msix_entries[] = {
@@ -4792,9 +4765,10 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 }
 
 int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
-	struct qla_msix_entry *msix, int vector_type)
+	struct qla_msix_entry *msix)
 {
-	const struct qla_init_msix_entry *intr = &msix_entries[vector_type];
+	const struct qla_init_msix_entry *intr =
+		&msix_entries[QLA_MSIX_QPAIR_MULTIQ_RSP_Q];
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	int ret;
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 8b71ac0b1d99..0abc47e72e0b 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -899,9 +899,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	    rsp->options, rsp->id, rsp->rsp_q_in,
 	    rsp->rsp_q_out);
 
-	ret = qla25xx_request_irq(ha, qpair, qpair->msix,
-		ha->flags.disable_msix_handshake ?
-		QLA_MSIX_QPAIR_MULTIQ_RSP_Q : QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS);
+	ret = qla25xx_request_irq(ha, qpair, qpair->msix);
 	if (ret)
 		goto que_failed;
 
-- 
2.43.0


