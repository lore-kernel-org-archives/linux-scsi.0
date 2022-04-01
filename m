Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C2CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 19:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350329AbiDAT6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 15:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiDAT63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 15:58:29 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E0E208245
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 12:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648842999; x=1680378999;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cLs4+aKqG1L1lB81CIkKnnCDoeE3sj6L/xjuj1RUYjE=;
  b=gzIetah1vyo/aDkZ/W0//OZdgaQFq87lH1NTJvBLy+4jKiqUQ5ahh5s0
   2W6GD18uexQy79fxiJze3c+yysHcqHdioYbMqJ6AVbiBgbIbMxOAF4qn+
   3l7YgSc4aqDm+VBJb5aH+uZdllNUcEJxL5PUunqUWuTy0+CG1h8oKxku1
   fC14OOT+A/pOMvN3p2EFpMokIhC16J6D4NrR/MWA6/aOQENeb2YSGBn9u
   YBDfxeEAuxU5FcxnWZtpYZbODkUdwtTrvqalApjy1mPRNV1hb1HrOAERH
   HiX1mPaocCMx7u7X5gvpFGz3P9rb9zLurRf0NcmdXzzTTb3q+MSbbsZEa
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="301033938"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 03:56:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldnpdj7t+pcGxT37wNkLdzVT6Pl2idr7W6MD2HyPgjjvI6Xcf9M19VYlPJ8EzWlP9zEi3YCSOs1TnqAbiIK4xbatGbMXyH3f4920I600LQFN7b8O/VKSkEPWX7PA4oMgy8SPKIwykXsVYuWn6dktXLxI00cTMWsThpLVnRCdourhq87DQ/wQ4go4VKPl3QhcvNcSWkZa/I1l/S+PKqAr8JhSCie0X217uJVPjzDO48Z0PetcPV6nUgIALfI62vnMRjqBhwL97/v24dGAdBVCVyvrNrPLy4n4Yb8Bo+7KJdGK3xXIDWvRUDnI4C/silh3jRBtnwsgaH3XaZ4QHbXJbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00j4raQckP13Pg+ns7KhyyxjbksTcnp55H5s5QpXovk=;
 b=DlA1Ej0d1ll+sjDn3wX2cWhQPpuSVhcyy+RhYkGR9NIoZnhVq09ANTHdXcq8cRBjLPW3N6OHYp6El8/hdbwbzx0n65l20aFdB0obkPNAx9TGILFHNTcXCWmSZtZ+A8eBLdPpKYqllYBvv/j62L0GTfUbA8Y++4XlAJ/tAKCRrSLbRUn80TSCTgY2mrXNHfqHTfMwWX/5YiYBoSnYfmlWgwdAsXlUK6fCp3oYY/fiBoKVyhMezUSnMlu2uPtjC+qhc35A9yL5oUyfIYcXcVMIzYT/YGatdDBwl5PrsqUPdC5RURcswnbIRPsyZHh7gjo5o5oNmd9uv7Fd+TbWYfr+GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00j4raQckP13Pg+ns7KhyyxjbksTcnp55H5s5QpXovk=;
 b=XSzmieJpe1XJrx+ta5ytBurIVPatC8VmpoalHpkS6+bG+APf0hvoCfqDcBedDRSPvmCCqhD24yOAVJaAsUrQGyS7ZQciAuCieDA8TjFTIPeuYcTSpbHmSQty5Tc53Skyw63TEb06KxUxvX/VfNvm7A7Z5pOvIJdJ52k8Y+AAtjg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BYAPR04MB4502.namprd04.prod.outlook.com (2603:10b6:a03:5a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.28; Fri, 1 Apr 2022 19:56:35 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 19:56:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Thread-Topic: [PATCH 09/29] scsi: ufs: Declare the quirks array const
Thread-Index: AQHYRU+53ppBLoiabkmFw8ebhOits6zbeRLA
Date:   Fri, 1 Apr 2022 19:56:35 +0000
Message-ID: <DM6PR04MB65757609D6D12BA09C6DEC4FFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-10-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eefced32-eda5-48e8-0a57-08da1419ba3d
x-ms-traffictypediagnostic: BYAPR04MB4502:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4502E924816D68482330E7C8FCE09@BYAPR04MB4502.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nuo0a1We+NDBSrTI5aYj7AZYXE+cCLMJ8UO8DVLxCl7CI8NjJpgpX/nAG16waPK6d85LrV8fgOIwxRmCPFE2iRS3/TgBFtAP3+kt0cabdgKf8rA6SJ5wGe+3h3lhmGbT7eaG8t1UyzHz/JAh6shET8WXv1B8J3NlUgEqnwm078XOQVgm77LaoGtXWCuDJRHjcCV235lkmNctty61SFmEtP3ZE9DP9kcXGRAlKy2hHkfj0cYxsur8nFjwcugzi2phj/zB/b6QHMrPqmC/cZvCCgKMOnmExLGK7Ryj3qoli0+hHX0bz3lna2TYZQuRea4/zpum6LTWGHiNG1Sqp5GX0dgBUMPbrc9CFL3OZ8RJUW1AIbHHISRFIuiDvi8UtuI0VvpyZjahX/OeSN8vEH7Ur+eZVflgPSbax19g/+4+mjpOo2Ubk0I+/exY2bqRBP3uzHiDkiBXkRtTsh7g3Mda6aiscj5/suRjNmBS6jPgnhaJB/TKZsZCPHoNDVV9sv2P0l1hU0K5kIuFjOGN3YTx2BXxDkh7KDwIWdRIsqv9teuysFj95fD7+EmPxFfJD6zGP4SSo809JN/Iq6N04M/Drw+m0P2edB01qUNiqbfUP3cOvR8vIYm1Aqhww2Okzgbby7zQChiT5mDjpANfJASNYda6BsBzwfxpzRz3Es6wzPf00B6HJDJ80CQ4x9PWWsI0QyMhktEpAC6CSfwtc4MtZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(9686003)(7696005)(6506007)(2906002)(82960400001)(7416002)(122000001)(38100700002)(55016003)(83380400001)(66556008)(8936002)(33656002)(186003)(26005)(316002)(76116006)(66946007)(71200400001)(64756008)(8676002)(52536014)(66476007)(66446008)(38070700005)(4326008)(110136005)(5660300002)(54906003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LPwjjEgYPvKOwEaWtT7oDO1A5448mhhZ2KYd6bZ+PeYwCG1dVy+bQeea65qR?=
 =?us-ascii?Q?eh+2VatDM1EfWBXISkkpG771J5n9TugPvMp1yb3eUoX0UqnivyEkpZ4UWFW/?=
 =?us-ascii?Q?j2fds2rFUTGNN+QLuGmEwDVyaDI5RYhR+70jK45pVf4V8amWkNdrneKLiA0C?=
 =?us-ascii?Q?/8OmoaO3V/ZKpAxnSFZBdLAyomsN6hYMNug5u70/IqUNFjOAlByoAj5M0v3a?=
 =?us-ascii?Q?Fdwm8XzzIlrdydJDsnoXXKqGIV88+95W6S55iztZ4gBR7Y+qzavp9oRY+ph2?=
 =?us-ascii?Q?ZTv6aWrNT40Fv17OIpSPrwodQzdM2r8jzAML6GLCGo4DSFlS3/+fQBswsMvA?=
 =?us-ascii?Q?NbMoyZ7Qxi5c+/wQKr7T6T67dtRWhzRiwbmU/Q/M0DR+/yQ71UyOrZWgnQY8?=
 =?us-ascii?Q?dczu1YIhuk9Ux6ptq6cL5m6RBJzXe7/zuxpWYZb3OpXiMrOS05tjn681Rh4L?=
 =?us-ascii?Q?QfmYlR3v3xdPgojx4Eqe6AlGL+tbHSfioeojuLt3Mi9eXnkrQVkQJVf2cS8t?=
 =?us-ascii?Q?UMoo6+WYUGK45/NpP6/pUpOm8b2gUHBPigTonlTRvOrUIqpkIx5xTUD1TVLZ?=
 =?us-ascii?Q?LQNK2T44zGl6K0DwP3MBqMHxZo5qu0mh7+4anIpy1Yov01/7uXRSYP8H1BZd?=
 =?us-ascii?Q?wXpOVymBJspCxS9vOcaCOe+fvG0mv+tiVxkZHI3smAr3uH1DetdSO1vuEeg4?=
 =?us-ascii?Q?mjs0bVWviIrl8f3S/vZ73nxes65cVJvGUxYdg79qIpfV10As8m2UJDQhrCBf?=
 =?us-ascii?Q?kLFl9+g0nkudhYo/RX3Bf7yD3hxtnGjZxqvyYuRUkJo/RqqFFTeDl+NKVahp?=
 =?us-ascii?Q?RzmiuEZReNIkTHMyrfL0fglSVvQOQSCuq3xJmL2+7tKbu/vBEg+W2M7oFw0w?=
 =?us-ascii?Q?KB0/4xBBsQJN++2R3X/wpDsz4bfzCpK4xiHv7pxLE+OGU8gBcTypyuXpy2RK?=
 =?us-ascii?Q?OdZ1lBACTlMu+k63cQ/uAd63ykuoXRXnVRJag4JUzNzcU/UM0dpX3lhEJNuV?=
 =?us-ascii?Q?OV1KWxjLo4S0BW+boxSObYLQRATIjYF8lJTuYdBnmbv0d4l9uy1JoXv4Dk5b?=
 =?us-ascii?Q?Zx7Wq+flNJY6Tk+aY+AkcZfOiBtrgYZh5RS0J2eaKLsV/0H8EDw56LlDkCaa?=
 =?us-ascii?Q?+CR0qgVIoCJPnatuBdauchi92vMnOvIIlJzXg6kllg83oqOr3bQptLuno228?=
 =?us-ascii?Q?bQU5m0NifX5qcgCBMopFWaVnj2RnOoqlV/v58wRQLyBVcRgj8O1y+CH13djk?=
 =?us-ascii?Q?NCzt8fElKX9gsFDfYG0nx+m/941g3FoBk92LiF552ub406o4VOAuX9AJD4hN?=
 =?us-ascii?Q?Jc2n1uuxB+KlBDTBKw6FmIrf/Td3BkUHkg2RewWKd6PeMdo3uItBE5wnzERz?=
 =?us-ascii?Q?JpIBSiMwH9ocae2X/cSO0jAG/urT3PBQ0i8Jf9+lM+yy6PcmlrOkT58gue2w?=
 =?us-ascii?Q?0GiPOfukwMPpWMsAa4MbZdgrXD4VqIq9JQYy4sxRy7jBIconbnChvfT8HC3/?=
 =?us-ascii?Q?wSFKrN7KspRkVCpniZ6+v4Bhea8WBnC/xKHqzW+dd/p8X0DKcym4TPnxyu2N?=
 =?us-ascii?Q?RSyOo2sVZW/j2JgEV/uqTsBBHYIpCr1lai3oSSRSEQJOQVTBN2qGRgeGpc5L?=
 =?us-ascii?Q?21bAz/vn2yFakJA1TOxlj0uIupa34cXORn9QNCbL2r3GMkaPMH4KY89im9Wz?=
 =?us-ascii?Q?7oQ4EAAXIyOGw38utEyZSP3iLyXBIVgTMLrN4mK+vNFnbc0XzAnYqtoYNaKF?=
 =?us-ascii?Q?I2zkvtv7rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefced32-eda5-48e8-0a57-08da1419ba3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 19:56:35.6865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vAwgqhf2hoeqP9DAV7R8FAH7bpA/f7fBFwpCVyy4MHjPKxGkURttvUJ5umFt8cjID1cf5ZG+ccMITL24ESh8KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4502
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Declare the quirks array and also its 'model' member const to make it exp=
licit
> that these are not modified.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Sometimes it's useful to be able to add a quirk as part of e.g. a debug ses=
sion in the OEM premises.
And not always we are able to recompile the kernel.=20
Since we have a debugfs now, how about adding this capability, instead of b=
locking it?

Thanks,
Avri
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 2 +-
>  drivers/scsi/ufs/ufs_quirks.h   | 2 +-
>  drivers/scsi/ufs/ufshcd.c       | 7 ++++---
>  drivers/scsi/ufs/ufshcd.h       | 3 ++-
>  4 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index 217348dde6a6..9a4474210627 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -44,7 +44,7 @@
>  #define ufs_mtk_device_reset_ctrl(high, res) \
>         ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, high, res)
>=20
> -static struct ufs_dev_quirk ufs_mtk_dev_fixups[] =3D {
> +static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] =3D {
>         { .wmanufacturerid =3D UFS_VENDOR_MICRON,
>           .model =3D UFS_ANY_MODEL,
>           .quirk =3D UFS_DEVICE_QUIRK_DELAY_AFTER_LPM }, diff --git
> a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h index
> e38dec5f0351..bcb4f004bed5 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -25,7 +25,7 @@
>   */
>  struct ufs_dev_quirk {
>         u16 wmanufacturerid;
> -       u8 *model;
> +       const u8 *model;
>         unsigned int quirk;
>  };
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 97b9b2b77593..931ce620fc34 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -204,7 +204,7 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum
> ufs_dev_pwr_mode dev_state,
>         return UFS_PM_LVL_0;
>  }
>=20
> -static struct ufs_dev_quirk ufs_fixups[] =3D {
> +static const struct ufs_dev_quirk ufs_fixups[] =3D {
>         /* UFS cards deviations table */
>         { .wmanufacturerid =3D UFS_VENDOR_MICRON,
>           .model =3D UFS_ANY_MODEL,
> @@ -7624,9 +7624,10 @@ static void ufshcd_temp_notif_probe(struct ufs_hba
> *hba, u8 *desc_buf)
>         }
>  }
>=20
> -void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_quirk *=
fixups)
> +void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
> +                            const struct ufs_dev_quirk *fixups)
>  {
> -       struct ufs_dev_quirk *f;
> +       const struct ufs_dev_quirk *f;
>         struct ufs_dev_info *dev_info =3D &hba->dev_info;
>=20
>         if (!fixups)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> 3d18581afc2b..107d19e98d52 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1180,7 +1180,8 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum
> query_opcode opcode,
>=20
>  void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);  void
> ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit); -void
> ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_quirk *fixups=
);
> +void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
> +                            const struct ufs_dev_quirk *fixups);
>  #define SD_ASCII_STD true
>  #define SD_RAW false
>  int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
