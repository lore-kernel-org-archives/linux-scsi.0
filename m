Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F8FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574622073E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dsOGLUac";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WPQ2iyxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389660AbgFXH0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:26:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33037 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgFXH0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 03:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592983600; x=1624519600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CKuAjE01mBcfGVD6h3MR9FNw6R+dRSoaL/Xr9p2/tIo=;
  b=dsOGLUac+9ToeSHnib9kTHKFNJ2TgPrg+RjKJfbdDIUbAvIBwiWMvpXb
   ENfKV2ySVGSHtHIAFfVFhzCwRfAR+N2Rr3WvuezJzsukcSBIH5DLM0b81
   HJH/qtBmRIbOA1jq97gK8eLCT3rIvMDq3kJ5dQPzE6rKPm7Nomq6hBaqg
   AcFcr1aHc5MxQzD0uDi4GsFq46khKoOfH4r9DurUh2WfyW0CfJ4JETixK
   LteCVTVKF3LlOl2T5KkxDeFv4whtcSPBOeFpBRa/Fi8CJLlFSUJ84GHrU
   uEFK7FfxY17c0SD/rSbhLRanoWhkzJZ7pKJDdzntRiFirRjZS0BpVM/hL
   w==;
IronPort-SDR: D8wMO0OW8lYYeeNc857GpGktbj2ns5YEtIr7Gf8Jqgd+vLd3ooUH+1IpJbnm3s6dJofem2qcvr
 xCZaNjWYbLHyJP7N5dH+I2pAUlBpUXY3d7Gp8gS1efKc3BwBMgA6EPRzmySmCstNZOgL5Geu3B
 ktItjvsOBRaUD65ZUSWLLGUpqDDVbYMXeQGZR8EtVBGWdG/vUlSbHXfNTacnfx/r+w3OI+RJNl
 eMk8PAJvtibJcC0ncoocit5r3OfcXfNvtaGbnnjRmaifFjwL/RH/aTCQF/Ga2pdbQ0rFCr0gfs
 iqA=
X-IronPort-AV: E=Sophos;i="5.75,274,1589212800"; 
   d="scan'208";a="145102726"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2020 15:26:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLEz+wiINV8UZ1uhObNx602dS8doeEs/kbJsSoYac4qcs+bz4Vajv2e37uRcMQOCNBc0BZ7T3XOzwDt51HPOtrILNqAgcPei5obrqPMXfX223hIBmSBNEIa+BIs14gRWlkcz59qqY0x7fPbzZCwYvAijGcdFyJ0aIO0abWgj+DdUlSq8abE3gZHMuFJ2xKPyyCCg4AjL9VE5hazt3+xhWv2NrsP0ElwvLnLeuq7Z3lPuWU5oL10NnGkMgK+l/HPzRa+YOCGYE9jcRpTEzkXCsS6M9uDVkOeD2LMJ/rUH19NiPWs+3IpOMZkuq8h/y77bPEcSl5PwQsaokr2/k3lyPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKuAjE01mBcfGVD6h3MR9FNw6R+dRSoaL/Xr9p2/tIo=;
 b=n5MaTcMxphtUXk4aUtQptbuCmee4FNKoXPLmskhJzG6+ywa+76fWrw9wI1tbHIyyIqTXGeevjSM19lvyuxYlsLCEfVh4K8vHcHXm/wJydK8UM+INaWky71o7iIdffcHqeH2cS7FhFgSF15nBHY3vkiYt97cDuxtPyUsoFXyM5ZGNfLgif4bOrZ4W4jSnsLtr/b356aeAEVoq4604zYYFMRGJzGps0AJpSWw+Qqtf7pFIGKszajPR0/XRU5km75gYbbcR1Q5fqmA7YAR/YwdOkfhEx2VCR9FWLNbbNICs7tZHzLMq3HfwsI2X97ZfeCgTrt1dQmevekk1h1CqFgpC4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKuAjE01mBcfGVD6h3MR9FNw6R+dRSoaL/Xr9p2/tIo=;
 b=WPQ2iyxIooAe+uqBpmnJ4yX89XL3DZFi+FHMnjdfSjd8Sz8jvHe/xu3hnAB6XCQ5TxxREgZGLdW0VvoO0sPgeQoeS2tmetV6U96yra6tZkmo4l6fH1pj2aJPsKkh6nPaRaQ2s+nBmMnxSdaxhNdG/A10M42HgvTGCXEVMkATPCs=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4078.namprd04.prod.outlook.com (2603:10b6:805:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 07:26:37 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 07:26:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v1] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
