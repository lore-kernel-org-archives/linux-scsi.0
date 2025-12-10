Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF872618;
	Wed, 10 Dec 2025 03:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338568; cv=none; b=q8VRGEKN+KkSaDE2LA2EfL++HQbA9Ocf455Qt2Ph8JBZiwgAWzPxbLuBPLEuNfeK+Oa0rZGO60Y2w25W7aEzXHlex0aUhPa4g1iTHdazGftBvitXl1TtxFezFVKtSRASr2DYPVgpzVG0ntw7O4++TXkpjnSFXzuMM5lwRxehRyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338568; c=relaxed/simple;
	bh=WxkIiow76bQGsbppUhoe5pUBx/TxNFumMikbrP/ed/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMGvGv2cY10NsTytbsJnMfrsXFpFdpf8RRWThcwyFIt7cMpGdDqOV+TXlag/mjA/OXxjpNRqNWeMrf/CMK9e5ZXh2HHQvE1wBO9VEMcVYU/DPlKPbW+DP/PSAerHEIxRtQbmz1YgUNjctccYT+56ltEdRaZf+kKx9e9MUZVXvA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljpg+AuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljpg+AuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B61CC4CEF1;
	Wed, 10 Dec 2025 03:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338567;
	bh=WxkIiow76bQGsbppUhoe5pUBx/TxNFumMikbrP/ed/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljpg+AuKiCBLNoiQ9NAlTGohRedyK+EMxHTZYLkjatoZAHwrNdS/UuI7Q3TPsuFnF
	 qkABdelJ6zERPJM0j41U1vBPOp4tEYMW8mpHPDVt/FgrK6ERozh5OZBkNt/1hmTsTY
	 kt+NxfgWRLatT2wauM4WYuO/FhkCaBDPUHTDWMEXMkrpDTldpcUkHFNHkaNhP+JYjd
	 tPksn66jgzAKwf81y7lX6GotAljBIfyRrU65EboujG7TnhWffxPayz6v9GS/76Ce+I
	 bFEjB0XZXtGV7cITN+7g0RGmdVO1M6TUW2GdO2ZTb57+IM6UZIgTIwLebgslsC5coe
	 KDzZdmzSacJ3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] scsi: qla2xxx: Fix lost interrupts with qlini_mode=disabled
Date: Tue,  9 Dec 2025 22:48:46 -0500
Message-ID: <20251210034915.2268617-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 4f6aaade2a22ac428fa99ed716cf2b87e79c9837 ]

When qla2xxx is loaded with qlini_mode=disabled,
ha->flags.disable_msix_handshake is used before it is set, resulting in
the wrong interrupt handler being used on certain HBAs
(qla2xxx_msix_rsp_q_hs() is used when qla2xxx_msix_rsp_q() should be
used).  The only difference between these two interrupt handlers is that
the _hs() version writes to a register to clear the "RISC" interrupt,
whereas the other version does not.  So this bug results in the RISC
interrupt being cleared when it should not be.  This occasionally causes
a different interrupt handler qla24xx_msix_default() for a different
vector to see ((stat & HSRX_RISC_INT) == 0) and ignore its interrupt,
which then causes problems like:

qla2xxx [0000:02:00.0]-d04c:6: MBX Command timeout for cmd 20,
  iocontrol=8 jiffies=1090c0300 mb[0-3]=[0x4000 0x0 0x40 0xda] mb7 0x500
  host_status 0x40000010 hccr 0x3f00
qla2xxx [0000:02:00.0]-101e:6: Mailbox cmd timeout occurred, cmd=0x20,
  mb[0]=0x20. Scheduling ISP abort
(the cmd varies; sometimes it is 0x20, 0x22, 0x54, 0x5a, 0x5d, or 0x6a)

This problem can be reproduced with a 16 or 32 Gbps HBA by loading
qla2xxx with qlini_mode=disabled and running a high IOPS test while
triggering frequent RSCN database change events.

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
Link: https://patch.msgid.link/56d378eb-14ad-49c7-bae9-c649b6c7691e@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of qla2xxx Lost Interrupts Fix

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: "scsi: qla2xxx: Fix lost interrupts with
qlini_mode=disabled"

Key findings:
- Contains "Fix" keyword indicating a bug fix
- No `Cc: stable@vger.kernel.org` tag present
- No `Fixes:` tag present
- Describes a clear user-visible problem: mailbox command timeouts and
  ISP aborts
