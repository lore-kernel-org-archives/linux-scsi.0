Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634FBC64E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 07:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E112087D
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 07:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SAQSSBwG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="f6bdZXpk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgLAHCN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 02:02:13 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:19483 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgLAHCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 02:02:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1606806133; x=1638342133;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GxMZaX6lm0BqYJV4mguMmKnnIF6A0vkp/bQSCDTssLg=;
  b=SAQSSBwGjjxyXDh5TOA6UQF15XR7TcMbeABtPtE+6/bXYkNRBx2sefXU
   CxacmZPKBH18eKANvPb6s9D1tcZcMK1sMkYuxsBAd27xPrVD5+P3ObINQ
   wDw3gJ/nzgHwLj3gaQBqZm89/1AOdJ2XqM5gdWtwQhACBqjil8Fi7fGfV
   7Xs7qsww+qmmiQoL3aPKYaiI0B6lTxm3lG6/jyvsZaIrXu1WKppr+TDmT
   xbf4D8d15ADOSeXKTaV5nd+CDbFNn779VP+/dWDqP4IAd4bZrEQyIkPzW
   cqJg4elO5/X81MgPor/CrzJTtEgJBB5JKpCQ1+jyvxaQWTo93VaE7cpl+
   w==;
IronPort-SDR: nVlAcVRZjvj3gwmUMAZTPgKidJIpnjZocU2uXPk/GuVVe1oNwBbjA3FHTzX6YF+VdZ2e6zFpUg
 EgknvMid/g02GAkZSsIjmkJ6gim6wZNaGfl9ullFoZ6b9WiQpPOTSyDqmqSv8TkeF2izWVwNxD
 nnndbFAAVXOxv/Acu/03tHN1jwFM/0bfB0+1c1IKys3Xn643x1BtkU7l+Ab5KslPjPX+UxMBA8
 lLZdMqnVb94E+uqs2ZozbsndqPFbu23Hr/G8DA/O2QhtPLhvNJYZL3M54A7M3aOr5yHPIj8SYS
 C7E=
