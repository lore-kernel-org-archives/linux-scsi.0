Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6418C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 08:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE992076D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 08:20:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bp0Lmzml";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Ls2gH8wH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRIT4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 04:19:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:58454 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgCRIT4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2020 04:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584519595; x=1616055595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qXeehXmIS2XB5BVnu57KTqc7OeFuKFAx4/5qS4zSmVM=;
  b=Bp0LmzmlO49VNRsm2dAD7vkmJwmxXX/7p9aY5J8mgd1NWslxxmZuOjgP
   TtM2lrU9G9QhbsdANlxoZVGuQwQf0qPJVsUkRmr9+HAx2qvXlzksnp3QM
   bgbPFuGg/biUNYr0InMbKk5uQ+Q5HtTbp2TmKueGmEPIydjrhh0d/Pkgt
   pSd1Kss4Ysa4gDHl0Vj6eiBAmCtOOXhcvRQbgxiqKB+SeoTju3xzmgvrg
   AkN9ybEyk9ubQ9jmDpCr4T0oQrs79mAN57CnpJjQa9f0w3hnew/n+teKd
   WSnRiKWql2P9itwyotbuHXiAiq5ML8sMjsTwjqPjnlSLHjrNUWo/aYRVA
   A==;
IronPort-SDR: 6qaYWzJ/ptvYmYJ56VjZ1b4iEGPSyDmexPm+OVEbQToxmv9EtGWitjl9QBviquv++7/THRnwTU
 6XsCRNWTt9BiiC7zNHnpqgVuxfBJGY8KUfrC52EUKD5QvruM8Nf1njB4LNv+ptSKFEqv0S5gvu
 HY63rAkx7WwmoQTEjZN6Pp36fc/n1c+Z3cHmgp8OvMNl8gPbpumMIyql6bnXkFf0TL+8/AqDC6
 FgT2Q5CnH0/KFg08p3m9nincFhAP4L4uP3g14j+H4uxL7Ufx5eiBNcIyr1Giqeo4qJUW4LW8V3
 OrY=
