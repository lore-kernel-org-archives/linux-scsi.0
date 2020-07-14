Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84501C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B0E20B80
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:49:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="HsG++XXe";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="OBPv/RLs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgGNEtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:49:41 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:8746 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNEtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594702179; x=1626238179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=us2mIUYRhwbb4VGU7iRVjM/eRQVA55EigUJWlYCne/U=;
  b=HsG++XXepbPSF0+ww3NA/Hnd3aEPFQXiv3pVai3At2tE4XMLaZ72V/Rz
   nmZBdTVTlDZH29kNdSnnll97CLHVHCmGizP//0kXl/4EoBmxB+s1vQnnM
   tiwQHwX/Hu0KKI6X1gC4kmccGKjDAHf3SaU7o1iOM2SvKuInm+heGNxZq
   s6j7ciomXAigWrmOQBknTi+h7mgDd1xKJHYKFSZQdyjWrqOcQBjufreaB
   3RB/X6s0FkqBrH5tk/chFYY3BiJSwnqfFz2rIurkaDcn9bpA7jHz5p0oY
   cBvD2/by/EZ3Ta1cGqB3jncal6bK4esiHdea/SLtCufPuhJ3F7JYzUpml
   Q==;
IronPort-SDR: iKFQUNyWmzcSRE2vrj/cSimfO64gXtmBqae7DHK1qR61L7gZAs+UNwnf9/dXhmI0KveLKSG9WR
 xLnxIE1zaESYzoMRouhAzits8b74ncn2hiUskcq/XIIr7x7921qyeBSCNwdq69ljl3+bVmJ9OQ
 B+735E0afd1sWirpaNhb8MSoER+q9WywYI86QcTdhlMlv5Y0urTjBZqA/dYAx36Athu9fOWau0
 Elbp6IY+dY9dHrKQo05fl/6mUhZQD96VS25D8UrR40Ahxcc6iapMfPV2pdevEs82a0f9CHVQIy
 Qs4=
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="81725026"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2020 21:49:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 21:49:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 13 Jul 2020 21:49:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNtQ8sfVI1vZM4WMR7wOXjMW4zb7EY5oCTGWJw18dyoFIKLB/g/UYdY0N+S3kPYxAW9j9y0wj8R7DUbo+v4mP8M4xnPgCvZLDOor7+mc2xNButVy9vcv0TeOp+k+Xus9gA7aIO1cNhS0lxEqb0KgMR9P8YRBTmhcleDbrkeka6mnkHMWvY5rKo9hIGt5PlV3/+cb+KUvm7FvY9a2WgbTm2kEHdjAKfnB3a6K04sjV4riUPeI4oK3AuqAR1Hwoqd40czxo9ItO0UWIFwW6kKxq3GbloMBSjWMz8lwugPA+Xl/uJusPZGNIYmNCoTyz373IuIvdlI4sMaV2A+dsiUJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us2mIUYRhwbb4VGU7iRVjM/eRQVA55EigUJWlYCne/U=;
 b=ldx3KA4iVHyKcL29TgJh1FDuVxwJRjbuzibIpwKb/Xa7fb14o2amz/GyQi2siqouXaJWy70bWwTYLnIU4bOfpp4f1ow2/thDuW4zz1oc3oCVrfUza/RgclqFQBg1vhWwWIqzZRsD39+5DurC4id62lsvl+TLYs5r/srigxordCTMdSd2t2ZG0keolcdRJbOIje/dbdwB+hLzlgHIAgpKvhe/34F0pGZ5dY3mooWqUaCYIx+0KcTTZ2otYa4XTRW4OJRZwZuGZh8ZNFXwiNdDH6mjmhWKAeJTePDm1ei08uQcIp4sBl3dm4Jdjhb7PKprlDJtJKC/wGCwRqIurp2jow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us2mIUYRhwbb4VGU7iRVjM/eRQVA55EigUJWlYCne/U=;
 b=OBPv/RLsBcxmYBnUpAhyhrC1+n9Ouvx3lxUeTLfuFeh5Fs9tkY7B1jhO7xMYOsa40SK6NeFuQRyqJOOf2+BXZa7I5wIGtgbkjV9COZ9JdBASAFhKM2tmGraJhmVFLKcBtsFMeSA0bT/mbvAhEws15sWGNh2ChakzG0iGkJMzYkU=
