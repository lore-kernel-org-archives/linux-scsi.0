From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [PATCHv3]scsi: don't fail zero length request too early
Date: Fri, 13 May 2016 10:07:56 +0200
Message-ID: <CAMGffEmZMWSTSP3VRxn8K_ZWG3qvRWeKOjzPJN8V4ZZ8Fa_xGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113973aae03ec00532b4c617
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35267 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbcEMIIR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2016 04:08:17 -0400
Received: by mail-oi0-f47.google.com with SMTP id x19so159026017oix.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2016 01:08:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

--001a113973aae03ec00532b4c617
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi James, and all,

I guess you're busy on other staff, so I create patch below as you
suggested, I think we also need this into stable.

>From 99eab170653544fa1e1bc9511ec055ba70e183d2 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@profitbricks.com>
Date: Fri, 13 May 2016 09:53:21 +0200
Subject: [PATCH] scsi: don't fail zero length request too early

We hit IO error in our production when SYNC on multipath devices during res=
ize
device on target side, the problem turns out scsi driver passes up as IO
error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
Capacity data has changed, even storage side sync the data properly.

Dig it further turns out we need special case on zero length commands
(currently only FLUSH), when it fails, we always need to drop down
into retry code.

Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/scsi_lib.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..5a97866 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
unsigned int good_bytes)
  }

  /*
- * If we finished all bytes in the request we are done now.
+ * special case: failed zero length commands always need to
+ * drop down into the retry code. Otherwise, if we finished
+ * all bytes in the request we are done now.
  */
- if (!scsi_end_request(req, error, good_bytes, 0))
+ if (!(good_bytes =3D=3D 0 && blk_rq_bytes(req) =3D=3D 0 && result !=3D 0)=
 &&
+    !scsi_end_request(req, error, good_bytes, 0))
  return;

  /*
--=20
1.9.1

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.

--001a113973aae03ec00532b4c617
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-scsi-don-t-fail-zero-length-request-too-early.patch"
Content-Disposition: attachment;
	filename="0001-scsi-don-t-fail-zero-length-request-too-early.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_io5fwb6g0

RnJvbSA5OWVhYjE3MDY1MzU0NGZhMWUxYmM5NTExZWMwNTViYTcwZTE4M2QyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogRnJpLCAxMyBNYXkgMjAxNiAwOTo1MzoyMSArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHNjc2k6IGRvbid0IGZhaWwgemVybyBsZW5ndGggcmVxdWVzdCB0b28gZWFybHkKCldlIGhpdCBJ
TyBlcnJvciBpbiBvdXIgcHJvZHVjdGlvbiB3aGVuIFNZTkMgb24gbXVsdGlwYXRoIGRldmljZXMg
ZHVyaW5nIHJlc2l6ZQpkZXZpY2Ugb24gdGFyZ2V0IHNpZGUsIHRoZSBwcm9ibGVtIHR1cm5zIG91
dCBzY3NpIGRyaXZlciBwYXNzZXMgdXAgYXMgSU8KZXJyb3Igd2hlbiBzZW5zZSBkYXRhIGlzIFVO
SVRfQVRURU5USU9OIGFuZCBBU0MgJiYgQVNDUSBpbmRpY2F0ZQpDYXBhY2l0eSBkYXRhIGhhcyBj
aGFuZ2VkLCBldmVuIHN0b3JhZ2Ugc2lkZSBzeW5jIHRoZSBkYXRhIHByb3Blcmx5LgoKRGlnIGl0
IGZ1cnRoZXIgdHVybnMgb3V0IHdlIG5lZWQgc3BlY2lhbCBjYXNlIG9uIHplcm8gbGVuZ3RoIGNv
bW1hbmRzCihjdXJyZW50bHkgb25seSBGTFVTSCksIHdoZW4gaXQgZmFpbHMsIHdlIGFsd2F5cyBu
ZWVkIHRvIGRyb3AgZG93bgppbnRvIHJldHJ5IGNvZGUuCgpSZXBvcnRlZC1ieTogU2ViYXN0aWFu
IFBhcnNjaGF1ZXIgPHMucGFyc2NoYXVlckBnbXguZGU+ClN1Z2dlc3RlZC1ieTogSmFtZXMgQm90
dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5lcnNoaXAuY29tPgpTaWduZWQtb2Zm
LWJ5OiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNvbT4KLS0tCiBkcml2ZXJz
L3Njc2kvc2NzaV9saWIuYyB8IDcgKysrKystLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9saWIu
YyBiL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jCmluZGV4IDgxMDY1MTUuLjVhOTc4NjYgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jCisrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2xp
Yi5jCkBAIC05MTEsOSArOTExLDEyIEBAIHZvaWQgc2NzaV9pb19jb21wbGV0aW9uKHN0cnVjdCBz
Y3NpX2NtbmQgKmNtZCwgdW5zaWduZWQgaW50IGdvb2RfYnl0ZXMpCiAJfQogCiAJLyoKLQkgKiBJ
ZiB3ZSBmaW5pc2hlZCBhbGwgYnl0ZXMgaW4gdGhlIHJlcXVlc3Qgd2UgYXJlIGRvbmUgbm93Lgor
CSAqIHNwZWNpYWwgY2FzZTogZmFpbGVkIHplcm8gbGVuZ3RoIGNvbW1hbmRzIGFsd2F5cyBuZWVk
IHRvCisJICogZHJvcCBkb3duIGludG8gdGhlIHJldHJ5IGNvZGUuIE90aGVyd2lzZSwgaWYgd2Ug
ZmluaXNoZWQKKwkgKiBhbGwgYnl0ZXMgaW4gdGhlIHJlcXVlc3Qgd2UgYXJlIGRvbmUgbm93Lgog
CSAqLwotCWlmICghc2NzaV9lbmRfcmVxdWVzdChyZXEsIGVycm9yLCBnb29kX2J5dGVzLCAwKSkK
KwlpZiAoIShnb29kX2J5dGVzID09IDAgJiYgYmxrX3JxX2J5dGVzKHJlcSkgPT0gMCAmJiByZXN1
bHQgIT0gMCkgJiYKKwkgICAgIXNjc2lfZW5kX3JlcXVlc3QocmVxLCBlcnJvciwgZ29vZF9ieXRl
cywgMCkpCiAJCXJldHVybjsKIAogCS8qCi0tIAoxLjkuMQoK
--001a113973aae03ec00532b4c617--
