From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v1 0/2] scsi: ufs: Fix broken hba->outstanding_tasks
Date: Sun, 21 Jul 2019 12:46:01 +0000
Message-ID: <SN6PR04MB4925208835D4760249E82DB7FCC50@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
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

SGksDQoNCj4gDQo+IEN1cnJlbnRseSBiaXRzIGluIGhiYS0+b3V0c3RhbmRpbmdfdGFza3MgYXJl
IGNsZWFyZWQgb25seSBhZnRlciB0aGVpcg0KPiBjb3JyZXNwb25kaW5nIHRhc2sgbWFuYWdlbWVu
dCBjb21tYW5kcyBhcmUgc3VjY2Vzc2Z1bGx5IGRvbmUgYnkNCj4gX191ZnNoY2RfaXNzdWVfdG1f
Y21kKCkuDQo+IA0KPiBJZiB0aW1lb3V0IGhhcHBlbnMgaW4gYSB0YXNrIG1hbmFnZW1lbnQgY29t
bWFuZCwgaXRzIGNvcnJlc3BvbmRpbmcNCj4gYml0IGluIGhiYS0+b3V0c3RhbmRpbmdfdGFza3Mg
d2lsbCBub3QgYmUgY2xlYXJlZCB1bnRpbCBuZXh0IHRhc2sNCj4gbWFuYWdlbWVudCBjb21tYW5k
IHdpdGggdGhlIHNhbWUgdGFnIHVzZWQgc3VjY2Vzc2Z1bGx5IGZpbmlzaGVzLuKApw0KdWZzaGNk
X2NsZWFyX3RtX2NtZCBpcyBhbHNvIGNhbGxlZCBhcyBwYXJ0IG9mIHVmc2hjZF9lcnJfaGFuZGxl
ci4NCkRvZXMgdGhpcyBjaGFuZ2Ugc29tZXRoaW5nIGluIHlvdXIgYXNzdW1wdGlvbnM/DQoNClRo
YW5rcywNCkF2cmkNCg0KPiANCj4gVGhpcyBpcyB3cm9uZyBhbmQgY2FuIGxlYWQgdG8gc29tZSBp
c3N1ZXMsIGxpa2UgcG93ZXIgY29uc3VtcHRvbiBpc3N1ZS4NCj4gRm9yIGV4YW1wbGUsIHVmc2hj
ZF9yZWxlYXNlKCkgYW5kIHVmc2hjZF9nYXRlX3dvcmsoKSB3aWxsIGRvIG5vdGhpbmcNCj4gaWYg
aGJhLT5vdXRzdGFuZGluZ190YXNrcyBpcyBub3QgemVybyBldmVuIGlmIGJvdGggVUZTIGhvc3Qg
YW5kIGRldmljZXMNCj4gYXJlIGFjdHVhbGx5IGlkbGUuDQo+IA0KPiBCZWNhdXNlIGVycm9yIGhh
bmRsaW5nIGZsb3csIGkuZS4sIHVmc2hjZF9yZXNldF9hbmRfcmVzdG9yZSgpLCB3aWxsIGJlDQo+
IHRyaWdnZXJlZCBhZnRlciBhbnkgdGFzayBtYW5hZ2VtZW50IGNvbW1hbmQgdGltZXMgb3V0LCB3
ZSBmaXggdGhpcyBieQ0KPiBjbGVhcmluZyBjb3JyZXNwb25kaW5nIGhiYS0+b3V0c3RhbmRpbmdf
dGFza3MgYml0cyBkdXJpbmcgdGhpcyBmbG93Lg0KPiBUbyBhY2hpZXZlIHRoaXMsIHdlIG5lZWQg
YSBtYXNrIHRvIHRyYWNrIHRpbWVkLW91dCBjb21tYW5kcyBhbmQgdGh1cw0KPiBlcnJvciBoYW5k
bGluZyBmbG93IGNhbiBjbGVhciB0aGVpciB0YWdzIHNwZWNpZmljYWxseS4NCj4gDQo+IFN0YW5s
ZXkgQ2h1ICgyKToNCj4gICBzY3NpOiB1ZnM6IE1ha2UgbmV3IGZ1bmN0aW9uIGZvciBjbGVhcmlu
ZyBvdXRzdGFuZGluZyB0YXNrIGJpdHMNCj4gICBzY3NpOiB1ZnM6IEZpeCBicm9rZW4gaGJhLT5v
dXRzdGFuZGluZ190YXNrcw0KPiANCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgfCA0OSAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0NCj4gIGRyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmggfCAgMSArDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyks
IDcgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjE4LjANCg0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWlsaW5nIGxp
c3QKbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5pbmZy
YWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
