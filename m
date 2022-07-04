Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15D6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 12:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiGDM6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 08:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiGDM6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 08:58:46 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDC460DC;
        Mon,  4 Jul 2022 05:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656939523; x=1688475523;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=I3CU3OUTTR6W7+zvWWpGd2CAcFX1H9le/V1XoICejBI=;
  b=EuyAnz9vK/nUxdZNnnIv9n5YRaAeya+DVGsturOF37ln3Gvfu1KYZmKo
   03tF9GRhQtADYY1JeB+A2/eC1ICxOzBx/IH44tqRM6PAiWDwFDjP3fnxE
   /gpkMhy9jAyLMdGMNb03sFQroMa3PcCm6cE26mrV1jacfNP0mYTBp5C7r
   BJ1jXaoVEyOtYKJyVCltHT7xKgtYGNTs3WU18iin+pHbJVxwBflRZZkAA
   xGmglMZ3W2RGs08PHMLZOw6Yi4LJAb1hxMennn1dZGt7+g2MFEHkh8JXx
   X55D8/q4aOz3zlKIOWAZ3LHbJYSGXU139Ht1azo+uUZ/Or37jvahj56dp
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="309089340"
Received: from mail-dm6nam04lp2045.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.45])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 20:58:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWeOS+dxJj67p6tEbPbOjiU2nB8KdLg0AEeZiL0+7T62S5bg6NVoAW1pn/CzMPEPoNLvj50Jc+PbFqBSyKeW/ML5bi3ZVgExhPNyOuAe69TNM+2xK/T9pKT8pm4Sllpylvje5KOfnEiwhPxQHQidGyeUy1ruVQlAQdlHEXqtUDsvrncbPHjXp+mbZyAzkKzMUMdx8XEtt2WRhDSCJEj/T8lUaIe4KweRbeQqW9Mwt3xvMa3Jtoj6+7fx9rlHcWeuIxOBzw6VDuenV6O5F7ue2f+CHHD5FdVZna4hrzp4J3YJVvtwlYxRN47yx4eyZKc2HnDrQIafj/Ej9OgmzRNkaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+BQo4+6qyQ8caLbjsZsMKWIgw58oJrc3bIPdLhNxGA=;
 b=m4nMeb9vddSwQOGrabUFkjIIp8vAQBkIT9fo+FtR5LGvGF4KdZUI5IaKa+CQrOoCQZkIXY9fES5ibnYjB7Et5IXX+rqB0jVYTGv6JvqZ6hShDorDnG2aLXKbbYyd7TgFNTKWTgGswEe5rnox4sZsmfrgT05/PZcbUmAOl03WuOz1DllbXZPCJPmKzsM91/ZihiPtjLmRNcpybGK2KrHdmPQZbLPsCHDE5zmbOL8eJMTeegWh8y68498UoMO75yRknHqv7lIKvpERYB0dLsLqiC4oFp8RBvolM2CLxLiRvkdj9TyfD/XTkOMPgqVDiUt+mjyD4s1Eh77S1FCdMeHS3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+BQo4+6qyQ8caLbjsZsMKWIgw58oJrc3bIPdLhNxGA=;
 b=gIlIteJn1cTX63S9/7ehsQf87V2VCfWQ450E9xbetwIOc0agleAxW7Ty5cnEznLwwAHu+GkX6/GSQyOu3kd0/VBu+TYQQXVJ391DrUyY/Tu3GYFTQ8RakanojD7yGWHeeTB74ZQnuPdPS4zEeNYSqJ5lllBwqUzJHAXnvpLsIRY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB5297.namprd04.prod.outlook.com (2603:10b6:408:d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 12:58:40 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 12:58:40 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Topic: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Index: AQHYj6PpBGDuTXPD8UWi1k2YGkh+6g==
Date:   Mon, 4 Jul 2022 12:58:40 +0000
Message-ID: <PH0PR04MB741671715E7F16D5335002509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 313da69d-ef19-4ce0-b9a6-08da5dbcead6
x-ms-traffictypediagnostic: BN7PR04MB5297:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gpHVWZnQqnLrwlxeeSAAWAlegpL6kN8Uf4gCpFJJ6erEnlYcM+Z3A9sPHk7ZIZSi2A6gK7bfcfY5Td719nhE0RSZK4odgJJnqc5Rb0mDky4k7/cRr0epmxL0Vc7/zI9AbH5YDdCRbs7Px18fNmmX8/40+kT6HGt2P3s9gHJ8wqr5UEwQim3kS1zn5eojAJD+vhpYDdZVyjFDGo8ChHcelL6TejxFerCbb/vwneH8N+UPL43D1g88iOvqStHrs9Cm+yLVtj9lxcT1pg3xntLe/0mOrYhmpVg7f60n9Jp0v+YzwfzXaoXhxdaseOVM2HLeIuVuBBAflo32m2ZHEgnEsVuSs/ofOKYbK54VcRGDFFDC3dkaK1FVXjflMNxvXMkWyzhQPL4wtLlKTH+GFcjn099Zh5utDLn2oQZy1S7NJEtl/gDInS5TcbtqFhlxfGAyoNE2Qmriw9EsZ5LoVv0pLp8mYSP0xj4dbw3FY+7mFJpuDXKDqUCEu2w9AVZjAVQehMjoJTQhzxZbNo0JBm2ZWHZD2xAEPlzP/99ismeeK0+QJcHAYprQDkYzaArFRIE6Or9O4pSa0L93yHsEdbWx7UrTMVgXQTBhf2TmJGV6RDC+VejBZyAYc9rqkMaEs9hka3VthkuOo7vck5xKwdT1v/ZgwgTyne/vv+BdqMaMJKv2NZKMfHyOD6aL+aRYC6B3wyH/HZenGD+VraOGspt42nxOJ15Pc8wHt2ZrknY1WMK+IwG97dyVnxB7eJtampI5pF+jPKl3N4a7JpyQnbze3YdKIzQ1SrC5oMiT91tf/hYEzUJYFw7Mrl3xrVwpubFzMK1pxCVKS2x1zuqF3JDcLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(9686003)(186003)(53546011)(7696005)(83380400001)(55016003)(6506007)(41300700001)(2906002)(38100700002)(54906003)(110136005)(38070700005)(122000001)(82960400001)(478600001)(4744005)(5660300002)(8936002)(52536014)(91956017)(71200400001)(66446008)(66556008)(4326008)(8676002)(66476007)(64756008)(316002)(33656002)(76116006)(66946007)(86362001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TO6VSNF53gDRSvoSPAdrqvqb6P31zJRu9J95U2e/iFjdZj4z9VfdphFQaKE4?=
 =?us-ascii?Q?uL77H30UZpASvrrJYczByoGigbxAgmOUyMw1KLY1X3X3cOaLtq/kegmerjqC?=
 =?us-ascii?Q?/ffOJZ4nPkWFwp/WPhpmX7NnvD9Zt2JMxxMfO/T/w8sHG11nracSkHLnstnE?=
 =?us-ascii?Q?XRfq4/bv6DxsbheCNLaim3utr1Sa+pqXrhBDf3CuuZp498rm0ck9qp4TtJD5?=
 =?us-ascii?Q?tFLBYaAcB5WcqtCereJhOrjF2qgx0iP8DSu+6Xc0DjRlkOmFC7SmdbSiWscW?=
 =?us-ascii?Q?kdWX/FrlRDxlm3746z78U7TSrJH+DunXQh38LQWu2scLgW+nqf9SoRZBPH9V?=
 =?us-ascii?Q?iKSyWXW6uGzUV9QXpkPzFKSRu9dKgwd1Ee722msNoIKxxscXRv+hseYu1M9q?=
 =?us-ascii?Q?LyjmLKn0m/KeBsHnLge0PsLndh4t9rGz2N/QN20jWLTzxLyROVdb69CqieAb?=
 =?us-ascii?Q?ue3OgNafzQsymCF2ohY6FjhVwMlpjv00nRn+hBpqKXEuBudlBfjfUc8cC5Ql?=
 =?us-ascii?Q?U/1ZpEvnjh/C78vTsyF38DdTBBMVt7s72SwsStFmae/9uQC/rJzLDRreKeUT?=
 =?us-ascii?Q?tCsIPXFl/zLd62ECIDLWl2zrOOaNYvLlA5pYD7au/VfaWFzF0KiPHQL4RAps?=
 =?us-ascii?Q?6bSOIKUy26AsKxXHEvQCYA3Ky7c6d38n+e5zZalmj0PDmQ4eS9u9GjSO2fYF?=
 =?us-ascii?Q?zqhyBIln4hMfIOK7FavN0EE6wrmFZaiLEFcq1ZyvdHE/Gc652n83pqB70pmN?=
 =?us-ascii?Q?V9yaURS/w8/xlAPLKhnLi+txYCkeuRBmmCpjkcqpN8HUKqQU12FGOdKNI5FM?=
 =?us-ascii?Q?25udxpRayOXYE7ohJMi5WPPnkS/EfbHLgn+5s/FalHPOpwwMXRrpOUHdzWit?=
 =?us-ascii?Q?Ihq0VtkZXB1NGpJfXq5bHj/UFLls5Q7qacBthDFrHSIBFYsN4Jrox9il3SWu?=
 =?us-ascii?Q?1ocByfigI8jW1ZYMJgDvHb7tNAtC3ENQujgY0UNvihWnrg2pnmZgAvhGlB/L?=
 =?us-ascii?Q?wS4tPpAwCs4LXpYH8zjaV10ZMkpEXc3aFPLw/FGNu+2SArla/ab2neuNzhvW?=
 =?us-ascii?Q?G+unbyhA5KGDcb7le0ohcQ/jyLy8kgW21UfWlenuaAhj4z68EfFnqHCkrpQB?=
 =?us-ascii?Q?6hESsZVvDEs6oDszVdORUr1knWFule7szSxF5DgEkFJtPx4Pa393wUUaAxTv?=
 =?us-ascii?Q?PNperrRek3QwVa7z9AGTriEIKSjJ20NGOSKFMoPFFPnEg1vIobEHT8WkPSRo?=
 =?us-ascii?Q?l7xI0GtJYi4zFK6O4i8mbORayvhWJJQ2g20uW7D1X+pMk9tu2+eFiD0COSBp?=
 =?us-ascii?Q?wF9LyLcDOPoR9GgadBFrHpGy1yEoTRjLpAeDV5WdlZOWEu/saaf4O/0AXF1O?=
 =?us-ascii?Q?T4pj16EMWRDglF6ydUQOXKdA8NFqeSMEV4j2ZgMlddhzO+Ygs8lcb1w/ff/c?=
 =?us-ascii?Q?8Qy1X88JXmulh9bq2yxihpJWOXa/t/8wpqOIU1VyFcfmGM9Wzq4KEsAHIBcV?=
 =?us-ascii?Q?tJaDHKj/biiNYXRBtmHIyy4CuUb77fW6ZLtCRgZOjIgnPmGbSWGgiKJ+17vJ?=
 =?us-ascii?Q?ImMcpfkN0dr5zzipudyWGaBRQ5mRlHd7g2aoyvyTVMpHbegyihMllEFdo+Sw?=
 =?us-ascii?Q?wJiVEpZi/H+KKDHvNY6CvV7yQ2FPx/gk409shvQo/MAEl8Sropqq7LJL70Cq?=
 =?us-ascii?Q?c761Bcj6PbUM80Sofota/H5mpiU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313da69d-ef19-4ce0-b9a6-08da5dbcead6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 12:58:40.1365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gT4aPgbnD/G0MI3rP44J50n9KJwpWx6/9r46JxIstCb00dOquUYzbcVkza0pB/dSrWA14BwsjNWrSzWoaMyBVZ7HeGMMZk8m56D/P2x0bfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5297
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04.07.22 14:45, Christoph Hellwig wrote:=0A=
> It doesn't hurt to lways have the blk_zone_cond_str prototype, and the=0A=
> two inlines can also be defined unconditionally.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  include/linux/blkdev.h | 3 ---=0A=
>  1 file changed, 3 deletions(-)=0A=
> =0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index b9a94c53c6cd3..270cd0c552924 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -899,8 +899,6 @@ static inline struct request_queue *bdev_get_queue(st=
ruct block_device *bdev)=0A=
>  	return bdev->bd_queue;	/* this is never NULL */=0A=
>  }=0A=
>  =0A=
> -#ifdef CONFIG_BLK_DEV_ZONED=0A=
> -=0A=
>  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */=0A=
>  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);=0A=
>  =0A=
=0A=
Won't this break tracing in null_blk, which uses blk_zone_cond_str()?=0A=
