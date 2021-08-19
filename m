Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A43C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 14:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C13B6113D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 14:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbhHSOnI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 10:43:08 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59150 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240502AbhHSOnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 10:43:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629384151; x=1660920151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=guT0vKw+AmN3//uyNkyXy8vM9JT34SRceTWf0KzFJ3I=;
  b=PDcmBAuEZn2kZerbUnTyQuWJSP6Ajw7C8jtWX48S1/UCvfrpccGjmsvG
   UyNaOcYWayBxVeOY6hShC8dfahk0iLxUC0uMTk6fWe0oQWHPwPI4E+voE
   WiTxOeESCRe9eJueeozGremzCQ4PmC72DGxXr7A37Or5PtPKUH1XLjO5D
   X/wCEMYmgLXhL+VQieg6Dil4sZOKkyoMIbSyj6XKxtOkpR9JO9pIlRygC
   bCJxw7a8xWRWwHyOWY5er2k4DasWLR9GK10J70PCMFh8pYve48nTbcfDS
   D/jUSTblc+NhwMHCLsJKOHv+DxF53jw+JonShbMyE4463Q3/h+xgRvyB6
   g==;
X-IronPort-AV: E=Sophos;i="5.84,335,1620662400"; 
   d="scan'208";a="281592108"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 19 Aug 2021 22:42:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAtki2k7mGQ4223Kqs8RT905ogNYEWAKETxuaVqEyRqzSKYzDvVxZ6oEZ+aLm1JWdjcn/Wa99WDymc5K+/iqUJL2tfTIyEvk6r53BipFbXA3pplRag1CMlfyvyVHd4rJfnL4uu1Wsw/Y0FTUDttWeIma0OMcoIVV+O4DtPEM9b3slw+QVHuBtkn3doLzgKqAZNO6vLKnyoeylRWmOVnamIbWRYIWEjRxSFs1yhCApCMugMVlYkQqNiJvN15h5Yjrw1W8AeYYVEnEzhSuGpEzIyYV7t3Pb919m34euFJtJYv2vAxRk5kgJDvjOUoLbjBSIDZvBZR3CBWw6ZRkwg4fVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz9rfrwv6kpfyYbh+s6hMSwWUXrBi3O6JRtmt6c4+bo=;
 b=bUYJBlOoNhywZ1ZBHXEZbIV12eOyYmgH3xC5+RqMhk24HYeXRtf8T5Pwo5fEsYI7TwkGUZ3QWV6Gb6B9S9TrPw0tn9fE4oUXq0meVr9vuBEOP+oqLiC4UDk7vk4hoSNAGqAQxcO509Zv0x/lGq3CoOSYnF/x9jVsv1bllvPL0cpwInHwqwqd3PoPQR64apjhrW02pTBV4UuAxBZ8P5mY5NbztwMTu0qU/mIRvCL3KdairQMLNuTn3M2UJc2j+ekb9qzZzmb8HsbMUM9FfeTp8hHJ0rZ51pCNCOflxM5ldeyXN2XUnA9pdlBUuZCXCCjKJucaiShCbGJdiSSoQQxDOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zz9rfrwv6kpfyYbh+s6hMSwWUXrBi3O6JRtmt6c4+bo=;
 b=w8KFmSLUVjVLrvS98bl7UqC6XG16QwrlSGiC9NlD9VNzbZbcGfbSjAz3bOdfYTfNXHpngbUsrgUD9QZ7avg8fwKrYuR+9n+OtTM2inKvk+N6+voU0raDdVIKso8NAaXe+/9Om4IlJC/r2zIm2v5b37r41vb94m2JcQ7Vkx/ImnQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7478.namprd04.prod.outlook.com (2603:10b6:510:4e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 14:42:30 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%9]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 14:42:29 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Thread-Topic: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Thread-Index: AQHXlQhvMKIY58x3W0eBesFqpeuIIw==
