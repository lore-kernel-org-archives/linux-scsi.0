Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6175DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 09:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E2864E06
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 09:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhBAJFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 04:05:46 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:19124 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbhBAJFm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 04:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612170342; x=1643706342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FlJlYWBqT2xVJk9SXD3NtycDe1bhtcOzepCbQXWAPBY=;
  b=Kh5qnLahivU8kX4apEkm33Nrz8IDID0TnXqUaY8Azi8KoIhsL2yyPrBJ
   R52ZLYZ2d8nlZJekxT4Ff2lUPRY/YfGQItqfnEBpaNYeJWHtRcMH1RKkp
   GhRy9yeTnE8dKa43IgQFzwFQ7Y4eVHh3ro11pNNb6134PsXX0p+cfrEeo
   LJJjedAMXtEFpwboTGWW+cXWl8VeXyOgjRa7eWZS3LGKqPV+vzORM3HMo
   Jt7UeJyArTpWKCLTpDynAdE/NpG39DK/5o40RPagXEMrymJQEhhgvlq19
   tiBG5fTVupjYecLLBBSa/fup0AP/kXrWeoUGMrgy79LKR3Vp1lN/pPIwD
   g==;
IronPort-SDR: 7DV0/L6kw3t432Lc87FxAl99tMVqUS759l9k/p0WfV9SGwQWZ41Z/9RgSmB16XbdsPt0PRp/FJ
 G9g3JCgGkMB8XhjJXtdeGwqDQNbDqSnNoPvzpwK/Dqt5QP1ol8XAvzD5zAP3SF4wEKI68/Jc3k
 XLihh+RcqSJiVdn37Lg6029n2aAxyeRzSZEYxLZCTTrx1E9ihLxI+LzUExhDsghLhGJ+0vPbkE
 mJBctZomSzzi/wUg+HzSzIT59V0ZGnX9QcBTIyNLLu8ksy7QOxeZ0rylsRlYekO6k8sk5mGva2
 Ci0=
