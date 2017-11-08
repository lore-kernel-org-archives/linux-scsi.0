From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 16:41:35 +0000
Message-ID: <1510159293.24237.19.camel@wdc.com>
References: <20171104015534.32684-1-ming.lei@redhat.com>
         <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
         <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
         <1510071607.2656.17.camel@wdc.com> <20171108003934.GB20599@ming.t460p>
         <26ee805b-883f-d588-5649-13700244b6e8@kernel.dk>
         <20171108025830.GA30129@ming.t460p>
         <1a153ff3-9d53-d347-cb16-b8480e690221@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1a153ff3-9d53-d347-cb16-b8480e690221@kernel.dk>
Content-Language: en-US
Content-ID: <EE38EDA544EC114C912D827AFD438C24@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "osandov@fb.com" <osandov@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE3LTExLTA3IGF0IDIwOjA2IC0wNzAwLCBKZW5zIEF4Ym9lIHdyb3RlOg0KPiBB
dCB0aGlzIHBvaW50LCBJIGhhdmUgbm8gaWRlYSB3aGF0IEJhcnQncyBzZXR1cCBsb29rcyBsaWtl
LiBCYXJ0LCBpdA0KPiB3b3VsZCBiZSBSRUFMTFkgaGVscGZ1bCBpZiB5b3UgY291bGQgdGVsbCB1
cyBob3cgeW91IGFyZSByZXByb2R1Y2luZw0KPiB5b3VyIGhhbmcuIEkgZG9uJ3Qga25vdyB3aHkg
dGhpcyBoYXMgdG8gYmUgZHJhZ2dlZCBvdXQuDQoNCkhlbGxvIEplbnMsDQoNCkl0IGlzIGEgZGlz
YXBwb2ludG1lbnQgdG8gbWUgdGhhdCB5b3UgaGF2ZSBhbGxvd2VkIE1pbmcgdG8gZXZhbHVhdGUg
b3RoZXINCmFwcHJvYWNoZXMgdGhhbiByZXZlcnRpbmcgImJsay1tcTogZG9uJ3QgaGFuZGxlIFRB
R19TSEFSRUQgaW4gcmVzdGFydCIuIFRoYXQNCnBhdGNoIG5hbWVseSByZXBsYWNlcyBhbiBhbGdv
cml0aG0gdGhhdCBpcyB0cnVzdGVkIGJ5IHRoZSBjb21tdW5pdHkgd2l0aCBhbg0KYWxnb3JpdGht
IG9mIHdoaWNoIGV2ZW4gTWluZyBhY2tub3dsZWRnZWQgdGhhdCBpdCBpcyByYWN5LiBBIHF1b3Rl
IGZyb20gWzFdOg0KIklPIGhhbmcgbWF5IGJlIGNhdXNlZCBpZiBhbGwgcmVxdWVzdHMgYXJlIGNv
bXBsZXRlZCBqdXN0IGJlZm9yZSB0aGUgY3VycmVudA0KU0NTSSBkZXZpY2UgaXMgYWRkZWQgdG8g
c2hvc3QtPnN0YXJ2ZWRfbGlzdCIuIEkgZG9uJ3Qga25vdyBvZiBhbnkgd2F5IHRvIGZpeA0KdGhh
dCByYWNlIG90aGVyIHRoYW4gc2VyaWFsaXppbmcgcmVxdWVzdCBzdWJtaXNzaW9uIGFuZCBjb21w
bGV0aW9uIGJ5IGFkZGluZw0KbG9ja2luZyBhcm91bmQgdGhlc2UgYWN0aW9ucywgd2hpY2ggaXMg
c29tZXRoaW5nIHdlIGRvbid0IHdhbnQuIEhlbmNlIG15DQpyZXF1ZXN0IHRvIHJldmVydCB0aGF0
IHBhdGNoLg0KDQpSZWdhcmRpbmcgdGhlIHRlc3QgSSBydW4sIGhlcmUgaXMgYSBzdW1tYXJ5IG9m
IHdoYXQgSSBtZW50aW9uZWQgaW4gcHJldmlvdXMNCmUtbWFpbHM6DQoqIEkgbW9kaWZpZWQgdGhl
IFNSUCBpbml0aWF0b3Igc3VjaCB0aGF0IHRoZSBTQ1NJIHRhcmdldCBxdWV1ZSBkZXB0aCBpcw0K
ICByZWR1Y2VkIHRvIG9uZSBieSBzZXR0aW5nIHN0YXJnZXQtPmNhbl9xdWV1ZSB0byAxIGZyb20g
aW5zaWRlDQogIHNjc2lfaG9zdF90ZW1wbGF0ZS50YXJnZXRfYWxsb2MuDQoqIFdpdGggdGhhdCBt
b2RpZmllZCBTUlAgaW5pdGlhdG9yIEkgcnVuIHRoZSBzcnAtdGVzdCBzb2Z0d2FyZSBhcyBmb2xs
b3dzDQogIHVudGlsIHNvbWV0aGluZyBicmVha3M6DQogIHdoaWxlIC4vcnVuX3Rlc3RzIC1mIHhm
cyAtZCAtZSBkZWFkbGluZSAtciA2MDsgZG8gOjsgZG9uZQ0KDQpUb2RheSBhIHN5c3RlbSB3aXRo
IGF0IGxlYXN0IG9uZSBJbmZpbmlCYW5kIEhDQSBpcyByZXF1aXJlZCB0byBydW4gdGhhdCB0ZXN0
Lg0KV2hlbiBJIGhhdmUgdGhlIHRpbWUgSSB3aWxsIHBvc3QgdGhlIFNSUCBpbml0aWF0b3IgYW5k
IHRhcmdldCBwYXRjaGVzIG9uIHRoZQ0KbGludXgtcmRtYSBtYWlsaW5nIGxpc3QgdGhhdCBtYWtl
IGl0IHBvc3NpYmxlIHRvIHJ1biB0aGF0IHRlc3QgYWdhaW5zdCB0aGUNClNvZnRSb0NFIGRyaXZl
ciAoZHJpdmVycy9pbmZpbmliYW5kL3N3L3J4ZSkuIFRoZSBvbmx5IGhhcmR3YXJlIHJlcXVpcmVk
IHRvDQp1c2UgdGhhdCBkcml2ZXIgaXMgYW4gRXRoZXJuZXQgYWRhcHRlci4NCg0KQmFydC4NCg0K
WzFdIFtQQVRDSF0gU0NTSTogZG9uJ3QgZ2V0IHRhcmdldC9ob3N0IGJ1c3lfY291bnQgaW4gc2Nz
aV9tcV9nZXRfYnVkZ2V0KCkNCihodHRwczovL3d3dy5tYWlsLWFyY2hpdmUuY29tL2xpbnV4LWJs
b2NrQHZnZXIua2VybmVsLm9yZy9tc2cxNTI2My5odG1sKS4=
