Return-Path: <SRS0=0MZD=6J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EF7C55186
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 08:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2D282074F
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 08:59:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AeotGCLA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="y2j2CIAw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDYI7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 04:59:07 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:11401 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgDYI7G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Apr 2020 04:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587805145; x=1619341145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UNkph1rsA1+NLcMRBtQmMRBFokjWmwoFkH4CQTV5yuw=;
  b=AeotGCLAU4zs/ukvWdzB088hAWlPJWHooeWPD4sG5EB0VdLul/urAV//
   tLZyVdAEbw8Vlr95lPcmRyDNbsLyDMjBqnebw9qfA9O7Oz24PzLhkNqgS
   Alz42NyXilr8Ms56v7HnFsd1BQGE7T9xA4lfSn/OIWXS7MmuMngx4SF/6
   5rH7QuYEaBUd8IOiDf6+KP3f5AGjig86idvQLbNOcQm9hCd9DHCd+37GV
   04gXuD3J4IZAXBepHrWpINFJu4LFNV/XS/7vQmXSckRrUXyLTg99JhgrT
   mUvInPMczFA0Vocd4ABahw77O+jsTjnzE3EKm0TcCTLdP62aOPgXNr2AE
   Q==;
IronPort-SDR: fgoDT1vXTwvXSIa1pRBzVj1TikGLuw4iggBWhrOAUVgBRV8q3FqbYyKcSO8IwpqSAzfOPaTUXK
 bTCJS4V4wtw4rOScAR5aaXo8UaJ6UDx6EhQDe7I0ADGz5+QS6iagA0HEWZ+SSStB12zgOY/b5V
 HKikdsSmiaDr7A5fK3yoMIMuLqYF+kgi0x9iTAcRApGKnRloNwwoH3noLbbdEMoArMEMtU9LfF
 cA2uJWMlhi+kITzGdBfxRlNRqKEMehbu4rC4UH7yzCnmJ9OHfmt7vCrajGhCYWaDlUGIT3pvM9
 5Sw=
