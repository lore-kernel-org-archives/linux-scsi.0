From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v1 0/2] scsi: ufs: Fix broken hba->outstanding_tasks
Date: Mon, 22 Jul 2019 06:10:25 +0000
Message-ID: <SN6PR04MB49256F66F259185F3876CCABFCC40@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
 <SN6PR04MB4925208835D4760249E82DB7FCC50@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Stanley Chu <stanley.chu@mediatek.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
Cc: "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "beanhuo@micron.com" <beanhuo@micron.com>
List-Id: linux-scsi@vger.kernel.org

PiANCj4gPg0KPiA+IEhpLA0KPiA+DQo+ID4gPg0KPiA+ID4gQ3VycmVudGx5IGJpdHMgaW4gaGJh
LT5vdXRzdGFuZGluZ190YXNrcyBhcmUgY2xlYXJlZCBvbmx5IGFmdGVyIHRoZWlyDQo+ID4gPiBj
b3JyZXNwb25kaW5nIHRhc2sgbWFuYWdlbWVudCBjb21tYW5kcyBhcmUgc3VjY2Vzc2Z1bGx5IGRv
bmUgYnkNCj4gPiA+IF9fdWZzaGNkX2lzc3VlX3RtX2NtZCgpLg0KPiA+ID4NCj4gPiA+IElmIHRp
bWVvdXQgaGFwcGVucyBpbiBhIHRhc2sgbWFuYWdlbWVudCBjb21tYW5kLCBpdHMgY29ycmVzcG9u
ZGluZw0KPiA+ID4gYml0IGluIGhiYS0+b3V0c3RhbmRpbmdfdGFza3Mgd2lsbCBub3QgYmUgY2xl
YXJlZCB1bnRpbCBuZXh0IHRhc2sNCj4gPiA+IG1hbmFnZW1lbnQgY29tbWFuZCB3aXRoIHRoZSBz
YW1lIHRhZyB1c2VkIHN1Y2Nlc3NmdWxseSBmaW5pc2hlcy7igKcNCj4gPiB1ZnNoY2RfY2xlYXJf
dG1fY21kIGlzIGFsc28gY2FsbGVkIGFzIHBhcnQgb2YgdWZzaGNkX2Vycl9oYW5kbGVyLg0KPiA+
IERvZXMgdGhpcyBjaGFuZ2Ugc29tZXRoaW5nIGluIHlvdXIgYXNzdW1wdGlvbnM/DQo+IEFuZCBC
VFcgdGhlcmUgaXMgYSBzcGVjaWZpYyBfX2NsZWFyX2JpdCBpbiBfX3Vmc2hjZF9pc3N1ZV90bV9j
bWQoKSBpbiBjYXNlDQo+IG9mIGEgVE8uDQoNCkdhdmUgaXQgYW5vdGhlciBsb29rIC0gDQpJZiBp
bmRlZWQgdGhpcyBiaXQgaXNuJ3QgY2xlYXJlZCBhcyBwYXJ0IG9mIHRoZSBlcnJvciBmbG93IHRo
YXQgdGhlIHRpbWVvdXQgdHJpZ2dlcnMsDQpJIHRoaW5rIHlvdSBzaG91bGQgcmVsYXRlIHRvIHVm
c2hjZF9jbGVhcl90bV9jbWQgc3BlY2lmaWNhbGx5IGluIHlvdXIgY29tbWl0IGxvZyAtIA0KQmVj
YXVzZSB0aGlzIGlzIHRoZSBvYnZpb3VzIHBsYWNlIHdoZXJlIHRoZSBiaXQgY2xlYW51cCBzaG91
bGQgdGFrZSBwbGFjZS4NCg0KQWxzbyB0aGUgZml4IHNob3VsZCBiZSBtdWNoIG1vcmUgaW50dWl0
aXZlIElNTyAtIA0KVG9kYXkgd2UgZG8gX19jbGVhcl9iaXQoKSBvbiBzdWNjZXNzLCB1ZnNoY2Rf
Y2xlYXJfdG1fY21kKCkgb24gZXJyb3IsDQpBbmQgYWxzbyB1ZnNoY2RfcHV0X3RtX3Nsb3QoKSBl
aXRoZXIgd2F5Pw0KDQpNYXliZSB5b3UgY2FuIGNob29zZSBhIHNpbmdsZSBwbGFjZSB0byBjbGVh
ciBpdCwgd2l0aG91dCBhbnkgYWRkaXRpb25hbCBjb2RlPw0KDQpUaGFua3MsDQpBdnJpDQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2Vy
bmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0
cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVs
Cg==
