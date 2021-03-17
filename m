Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D72C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 14:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74E3C64F67
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 14:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhCQOC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 10:02:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:55158 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhCQOC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 10:02:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615989748; x=1647525748;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=m2FacuBUTADm58nxdI+02zr9kfTLgsIaGE6/CWrFQEI=;
  b=Jyc5aLt7/cSb03foBJmkNjlE9zdIv4w3nE701qhEsBV7QN3RvQzOCw/S
   I2sancoWpGWRPTFONQmUzTxnYHNt1fFdrkbcKwUCkb3LbVxSzEf7ROpTI
   A1JZt4nlBYvLTfLLoyIkerIirnUJJO1lWzVhSRYTfkigS9ZW0UNqsLAFK
   5PJhZb69LRNmWV5ltk/ZP/lcqOw/6VdMeLhhti4jkAtnmAcvF4VFx2N5E
   gNpZSNYZqL/8fr2T/C6KpNR3dA1l6Ll2elTP3eHOKiHdbun4QhlUBU6ad
   Uqi/a5UGvbKT4xyE6wN2NfapqNdCd+neAgyXdAlVYC5j0juRw1wTHlP4A
   A==;
IronPort-SDR: g46nm0mCGWTph2MfCxYy0jeJkpDy8EKKn4wPOE6WPST3e+P2yrqUd6fhx+8/v0V1e53Or5qe9C
 P8qXWDai//cKUOUWfT2yLsRcFCSVSPzV4zN8kyzj/+N0KVUuj/oydia3ai3Ig+vctnTEfUMSHy
 IRThzdYWdO+luoZDat8+CfJ4WqVvmtyw5sKuSoScIE3xfzBx+UiL8uIpzDKSSMp0aiWdYVoi3M
 La6+dQeOAJrDQ4kGP9ViiUVtZ+wR2F4FLtNCgzs84IyaJtpOG5Q4wEpII7iBbvdi+2wp8CIii6
 ttg=
