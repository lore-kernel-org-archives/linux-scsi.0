From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 01/29] scsi: aacraid: Fix udev inquiry race condition
Date: Wed, 27 Dec 2017 01:22:57 +0000
Message-ID: <8213b7939770477cbac774fd370ba1fc@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
         <20171221173420.8213-2-RaghavaAditya.Renukunta@microsemi.com>
 <1513878840.2931.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0048.outbound.protection.outlook.com ([104.47.38.48]:8736
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751211AbdL0BX1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 20:23:27 -0500
In-Reply-To: <1513878840.2931.16.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>, Tom White <tom.white@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmFydCBWYW4gQXNzY2hl
IFttYWlsdG86QmFydC5WYW5Bc3NjaGVAd2RjLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIERlY2Vt
YmVyIDIxLCAyMDE3IDk6NTQgQU0NCj4gVG86IGplamJAbGludXgudm5ldC5pYm0uY29tOyBSYWdo
YXZhIEFkaXR5YSBSZW51a3VudGENCj4gPFJhZ2hhdmFBZGl0eWEuUmVudWt1bnRhQG1pY3Jvc2Vt
aS5jb20+OyBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsNCj4gbWFydGluLnBldGVyc2VuQG9y
YWNsZS5jb20NCj4gQ2M6IGRsLWVzYy1BYWNyYWlkIExpbnV4IERyaXZlciA8YWFjcmFpZEBtaWNy
b3NlbWkuY29tPjsNCj4gZ3BpY2NvbGlAbGludXgudm5ldC5pYm0uY29tOyBUb20gV2hpdGUgPHRv
bS53aGl0ZUBtaWNyb3NlbWkuY29tPjsNCj4gU2NvdHQgQmVuZXNoIDxzY290dC5iZW5lc2hAbWlj
cm9zZW1pLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwMS8yOV0gc2NzaTogYWFjcmFpZDog
Rml4IHVkZXYgaW5xdWlyeSByYWNlIGNvbmRpdGlvbg0KPiANCj4gRVhURVJOQUwgRU1BSUwNCj4g
DQo+IA0KPiBPbiBUaHUsIDIwMTctMTItMjEgYXQgMDk6MzMgLTA4MDAsIFJhZ2hhdmEgQWRpdHlh
IFJlbnVrdW50YSB3cm90ZToNCj4gPiArICAgICAgICAgICAgIGNoYXIgKmNwOw0KPiA+ICsgICAg
ICAgICAgICAgY2hhciAqY25hbWUgPSBrbWFsbG9jKHNpemVvZihzdXBfYWRhcF9pbmZvLQ0KPiA+
YWRhcHRlcl90eXBlX3RleHQpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgR0ZQX0FUT01JQyk7DQo+IA0KPiBXaHkgZGlk
IHlvdSBjaG9vc2UgdG8gdXNlIEdGUF9BVE9NSUMgaW5zdGVhZCBvZiBHRlBfS0VSTkVMIGluIHRo
ZQ0KPiBhYm92ZQ0KPiBrbWFsbG9jKCkgY2FsbD8NCg0KSXQgd2FzIG1haW5seSBiZWNhdXNlIG9m
IGEgdHJhY2UgY2FsbCB0aGF0IGN1dCB0aHJ1IHRoZSBrbWFsbG9jIGNhbGwuIA0KIA0KPiA+ICsN
Cj4gPiArICAgICAgICAgICAgIGlmICghY25hbWUpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
IHJldHVybjsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICBjcCA9IGNuYW1lOw0KPiA+ICsgICAg
ICAgICAgICAgbWVtY3B5KGNuYW1lLCBzdXBfYWRhcF9pbmZvLT5hZGFwdGVyX3R5cGVfdGV4dCwN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKHN1cF9hZGFwX2luZm8tPmFkYXB0ZXJf
dHlwZV90ZXh0KSk7DQo+IA0KPiBJcyB0aGUgc3VwX2FkYXBfaW5mby0+YWRhcHRlcl90eXBlX3Rl
eHQgYSBzdHJpbmcgdGhhdCBpcyBcMC10ZXJtaW5hdGVkPyBJZg0KPiBzbywNCj4gaGF2ZSB5b3Ug
Y29uc2lkZXJlZCB0byB1c2Uga21lbWR1cCgpIGluc3RlYWQgb2Yga21hbGxvYygpICsgbWVtY3B5
KCk/DQoNCkkgd2lsbCB0YWtlIHRoYXQgaW50byBjb25zaWRlcmF0aW9uIEJhcnQuDQoNClRoYW5r
IHlvdSANClJhZ2hhdmEgQWRpdHlhDQoNCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
