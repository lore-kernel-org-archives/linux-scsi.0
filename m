Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FABC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 14:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbiFHOQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 10:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239694AbiFHOQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 10:16:49 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305482DABF
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 07:16:47 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2DB234249F;
        Wed,  8 Jun 2022 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received:received; s=mta-01; t=1654697804; x=
        1656512205; bh=RSlwQpEqCXhbZZ9ImsVUexNsLzWcERQTmbLCHIGg1/k=; b=L
        RxsVnkbus3PjFnnUVEX4VPdNtyeiplpWWJN0aXup9ljrbdCriooGzAK350oyiYf1
        A2uZu7U80kLpmgWdCGnmdy9rvTW93JxUX1LEIFPTbdo5yt13IlnkFxi2A1gablk4
        v9p7akcEL+v8yK8e8IYDjkMPyw7mGGx2/quHlq9GFg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yD-QAnHORcPL; Wed,  8 Jun 2022 17:16:44 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5038D424A1;
        Wed,  8 Jun 2022 17:16:42 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 8 Jun 2022 17:16:42 +0300
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 8 Jun 2022 17:16:41 +0300
Received: from T-EXCH-09.corp.yadro.com ([fe80::d9f:e165:8a50:d450]) by
 T-EXCH-09.corp.yadro.com ([fe80::d9f:e165:8a50:d450%4]) with mapi id
 15.02.0986.022; Wed, 8 Jun 2022 17:16:41 +0300
From:   Dmitriy Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
CC:     "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: RE: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Thread-Topic: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Thread-Index: AQHYenFLnkgrMqHdCEim3M4HDVs6OK1D5uuAgAAC6wCAAXQf4A==
Date:   Wed, 8 Jun 2022 14:16:41 +0000
Message-ID: <e5c2ab5b4de8428495efe85865980133@yadro.com>
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
 <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
 <6a58acb4-e29e-e8c7-d85c-fe474670dad7@oracle.com>
