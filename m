Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF44C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 05:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90DCE619EC
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 05:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhCYF63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 01:58:29 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:30676 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhCYF6C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 01:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616651883; x=1648187883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZSwYGqsTczj/anRVB5JTuhJPJieVYDN8fetAvpSHzV4=;
  b=dtsR+l969/32Iro8LQV+fzF4zuJKQT8RQFkSnwwzLH4zIAyX5aNQt5pn
   3KrG++SUdXFpiFHcIcazIF8DbUpX2ijCJsoLM6LyJj7pfIMDMNtz8N0XO
   lhy20cv41UNmKLUbVu6jzZ4J63cR4wzT4cB8CoSK+45ni7NFo+FXpH2ZH
   gFwVFgXaG9E4eTwdwPiHDp1gGGvrmgtVpjzT6+/IyoCpg7FIifWd/OaGP
   /GVTLs0rv6eG+lpMV3KsycGmaIJ8PXFYX6MRyHh5yCA6Sk58hke7NSS3X
   sh3tIiSRFhyO60v+C8b4yXnPczOqLwFHwVNEmiuj8trh29uGx9xwwLnYd
   Q==;
IronPort-SDR: m+bGFo1yKtUTcTB3MZAv7XKs+/CZDsPCe9GtDUtNYDAgXpp/g96p0xE8ht7FOT39kTzpudJ0wU
 NEP5vYAokYEXZD2kMMQoQPDthjfSJgmBIqtFRFowE343SnJ5LIwwpt103pvv3+epuMNaRnCs5C
 kodOPCRfauYnXJ3HNuzZLXpgTmeCxwT4sNFZ2NX4gFy44KhtUke9rVV8lmVUylxfSE4oYwJyG5
 tqXDQyTgsx3xKi/luteCXrwBH6o+hrEgAYRHDCIaxPrVaimw/rGHeLFDABkS19x691C/MDqtDE
 Wjw=
