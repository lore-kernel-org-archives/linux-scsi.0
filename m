Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E936EC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6686611AE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhENCHO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 22:07:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31136 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhENCHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 22:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957962; x=1652493962;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MadqigLhxM5WtAz5td5nvFIda+jNmPmGhGPGLTrik0E=;
  b=hJ564IR9eu9JiP9Fr3DYnLEFWaLDc4qBbvXJNVOvCPao4PyF/v5hmPdX
   f+DHWCmry3Z4hTpslLlscdVjUu6aBhVrDtsUP7Mjv03I425mO/qNrDH+O
   U59C3dTUyg8V3Gk63DQo56WGkBl4y78P7MwbmpvmSxGREUMuyijZAaouD
   j4IcNoJ6Y562qNfXpof8p5GYWVjXdhQEaCBfkcL9G4YbERL8Ru11aqOu/
   0DtEPVr+MqJbQafv5+ZFI+uXnj+LCHKGlcL5WmaGAqeuwTcaHOulc0Ui6
   0SZt72zntMT1SMA/v7zZRakvkWzmH/ZXMyv3RFSdf142UkOrRaOKiuHTr
   A==;
IronPort-SDR: kpfNMcgDRJeIJ65Llxje/dS8aD5sfBpVehaHcQkCNmIknXLPvc5La2zZIO7XQ/iczYRT1H4V5L
 6+VpjS+o9eb2eWxcHks8BIqPn4GMJAfoWL6l72EFEriqUBbPCoXLnraw/Adh5/FgTcSGDw+tdM
 EQmJq0vZeNCAVo7XXN6RCZOTCP9PZaW65mgKUZuuALlpO8zaKVTEP+KkyYEOvjAW3ZdEsMrJBk
 6ixlThMLuXOj4gIAQLz4Q2a3LjqF66W1dnUgbDLuBCjxMfoEXiDxf2me4qiqI+QZ+2XXiyWgr1
 Z3s=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="168139254"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 10:06:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZEiiAGwRxNJot9wPJNJnkn1Lt/fERbTuHjBygDv82yHG5FT+Fp6B1oWtsR3knDw910dI+o0Ik+9esyU/qPsi6CykDafHzOvOvqc/eu2tTM1/N6S8b7PycqCd0fsixaUs7imKHGwVwETjclTXadJe7Mu9FQq8OxbILfY2HjPbzqHsg6wyNTCocS7F1ETo0bHjPxGnlyPbXmc0U1FRgJhiRFPCJXB3d13GMsnYZT/nwhckylabQ6SCiZyRvwy7gSy+RiqCqTIvrXcacNvMKQnODrB1LqyeL7+OXsiyzmoVMynDm8ftldUtWj9tRNpvVpHk8JhpWT1uqiwte+AiCesyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA19ot302tTMhJ4FmUi+XVvuzEQKt4KgsgFCU/+b4e8=;
 b=fPpsnMRQU2U/AGpyXd7D4QMLiKSl6OjhQmerdTHIPxm/1UT+VKkELJXhuDcY1r1GKRab26mZAaSDL4Hs9JM0KJxtCKBIhgnApz1iYL1TRACcK/PWP2ns4i+HWP0ewYygI/rL42xnOYYhxFws0WPSodHAXvkeE74ooTbm8X92ixlLLhPO/JhOWNCw8s/fh1g4BQxfR/QcIqxdUKr9ZX9JrQffyYq7A2fgAguOaBj0cgg6ZA7taSz8o9ukowP6Ke32zLLQAL6HugCIMxAZUd0yXXHwz8q0OG8hwXevHrlJL+RHMsFVf1Tflm8Htm0ziODOzum5Kg2LsHAwDPeNH+3n1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA19ot302tTMhJ4FmUi+XVvuzEQKt4KgsgFCU/+b4e8=;
 b=AxqUxACrHQdMaJBWODv/uV6ZImq9kX0MuObRqiGWqfYQybXd56HBJcubLQg1d5Z8pGaEbjQK5tRkshuKxHEWa7LGV3jkBJ7vytC8DcReKeWLrQq/vN44B7q7FNFipjfOokD3NpYYpXzGbKuIz918yMIoOM7UGGEyIAseteKTT20=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4411.namprd04.prod.outlook.com (2603:10b6:5:9b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 02:06:01 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 02:06:01 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 8/8] core: Remove scsi_get_lba()
