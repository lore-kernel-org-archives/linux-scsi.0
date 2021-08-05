Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA87C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 06:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF6D60525
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 06:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhHEGej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 02:34:39 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9592 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhHEGej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 02:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628145263; x=1659681263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fSedysrwhwPWELbxjmVEWOYfBS0WItRlPoQ6eabqP50=;
  b=o19HsTFzVTCRKS+Mt5HqrD7APBZP3jbzx578EP8BGkWzCL84TP98htHX
   0yTev6C3CcHfNvqbuesGZCuGEMULN78Id7Nm89yANCPsmbsaAB2HLjb8P
   G+tWvMgWA14ODxFAk3yH83HZ4Vx4Mnt/iPgPmu1pXmf3LQXLUieFHoThu
   7/G7zUWSHdRnOkJ4jDSheTnWn6BuexL/M0TXaQyDcqfcA8Byx0oJLiFbL
   SKx6/SFnst1o2E/agIGUerHVwM7crD1sA4ZXjPIvT/wobFcIni7ssMjaF
   eVoupmQqfJ7nMeyvwD8wuDmoMptRO6MFASuJ5veNjoWhZRD065gZR2oYi
   w==;
X-IronPort-AV: E=Sophos;i="5.84,296,1620662400"; 
   d="scan'208";a="181189442"