In-Reply-To: <6a58acb4-e29e-e8c7-d85c-fe474670dad7@oracle.com>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.18.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgTWlrZSwNCg0KPk9uIDYvNy8yMiAxMDo1NSBBTSwgTWlrZSBDaHJpc3RpZSB3cm90ZToNCj4+
IE9uIDYvNy8yMiA4OjE5IEFNLCBEbWl0cnkgQm9nZGFub3Ygd3JvdGU6DQo+Pj4gSW4gZnVuY3Rp
b24gaXNjc2lfZGF0YV94bWl0IChUWCB3b3JrZXIpIHRoZXJlIGlzIHdhbGtpbmcgdGhyb3VnaCB0
aGUNCj4+PiBxdWV1ZSBvZiBuZXcgU0NTSSBjb21tYW5kcyB0aGF0IGlzIHJlcGxlbmlzaGVkIGlu
IHBhcmFsbGVsbC4gQW5kIG9ubHkNCj4+PiBhZnRlciB0aGF0IHF1ZXVlIGdvdCBlbXB0aWVkIHRo
ZSBmdW5jdGlvbiB3aWxsIHN0YXJ0IHNlbmRpbmcgcGVuZGluZw0KPj4+IERhdGFPdXQgUERVcy4g
VGhhdCBsZWFkIHRvIERhdGFPdXQgdGltZXIgdGltZSBvdXQgb24gdGFyZ2V0IHNpZGUgYW5kDQo+
Pj4gdG8gY29ubmVjdGlvbiByZWluc3RhdG1lbnQuDQo+Pj4NCj4+PiBUaGlzIHBhdGNoIHN3YXBz
IHdhbGtpbmcgdGhyb3VnaCB0aGUgbmV3IGNvbW1hbmRzIHF1ZXVlIGFuZCB0aGUgcGVuZGluZw0K
Pj4+IERhdGFPdXQgcXVldWUuIFRvIG1ha2UgYSBwcmVmZXJlbmNlIHRvIG9uZ29pbmcgY29tbWFu
ZHMgb3ZlciBuZXcgb25lcy4NCj4+Pg0KPj4NCj4+IC4uLg0KPj4NCj4+PiAgICAgICAgICAgICAg
dGFzayA9IGxpc3RfZW50cnkoY29ubi0+Y21kcXVldWUubmV4dCwgc3RydWN0IGlzY3NpX3Rhc2ss
DQo+Pj4gQEAgLTE1OTQsMjggKzE2MTYsMTAgQEAgc3RhdGljIGludCBpc2NzaV9kYXRhX3htaXQo
c3RydWN0IGlzY3NpX2Nvbm4gKmNvbm4pDQo+Pj4gICAgICAgICAgICAgICAqLw0KPj4+ICAgICAg
ICAgICAgICBpZiAoIWxpc3RfZW1wdHkoJmNvbm4tPm1nbXRxdWV1ZSkpDQo+Pj4gICAgICAgICAg
ICAgICAgICAgICAgZ290byBjaGVja19tZ210Ow0KPj4+ICsgICAgICAgICAgICBpZiAoIWxpc3Rf
ZW1wdHkoJmNvbm4tPnJlcXVldWUpKQ0KPj4+ICsgICAgICAgICAgICAgICAgICAgIGdvdG8gY2hl
Y2tfcmVxdWV1ZTsNCj4+DQo+Pg0KPj4NCj4+IEhleSwgSSd2ZSBiZWVuIHBvc3RpbmcgYSBzaW1p
bGFyIHBhdGNoOg0KPj4NCj4+IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LXNj
c2kvbXNnMTU2OTM5Lmh0bWwNCj4+DQo+PiBBIHByb2JsZW0gSSBoaXQgaXMgYSBwb3NzaWJsZSBw
cmVmIHJlZ3Jlc3Npb24gc28gSSB0cmllZCB0byBhbGxvdw0KPj4gdXMgdG8gc3RhcnQgdXAgYSBi
dXJzdCBvZiBjbWRzIGluIHBhcmFsbGVsLiBJdCdzIHByZXR0eSBzaW1wbGUgd2hlcmUNCj4+IHdl
IGFsbG93IHVwIHRvIGEgcXVldWUncyB3b3J0aCBvZiBjbWRzIHRvIHN0YXJ0LiBJdCBkb2Vzbid0
IHRyeSB0bw0KPj4gY2hlY2sgdGhhdCBhbGwgY21kcyBhcmUgZnJvbSB0aGUgc2FtZSBxdWV1ZSBv
ciBhbnl0aGluZyBmYW5jeSB0byB0cnkNCj4+IGFuZCBrZWVwIHRoZSBjb2RlIHNpbXBsZS4gTW9z
dGx5IGp1c3QgYXNzdW1pbmcgdXNlcnMgbWlnaHQgdHJ5IHRvIGJ1bmNoDQo+PiBjbWRzIHRvZ2V0
aGVyIGR1cmluZyBzdWJtaXNzaW9uIG9yIHRoZXkgbWlnaHQgaGl0IHRoZSBxdWV1ZSBwbHVnZ2lu
Zw0KPj4gY29kZS4NCj4+DQo+PiBXaGF0IGRvIHlvdSB0aGluaz8NCj4NCj5PaCB5ZWFoLCB3aGF0
IGFib3V0IGEgbW9kcGFyYW0gYmF0Y2hfbGltaXQ/IEl0J3MgYmV0d2VlbiAwIGFuZCBjbWRfcGVy
X2x1bi4NCj4wIHdvdWxkIGNoZWNrIGFmdGVyIGV2ZXJ5IHRyYW5zbWlzc2lvbiBsaWtlIGFib3Zl
Lg0KDQogRGlkIHlvdSByZWFsbHkgZmFjZSB3aXRoIGEgcGVyZiByZWdyZXNzaW9uPyBJIGNvdWxk
IG5vdCBpbWFnaW5lIGhvdyBpdCBpcw0KcG9zc2libGUuDQpEYXRhT3V0IFBEVSBjb250YWlucyBh
IGRhdGEgdG9vLCBzbyBhIHRocm91Z2hwdXQgcGVyZm9ybWFuY2UgY2Fubm90IGJlDQpkZWNyZWFz
ZWQgYnkgc2VuZGluZyBEYXRhT3V0IFBEVXMuDQoNCiBUaGUgb25seSB0aGluZyBpcyBhIGxhdGVu
Y3kgcGVyZm9ybWFuY2UuIEJ1dCB0aGF0IGlzIG5vdCBhbiBlYXN5IHF1ZXN0aW9uLg0KSU1ITywg
YSBzeXN0ZW0gc2hvdWxkIHN0cml2ZSB0byByZWR1Y2UgYSBtYXhpbXVtIHZhbHVlIG9mIHRoZSBs
YXRlbmN5IGFsbW9zdA0Kd2l0aG91dCBpbXBhY3Rpbmcgb2YgYSBtaW5pbXVtIHZhbHVlIChwcmVm
ZXIgY3VycmVudCBjb21tYW5kcykgaW5zdGVhZCBvZg0KdG8gcmVkdWNlIGEgbWluaW11bSB2YWx1
ZSBvZiB0aGUgbGF0ZW5jeSB0byB0aGUgZGV0cmltZW50IG9mIG1heGltdW0gdmFsdWUNCihwcmVm
ZXIgbmV3IGNvbW1hbmRzKS4NCg0KIEFueSBwcmVmZXJlbmNlIG9mIG5ldyBjb21tYW5kcyBvdmVy
IGN1cnJlbnQgb25lcyBsb29rcyBsaWtlIGFuIGlvIHNjaGVkdWxlcg0KZnVuY3Rpb25hbGl0eSwg
YnV0IG9uIHVuZGVybHlpbmcgbGF5ZXIsIHNvIHRvIHNheSBhIEJVUyBsYXllci4NCkkgdGhpbmsg
aXMgYSBtYXR0ZXIgb2YgZnV0dXJlIGludmVzdGlnYXRpb24vZGV2ZWxvcG1lbnQuDQoNCkJSLA0K
IERtaXRyeQ0K
