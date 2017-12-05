From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Tue, 5 Dec 2017 16:08:20 +0000
Message-ID: <1512490099.2660.6.camel@sandisk.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24217 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLEQIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 11:08:23 -0500
In-Reply-To: <20171205075256.10319-1-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <0C64A389DF03B445955E906C4745E347@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "holger@applied-asynchrony.com" <holger@applied-asynchrony.com>

T24gVHVlLCAyMDE3LTEyLTA1IGF0IDE1OjUyICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGIvZHJpdmVycy9zY3NpL3Njc2lfbGli
LmMNCj4gaW5kZXggZGI5NTU2NjYyZTI3Li4xODE2ZGQ4MjU5YjMgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvc2NzaS9zY3NpX2xpYi5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jDQo+
IEBAIC0xOTY3LDYgKzE5NjcsOCBAQCBzdGF0aWMgYm9vbCBzY3NpX21xX2dldF9idWRnZXQoc3Ry
dWN0IGJsa19tcV9od19jdHggKmhjdHgpDQo+ICBvdXRfcHV0X2RldmljZToNCj4gIAlwdXRfZGV2
aWNlKCZzZGV2LT5zZGV2X2dlbmRldik7DQo+ICBvdXQ6DQo+ICsJaWYgKGF0b21pY19yZWFkKCZz
ZGV2LT5kZXZpY2VfYnVzeSkgPT0gMCAmJiAhc2NzaV9kZXZpY2VfYmxvY2tlZChzZGV2KSkNCj4g
KwkJYmxrX21xX2RlbGF5X3J1bl9od19xdWV1ZShoY3R4LCBTQ1NJX1FVRVVFX0RFTEFZKTsNCj4g
IAlyZXR1cm4gZmFsc2U7DQo+ICB9DQoNClRoaXMgY2Fubm90IHdvcmsgc2luY2UgbXVsdGlwbGUg
dGhyZWFkcyBjYW4gY2FsbCBzY3NpX21xX2dldF9idWRnZXQoKQ0KY29uY3VycmVudGx5IGFuZCBo
ZW5jZSBpdCBjYW4gaGFwcGVuIHRoYXQgbm9uZSBvZiB0aGVtIHNlZXMNCmF0b21pY19yZWFkKCZz
ZGV2LT5kZXZpY2VfYnVzeSkgPT0gMC4gQlRXLCB0aGUgYWJvdmUgcGF0Y2ggaXMgc29tZXRoaW5n
IEkNCmNvbnNpZGVyIGFzIGEgd29ya2Fyb3VuZC4gSGF2ZSB5b3UgY29uc2lkZXJlZCB0byBmaXgg
dGhlIHJvb3QgY2F1c2UgYW5kIHRvDQphZGQgYmxrX21xX3NjaGVkX21hcmtfcmVzdGFydF9oY3R4
KCkgd2hlcmUgdGhlc2UgYXJlIG1pc3NpbmcsIGUuZy4gaW4gDQpibGtfbXFfc2NoZWRfZGlzcGF0
Y2hfcmVxdWVzdHMoKT8gVGhlIHBhdGNoIGJlbG93IGlzIG5vdCBhIGZ1bGwgc29sdXRpb24NCmJ1
dCByZXN1bHRlZCBpbiBhIHNpZ25pZmljYW50IGltcHJvdmVtZW50IGluIG15IHRlc3RzOg0KDQpk
aWZmIC0tZ2l0IGEvYmxvY2svYmxrLW1xLXNjaGVkLmMgYi9ibG9jay9ibGstbXEtc2NoZWQuYw0K
aW5kZXggNjllMzIyNmU2NmNhLi45ZDg2ODc2ZWM1MDMgMTAwNjQ0DQotLS0gYS9ibG9jay9ibGst
bXEtc2NoZWQuYw0KKysrIGIvYmxvY2svYmxrLW1xLXNjaGVkLmMNCkBAIC0yMjYsNiArMjI2LDcg
QEAgdm9pZCBibGtfbXFfc2NoZWRfZGlzcGF0Y2hfcmVxdWVzdHMoc3RydWN0IGJsa19tcV9od19j
dHggKmhjdHgpDQogCQkgKiBUT0RPOiBnZXQgbW9yZSBidWRnZXRzLCBhbmQgZGVxdWV1ZSBtb3Jl
IHJlcXVlc3RzIGluDQogCQkgKiBvbmUgdGltZS4NCiAJCSAqLw0KKwkJYmxrX21xX3NjaGVkX21h
cmtfcmVzdGFydF9oY3R4KGhjdHgpOw0KIAkJYmxrX21xX2RvX2Rpc3BhdGNoX2N0eChoY3R4KTsN
CiAJfSBlbHNlIHsNCiAJCWJsa19tcV9mbHVzaF9idXN5X2N0eHMoaGN0eCwgJnJxX2xpc3QpOw0K
DQpCYXJ0Lg==
