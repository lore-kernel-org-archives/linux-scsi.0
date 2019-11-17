Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6215C432C3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 23:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FDC20729
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 23:56:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TLnnu5dj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ioE7IZ6y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfKQX4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 18:56:48 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:58054 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfKQX4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 18:56:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574035009; x=1605571009;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hPWaQKGqTF9b3GIIoyC0Y3xxP883gJqlKeoYg0WOPks=;
  b=TLnnu5djm4lEEjn5xWCBCT0OWslQMIGtGDE1xvHvN8WwAuJ3adsR9gxu
   gEPW9/p2oZ/Y3VtMrAU5zjbVG+a6u4GLFDfyZG9NHTCjhbAsPA7UEwmnV
   9VmoNA8/E6InVQH8N8UwDIPZ8LOFIQqBXMe/8i0YzT3cdC/98yI0vxJOY
   SFYRSIOgHk/oM3d7eo+E9LQOpHkMVJLSynAEVpMuhwq0oGm2sV+np1Rqy
   9R+B2Y3V6LQ6FGdhgAZAAgQ/baLXgV9eLQef2qLC8+K5wF3uilNQVsfaq
   eioc882Uc21xtmXsBJV4K/1VzfOy2vnnn3cWwiuMcMEJwOHiGwd5hXaqO
   Q==;
IronPort-SDR: YTejGEgNHh/Z+WZ9z5afUg+Swmek9Rpvcw+5hOAhPQgeT45l5uD7ljnwTKLefqWpQOpTYzsBLn
 4LcbEErtnwlVtA8uddiSTo4wsogOHhAQGKseOfwwMMxI01ta8fpTXNTlB41QgAfKlglASxQOBZ
 NUN/Nzoe5eWFUqpwK+eirohw9F5OHvlpix84GkpELb5VIc6k7iwy1KWpRo7uZ99BNRVh8UiEUO
 yReDbRaIUid7I6cnB3wf4QQ59oYQbuqgmWfe4w4UgUWC9+nav0efJ0K7ApkURenK9C7yZq+yC+
 mh0=
X-IronPort-AV: E=Sophos;i="5.68,318,1569254400"; 
   d="scan'208";a="127690772"
Received: from mail-bn3nam01lp2054.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.54])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2019 07:56:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNqpituIrY0pGeqfhKGHOn1BLU5W912NS0A4KdM4YVf35QzuOABD1sJtHAJtvsgqKm8ATs7JEAER+NY5fNzL486Jp+oAX7sm1sOIQr4R6/uGU9s8uRZYa16PSi5DhiEzRcZmJCUFeyZx964F+5NkWknJHQa1WcHDjR0rfAo7RmwwspItDG0wmDvozPrZVBUJDNOsCYwS71z32/3w0B1SxBsGF7Qwf2oNA1GBqAhMBWP8xDQQXTsTvoJobHoYA/TJqPnegjhFpuOOAngpcMub0ufuhVkknXt1ICtjOwQwLXmo0sycHApE8QfbhZ1rZYlEakbqBUPf/vPtFhGv9vRvDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djJPsaMb19IHY9GISP1j0a2BcGtKknHQS8dlRP725Fs=;
 b=Iyl+cM2UwwmUcV6GfL8tRUOAnQTEp6JVsm97kY4eJUa2Woo6KLPdZp4hz6hjyPey8PKNnTgbPQoXmVbViM+wzlrxcop3igRTVpyLJkHpAHZ5jCLE8VmhY4UEN5qLvFphhVLCaSCatbQoRKiwU6Tur2WRqB0xugk6WkUuPseKHi7dCMzilQITElBNPfmn97FMB6n3RfMxQLglc504ZhbJIfNrtVc5sOqhUpDZYyBNEtAimzBWrLB6/PIHl2KqUGMtd9HNxpMrMRRbEfRBU0/fg20KMAShQ/UEXQ0H9gpUQ96K2DcXiDxISOyuGMMa65sROQsu/3qNe8P0NS9G7+rZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djJPsaMb19IHY9GISP1j0a2BcGtKknHQS8dlRP725Fs=;
 b=ioE7IZ6yqJV1NLLCqR+mU2Uov/dk1KmHoPYGgdPdphT30n7Kq//Q8Qw1a8RgGTu4JyFjQX5upP7vb28r47JyOreXvpp2AX2K3zEmjpZJqQ/RUo1rooSOLOWTvM9qBaizKrFBPS979cSW8sa1v7jL+Ia77HzVDC3ndBllKovrTd0=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4920.namprd04.prod.outlook.com (52.135.232.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.24; Sun, 17 Nov 2019 23:56:40 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2451.029; Sun, 17 Nov 2019
 23:56:40 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] scsi: sd_zbc: Remove set but not used variable
 'buflen'
