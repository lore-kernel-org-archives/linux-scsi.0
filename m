From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: The latest megaraid_mbox 2.20.4.5 is hung
Date: Mon, 21 Mar 2005 12:00:10 +0900
Message-ID: <BF571719A4041A478005EF3F08EA6DF0CA4272@pcsmail03.pcs.pc.ome.toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C52DC2.6CBDAD86"
Received: from inet-tsb5.toshiba.co.jp ([202.33.96.24]:31906 "EHLO
	inet-tsb5.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S261498AbVCUDDr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2005 22:03:47 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "Ju, Seokmann" <sju@lsil.com>, linux-scsi@vger.kernel.org, "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C52DC2.6CBDAD86
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit

Hi Atul,

The race issue seem to be in latest megaraid_mbox 2.20.4.5.
I think that I make adapter->quiescent illegal by megaraid_isr() and 
megaraid_mbox_mm_done(). I corrected these processing.
(See attached file linux-2.6.12-rc1-megaraid-isr-quiescent-race-fix.patch) 

This issue occurs when it composes RAID5 by using 3 HDD of UL320. 
When heavy I/O is executed, the system does hung.
It easily reproduces it with Express5800(4way) of NEC. 
If the controller is 520 or 518, both are acceptable.

I continue the driver's debugging further. 
I want to hear your opinion. 
--
Haruo

------_=_NextPart_001_01C52DC2.6CBDAD86
Content-Type: application/octet-stream;
	name="linux-2.6.12-rc1-megaraid-isr-quiescent-race-fix.patch"
Content-Transfer-Encoding: base64
Content-Description: linux-2.6.12-rc1-megaraid-isr-quiescent-race-fix.patch
Content-Disposition: attachment;
	filename="linux-2.6.12-rc1-megaraid-isr-quiescent-race-fix.patch"

ZGlmZiAtdXJOIGxpbnV4LTIuNi4xMi1yYzEub3JpZy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YV9jb21tb24uaCBsaW51eC0yLjYuMTItcmMxL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhX2Nv
bW1vbi5oCi0tLSBsaW51eC0yLjYuMTItcmMxLm9yaWcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FfY29tbW9uLmgJMjAwNS0wMy0wMiAxNjozODoxMC4wMDAwMDAwMDAgKzA5MDAKKysrIGxpbnV4
LTIuNi4xMi1yYzEvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FfY29tbW9uLmgJMjAwNS0wMy0y
MCAxMDo1MTowNC41NTg4NzMxOTIgKzA5MDAKQEAgLTE1Myw3ICsxNTMsNyBAQAogCXN0cnVjdCBT
Y3NpX0hvc3QJKmhvc3Q7CiAJc3BpbmxvY2tfdAkJKmhvc3RfbG9jazsKIAlzcGlubG9ja190CQls
b2NrOwotCXVpbnQ4X3QJCQlxdWllc2NlbnQ7CisJYXRvbWljX3QJCXF1aWVzY2VudDsKIAlpbnQJ
CQlvdXRzdGFuZGluZ19jbWRzOwogCXNjYl90CQkJKmtzY2JfbGlzdDsKIAlzdHJ1Y3QgbGlzdF9o
ZWFkCWtzY2JfcG9vbDsKZGlmZiAtdXJOIGxpbnV4LTIuNi4xMi1yYzEub3JpZy9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfbWJveC5jIGxpbnV4LTIuNi4xMi1yYzEvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX21ib3guYwotLS0gbGludXgtMi42LjEyLXJjMS5vcmlnL2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9tYm94LmMJMjAwNS0wMy0yMCAwOTo0NDozMC43OTYw
MTc0MzIgKzA5MDAKKysrIGxpbnV4LTIuNi4xMi1yYzEvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX21ib3guYwkyMDA1LTAzLTIwIDEwOjU4OjU3LjM0MTk5OTIzMiArMDkwMApAQCAtMjA5
NCw3ICsyMDk0LDcgQEAKIAl9CiAKIAkvLyBpZiB0aGUgYWRhcHRlciBpbiBub3QgaW4gcXVpZXNj
ZW50IG1vZGUsIHBvc3QgdGhlIGNvbW1hbmRzIHRvIEZXCi0JaWYgKGFkYXB0ZXItPnF1aWVzY2Vu
dCkgeworCWlmIChhdG9taWNfcmVhZCgmYWRhcHRlci0+cXVpZXNjZW50KSkgewogCQlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKFBFTkRJTkdfTElTVF9MT0NLKGFkYXB0ZXIpLCBmbGFncyk7CiAJCXJl
dHVybjsKIAl9CkBAIC0yMzcyLDcgKzIzNzIsNyBAQAogCWhhbmRsZWQgPSBtZWdhcmFpZF9hY2tf
c2VxdWVuY2UoYWRhcHRlcik7CiAKIAkvKiBMb29wIHRocm91Z2ggYW55IHBlbmRpbmcgcmVxdWVz
dHMgKi8KLQlpZiAoIWFkYXB0ZXItPnF1aWVzY2VudCkgeworCWlmICghYXRvbWljX3JlYWQoJmFk
YXB0ZXItPnF1aWVzY2VudCkpIHsKIAkJbWVnYXJhaWRfbWJveF9ydW5wZW5kcShhZGFwdGVyLCBO
VUxMKTsKIAl9CiAKQEAgLTM4NDAsMTYgKzM4NDAsMTMgQEAKIHN0YXRpYyBpbnQKIHdhaXRfdGls
bF9md19lbXB0eShhZGFwdGVyX3QgKmFkYXB0ZXIpCiB7Ci0JdW5zaWduZWQgbG9uZwlmbGFncyA9
IDA7CiAJaW50CQlpOwogCiAKIAkvKgogCSAqIFNldCB0aGUgcXVpZXNjZW50IGZsYWcgdG8gc3Rv
cCBpc3N1aW5nIGNtZHMgdG8gRlcuCiAJICovCi0Jc3Bpbl9sb2NrX2lycXNhdmUoYWRhcHRlci0+
aG9zdF9sb2NrLCBmbGFncyk7Ci0JYWRhcHRlci0+cXVpZXNjZW50Kys7Ci0Jc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZShhZGFwdGVyLT5ob3N0X2xvY2ssIGZsYWdzKTsKKwlhdG9taWNfaW5jKCZhZGFw
dGVyLT5xdWllc2NlbnQpOwogCiAJLyoKIAkgKiBXYWl0IHRpbGwgdGhlcmUgYXJlIG5vIG1vcmUg
Y21kcyBvdXRzdGFuZGluZyBhdCBGVy4gVHJ5IGZvciBhdCBtb3N0CkBAIC0zOTA0LDcgKzM5MDEs
NyBAQAogCS8vIGNvbnRyb2xsZXIKIAlpZiAocmF3X21ib3hbMF0gPT0gRkNfREVMX0xPR0RSViAm
JiByYXdfbWJveFsyXSA9PSBPUF9ERUxfTE9HRFJWKSB7CiAKLQkJYWRhcHRlci0+cXVpZXNjZW50
LS07CisJCWF0b21pY19kZWMoJmFkYXB0ZXItPnF1aWVzY2VudCk7CiAKIAkJbWVnYXJhaWRfbWJv
eF9ydW5wZW5kcShhZGFwdGVyLCBOVUxMKTsKIAl9Cg==

------_=_NextPart_001_01C52DC2.6CBDAD86--
