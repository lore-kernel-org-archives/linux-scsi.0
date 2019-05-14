From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [EXT] [PATCH v1 2/3] scsi: ufs: add error handling of auto-hibern8
Date: Tue, 14 May 2019 11:14:40 +0000
Message-ID: <BN7PR08MB56840A3CD3BA7C107D0230CADB080@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
 <1557758186-18706-3-git-send-email-stanley.chu@mediatek.com>
 <BN7PR08MB568438668FC7C90A1284F53DDB0F0@BN7PR08MB5684.namprd08.prod.outlook.com>
 <1557817102.24427.20.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1557817102.24427.20.camel@mtkswgap22>
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
To: Stanley Chu <stanley.chu@mediatek.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, "andy.teng@mediatek.com" <andy.teng@mediatek.com>, "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>, "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, "peter.wang@mediatek.com" <peter.wang@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "sayalil@codeaurora.org" <sayalil@codeaurora.org>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

SGksIFN0YW5sZXkNClRoYW5rcyBmb3IgcmVwbHkuDQoNCj4NCj5PbiBNb24sIDIwMTktMDUtMTMg
YXQgMTg6MjEgKzAwMDAsIEJlYW4gSHVvIChiZWFuaHVvKSB3cm90ZToNCj4+IEhpLCBTdGFubGV5
DQo+Pg0KPj4gPisNCj4+ID4rc3RhdGljIGlubGluZSBib29sIHVmc2hjZF9pc19hdXRvX2hpYmVy
bjhfZXJyb3Ioc3RydWN0IHVmc19oYmEgKmhiYSwNCj4+ID4rCQkJCQkJdTMyIGludHJfbWFzaykN
Cj4+ID4rew0KPj4gPisJcmV0dXJuICh1ZnNoY2RfaXNfYXV0b19oaWJlcm44X3N1cHBvcnRlZCho
YmEpICYmDQo+PiA+KwkJIWhiYS0+dWljX2FzeW5jX2RvbmUgJiYNCj4+DQo+PiBIZXJlIGNoZWNr
IGlmIHVpY19hc3luY19kb25lIGlzIE5VTEwsIG5vIGJpZyBwcm9ibGVtIHNvIGZhciwgYnV0IG5v
dCBzYWZlDQo+ZW5vdWdoLg0KPj4gSG93IGFib3V0IHNldHRpbmcgYSBmbGFnIGluIHVmc2hjZF9h
dXRvX2hpYmVybjhfZW5hYmxlKCksDQo+DQo+Pg0KPj4gSSBjb25jZXJuIGFib3V0IGhvdyB0byBj
b21wYXRpYmxlIHdpdGggYXV0b19oaWJlcm44IGRpc2FibGVkIGNvbmRpdGlvbi4NCj4NCj5DdXJy
ZW50bHkgYXV0by1oaWJlcm44IGRpc2FibGluZyBtZXRob2QgaXMgbm90IGltcGxlbWVudGVkIGlu
IG1haW5zdHJlYW0sDQo+c28gYW4gImVuYWJsaW5nIiBmbGFnIG1heSBsb29rcyByZWR1bmRhbnQg
dW5sZXNzIGRpc2FibGluZyBwYXRoIGlzIHJlYWxseQ0KPmV4aXN0ZWQuDQo+DQpEaWQgeW91IHRy
eSB0byB1cGRhdGUgQXV0by1IaWJlcm5hdGUgSWRsZSBUaW1lciB3aXRoIDAgdGhyb3VnaCAnL3N5
cycgIChzY3NpOiB1ZnM6IEFkZCBzdXBwb3J0IGZvciBBdXRvLUhpYmVybmF0ZSBJZGxlIFRpbWVy
KT8gDQpJIGRvbid0IGtub3cgaWYgdGhpcyB3aWxsIGRpc2FibGUgeW91ciBVRlMgY29udHJvbGxl
ciBBdXRvLUhpYmVybmF0ZS4NCklmIGhhdmluZyBhIGxvb2sgYXQgVUZTIGhvc3QgU3BlYywgc29m
dHdhcmUgd3JpdGVzIOKAnDDigJ0gdG8gZGlzYWJsZSBBdXRvLUhpYmVybmF0ZSBJZGxlIFRpbWVy
Lg0KU29ycnkgSSBjYW5ub3QgdmVyaWZ5IHRoaXMgb24gbXkgcGxhdGZvcm0gc2luY2UgaXQgZG9l
c24ndCBzdXBwb3J0IGF1dG8taGliZXJuYXRlLg0KDQoNCj5JIGFncmVlIHRoYXQgY2hlY2tpbmcg
aGJhLT51aWNfYXN5bmNfZG9uZSBoZXJlIGRvZXMgbm90IGxvb2sgc28gaW50dWl0aXZlLg0KPkhv
d2V2ZXIgZXZlbiBpZiBhdXRvLWhpYmVybjggaXMgZGlzYWJsZWQsIHRoZXNlIGNoZWNrcyBjb3Vs
ZCBiZSBzYWZlIGVub3VnaA0KPmJlY2F1c2UgYm90aCAiVUlDX0hJQkVSTkFURV9FTlRFUiIgYW5k
ICJVSUNfSElCRVJOQVRFX0VYSVQiIGFyZQ0KPnJhaXNlZCBvbmx5IGlmICJtYW51YWwtaGliZXJu
YXRlIiBpcyBwZXJmb3JtZWQsIGFuZCBpbiB0aGlzIGNhc2UgaGJhLQ0KPj51aWNfYXN5bmNfZG9u
ZSBzaGFsbCBiZSB0cnVlLg0KPg0KWWVzLCBtb3N0IG9mIGNhc2VzICx0aGlzIGlzIG5vIHByb2Js
ZW0uDQoNCj5Bbnl0aGluZyBlbHNlIG9yIGNvcm5lciBjYXNlIEkgbWlzc2VkPw0KPg0KVGhlIG90
aGVycyBhcmUgZmluZS4gSSBvbmx5IGNvbmNlcm4gY2hlY2tpbmcgaGJhLT51aWNfYXN5bmNfZG9u
ZS4NCg0KLy9CZWFuDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3Rz
LmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1hcm0ta2VybmVsCg==