Thread-Topic: [PATCH v3 8/8] core: Remove scsi_get_lba()
Thread-Index: AQHXSEiz2sS1Qg8ObkOJpaHO5Oy2yQ==
Date:   Fri, 14 May 2021 02:06:01 +0000
Message-ID: <DM6PR04MB70817BFB857B5794E0FCC8AEE7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29ee8300-28a8-45e1-9022-08d9167cd2b9
x-ms-traffictypediagnostic: DM6PR04MB4411:
x-microsoft-antispam-prvs: <DM6PR04MB4411FB6E84F00003702949CDE7509@DM6PR04MB4411.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:462;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eK3aGKtj5nGS0Gs+Md9KIjLx30iYuZ+iMg2fRDVGLItgxV/6bvGRUANrtxUhZEBywP1Sh5b/KtnmOLMG6ysdXqgANJJ4y/kXq+/TqB6lhdajaP6pCXmxl/mMesh+nY46M9hJhxFjTHgU5hPkZf8jM6HcNJMOKdkyxq0703hGsZWBWdSrE8QCB9w1giy6Uv4DsDl7hrYAWED8NR/bGxI2Wgjv7PG/wQ0Guuszsu1dYoSqEXJCRvBndIp1vuFU9M6DMRoK8tBDF2TJJhu+1fR+JW1dOwEqtBm9xqiT1afZLFU9ZfUkxSGTwp4rTQGu3ldlPY8KVc+b1B/F4kgo2GfIpKdqHvr8Mfbv2V4eWuGE5Gc6SOyoVf12TkAEX5Do7A/z2kM7gdTmVxKc2fYROsNh0l7xtHm9YD68tDbO+krElYayqrKrHeXRO1my8opEWIsC35OgwUmDbo5uJU1uYFJiQ4aK/XUDNQdwB/D3c6Itw0/5JN6CJAsw4ZMlZSqCQ5VIx3vu4gbDBxgUQGRngi4DgraJEXjGm5KD0P7xJqxkZHO5tAFp+xXVH0Grq83t03H/VBhDHZR2BKJi7y/rv37Ad2DO0xkQLCme4RSivPlZv8I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(478600001)(66476007)(6506007)(66446008)(8676002)(66556008)(38100700002)(83380400001)(9686003)(71200400001)(86362001)(4744005)(4326008)(55016002)(8936002)(64756008)(54906003)(2906002)(91956017)(53546011)(66946007)(33656002)(76116006)(5660300002)(316002)(52536014)(110136005)(7696005)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sr005MGspPiL5eC8m99ULF3TWgruTv5KdCv+qfCq+SN6oU5e2YEjVrZcu16W?=
 =?us-ascii?Q?ggrHM+aqCWZ+/fbyoxiOe0BHy2MUfti78vOVLwj17tDiKBV3/1TXe80RCsFg?=
 =?us-ascii?Q?vVXboZDy2RpyvCorm4nZetlS3GgAp9I/kRpA3bJmRon3ykmeDPKNsY3582Kg?=
 =?us-ascii?Q?o3BJzqgBdVdDc8BKpsAj4xuZFGBuqY3qLt97azfenPVOkbBx4jxAtDZw3C9m?=
 =?us-ascii?Q?oZrT0EbOyu9fnFOcXeOTHltlZbIuDMYUzMbhevBHIp5GIjKz/eJ4uaI9Z2Ij?=
 =?us-ascii?Q?rVAWpBqWnLAROeadQcfZzNTkB1PBomtVnGtSstJEiEBFl5lBGE8lK2O3b09w?=
 =?us-ascii?Q?L4UHPp/ZWPkvlbzbHAN278CWbDCzJ32d2847/sdtbynh1GgeC9M9wXa3OxrI?=
 =?us-ascii?Q?TmLAptbR61QOgvco6PKv76eNNDjOJHO40gJtxosEa7pCPiT6hduM2/Ugbnob?=
 =?us-ascii?Q?Nl4rzWx+V/R4crAURrUh8LxppmtKSVE0+6lwrbpxxNdRK2RmbFQg1Vv6WfAt?=
 =?us-ascii?Q?AOm91VA6lri66HJc6T1XnwqZwae9FLNuB8e8n+qr2HfRn/VuMv/CA/5U9pwA?=
 =?us-ascii?Q?FoP0tKZE0v6ERhcT7Z77R9fNYP5vWxPJNc+JGT8bDPa6u4xhYlLSUKcktWHB?=
 =?us-ascii?Q?gvIer08EdDsrOPV+bUjCdNJmL+7nArSyRA4doLghw0IVcvWZB+FIh8GxdZXT?=
 =?us-ascii?Q?Vr3Ieyozv3jA/QJ5vQIn9LqqjJk0rzCyYSMS4UQYLWKHKySfVJ1+j71ECcfU?=
 =?us-ascii?Q?xv9znnlRhpu2DVIdxrS72RSyK5BvyShuAmi8CqfjmJdVGmez0zkYX6UnKMy1?=
 =?us-ascii?Q?nFh0LbrN1Z5YrEJXMgEwDmeiNXkqRYC6drTgdzRZOzEAQzYOhODh9VAuiZsE?=
 =?us-ascii?Q?nQZhSh+/8niEbO9rAHJzdnxELDi9LtoPPn/jVLWSDxvbQI6/JhIyK/ZuuTjO?=
 =?us-ascii?Q?jl90Iooxm6YZCXB4iYhbbZzQIQXVBdDvpKJUdwRz1LiI2j3Q5QZt2gL/fO3W?=
 =?us-ascii?Q?LbLxKiUnIcuhMKeqZFVH+bf+r9IjXSX7mJ/8kE4syLh9gU5EZ/6dspN0PodV?=
 =?us-ascii?Q?zTAK1DoiZjdnZVZk9O96/l32EgfwvEn8wFkHalcdh2XbyuM48gSJfA7d5eiB?=
 =?us-ascii?Q?TJKoR8uaYm+wFmjoqqt8X+Q6HtRNNTEPfqouXs3bP6WAWd0PA4uju6zT2F3H?=
 =?us-ascii?Q?3ZCHBMX13Eql4kf89pGsibK+M86YvWg2eoQ7kCfJSxUxQnionq52hFhnKigC?=
 =?us-ascii?Q?Efk6kxc5dmqV4UyC80MrmpkTzYaHHl/j8mSVi7EXSnmyM0RY7+Y7v/dh4Ohq?=
 =?us-ascii?Q?CDD/X7WNhPCDQMLJniNRt/wJ1tcwu8Jqvnf5D4Nz6GqsHqz63JiftlO2bZO1?=
 =?us-ascii?Q?A4I6h2QSsiV5hgu8hwtLSnXanxkkQvXK7dHABoTjqdcPLH0ezw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ee8300-28a8-45e1-9022-08d9167cd2b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 02:06:01.5563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ajn7jlnr25OxO9ToYmPZ1pXU2oIfblitwFq9MEHwgwoTa/1VhdVbbf15U+izZ2qOyjGnHGEB5qlxac3K9PwVZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4411
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Remove scsi_get_lba() since all callers have been converted to=0A=
> scsi_get_sector().=0A=
> =0A=
> Cc: Christoph Hellwig <hch@lst.de>=0A=
> Cc: Ming Lei <ming.lei@redhat.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  include/scsi/scsi_cmnd.h | 5 -----=0A=
>  1 file changed, 5 deletions(-)=0A=
> =0A=
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h=0A=
> index 7f55faa70301..77a0916c8769 100644=0A=
> --- a/include/scsi/scsi_cmnd.h=0A=
> +++ b/include/scsi/scsi_cmnd.h=0A=
> @@ -284,11 +284,6 @@ static inline unsigned char scsi_get_prot_type(struc=
t scsi_cmnd *scmd)=0A=
>  	return scmd->prot_type;=0A=
>  }=0A=
>  =0A=
> -static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)=0A=
> -{=0A=
> -	return blk_rq_pos(scmd->request);=0A=
> -}=0A=
> -=0A=
>  static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)=0A=
>  {=0A=
>  	return blk_rq_pos(scmd->request);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
