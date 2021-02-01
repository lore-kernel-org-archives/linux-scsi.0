Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4A3C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C43B64E2B
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhBAITL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 03:19:11 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11977 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhBAITI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 03:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612167548; x=1643703548;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mMRoUjVh1OEjwCIvIL0LD2JLncQ88rRCD3+tNng9CBI=;
  b=j2+IM876r0rRv3uMqt+KtY8Tlhyp/zhmDVoK/lvyfR1/VTBAdep97oFo
   AVsp67ktUBR2dgLqvXoLDvlxW2Wf+MnglDTNtevvniYSH3EhvHIbF7W7J
   3xKAuI+jjaZqV/CplOwsjwa3parX2RjV0A1jXAdw9HzSwi2GO4I9jB1yn
   bEOPCYDyylrqitubMuvjA5/0NpY5+At4I8rJmANUFMl3WhCDVjWgOiE3H
   3xhaaFldo5+UsYV/7ohBT/mGAHaD+a03SDPyNIdzqSqmM+dr+r7eng9U8
   jootyNUja/x4P4DCnuE92PvuoP7jNKzF1xlhYk7bMVq4/gx0A3pKobxuT
   w==;
IronPort-SDR: nxf0oLvu9T4nKVtgsp8lwmx+sh26l6qJprk0gSjfLnMGCry9h7U5x1k+K/1v2tZA2sefTUkV/+
 zZaKLdWL+cdz4y36/MEDQ/AOVa4HPNuR8M0vh+XBbyaVwnRdIQuTJF7ff0ewNzhQxOmEUUl7pw
 A3nfP6M/0rzbbfSmyDII8MMv9q0Y4Q+nNqsu5C3Doh+LUy/Jck0jMIs8+5B2DTeHKyC2I451jw
 lB1cMvBk17T0dGbz7rYrL48/tpK4d+FxSMUGrQ/ivOOcJR5tk6wJ7/Yd8wtUn7/noqprKKIoya
 KJU=
X-IronPort-AV: E=Sophos;i="5.79,391,1602518400"; 
   d="scan'208";a="269205300"
