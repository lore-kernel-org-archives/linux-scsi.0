Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B80AC4361A
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC6164EDB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446980AbhCCMr0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:26 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24107 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452227AbhCCHUa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 02:20:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614756030; x=1646292030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4USR5ChpWh444UJVlkNCRG+y3RE5QArdMmf7LMDdPoc=;
  b=XjC/cSaFDWNnXMBucRvA49nlDw7gbaHieX62pANoyLy8rKhkizx6bGB8
   63SOdKzyDGQLTS/Qs/jSMhekHfrLXDe6hjNhRbwI6z0OgHWbKTzaVCgS+
   +oI36u3/cUJ5fFQH60pY3k4K19f+8bo3mfgLJny6YhBxEYYzyu5UEgb4p
   PKmcGRzqM/RYdb8G+vkzL2Cmnbc/1o/taIPmzKvS+Op81IBq1FYcZpkU8
   7OHJgAygYQBI+p2j65P/35P+pfyJSjwyA/3LRMm8IvGVb+Vj5vLruH1K9
   v5xPqCoU7RtveM2ZThiENAxSOUD3Pw97F8ZCQABElvVUCV9oYAz3IiOty
   g==;
IronPort-SDR: G74SV63rezumexV4OVufwISfMpOeHqABQUq+tclndUzXBQnWqsxAlg4YAwIA6kMJsNhrN+jT3r
 3JHPzLjXCy5Pcyn4xf4zdT1VJNPozuqi4S+NGe7XQ1tRahP201bIK8NPq3+x4DEfhKQBg+70R5
 dKY8XxIjlBgcllz2smmtqywfYF9tLcap/ps9l07R0HM6lUQx2v8Esd2kxgsMLrMPA8wmhXiIY3
 Uz44pciWhfR8/nh/c+dC8h/o1nvNs6r5jXz5z7C8cHZae/vOO2e1CsOXXcJzd5BMk7I6A3ks1R
 PmI=