- Symptoms documented include:
```
MBX Command timeout for cmd 20... Scheduling ISP abort
```

### 2. CODE CHANGE ANALYSIS

**Root Cause**: `ha->flags.disable_msix_handshake` is accessed before
it's set during initialization. This causes incorrect interrupt handler
selection:
- `qla2xxx_msix_rsp_q_hs()` is erroneously used when
  `qla2xxx_msix_rsp_q()` should be used
- The `_hs` handler clears the RISC interrupt when it shouldn't
- This causes `qla24xx_msix_default()` to see `(stat & HSRX_RISC_INT) ==
  0` and ignore its interrupt

**The Fix**:
1. Removes the problematic `qla2xxx_msix_rsp_q_hs()` handler entirely
2. Removes `QLA_MSIX_QPAIR_MULTIQ_RSP_Q_HS` definition
3. Simplifies `qla25xx_request_irq()` by removing `vector_type`
   parameter
4. Always uses the correct `qla2xxx_msix_rsp_q` handler

**Why This Works**: The author's testing shows that the RISC interrupt
clearing in `_hs` was never necessary - removing it actually improves
correctness (100% of calls see HSRX_RISC_INT set vs 50% previously).

### 3. CLASSIFICATION

- **Bug fix**: Yes - fixes lost interrupts causing command timeouts
- **Feature addition**: No - actually *removes* code
- **Security fix**: No
- **Hardware affected**: QLogic FC HBAs (16/32 Gbps) in enterprise
  environments

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Files changed | 4 (all qla2xxx driver) |
| Net lines | Negative (code removal) |
| Subsystem | SCSI/qla2xxx - mature, enterprise driver |
| Risk level | LOW - removes problematic code path |

The fix is self-contained and simplifies rather than complicates the
code.

### 5. USER IMPACT

**Affected users**:
- QLogic FC HBA users with `qlini_mode=disabled` (target mode)
- High IOPS environments with frequent RSCN events
- Enterprise storage deployments using SCST

**Severity**: HIGH
- Command timeouts cause I/O disruptions
- ISP aborts can trigger path failovers
- Production storage environments severely impacted

### 6. STABILITY INDICATORS

**Testing documented**:
- QLE2742 FW:v9.08.02 (32 Gbps)
- QLE2694L FW:v9.10.11 and v9.08.02 (16 Gbps)
- QLE2672 FW:v8.07.12 (16 Gbps)
- Both initiator and target modes tested

**Sign-offs**: Tony Battersby (author), Martin K. Petersen (SCSI
maintainer)

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- Self-contained within qla2xxx driver
- The affected code (multi-queue support) exists in stable trees

### 8. CONCERNS

1. **No explicit stable tags**: Maintainer didn't request backport
   explicitly
2. **No Fixes: tag**: Unknown exactly when bug was introduced
3. **Configuration-specific**: Only affects `qlini_mode=disabled` mode
4. **Removes entire handler**: Could theoretically affect unknown edge
   cases

### FINAL ASSESSMENT

**Arguments FOR backport**:
- Fixes real, user-visible bug causing command timeouts and ISP aborts
- Affects enterprise FC storage deployments in target mode
- Low risk - removes problematic code rather than adding new code
- Extensively tested on multiple HBA models
- SCSI maintainer approved
- Self-contained fix with no dependencies

**Arguments AGAINST backport**:
- No explicit stable request from maintainers
- Touches multiple functions (though all removals)
- Affects specific configuration (target mode)

The fix addresses a significant reliability issue in enterprise storage
environments. While lacking explicit stable tags, the nature of the fix
(removing buggy code, not adding features), the thorough testing, and
the severity of the symptoms (command timeouts, ISP aborts in
production) make this appropriate for stable backport. The code removal
approach minimizes regression risk.

**YES**

 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_gbl.h |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 32 +++-----------------------------
 drivers/scsi/qla2xxx/qla_mid.c |  4 +---
 4 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb95b7b12051d..b3265952c4bed 100644
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
index 145defc420f27..55d531c19e6b2 100644
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
index c4c6b5c6658c0..a3971afc2dd1e 100644
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
index 8b71ac0b1d999..0abc47e72e0bf 100644
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
2.51.0

