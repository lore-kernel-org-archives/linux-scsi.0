From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/5]  qla2xxx: Correct additional posting issues during NVRAM accesses.
Date: 8 Nov 2005 14:37:06 -0800
Message-ID: <20051108223702.25189.52785.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40779 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965265AbVKHWhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:37:06 -0500
In-Reply-To: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>


On MMIO relaxed-order platforms, it is possible for the
proper delay during NVRAM access to begin before the request
passes through the PCI bus (via a MMIO write) to the ISP.
Thus, causing a subsequent read to the NVRAM part to fail.
Add a MMIO read, after the MMIO write to insure any posted
writes are flushed.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_sup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

applies-to: 1be9353a298e3439ce94d23ab213648890ba846d
f2d6dc1037b51bd9965262058ee2daa4c1422e1a
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 4bec0b4..d54d2a9 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -126,6 +126,7 @@ qla2x00_write_nvram_word(scsi_qla_host_t
 
 	/* Wait for NVRAM to become ready */
 	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
 	do {
 		NVRAM_DELAY();
 		word = RD_REG_WORD(&reg->nvram);
@@ -178,6 +179,7 @@ qla2x00_write_nvram_word_tmo(scsi_qla_ho
 
 	/* Wait for NVRAM to become ready */
 	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
 	do {
 		NVRAM_DELAY();
 		word = RD_REG_WORD(&reg->nvram);
@@ -235,6 +237,7 @@ qla2x00_nvram_request(scsi_qla_host_t *h
 	/* Read data from NVRAM. */
 	for (cnt = 0; cnt < 16; cnt++) {
 		WRT_REG_WORD(&reg->nvram, NVR_SELECT | NVR_CLOCK);
+		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
 		NVRAM_DELAY();
 		data <<= 1;
 		reg_data = RD_REG_WORD(&reg->nvram);
@@ -337,6 +340,7 @@ qla2x00_clear_nvram_protection(scsi_qla_
 
 		/* Wait for NVRAM to become ready. */
 		WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+		RD_REG_WORD(&reg->nvram);	/* PCI Posting. */
 		do {
 			NVRAM_DELAY();
 			word = RD_REG_WORD(&reg->nvram);
@@ -388,6 +392,7 @@ qla2x00_set_nvram_protection(scsi_qla_ho
 
 	/* Wait for NVRAM to become ready. */
 	WRT_REG_WORD(&reg->nvram, NVR_SELECT);
+	RD_REG_WORD(&reg->nvram);		/* PCI Posting. */
 	do {
 		NVRAM_DELAY();
 		word = RD_REG_WORD(&reg->nvram);
---
0.99.9.GIT

-- 
Andrew Vasquez
