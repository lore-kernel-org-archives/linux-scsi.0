From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 2/4] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Tue, 8 Nov 2016 17:40:49 +0000
Message-ID: <3CD90A52-9D95-4280-BE67-E276B563577E@cavium.com>
References: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
 <1478277213-3848-3-git-send-email-himanshu.madhani@cavium.com>
 <1478534026.32271.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0044.outbound.protection.outlook.com ([104.47.32.44]:27012
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753021AbcKHTOR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 14:14:17 -0500
In-Reply-To: <1478534026.32271.28.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <CE8EBC7A5F73FB488936C46DCFE1D430@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "himanshu.madhani@qlogic.com" <himanshu.madhani@qlogic.com>

SGkgRXdhbiwNCg0KDQoNCk9uIDExLzcvMTYsIDc6NTMgQU0sICJFd2FuIEQuIE1pbG5lIiA8ZW1p
bG5lQHJlZGhhdC5jb20+IHdyb3RlOg0KDQo+T24gRnJpLCAyMDE2LTExLTA0IGF0IDA5OjMzIC0w
NzAwLCBoaW1hbnNodS5tYWRoYW5pQGNhdml1bS5jb20gd3JvdGU6DQo+Li4uDQo+PiBAQCAtMjM0
OSw2ICsyMzQ5LDE3IEBAIHVpbnQzMl90IHFsYTJ4MDBfaXNwX3JlZ19zdGF0KHN0cnVjdCBxbGFf
aHdfZGF0YSAqaGEpDQo+PiAgCXJldHVybiBhdG9taWNfcmVhZCgmdmhhLT5sb29wX3N0YXRlKSA9
PSBMT09QX1JFQURZOw0KPj4gIH0NCj4+ICANCj4+ICtzdGF0aWMgdm9pZCBxbGEyeDAwX2Rlc3Ry
b3lfbWJ4X3dxKHN0cnVjdCBxbGFfaHdfZGF0YSAqaGEpDQo+PiArew0KPj4gKwlzdHJ1Y3Qgd29y
a3F1ZXVlX3N0cnVjdCAqd3EgPSBoYS0+bWJ4X3dxOw0KPj4gKw0KPj4gKwlpZiAod3EpIHsNCj4+
ICsJCWhhLT5tYnhfd3EgPSBOVUxMOw0KPj4gKwkJZmx1c2hfd29ya3F1ZXVlKHdxKTsNCj4+ICsJ
CWRlc3Ryb3lfd29ya3F1ZXVlKHdxKTsNCj4+ICsJfQ0KPj4gK30NCj4+ICsNCj4+ICAvKg0KPj4g
ICAqIFBDSSBkcml2ZXIgaW50ZXJmYWNlDQo+PiAgICovDQo+DQo+VGhlcmUgaXMgYWxyZWFkeSBh
IGZ1bmN0aW9uIHFsYTJ4MDBfZGVzdHJveV9kZWZlcnJlZF93b3JrKCkgdGhhdA0KPmRlc3Ryb3lz
IDMgb3RoZXIgd29ya3F1ZXVlcy4NCj4NCj4uLi4NCj4NCj4+IEBAIC0zMDU5LDYgKzMwNzksOCBA
QCB1aW50MzJfdCBxbGEyeDAwX2lzcF9yZWdfc3RhdChzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhhKQ0K
Pj4gIA0KPj4gIAlxbGEyeDAwX2ZyZWVfZndfZHVtcChoYSk7DQo+PiAgDQo+PiArCXFsYTJ4MDBf
ZGVzdHJveV9tYnhfd3EoaGEpOw0KPj4gKw0KPj4gIAlwY2lfZGlzYWJsZV9wY2llX2Vycm9yX3Jl
cG9ydGluZyhwZGV2KTsNCj4+ICAJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOw0KPj4gIH0NCj4N
Cj5UaGlzIGNvZGUgcGF0aCAocGNpX2RyaXZlci0+c2h1dGRvd24pIGRvZXMgbm90IGFwcGVhciB0
byBkZXN0cm95IHRoZQ0KPm90aGVyIHdvcmtxdWV1ZXMgY3JlYXRlZCBieSB0aGUgZHJpdmVyLiA/
Pz8NCj4NCj4+IEBAIC01MDExLDYgKzUwMzMsOCBAQCB2b2lkIHFsYTJ4MDBfcmVsb2dpbihzdHJ1
Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhKQ0KPj4gIAkgKi8NCj4+ICAJcWxhMngwMF9mcmVlX3N5c2Zz
X2F0dHIoYmFzZV92aGEsIGZhbHNlKTsNCj4+ICANCj4+ICsJcWxhMngwMF9kZXN0cm95X21ieF93
cShoYSk7DQo+PiArDQo+PiAgCWZjX3JlbW92ZV9ob3N0KGJhc2VfdmhhLT5ob3N0KTsNCj4+ICAN
Cj4+ICAJc2NzaV9yZW1vdmVfaG9zdChiYXNlX3ZoYS0+aG9zdCk7DQo+DQo+U2VlIGFib3ZlLg0K
DQpBY2suIHdpbGwgZml4IHVwIHBhdGNoIHRvIGFkZHJlc3MgdGhlc2UgY29tbWVudHMuIA0KIA0K
DQo+DQo+LUV3YW4NCg0KVGhhbmtzLA0KSGltYW5zaHUNCg==
