Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD3BC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 15:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D3C0611F2
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 15:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhDUPHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 11:07:54 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36760 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238067AbhDUPHw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 11:07:52 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9155441268;
        Wed, 21 Apr 2021 15:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1619017630; x=
        1620832031; bh=naHOwxO5PGhnqzxlQmROUBcliJeUHo+BMhLRonTpiyY=; b=W
        2yXwKaIcUO4utwYHpR0qffNbifuhO7sNgRY7OK/cWuLsNDbqhehldmUzNbjY5sdM
        UymUIceJB0CU0WaCTPpx+KbYbhnygBiTARC8nNPw3fzTS50V0R59PnInxguT3Uv0
        K+Eb5yFzK+vtFB/f65M3iNlD66W1cXnjIQgN533YAA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CWNMFbOLoUnq; Wed, 21 Apr 2021 18:07:10 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1CCAE41241;
        Wed, 21 Apr 2021 18:07:09 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 21 Apr 2021 18:07:09 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Wed, 21 Apr 2021 18:07:09 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH v2] target: core: remove from tmr_list at lun unlink
Thread-Topic: [PATCH v2] target: core: remove from tmr_list at lun unlink
Thread-Index: AQHXMqI/H57DoNH3mkWn7Ff2D9R1+qq3iwkAgAADNACAByTakA==
Date:   Wed, 21 Apr 2021 15:07:09 +0000
Message-ID: <39c7c7c7671742c183cfddd4a4a68ee9@yadro.com>
References: <20210416092146.3201-1-d.bogdanov@yadro.com>
 <d4a19bc6-a89a-7572-b726-31df86fc84fd@oracle.com>
 <a91500ce-5ff8-8f97-03dc-74ae097d22e2@oracle.com>
