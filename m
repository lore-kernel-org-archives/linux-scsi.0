Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201D7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 15:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDEA561153
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 15:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346211AbhDMPxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 11:53:30 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51838 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346190AbhDMPx2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Apr 2021 11:53:28 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9A20F4136F;
        Tue, 13 Apr 2021 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1618329186; x=
        1620143587; bh=M2eN3sE8viYhhZc1aqv0I16ZfMysIqKRpZ8NGIL1vck=; b=k
        U1tC2FXUMUR5OC30bF0NPlbkDZtJA9nePS+0UIJPVIXloMYwzAI3LD4P/kjaqQSG
        eZTTjn+owSlYk+zx4L0LLWhWtRI2g2KkhGJR80OREoJWC7clsDK7oXsTWj8ldDyZ
        L4Ldn0UfKTh5XtXVBoo/r4KIoNZEsbgVvCHJifcm9Q=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vaJ3TQ8D3Qz8; Tue, 13 Apr 2021 18:53:06 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 964A44136E;
        Tue, 13 Apr 2021 18:53:06 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 13 Apr 2021 18:53:06 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Tue, 13 Apr 2021 18:53:06 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH] target: core: remove from tmr_list at lun unlink
Thread-Topic: [PATCH] target: core: remove from tmr_list at lun unlink
Thread-Index: AQHXK7lYqmKXJcU3VEyXDfN/CXSYiKqsPxKAgAAEXQCABe3aUA==
Date:   Tue, 13 Apr 2021 15:53:06 +0000
Message-ID: <ef29eab727ae49ee9a77bfe050c80261@yadro.com>
References: <20210407142140.29947-1-d.bogdanov@yadro.com>
 <f8182d4d-449a-eb00-7564-a230a1daee8a@oracle.com>
 <0cf306d4-5a4b-e4c3-f14e-7165cd4a1503@oracle.com>
In-Reply-To: <0cf306d4-5a4b-e4c3-f14e-7165cd4a1503@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.223]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPiA+IFRoaXMgaXMganVzdCBhIG5pdC4gTWF5YmUganVzdCBkbzoNCj4gPiAN
Cj4gPiBzdHJ1Y3Qgc2VfZGV2aWNlICpkZXYgPSBOVUxMOw0KPiA+IHVuc2lnbmVkIGxvbmcgZmxh
Z3M7DQo+ID4gDQo+ID4gaWYgKCEoY21kLT5zZV9jbWRfZmxhZ3MgJiBTQ0ZfU0NTSV9UTVJfQ0RC
KSkNCj4gPiAJcmV0dXJuOw0KPiA+IA0KPiA+IGRldiA9IGNtZC0+c2VfdG1yX3JlcS0+dG1yX2Rl
djsNCj4gPiBzcGluX2xvY2tfaXJxc2F2ZSgmZGV2LT5zZV90bXJfbG9jaywgZmxhZ3MpOw0KPiA+
IGxpc3RfZGVsX2luaXQoJmNtZC0+c2VfdG1yX3JlcS0+dG1yX2xpc3QpOw0KPiA+IHNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmRldi0+c2VfdG1yX2xvY2ssIGZsYWdzKTsNCj4gPiANCg0KPiBUaGlz
IG1pZ2h0IGJlIHdyb25nLiBJIHRob3VnaHQgd2hlbiB5b3UgbW92ZWQgdGhlIGRlbGV0aW9uIHRv
DQo+IHRyYW5zcG9ydF9jbWRfY2hlY2tfc3RvcF90b19mYWJyaWMsIHdlIHdvdWxkIGFsd2F5cyBo
YXZlIGEgZGV2IHNldC4NCj4gQnV0IGluIGNvcmVfdG1yX2Fib3J0X3Rhc2sgdGhlcmUgaXMgdGhh
dCB0cmFuc3BvcnRfbG9va3VwX3Rtcl9sdW4NCj4gY2hlY2suIElmIHRoYXQgaXMgYSB2YWxpZCBj
aGVjayBpbiB0aGVyZSBhbmQgaXQgY291bGQgYmUgTlVMTCBpbg0KPiB0aGUgcGF0aDoNCg0KPiB0
cmFuc3BvcnRfZ2VuZXJpY19oYW5kbGVfdG1yIC0+IHRhcmdldF9oYW5kbGVfYWJvcnQgLT4gDQo+
IHJhbnNwb3J0X2NtZF9jaGVja19zdG9wX3RvX2ZhYnJpYw0KPg0KPiB0aGVuIHdlIHdvdWxkIGhp
dCBhIE5VTEwgcG9pbnRlci4gSSdtIG5vdCBzdXJlIGhvdyB3ZSB3b3VsZCBnZXQgYSBOVUxMDQo+
IGRldiB0aGVyZSB0aG91Z2guIFRoZSBkcml2ZXIgd291bGQgaGF2ZSB0byBub3QgdXNlIHRoZSBz
dGFuZGFyZA0KPiB0YXJnZXRfc3VibWl0X3RtciBvciBiZSBpc2NzaSBhbmQgbm90IGNhbGwgdHJh
bnNwb3J0X2xvb2t1cF90bXJfbHVuLg0KSW4gdGhlb3J5IGl0IGNhbiBkbyBzb21lIG91dC1vZi10
cmVlIHRyYW5zcG9ydCBkcml2ZXIsIG9rIEkgd2lsbCBrZWVwIGEgZ3VhcmQNCmluIHRhcmdldF9y
ZW1vdmVfZnJvbV90bXJfbGlzdCgpLg0KDQo+DQo+IE9uZSBpc3N1ZSB3aXRoIHRoZSBwYXRjaCB0
aG91Z2ggaXMgaWYgaXNjc2l0X3Rtcl9hYm9ydF90YXNrIGZhaWxzIHRoZW4gd2UgZG9uJ3QNCj4g
Y2FsbCB0cmFuc3BvcnRfY21kX2NoZWNrX3N0b3BfdG9fZmFicmljLCBzbyB0aGUgdG1yIHdpbGwg
YmUgc3R1Y2sgb24gdGhlIGxpc3QuDQpZZXMsIEkgc2VlLiBJIGFtIGdvaW5nIHRvIHVzZSB0aGlz
IHBhdGNoIHRvIHNvbHZlIGl0Og0KLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFy
Z2V0LmMNCisrKyBiL2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldC5jDQpAQCAtMjE0
Miw3ICsyMTQyLDcgQEAgaXNjc2l0X2hhbmRsZV90YXNrX21ndF9jbWQoc3RydWN0IGlzY3NpX2Nv
bm4gKmNvbm4sIHN0cnVjdCBpc2NzaV9jbWQgKmNtZCwNCiAgICAgICAgICogVE1SIFRBU0tfUkVB
U1NJR04uDQogICAgICAgICAqLw0KICAgICAgICBpc2NzaXRfYWRkX2NtZF90b19yZXNwb25zZV9x
dWV1ZShjbWQsIGNvbm4sIGNtZC0+aV9zdGF0ZSk7DQotICAgICAgIHRhcmdldF9wdXRfc2Vzc19j
bWQoJmNtZC0+c2VfY21kKTsNCisgICAgICAgdHJhbnNwb3J0X2dlbmVyaWNfZnJlZV9jbWQoJmNt
ZC0+c2VfY21kLCBmYWxzZSk7DQogICAgICAgIHJldHVybiAwOw0KIH0NCiBFWFBPUlRfU1lNQk9M
KGlzY3NpdF9oYW5kbGVfdGFza19tZ3RfY21kKTsNCg0KDQpCUiwNCiBEbWl0cnkNCg==