X-IronPort-AV: E=Sophos;i="5.73,315,1583164800"; 
   d="scan'208";a="137564778"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 25 Apr 2020 16:59:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3cO4WLrkvOxme1cK0x5blUIOeXyw2s+/Qoz4fIUFmVemCqGFgwk50waIRUCSxbrQzldNtdegqjU60uWf529GDZkzaB/g1XAYdPyxXhc4y2RjGW/JuaBp5HfeH6RN128LzvuPQOpxPzEmC1U3U3ZuUmgVsg8YHSoexP8GatJZnIjTHl6QV3pRUyYXaauK4ehjvmucdOFhjqMs2fV3ZSrcUxfdiLIJ3oYzlM6yBBP/KjfGlLyvQYhdlOKZ8RSOKr+6dtNaCQDEu+HjkKH2NneORyZ5M2cEC7qJkMCg03AwsLP6GkmitfkZOvlNQjk5vso0MF9ILRWMUCL7nYIBqsTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNkph1rsA1+NLcMRBtQmMRBFokjWmwoFkH4CQTV5yuw=;
 b=QMmoB19OP3K7401KdsJAtJsWv7ZpjQVt0wQKUXqwFuwqavUQAIppxTxNqZ0c7fvIEbohQTWv+M/JaY5187Mum/yOTX53Nsoijr4Glqkmba4yvgo0sqJwjc+xYnKo6bPYJF0UNUswpSEp008i0xWUuP07S7CvA36xxML6CMiiBHDHx9yM3O4dgy2NzxdCJ3ah0RgFTjlrvzZ0wHQ76n95cPIuuBBnh47FQrSIG2v/itD7t4xh1ULiZhtdj3bWxnsFQW5Y0SWE26YkWkjZoTbwd8Dqm8RVpz4RV7DptD6opRzGhYbJysk2YjEOmaI9YUdSuUMHoLfJ9HCP6/8+ltbkZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNkph1rsA1+NLcMRBtQmMRBFokjWmwoFkH4CQTV5yuw=;
 b=y2j2CIAwEqzf5QY7pHb6al8VucKQgCYgPIM2BmoOhbfhLH81GZGzNidy/h+RbyrfweJD7lb1FhnGQUkeTG9SmKfUe8kJwNC5BYxea0oiRnJLSDiJMvB/xCY5xXCfIwRH52xbqeApbFM0bjBtl3lkeiJRJkaaDK5iiKIylmi+Ofk=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4685.namprd04.prod.outlook.com (2603:10b6:805:b1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Sat, 25 Apr
 2020 08:59:01 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2937.020; Sat, 25 Apr 2020
 08:59:01 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Topic: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
Thread-Index: AQHWFC4dSn/DnOroKESaR41iHFfp4qiF2/SAgAK+MnCAAPi+kA==
Date:   Sat, 25 Apr 2020 08:59:00 +0000
Message-ID: <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
 <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1828e2f-66d8-49c0-9c8c-08d7e8f6e5c0
x-ms-traffictypediagnostic: SN6PR04MB4685:
x-microsoft-antispam-prvs: <SN6PR04MB4685857373A8598D8916A737FCD10@SN6PR04MB4685.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0384275935
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(6506007)(54906003)(4326008)(26005)(71200400001)(7696005)(110136005)(9686003)(33656002)(55016002)(5660300002)(8676002)(64756008)(66476007)(76116006)(66556008)(66946007)(52536014)(81156014)(86362001)(478600001)(8936002)(66446008)(2906002)(316002)(186003)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwnZM3NZBpp6iiUB6qjNcXaaKTElgpE1TVZ9AoJYwYwGlmeShV/tXX/MUCSjK/BIfQ1130maoCnHJYh0GEu8Mwi7qVLUu54/1Z8i+pRTLUUvhT7cJiJA3rn6aKxppfLmtO2hVzEg0/BZQFcS/bS3vnF6TRszjnuLa3ReQc5jANdSsDwBT1F1CAauQcCZthRK2d7ISMS8wnu5ooNmdPFsOLIJUmTiRMWi1PhjsDKBTHzTI7OgU1Q97uSwccREMAdeKOhAU88DK07yTKwqeAr1EYjwKkR1el10YoBcCaghkW+4GGWsKB5kn7Hxaw+FhBr1MmS/N6wXlRONzH8xptNXm8Eoy0yWdn+ucKU/kJoOBEEfzAcLFmq7pLddD/ptgwRubg5a2l79DNp9oAoawRQ4YNz81wVxvRTVyMON6ESKjlWRt80podQYdvxQuPl3y2yMi+yXRwU+J2aKs9nMMtRM8WCBGyoQdT54jgSjH2OkcrE=
x-ms-exchange-antispam-messagedata: a2AkbcPsy0l8Z1ioeuIkgtZ23ktXquHtn0FOGjXRTwiYH+xHcCZS9bfyQOG3dPWIrMJOinFvzClgBDDg5D//sPYPkkk/4sCwdB6BpLlV1EG5x21KKxvvuvfXa892RYeyHjZWfxlMoPuwEo8tksR/PZDu3WrhmM50NE+sjyY0WhU8bcG1xCtELHnqeid9LJBWWndQslRFGHpx42fNXdEqBGWFYh7kmJeD5a/rDSABZok8ilxObKGI/OaZ0CoRflZ+6FgNVnSK3YMIxf4AUJ6i7lL8WHzkDCufKH0Js/heXDq8MAFIcU76smZu/RDm09SRCwgPZZtjTtlK/a+fqhqOLV07WCBP1r6rt1fefpqjMf3aVSXgTF+bBeN0is3PtBZzdEReBWGzEYkHz4FTAjqKEzZYS+3lhXJ/Aj8CVlDuqvhvTOfepGLHgvAMbBS2YqM26lP/b5fOFL8eG0iYJacLknYsWXJX0vxoGyAsZaDpv4ppJzLj15DfOgWcX1qIAyp2XDmfn9IaOXsPCEDqgJy0ZV6DG7vKhgbgCWXjUOqF5p59NhD3F0YaVROCu/kjnvqme4ZuuoqtGiiSTwVrUyvC6wIpvByoMY0XPVzndYO4d+REhrRZrThm5wwIJS51OJVEvXYMwcCgR2p8yWgbL6P6hjAogKhvAU1qSNr6ENRYdmhqfiAiA5u+D+g7wo9UFCFvrviiBy/m8Hrvxu8Dz2izoBE+9uXYt6OOOMsj/zFKnldStvNoCO5g/W4DQOprGun7WL7rRaSXbOGF7eTnf7Gzsc3RMg1wmnr+N5IaDYvVrIw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1828e2f-66d8-49c0-9c8c-08d7e8f6e5c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2020 08:59:00.8939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOVj1IiTvn1+gLVLH7Nf+6uvtABBg8PVCxqKKk0WK53GT4F5++NMztne1mJ/EpsCs2b45FrGNiLO/AUPuZE7wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4685
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T25lIGxhc3Qgd29yZCBmb3IgdGhlIGNvbW11bml0eSBtZW1iZXJzIHRoYXQgYXJlIG5vdCBpbnRv
IHVmcyBkYXktdG8tZGF5Og0KDQpIUEIgaW1wbGVtZW50YXRpb24gbWFkZSBpdHMgZmlyc3QgcHVi
bGljIGFwcGVhcmFuY2UgYXJvdW5kIDIwMTggYXMgcGFydCBvZiBHb29nbGUncyBQaXhlbDMgYW5k
IHNvbWUgVklWTyBtb2RlbHMuDQpTaW5jZSB0aGVuLCBtb3JlIGFuZCBtb3JlIG1vYmlsZSBwbGF0
Zm9ybXMgYXJlIHB1YmxpY2FsbHkgdXNpbmcgSFBCOiBHYWxheHkgTm90ZTEwLA0KR2FsYXh5IFMy
MCBhbmQgVklWTyBORVgzICh0aGF0IGlzIGFscmVhZHkgdXNpbmcgSFBCMi4wKSwgc29tZSBYaWFv
bWkgbW9kZWxzIGV0Yy4NCg0KT24gdGhlIG90aGVyIGhhbmQsIEhQQjEuMCBzcGVjIHdhcyBqdXN0
IHJlY2VudGx5IGNsb3NlZCAtIG5vdCBldmVuIGFzIHBhcnQgb2YgVUZTMy4xLA0KYnV0IG9ubHkg
YWZ0ZXIgLSBhYm91dCAyIG1vbnRocyBhZ28uIFRoZSBpbmR1c3RyeSBpcyBydXNoaW5nIGZvcndh
cmQsIHdlJ3ZlIHNlZW4gdGhpcyBtYW55IHRpbWVzLg0KDQpUaGUgZmFjdCBpcyB0aGF0IEhQQiBp
cyBoZXJlIHRvIHN0YXkgLSBlaXRoZXIgYXMgYSBob3JkZSBvZiBvdXQtb2YtdHJlZSBpbXBsZW1l
bnRhdGlvbnMsDQpvciBhcyBhIHN0YW5kYXJkIGFjY2VwdGFibGUgbWFpbmxpbmUgZHJpdmVyLg0K
DQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IEhpIEJhcnQsDQo+IA0KPiA+IFdoYXQgYXJlIHRoZSBz
aW1pbGFyaXRpZXMgYW5kIGRpZmZlcmVuY2VzIGNvbXBhcmVkIHRvIHRoZSBsaWdodG52bQ0KPiA+
IGZyYW1ld29yayB0aGF0IHdhcyBhZGRlZCBzZXZlcmFsIHllYXJzIGFnbyB0byB0aGUgTGludXgg
a2VybmVsPyBXaGljaCBvZg0KPiA+IHRoZSBjb2RlIGluIHRoaXMgcGF0Y2ggY2FuIGJlIHNoYXJl
ZCB3aXRoIHRoZSBsaWdodG52bSBmcmFtZXdvcms/DQo+IFNpbXBseSBwdXQsIHVubGlrZSBsaWdo
dG52biwgSFBCIGlzIG5vdCBob3N0LW1hbmFnZWQgRlRMLCBCdXQgaW5zdGVhZCBjYW4gYmUNCj4g
cGVyY2VpdmVkIGFzIGEgY29zdC1yZWR1Y3Rpb24gZWZmb3J0Lg0KPiBJdHMgYWltIGlzIG5vdCB0
byBtb3ZlIHRoZSBmdyB0byB0aGUgaG9zdCwgYnV0IHRvIGNvbnRyb2wgdGhlIGlOQU5EIGNvc3Qg
YnkNCj4gbGltaXRpbmcgdGhlIGFtb3VudCBvZiBpdHMgaW50ZXJuYWwgUkFNLg0KPiBJdCBpcyBk
b25lIGJ5IHVzaW5nIHRoZSBob3N0IG1lbW9yeSB0byBjYWNoZSB0aGUgTDJQIHRhYmxlcywgYW5k
IHJlcGxhY2UNCj4gUkVBRF8xMCB0aGF0IGhhdmUgb25seSB0aGUgbGJhLA0KPiBieSBhbiBhbHRl
cm5hdGl2ZSBjb21tYW5kIC0gSFBCX1JFQUQsIHRoYXQgaGF2ZSBib3RoIHRoZSBsb2dpY2FsIGFu
ZA0KPiBwaHlzaWNhbCBhZGRyZXNzZXMuDQo+IA0KPiBVc2luZyBMaWdodG52bSB3YXMgY29uc2lk
ZXJlZCBpbiB0aGUgcGFzdCBhcyBwb3NzaWJsZSBmcmFtZXdvcmsgZm9yIEhQQiwNCj4gYnV0IHdh
cyByZWplY3RlZCBieSBib3RoIENocmlzdG9waCAmIE1hdHRpYXMuDQo+IA0KPiBUaGUgSFBCIGZl
YXR1cmUgd2FzIE5BS2VkIGJ5IENocmlzdG9waCBpbiBpdHMgZW50aXJldHksIHJlZ2FyZGxlc3Mg
b2YgdGhlDQo+IGRyaXZlciBkZXNpZ24uDQo+IFVudGlsIHRoaXMgaXMgbm90IHJldmVyc2VkLCBr
ZWVwIGNvbW1lbnRpbmcgdGhpcyBwYXRjaCBpcyBjb3VudGVycHJvZHVjdGl2ZQ0KPiBhbmQgY29u
ZnVzaW5nLg0KPiANCj4gU2hvdWxkIHRoaXMgZGVjaXNpb24gaXMgcmV2ZXJzZWQsIEkgdGhpbmsg
dGhpcyBwYXRjaCBzaG91bGQgYmUgcmUtcG9zdGVkIGFzIGENCj4gUkZDLA0KPiBBbmQgZnJhZ21l
bnQgaXRzIDUsMDAwIGxpbmVzIG9yIHNvIGludG8gYSBzZXQgb2YgcmV2aWV3YWJsZSBwYXRjaGVz
Lg0KPiANCj4gVGhhbmtzLA0KPiBBdnJpDQoNCg==
