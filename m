Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB512C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 20:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54AF2074A
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 20:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CGJg6P7r";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ivorwUyh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgE3UDy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 16:03:54 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23003 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3UDx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 16:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590869043; x=1622405043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8ZSN6Qr5F4U2RZ2rbn+jKeqUA3e3njrlLuGyASCUpEA=;
  b=CGJg6P7r84rSv+I8qAcbmgdCJO7FINyyGVGPLFS8/IF2oWq86f5x/6a0
   45wI5iUDXRDCyciXCF6PKkgjQdlLgEheevymVW6q4++JQURQc6OwoTuDi
   WqYpEkiPot02PMIKrGhkAay2zmUt3J/ptQejVFhJsWqSoSewvw+JWJSd9
   nMi04u3UxAcw5tW6xv760okhcQYFpFJEVKDIQyqHydY3MdGH1RaR/1Ys2
   iAhZCWcKsGf8ERI9jTEnTRlswbh/n6c8KjkoLldVH+qWLcNLpa2hUPgHS
   FkhJYGCzPy53Mr8EYwLkarqu7CL7lTgtB6EY46pdfLaIlVvzb9vl6JL2O
   w==;
IronPort-SDR: OS8f++Se711KreTj2w7OU4qFmwZIg15JiKQqLxtoaHBrHH6va3Q4luifPej4GH67dQGPs9z9E5
 gBeD78eCx66J6/3TvULPXSDotm72HtPvwJj05gCnV9zXpRhmPDpnShjwG9zxWR6nN9Dx6NB4Ew
 LO9uYGud91UU5PKCu+WgcprmTX60QPYc4yKz50cPJ7RRJn+lrgI41mMv8iYPTVOIFUaEc3Rp9P
 DcoXB/rvjvz1dTt1CSMAf1L7o7YGUj6bK+goBiA4iDOXefLX+/DHGdAxiqxcuXSAvAu4j6r6yL
 JAc=
X-IronPort-AV: E=Sophos;i="5.73,454,1583164800"; 
   d="scan'208";a="241707238"
