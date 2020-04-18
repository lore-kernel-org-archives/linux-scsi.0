Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2143C38A29
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 16:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB9C42223D
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 16:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HNxxX340";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="R1B4h9ik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDRQAe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 12:00:34 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:64409 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgDRQAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2020 12:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587225633; x=1618761633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HlEpixWKamHd+fsIaVTDPF0+2BxrY+9Agnk1GpSmDvs=;
  b=HNxxX340PNaPk4fJVDoaGR5JlM5TyDEPmGP1xHYHvnfRAnnyebBjoWXc
   D41nNKVXzXk9PAb8NLhUAkzomUtCmJTivVfhvHFAmwk+W5DMi1Rw7yZKe
   uf6e/WVt3v+569gpSk/JjZVH8Ozlko+5/0pUFIR7Dp5vWB7nFgosjw9Wm
   fIvl7zh4+A0bIOozZRnLMZgxKHUhsztrrWxqjEYths+QK5cDRz57Cg1SS
   BwQM75X4Uj+HWPvgMEHnpfm9L/8HpCpBj5VlrxJI+c/IItuS5Ve5YoUbD
   7dAOgLCfbEM2CbXqdRN1UprDGRFKTMkuzs2fA0nxgyBEmbzb1fZSLBrGZ
   w==;
IronPort-SDR: wz1DpeAhMrPYGPRAQsv59uhkMtlJ3uOQVOWapKI0dNrmfafZH35DIoVkVT0meQZwKI6pKVLFes
 aree8JpajMyED3uRTn12LQcEbbkbiEZFeMUt1VWSJDdxHDQz6mXtCYs2oQRAh2f1+DY7zCAbpT
 0gRP5jnpyVOyCf+8mtpzO0iC1/f8qe+IIMmw8B0q+ZiHPr41KdCIm2BktprwLuPW7JKdi0BrtP
 lstXEAb+x4w+wayQaCBe2H8vV/cu0Y14W64GDwkM7MBFviNCmeRs8spgBmsnA9J4qJ9rpEHJGK
 fec=
X-IronPort-AV: E=Sophos;i="5.72,399,1580745600"; 
   d="scan'208";a="135623271"