Date:   Thu, 19 Aug 2021 14:42:29 +0000
Message-ID: <YR5t1OoLOEQ0zz4O@x1-carbon>
References: <20210813010738.1204219-1-damien.lemoal@wdc.com>
In-Reply-To: <20210813010738.1204219-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fe0fe3f-6e16-496f-f63c-08d9631f9240
x-ms-traffictypediagnostic: PH0PR04MB7478:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB747847CF571F12034913A9DEF2C09@PH0PR04MB7478.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bt06Snr1Lr+2EYPXS891Bg+niYX5hJ3AL9LRRPqJXjWji6LJU95zrFx1YR0M/5VcdqteN+TWiQTSFW1o1pK40iIXAtdv6gU0Ref9R3saBus9nWsRXxE6ydkN77baPfdwUwo5YLQOzf3CmXLbG+jFNRggbzHxjqrag62z2MCtDBpS4YOaY8fYrj3OaTkCbOKh4zf9V8GluX0Sygxjt2sWdHd9cCPodUB/aPSCNrMPp0Yb5XsBAaSd4UxPddo52JiOWFPY+TYtUSezJ40tiWPhSVrPnI8ay1j8rR2LKCY3xiiwZEY4kfNbbbhen6l/rR3qUfneFeAHwadvE0v1oYUCLbj9qDV4iewjjEOROKSSzv17Lmf0BDcoyZ+FBTo+HvLvqzrE/A/r3zXcAf5XJ7LHWkpwil6zveMDBPMwN1mYPx83Jl+1SB4GOKwLdQXgwuV2PtDSe3KFRYI6KwrRhSwiUsx5mJ/HWva/JjIk4i1mNSM23qy/VPQuJd1NT2eVjAnzBCcWeYaJYHpoQXdIrks215sr7a4Ge6Oi2ZbhtA5SUs4Ca7/Kd2j8bQePRi/7jh0bNp0h94HdPDNLMorYDFGYGOM3pKhQyoe3zmyYd4krmCZ7hzwOJLCkOPStR7xu7SQV6g+MlLFx7Y6qN0VmzwxLx4Tde4KuWirHNhxu9N8tU0E7y+Z39PeIPASa5VMk+Wl6IH2rrCUK2rnIvNSGhRVdyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(122000001)(33716001)(71200400001)(54906003)(6636002)(86362001)(66556008)(38070700005)(91956017)(6506007)(6486002)(9686003)(186003)(6512007)(6862004)(4326008)(76116006)(8676002)(5660300002)(478600001)(83380400001)(2906002)(38100700002)(8936002)(26005)(64756008)(66446008)(66476007)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dy/yuijRratnCAcmtVBIFi+m94NWdQxVRvi4cbdI/ykY5WNr47HTUJzOFK8s?=
 =?us-ascii?Q?k3B1gbyaNedCeqVRU8kBHjoHP69ybCfiOH4sk/ThzjEzJlZq+BLx/F7XK/Fj?=
 =?us-ascii?Q?1wXA+fha/vidVFvEHA8KpJOqyPenjwi5UgmcqOzPzgo1TDJJzZncj3HgkFK5?=
 =?us-ascii?Q?IzR8yQ34YxEf9VEiTbW0jQi2qCxxebfNShSAT0k0M04tGux5RYtPchjROOCW?=
 =?us-ascii?Q?pi0clU08ZjbFyN+fvqdR2uuGzhS8F/FU1D4U802dK+0FuAVlyhJBrZehcoTQ?=
 =?us-ascii?Q?uEdXNGV5BP8WhJla3mzJIGvXZkWdrubHsoNcaGdS+echjs7egbu3oMXxX1Lg?=
 =?us-ascii?Q?J5653GOypjf7+dPPE5MrL1ioCXKxLuIe9Bfqjy6gX08YO4e5qMJDzXva62FJ?=
 =?us-ascii?Q?q3y/lsEj/Gj3hSQol/896d2samdbcrzVGv4x0ArJwWiiUTektZqLf7Xa5LmW?=
 =?us-ascii?Q?ZsWN7QoHHq4ihPBhwb2ti6bTvb9YPyYvS2xVd5KwBu9HA01DLuYgf2ubj3uI?=
 =?us-ascii?Q?vor8hPEtZygTXfbsYlHL9AeBKl1dba7JK/F5mXBHdtqhwfH/PaLBIJHHGd9S?=
 =?us-ascii?Q?5DbA1q1z8LGgZ502nxwHm7BOgiE5t3J/NvU3f5mYLETqLtliAWo9USJ96DZQ?=
 =?us-ascii?Q?nH15vIfH8vcY3ShPCHRCIz6OY3L5vSDLPbHErUbN71Vw1EVR2iHv1DglNOng?=
 =?us-ascii?Q?wgpRt6xIHK2yMuYLTvDefMMvAWg0aCj52zDhzJuowGjtgj207cfdXypRkkYZ?=
 =?us-ascii?Q?B2s7M+BdrBExlMXvb++i9ji1TtduBWSm0ie1xnvOvBOcDRFngn69uWytVAF8?=
 =?us-ascii?Q?5rJ4pqfNJbiQroME9YwrJtey9Jf/udQ58/a1fOO8Bkscz5+mltcmm5UiRB7B?=
 =?us-ascii?Q?R5x2mnZ2GY2qFRQ4qjjFMbPUDbrMmbKgKdoxN4iNrIiriPGnn/hqblmn2T/m?=
 =?us-ascii?Q?6DDEcyicAwc+bnuDwhYQTh+EknlJkMuOn1Ky/pjY7YDIHrM/pWbYQ4dRJOog?=
 =?us-ascii?Q?m1m/K+hNCz8nb8i1kP+kDOebQeT1qMMpOHmhWi9vipdJUgfaFNeaqXyiK4TB?=
 =?us-ascii?Q?Yuv6zAgU7voO0+f6TghPtkDcuXuc/D4GRbEfmAKTp5hL7TlpMCiuURWxsjVN?=
 =?us-ascii?Q?b+G5ElJ1GJLD6+R23sSm4F6bHFgT0nGPu5Tv31EA2R2XaGCEMe2K6diFaXs5?=
 =?us-ascii?Q?g+lh/BIevRi7PAkEOypbR0/k2TwK54ulZDamKpoHjWlVzrLN2u4LhC+VGXLl?=
 =?us-ascii?Q?z48k8du0lz0cHWN0Cx1KBATvokK/9OXAbPNp4DROQltUGyB75uevUw3X4Qac?=
 =?us-ascii?Q?QuUGP5BWG5YVVFEpIafIQhA+3npbzSvz5tv++phsIz2HXw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9BCB8B7F732C5C48991BF0109F4D2B26@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe0fe3f-6e16-496f-f63c-08d9631f9240
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 14:42:29.6859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdkaOPBgOQ9s3sXxLvZDhiLMhM/J4Cd4xuWe6K15zx4srruirV2QIAjlBGYAIYcVUEaosjzPuoA18qT7RyAPdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7478
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 13, 2021 at 10:07:38AM +0900, Damien Le Moal wrote:
> Remove unnecessary gotos in scsi_get_vpd_page() to improve the code
> readability. Also use memchr() instead of an open coded search loop
> and update the outdated kernel doc comment for this function.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>=20
> Changes from v1:
> * Keep the "found" goto and use memchr() in place of the page search
>   loop, as suggested by Bart.
> * Update the patch commit title and message
>=20
>  drivers/scsi/scsi.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index d26025cf5de3..4946d8c4f298 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -339,47 +339,43 @@ static int scsi_vpd_inquiry(struct scsi_device *sde=
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
> +	int result;
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
> +	if (memchr(&buf[4], page, min(result, buf_len)))

Hello Damien,

This will try to access data outside the buffer.

When starting from index 4, you cannot search buf_len number of elements.


Kind regards,
Niklas=
