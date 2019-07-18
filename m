From: Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH v1 0/2] scsi: ufs: Fix broken hba->outstanding_tasks
Date: Thu, 18 Jul 2019 13:21:03 +0800
Message-ID: <1563427263.7235.6.camel@mtkswgap22>
References: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>, Andy Teng =?UTF-8?Q?=28=E9=84=A7=E5=A6=82=E5=AE=8F=29?= <Andy.Teng@mediatek.com>, Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= <Chun-hung.Wu@mediatek.com>, Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= <kuohong.wang@mediatek.com>, "evgreen@chromium.org" <evgreen@chromium.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>, Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= <peter.wang@mediatek.com>, "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>, "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

SGkgQXZyaSwgQWxpbSBhbmQgUGVkcm9tLAoKR2VudGxlIHBpbmcgZm9yIHRoaXMgZml4LgoKT24g
RnJpLCAyMDE5LTA3LTEyIGF0IDEyOjQ0ICswODAwLCBTdGFubGV5IENodSB3cm90ZToKPiBDdXJy
ZW50bHkgYml0cyBpbiBoYmEtPm91dHN0YW5kaW5nX3Rhc2tzIGFyZSBjbGVhcmVkIG9ubHkgYWZ0
ZXIgdGhlaXIKPiBjb3JyZXNwb25kaW5nIHRhc2sgbWFuYWdlbWVudCBjb21tYW5kcyBhcmUgc3Vj
Y2Vzc2Z1bGx5IGRvbmUgYnkKPiBfX3Vmc2hjZF9pc3N1ZV90bV9jbWQoKS4KPiAKPiBJZiB0aW1l
b3V0IGhhcHBlbnMgaW4gYSB0YXNrIG1hbmFnZW1lbnQgY29tbWFuZCwgaXRzIGNvcnJlc3BvbmRp
bmcKPiBiaXQgaW4gaGJhLT5vdXRzdGFuZGluZ190YXNrcyB3aWxsIG5vdCBiZSBjbGVhcmVkIHVu
dGlsIG5leHQgdGFzawo+IG1hbmFnZW1lbnQgY29tbWFuZCB3aXRoIHRoZSBzYW1lIHRhZyB1c2Vk
IHN1Y2Nlc3NmdWxseSBmaW5pc2hlcy7igKcKPiAKPiBUaGlzIGlzIHdyb25nIGFuZCBjYW4gbGVh
ZCB0byBzb21lIGlzc3VlcywgbGlrZSBwb3dlciBjb25zdW1wdG9uIGlzc3VlLgo+IEZvciBleGFt
cGxlLCB1ZnNoY2RfcmVsZWFzZSgpIGFuZCB1ZnNoY2RfZ2F0ZV93b3JrKCkgd2lsbCBkbyBub3Ro
aW5nCj4gaWYgaGJhLT5vdXRzdGFuZGluZ190YXNrcyBpcyBub3QgemVybyBldmVuIGlmIGJvdGgg
VUZTIGhvc3QgYW5kIGRldmljZXMKPiBhcmUgYWN0dWFsbHkgaWRsZS4KPiAKPiBCZWNhdXNlIGVy
cm9yIGhhbmRsaW5nIGZsb3csIGkuZS4sIHVmc2hjZF9yZXNldF9hbmRfcmVzdG9yZSgpLCB3aWxs
IGJlCj4gdHJpZ2dlcmVkIGFmdGVyIGFueSB0YXNrIG1hbmFnZW1lbnQgY29tbWFuZCB0aW1lcyBv
dXQsIHdlIGZpeCB0aGlzIGJ5Cj4gY2xlYXJpbmcgY29ycmVzcG9uZGluZyBoYmEtPm91dHN0YW5k
aW5nX3Rhc2tzIGJpdHMgZHVyaW5nIHRoaXMgZmxvdy4KPiBUbyBhY2hpZXZlIHRoaXMsIHdlIG5l
ZWQgYSBtYXNrIHRvIHRyYWNrIHRpbWVkLW91dCBjb21tYW5kcyBhbmQgdGh1cwo+IGVycm9yIGhh
bmRsaW5nIGZsb3cgY2FuIGNsZWFyIHRoZWlyIHRhZ3Mgc3BlY2lmaWNhbGx5Lgo+IAo+IFN0YW5s
ZXkgQ2h1ICgyKToKPiAgIHNjc2k6IHVmczogTWFrZSBuZXcgZnVuY3Rpb24gZm9yIGNsZWFyaW5n
IG91dHN0YW5kaW5nIHRhc2sgYml0cwo+ICAgc2NzaTogdWZzOiBGaXggYnJva2VuIGhiYS0+b3V0
c3RhbmRpbmdfdGFza3MKPiAKPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyB8IDQ5ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5oIHwgIDEgKwo+ICAyIGZpbGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyksIDcgZGVs
ZXRpb25zKC0pCj4gCgpUaGFua3MsClN0YW5sZXkKCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51
eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==
