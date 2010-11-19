From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 7/9] scsi: megaraid_sas - Driver created the self work queue
 for OCR
Date: Fri, 19 Nov 2010 10:37:02 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106A9621E@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4B6A08C587958942AA3002690DD4F8C30106A9621Ecosmail02lsic_"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A96218@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

--_002_4B6A08C587958942AA3002690DD4F8C30106A9621Ecosmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Driver created the owner work queue (don't use global work queue). This que=
ue will be used for online controller reset routine.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--_002_4B6A08C587958942AA3002690DD4F8C30106A9621Ecosmail02lsic_
Content-Type: application/octet-stream; name="megasas-p7-workqueue.patch"
Content-Description: megasas-p7-workqueue.patch
Content-Disposition: attachment; filename="megasas-p7-workqueue.patch";
	size=1593; creation-date="Thu, 18 Nov 2010 20:37:02 GMT";
	modification-date="Wed, 17 Nov 2010 13:09:12 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5jIG5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMKLS0tIG9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0xNyAxMzo0NjoxMS4wMDAwMDAwMDAgLTA1
MDAKKysrIG5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0x
NyAxMzo0Nzo0Ni4wMDAwMDAwMDAgLTA1MDAKQEAgLTEwOCw2ICsxMDgsNyBAQCBzdGF0aWMgc3Ry
dWN0IG1lZ2FzYXNfbWdtdF9pbmZvIG1lZ2FzYXNfCiBzdGF0aWMgc3RydWN0IGZhc3luY19zdHJ1
Y3QgKm1lZ2FzYXNfYXN5bmNfcXVldWU7CiBzdGF0aWMgREVGSU5FX01VVEVYKG1lZ2FzYXNfYXN5
bmNfcXVldWVfbXV0ZXgpOwogCitzdGF0aWMgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKm1lZ2Fz
YXNfb2NyX3dxOwogc3RhdGljIGludCBtZWdhc2FzX3BvbGxfd2FpdF9hZW47CiBzdGF0aWMgREVD
TEFSRV9XQUlUX1FVRVVFX0hFQUQobWVnYXNhc19wb2xsX3dhaXQpOwogc3RhdGljIHUzMiBzdXBw
b3J0X3BvbGxfZm9yX2V2ZW50OwpAQCAtMjQzNSw3ICsyNDM2LDcgQEAgbWVnYXNhc19kZXBsZXRl
X3JlcGx5X3F1ZXVlKHN0cnVjdCBtZWdhcwogCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhc2Fz
OiBmd1N0YXRlPSV4LCBzdGFnZTolZFxuIiwKIAkJCQkJZndfc3RhdGUsIGluc3RhbmNlLT5hZHBy
ZWNvdmVyeSk7CiAKLQkJCXNjaGVkdWxlX3dvcmsoJmluc3RhbmNlLT53b3JrX2luaXQpOworCQkJ
cXVldWVfd29yayhtZWdhc2FzX29jcl93cSwgJmluc3RhbmNlLT53b3JrX2luaXQpOwogCQkJcmV0
dXJuIElSUV9IQU5ETEVEOwogCiAJCX0gZWxzZSB7CkBAIC01MTU3LDYgKzUxNTgsMTEgQEAgc3Rh
dGljIGludCBfX2luaXQgbWVnYXNhc19pbml0KHZvaWQpCiAJCWdvdG8gZXJyX3BjaWRydjsKIAl9
CiAKKwltZWdhc2FzX29jcl93cSA9IGNyZWF0ZV93b3JrcXVldWUoIm1lZ2FzYXNfb2NyIik7CisK
KwlpZiAoICFtZWdhc2FzX29jcl93cSApCisJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBG
YWlsZWQgdG8gY3JlYXRlIHdvcmtxdWV1ZS5cbiIpOworCiAJcnZhbCA9IGRyaXZlcl9jcmVhdGVf
ZmlsZSgmbWVnYXNhc19wY2lfZHJpdmVyLmRyaXZlciwKIAkJCQkgICZkcml2ZXJfYXR0cl92ZXJz
aW9uKTsKIAlpZiAocnZhbCkKQEAgLTUyMjgsNiArNTIzNCwxMSBAQCBzdGF0aWMgdm9pZCBfX2V4
aXQgbWVnYXNhc19leGl0KHZvaWQpCiAJCQkgICAmZHJpdmVyX2F0dHJfcmVsZWFzZV9kYXRlKTsK
IAlkcml2ZXJfcmVtb3ZlX2ZpbGUoJm1lZ2FzYXNfcGNpX2RyaXZlci5kcml2ZXIsICZkcml2ZXJf
YXR0cl92ZXJzaW9uKTsKIAorCWlmIChtZWdhc2FzX29jcl93cSkgeworCQlkZXN0cm95X3dvcmtx
dWV1ZShtZWdhc2FzX29jcl93cSk7CisJCW1lZ2FzYXNfb2NyX3dxID0gTlVMTDsKKwl9CisKIAlw
Y2lfdW5yZWdpc3Rlcl9kcml2ZXIoJm1lZ2FzYXNfcGNpX2RyaXZlcik7CiAJdW5yZWdpc3Rlcl9j
aHJkZXYobWVnYXNhc19tZ210X21ham9ybm8sICJtZWdhcmFpZF9zYXNfaW9jdGwiKTsKIH0K

--_002_4B6A08C587958942AA3002690DD4F8C30106A9621Ecosmail02lsic_--
