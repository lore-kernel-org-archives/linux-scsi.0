From: <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Wed, 1 Jun 2011 16:50:09 -0700
Message-ID: <50725EF61B96174EB1803401F1A2E3733508E57DFF@EXMAIL.ad.emulex.com>
References: <4DD6AEB7.2090900@redhat.com> <4DD6AF29.8090903@redhat.com>
    <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com>,<4DD6B83B.5000703@redhat.com>
    <50725EF61B96174EB1803401F1A2E3733508E57DFE@EXMAIL.ad.emulex.com>,<67dd21012f4b055efd0ef484712ddb30.squirrel@webmail.sf-mail.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_50725EF61B96174EB1803401F1A2E3733508E57DFFEXMAILademule_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht2.emulex.com ([138.239.113.184]:55612 "EHLO
	exht2.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752448Ab1FAXup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2011 19:50:45 -0400
In-Reply-To: <67dd21012f4b055efd0ef484712ddb30.squirrel@webmail.sf-mail.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eike-kernel@sf-tec.de
Cc: prarit@redhat.com, linux-scsi@vger.kernel.org, mchristi@redhat.com

--_002_50725EF61B96174EB1803401F1A2E3733508E57DFFEXMAILademule_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Removed the redundant check for (!i) and reworked the patch.

Thanks
Jay
________________________________________
From: Rolf Eike Beer [eike-kernel@sf-tec.de]
Sent: Wednesday, June 01, 2011 12:41 PM
To: Kallickal, Jayamohan
Cc: prarit@redhat.com; linux-scsi@vger.kernel.org; mchristi@redhat.com
Subject: RE: [PATCH]: be2iscsi: Fix MSIX interrupt names

> I have taken the original patch from Prarit and made changes to move the
> allocation
> inside the main for loop along with request_irq.
>
> I feel doing devres would be good but going to take some time. However, w=
e
> need to fix this now and hence
> am submitting this patch. When we have a final devres solution working an=
d
> tested ,we would move over.

I think this is a good way to go.

+                       if (!phba->msi_name[i]) {
+                               ret =3D -ENOMEM;
+                               if (!i)
+                                       return ret;
+                               goto free_msix_irqs;
+                       }

That "if (!i)" stuff is useless. If you enter the loop with i=3D=3D0 j will
become -1 which causes the loop never to execute. The same is true for the
request_irq() error handling below.

Eike

--_002_50725EF61B96174EB1803401F1A2E3733508E57DFFEXMAILademule_
Content-Type: application/octet-stream;
	name="0001-be2iscsi-Fixing-the-proc-interrupts-problem-V2.patch"
Content-Description: 0001-be2iscsi-Fixing-the-proc-interrupts-problem-V2.patch
Content-Disposition: attachment;
	filename="0001-be2iscsi-Fixing-the-proc-interrupts-problem-V2.patch";
	size=3823; creation-date="Wed, 01 Jun 2011 23:48:41 GMT";
	modification-date="Wed, 01 Jun 2011 23:48:41 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzOGIzYmMxY2IzYzc5MzZmNWExYzkxODM1ZDVhNzBjNzE3NWFiMDUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXlhbW9oYW4gS2FsbGlja2FsIDxqYXlhbW9oYW4ua2FsbGlj
a2FsQGVtdWxleC5jb20+CkRhdGU6IFdlZCwgMSBKdW4gMjAxMSAxNjoyMjoyNyAtMDcwMApTdWJq
ZWN0OiBbUEFUQ0ggMS8xXSBiZTJpc2NzaTpGaXhpbmcgdGhlIC9wcm9jL2ludGVycnVwdHMgcHJv
YmxlbSBWMgoKICAgVGhpcyBwYXRjaCBpcyBiYXNlZCBvbiBvbmUgYnkgUHJhcml0IEJoYXJnYXZh
LiBJIGhhdmUgbWFkZSBtaW5vcgpjaGFuZ2VzLiBBbHNvLCByZW1vdmVkIHRoZSByZWR1bmRhbnQg
Y2hlY2sgZm9yIGkgPT0gMCBhcyBzdWdnZXN0ZWQKYnkgUm9sZi4KClNpZ25lZC1vZmYtYnk6IFBy
YXJpdCBCaGFyZ2F2YSA8cHJhcml0QHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IEpheWFtb2hh
biBLYWxsaWNrYWwgPGpheWFtb2hhbixrYWxsaWNrYWxAZW11bGV4LmNvbT4KLS0tCiBkcml2ZXJz
L3Njc2kvYmUyaXNjc2kvYmVfbWFpbi5jIHwgICAzMyArKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0KIGRyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tYWluLmggfCAgICAzICsrKwogMiBm
aWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tYWluLmMgYi9kcml2ZXJzL3Njc2kvYmUyaXNj
c2kvYmVfbWFpbi5jCmluZGV4IDk0YjlhMDcuLjBiM2U1MjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c2NzaS9iZTJpc2NzaS9iZV9tYWluLmMKKysrIGIvZHJpdmVycy9zY3NpL2JlMmlzY3NpL2JlX21h
aW4uYwpAQCAtODc1LDMzICs4NzUsNDYgQEAgc3RhdGljIGludCBiZWlzY3NpX2luaXRfaXJxcyhz
dHJ1Y3QgYmVpc2NzaV9oYmEgKnBoYmEpCiAJc3RydWN0IGh3aV9jb250cm9sbGVyICpwaHdpX2N0
cmxyOwogCXN0cnVjdCBod2lfY29udGV4dF9tZW1vcnkgKnBod2lfY29udGV4dDsKIAlpbnQgcmV0
LCBtc2l4X3ZlYywgaSwgajsKLQljaGFyIGRlc2NbMzJdOwogCiAJcGh3aV9jdHJsciA9IHBoYmEt
PnBod2lfY3RybHI7CiAJcGh3aV9jb250ZXh0ID0gcGh3aV9jdHJsci0+cGh3aV9jdHh0OwogCiAJ
aWYgKHBoYmEtPm1zaXhfZW5hYmxlZCkgewogCQlmb3IgKGkgPSAwOyBpIDwgcGhiYS0+bnVtX2Nw
dXM7IGkrKykgewotCQkJc3ByaW50ZihkZXNjLCAiYmVpc2NzaV9tc2l4XyUwNHgiLCBpKTsKKwkJ
CXBoYmEtPm1zaV9uYW1lW2ldID0ga3phbGxvYyhCRUlTQ1NJX01TSV9OQU1FLCBHRlBfS0VSTkVM
KTsKKwkJCWlmICghcGhiYS0+bXNpX25hbWVbaV0pIHsKKwkJCQlyZXQgPSAtRU5PTUVNOworCQkJ
CWdvdG8gZnJlZV9tc2l4X2lycXM7CisJCQl9CisKKwkJCXNwcmludGYocGhiYS0+bXNpX25hbWVb
aV0sICJiZWlzY3NpXyUwMnhfJTAyeCIsCisJCQkJcGhiYS0+c2hvc3QtPmhvc3Rfbm8sIGkpOwog
CQkJbXNpeF92ZWMgPSBwaGJhLT5tc2l4X2VudHJpZXNbaV0udmVjdG9yOwotCQkJcmV0ID0gcmVx
dWVzdF9pcnEobXNpeF92ZWMsIGJlX2lzcl9tc2l4LCAwLCBkZXNjLAorCQkJcmV0ID0gcmVxdWVz
dF9pcnEobXNpeF92ZWMsIGJlX2lzcl9tc2l4LCAwLAorCQkJCQkgIHBoYmEtPm1zaV9uYW1lW2ld
LAogCQkJCQkgICZwaHdpX2NvbnRleHQtPmJlX2VxW2ldKTsKIAkJCWlmIChyZXQpIHsKIAkJCQlz
aG9zdF9wcmludGsoS0VSTl9FUlIsIHBoYmEtPnNob3N0LAogCQkJCQkgICAgICJiZWlzY3NpX2lu
aXRfaXJxcy1GYWlsZWQgdG8iCiAJCQkJCSAgICAgInJlZ2lzdGVyIG1zaXggZm9yIGkgPSAlZFxu
IiwgaSk7Ci0JCQkJaWYgKCFpKQotCQkJCQlyZXR1cm4gcmV0OworCQkJCWtmcmVlKHBoYmEtPm1z
aV9uYW1lW2ldKTsKIAkJCQlnb3RvIGZyZWVfbXNpeF9pcnFzOwogCQkJfQogCQl9CisJCXBoYmEt
Pm1zaV9uYW1lW2ldID0ga3phbGxvYyhCRUlTQ1NJX01TSV9OQU1FLCBHRlBfS0VSTkVMKTsKKwkJ
aWYgKCFwaGJhLT5tc2lfbmFtZVtpXSkgeworCQkJcmV0ID0gLUVOT01FTTsKKwkJCWdvdG8gZnJl
ZV9tc2l4X2lycXM7CisJCX0KKwkJc3ByaW50ZihwaGJhLT5tc2lfbmFtZVtpXSwgImJlaXNjc2lf
bWNjXyUwMngiLAorCQkJcGhiYS0+c2hvc3QtPmhvc3Rfbm8pOwogCQltc2l4X3ZlYyA9IHBoYmEt
Pm1zaXhfZW50cmllc1tpXS52ZWN0b3I7Ci0JCXJldCA9IHJlcXVlc3RfaXJxKG1zaXhfdmVjLCBi
ZV9pc3JfbWNjLCAwLCAiYmVpc2NzaV9tc2l4X21jYyIsCisJCXJldCA9IHJlcXVlc3RfaXJxKG1z
aXhfdmVjLCBiZV9pc3JfbWNjLCAwLCBwaGJhLT5tc2lfbmFtZVtpXSwKIAkJCQkgICZwaHdpX2Nv
bnRleHQtPmJlX2VxW2ldKTsKIAkJaWYgKHJldCkgewogCQkJc2hvc3RfcHJpbnRrKEtFUk5fRVJS
LCBwaGJhLT5zaG9zdCwgImJlaXNjc2lfaW5pdF9pcnFzLSIKIAkJCQkgICAgICJGYWlsZWQgdG8g
cmVnaXN0ZXIgYmVpc2NzaV9tc2l4X21jY1xuIik7Ci0JCQlpKys7CisJCQlrZnJlZShwaGJhLT5t
c2lfbmFtZVtpXSk7CiAJCQlnb3RvIGZyZWVfbXNpeF9pcnFzOwogCQl9CiAKQEAgLTkxNiw4ICs5
MjksMTEgQEAgc3RhdGljIGludCBiZWlzY3NpX2luaXRfaXJxcyhzdHJ1Y3QgYmVpc2NzaV9oYmEg
KnBoYmEpCiAJfQogCXJldHVybiAwOwogZnJlZV9tc2l4X2lycXM6Ci0JZm9yIChqID0gaSAtIDE7
IGogPT0gMDsgaisrKQorCWZvciAoaiA9IGkgLSAxOyBqID49IDA7IGotLSkgeworCQlrZnJlZShw
aGJhLT5tc2lfbmFtZVtqXSk7CisJCW1zaXhfdmVjID0gcGhiYS0+bXNpeF9lbnRyaWVzW2pdLnZl
Y3RvcjsKIAkJZnJlZV9pcnEobXNpeF92ZWMsICZwaHdpX2NvbnRleHQtPmJlX2VxW2pdKTsKKwl9
CiAJcmV0dXJuIHJldDsKIH0KIApAQCAtNDEyMyw2ICs0MTM5LDcgQEAgc3RhdGljIHZvaWQgYmVp
c2NzaV9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBjaWRldikKIAkJZm9yIChpID0gMDsgaSA8PSBw
aGJhLT5udW1fY3B1czsgaSsrKSB7CiAJCQltc2l4X3ZlYyA9IHBoYmEtPm1zaXhfZW50cmllc1tp
XS52ZWN0b3I7CiAJCQlmcmVlX2lycShtc2l4X3ZlYywgJnBod2lfY29udGV4dC0+YmVfZXFbaV0p
OworCQkJa2ZyZWUocGhiYS0+bXNpX25hbWVbaV0pOwogCQl9CiAJfSBlbHNlCiAJCWlmIChwaGJh
LT5wY2lkZXYtPmlycSkKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tYWlu
LmggYi9kcml2ZXJzL3Njc2kvYmUyaXNjc2kvYmVfbWFpbi5oCmluZGV4IDA4MWMxNzEuLjFhNTVh
ZWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9iZTJpc2NzaS9iZV9tYWluLmgKKysrIGIvZHJp
dmVycy9zY3NpL2JlMmlzY3NpL2JlX21haW4uaApAQCAtMTYyLDYgKzE2Miw4IEBAIGRvIHsJCQkJ
CQkJXAogI2RlZmluZSBQQUdFU19SRVFVSVJFRCh4KSBcCiAJKCh4IDwgUEFHRV9TSVpFKSA/IDEg
OiAgKCh4ICsgUEFHRV9TSVpFIC0gMSkgLyBQQUdFX1NJWkUpKQogCisjZGVmaW5lIEJFSVNDU0lf
TVNJX05BTUUgMjAgLyogc2l6ZSBvZiBtc2lfbmFtZSBzdHJpbmcgKi8KKwogZW51bSBiZV9tZW1f
ZW51bSB7CiAJSFdJX01FTV9BREROX0NPTlRFWFQsCiAJSFdJX01FTV9XUkIsCkBAIC0yODcsNiAr
Mjg5LDcgQEAgc3RydWN0IGJlaXNjc2lfaGJhIHsKIAl1bnNpZ25lZCBpbnQgbnVtX2NwdXM7CiAJ
dW5zaWduZWQgaW50IG54dF9jcWlkOwogCXN0cnVjdCBtc2l4X2VudHJ5IG1zaXhfZW50cmllc1tN
QVhfQ1BVUyArIDFdOworCWNoYXIgKm1zaV9uYW1lW01BWF9DUFVTICsgMV07CiAJYm9vbCBtc2l4
X2VuYWJsZWQ7CiAJc3RydWN0IGJlX21lbV9kZXNjcmlwdG9yICppbml0X21lbTsKIAotLSAKMS43
LjEKCg==

--_002_50725EF61B96174EB1803401F1A2E3733508E57DFFEXMAILademule_--
