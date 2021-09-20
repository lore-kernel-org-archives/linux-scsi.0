Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA95BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 16:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD0AB611AE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 16:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbhITQl6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:41:58 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:37712 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229561AbhITQl4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 12:41:56 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2FE8B43B9E;
        Mon, 20 Sep 2021 16:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1632156025; x=
        1633970426; bh=CzeHddJHd4BBW6z9xmJrYhZN3J1lLBkEq/6QQutr8D8=; b=s
        YWAg+GNMIfgi5hrzOyr3SvL31O9fchMBkMY56qhUYO/Dj7koIYVcnbLyoO3sC+Hz
        8lbVKbgj0P5JCTyRJ0x9K7hBVq2sT2HjeZtVYurxRqbuhvhjwqMed9yAmSX0yn1S
        0+yZAj2c7NGoYTYz1P5FoGa15mcnhEC4Ui5sIurNgQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZG54gQNe_Zdb; Mon, 20 Sep 2021 19:40:25 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 22EF643B9C;
        Mon, 20 Sep 2021 19:40:24 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 20 Sep 2021 19:40:24 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Mon, 20 Sep 2021 19:40:24 +0300
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
Thread-Index: AQHXqjxsRxjpgHbtYEm89uYUDNcxt6uoQ5KAgATA8DA=
Date:   Mon, 20 Sep 2021 16:40:23 +0000
Message-ID: <8f81906545014a768a7f775d1dcf51cf@yadro.com>
References: <20210915141719.1484-1-d.bogdanov@yadro.com>
 <40b321b4-76bd-8eb4-84bd-c7378ad2bbc7@oracle.com>
