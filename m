Return-Path: <SRS0=kzw7=DL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B487FC4363D
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Oct 2020 14:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604AA206C1
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Oct 2020 14:24:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SrTs7GWj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="tD26S+4u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJDOYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Oct 2020 10:24:05 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:4924 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDOYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Oct 2020 10:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601821443; x=1633357443;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zqLbPdfGk5rixwFxTro63TW+UGV31rPAAta8oQnm8E8=;
  b=SrTs7GWjIMGRsF/Ys4TQXZuLNZhLGxEEaVdwRB/iqmXcGHT0nwH5nThL
   QfDz8PJ8BcnHfifq8mLhq2fHt4bfpelZ+aADtx/QxTQRzpNmfkYSDkCF1
   OmK8tViLdzNIlPeu48c3PwEoPg8O5nWLsoCdu0wqj36dk7mw1HXMKgNug
   BmuNgGpMdKldmPb9zFdTphKNHWG8HuPCTXu06IkCZkB/3GdxELzZZjXNJ
   KT8KksNBu+OaIg02pIeA6HUGtm6Ch4DvyJCqaZ0XCqVaUkbSNywgdxGVB
   BOf9AHtPOF8j1H8KhmuRa5S5woYlJI6YFkVKJRGGPS2S0iMmATRyxYNfm
   g==;
IronPort-SDR: eXy+JtwEWxBhJ0H4eO9ufjGoPL7irwrYYYKTEK3g6qfZ3U1Ptk2CLYYVaxmcSoLhCTwtDP2xh6
 PsuTfDC5leB6OipoOL9NLpw+wkYjsxMIw+UR1hxnxV3kAorCcMRpKRStwgqG3/m79tbJHvfIEo
 oebZc/qAAyF+OZ9LsVRqDwEh82mk47ttj/H+GFVXIuQgodFme9Bw4iGtS2nAgtA18zHWXWnkPV
 I4zjH2BGYmBGpLLw+beZhjc0ygXv9Oya/oLuGgEVNTRUxJPvEsWve7/aKlk5O4qlIueCPMY2Tb
 u3U=
X-IronPort-AV: E=Sophos;i="5.77,335,1596470400"; 
   d="scan'208";a="258802798"
Received: from mail-sn1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.55])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2020 22:24:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyweHcWBKi7XUUtFYdZKc7chM5DZUjvb6wAphWTNiM+PGu4E/zue1nGt3gHaAEumWHCCzE9lFqD0UkQifYZQVI3SEWscTmq54GQtluhqdbSNzU6F8oY06qAMveAlbAm0M8TOLvvpCD8SFjxaJ/dgS1/Lb//gEBiEiLBuI4Fl8ytjU+sMYg01F2NPkwEPJxZL33VtUfgkdk/hTRQ/Ajxdgl05kvAnsAXhLrQ5D/wxDwu+3Z7ofxIUJ0ccz4cdOts2ezgsk/Ngdtjj6jMYsDFsYufF9B7/9B8/yZI0TyiWDCOH7pvNb9lnT5aeCdCzB4JX/nsY/JX4UM9QoSsfkVlbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu3tgfO/T2N8dykrVPnKANt8uviDON/lkzY60uV5OtU=;
 b=nvTaXRjTvm2CtRv6bnFbdxAE+vjufOQsUqNBLrEz6XUz0W57qUVT5Q8FYDPtfSB8c2C0gp1jlYugi1k56G5vBg3EvDkvhZAQZgZlS2QlwTQ+2n9+CpqnS68kbc+tmP4+jav79agEzViaCFemDQpEJ1v8s2ONtD70g2ZeJLTiOwpv9r0Mvj9hSdxl3amzrtp97Wrb45hzEr6au+IBcmHdv/P8oQmc5KKWKf6m0pSSS3bN/W1L8/xUUqrPXBiwitOQ9cjRd/5CHTP+Lwu6sPCEyICva685O4/FjDQWUgZmC+duzmtjEDth6cDNC8VI6jNK1V7BwD3cTzxeT7I4DeMD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu3tgfO/T2N8dykrVPnKANt8uviDON/lkzY60uV5OtU=;
 b=tD26S+4uqsaDRgZeqbAcMVTsSa5Fyimk1M/BnG1oNgHprgETiveVN6svv7E8YIf/KkYatqM7NuPUZae+FmvyxEIuuQ5pnMZMF4IZD83KhgaSHM0BWbL2XnOhNpi3R7YeH95bB80sty+S5qPg3KHGj+BHEl32ocmWRu0uAYQ6Zlw=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BYAPR04MB4807.namprd04.prod.outlook.com (2603:10b6:a03:14::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Sun, 4 Oct
 2020 14:24:01 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::5567:207e:4c1b:3ce1%8]) with mapi id 15.20.3433.043; Sun, 4 Oct 2020
 14:24:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Topic: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
