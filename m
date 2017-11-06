From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 0/4] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Mon, 6 Nov 2017 00:18:50 +0000
Message-ID: <1509927529.8757.1.camel@wdc.com>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
         <CAGXu5jJnB9rAN_qjrdh3iGfWtB2-p5dqNOtqScnSZn9j20iFgg@mail.gmail.com>
         <F16A8DFC-AF77-44A0-BDC8-F0197A314123@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:51644 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdKFASy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Nov 2017 19:18:54 -0500
In-Reply-To: <F16A8DFC-AF77-44A0-BDC8-F0197A314123@cavium.com>
Content-Language: en-US
Content-ID: <3E1A26FD83F09144A7D80CE7883CCB94@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>, "Himanshu.Madhani@cavium.com" <Himanshu.Madhani@cavium.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "qla2xxx-upstream@cavium.com" <qla2xxx-upstream@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

T24gV2VkLCAyMDE3LTExLTAxIGF0IDE5OjE4ICswMDAwLCBNYWRoYW5pLCBIaW1hbnNodSB3cm90
ZToNCj4gSGkgS2VlcywgDQo+IA0KPiA+IE9uIE5vdiAxLCAyMDE3LCBhdCAxMTo0NiBBTSwgS2Vl
cyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwg
T2N0IDMxLCAyMDE3IGF0IDEyOjEzIFBNLCBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9y
Zz4gd3JvdGU6DQo+ID4gPiBUaGlzIGJyZWFrcyBvdXQgdGhlIGxvZ2ljYWwgc3RlcHMgdG8gY29u
dmVydCB0aGUgcWxhMnh4eCB0aW1lcnM6DQo+ID4gPiANCj4gPiA+IDEpIGluaXRfdGltZXIoKSAt
PiBzZXR1cF90aW1lcigpDQo+ID4gPiAyKSByZWZhY3RvciBxbGEyeDAwX3N0YXJ0X3RpbWVyKCkg
dG8gbm90IHBhc3MgY2FsbGJhY2sgYXMgYXJndW1lbnQNCj4gPiA+IDMpIHFsYTJ4MDBfdGltZXIo
KSB0byB1c2UgdGltZXJfc2V0dXAoKQ0KPiA+ID4gNCkgcWxhMngwMF9zcF90aW1lb3V0KCkgdG8g
dXNlIHRpbWVyX3NldHVwKCkNCj4gPiA+IA0KPiA+ID4gVGhlIHJlc3VsdGluZyBkaWZmIGlzIGlk
ZW50aWNhbCB0byB0aGUgcGF0Y2ggdGhhdCBhcHBlYXJzIHRvIGxvY2sgdXANCj4gPiA+IHRoZSBk
cml2ZXIuIFRoaXMgc2hvdWxkIGhlbHAgaWRlbnRpZnkgd2hpY2ggc3RlcCBjYXVzZXMgdGhpcyBi
ZWhhdmlvci4NCj4gPiANCj4gPiBIaSwganVzdCBjdXJpb3VzIGlmIHRoZXJlJ3MgYmVlbiBhbnkg
cHJvZ3Jlc3Mgb24gZGVidWdnaW5nIHRoZSBpc3N1ZQ0KPiA+IHlvdSBzYXcgd2l0aCB0aGlzIHNl
cmllcz8NCj4gDQo+IFNvcnJ5IGZvciBkZWxheS4gSSB3aWxsIHRlc3QgdGhpcyBzZXJpZXMgbGF0
ZXIgdG9kYXkgYW5kIHBvc3QgdXBkYXRlLiANCg0KSGVsbG8gSGltYW5zaHUgYW5kIEtlZXMsDQoN
ClRoZSBxbGEyeHh4IGRyaXZlciBkb2VzIG5vdCBjcmFzaCBpZiBhcHBseSB0aGVzZSBmb3VyIHBh
dGNoZXMgb24ga2VybmVsDQp2NC4xNC1yYzggYW5kIGxvYWQgdGhlIHFsYTJ4eHggZHJpdmVyIG9u
IG15IHRlc3Qgc2V0dXAuIFBvaW50LXRvLXBvaW50DQptb2RlIHNlZW1zIGJyb2tlbiBhZ2FpbiBi
dXQgSSBkb24ndCB0aGluayB0aGF0J3MgcmVsYXRlZCB0byB0aGlzIHBhdGNoDQpzZXJpZXMuDQoN
CkJhcnQu
