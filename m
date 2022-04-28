Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9D9C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 07:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbiD1Hla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Apr 2022 03:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiD1Hl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Apr 2022 03:41:27 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD3E9AE40
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 00:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651131490; x=1682667490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jGWwQmavjyDZJpB6H6zABqGcInW2S5LtcyjBE7Cpmb8=;
  b=NIBLD9WpaPf/BlXYRrln51HXV5AslIumfwMUhoFYRRXuWUk+685A1Dw0
   5zfFRFeAs2sLhQ8Qxk8UBCHJVXttE5bCEOJg7bDGHK1bW73GKrhpoJyhB
   gQAfoCvq25mYYq95dAh+Gbpq/ZjIg6Gbbl0t606SsAAzNV/TCxdZR6CXL
   WHpwEarzfLtm+DI8R4foOWgQVojQZ9XIDwtfsmvv+uTmRAc5WpZnZKqWk
   H6mWhNZy47b7OnsW3hkwfmwPJZpSvH4vGxzd1bhFP9oX8rYpHXcVnpdf5
   YyadAT9pOt/4q42OTR1HxJMR1yx+4+TJP0fSjf/n5tJ0VLPYDtMiYObVA
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,295,1643644800"; 
   d="scan'208";a="203908144"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 15:38:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC5YXAqCUQCXiDtl15WyA7F6U3UqP1w3p3XzX5sNEzkOJE9tQQ6ReBHat8q3zla/NieMCknIJAaYro5XMsDQG1uPKkbcBzasXeLgbDi9eVuelOUevNnODOrLCKPtNpnpbqNRC/qQxmouqwZf/j3S6uIZSZNwCzfMvRQeHHjdbozl2fK/F8F5y4PX8PXt+t/4nNSxM6wvO92/ceFqC35Y9lPlt/zcailrKD4SI9ZIyNuZ5NAQ1Jciql8H0qfd0qPI7/pz8t6HM+yTPY4zg1uesvnMohcRLy//auZddeyycgRUzfsHDCILiHpwZ668L5pm247XQc/uGpbiWAT4CygskA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzNbXf7pN3lA4+CFKQgw1GSFXYb6iyC57fTJlk5Pv6U=;
 b=Tf3WcGMly9kSiP+SLUsUKLoGToC/Hu0QHpDGLuWGdfJaoIJenXUy9tW8YhIbNS3qD9JiTxe/EyGvyoT9ekBYIRPyXFmv/48bI+R8kcY0EuHQg8sI8jcuAgXXiuoY6fd5wIFe8pMkcqKtRNhgY9LBtMyNhnpkzi9BS8jKKQQiKCOwwFnu9QWenZKSt8HRWuR9jJsB141TO3oZvN+s3EDMYVMZqzIRXam7t42iLv9lMXFZ1bedQh0xW61iT6La4OQPmolgmHh05/8wx3jC3XrYMzu7deLycs07tfV5IV3QMfEluFm9qZorxelcEuL1eOcmSyEv6Vpj2RczDeqT3FxfiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzNbXf7pN3lA4+CFKQgw1GSFXYb6iyC57fTJlk5Pv6U=;
 b=lwJ6GFWh/sESR4vgM3wFHmpFKlFiaSlNKfKcclH63UBJ5+zNWD9iiAvS2QRsGknmgZEq6yvs6kUAeJwWIEHSL/CsojLOuVflW0MrKgyQm9hcsTD5nHEAvKTW+hAt/r7SxE3lzftJWC3/wqgQN9bSCLGeNsh0SHSm5rSJW4ALgzY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB6392.namprd04.prod.outlook.com (2603:10b6:a03:1ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 28 Apr
 2022 07:38:10 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 07:38:10 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/4] scsi: ufs: Move a clock scaling check
Thread-Topic: [PATCH 2/4] scsi: ufs: Move a clock scaling check
Thread-Index: AQHYWpAPCgeI1PjC+EmQn+ga8JrAva0E8ERA
Date:   Thu, 28 Apr 2022 07:38:10 +0000
Message-ID: <DM6PR04MB6575D637A530236D970386F6FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220427233855.2685505-1-bvanassche@acm.org>
 <20220427233855.2685505-3-bvanassche@acm.org>
