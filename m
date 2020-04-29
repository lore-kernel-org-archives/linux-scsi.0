Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB3FC83004
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 10:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 684502087E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 10:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="VU4RRI8s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgD2KSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 06:18:36 -0400
Received: from mail-eopbgr690089.outbound.protection.outlook.com ([40.107.69.89]:27968
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726503AbgD2KS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 06:18:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8uCbDm3sDkG4T+tO9toGzT7hNdj4zoLgEwu7j53McJQVB/gKz2tPdMc6Pcah8cKtS3FFj4d0eAIpUtjtXn6/6Lwwj93rA4eJ51G6UkM8e8xntW0u1K8w+k76qCb9itY70n62cMn+KgM7SErZBAo8ZgGAg8oUZo1DguRRFfqgzHXtV3fQIYe4f5REsL1Vjx6i+rqcsPJVMTVhIQxfBimdaMk/MmYp/cXOLcbqlpj7tUsdAYD2W9ArYmqFah5iaYWsq23yy114r/QG0JflR0XpJQFN6gnxylccEyIVIiafwavKjP6LYCIviAzGKX7z5HNM7yh7HeH96XgOarAE/DMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kuB5yoOGMhcVPpEBveV6JlLpDG2XZawWCrTJtyL9ZQ=;
 b=CuQna+P2XllR+htk/DzJdbaO7rDz7/RbhA1BybPUIbyazZ1v63g+zxNFJClGx+GvLGPri9fmxXJlWSmdHurrucbeNHq2dEW0EBltIUe9HPqcZb2qJGlwkUKZWr5je/tq9atgJ9Y/WPco0qOEDdpJDowC0z7o4L1MTLwHicjy5UJyrmyG+cNEREdtD7TEqLrSo5/aq276c+7V0j3XF6lMWv64RP8ll08iUYPAxKBbec+Z5kv+aIsBMjWYMLPcgHwzIWGIfhzeEqg9ephsd3OxUkzwe5HJFBb6a0Y9WmsSs8t8FYZY4Df7Hps8qHYhJZUIsde4Qv0498OgZRDvNqiXTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kuB5yoOGMhcVPpEBveV6JlLpDG2XZawWCrTJtyL9ZQ=;
 b=VU4RRI8sWm/AM/01OgP7pLw8ZRCQSPjFSyxbXo8cn4BY13OL33wARGW7xpfK/hyEajKCXEB92GMlCbN9UKcXqbmnSysNIg3nRgAxYkV8JMZPD6VO6XH9mhdIpN85cIpVImi6/Xh+ZMRJgsPUbP+ziLLpq08jNn7TYhSVsNJxa+4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4210.namprd08.prod.outlook.com (2603:10b6:406:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 29 Apr
 2020 10:18:22 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c%4]) with mapi id 15.20.2958.020; Wed, 29 Apr 2020
 10:18:22 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v1 1/4] scsi: ufs: allow legacy UFS devices to
 enable WriteBooster
Thread-Topic: [EXT] [PATCH v1 1/4] scsi: ufs: allow legacy UFS devices to
 enable WriteBooster
Thread-Index: AQHWHU4iZoA14hvpQ0SN1N4w8h0dMqiP5DJQ
Date:   Wed, 29 Apr 2020 10:18:22 +0000
Message-ID: <BN7PR08MB5684EA9B884FBCCF8A7416DEDBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200428111355.1776-1-stanley.chu@mediatek.com>
 <20200428111355.1776-2-stanley.chu@mediatek.com>
