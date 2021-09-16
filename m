Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF38C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 08:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A3E6120F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 08:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbhIPIcC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 04:32:02 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36260 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234108AbhIPIcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 04:32:01 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 61F5143286;
        Thu, 16 Sep 2021 08:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1631781039; x=
        1633595440; bh=U/W/lxkVcURClJ7/RNHMOFrT6ee/N9Mf757IGby8dj8=; b=Q
        2mO5wR5oz94XTozGD8WexZH/9yYiBu4BxPeE23qo5TheqFnhjIgB8Jx9rrqV0SLI
        ce4+W0h8QCzjkxTolaZv47eHZQJNsKxjOuYezExvcSGfQ4v3YEiS6a4HO0ULQ28M
        fzVm+mBDz6EdXKqbsk/xWdd/8/imVR0FUFCcw8g+0w=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CMyo-e0BuOdY; Thu, 16 Sep 2021 11:30:39 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A1FD443260;
        Thu, 16 Sep 2021 11:30:37 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 16 Sep 2021 11:30:37 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Thu, 16 Sep 2021 11:30:37 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        "Michael Cyr" <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: RE: [PATCH v5 1/7] target: core: add common tpg/enable attribute
Thread-Topic: [PATCH v5 1/7] target: core: add common tpg/enable attribute
Thread-Index: AQHXph+uFV1ckypL8kW754fuF8HqqqulOHmAgAEZuYA=
Date:   Thu, 16 Sep 2021 08:30:36 +0000
Message-ID: <d2e4ac2cd0e143aa82be090c89fb3945@yadro.com>
References: <20210910084133.17956-1-d.bogdanov@yadro.com>
 <20210910084133.17956-2-d.bogdanov@yadro.com>
 <39eadb0e-6f25-6a72-e69d-64d55328f6f7@gmail.com>
In-Reply-To: <39eadb0e-6f25-6a72-e69d-64d55328f6f7@gmail.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.146]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQm9kbywNCg0KPiA+ICsJaWYgKHNlX3RwZy0+ZW5hYmxlZCA9PSBvcCkNCj4gPiArCQlyZXR1
cm4gY291bnQ7DQoNCj4gU29ycnkgZm9yIGp1bXBpbmcgaW4gbGF0ZWx5Lg0KDQo+IEp1c3Qgb25l
IG5pdDoNCj4gSW4gY2FzZSBzb21lb25lIHRyaWVzIHRvIGVuYWJsZSBvciBkaXNhYmxlIHRoZSBz
YW1lIHRwZyBhIHNlY29uZCB0aW1lLCB3aXRoDQo+IHRoZSBjaGFuZ2Ugd2UgYWx3YXlzIGRvIG5v
dGhpbmcgYW5kIHJldHVybiBjb3VudCAoLS0+IE9LKS4NCj4NCj4gSSBqdXN0IGNoZWNrZWQgaXNj
c2kgYW5kIHFsYTJ4eHguIEFGQUlDUyBpc2NzaSBiZWZvcmUgdGhlIHBhdGNoIHJlamVjdGVkIHRo
ZQ0KPiBzZWNvbmQgZW5hYmxlIG9yIGRpc2FibGUgd2l0aCAtRUlOVkFMLCB3aGlsZSBxbGEyeHh4
IGFjY2VwdHMgdGhlIHNlY29uZA0KPiBkaXNhYmxlIGFuZCByZWplY3RzIHRoZSBzZWNvbmQgZW5h
YmxlIHdpdGggLUVFWElTVC4NCj4NCj4gT2YgY291cnNlIGl0IHNvdW5kcyBnb29kIHRvIHVuaWZ5
IHRoZSBiZWhhdmlvciBvZiBleGlzdGluZyBlbmFibGUNCj4gYXR0cmlidXRlcy4gT1RPSDogZXZl
biBpZiBlbmFibGluZy9kaXNhYmxpbmcgdGhlIHNhbWUgdHBnIHR3aWNlIGNhbiBiZSBzZWVuDQo+
IGFzIHN1c3BpY2lvdXMgYmVoYXZpb3IsIGFyZSB3ZSBzdXJlIHRvIG5vdCBjb25mdXNlIGV4aXN0
aW5nIHVzZXIgc3BhY2UgdG9vbHMNCj4gYnkgY2hhbmdpbmcgdGhlIHJlc3VsdD8NCg0KdGFyZ2V0
Y2xpIHRvb2wgZG9lcyBub3QgY2hlY2sgdGhlIHJlc3VsdCBvZiBkaXNhYmxlL2VuYWJsZSBhdCBh
bGwuDQpPdXIgcHJvcHJpZXRhcnkgYXBwbGljYXRpb24gY2hlY2tzIGEgcmVzdWx0IGJ1dCBkb2Vz
IG5vdCBjaGVjayB0aGUgcGFydGljdWxhcg0KcmV0dXJuIGNvZGUsIGFuZCB0aGUgYXBwbGljYXRp
b24gZG9lcyBub3QgZXhwZWN0IHRoZSBmYWlsdXJlIG9mIHRoZSBzYW1lIHNlY29uZA0KcmVxdWVz
dC4NCg0KSXQncyBoYXJkbHkgdG8gaW1hZ2luZSB3aHkgc29tZW9uZSBzaG91bGQgZXhwZWN0IHRo
ZSBzZWNvbmQgZW5hYmxlIGFuZCBlc3BlY2lhbGx5DQp0aGUgc2Vjb25kIGRpc2FibGUgdG8gZmFp
bCAtIHRoZSByZXF1ZXN0ZWQgb3BlcmF0aW9uKGRpc2FibGUgb3IgZW5hYmxlKSBpcyBzdWNjZXNz
ZnVsbHkNCmRvbmUgZm9yIHRoZSBjYWxsZXIuDQoNCkJSLA0KIERtaXRyeQ0K