Thread-Topic: [PATCH -next] scsi: sd_zbc: Remove set but not used variable
 'buflen'
Thread-Index: AQHVm7dj0yj5L8RVIk6wU+rJbBb19w==
Date:   Sun, 17 Nov 2019 23:56:40 +0000
Message-ID: <BYAPR04MB58168330EBC014EAD1BBC980E7720@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191115131829.162946-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a7d4d97-edc3-471f-a5f4-08d76bb9ca54
x-ms-traffictypediagnostic: BYAPR04MB4920:
x-microsoft-antispam-prvs: <BYAPR04MB492072BABDD9D32D62A0A110E7720@BYAPR04MB4920.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:167;
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(366004)(396003)(346002)(376002)(136003)(189003)(199004)(54906003)(99286004)(81166006)(316002)(6116002)(5660300002)(52536014)(2906002)(3846002)(25786009)(478600001)(110136005)(305945005)(33656002)(14444005)(486006)(256004)(14454004)(74316002)(476003)(446003)(91956017)(76116006)(66066001)(53546011)(6506007)(71200400001)(71190400001)(6436002)(6246003)(76176011)(7696005)(8676002)(4326008)(26005)(7736002)(186003)(66446008)(64756008)(66556008)(66946007)(86362001)(9686003)(81156014)(8936002)(102836004)(229853002)(55016002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4920;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q7AgqQlempPKtFw30Xl+537/VX6dvcnYWqxGzstxIMa+T3n+w9woyrqPL+EgDzQH9bs5mHri2qhhkqq88bhDDAh/mZdO8LMX8MOq2P1Ph5RxmhS5+IsF11BOp+gkOY1iwWotPtdbKE3NFzDrt4ESoE4z3JrO8jC9v9/3fpORVYIodg2yoyP6PyDNePZedSj0zwzfponXP+aXFBLX3ZAdGRORBqBye2/sHtrry5F2PIucGGqgGFcgvZ6ZDBBlYkqkW3941V9jDgTmLOK/4+M5DrCZh4WmKf0J+bNgk4ssVaXEu7vdBxtF/WF+BfSPnWYnYcD+teGZJLMMEfOV/Zh7wiHvDeMDmMWXhCg84XyL6ckulgCG7hMseLKp6cy+6z1GAY6XPi9ac0eeGFpHs4Z28qKyWAbQg6ymgJIgZIn7Ye7QzQmyu497Mgja0tH5bCWA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a7d4d97-edc3-471f-a5f4-08d76bb9ca54
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2019 23:56:40.2872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b9Gc+qRKXmg3pAm+Vb7vO89J72Y+kUvBHdWHLtQxdbe0U4wDi0T373DxavoGqLbgIv7KENey8aXJK+0lFYLhzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4920
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/15 22:20, YueHaibing wrote:=0A=
> Fixes gcc '-Wunused-but-set-variable' warning:=0A=
> =0A=
> drivers/scsi/sd_zbc.c: In function 'sd_zbc_check_zones':=0A=
> drivers/scsi/sd_zbc.c:341:9: warning:=0A=
>  variable 'buflen' set but not used [-Wunused-but-set-variable]=0A=
> =0A=
> It is not used since commit d9dd73087a8b ("block: Enhance=0A=
> blk_revalidate_disk_zones()")=0A=
> =0A=
> Reported-by: Hulk Robot <hulkci@huawei.com>=0A=
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 2 --=0A=
>  1 file changed, 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 23281825ec38..0e5ede48f045 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -338,7 +338,6 @@ static int sd_zbc_check_zoned_characteristics(struct =
scsi_disk *sdkp,=0A=
>  static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf=
,=0A=
>  			      u32 *zblocks)=0A=
>  {=0A=
> -	size_t buflen;=0A=
>  	u64 zone_blocks =3D 0;=0A=
>  	sector_t max_lba;=0A=
>  	unsigned char *rec;=0A=
> @@ -363,7 +362,6 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp,=
 unsigned char *buf,=0A=
>  	}=0A=
>  =0A=
>  	/* Parse REPORT ZONES header */=0A=
> -	buflen =3D min_t(size_t, get_unaligned_be32(&buf[0]) + 64, SD_BUF_SIZE)=
;=0A=
>  	rec =3D buf + 64;=0A=
>  	zone_blocks =3D get_unaligned_be64(&rec[8]);=0A=
>  	if (!zone_blocks || !is_power_of_2(zone_blocks)) {=0A=
=0A=
Good catch !=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