Thread-Topic: [PATCH v1] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
Thread-Index: AQHWSdJarpjPY1IvO06jKu22T8rTZqjnXcig
Date:   Wed, 24 Jun 2020 07:26:37 +0000
Message-ID: <SN6PR04MB4640974695F782566A83F2EFFC950@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200624025119.6509-1-stanley.chu@mediatek.com>
In-Reply-To: <20200624025119.6509-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a5c3b51-4774-4051-a848-08d8180fee34
x-ms-traffictypediagnostic: SN6PR04MB4078:
x-microsoft-antispam-prvs: <SN6PR04MB40780EADD30E232E23BBB4B3FC950@SN6PR04MB4078.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jxKxufRLe421Nbe4vumV7/l7qwT/HMoTKko6tLXx2dujGdhLaNYCMPJ2tnQBsYh5SYssLZivMjn6ZOAgkpcV2iJko2JyWCcMKaF2ej6IuSRbPjqhB5Gvrzpo7JYKu3+Fo6IazqMYHZZcq+lQsgbJwNU8qOUk0lMhBhLF47NxheB+O9N5DKaudPQlsfP+HQPNnvdadXHOagbcQy5youvux5gC6CHa+3XeIpFAcGRi4vY/suJ6bzdUukkTBT4EOppR+z6pV+oDRL+Tl7TK/HYg/Lbs0pfkWfnLAFAHhwpeHomauDmVWdjq8g3OhT7TBEPFIrucamlscAbBPX7gaJYklQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(76116006)(33656002)(66556008)(66446008)(7696005)(66946007)(64756008)(5660300002)(110136005)(316002)(66476007)(7416002)(52536014)(54906003)(71200400001)(86362001)(83380400001)(8676002)(8936002)(9686003)(26005)(2906002)(6506007)(478600001)(4326008)(55016002)(558084003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2daC3YpjQoAPd/MQppwTgFqyiVOoXRdQjL5czFX+XyVHqf3tbadK4H6ZcnPtpbe7Y5vK+vlZ05tTPSeMQ+lUnszGBO/CFij7wB9aK6hOoe7vLG3neKiTjbQuU8TKS6C7oFtYs7AOfOhqavp0qjk74rXhRvbu610WYxtwhEOpHo5WzDq6WkwnaBwPscRf0lm9Gajl+jiOOUwxeJLO1cwo4xHNTY58nfSLeb1YGpul1iTnuZbBBRs0IXKfYnPju5L0vHq50uskrfoVi5rXVMgRMj7nQ5nnhR9XpenB6m5kfQrx0nW8rtAyUMldkAlVKM/5eYCi/bZfCKBk0PK1OSjosc7sTuB2nWQIQiSjOQCmgxEF+YZiEZX3Ml77RK03byzuvGEYIrD25hwEIwv7yFqVs235bxqgPjXn4sVwnJbM3Z9lRSs59LBiOkotXVgmfgvVKZ9F8Fopy6CqHY2G5HqAb2X1aZberLG8rxZfsbCT86o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5c3b51-4774-4051-a848-08d8180fee34
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 07:26:37.1920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1OHhz8ODJixp16CqFHvZ9m8YPgM3UNgByNhF82OV8Yw0hFgygLgHjazomkmK/Oozjc2VCvqCjv+ckQwGiLULFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> If UFS device is not qualified to enter the detection of WriteBooster
> probing by disallowed UFS version or device quirks, then WriteBooster
> capability in host shall be disabled to prevent any WriteBooster
> operations in the future.

Fixes: ?
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
