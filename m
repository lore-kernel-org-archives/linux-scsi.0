From: "=?utf-8?B?6ZmI5Y2O5omN?=" <chenhc@lemote.com>
Subject: Re: [PATCH V7 1/2] dma-mapping: Rework dma_get_cache_alignment()
Date: Tue, 26 Sep 2017 09:48:01 +0800
Message-ID: <tencent_7716E99906A9D63D4592EFB6@qq.com>
References: <1506332766-23966-1-git-send-email-chenhc@lemote.com>
        <20170925125107.GC8130@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:47354 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934961AbdIZBsT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Sep 2017 21:48:19 -0400
In-Reply-To: <20170925125107.GC8130@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: =?utf-8?B?Q2hyaXN0b3BoIEhlbGx3aWc=?= <hch@lst.de>, =?utf-8?B?TWFyZWsgU3p5cHJvd3NraQ==?= <m.szyprowski@samsung.com>, =?utf-8?B?Um9iaW4gTXVycGh5?= <robin.murphy@arm.com>, =?utf-8?B?QW5kcmV3IE1vcnRvbg==?= <akpm@linux-foundation.org>, =?utf-8?B?RnV4aW4gWmhhbmc=?= <zhangfx@lemote.com>, =?utf-8?B?bGludXgta2VybmVs?= <linux-kernel@vger.kernel.org>, =?utf-8?B?UmFsZiBCYWVjaGxl?= <ralf@linux-mips.org>, =?utf-8?B?SmFtZXMgSG9nYW4=?= <james.hogan@imgtec.com>, =?utf-8?B?bGludXgtbWlwcw==?= <linux-mips@linux-mips.org>, =?utf-8?B?SmFtZXMgRSAuIEogLiBCb3R0b21sZXk=?= <jejb@linux.vnet.ibm.com>, =?utf-8?B?TWFydGluIEsgLiBQZXRlcnNlbg==?= <martin.petersen@oracle.com>, =?utf-8?B?bGludXgtc2NzaQ==?= <linux-scsi@vger.kernel.org>, =?utf-8?B?Um9sYW5kIERyZWllcg==?= <rolandd@cisc>

