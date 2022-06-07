Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B5EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 09:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiFGJQY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbiFGJQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 05:16:21 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4400FB0D0B
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654593377; x=1686129377;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=js9BohD5MgfbCOkodUAt8kaT2/qOQTgcfaVLqlCASic=;
  b=N0PhGJQH8klIu4hlkhLerHDBdA7YJg7xCT2IXNUiRHm1xVI28gOmturF
   K9+6Yuwo3kV7dHECEYF/QABFojrZ48S1zUCxqkM7Eco+2nXWJ3Hi5nTfd
   HAJ/yeUFzzAmNJIWgeZE8drKXJqAL1l+HiFXQ+0jj+BUakLVWfn0YF2cB
   waxzfg8BbGXEBhw/7gnJO1XQKsJXcWyL0XRgaTsn0zY1kmos8BvYEi8fZ
   WKT8gKog2S+N6cR8ccXuHq+N/Qk+GUM7zO657z90/no2qBCNwfX5U4UxR
   LRWbCe6nfy/WP+jky6w9d6uyY8s4gBRXjKiPuHIK5vLJDLuwybxNtlX+L
   w==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647273600"; 
   d="scan'208";a="202464654"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 17:16:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvhGl2DKpWWp+1SU6uZTbvCsZkN+Xbz39NK06KubW2qshON7NnS8HWgJP7xVFgk3PNaAcOtxI7sJpQ3EIKcankTsZ62lc4sILPwKVuLOsF1q6ahenyxvXNw8OuGu6R3U0ziAWZ4nka47EyRb4UR0QlwawofPivanOad6WUP/NFOM8qAzpuTtZI7s8yY4M3qDm5ZbLHe/AdwCex42/aZwaGV1iMYsYMn7GL7eKTpy9HdkozTII0Gsv+64XKNurLZHE2DAbkZCj1n92MfeIilegONbGfLaMMhodIU/AGxdvlLRywxBFdG9iTs4u6H+BzPf2vXvYw23CNyLEAfFYkPduQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BpRAcwkR7oMLWjFAUODmb9ZJEvmjrRniyhbBgOm0yAk=;
 b=NWddvW7ej98rczTLCwtmDTNHEOwzdePVIrblh4D+FC991vStGXC4LLO7aFHz4LXWjv7ETAgGb/j/V4kHFRMI+thnVVRh3XjKxuRVUeaY7Z6jIQmD5H81/fUUyS//bWzWdrt+dvdlotWRd8+vTdpshshL4MtAOaNCNRkx6nnmkOok+GeFNu14qNbul16iy+vIAPw5SgPQhnjkO3o2gFPj2u2AK8nmdXK/CT3ieLZ1wEPwDogzjKaIUTZkVMknym9K45/kqbJ9B4JqrI2HFl/DiIgEqTB5xSZfDYjJquz8ePetCaOUBSLm3PpmoU2KONNB4TnEShHbxfLAxECZtLXUyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpRAcwkR7oMLWjFAUODmb9ZJEvmjrRniyhbBgOm0yAk=;
 b=tdrYzf4HlDLWKK6INWhmN3rCBhONe351P5+ycuUy3CabcoPtJLdwQ+jrUDPR+BUE+DMxEOJ+maTrhumzUzQhK3JhXA7bFajwEwS5Xfoz7bLkK3Ej2MsP9h7eNEIDzEgG/seQkn9AeLAvMGuYkD7jm7MbU3RpLLAAt4i3di5b8fk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by MW4PR04MB7329.namprd04.prod.outlook.com (2603:10b6:303:72::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 7 Jun
 2022 09:16:15 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617%3]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 09:16:14 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Thread-Topic: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Thread-Index: AQHYek88ElC509gMvE6mTbpf/6AP0g==
