From: adam radford <aradford@gmail.com>
Subject: [PATCH 9/10] megaraid_sas: Add driver workaround for PERC5/1068 kdump
 kernel panic
Date: Sat, 8 Oct 2011 18:15:19 -0700
Message-ID: <CAHtARFFp12dh5fmsNQG8w_g_RP6ftXR57HmhydNomZy1PtExXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364d25695e197404aed368cd
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBPT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:15:19 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:15:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364d25695e197404aed368cd
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds a driver workaround for
PERC5/1068 based controller FW that keeps a command from the main
kernel that the driver cannot cancel which was causing a kernel panic
in shutdown of the kdump kernel.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
15:29:22.411330755 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
17:20:01.091455209 -0700
@@ -215,6 +215,10 @@

 	cmd->scmd = NULL;
 	cmd->frame_count = 0;
+	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
+	    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
+	    (reset_devices))
+		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
 	list_add_tail(&cmd->list, &instance->cmd_pool);

 	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
@@ -2165,7 +2169,16 @@
 		cmd->scmd->SCp.ptr = NULL;

 	switch (hdr->cmd) {
-
+	case MFI_CMD_INVALID:
+		/* Some older 1068 controller FW may keep a pended
+		   MR_DCMD_CTRL_EVENT_GET_INFO left over from the main kernel
+		   when booting the kdump kernel.  Ignore this command to
+		   prevent a kernel panic on shutdown of the kdump kernel. */
+		printk(KERN_WARNING "megaraid_sas: MFI_CMD_INVALID command "
+		       "completed.\n");
+		printk(KERN_WARNING "megaraid_sas: If you have a controller "
+		       "other than PERC5, please upgrade your firmware.\n");
+		break;
 	case MFI_CMD_PD_SCSI_IO:
 	case MFI_CMD_LD_SCSI_IO:

@@ -2934,6 +2947,10 @@
 		memset(cmd->frame, 0, total_sz);
 		cmd->frame->io.context = cmd->index;
 		cmd->frame->io.pad_0 = 0;
+		if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
+		    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
+		    (reset_devices))
+			cmd->frame->hdr.cmd = MFI_CMD_INVALID;
 	}

 	return 0;
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
15:29:22.413330801 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
17:16:58.131395817 -0700
@@ -139,6 +139,7 @@
 #define MFI_CMD_ABORT				0x06
 #define MFI_CMD_SMP				0x07
 #define MFI_CMD_STP				0x08
+#define MFI_CMD_INVALID				0xff

 #define MR_DCMD_CTRL_GET_INFO			0x01010000
 #define MR_DCMD_LD_GET_LIST			0x03010000

--0016364d25695e197404aed368cd
Content-Type: application/octet-stream; name="megaraid_sas.patch9"
Content-Disposition: attachment; filename="megaraid_sas.patch9"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjc666x0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMTAtMDggMTU6Mjk6MjIuNDExMzMwNzU1IC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTEwLTA4IDE3OjIwOjAxLjA5MTQ1NTIwOSAtMDcwMApAQCAtMjE1LDYgKzIxNSwxMCBA
QAogCiAJY21kLT5zY21kID0gTlVMTDsKIAljbWQtPmZyYW1lX2NvdW50ID0gMDsKKwlpZiAoKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSAmJgorCSAg
ICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSKSAm
JgorCSAgICAocmVzZXRfZGV2aWNlcykpCisJCWNtZC0+ZnJhbWUtPmhkci5jbWQgPSBNRklfQ01E
X0lOVkFMSUQ7CiAJbGlzdF9hZGRfdGFpbCgmY21kLT5saXN0LCAmaW5zdGFuY2UtPmNtZF9wb29s
KTsKIAogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5jbWRfcG9vbF9sb2NrLCBm
bGFncyk7CkBAIC0yMTY1LDcgKzIxNjksMTYgQEAKIAkJY21kLT5zY21kLT5TQ3AucHRyID0gTlVM
TDsKIAogCXN3aXRjaCAoaGRyLT5jbWQpIHsKLQorCWNhc2UgTUZJX0NNRF9JTlZBTElEOgorCQkv
KiBTb21lIG9sZGVyIDEwNjggY29udHJvbGxlciBGVyBtYXkga2VlcCBhIHBlbmRlZAorCQkgICBN
Ul9EQ01EX0NUUkxfRVZFTlRfR0VUX0lORk8gbGVmdCBvdmVyIGZyb20gdGhlIG1haW4ga2VybmVs
CisJCSAgIHdoZW4gYm9vdGluZyB0aGUga2R1bXAga2VybmVsLiAgSWdub3JlIHRoaXMgY29tbWFu
ZCB0bworCQkgICBwcmV2ZW50IGEga2VybmVsIHBhbmljIG9uIHNodXRkb3duIG9mIHRoZSBrZHVt
cCBrZXJuZWwuICovCisJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogTUZJX0NN
RF9JTlZBTElEIGNvbW1hbmQgIgorCQkgICAgICAgImNvbXBsZXRlZC5cbiIpOworCQlwcmludGso
S0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IElmIHlvdSBoYXZlIGEgY29udHJvbGxlciAiCisJ
CSAgICAgICAib3RoZXIgdGhhbiBQRVJDNSwgcGxlYXNlIHVwZ3JhZGUgeW91ciBmaXJtd2FyZS5c
biIpOworCQlicmVhazsKIAljYXNlIE1GSV9DTURfUERfU0NTSV9JTzoKIAljYXNlIE1GSV9DTURf
TERfU0NTSV9JTzoKIApAQCAtMjkzNCw2ICsyOTQ3LDEwIEBACiAJCW1lbXNldChjbWQtPmZyYW1l
LCAwLCB0b3RhbF9zeik7CiAJCWNtZC0+ZnJhbWUtPmlvLmNvbnRleHQgPSBjbWQtPmluZGV4Owog
CQljbWQtPmZyYW1lLT5pby5wYWRfMCA9IDA7CisJCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmlj
ZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pICYmCisJCSAgICAoaW5zdGFuY2UtPnBkZXYt
PmRldmljZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSKSAmJgorCQkgICAgKHJlc2V0X2Rl
dmljZXMpKQorCQkJY21kLT5mcmFtZS0+aGRyLmNtZCA9IE1GSV9DTURfSU5WQUxJRDsKIAl9CiAK
IAlyZXR1cm4gMDsKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXMuaCBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhcy5oCTIwMTEtMTAtMDggMTU6Mjk6MjIuNDEzMzMwODAxIC0wNzAwCisrKyBzY3Np
LW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0x
MC0wOCAxNzoxNjo1OC4xMzEzOTU4MTcgLTA3MDAKQEAgLTEzOSw2ICsxMzksNyBAQAogI2RlZmlu
ZSBNRklfQ01EX0FCT1JUCQkJCTB4MDYKICNkZWZpbmUgTUZJX0NNRF9TTVAJCQkJMHgwNwogI2Rl
ZmluZSBNRklfQ01EX1NUUAkJCQkweDA4CisjZGVmaW5lIE1GSV9DTURfSU5WQUxJRAkJCQkweGZm
CiAKICNkZWZpbmUgTVJfRENNRF9DVFJMX0dFVF9JTkZPCQkJMHgwMTAxMDAwMAogI2RlZmluZSBN
Ul9EQ01EX0xEX0dFVF9MSVNUCQkJMHgwMzAxMDAwMAo=
--0016364d25695e197404aed368cd--
