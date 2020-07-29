Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7E7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 07:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D89D120809
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 07:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Wv9dy0fA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="y5jlvtoo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgG2Hcr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 03:32:47 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58150 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgG2Hcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 03:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596007966; x=1627543966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FEMJ65xFpG/Aay6/plLBkrCC0NjAQp4ZKqX6H+IhJLA=;
  b=Wv9dy0fAumD8d2zryBAkrGViJyKzPenPd89eTVKk7/pVczIWDReeXW6l
   qEj27mU3fmTQw8PSDa8/ZjirIyxQNvhbsqai0RK2avGlp8V8usdhHmQTa
   kCe6+gXBMnsodPFqV9WK8iVKa0NRcwl1QgXMCGOx2b+BdftIwApTZPgiL
   8wfCGrl6rfs4n4Bmi4GaXOhxs/NU15o89F8aj3fOd/kfAQPhmAUG7ikB9
   CChD8JZlP0Mp1KENlyuMsHEsHWBT2wbUXdGEazlmFJYS4POI9pLMBR+R8
   eBHOV+yaENtbztWVuOY0aL0Frb4mIuYT0tKOm4HQqlDvx+3MqEWhqX4NW
   Q==;
IronPort-SDR: sDekZEBUpNEFNMQFtpc5PuTF5ZuNLnIcDes1tt25gjNXMKsnqeaxTvB0X16FzIewmVkeihKgan
 F28lHF4twwePBK5c0Yt7VglgTT+mSW6C8uFJfvVqy7RATJcxEr0UO5Sdz5f6sxZU/ElGfM09I+
 iEqhmSgNBKqQhiJBogIuB3RODz5V5lXVDMUsjF3dPU8FrwH4xAxDUgoHCMaHUNWD6TB3vEX86d
 rRsTlpkIuVqLIl86hg/lQiA8+iL50XXH8smRSRyDeVJtseIwXZJilBvT3zqFQsaqH21S4/EXtc
 4KM=