Date:   Tue, 7 Jun 2022 09:16:14 +0000
Message-ID: <Yp8XXXX/vYKvuvSS@x1-carbon>
References: <20220607014942.38384-1-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220607014942.38384-1-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b75ad28-c0d1-4598-cb2c-08da48665f3e
x-ms-traffictypediagnostic: MW4PR04MB7329:EE_
x-microsoft-antispam-prvs: <MW4PR04MB73297955C8494EC6664D069FF2A59@MW4PR04MB7329.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0kx2dDyjqjM6+dFxsT1AHQcy7qkeKudvX2ronyjiQP91HGyyIZ61tePT4Ryv+qWC09O4ILSIs643O0ZorAhNEGVbgmnVpJRzeR03DM/2yfUxTK/79O9/Q9ztQ3N67/DR+uLgbBHruWAQnTLt/bKM+ML28bPePGLivgHDF6aquVYpV6VFYKRP2kEah8bEKS34inOQE68KsEToa9PHLgdC10IEEUTnNTBOw3d+MGjND06ioGcKui0VeNIMfNugx46r5qRhuYQ9W+asKSSrcJAfnef96G00YpFdOuzbboXeBjZhjnxLrkXfecZ+F0PMgblRTlpqZIRHoRdiOFRu+9GSLx8esul7MI7x3aQrC3nip279cSv/g8qS/750dpsU8ZVxZ5CMi78yS7y5d7yOAFK+zamY7AcOGMtYVzP23dUa0o3m+ntMmdstb7qSnbGpWsXua1s63707CENhMvFhVDUv/VS6QXNznaMakWshVWPfO0DbD/CrXeqna+f8zapixDBdAA4QGwIioHc8O1TgNrGCl6MOWZRgmF5ibd1/xY9trBynxhDgoPstcC+dtC64uG1rI96x/7EUOw7sE9Thph40CweVrFF6JoCDKp09lAHbwEc2BV3uS0cBOmBz2Yxaw4NsVBMpSx77zVotUTNqq9G/brOJLCkuUdoF3F1/7R8mYz1FFs8f00qRihd9iJxJzQDae4najOKalZ/0MqQezQE+jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(83380400001)(508600001)(8936002)(6506007)(6862004)(82960400001)(38070700005)(64756008)(66556008)(8676002)(71200400001)(76116006)(66446008)(66476007)(66946007)(2906002)(4326008)(38100700002)(5660300002)(122000001)(6512007)(9686003)(6486002)(91956017)(86362001)(316002)(54906003)(33716001)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zoTKIb7EEyL0osuZN/uq8DQGgmCCfanQT7ZwVpcCgRfkiydmVwNaXAhj5kGB?=
 =?us-ascii?Q?N8G0arIlinielvSZk+xnjOCN9s40J4crIoBlEw10lhmtNB8Fse3CI8hoM+Qy?=
 =?us-ascii?Q?iLsQtrTO0HMnNeQDpbjJIJwtJf52j0kMVE8CU1h/MPkJqVBOEA1f3GUTWs5A?=
 =?us-ascii?Q?t1DnKF02A4LXLwuuIoYkVev3OgbOx50nDd0vueZLMMTXwlv8/bxrSb/5ofIn?=
 =?us-ascii?Q?1kwaeJ7/bqstJS/ZLTrRUsA5HzQx9rgM9/6fAckR9xfXz9m4qiq329n6Oksi?=
 =?us-ascii?Q?41INRLyXIwlMvKc2JUqlQYz0yoA/lRMBdrxOEUIg0T3+5uVbwZeJqwzxSpaZ?=
 =?us-ascii?Q?t3PN+N4nEaSSXTkVr1jRr/pxLLGpbNy1cr/e8KBviavvHqpWmneu8sVDjZt2?=
 =?us-ascii?Q?BWy2IY/XTtOlmN424iD8WVVy71D5zylvwmHgMxZDXo1d1HSzkf4ErbLsRHPe?=
 =?us-ascii?Q?jdtdhRy9DbFC/+opsdsgLYkfhl/rBbRH3ja/AUgbdJz5T/SyzgUkU6azfUHV?=
 =?us-ascii?Q?HKcAeYM1K1r/AT8WQjY9H++I7J7cuRFSRQWMT3bahdoS6crOVnKJzjQjmDco?=
 =?us-ascii?Q?kVsgfvEK95TDUVncd0fbqkNEse0z4PwxYPvdCmnbBNk6wjfLRMK1Wzp8rMHd?=
 =?us-ascii?Q?zvwQQ3G1rx8bUrBpBhlp9vq/tJj9LvmSh4AMo+wrXPU0DtVs9+wKA3yfeudE?=
 =?us-ascii?Q?MfkSMlM26ifbf46OF9XoIJ9qwSsFHw6+ComImnoExEWB0bqjYO4FBPJ+pt3Q?=
 =?us-ascii?Q?VBFeCpkPMOR9TUpEmOPGWXLwkHiOr5TqAlJEiTuDezlJgDx9Vwy7Xy0LKmBH?=
 =?us-ascii?Q?59IXgJjcwxGgFiZq8EHjo/1zuZK0auP/ncMb3VfS2c9GYLKD5/4zlM+GR8nZ?=
 =?us-ascii?Q?JKgLMNLhCo3IqN1Yr7A0WrFXdL/G6MhKK2CIZARgN2QTeFUPfAQSubqI4y99?=
 =?us-ascii?Q?iFv1QBDuq3+AELu43QaEUjN+BMZdf2YqOtDAMD4DmDvK+UJgKZdx4nM3KS/s?=
 =?us-ascii?Q?jRUSXtFSNgIabxqDiXv3osO1QExzEkLKyZOgqlQOTMtzf18n5Mm6cvOCOwbZ?=
 =?us-ascii?Q?iaBlZ3EssYNaiDeVMUNTx+HD8sJ95CitvSYwXl+da3a9q2NdpJwrcf1aP86x?=
 =?us-ascii?Q?1xAiewrUcgwaR1ahuLygNGCkjLXnEJwuGJ0D9bmmQn2KwiiQX4hDASsCE68g?=
 =?us-ascii?Q?bwlGUWcC4hU8CHpMfkgybokUYYouiX1IUfzHX4QaZmgC9kNR8qn4iWrdMoDX?=
 =?us-ascii?Q?bdnSPe30JGz3Dtp0tsHO9zowtt3EtwgtjfGtNMZDMqaZtdIsrKrCm+pvg4z4?=
 =?us-ascii?Q?1pYUOrM+u3S7sqvlL7wra/Je2ZbWxQjyUGIcpWeA9ljTfUyEqdkHKjDssqvn?=
 =?us-ascii?Q?eKDVHuGiOwMo9w757pz1zWA98ce1m+6IS1SUFBc8s9sLjEQA1HOjOc1xSiBJ?=
 =?us-ascii?Q?jlthFO+PwwM6dYiCmfACl7cGNMeuk9bQHIUB7YRDNMY3cs0ZY+IeTOtRMnsP?=
 =?us-ascii?Q?HPt1NKhIlaKOIbitHYNTj8ysHUMvEPlbCCbr7pKAB+i6aqYetMICR3x18fxR?=
 =?us-ascii?Q?YrLVda7fiavvpi1VMP/H01HctnA/3XDRMArSMzAxe9xWSnO2k3rqAu4+kyWY?=
 =?us-ascii?Q?a8os1NeHyGpnemMum81oDXhHSJ4YL2xWXRGzqUMoTgnFhm9X6xTsYEDLp+IF?=
 =?us-ascii?Q?VHhKW9h1BxP+lozH7NUIOh4/oMZ8umdUYG89cYKTSsaDuBzJ/As9dyhXR2He?=
 =?us-ascii?Q?cVQYotBy9JEPnEphAxjsyEjBgPRlfa8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B00C2525F1726644BCE93F40FEAF154A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b75ad28-c0d1-4598-cb2c-08da48665f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 09:16:14.7848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: udFJTMGmwe+j8LkA6Dzqtqyt+eWA1XbkAT+kkaMzQm2m4nNLaXbYmtcWBf4sgwkEaz+uXnyFJ/mWmZXvP0bMxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7329
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 07, 2022 at 10:49:42AM +0900, Damien Le Moal wrote:
> When a write command to a sequential write required or sequential write
> preferred zone result in the zone write pointer reaching the end of the
> zone, the zone condition must be set to full AND the number of
> implicitly or explicitly open zones updated to have a correct accounting
> for zone resources. However, the function zbc_inc_wp() only sets the
> zone condition to full without updating the open zone counters,
> resulting in a zone state machine breakage.
>
> Factor out the correct code from zbc_finish_zone() to transition a zone
> to the full condition and introduce the helper zbc_set_zone_full(). Use
> this helper in zbc_finish_zone() and zbc_inc_wp() to correctly
> transition zones to the full condition.
>
> Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  drivers/scsi/scsi_debug.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1f423f723d06..6c2bb02a42d8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2826,6 +2826,19 @@ static void zbc_open_zone(struct sdebug_dev_info *=
devip,
>	}
>  }
>
> +static inline void zbc_set_zone_full(struct sdebug_dev_info *devip,
> +				     struct sdeb_zone_state *zsp)
> +{
> +	enum sdebug_z_cond zc =3D zsp->z_cond;
> +
> +	if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> +		zbc_close_zone(devip, zsp);
> +	if (zsp->z_cond =3D=3D ZC4_CLOSED)
> +		devip->nr_closed--;
> +	zsp->z_wp =3D zsp->z_start + zsp->z_size;
> +	zsp->z_cond =3D ZC5_FULL;
> +}
> +
>  static void zbc_inc_wp(struct sdebug_dev_info *devip,
>		       unsigned long long lba, unsigned int num)
>  {
> @@ -2838,7 +2851,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
>	if (zsp->z_type =3D=3D ZBC_ZTYPE_SWR) {
>		zsp->z_wp +=3D num;
>		if (zsp->z_wp >=3D zend)
> -			zsp->z_cond =3D ZC5_FULL;
> +			zbc_set_zone_full(devip, zsp);
>		return;
>	}
>
> @@ -2857,7 +2870,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
>			n =3D num;
>		}
>		if (zsp->z_wp >=3D zend)
> -			zsp->z_cond =3D ZC5_FULL;
> +			zbc_set_zone_full(devip, zsp);

