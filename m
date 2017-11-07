From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH V2] scsi_debugfs: fix crash in scsi_show_rq()
Date: Tue, 7 Nov 2017 16:13:48 +0000
Message-ID: <1510071227.2656.12.camel@wdc.com>
References: <20171107152155.19949-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171107152155.19949-1-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <54B0B6F2C4D015428009068C659912C4@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "JBottomley@parallels.com" <JBottomley@parallels.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "hare@suse.com" <hare@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "osandov@fb.com" <osandov@fb.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTExLTA3IGF0IDIzOjIxICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gY21k
LT5jbW5kIGNhbiBiZSBhbGxvY2F0ZWQvZnJlZWQgZHluYW1pY2FsbHkgaW4gY2FzZSBvZiBUMTBf
UElfVFlQRTJfUFJPVEVDVElPTiwNCj4gc28gd2UgY2FuJ3QgYWNjZXNzIGl0IGluIHNjc2lfc2hv
d19ycSgpIGlmICdTQ3BudC0+Y21uZCAhPSBzY3NpX3JlcShycSktPmNtZCcsDQo+IGJlY2F1c2Ug
dGhpcyByZXF1ZXN0IGNhbiBiZSBmcmVlZCBhbnkgdGltZS4NCg0KVGhhdCBkZXNjcmlwdGlvbiBp
cyBpbmFjY3VyYXRlLiBJdCBpcyBub3QgYWxsb3dlZCB0byBmcmVlIFNDcG50LT5jbW5kIHdoaWxl
DQphIGNvbW1hbmQgaXMgYmVpbmcgZXhlY3V0ZWQuDQoNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9zY3NpX2RlYnVnZnMuYyBiL2RyaXZlcnMvc2NzaS9zY3NpX2RlYnVnZnMuYw0KPiBpbmRl
eCA1ZTk3NTUwMDhhZWQuLjdhNTA4Nzg0NDZiNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3Np
L3Njc2lfZGVidWdmcy5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2RlYnVnZnMuYw0KPiBA
QCAtOSw3ICs5LDEwIEBAIHZvaWQgc2NzaV9zaG93X3JxKHN0cnVjdCBzZXFfZmlsZSAqbSwgc3Ry
dWN0IHJlcXVlc3QgKnJxKQ0KPiAgCWludCBtc2VjcyA9IGppZmZpZXNfdG9fbXNlY3MoamlmZmll
cyAtIGNtZC0+amlmZmllc19hdF9hbGxvYyk7DQo+ICAJY2hhciBidWZbODBdOw0KPiAgDQo+IC0J
X19zY3NpX2Zvcm1hdF9jb21tYW5kKGJ1Ziwgc2l6ZW9mKGJ1ZiksIGNtZC0+Y21uZCwgY21kLT5j
bWRfbGVuKTsNCj4gKwlpZiAoY21kLT5jbW5kID09IHNjc2lfcmVxKHJxKS0+Y21kKQ0KPiArCQlf
X3Njc2lfZm9ybWF0X2NvbW1hbmQoYnVmLCBzaXplb2YoYnVmKSwgY21kLT5jbW5kLCBjbWQtPmNt
ZF9sZW4pOw0KPiArCWVsc2UNCj4gKwkJc3RyY3B5KGJ1ZiwgInVua25vd24iKTsNCj4gIAlzZXFf
cHJpbnRmKG0sICIsIC5jbWQ9JXMsIC5yZXRyaWVzPSVkLCBhbGxvY2F0ZWQgJWQuJTAzZCBzIGFn
byIsIGJ1ZiwNCj4gIAkJICAgY21kLT5yZXRyaWVzLCBtc2VjcyAvIDEwMDAsIG1zZWNzICUgMTAw
MCk7DQo+ICB9DQoNClRoaXMgY2hhbmdlIGludHJvZHVjZXMgYSBuZXcgYnVnLCBuYW1lbHkgdGhh
dCAidW5rbm93biIgd2lsbCBhcHBlYXIgaW4gdGhlDQpkZWJ1Z2ZzIG91dHB1dCBpZiAoY21kLT5j
bW5kICE9IHNjc2lfcmVxKHJxKS0+Y21kKS4gSGF2ZSB5b3UgY29uc2lkZXJlZCB0byB1c2UNCnRo
ZSB0ZXN0IChjbWQtPmNtbmQgIT0gTlVMTCkgaW5zdGVhZD8NCg0KQWRkaXRpb25hbGx5LCBpZiB5
b3UgcmVhbGx5IHdhbnQgdG8gYXZvaWQgdGhhdCB0aGlzIGNvZGUgY3Jhc2hlcyBpZiBOVUxMIGlz
DQphc3NpZ25lZCB0byBjbWQtPmNtbmQgeW91IHdpbGwgaGF2ZSB0byB1c2UgUkVBRF9PTkNFKGNt
ZC0+Y21uZCkuDQoNCkJhcnQu