In-Reply-To: <40b321b4-76bd-8eb4-84bd-c7378ad2bbc7@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.111]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPiA+IEBAIC0yMzQsNiArMjI1LDcgQEAgc3RhdGljIHZvaWQgY29yZV90bXJf
ZHJhaW5fdG1yX2xpc3QoDQo+ID4gIAkJfQ0KPiA+ICANCj4gPiAgCQlsaXN0X21vdmVfdGFpbCgm
dG1yX3AtPnRtcl9saXN0LCAmZHJhaW5fdG1yX2xpc3QpOw0KPiA+ICsJCXRtcl9wLT50bXJfZGV2
ID0gTlVMTDsNCj4NCj4gSXMgdGhpcyBwYXRjaCBub3cgYWRkaW5nIGEgd2F5IHRvIGhpdDoNCj4N
Cj4gaWYgKCF0bXItPnRtcl9kZXYpDQo+CVdBUk5fT05fT05DRSh0cmFuc3BvcnRfbG9va3VwX3Rt
cl9sdW4odG1yLT50YXNrX2NtZCkgPCAwKTsgICAgICAgICAgICAgICAgICAgICAgDQo+DQo+IGlu
IGNvcmVfdG1yX2Fib3J0X3Rhc2s/DQo+DQo+IFlvdSBoYXZlIHRoZSBhYm9ydCBhbmQgbHVuIHJl
c2V0IHdvcmtzIHJ1bm5pbmcgb24gZGlmZmVyZW50IENQVXMuDQo+IFRoZSBsdW4gcmVzZXQgaGl0
cyB0aGUgYWJvdmUgY29kZSBmaXJzdCBhbmQgY2xlYXJzIHRtcl9kZXYuDQo+IFRoZSBhYm9ydCB0
aGVuIGhpdHMgdGhlIHRtci0+dG1yX2RldiBjaGVjayBhbmQgdHJpZXMgdG8gZG8NCj4gdHJhbnNw
b3J0X2xvb2t1cF90bXJfbHVuLg0KPg0KPiBGb3IgdGhlIGNhc2Ugd2hlcmUgdGhlIGx1biBpcyBu
b3QgcmVtb3ZlZCwgaXQgbG9va3MgbGlrZQ0KPiB0cmFuc3BvcnRfbG9va3VwX3Rtcl9sdW4gd2ls
bCBhZGQgdGhlIHRtciB0byB0aGUgZGV2X3Rtcl9saXN0DQo+IGJ1dCBpdCB3b3VsZCBhbHNvIGJl
IG9uIHRoZSBkcmFpbl90bXJfbGlzdCBhYm92ZSBzbyB3ZSB3b3VsZA0KPiBoaXQgbGlzdCBjb3Jy
dXB0aW9uLg0KDQpZZXMsIHRoZXJlIGlzIGEgc3VjaCByYWNlLiBJIHRoaW5rLCAgSSBjYW4gc29s
dmUgaXQgYnkgY2hhbmdpbmcgdGhlIG9yZGVyIG9mDQpkcmFpbmluZyB0aGUgdG1yX2xpc3QgYW5k
IHN0YXRlX2xpc3QgYXQgTFVOIFJlc2V0IHRvIG1ha2UgdGhlIHJhY2VkIGxpbmVzIA0KYmUgdW5k
ZXIgdGhlIHNhbWUgbG9jay4NCg0KRXNwZWNpYWxseSBTQU0tNSBkZXNjcmliZXMoYnV0IGRvZXMg
bm90IHJlcXVpcmUpIGFib3J0aW5nIGNvbW1hbmRzDQpiZWZvcmUgdG1mczoNCnwgV2hlbiByZXNw
b25kaW5nIHRvIGEgbG9naWNhbCB1bml0IHJlc2V0IGNvbmRpdGlvbiwgdGhlIGxvZ2ljYWwgdW5p
dCBzaGFsbDoNCnwJYSkgYWJvcnQgYWxsIGNvbW1hbmRzIGFzIGRlc2NyaWJlZCBpbiA1LjY7DQp8
CWIpIGFib3J0IGFsbCBjb3B5IG9wZXJhdGlvbnMgKHNlZSBTUEMtNCk7DQp8CWMpIHRlcm1pbmF0
ZSBhbGwgdGFzayBtYW5hZ2VtZW50IGZ1bmN0aW9uczsNCg0KDQo+IEZvciB0aGUgY2FzZSB3aGVy
ZSB0aGUgbHVuIGlzIGdldHRpbmcgcmVtb3ZlZCwgcGVyY3B1X3JlZl90cnlnZXRfbGl2ZQ0KPiB3
b3VsZCBmYWlsIGluIHRyYW5zcG9ydF9sb29rdXBfdG1yX2x1biBhbmQgd2UgaGl0IHRoZSBXQVJO
X09OX09OQ0UuDQo+IEkgdGhpbmsgdGhvdWdoIHdpdGggeW91ciBwYXRjaCwgd2Ugd291bGQgYmUg
b2sgYW5kIGRvbid0IHdhbnQNCj4gdGhlIFdBUk5fT05fT05DRSwgcmlnaHQ/IFRoZSBsdW4gcmVz
ZXQgd291bGQganVzdCB3YWl0IGZvciB0aGUNCj4gYWJvcnQuIFdoZW4gaXQgY29tcGxldGVzIHRo
ZSBhYm9ydCBhbmQgcmVzZXQgY29tcGxldGUgYXMgZXhwZWN0ZWQuDQoNCkkgZG9u4oCZdCB1bmRl
cnN0YW5kIHRoZSBtZWFuaW5nIG9mIHRoYXQgdHJhbnNwb3J0X2xvb2t1cF90bXJfbHVuIHRoZXJl
Lg0KRXZlcnkgVE1GIEFib3J0IGhhcyBhbHJlYWR5IGV4ZWN1dGVkIHRyYW5zcG9ydF9sb29rdXBf
dG1yX2x1biBhdCB0aGUgdmVyeQ0KYmVnaW5uaW5nIG9mIGl0cyBoYW5kbGluZy4gDQpFbGltaW5h
dGluZyB0aGUgcmFjZSB3aWxsIGVsaW1pbmF0ZSB0aGUgaW1wYWN0IG9mIG15IHBhdGNoIG9uIHRo
aXMgY2FzZSB0b28uIA0KDQpCUiwNCiBEbWl0cnkNCg==
