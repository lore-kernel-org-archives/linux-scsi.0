From: Brian King <brking@us.ibm.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Mon, 20 Feb 2006 17:00:09 -0600
Message-ID: <43FA49F9.4020309@us.ibm.com>
References: <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040704060205010003020800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45977 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1161188AbWBTXA1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 18:00:27 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1KN0BtO029475
	for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2006 18:00:11 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1KN0Ba8245548
	for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2006 18:00:11 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1KN0ASX032724
	for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2006 18:00:11 -0500
In-Reply-To: <20060210232935.GA27760@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040704060205010003020800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Olaf Hering wrote:
> 1:mon> d c0000000024cacc8
> c0000000024cacc8 00000000dead4ead ffffffff00000000  |......N.........|
> c0000000024cacd8 ffffffffffffffff c0000000024cace0  |.............L..|
> c0000000024cace8 c0000000024cace0 c000000000614f68  |.....L.......aOh|
> c0000000024cacf8 c000000000614f38 0000000000000000  |.....aO8........|
> c0000000024cad08 0000000000000000 0000000000000000  |................|
> c0000000024cad18 0000000000000000 0000000000000000  |................|
> c0000000024cad28 0000000000000000 0000000000000000  |................|
> c0000000024cad38 0000000000000000 0000000000000000  |................|
> c0000000024cad48 0000000000000000 0000000000000000  |................|
> c0000000024cad58 0000000000000000 0000000000000000  |................|
> c0000000024cad68 0000000000000000 0000000000000000  |................|
> c0000000024cad78 0000000000000000 0000000000000000  |................|
> c0000000024cad88 0000000000000000 0000000000000000  |................|
> c0000000024cad98 0000000000000000 0000000000000000  |................|
> c0000000024cada8 0000000000000000 0000000000000000  |................|
> c0000000024cadb8 0000000000000000 0000000000000000  |................|
> c0000000024cadc8 0000000000000000 0000000000000000  |................|
> c0000000024cadd8 0000000000000000 0000000000000000  |................|

I've now seen a couple recreates of this problem on various systems in
our labs, and there are always a bunch of zeroes in the struct device
in the same place as above. I wonder if perhaps the call to device_add
is failing in scsi_alloc_target. Failure of this call is not being handled
today. Can you give the attached patch a try? 

> c0000000024cade8 0000000000000000 c00000000303a1a8  |................|
> c0000000024cadf8 c0000000024cae00 746172676574303a  |.....L..target0:|
> c0000000024cae08 3235353a31303000 0000000000000006  |255:100.........|
> c0000000024cae18 c0000000024cae18 c0000000024cae18  |.....L.......L..|
> c0000000024cae28 c00000000303a2d8 c000000000500c88  |.............P..|
> c0000000024cae38 0000000000000000 0000000000000000  |................|
> c0000000024cae48 746172676574303a 3235353a31303000  |target0:255:100.|
> c0000000024cae58 0000000000000000 0000000000000000  |................|
> c0000000024cae68 0000000000000000 0000000000000000  |................|
> c0000000024cae78 0000000000000000 0000000000000000  |................|



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------040704060205010003020800
Content-Type: text/x-patch;
 name="scsi_alloc_target_device_add_failure.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="scsi_alloc_target_device_add_failure.patch"

CgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLaW5nIDxicmtpbmdAdXMuaWJtLmNvbT4KLS0tCgog
bGludXgtMi42LWJqa2luZzEvZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jIHwgICAxMSArKysr
KysrKystLQogMSBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC1wdU4gZHJpdmVycy9zY3NpL3Njc2lfc2Nhbi5jfnNjc2lfYWxsb2NfdGFy
Z2V0X2RldmljZV9hZGRfZmFpbHVyZSBkcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmMKLS0tIGxp
bnV4LTIuNi9kcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmN+c2NzaV9hbGxvY190YXJnZXRfZGV2
aWNlX2FkZF9mYWlsdXJlCTIwMDYtMDItMjAgMTQ6NTU6MTMuMDAwMDAwMDAwIC0wNjAwCisr
KyBsaW51eC0yLjYtYmpraW5nMS9kcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmMJMjAwNi0wMi0y
MCAxNjo1MToxNS4wMDAwMDAwMDAgLTA2MDAKQEAgLTM2MSw3ICszNjEsMTUgQEAgc3RhdGlj
IHN0cnVjdCBzY3NpX3RhcmdldCAqc2NzaV9hbGxvY190YQogCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoc2hvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwogCS8qIGFsbG9jYXRlIGFuZCBhZGQg
Ki8KIAl0cmFuc3BvcnRfc2V0dXBfZGV2aWNlKGRldik7Ci0JZGV2aWNlX2FkZChkZXYpOwor
CWlmIChkZXZpY2VfYWRkKGRldikpIHsKKwkJc3Bpbl9sb2NrX2lycXNhdmUoc2hvc3QtPmhv
c3RfbG9jaywgZmxhZ3MpOworCQlsaXN0X2RlbF9pbml0KCZzdGFyZ2V0LT5zaWJsaW5ncyk7
CisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoc2hvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwor
CQl0cmFuc3BvcnRfZGVzdHJveV9kZXZpY2UoZGV2KTsKKwkJcHV0X2RldmljZShwYXJlbnQp
OworCQlrZnJlZShzdGFyZ2V0KTsKKwkJcmV0dXJuIE5VTEw7CisJfQogCXRyYW5zcG9ydF9h
ZGRfZGV2aWNlKGRldik7CiAJaWYgKHNob3N0LT5ob3N0dC0+dGFyZ2V0X2FsbG9jKSB7CiAJ
CWludCBlcnJvciA9IHNob3N0LT5ob3N0dC0+dGFyZ2V0X2FsbG9jKHN0YXJnZXQpOwpAQCAt
NDAzLDcgKzQxMSw2IEBAIHN0YXRpYyB2b2lkIHNjc2lfdGFyZ2V0X3JlYXBfdXNlcmNvbnRl
eHQKIAkJdHJhbnNwb3J0X2Rlc3Ryb3lfZGV2aWNlKCZzdGFyZ2V0LT5kZXYpOwogCQlwdXRf
ZGV2aWNlKCZzdGFyZ2V0LT5kZXYpOwogCQlyZXR1cm47Ci0KIAl9CiAJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZShzaG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CiAKXwo=
--------------040704060205010003020800--
