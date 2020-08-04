Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BE6C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 15:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 989C4208A9
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 15:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="t83x2I9S";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="YmLWd1Vo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgHDPTH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 11:19:07 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:39121 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728586AbgHDPTG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 11:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596554346; x=1628090346;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/XiJigC+V+poB1DJy6GqtVSUeGS4164elRNRC/6JcTA=;
  b=t83x2I9SO8yDXn2OQlpR8FdEDRYoq8aTcctsACPyfuUNUhSAFXp4HxD+
   VIA7USkm0y9lizygNSyeVNyDoD0U5CtBY1l/E+xGtlMd9Un8orE4QXFmd
   Th0N/b3lvpNxaF1cn8KiEv3JuDU2U1kTBt9UGSIcmoK6qow/WMHJofg9j
   nMLiG8daiW9Bz/wK1wvOvWEJMrMVwE1PR65xupoBVsjwlqFTVrMIMes9r
   WJ/oxOIEhDIH30gD0ZMjT2R1R5jM6HwXY9pjQXrUhiQ226KFAH3J4MYf2
   gi3S5ufpbg57Vqx7tqoJcebOjcuu0R0D3jkux2Qw6MRQ6SKzODfHIVAn7
   A==;
IronPort-SDR: VyCGxXDsfjtZYC5JsLLYazezB8tBXzxaporNGffEyVd5y+W9cdcOmImyP2VgzeNw2OgyXiYCX8
 igcUYCfQq0SXGWExdf6dVbn6rSKtSfwBCkzXXxMtdUVStVlA9/MsZhmpAHjmRlECLiq9od5PFE
 aze5+mqS7yk8uzGn6CllOi+GQcrvDZuzuYCR+aYx1PL5WgmD3LueIsF20TtNnXRVb+0AHVhucq
 wn3EVdj5jYeaGWsvCMlcCfEKKgn5FxmG7tVaQQ/+P3ru14IqOSSLEihaA3UWW7nurtTdvRELe+
 +fk=
