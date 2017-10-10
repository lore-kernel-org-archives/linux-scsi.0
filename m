From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v7 9/9] block, scsi: Make SCSI quiesce and resume work
 reliably
Date: Tue, 10 Oct 2017 15:27:22 +0000
Message-ID: <1507649241.2815.9.camel@wdc.com>
References: <20171009231400.562-1-bart.vanassche@wdc.com>
         <20171009231400.562-10-bart.vanassche@wdc.com> <2538545.nE4DvSpPT1@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48257 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932293AbdJJP10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 11:27:26 -0400
In-Reply-To: <2538545.nE4DvSpPT1@merkaba>
Content-Language: en-US
Content-ID: <79AD6A912A555A499F9BBEBBFA478CB7@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "martin@lichtvoll.de" <martin@lichtvoll.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "hare@suse.com" <hare@suse.com>, "mcgrof@kernel.org" <mcgrof@kernel.org>

T24gVHVlLCAyMDE3LTEwLTEwIGF0IDA5OjU3ICswMjAwLCBNYXJ0aW4gU3RlaWdlcndhbGQgd3Jv
dGU6DQo+IEJhcnQgVmFuIEFzc2NoZSAtIDA5LjEwLjE3LCAxNjoxNDoNCj4gPiBUaGUgY29udGV4
dHMgZnJvbSB3aGljaCBhIFNDU0kgZGV2aWNlIGNhbiBiZSBxdWllc2NlZCBvciByZXN1bWVkIGFy
ZToNCj4gPiBbIC4uLiBdDQo+IA0KPiBEb2VzIHRoaXMgYXMgcmVsaWFibHkgZml4IHRoZSBpc3N1
ZSBhcyB0aGUgcGF0Y2hlcyBmcm9tIE1pbmc/IEkgbWVhbiBpbiAqcmVhbCANCj4gd29ybGQqIHNj
ZW5hcmlvcz8gT3IgaXMgaXQganVzdCBhYm91dCB0aGUgc2FtZSBhcHByb2FjaCBhcyBNaW5nIGhh
cyB0YWtlbi4NCj4gDQo+IEkgYXNrIGNhdXNlIEkgZG9uwrR0IHNlZSBhbnkgVGVzdGVkLUJ5OsK0
cyBoZXJlPyBJIGtub3cgSSB0ZXN0ZWQgTWluZ8K0cyBwYXRjaCANCj4gc2VyaWVzIGFuZCBJIGtu
b3cgaXQgZml4ZXMgdGhlIGhhbmcgYWZ0ZXIgcmVzdW1lIGZyb20gc3VzcGVuZCB3aXRoIGJsay1t
cSArIEJGUSANCj4gaXNzdWUgZm9yIG1lLiBJIGhhdmUgYW4gdXB0aW1lIG9mIDcgZGF5cyBhbmQg
SSBkaWRuwrR0IHNlZSBhbnkgdXB0aW1lIGV2ZW4gDQo+IHJlbW90ZWx5IGxpa2UgdGhhdCBpbiBh
IGxvbmcgdGltZSAoYmVmb3JlIHRoYXQgaXNzdWUgSW50ZWwgZ2Z4IGRyaXZlcnMgY2F1c2VkIA0K
PiBoYW5ncywgYnV0IHRoYW5rZnVsbHkgdGhhdCBzZWVtcyBmaXhlZCBtZWFud2hpbGUpLg0KPiAN
Cj4gScK0ZCBiZSB3aWxsaW5nIHRvIHRlc3QuIERvIHlvdSBoYXZlIGEgNC4xNC54IHRyZWUgYXZh
aWxhYmxlIHdpdGggdGhlc2UgcGF0Y2hlcyANCj4gYXBwbGllZCBJIGNhbiBqdXN0IGFkZCBhcyBh
IHJlbW90ZSBhbmQgZmV0Y2ggZnJvbT8NCg0KSGVsbG8gTWFydGluLA0KDQpBIHByZXZpb3VzIHZl
cnNpb24gb2YgdGhpcyBwYXRjaCBzZXJpZXMgcGFzc2VkIE9sZWtzYW5kcidzIHRlc3RzLiBUaGlz
IHNlcmllcyBpcw0KY2xvc2UgdG8gdGhhdCBwcmV2aW91cyB2ZXJzaW9uIHNvIEkgdGhpbmsgaXQg
aXMgc2FmZSB0byBhc3N1bWUgdGhhdCB0aGlzIHZlcnNpb24NCndpbGwgYWxzbyBwYXNzIE9sZWtz
YW5kcidzIHRlc3RzLiBBbnl3YXksIG1vcmUgdGVzdGluZyBpcyBkZWZpbml0ZWx5IHdlbGNvbWUg
c28NCmlmIHlvdSB3YW50IHRvIHZlcmlmeSB0aGlzIHNlcmllcyBwbGVhc2Ugc3RhcnQgZnJvbSB0
aGUgZm9sbG93aW5nIHRyZWUgKEplbnMnDQpmb3ItbmV4dCBicmFuY2ggKyB0aGlzIHNlcmllcyk6
IGh0dHBzOi8vZ2l0aHViLmNvbS9idmFuYXNzY2hlL2xpbnV4L3RyZWUvYmxrLW1xLXBtLXY3DQoN
ClRoYW5rcywNCg0KQmFydC4=