Received: from mail-co1nam04lp2051.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.51])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2020 04:03:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKwTEQWkDcx0kQjU3dfVA1+X6xjMb/MM5Fd0OoAPcgKS81Q9wc8b+1ywceeAqcc84v4bl9tbscxse39E1edvNfezKre9mX4Jeh8vx482/S5k6X/2q5vV1rqNJv7HOYu2dlMLwt1RxQTOSutwpnbiws0SqQ+/FcUTA8EaiJjNOSe8ZMkeH3MLM8zf288vbf0dyjbvW4SNLGs40MIcvkOai5sEtXOFShuqhcvXwjrBclk2DBF69qTZ5BmMUKrA4tDmNAZDjzUBQIWCNA96OFOM6NawyAkL3Kp9KiwZpmXCxtP9zNftc/N774Tj8LEwdFaxNjVLOhUp9ipF40cBEr2CBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZSN6Qr5F4U2RZ2rbn+jKeqUA3e3njrlLuGyASCUpEA=;
 b=g3y02Y/VOrwV2jP9Tvk1TsLLcFbnp4D6J8R6RR2Nq+jHfKbC1G/akZKqLj3yRZtN2wQAalL+CrGEn6bufWukEhzs6VnNWFRNyEKw9xsHqWiMZTO/4y0/5wK3VBBfsh3O+BdeNgJu6rZu0/QcVMWG10IwdKZnHpRhB6zXpu8xKalPmNdgKXTGCkM2m1o5XcJpT80bv0O5CbDQG8tH8WUNZQfQbL8keGk1kMBvFnN4ntrHYxW4ff7MHkPqEnIxoE4OcsEGPBTkVuNj0C1Aob0tQhABPGIYibY1nbcXBIQRj69s31mK4BMR2zJpEloDTHegJUp5/uFEp889noJBsfD88g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZSN6Qr5F4U2RZ2rbn+jKeqUA3e3njrlLuGyASCUpEA=;
 b=ivorwUyhd7nHxK0kTPpAJCff8toA/V3u8tDfDB0U2yLOQmS5QDh4Wd7EdYRvdpMTvyythJhaJj+8J/r7GOVDTov8A1V5XIlExogJRkpofxZTBsxdkXYxbsCTcJ4/lFQT6RnKB9G7fAusCFRrKyStNzj2QbkAqQfcc/9HDIQRtWc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4736.namprd04.prod.outlook.com (2603:10b6:805:b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Sat, 30 May
 2020 20:03:48 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 20:03:48 +0000
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
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>
Subject: RE: [PATCH v1 0/2] scsi: ufs: Support WriteBooster on Samsung UFS
 devices
Thread-Topic: [PATCH v1 0/2] scsi: ufs: Support WriteBooster on Samsung UFS
 devices
Thread-Index: AQHWNpT2nA2KBmD3zEe9LyN/iNuOVKjBDRoA
Date:   Sat, 30 May 2020 20:03:48 +0000
Message-ID: <SN6PR04MB4640B45DD91BA7191FB1AB50FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200530151337.6182-1-stanley.chu@mediatek.com>
In-Reply-To: <20200530151337.6182-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54c9124b-157d-4798-f84f-08d804d49132
x-ms-traffictypediagnostic: SN6PR04MB4736:
x-microsoft-antispam-prvs: <SN6PR04MB473603C2F9C66F82A7DC723CFC8C0@SN6PR04MB4736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BaWFgmdTBDEYIWjLLQwp5HFV5rA9iBRxsgqL8BWs4aKCZHnRG7tu35f2q1v/PpWpfMnR2/04g3PVVdMyZFkEp3SQYoQK8KTOPiaCQxqaUJxxLY5SrsUBRkPxysk6Ju98VIPK/EGhQiFNoA6tAP2nYaVfdEO7Q6kttrSUxXuIb5RerK8kFW5fB5qsu3LxDYnSrqFKvUc6NVsYpUeIeFj/d9pt8HuBChQVifoQDOJjLd9qhNiB1PGXPNZEMH7l6J45vZK0CTau93dW0kY+6J0U59qa41ZR1PyC/P7XD3NoSRNRMr0hg7DLRxWXVa+GPplG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(316002)(86362001)(110136005)(54906003)(64756008)(6506007)(66556008)(186003)(52536014)(4744005)(7696005)(66946007)(66476007)(26005)(71200400001)(66446008)(76116006)(5660300002)(7416002)(2906002)(8936002)(9686003)(478600001)(55016002)(8676002)(4326008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: B2qL6bvGpWjCLKpCOZq9jvBKre4QEjeZ0NmWzO/tnDNqwNjj/HmAOn+h79MJRqlh+fvsuSVwx36IIplTQDAkcgS/hMoQGJjncyQCoRDOzjkVSJz2A+yMPUsvJ+SgC6epBMEFGDx9E42eyqm5qx3u/Viw+lh1dQqNRdqQ0qehSTOQEpH5kFig2NbVfjE8/BopOLm8lreyuyApEy8vlR5ryYestk2g3ZWzGg/uioqabIpniYkDNjYiMcrqMwfJaqDak1lPCUhyPMbazdAW3kXXXpRPJzOoWpCAyN5NeEb1xVHCHApP3Lg9SDR3Pn/gVyuFSNgaSmnr6+LVhJf1QC8LyONqP7CAwopmEiS1I/eSFTy9W/9IuTpw/9LMxTi50WORMQX9q52JpZhmOvpzYOeqryawUp3X+Q7+THe8hrT7kSbv4aSFvwC0DRpW49HX2oVyAS1+mZXCUXYSsSIY/efRSZuHYnSYNteJFFGP76SvKCA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c9124b-157d-4798-f84f-08d804d49132
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 20:03:48.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kLTsl/uXozQKmUQGdl3MlsvQvrb92j6V8McST00rGLSFMi6z6GlYel19gerwt8shtve8N8BlN7x4DqDDoP7FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4736
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>=20
> Hi,
> Samsung UFS devices are widely used in the market, however these devices
> need some special handling to support WriteBooster. Introduce a device qu=
irk
> to handle this special requirement.
>=20
> Currently Bean Huo is doing some nice cleanup work for device descriptor
> length so our series will have merge conflict. I would like to submit thi=
s series
> first for review and then resend with conflict fix after Bean's series ge=
ts
> accepted.
Maybe better to wait few days for that series to be accepted ?

Thanks,
Avri
