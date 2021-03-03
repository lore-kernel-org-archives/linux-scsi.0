Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801BCC4646F
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53C7D60234
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446994AbhCCMr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:28 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:23226 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347190AbhCCHYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 02:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614756276; x=1646292276;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aDJuNOap3Yel3VNJ36FYyIii+URg/v+/28IwY4VsqxA=;
  b=U1NHSpwUADBtvaskIkJrmyJjbVqxwFW5GumhgBKw2IZo2rNE4MC4jA+K
   wwn2OX6bK+U21tMb4LL0TrUrmkJggck5mYHxlfkD+t7YoqkPiz5XVTudI
   6KYCzhXJmqqX5ArrimGOQAIE9fctjHoVHn/zlYY+ObRfZ86Af+0UKC22v
   c6cb1iW+SCOxmaWfMDMfyuApVyOA+nkaV+TrGQ8kvaWf2DPJcNzBOQDzy
   9+odEOO5zFiOTx9gvtXKWNEN//qmmvW5yrWHTZCFU0tnwjhZq8/olxRup
   VRQhSsL5CShRBylKrcmlZWFoivUQ/0oXGRoF8AwYn0Nz9ceuWti+axOQj
   Q==;
IronPort-SDR: Nia6K+ydexAVGir2SA8x2sGa7SPUFNVDqFoIPDv082gV0uKveZCjyI3CDq5gYNgPqsevaTyym6
 D65A4PYFMoYlTntT7uNmHjGP/L5YLIb7P5f5Sx7EKe4JzMkcP5AovmmKSxTCu2bCdYjnHTwLo4
 8C079Tzc4gVdbopdMHwjISLlYyXscne+0uiloYQM0eTK7E3lGc8aDFMfbiwpvLzkBmA3wwKhuw
 2kwVqk/QTooc+swn/oKoqRmnJ5zgAXzL/EGS1VjnI0xvwfrBAVBZO4JunnxP+O50nJyooKl/S6
 et4=
X-IronPort-AV: E=Sophos;i="5.81,219,1610380800"; 
   d="scan'208";a="161248080"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2021 15:22:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EAr0dVtCWTvIqwkURil1YjcPePWQ94zDpYhH22usFt5n5+ZmIU7kUhp1+abOhVcsyTPovELmZQFtplwIUfx4fZ8X3hFh3VezOt3GS6kwvsmdpLtLrOsMsbyELHDI5o1C2la2Glb8eKj4fjdocARdf97kWPM0b1p4oWzOBzToIhlUPg/0mgANWmbP9dZaVwQS9Y75rGYahHm4jXrctSnHJclioStEApU0ENyF0U222yzbhsWziqfl+/dsK0wtNnZdkggbjpA7KKyR2W6ei3/ty+3xPOZzf+vycXkgBur+hq8Y/+8hcFIGW5hEMWQvWnk60XWlcyTmbucR24cejVC4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vdrtSfDWrXlQesEQZiihKziLgj2oNRXH7ivQGHpzck=;
 b=fe0ZWS5MxXqqf+WZegrChvptpjE/GqMgpjB9UG7FCB+XtT5iHJHPTDbCQWHlxF3eCDcD2oNBhbzfq+ETZTpEPi6dnFOVRX2f1Da3AdiSZrtsMKZa+x4vvK1DjQiQTc97fb0x59ZtzGBYgTLlCzZzEBBy929lvesBflMB3pp29tkzGsXok4fbr6FfNdaytiNd/UP9hDPL7W+5Jz6jkxTNw1J2dBVUvEg/IW4USgWS8w5SiLu5cXJp+5K3xtmguFFUJ0uugMoqg2VYvPxpyknUVz+brvH4g/bXnfgFXzRb75HRfeJ3EryJnuB1fvrwucquKkhqHRpRFTXu5KhFFnF1kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vdrtSfDWrXlQesEQZiihKziLgj2oNRXH7ivQGHpzck=;
 b=pk9NdmtKwy6CB2TYB/VfV4x/dtPg7FDpFvz1IdBnnc8inW41DRYmAjHRWd0EUS/MRPG9CWR5SBlMeOoKiBKxMMni37j38Mk26xxsqQvzcCRTLcajHiYb3fBSF4JOH+qecKeD/Ro1unNx11Ecj2jjbwJDSF1wPQM1Tzzve1qmnG4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4026.namprd04.prod.outlook.com (2603:10b6:5:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.20; Wed, 3 Mar 2021 07:22:30 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 07:22:30 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] scsi: ufs: Minor adjustments to error handling
Thread-Topic: [PATCH v2 1/3] scsi: ufs: Minor adjustments to error handling
Thread-Index: AQHXCm8VGyJQOUJ72k+Gqmf0n4Zi1Kpx5rkw
Date:   Wed, 3 Mar 2021 07:22:30 +0000
Message-ID: <DM6PR04MB657549A42A64963CA134609CFC989@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
 <1614145010-36079-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1614145010-36079-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df0d3e2c-813f-4cfc-f583-08d8de151b00
