From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Patch: Make the iscsi lld create a WQ_HIGHPRI workqueue itself
Date: Mon, 28 Mar 2016 13:46:05 -0700
Message-ID: <CACyXjPxwz4znmt7g9ptYdpzkfF1Ok7KKJa2ceyKxg00buSfmcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1143798a6abfea052f22000a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:36800 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbcC1UqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2016 16:46:07 -0400
Received: by mail-qk0-f177.google.com with SMTP id i4so90249393qkc.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2016 13:46:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

--001a1143798a6abfea052f22000a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

We noticed recently while testing with large numbers of iSCSI
connections that iscsid was going to heroic lengths to change the nice
value of the iSCSI work queue to -20. It becomes very expensive with
hundreds of connections.

This small patch has the LLD do the work,

Feedback welcome.

A small patch will be needed for the user-space tools as well. I will
send one in if someone else does not do so.

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)

--001a1143798a6abfea052f22000a
Content-Type: application/octet-stream;
	name="0001-Make-the-iscsi-lld-create-a-WQ_HIGHPRI-workqueue.patch"
Content-Disposition: attachment;
	filename="0001-Make-the-iscsi-lld-create-a-WQ_HIGHPRI-workqueue.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imcgrdiz0

RnJvbSBjMGYwNGE2NmIyOWE5MTkwMTA5NzQwYzAzZWU5ZTY1YmI2MmFmZTI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSaWNoYXJkIFNoYXJwZSA8cnNoYXJwZUBudXRhbml4LmNvbT4K
RGF0ZTogTW9uLCAyOCBNYXIgMjAxNiAxMzozNjoxOCAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIE1h
a2UgdGhlIGlzY3NpIGxsZCBjcmVhdGUgYSBXUV9ISUdIUFJJIHdvcmtxdWV1ZS4KClRoZSBvcGVu
LWlzY3NpIHRvb2xzIGdvIHRvIGhlcm9pYyBlZmZvcnRzIHRvIGNoYW5nZSB0aGUgbmljZSB2YWx1
ZSBvZgp0aGUgaXNjc2kgd29ya3F1ZXVlIHRvIC0yMC4gSXQgc2NhbnMgYWxsIHByb2Nlc3NlcyBp
biAvcHJvYyBhbmQKd2hlbiBpdCBmaW5kcyB0aGUgb25lIGl0IGlzIGludGVyZXN0ZWQgaW4gY2Fs
bHMgc2V0cHJpb3JpdHkuCgpXaGVuIHlvdSBhcmUgY29ubmVjdGluZyB0byBhIHJlYXNvbmFibGUg
bnVtYmVyIG9mIGlTQ1NJIHRhcmdldHMgdGhpcwpjYW4gYmUgY29zdGx5LgoKVGhpcyBzbWFsbCBw
YXRjaCBoYXMgdGhlIGlzY3NpIExMRCBkbyB0aGUgd29yayBpdHNlbGYuIEl0IHNlZW1zIGxpa2UK
dGhlIGxlYXN0IGludHJ1c2l2ZSB3YXkgdG8gYWNoZWl2ZSB0aGUgcmVzdWx0LgoKQSBzbWFsbCBw
YXRjaCB3aWxsIGJlIG5lZWRlZCBpbiB0aGUgb3Blbi1pc2NzaSB1c2Vyc3BhY2UgdG9vbHMKYXMg
d2VsbC4KClNpZ25lZC1vZmYtYnk6IFJpY2hhcmQgU2hhcnBlIDxyZWFscmljaGFyZHNoYXJwZUBn
bWFpbC5jb20+Ci0tLQogZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMgfCAgICA0ICsrKy0KIDEgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9saWJpc2NzaS5jIGIvZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMKaW5kZXgg
NmJmZmQ5MS4uYWJhZWZlMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMKKysr
IGIvZHJpdmVycy9zY3NpL2xpYmlzY3NpLmMKQEAgLTI2MTUsOSArMjYxNSwxMSBAQCBzdHJ1Y3Qg
U2NzaV9Ib3N0ICppc2NzaV9ob3N0X2FsbG9jKHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgKnNo
dCwKIAlpaG9zdCA9IHNob3N0X3ByaXYoc2hvc3QpOwogCiAJaWYgKHhtaXRfY2FuX3NsZWVwKSB7
CisJCWludCB3cV9mbGFncyA9IF9fV1FfTEVHQUNZIHwgV1FfTUVNX1JFQ0xBSU0gfCBXUV9ISUdI
UFJJOwogCQlzbnByaW50ZihpaG9zdC0+d29ya3FfbmFtZSwgc2l6ZW9mKGlob3N0LT53b3JrcV9u
YW1lKSwKIAkJCSJpc2NzaV9xXyVkIiwgc2hvc3QtPmhvc3Rfbm8pOwotCQlpaG9zdC0+d29ya3Eg
PSBjcmVhdGVfc2luZ2xldGhyZWFkX3dvcmtxdWV1ZShpaG9zdC0+d29ya3FfbmFtZSk7CisJCWlo
b3N0LT53b3JrcSA9IGFsbG9jX29yZGVyZWRfd29ya3F1ZXVlKCIlcyIsIHdxX2ZsYWdzLAorCQkJ
CQkJaWhvc3QtPndvcmtxX25hbWUpOwogCQlpZiAoIWlob3N0LT53b3JrcSkKIAkJCWdvdG8gZnJl
ZV9ob3N0OwogCX0KLS0gCjEuNy4xCgo=
--001a1143798a6abfea052f22000a--