In-Reply-To: <20200428111355.1776-2-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWJlNzZlYTM0LThhMDItMTFlYS04YjkzLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxiZTc2ZWEzNi04YTAyLTExZWEtOGI5My1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjMzNjIiIHQ9IjEzMjMyNjI5MDk4ODU1ODM1MyIgaD0ibVRwSnZ3TzJyRTNPcGhCRjFhVk5ONDVnRW9JPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFBUmFOR0FEeDdXQWNSV0FTUi9GbEQ5eEZZQkpIOFdVUDBBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUFmM09FS1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8d96565-c784-4609-28f9-08d7ec26a59d
x-ms-traffictypediagnostic: BN7PR08MB4210:|BN7PR08MB4210:|BN7PR08MB4210:
x-microsoft-antispam-prvs: <BN7PR08MB4210075F2984719D4666132BDBAD0@BN7PR08MB4210.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v7DZowDXBL8QpZuoAJq0NwHLEg5YJUnjRdpgruVe4qhrqMCrz0sdCismDBJ6zejJffqZwrLmbB78HL21k4KiHaRKSyRyCgzzont0YODZgBJfm+jgvmK1NU1jsfm7Wn3UaPLfRb4vscoFbCioL5deb8NOjrTi81DFtlM3KkreLBsBmERfMmisKN9q/R/vBVCIIDWGEX6UgvP0wPIH3WZH3WlvMSS7MHhSD74ON7/W3T9Ggr9X2Ww1qs3PkI8YQwsS3YKLkCX3uQP1ZRoBbw6RNQ/LArPXsQse2z92wwDu0m8IsMNCRELrLBu6rkUrtShfJnnDZNLopPl9mecRiF+K8ycfdC8sKsVRQ2A2QRsIMrfftLvZmhpobII0kMXGTnu1Cw9hVbsZabkoAfgUdG59+HP5UYJyK8xQFvlPwvvkZSUZvyBZnR0ZB7mQV0ly2tij
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(5660300002)(71200400001)(54906003)(8936002)(86362001)(316002)(55016002)(66946007)(9686003)(76116006)(7696005)(110136005)(8676002)(64756008)(33656002)(66556008)(66476007)(478600001)(66446008)(52536014)(7416002)(186003)(55236004)(26005)(4326008)(6506007)(53546011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cofDpE2j6uT1kXig6xBsCqp1NjsM8fF8ooK9PrAta+138V5Enc9vq7NsLnehWv5OAh9avT48iAXmYL/3GYYTG2W1ZyUtToaYLOoaij03kzEwfhpNza96XxAwGbjDd+GnyRTIFhAh/WzOx/Mu863h/P8LcypANrsQ/5XJEjc1GEgrpjNznqZG0RET3vy0PS9odOsLr7VGa7jNKkhgVAHwV2Y2wDPeTrwQytJCSwwn04NuETFcYOSShkjw2vdEh7wOuSpTFd6Htr3P9E4uDZWE/FAw8ob87r33WicfLW9+iANxe2o0q/Ei14gLHWaGPpgSCc8v4vQgmw7dVXrzQxRzBmGpG/PTl/+E3OyYCLLXLe6C/wSuAjzcDGl9JKAcZqnC2N5nQhFY8yMWv1F5dDEG4dHHxyI3uOKZzkBLAiWZR6ovjfk8aOPhHhQvIbd+ZhnEQ8w7rfamv/1uglPkce32Wu3hYjW8827P0x/Un4wkTOQjP/54mImZntNbIHVAkPkAdZfvLHwUcs8xhIF7tZnnZejxfBJPzABrHQl0qQGLpoTtNi/2O340+nJ2F/tt0owHkHmgtw3hIN0vBhKAmXFK4fRLKV27fHroohU4nc5X3a2RuG5ey3A6WUaQ5OF5GeK5mOLtRazFajEQIHtjQkg79EGRAYLgsuaUAzPpPFvUGbi6VOaihfrvfkOfynUL480RjjeoDquNOtotUhF1pWqk5imnvJZiwrXoU9G3qah6ounmzCGJx4UUoRKztnTmJ2fQcgpL7mn0cqyufHPHB70Uf+oRgo/lfkKAUkrApxpUuls=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d96565-c784-4609-28f9-08d7ec26a59d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 10:18:22.5788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBgvZB7qKvHfq2F2YvUyxcUZxjuY1HQDV68lejF2GZ/NE3ZXmFvrTDebTUMUJjZMJz7qUyGnUq0h5GX9Xbmclg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4210
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Stanley Chu <stanley.chu@mediatek.com>
> Sent: Tuesday, April 28, 2020 1:14 PM
> To: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> avri.altman@wdc.com; alim.akhtar@samsung.com; jejb@linux.ibm.com;
> asutoshd@codeaurora.org
> Cc: Bean Huo (beanhuo) <beanhuo@micron.com>; cang@codeaurora.org;
> matthias.bgg@gmail.com; bvanassche@acm.org; linux-
> mediatek@lists.infradead.org; linux-arm-kernel@lists.infradead.org; linux=
-
> kernel@vger.kernel.org; kuohong.wang@mediatek.com;
> peter.wang@mediatek.com; chun-hung.wu@mediatek.com;
> andy.teng@mediatek.com; Stanley Chu <stanley.chu@mediatek.com>
> Subject: [EXT] [PATCH v1 1/4] scsi: ufs: allow legacy UFS devices to enab=
le
> WriteBooster
>=20
> WriteBooster feature may be supported by some legacy UFS devices (i.e., <=
 3.1)
> by upgrading firmware.
>=20
> To enable WriteBooster feature in such devices, relax the entrance condit=
ion of
> ufshcd_wb_probe() to allow host driver to check those devices' WriteBoost=
er
> capability.
>=20
> WriteBooster feature can be available if below both conditions are satisf=
ied,
>=20
> 1. Device descriptor has dExtendedUFSFeaturesSupport field.
> 2. WriteBooster support is specified in above field.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 915e963398c4..111812c5304a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6800,9 +6800,16 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hb=
a)
>=20
>  static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)  {
> +	if (hba->desc_size.dev_desc <=3D
> DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP)
> +		goto wb_disabled;
> +
>  	hba->dev_info.d_ext_ufs_feature_sup =3D
>  		get_unaligned_be32(desc_buf +
>=20
> DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
> +
> +	if (!(hba->dev_info.d_ext_ufs_feature_sup &
> UFS_DEV_WRITE_BOOSTER_SUP))
> +		goto wb_disabled;
> +
>  	/*
>  	 * WB may be supported but not configured while provisioning.
>  	 * The spec says, in dedicated wb buffer mode, @@ -6818,11 +6825,12
> @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>  	hba->dev_info.b_presrv_uspc_en =3D
>  		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
>=20
> -	if (!((hba->dev_info.d_ext_ufs_feature_sup &
> -		 UFS_DEV_WRITE_BOOSTER_SUP) &&
> -		hba->dev_info.b_wb_buffer_type &&
> +	if (!(hba->dev_info.b_wb_buffer_type &&
>  	      hba->dev_info.d_wb_alloc_units))
> -		hba->caps &=3D ~UFSHCD_CAP_WB_EN;
> +		goto wb_disabled;
> +
> +wb_disabled:
> +	hba->caps &=3D ~UFSHCD_CAP_WB_EN;
>  }
>=20
>  static int ufs_get_device_desc(struct ufs_hba *hba) @@ -6862,8 +6870,7 @=
@
> static int ufs_get_device_desc(struct ufs_hba *hba)
>=20
>  	model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>=20
> -	/* Enable WB only for UFS-3.1 */
> -	if (dev_info->wspecversion >=3D 0x310)
> +	if (ufshcd_is_wb_allowed(hba))
>  		ufshcd_wb_probe(hba, desc_buf);
>=20
>  	err =3D ufshcd_read_string_desc(hba, model_index,
> --
> 2.18.0

Reviewed-by: Bean Huo <beanhuo@micron.com>