X-IronPort-AV: E=Sophos;i="5.81,256,1610380800"; 
   d="scan'208";a="163509455"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 22:02:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmbJN3DkRFcufj4HOdr2TqMsFchy84WBOEOk1wWqBmqm0OpYVSERpVm8gdTgqDaL7VMyqe3xPyF7LgyT4Q9ewrFuYITUd/aaStmzRDxJWs1F1kBz/iMEH1mjSe3JJDeazHGGy7aJqUUtwRLanBSXbX1hNQ886wNDCawXpyU2/uAdOKjekRV1trF+QsWds/QNGSjqCkbe0EDILs121KH18DaNnHaOXxlDdhl37ek227IMp8H2DUOuBDMF4VP+QiblUqRv1oY2hehPQMU41DrYEFYdSYP71syRKajjOKawRm0SUYTnxdpBDSmnjhULXAJ7ESxNK8fSvvi3N6m1s7E4mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=261xfYSeDoaGbxCy0IC5+RBT0LNAAUeKp6Fk36YUnOg=;
 b=CFPp94bFOr67+6YMbl8qRgyf8RiSgRfux7+2T1HQjKV/CXgM3oG+JQ/LAG7Fgbq3ZGI4TBq1dvCFKMNIrxveEnzy/hLTzY0onNOyCdJiprhfcITS1GHl+Sa1snMTIXzsD7a6FqFoY3MOWLdZUBXSLKwq0yr7d/9N3ig4sapYpeaS1bR8Qkr1/b3QZhozDa8dWsRMOjiesda9ITwXL+vxU7cBzhOy6rFreZTlw+fNZ2qO9D4KGB+m2KVZPo2yzGsv/VnccFSWfnMr4pbIPtu/AS3CcBpYUJm8rvoj1ov1cn9xWTzMiEtDAkGy9Ik7v3OF449qZKykTDdIpyWvi2NPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=261xfYSeDoaGbxCy0IC5+RBT0LNAAUeKp6Fk36YUnOg=;
 b=N4ySEwxCkxWPMNN98bw8RBsXfufzjWGvML27veEhdioQFrfzE/ZE7f0hmGAZxsaWaEK5gdRilblAIr+ldvjCLlPsul/VXfFzNnvO8MoNzJh9RW5GnsHgLxEv7txClZe1nX/UqtRsaCuMnsVgg/qPtifxedbp5wOE+YPO2DpTYsY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6589.namprd04.prod.outlook.com (2603:10b6:5:1ba::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 14:02:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 14:02:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Yue Hu <zbestahu@gmail.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        "zbestahu@163.com" <zbestahu@163.com>
Subject: RE: [PATCH] scsi: ufs: Tidy up WB configuration code
Thread-Topic: [PATCH] scsi: ufs: Tidy up WB configuration code
Thread-Index: AQHXGyL1yhoIcuBDj0CLUEAEsuuMt6qINPAA
Date:   Wed, 17 Mar 2021 14:02:23 +0000
Message-ID: <DM6PR04MB6575F4023FAC6600288A8973FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210317114438.1900-1-zbestahu@gmail.com>
In-Reply-To: <20210317114438.1900-1-zbestahu@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d488d65-e9ca-4414-25a0-08d8e94d49f6
x-ms-traffictypediagnostic: DM6PR04MB6589:
x-microsoft-antispam-prvs: <DM6PR04MB6589812E141E2C0DB7F92C4AFC6A9@DM6PR04MB6589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:466;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H6JLcEfItb/nZXczv97H5vgDkDizZZO2tWdIh63Fcsv/640eaNdG6uAfRjSyljHcgwozBbTvCi14Sm+GmU69r7ksdHLF8ax6v71de5cuvFXfXWEavGvfH+k8WbdhAbhbIHUoYXVc6kNK4OU4Qw1+wMonKN7rphLiZs/bq5Jjjb6DYJTOVWLfwNExbkQbvSDVzcI7T9P+eWKCnbS1AwUzr7e1xKOUZawvcZR7nSYWz4kDccdUiHwrdaiApDWoNso0tzaD2JgdlUlQKvzwK5a/Gp5/UNpFL21dap5mXmXr7BX/c0YMAKzP9L97GJy15u9H4P0uHSgR0VlwDPcg7Ke1iC/00KpZfYj1wQzEROitrcnCb3S+xKayzGPJzO/1wck1HkgRk8EORBLsnXTYyHepyEf5hXksMe24ORv+wDTZKMnEm8p2z40/v4c/fT3D0KQBwUwJxVL9i0kf15yB615qLts41O7ugqYo16zJLz/mcDUlBAzG/m5UXKpzH98Mlu/qA+0EdX9tLXbVZayMODFo4SNDMVyg1tu8q8FfYhTd9e3QwNaJYbYWZK7wEYFkF0g0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(52536014)(83380400001)(66556008)(54906003)(6506007)(66446008)(26005)(2906002)(66476007)(8936002)(7696005)(71200400001)(8676002)(9686003)(316002)(55016002)(76116006)(110136005)(186003)(86362001)(5660300002)(64756008)(33656002)(66946007)(4326008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?VOkwvNGD6wAQNRR1z7w8G9bZ4iDSTcekFkUHf02hJxzfuZOG19QNL+rL+jhx?=
 =?us-ascii?Q?dNBaoYj6m5zhJhdKXqolNg67XUsxLMT9mcf3OvnGO7II6ykSRUgZpkRHQaFm?=
 =?us-ascii?Q?53tTklMedFl90dBzlidfoSU8+rd4yuvrDJRtqWNxt6WjDAZ2cVETW+BnO9uY?=
 =?us-ascii?Q?k+l6MZScjoz4Zwdo4kXEXRrRT/UxZPC0lmb2r91v/lASEs5qeVmrkwEWNyQU?=
 =?us-ascii?Q?zFR4Ygg/FdRn+osucQUwjbumPOUdPo9KQBw6kuC5L3qiR5cIp5t0xr6EngJJ?=
 =?us-ascii?Q?aUtmKzysC84nPctOV7tj+ou2Vz/TtBSvyHBGJIrgw8aatsWXKQwwTl1pT+Eq?=
 =?us-ascii?Q?YjyckxsyLcEm9T2KCn2/30xXTgHdBkEtGn6ZtM7i4+XmCT/pSG1SK+MQrZLm?=
 =?us-ascii?Q?u5uOyobWbcvgcBNbaoU5QtlUSfIt7ssNNotijyZ8mvVlEdDYrAPypDcSsRVm?=
 =?us-ascii?Q?S8y8CAvv0t+/hI4hOulyCW4JJDVqflnVfWMSUk4/jkKGlEPj+13YqJWwAPDJ?=
 =?us-ascii?Q?/3AL42h+Ekg9hf2o7q1+QPsDI5LlbN7pDIkZ0cIJqgptHmWJ3dRPifCH8CjC?=
 =?us-ascii?Q?SUqguJACPkV4p13evcL26COGcHeaRc/8a1FETXXznhs15YvJ4SGNF/1CzDA4?=
 =?us-ascii?Q?fklm8Wi2W9jSsf90yug4wv4XA+dQ+zYuZZkXCVY4Br7Si5NC5zvuk3cN4QQf?=
 =?us-ascii?Q?lVKWVlrlS+HG2VpC62A96uP+KQJa5GFBWosJl0vGb6fFYqWZFlBTMXnoOCiM?=
 =?us-ascii?Q?wa6ISPJ+VXnvRjJowdy5sfuPoSih9YjSdj8HQLIR6nPwJoHuAK6XYXz6xPUx?=
 =?us-ascii?Q?qzoXPJ5LtKSLFPGFwQOh6i1BranGpqfgFRHZEdvyMHo/pN+RRoSL8jUODTUE?=
 =?us-ascii?Q?SsZRHQ6tY8lY9IsULOOkE27hKUOM0I8Kv0yHA8KULwqRQlrEZYhnk17PvYNz?=
 =?us-ascii?Q?CgEp1Ec6HVDWy0YfluLJSi3HME1ZRKoE4oil/XFvdQls2oUzxiYbeGpx98W+?=
 =?us-ascii?Q?AMI1BA+eghLMz4y3BM8rDBPiJ09+9OEm8ytbzPeiaEtvP8IbYTYs+k4cl3jx?=
 =?us-ascii?Q?Vl/0eSRNzI5SS1wWCg8owyjlKEa0tDs6h/BsE5aZ+Yl0dfBnSr67AbmcfiEF?=
 =?us-ascii?Q?slzD2I83wWmjp9aK9/YjzmlLeVQ05m5w4JT0QJvfAaEb/cu9L6zzDXRq8AUY?=
 =?us-ascii?Q?6UhHtPNO+5q2/04P1f4E9rwQk/ta6Iv1HZ79OXYB4nBhtVlpQNcccQN6F6ls?=
 =?us-ascii?Q?iCvuHxL2LjeKWqTTToxaUHjNS9oTHuhgQMfSBYNyPQ/X6Jh5862N90x1RJD3?=
 =?us-ascii?Q?0ejiDWcKO5/b4XKkJdVJzCjF?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d488d65-e9ca-4414-25a0-08d8e94d49f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 14:02:23.4392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z/6WhU6PLrr22kR2TVBgE4ftn3zwaTJ8ljmhJcowlDeiH2MAi3M3R89SyggWYb63GEM2VPIg8sT7yH7nIZVOUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6589
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Yue Hu <huyue2@yulong.com>
>=20
> There are similar code implemetentions for WB configurations in
> ufshcd_wb_{ctrl, toggle_flush_during_h8, toggle_flush}. We can
> extract the part to create a new helper with a flag parameter to
> reduce code duplication.
>=20
> Meanwhile, change ufshcd_wb_ctrl() -> ufshcd_wb_toggle() for better
> readability.
>=20
> And remove unnecessary log messages from ufshcd_wb_config() since
> relevant toggle function will spew log respectively. Also change
> ufshcd_wb_toggle_flush{__during_h8} to void type accordingly.
>=20
> Signed-off-by: Yue Hu <huyue2@yulong.com>
A small nit below, otherwise - looks good to me.
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufshcd.c    | 99 +++++++++++++++++++-------------------=
------
>  drivers/scsi/ufs/ufshcd.h    |  2 +-
>  3 files changed, 44 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index acc54f5..d7c3cff 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -246,7 +246,7 @@ static ssize_t wb_on_store(struct device *dev, struct
> device_attribute *attr,
>         }
>=20
>         pm_runtime_get_sync(hba->dev);
> -       res =3D ufshcd_wb_ctrl(hba, wb_enable);
> +       res =3D ufshcd_wb_toggle(hba, wb_enable);
>         pm_runtime_put_sync(hba->dev);
>  out:
>         up(&hba->host_sem);
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 7716175..1368f9e 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -247,8 +247,8 @@ static int ufshcd_change_power_mode(struct ufs_hba
> *hba,
>  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>                                          struct ufs_vreg *vreg);
>  static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
> -static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool se=
t);
> -static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enabl=
e);
> +static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool s=
et);
> +static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enab=
le);
>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
>  static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
>=20
> @@ -275,20 +275,12 @@ static inline void ufshcd_disable_irq(struct ufs_hb=
a
> *hba)
>=20
>  static inline void ufshcd_wb_config(struct ufs_hba *hba)
>  {
> -       int ret;
> -
>         if (!ufshcd_is_wb_allowed(hba))
>                 return;
>=20
> -       ret =3D ufshcd_wb_ctrl(hba, true);
> -       if (ret)
> -               dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__,=
 ret);
