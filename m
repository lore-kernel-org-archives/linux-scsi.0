Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9383EC433C1
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Mar 2021 08:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5061D619F3
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Mar 2021 08:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhC0IFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Mar 2021 04:05:14 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:49216 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbhC0IEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Mar 2021 04:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616832301; x=1648368301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=74/q5XHQu83DH2XygilY8nivEJAK1N8vmehf5IGh4Xs=;
  b=Ppyn2Ci0ChZGZRu8aa6uaTwODL9ZzTKqmbTXd9lml90n4TxyobLWUP1t
   i6RMC96tvziY5M/quG6oFRVrQs5jfXtSMQy45dLJ7rda4x5QGcFyXT4Sx
   YJGekDErHL+kR5SwJdZIu5WnkYGRxo5HKRiINFdZgLOaUI7dkIQb9ILU2
   Edofd0YQQUe6IX5dvoKRSdiqK0GAKoUucYcfUxyWSmQH+oz3dtFcWqpbB
   2r3xOr+pyQm7/ctPqqN1+kPI63HgQTXpvIqOVpthF99U3l39MVOoDBACt
   IrCEISewN/sLdKPAsQP5DRlroLouA2zqyRMffH2iPOmMITsoBE5oFTnxT
   A==;
IronPort-SDR: /mOccSrUibMYxYwELQ3q9/AR03moq5eG9XZakVsZ+kS10Ql1GPUT3s3Hfx6km4+vffA4941WKA
 c7+INhf6jrQHj+K4/J27gJ87b4WU13h4JVcgCpW5yP0pdHOalwae4E12yNiY1tWICZ6F+1dcu6
 xjdY7aDdHHwIZNtRVRvGclmt6yJdWYVPxkrI+ZSOJ71KPOmK9v15qYlWVkiFIix3UBlRpmWMCN
 0bTchji/bq+eCvWgwpzfc2XFJA79hzosJeIe9/UKP2DsNEyGD6KiGugOsWSO/1RqErJYM+YWuS
 M2c=
X-IronPort-AV: E=Sophos;i="5.81,283,1610380800"; 
   d="scan'208";a="267558125"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2021 16:01:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dX0y5JUBTXvj+yXF3DenHfy7EPOaVsJ60aGBpFJ6TieVzOTuDhX9DXIi4JU9aEZl6UFWOP2hZyZ8myFdjm7UXOaFxw3b90YU5QWbjk+62WJs4JgytJVEU/htNxljXAvo3WDdM5spQXR9QdirdNoHQihHXBtYgMaiTEGCQUKgFnvIcV2Pa7OA78Osu+HR5pRVZ8FEyAp1+cBpKNiLmuNhehA4/zlgCiMzfleeyF+F0pQKe56ITxRcMJt6Qy3poReVIu9AFnbTtc1rBbmhrXT2prMXCrUcGfPWjWNI8wjtvdcHESZkGBTUAyku+gnmv9t0L+ZzgsEC6qcBaMrYPT5//w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sbGDacYi0cXIiKc95oeIpqlobBhuiUFSgDP+/X29QA=;
 b=OhDqO5CcVCactLuxLH12VJrkwIumlv0dBoLJVu/cK+N4cBncdKCaA8q6OU6VRrrp/D9ERu1CHbSMYj/6ADmlI7n1LyTHFbQ/EDVL8XLJn3XF6+9WMFKLYU6KTNGxbvQ78+FtQha79IWV3HWVSVi56usi3F+Bk7rob/AEaKgGOhHZqe/tVV62vy+f2TSi+dXnsvY7WXEMDEzc5ON1aXiKPXi4U5A6B6/ql1bJ0bMoZ/y0vvAs9X+olwuYUDzO6Yk+VBA8nrpaNaabFp4WKoXnvRIybFikkdH3BN1apblVmBV7a2EAok/H+G9PC//7cTxVOBDbTIiJv2UEwloyLv0FuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sbGDacYi0cXIiKc95oeIpqlobBhuiUFSgDP+/X29QA=;
 b=VrNTOR7VnlvfTjwJY2OqpNvibSLOHtp+ZVsNIDTLhVPtNFk0gkjVngAG0Fyo/PfkT+9i5xYKZZs3vbK20qpJiU0ATtpObUshNR1QNFmbOB2yQ148ktSZlIWjjyKqzlBZYTfAJb0zsBOZK10wTQemASCkQLV/SkGr19zTKda8Kks=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5226.namprd04.prod.outlook.com (2603:10b6:5:104::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.24; Sat, 27 Mar 2021 08:02:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%4]) with mapi id 15.20.3977.032; Sat, 27 Mar 2021
 08:02:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>
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
Subject: RE: [PATCH v6 03/10] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v6 03/10] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHXHvL+vc4JYsRlSk+QZni8T9rJ26qS4VeAgAAhScCABHz0MA==
Date:   Sat, 27 Mar 2021 08:02:41 +0000
Message-ID: <DM6PR04MB657536A30C2F0C35CA50C71DFC609@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
 <20210322081044.62003-4-avri.altman@wdc.com>
 <48758404e172e8faca07c3fab8a3bd5c@codeaurora.org>
 <DM6PR04MB65752DA7982142B85F82344FFC639@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB65752DA7982142B85F82344FFC639@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1774c4c8-b20e-480d-43e3-08d8f0f6b242