Received: from mail-co1nam04lp2051.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.51])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2020 00:00:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF9e5farm8Cl7/9lZYofOQvE7DcRFj9iQLUrYotMZopnrh29F9Q/1nEpJHESPIVdmacd6NEoKnTgs2h66OjrfpoZPeeESUirerS6um/WADcUjDUsdK/dl6l6HcZnGKCSKrli88La54O9co82wDkE0EABk+eaQymdmhuBNNQ0fN6gsibtMfmMcIG4NCqnOBJKRSr184ZFdQuo+ximjG8Wasz/F7dSUL04S81iSghXfL63KsKCr6g7yTP2LcSb/S/H8AWIbFZCtWw/zSkUM2qHuQKhqP7CwPweP/yCW/zQaQYI53ZrfK0oBnscTQvICkZJTF05O9gQ7HUZccD1yYwF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlEpixWKamHd+fsIaVTDPF0+2BxrY+9Agnk1GpSmDvs=;
 b=GBkcpJ1fDvC1G0lu7FbN/Z3I6QmBYs4HDwY0JDSN4TaVvA01QdXZw7goOTzwDtv8MPvReDo/HySN5Q8p3IfD0UYabCFLL2kAZvSbXPjqeFI93j1zfBh7UjVRYqrjdL4HK8zssW2Q4V4lZkgH/X9VvMAa1OSWEo7e4Uwd28rkY1pyXktHnHXDKEO/zxL69RVHpHLaGEoVzqhR6pg1tCqfPIbWTaQnYzOWsekApp5WSSryVC3Fh48n0w7CrAvJt1BHa6b+4Vkasn4JJcbRVla6rKWszwai0j0M9WKHPH3HBcBGywbIVAdVJyjBYSamzFnAvthL0xlvNLew8hyL5ssPAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HlEpixWKamHd+fsIaVTDPF0+2BxrY+9Agnk1GpSmDvs=;
 b=R1B4h9ikGhnnha2GhDQtpU4HOR4uElzqd6kRuhMsbU50MSdVm5YQI6HTsI300n7Gc1BpFLaUy2RL8joOp9+ef4DRlU9HPrcG6UKrHK3ICYRr46hnkdYxxgDm988JgWupI6rXCD81w6NG0OBHlz4l2dirCEX78keFwW1TEhacly8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5134.namprd04.prod.outlook.com (2603:10b6:805:90::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Sat, 18 Apr
 2020 16:00:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 16:00:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Thread-Topic: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Thread-Index: AQHWFONyboJhjuJWAki6eibLTJAA36h+0jPwgAAI5ICAAC8qUA==
Date:   Sat, 18 Apr 2020 16:00:29 +0000
Message-ID: <SN6PR04MB464066C386886C45202E6107FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364@epcas5p2.samsung.com>
        <20200417175944.47189-1-alim.akhtar@samsung.com>
        <SN6PR04MB46402211952BC3D427AADA00FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
 <002a01d61582$72250990$566f1cb0$@samsung.com>
In-Reply-To: <002a01d61582$72250990$566f1cb0$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab9c0689-6527-4ee7-9833-08d7e3b19df2
x-ms-traffictypediagnostic: SN6PR04MB5134:
x-microsoft-antispam-prvs: <SN6PR04MB5134FB50C2B0BA76B315CA67FCD60@SN6PR04MB5134.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(71200400001)(66556008)(66476007)(66946007)(8936002)(64756008)(76116006)(66446008)(7416002)(186003)(5660300002)(2906002)(81156014)(8676002)(316002)(33656002)(54906003)(9686003)(55016002)(7696005)(110136005)(6506007)(53546011)(26005)(4326008)(478600001)(52536014)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlBBoQjGH+YTJjFZJ3KAykk478dpkMNOPqfDEglRH5X3q3sGvdjuX7t1Tk7aRvqob5RyV4/L9Kn0jaJ10AiG3QZHHlQBVpjr6RTkoyBalaXZxW82pxcRG4nfoVI8WNnsCp2VMre3YH0tpseHhaZ9Ue+7bEUY4b3nA8+WW4TLJ+KfbuZ8rSI0ryNtxzxQrxCkv4av4X6y0UKVSshx4ORwTyjQ9PH8584FVg7rUXAZ9mE+sf605tsRd0tD0bhQCsgAVtHfjx8rZov7yP6pnHy22Ly2WYpW3grr7XcN6mjtl4OFwZGkDAf8eshScybPbL7nU9XDx4PB5bcywAArXDdDYTHPmBe3S4/L+vGJ3on4ICdt9EKkjyiWpW4sXT4k6qsEdwiXWhCWHCtChZNjkVIeZzhuQTnhzTxGSyHuvlYRmeIGCH6AN7WfLYYyRMjSi+HS
x-ms-exchange-antispam-messagedata: 7jUD7gMPHSmDqI6eZGZfQjN4QGeBTh7bqGCtB3JBcQ3TEc3e5UdesLgqHLcGnQKdWtT1eXwWcHzrUeGugkofrxKN8U8eiDnqNrs4sPMUli5mlGw10vH28r5SircsbXQ7WMC7YRKFHLRaueEhi0UH4A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab9c0689-6527-4ee7-9833-08d7e3b19df2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2020 16:00:29.2893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62CMCHeOb9Kg46WQXgJ14MfjT15Avz7cCcOa7PyQaTDtZpIP848h/3KYWtLlaedEQX5jZ4YHbcXq7RLqOpGnFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5134
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogQXZyaSBBbHRtYW4gPEF2
cmkuQWx0bWFuQHdkYy5jb20+DQo+ID4gU2VudDogMTggQXByaWwgMjAyMCAxODowOQ0KPiA+IFRv
OiBBbGltIEFraHRhciA8YWxpbS5ha2h0YXJAc2Ftc3VuZy5jb20+OyByb2JoQGtlcm5lbC5vcmcN
Cj4gPiBDYzogZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNjc2lAdmdlci5rZXJu
ZWwub3JnOw0KPiBrcnprQGtlcm5lbC5vcmc7DQo+ID4gbWFydGluLnBldGVyc2VuQG9yYWNsZS5j
b207IGt3bWFkLmtpbUBzYW1zdW5nLmNvbTsNCj4gPiBzdGFubGV5LmNodUBtZWRpYXRlay5jb207
IGNhbmdAY29kZWF1cm9yYS5vcmc7IGxpbnV4LXNhbXN1bmctDQo+ID4gc29jQHZnZXIua2VybmVs
Lm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4gPiBr
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUkU6IFtQQVRDSCB2NiAwLzEwXSBl
eHlub3MtdWZzOiBBZGQgc3VwcG9ydCBmb3IgVUZTIEhDSQ0KPiA+DQo+ID4NCj4gPiA+DQo+ID4g
PiBUaGlzIHBhdGNoLXNldCBpbnRyb2R1Y2VzIFVGUyAoVW5pdmVyc2FsIEZsYXNoIFN0b3JhZ2Up
IGhvc3QNCj4gPiA+IGNvbnRyb2xsZXIgc3VwcG9ydCBmb3IgU2Ftc3VuZyBmYW1pbHkgU29DLiBN
b3N0bHksIGl0IGNvbnNpc3RzIG9mIFVGUw0KPiA+ID4gUEhZIGFuZCBob3N0IHNwZWNpZmljIGRy
aXZlci4NCj4gPiA+DQo+ID4gPiAtIENoYW5nZXMgc2luY2UgdjU6DQo+ID4gPiAqIHJlLWludHJv
ZHVjZSB2YXJpb3VzIHF1aWNrcyB3aGljaCB3YXMgcmVtb3ZlZCBiZWNhdXNlIG9mIG5vIGRyaXZl
cg0KPiA+ID4gKiBjb25zdW1lciBvZiB0aG9zZSBxdWlya3MsIGluaXRpYWwgNCBwYXRjaGVzIGRv
ZXMgdGhlIHNhbWUuDQo+ID4gWW91IGZvcmdvdCB0byBhZGQgdGhvc2UgcXVpcmtzIHRvIHVmc19m
aXh1cHMuDQo+IA0KPiB1ZnNfZml4dXBzIGFyZSBmb3IgdWZzIF9fZGV2aWNlX18gcmVsYXRlZCBx
dWlya3MsIHdoYXQgSSBoYXZlIHBvc3RlZCBhcmUgYWxsDQo+IGhvc3QgY29udHJvbGxlciBxdWly
a3MuDQpSaWdodC4NClNvIHdoYXQgSSBhbSBzYXlpbmcgaXMgdGhhdCBJIGFtIG1pc3NpbmcgdGhl
IGhiYS0+cXVpcmtzIHw9IFVGU0hDSV9RVUlSS188bmV3LXF1aXJrPg0KSW4gdWZzLWV4eW5vcy5j
IGZvciBlYWNoIG9uZSBvZiB0aGUgbmV3IHF1aXJrcy4NCg0K
