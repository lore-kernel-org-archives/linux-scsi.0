Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C565C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527E560EE5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 11:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhJRLvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 07:51:18 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:37064 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231570AbhJRLvN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 07:51:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 11870411FB;
        Mon, 18 Oct 2021 11:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1634557737; x=
        1636372138; bh=lxZqy3/6n5Hr7rHa30PuIVLMdjOYNRXsXm2Y3Ez4BiU=; b=m
        CEXgLlisq8qYzcPSoh5t1k2e43Rczs1ww3PpySXmmUW9F445Uve2YU+1TcY+Ol3Y
        pStwW6BbXfuOrhJreE/Ba/spF77XUkVkF0uqScTCtGFFh2DVkfMZX9QX/FysCAwM
        dMYgCG2rMIaFhfZHKeVKWydj4vxoUICNW7r/PJDkgQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WWG07SQfMDiT; Mon, 18 Oct 2021 14:48:57 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id CF1D1404CF;
        Mon, 18 Oct 2021 14:48:57 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Oct 2021 14:48:57 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Mon, 18 Oct 2021 14:48:57 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: RE: [PATCH 3/3] target: iscsi: control authentication per ACL
Thread-Topic: [PATCH 3/3] target: iscsi: control authentication per ACL
Thread-Index: AQHXqU/Pfb0jjhKJh0CWot0YJKeYQqu808MAgAXAwGCAAevWAIAUV0Zg
Date:   Mon, 18 Oct 2021 11:48:57 +0000
Message-ID: <a41e01efa205400e8dc73274d75e506d@yadro.com>
References: <20210914100314.492-1-d.bogdanov@yadro.com>
 <20210914100314.492-4-d.bogdanov@yadro.com>
 <2f65a5a4-6296-cd72-b143-1053665fd4b3@oracle.com>
 <380d7926b0b6401fbf6c8e3dac4eb9b3@yadro.com>
 <27949fe2-ef29-adc7-ab77-bed4f14cd783@oracle.com>
