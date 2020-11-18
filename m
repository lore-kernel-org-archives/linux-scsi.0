Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8EEC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACDD524654
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Emb8wF+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgKRJFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 04:05:10 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:54094 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726690AbgKRJFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 04:05:09 -0500
X-UUID: 60219152979d441796e68b5da55ec20e-20201118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=sVHPcL5zweKCEakHoExS8RiyEaMih0MIWkOl8zmPlpQ=;
        b=Emb8wF+bj3IdSOyacyI8v7uXczFHmZwoUWJTBz4k5YTPI2DR/G0+1/dCWRMsDzEFwwfuhxOm5+JMf6CmLU5YZITGvugypWtksKiYAVmie6WehioqDi5qrMvwOKlJvGk1675+HvmC346ZBxm89u7Z6cWmT5FU2fSuFzhdFl6lxYc=;
X-UUID: 60219152979d441796e68b5da55ec20e-20201118
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1189853474; Wed, 18 Nov 2020 17:05:04 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Nov
 2020 17:05:02 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Nov 2020 17:05:02 +0800
Message-ID: <1605690302.18082.1.camel@mtkswgap22>
Subject: Re: [PATCH v2 9/9] block: Do not accept any requests while suspended
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Can Guo" <cang@codeaurora.org>, Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Date:   Wed, 18 Nov 2020 17:05:02 +0800
In-Reply-To: <20201116030459.13963-10-bvanassche@acm.org>
References: <20201116030459.13963-1-bvanassche@acm.org>
         <20201116030459.13963-10-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTExLTE2IGF0IDExOjA0ICswODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEZyb206IEFsYW4gU3Rlcm4gPHN0ZXJuQHJvd2xhbmQuaGFydmFyZC5lZHU+DQo+IA0KPiBi
bGtfcXVldWVfZW50ZXIoKSBhY2NlcHRzIEJMS19NUV9SRVFfUFJFRU1QVCBpbmRlcGVuZGVudCBv
ZiB0aGUgcnVudGltZQ0KPiBwb3dlciBtYW5hZ2VtZW50IHN0YXRlLiBTaW5jZSBTQ1NJIGRvbWFp
biB2YWxpZGF0aW9uIG5vIGxvbmdlciBkZXBlbmRzIG9uDQo+IHRoaXMgYmVoYXZpb3IsIG1vZGlm
eSB0aGUgYmVoYXZpb3Igb2YgYmxrX3F1ZXVlX2VudGVyKCkgYXMgZm9sbG93czoNCj4gLSBEbyBu
b3QgYWNjZXB0IGFueSByZXF1ZXN0cyB3aGlsZSBzdXNwZW5kZWQuDQo+IC0gT25seSBwcm9jZXNz
IHBvd2VyIG1hbmFnZW1lbnQgcmVxdWVzdHMgd2hpbGUgc3VzcGVuZGluZyBvciByZXN1bWluZy4N
Cj4gDQo+IFN1Ym1pdHRpbmcgQkxLX01RX1JFUV9QUkVFTVBUIHJlcXVlc3RzIHRvIGEgZGV2aWNl
IHRoYXQgaXMgcnVudGltZS0NCj4gc3VzcGVuZGVkIGNhdXNlcyBydW50aW1lLXN1c3BlbmRlZCBi
bG9jayBkZXZpY2VzIG5vdCB0byByZXN1bWUgYXMgdGhleQ0KPiBzaG91bGQuIFRoZSByZXF1ZXN0
IHdoaWNoIHNob3VsZCBjYXVzZSBhIHJ1bnRpbWUgcmVzdW1lIGluc3RlYWQgZ2V0cw0KPiBpc3N1
ZWQgZGlyZWN0bHksIHdpdGhvdXQgcmVzdW1pbmcgdGhlIGRldmljZSBmaXJzdC4gT2YgY291cnNl
IHRoZSBkZXZpY2UNCj4gY2FuJ3QgaGFuZGxlIGl0IHByb3Blcmx5LCB0aGUgSS9PIGZhaWxzLCBh
bmQgdGhlIGRldmljZSByZW1haW5zIHN1c3BlbmRlZC4NCj4gDQo+IFRoZSBwcm9ibGVtIGlzIGZp
eGVkIGJ5IGNoZWNraW5nIHRoYXQgdGhlIHF1ZXVlJ3MgcnVudGltZS1QTSBzdGF0dXMNCj4gaXNu
J3QgUlBNX1NVU1BFTkRFRCBiZWZvcmUgYWxsb3dpbmcgYSByZXF1ZXN0IHRvIGJlIGlzc3VlZCwg
YW5kDQo+IHF1ZXVpbmcgYSBydW50aW1lLXJlc3VtZSByZXF1ZXN0IGlmIGl0IGlzLiAgSW4gcGFy
dGljdWxhciwgdGhlIGlubGluZQ0KPiBibGtfcG1fcmVxdWVzdF9yZXN1bWUoKSByb3V0aW5lIGlz
IHJlbmFtZWQgYmxrX3BtX3Jlc3VtZV9xdWV1ZSgpIGFuZA0KPiB0aGUgY29kZSBpcyB1bmlmaWVk
IGJ5IG1lcmdpbmcgdGhlIHN1cnJvdW5kaW5nIGNoZWNrcyBpbnRvIHRoZQ0KPiByb3V0aW5lLiAg
SWYgdGhlIHF1ZXVlIGlzbid0IHNldCB1cCBmb3IgcnVudGltZSBQTSwgb3IgdGhlcmUgY3VycmVu
dGx5DQo+IGlzIG5vIHJlc3RyaWN0aW9uIG9uIGFsbG93ZWQgcmVxdWVzdHMsIHRoZSByZXF1ZXN0
IGlzIGFsbG93ZWQuDQo+IExpa2V3aXNlIGlmIHRoZSBCTEtfTVFfUkVRX1BSRUVNUFQgZmxhZyBp
cyBzZXQgYW5kIHRoZSBzdGF0dXMgaXNuJ3QNCj4gUlBNX1NVU1BFTkRFRC4gIE90aGVyd2lzZSBh
IHJ1bnRpbWUgcmVzdW1lIGlzIHF1ZXVlZCBhbmQgdGhlIHJlcXVlc3QNCj4gaXMgYmxvY2tlZCB1
bnRpbCBjb25kaXRpb25zIGFyZSBtb3JlIHN1aXRhYmxlLg0KPiANCj4gQ2M6IENhbiBHdW8gPGNh
bmdAY29kZWF1cm9yYS5vcmc+DQo+IENjOiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0
ZWsuY29tPg0KPiBDYzogTWluZyBMZWkgPG1pbmcubGVpQHJlZGhhdC5jb20+DQo+IENjOiBSYWZh
ZWwgSi4gV3lzb2NraSA8cmFmYWVsLmoud3lzb2NraUBpbnRlbC5jb20+DQo+IFJlcG9ydGVkLWFu
ZC10ZXN0ZWQtYnk6IE1hcnRpbiBLZXBwbGluZ2VyIDxtYXJ0aW4ua2VwcGxpbmdlckBwdXJpLnNt
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGFuIFN0ZXJuIDxzdGVybkByb3dsYW5kLmhhcnZhcmQuZWR1
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4N
Cg0KUmV2aWV3ZWQtYnk6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoN
Cg0K