X-IronPort-AV: E=Sophos;i="5.78,383,1599494400"; 
   d="scan'208";a="153958471"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2020 15:01:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4YSLGoNOLkn2POF/VrCVrfA9v2i1Gh6fcqRDUVLGIupACsOFowJgK61fsTg9pFe2fQW1c2f9gsKUR014OvvxgVMJoO22E/lmXfTZwqqHtMAYKkKVm2ehS2X/fTs5EOgbJEwIEAqcsDhWqyvm21iEZyDuewNA6gKNMM+Hq9Ugw1kFhvT1kAbo7l5oY/L7NDtqE+mIt5cC5qOsu5wuqTFOzXT6eD8tCNiJsnzoNhNOwc3ZpbD8+lPxuquP2JpHc28Sy2rYvGSiAhZjSH7aYFz6URDH3kw7WLzkfOdIl7CaO/nAYPBxXJ9nurxriMATlRT9c402Iu3ra83rWCfFcipFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIq556wau+puVwL0DZn+szyRbzLSDk2r1dZ9y4lhq1E=;
 b=Ta3v6NT4y7cIHWXRtj1MNMV22OX5jI+kMVsFAvXoLP7q8C7KWgMuzT0mL+hVO0W1HubWcO4mYqbKiWnPQAe85toit3Kd0klZjAdi006pWe5/3GLWPxlUocN2mD6F04z1MlKtiJjE+V7crMaNR2h8xvuq8s/yg7BEZNIC5CB+qros2U/aB8TlEE4tVVv++94LfmOLVtkTyunpBN/6hX71c1NIvguKEZYrhsnRJSnwodwnyDjw1LfFVsXskjg9bNYy846GlMDZP5VRq35OG7a7fsVDRDZ+tpc5edfoGdDigSKEs3gY+qBQmsrvVph71RvhBLLbzEFgAqnOocUCf62zrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIq556wau+puVwL0DZn+szyRbzLSDk2r1dZ9y4lhq1E=;
 b=f6bdZXpkTq3ztfcoT1ubOvcJP6yQEgwYiyjuHlGKnvxf7ZkMrLxU5Bg08OSi094Jpg6WSc2CO84sLxqSeR/LEfulHZ/3ZlzQ6CbecSQRtcujvxeOaUIVlmKSWWFcVs0oXPOWvSgFtce2csgrIOeLBcrNr3xMTp3F0QCqjsx4BKc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6140.namprd04.prod.outlook.com (2603:10b6:5:12c::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25; Tue, 1 Dec 2020 07:01:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.017; Tue, 1 Dec 2020
 07:01:23 +0000
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
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Subject: RE: [PATCH v2] scsi: ufs: Remove pre-defined initial voltage values
 of device powers
Thread-Topic: [PATCH v2] scsi: ufs: Remove pre-defined initial voltage values
 of device powers
Thread-Index: AQHWx65onxXE/o6nwEmQABYecW9/fKnhz+9A
Date:   Tue, 1 Dec 2020 07:01:23 +0000
Message-ID: <DM6PR04MB6575D146BBE580B0EF1F995EFCF40@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201201065114.1001-1-stanley.chu@mediatek.com>
In-Reply-To: <20201201065114.1001-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5336c9b3-b5ec-4c30-4319-08d895c6e9fc
x-ms-traffictypediagnostic: DM6PR04MB6140:
x-microsoft-antispam-prvs: <DM6PR04MB61404213ED6AE6A7B09CDA7FFCF40@DM6PR04MB6140.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tYu03Iq8NM+T9nxn/AZi21r6cOXbtaexdHPKk53l/w42K+uoBTLIpYYhipH9VURCVFyaoAObA2sRXgijuFJdheUEIOYqgNqDStXKu6vkLv8tzIKg2NLs9ipPQRLbsAIZSgfbap1kFQ9bboZ51v4J48yxyQEofsnrFb7OcMiYR/jd9VDClrYqkLR+eY0p/Y2rI5SE9uUW0ovZXgOsQMJ3rVKi6Q9C9C1EyjfI/+cSTqd/YRmKBgyx6I++UWCYw3UAkrAGf6yrkJKO4AVGofSKtCNjtTsiwIC0we6XTZDbIDYbwp/0EfBXpApz8HvYtwYi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(55016002)(7696005)(4326008)(316002)(9686003)(86362001)(478600001)(54906003)(26005)(7416002)(8936002)(110136005)(8676002)(186003)(66556008)(66446008)(33656002)(6506007)(71200400001)(5660300002)(52536014)(64756008)(83380400001)(2906002)(66946007)(76116006)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?k4Br2qijvmg3GlluASUJq6rOFhk5mrlS1Ax+bdX28cpDNtFGPFq3BoynD+x8?=
 =?us-ascii?Q?qdxF3maHBAw6J39VET31VzV/d7tmT5BLSZMJrQ17w9a4Oa0ueaKCJnT3zOtZ?=
 =?us-ascii?Q?uqY4x3QmG3+U5w3iFrkyCgBdAezFGDtrzgX136hIrDzjUzLiW+hNMwPsUQMx?=
 =?us-ascii?Q?DyHW/tjHhZTlrj4OPpsLkfK7OSCBXaE67ZAl9H5KSZPVb1SmyjRkgicmla8A?=
 =?us-ascii?Q?AG4hRjrDxgHQts3/h+sHipmTvQzpiJZ0cFv83gGw/0xWmLskOdaeHoqhRe0q?=
 =?us-ascii?Q?4BiXRg7G/b/zBKZo1Pj0SZiqg1D4nuv3erUOf1qGAI6OCjvkPCWk3EGsTLFO?=
 =?us-ascii?Q?omWaEqgMfy2dW2A3ngTau837KBRDJ0l8b+FBNB051M5RH4vLKrj+sS/ckVAk?=
 =?us-ascii?Q?euT8XE4WrYh6xyck9F471OmRB4tXh9LkKERDx1bSgI1CAH0Zi/DA0qxLLDHW?=
 =?us-ascii?Q?qlqQpvWEh+eCDDUhO/7YQvfn6/Q0QHgdGWtMwmQWXIM8aNHbK8YgcFC1MrZZ?=
 =?us-ascii?Q?dq9FaA0zZqOI/DdXGyeGmteQz5XRntQyK21dycggY1mNR4rJOgJjMnrgc355?=
 =?us-ascii?Q?L+nuoKG74HG8ddsy5gEk8O3zDlN/1hMLI67+OkZQh1gdxqlJOtmbWw2S3vdZ?=
 =?us-ascii?Q?HtcTf0Ugw3RaiLzBJcigxswPsxcj2BLHeNiaaV2FQfrQSmWJMBXiuswn91CA?=
 =?us-ascii?Q?vlr9eiA+9PCNWrf5RxnIOCAbKdUyTfQ6YzHjb3RBuFWHWBMTYP50MZAHBArL?=
 =?us-ascii?Q?UQltAhymH5tX1ZPpIDxvNkgioLbXy56F+cJCDaRgnuxHmmsH9sT8qSrthi+e?=
 =?us-ascii?Q?BWRE9s0XbAPavq5FAMhUe9tPj0obunT4r8vC82rTKKW3IsUPK4+OhVhXRFbT?=
 =?us-ascii?Q?9DO8CG5ZI/muElQmvNgs2sSaXs71ltcB8fFdADS4bK7EsXgZNopEME6FYIAv?=
 =?us-ascii?Q?s86nKfo5EJow/uGp88OlqJ8fVSVyNpPcZjuHTIakWRg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5336c9b3-b5ec-4c30-4319-08d895c6e9fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 07:01:23.3795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rE0QYkk3ue8qX5NQR0XEuqagc5uf8/tEtrfXEK45DCeZFEd11QmdNRoQ3xIlHmEJGP4sSAcKcfsTQCTw27q00g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> UFS specficication allows different VCC configurations for UFS devices,
> for example,
>         (1). 2.70V - 3.60V (Activated by default in UFS core driver)
>         (2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
>                           device tree)
>         (3). 2.40V - 2.70V (Supported since UFS 3.x)
>=20
> With the introduction of UFS 3.x products, an issue is happening that
> UFS driver will use wrong "min_uV-max_uV" values to configure the
> voltage of VCC regulator on UFU 3.x products with the configuration (3)
> used.
>=20
> To solve this issue, we simply remove pre-defined initial VCC voltage
> values in UFS core driver with below reasons,
>=20
> 1. UFS specifications do not define how to detect the VCC configuration
>    supported by attached device.
>=20
> 2. Device tree already supports standard regulator properties.
>=20
> Therefore VCC voltage shall be defined correctly in device tree, and
> shall not changed by UFS driver. What UFS driver needs to do is simply
> enable or disable the VCC regulator only.
>=20
> Similar change is applied to VCCQ and VCCQ2 as well.
>=20
> Note that we keep struct ufs_vreg unchanged. This is allow vendors to
> configure proper min_uV and max_uV of any regulators to make
> regulator_set_voltage() works during regulator toggling flow.
> Without specific vendor configurations, min_uV and max_uV will be NULL
> by default and UFS core driver will enable or disable the regulator
> only without adjusting its voltage.
>=20
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