Received: from mail-bl2nam02lp2055.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.55])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 16:18:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AM6W/gYumtCCf5sjPRappHPTW/l9a7bYWPptu3rWM97QieMkFKcWsA6SLv/G20fa/4qNng0WiEu7u1VChfLzWojBiEmsN2rMWWmHZk0cZlFkaBcGSOFyaRR1stdOjYw65ucr5YCTernkC4CxtjEKaJMRRm958BwXs7WRMNptjRXIbQvPSH1Gayb5GGFYq0IRGax6X0PM98/lofK/Fc3JOSuhAIbBpvHgS8eXN+cfRjzBg5EeQGujV3Y3ynIpjdIl+RJe23Uc2xNe+5Jjz50tNxTCImgpynH/Zw8WPyew19jmm0DKHr2AC6u6xRTp+H0Bm6h/VbK66Wdx1wsOT49mDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJBxjdicDW3wL/SjvfeQ1cNOoH8XZM2a2nLFPd3rS8k=;
 b=WlSPuc18A+gXFFxPfiPtH4nbLIJprFz+uoXX6PyYMgVbIP61D+tQTR9AZDYxDDSaBcy5Y3YaHPEdZz433sBeAEVgJjM9wQHXGiNQCVw0DCHRzjHWr0CZ7c8KZl4pZ3BIWfLJRSwcw1ouu+t/WVeHiEQSed+CvdPh1esFFZH4+/oahHS0euarJ4ZxTjXN4QcuPPjgRb8uumJvhyxQ3AIQsgS6DI9EVWhlhXrx9CDo6wA1OgKgOQ4w4NbbqPWDmBalTxhMrq/xmw56N9Ax9kep7OjTgJ5YEHhcdsunPIY30Yf0LzGvs+RFFabEg9lUg/G/TvNmKPSiZDU2loRXSY2csg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJBxjdicDW3wL/SjvfeQ1cNOoH8XZM2a2nLFPd3rS8k=;
 b=0Abcjj5YTruuXZcgtuhzZeN3jiszOLgRhq9oZLhxsqiR1Bfezg0GYW4HiVtxZQbTMFMimRwLbUv4nlZdyYr1uXDvT8Qd5akEhww9GzciopiLjdhY/QfQJu4slFuBs9G1SEwrXhXfi+Mrid+c6htvaJCla2A6HvJjQSLQ9K84QY8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0733.namprd04.prod.outlook.com (2603:10b6:3:f8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.25; Mon, 1 Feb 2021 08:17:59 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 08:17:59 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHW9L7x4iaxfLLWbU2VlJGMVSiCUapCsZUAgAA24sCAAAZggIAAAoYwgAAF74CAAACgEA==
Date:   Mon, 1 Feb 2021 08:17:59 +0000
Message-ID: <DM6PR04MB65751A2F42801BAACF073F6FFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
 <20210127151217.24760-1-avri.altman@wdc.com>
 <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
 <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBeuK92cgBkvYpk1@kroah.com>
 <DM6PR04MB6575018DEE12E7A5910FF2CBFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBe1QxSyMBKSTJA9@kroah.com>
In-Reply-To: <YBe1QxSyMBKSTJA9@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 35dfd140-e539-476b-0f3b-08d8c689e340
x-ms-traffictypediagnostic: DM5PR04MB0733:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB07335112E4DAD555F3B2B85AFCB69@DM5PR04MB0733.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nGM5bB5BQY+vszYDjHkDU5wDhPS0tChZvi1C41Ew+XAbQuRVC+EffcQDh8kB2hpcmkVYPY4R7Ud6tYGKQ01321zDaAn+wkZ4Z8UL89xvaRG8zGLwHD+BI1GmUVlNxCgp9d/Oa7wFVaoznsqEQmyEVbIzGULcGY9o0s94psxWLV2dhlliJUkdkc7Ho54Jn8dcmBvIKAx0vJ7PeExcAOPBtWz/5MlsrfG9IQzF3FvqXIYyA5Wszy2hp5VHItvqsrm2z+1VNEjIZY8RZD4UXcj0kdoJ1e6UtwqXaTKa+jHpTIIIoWCxi2wl+9KXZBtaScfVb3+FQMGYN8y8+K/SWEOhUhKjrzbdWUsI96IK48WodYH1qdhqL//AAxwgCgUDEtni3EK5xhdhGSV6jjm0MilOy2Sn8Se+vTMVrLaGcTP3Xy61nY3gjbhx0+pkT5uw5vxR1EPMoNNzb40O9ukkHgSbY9Tw43N1gLyeB9sctK+3T+KWLxEAXWcp81HxHEtNGQ8V6rgweyLkGzHhfXfieuYrQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(9686003)(54906003)(4326008)(6916009)(86362001)(6506007)(55016002)(478600001)(7416002)(2906002)(26005)(316002)(71200400001)(83380400001)(7696005)(186003)(8676002)(33656002)(5660300002)(8936002)(52536014)(66476007)(64756008)(66556008)(66446008)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uSyXOQgHF7Ih7qdMHDgkp6mgV6dTuatpOBF0hmkDO7joStYhoVkPbmNuikTU?=
 =?us-ascii?Q?3W5IHYTqalv+dmj3R8JQwCDlH3mIIbysEVxahgd+KbMwbw2mO5FNszZoLrru?=
 =?us-ascii?Q?OBH0aprw8wJ6OXRZCfmHNxauflNfFE9GLtVLV97SDAn4pP2nA5uvE1DCR1WK?=
 =?us-ascii?Q?v2uvcAp2Qk6qOFlcsfRJifSxRwKOiXehlOd3DopAVgEXN0pci18aTnR0n3R+?=
 =?us-ascii?Q?mxrCgT7aTXPMrx4Bp7fAFJrq7rMZgPQKvN0udtX1+5UZnYj8Nqey8I/faMlF?=
 =?us-ascii?Q?zhuiUW77IvUCj116Jo0NdNfIh443Va+seLGfq3+RSyLcpKC5oBczM6QrjJH+?=
 =?us-ascii?Q?3ZiBRmVaDrxyB3Nhk40gH5/5MUVjM10r3E0drXTj49bNyy8fLRismApqEkf3?=
 =?us-ascii?Q?5YJPnziHA/5lpEPdntJshnVijs5RRdNObAdQjLctspIhkqBiKKNu0wQwcbGD?=
 =?us-ascii?Q?2BWo7Tc3hb1qC8sWvrEG8LPiaI5HPJVzt4f4AOHgztYaBe4RtR5ASKkxR3iT?=
 =?us-ascii?Q?AuYEgm7cp7cu0sbKmXOFDx5K8iw3O/USASkY4uy7qOUbWJWT/i8FPNcwsrwX?=
 =?us-ascii?Q?Zw6qrkfScyV1F/OSG+jgC7qa2WETLLGn5TiAazlYlSKaDWudnN9X/5ievKz9?=
 =?us-ascii?Q?nLPZUuM2NfNLyJDZauVwYFBajxPHfXE38peMCDMZz9qnfWHjUMdbBN93DW88?=
 =?us-ascii?Q?zoZlwyPNJEsmq5KblREEtZXctF9X+FtcVw0f++qpbuz6lAcR/ps91+61HVLW?=
 =?us-ascii?Q?+nSin0CTBOHA1AzWxdUrvQjcHZp9ooTiZALcGNDo7rtZHDdbLSs+AwsE8u/1?=
 =?us-ascii?Q?dRno5kODj8KrbeLCEmbAeJbkXcpSdtTsB4EGgRqdzZqmiM1ZQCgu7mVEVSbT?=
 =?us-ascii?Q?VmXONbZaysqaVPm3sqVx/TWRCpr1fSd2hvzaMRFdlSpA3UFnbmXxKAvsbpDd?=
 =?us-ascii?Q?3YXYHieWfh+UmhfsDGYsGrSbv6lse3tQUKePhMW2P+vLigrmlr4Jqt/kJAMn?=
 =?us-ascii?Q?kgJ+XHAb8xtmfMfp90ZY4+oRHZmvLx0P5o8wR5UzVpOX7v2WTIyVVAiJQBeu?=
 =?us-ascii?Q?s5iA8ZPG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35dfd140-e539-476b-0f3b-08d8c689e340
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 08:17:59.7335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 63GiuDalaQxAh2540+mbzZ9kdw3xS+epH1BRqcWLGeDDhYO9c77wPmFHevVV9StSm7GbLlNw0xeEbXrYvGpohA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0733
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Mon, Feb 01, 2021 at 07:51:19AM +0000, Avri Altman wrote:
> > >
> > > On Mon, Feb 01, 2021 at 07:12:53AM +0000, Avri Altman wrote:
> > > > > > +#define WORK_PENDING 0
> > > > > > +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> > > > > Rather than fixing it with macro, how about using sysfs and make =
it
> > > > > configurable?
> > > > Yes.
> > > > I will add a patch making all the logic configurable.
> > > > As all those are hpb-related parameters, I think module parameters =
are
> > > more adequate.
> > >
> > > No, this is not the 1990's, please never add new module parameters to
> > > drivers.  If not for the basic problem of they do not work on a
> > > per-device basis, but on a per-driver basis, which is what you almost
> > > never want.
> > OK.
> >
> > >
> > > But why would you want to change this value, why can't the driver "ju=
st
> > > work" and not need manual intervention?
> > It is.
> > But those are a knobs each vendor may want to tweak,
> > So it'll be optimized with its internal device's implementation.
> >
> > Tweaking the parameters, as well as the entire logic, is really an endl=
ess
> task.
> > Some logic works better for some scenarios, while falling behind on oth=
ers.
>=20
> Shouldn't the hardware know how to handle this dynamically?  If not, how
> is a user going to know?
There is one "brain".
It is either in the device - in device mode, Or in the host - in host mode =
control.
The "brain" decides which region is active, thus carrying the physical addr=
ess along with the logical -
minimizing context switches in the device's RAM.

There can be up to N active regions.
Activation and deactivation has its overhead.
So basically it is a constraint-optimization problem.

>=20
> > How about leaving it for now, to be elaborated it in the future?
>=20
> I do not care, just do not make it a module parameter for the reason
> that does not work on a per-device basis.
OK.  Will make it a sysfs per hpb-lun, like Daejun proposed.

Thanks,
Avri