SGksIENocmlzdG9waCwNCg0KQ2FuIEkgcHV0IHRoZSBkZWNsYXJhdGlvbiBpbiBhc20vZG1h
LWNvaGVyZW5jZS5oPw0KDQpBbmQsIGxhc3QgdGltZSB5b3Ugc2FpZCBpdCBpcyBPSyB0byBw
YXNzIGEgTlVMTCB0byBkbWFfZ2V0X2NhY2hlX2FsaWdubWVudCgpIGFuZCBjYyBhbGwgZHJp
dmVyIG1haW50YWluZXJzLiBJIGhhdmUgZG8gc28uDQoNCkh1YWNhaQ0KDQotLS0tLS0tLS0t
LS0tLS0tLS0gT3JpZ2luYWwgLS0tLS0tLS0tLS0tLS0tLS0tDQpGcm9tOiAgIkNocmlzdG9w
aCBIZWxsd2lnIjxoY2hAbHN0LmRlPjsNCkRhdGU6ICBNb24sIFNlcCAyNSwgMjAxNyAwODo1
MSBQTQ0KVG86ICAiSHVhY2FpIENoZW4iPGNoZW5oY0BsZW1vdGUuY29tPjsgDQpDYzogICJD
aHJpc3RvcGggSGVsbHdpZyI8aGNoQGxzdC5kZT47ICJNYXJlayBTenlwcm93c2tpIjxtLnN6
eXByb3dza2lAc2Ftc3VuZy5jb20+OyAiUm9iaW4gTXVycGh5Ijxyb2Jpbi5tdXJwaHlAYXJt
LmNvbT47ICJBbmRyZXcgTW9ydG9uIjxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPjsgIkZ1
eGluIFpoYW5nIjx6aGFuZ2Z4QGxlbW90ZS5jb20+OyAibGludXgta2VybmVsIjxsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgIlJhbGYgQmFlY2hsZSI8cmFsZkBsaW51eC1taXBz
Lm9yZz47ICJKYW1lcyBIb2dhbiI8amFtZXMuaG9nYW5AaW1ndGVjLmNvbT47ICJsaW51eC1t
aXBzIjxsaW51eC1taXBzQGxpbnV4LW1pcHMub3JnPjsgIkphbWVzIEUgLiBKIC4gQm90dG9t
bGV5IjxqZWpiQGxpbnV4LnZuZXQuaWJtLmNvbT47ICJNYXJ0aW4gSyAuIFBldGVyc2VuIjxt
YXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47ICJsaW51eC1zY3NpIjxsaW51eC1zY3NpQHZn
ZXIua2VybmVsLm9yZz47ICJSb2xhbmQgRHJlaWVyIjxyb2xhbmRkQGNpc2NvLmNvbT47ICJQ
YXdlbCBPc2NpYWsiPHBhd2VsQG9zY2lhay5jb20+OyAiS3l1bmdtaW4gUGFyayI8a3l1bmdt
aW4ucGFya0BzYW1zdW5nLmNvbT47ICJNaWNoYWVsIENoYW4iPG1pY2hhZWwuY2hhbkBicm9h
ZGNvbS5jb20+OyAiQmVuamFtaW4gSGVycmVuc2NobWlkdCI8YmVuaEBrZXJuZWwuY3Jhc2hp
bmcub3JnPjsgIkl2YW4gTWlraGF5bG92IjxpdmFuQHJ1LmlibS5jb20+OyAiVGFyaXEgVG91
a2FuIjx0YXJpcXRAbWVsbGFub3guY29tPjsgIkFuZHkgR3Jvc3MiPGFncm9zc0Bjb2RlYXVy
b3JhLm9yZz47ICJNYXJrIEEgLiBHcmVlciI8bWdyZWVyQG12aXN0YS5jb20+OyAiUm9iZXJ0
IEJhbGR5Z2EiPHIuYmFsZHlnYUBzYW1zdW5nLmNvbT47ICJzdGFibGUiPHN0YWJsZUB2Z2Vy
Lmtlcm5lbC5vcmc+OyANClN1YmplY3Q6ICBSZTogW1BBVENIIFY3IDEvMl0gZG1hLW1hcHBp
bmc6IFJld29yayBkbWFfZ2V0X2NhY2hlX2FsaWdubWVudCgpDQoNCiANCj4gaW5kZXggYWJh
NzEzOC4uZTJjNWQ5ZSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9taXBzL2luY2x1ZGUvYXNtL2Rt
YS1tYXBwaW5nLmgNCj4gKysrIGIvYXJjaC9taXBzL2luY2x1ZGUvYXNtL2RtYS1tYXBwaW5n
LmgNCj4gQEAgLTM5LDQgKzM5LDYgQEAgc3RhdGljIGlubGluZSB2b2lkIGFyY2hfc2V0dXBf
ZG1hX29wcyhzdHJ1Y3QgZGV2aWNlICpkZXYsIHU2NCBkbWFfYmFzZSwNCj4gICNlbmRpZg0K
PiAgfQ0KPiAgDQo+ICtpbnQgbWlwc19nZXRfY2FjaGVfYWxpZ25tZW50KHN0cnVjdCBkZXZp
Y2UgKmRldik7DQoNCkFsbCB0aGUgb3RoZXIgbWlwcyBnZW5lcmljIGRtYSBoZWxwZXJzIGFy
ZSBwcmVmaXhlZCBtaXBzX2RtYV8qDQpzbyBpdCBtaWdodCBtYWtlIHNlbnNlIHRvIGZvbGxv
dyB0aGF0Lg0KDQpBbHNvIHBsZWFzZSBkb24ndCBhZGQgYXJjaC1sb2NhbCBoZWxwZXJzIHRv
IGFzbS9kbWEtbWFwcGluZy5oIC0gdGhpcw0KaXMgYSBoZWFkZXIgdXNlZCBieSBsaW51eC9k
bWEtbWFwcGluZy5oIGFuZCBzaG91bGQgbm90IGNvbnRhaW4NCmltcGxlbWVudGF0aW9uIGRl
dGFpbHMgaWYgYXZvaWRhYmxlLg0KDQo+ICsJCQkJCSAgIGRtYV9nZXRfY2FjaGVfYWxpZ25t
ZW50KE5VTEwpKSAvIG1kZXYtPmxpbWl0cy5tdHRfc2VnX3NpemU7DQoNCkFzIHNhaWQgYmVm
b3JlIC0gcGxlYXNlIGRvbid0IHBhc3MgTlVMTCB0byB0aGlzIGZ1bmN0aW9uIGJ1dCB0aGUg
cHJvcGVyDQpkZXZpY2UsIHdoaWNoIHdvdWxkIGJlICZtZGV2LT5wZGV2LT5kZXYgaW4gdGhp
cyBjYXNlIGZvciBleGFtcGxlLg==