X-IronPort-AV: E=Sophos;i="5.81,219,1610380800"; 
   d="scan'208";a="162398752"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2021 15:19:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bt14E1Xug4Ty46IA1W+DxJofjiOFiB9aVgQA2wWj486wM/OHCLOtGXw+WC/R76QLQ/GSXdlRQFQXkTcTrqjC8wIErXkjOoiNI8KxEXpsun0TZ1t+Bde3/knooMpULKUXyfS9bXh0tzTPI05T0061AlvT8w4xhHlbhtwGxYbFngEj1J/X66Hicf02ZyhqjiMRvb2M9hsG0lvDSSipmE9N5m3J3SbTF+WBZjsPRpUdKeD4XoA1LB52P7CQgWmSFtZKoV1jYz3MbJ5u8oYKgr3+pWVMS4xsVCKN2FAahW+UlAVVzt9/j8tb5+BLDC6LeA/pUJFN4oz3yfRC8QjCBdheRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyLR3B1W4axGu8NWMjSqG+oyaI2i+ak64Vw5SGIQ8dE=;
 b=X3pvSLCZmDLMdGeBAra+h6z6mrPhUejKyG2YYPiK8Vkpyn51SBbaZvhHmBUFjtH9DVavIjkzxKD7BoV9DTLVCrVU3TLPgiPDgNi8jx961ZAh/6AIErTLZozcOgBOeeep1OHu515ZWooiudf+Lz9sPakl+r9PLP8vMZ+xiRG+YwiSDINR/9wyhHpNeSIkRoqf69r0gXJN3NyBr4t822JWWGhMHiOXN6uU6BPiWV4uwmbmQysbEEEsbfzffXYvxq35gkR/c7FxJFUgdOPPPgNR3ErwYUr/sjX7T9ST2/R1P2Y7Zfty0QLhI/YPu3WNbtXTzML+rboaiVUHJI+gmf1rcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyLR3B1W4axGu8NWMjSqG+oyaI2i+ak64Vw5SGIQ8dE=;
 b=i9BGg2DVzQpesDO6UQgo2XgMCtbffFUL2fJ7ei2S6DYiKV684XHdRLYCgZP88xMJqmvO/QukY3qpVOAslelZH1GrbhKUqM976iNVcTHKY1DPDi2aoLppLK+VTG1qtuR/dcb7xi6uzXi5iSNCAATRcTosLKrqog4Ah8XxmDqECo8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0970.namprd04.prod.outlook.com (2603:10b6:4:47::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Wed, 3 Mar 2021 07:19:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 07:19:22 +0000
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
Subject: RE: [PATCH v2 3/3] scsi: ufs: Remove redundant checks of !hba in
 suspend/resume callbacks
Thread-Topic: [PATCH v2 3/3] scsi: ufs: Remove redundant checks of !hba in
 suspend/resume callbacks
Thread-Index: AQHXCm9gO8v0f6H3g0amtwRrqOzM0qpx5goQ
Date:   Wed, 3 Mar 2021 07:19:22 +0000
Message-ID: <DM6PR04MB657592719F6C029BA23B49E3FC989@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
 <1614145010-36079-4-git-send-email-cang@codeaurora.org>
In-Reply-To: <1614145010-36079-4-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 76c5b6dd-fa2e-4b73-9fd5-08d8de14aaf2
x-ms-traffictypediagnostic: DM5PR04MB0970:
x-microsoft-antispam-prvs: <DM5PR04MB09705793EB17B8294ED558D0FC989@DM5PR04MB0970.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SUb7NXb24eiIBEjpLqxpy++MCfrmZ5g6+6o/Fx96/JzDsfJPHbZg6ygm3j4SN02sQUKj3HEw15GWKAzljN/M4LnOmp0HSi1Qb5ufIiAHxGruyUJ3PzAdyKKthhZeHgJmlk9cxqx2trhlTp7eGbtHWU1SGfanio2J4Kj/juuXXNVmWBw0cuA2mGio1kCU4D+EMCrF7mZrolNx0bxA8lcV7OyVR5efvpD7cGU6W9+oVHy5kvEqIHWxbMBwz9LQnBn0wrcGg7AfOo3OLISrYO/vXzkht9dHL/Q055r+0HSoZ7S/td3nYaSBWbDMCYjRIoi3LgRDsDl5nxN9jDNoO2GkkvRIPFUQEj2ofvheVCP4cgmlKzn6qcBhyozSe3Aw0KmNfjN5jC6YlfYP0iWJty0ejs1zpJuiuqhMZdo7/fOpL+v9NCV13Co62f0V6LxBfZ0yTDJm8MffF3JDUJl2LKpbewEZ6+e+QXMskc+lIy9FtnP9T9ubvGxbaik/xRMIJiuFPS4IfTfGa5eA+JTQsI3J2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(71200400001)(54906003)(7416002)(26005)(6506007)(86362001)(52536014)(186003)(8936002)(9686003)(2906002)(5660300002)(15650500001)(8676002)(55016002)(64756008)(7696005)(33656002)(110136005)(66476007)(4326008)(66446008)(316002)(478600001)(66946007)(76116006)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XKbIP28VmTbz87+szdDlb1uDNqLHwGXmk+BvLHdHgKjXcF2eBj21CBkYnT/l?=
 =?us-ascii?Q?ivxYCYL9k8SlwgcPa6wsVF8ux+rg9gvy5wDZtQDWj0EDzAtRbLUSNF4ywZYA?=
 =?us-ascii?Q?LOKd9QN4cKoakqvunjHaGBeV/1umCHwkxhjnbFF+RlK5VK+J8F99kxZgMaot?=
 =?us-ascii?Q?kLoksCalXGJ/jSufiNTBmJJXJf1toMRI96HsMcKZTGNWl72NM/x1NjTsV1LC?=
 =?us-ascii?Q?3FgHryvn2lpoAt1R3NYVSXu4rs3xl2PO9HqCr/z0UlHWktfcDPKYe5LYAAaI?=
 =?us-ascii?Q?WdnVJQz8agB54UScYDCfCjVs5ZJ+xhjfofGvUmQ6oprJ5ENB5U0fbbXYMVll?=
 =?us-ascii?Q?heemIVbCTKsbEvfgJyhdr4VfCvHt2E3/CXwwCcMbg6MD9I3M4yIh/qkxUovR?=
 =?us-ascii?Q?Gq2kqL6CVobdjo8H43/1LmdaXt45VqHm2sCs2Lfw92+UsXGjnQus9KbpP+JO?=
 =?us-ascii?Q?Y5T///s475scJbIuxRAzSNhZYG7Ku0mRfjI3F1z34iqohzeva+bsWO5Rux7i?=
 =?us-ascii?Q?0jJbdxxaVNKcwyuoNDdDDAFiq3k/TQNWG5avpDLe00OeHg3jjPLP1pKhxhs6?=
 =?us-ascii?Q?0cfHcpNOtwiI/AhnZUvz34p/NJqcb64rXq4gmuvxiVtNfa84wnUZdj095iRb?=
 =?us-ascii?Q?1Hgaod39T8Qc9jQj3isUXdqLjaLA52gkA4b3jbVWxfkY2AuSDAmhp/nR8ru3?=
 =?us-ascii?Q?MFWmahIN99O1vYDmUwmRnSL+asyDilvp7KwT2sf7DFOdmZCA1VuOQz6gxrAL?=
 =?us-ascii?Q?m4Co5+tCgIChOrt3hM2Q9O/pFFXiURXnqdXtok2Kd5dTALT42iGd1ShWHr7e?=
 =?us-ascii?Q?yt0byA1QuZkdclsWeSFXMDUBtUg03FWJ642FXcvubLaJwgzZ6g3mLdy5yDPJ?=
 =?us-ascii?Q?lQRWgJcuWgtmnIpikkCpgbDhrCBTzhBWlNCtNf/00Gzrrbh2RN9B4XmgDUZ2?=
 =?us-ascii?Q?g4bqy1BsRsdIcBLnf40qfPLGVwkXRbkN+cgQbSKP1LW02q71GNntd5kC57oN?=
 =?us-ascii?Q?CZeHc5wlXY0VlVYBmBceAVchdOIdAbKNREffU0HfGDwwbf41ogoicHuGc4ya?=
 =?us-ascii?Q?WXSdOIlR9H3NKFeFosun6goZJSqaAa+5SDEZzEKyXMWsWDu3/XkjiRNDE04O?=
 =?us-ascii?Q?3zDG27/YLfyFfVhhfJLr9y3Gr+0llDff2K6iQotZR2nDhhCkcysJubLrM8k2?=
 =?us-ascii?Q?TKDqDMMPIpE7vIf6KcJtwWvHpoD8QISPa29HixZFj/FHx9GtVY06ICdWTuvw?=
 =?us-ascii?Q?vUou49oZ8nVpU5pT1A6pD7q28Y1AILZ9oAopbP5jE+amKdR0odbsw7DfeQZK?=
 =?us-ascii?Q?B6tM380AxllPWnWH2KdmTh4j?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c5b6dd-fa2e-4b73-9fd5-08d8de14aaf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 07:19:22.0410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJQKiiqlNztkBGjll19wpyRmMFTSNOexFIVM+WOXaBH1bTujypUvZd8B2t3CkkDT30rZmCJ4aXTpQUpZMXDQuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0970
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Runtime and system suspend/resume can only come after hba probe invokes
> platform_set_drvdata(pdev, hba), meaning hba cannot be NULL in these PM
> callbacks, so remove the checks of !hba.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 21 ---------------------
>  1 file changed, 21 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 013eb73..2517ef1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -95,8 +95,6 @@
>                        16, 4, buf, __len, false);                        =
\
>  } while (0)
>=20
> -static bool early_suspend;
> -
>  int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>                      const char *prefix)
>  {
> @@ -8978,11 +8976,6 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>         int ret =3D 0;
>         ktime_t start =3D ktime_get();
>=20
> -       if (!hba) {
> -               early_suspend =3D true;
> -               return 0;
> -       }
> -
>         down(&hba->host_sem);
>=20
>         if (!hba->is_powered)
> @@ -9034,14 +9027,6 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>         int ret =3D 0;
>         ktime_t start =3D ktime_get();
>=20
> -       if (!hba)
> -               return -EINVAL;
> -
> -       if (unlikely(early_suspend)) {
> -               early_suspend =3D false;
> -               down(&hba->host_sem);
> -       }
> -
>         if (!hba->is_powered || pm_runtime_suspended(hba->dev))
>                 /*
>                  * Let the runtime resume take care of resuming
> @@ -9074,9 +9059,6 @@ int ufshcd_runtime_suspend(struct ufs_hba *hba)
>         int ret =3D 0;
>         ktime_t start =3D ktime_get();
>=20
> -       if (!hba)
> -               return -EINVAL;
> -
>         if (!hba->is_powered)
>                 goto out;
>         else
> @@ -9115,9 +9097,6 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
>         int ret =3D 0;
>         ktime_t start =3D ktime_get();
>=20
> -       if (!hba)
> -               return -EINVAL;
> -
>         if (!hba->is_powered)
>                 goto out;
>         else
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x
> Foundation Collaborative Project.

