Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA92C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE6A64F18
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 08:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCRI7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 04:59:12 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51226 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229558AbhCRI6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 04:58:47 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DAEC841207;
        Thu, 18 Mar 2021 08:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1616057924; x=
        1617872325; bh=Ark6wA2FA35KNvDzpfm0UvI1cDCCNXs05DHauoMogoc=; b=o
        GYxzSATpvAeAPq4EUODiG7cgjzRb8OWkbh63nD0tn1jLqtB2RISR7kz5alzqxuh8
        LJSTyi/vR22yIwcfp1xO4bU+U1eSMekVdFTWeq8QW2CSZ8vbp/axLWpbmO1iPTRU
        73lLkpGJ4paPDMjIpQGT91k9T+nXfI1Abf0exnieEk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K1kvFnn9K5zo; Thu, 18 Mar 2021 11:58:44 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id B9D86411FB;
        Thu, 18 Mar 2021 11:58:43 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 18 Mar 2021 11:58:43 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Thu, 18 Mar 2021 11:58:43 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>
Subject: RE: [PATCH 0/4] target: make tpg/enable attribute
Thread-Topic: [PATCH 0/4] target: make tpg/enable attribute
Thread-Index: AQHXGxrIW3vuprwTb0igO+tWtrRpzqqILbgAgAEyTKA=
Date:   Thu, 18 Mar 2021 08:58:43 +0000
Message-ID: <2b099689cee84bd4b27509425c8139b4@yadro.com>
References: <20210317104609.25236-1-d.bogdanov@yadro.com>
 <03cdc625-98de-7c41-d8cf-74143b2b7446@oracle.com>
In-Reply-To: <03cdc625-98de-7c41-d8cf-74143b2b7446@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.171]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KVGhhbmsgeW91IGZvciBxdWljayByZXNwb25zZS4NCg0KSSBnb3QgbXkgbWlz
dGFrZXMuDQpXaWxsIHRyeSB0byBjb21lIHVwIHdpdGggYSBuZXcgc29sdXRpb24uDQoNCkJSLA0K
IERtaXRyeQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogTWlrZSBDaHJpc3Rp
ZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPiANClNlbnQ6IFdlZG5lc2RheSwgTWFyY2gg
MTcsIDIwMjEgNzozMiBQTQ0KVG86IERtaXRyaXkgQm9nZGFub3YgPGQuYm9nZGFub3ZAeWFkcm8u
Y29tPjsgTWFydGluIFBldGVyc2VuIDxtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbT47IHRhcmdl
dC1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZzsg
bGludXhAeWFkcm8uY29tOyBOaWxlc2ggSmF2YWxpIDxuamF2YWxpQG1hcnZlbGwuY29tPjsgQ2hy
aXMgQm9vdCA8Ym9vdGNAYm9vdGMubmV0Pg0KU3ViamVjdDogUmU6IFtQQVRDSCAwLzRdIHRhcmdl
dDogbWFrZSB0cGcvZW5hYmxlIGF0dHJpYnV0ZQ0KDQpPbiAzLzE3LzIxIDU6NDYgQU0sIERtaXRy
eSBCb2dkYW5vdiB3cm90ZToNCj4gQWxsIHRhcmdldCB0cmFuc3BvcnQgZHJpdmVycyBoYXZlIGl0
cyBvd24gJ3RwZy9lbmFibGUnIGF0dHJpYnV0ZSANCj4gaW1wbGVtZW50YXRpb24uIFRoaXMgcHJv
ZHVjZXMgdW5uZWNlc3NhcnkgY29kZSBkdXBsaWNhdGlvbg0KSSBkb24ndCB0aGluayB0aGF0IGlz
IGNvcnJlY3QuIFNvbWUgZHJpdmVycyBkb24ndCBoYXZlIGVuIGVuYWJsZSBhdHRyOg0KDQotIHZo
b3N0LXNjc2ksIHhlbiBhbmQgbG9vcCBoYXZlIGEgbmV4dXMgYXR0ciB0aGF0IHNvcnQgb2YgbGVh
dmVzIGl0IGluIHRoZSBlcXVpdmFsZW50IG9mIGVuYWJsZWQuDQoNCi0gdXNiIGhhcyBhIG5leHVz
IGZpbGUgbGlrZSBhYm92ZSwgYnV0IGFmdGVyIHlvdSB3cml0ZSB0byBpdCB5b3Ugc3RpbGwgaGF2
ZSB0byB3cml0ZSB0byB0aGUgZW5hYmxlIGF0dHIuDQoNCi0gdGNtX2ZjIGRvZXMgbm90IGhhdmUg
YW4gZW5hYmxlIGFuZCBoYXMgaXQncyBvd24gaW5pdGlhbGl6YXRpb24gc3RyYXRlZ3kuDQoNCkZv
ciBkcml2ZXJzIHRoYXQgaGF2ZSBhbiBlbmFibGUgZmlsZSB5b3VyIHBhdGNoZXMgbWlzc2VkIHVz
Yiwgc3JwdCBhbmQgaWJtX3ZzY3NpLg0KDQo+IEFsc28gaXQgbWFrZXMgZGlmZmljdWx0IHRvIGNv
bnRyb2wgdGhhdCBhdHRyaWJ1dGUgYW5kIHRvIGRlcGVuZCBvbiANCj4gdGhhdCBhdHRyaWJ1dGUg
aW5zaWRlIG9mIHRhcmdldCBjb3JlIG1vZHVsZS4NCg0KSSBhZ3JlZSB3aXRoIHRoaXMgOikgSXQn
cyBhIGJpdCBvZiBtZXNzLCBidXQgSSB0aGluayBpdCdzIHNvbWV0aW1lcyBkdWUgdG8gaG93IHRo
ZSBkcml2ZXIgaXMgaW1wbGVtZW50ZWQgYW5kIGhvdyB1c2Vyc3BhY2UgaGFzIHRvIHNldCBpdCB1
cCwgc28gaXQncyBub3QgYXMgc2ltcGxlIGFzIGluIHRoaXMgcGF0Y2hzZXQgZHVlIHRvIGhhdmlu
ZyB0byBzdXBwb3J0IGV4aXN0aW5nIHRvb2xzLg0K
