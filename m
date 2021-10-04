Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4E8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 07:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9FA361354
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 07:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhJDHmx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 03:42:53 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:52958 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230004AbhJDHmx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 03:42:53 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1EB0A42452;
        Mon,  4 Oct 2021 07:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1633333262; x=
        1635147663; bh=nCsuyxlriHS9PsswB8/Cqc5m4yr3FEKhcnCMGbGpsgE=; b=O
        iXp6ZpzohJXEJyN28ElOLqR64xrg5+DyJH8+YdaG9US30mMIn5DTqiO9/gYEBLyl
        YHcCiqLDbY1+tZJtUWaYKmsyWXbqCpdT3GWzZUxL962c4RmU9ANYglFbqu0Frgla
        dbcmDd58fulpxzHS10NyIJHJoFtrZ7sQsonK8UWxEQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j3-rREa5ienx; Mon,  4 Oct 2021 10:41:02 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1A4324174D;
        Mon,  4 Oct 2021 10:41:02 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (172.17.100.104) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 4 Oct 2021 10:41:01 +0300
Received: from T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df]) by
 T-EXCH-04.corp.yadro.com ([fe80::d8c5:6f0a:3d48:18df%15]) with mapi id
 15.01.0669.032; Mon, 4 Oct 2021 10:41:01 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: RE: [PATCH 2/3] scsi: target: iscsi: extract auth functions
Thread-Topic: [PATCH 2/3] scsi: target: iscsi: extract auth functions
Thread-Index: AQHXqU/Nwg0ihBoRGEqPr+4XkS7wEKu80guAgAWQlsA=
Date:   Mon, 4 Oct 2021 07:41:01 +0000
Message-ID: <31e1f968b10047bba06e36ff97f16744@yadro.com>
References: <20210914100314.492-1-d.bogdanov@yadro.com>
 <20210914100314.492-3-d.bogdanov@yadro.com>
 <c55719fa-9150-b64e-306f-b8b31a405be4@oracle.com>
In-Reply-To: <c55719fa-9150-b64e-306f-b8b31a405be4@oracle.com>
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