Received: from mail-dm6nam12lp2173.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.173])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2021 14:34:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpFDXVPfXanVxkRFG/903ALdIydl8KkNeME/AP86JK3NhqXwhdSCcUMr3/qyLJ9qFv81IyqtpTbQi8jK8cPuDkyEHkKQ8uYlyZZ/XD7OLerNxqQ5Pk7b+GcU7DobGbu1ARVwWWxMVJOddzD6Hujd4LIaQw+3dLwX7f65hM4HnIDY9Cd0YZ1r0urOYpHgjMYD0yZCr2LD8H6fCFpYe3JeUMsK7ulpnDBO6RW3vkA0NQrJELVfjY2I7o9e01WaPJcsWA4/oQDMcXh2qqO02WB3xFNmxISasWjK32KpuKpiT2nqRK/X5AhabvYl+0I/KPc7a52hIs/ULdejHsp2ZSKqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RB9bndwj57g2Oqx/j/4y36TWCDesxWZRbPgBkARv+xg=;
 b=WCLR6I72LhHf2FJEMbNtQYhHet8LHSKBLTK6oh+LKN64uX6pMNrhbj4siwM5Pm6mAVpAWPPsT58hu76J4fjWgo2jO1MN9cDg5kXqKWq5FaIY/njpxDGVnWq+Q60aFXjtpe5pLYEaYHhWaGrGn5dKS+rTsD/rIhUr+y7YYk+kMPGHThP36GDwpdnU+Q555uJATu08DYHZGI4qe8OG6RdU9gkADPR+NTit0v2xg2G/Qavg/X+H9PB5PJxSD5MD0VoTwCuku3koLS8ExxGgmsbk44R1yC1p92gcVOYQip6ptvruPwOZ/A1yg34pQ8WoqDLOhKmSA/CF7zSerob10rvopw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RB9bndwj57g2Oqx/j/4y36TWCDesxWZRbPgBkARv+xg=;
 b=SeVHyP3NBufoXkXce+oePrSBnZgMao6pyqCJ+7rCDzOa/2Cp3MtyN2ZA86LYWzL+2b3lLhhQUgu3w7fVoHV+0V6qa1MPixECUESEdUED6yHgg8KK51NzpCTWIZbb2bRshrBfGWNNGAm9MlVw61fWCI1sj4Yrog489QJMx5SThBg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1132.namprd04.prod.outlook.com (2603:10b6:3:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.26; Thu, 5 Aug 2021 06:34:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4373.026; Thu, 5 Aug 2021
 06:34:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Add L2P entry swap quirk for Micron UFS
 in HPB READ command
Thread-Topic: [PATCH v1 1/2] scsi: ufs: Add L2P entry swap quirk for Micron
 UFS in HPB READ command
Thread-Index: AQHXiV2V2+N3YA8RXkihQlAMhvC5z6tkdIGQ
Date:   Thu, 5 Aug 2021 06:34:22 +0000
Message-ID: <DM6PR04MB6575F7580C428373EAAA33B4FCF29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210804182128.458356-1-huobean@gmail.com>
 <20210804182128.458356-2-huobean@gmail.com>
In-Reply-To: <20210804182128.458356-2-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d07693a-e302-4c81-3fc3-08d957db0fd3
x-ms-traffictypediagnostic: DM5PR04MB1132:
x-microsoft-antispam-prvs: <DM5PR04MB11329DC189884FE14EC3C3CFFCF29@DM5PR04MB1132.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J+aBEsuIUvdU5gJxilYWzVc8qGc9jvveuY/h48x8lWuy8QCAdgBWx+QZEYVFoECUG7hp8qDqiuCFdmBJQhOHM9plKC7eK+vEowt2VSHLxp7bxNiOvGzgnIltFWGjL7w5HIAwzQnVHNNUlLUyCWuEwKDa+nV6AKI9r9scb11If6A47aOnI6w2SLlXSM58m4G/UzzaSXLqPRqW321lxCAQvw7SxuAcML/exQakp5xRcrdaS9IEMpBYo6oEvKoYI6LQHl9GApZfMx/7J6r3zci1vHeceT2qlsaJisVr1oQgQvH84OPcYu3tCV9gcx6KVaHYxnp/R0BzWrPX4rfZWnl+W/QkwrtHNufaTQn9m7c/ScTF13PiBqOy00S44pg9xY5Udm8itzdKbaMaewAC739BCtOzfdSxBU2dqJVg476rOWeb5g+Q2mlDSWSKj4UWXRyAS0+z0ydo2Ff9LV8TFapvUrfzxOUqFbsAu52d5MU+hePX8xes4upDr6nYllmW/5R9rZwqO9APsOwPGNO+HHQVExlqOBGQcFxk/OwmwRzUxNlingrvfchruO3UFWstm8ULMv+E6Hq3UAUPjJWz2fmLzFaCFIMmsqKIhDpzIDFMy31MykGkw00MM3MJtZnJndcuyDpNYw22cXUHccgtKqcrPtF2Amwd46mM2mKGIMJHaXzbIfrDhfd17E8RXB3D6jM6WTzvBpmfhBwm1tpoQ49vmAdsga92wrLMJxkLiLC1lho=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(366004)(376002)(52536014)(122000001)(76116006)(66476007)(186003)(478600001)(66556008)(71200400001)(9686003)(66946007)(64756008)(66446008)(316002)(54906003)(921005)(38100700002)(110136005)(2906002)(7416002)(38070700005)(55016002)(7696005)(5660300002)(33656002)(86362001)(8676002)(83380400001)(4326008)(26005)(6506007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zk5Qz1DEWoOhbOdDLKWym1EgiQ003HotQJg99zY7HWFbvKGSSx9soH6TTUEz?=
 =?us-ascii?Q?jPogp020pSriKmMY6w1lf0L+WCU1SqNHXWSJbklufgwD5d1WyOi2D1umDk8v?=
 =?us-ascii?Q?L2aWlGdI2GdSemnQ8R/5Nfm0wdK+aU3cz1v7qdrGuyTBzmpOJBuwSBclsFEy?=
 =?us-ascii?Q?ThpWC79P5Wvg7mRm8I6/1Op5HnqOxCCQkzAW7HRolq49XsSIGwCEZm+8/sSy?=
 =?us-ascii?Q?EitL4vnJtRA7WSOou4QpP2KAPXPIQTXIvEKCI7ij4EaodAwBO1U1LuEfJCLa?=
 =?us-ascii?Q?b2IohQuS8GIxla6DVJdzV8HiaGjPfgkyraN/cJHnKHQ2SU+TI5fwg9a13Ytd?=
 =?us-ascii?Q?3nNqWL7dGYMANFMGeqEjQgoOLqj31iGHJYw7/xveGHMWaVPSpv3D2vKB2K7N?=
 =?us-ascii?Q?s04Jl6kRnVXSEGwnPb+GrSHjpMRTD3iQYYxA8SO0zjHZCVg5ri9aT1UlLXpt?=
 =?us-ascii?Q?2Gg5bPghV6q/zeWlHXrZbApUZoUYQd7xb53XhzkbeCpLEBKfCsNSAlWmvXa4?=
 =?us-ascii?Q?7Kok6vKs/IDXcb8s0DSNoOhYpwXO0u4NDIki0J7NTADb0+pyFFfhtF/kJjge?=
 =?us-ascii?Q?NLZSF4rrp3mPYsn6M/jUc1OdHwjgyP44IPanWhNclVUgFb6Cs4eh3Ky+K/7N?=
 =?us-ascii?Q?hJwON/ucE4ZEKNcIZ2UkJF/nvVqSUM3NjJ6CxcPjSpTmf7mhCJ5OGsMLhfFI?=
 =?us-ascii?Q?viyFHDuQsz7i2VnJYBZ9vjO8L290CkM1RvITQ3nzo3duOql+jwu2ZjgrN8ip?=
 =?us-ascii?Q?jFZoM/ujhe0sbeIgs0iDbwjwZP5Klj8Gmy1l8XgnINsYLUyvKPl0rpKUQ8Iu?=
 =?us-ascii?Q?IFS1VKwvGfGFaJLCmIQs4qUazhDaxZksujZcXg53wdQkM3r7Tx1XwgFqthIt?=
 =?us-ascii?Q?4OoMTBme71URNXloBC2ZkvlWekLQ20BuWxLWNDhbiFkYQt1uf+VmIgKuJAsG?=
 =?us-ascii?Q?Kw6FO/GRl2XUlDcJh+AiMVh5mMFQSSYlvMP8MENHJK/CjxskN6d4oq4wB6z0?=
 =?us-ascii?Q?gf124df4KkWTBl+lHRSk/uGv7WVvqhs2RRCcaetwaeiT3ULEZ0zv5pmFW2LR?=
 =?us-ascii?Q?La1IzyxkIOX9hwjX84azsCCr7mAoGYIKWrbi4mPdg9EyLM7ir4bu7CGkP++3?=
 =?us-ascii?Q?Z0L5O1CJ/6V3+H+9CedAG0ey9zbgNgiD91h27FgQAoZ/ceVOnEglxxrUwKnU?=
 =?us-ascii?Q?jcGa0gGjJL2UERAs+yN4VB+hXivHMAnw0SIRaLuL4IwqP5KtmJHtd864Sbr3?=
 =?us-ascii?Q?tdgCuJvJv+pcLC5c9CIzDTs4G6B2QZ8TbLvJx7NIZxBSL7/96PrI53InBBBl?=
 =?us-ascii?Q?rCnf6jd5IoVyVwRh6j1GksRR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d07693a-e302-4c81-3fc3-08d957db0fd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 06:34:22.3995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: InZr69G+l2V7GBrib6B49XsKSK8BMKNNFi2xofNjw0MTIPAUU33tq3UvLAf+vm33uMMXChCXzRUZwwEi0HdOkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Bean Huo <beanhuo@micron.com>
>=20
> For the Micron UFS, L2P entry need to be swapped in HPB READ command
> before sending HPB READ command to the UFS device. Add this quirk
> UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ to fix this
> inconsistency.
>=20
> Fixes: 2fff76f87542 ("scsi: ufs: ufshpb: Prepare HPB read for cached sub-
> region")
Not really needed - the patch is fine.

> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs_quirks.h |  6 ++++++
>  drivers/scsi/ufs/ufshcd.c     |  3 ++-
>  drivers/scsi/ufs/ufshpb.c     | 15 ++++++++++-----
>  3 files changed, 18 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.=
h
> index 07f559ac5883..35ec9ea79869 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -116,4 +116,10 @@ struct ufs_dev_fix {
>   */
>  #define UFS_DEVICE_QUIRK_DELAY_AFTER_LPM        (1 << 11)
>=20
> +/*
> + * Some UFS devices require L2P entry should be swapped before being sen=
t to
> the
> + * UFS device for HPB READ command.
> + */
> +#define UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ (1 << 12)
> +
>  #endif /* UFS_QUIRKS_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 47a5085f16a9..c3a14d3b0030 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -199,7 +199,8 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum
> ufs_dev_pwr_mode dev_state,
>  static struct ufs_dev_fix ufs_fixups[] =3D {
>         /* UFS cards deviations table */
>         UFS_FIX(UFS_VENDOR_MICRON, UFS_ANY_MODEL,
> -               UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
> +               UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
> +               UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ),
>         UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
>                 UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
>                 UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 54e8e019bdbe..d0eb14be47a3 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -323,15 +323,19 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb,
> unsigned long lpn, int *rgn_idx,
>  }
>=20
>  static void
> -ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct ufshcd_lrb *lr=
bp,
> -                           u32 lpn, __be64 ppn, u8 transfer_len, int rea=
d_id)
> +ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
> +                           struct ufshcd_lrb *lrbp, u32 lpn, __be64 ppn,
> +                           u8 transfer_len, int read_id)
>  {
>         unsigned char *cdb =3D lrbp->cmd->cmnd;
> -
> +       __be64 ppn_tmp =3D ppn;
>         cdb[0] =3D UFSHPB_READ;
>=20
> +       if (hba->dev_quirks &
> UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ)
> +               ppn_tmp =3D swab64(ppn);
> +
>         /* ppn value is stored as big-endian in the host memory */
> -       memcpy(&cdb[6], &ppn, sizeof(__be64));
> +       memcpy(&cdb[6], &ppn_tmp, sizeof(__be64));
>         cdb[14] =3D transfer_len;
>         cdb[15] =3D read_id;
>=20
> @@ -689,7 +693,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lr=
b
> *lrbp)
>                 }
>         }
>=20
> -       ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len, re=
ad_id);
> +       ufshpb_set_hpb_read_to_upiu(hba, hpb, lrbp, lpn, ppn, transfer_le=
n,
> +                                   read_id);
>=20
>         hpb->stats.hit_cnt++;
>         return 0;
> --
> 2.25.1