Thread-Index: AQHWmLlX/36ef3l9WEy26/6zpaIUz6mHC2pQgAB29+A=
Date:   Sun, 4 Oct 2020 14:24:00 +0000
Message-ID: <BY5PR04MB67050D9A3EAC48B0F8060810FC0F0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20201002124043.25394-1-adrian.hunter@intel.com>
 <20201002124043.25394-2-adrian.hunter@intel.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 991cec96-5d4b-43ff-ef01-08d868712342
x-ms-traffictypediagnostic: BYAPR04MB4807:
x-microsoft-antispam-prvs: <BYAPR04MB48072DCF98D89F4455C7C31FFC0F0@BYAPR04MB4807.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IXaGZp+2gEMNZ0Wc7dkvBUXAMlYarjfdReecOeDbLtRZRIG10BrlWdYvFX93ECzmViCJ++PEOQRjwtC3el58O+U0kPPf/Cd2w8LhHaV/ceLSZpHWr2Gkt0ZBMec9/BF1i17ngRc6FqLWBFOcDFaoh4LmzfJR0x7j2dNSH5yQMivQb7kwjqwDVYrwmaziULDOt4XW9jGeUjHlOWl5uayMoAqp4bRoQ4YPjXdYiLUYf33QEo1qy2tic7oU2M3H0Uv479n/7hlC9ewF2xWkNaYNsxtZC7ptOFeMWqa6rdsjOyMd0ujlWRh7bEOeJyhD/ocb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39850400004)(26005)(6506007)(4326008)(8676002)(55016002)(9686003)(66476007)(66556008)(66946007)(316002)(71200400001)(64756008)(33656002)(52536014)(186003)(2906002)(76116006)(478600001)(66446008)(8936002)(54906003)(86362001)(83380400001)(4744005)(5660300002)(110136005)(7696005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: x/E9PBCj82YEOmIsXQEEoU0kvzKz1Z2Hg3AHSn2Qu3cnlAT+qldPs2nWEQZYpTlQ+Kl3cbPERoAwRlZhbeQ+LLMKIrRZfT8zQjSOMUUJWA1wAQHrkJAYnkJ7WX3AgMcTfti7dZBFMwnE1FxXsX72Rse30Ap/2GA7F8JetMs8/M0cUNiMRJi8BHew7urcAU6eqHPRRRf/n64cML9w2WJ+uV8NbmEp8+SnbkOc2HTLruxZLhtvobzUbZyyKU/p2pHC4f6219GnOM4nD/2s9L7SuStxo+AFnZysUaLQBCFm/+X/y2EGwZ7AsJqAtiPYOLkGbBY5a2JWSteXUSbDzhkPlqiGgsY+kCLqXfm5ThRVVS6ivywOWr55iAHtZvzTWCZyElhvj65Ku0Gm0mbfL8LXQ/w7AxCjXCbMrV1ctHy0lxAB7IWCyPNq5W002ZbgqhOJJr+C2QCRrTuM5Kje7atn+WgIl90NJVzhjfcImlYnKfTlttTL4isx6B2c2Yrg3aFxaTivMnQJws9fpTkq/RWm2tBfNBCnu1nuIQD3owBd5mMklE1w8CElRg66TES8vASiXOFdfh7GJJ13Hto/Cm9TBkyfEiLH0oKY5/4iQUnTlTJQ0/xm30T4lAarlYA1J5WHWP/o6lZIatmJV/NB4QilLg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991cec96-5d4b-43ff-ef01-08d868712342
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 14:24:00.4271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 75AZ7l5yza23ORqydL7ubkoreGhXm9AyYuoY0DLTTclR3W29oqQPD/4bzqpADuLLZzwTvhHeAWD+uZLT2M6mlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4807
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please ignore - I was confused with pre-fetch.
Sorry,
Avri

> -----Original Message-----
> From: Avri Altman
> Sent: Sunday, October 4, 2020 10:21 AM
> To: 'Adrian Hunter' <adrian.hunter@intel.com>; Martin K . Petersen
> <martin.petersen@oracle.com>; James E . J . Bottomley <jejb@linux.ibm.com=
>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Alim Akhtar
> <alim.akhtar@samsung.com>
> Subject: RE: [PATCH 1/2] scsi: ufs: Add DeepSleep feature
>=20
> > +       /*
> > +        * DeepSleep requires the Immediate flag. DeepSleep state is ac=
tually
> > +        * entered when the link state goes to Hibern8.
> > +        */
> > +       if (pwr_mode =3D=3D UFS_DEEPSLEEP_PWR_MODE)
> > +               cmd[1] =3D 1;
> Shouldn't it be bit1, i.e. cmd[1] =3D 2 ?
>=20
> >         cmd[4] =3D pwr_mode << 4;
> >
