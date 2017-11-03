From: "=?utf-8?B?6ZmI5Y2O5omN?=" <chenhc@lemote.com>
Subject: Re: [PATCH V9 1/4] dma-mapping: Rework dma_get_cache_alignment()
Date: Fri, 3 Nov 2017 14:15:41 +0800
Message-ID: <tencent_6BDFE15F713B83B37D2C6D88@qq.com>
References: <CGME20171023071025epcas4p3e9b9c0af7c0a34561f0d57a20a4f9946@epcas4p3.samsung.com>
        <1508742767-28366-1-git-send-email-chenhc@lemote.com>
        <0f34e021-a559-3e3c-4586-48450e87d5c8@samsung.com>
        <tencent_06493D0500CE277740BDF088@qq.com>
        <7ac87ae6-32e5-bd14-32a1-abdcf8aa8221@samsung.com>
        <tencent_6576ECDE049EE8921F2D13BB@qq.com>
        <tencent_56D97C65293D16191A2D88C9@qq.com>
        <20171103051445.GA14933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:33836 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdKCGPy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Nov 2017 02:15:54 -0400
In-Reply-To: <20171103051445.GA14933@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: =?utf-8?B?TWFyZWsgU3p5cHJvd3NraQ==?= <m.szyprowski@samsung.com>, =?utf-8?B?Q2hyaXN0b3BoIEhlbGx3aWc=?= <hch@lst.de>, =?utf-8?B?Um9iaW4gTXVycGh5?= <robin.murphy@arm.com>, =?utf-8?B?QW5kcmV3IE1vcnRvbg==?= <akpm@linux-foundation.org>, =?utf-8?B?RnV4aW4gWmhhbmc=?= <zhangfx@lemote.com>, =?utf-8?B?bGludXgta2VybmVs?= <linux-kernel@vger.kernel.org>, =?utf-8?B?UmFsZiBCYWVjaGxl?= <ralf@linux-mips.org>, =?utf-8?B?SmFtZXNIb2dhbg==?= <james.hogan@imgtec.com>, =?utf-8?B?bGludXgtbWlwcw==?= <linux-mips@linux-mips.org>, =?utf-8?B?SmFtZXMgRSAuIEogLkJvdHRvbWxleQ==?= <jejb@linux.vnet.ibm.com>, =?utf-8?B?TWFydGluIEsgLiBQZXRlcnNlbg==?= <martin.petersen@oracle.com>, =?utf-8?B?bGludXgtc2NzaQ==?= <linux-scsi@vger.kernel.org>, =?utf-8?B?c3RhYmxl?= <stable@vger.kernel.org>

T25seSBwYXRjaCA0IGNhbiBiZSBtZXJnZWQgdG8gc3RhYmxlLCBwbGVhc2UgaWdub3JlIGNj
LXN0YWJsZSBpbiB0aGUgcmVzdC4NCiANCi0tLS0tLS0tLS0tLS0tLS0tLSBPcmlnaW5hbCAt
LS0tLS0tLS0tLS0tLS0tLS0NCkZyb206ICAiQ2hyaXN0b3BoIEhlbGx3aWciPGhjaEBsc3Qu
ZGU+Ow0KRGF0ZTogIEZyaSwgTm92IDMsIDIwMTcgMDE6MTQgUE0NClRvOiAgIumZiOWNjuaJ
jSI8Y2hlbmhjQGxlbW90ZS5jb20+OyANCkNjOiAgIk1hcmVrIFN6eXByb3dza2kiPG0uc3p5
cHJvd3NraUBzYW1zdW5nLmNvbT47ICJDaHJpc3RvcGggSGVsbHdpZyI8aGNoQGxzdC5kZT47
ICJSb2JpbiBNdXJwaHkiPHJvYmluLm11cnBoeUBhcm0uY29tPjsgIkFuZHJldyBNb3J0b24i
PGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+OyAiRnV4aW4gWmhhbmciPHpoYW5nZnhAbGVt
b3RlLmNvbT47ICJsaW51eC1rZXJuZWwiPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+
OyAiUmFsZiBCYWVjaGxlIjxyYWxmQGxpbnV4LW1pcHMub3JnPjsgIkphbWVzSG9nYW4iPGph
bWVzLmhvZ2FuQGltZ3RlYy5jb20+OyAibGludXgtbWlwcyI8bGludXgtbWlwc0BsaW51eC1t
aXBzLm9yZz47ICJKYW1lcyBFIC4gSiAuQm90dG9tbGV5IjxqZWpiQGxpbnV4LnZuZXQuaWJt
LmNvbT47ICJNYXJ0aW4gSyAuIFBldGVyc2VuIjxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNv
bT47ICJsaW51eC1zY3NpIjxsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZz47ICJzdGFibGUi
PHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+OyAiTWljaGFlbCBTIC4gVHNpcmtpbiI8bXN0QHJl
ZGhhdC5jb20+OyAiUGF3ZWwgT3NjaWFrIjxwYXdlbEBvc2NpYWsuY29tPjsgIkt5dW5nbWlu
IFBhcmsiPGt5dW5nbWluLnBhcmtAc2Ftc3VuZy5jb20+OyAiTWljaGFlbCBDaGFuIjxtaWNo
YWVsLmNoYW5AYnJvYWRjb20uY29tPjsgIkJlbmphbWluIEhlcnJlbnNjaG1pZHQiPGJlbmhA
a2VybmVsLmNyYXNoaW5nLm9yZz47ICJJdmFuIE1pa2hheWxvdiI8aXZhbkBydS5pYm0uY29t
PjsgIlRhcmlxIFRvdWthbiI8dGFyaXF0QG1lbGxhbm94LmNvbT47ICJBbmR5IEdyb3NzIjxh
Z3Jvc3NAY29kZWF1cm9yYS5vcmc+OyAiTWFyayBBIC4gR3JlZXIiPG1ncmVlckBhbmltYWxj
cmVlay5jb20+OyAiUm9iZXJ0QmFsZHlnYSI8ci5iYWxkeWdhQGhhY2tlcmlvbi5jb20+OyAN
ClN1YmplY3Q6ICBSZTogW1BBVENIIFY5IDEvNF0gZG1hLW1hcHBpbmc6IFJld29yayBkbWFf
Z2V0X2NhY2hlX2FsaWdubWVudCgpDQoNCiANCkkgY2FuIHF1ZXVlIDEgdXAgaW4gdGhlIGRt
YS1tYXBwaW5nIHRyZWUsIGFuZCBpZiBJIGdldCByZXZpZXdzIGZvcg0KdGhlIG1pcHMgYW5k
IHNjc2kgYml0cyBJJ2QgYmUgaGFwcHkgdG8gcXVldWUgdGhvc2UgdXAgYXMgd2VsbC4NCg0K
QnV0IEkgdGhpbmsgeW91J2QgYmUgYmV0dGVyIG9mZiBtb3ZpbmcgcGF0Y2hlcyAzIGFuZCA0
IHRvIHRoZSBmcm9udA0Kd2l0aG91dCB0aGUgZG1hX2dldF9jYWNoZV9hbGlnbm1lbnQgcHJv
dG90eXBlIGNoYW5nZSBzbyB0aGF0IHRoZXkgY2FuIGJlDQptZXJnZWQgdG8gc3RhYmxlLg==