SGkgTWlrZSwNCg0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3Qgc2Vfbm9kZV9hY2wgKnNlX25hY2w7DQo+
ID4gKw0KPiA+ICsJaWYgKGNvbm4tPnNlc3MtPnNlc3Nfb3BzLT5TZXNzaW9uVHlwZSkgew0KPiA+
ICsJCS8qDQo+ID4gKwkJICogRm9yIFNlc3Npb25UeXBlPURpc2NvdmVyeQ0KPiA+ICsJCSAqLw0K
PiA+ICsJCXJldHVybiBjb25uLT50cGctPnRwZ19hdHRyaWIuYXV0aGVudGljYXRpb247DQo+ID4g
Kwl9DQo+ID4gKwkvKg0KPiA+ICsJICogRm9yIFNlc3Npb25UeXBlPU5vcm1hbA0KPiA+ICsJICov
DQo+ID4gKwlzZV9uYWNsID0gY29ubi0+c2Vzcy0+c2Vfc2Vzcy0+c2Vfbm9kZV9hY2w7DQo+ID4g
KwlpZiAoIXNlX25hY2wpIHsNCj4gPiArCQlwcl9kZWJ1ZygiVW5rbm93biBBQ0wgJXMgaXMgdHJ5
aW5nIHRvIGNvbm5lY3RcbiIsDQo+ID4gKwkJCSBzZV9uYWNsLT5pbml0aWF0b3JuYW1lKTsNCj4g
PiArCQlyZXR1cm4gdHJ1ZTsNCj4NCj4gQmVmb3JlIHRoZSBwYXRjaCwgaWYgd2UgZGlkbid0IGhh
dmUgYW4gQUNMIHdlIHdvdWxkIGdvIGJ5DQo+IGNvbm4tPnRwZy0+dHBnX2F0dHJpYi5hdXRoZW50
aWNhdGlvbi4gQnV0IHdpdGggdGhlIHBhdGNoLCBpZg0KPiB3ZSBkb24ndCBoYXZlIGFuIEFDTCwg
dGhlbiBpdCBsb29rcyBsaWtlIHdlIGFsd2F5cyByZXF1aXJlIGF1dGhlbnRpY2F0aW9uDQo+IHdo
aWNoIEkgZG9uJ3QgdGhpbmsgaXMgcmlnaHQuDQo+DQo+IElzIHRoZSBjb2RlIGFib3ZlIHN1cHBv
c2VkIHRvIHJldHVybiB0aGUgdmFsdWUgb2YgDQo+IGNvbm4tPnRwZy0+dHBnX2F0dHJpYi5hdXRo
ZW50aWNhdGlvbj8NCg0KTm8sIG5vLiBUaGlzIHBpZWNlIG9mIGNvZGUgaXMgdGhlIHNhbWUgYXMg
aXQgd2FzLg0KQW4gYWJzZW5jZSBvZiBBQ0wgaXMgc29tZSBlcnJvbmVvdXMgc2l0dWF0aW9uIGJl
Y2F1c2UgdGhlIGxvZ2luIG11c3QgYmUNCnJlamVjdGVkIGVhcmxpZXIgaW4gX19pc2NzaV90YXJn
ZXRfbG9naW5fdGhyZWFkIC0+IGlzY3NpX3RhcmdldF9sb2NhdGVfcG9ydGFsDQoNCj4gPiArCX0N
Cj4gPiArDQo+ID4gKwlpZiAoc2VfbmFjbC0+ZHluYW1pY19ub2RlX2FjbCkgew0KPiA+ICsJCXBy
X2RlYnVnKCJEeW5hbWljIEFDTCAlcyBpcyB0cnlpbmcgdG8gY29ubmVjdFxuIiwNCj4gPiArCQkJ
IHNlX25hY2wtPmluaXRpYXRvcm5hbWUpOw0KPiA+ICsJCXJldHVybiBjb25uLT50cGctPnRwZ19h
dHRyaWIuYXV0aGVudGljYXRpb247DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJcHJfZGVidWcoIktu
b3duIEFDTCAlcyBpcyB0cnlpbmcgdG8gY29ubmVjdFxuIiwNCj4gPiArCQkgc2VfbmFjbC0+aW5p
dGlhdG9ybmFtZSk7DQo+ID4gKwlyZXR1cm4gY29ubi0+dHBnLT50cGdfYXR0cmliLmF1dGhlbnRp
Y2F0aW9uOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGlzY3NpX3RhcmdldF9oYW5k
bGVfY3NnX3plcm8oDQo+ID4gIAlzdHJ1Y3QgaXNjc2lfY29ubiAqY29ubiwNCj4gPiAgCXN0cnVj
dCBpc2NzaV9sb2dpbiAqbG9naW4pDQo+ID4gQEAgLTg3NCwyMiArOTAzLDI2IEBAIHN0YXRpYyBp
bnQgaXNjc2lfdGFyZ2V0X2hhbmRsZV9jc2dfemVybygNCj4gPiAgCQlyZXR1cm4gLTE7DQo+ID4g
IA0KPiA+ICAJaWYgKCFpc2NzaV9jaGVja19uZWdvdGlhdGVkX2tleXMoY29ubi0+cGFyYW1fbGlz
dCkpIHsNCj4gPiAtCQlpZiAoY29ubi0+dHBnLT50cGdfYXR0cmliLmF1dGhlbnRpY2F0aW9uICYm
DQo+ID4gLQkJICAgICFzdHJuY21wKHBhcmFtLT52YWx1ZSwgTk9ORSwgNCkpIHsNCj4gPiAtCQkJ
cHJfZXJyKCJJbml0aWF0b3Igc2VudCBBdXRoTWV0aG9kPU5vbmUgYnV0Ig0KPiA+IC0JCQkJIiBU
YXJnZXQgaXMgZW5mb3JjaW5nIGlTQ1NJIEF1dGhlbnRpY2F0aW9uLCINCj4gPiAtCQkJCQkiIGxv
Z2luIGZhaWxlZC5cbiIpOw0KPiA+IC0JCQlpc2NzaXRfdHhfbG9naW5fcnNwKGNvbm4sIElTQ1NJ
X1NUQVRVU19DTFNfSU5JVElBVE9SX0VSUiwNCj4gPiAtCQkJCQlJU0NTSV9MT0dJTl9TVEFUVVNf
QVVUSF9GQUlMRUQpOw0KPiA+IC0JCQlyZXR1cm4gLTE7DQo+ID4gLQkJfQ0KPiA+ICsJCWJvb2wg
YXV0aF9yZXF1aXJlZCA9IGlzY3NpX2Nvbm5fYXV0aF9yZXF1aXJlZChjb25uKTsNCj4gPiArDQo+
DQo+IEluIF9faXNjc2lfdGFyZ2V0X2xvZ2luX3RocmVhZCB3ZSBoYXZlOg0KPg0KPiAgICAgICAg
IGlmIChjb25uLT5zZXNzKQ0KPiAgICAgICAgICAgICAgICAgY29ubi0+c2Vzcy0+c2Vfc2Vzcy0+
c3VwX3Byb3Rfb3BzID0NCj4gICAgICAgICAgICAgICAgICAgICAgICAgY29ubi0+Y29ubl90cmFu
c3BvcnQtPmlzY3NpdF9nZXRfc3VwX3Byb3Rfb3BzKGNvbm4pOw0KPg0KPiBiZWZvcmUgd2UgY2Fs
bDoNCj4NCj4gaXNjc2lfdGFyZ2V0X3N0YXJ0X25lZ290aWF0aW9uIC0+IGlzY3NpX3RhcmdldF9k
b19sb2dpbi0gPiBpc2NzaV90YXJnZXRfaGFuZGxlX2NzZ196ZXJvDQo+IGFuZCBoaXQgdGhlIGNv
ZGUgYWJvdmUuDQo+DQo+IElmIGNvbm4tPnNlc3MgY2FuIGJlIE5VTEwgdGhlbiBpc2NzaV9jb25u
X2F1dGhfcmVxdWlyZWQgd2lsbCBjcmFzaC4NCj4NCj4gSG93ZXZlciwgSSBjYW4ndCB0ZWxsIGhv
dyBjb25uLT5zZXNzIGNhbiBiZSBOVUxMIGluIHRoYXQgY29kZSBwYXRoLiBJcyB0aGUgY29ubi0+
c2Vzcw0KPiBjaGVjayBpbiBfX2lzY3NpX3RhcmdldF9sb2dpbl90aHJlYWQgbm90IG5lZWRlZD8N
Cg0KY29ubi0+c2VzcyBpcyBzZXQgdG8gTlVMTCBpbiBpc2NzaV9sb2dpbl9ub25femVyb190c2lo
X3MxIGFuZCAgbmV3IHNlc3Npb24gaXMgY3JlYXRlZA0KaW4gaXNjc2lfbG9naW5fbm9uX3plcm9f
dHNpaF9zMiB3aGljaCBpcyBiZWZvcmUgaXNjc2lfdGFyZ2V0X3N0YXJ0X25lZ290aWF0aW9uLCBz
bw0Kd2UgYXJlIHNhZmUuDQoNCkJSLA0KIERtaXRyeQ0K
