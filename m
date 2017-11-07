From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 22:34:35 +0000
Message-ID: <1510094074.2656.39.camel@wdc.com>
References: <20171104015534.32684-1-ming.lei@redhat.com>
         <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
         <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
         <1510071607.2656.17.camel@wdc.com>
         <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
         <49b5c202-0303-85f7-102a-fcc013e7256e@kernel.dk>
         <292e3f7d-cfe3-840a-5a5e-d00e01239152@kernel.dk>
         <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
Content-Language: en-US
Content-ID: <C7CBC00EE299C04585CC673012EE1B17@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTExLTA3IGF0IDE1OjA2IC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBK
dXN0IHRvIGtlZXAgZXZlcnlvbmUgaW4gdGhlIGxvb3AsIHRoaXMgYnVnIGlzIG5vdCBuZXcgdG8N
Cj4gZm9yLTQuMTUvYmxvY2ssIG5vciBpcyBpdCBuZXcgdG8gdGhlIGN1cnJlbnQgNC40MS1yYyBv
ciA0LjEzLiBTbyBpdCdzDQo+IHByb2JhYmx5IGRpZmZlcmVudCB0byB3aGF0IEJhcnQgaXMgaGl0
dGluZywgYnV0IGl0J3MgYSBidWcgbm9uZSB0aGUNCj4gbGVzcy4uLg0KDQpIZWxsbyBKZW5zLA0K
DQpUaGVyZSBhcmUgc2V2ZXJhbCByZWFzb25zIHdoeSBJIHRoaW5rIHRoYXQgcGF0Y2ggImJsay1t
cTogZG9uJ3QgaGFuZGxlDQpUQUdfU0hBUkVEIGluIHJlc3RhcnQiIHJlYWxseSBzaG91bGQgYmUg
cmV2ZXJ0ZWQ6DQoqIFRoYXQgcGF0Y2ggaXMgYmFzZWQgb24gdGhlIGFzc3VtcHRpb24gdGhhdCBv
bmx5IHRoZSBTQ1NJIGRyaXZlciB1c2VzIHNoYXJlZA0KICB0YWdzLiBUaGF0IGFzc3VtcHRpb24g
aXMgbm90IGNvcnJlY3QuIG51bGxfYmxrIGFuZCBudm1lIGFsc28gdXNlIHNoYXJlZCB0YWdzLg0K
KiBBcyBteSB0ZXN0cyBoYXZlIHNob3duLCB0aGUgYWxnb3JpdGhtIGZvciByZXN0YXJ0aW5nIHF1
ZXVlcyBiYXNlZCBvbiB0aGUNCiAgU0NTSSBzdGFydmVkIGxpc3QgaXMgZmxhd2VkLiBTbyB1c2lu
ZyB0aGF0IG1lY2hhbmlzbSBpbnN0ZWFkIG9mIHRoZSBibGstbXENCiAgc2hhcmVkIHF1ZXVlIHJl
c3RhcnRpbmcgYWxnb3JpdGhtIGlzIHdyb25nLg0KKiBXZSBhcmUgY2xvc2UgdG8gdGhlIG1lcmdl
IHdpbmRvdy4gSXQgaXMgdG9vIGxhdGUgZm9yIHRyeWluZyB0byBmaXggdGhlDQogICJibGstbXE6
IGRvbid0IGhhbmRsZSBUQUdfU0hBUkVEIGluIHJlc3RhcnQiIHBhdGNoLg0KDQpNeSBwcm9wb3Nh
bCBpcyB0byBtYWtlIHN1cmUgdGhhdCB3aGF0IHdpbGwgYmUgc2VudCB0byBMaW51cyBkdXJpbmcg
dGhlIHY0LjE1DQptZXJnZSB3aW5kb3cgd29ya3MgcmVsaWFibHkuIFRoYXQgbWVhbnMgdXNpbmcg
dGhlIHY0LjEzL3Y0LjE0IGFsZ29yaXRobSBmb3INCnF1ZXVlIHJlc3RhcnRpbmcgd2hpY2ggaXMg
YW4gYWxnb3JpdGhtIHRoYXQgaXMgdHJ1c3RlZCBieSB0aGUgY29tbXVuaXR5LiBJZg0KUm9tYW4g
UGVueWFldidzIHBhdGNoIGNvdWxkIGdldCBhcHBsaWVkIHRoYXQgd291bGQgYmUgZXZlbiBiZXR0
ZXIuDQoNCkJhcnQu