> -       else
> -               dev_info(hba->dev, "%s: Write Booster Configured\n", __fu=
nc__);
> -       ret =3D ufshcd_wb_toggle_flush_during_h8(hba, true);
> -       if (ret)
> -               dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\=
n",
> -                       __func__, ret);
> +       ufshcd_wb_toggle(hba, true);
> +
> +       ufshcd_wb_toggle_flush_during_h8(hba, true);
>         if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
>                 ufshcd_wb_toggle_flush(hba, true);
>  }
> @@ -1268,7 +1260,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba=
,
> bool scale_up)
>         /* Enable Write Booster if we have scaled up else disable it */
>         downgrade_write(&hba->clk_scaling_lock);
>         is_writelock =3D false;
> -       ufshcd_wb_ctrl(hba, scale_up);
> +       ufshcd_wb_toggle(hba, scale_up);
>=20
>  out_unprepare:
>         ufshcd_clock_scaling_unprepare(hba, is_writelock);
> @@ -5432,85 +5424,78 @@ static void
> ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>                                 __func__, err);
>  }
>=20
> -int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
> +static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_i=
dn
> idn)
>  {
> -       int ret;
> +       int val;
Use turnery here?


>         u8 index;
> -       enum query_opcode opcode;
> +
> +       if (set)
> +               val =3D UPIU_QUERY_OPCODE_SET_FLAG;
> +       else
> +               val =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +
> +       index =3D ufshcd_wb_get_query_index(hba);
> +       return ufshcd_query_flag_retry(hba, val, idn, index, NULL);
> +}
> +
> +int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
> +{
> +       int ret;
>=20
>         if (!ufshcd_is_wb_allowed(hba))
>                 return 0;
>=20
>         if (!(enable ^ hba->dev_info.wb_enabled))
>                 return 0;
> -       if (enable)
> -               opcode =3D UPIU_QUERY_OPCODE_SET_FLAG;
> -       else
> -               opcode =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
>=20
> -       index =3D ufshcd_wb_get_query_index(hba);
> -       ret =3D ufshcd_query_flag_retry(hba, opcode,
> -                                     QUERY_FLAG_IDN_WB_EN, index, NULL);
> +       ret =3D __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_EN);
>         if (ret) {
> -               dev_err(hba->dev, "%s write booster %s failed %d\n",
> +               dev_err(hba->dev, "%s Write Booster %s failed %d\n",
>                         __func__, enable ? "enable" : "disable", ret);
>                 return ret;
>         }
>=20
>         hba->dev_info.wb_enabled =3D enable;
> -       dev_dbg(hba->dev, "%s write booster %s %d\n",
> -                       __func__, enable ? "enable" : "disable", ret);
> +       dev_info(hba->dev, "%s Write Booster %s\n",
> +                       __func__, enable ? "enabled" : "disabled");
>=20
>         return ret;
>  }
>=20
> -static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool se=
t)
> +static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool s=
et)
>  {
> -       int val;
> -       u8 index;
> -
> -       if (set)
> -               val =3D  UPIU_QUERY_OPCODE_SET_FLAG;
> -       else
> -               val =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +       int ret;
>=20
> -       index =3D ufshcd_wb_get_query_index(hba);
> -       return ufshcd_query_flag_retry(hba, val,
> -                               QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBER=
N8,
> -                               index, NULL);
> +       ret =3D __ufshcd_wb_toggle(hba, set,
> +                       QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8);
> +       if (ret) {
> +               dev_err(hba->dev, "%s: WB-Buf Flush during H8 %s failed: =
%d\n",
> +                       __func__, set ? "enable" : "disable", ret);
> +               return;
> +       }
> +       dev_dbg(hba->dev, "%s WB-Buf Flush during H8 %s\n",
> +                       __func__, set ? "enabled" : "disabled");
>  }
>=20
> -static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enabl=
e)
> +static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enab=
le)
>  {
>         int ret;
> -       u8 index;
> -       enum query_opcode opcode;
>=20
>         if (!ufshcd_is_wb_allowed(hba) ||
>             hba->dev_info.wb_buf_flush_enabled =3D=3D enable)
> -               return 0;
> -
> -       if (enable)
> -               opcode =3D UPIU_QUERY_OPCODE_SET_FLAG;
> -       else
> -               opcode =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +               return;
>=20
> -       index =3D ufshcd_wb_get_query_index(hba);
> -       ret =3D ufshcd_query_flag_retry(hba, opcode,
> -                                     QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, in=
dex,
> -                                     NULL);
> +       ret =3D __ufshcd_wb_toggle(hba, enable,
> QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN);
>         if (ret) {
>                 dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __fun=
c__,
>                         enable ? "enable" : "disable", ret);
> -               goto out;
> +               return;
>         }
>=20
>         hba->dev_info.wb_buf_flush_enabled =3D enable;
>=20
> -       dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : "disa=
bled");
> -out:
> -       return ret;
> -
> +       dev_dbg(hba->dev, "%s WB-Buf Flush %s\n",
> +                       __func__, enable ? "enabled" : "disabled");
>  }
>=20
>  static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 18e56c1..eddc819 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1099,7 +1099,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
> *hba,
>                              u8 *desc_buff, int *buff_len,
>                              enum query_opcode desc_op);
>=20
> -int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
> +int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
>=20
>  /* Wrapper functions for safely calling variant operations */
>  static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
> --
> 1.9.1

