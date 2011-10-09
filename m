From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/10] megaraid_sas: Clear state change interrupts
Date: Sat, 8 Oct 2011 18:14:50 -0700
Message-ID: <CAHtARFE7j4Z9EJSkAizOn5xb9=7oNufGnnZto-zr+enEZh6F-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364d2569aa576804aed3667a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:14:51 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364d2569aa576804aed3667a
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas will clear state change interrupts.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
19:13:13.460237034 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
19:14:43.424174966 -0700
@@ -101,6 +101,10 @@
 void
 megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
 {
+	/* For Thunderbolt/Invader also clear intr on enable */
+	writel(~0, &regs->outbound_intr_status);
+	readl(&regs->outbound_intr_status);
+
 	writel(~MFI_FUSION_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);

 	/* Dummy readl to force pci flush */
@@ -1806,10 +1810,13 @@
 	}

 	/* If we are resetting, bail */
-	if (test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+	if (test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags)) {
+		instance->instancet->clear_intr(instance->reg_set);
 		return IRQ_HANDLED;
+	}

 	if (!complete_cmd_fusion(instance)) {
+		instance->instancet->clear_intr(instance->reg_set);
 		/* If we didn't complete any commands, check for FW fault */
 		fw_state = instance->instancet->read_fw_status_reg(
 			instance->reg_set) & MFI_STATE_MASK;

--0016364d2569aa576804aed3667a
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbw8qo0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTk6MTM6MTMuNDYwMjM3MDM0IC0wNzAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTk6MTQ6NDMuNDI0MTc0OTY2IC0wNzAwCkBAIC0xMDEsNiAr
MTAxLDEwIEBACiB2b2lkCiBtZWdhc2FzX2VuYWJsZV9pbnRyX2Z1c2lvbihzdHJ1Y3QgbWVnYXNh
c19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKIHsKKwkvKiBGb3IgVGh1bmRlcmJvbHQvSW52
YWRlciBhbHNvIGNsZWFyIGludHIgb24gZW5hYmxlICovCisJd3JpdGVsKH4wLCAmcmVncy0+b3V0
Ym91bmRfaW50cl9zdGF0dXMpOworCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX3N0YXR1cyk7
CisKIAl3cml0ZWwofk1GSV9GVVNJT05fRU5BQkxFX0lOVEVSUlVQVF9NQVNLLCAmKHJlZ3MpLT5v
dXRib3VuZF9pbnRyX21hc2spOwogCiAJLyogRHVtbXkgcmVhZGwgdG8gZm9yY2UgcGNpIGZsdXNo
ICovCkBAIC0xODA2LDEwICsxODEwLDEzIEBACiAJfQogCiAJLyogSWYgd2UgYXJlIHJlc2V0dGlu
ZywgYmFpbCAqLwotCWlmICh0ZXN0X2JpdChNRUdBU0FTX0ZVU0lPTl9JTl9SRVNFVCwgJmluc3Rh
bmNlLT5yZXNldF9mbGFncykpCisJaWYgKHRlc3RfYml0KE1FR0FTQVNfRlVTSU9OX0lOX1JFU0VU
LCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKSkgeworCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5jbGVh
cl9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKIAkJcmV0dXJuIElSUV9IQU5ETEVEOworCX0KIAog
CWlmICghY29tcGxldGVfY21kX2Z1c2lvbihpbnN0YW5jZSkpIHsKKwkJaW5zdGFuY2UtPmluc3Rh
bmNldC0+Y2xlYXJfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7CiAJCS8qIElmIHdlIGRpZG4ndCBj
b21wbGV0ZSBhbnkgY29tbWFuZHMsIGNoZWNrIGZvciBGVyBmYXVsdCAqLwogCQlmd19zdGF0ZSA9
IGluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKIAkJCWluc3RhbmNlLT5y
ZWdfc2V0KSAmIE1GSV9TVEFURV9NQVNLOwo=
--0016364d2569aa576804aed3667a--
