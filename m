From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: srp_transport: Fix 'always false comparison' in
 srp_tmo_valid()
Date: Thu, 26 Jan 2017 15:11:43 +0000
Message-ID: <1485443483.2980.1.camel@sandisk.com>
References: <1485429447-19103-1-git-send-email-augustocaringi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0076.outbound.protection.outlook.com ([104.47.42.76]:49024
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753169AbdAZPLy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 10:11:54 -0500
In-Reply-To: <1485429447-19103-1-git-send-email-augustocaringi@gmail.com>
Content-Language: en-US
Content-ID: <60F89A3FF81E5B4C9FB135C38048D49B@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "augustocaringi@gmail.com" <augustocaringi@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "emilne@redhat.com" <emilne@redhat.com>, "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>

T24gVGh1LCAyMDE3LTAxLTI2IGF0IDExOjE3ICswMDAwLCBBdWd1c3RvIE1lY2tpbmcgQ2FyaW5n
aSB3cm90ZToNCj4gSW4gYSA2NGJpdCBzeXN0ZW0gKHdoZXJlIGxvbmcgaXMgNjRiaXQgd2lkZSks
IGV2ZW4gZGl2aWRpbmcgTE9OR19NQVggYnkNCj4gSFogd2lsbCBhbHdheXMgYmUgYmlnZ2VyIHRo
YW4gdGhlIG1heCB2YWx1ZSB0aGF0IGFuIGludCB2YXJpYWJsZSBjYW4NCj4gaG9sZC4NCj4gDQo+
IFRoaXMgaGFzIGJlZW4gZGV0ZWN0ZWQgYnkgYnVpbGRpbmcgdGhlIGRyaXZlciB3aXRoIFc9MToN
Cj4gDQo+IGRyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zcnAuYzogSW4gZnVuY3Rpb24g4oCY
c3JwX3Rtb192YWxpZOKAmToNCj4gZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X3NycC5jOjky
OjE5OiB3YXJuaW5nOiBjb21wYXJpc29uIGlzIGFsd2F5cw0KPiBmYWxzZSBkdWUgdG8gbGltaXRl
ZCByYW5nZSBvZiBkYXRhIHR5cGUgWy1XdHlwZS1saW1pdHNdDQo+IGlmIChkZXZfbG9zc190bW8g
Pj0gTE9OR19NQVggLyBIWikNCj4gICAgICAgICAgICAgICAgICAgIF4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEF1Z3VzdG8gTWVja2luZyBDYXJpbmdpIDxhdWd1c3RvY2FyaW5naUBnbWFpbC5jb20+
DQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X3NycC5jIHwgMiArLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X3NycC5jIGIvZHJpdmVycy9zY3Np
L3Njc2lfdHJhbnNwb3J0X3NycC5jDQo+IGluZGV4IGI4N2E3ODYuLmQ4YzgzZjQgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9zcnAuYw0KPiArKysgYi9kcml2ZXJz
L3Njc2kvc2NzaV90cmFuc3BvcnRfc3JwLmMNCj4gQEAgLTg5LDcgKzg5LDcgQEAgaW50IHNycF90
bW9fdmFsaWQoaW50IHJlY29ubmVjdF9kZWxheSwgaW50IGZhc3RfaW9fZmFpbF90bW8sIGludCBk
ZXZfbG9zc190bW8pDQo+ICAJaWYgKGZhc3RfaW9fZmFpbF90bW8gPCAwICYmDQo+ICAJICAgIGRl
dl9sb3NzX3RtbyA+IFNDU0lfREVWSUNFX0JMT0NLX01BWF9USU1FT1VUKQ0KPiAgCQlyZXR1cm4g
LUVJTlZBTDsNCj4gLQlpZiAoZGV2X2xvc3NfdG1vID49IExPTkdfTUFYIC8gSFopDQo+ICsJaWYg
KGRldl9sb3NzX3RtbyA+PSBJTlRfTUFYIC8gSFopDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAg
CWlmIChmYXN0X2lvX2ZhaWxfdG1vID49IDAgJiYgZGV2X2xvc3NfdG1vID49IDAgJiYNCj4gIAkg
ICAgZmFzdF9pb19mYWlsX3RtbyA+PSBkZXZfbG9zc190bW8pDQoNClRoaXMgcGF0Y2ggaXMgd3Jv
bmcuIFRoZSBwdXJwb3NlIG9mIHRoZSBkZXZfbG9zc190bW8gPj0gTE9OR19NQVggLyBIWiBjaGVj
aw0KaXMgdG8gYXZvaWQgdGhhdCB0aGUgZXhwcmVzc2lvbiAxVUwgKiBkZXZfbG9zc190bW8gKiBI
WiBmdXJ0aGVyIGRvd24NCm92ZXJmbG93cy4gQ2FuIHlvdSBjaGVjayB3aGV0aGVyIGNoYW5naW5n
IHRoZSBpZi1zdGF0ZW1lbnQgaW50byBpZiAoMVVMICoNCmRldl9sb3NzX3RtbyA+PSBMT05HX01B
WCAvIEhaKSBhbHNvIHN1cHByZXNzZXMgdGhlIGNvbXBpbGVyIHdhcm5pbmc/DQoNCkJhcnQu
