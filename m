Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1890C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 07:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiLMHSF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 02:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbiLMHSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 02:18:03 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6981CFD12
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 23:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670915880; x=1702451880;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BXzbN+fDLiMa0k5Jn6+UiYApJD4c1B+HX8uVrzEhyh0=;
  b=LFoKtED4PKzzlSfUg3yorards+S7CoT4i92exUXXdo/jMtBEVbW53BbQ
   Xx9xwcHZgIaEa9lcQFLBbmEUZSwaxZxUkqzCMfHZYoBxvo+cmx91siwZ3
   LSkPGlj6l+ivnkdLA3yQlBMJVs7dZFRLPxh33tmi3+8gRvB5LTMS2m5Je
   ZpGBMwRa/d7FS7iplWuRaLf4RNm8D0YZRx0cRBxJlQyYRxnv5L2kE1F+b
   fpuQgeC+bIzHRQs2IJGrFHGY9vg2SLR6BgNech0ovMvFhl9nWG6MLYE9x
   vPr2o4UeyPY/Q5cE4k9+sSSvlV1N24LuF2tYFkMEwPrufv8ArAJJchZXQ
   g==;
X-IronPort-AV: E=Sophos;i="5.96,240,1665417600"; 
   d="scan'208";a="216720048"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2022 15:17:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBWkz9jhvozfKqT5ZzjhxyFQOcZ0svb/OVZoOKZixSCUSXhePF6ZeOX7BTCSXFbwU/r+W5F8/5T3ugJmWmvIL71cfCxpQjPIg5mrrAQQ/uuxtYewtZLy+aQFJ+tRn1MJd1sBCP4RSPcLTmbuH4w96pt2e77LHsTIcx+uTmtjYTczviGkpbxK+6mMoBH4k6hmaoVqsRG7S0rVm6QyqrVtN84Rmvu5ob3rqJ65fjfqaTAvblf+M7i2BNCAXzjlIEmbWRoNPk3asq5LMwPqUYr1FYCJMulKTYRaqvbz6p9hNGRnBABcCYMYMcB2nJJX5IY0MCCmW4szcbzlTwB6oz22ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0nYj/ceOJkxctYuKNL29wSSOgMBO3eA/7SJNbSeswE=;
 b=g5wHyHesnKIkK1ipLNBfGa1Eh7CEgXzLS9efnZAEwf9+C+szhI4uEAcUa3q6nst64xYehvixnuSgZikwt8uS9zBMLDqXMczA1qiqWuei2JMPhMKkO3lvUyL2aDszSH/cUIszM71/Dga6JwgRBeNzzq32tv3qA4ngLqoRXDWVqBPWrjyFIdS5V1B1pAhlEi5hidjBrv4mv7pMGQ134/iuv6vGbW3Xiw2r5tQAUCbeF2gNa/WBTuhddRx/mRqzYQzRHNAvfaqrhI+TdKdCtRH+Aw+llMP71FR1UKpojwjbk3wv+g1yINxJrJ8x1CsVL6TYBaocb81TEzV9mv1MhrJZrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0nYj/ceOJkxctYuKNL29wSSOgMBO3eA/7SJNbSeswE=;
 b=zQvD3U2+k493qJhV79Dq/BRPE37WRYIiCw5RFw8mAlirIHJG9igItHCT0e6+jIdUJd8sAM+Xty11t1i26y8PPVsB5w/RF3Vwz7sOEvSPK0DQRDA1RVqZ7fMEqF1bfWrvqRC61esVRo0MHlAlmXhsUYJcPNZUkHQmTue8xj91Evc=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN6PR04MB1013.namprd04.prod.outlook.com (2603:10b6:405:43::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Tue, 13 Dec 2022 07:17:53 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%5]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 07:17:53 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Thread-Topic: [PATCH v2 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Thread-Index: AQHZDo05JVp6pb1K10SXikuESH7thK5rTRmAgAAb0YA=
Date:   Tue, 13 Dec 2022 07:17:53 +0000
Message-ID: <20221213071751.qfxh5wjrwyiwvpat@shindev>
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
 <20221213005243.2727877-2-shinichiro.kawasaki@wdc.com>
 <CAFdVvOyyw3Ri8BW3U=vqtyDq6fiBoJVQSqP=2ib6-WAHFaunLA@mail.gmail.com>
In-Reply-To: <CAFdVvOyyw3Ri8BW3U=vqtyDq6fiBoJVQSqP=2ib6-WAHFaunLA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN6PR04MB1013:EE_
x-ms-office365-filtering-correlation-id: 66abad1f-e413-455d-f807-08dadcda26c9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A/lQLuF13BAm4Boq1m2AfwN7erM/4jHv7uL5Y45FsttVLExEDHGE0g+nzGUPhjZw33A1ZFRQ+Jkj/BxS7XWkPgbHdeH0MAQWFKeyBIJMbnCYCj4sR2W5voYVS48QHpGRYS8XqnNPOz6rba+B7+zLRUw78YQqDhteUyvHcIDE5cAX3Lfc3kI0BeQnAyJGA8rr2mUhJDHOuvfFvzPKKaJJAEV7H/mTZufepgQgwfE2YuLFtqmUWDSF4+bvsQeq0oSiZxKOd++rJvzfDS7axyGBP7ueOYRzCRuZh8F7AKILBhP4SSO7ROImfupiYYMjbBJ0fqFGuT+E0hS56SoYdX8llaKDUsqMP4mxZrTFkuetmJSD6nOBPV7730BDQuXbprQ+0V7MMqOaPj6knNwP8eEB44ycGa1TzP2B3uPMZ1XeOtURjGOTKoCN0yDvCjWS8ww/3/pgrL1t6CY3cz/5XJGSdNe42OdHZIf9Rg/J4oelE42hn5gLul+bZsaAOkJAdt/rKYoU3/gzPgcWPT8MEzBtCFBRBX7P3wtPvlwooESge1SnKJzxwflB/qfi/D51tr7EBHvp7v2x/0PcEQKdy4NRM7zsPyM+dWy4P8NsMz4ap+zDxD7QV2eOq9Tr7O6dYNCrj/A0QkE2JuPH31MuKn7Q5P5omyQO8l5WIt/tM9NpLwTcgrd1d69NhkgQtRGhNW7pzN+AetmaaRhyMDF1IExq/rX+/MSrheTHYpULc+hWvXg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(6512007)(86362001)(41300700001)(71200400001)(9686003)(38070700005)(26005)(8936002)(6486002)(478600001)(33716001)(66946007)(6506007)(53546011)(66446008)(91956017)(66556008)(76116006)(4326008)(64756008)(8676002)(66476007)(54906003)(6916009)(5660300002)(316002)(83380400001)(44832011)(122000001)(38100700002)(1076003)(186003)(2906002)(82960400001)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e/OvgPDwN5z3NMrHFjFjUikoGnuSFLq/HBL65+xtM1YM/hl9xw1uvIL3TyJg?=
 =?us-ascii?Q?IExUkzNeXltp93hDA2UKGimCYnpcHsn7k5+BjDlUZY+/ECf9pN8uX5KJf1nH?=
 =?us-ascii?Q?h+6+ktHFpN0JoWHMkrD8QrjfxFyH2D2pmv9qpGI2tf8tNOtrDhbuHaPHPqxC?=
 =?us-ascii?Q?7YyhUuJL8+3VHRerPa5dxRX2vO2QXMr/tQM0gOT9Lk2CZFiisIaKPF9qlHAv?=
 =?us-ascii?Q?U61ijuTKYMduudB+N9/qjXhGqoKSVk4SozPHJj5omcVAX2woYeq8qH57jpgp?=
 =?us-ascii?Q?1m5QGL5YM1iAL6IS0ayTMZQvLJl+wcVnIslQhNA8Dp9N3kcfbAdJIjybXp8f?=
 =?us-ascii?Q?DhVw5X55C9NjpAZeLfcSNL+p8z+dYX0dZobdrQcBUKxeZ5Q9KU2VOWjbcFnd?=
 =?us-ascii?Q?wdOSg+b0M6eYQIG7Kdkurh35aazaob9E9N5z02pnbrP2NunIQ4qZOF6Yp9QU?=
 =?us-ascii?Q?3JjxfAGDPi4RT8iSnwGvG2vUMK4xQVSK3LEc0nneQq3u2ZZCSUFRFniRqfyj?=
 =?us-ascii?Q?y2Mxm1gmZ4dW3FPUnH6iOx2B8q09I8zyIDl5vv+B1jrC2Z/P+2/dhZnSmxku?=
 =?us-ascii?Q?leXB5DxoOIpnj/4z3pZkw86Vy0j1jrHXu4S9ov4JQM4JXSrP/SoSOnRPMQm1?=
 =?us-ascii?Q?6JHvykMuLStX+wsS+zf246n8i6U5mge1HgOl2Yh4FQZrr9KBwZiSBXq+OpXG?=
 =?us-ascii?Q?6eokU8tDEAgn6r0O82C9VlqoGQLxtffHlY2bowHdK09nsyWOdFfQr32iGzzP?=
 =?us-ascii?Q?V5lhLFL6YEVtau7q1/waddkXVyx9i2xrW9bhm6w6SERNXsAo0jgSQ7UJ95bv?=
 =?us-ascii?Q?B7uKHphpvH38CQQ1/TMKTKH4XOOsZljRvdYvlrEBZIazqjb+SiAA6oqyYPcP?=
 =?us-ascii?Q?E5SZ150LyMnLZMeXsz0GOnuzj8/kPCixMiZr7MJ2afHeHBc1hJ05J8WM6g95?=
 =?us-ascii?Q?S1KiHDAI4/DCJDH8E0ZF9TpCOrGg3vs8MN4lRjCAVyE4jYfduyHU4vTKWH8S?=
 =?us-ascii?Q?PpmxhgiMOvrPI8HA0E7o2YL2kpIASGVZywQP6oW/Din9eeKXFIcuei3bxZk0?=
 =?us-ascii?Q?nxqWiNXfWbt4SrgqPZkCWV5qK4N0Exi0N94A9XTnA24FrimG9jWVhwZ4ovgO?=
 =?us-ascii?Q?ic/FFw9Y9EDGSzVozGymKxQ90WRR+TlJ/CMETtNGVJ5sd1ftDLr5Q/+NBCxN?=
 =?us-ascii?Q?94oxSqsYkiSN8s0vS/bRf1SLzqAFWeXH462i5ELbHXUj/+DmrS7Kd5nKsqv+?=
 =?us-ascii?Q?THIkk/gIcvT/uAF8IvVg3LhFrwnzOSs+6kHSFyoMZ+Wv+YpeOdCg0u2eb0pE?=
 =?us-ascii?Q?aNbAFPgPt0Ut7G0ElucBKyLEQndcwAIIi+jZQm+p3/0KB+ntVbCvKPsOQIco?=
 =?us-ascii?Q?qILSfTVpYpIgGPJPnu0qgvEU1p/9NBxqHz2L24knq2OPOURONWm0ZyiZRFHw?=
 =?us-ascii?Q?d8DxBkIurVve2p19oQBzmkaDMX3R5FvnaMzmCtAVkc+yeZpL/TgdiI4HQXFN?=
 =?us-ascii?Q?z9NWpxwmP5TXAqxEbhUd6FHidvpqCFeT9yaxSAfqnn06C5ADfNhHS8rxvxL6?=
 =?us-ascii?Q?omVwx87bY6LtbsLZbdOe8kYIYs6QmW0bf5fCUXWQs3jI6wAtdoW6cj7vRnFj?=
 =?us-ascii?Q?DzcImhONv/CGDAfY3xALeAQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <99A998A26634BA4BBCF591ADC883FFE6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66abad1f-e413-455d-f807-08dadcda26c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 07:17:53.7941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kjwpaYqYw/GnlfVDallsdYs5FR1pUZF/DNHqlrnGh8GMAD/Ea7M4qBGPNR+79xzKFl+FOWT4vpmP0wG5dJiZRfKwHTp2TRpY0Y8wrlK3MWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB1013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Sathya, thanks for the comment.

On Dec 12, 2022 / 22:38, Sathya Prakash Veerichetty wrote:
> On Mon, Dec 12, 2022 at 5:52 PM Shin'ichiro Kawasaki
> <shinichiro.kawasaki@wdc.com> wrote:
> >
> > The function mpi3mr_get_all_tgt_info calculates size of alltgt_info and
> > allocate memory for it. After preparing valid data in alltgt_info, it
> > calls sg_copy_from_buffer to copy alltgt_info to job->request_payload,
> > specifying length of the payload as copy length. This length is larger
> > than the calculated alltgt_info size. It causes memory access to invali=
d
> > address and results in "BUG: KASAN: slab-out-of-bounds". The BUG was
> > observed during boot using systems with eHBA-9600. By updating the HBA
> > firmware to latest version 8.3.1.0 the BUG was not observed during boot=
,
> > but still observed when command "storcli2 /c0 show" is executed.
> >
> > Fix the BUG by specifying the calculated alltgt_info size as copy
> > length. Also check that the copy destination payload length is larger
> > than the copy length.
> >
> > Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
> Thanks for the patch, though this code needs a fix, the changes are
> not correct and needs modification.
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr_app.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi=
3mr_app.c
> > index 9baac224b213..2e35b0fece9c 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> > @@ -322,6 +322,13 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_=
ioc *mrioc,
> >
> >         kern_entrylen =3D (num_devices - 1) * sizeof(*devmap_info);
> >         size =3D sizeof(*alltgt_info) + kern_entrylen;
> > +
> > +       if (size > job->request_payload.payload_len) {
> > +               dprint_bsg_err(mrioc, "%s: payload length is too small\=
n",
> > +                              __func__);
> > +               return rval;
> > +       }
> > +
> This check is not needed, this is already handled by reducing the size
> to be copied to the given payload size

Ah, I see that min_entrylen is prepared to copy bytes smaller than the payl=
oad
size.

> >         alltgt_info =3D kzalloc(size, GFP_KERNEL);
> >         if (!alltgt_info)
> >                 return -ENOMEM;
> > @@ -358,7 +365,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_i=
oc *mrioc,
> >
> >         sg_copy_from_buffer(job->request_payload.sg_list,
> >                             job->request_payload.sg_cnt,
> > -                           alltgt_info, job->request_payload.payload_l=
en);
> > +                           alltgt_info, size);
> instead of size, this should be min_entry_len+sizeof(u32).