X-IronPort-AV: E=Sophos;i="5.81,276,1610380800"; 
   d="scan'208";a="267381864"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 25 Mar 2021 13:56:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gl00qYN3rkEor5J6WE4L6ctRkwTAg3GPvWDeEbdpSJcVsDLb5mInlGzN9yCv9DWiShNDOZgukliBbM3sgWcpC40oYqAMFRuwF9O7RQer16Z07fwLakCd4PCz8cZwJC7iZ+QJGbm47fMoxSRw/+kZZYkqiWXfu8Tmvxe8voNmkSIR1RQiXzTygvqPELEfI/MJ4YMvN1m3XZU4QkEkBttY+3aXUcb09Sx1exFslEE00AWwlheCD/AFHtyJjN7EGrJetQLPHLs1Ka/8HirYDw113myBoK9F3KQ6/FBCKZ5lD1icXpeZu2uDlge4OcdoDA3gvJqmYlfU7oRR3f6solNJOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMUNvUtinRlIRZEbVdE+56gi0y3L0hNtvwSOvvN30c0=;
 b=JjU+e5jZ5qIj7HvybWGEgGKFRzJsyyIwXUpgorup8kl2Udc3fLLnYQt+ETvMYUjCD54nOmPJKxkYHfTyVX6IlXMI5XaXZ/nViPNuUmQJiSqnW75LsjceaapXn4totpDuMM0JDQCah+EDkbo5p6CvJhMQNgylauY42gEzTfUX7DrojjHynCMDD/U3qEOo55qrAV94nBkCdTseJIsPfmd3ESaEKeCsPzl3rD9rClEMGiHpO4tzzvBBEvlNXURwLxTsD2JKRF8380qWBzNF0O3HSz1l5WdYb7lWfzHB2uUpKzP5+kO74GvS8++D5edCm0U8xGxPiAIAwB9b9Fa6ECFeGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMUNvUtinRlIRZEbVdE+56gi0y3L0hNtvwSOvvN30c0=;
 b=UbyXQK0cDzmH5yBwLi56wjmXQvMnHUB4SKJdF/4Aa5ILe7axEhD16GT8qlxM8RxOttF0MhVO1nz9vklIt0Nsg23eSQuQIe+DPpic8UplEI5C15Jq8/G2FT+xCiEJYwR3AZO9F387Qqit7K5GdUaRRQ22FAhpiJaoX4Dtblin/qA=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5017.namprd04.prod.outlook.com (2603:10b6:5:fd::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Thu, 25 Mar 2021 05:56:40 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 05:56:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v6 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Topic: [PATCH v6 04/10] scsi: ufshpb: Make eviction depends on region's
 reads
Thread-Index: AQHXHvMB0UyOx5FZfEKuIKqQy+zc/qqUMx2AgAABiHA=
Date:   Thu, 25 Mar 2021 05:56:40 +0000
Message-ID: <DM6PR04MB6575CC008E355F965A1886E7FC629@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-5-avri.altman@wdc.com>
 <b06c0bcc3ea51ab7d6b8e5fb46ed6bdb@codeaurora.org>
In-Reply-To: <b06c0bcc3ea51ab7d6b8e5fb46ed6bdb@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [192.116.177.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 074175d7-4a83-4c0c-0b3b-08d8ef52c2b7
x-ms-traffictypediagnostic: DM6PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5017B2B604480096082F0831FC629@DM6PR04MB5017.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AVHtOhqMC7BKL24hVp1WHxs4V8cLctizW5VrMAsYxqc3rAsdDoK5HhsbTYt8KvnAelB3X8A9C1SgCYTIOfBQ7xv+bPNL8wmosDZOu9vHB9Hc7YK0p2Kte7VnJVVCdEZz0T37xFk/znwxMqFO0tVxXE0Z4d99QsIK5L5zjmNorTfsohcfG8vauysCbK2wQCw5Z3aCB1oiUQZYqjmgsXmUzA3ghFRWdkkwgux6PlnjmRqq1dmIOOfVlIIcuxZS4iiytUNjP5aR63Js+P4VecysDGZbip0fWXQXbFhsfDtGW/zrx5cpUcy24a+TOGlUcNjOUnH6lF8h4u5DKnXxsHW2OJi1K09xp/WNRqFtxwV6t46PPFqpXBzcPKYGTu45akZ7RzBO85jXv9WZQ3l1L7teRO0EY2HyQJw5wmG5HKecvtjMoDTzJHLgrHh78xx+TTvIEPMzbyHZYd4MkKT7/ihvOYHol+zIqC+S1Rc63k1UsgWAdGw08QOlf1xaIXswQ0FhLFD8t8iJhkfnBXf4Uljmpnhsf9waywTDCS4JBwGvTH6uGzU7YOI6kaIPXXv6bU48kahrhI2ER1BCfDz5//dGoYijEpuAcIdYHpIUZP0UuRGeqDs1x7rwX8nXUxkE3hOppaq3siVBnzgq59UTjNiSi6OkOWgQCNrIWFTvIPUaIc0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(64756008)(66556008)(83380400001)(66446008)(316002)(76116006)(66476007)(66946007)(54906003)(7696005)(7416002)(186003)(4326008)(478600001)(8936002)(71200400001)(6916009)(2906002)(53546011)(38100700001)(6506007)(52536014)(8676002)(55016002)(26005)(5660300002)(33656002)(9686003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KYmgCvkB27zLQdULMEQ1pBeNQ4FxTLbgrndC86JgzSRAXCjsNGMou1QRxX49?=
 =?us-ascii?Q?ma2S6EGkDKfaglg0b3bHapRyKpy7sIP0/C2vZSSuABwpkiiJpK8aMH5+5sdh?=
 =?us-ascii?Q?pMybeQv29g030U2GT+sEUUwoZRMmaSL8wG2WrEtmUvPvWbxqZ+nsfYKnDRiy?=
 =?us-ascii?Q?Av4h++oXOLKTgU5mz9AJKlCPWbnc0JYX3o3Y+Z5dXEp5Zp6TBy8GZT8ZDwX6?=
 =?us-ascii?Q?dAopUl/glr2eR95NcwXS5Q/qUN0OfIQQCF2GpTVyqsjJ3M9WetNuJXQ8f0Ex?=
 =?us-ascii?Q?qA3rxZekUXq5/p1FXwCyfq/Kv+Ig3cnOiQ/mRnNNbUjcJiTp17IQCBQvKOwN?=
 =?us-ascii?Q?Cz/z9Pmtxkaq0A4CA9fpbfMnf7HF6mtbLJFyMdKFwkPtSp0sXcqW+NG7yV3k?=
 =?us-ascii?Q?JSckBS1odFULvjZXHztXh6bbtPADzRehhKb4ArbdfjNyJd8slaEJbsi+DRF6?=
 =?us-ascii?Q?SM3yJQqDSflHGAycoaQXw89HhNmczT1Qb2Oyy6QnoU+n5uPHcc+UvAP22E35?=
 =?us-ascii?Q?hZ2Yc5k7A4Ov4UjGC5BrIStwcRouYY2laV9EJ8T5C59hKMY98DIhNoKKYg50?=
 =?us-ascii?Q?4urnxgUyPCpK2aNQYlGXoRTyLnW0UfQffhM/2PeiSh9AUpbX1lFoTROYcUOP?=
 =?us-ascii?Q?9P/mUErzaC3688Miwgs9iIcXfBlUdRm9KT26GkLlo8MSTU1n5ev6TA6A0Q3H?=
 =?us-ascii?Q?31mJkHXZ3T4FRQyNJzZtcrxqExIy6TVj7785ZZrO7mT3Vk+4usYPZ+TfkYwL?=
 =?us-ascii?Q?5+WnTH306RNVrOcCndctZglEG6FpoCrGeqUAJQiioWaZgW7YqrGNNQFSLaOm?=
 =?us-ascii?Q?oi3i8YgD2qgv4Z1hPSzgdxab+nTwvijVf2ijg1iA77Y6H2olk8pMYDo2Krpd?=
 =?us-ascii?Q?4FSvYwSIh8jp3OnbF262FBijq/08N4YY3BBwxQv2PPaZiXTbo4sxMkqoeey/?=
 =?us-ascii?Q?3Rb53zT2kW/2isb8GrnjdD3vXiwB6By9qH6ZUibZEr+eIlB2WbPwbVfErqNV?=
 =?us-ascii?Q?/OktE+f/zdtDEzyxmLThNg84io1p18AF5ccmb9Hzoo/tzka1lIKfTnKdle8B?=
 =?us-ascii?Q?XHxY32NklBEgjbd9FNtytp9telFFjnWAePHo+TwNdfq3I9HE5NPY2Ouwg9sA?=
 =?us-ascii?Q?L/3e3Surx4vbhWxZh87vyyxkn2b0kd3NGOdeUo71LTLMtZnRlXhGuatW4+Hc?=
 =?us-ascii?Q?q7V7yCbIddhyRSzj7amLoLC7B69wksE10kEv4O/QBwTarixZCtzkMb8YTV6S?=
 =?us-ascii?Q?dKt8nj93f1NWZCjvtdOQAGdOM4t82nZXMtAWwM+3ldQLJDXtq65Wu4kGRmz3?=
 =?us-ascii?Q?vsvzcEMDXJwKYrduaPyJbbRb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 074175d7-4a83-4c0c-0b3b-08d8ef52c2b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 05:56:40.4464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mWC1MrZ8HEJ3dCU/9AZUj6577syGdsb3MbWfnONlogFkaqDS/UZriUN3CtUVoAuFL79xYgah0GWswV7htyKVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2021-03-22 16:10, Avri Altman wrote:
> > In host mode, eviction is considered an extreme measure.
> > verify that the entering region has enough reads, and the exiting
> > region has much less reads.
> >
> > Signed-off-by: Avri Altman <avri.altman@wdc.com>
> > ---
> >  drivers/scsi/ufs/ufshpb.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > index a1519cbb4ce0..5e757220d66a 100644
> > --- a/drivers/scsi/ufs/ufshpb.c
> > +++ b/drivers/scsi/ufs/ufshpb.c
> > @@ -17,6 +17,7 @@
> >  #include "../sd.h"
> >
> >  #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
> > +#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs
> */
> >
> >  /* memory management */
> >  static struct kmem_cache *ufshpb_mctx_cache;
> > @@ -1047,6 +1048,13 @@ static struct ufshpb_region
> > *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
> >               if (ufshpb_check_srgns_issue_state(hpb, rgn))
> >                       continue;
> >
> > +             /*
> > +              * in host control mode, verify that the exiting region
> > +              * has less reads
> > +              */
> > +             if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1)=
)
> > +                     continue;
> > +
> >               victim_rgn =3D rgn;
> >               break;
> >       }
> > @@ -1219,7 +1227,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu
> > *hpb,
> >
> >  static int ufshpb_add_region(struct ufshpb_lu *hpb, struct
> > ufshpb_region *rgn)
> >  {
> > -     struct ufshpb_region *victim_rgn;
> > +     struct ufshpb_region *victim_rgn =3D NULL;
> >       struct victim_select_info *lru_info =3D &hpb->lru_info;
> >       unsigned long flags;
> >       int ret =3D 0;
> > @@ -1246,7 +1254,15 @@ static int ufshpb_add_region(struct ufshpb_lu
> > *hpb, struct ufshpb_region *rgn)
> >                        * It is okay to evict the least recently used re=
gion,
> >                        * because the device could detect this region
> >                        * by not issuing HPB_READ
> > +                      *
> > +                      * in host control mode, verify that the entering
> > +                      * region has enough reads
> >                        */
> > +                     if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOL=
D) {
> > +                             ret =3D -EACCES;
> > +                             goto out;
> > +                     }
> > +
>=20
> I cannot understand the logic behind this. A rgn which host chooses to
> activate,
> is in INACTIVE state now, if its rgn->reads < 256, then don't activate
> it.
> Could you please elaborate?
I am re-citing the commit log:
"In host mode, eviction is considered an extreme measure.
verify that the entering region has enough reads, and the exiting
region has much less reads."

