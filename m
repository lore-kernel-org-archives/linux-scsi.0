From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v2 3/4] scsi: Avoid that .queuecommand() gets called for a
 quiesced SCSI device
Date: Fri, 12 Jan 2018 22:45:57 +0000
Message-ID: <1515797155.2396.86.camel@wdc.com>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
         <20180110181817.25166-4-bart.vanassche@wdc.com>
         <20180111022341.GA7290@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111022341.GA7290-1Cy0MwPVgsaKEAUSAb389g@public.gmane.org>
Content-Language: en-US
Content-ID: <1962A62B8D409E409D88F3ACC224BF07-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jthumshirn-l3A5Bk7waGM@public.gmane.org" <jthumshirn-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hare-IBi9RG/b67k@public.gmane.org" <hare-IBi9RG/b67k@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDEwOjIzICswODAwLCBNaW5nIExlaSB3cm90ZToNCj4gPiBu
b3Qgc3VmZmljaWVudCB0byBwcmV2ZW50IC5xdWV1ZWNvbW1hbmQoKSBjYWxscyBmcm9tIHNjc2lf
c2VuZF9laF9jbW5kKCkuDQo+IA0KPiBHaXZlbiBpdCBpcyBlcnJvciBoYW5kbGluZywgZG8gd2Ug
bmVlZCB0byBwcmV2ZW50IHRoZSAucXVldWVjb21tYW5kKCkgY2FsbA0KPiBpbiBzY3NpX3NlbmRf
ZWhfY21uZCgpPyBDb3VsZCB5b3Ugc2hhcmUgdXMgd2hhdCB0aGUgYWN0dWFsIGlzc3VlDQo+IG9i
c2VydmVkIGlzIGZyb20gdXNlciB2aWV3Pw0KDQpQbGVhc2UgaGF2ZSBhIGxvb2sgYXQgdGhlIGtl
cm5lbCBidWcgcmVwb3J0IGluIHRoZSBkZXNjcmlwdGlvbiBvZiBwYXRjaCA0LzQgb2YNCnRoaXMg
c2VyaWVzLg0KDQo+ID4gSGVuY2Ugc3Vycm91bmQgdGhlIC5xdWV1ZWNvbW1hbmQoKSBjYWxsIGZy
b20gdGhlIFNDU0kgZXJyb3IgaGFuZGxlciB3aXRoDQo+ID4gYmxrX3N0YXJ0X3dhaXRfaWZfcXVp
ZXNjZWQoKSAvIGJsa19maW5pc2hfd2FpdF9pZl9xdWllc2NlZCgpLg0KPiA+IA0KPiA+IE5vdGU6
IGNvbnZlcnRpbmcgdGhlIC5xdWV1ZWNvbW1hbmQoKSBjYWxsIGluIHNjc2lfc2VuZF9laF9jbW5k
KCkgaW50bw0KPiA+IGNvZGUgdGhhdCBjYWxscyBibGtfZ2V0X3JlcXVlc3QoKSwgZS5nLiBzY3Np
X2V4ZWN1dGVfcmVxKCksIGlzIG5vdCBhbg0KPiA+IG9wdGlvbiBzaW5jZSBzY3NpX3NlbmRfZWhf
Y21uZCgpIGNhbiBiZSBjYWxsZWQgaWYgYWxsIHJlcXVlc3RzIGFyZQ0KPiA+IGFsbG9jYXRlZCBh
bmQgaWYgbm8gcmVxdWVzdHMgd2lsbCBtYWtlIHByb2dyZXNzIHdpdGhvdXQgYWJvcnRpbmcgYW55
DQo+ID4gb2YgdGhlc2UgcmVxdWVzdHMuDQo+IA0KPiBJZiB3ZSBuZWVkIHRvIHByZXZlbnQgdGhl
IC5xdWV1ZWNvbW1hbmQoKSBpbiBzY3NpX3NlbmRfZWhfY21uZCgpLCB3aGF0DQo+IGRvIHlvdSB0
aGluayBvZiB0aGUgYXBwcm9hY2ggYnkgcmVxdWV1aW5nIHRoZSBFSCBjb21tYW5kIHZpYQ0KPiBz
Y3NpX21xX3JlcXVldWVfY21kKCkvc2NzaV9yZXF1ZXVlX2NtZCgpPyBBbmQgdGhlIEVIIHJlcXVl
c3Qgd2lsbCBiZQ0KPiBkaXNwYXRjaGVkIGZpbmFsbHkgd2hlbiB0aGUgcXVldWUgYmVjb21lcyB1
bnF1aWVzY2VkIG9yIHRoZSBTVE9QUEVEDQo+IGlzIGNsZWFyZWQuDQoNCkNhbGxpbmcgc2NzaV9t
cV9yZXF1ZXVlX2NtZCgpIHdvdWxkIHRyaWdnZXIgc2NzaV9tcV91bmluaXRfY21kKCksDQpibGtf
bXFfcHV0X2RyaXZlcl90YWcoKSwgYmxrX21xX2dldF9kcml2ZXJfdGFnKCkgYW5kIHNjc2lfbXFf
cHJlcF9mbigpLg0KVGhhdCBjb3VsZCBjYXVzZSBzY3NpX2VoX3NjbWRfYWRkKCkgdG8gYmUgY2Fs
bGVkIG11bHRpcGxlIHRpbWVzIGZvciB0aGUNCnNhbWUgU0NTSSBjb21tYW5kLiBIb3dldmVyLCB0
aGF0IHdvdWxkIGJyZWFrIG9uZSBvZiB0aGUgYXNzdW1wdGlvbnMNCnNjc2lfZWhfc2NtZF9hZGQo
KSBpcyBiYXNlZCBvbiwgbmFtZWx5IHRoYXQgdGhhdCBmdW5jdGlvbiBnZXRzIGNhbGxlZA0Kb25s
eSBvbmNlIHBlciBTQ1NJIGNvbW1hbmQgdGhhdCBpcyBpbiBwcm9ncmVzcy4NCg0KQmFydC4g
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