In-Reply-To: <27949fe2-ef29-adc7-ab77-bed4f14cd783@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.10.157]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPj4+PiBBZGQgYWNscy97QUNMfS9hdHRyaWIvYXV0aGVudGljYXRpb24gYXR0
cmlidXRlIHRoYXQgY29udHJvbHMgYXV0aGVudGljYXRpb24NCj4+Pj4gZm9yIHRoZSBwYXJ0aWN1
bGFyIEFDTC4gQnkgZGVmYXVsdCwgdGhpcyBhdHRyaWJ1dGUgaW5oZXJpdHMgYSB2YWx1ZSBvZg0K
Pj4+PiBhdXRoZW50aWNhdGlvbiBhdHRyaWJ1dGUgb2YgdGhlIHRhcmdldCBwb3J0IGdyb3VwIHRv
IGtlZXAgYmFja3dhcmQNCj4+Pj4gY29tcGF0aWJpbGl0eS4NCj4+Pj4NCj4+Pj4gYXV0aGVudGlj
YXRpb24gYXR0cmlidXRlIGhhcyAzIHN0YXRlczoNCj4+Pj4gICIwIiAtIGF1dGhlbnRpY2F0aW9u
IGlzIHR1cm5lZCBvZmYgZm9yIHRoaXMgQUNMDQo+Pj4+ICAiMSIgLSBhdXRoZW50aWNhdGlvbiBp
cyByZXF1aXJlZCBmb3IgdGhpcyBBQ0wNCj4+Pj4gICIiIC0gYXV0aGVudGljYXRpb24gaXMgaW5o
ZXJpdGVkIGZyb20gVFBHDQo+Pj4NCj4+Pg0KPj4+IFdoeSB0aGUgZW1wdHkgc3RyaW5nIGZvciB0
aGlzIHZhbHVlPyBNYXliZSAyIG9yIC0xPw0KPj4gVGhhdCB3YXMgZGVzaWduIGRlY2lzaW9uIGJ5
IGxvZ2ljIHRoYXQgc2luY2UgdGhhdCBhdHRyaWJ1dGUgaGFzIGEgcHJlY2VkZW5jZSANCj4+IHRv
IGNsZWFyIHRoYXQgcHJlY2VkZW5jZSB3ZSBtdXN0IGNsZWFyIHRoZSBhdHRyaWJ1dGUsIGkuZS4g
c2V0IHRvIHRoZSBlbXB0eSB2YWx1ZS4NCj4+IA0KPj4+Pg0KPj4+PiBSZXZpZXdlZC1ieTogUm9t
YW4gQm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+DQo+Pj4+IFJldmlld2VkLWJ5OiBL
b25zdGFudGluIFNoZWxla2hpbiA8ay5zaGVsZWtoaW5AeWFkcm8uY29tPg0KPj4+PiBTaWduZWQt
b2ZmLWJ5OiBEbWl0cnkgQm9nZGFub3YgPGQuYm9nZGFub3ZAeWFkcm8uY29tPg0KPj4+PiAtLS0N
Cj4+Pj4gIGRyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9jb25maWdmcy5jICB8IDQx
ICsrKysrKysrKysrKysrKysrKysNCj4+Pj4gIGRyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3Rh
cmdldF9uZWdvLmMgICAgICB8ICA4ICsrKy0NCj4+Pj4gIC4uLi90YXJnZXQvaXNjc2kvaXNjc2lf
dGFyZ2V0X25vZGVhdHRyaWIuYyAgICB8ICAxICsNCj4+Pj4gIGluY2x1ZGUvdGFyZ2V0L2lzY3Np
L2lzY3NpX3RhcmdldF9jb3JlLmggICAgICB8ICAyICsNCj4+Pj4gIDQgZmlsZXMgY2hhbmdlZCwg
NTEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2NvbmZpZ2ZzLmMgYi9kcml2ZXJzL3Rh
cmdldC9pc2NzaS9pc2NzaV90YXJnZXRfY29uZmlnZnMuYw0KPj4+PiBpbmRleCBlMzc1MGI2NGNj
MGMuLjJkNzBkZTM0MjQwOCAxMDA2NDQNCj4+Pj4gLS0tIGEvZHJpdmVycy90YXJnZXQvaXNjc2kv
aXNjc2lfdGFyZ2V0X2NvbmZpZ2ZzLmMNCj4+Pj4gKysrIGIvZHJpdmVycy90YXJnZXQvaXNjc2kv
aXNjc2lfdGFyZ2V0X2NvbmZpZ2ZzLmMNCj4+Pj4gQEAgLTMxNCw2ICszMTQsNDYgQEAgSVNDU0lf
TkFDTF9BVFRSKHJhbmRvbV9kYXRhaW5fcGR1X29mZnNldHMpOw0KPj4+PiAgSVNDU0lfTkFDTF9B
VFRSKHJhbmRvbV9kYXRhaW5fc2VxX29mZnNldHMpOw0KPj4+PiAgSVNDU0lfTkFDTF9BVFRSKHJh
bmRvbV9yMnRfb2Zmc2V0cyk7DQo+Pj4+ICANCj4+Pj4gK3N0YXRpYyBzc2l6ZV90IGlzY3NpX25h
Y2xfYXR0cmliX2F1dGhlbnRpY2F0aW9uX3Nob3coc3RydWN0IGNvbmZpZ19pdGVtICppdGVtLA0K
Pj4+PiArCQljaGFyICpwYWdlKQ0KPj4+PiArew0KPj4+PiArCXN0cnVjdCBzZV9ub2RlX2FjbCAq
c2VfbmFjbCA9IGF0dHJpYl90b19uYWNsKGl0ZW0pOw0KPj4+PiArCXN0cnVjdCBpc2NzaV9ub2Rl
X2FjbCAqbmFjbCA9IHRvX2lzY3NpX25hY2woc2VfbmFjbCk7DQo+Pj4+ICsNCj4+Pj4gKwlpZiAo
bmFjbC0+bm9kZV9hdHRyaWIuYXV0aGVudGljYXRpb24gPT0gTkFfQVVUSEVOVElDQVRJT05fSU5I
RVJJVEVEKSB7DQo+Pj4+ICsJCXN0cnVjdCBpc2NzaV9wb3J0YWxfZ3JvdXAgKnRwZyA9IHRvX2lz
Y3NpX3RwZyhzZV9uYWNsLT5zZV90cGcpOw0KPj4+PiArDQo+Pj4+ICsJCXJldHVybiBzcHJpbnRm
KHBhZ2UsICIldSAoaW5oZXJpdGVkKVxuIiwNCj4+Pj4gKwkJCQl0cGctPnRwZ19hdHRyaWIuYXV0
aGVudGljYXRpb24pOw0KPj4+DQo+Pj4NCj4+PiBJIHRoaW5rIHdlIHdhbnQgYSB2YWx1ZSBvZiAt
MSBvciAyIGZvciBpbmhlcml0ZWQgdGhlbiBoZXJlIGl0IHNob3VsZCBwcmludA0KPj4+IHRoYXQg
dmFsdWUuDQo+PiANCj4+IFdlIGRlY2lkZWQgdG8gaGlkZSB0aGUgaW50ZXJuYWwgdmFsdWUgZnJv
bSB1c2Vyc3BhY2UgYW5kIHJlcHJlc2VudCBpdCBzaW1pbGFyIHRvDQo+PiB0cGcuYXV0aGVudGlj
YXRpb24gdG8gaGF2ZSB0aGUgc2FtZSBoYW5kbGluZyB0aGVyZS4NCj4NCj4gSSdtIG5vdCBzdXJl
IHdoYXQgeW91IG1lYW50IGJ5IHJlcHJlc2VudGluZyBpdCBzaW1pbGFyIHRvIHRwZy5hdXRoZW50
aWNhdGlvbi4gVGhhdA0KPiBhdHRyaWIsIGFuZCBJIHRoaW5rIGV2ZXJ5IGF0dHJpYiwgcHJpbnRz
IDEgdmFsdWUuDQo+DQo+IFRoZSBwcm9ibGVtIHdpdGggYWJvdmUgaXMgdGhhdCB0aGlzIHdvcmtz
IGJ5IGFjY2lkZW50IGZvciBydHNsaWIgYmFzZWQgYXBwcyB3aGljaA0KPiByZWFkIGluIHRoZSBh
dHRyaWJzLCBzdG9yZXMgdGhlbSwgdGhlbiBvbiByZXN0b3JlIHdyaXRlcyB0aGVtIHRvIHRoZSBr
ZXJuZWwuIE9uIHRoZQ0KPiByZWFkL3NhdmUgc3RhZ2Ugd2UgZ2V0ICIwIChpbmhlcml0ZWQpIi4g
VGhlbiBvbiB0aGUgcmVzdG9yZSBzdGFnZSB3ZSB0cnkgdG8gd3JpdGUNCj4gdGhhdCBiYWNrIHRv
IHRoZSBrZXJuZWwgYW5kIGdldCBhbiBlcnJvci4gcnRzbGliL3RhcmdldGNsaSBqdXN0IHNwaXRz
IG91dCBhbiBlcnJvcg0KPiBhbmQgaWdub3JlcyBpdCwgc28gaXQgc3RpbGwgd29ya3Mgc2luY2Ug
dGhlIGtlcm5lbCB1c2VkIHRoZSBkZWZhdWx0LiBXZSBkb24ndA0KPiByZWFsbHkgd2FudCB0aGUg
ZXJyb3Igc3BpdCBvdXQgYW5kIEkgZG9uJ3QgdGhpbmsgd2Ugd2FudCBpdCB0byB3b3JrIGJ5IGFj
Y2lkZW50IGxpa2UNCj4gdGhpcy4NCg0KSSBtaXNzZWQgdGhhdCBmYWN0IHRoYXQgcnRzbGliIHNh
dmVzL3Jlc3RvcmVzIGFsbCBhdHRyaWJ1dGVzLiBZb3UgYXJlIHJpZ2h0IHRoZW4sIEkgbmVlZCB0
bw0KcmVwb3J0IHNvbWUgZWZmZWN0aXZlIHZhbHVlIChJIHRoaW5rICctMScpLiBXaWxsIHNlbmQg
bmV3IHBhdGNoc2V0IHNvb24uDQoNCkJSLA0KIERtaXRyeQ0K
