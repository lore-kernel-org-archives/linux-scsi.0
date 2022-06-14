Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82585C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 13:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbiFNNei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 09:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiFNNeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 09:34:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44AC31C10E
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jun 2022 06:34:33 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-153-BO5-wPNkNeqR-kRQjgCfMA-1; Tue, 14 Jun 2022 14:34:30 +0100
X-MC-Unique: BO5-wPNkNeqR-kRQjgCfMA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Tue, 14 Jun 2022 14:34:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Tue, 14 Jun 2022 14:34:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>
CC:     Davidlohr Bueso <dave@stgolabs.net>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "ejb@linux.ibm.com" <ejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 09/10] scsi/ibmvscsi: Replace srp tasklet with work
Thread-Topic: [PATCH 09/10] scsi/ibmvscsi: Replace srp tasklet with work
Thread-Index: AQHYfBIQ5eC55mb1HE+HVpd+R7cwqq1HLyyAgAesY4CAABJK0A==
Date:   Tue, 14 Jun 2022 13:34:28 +0000
Message-ID: <9e2aad79e478431c89c7ec93c80bcea2@AcuMS.aculab.com>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-10-dave@stgolabs.net> <YqILmd/WnNT/zYrf@linutronix.de>
 <7faa88aaf7554545a60561d73597dc4f@AcuMS.aculab.com>
 <YqiMUS0IGtMgyQ6q@linutronix.de>
In-Reply-To: <YqiMUS0IGtMgyQ6q@linutronix.de>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogU2ViYXN0aWFuIEFuZHJ6ZWogU2lld2lvcg0KPiBTZW50OiAxNCBKdW5lIDIwMjIgMTQ6
MjYNCi4uLg0KPiA+IFRoZXNlIGNoYW5nZXMgc2VlbSB0byBkcm9wIHRoZSBwcmlvcml0eSBmcm9t
IGFib3ZlIHRoYXQgb2YgdGhlDQo+ID4gaGlnaGVzdCBwcmlvcml0eSBSVCBwcm9jZXNzIGRvd24g
dG8gdGhhdCBvZiBhIGRlZmF1bHQgcHJpb3JpdHkNCj4gPiB1c2VyIHByb2Nlc3MuDQo+ID4gVGhl
cmUgaXMgbm8gcmVhbCBndWFyYW50ZWUgdGhhdCB0aGUgbGF0dGVyIHdpbGwgcnVuICdhbnkgdGlt
ZSBzb29uJy4NCj4gDQo+IE5vdCBzdXJlIEkgY2FuIGZvbGxvdy4gVXNpbmcgdGhyZWFkZWQgaW50
ZXJydXB0cyB3aWxsIHJ1biBhdCBGSUZPLTUwIGJ5DQo+IGRlZmF1bHQuIFdvcmtxdWV1ZSBob3dl
dmVyIGlzIFNDSEVEX09USEVSLiBCdXQgdGhlbiBpdCBpcyBub3QgYm91bmQgdG8NCj4gYW55IENQ
VSBzbyBpdCB3aWxsIHJ1biBvbiBhbiBhdmFpbGFibGUgQ1BVLg0KDQpPaywgSSdkIG9ubHkgbG9v
a2VkIGF0IG5vcm1hbCB3b3JrcXVldWVzLCBzb2Z0aW50cyBhbmQgbmFwaS4NClRoZXkgYXJlIGFs
bCBTQ0hFRF9PVEhFUi4NCg0KVW5ib3VuZCBGSUZPIGlzIG1vZGVyYXRlbHkgb2sgLSB0aGV5IGFy
ZSBzdGlja3kgYnV0IGNhbiBtb3ZlLg0KVGhlIG9ubHkgcHJvYmxlbSBpcyB0aGF0IHRoZXkgd29u
J3QgbW92ZSBpZiBhIHByb2Nlc3MgaXMNCnNwaW5uaW5nIGluIGtlcm5lbCBvbiB0aGUgY3B1IHRo
ZXkgbGFzdCBydW4gb24uDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