X-IronPort-AV: E=Sophos;i="5.79,392,1602518400"; 
   d="scan'208";a="159980354"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2021 17:04:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+uhxXaHirC/iAaHtUtffChRtejHyydAHMfh3f3dfa1+IOVuQkI26BmrzoD8dryc8eyS166fk0ZJVkeI+NMHZzI9n2lVCXzL7JkzkZeg48VQTCL6tPmbcTBxGr6BOn/ciqKLkOS9TbvhnGQ7YQOqr5WRke8bO1Cqb74llsrwvw2ebvyzyohX0oe7WHizEoy9tiOMwAlC6VHKo/U4Cg0SAVI89Tu6L153KBrzJnyyePDm2+olcU7cYZ0JuWnFzal7HLqDwTP0FV+9QiD4lulanZ6dIpHwsJhceaZpMW3W2EG22vsUwFcI8Ztxur9fcEdj54f9ow9xMaWH/GIGjooG+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYIqfB9JMQX7uwCi7tn5KCb3Qt1sEZc4qeALvBzF8Ec=;
 b=i5URx/zKrpz7rruScRq4RVA2319RzsNIozv7sCycwF/e2jEf9SU/gB7KaFdKcD9piNMeVsu13KBPkyKSrDrv6Dt1WbUZWu7QIl2NsHBi/3GJRwoUiBQhV0Edtn304TtDSf+9bqmbZ8dbYpORV0A08uvM9asI1ztMwNuXB8TN7mFwpe0w8OkgpXYEDrXjTsj9saEyNTUnsOZKnH4q+013S6ttwWW21RpWH9QXpbT/hbHmf3+9+OyWB62/ljDIuJEuzbhLI1LcrKQD+54o6NKdnlTfS/TnxFWz7G2aBhapYzORb/Juv4ycvyS/LSsK3pMyNBlbEnPnph2SRXlJSd2wYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYIqfB9JMQX7uwCi7tn5KCb3Qt1sEZc4qeALvBzF8Ec=;
 b=GNrbbMP9m+edNpCRKbiguK/0s9pS/PPQNeUDArz28CF5qeZBAKc+sUYEm6SjxvEto0gzFkNKX+0nQ7OUiDKRf8mKCGpY2FvVQlROOfgbzAzny+tkOPd5QzbBMzJxu4HiCFNJ7NSYYrkmQdIbhWPVCrXWaaVc/dY7bApDH+GX+Do=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7001.namprd04.prod.outlook.com (2603:10b6:5:24b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.23; Mon, 1 Feb 2021 09:04:33 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 09:04:33 +0000
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
Thread-Index: AQHW9L7x4iaxfLLWbU2VlJGMVSiCUapCsZUAgAA24sCAAAZggIAAAoYwgAAF74CAAACgEIAAC3EAgAAFavA=
Date:   Mon, 1 Feb 2021 09:04:33 +0000
Message-ID: <DM6PR04MB6575CF8DE63C22D0615F2608FCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-4-avri.altman@wdc.com>
 <20210127151217.24760-1-avri.altman@wdc.com>
 <CGME20210127151311epcas2p1696c2b73f3b4777ac0e7f603790b552f@epcms2p2>
 <1891546521.01612153501819.JavaMail.epsvc@epcpadp3>
 <DM6PR04MB657521540E2769C5F1BA2BBFFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBeuK92cgBkvYpk1@kroah.com>
 <DM6PR04MB6575018DEE12E7A5910FF2CBFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBe1QxSyMBKSTJA9@kroah.com>
 <DM6PR04MB65751A2F42801BAACF073F6FFCB69@DM6PR04MB6575.namprd04.prod.outlook.com>
 <YBe/YjlF4GewQFi6@kroah.com>
In-Reply-To: <YBe/YjlF4GewQFi6@kroah.com>
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
x-ms-office365-filtering-correlation-id: a807558b-dce2-488f-3637-08d8c6906477
x-ms-traffictypediagnostic: DM6PR04MB7001:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB7001923FB60773A809A433E9FCB69@DM6PR04MB7001.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2BzDASGhPDZCz5O5c8/Yy+kqX0IhpGRtQP2WQZ/aTgozo6/QW2hVit2resUrHDuuRtcXADJvA+bN0Xz/AWE5/wHRX2rRxQ1fIZABi2DM5tTZO0xj2SluGUmz466xf1zCntURz6nS6vzr/r033zunKpxo8hW/Eq6IO0paOSEChrtOITHivhJxhl9gDQxseqAWwPnAaEEL0lKvgb+FkT89LKV75Ov7znmsWSwXcYwD7Pr28mRNpyK7Pwi7nvHls//Tu5942J/QEgsIAjoLXZ9JBjqOTQaBb8SM//sp5DfxLLzb85zklDioJU3j4sfq9X7AyMhDjkTYvBCsb87wO97TTs0EJC6BmXd63qWnDK+H/+9J4GC57lakKPYaMigaWcFMeLvuIg82TP6DbyuaLPLs9jFl3a222Zgec6y5IJ/KQcC22aDMBIy9cZ8xjj1VIEBhNrDSIWy9euPEqtLeOgL1bCQFABy8qWm/8y5k91N21AJGjo+p0EEGMxApy67cf2S1nRaJ4cHEgusBRi/xGvJTFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(7416002)(6916009)(55016002)(9686003)(8936002)(2906002)(8676002)(478600001)(4326008)(66446008)(5660300002)(66476007)(66556008)(64756008)(66946007)(33656002)(52536014)(83380400001)(26005)(186003)(86362001)(54906003)(6506007)(76116006)(71200400001)(316002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lB3lKBiEtFXEkUMog8aCo2P5T6Cd9fe05OoLHRrI2Z1O3a+4QWDfPC7RE1Ud?=
 =?us-ascii?Q?2ZcB+n2D+oqwATPS78aZ1JMdVfSnuH3axOXTjHEJ8+yiJYR8iw6VJBSfJ2rb?=
 =?us-ascii?Q?jR8C63blRFbzvJ6pa7v3cmUPOEGzZbffWtokoi69hLz6+I6JvQlQwhnyrcZw?=
 =?us-ascii?Q?8vm84Aj8e54H4zyA+u8hkVQSYt2wYTXsml7EDPM/oAwruUWUV/++bppcCVuv?=
 =?us-ascii?Q?YlSXTL+aYgTdDf3iC8LCrZORpe2KJfSj5prIa3Uncxm44gYIqy1vnIO3sPC+?=
 =?us-ascii?Q?nbXuXgWpkTZ9euOtN6GbYmoeco0Mq7jYuoLt59wHMRVgBfeLZ2S3v4Ejb51P?=
 =?us-ascii?Q?CDGKJACBzPXkTLDXCGqKoBk8K/j0uehYQGNONA2lVDdzhAToDrLZs9Xgc2Mf?=
 =?us-ascii?Q?7D2ItS8gYiF1zoQMD/WOGZu2y8ZL7N8Q8YSdBdViRhAjfcJscqUbacPvGnH+?=
 =?us-ascii?Q?PbVCL3EqUUkcAfpAAA1YpeDU+eNVPx0J0xizcHxX2pBXgg0JS8nLWXLMk6E8?=
 =?us-ascii?Q?qvlFjihMYCOXx8NhzhqQq4ME4eW0izTxBJyHQAmejRCKPhGmx9owJdA9DFUi?=
 =?us-ascii?Q?JQY0+sf2hZWdraO35WGxCcRkwysTpqi0tfKniWcpav4Oe6pOOrXsWSK+x1t1?=
 =?us-ascii?Q?cS7CGeVBLra5AfX+7Fu6PFoFC2fBD+kPhle7mqZ+kmZ+tshUm5q+PH5DcXeV?=
 =?us-ascii?Q?QrqmuQec5S6J0MeNIQpQwTLcrf+0DBafcpXURhFsC2r+1nDingG0a+K55qak?=
 =?us-ascii?Q?qgrpfvM5A5EZ5vnO7sTBenGo2dyB0NNHXaNcZHd/StGqGjHqEsXu9FKn7pBZ?=
 =?us-ascii?Q?KbQUwJhAaM47Ajx+Qn4zl2mdGfQ3/osEhfYky/QmFAQLjGMOY/MMzjY+tWAv?=
 =?us-ascii?Q?PKCPofp/YCsu1WR2LvmGpa/q3Va/d4guRhu0/Gp1V2AH4xdwe7lzj7SqTV0P?=
 =?us-ascii?Q?GPda+4OZFFxumhtbg/haHNIHM716UsNAAfcXnlMqU1WDzudVuUVUx5Wroojk?=
 =?us-ascii?Q?uFRhTu/kO5nlCRpVVkh8Ng1EMewZfmxGnLhto0lXycwAbiO/TKhHNRbtUxsz?=
 =?us-ascii?Q?aPPEMbZ5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a807558b-dce2-488f-3637-08d8c6906477
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 09:04:33.4665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Rjq7B9QevPILJ++71/H5Ew7LHAe3m70sNpwqghvuxymzEkot3d8pFu/2VML7MSN/Pl9vT7gN3hMv0HgcEE9eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> On Mon, Feb 01, 2021 at 08:17:59AM +0000, Avri Altman wrote:
> > >
> > > On Mon, Feb 01, 2021 at 07:51:19AM +0000, Avri Altman wrote:
> > > > >
> > > > > On Mon, Feb 01, 2021 at 07:12:53AM +0000, Avri Altman wrote:
> > > > > > > > +#define WORK_PENDING 0
> > > > > > > > +#define ACTIVATION_THRSHLD 4 /* 4 IOs */
> > > > > > > Rather than fixing it with macro, how about using sysfs and m=
ake it
> > > > > > > configurable?
> > > > > > Yes.
> > > > > > I will add a patch making all the logic configurable.
> > > > > > As all those are hpb-related parameters, I think module paramet=
ers
> are
> > > > > more adequate.
> > > > >
> > > > > No, this is not the 1990's, please never add new module parameter=
s to
> > > > > drivers.  If not for the basic problem of they do not work on a
> > > > > per-device basis, but on a per-driver basis, which is what you al=
most
> > > > > never want.
> > > > OK.
> > > >
> > > > >
> > > > > But why would you want to change this value, why can't the driver
> "just
> > > > > work" and not need manual intervention?
> > > > It is.
> > > > But those are a knobs each vendor may want to tweak,
> > > > So it'll be optimized with its internal device's implementation.
> > > >
> > > > Tweaking the parameters, as well as the entire logic, is really an =
endless
> > > task.
> > > > Some logic works better for some scenarios, while falling behind on
> others.
> > >
> > > Shouldn't the hardware know how to handle this dynamically?  If not, =
how
> > > is a user going to know?
> > There is one "brain".
> > It is either in the device - in device mode, Or in the host - in host m=
ode
> control.
> > The "brain" decides which region is active, thus carrying the physical =
address
> along with the logical -
> > minimizing context switches in the device's RAM.
> >
> > There can be up to N active regions.
> > Activation and deactivation has its overhead.
> > So basically it is a constraint-optimization problem.
>=20
> So how do you solve it?  And how would you expect a user to solve it if
> the kernel can not?
>=20
> You better document the heck out of these configuration options :)
Yes.  Will do.

Thanks,
Avri