x-ms-traffictypediagnostic: DM6PR04MB4026:
x-microsoft-antispam-prvs: <DM6PR04MB4026DD8A61D8988F5A92D7D0FC989@DM6PR04MB4026.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ztBC2wtUVvXTGF60mvAtiZuVpeM1mXpTr9o24JW9vzS9GGEwQEijzYl/QSvkB7V3hK+iDKOZFEyOsw6CuXdF1gCJbVBAwhvg3fN1mhaV1ePiD7ZAviwKMoj/yzJNWectarg8iLikY5RWlSaEMaKgd5wlOZWKsrnmmaB4cOw8l3+8GfGqO2YlXWpR9y8mesMvCqHn/SQ410cx2gkt+oJ5UQFlVuYO07fl019yUiqtcUUf8X1xW9ZmZf6QrsVRqBSoRD41kUhtGhECj2hmWrd2xFVLX/XvqOpEKm+X1XZtINxAG1SJ32tzmntjwTPtZqfhC9I3USHWAka5+nH9YrdMzy3HpStzIEfcAuRDciTJfXSPfbPUu8cKza/XnDDWIyQQ2w5oVsCrkP29pDmoRYlN5PsLmcJoaxhUxhgc5+ruik5Fb6tFddAJpZPYvtEQNfyPn2cEGGvpa4vlhPmwVI9iBPBkJ7UVffsaIZmpNiBsRmzd/SEEgtSH0GokMlnKmGkCRLcvW4AkvIMlV1iZAZVF3oqIXJqX5KwCAbtkiV9sAAgVPngcmobZVhRrsyl5coghk/WL+SxttuVKjVjv5HsOs4T4TRk64bIrLxLjmaY1GA8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(8936002)(966005)(9686003)(478600001)(55016002)(7416002)(83380400001)(8676002)(2906002)(4326008)(5660300002)(110136005)(316002)(7696005)(76116006)(66476007)(66946007)(66446008)(66556008)(64756008)(186003)(54906003)(86362001)(6506007)(26005)(71200400001)(52536014)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2MNAZCU7ZsEHeKwqltu+xxPGqGTuOq4cNsB0NoVHg+zTlMB8ALER1JoA/Q90?=
 =?us-ascii?Q?aYuaztIMS48f8bevnNoMQ8kXlIelmCYHKTIobRhKEAGjWAmBZbA/Mvr5TSbO?=
 =?us-ascii?Q?spzTSqxfwQ6+2D4JV0Xm5vDe9G5Wy2sauQP9v/hENxwOhpoCUBYZYdnXj8Kb?=
 =?us-ascii?Q?hVma73erqrpjWf/yn2SvdyNM7AHjm7HKNBs1OsLHPG9O4zxYMo1qKTpzFZTW?=
 =?us-ascii?Q?oye/Ed0tueDaPA7RR5z+1eH3sLA+iZ/1djLJQGJAoVeH1Em2Sz2xMzzsLaP0?=
 =?us-ascii?Q?X/XX8js2IXlOlc4pyJvTyQvPH4GYAX37fQnMAZevG5eiaWs4e9MSQReL4wVw?=
 =?us-ascii?Q?u4hx2mP0V/mrz7eaIYnBa7DPIcC/rnkhlvaVswMria3honWXgyPKTwtTtmrJ?=
 =?us-ascii?Q?u4g+oosXlwdIUPAqtPpXA1LMuY2FFrXFm5FtHPg6CbiUMbkNZJnhX43s5e/2?=
 =?us-ascii?Q?0Diz8Fh3hbBe8JWVjqrLwYd6nBPFwxuzhm4bkPpSXQiR0X4SBtWlAzh+h9Zv?=
 =?us-ascii?Q?mptIt7uwp9I9nuwXmaU4nAhDrLtomOxDw2wEpstRFRvggh9d32PwHXwVQ5b5?=
 =?us-ascii?Q?z5hbj8qchJmg4l21VWo6E8blXXZzc/xiZwiZektObWrsmILMOqLlzMg4oR4T?=
 =?us-ascii?Q?PrS6aL1/MJFyh3vBz+OfR+g3rNeQzl2dmFu5yjEyu5eug7LESKN4y+5pux1g?=
 =?us-ascii?Q?8fuqxuSIlzz4TIXab+JmFKl8+EX7UIaErcjEqa4/n4+Su5jMFv/hqe30b91D?=
 =?us-ascii?Q?cjdX44wr6HHg8ZW7RFtw8vu5oXzc6hPxZFj3+YzGxn3wYxmhA4dw9mFjH1ZN?=
 =?us-ascii?Q?iTnr7oPes8vGIUuZ8vfokgtQ4qYReoJfzWxyDPF4sm82u7QsnqAEknvJH31J?=
 =?us-ascii?Q?DMfzOmV+xlj+i/4qjWTGwajwk3DHhkipsf8C0SYT5hifQy4nbqQZK/lRWv+C?=
 =?us-ascii?Q?R71Z5Mw1MhTTZDOu6QQMs0x+Bou4CtgVUy0b4KS1EqzQYVYyywN+EXGxfwS2?=
 =?us-ascii?Q?22/V9EyLrkLxTnGc66I4jRPItfVP+VK2knzoSGoj+wvDSuoTZVUbkB7an818?=
 =?us-ascii?Q?wbUx4jeOy3MMVFbVvFt93OkQn/e8XZLtoVB0J+75xVaPZDW3c7h6a66rkPuI?=
 =?us-ascii?Q?S/OuRxtPl5jM8knXRQr7vDmwcWFcuwM1VuwDHz8YbYM6rRG3s0em4Qm6qtsZ?=
 =?us-ascii?Q?/6zBtzBrOvFyYWjbrfl/92xxJf/YRLtE2laBr8jQWSZKPibOOpxBZzl4eJvl?=
 =?us-ascii?Q?CSEJuRG31qOvZ+wzBg8cb3w/HUJmgnaJDm4fasNrshnscJWfex34BNWkkZRK?=
 =?us-ascii?Q?8fNiEU8O6F6iscGbK0312aeA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0d3e2c-813f-4cfc-f583-08d8de151b00
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 07:22:30.0328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nzn9Nh5UjNByrM/dHkm3lVy/4j9Q6RpMV1L7X9i/vEpw/iNDiBWQjodwA24HJ7U+URqoDBa0gXk62qDnUPiL2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> In error handling prepare stage, after SCSI requests are blocked, do a
> down/up_write(clk_scaling_lock) to clean up the queuecommand() path.
> Meanwhile, stop eeh_work in case it disturbs error recovery. Moreover,
> reset ufshcd_state at the entrance of ufshcd_probe_hba(), since it may be
> called multiple times during error recovery.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
I noticed that you tagged Adrian's patch -
https://lore.kernel.org/lkml/20210301191940.15247-1-adrian.hunter@intel.com=
/
So this patch needs to be adjusted accordingly?