Hello Damien,

In the equivalent function (null_zone_write()) in null_blk,
we instead do this:

	if (zone->wp =3D=3D zone->start + zone->capacity) {
		null_lock_zone_res(dev);
		if (zone->cond =3D=3D BLK_ZONE_COND_EXP_OPEN)
			dev->nr_zones_exp_open--;
		else if (zone->cond =3D=3D BLK_ZONE_COND_IMP_OPEN)
			dev->nr_zones_imp_open--;
		zone->cond =3D BLK_ZONE_COND_FULL;
		null_unlock_zone_res(dev);
	}

Isn't it more clear to do the same here?
i.e. set the state to FULL, like before, and simply decrease the
imp/exp open counters.

zbc_set_zone_full() does some things that are not applicable in
the write path, specifically this:
> +     if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> +             zbc_close_zone(devip, zsp);
> +     if (zsp->z_cond =3D=3D ZC4_CLOSED)
> +             devip->nr_closed--;

e.g. with this new helper, if we are in e.g. IMP OPEN, we will now
set the zone state first to CLOSED, increase the nr_closed counter,
decrease the nr_closed counter, and then set the zone state to FULL.

Isn't it more clear to just set it to FULL directly, like before,
and simply add:
		if (zone->cond =3D=3D BLK_ZONE_COND_EXP_OPEN)
			dev->nr_zones_exp_open--;
		else if (zone->cond =3D=3D BLK_ZONE_COND_IMP_OPEN)
			dev->nr_zones_imp_open--;

