From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Mon, 16 Jan 2017 16:20:30 +0000
Message-ID: <1484583615.3144.1.camel@sandisk.com>
References: <20161229080250.GA11605@infradead.org>
         <1483226343.2518.32.camel@linux.vnet.ibm.com>
         <1483280506.5512.1.camel@sandisk.com>
         <20170101.113311.417107391370623850.davem@davemloft.net>
         <1483292364.2345.5.camel@linux.vnet.ibm.com>
         <bd5a8849-e533-7d27-750b-0d89b8918c22@akamai.com>
         <1484499673.2405.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:56736
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751007AbdAPQUh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Jan 2017 11:20:37 -0500
In-Reply-To: <1484499673.2405.4.camel@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <08C8BD4049F93E449756E1AF0FB1D0E0@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "davem@davemloft.net" <davem@davemloft.net>, "jbaron@akamai.com" <jbaron@akamai.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "dledford@redhat.com" <dledford@redhat.com>

T24gU3VuLCAyMDE3LTAxLTE1IGF0IDA5OjAxIC0wODAwLCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6
DQo+IEZyb20gYjQ3YzI4NDM0ZTljZWU5Y2JiOTVhNzk0Yzk3ZWM1MzY1NzQwODExMSBNb24gU2Vw
IDE3IDAwOjAwOjAwIDIwMDENCj4gRnJvbTogSmFtZXMgQm90dG9tbGV5IDxqZWpiQGxpbnV4LnZu
ZXQuaWJtLmNvbT4NCj4gRGF0ZTogU3VuLCAxIEphbiAyMDE3IDA5OjM5OjI0IC0wODAwDQo+IFN1
YmplY3Q6IFtQQVRDSF0gc2NzaTogbXB0M3NhczogZml4IGhhbmcgb24gYXRhIHBhc3N0aHJ1IGNv
bW1hbmRzDQo+IA0KPiBtcDNzYXMgaGFzIGEgZmlybXdhcmUgZmFpbHVyZSB3aGVyZSBpdCBjYW4g
b25seSBoYW5kbGUgb25lIHBhc3MNCj4gdGhyb3VnaCBBVEEgY29tbWFuZCBhdCBhIHRpbWUuICBJ
ZiBhbm90aGVyIGNvbWVzIGluLCBjb250cmFyeSB0byB0aGUNCj4gU0FUIHN0YW5kYXJkLCBpdCB3
aWxsIGhhbmcgdW50aWwgdGhlIGZpcnN0IG9uZSBjb21wbGV0ZXMgKGNhdXNpbmcgbG9uZw0KPiBj
b21tYW5kcyBsaWtlIHNlY3VyZSBlcmFzZSB0byB0aW1lb3V0KS4gIFRoZSBvcmlnaW5hbCBmaXgg
d2FzIHRvIGJsb2NrDQo+IHRoZSBkZXZpY2Ugd2hlbiBhbiBBVEEgY29tbWFuZCBjYW1lIGluLCBi
dXQgdGhpcyBjYXVzZWQgYSByZWdyZXNzaW9uDQo+IHdpdGgNCj4gDQo+IGNvbW1pdCA2NjlmMDQ0
MTcwZDg5MzNjM2Q2NmQyMzFiNjllYTk3Y2I4NDQ3MzM4DQo+IEF1dGhvcjogQmFydCBWYW4gQXNz
Y2hlIDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4NCj4gRGF0ZTogICBUdWUgTm92IDIyIDE2
OjE3OjEzIDIwMTYgLTA4MDANCj4gDQo+ICAgICBzY3NpOiBzcnBfdHJhbnNwb3J0OiBNb3ZlIHF1
ZXVlY29tbWFuZCgpIHdhaXQgY29kZSB0byBTQ1NJIGNvcmUNCj4gDQo+IFNvIGZpeCB0aGUgb3Jp
Z2luYWwgZml4IG9mIHRoZSBzZWN1cmUgZXJhc2UgdGltZW91dCBieSBwcm9wZXJseQ0KPiByZXR1
cm5pbmcgU0FNX1NUQVRfQlVTWSBsaWtlIHRoZSBTQVQgcmVjb21tZW5kcy4NCj4gDQo+IEZpeGVz
OiAxOGY2MDg0YTk4OWJhMWIzODcwMmY5YWYzN2EyZTQwNDlhOTI0YmU2DQo+IFNpZ25lZC1vZmYt
Ynk6IEphbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNv
bT4NCg0KSGVsbG8gSmFtZXMsDQoNClRoaXMgZGVzY3JpcHRpb24gbG9va3MgaW5jb21wbGV0ZSB0
byBtZS4gSXQgZG9lc24ndCBtZW50aW9uIHRoZSByYWNlDQpjb25kaXRpb24gdGhhdCB3YXMgaW50
cm9kdWNlZCBieSBwYXRjaCAic2NzaTogbXB0M3NhczogRml4IHNlY3VyZQ0KZXJhc2UgcHJlbWF0
dXJlIHRlcm1pbmF0aW9uIi4gUGxlYXNlIGFsc28gZm9sbG93IHRoZSBndWlkZWxpbmVzIGZyb20N
CnByb2Nlc3Mvc3VibWl0dGluZy1wYXRjaGVzLnJzdCBmb3IgdGhlICJGaXhlczoiIHRhZy4gQSBx
dW90ZSBmcm9tIHRoYXQNCmRvY3VtZW50OiAicGxlYXNlIHVzZSB0aGUgJ0ZpeGVzOicgdGFnIHdp
dGggdGhlIGZpcnN0IDEyIGNoYXJhY3RlcnMNCm9mIHRoZSBTSEEtMSBJRCwgYW5kIHRoZSBvbmUg
bGluZSBzdW1tYXJ5Ii4gUGxlYXNlIGFsc28gZml4IHRoZQ0Kc3BlbGxpbmcgb2YgdGhlIGFkYXB0
ZXIgbmFtZSAibXAzc2FzIi4NCg0KVGhhbmtzLA0KDQpCYXJ0Lg==
