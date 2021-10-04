Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073DAC433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 07:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F3261354
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 07:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhJDH6N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 03:58:13 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:54060 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229574AbhJDH6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 03:58:12 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9977643EA4;
        Mon,  4 Oct 2021 07:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1633334181; x=
        1635148582; bh=A2bJ+PgE3j8Ms0rTKjxH/Pn6zKjtiHRnYiE+Wrr1KRQ=; b=g
        OS4YotgHX1DKbhSNQNpzFMjPreoZGyYaNsrYoSI6TKSl24vJFTiZB8SRw0PE+6eo
        SwolOOPoHkVeQXg2my3Tz+lyJrjw5/t6KOJ/3TJMSLdhgjzSjJkDPrzUiOdClhoz
        QoObW6qruHeOnHYN48CLoQM1WHJQVW4x8w4uZBgCFU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FALbSYxImDuN; Mon,  4 Oct 2021 10:56:21 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 8AA3E43E62;
        Mon,  4 Oct 2021 10:56:21 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 4 Oct 2021 10:56:20 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Mon, 4 Oct 2021 10:56:20 +0300
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
Thread-Index: AQHXqU/Pfb0jjhKJh0CWot0YJKeYQqu808MAgAXAwGA=
Date:   Mon, 4 Oct 2021 07:56:20 +0000
Message-ID: <380d7926b0b6401fbf6c8e3dac4eb9b3@yadro.com>
References: <20210914100314.492-1-d.bogdanov@yadro.com>
 <20210914100314.492-4-d.bogdanov@yadro.com>
 <2f65a5a4-6296-cd72-b143-1053665fd4b3@oracle.com>