X-IronPort-AV: E=Sophos;i="5.75,409,1589212800"; 
   d="scan'208";a="143628491"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2020 15:32:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCUWMNt3GbHziL8oV2vOZXHDguspOUG2TJrAqIUm1pd62HJic/to/4/GXpyBCXpibh69zly0wA8BcYfyNTB2nUwgZUtNAOncmwaSnFjz/Pq/nXIVQDEhd/qZwKPRuB5ZJfqcIHPTq4OOMsLvZszI8gYAaahb/kDUftEfW+XoJT7D+WwA6XJBLEfrhxsB9nLXtlueMNh6750b7VbfgrPkTkdBEMF81RxvQW7A6jHKrDIw2HxP9aTBjI4Q7SIUzlJ0UeALz5yAdkwJQvg74fI5b/CAhG9UlbiH/JwZan+EsfmF4Ak0FRF3skCSjAYNXp45e84ednd0emYTKilT8mSajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY3rt1hW8NT26O9DHC/O6rtuIIC0Zb4VLOLAJzp/0P0=;
 b=WbqnYB++WjNE19GU3nJy2VAbAmTpZqbzZeZKxtPI9nUJEDNXQeLlWeylpvmsKaTyhlGvan6mTa0RShYYuZEXI0+3Xth+jjIKcMwYYZ36XAw4/lDV7pOd5yvgGw5Jrx0FBn16G1nRGqdIKWeSHT06YQhO+SNcPUzyuCCiiMCbqU3Z2FByiQExbDOLakCX5TLjLs0kRwaQUPKVU55CQlHqcaQqTGum/o767/HA+ucNuY0Xm5Kx4u4sMUOwmNzH8jbGqNP3kRMkpE1ovMZGW1X5mvBXvCER7UvpCf6AkJxvVYiRw8v+2WrSmGPUhXZCkeF1ZCRpiMZMA2iMmfpNNturlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY3rt1hW8NT26O9DHC/O6rtuIIC0Zb4VLOLAJzp/0P0=;
 b=y5jlvtooi8w76dc0905w23Y5woFXHXGqvn/hK4ytjZ3NlO8jm2yV2V2ThPWyg4ljQ/cdUuLpQ4PBRD1CHkZT0w6W5USpzhtMlppeefir2hKq4NLkQhru9NufYjveRJb2WO4vLQ8QGLHc1OtLezRu9XS0RLqvg6XS02ob7KWY2OQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4959.namprd04.prod.outlook.com (2603:10b6:805:9d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 29 Jul
 2020 07:32:42 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 07:32:42 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
Subject: RE: [PATCH v1 0/2] scsi: ufs: Introduce and apply DELAY_AFTER_LPM
 device quirk
Thread-Topic: [PATCH v1 0/2] scsi: ufs: Introduce and apply DELAY_AFTER_LPM
 device quirk
Thread-Index: AQHWZWe+NII92fdsh0euLymi3XWlT6keKffQ
Date:   Wed, 29 Jul 2020 07:32:42 +0000
Message-ID: <SN6PR04MB464010C0B5D07A74CCC65E0DFC700@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200729051840.31318-1-stanley.chu@mediatek.com>
In-Reply-To: <20200729051840.31318-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 915e040a-31da-4deb-5166-08d833919455
x-ms-traffictypediagnostic: SN6PR04MB4959:
x-microsoft-antispam-prvs: <SN6PR04MB4959E2A28FA5C630F210B4DCFC700@SN6PR04MB4959.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FATQ1zQPgSBm3l53BFYWmiHgwOEkVDmcQRvSpuse8DoJAzMxwSxhX1zhmBaRAyZjukOqW7Vi1XR3tp74oFHF29tzRDNGzSBeXk/0GigfagwsQ+p2tzpEsQobw9GYh5JfgArwGGjTOGuXkGKC5FgfznCMV4v0E13m4IyqFcBRab4jGpKZLP/ZQu6a6h2khbpZRf9IiA6MuGDfn7BpWeLaglXG2nCqTCbRhVh0rONpa0j4W8ECjQgDiIDcuKSVRVgr93Fytp943kFVmtHj/Ktg6jQiWg4TwlD9GSN1jgSX2Z+ybeQFfHzO30+XFnX6irZU7/Js0BM8BRH9m+Uuy+tsOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(7416002)(33656002)(9686003)(54906003)(55016002)(71200400001)(4326008)(316002)(110136005)(86362001)(7696005)(52536014)(76116006)(2906002)(8676002)(478600001)(6506007)(66556008)(66476007)(66946007)(26005)(186003)(64756008)(66446008)(4744005)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DU6SYi1e39l07XIBfhytMcG0BEmbVhmv2D5uFhEXfGLrcM2InDx4zPIYx+oMjgC5LDHW+hDiKdF6xURaQ9zVxZlH3i/6XPbjeK86rNZ1IunqJ1yqC5hTxf0oSggK0CXh6rBQrXoe6VokstIbHbOb10cBKYKdiATnGRUtR2mPI5OisggKR9Xwy54RzLOyI2BbkJK8aIccSNTtkzjx2SZmssrFjBUIcseU7HPiPQk/XJAyeCMtHxPApW/j/oh8G1IgDzIeMER/XXyFgpkMR337sJgF4cVDIW8R1QLREE7Un+7J/rHD7EMK5ArWtSOg38mVpqzSLaSbqXjwvGWdZoBwcZmblrNjxwf+v+mlcm1VgUyJS4c2EZ5YbgAuBd3HH2XLF2D9hMUZzNk+wyicvsXEUDeF1N8lbiEfAzmJEFLqShrGbdXi3cDCg+dYDsSE7H4veZd9IzsXEtq4kASj6pjmFarZywh6o6hrEZniOdbhWIn5zj4uc7gkJ48JGIRHY8qnRyugg3slrhPrC+xDlPKv9Lu0+x8myIhiDKpyvWrE64s7/Y/kbq0LDcNqpxFR6+gp1xHvSnlQBrU6pP6Ti5YSihpAWGAtyCyRRfSVzjF/wRELxAPJ8Oy4y0BRU6J/OPS3YrF3mt7kFtMxawBucv9rcA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 915e040a-31da-4deb-5166-08d833919455
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 07:32:42.3459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ceuiaEfmaQStmnr2W4+Qx/G0R9ECbYsdkxrhU/Mgfy5S0TGiZk/wvM844HpIwSvY0D6K3nTYyKyDmQ/VV34nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4959
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks fine.
Thanks,
Avri

=20
>=20
> Hi,
> This patchset introduces and applies DELAY_AFTER_LPM device quirk in
> MediaTek platforms.
>=20
> Stanley Chu (2):
>   scsi: ufs: Introduce device quirk "DELAY_AFTER_LPM"
>   scsi: ufs-mediatek: Apply DELAY_AFTER_LPM quirk to Micron devices
>=20
>  drivers/scsi/ufs/ufs-mediatek.c |  2 ++
>  drivers/scsi/ufs/ufs_quirks.h   |  7 +++++++
>  drivers/scsi/ufs/ufshcd.c       | 11 +++++++++++
>  3 files changed, 20 insertions(+)
>=20
> --
> 2.18.0
