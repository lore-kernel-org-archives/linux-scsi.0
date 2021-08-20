Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C610AC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 13:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D14610FA
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 13:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240742AbhHTNNl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 09:13:41 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50848 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbhHTNNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 09:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629465183; x=1661001183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Xa8+ywJ4QyZAniZd35tv3/KpwFyrQan33MuRYxymzoA=;
  b=QhEOBOcqni8wO97Wyly+0ipfXbZVasg7kIZ9VRgC4ZrW2HWBXKHUixUp
   wTc1jrQkZQ3Yt9hXzDFCD7baaaYldgxwtEmv6Zdq0pcywd/L8M+2LPpED
   z80JquNeyeX3wjhKnqFnQKR3o+gF5aB6C0gHnIm2iBQcUG5jAcNOZtAcG
   V8LgGH395fzc690MB8x6011Jz4kZRxwS+SAbJg51Um6ctu9/uKCUFCphq
   c1jxeYUlKmAHTR1CD74p3jeND/1QPoOhw0+Y4CR9owH0m6rwMw3l4sOgI
   /TM14xnv4jOnxAg6aF3+iUQ8Lboq22qg4C6zhUTIamFqK8mjrtm4dDpT5
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,337,1620662400"; 
   d="scan'208";a="178484876"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 21:13:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENTU6Ovw8jtQe2G8lsUnatyAJ5cSHwAqg5qToQsqeeeVEql4VXKajBOpIhJf6W9KrhO3XcGpxuS3pHYFpb7/6FzXD+KVHdF7+8P+iCIWAOnuUAh9JhyHYDwar0boeutWIzNYZLZSsy2upaxNrUNaKSzv8lJOYwBgT1RPGNjKrUcY3Z+w8743oMtM8duoc38XFar4snPelmmsRkH6+4PRqW+w5+R41mtgG5g9yfLIF+vCwLeiHdHeDrQVjAVWw2SS+tiyjZT1WYM+k1agb5Kri2DWPTQm6kRKcaJzPiA8qpukSvEccol8qA9IIIdCYTDXRPbCZkwWCmuywgFYa9hDFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX59jQVrEpq2XCXk7L2uMSfCAJfNtxUeEcpPz08mZRM=;
 b=IpKn8wBcXHyaV61ZE6lPNQi8pLQ6M89WHSjIp8PkFEpIexiZBL1xbRtKXobas0+bXnCOUHUdNAvavh49gYIMILycP1/4/WD3QkastRj/SiluKNWn68N52hYAoK7F0jE7N3hzC2F8U//Z+eoTltRVEAN1cqnyl0vqojcV4tl/WJ5ONHvDklOlckY2dB54FpqCh504hxmv6qxYNg+2+UhD0PRJg2mg5zOeryGzdk16GD2gsuWDNYTQtZo1wNn7NUnquZF+Z5MdzkimpcBJbF55MK6KGAqf4bWGVpKTkBmsQhZZ/okY6qVXxpaSDYR69UsYanFjEV1YE4a0MOxqjgzZEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX59jQVrEpq2XCXk7L2uMSfCAJfNtxUeEcpPz08mZRM=;
 b=IdpwumE2bR+yBbCr0sl96f5Ch5CQWUHW/Z/5P+LOWtTxxhY8HVHXMmTJRBizj+fLB5D2q2QKF8wvHy4VMURD428aG1yBMON9YtICeaBsCVSrGlD6LSZ+wm+/8OOFadsL0Z//IpRPC4NXaeoaTIBbbzzYqARsfgxSaLne2E7r4fs=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7734.namprd04.prod.outlook.com (2603:10b6:510:5b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 13:13:01 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%8]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 13:13:01 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Thread-Topic: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Thread-Index: AQHXlcUZ3QKuFrDl20SX+jnl3fld+A==