Thanks,
Avri

> ---
>  drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 80620c8..013eb73 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4987,6 +4987,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>                          * UFS device needs urgent BKOPs.
>                          */
>                         if (!hba->pm_op_in_progress &&
> +                           !ufshcd_eh_in_progress(hba) &&
>                             ufshcd_is_exception_event(lrbp->ucd_rsp_ptr) =
&&
>                             schedule_work(&hba->eeh_work)) {
>                                 /*
> @@ -5784,13 +5785,20 @@ static void ufshcd_err_handling_prepare(struct
> ufs_hba *hba)
>                         ufshcd_suspend_clkscaling(hba);
>                 ufshcd_clk_scaling_allow(hba, false);
>         }
> +       ufshcd_scsi_block_requests(hba);
> +       /* Drain ufshcd_queuecommand() */
> +       down_write(&hba->clk_scaling_lock);
> +       up_write(&hba->clk_scaling_lock);
> +       cancel_work_sync(&hba->eeh_work);
>  }
>=20
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  {
> +       ufshcd_scsi_unblock_requests(hba);
>         ufshcd_release(hba);
>         if (ufshcd_is_clkscaling_supported(hba))
>                 ufshcd_clk_scaling_suspend(hba, false);
> +       ufshcd_clear_ua_wluns(hba);
>         pm_runtime_put(hba->dev);
>  }
>=20
> @@ -5882,8 +5890,8 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>         ufshcd_err_handling_prepare(hba);
>         spin_lock_irqsave(hba->host->host_lock, flags);
> -       ufshcd_scsi_block_requests(hba);
> -       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +       if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
> +               hba->ufshcd_state =3D UFSHCD_STATE_RESET;
>=20
>         /* Complete requests that have door-bell cleared by h/w */
>         ufshcd_complete_requests(hba);
> @@ -6042,12 +6050,8 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>         }
>         ufshcd_clear_eh_in_progress(hba);
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       ufshcd_scsi_unblock_requests(hba);
>         ufshcd_err_handling_unprepare(hba);
>         up(&hba->host_sem);
> -
> -       if (!err && needs_reset)
> -               ufshcd_clear_ua_wluns(hba);
>  }
>=20
>  /**
> @@ -7858,6 +7862,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
> bool async)
>         unsigned long flags;
>         ktime_t start =3D ktime_get();
>=20
> +       hba->ufshcd_state =3D UFSHCD_STATE_RESET;
> +
>         ret =3D ufshcd_link_startup(hba);
>         if (ret)
>                 goto out;
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x
> Foundation Collaborative Project.

