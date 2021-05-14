Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C655CC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A0F61402
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 01:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhENB6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 21:58:43 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:32413 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhENB6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 21:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957452; x=1652493452;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UXy/yzBAwSfnoMarIZQZa5oE80gsbpVmVvkSRjc5aj4=;
  b=Vul+qqZHMS8f+EoKYabM2A8z+IrSn3uzEPREbA8oqhMZDiAWrlO9o2C4
   XRsC+Zal/Ilh+DKM9tyTYBN3H+Y7ffErNThy0aujxw6JaLSzTq0hPi09B
   zXxm3F5zTSyXVolCoFiqW3+aVouz3EbhAazBQh8py/DrQuzaKgi0hW6Fu
   AelJl0vIqgtgAtlHNvq4x8gT3pc+rF9PEhJyy/gP+SJZiS+yDAY48ASC6
   fIzWtIZOTqtQTjDUVCqcB5gsqM3A61ViJ9xihDcNsNLbkCf5I0RneLOgW
   gnMMdsmpeSiTpwg4Mje9gf5JI4IWGjAJdIagJ5AwrxnLyNWXtjGI7RLHO
   A==;
IronPort-SDR: VuvHlCDEN37LFXJnuO3RaAvzbUNdoPyg5i64Ukfik1TI/AyxB803sRS4koJRlS0L1QzRd/lBIX
 Gx2/+46f4TBgrI3Y2pMW0RkwCFndTK/JAgXLaHjNosE6q3C1G8P8psTw8u02JZcoRY2QqOJM5f
 nqrAo4eK9q+TRv6TK+hpUCp1A4O1Nw3EQG8yTj5k8N2i17okny+JuAdDSIRcVaFV2HbARFtRpr
 GVoDkaq1MDXQAJVWwgGzQoAuEPKy09697YFm9Zs3/5bagGX22UegqFATxmcTE2k8VtOFO5wm+L
 dng=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="167454394"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 09:57:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvrPatTNMcuuo4NIN0Xt86hL8SIEKZ7ZG0QARvmKul6aiNqCGDufDUoWtTKlp4VDIyrQulkRwU43H48R6cl4rF96wUWx5XDeRCHL7y0TavNAladrj2AQliJnmM4KHfWKcctWG/W6kailVbdBRt8eaxx/ma6i7iYF0hDHlWxkaZXvlcNPk+spDsZIsmx61OKYsjzFZfDAwAVgL9b03VKd5JzMJJciBaXo6QKKMBEPWZOMapV+m/doRw7a3xMBLQS34A8iMhhKj5pS+1eNukdUakUiq1EW2RyOmh3/6goMuC1tyzkcu/cRi/pr6XC9OU6hsvZMtJbTaHmvVzVKUn/+UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyN8zGOSk1wpOSVG0Ya2kFOqBB9gDUROm4DIAGLk16U=;
 b=V++bvmx64nREZIkipYtMUE7M1lzk3TWnhsvehF24xU9ImuwC7VmCqK6UgR9NPUuqR+qXlMIhFew9tIuoS/f0iOcD02gJgOeBf4bkp6Z4DygviSc0V6B/1y1AmIiKiP7mf1fLQaCY8oK/mdmqSORU1x2ZCszdUZ93kiahaj6mSOUQ8OHp/2SBD23Kxpb4069v4UJqzOvLLQnfMuSu3UDDjo80G/Kdhm9iJjrXBbDae5Vw6Z0IapSwN94KGpA9tZyxIpRD0KsHZGKdWCSNctpsP2P3qkNRWLF3ry8hrFUVEWRvK2B8IEvJnjXtxNRfHA48QOB87RrTKGgdknH/k0hRkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyN8zGOSk1wpOSVG0Ya2kFOqBB9gDUROm4DIAGLk16U=;
 b=lH7FAwxRi04BW+AtjyLVy0i1XTJaYuvssDpUQ2h75u0OlGwQ5yrtIi/FwviG9gQJV/FXHD60yKhZVmuUi0EgJmIXS4+OM0ltzGEfvitaNshMcNUVVGFzYWWVrwAr9r08gR2FV4ZLWms6+oOiPBsvS+hSLX4YncT2DsJZcbtGBI4=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0813.namprd04.prod.outlook.com (2603:10b6:3:f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 01:57:30 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 01:57:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v3 2/8] iser: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Topic: [PATCH v3 2/8] iser: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Index: AQHXSEip6wHdnPRB50yf5ZGC7QGwXg==