Just like the equivalent code in null_blk.

>
>		num -=3D n;
>		lba +=3D n;
> @@ -4731,14 +4744,8 @@ static void zbc_finish_zone(struct sdebug_dev_info=
 *devip,
>	enum sdebug_z_cond zc =3D zsp->z_cond;
>
>	if (zc =3D=3D ZC4_CLOSED || zc =3D=3D ZC2_IMPLICIT_OPEN ||
> -	    zc =3D=3D ZC3_EXPLICIT_OPEN || (empty && zc =3D=3D ZC1_EMPTY)) {
> -		if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> -			zbc_close_zone(devip, zsp);
> -		if (zsp->z_cond =3D=3D ZC4_CLOSED)
> -			devip->nr_closed--;
> -		zsp->z_wp =3D zsp->z_start + zsp->z_size;
> -		zsp->z_cond =3D ZC5_FULL;
> -	}
> +	    zc =3D=3D ZC3_EXPLICIT_OPEN || (empty && zc =3D=3D ZC1_EMPTY))
> +		zbc_set_zone_full(devip, zsp);

In the equivalent function (null_finish_zone()) in null_blk,
we instead do this:

	switch (zone->cond) {
	case BLK_ZONE_COND_FULL:
		/* finish operation on full is not an error */
		goto unlock;
	case BLK_ZONE_COND_EMPTY:
		ret =3D null_check_zone_resources(dev, zone);
		if (ret !=3D BLK_STS_OK)
			goto unlock;
		break;
	case BLK_ZONE_COND_IMP_OPEN:
		dev->nr_zones_imp_open--;
		break;
	case BLK_ZONE_COND_EXP_OPEN:
		dev->nr_zones_exp_open--;
		break;
	case BLK_ZONE_COND_CLOSED:
		ret =3D null_check_zone_resources(dev, zone);
		if (ret !=3D BLK_STS_OK)
			goto unlock;
		dev->nr_zones_closed--;
		break;
	default:
		ret =3D BLK_STS_IOERR;
		goto unlock;
	}

This might be a bit more verbose, but isn't it more clear to implement it i=
n
this way, since the spec (ZBC) defines the transition for each zone state.
That way, it is easier to follow that each zone transition follows the spec=
.

I realize that the equivalent for null_check_zone_resources() in scsi debug=
,
is check_zbc_access_params().

So for scsi debug, the equivalent call to null_check_zone_resources() has
already been done elsewhere, and can be skipped, but other than that, the
code should be able to look the same as null_blk.

Doing so also avoids the unnecessary temporary transition to CLOSED, and
increasing + decreasing the nr_closed counter, before transitioning to FULL=
.

The reason why I don't really like this, is that ZBC does not mention that
finishing a zone temporarily transitions to close, so why should the scsi
debug code do so, especially when the the null_blk code shows that it is
not needed.


Kind regards,
Niklas=