x-ms-traffictypediagnostic: DM6PR04MB5226:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5226C93797374269EC4D7E33FC609@DM6PR04MB5226.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWOOeBor4CxPvES9glzdHcVpRMFT5+OHMHHNTiSJqWvPq4XezlBdKBSqZ8Jn1XCNFEfFoDiu0Mmh51IHYmxJGA3yRyJM+PetVMgphV3hCm5wjt26+rXncPOg0GJwET17kTDDNuOJEScE+GE77cUN9I1E9aIJgGllFoeFNYwIcWyHsdFqFG9PRO9knbsl5SBa8cP/nuAdsUQj6Ro8rjZs67EGVEhsf0as9xpUOcwqBwkZZ2nr7V07hjhkLfF9wB2wjg0UgG/x9TyEhD8dz3d0VaesEhyUgoyaWPUlSAYgkJPmcm+vXOopsWD7f1PRJlD+6cWoKsK89E7qUATElhRxR1IFIGo2WmojNN612xVsTD/6a2aJeqZQXm9Bs0fcjpPF1gmhq8TNGhJpz9uX6qot/kcp5G02+NHOuLR5Ucc7BT8GILT88d4Op1vTXl11VRBAnG6tMlEZePsLWDOX8UrdvhTheKyp0kpNCSLL/lvzlT4fVuiHeRQuHSiXea1myRFm6WXVOjzC3LMjnGY/y2GlBcFSgo5iJceOWDHG8uqnlM8Rvh/UBZ8KKqq+c4vmsC0zCJHAK4MsZONFa+PvO76Dw4T3LwsNRCYp7ryfKAXoh3QwT5ykPKdJva0mwF97fM8OBOEvOgJxhxyDvyUefAsbbxVCoVFXw2pLm6505uaahUc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(110136005)(38100700001)(316002)(2906002)(76116006)(64756008)(66476007)(7696005)(5660300002)(71200400001)(478600001)(8936002)(86362001)(66446008)(7416002)(54906003)(6506007)(66556008)(33656002)(66946007)(9686003)(52536014)(55016002)(8676002)(186003)(26005)(83380400001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+taIyjjalS1PFr1Gi6JTeJc4wn3P7Ifb3UQ15TesjkTi3dtUMpq/+C0RcEtE?=
 =?us-ascii?Q?UzwokRSZ/gJoYOC3gZLkxXJ/zB2WjGzR24JpQL0spwZfXwZ3BNV7U0Ikr+XR?=
 =?us-ascii?Q?Az8YXxFPUkEVX9/tUfUskIvgt78DN9ULsoQeXnXhmrkvjdFOtx6byLSgc9G4?=
 =?us-ascii?Q?w5JJ2M03xKBEKTDFP0BdNHrcnBRg5E3yAB/qsmzoNH77gb1Csn+T8+XJS+Rp?=
 =?us-ascii?Q?qOif6QFRUKIHzCRKghhUopCheYI0kgvcFYPtBl2OVzPVEoThnvrjXhYcNIPB?=
 =?us-ascii?Q?tf9mVuCEKUbD/lq4DTBFA7zEZ8XW3SFQpP2lsrb0v9frNZahWEIKunY/J29X?=
 =?us-ascii?Q?E7i50GMNBINmxm9rBMsMM4mJHxlRMHPlSM8nsLbMAui0F/IS4ky7wU6srSx3?=
 =?us-ascii?Q?kC7Kde86cMV+DuwcOZQHqO5a10kONaLGerKm0k6apHOVVCbEmk+oGIPsAhCI?=
 =?us-ascii?Q?uZKWmKSC4UMjAj5bLQQvTVs0w+ORHVZAGcLj+VwTPYVCE+bpry5zQLYEnwo6?=
 =?us-ascii?Q?mNY66uYJMed7ZwJKM0p9OGogOoMy1RcRJS10HzNgbSWbQekkw+5oXQE497Qk?=
 =?us-ascii?Q?unykbSlcuRf+T6kdmvkqSgJ2oUOtHCQ0mEcc+YGdn9R/CbnLQX7mYLRpPWOc?=
 =?us-ascii?Q?+3iZ5ivbnAcolDhus+DMVToy3bH+swGZeEoR5y1Wjg1IuYsJPGOQM3fCtgCg?=
 =?us-ascii?Q?4Zg1aL2j7+uUCFZshYROVxZdYzOv6rG0mxrDpzAx7wfLqjOKsbWaf+LHwKjK?=
 =?us-ascii?Q?gARd+M7q0UCyCaBoeC4ftGXRmNo6HQwTQ+REhrF6ax0g8pdN25RfulpfBgXl?=
 =?us-ascii?Q?7rZTFGc8K/08oTbCZA04q9mY6bsy2qlq9aSi1gonmLnWwOX1VBVL6QykBuH2?=
 =?us-ascii?Q?BKkIg6+CjBt2d9vnPkGTiYmQYa9ycyPRp5mgDQw4vCJwQ1Ad+HeTezSKHfUC?=
 =?us-ascii?Q?lByi258x9UYcsJMSa6Nat5d5Z7jeOD/irSHGNroWeOsjcFIRv3qE+SOMwQ9H?=
 =?us-ascii?Q?o6rTBpKV6Rf1pnuNHnaPIBo85vgQp6IjhUCs42M/eHH7MKlziSU7+mAIUNGw?=
 =?us-ascii?Q?OHE1il0F86+/ob467fn40NYCxaGYKXvidQCpBQsLy/BojgW/IwmrkKFo6ZHo?=
 =?us-ascii?Q?SWZRTIY0Tf0Dvdx9QGRp3lsxO/ZQyFpmJO7A5yeUPON6xQTCYdWYufCR4H5R?=
 =?us-ascii?Q?hmvbfiU68vtQLrVDFtPtwOmJDomN9T06xdegXaSnnSgXo0dkXcEiCDmV4iN4?=
 =?us-ascii?Q?sgPrWgA5Sejm6116W4NzNXX+cBWkCRkjMmwBq6twxWFZa2Dfb994y4B0iVIg?=
 =?us-ascii?Q?H/g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1774c4c8-b20e-480d-43e3-08d8f0f6b242
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2021 08:02:41.4640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 749ZtojRTL3T3txS/kbrIl5pElsoMiJ8P1p8HmhrRgDYoIIda/hB9di5r7fYRat16SUmDcdRmu7tcRblqSg70w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5226
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > @@ -596,12 +615,43 @@ int ufshpb_prep(struct ufs_hba *hba, struct
> > > ufshcd_lrb *lrbp)
> > >               ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offse=
t,
> > >                                transfer_len);
> > >               spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> > > +
> > > +             if (hpb->is_hcm) {
> > > +                     spin_lock(&rgn->rgn_lock);
> > > +                     rgn->reads =3D 0;
> > > +                     spin_unlock(&rgn->rgn_lock);
> Here also.
>=20
> > > +             }
> > > +
> > >               return 0;
> > >       }
> > >
> > >       if (!ufshpb_is_support_chunk(hpb, transfer_len))
> > >               return 0;
> > >
> > > +     if (hpb->is_hcm) {
> > > +             bool activate =3D false;
> > > +             /*
> > > +              * in host control mode, reads are the main source for
> > > +              * activation trials.
> > > +              */
> > > +             spin_lock(&rgn->rgn_lock);
> > > +             rgn->reads++;
> > > +             if (rgn->reads =3D=3D ACTIVATION_THRESHOLD)
> > > +                     activate =3D true;
> > > +             spin_unlock(&rgn->rgn_lock);
> > > +             if (activate) {
> > > +                     spin_lock_irqsave(&hpb->rsp_list_lock, flags);
> > > +                     ufshpb_update_active_info(hpb, rgn_idx, srgn_id=
x);
> >
> > If a transfer_len (possible with HPB2.0) sits accross two
> > regions/sub-regions,
> > here it only updates active info of the first region/sub-region.
> Yes.  Will fix.
Giving it another look, I noticed that the current design only support a si=
ngle subregion per region.
As activation is done per subregion, we need to count reads per subregion a=
nd make those activation decisions accordingly.=20
Still, the read counter per region needs to stay, as well as its spinlock f=
or the inactivation decision.

Will fix it in my next version.  Waiting for v32.

Thanks,
Avri

>=20
> Thanks,
> Avri
>=20
> >
> > Thanks,
> > Can Guo.
> >