Thanks for the comment. I read through mpi3mr_get_all_tgt_info() again. I s=
till
have three unclear points. Your comments on them will be appreciated.

1) copy length

The pointer alltgt_info points to the struct below, which is defined in
include/uapi/scsi/scsi_bsg_mpi3mr.h (I refer kernel code at v6.1):

struct mpi3mr_all_tgt_info {
	__u16	num_devices;
	__u16	rsvd1;
	__u32	rsvd2;
	struct mpi3mr_device_map_info dmi[1];
};

When we copy "min_entrylen+sizeof(u32)", it looks for me that the struct is
copied partially. The expected length is as follows, isn't it?

  "min_entrylen + sizeof(u16) + sizeof(u16) + sizeof(u32)"

Regarding the min_entrylen, I find code in mpi3mr_get_all_tgt_info:

	usr_entrylen =3D (job->request_payload.payload_len - sizeof(u32)) / sizeof=
(*devmap_info);
	usr_entrylen *=3D sizeof(*devmap_info);
	min_entrylen =3D min(usr_entrylen, kern_entrylen);

The usr_entrylen calculation subtracts sizeof(u32). I guess the line also
needs change to subtract sizeof(u16) + sizeof(u16) + sizeof(u32).


2) kern_entrylen

usr_entrylen is compared with kern_entrylen to get min_etnrylen. And
kern_entrylen covers (num_devices - 1) entries:

	kern_entrylen =3D (num_devices - 1) * sizeof(*devmap_info);
	size =3D sizeof(*alltgt_info) + kern_entrylen;

Is it ok to cover only (num_devices - 1) for comparison with usr_entrylen?
Don't we need to cover all num_devices?


3) memcpy from devmap_info to alltgt_info->dmi

Also regarding the min_entrylen, I find a line below:

	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen)=
)) {

The memcpy copies data from devmap_info to alltgt_inf->dmi, but it looks fo=
r me
that these two points to same address. Do we really need this memcpy?


I'm new to the mpi3mr driver. If I overlook or misunderstand anything, plea=
se
let me know.

--=20
Shin'ichiro Kawasaki=
