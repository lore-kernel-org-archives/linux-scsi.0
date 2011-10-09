From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/10] megaraid_sas: Remove some un-necessary code
Date: Sat, 8 Oct 2011 18:14:45 -0700
Message-ID: <CAHtARFHOnTyKoGPQXZcgmPtHBm4wvUxBKCrPFdGcZmnYFJn3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6de03a45a7a0304aed36627
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:14:46 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6de03a45a7a0304aed36627
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will remove some un-necessary code.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
19:03:01.636237010 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
19:06:39.923236915 -0700
@@ -139,11 +139,6 @@
 	if (!(status & MFI_FUSION_ENABLE_INTERRUPT_MASK))
 		return 0;

-	/*
-	 * dummy read to flush PCI
-	 */
-	readl(&regs->outbound_intr_status);
-
 	return 1;
 }

@@ -590,7 +585,6 @@
 	struct megasas_init_frame *init_frame;
 	struct MPI2_IOC_INIT_REQUEST *IOCInitMessage;
 	dma_addr_t	ioc_init_handle;
-	u32 context;
 	struct megasas_cmd *cmd;
 	u8 ret;
 	struct fusion_context *fusion;
@@ -639,9 +633,6 @@
 	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);

 	frame_hdr = &cmd->frame->hdr;
-	context = init_frame->context;
-	init_frame->context = context;
-
 	frame_hdr->cmd_status = 0xFF;
 	frame_hdr->flags |= MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;

@@ -1612,7 +1603,6 @@

 	req_desc->Words = 0;
 	cmd->request_desc = req_desc;
-	cmd->request_desc->Words = 0;

 	if (megasas_build_io_fusion(instance, scmd, cmd)) {
 		megasas_return_cmd_fusion(instance, cmd);
@@ -1928,15 +1918,12 @@
 			  struct megasas_cmd *cmd)
 {
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
-	union desc_value d_val;

 	req_desc = build_mpt_cmd(instance, cmd);
 	if (!req_desc) {
 		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
-	d_val.word = req_desc->Words;
-
 	instance->instancet->fire_cmd(instance, req_desc->u.low,
 				      req_desc->u.high, instance->reg_set);
 }

--0016e6de03a45a7a0304aed36627
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbtw5l0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTk6MDM6MDEuNjM2MjM3MDEwIC0wNzAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTk6MDY6MzkuOTIzMjM2OTE1IC0wNzAwCkBAIC0xMzksMTEg
KzEzOSw2IEBACiAJaWYgKCEoc3RhdHVzICYgTUZJX0ZVU0lPTl9FTkFCTEVfSU5URVJSVVBUX01B
U0spKQogCQlyZXR1cm4gMDsKIAotCS8qCi0JICogZHVtbXkgcmVhZCB0byBmbHVzaCBQQ0kKLQkg
Ki8KLQlyZWFkbCgmcmVncy0+b3V0Ym91bmRfaW50cl9zdGF0dXMpOwotCiAJcmV0dXJuIDE7CiB9
CiAKQEAgLTU5MCw3ICs1ODUsNiBAQAogCXN0cnVjdCBtZWdhc2FzX2luaXRfZnJhbWUgKmluaXRf
ZnJhbWU7CiAJc3RydWN0IE1QSTJfSU9DX0lOSVRfUkVRVUVTVCAqSU9DSW5pdE1lc3NhZ2U7CiAJ
ZG1hX2FkZHJfdAlpb2NfaW5pdF9oYW5kbGU7Ci0JdTMyIGNvbnRleHQ7CiAJc3RydWN0IG1lZ2Fz
YXNfY21kICpjbWQ7CiAJdTggcmV0OwogCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOwpA
QCAtNjM5LDkgKzYzMyw2IEBACiAJbWVtc2V0KGluaXRfZnJhbWUsIDAsIE1FR0FNRklfRlJBTUVf
U0laRSk7CiAKIAlmcmFtZV9oZHIgPSAmY21kLT5mcmFtZS0+aGRyOwotCWNvbnRleHQgPSBpbml0
X2ZyYW1lLT5jb250ZXh0OwotCWluaXRfZnJhbWUtPmNvbnRleHQgPSBjb250ZXh0OwotCiAJZnJh
bWVfaGRyLT5jbWRfc3RhdHVzID0gMHhGRjsKIAlmcmFtZV9oZHItPmZsYWdzIHw9IE1GSV9GUkFN
RV9ET05UX1BPU1RfSU5fUkVQTFlfUVVFVUU7CiAKQEAgLTE2MTIsNyArMTYwMyw2IEBACiAKIAly
ZXFfZGVzYy0+V29yZHMgPSAwOwogCWNtZC0+cmVxdWVzdF9kZXNjID0gcmVxX2Rlc2M7Ci0JY21k
LT5yZXF1ZXN0X2Rlc2MtPldvcmRzID0gMDsKIAogCWlmIChtZWdhc2FzX2J1aWxkX2lvX2Z1c2lv
bihpbnN0YW5jZSwgc2NtZCwgY21kKSkgewogCQltZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uKGlu
c3RhbmNlLCBjbWQpOwpAQCAtMTkyOCwxNSArMTkxOCwxMiBAQAogCQkJICBzdHJ1Y3QgbWVnYXNh
c19jbWQgKmNtZCkKIHsKIAl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAq
cmVxX2Rlc2M7Ci0JdW5pb24gZGVzY192YWx1ZSBkX3ZhbDsKIAogCXJlcV9kZXNjID0gYnVpbGRf
bXB0X2NtZChpbnN0YW5jZSwgY21kKTsKIAlpZiAoIXJlcV9kZXNjKSB7CiAJCXByaW50ayhLRVJO
X0VSUiAiQ291bGRuJ3QgaXNzdWUgTUZJIHBhc3MgdGhydSBjbWRcbiIpOwogCQlyZXR1cm47CiAJ
fQotCWRfdmFsLndvcmQgPSByZXFfZGVzYy0+V29yZHM7Ci0KIAlpbnN0YW5jZS0+aW5zdGFuY2V0
LT5maXJlX2NtZChpbnN0YW5jZSwgcmVxX2Rlc2MtPnUubG93LAogCQkJCSAgICAgIHJlcV9kZXNj
LT51LmhpZ2gsIGluc3RhbmNlLT5yZWdfc2V0KTsKIH0K
--0016e6de03a45a7a0304aed36627--
