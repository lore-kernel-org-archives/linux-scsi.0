From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v5 14/14] nvme: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Mon, 31 Oct 2016 15:10:36 +0000
Message-ID: <1477926635.2511.1.camel@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
         <fe057bf0-6ede-fc9e-9a53-9d790c9782c2@sandisk.com>
         <540193784.5466628.1477921998345.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0074.outbound.protection.outlook.com ([104.47.40.74]:4992
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S943680AbcJaPKj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Oct 2016 11:10:39 -0400
In-Reply-To: <540193784.5466628.1477921998345.JavaMail.zimbra@redhat.com>
Content-Language: en-US
Content-ID: <77BA6145B5B13840AAB2DC0AD60AE64A@namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "loberman@redhat.com" <loberman@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "keith.busch@intel.com" <keith.busch@intel.com>, "dledford@redhat.com" <dledford@redhat.com>

T24gTW9uLCAyMDE2LTEwLTMxIGF0IDA5OjUzIC0wNDAwLCBMYXVyZW5jZSBPYmVybWFuIHdyb3Rl
Og0KPiBBcHBsaWVkIGFsbCAxNCBwYXRjaGVzLCBhbHNvIGNvcnJlY3RlZCB0aGUgcGFydCBvZiB0
aGUgeGVuLWJsa2Zyb250LmMgDQo+IGJsa2lmX3JlY292ZXIgcGF0Y2ggaW4gcGF0Y2h2NS01LzE0
Lg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2sveGVuLWJsa2Zyb250LmMgYi9kcml2
ZXJzL2Jsb2NrL3hlbi0NCj4gYmxrZnJvbnQuYw0KPiBpbmRleCA5OTA4NTk3Li42MGZmZjk5IDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtmcm9udC5jDQo+ICsrKyBiL2RyaXZl
cnMvYmxvY2sveGVuLWJsa2Zyb250LmMNCj4gQEAgLTIwNDUsNiArMjA0NSw3IEBAIHN0YXRpYyBp
bnQgYmxraWZfcmVjb3ZlcihzdHJ1Y3QgYmxrZnJvbnRfaW5mbw0KPiAqaW5mbykNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoEJVR19PTihyZXEtPm5yX3BoeXNfc2VnbWVudHMg
PiBzZWdzKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJsa19tcV9yZXF1
ZXVlX3JlcXVlc3QocmVxKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgfQ0KPiArwqDCoMKgwqDCoMKg
wqDCoGJsa19tcV9zdGFydF9zdG9wcGVkX2h3X3F1ZXVlcyhpbmZycSwNCj4gdHJ1ZSk7wqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCoqKiBDb3JyZWN0ZWQNCj4gwqDCoMKg
wqDCoMKgwqDCoMKgYmxrX21xX2tpY2tfcmVxdWV1ZV9saXN0KGluZnJxKTsNCj4gwqANCj4gwqDC
oMKgwqDCoMKgwqDCoMKgd2hpbGUgKChiaW8gPSBiaW9fbGlzdF9wb3AoJmluZmJpb19saXN0KSkg
IT0gTlVMTCkgew0KDQpIZWxsbyBMYXVyZW5jZSwNCg0KU29ycnkgZm9yIHRoZSBidWlsZCBmYWls
dXJlLiBUaGUgd2F5IHlvdSBjaGFuZ2VkIHhlbi1ibGtmcm9udCBpcyBpbmRlZWQNCndoYXQgSSBp
bnRlbmRlZC4gQXBwYXJlbnRseSBJIGZvcmdvdCB0byBlbmFibGUgWGVuIGluIG15IGtlcm5lbCBj
b25maWcNCi4uLg0KDQpCYXJ0Lg==
