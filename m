From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/5] megaraid_sas: Return leaked MPT frames to MPT frame pool
Date: Mon, 10 Mar 2014 02:51:45 -0700
Message-ID: <CAHtARFGWcbLARtbCzDjCMKPJ1QSA3teCvV1w=yF+tr7RHLNgYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c2aeda33f3a604f43d8dd4
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:50412 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaCJJvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 05:51:46 -0400
Received: by mail-yh0-f44.google.com with SMTP id f10so2120187yha.31
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 02:51:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

--001a11c2aeda33f3a604f43d8dd4
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will return leaked MPT frames from any
polled DCMD's that timeout to the MPT frame pool.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-03-09 21:31:26.710918424 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-03-09 21:45:22.598012009 -0700
@@ -2432,11 +2432,14 @@
  instance,
  cmd_mfi->context.smid
  -1);
- if (!req_desc)
+ if (!req_desc) {
  printk(KERN_WARNING
        "req_desc NULL"
        "\n");
- else {
+ /* Return leaked MPT
+   frame */
+ megasas_return_cmd_fusion(instance, cmd_fusion);
+ } else {
  instance->instancet->
  fire_cmd(instance,
  req_desc->

--001a11c2aeda33f3a604f43d8dd4
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hslkc3mr0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Z1c2lvbi5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfZnVzaW9uLmMJMjAxNC0wMy0wOSAyMTozMToyNi43MTA5MTg0MjQgLTA3MDAKKysr
IHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24u
YwkyMDE0LTAzLTA5IDIxOjQ1OjIyLjU5ODAxMjAwOSAtMDcwMApAQCAtMjQzMiwxMSArMjQzMiwx
NCBAQAogCQkJCQkJCWluc3RhbmNlLAogCQkJCQkJCWNtZF9tZmktPmNvbnRleHQuc21pZAogCQkJ
CQkJCS0xKTsKLQkJCQkJCWlmICghcmVxX2Rlc2MpCisJCQkJCQlpZiAoIXJlcV9kZXNjKSB7CiAJ
CQkJCQkJcHJpbnRrKEtFUk5fV0FSTklORwogCQkJCQkJCSAgICAgICAicmVxX2Rlc2MgTlVMTCIK
IAkJCQkJCQkgICAgICAgIlxuIik7Ci0JCQkJCQllbHNlIHsKKwkJCQkJCQkvKiBSZXR1cm4gbGVh
a2VkIE1QVAorCQkJCQkJCSAgIGZyYW1lICovCisJCQkJCQkJbWVnYXNhc19yZXR1cm5fY21kX2Z1
c2lvbihpbnN0YW5jZSwgY21kX2Z1c2lvbik7CisJCQkJCQl9IGVsc2UgewogCQkJCQkJCWluc3Rh
bmNlLT5pbnN0YW5jZXQtPgogCQkJCQkJCWZpcmVfY21kKGluc3RhbmNlLAogCQkJCQkJCQkgcmVx
X2Rlc2MtPgo=
--001a11c2aeda33f3a604f43d8dd4--