X-IronPort-AV: E=Sophos;i="5.75,434,1589266800"; 
   d="scan'208";a="84385571"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Aug 2020 08:18:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 08:18:45 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 4 Aug 2020 08:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPCNgYvclkgkngoAAE+xINm126kAUpqSkanopId+sDOW2/C2nMIDvNvJqs/gzE8xQivn7dCPFwWQQLt3BBrNz557Rk9pYnCNGTfeRg3juf/LhdAXNsm6Jh0zz0m1ayrTt3nEEQtkUubU53k3krbVYjBL3ASKqZVn3lcp30pZmG+zRT4Q58uTKxtdQIg0fCreZ6D6uO2DbUEPW2YcCvP5NmTg8JNFQaV7Mcnmf6/vLGPYbZIzl7Q3+AuKJlZ2gYixOGD4WgMgBrxtC5kA55+o0sZvp3I7rdFsKA3l3cA95SHr3mlQcYNnwWQG4rPk1ymMM+NdUMfHczssNCBD2uU+kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XiJigC+V+poB1DJy6GqtVSUeGS4164elRNRC/6JcTA=;
 b=FlIOmWBq5REDwpQ9fHcpfk/MEhP1xOer/ceC+/12FMLPsn1EHFZaEgO4tFDIFp4DDBpWbtw1P8IctVdxS5ApWoUWIqmLDcgCaIZEDnsSU74jeGzC8Lw3tm3vCh8K8ZRS9WQyjpxbccUeUEdZ4VVT6EIe0WxShZ7lMhIA7A2e1KBVaDQtpyEX9jpB48iaF/0pbj/0Gus8h6jMKxD9+Op1uhK1T27sRTSMzncCba+5OGdJwginbIDATRfaO8qSRRBBaAClknfvzJ2FREZK9v5aOfF1pu5h38jVg4ZGmX35+YBIAXE1EkUJqumC1VC1Cr1Pax5294x1OhyD00oEeDWwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/XiJigC+V+poB1DJy6GqtVSUeGS4164elRNRC/6JcTA=;
 b=YmLWd1Vo9j+qOqSO1wziaoGpcsfFCFRdoDR/vm3qU+LaLTq8e6gaNBP4rMNUwolKilsE9Pf+OGpj81uDGeUNo8kb+qfHgbdq7eYSFbCiWHIlTAkO4ToCEbmg9cRmmHJYvzZ/3tp4n4rAd4871y0cbDorNjhqpsSTCkehQOVvDzY=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2749.namprd11.prod.outlook.com (2603:10b6:805:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Tue, 4 Aug
 2020 15:18:47 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 15:18:46 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <hare@suse.de>, <don.brace@microsemi.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
Subject: RE: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Topic: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Index: AQHWP01RAs2BRuCN0k+i3rLwgMsJTKkG5J+AgAABKwCAAAMVAIAgQ/rQgADXkYCAAGEqcA==
Date:   Tue, 4 Aug 2020 15:18:46 +0000
Message-ID: <SN6PR11MB2848F0DD0CB3357541DBDAA9E14A0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
 <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
In-Reply-To: <ccc119c8-4774-2603-fb79-e8c31a1476c6@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e2a0fc7-097b-4552-1c16-08d83889aedd
x-ms-traffictypediagnostic: SN6PR11MB2749:
x-microsoft-antispam-prvs: <SN6PR11MB274978FB0964DD96D0C5EFABE14A0@SN6PR11MB2749.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xwcDIWBItWuSFgyhKi7g+0Ut39PrDqoNe0Sui9USpFPNOUWQCbnfsefuXDPaWeBNAJwBJ5i+ixXO1KtmvKMXqJBdDp2bw02TcQrgYKWTBf8fY89eijcAjEU1TZTINL14ElEAD3tZ1OE33xzBIQNeOUTBWejEssOA6Zn6clcoEipO3zkWPAZrssfzUy1tQdFQbjld0kDZk5YoS0qeYA8HDsnGLc4nT+7eafQJ+R0K7gNG+90j2EiDgpZGzPJCVH9Jmq7FMosmJ4wgf/S11tmSCeFCmNZtDVvyu6yqMSA6ZtSWZ4uMEFff6Y35FM+We15PkesdUCjmEeoMkEHlTtA1LYpoaoplmQ6pzcGX6kMHqROCDWphNraPXyRXoGWfhSzVqq4QCBy88IGNta1F/A61fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(8676002)(66476007)(8936002)(498600001)(2906002)(66556008)(7416002)(4326008)(76116006)(66446008)(64756008)(9686003)(71200400001)(5660300002)(55016002)(7696005)(110136005)(6506007)(186003)(54906003)(33656002)(86362001)(52536014)(26005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AK0gMwruNVd1cxLydle3tf2W7GD0FFu4wj93LUitd+oT/TTLdUfZ4rpFdkM3JISONv+5PsH2BqKcQa74cN61eNV4jHDKyg41RyqebW8zEuLgV2/qIEHZ1i5EwJrV1TCrNN7sOwjjxhO9Zc7cID7schL3X74T/xW2QcklVEHNHZBXWa2/FXOD5FNXuhYiVZqQw1eyF2N8YU991QbiUpoXbyMslvNSyeM5xiNiGImU/RT7APNqb3ZivSyysWG3W2w/IGz1FYntK1TDlI9/tE0llDLzV4Dlaa4J7P0kNE/xmtXVdHti3c0RUcpv2ux2cLZa7d1HcKFZoqGyxxkY3JoiVlateRtbUhnpm4gsVYpDkvqTsuTWQeeqzLYjec7sgX7gkT/mX9FORbZuUV/GNUrg0wj8/VzetAvMNBs7iDHGG1rdvU/MmS9qB3IGj5MDMlLUZxdeUCyJQmc+H/Nw0uHgoUArTwl7GYU8E/PK/8Y6Nhgmk5/cgQmW/aguELKbzF+b3e6/QKsSl+FeHq6mIPJ7lOIz9yIAEKOAICOQoWhH/cm240zdrKJrI65TPVxGPM6m2TGca4fAKKorpHAQy6RQhOrnUAdz35YZCZ5eFn2eQn7BL+nU6aV1oGhEIgsQOSn4CI8LQ9twIwt9QLLb0advig==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2a0fc7-097b-4552-1c16-08d83889aedd
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 15:18:46.5707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZgtpWnjLYuulV7qdCmSwT2WFymrFeWFQ6t3qsN9OMIqvdwMHeRAAt55xc4IL9Qg6SvoG9khQxSWrema+MRtCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2749
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgdjcgMTIvMTJdIGhwc2E6IGVuYWJsZSBob3N0X3RhZ3Nl
dCBhbmQgc3dpdGNoIHRvIE1RDQoNCkhpIERvbiwNCg0KPj4+IGF0IHNob3VsZCBiZSBnb29kIHRv
IHRlc3Qgd2l0aCBmb3Igbm93Lg0KPiBjbG9uZWRodHRwczovL2dpdGh1Yi5jb20vaGlzaWxpY29u
L2tlcm5lbC1kZXYNCj4gICAgICAgYnJhbmNoIG9yaWdpbi9wcml2YXRlLXRvcGljLWJsay1tcS1z
aGFyZWQtdGFncy1yZmMtdjcNCj4NCj4gVGhlIGRyaXZlciBkaWQgbm90IGxvYWQsIHNvIEkgY2hl
cnJ5LXBpY2tlZCBmcm9tDQo+DQo+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9oYXJlL3Njc2ktZGV2ZWwuZ2l0DQo+ICAgICAgIGJyYW5jaCBvcmlnaW4vcmVz
ZXJ2ZWQtdGFncy52Ng0Kb2ssIGdyZWF0DQoNCj4gYnV0IEkgYW0gZ2V0dGluZyBhbiBleHRyYSBk
ZXZpY2VzIGluIHRoZSBsaXN0IHdoaWNoIGRvZXMgbm90IHNlZW0gdG8gDQo+IGJlIGNvbWluZyBm
cm9tIGhwc2EgZHJpdmVyLg0KPg0KPj5JIGFzc3VtZSB0aGF0IHlvdSBhcmUgbWlzc2luZyBzb21l
IG90aGVyIHBhdGNoZXMgZnJvbSA+PnRoYXQgYnJhbmNoLCBsaWtlDQo+PnRoZXNlOg0KDQo+Pjc3
ZGNiOTJjMzFhZSBzY3NpOiByZXZhbXAgaG9zdCBkZXZpY2UgaGFuZGxpbmcNCj4+NmU5ODg0YWVm
ZTY2IHNjc2k6IFVzZSBkdW1teSBpbnF1aXJ5IGRhdGEgZm9yIHRoZSBob3N0ID4+ZGV2aWNlIGEz
ODE2MzdmOGE2ZSBzY3NpOiB1c2UgcmVhbCBpbnF1aXJ5IGRhdGEgd2hlbiA+PmluaXRpYWxpc2lu
ZyBkZXZpY2VzDQoNCj4+QEhhbm5lcywgQW55IHBsYW5zIHRvIGdldCB0aGlzIHNlcmllcyBnb2lu
ZyBhZ2Fpbj8NCg0KSSBjaGVycnktcGlja2VkIHRoZSBmb2xsb3dpbmcgYW5kIHRoaXMgcmVzb2x2
ZXMgdGhlIGlzc3VlLg0KNzdkY2I5MmMzMWFlIHNjc2k6IHJldmFtcCBob3N0IGRldmljZSBoYW5k
bGluZw0KNmU5ODg0YWVmZTY2IHNjc2k6IFVzZSBkdW1teSBpbnF1aXJ5IGRhdGEgZm9yIHRoZSBo
b3N0IGRldmljZQ0KYTM4MTYzN2Y4YTZlIHNjc2k6IHVzZSByZWFsIGlucXVpcnkgZGF0YSB3aGVu
IGluaXRpYWxpc2luZyBkZXZpY2VzDQpJJ2xsIGNvbnRpbnVlIHdpdGggbW9yZSBJL08gc3RyZXNz
IHRlc3RpbmcuDQoNClRoYW5rcyBmb3IgdGhlIHBhdGNoIHN1Z2dlc3Rpb25zLA0KRG9uDQo=
