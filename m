From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix oops in error handlers after
 shutdown/unload
Date: Wed, 31 Jan 2018 22:59:06 +0000
Message-ID: <1517439544.7325.13.camel@wdc.com>
References: <1517425200-19126-1-git-send-email-mauricfo@linux.vnet.ibm.com>
         <1517425560.7325.2.camel@wdc.com>
         <6abeeab8-00f8-3a8f-2ccd-21aaefac65fc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19889 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbeAaW7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2018 17:59:08 -0500
In-Reply-To: <6abeeab8-00f8-3a8f-2ccd-21aaefac65fc@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <A50AAD603E40C94484926FB57591EC65@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE4LTAxLTMxIGF0IDE3OjQ4IC0wMjAwLCBNYXVyaWNpbyBGYXJpYSBkZSBPbGl2
ZWlyYSB3cm90ZToNCj4gT24gMDEvMzEvMjAxOCAwNTowNiBQTSwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+IFNvcnJ5IGJ1dCBJIHRoaW5rIHRoaXMgcGF0Y2ggaW50cm9kdWNlcyBuZXcgcmFj
ZSBjb25kaXRpb25zLiBIYXZlIHlvdQ0KPiANCj4gQ2FuIHlvdSBkZXRhaWwgdGhlIHJhY2UgY29u
ZGl0aW9ucz8gQXMgZmFyIGFzIEkgY2FuIHNlZSwgdGhlIG9ubHkgcmFjZQ0KPiBjb25kaXRpb24g
d291bGQgYmUgd2hlbiBhbiBlcnJvciBoYW5kbGVyIGlzIGludm9rZWQgdmVyeSBjbG9zZSBpbiB0
aW1lDQo+IHRvIHRoZSBzaHV0ZG93bi91bmxvYWQgaGFuZGxlciwgYW5kIGFzIHN1Y2ggbWlzcyB0
aGUgJ2lvYy0+cmVtb3ZlX2hvc3QnDQo+IGFzc2lnbm1lbnQgKHRodXMgaXQgY29udGludWVzIHJ1
bm5pbmcgYW55d2F5LCBhbmQgaGl0IHRoZSBvb3BzKS4NCg0KVGhhdCdzIGluZGVlZCB0aGUgcmFj
ZSBJIHdhcyByZWZlcnJpbmcgdG8uIEJUVywgYXJlIHlvdSBhd2FyZSB0aGF0IHlvdXIgcGF0Y2gN
CmRvZXMgbm90IHNlZW0gdG8gYXBwbHkgb24gTWFydGluJ3MgdHJlZSAodGhlIGZpeGVzIGJyYW5j
aCBvZg0KZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21rcC9z
Y3NpLmdpdCk6DQoNCiQgcGF0Y2ggLXAxIDwgfi9cW1BBVENIXF1fc2NzaVw6X21wdDNzYXNcOl9m
aXhfb29wc19pbl9lcnJvcl9oYW5kbGVyc19hZnRlcl9zaHV0ZG93bl91bmxvYWQubWJveCAgICAg
ICANCnBhdGNoaW5nIGZpbGUgZHJpdmVycy9zY3NpL21wdDNzYXMvbXB0M3Nhc19zY3NpaC5jDQpI
dW5rICMxIEZBSUxFRCBhdCAzMDA3Lg0KSHVuayAjMiBzdWNjZWVkZWQgYXQgMjk3MCAob2Zmc2V0
IC05OSBsaW5lcykuDQpIdW5rICMzIHN1Y2NlZWRlZCBhdCAyOTc3IChvZmZzZXQgLTE2MSBsaW5l
cykuDQpIdW5rICM0IHN1Y2NlZWRlZCBhdCAzMDMzIChvZmZzZXQgLTE2MCBsaW5lcykuDQoxIG91
dCBvZiA0IGh1bmtzIEZBSUxFRCAtLSBzYXZpbmcgcmVqZWN0cyB0byBmaWxlIGRyaXZlcnMvc2Nz
aS9tcHQzc2FzL21wdDNzYXNfc2NzaWguYy5yZWoNCg0KQ2FuIHlvdSByZWJhc2UgdGhpcyBwYXRj
aCBvbiB0b3Agb2YgTWFydGluJ3MgdHJlZT8NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
