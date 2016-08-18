From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Thu, 18 Aug 2016 14:59:59 +0000
Message-ID: <SN1PR0201MB1870C7DFF1595905BDAE985F81150@SN1PR0201MB1870.namprd02.prod.outlook.com>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="_002_SN1PR0201MB1870C7DFF1595905BDAE985F81150SN1PR0201MB1870_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0082.outbound.protection.outlook.com ([104.47.33.82]:3433
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753788AbcHSCjr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Aug 2016 22:39:47 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

--_002_SN1PR0201MB1870C7DFF1595905BDAE985F81150SN1PR0201MB1870_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 08/17/16 22:55, Sreekanth Reddy wrote:=0A=
> Observing softlockups while running heavy IOs on 8 SSD drives=0A=
> connected behind our LSI SAS 3004 HBA.=0A=
=0A=
Hello Sreekanth,=0A=
=0A=
This means that more than 23s was spent before the scheduler was =0A=
invoked, probably due to a loop. Can you give the attached (untested) =0A=
patch a try to see whether it is the loop in __blk_mq_run_hw_queue()?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
=0A=

--_002_SN1PR0201MB1870C7DFF1595905BDAE985F81150SN1PR0201MB1870_
Content-Type: text/x-patch;
	name="0001-block-Measure-__blk_mq_run_hw_queue-execution-time.patch"
Content-Description: 0001-block-Measure-__blk_mq_run_hw_queue-execution-time.patch
Content-Disposition: attachment;
	filename="0001-block-Measure-__blk_mq_run_hw_queue-execution-time.patch";
	size=1132; creation-date="Thu, 18 Aug 2016 14:59:58 GMT";
	modification-date="Thu, 18 Aug 2016 14:59:58 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0ZGE5NGYyZWMzN2VlNWQxYjRhNWYxY2UyODg2YmRhZmQ1Y2QzOTRjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHNhbmRp
c2suY29tPgpEYXRlOiBUaHUsIDE4IEF1ZyAyMDE2IDA3OjUxOjQ5IC0wNzAwClN1YmplY3Q6IFtQ
QVRDSF0gYmxvY2s6IE1lYXN1cmUgX19ibGtfbXFfcnVuX2h3X3F1ZXVlKCkgZXhlY3V0aW9uIHRp
bWUKCk5vdGU6IHRoZSAibWF4X2VsYXBzZWQiIHZhcmlhYmxlIGNhbiBiZSBtb2RpZmllZCBieSBt
dWx0aXBsZSB0aHJlYWRzCmNvbmN1cnJlbnRseS4KLS0tCiBibG9jay9ibGstbXEuYyB8IDEwICsr
KysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEv
YmxvY2svYmxrLW1xLmMgYi9ibG9jay9ibGstbXEuYwppbmRleCBlOTMxYTBlLi42ZDA5NjFjIDEw
MDY0NAotLS0gYS9ibG9jay9ibGstbXEuYworKysgYi9ibG9jay9ibGstbXEuYwpAQCAtNzkyLDYg
Kzc5Miw5IEBAIHN0YXRpYyB2b2lkIF9fYmxrX21xX3J1bl9od19xdWV1ZShzdHJ1Y3QgYmxrX21x
X2h3X2N0eCAqaGN0eCkKIAlMSVNUX0hFQUQoZHJpdmVyX2xpc3QpOwogCXN0cnVjdCBsaXN0X2hl
YWQgKmRwdHI7CiAJaW50IHF1ZXVlZDsKKwlzdGF0aWMgbG9uZyBtYXhfZWxhcHNlZCA9IC0xOwor
CXVuc2lnbmVkIGxvbmcgc3RhcnQgPSBqaWZmaWVzOworCWxvbmcgZWxhcHNlZDsKIAogCVdBUk5f
T04oIWNwdW1hc2tfdGVzdF9jcHUocmF3X3NtcF9wcm9jZXNzb3JfaWQoKSwgaGN0eC0+Y3B1bWFz
aykpOwogCkBAIC04ODksNiArODkyLDEzIEBAIHN0YXRpYyB2b2lkIF9fYmxrX21xX3J1bl9od19x
dWV1ZShzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCkKIAkJICoqLwogCQlibGtfbXFfcnVuX2h3
X3F1ZXVlKGhjdHgsIHRydWUpOwogCX0KKworCWVsYXBzZWQgPSBqaWZmaWVzIC0gc3RhcnQ7CisJ
aWYgKGVsYXBzZWQgPiBtYXhfZWxhcHNlZCkgeworCQltYXhfZWxhcHNlZCA9IGVsYXBzZWQ7CisJ
CXByX2luZm8oIiVzKCkgZmluaXNoZWQgYWZ0ZXIgJWQgbXNcbiIsIF9fZnVuY19fLAorCQkJamlm
Zmllc190b19tc2VjcyhlbGFwc2VkKSk7CisJfQogfQogCiAvKgotLSAKMi45LjIKCg==

--_002_SN1PR0201MB1870C7DFF1595905BDAE985F81150SN1PR0201MB1870_--