Here comes to play the reads counter as a comparative index.
Max-active-regions has crossed, and to activate a region, you need to evict=
 another region.
But the activation threshold is relatively low, how do you know that you wi=
ll benefit more,
From the new region, than from the one you choose to evict?

Not to arbitrarily evict the "first" (LRU) region, like in device mode, we =
are looking for a solid
Reason for the new region to enter, and for the existing region to leave.
Otherwise, you will find yourself entering and existing the same region ove=
r and over,
Just threshing the active-list creating an unnecessary overhead by keep sen=
ding map requests.
For example, say the entering region has 4 reads, but the LRU region has 20=
0, and its reads keeps coming.
Is it the "correct" decision to evict a 200-reads region for a 4-reads regi=
on?
If you indeed evict this 200-reads region, you will evict another to put it=
 right back,
Over and over.

On the other hand, we are not hanging-on to "cold" regions, and inactivate =
them if there are no recent
Reads to that region - see the patch with the "Cold" timeout.

I agree that this can be elaborate to a more sophisticated policies - which=
 we tried.
For now, let's go with the simplest one - use thresholds for both the enter=
ing and exiting regions.

Thanks,
Avri
>=20
> Thanks,
> Can Guo.
>=20
> >                       victim_rgn =3D ufshpb_victim_lru_info(hpb);
> >                       if (!victim_rgn) {
> >                               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