In-Reply-To: <a91500ce-5ff8-8f97-03dc-74ae097d22e2@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.213]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPj4+IC0tLSBhL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldC5j
DQo+Pj4gKysrIGIvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0LmMNCj4+PiBAQCAt
MjE0Miw3ICsyMTQyLDcgQEAgaXNjc2l0X2hhbmRsZV90YXNrX21ndF9jbWQoc3RydWN0IGlzY3Np
X2Nvbm4gKmNvbm4sIHN0cnVjdCBpc2NzaV9jbWQgKmNtZCwNCj4+PiAgCSAqIFRNUiBUQVNLX1JF
QVNTSUdOLg0KPj4+ICAJICovDQo+Pj4gIAlpc2NzaXRfYWRkX2NtZF90b19yZXNwb25zZV9xdWV1
ZShjbWQsIGNvbm4sIGNtZC0+aV9zdGF0ZSk7DQo+Pj4gLQl0YXJnZXRfcHV0X3Nlc3NfY21kKCZj
bWQtPnNlX2NtZCk7DQo+Pj4gKwl0cmFuc3BvcnRfZ2VuZXJpY19mcmVlX2NtZCgmY21kLT5zZV9j
bWQsIGZhbHNlKTsNCj4+PiAgCXJldHVybiAwOw0KPj4+ICB9DQo+PiANCj4+IERvaC4gSSBzZWUg
aG93IEkgZ290IGFsbCBjb25mdXNlZC4gSSBndWVzcyB0aGlzIHBhdGggbGVha3MgdGhlIGx1bl9y
ZWYgDQo+PiB0YWtlbiBieSB0cmFuc3BvcnRfbG9va3VwX3Rtcl9sdW4uIEl0IGxvb2tzIGxpa2Ug
YW4gb2xkIGlzc3VlIGFuZCANCj4+IG5vdGhpbmcgdG8gZG8gd2l0aCB5b3VyIHBhdGNoLg0KDQo+
PiBJJ20gbm90IHN1cmUgaWYgd2UgYXJlIHN1cHBvc2VkIHRvIGJlIGNhbGxpbmcgDQo+PiB0cmFu
c3BvcnRfZ2VuZXJpY19mcmVlX2NtZCB0d2ljZS4gSXQgbG9va3MgbGlrZSBpdCB3b3JrcyBvaywg
YmVjYXVzZSB5b3VyIHBhdGNoIGFkZGVkIHRoZSAiY21kLT5zZV9sdW4gPSBOVUxMIg0KPj4gaW4g
dHJhbnNwb3J0X2x1bl9yZW1vdmVfY21kLCBzbyB3ZSB3b24ndCBkbyBhIGRvdWJsZSBsaXN0IGRl
bGV0aW9uLg0KPj4gSXQgZmVlbHMgZGlydHkgdGhvdWdoLiBJIGNhbiBmZWVsIEJhcnQgc2F5aW5n
LCAiTWlrZSBkaWQgeW91IHNlZSB0aGUgDQo+PiBjb21tZW50IGF0IHRoZSB0b3Agb2YgdGhlIGZ1
bmN0aW9uIi4gOikNCj4+IA0KPj4gTWF5YmUgaXQncyBiZXN0IHRvIG1vcmUgY2xlYW5seSB1bndp
bmQgd2hhdCB3YXMgc2V0dXAgaW4gdGhlIHJyb3IgDQo+PiBwYXRoLiBJIHRoaW5rIHdlIGNhbiBm
aXggbHVuX3JlZiBsZWFrIHRvby4NCj4+IA0KPj4gU28gaW5zdGVhZCBvZiBkb2luZyB0cmFuc3Bv
cnRfZ2VuZXJpY19mcmVlX2NtZCBhYm92ZSBkbyANCj4+IHRyYW5zcG9ydF9sdW5fcmVtb3ZlX2Nt
ZCB0byBtYXRjaC91bmRvIHRoZSB0cmFuc3BvcnRfbG9va3VwX3Rtcl9sdW4gY2FsbCBpbiBpc2Nz
aXRfaGFuZGxlX3Rhc2tfbWd0X2NtZD8NCj4NCj5TaG9vdC4gSSdtIGFsbCBvdmVyIHRoZSBwbGFj
ZS4gSSB0aGluayB0aGUgcm9vdCBpc3N1ZSBpcyBteSBvcmlnaW5hbCBjb21tZW50IG9uIHRoZSB2
MSBwYXRjaCB3YXMgd3JvbmcuDQo+T24gYSBmYWlsdXJlIHdlIHdvdWxkIHN0aWxsIGRvOg0KPmlz
Y3NpdF9mcmVlX2NtZCAtPiB0cmFuc3BvcnRfZ2VuZXJpY19mcmVlX2NtZCAtPiB0cmFuc3BvcnRf
bHVuX3JlbW92ZV9jbWQNCj5yaWdodD8gU28gd2UgZG9uJ3QgbmVlZCBhbnkgY2hhbmdlIGluIHRo
ZSBpc2NzaSB0YXJnZXQuIEl0IHNob3VsZCBhbGwganVzdCB3b3JrLg0KDQppc2NzaXRfZnJlZV9j
bWQgd2lsbCBiZSBjYWxsZWQgb25seSBhdCByZXNwb25zZSBjb21wbGV0aW9uKG5leHQgaW5jb21p
bmcgaXNjc2kgY29tbWFuZCk6IGlzY3NpdF9hY2tfZnJvbV9leHBzdGF0c24gLT4gaXNjc2l0X2Zy
ZWVfY21kLg0KVGhhdCBwcm9kdWNlcyBzb21lIHVuYWNjZXB0YWJsZSBkZWxheSBvZiBsdW4gdW5s
aW5raW5nIGZyb20gY21kLiBUaGVyZSBpcyBhIGJ1ZyByZXBvcnQgdG8gdGhlIHNpbWlsYXIgYmVo
YXZpb3I6DQpodHRwOi8vbGttbC5pdS5lZHUvaHlwZXJtYWlsL2xpbnV4L2tlcm5lbC8yMDAyLjAv
MDUyNzIuaHRtbA0KQmVjYXVzZSBvZiB0aGF0IGNvbXBsYWluLCB0aGUgY29tbWl0IDgzZjg1Yjhl
YzMwNSwgdGhhdCBzb2x2ZXMgdGhlIHNhbWUgY3Jhc2ggYXMgSSBhbSBmaXhpbmcsICB3YXMgcmV2
ZXJ0ZWQuDQoNClNvLCB0aGlzIHBpZWNlIG9mIHBhdGNoIGhhcyBzb21lIGluZGlyZWN0IHJlbGF0
aW9uIDopDQpJIHdpbGwgZXh0cmFjdCBpdCB0byBhIHNlcGFyYXRlIHBhdGNoIGluIHRoZSBjb21p
bmcgcGF0Y2hzZXQgb24gVE1GIGhhbmRsaW5nLg0KDQpCUiwNCiBEbWl0cnkNCg==