X-IronPort-AV: E=Sophos;i="5.70,566,1574092800"; 
   d="scan'208";a="137189482"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 18 Mar 2020 16:19:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkByoZ/PudSgUxCPH9k58pZhK9Jo02e2+cSt5yz8dmvXIA/Qx1OWOe2EB0TE2qi6e8CQkFOi2V+qzExvZIvmLQWci9nE021UY+ed51z0Z5/NU5lNu0LvS+sUjqXhQSL8OiVtCBTJujh4GKtVQWgSNoo0HJxadn6NuE83TpZpCpcGzffoIFbvQfWrvKABwdABMSJqSeYMgC4ZhvQIF6eRUthPUzLvI88I7RJWwT9YL4x0JA9cMUx/Lw+5SJgf/roEG67zculPc9JKaFL3WHtQpvn7QG4BLj3WB6pvPCX05/C9luzaBgQFbUjFXFhEISIKrUslZ7EkGNwtBDGR//pSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6MPPHcsIdSVQ0oe9qC0RHEpje3Is8VGW7+TqlskZG8=;
 b=N451KybLAkDoSBzIzcxJritS9any3uHL0CotPPFRpgIw2ZzNsuqErmVvBSG10BsEYI8WTgyZWnU6A7yc7IEJNhECKjvQjrR/GNnQ9jRRK2RrApkMd8HTbq2beRqzwMjANkCcfVe9jEceQe+U9LBbFnntHJ2MipVF6HKA8zyIQMAhta4nBuXk6YToR5XtHbgy5oFpLy8Ag/seoFQbyChMMlMi+F92u5LQ8PuhRp2LnxJofVdxRnUw4KFvR98eaqxuhlIwy0c3S9UYDBtZqk8ovcgLpcJTkGXLb7+XrOHz2Kb28kdpGUjQAp954bBzu25xxNYiGjtZYnf84spiKZiKUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6MPPHcsIdSVQ0oe9qC0RHEpje3Is8VGW7+TqlskZG8=;
 b=Ls2gH8wHDyaoyvNK4UvTgv0Je4bOO2cmtB9Djf7W/7DGDx/DmW4TCaqCBoi93mySblAcvnraq990+Ev0qxf52wkpRRkJr/QwVV81+nbYVAK0ikyG50S3xRzzZGt6I1nfvXQ4I3xQAduUfo6T3fl0B9RI3D4mHyktIXPzYHQXV0A=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4350.namprd04.prod.outlook.com (2603:10b6:805:3b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Wed, 18 Mar
 2020 08:19:52 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 08:19:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: ufs: Clean up ufshcd_scale_clks() and clock
 scaling error out path
Thread-Topic: [PATCH 1/2] scsi: ufs: Clean up ufshcd_scale_clks() and clock
 scaling error out path
Thread-Index: AQHV+2FxCSs4Pin03USk3FSY0RKVv6hOAA7w
Date:   Wed, 18 Mar 2020 08:19:51 +0000
Message-ID: <SN6PR04MB4640E8EF26802A44B1F5D38AFCF70@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1584342373-10282-1-git-send-email-cang@codeaurora.org>
 <1584342373-10282-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1584342373-10282-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5a4f43e-93f0-4df1-2259-08d7cb1521e0
x-ms-traffictypediagnostic: SN6PR04MB4350:
x-microsoft-antispam-prvs: <SN6PR04MB43503D5DB1D773DC384773E8FCF70@SN6PR04MB4350.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(54906003)(7696005)(316002)(9686003)(4326008)(52536014)(55016002)(2906002)(26005)(6506007)(186003)(110136005)(71200400001)(8676002)(64756008)(66556008)(66446008)(66476007)(81166006)(86362001)(81156014)(7416002)(66946007)(478600001)(8936002)(33656002)(76116006)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4350;H:SN6PR04MB4640.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KonXnQAL2KxLOLxgWi55Gm+oB6sofURUEDANdPnezpVo2Wx+yu/kwGQ2puB/7rGkDdL0jS52JSu6ZXiGPUXBpuUPPvY/VGsX+XuJLwemAaHqVUSf4NRf0gVRheoIznmGQKBAs62gcwhpE0x8K38dcJ0t9BphTPTsz0H3IVOcnxSnJ9c8hI0TOaiPVQJ30MCl3X+w8I0mzZHRK6ygI24+Jyx5+w6fkxm1MTOi+b3raTOPgAeYNz1rzS6ClcCoSSAdl6cJdQ0o48Ne7z4J0fOlNy1IVYaaIq3HenAsAztjk0FBRyAqR6a0YoV8+6gOO8aYzSQYjcPYeIpNxckcTOzAH62k7D0x0kvhrqDS/ok72eKxI0ZudtiyO6yv2xgsr22XCPVSp6qPtJWE16hwQMWayQmTylZ2G9XJVCPOPtfB9p74Ygcz0mCNqDUpAMMBx0eB
x-ms-exchange-antispam-messagedata: BpSoRNhIrrR2Ei1lQ0/KfuelB0kOZTpkk1jkFpa7HBMgdOZUKBd/h6nhOPQcJnEcZdo0u/NneX2M0RLGcdsL5siCN5KhodmT4dnJkfQ7AIo9/elzF/NB9eA3UtjyH6HsOOTTzQx8Abtp7RV/tDoKFA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a4f43e-93f0-4df1-2259-08d7cb1521e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 08:19:51.7784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SPwjba8dGm5JF/ZSV8IqoT66T09Mrc/xK9K6TXKQcrW1o3jRhW1c2ph409s/v72lqzyRssJgdcENkoImjYNUXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4350
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

>=20
> From: Subhash Jadavani <subhashj@codeaurora.org>
>=20
> This change introduces a func ufshcd_set_clk_freq() to explicitly
> set clock frequency so that it can be used in reset_and_resotre path and
> in ufshcd_scale_clks(). Meanwhile, this change cleans up the clock scalin=
g
> error out path.
>=20
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2a2a63b..63aaa88f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -855,28 +855,29 @@ static bool
> ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
>                 return false;
>  }
>=20
> -static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
> +/**
> + * ufshcd_set_clk_freq - set UFS controller clock frequencies
> + * @hba: per adapter instance
> + * @scale_up: If True, set max possible frequency othewise set low
> frequency
> + *
> + * Returns 0 if successful
> + * Returns < 0 for any other errors
> + */
> +static int ufshcd_set_clk_freq(struct ufs_hba *hba, bool scale_up)
Personally I prefer using the convention of "__scale_clks" to describe the =
privet core of scale_clks,
But I know that many people are against it.