Received: from CY4PR11MB1400.namprd11.prod.outlook.com (2603:10b6:903:29::21)
 by CY4PR1101MB2245.namprd11.prod.outlook.com (2603:10b6:910:1f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 14 Jul
 2020 04:49:35 +0000
Received: from CY4PR11MB1400.namprd11.prod.outlook.com
 ([fe80::dbb:7f04:ea0a:e55e]) by CY4PR11MB1400.namprd11.prod.outlook.com
 ([fe80::dbb:7f04:ea0a:e55e%3]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 04:49:35 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <john.garry@huawei.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <dpf@google.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH V2 3/3] pm80xx : Wait for PHY startup before draining
 libsas queue.
Thread-Topic: [PATCH V2 3/3] pm80xx : Wait for PHY startup before draining
 libsas queue.
Thread-Index: AQHWSh4n4Ai6sgowaE+/Sw0sT9em46jn/0kAgB6fomA=
Date:   Tue, 14 Jul 2020 04:49:34 +0000
Message-ID: <CY4PR11MB1400DB6F326A00C475AE2325EF610@CY4PR11MB1400.namprd11.prod.outlook.com>
References: <20200624120322.6265-1-deepak.ukey@microchip.com>
 <20200624120322.6265-4-deepak.ukey@microchip.com>
 <858e1af3-6ce6-e827-d24e-02d56459959b@huawei.com>
In-Reply-To: <858e1af3-6ce6-e827-d24e-02d56459959b@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [103.252.171.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ddc8349-3558-4bd2-6c24-08d827b14e5b
x-ms-traffictypediagnostic: CY4PR1101MB2245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB22459A81A4E51C5CC8AF1D0CEF610@CY4PR1101MB2245.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TwzBAAfnvq7Ws5lmPYT6K2kqUlMZrcOAElZL3OWT1NsJccOI1tZ7kYD+IwF0tpZAkAXTmYsVMWnt9tBaXJ9299HTlgJwog/6iHUEjqEOVv+IIJXctWS8yxyZzWbgOQqawPsrl0H8B9fxXnzN5l9FjKKOIPhkRKpcBUDHeCyrl0bKZteDqEy2VBU24AI9OLNfYYWiiwmFlwgv62UzZLUwiQfv2tQzb/BVLXZX+S39bz4nAaW9WktHPK1qxrpYs1oHhU1VKC0m2pIGR2O0c9Gc4KIZrehtvor+J8/NBxM0YskXOFg9aL5KNcAKTc6xK35+3QsLo3BML0/XTeNDFUm62w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1400.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(366004)(396003)(346002)(376002)(66556008)(66446008)(7696005)(71200400001)(26005)(2906002)(8676002)(33656002)(5660300002)(53546011)(186003)(6506007)(478600001)(7416002)(9686003)(76116006)(66476007)(66946007)(4326008)(55016002)(64756008)(86362001)(8936002)(54906003)(83380400001)(52536014)(110136005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wmpv3jU2PXfquW00QrqaxGigSprtS+Fz9tCXhuOZDf742NaqM4YdsewVIFmM769OiEtmbdag0mzicbl5ZLZBlgDRDts5IwjDliEHmbr9QLDPSRDvmG0NkTyDPCGBPjQYOXxTNZstioPsUiJNcB336xyd3K8864j/mloG15DqGM00WMqepauygCREfB3dcgkfPfvJmpK/SrS6jeNKGbvjEpOZrL/BjhDOyKuwKdp6RwwXffwbFXunvoBcnW2TDD05vUixebOWcx7g0zJnmL71eAu1YuHSEsrODMTy7PnPRWnoz/VIYHMg10/R8LRkoc9WWpL6uteMK5vPssdXO23KF22Ip4s8OfpuusxaTB4f3mSymkKIeFGesBDybI2p64bo2hju/MpLD60iRhHZ6ID5wE8jMzHEKHwuoqE3+ZOp+jjz49BHhrDw6shQ7ZHRbFc5hn9YMV9ssDQeu2kcaIIHiG9BMJZbXw+Z2ZaV9UbGzeKOiSeXi4etU73oKi62uqoW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1400.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ddc8349-3558-4bd2-6c24-08d827b14e5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 04:49:34.8514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tqRJogOo9bsSItViodc1W18Xydnzo+DKrQq40vsD17DMsOa2O1rFuFPhiB5Immvg7ZW/IbVMQAIK36HJ9hJsvMmmRf+xc209UwcGpgH/gN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2245
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gMjQvMDYvMjAyMCAxMzow
MywgRGVlcGFrIFVrZXkgd3JvdGU6DQoNCg0KPiBGcm9tOiBwZXRlciBjaGFuZyA8ZHBmQGdvb2ds
ZS5jb20+DQo+DQo+IFRoZSBob3N0J3Mgc2NhbiBmaW5pc2ggd2FpdHMgZm9yIHRoZSBsaWJzYXMg
cXVldWUgdG8gZHJhaW4uIEhvd2V2ZXIsIA0KPiBpZiB0aGUgUEhZcyBhcmUgc3RpbGwgaW4gdGhl
IHByb2Nlc3Mgb2Ygc3RhcnRpbmcgdGhlbiB0aGUgcXVldWUgd2lsbCANCj4gYmUgZW1wdHkuIFRo
aXMgbWVhbnMgdGhhdCB3ZSBkZWNsYXJlIHRoZSBzY2FuIGZpbmlzaGVkIGJlZm9yZSBpdCBoYXMg
DQo+IGV2ZW4gc3RhcnRlZC4gSGVyZSB3ZSB3YWl0IGZvciB2YXJpb3VzIGV2ZW50cyBmcm9tIHRo
ZSBmaXJtd2FyZS1zaWRlLg0KDQpCdXQgd2Ugc3RpbGwgcmVwb3J0IHRoZSBwaHkgdXAgZXZlbiB0
byBsaWJzYXMgbGF0ZXIsIHNvIHNob3VsZCByZXZhbGlkYXRlIHRoZSBkb21haW4gYW5kIGRpc2Nv
dmVyIHRoZSBkZXZpY2UuDQotIFRoZSBzY3NpX2hvc3Qgc2Nhbl9maW5pc2hlZCBjYWxsYmFjayBw
b2xscyB0aGUgcGh5IHN0YXRlIGluIHBtODAwMV91cGRhdGVfcGh5X21hc2suIElmIHRoZSBwaHkg
ZmFpbHMgdG8gY29tZSB1cCAtIC0gYWZ0ZXIgcGh5LT5zdGFydF90aW1lb3V0LCB3ZSBkZWNsYXJl
IHRoZSBzY2FuIGFzIGZpbmlzaGVkIGFuZCBwcm9jZWVkLg0KPg0KPiBUaGUgd2FpdCBiZWhhdmlv
ciBjYW4gYmUgY29uZmlndXJlZCB1c2luZyB0aGUgbW9kdWxlIHBhcmFtZXRlciANCj4gIndhaXRf
Zm9yX3BoeV9zdGFydHVwIiwgaWYgdGhlIHBhcmFtZXRlciBpcyBlbmFibGVkLCB0aGUgZHJpdmVy
IHdpbGwgDQo+IHdhaXQgZm9yIHRoZSBwaHkgZXZlbnQgZnJvbSB0aGUgZmlybXdhcmUsIGJlZm9y
ZSBwcm9jZWVkaW5nIHdpdGggbG9hZC4NCg0KSWYgdGhpcyBpcyB0byBjaXJjdW12ZW50IGEgZGVm
aWNpZW5jeSBpbiB1ZGV2ICh3aGljaCB5b3UgbWVudGlvbmVkIGluIHRoZSB2MSBpbiB0aGlzIHNl
cmllcywgYnV0IGZhaWwgdG8gbWVudGlvbiBoZXJlKSwgdGhlbiBiZXR0ZXIgdG8gZml4IHVkZXYu
DQotIEFjY29yZGluZyB0byByZWNvbW1lbmRhdGlvbiB0byBmaXggdGhpcyB1c2luZyB1ZGV2LiBJ
dCBsb29rcyBsaWtlIHVwc3RyZWFtaW5nIHRoaXMgcGF0Y2ggaXMgbm90IHBvc3NpYmxlLiBXZSB3
aWxsICAgICAgIC0gaW52ZXN0aWdhdGUgdXNpbmcgdWRldiBmb3IgZml4aW5nIHRoaXMgaXNzdWUg
YW5kIHN1Ym1pdCB0aGlzIHBhdGNoIGxhdGVyIGluICBmdXR1cmUuDQoNCj4NCj4gU2lnbmVkLW9m
Zi1ieTogVmlzd2FzIEcgPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+DQoNCkF1dGhvciAhPSBmaXJz
dCBTaWduZWQtb2ZmLWJ5DQoNCj4gU2lnbmVkLW9mZi1ieTogcGV0ZXIgY2hhbmcgPGRwZkBnb29n
bGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBSYWRoYSBSYW1hY2hhbmRyYW4gPHJhZGhhQGdvb2ds
ZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IERlZXBhayBVa2V5IDxEZWVwYWsuVWtleUBtaWNyb2No
aXAuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9jdGwuYyAgfCAz
NiArKysrKysrKysrKysrKysrKysrKysNCj4gICBkcml2ZXJzL3Njc2kvcG04MDAxL3BtODAwMV9k
ZWZzLmggfCAgNiArKy0tDQo+ICAgZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfaW5pdC5jIHwg
MjIgKysrKysrKysrKysrKw0KPiAgIGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX3Nhcy5jICB8
IDY3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPiAgIGRyaXZlcnMv
c2NzaS9wbTgwMDEvcG04MDAxX3Nhcy5oICB8ICA0ICsrKw0KPiAgIGRyaXZlcnMvc2NzaS9wbTgw
MDEvcG04MHh4X2h3aS5jICB8IDY3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLQ0KPiAgIDYgZmlsZXMgY2hhbmdlZCwgMTg1IGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9u
cygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfY3RsLmMg
DQo+IGIvZHJpdmVycy9zY3NpL3BtODAwMS9wbTgwMDFfY3RsLmMNCj4gaW5kZXggM2M5ZjQyNzc5
ZGQwLi5lYWU2Mjk2MTBhNWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04
MDAxX2N0bC5jDQo+ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MDAxX2N0bC5jDQo+IEBA
IC04OCw2ICs4OCw0MSBAQCBzdGF0aWMgc3NpemVfdCBjb250cm9sbGVyX2ZhdGFsX2Vycm9yX3No
b3coc3RydWN0IGRldmljZSAqY2RldiwNCj4gICB9DQo+ICAgc3RhdGljIERFVklDRV9BVFRSX1JP
KGNvbnRyb2xsZXJfZmF0YWxfZXJyb3IpOw0KPg0KPiArLyoqDQo+ICsgKiBwaHlfc3RhcnR1cF90
aW1lb3V0X3Nob3cgLSBwZXItcGh5IGRpc2NvdmVyeSB0aW1lb3V0DQo+ICsgKiBAY2RldjogcG9p
bnRlciB0byBlbWJlZGRlZCBjbGFzcyBkZXZpY2UNCj4gKyAqIEBidWY6IHRoZSBidWZmZXIgcmV0
dXJuZWQNCj4gKyAqDQo+ICsgKiBBIHN5c2ZzICdyZWFkL3dyaXRlJyBzaG9zdCBhdHRyaWJ1dGUu
DQo+ICsgKi8NCj4gK3N0YXRpYyBzc2l6ZV90IHBoeV9zdGFydHVwX3RpbWVvdXRfc2hvdyhzdHJ1
Y3QgZGV2aWNlICpjZGV2LA0KPiArICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwg
Y2hhciAqYnVmKSB7DQo+ICsgICAgIHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gY2xhc3NfdG9f
c2hvc3QoY2Rldik7DQo+ICsgICAgIHN0cnVjdCBzYXNfaGFfc3RydWN0ICpzaGEgPSBTSE9TVF9U
T19TQVNfSEEoc2hvc3QpOw0KPiArICAgICBzdHJ1Y3QgcG04MDAxX2hiYV9pbmZvICpwbTgwMDFf
aGEgPSBzaGEtPmxsZGRfaGE7DQo+ICsNCj4gKyAgICAgcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFH
RV9TSVpFLCAiJTA4eGhcbiIsDQo+ICsgICAgICAgICAgICAgcG04MDAxX2hhLT5waHlfc3RhcnR1
cF90aW1lb3V0IC8gSFopOyB9DQo+ICsNCj4gK3N0YXRpYyBzc2l6ZV90IHBoeV9zdGFydHVwX3Rp
bWVvdXRfc3RvcmUoc3RydWN0IGRldmljZSAqY2RldiwNCj4gKyAgICAgc3RydWN0IGRldmljZV9h
dHRyaWJ1dGUgKmF0dHIsIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KSB7DQo+ICsgICAg
IHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gY2xhc3NfdG9fc2hvc3QoY2Rldik7DQo+ICsgICAg
IHN0cnVjdCBzYXNfaGFfc3RydWN0ICpzaGEgPSBTSE9TVF9UT19TQVNfSEEoc2hvc3QpOw0KPiAr
ICAgICBzdHJ1Y3QgcG04MDAxX2hiYV9pbmZvICpwbTgwMDFfaGEgPSBzaGEtPmxsZGRfaGE7DQo+
ICsgICAgIGludCB2YWwgPSAwOw0KPiArDQo+ICsgICAgIGlmIChrc3RydG9pbnQoYnVmLCAwLCAm
dmFsKSA8IDApDQo+ICsgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ICsNCj4gKyAgICAg
cG04MDAxX2hhLT5waHlfc3RhcnR1cF90aW1lb3V0ID0gdmFsICogSFo7DQo+ICsgICAgIHJldHVy
biBzdHJsZW4oYnVmKTsNCg0KSSBkb24ndCBzZWUgaG93IHRoaXMgY2FuIGJlIHVzZWQuDQoNCj4g
K30NCj4gKw0KPiArc3RhdGljIERFVklDRV9BVFRSX1JXKHBoeV9zdGFydHVwX3RpbWVvdXQpOw0K
PiArDQoNCiA+DQogPiAgICAgIGNhc2UgSFdfRVZFTlRfU0FTX1BIWV9VUDoNCiA+IEBAIC00OTc1
LDYgKzUwMTUsOSBAQCBwbTgweHhfY2hpcF9waHlfc3RhcnRfcmVxKHN0cnVjdCBwbTgwMDFfaGJh
X2luZm8gKnBtODAwMV9oYSwgdTggcGh5X2lkKSAgPg0KID4gICAgICBQTTgwMDFfSU5JVF9EQkco
cG04MDAxX2hhLA0KID4gICAgICAgICAgICAgIHBtODAwMV9wcmludGsoIlBIWSBTVEFSVCBSRVEg
Zm9yIHBoeV9pZCAlZFxuIiwgcGh5X2lkKSk7DQogPiArICAgIHNldF9iaXQocGh5X2lkLCAmcG04
MDAxX2hhLT5waHlfbWFzayk7DQogPiArICAgIHBtODAwMV9oYS0+cGh5W3BoeV9pZF0uc3RhcnRf
dGltZW91dCA9DQogPiArICAgICAgICAgICAgamlmZmllcyArIHBtODAwMV9oYS0+cGh5X3N0YXJ0
dXBfdGltZW91dDsNCiA+DQogPiAgICAgIHBheWxvYWQuYXNlX3NoX2xtX3Nscl9waHlpZCA9IGNw
dV90b19sZTMyKFNQSU5IT0xEX0VOQUJMRSB8DQogPiAgICAgICAgICAgICAgICAgICAgICBMSU5L
TU9ERV9BVVRPIHwgcG04MDAxX2hhLT5saW5rX3JhdGUgfCBwaHlfaWQpOw0KID4gLS0NCg0KSWYg
dGhlcmUgaXMgbm90aGluZyBhdHRhY2hlZCB0byB0aGUgcGh5LCB0aGVuIGl0IHdvdWxkIG5ldmVy
IGNvbWUgdXAsIHJpZ2h0PyBJZiBzbywgaG93IGRvIHlvdSBoYW5kbGUgdGhpcz8NCg0KVGhhbmtz
LA0Kam9obg0KDQo=