Date:   Fri, 14 May 2021 01:57:30 +0000
Message-ID: <DM6PR04MB70813089AA33A12F473D075CE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed795200-0622-42e1-3134-08d9167ba221
x-ms-traffictypediagnostic: DM5PR04MB0813:
x-microsoft-antispam-prvs: <DM5PR04MB081398B7E5812EF46DE02D48E7509@DM5PR04MB0813.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Vg5+vMjfjbe0s/WFhVSlLrK53veNN8rptJFVlbe+jBVee0hZmmWKoMbxWd1cMr955iyflv+oBYbSBkoa5Fu9IprrqYi/rjJECuP45WhYpW6hqvzOFx7FI+E4IRWC/0++2WBReTFljv2Sg0ZyFlNJLpvvWLf8PkI3O0R8Ol8KPb+OO17q7Pj4rxvsP/VzoAIvXI5gauCGZE0X272hkSKlgUUs+B5T1R3VPtnu7kLr1HtQ4aaIXWJVqZm32zmb0IQJ6QO65j0yGphUdMHpMmSPXGDCy+DDZbbw9uvAnAQMt4FpONbj3Kj9kJbjbdut3JCjjZOaxRYg2Ah1iMJaQi/Jnoz5WE3zABoNTni9NCFocBiBFuc1Wg+lkBEO21BKBhlKlMYdP6JLH65lNWa4BC2bG5FaxQSwmNFvyD18e4EhqR9RSwawARADp+wPIT2GEagwJ4fWsrEe1VEBfBJPm9lrvMLRBxn/Gm2ydrl4E6r7D/usKR5yaSdOJg3/SmmQcltfS+iyEcirMRBxjzEPoOJvWqr1pWxZDUae83c7akygeE5dY4fwbpILvZgVJWpQ9HOSVO8i5mfMtBKo0avQ46PvcRehxjLIhcgi8Zb/+BEsx4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(9686003)(33656002)(83380400001)(55016002)(4326008)(71200400001)(478600001)(2906002)(53546011)(38100700002)(122000001)(8936002)(186003)(66476007)(64756008)(316002)(8676002)(91956017)(86362001)(110136005)(6506007)(54906003)(5660300002)(66946007)(76116006)(66446008)(52536014)(7696005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?orCcL1mvGVCPtiAz1wK/1KbIKYLo6IhDIbTB6tNk1TvyJPUDTp2xZg1Wxo2P?=
 =?us-ascii?Q?GFRo9sDZl0AE222PKu+pjZ8FMen3M0Jc1Lf7DcqQLErnJl9wx445Zx2ouSmZ?=
 =?us-ascii?Q?fa8xSKhp2mF34FblQaqhXzvdNZztOvT4ZkCuvn86H1Du0gxZSc9zBFiQp7xW?=
 =?us-ascii?Q?+JdPKpK5OO3B247xMGL47dU+Qr9Fr5igUcs+p4HRZLILZ/Pn13uvg6uNLkmv?=
 =?us-ascii?Q?1/ELc4z+BqWK5gnCN6aTorMUh4Fql31Dt/od83hq5WZayQTKkLXa8c2KrutA?=
 =?us-ascii?Q?jHZeZqzBvXMnLeOnfD1u6aKkpYaRboYquK0Foqf/kzJ7zfNNP8O9t+LDjAZY?=
 =?us-ascii?Q?/7jvBRbluTsy4VD+GGQDIluTYOBiEHwBiQBXPvK+hGH/od6nokwuAwJzRT1q?=
 =?us-ascii?Q?83hxmnbCdqfyzFUjvdvYGdVZEjRASQny3O+brqvYc6hJSKgbNqW8MPpMo5Up?=
 =?us-ascii?Q?sWmtWHa2OrVufLlDxiVcAHw2ANDibaddI1Ii9iTKIBR7GpM0j67a9vcC500Y?=
 =?us-ascii?Q?w2z5Zqn38WaSU8F9vaAiBimhHegIbP3bVUp2NaskGUvzoFvEVV7LNx0ztNRA?=
 =?us-ascii?Q?rIwdXVBg9HJOWBYd72R+Pa6W+dI2ykgQXQdsN7HbgX7oIEU0nAB+a2wu5eVc?=
 =?us-ascii?Q?m2MLKk4wZLxhaLr91X8gRQQp/gNHHMM1lmOAGh68ESGkd7/igns/L0QPGNJ7?=
 =?us-ascii?Q?HsKU58nimFBQtY+2vtVsmvnbQtBwHvii+MGWkDjJC0HsT3k0MBweHWyx+ANg?=
 =?us-ascii?Q?CoHRWraUK/gLjik84U+QsALbH11JEXRtJviYOo4YGfLbeqNc2lr46yRZUvB8?=
 =?us-ascii?Q?K/HSxhOeuGfloKYjVKw+AZd58iv5QFXNX6KKMgpVYK5l5qLlTvwoctGjK2xc?=
 =?us-ascii?Q?8N7dzQ9pNFzPksVle+pUUS2UxzY9pxORnbO0pSfWMTLj+UVqIwi17g6LnfQ6?=
 =?us-ascii?Q?y57iGPe+Sk/V1pyhF0UAM2YBh2nso/ZEsELUz4luO1rWrEFpuYf763TO8LUQ?=
 =?us-ascii?Q?5i7c7kZSXoXndbiBrmt2aCcwXQ7zi1I5b7zaElLmXFj5lPoiZVM6DTXW4t9w?=
 =?us-ascii?Q?CaCbAQAqHsIIiwuyzKwpoZQLyq8q7PVElIgSd+WF/1WQ/mHw0C9O6TCTe8/R?=
 =?us-ascii?Q?1W83nZhKUkEXtEuewWKCF7kJCdCXW1byGkF1eZ7y2+DLYZIgdvzc59MBu8sp?=
 =?us-ascii?Q?OgX+u0B4M+IlNYqNlEVJhlqFT83LwOVyrcgBaczD0Q8QJRGPh3mbr2ce29SG?=
 =?us-ascii?Q?VzimrpuV6KeA5HdmgI//D2AmoJtaO63IIPsWZM7iFJJOgq0eMRJ4R0Yda9Fi?=
 =?us-ascii?Q?V6GGlNSFEccaJhAtMXKpEZLTM9PV21dUpOJ4fe7zZ39mu9xnunHkYGoZN7Ml?=
 =?us-ascii?Q?nkg8HyhnKUT6rgCJIinw+cLgi1fi9MfEreUO8V+0yu0ITBziwQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed795200-0622-42e1-3134-08d9167ba221
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 01:57:30.5144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zUtWr2e6jTgIaNg7pxBG6A7pu5D8W/sYhRWHZTa8a6i9gpy/1WghAESF7qdpmFuCPZZe2HQ/6WRVt9vMdOP+iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0813
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the=0A=
> latter is confusing. This patch does not change any functionality.=0A=
> =0A=
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  drivers/infiniband/ulp/iser/iser_verbs.c | 2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniban=
d/ulp/iser/iser_verbs.c=0A=
> index 136f6c4492e0..d6bbf1bf428c 100644=0A=
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c=0A=
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c=0A=
> @@ -949,7 +949,7 @@ u8 iser_check_task_pi_status(struct iscsi_iser_task *=
iser_task,=0A=
>  			sector_t sector_off =3D mr_status.sig_err.sig_err_offset;=0A=
>  =0A=
>  			sector_div(sector_off, sector_size + 8);=0A=
> -			*sector =3D scsi_get_lba(iser_task->sc) + sector_off;=0A=
> +			*sector =3D scsi_get_sector(iser_task->sc) + sector_off;=0A=
>  =0A=
>  			iser_err("PI error found type %d at sector %llx "=0A=
>  			       "expected %x vs actual %x\n",=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
