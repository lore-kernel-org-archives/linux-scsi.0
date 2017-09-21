From: "=?utf-8?B?6ZmI5Y2O5omN?=" <chenhc@lemote.com>
Subject: Re: [PATCH V6 2/3] dma-mapping: Rework dma_get_cache_alignment()function
Date: Thu, 21 Sep 2017 12:28:25 +0800
Message-ID: <tencent_0C366F4D229840FF7D683E10@qq.com>
References: <1505811161-25246-1-git-send-email-chenhc@lemote.com>
        <1505811161-25246-2-git-send-email-chenhc@lemote.com>
        <20170919150252.GA23540@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170919150252.GA23540@lst.de>
Sender: stable-owner@vger.kernel.org
Cc: =?utf-8?B?Q2hyaXN0b3BoIEhlbGx3aWc=?= <hch@lst.de>, =?utf-8?B?TWFyZWsgU3p5cHJvd3NraQ==?= <m.szyprowski@samsung.com>, =?utf-8?B?Um9iaW4gTXVycGh5?= <robin.murphy@arm.com>, =?utf-8?B?QW5kcmV3IE1vcnRvbg==?= <akpm@linux-foundation.org>, =?utf-8?B?RnV4aW4gWmhhbmc=?= <zhangfx@lemote.com>, =?utf-8?B?bGludXgta2VybmVs?= <linux-kernel@vger.kernel.org>, =?utf-8?B?SmFtZXMgRSAuIEogLiBCb3R0b21sZXk=?= <jejb@linux.vnet.ibm.com>, =?utf-8?B?TWFydGluIEsgLiBQZXRlcnNlbg==?= <martin.petersen@oracle.com>, =?utf-8?B?bGludXgtc2NzaQ==?= <linux-scsi@vger.kernel.org>, =?utf-8?B?c3RhYmxl?= <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

SGksIENocmlzdG9waCwNCg0KSSBoYXZlIGNoYW5nZWQgZG1hX2dldF9jYWNoZV9hbGlnbm1l
bnQncyByZXR1cm4gdmFsdWUsIGFuZCBJIGRvbid0IGtub3cgd2hldGhlciB0aG9zZSBkcml2
ZXJzIHdhbnQgdG8gcmV0dXJuIEFSQ0hfRE1BX01JTkFMSUdOIHVuY29uZGl0aW9uYWxseS4g
U28gSSBwYXNzIGEgTlVMTCBmb3IgdGhvc2UgZHJpdmVycywgaW4gb3JkZXIgdG8ga2VlcCB0
aGVpciBvbGQgYmVoYXZpb3IuDQogDQpIdWFjYWkNCiANCi0tLS0tLS0tLS0tLS0tLS0tLSBP
cmlnaW5hbCAtLS0tLS0tLS0tLS0tLS0tLS0NCkZyb206ICAiQ2hyaXN0b3BoIEhlbGx3aWci
PGhjaEBsc3QuZGU+Ow0KRGF0ZTogIFR1ZSwgU2VwIDE5LCAyMDE3IDExOjAyIFBNDQpUbzog
ICJIdWFjYWkgQ2hlbiI8Y2hlbmhjQGxlbW90ZS5jb20+OyANCkNjOiAgIkNocmlzdG9waCBI
ZWxsd2lnIjxoY2hAbHN0LmRlPjsgIk1hcmVrIFN6eXByb3dza2kiPG0uc3p5cHJvd3NraUBz
YW1zdW5nLmNvbT47ICJSb2JpbiBNdXJwaHkiPHJvYmluLm11cnBoeUBhcm0uY29tPjsgIkFu
ZHJldyBNb3J0b24iPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+OyAiRnV4aW4gWmhhbmci
PHpoYW5nZnhAbGVtb3RlLmNvbT47ICJsaW51eC1rZXJuZWwiPGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc+OyAiSmFtZXMgRSAuIEogLiBCb3R0b21sZXkiPGplamJAbGludXgudm5l
dC5pYm0uY29tPjsgIk1hcnRpbiBLIC4gUGV0ZXJzZW4iPG1hcnRpbi5wZXRlcnNlbkBvcmFj
bGUuY29tPjsgImxpbnV4LXNjc2kiPGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPjsgInN0
YWJsZSI8c3RhYmxlQHZnZXIua2VybmVsLm9yZz47IA0KU3ViamVjdDogIFJlOiBbUEFUQ0gg
VjYgMi8zXSBkbWEtbWFwcGluZzogUmV3b3JrIGRtYV9nZXRfY2FjaGVfYWxpZ25tZW50KClm
dW5jdGlvbg0KDQogDQo+ICAJbWRldi0+bGltaXRzLnJlc2VydmVkX210dHMgPSBBTElHTiht
ZGV2LT5saW1pdHMucmVzZXJ2ZWRfbXR0cyAqIG1kZXYtPmxpbWl0cy5tdHRfc2VnX3NpemUs
DQo+IC0JCQkJCSAgIGRtYV9nZXRfY2FjaGVfYWxpZ25tZW50KCkpIC8gbWRldi0+bGltaXRz
Lm10dF9zZWdfc2l6ZTsNCj4gKwkJCQkJICAgZG1hX2dldF9jYWNoZV9hbGlnbm1lbnQoTlVM
TCkpIC8gbWRldi0+bGltaXRzLm10dF9zZWdfc2l6ZTsNCj4gIA0KPiAgCW1kZXYtPm1yX3Rh
YmxlLm10dF90YWJsZSA9IG10aGNhX2FsbG9jX2ljbV90YWJsZShtZGV2LCBpbml0X2hjYS0+
bXR0X2Jhc2UsDQoNClBsZWFzZSBwYXNzIHRoZSBhY3R1YWxseSByZWxldmFudCBzdHJ1Y3Qg
ZGV2aWNlIGZvciBlYWNoIGNhbGwu