Date:   Fri, 20 Aug 2021 13:13:00 +0000
Message-ID: <YR+qWsx4jVjTX3HV@x1-carbon>
References: <20210820032154.574953-1-damien.lemoal@wdc.com>
In-Reply-To: <20210820032154.574953-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cdf1d68-fac9-4bb1-cdf4-08d963dc3c96
x-ms-traffictypediagnostic: PH0PR04MB7734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7734D06E0928CDC7F6F219A2F2C19@PH0PR04MB7734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F5+kBkbTX2CfimPfNYR/IUtDp5uxRTuOFqGuuDfngpBYAKL1FjlQ0dNavtSPn3X9aner9J2DFKJAKB2vYyvzDLsct4oDZeV0Qs0HdwUsV7CNTnW5pScrm5Ol1gUCIdPlOsV/k5kasGZf55MH7TSIMY+7G0uR6BUJaV2wCoV0OTr5ujWhpNRq6ofJ/9MzDmJpiru4tStfCRlhFPmCTpOlL49za+DmMumoSmRGIO0TWQszjc/3hCMjZWd+I15oIed/Ei+N8UgHw2Xmj5P4vrzEH5VrG80jBvbd1poAmZkQyjWVFrTxvTEEf7EJexDpA+JVxq1GLeN5gt0XIbTHyuQgF6dn+9I9P4X6MZLSitMiRXT+4mZ0/kcg+Evmcl3qJkWKpXL55Ohpe7gFKQ+ROYgaJvcLTRP0FyZWl9dCLQ0PWQYPiuyWDt6fmIOfFnqg57NnCc0N1a7gIdHvh2LL8zu+sqApVdFg0sepWYdAOoail1M0wjaMtgdT0m08RG0BxTRWdUc95v5vkF35bZPVVQ922rSqVI6VAw6TjVSFj134xHcmoxJof6bPckVJOQrx7RVPQMeGiIxKiOmkqTehRcGm7ffS4iNn5NwaN3dsquBd4cTpr2qnpbohPNLdX5JrUFW1uJLJomUz6RvCFlgmhI63ReABn8KKKBnONmt4crfmZoLBTkepex4AadKzpXNELR1oP/lKM0Olh9WYRlFAiIunlio9OVA+eT1ho0lrB7UqTO8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(366004)(39860400002)(396003)(346002)(376002)(122000001)(38100700002)(38070700005)(6506007)(33716001)(86362001)(186003)(26005)(8676002)(83380400001)(6486002)(8936002)(66946007)(316002)(66446008)(66556008)(76116006)(66476007)(2906002)(478600001)(6862004)(64756008)(4326008)(71200400001)(9686003)(6512007)(54906003)(5660300002)(6636002)(91956017)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Jt4zc3KCkT8+PzL1iU/pRjaynz7JH4jqmpvB/qS7JHg2ILf37UTbinOf/nde?=
 =?us-ascii?Q?Qik8OeQCSugTjhCk9yuSREOV79JpUr7MTb/LRS0N8rDx+h2hdpVQjSkLAecw?=
 =?us-ascii?Q?wlHE3MGLrK8AKbSYhXqy+Ne7T+CFxV3L+xf70b9rvC9lQNrBbofwoTNr/9TV?=
 =?us-ascii?Q?ffpc3JJJbz+7xH2/zulki801NWKpJUw6F5HU+9u5gSrnqVKlDt1YYT+A8b5y?=
 =?us-ascii?Q?OpkYjQM01nRPdObSVGWirpniBRTHaMK70S0w2sCLRCCloO8uZbC9ztIIMYQ3?=
 =?us-ascii?Q?rU49+36EPAqZGnKpqtPL8M/8/lJqqin/6X65LS4Y4Q2IHR5PPrHghbS1Ygdy?=
 =?us-ascii?Q?owOjW49VP0xOVlrPmsXDX+QmZi6AhiqaHiQd7Vgk7V124JJhDy9JbCGZv0RX?=
 =?us-ascii?Q?VJNrGFSzp0Z2VB11FbC5cJwf2LlTqu98GsLMXE/kvQCTwaoGiSpZV3+kMiTD?=
 =?us-ascii?Q?sNl6AOHKl05jnfRpB55PDYkMOgM5vEU10Lw+FWAfmO/moT5NXrg7t5IJtTQh?=
 =?us-ascii?Q?LdBW9Cx24SA2i5xLpeCXXpkdliMqXv/DeVsV+FyEBpthbbXciVhvlp0cOulv?=
 =?us-ascii?Q?ilc6fUdYmqNrvgvXVvKfU7oUq/6eEu6/Fs9SRvLfI/wWqO9mHURdk3LWbVIm?=
 =?us-ascii?Q?B/P8ry4XHCuzgpT0PXYpGUDQ8G3JOsJcnUjG8m2Wb0jkfAUwmoaKc+Vfo2Z+?=
 =?us-ascii?Q?Fz5XuDF2b/CuYuLEoUFVASLadpdVfgWGa/Tl6xCMoBsx+VKAr0hDXRprvBBq?=
 =?us-ascii?Q?x0pb3zqCm54P3jW77Yurc4Blw6RdZRuwFpwZhW9xIqOEHri+rYhq169nYEyQ?=
 =?us-ascii?Q?UkDoapoEalSzU0mZelxSbbgJMQHvEZIyEZ/prFJJ5hpbgceqCdwXdG1qelmg?=
 =?us-ascii?Q?zcCmv5IrPqDpnJst4wCTh7wbrj7cOICE2PiM20G/28JdwnyA7d6r5YfoZ7wM?=
 =?us-ascii?Q?M6Y/5JZqT3RTpDSZjJJDrXxzcZJJIi4Z7sulls4Bb3Gc1hp6YExzVtwy/G5+?=
 =?us-ascii?Q?DB5iMBcDHwrdUY8GseYCYOu4uH6TB83W0+pqbeL2CiObVbA5JKESnDsZFPke?=
 =?us-ascii?Q?jDe+jUDFq+ebq3AQ/x62Q10kGXOBGi0NDSoOsm9AoPWunAFxETw+aSi4auY6?=
 =?us-ascii?Q?1l9FM9Gl/vAgJpOKKBvzr3njhl2WWLYpuuPG/Dl+Ob3yFBT6x1QY5dMUpXrA?=
 =?us-ascii?Q?0UtlSV42M6Qjezv/1TBZIO0bMYLnDGZpJFksAdm35dwh1zXTmOkKAD1L/Q7q?=
 =?us-ascii?Q?ZaDuI9ul7pDHcCA51dHjWdMOWhgqyV2fxRdQXiMKmETAdOamjScxNf11mmFs?=
 =?us-ascii?Q?qkd9hu2COfZkwEZiB3GYGA/K7Mp/uoLTiimhGbbnl+7t8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25117C5AD9D9E34DA554C9FF6C99E13B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cdf1d68-fac9-4bb1-cdf4-08d963dc3c96
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 13:13:00.8026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5srh2mjr6DDIVU4Y446I7gxO2Vuo8CVLmpFjIAqHFTleQ0FuiTarJk9t3ZajogL49e4FXs4RdDjbsj4HRCI0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7734
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 20, 2021 at 12:21:54PM +0900, Damien Le Moal wrote:
> Remove unnecessary gotos in scsi_get_vpd_page() to improve the code
> readability and use memchr() instead of an open coded search loop.
> Also update the outdated kernel doc comment for this function.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> Changes from v1:
> * Fix memchr() use to avoid accesses beyond the buffer and result size.
>=20
>  drivers/scsi/scsi.c | 31 ++++++++++++++-----------------
>  1 file changed, 14 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..6be68b3427a0 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -339,47 +339,44 @@ static int scsi_vpd_inquiry(struct scsi_device *sde=
v, unsigned char *buffer,
>   *
>   * SCSI devices may optionally supply Vital Product Data.  Each 'page'
>   * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
> - * If the device supports this VPD page, this routine returns a pointer
> - * to a buffer containing the data from that page.  The caller is
> - * responsible for calling kfree() on this pointer when it is no longer
> - * needed.  If we cannot retrieve the VPD page this routine returns %NUL=
L.
> + * If the device supports this VPD page, this routine fills @buf
> + * with the data from that page and return 0. If the VPD page is not
> + * supported or its content cannot be retrieved, -EINVAL is returned.
>   */
>  int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *=
buf,
>  		      int buf_len)
>  {
> -	int i, result;
> +	int result, len;
> =20
>  	if (sdev->skip_vpd_pages)
> -		goto fail;
> +		return -EINVAL;
> =20
>  	/* Ask for all the pages supported by this device */
>  	result =3D scsi_vpd_inquiry(sdev, buf, 0, buf_len);
>  	if (result < 4)
> -		goto fail;
> +		return -EINVAL;
> =20
>  	/* If the user actually wanted this page, we can skip the rest */
>  	if (page =3D=3D 0)
>  		return 0;
> =20
> -	for (i =3D 4; i < min(result, buf_len); i++)
> -		if (buf[i] =3D=3D page)
> -			goto found;
> +	len =3D min(result, buf_len);
> +	if (len > 4 && memchr(&buf[4], page, len - 4))
> +		goto found;
> =20
> -	if (i < result && i >=3D buf_len)
> -		/* ran off the end of the buffer, give us benefit of doubt */
> +	/* If we ran off the end of the buffer, give us benefit of doubt */
> +	if (result > buf_len)
>  		goto found;
> +
>  	/* The device claims it doesn't support the requested page */
> -	goto fail;
> +	return -EINVAL;
> =20
>   found:
>  	result =3D scsi_vpd_inquiry(sdev, buf, page, buf_len);
>  	if (result < 0)
> -		goto fail;
> +		return -EINVAL;
> =20
>  	return 0;
> -
> - fail:
> -	return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
> =20

(Nit: I think you forgot to bump the version. Subject for this is v2, which
is the same as the previous "scsi: simplify scsi_get_vpd_page()" patch.)

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
