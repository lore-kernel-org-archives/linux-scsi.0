From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 02/11] qla2xxx: Cleanup TMF code translation from
 qla_target.
Date: Wed, 11 Jan 2017 20:43:57 +0000
Message-ID: <D4727FD5-AF9D-4EE4-A727-E5F6F6E8FFE5@cavium.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
 <1482553419-4117-3-git-send-email-himanshu.madhani@cavium.com>
 <c4a6fb9b-5523-5070-50ed-b869a4686262@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:60416
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753810AbdAKUoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 15:44:01 -0500
In-Reply-To: <c4a6fb9b-5523-5070-50ed-b869a4686262@sandisk.com>
Content-Language: en-US
Content-ID: <1CD79EEF75D9DC4A85600A6D8EB79998@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

DQpPbiAxLzExLzE3LCAxMjowNSBQTSwgIkJhcnQgVmFuIEFzc2NoZSIgPGJhcnQudmFuYXNzY2hl
QHNhbmRpc2suY29tPiB3cm90ZToNCg0KPk9uIDEyLzIzLzIwMTYgMDg6MjMgUE0sIEhpbWFuc2h1
IE1hZGhhbmkgd3JvdGU6DQo+PiAgc3RhdGljIGludCB0Y21fcWxhMnh4eF9oYW5kbGVfdG1yKHN0
cnVjdCBxbGFfdGd0X21nbXRfY21kICptY21kLCB1aW50MzJfdCBsdW4sDQo+PiAtCXVpbnQ4X3Qg
dG1yX2Z1bmMsIHVpbnQzMl90IHRhZykNCj4+ICsJdWludDE2X3QgdG1yX2Z1bmMsIHVpbnQzMl90
IHRhZykNCj4+ICB7DQo+PiAgCXN0cnVjdCBxbGFfdGd0X3Nlc3MgKnNlc3MgPSBtY21kLT5zZXNz
Ow0KPj4gIAlzdHJ1Y3Qgc2VfY21kICpzZV9jbWQgPSAmbWNtZC0+c2VfY21kOw0KPj4gKwlpbnQg
dHJhbnNsX3Rtcl9mdW5jOw0KPj4gKw0KPj4gKwlzd2l0Y2ggKHRtcl9mdW5jKSB7DQo+PiArCWNh
c2UgUUxBX1RHVF9BQlRTOg0KPj4gKwkJcHJfZGVidWcoIiVsZDogQUJUUyByZWNlaXZlZFxuIiwg
c2Vzcy0+dmhhLT5ob3N0X25vKTsNCj4+ICsJCXRyYW5zbF90bXJfZnVuYyA9IFRNUl9BQk9SVF9U
QVNLOw0KPj4gKwkJYnJlYWs7DQo+PiArCWNhc2UgUUxBX1RHVF8yR19BQk9SVF9UQVNLOg0KPj4g
KwkJcHJfZGVidWcoIiVsZDogMkcgQWJvcnQgVGFzayByZWNlaXZlZFxuIiwgc2Vzcy0+dmhhLT5o
b3N0X25vKTsNCj4+ICsJCXRyYW5zbF90bXJfZnVuYyA9IFRNUl9BQk9SVF9UQVNLOw0KPj4gKwkJ
YnJlYWs7DQo+PiArCWNhc2UgUUxBX1RHVF9DTEVBUl9BQ0E6DQo+PiArCQlwcl9kZWJ1ZygiJWxk
OiBDTEVBUl9BQ0EgcmVjZWl2ZWRcbiIsIHNlc3MtPnZoYS0+aG9zdF9ubyk7DQo+PiArCQl0cmFu
c2xfdG1yX2Z1bmMgPSBUTVJfQ0xFQVJfQUNBOw0KPj4gKwkJYnJlYWs7DQo+PiArCWNhc2UgUUxB
X1RHVF9UQVJHRVRfUkVTRVQ6DQo+PiArCQlwcl9kZWJ1ZygiJWxkOiBUQVJHRVRfUkVTRVQgcmVj
ZWl2ZWRcbiIsIHNlc3MtPnZoYS0+aG9zdF9ubyk7DQo+PiArCQl0cmFuc2xfdG1yX2Z1bmMgPSBU
TVJfVEFSR0VUX1dBUk1fUkVTRVQ7DQo+PiArCQlicmVhazsNCj4+ICsJY2FzZSBRTEFfVEdUX0xV
Tl9SRVNFVDoNCj4+ICsJCXByX2RlYnVnKCIlbGQ6IExVTl9SRVNFVCByZWNlaXZlZFxuIiwgc2Vz
cy0+dmhhLT5ob3N0X25vKTsNCj4+ICsJCXRyYW5zbF90bXJfZnVuYyA9IFRNUl9MVU5fUkVTRVQ7
DQo+PiArCQlicmVhazsNCj4+ICsJY2FzZSBRTEFfVEdUX0NMRUFSX1RTOg0KPj4gKwkJcHJfZGVi
dWcoIiVsZDogQ0xFQVJfVFMgcmVjZWl2ZWRcbiIsIHNlc3MtPnZoYS0+aG9zdF9ubyk7DQo+PiAr
CQl0cmFuc2xfdG1yX2Z1bmMgPSBUTVJfQ0xFQVJfVEFTS19TRVQ7DQo+PiArCQlicmVhazsNCj4+
ICsJY2FzZSBRTEFfVEdUX0FCT1JUX1RTOg0KPj4gKwkJcHJfZGVidWcoIiVsZDogQUJPUlRfVFMg
cmVjZWl2ZWRcbiIsIHNlc3MtPnZoYS0+aG9zdF9ubyk7DQo+PiArCQl0cmFuc2xfdG1yX2Z1bmMg
PSBUTVJfQUJPUlRfVEFTS19TRVQ7DQo+PiArCQlicmVhazsNCj4+ICsJZGVmYXVsdDoNCj4+ICsJ
CXByX2RlYnVnKCIlbGQ6IFVua25vd24gdGFzayBtZ210IGZuIDB4JXhcbiIsDQo+PiArCQkgICAg
c2Vzcy0+dmhhLT5ob3N0X25vLCB0bXJfZnVuYyk7DQo+PiArCQlyZXR1cm4gLUVOT1NZUzsNCj4+
ICsJCWJyZWFrOw0KPj4gKwl9DQo+PiAgDQo+PiAgCXJldHVybiB0YXJnZXRfc3VibWl0X3Rtcihz
ZV9jbWQsIHNlc3MtPnNlX3Nlc3MsIE5VTEwsIGx1biwgbWNtZCwNCj4+ICAJCQl0bXJfZnVuYywg
R0ZQX0FUT01JQywgdGFnLCBUQVJHRVRfU0NGX0FDS19LUkVGKTsNCj4NCj5IZWxsbyBIaW1hbnNo
dSBhbmQgUXVpbm4sDQo+DQo+VGhpcyBwYXRjaCBpbnRyb2R1Y2VzIGEgbmV3IGNvbXBpbGVyIHdh
cm5pbmcgd2hlbiBidWlsZGluZyB3aXRoIFc9MSwNCj5uYW1lbHkgdGhhdCB0cmFuc2xfdG1yX2Z1
bmMgaXMgc2V0IGJ1dCBub3QgdXNlZC4gUGxlYXNlIHJldmlldyB0aGUgY29kZS4NCg0KU3VyZS4g
V2lsbCB1cGRhdGUgcGF0Y2guIA0KDQo+VGhhbmtzLA0KPg0KPkJhcnQuDQo=
