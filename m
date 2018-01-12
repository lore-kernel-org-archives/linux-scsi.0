From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] mptfusion: use strlcpy() instead of strncpy()
Date: Fri, 12 Jan 2018 15:09:31 +0000
Message-ID: <1515769770.3124.3.camel@wdc.com>
References: <1515757619-29651-1-git-send-email-wangxiongfeng2@huawei.com>
         <CAHp75VctB9uRwvEQH=GW65gfOOn4-P7UKNa2OxM0pO7qQjOZrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64428 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933917AbeALPJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2018 10:09:34 -0500
In-Reply-To: <CAHp75VctB9uRwvEQH=GW65gfOOn4-P7UKNa2OxM0pO7qQjOZrw@mail.gmail.com>
Content-Language: en-US
Content-ID: <03349B01A8B13A42830420635C216ACD@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>, "wangxiongfeng2@huawei.com" <wangxiongfeng2@huawei.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "arnd@arndb.de" <arnd@arndb.de>

T24gRnJpLCAyMDE4LTAxLTEyIGF0IDE1OjQ1ICswMjAwLCBBbmR5IFNoZXZjaGVua28gd3JvdGU6
DQo+IE9uIEZyaSwgSmFuIDEyLCAyMDE4IGF0IDE6NDYgUE0sICBXYW5nIDx3YW5neGlvbmdmZW5n
MkBodWF3ZWkuY29tPiB3cm90ZToNCj4gPiANCj4gPiAtICAgICAgIHN0cm5jcHkgKGthcmctPmRy
aXZlclZlcnNpb24sIE1QVF9MSU5VWF9QQUNLQUdFX05BTUUsIE1QVF9JT0NUTF9WRVJTSU9OX0xF
TkdUSCk7DQo+ID4gLSAgICAgICBrYXJnLT5kcml2ZXJWZXJzaW9uW01QVF9JT0NUTF9WRVJTSU9O
X0xFTkdUSC0xXT0nXDAnOw0KPiA+ICsgICAgICAgc3RybGNweSAoa2FyZy0+ZHJpdmVyVmVyc2lv
biwgTVBUX0xJTlVYX1BBQ0tBR0VfTkFNRSwgTVBUX0lPQ1RMX1ZFUlNJT05fTEVOR1RIKTsNCj4g
DQo+IFRoaXMgb25lIGlzIGZhbHNlIHBvc2l0aXZlLg0KPiANCj4gPiAtICAgICAgIHN0cm5jcHkg
KGthcmcubmFtZSwgaW9jLT5uYW1lLCBNUFRfTUFYX05BTUUpOw0KPiA+IC0gICAgICAga2FyZy5u
YW1lW01QVF9NQVhfTkFNRS0xXT0nXDAnOw0KPiA+IC0gICAgICAgc3RybmNweSAoa2FyZy5wcm9k
dWN0LCBpb2MtPnByb2RfbmFtZSwgTVBUX1BST0RVQ1RfTEVOR1RIKTsNCj4gPiAtICAgICAgIGth
cmcucHJvZHVjdFtNUFRfUFJPRFVDVF9MRU5HVEgtMV09J1wwJzsNCj4gPiArICAgICAgIHN0cmxj
cHkgKGthcmcubmFtZSwgaW9jLT5uYW1lLCBNUFRfTUFYX05BTUUpOw0KPiA+ICsgICAgICAgc3Ry
bGNweSAoa2FyZy5wcm9kdWN0LCBpb2MtPnByb2RfbmFtZSwgTVBUX1BST0RVQ1RfTEVOR1RIKTsN
Cj4gDQo+IFRoZXNlIHR3byBhcyB3ZWxsLg0KDQpCdXQgdXNpbmcgc3RybGNweSgpIG1ha2VzIHRo
ZSBjb2RlIGVhc2llciB0byByZWFkLg0KDQpYaW9uZ2ZlbmcsIGlmIHlvdSB3YW50IHRvIGNvbnRp
bnVlIHdpdGggdGhpcyBwYXRjaCwgcGxlYXNlIGNoYW5nZSB0aGUgdGhpcmQNCmFyZ3VtZW50IG9m
IGFsbCBzdHJsY3B5KCkgY2FsbHMgaW50byBhIHNpemVvZigpIGV4cHJlc3Npb24uIFRoYXQgbWFr
ZSB0aGUNCmNvZGUgZWFzaWVyIHRvIHZlcmlmeS4NCg0KPiA+IC0gICAgICAgc3RybmNweShrYXJn
LnNlcmlhbF9udW1iZXIsICIgIiwgMjQpOw0KPiA+ICsgICAgICAgc3RybGNweShrYXJnLnNlcmlh
bF9udW1iZXIsICIgIiwgMjQpOw0KPiANCj4gVGhpcyBvbmUgaXMgaW50ZXJlc3RpbmcgaW5kZWVk
Lg0KPiBUaG91Z2ggdGhlIGZpeCB3b3VsZCBiZSByYXRoZXIgc29tZXRoaW5nIGxpa2UNCj4gDQo+
IG1lbXNldCgma2FyZy5zZXJpYWxfbnVtYmVyLCAiICIsIDI0KTsgLy8gbGVhdmUgMjQgZm9yIGJl
c3QgcGVyZm9ybWFuY2Ugb2YgbWVtc2V0DQo+IGthcmcuc2VyaWFsX251bWJlclsyNC0xXSA9ICdc
MCc7DQoNCkRvZXMgcGVyZm9ybWFuY2UgcmVhbGx5IG1hdHRlciBpbiB0aGlzIGNvbnRleHQ/IEhv
dyBhYm91dCB0aGUgZm9sbG93aW5nIGluc3RlYWQ6DQoNCnNucHJpbnRmKGthcmcuc2VyaWFsX251
bWJlciwgc2l6ZW9mKGthcmcuc2VyaWFsX251bWJlciksICIlKnMiLCAoaW50KShrYXJnLnNlcmlh
bF9udW1iZXIpIC0gMSwgIiIpOw0KDQpCYXJ0Lg==
