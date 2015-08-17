From: "Hiral Shah (hishah)" <hishah@cisco.com>
Subject: Re: [PATCH 1/1] Using the local variable instead of I/O flag to
 acquire io_req_lock in fnic_queuecommand() to avoid deadloack
Date: Mon, 17 Aug 2015 17:50:39 +0000
Message-ID: <8FC9A9E3-7C47-45D1-869B-6E4E5A15396D@cisco.com>
References: <1436882937-11741-1-git-send-email-hishah@cisco.com>
 <yq1pp3rmtsd.fsf@sermon.lab.mkp.net>
 <6C49D972-4646-4074-927E-EF1B9F75BF34@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:25112 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbbHQSAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2015 14:00:12 -0400
In-Reply-To: <6C49D972-4646-4074-927E-EF1B9F75BF34@cisco.com>
Content-Language: en-US
Content-ID: <4F0820D31940A542BFF3039E10CDAFB9@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Anil Chintalapati (achintal)" <achintal@cisco.com>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

QnJvYWRjYXN0aW5n4oCmDQoNClJlZ2FyZHMsDQpIaXJhbA0KDQoNCg0KDQoNCg0KDQoNCk9uIDcv
MjAvMTUsIDU6NDggUE0sICJIaXJhbCBTaGFoIChoaXNoYWgpIiA8aGlzaGFoQGNpc2NvLmNvbT4g
d3JvdGU6DQoNCj5IaSBNYXJ0aW4sDQo+DQo+VGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4gQWN0
dWFsbHkgYm9vdCBtYWtlIG1vcmUgc2Vuc2UgYXMgdGhlIHZhbHVlIHdpbGwgYmUgZWl0aGVyIDAg
b3IgMSBvbmx5LiBXZSBoYXZlIGFscmVhZHkgcmVsZWFzZSBmb2xsb3dpbmcgcGF0Y2ggdG8gb3Ro
ZXIgbm9uLWxpbnV4IGN1c3RvbWVycy4gV2Ugd2lsbCBtYWtlIHN1cmUgbmV4dCB0aW1lLg0KPg0K
Pg0KPlJlZ2FyZHMsDQo+SGlyYWwNCj4NCj4NCj4NCj4NCj4NCj4NCj4NCj4NCj5PbiA3LzE2LzE1
LCA5OjU2IFBNLCAiTWFydGluIEsuIFBldGVyc2VuIiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5j
b20+IHdyb3RlOg0KPg0KPj4+Pj4+PiAiSGlyYWwiID09IEhpcmFsIFNoYWggPGhpc2hhaEBjaXNj
by5jb20+IHdyaXRlczoNCj4+DQo+PkhpcmFsPiBXZSBhZGRlZCBjaGFuZ2VzIGluIGZuaWMgZHJp
dmVyIHBhdGNoIDEuNi4wLjE2IHRvIGFjcXVpcmUNCj4+SGlyYWw+IGlvX3JlcV9sb2NrIGluIGZu
aWNfcXVldWVjb21tYW5kKCkgYmVmb3JlIGlzc3VpbmcgSS9PIHNvIHRoYXQgaW8NCj4+SGlyYWw+
IGNvbXBsZXRpb24gaXMgc2VyaWFsaXplZC4gQnV0IHdoZW4gcmVsZWFzaW5nIHRoZSBsb2NrIHdl
IGNoZWNrDQo+PkhpcmFsPiBmb3IgdGhlIEkvTyBmbGFnIGFuZCB0aGlzIGNvdWxkIGJlIG1vZGlm
aWVkIGlmIElPIGFib3J0IG9jY3Vycw0KPj5IaXJhbD4gYmVmb3JlIEkvTyBjb21wbGV0aW9uLiBJ
biB0aGlzIGNhc2Ugd2Ugd29udCByZWxlYXNlIHRoZSBsb2NrIGFuZA0KPj5IaXJhbD4gY2F1c2Vz
IGRlYWRsb2NrIGluIHNvbWUgc2NlbmVyaW9zLiBVc2luZyB0aGUgbG9jYWwgdmFyaWFibGUgdG8N
Cj4+SGlyYWw+IGNoZWNrIHRoZSBJTyBsb2NrIHN0YXR1cyB3aWxsIHJlc29sdmUgdGhlIHByb2Js
ZW0uDQo+Pg0KPj5NYXliZSBib29sIGluc3RlYWQgb2YgaW50Pw0KPj4NCj4+T3RoZXJ3aXNlIE9L
Lg0KPj4NCj4+UmV2aWV3ZWQtYnk6IE1hcnRpbiBLLiBQZXRlcnNlbiA8bWFydGluLnBldGVyc2Vu
QG9yYWNsZS5jb20+DQo+Pg0KPj4tLSANCj4+TWFydGluIEsuIFBldGVyc2VuCU9yYWNsZSBMaW51
eCBFbmdpbmVlcmluZw0K
