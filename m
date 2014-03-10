From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/5] megaraid_sas: Fix megasas_ioc_init_fusion
Date: Mon, 10 Mar 2014 02:51:36 -0700
Message-ID: <CAHtARFFkb7ziyOQ=cSFqC8=6813+7TBjXSj8u5fL6zAUcAyUew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3010e48d9e473604f43d8c92
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:61555 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaCJJvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 05:51:36 -0400
Received: by mail-yk0-f169.google.com with SMTP id 142so18509537ykq.0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 02:51:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

--20cf3010e48d9e473604f43d8c92
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas fixes the megasas_ioc_init_fusion function
to use a local stack variable for the IOCinit frame physical address
instead of clobbering the first request descriptor.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-03-09 21:07:03.893980795 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-03-09 21:30:32.104856111 -0700
@@ -585,7 +585,7 @@
  struct megasas_cmd *cmd;
  u8 ret;
  struct fusion_context *fusion;
- union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+ union MEGASAS_REQUEST_DESCRIPTOR_UNION req_desc;
  int i;
  struct megasas_header *frame_hdr;

@@ -647,15 +647,12 @@
  init_frame->queue_info_new_phys_addr_lo = cpu_to_le32((u32)ioc_init_handle);
  init_frame->data_xfer_len = cpu_to_le32(sizeof(struct MPI2_IOC_INIT_REQUEST));

- req_desc =
-  (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)fusion->req_frames_desc;
-
- req_desc->Words = 0;
- req_desc->MFAIo.RequestFlags =
+ req_desc.Words = 0;
+ req_desc.MFAIo.RequestFlags =
  (MEGASAS_REQ_DESCRIPT_FLAGS_MFA <<
  MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
- cpu_to_le32s((u32 *)&req_desc->MFAIo);
- req_desc->Words |= cpu_to_le64(cmd->frame_phys_addr);
+ cpu_to_le32s((u32 *)&req_desc.MFAIo);
+ req_desc.Words |= cpu_to_le64(cmd->frame_phys_addr);

  /*
  * disable the intr before firing the init frame
@@ -669,8 +666,8 @@
  break;
  }

- instance->instancet->fire_cmd(instance, req_desc->u.low,
-      req_desc->u.high, instance->reg_set);
+ instance->instancet->fire_cmd(instance, req_desc.u.low,
+      req_desc.u.high, instance->reg_set);

  wait_and_poll(instance, cmd);

--20cf3010e48d9e473604f43d8c92
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hslk943w0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Z1c2lvbi5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfZnVzaW9uLmMJMjAxNC0wMy0wOSAyMTowNzowMy44OTM5ODA3OTUgLTA3MDAKKysr
IHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24u
YwkyMDE0LTAzLTA5IDIxOjMwOjMyLjEwNDg1NjExMSAtMDcwMApAQCAtNTg1LDcgKzU4NSw3IEBA
CiAJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CiAJdTggcmV0OwogCXN0cnVjdCBmdXNpb25fY29u
dGV4dCAqZnVzaW9uOwotCXVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICpy
ZXFfZGVzYzsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiByZXFfZGVz
YzsKIAlpbnQgaTsKIAlzdHJ1Y3QgbWVnYXNhc19oZWFkZXIgKmZyYW1lX2hkcjsKIApAQCAtNjQ3
LDE1ICs2NDcsMTIgQEAKIAlpbml0X2ZyYW1lLT5xdWV1ZV9pbmZvX25ld19waHlzX2FkZHJfbG8g
PSBjcHVfdG9fbGUzMigodTMyKWlvY19pbml0X2hhbmRsZSk7CiAJaW5pdF9mcmFtZS0+ZGF0YV94
ZmVyX2xlbiA9IGNwdV90b19sZTMyKHNpemVvZihzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNU
KSk7CiAKLQlyZXFfZGVzYyA9Ci0JICAodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1Jf
VU5JT04gKilmdXNpb24tPnJlcV9mcmFtZXNfZGVzYzsKLQotCXJlcV9kZXNjLT5Xb3JkcyA9IDA7
Ci0JcmVxX2Rlc2MtPk1GQUlvLlJlcXVlc3RGbGFncyA9CisJcmVxX2Rlc2MuV29yZHMgPSAwOwor
CXJlcV9kZXNjLk1GQUlvLlJlcXVlc3RGbGFncyA9CiAJCShNRUdBU0FTX1JFUV9ERVNDUklQVF9G
TEFHU19NRkEgPDwKIAkJIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOwot
CWNwdV90b19sZTMycygodTMyICopJnJlcV9kZXNjLT5NRkFJbyk7Ci0JcmVxX2Rlc2MtPldvcmRz
IHw9IGNwdV90b19sZTY0KGNtZC0+ZnJhbWVfcGh5c19hZGRyKTsKKwljcHVfdG9fbGUzMnMoKHUz
MiAqKSZyZXFfZGVzYy5NRkFJbyk7CisJcmVxX2Rlc2MuV29yZHMgfD0gY3B1X3RvX2xlNjQoY21k
LT5mcmFtZV9waHlzX2FkZHIpOwogCiAJLyoKIAkgKiBkaXNhYmxlIHRoZSBpbnRyIGJlZm9yZSBm
aXJpbmcgdGhlIGluaXQgZnJhbWUKQEAgLTY2OSw4ICs2NjYsOCBAQAogCQkJYnJlYWs7CiAJfQog
Ci0JaW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsIHJlcV9kZXNjLT51Lmxv
dywKLQkJCQkgICAgICByZXFfZGVzYy0+dS5oaWdoLCBpbnN0YW5jZS0+cmVnX3NldCk7CisJaW5z
dGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsIHJlcV9kZXNjLnUubG93LAorCQkJ
CSAgICAgIHJlcV9kZXNjLnUuaGlnaCwgaW5zdGFuY2UtPnJlZ19zZXQpOwogCiAJd2FpdF9hbmRf
cG9sbChpbnN0YW5jZSwgY21kKTsKIAo=
--20cf3010e48d9e473604f43d8c92--