In-Reply-To: <20220427233855.2685505-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b6d7080-d988-43cf-d782-08da28ea0b71
x-ms-traffictypediagnostic: BY5PR04MB6392:EE_
x-microsoft-antispam-prvs: <BY5PR04MB63929BE0819F1B93471455C4FCFD9@BY5PR04MB6392.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8wSce9A0wC3aAory70LTg/3xCNu1ry1PrjS0kTBpJCOZtXFbd0gVU3Ra7SPCGYjGWr7ImyGFjKhLvppvIdkMDTI/7HAkaHQ03WZp9fhbFyb0jD2QA6K9fjLV5H1Lib6yTQFi/KLJmyvKRZOSNFC+NxoZL5aUmDkqojoTS+EUChvrzW6TczbMB7PWwv4QMOm+Sg+pZRtd3TkZNntGgu8SjTuE6AAL7H6ZCRTZ0Jna7Yn7aroKCBhwb5BK0jvQrPHNRNR0jfV4ULfpBrkOjBEJXYdGbxnTbMu5PuuVibeTLTy2qK/v5E8MZySnWBK8XGs7NrEUyAXh1Fs1pcr38O0x6N9Ssb3DZAE27dPxJ4sPX5tVxIgaokfx9Ke7OCXlNqI3jIrMj4ZXvKGtFFreCAianYj6BYk8Uf3EbBEau8EM/VuggkYO3tjVo3DxBVFF0OqnU0ULEbqlmGGLAiOvuFwF755FZJWsDeouLInInwkVWEyi/6zZgky40aw/MJTc3ywQ4I+GpoNwidBS3lnsbX02bofmVFvsmn3tqAuoG4jAhk4Lq4u32ZmeoyekPf/GRayFAmN8izgTbj1boWhHiULJSHi+u/bUO85whemFu63Bsb4+4NEvc+bvQK5eAEySAVF8zatb9HFCFUsxFU+kyPbGdqic3oN1tlAopEaKFUDoeOrWsGu94x/yG5l4FlspzJ8fWlpFkXEfl9oSf8pNsuPufQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(9686003)(55016003)(71200400001)(2906002)(8936002)(33656002)(5660300002)(52536014)(7696005)(6506007)(38070700005)(38100700002)(122000001)(54906003)(186003)(316002)(83380400001)(82960400001)(110136005)(66476007)(64756008)(66556008)(66446008)(4326008)(8676002)(76116006)(508600001)(86362001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x1YcXkL5PWcORkGqyYFNFsUPobtznPU51liJC5RvnIfxdYF9+U8oAiO/vPuD?=
 =?us-ascii?Q?tmvwTUwGrHnpWpxKlg/+3mgBNzB4QkMdllo5ozHE8xKPWEWwN08ngSX8nvDk?=
 =?us-ascii?Q?MvoMDmQZFTnvOVu17M0snXbgvCHPStNc/LqcljOLPckKRxJUaYZNuxickMVc?=
 =?us-ascii?Q?mQsQwxriErTKTJ7ZzAQizC7whCHO26b9VjCJakMtOZkzOPZkdcibmV6fJq3Z?=
 =?us-ascii?Q?bia5In+JMW3NqcMrhHvye8BfIgle8/JOhxE0WkvXPD+KgMwOtq/wvEWD8Gfy?=
 =?us-ascii?Q?ZvozrN298ZocBSW4m4if+CvlFzM9q5xvc/5SYhF3H0gcXQ3CkMOykEb1BCG6?=
 =?us-ascii?Q?Ac/pmcL3/iGTAs8M0DuA5TN+1MKny+8FofM0WXg1JPMIVaVubVvpv9BcjdsM?=
 =?us-ascii?Q?iYQMAjGv4dm9FQIr0FTzpNPmiIJg91UMNYihAvhK3NT0wVS4dF1OIyyQdtYD?=
 =?us-ascii?Q?YzipBwuEHtEGjcWwfh1i0OnkF+r2WZqIleIpXSJeapLNo/+HB4v5sj30Jcjr?=
 =?us-ascii?Q?Az4bVKrfRXmiSnt/1jFvO3uWfA9Zykfkp6STErnKtdyQKk6eGbfosUqPvqCz?=
 =?us-ascii?Q?EKO5M5WSlv1TfiqDS8+YzF40LS8aqTgSg95od41LlpQgOVM8BRV6h+ihKcEW?=
 =?us-ascii?Q?1dQXPEfjkhHpUGgrjXGik8MxdcFT9/ynPLURqG42HRXHRhkJfY2OxeDw3gN+?=
 =?us-ascii?Q?LAtMN882Ppag+x2zrel/DHq8F1BjX3/07UEkOIHio5mxMnfkTY+3CRYaLTTb?=
 =?us-ascii?Q?XFR6bvhJ84mdTVjH9Bm547Kof6prb0V649BR7zThVJnY9N47bsAq52P9fk8f?=
 =?us-ascii?Q?B4nLZ/2yLyZBNbXSfbA4pMPsro6XY8xhoyNbHsaLYXTrlAvIaw00ipvG1LQZ?=
 =?us-ascii?Q?7Jx+f7RZHeG6muV7CqCift4Jh9h9SGrvdPZhP8tKieXHUDkhIWYKbrCycfhY?=
 =?us-ascii?Q?7yywIXjLzvsZHv8mmDBWoac/M0IR9iO4R4GqX2CaPBrUCVHO06A4jJzF5Hjh?=
 =?us-ascii?Q?x7VQ5k9z3muf2bLmvflGULxz6KnkK1owEm87zUfeOdySswJ51XVU0YCOffTR?=
 =?us-ascii?Q?zXMAu6IRZVhya52HoX0wgOP3cipuaTQyfe3uHwm3MfTLRqlxrLGDHx9jhr65?=
 =?us-ascii?Q?NT8av6FMbWs9aDWexzegYUyLTEAfwSuGpcq8OBUgQiy/Pelxfu+xadr6NwF6?=
 =?us-ascii?Q?2JZ+GzqsB+3unlashRbyRqe1ghRm4nwTKg5DGS/t5JZMg2IpL+nLf2OC/8oI?=
 =?us-ascii?Q?bPrApT/U27x65MKxYFTsLir1X6+qei7TsZXsseqJwxLyf0sprN0ffqv7iTPf?=
 =?us-ascii?Q?SwipT2NlTD3cVEMSNVnVUQheGOK6X9OT7eMJTKTN66Ee1coUb1O5BJaXj6JA?=
 =?us-ascii?Q?Fm/SRSu5UrbGcgYNb801Iv5Wo/40oW45Ebyyy01q29x42EpCzrZ6+jXBHvHC?=
 =?us-ascii?Q?a/BkezxyGuTUsGyYlKBYZ/O9Ql5WoGR6iF3HoWNGP9aQ7kmBAShBxXBCdVQ2?=
 =?us-ascii?Q?8mhj42aTgBECOJ8O2ejUUT4JezXZM7NORgqRRrGI9Dk7e4QDwwdPhY9e6LFZ?=
 =?us-ascii?Q?E8B94QliRYZRDMn++15IpJ8j3PHU1EmqpmvnzWQiiGqCJ8p9+eIcuFrHgAVI?=
 =?us-ascii?Q?nfDJ1Zp++pem2Nan6AqG2BDMUdlUJjvDNGbwU8aKtRdhn8W35DeJGt6XA9UR?=
 =?us-ascii?Q?R1r1/dIXA8AgulWQ5vPttVqMsYpapjk4rT90cB8AzzacfC+BSz2PMA2sJidJ?=
 =?us-ascii?Q?5x6zrYBPQg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6d7080-d988-43cf-d782-08da28ea0b71
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 07:38:10.5503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QkU7GhTg+TWIBSRe8c3KR3o+BG9T5gOa4Qo5HQQ0TPG5LZp15H/c3bNEd02wdjIGO0vhAyuxKJLciWtN4E/hOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6392
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Move a check related to clock scaling into ufshcd_devfreq_scale(). This
> patch prepares for adding a second ufshcd_clock_scaling_prepare()
> caller.
A caller for ufshcd_clock_scaling_prepare() in which clk_scaling is not all=
owed ?

Thanks,
Avri

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a3fecbb403d3..3c83f4049031 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1223,8 +1223,7 @@ static int ufshcd_clock_scaling_prepare(struct
> ufs_hba *hba)
>         ufshcd_scsi_block_requests(hba);
>         down_write(&hba->clk_scaling_lock);
>=20
> -       if (!hba->clk_scaling.is_allowed ||
> -           ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> +       if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
>                 ret =3D -EBUSY;
>                 up_write(&hba->clk_scaling_lock);
>                 ufshcd_scsi_unblock_requests(hba);
> @@ -1262,10 +1261,18 @@ static int ufshcd_devfreq_scale(struct ufs_hba
> *hba, bool scale_up)
>         int ret =3D 0;
>         bool is_writelock =3D true;
>=20
> +       if (!hba->clk_scaling.is_allowed)
> +               return -EBUSY;
> +
>         ret =3D ufshcd_clock_scaling_prepare(hba);
>         if (ret)
>                 return ret;
>=20
> +       if (!hba->clk_scaling.is_allowed) {
> +               ret =3D -EBUSY;
> +               goto out_unprepare;
> +       }
> +
>         /* scale down the gear before scaling down clocks */
>         if (!scale_up) {
>                 ret =3D ufshcd_scale_gear(hba, false);