>  {
>         int ret =3D 0;
>         struct ufs_clk_info *clki;
>         struct list_head *head =3D &hba->clk_list_head;
> -       ktime_t start =3D ktime_get();
> -       bool clk_state_changed =3D false;
>=20
>         if (list_empty(head))
>                 goto out;
>=20
> -       ret =3D ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
> -       if (ret)
> -               return ret;
> -
>         list_for_each_entry(clki, head, list) {
>                 if (!IS_ERR_OR_NULL(clki->clk)) {
>                         if (scale_up && clki->max_freq) {
>                                 if (clki->curr_freq =3D=3D clki->max_freq=
)
>                                         continue;
>=20
> -                               clk_state_changed =3D true;
>                                 ret =3D clk_set_rate(clki->clk, clki->max=
_freq);
>                                 if (ret) {
>                                         dev_err(hba->dev, "%s: %s clk set=
 rate(%dHz) failed,
> %d\n",
> @@ -895,7 +896,6 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up)
>                                 if (clki->curr_freq =3D=3D clki->min_freq=
)
>                                         continue;
>=20
> -                               clk_state_changed =3D true;
>                                 ret =3D clk_set_rate(clki->clk, clki->min=
_freq);
>                                 if (ret) {
>                                         dev_err(hba->dev, "%s: %s clk set=
 rate(%dHz) failed,
> %d\n",
> @@ -914,13 +914,36 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
> bool scale_up)
>                                 clki->name, clk_get_rate(clki->clk));
>         }
>=20
> +out:
> +       return ret;
> +}
> +
> +/**
> + * ufshcd_scale_clks - scale up or scale down UFS controller clocks
> + * @hba: per adapter instance
> + * @scale_up: True if scaling up and false if scaling down
> + *
> + * Returns 0 if successful
> + * Returns < 0 for any other errors
> + */
> +static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
> +{
> +       int ret =3D 0;
> +
> +       ret =3D ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D ufshcd_set_clk_freq(hba, scale_up);
> +       if (ret)
> +               return ret;
> +
>         ret =3D ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
> +       if (ret) {
> +               ufshcd_set_clk_freq(hba, !scale_up);
> +               return ret;
> +       }
>=20
> -out:
> -       if (clk_state_changed)
> -               trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
> -                       (scale_up ? "up" : "down"),
> -                       ktime_to_us(ktime_sub(ktime_get(), start)), ret);

Why remove the ufshcd_profile_clk_scaling trace?


>         return ret;
>  }
>=20
> @@ -1106,35 +1129,36 @@ static int ufshcd_devfreq_scale(struct ufs_hba
> *hba, bool scale_up)
>=20
>         ret =3D ufshcd_clock_scaling_prepare(hba);
>         if (ret)
> -               return ret;
> +               goto out;
Are you fixing here a hold without release?
Should make note of that.

>=20
>         /* scale down the gear before scaling down clocks */
>         if (!scale_up) {
>                 ret =3D ufshcd_scale_gear(hba, false);
>                 if (ret)
> -                       goto out;
> +                       goto clk_scaling_unprepare;
>         }
>=20
>         ret =3D ufshcd_scale_clks(hba, scale_up);
> -       if (ret) {
> -               if (!scale_up)
> -                       ufshcd_scale_gear(hba, true);
> -               goto out;
> -       }
> +       if (ret)
> +               goto scale_up_gear;
>=20
>         /* scale up the gear after scaling up clocks */
>         if (scale_up) {
>                 ret =3D ufshcd_scale_gear(hba, true);
>                 if (ret) {
>                         ufshcd_scale_clks(hba, false);
> -                       goto out;
> +                       goto clk_scaling_unprepare;
>                 }
>         }
>=20
> -       ret =3D ufshcd_vops_clk_scale_notify(hba, scale_up, POST_CHANGE);
> +       goto clk_scaling_unprepare;
I think you should find a way to make this function more readable.
Adding all those "spaghetti" gotos making it even harder to read.=20

Thanks,
Avri

>=20
> -out:
> +scale_up_gear:
> +       if (!scale_up)
> +               ufshcd_scale_gear(hba, true);
> +clk_scaling_unprepare:
>         ufshcd_clock_scaling_unprepare(hba);
> +out:
>         ufshcd_release(hba);
>         return ret;
>  }
> @@ -6251,7 +6275,7 @@ static int ufshcd_host_reset_and_restore(struct
> ufs_hba *hba)
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
>         /* scale up clocks to max frequency before full reinitialization =
*/
> -       ufshcd_scale_clks(hba, true);
> +       ufshcd_set_clk_freq(hba, true);
>=20
>         err =3D ufshcd_hba_enable(hba);
>         if (err)
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project.

