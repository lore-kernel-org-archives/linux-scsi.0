From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V6 4/5] blk-mq-sched: improve dispatching from sw queue
Date: Thu, 12 Oct 2017 15:33:33 +0000
Message-ID: <1507822412.2448.12.camel@wdc.com>
References: <20171009112424.30524-1-ming.lei@redhat.com>
         <20171009112424.30524-5-ming.lei@redhat.com>
         <20171010182345.GD30738@vader.DHCP.thefacebook.com>
         <20171012100107.GA28224@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012100107.GA28224@ming.t460p>
Content-Language: en-US
Content-ID: <C43AEC7457E769429688B0C462B74DBC@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "osandov@osandov.com" <osandov@osandov.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "tom81094@gmail.com" <tom81094@gmail.com>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "snitzer@redhat.com" <snitzer@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "osandov@fb.com" <osandov@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTEwLTEyIGF0IDE4OjAxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gRXZl
biBFV01BIGFwcHJvYWNoIGlzbid0IGdvb2Qgb24gU0NTSS1NUSB0b28sIGJlY2F1c2UNCj4gc29t
ZSBTQ1NJJ3MgLmNtZF9wZXJfbHVuIGlzIHZlcnkgc21hbGwsIHN1Y2ggYXMgMyBvbg0KPiBscGZj
IGFuZCBxbGEyeHh4LCBhbmQgb25lIGZ1bGwgZmx1c2ggd2lsbCB0cmlnZ2VyDQo+IEJMS19TVFNf
UkVTT1VSQ0UgZWFzaWx5Lg0KPiANCj4gU28gSSBzdWdnZXN0IHRvIHVzZSB0aGUgd2F5IG9mIHEt
PnF1ZXVlX2RlcHRoIGZpcnN0LCBzaW5jZSB3ZQ0KPiBkb24ndCBnZXQgcGVyZm9ybWFuY2UgZGVn
cmFkZSByZXBvcnQgb24gb3RoZXIgZGV2aWNlcyghcS0+cXVldWVfZGVwdGgpDQo+IHdpdGggYmxr
LW1xLiBXZSBjYW4gaW1wcm92ZSB0aGlzIHdheSBpbiB0aGUgZnV0dXJlIGlmIHdlDQo+IGhhdmUg
YmV0dGVyIGFwcHJvYWNoLg0KDQpNZWFzdXJlbWVudHMgaGF2ZSBzaG93biB0aGF0IGV2ZW4gd2l0
aCB0aGlzIHBhdGNoIHNlcmllcyBhcHBsaWVkIHNlcXVlbnRpYWwNCkkvTyBwZXJmb3JtYW5jZSBp
cyBzdGlsbCBiZWxvdyB0aGF0IG9mIHRoZSBsZWdhY3kgYmxvY2sgYW5kIFNDU0kgbGF5ZXJzLiBT
bw0KdGhpcyBwYXRjaCBzZXJpZXMgaXMgbm90IHRoZSBmaW5hbCBzb2x1dGlvbi4gKFNlZSBhbHNv
IEpvaG4gR2FycnkncyBlLW1haWwNCm9mIE9jdG9iZXIgMTB0aCAtIGh0dHBzOi8vbGttbC5vcmcv
bGttbC8yMDE3LzEwLzEwLzQwMSkuIEkgaGF2ZSBiZWVuDQp3b25kZXJpbmcgd2hhdCBjb3VsZCBi
ZSBjYXVzaW5nIHRoYXQgcGVyZm9ybWFuY2UgZGlmZmVyZW5jZS4gTWF5YmUgaXQncw0KYmVjYXVz
ZSByZXF1ZXN0cyBjYW4gcmVzaWRlIGZvciBhIHdoaWxlIGluIHRoZSBoY3R4IGRpc3BhdGNoIHF1
ZXVlIGFuZCBoZW5jZQ0KYXJlIHVudmlzaWJsZSBmb3IgdGhlIHNjaGVkdWxlciB3aGlsZSBpbiB0
aGUgaGN0eCBkaXNwYXRjaCBxdWV1ZT8gU2hvdWxkIHdlDQptb2RpZnkgYmxrX21xX2Rpc3BhdGNo
X3JxX2xpc3QoKSBzdWNoIHRoYXQgaXQgcHV0cyBiYWNrIHJlcXVlc3RzIHRoYXQgaGF2ZQ0Kbm90
IGJlZW4gYWNjZXB0ZWQgYnkgLnF1ZXVlX3JxKCkgb250byB0aGUgc2NoZWR1bGVyIHF1ZXVlKHMp
IGluc3RlYWQgb2YgdG8NCnRoZSBoY3R4IGRpc3BhdGNoIHF1ZXVlPyBJZiB3ZSB3b3VsZCBtYWtl
IHRoYXQgY2hhbmdlLCB3b3VsZCBpdCBhbGxvdyB1cyB0bw0KZHJvcCBwYXRjaCAiYmxrLW1xLXNj
aGVkOiBpbXByb3ZlIGRpc3BhdGNoaW5nIGZyb20gc3cgcXVldWUiPw0KDQpCYXJ0Lg==