In-Reply-To: <2f65a5a4-6296-cd72-b143-1053665fd4b3@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.152]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPiA+IEFkZCBhY2xzL3tBQ0x9L2F0dHJpYi9hdXRoZW50aWNhdGlvbiBhdHRy
aWJ1dGUgdGhhdCBjb250cm9scyBhdXRoZW50aWNhdGlvbg0KPiA+IGZvciB0aGUgcGFydGljdWxh
ciBBQ0wuIEJ5IGRlZmF1bHQsIHRoaXMgYXR0cmlidXRlIGluaGVyaXRzIGEgdmFsdWUgb2YNCj4g
PiBhdXRoZW50aWNhdGlvbiBhdHRyaWJ1dGUgb2YgdGhlIHRhcmdldCBwb3J0IGdyb3VwIHRvIGtl
ZXAgYmFja3dhcmQNCj4gPiBjb21wYXRpYmlsaXR5Lg0KPiA+IA0KPiA+IGF1dGhlbnRpY2F0aW9u
IGF0dHJpYnV0ZSBoYXMgMyBzdGF0ZXM6DQo+ID4gICIwIiAtIGF1dGhlbnRpY2F0aW9uIGlzIHR1
cm5lZCBvZmYgZm9yIHRoaXMgQUNMDQo+ID4gICIxIiAtIGF1dGhlbnRpY2F0aW9uIGlzIHJlcXVp
cmVkIGZvciB0aGlzIEFDTA0KPiA+ICAiIiAtIGF1dGhlbnRpY2F0aW9uIGlzIGluaGVyaXRlZCBm
cm9tIFRQRw0KPg0KPg0KPiBXaHkgdGhlIGVtcHR5IHN0cmluZyBmb3IgdGhpcyB2YWx1ZT8gTWF5
YmUgMiBvciAtMT8NClRoYXQgd2FzIGRlc2lnbiBkZWNpc2lvbiBieSBsb2dpYyB0aGF0IHNpbmNl
IHRoYXQgYXR0cmlidXRlIGhhcyBhIHByZWNlZGVuY2UgDQp0byBjbGVhciB0aGF0IHByZWNlZGVu
Y2Ugd2UgbXVzdCBjbGVhciB0aGUgYXR0cmlidXRlLCBpLmUuIHNldCB0byB0aGUgZW1wdHkgdmFs
dWUuDQoNCj4gPiANCj4gPiBSZXZpZXdlZC1ieTogUm9tYW4gQm9sc2hha292IDxyLmJvbHNoYWtv
dkB5YWRyby5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEtvbnN0YW50aW4gU2hlbGVraGluIDxrLnNo
ZWxla2hpbkB5YWRyby5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogRG1pdHJ5IEJvZ2Rhbm92IDxk
LmJvZ2Rhbm92QHlhZHJvLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy90YXJnZXQvaXNjc2kv
aXNjc2lfdGFyZ2V0X2NvbmZpZ2ZzLmMgIHwgNDEgKysrKysrKysrKysrKysrKysrKw0KPiA+ICBk
cml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXRfbmVnby5jICAgICAgfCAgOCArKystDQo+
ID4gIC4uLi90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X25vZGVhdHRyaWIuYyAgICB8ICAxICsN
Cj4gPiAgaW5jbHVkZS90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2NvcmUuaCAgICAgIHwgIDIg
Kw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0
X2NvbmZpZ2ZzLmMgYi9kcml2ZXJzL3RhcmdldC9pc2NzaS9pc2NzaV90YXJnZXRfY29uZmlnZnMu
Yw0KPiA+IGluZGV4IGUzNzUwYjY0Y2MwYy4uMmQ3MGRlMzQyNDA4IDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvdGFyZ2V0L2lzY3NpL2lzY3NpX3RhcmdldF9jb25maWdmcy5jDQo+ID4gKysrIGIv
ZHJpdmVycy90YXJnZXQvaXNjc2kvaXNjc2lfdGFyZ2V0X2NvbmZpZ2ZzLmMNCj4gPiBAQCAtMzE0
LDYgKzMxNCw0NiBAQCBJU0NTSV9OQUNMX0FUVFIocmFuZG9tX2RhdGFpbl9wZHVfb2Zmc2V0cyk7
DQo+ID4gIElTQ1NJX05BQ0xfQVRUUihyYW5kb21fZGF0YWluX3NlcV9vZmZzZXRzKTsNCj4gPiAg
SVNDU0lfTkFDTF9BVFRSKHJhbmRvbV9yMnRfb2Zmc2V0cyk7DQo+ID4gIA0KPiA+ICtzdGF0aWMg
c3NpemVfdCBpc2NzaV9uYWNsX2F0dHJpYl9hdXRoZW50aWNhdGlvbl9zaG93KHN0cnVjdCBjb25m
aWdfaXRlbSAqaXRlbSwNCj4gPiArCQljaGFyICpwYWdlKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qg
c2Vfbm9kZV9hY2wgKnNlX25hY2wgPSBhdHRyaWJfdG9fbmFjbChpdGVtKTsNCj4gPiArCXN0cnVj
dCBpc2NzaV9ub2RlX2FjbCAqbmFjbCA9IHRvX2lzY3NpX25hY2woc2VfbmFjbCk7DQo+ID4gKw0K
PiA+ICsJaWYgKG5hY2wtPm5vZGVfYXR0cmliLmF1dGhlbnRpY2F0aW9uID09IE5BX0FVVEhFTlRJ
Q0FUSU9OX0lOSEVSSVRFRCkgew0KPiA+ICsJCXN0cnVjdCBpc2NzaV9wb3J0YWxfZ3JvdXAgKnRw
ZyA9IHRvX2lzY3NpX3RwZyhzZV9uYWNsLT5zZV90cGcpOw0KPiA+ICsNCj4gPiArCQlyZXR1cm4g
c3ByaW50ZihwYWdlLCAiJXUgKGluaGVyaXRlZClcbiIsDQo+ID4gKwkJCQl0cGctPnRwZ19hdHRy
aWIuYXV0aGVudGljYXRpb24pOw0KPg0KPg0KPiBJIHRoaW5rIHdlIHdhbnQgYSB2YWx1ZSBvZiAt
MSBvciAyIGZvciBpbmhlcml0ZWQgdGhlbiBoZXJlIGl0IHNob3VsZCBwcmludA0KPiB0aGF0IHZh
bHVlLg0KDQpXZSBkZWNpZGVkIHRvIGhpZGUgdGhlIGludGVybmFsIHZhbHVlIGZyb20gdXNlcnNw
YWNlIGFuZCByZXByZXNlbnQgaXQgc2ltaWxhciB0bw0KdHBnLmF1dGhlbnRpY2F0aW9uIHRvIGhh
dmUgdGhlIHNhbWUgaGFuZGxpbmcgdGhlcmUuDQoNCkJSLA0KIERtaXRyeQ0K
