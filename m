From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] blk-mq: Fix several SCSI request queue lockups
Date: Mon, 4 Dec 2017 22:48:18 +0000
Message-ID: <1512427697.2795.14.camel@wdc.com>
References: <20171204173032.16330-1-bart.vanassche@wdc.com>
         <20171204224200.GA6888@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59995 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLDWsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 17:48:21 -0500
In-Reply-To: <20171204224200.GA6888@ming.t460p>
Content-Language: en-US
Content-ID: <DDD5BD0DB68A3B44BDC0E819456B8984@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

T24gVHVlLCAyMDE3LTEyLTA1IGF0IDA2OjQyICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gT24g
TW9uLCBEZWMgMDQsIDIwMTcgYXQgMDk6MzA6MzJBTSAtMDgwMCwgQmFydCBWYW4gQXNzY2hlIHdy
b3RlOg0KPiA+ICogQSBzeXN0ZW1hdGljIGxvY2t1cCBmb3IgU0NTSSBxdWV1ZXMgd2l0aCBxdWV1
ZSBkZXB0aCAxLiBUaGUNCj4gPiAgIGZvbGxvd2luZyB0ZXN0IHJlcHJvZHVjZXMgdGhhdCBidWcg
c3lzdGVtYXRpY2FsbHk6DQo+ID4gICAtIENoYW5nZSB0aGUgU1JQIGluaXRpYXRvciBzdWNoIHRo
YXQgU0NTSSB0YXJnZXQgcXVldWUgZGVwdGggaXMNCj4gPiAgICAgbGltaXRlZCB0byAxLg0KPiA+
ICAgLSBSdW4gdGhlIGZvbGxvd2luZyBjb21tYW5kOg0KPiA+ICAgICAgIHNycC10ZXN0L3J1bl90
ZXN0cyAtZiB4ZnMgLWQgLWUgbm9uZSAtciA2MCAtdCAwMQ0KPiA+ICAgU2VlIGFsc28gIltQQVRD
SCA0LzddIGJsay1tcTogQXZvaWQgdGhhdCByZXF1ZXN0IHByb2Nlc3NpbmcNCj4gPiAgIHN0YWxs
cyB3aGVuIHNoYXJpbmcgdGFncyINCj4gPiAgIChodHRwczovL21hcmMuaW5mby8/bD1saW51eC1i
bG9jayZtPTE1MTIwODY5NTMxNjg1NykuIE5vdGU6DQo+ID4gICByZXZlcnRpbmcgY29tbWl0IDBk
ZjIxYzg2YmRiZiBhbHNvIGZpeGVzIGEgc3BvcmFkaWMgU0NTSSByZXF1ZXN0DQo+ID4gICBxdWV1
ZSBsb2NrdXAgd2hpbGUgaW5zZXJ0aW5nIGEgYmxrX21xX3NjaGVkX21hcmtfcmVzdGFydF9oY3R4
KCkNCj4gPiAgIGJlZm9yZSBhbGwgYmxrX21xX2Rpc3BhdGNoX3JxX2xpc3QoKSBjYWxscyBvbmx5
IGZpeGVzIHRoZQ0KPiA+ICAgc3lzdGVtYXRpYyBsb2NrdXAgZm9yIHF1ZXVlIGRlcHRoIDEuDQo+
IA0KPiBZb3UgYXJlIHRoZSBvbmx5IHJlcHJvZHVjZXIgWyAuLi4gXQ0KDQpUaGF0J3Mgbm90IGNv
cnJlY3QuIEknbSBwcmV0dHkgc3VyZSBpZiB5b3UgdHJ5IHRvIHJlcHJvZHVjZSB0aGlzIHRoYXQN
CnlvdSB3aWxsIHNlZSB0aGUgc2FtZSBoYW5nIEkgcmFuIGludG8uIERvZXMgdGhpcyBtZWFuIHRo
YXQgeW91IGhhdmUgbm90DQp5ZXQgdHJpZWQgdG8gcmVwcm9kdWNlIHRoZSBoYW5nIEkgcmVwb3J0
ZWQ/DQoNCj4gWW91IHNhaWQgdGhhdCB5b3VyIHBhdGNoIGZpeGVzICdjb21taXQgYjM0NzY4OWZm
YmNhICgiYmxrLW1xLXNjaGVkOg0KPiBpbXByb3ZlIGRpc3BhdGNoaW5nIGZyb20gc3cgcXVldWUi
KScsIGJ1dCB5b3UgZG9uJ3QgbWVudGlvbiBhbnkgaXNzdWUNCj4gYWJvdXQgdGhhdCBjb21taXQu
DQoNClRoYXQncyBub3QgY29ycmVjdCBlaXRoZXIuIEZyb20gdGhlIGNvbW1pdCBtZXNzYWdlICJB
IHN5c3RlbWF0aWMgbG9ja3VwDQpmb3IgU0NTSSBxdWV1ZXMgd2l0aCBxdWV1ZSBkZXB0aCAxLiIN
Cg0KPiA+IEkgdGhpbmsgdGhlIGFib3ZlIG1lYW5zIHRoYXQgaXQgaXMgdG9vIHJpc2t5IHRvIHRy
eSB0byBmaXggYWxsIGJ1Z3MNCj4gPiBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCAwZGYyMWM4NmJkYmYg
YmVmb3JlIGtlcm5lbCB2NC4xNSBpcyByZWxlYXNlZC4NCj4gPiBIZW5jZSByZXZlcnQgdGhhdCBj
b21taXQuDQo+IA0KPiBXaGF0IGlzIHRoZSByaXNrPw0KDQpUaGF0IG1vcmUgYnVncyB3ZXJlIGlu
dHJvZHVjZWQgYnkgY29tbWl0IDBkZjIxYzg2YmRiZiB0aGFuIHRoZSBvbmVzIHRoYXQNCmhhdmUg
YmVlbiBkaXNjb3ZlcmVkIHNvIGZhci4NCg0KQmFydC4=
