Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465ECC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26879611F2
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhIVQpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:45:30 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:58464 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231925AbhIVQp3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 12:45:29 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 780B943EDB;
        Wed, 22 Sep 2021 16:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1632329033; x=
        1634143434; bh=jEcF9jrFFknizQXVio793eWQQQtI0Q3SBQaN/X5YYig=; b=Y
        1Tqz+bzeGPnqWKjIqv/gTg8FxcGL8MxEUQn20KrUANqQ3n9EAxtQ+HUteYA9HdBe
        mwzlIXE9LYBfK/Oxv5Pjxf1cHY8QscELnaDLFOPf25Hmdj2IbVxU8EsJ583ev94h
        dUXbuinsvRCJLmMjQD32Js+SJ8o2VJcyfP1PSNLbkQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gwaOAUDTVQMw; Wed, 22 Sep 2021 19:43:53 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 45C6043EB8;
        Wed, 22 Sep 2021 19:43:52 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 22 Sep 2021 19:43:52 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Wed, 22 Sep 2021 19:43:52 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH v3] target: core: remove from tmr_list at lun unlink
Thread-Topic: [PATCH v3] target: core: remove from tmr_list at lun unlink
Thread-Index: AQHXqjxsRxjpgHbtYEm89uYUDNcxt6uoQ5KAgATA8DCAAwqxgIAAOdSg
Date:   Wed, 22 Sep 2021 16:43:51 +0000
Message-ID: <b56124c7c8b94531bdbd7b8d2fe00633@yadro.com>
References: <20210915141719.1484-1-d.bogdanov@yadro.com>
 <40b321b4-76bd-8eb4-84bd-c7378ad2bbc7@oracle.com>
 <8f81906545014a768a7f775d1dcf51cf@yadro.com>
 <9ca9ec9f-bc6b-9aea-3b5a-43ce5fd09b5c@oracle.com>
In-Reply-To: <9ca9ec9f-bc6b-9aea-3b5a-43ce5fd09b5c@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.54]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPiBZZWFoLCBJIHRoaW5rIGl0J3Mgbm90IG5lZWRlZC4gSXQgY2FtZSBpbiB3
aXRoOg0KPg0KPiBjb21taXQgMmM5ZmE0OWUxMDBmOTYyYWY5ODhmMWMwNTI5MjMxYmYxNDkwNWNk
YQ0KPiBBdXRob3I6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiBEYXRl
OiAgIFR1ZSBOb3YgMjcgMTU6NTI6MDMgMjAxOCAtMDgwMA0KPg0KPiAgICAgc2NzaTogdGFyZ2V0
L2NvcmU6IE1ha2UgQUJPUlQgYW5kIExVTiBSRVNFVCBoYW5kbGluZyBzeW5jaHJvbm91cw0KPiBn
cmVlLiBJdCBsb29rcyBsaWtlIGl0IHdhcyBhZGRlZCBpbjoNCj4NCj4gYW5kIGluIHRoYXQgcGF0
Y2ggSSBjYW4ndCBzZWUgaXQgZXZlciBoYXBwZW5pbmcuIFdlIGhhdmUgMiB3YXlzIHRvIHN1Ym1p
dA0KPiBhbiBhYm9ydCB0bXI6DQo+DQo+IDEuIHRhcmdldF9zdWJtaXRfdG1yIC0gQ2FsbHMgdHJh
bnNwb3J0X2xvb2t1cF90bXJfbHVuIHRoZW4NCj4gdHJhbnNwb3J0X2dlbmVyaWNfaGFuZGxlX3Rt
ci4NCj4NCj4gMi4gaXNjc2l0X2hhbmRsZV90YXNrX21ndF9jbWQgLSBXaWxsIGNhbGwgdHJhbnNw
b3J0X2xvb2t1cF90bXJfbHVuDQo+IGZvciBldmVyeSB0bXIgZXhjZXB0IHRoZSBpc2NzaSBzcGVj
aWZpYyBUQVNLIFJFQVNTSUdOLiBUQVNLIFJFQVNTSU5HDQo+IGlzIG5vdCBwYXNzZWQgdG8gdHJh
bnNwb3J0X2dlbmVyaWNfaGFuZGxlX3Rtci4NCj4NCj4gSSBkb24ndCBzZWUgYW55IHBsYWNlcyB3
aGVyZSB0bXJfZGV2IGlzIE5VTEwgYWZ0ZXIgdHJhbnNwb3J0X2xvb2t1cF90bXJfbHVuDQo+IGhh
cyBzZXQgaXQgYW5kIGFkZGVkIGl0IHRvIHRoZSBsaXN0Lg0KPg0KPiBTbyBJIHRoaW5rIHlvdSBj
YW4ganVzdCBraWxsIGl0Lg0KDQpPaywgdGhlbiBpbiB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUg
cGF0Y2ggSSB3aWxsIGp1c3QgcmVtb3ZlIHRoYXQgdHJhbnNwb3J0X2xvb2t1cF90bXJfbHVuIHdp
dGggV0FSTl9PTi4NCg0KQlIsDQogRG1pdHJ5DQo=
