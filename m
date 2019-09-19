Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61654C49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 10:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37BEF21907
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 10:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OokzBXbn";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mbwNMkPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388940AbfISKV7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 06:21:59 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45009 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388742AbfISKV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 06:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568888518; x=1600424518;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=deV528byAINl2K68ZSD8ncC44+0XeLDJ2+y/QLx91ZM=;
  b=OokzBXbni7ynhGJ+MVc0bR/UECOE1/dHQk7oMyQhuMMyjdD1pD4/HDug
   LGsQdamJTXm4dML3RF3MnOApbLhj16duyeISjt4yQyL+yM2tdX3AXcz6r
   P3dpiF213l4g0pM/exDG0v/b8zlQJSsBC847cFDBPrpJ0yiHYkdAiUwRx
   xuX0dS4QkV/BqfxTmKlePl+LxjvEUBiyJOOu02uMsTTR56bXppcLvDnXb
   InjzAKnqCddgXOcnLLq2ACRh+7FJ6QojJD9rbptr5MEmfwV8fGNSLEOaB
   j1KBDEL8A5Jhp6cBfqDBGsR+UGv3VNXRT0kgBUI1Gu/uy8a7UJ03NB4Fe
   w==;
IronPort-SDR: NHdeY8gq3m6jdlzyD8V8R8wtutMfK6y7/sWqsgn+XbVZUC3Y+sXNAYNi1GzrFiB+JpLWc3ijO3
 EW2v1yRqb0NLnenA4BAiksIj9H+woiprQt9Hp2vE1y0qoatCoSxwhijJm62+491TxOEliyXvoA
 kGgugDajEk7qa05hcBYYMLNzQ3dCc3PVSGqCI/HvzqfROpjBOmmAd1BLvW0PCIR8bUosdQD1Xg
 KthORkD+MIOA1l6p3hMTMczkMRnQvfcDgou2HgtUgtz+gFd4VkFxIYducbQSXBVVXdXzkJuocT
 Wcg=
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="119437310"
Received: from mail-co1nam03lp2056.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.56])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2019 18:21:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLSqmRA2LnBZHjQQc25AIbyJzl0u1qhr5OBI5dF8mUkF9/Ol9uR3UgboSqH4upeWRviVjuMZFYyKgxfNXQdM9rKT9D2MIS9nJwPHJOxaZFA5v2t5/ryCbEdYU3n+RRLcmQ03U/JDgVTmqwEymMHvjTuugSGYNhLjl2FiS0qK8VIk+mAgXJMZLzG4rWgVXc9kOkpVDr8te7Srm93k5JrnwFemnvRCGaey7TExtG4nncZQhbkMf06xowQwHlGOHe40+oGfzJiMfx+YQr1/X2O4uAOQhG3AP+QWmEZky1Zyy/qJcqcDpEOi7zkIUhY4mMHDUEni/l47VKesAVlPdD7yCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/lBDu5kQpITmrR5c//+vxicNV0IOhKXURNC5DtQLVk=;
 b=Q5xPb2KmP20jkvcbbzru66wt8qvKrHm/ANd5iyQy4JI28fvYmlNLCCyUtAxBjzbrEnN9J3xnnrbacIroWPTW+gN/pGvBakq4nsrk18JWb/9BU8NmjXJ5Y5Uaf5P1VelasUMGEPRgDL9xyfJWBY3dFxyw24FVLOc+UJW5lGoKVlNduYXyPZb7JNYl1BK8LDb9cQfIL2y0tXUx5FgfZQZj3b39IVYuhxm8X1hhRRBuXNJ9S6pwo0xNewZoVExVreL6qEbADitkv1uZB77CF5VbyM1CP5DwDq7R/OzFnUpEl0ojxqrvIaNZLHJ9ebqOdkc5VxWDmY3dwO2MW7p22yhtWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/lBDu5kQpITmrR5c//+vxicNV0IOhKXURNC5DtQLVk=;
 b=mbwNMkPLgFFqR1sPj9Ctu2U/59JA0FzFCDFmvy38R7/EqGxSZFi0QAy+jEI8OVIuvyJG3OXv+JJSWvxelRLG/SmhuYzr93aYtwp022+WDyu41KwDT4S7Q3A4y5M2zSblAKYDGlHD8Ip/L+lXv0BEAdJh3/hL0+zZbKK9vXS8PiE=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4486.namprd04.prod.outlook.com (52.135.237.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 19 Sep 2019 10:21:54 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 10:21:54 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 2/2] blk-mq: always call into the scheduler in
 blk_mq_make_request()
Thread-Topic: [PATCH 2/2] blk-mq: always call into the scheduler in
 blk_mq_make_request()
Thread-Index: AQHVbs8K3cwX+YB3YkG6oq7+AYxM/w==
Date:   Thu, 19 Sep 2019 10:21:54 +0000
Message-ID: <BYAPR04MB5816F1F98D8F408D23C1AF47E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190919094547.67194-1-hare@suse.de>
 <20190919094547.67194-3-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [193.86.95.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a25a270-e152-4e4c-8d47-08d73ceb31ae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR04MB4486;
x-ms-traffictypediagnostic: BYAPR04MB4486:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB44865859DDAC0A4DBCA6B03FE7890@BYAPR04MB4486.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(199004)(189003)(7736002)(74316002)(55016002)(9686003)(25786009)(305945005)(6506007)(66946007)(53546011)(55236004)(76176011)(66476007)(66556008)(102836004)(66446008)(64756008)(2906002)(256004)(99286004)(14444005)(5024004)(7696005)(76116006)(91956017)(3846002)(446003)(14454004)(6246003)(476003)(478600001)(486006)(86362001)(5660300002)(186003)(26005)(6116002)(71190400001)(6436002)(8936002)(66066001)(71200400001)(54906003)(110136005)(33656002)(316002)(81166006)(229853002)(4326008)(81156014)(52536014)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4486;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IC0oFMiYyMEtzddK1d2kGV4tIZWFkEvLyO1MaHxEBRk3Dty/mwAj2K/4MgdQ+gZCJ4jMqMBE3IgKep4y9RHBETfZCg0iPs7tyT480pP488Vxqw2fv4c6ntaJo263OCc0NLk0cgP8IcKw093iU3bN3xLpbnlIcJ6Kel3tKcrsDPUaB8vMMZAGUAN6iKD+DN1dp/ttVitwigeCRBp3JkEMrH9OoxwmUyCHBz0nfkbkr9HZMw5wRHjOnj+fenwvjdcxomMUhMvOJR4eBAYmEebSUGjOV/QjFBuzNkjXCUbddK84JAPGy/Y4QSydM1CMvlhV7yhkLe5lN5ZRdItQQIqbIO9jm7UYC0b+NhVr9+MIceRhVPy09QSXDoQx0A9dtk4ivuPWFF+ayavlJY5xkQiSB+oAHihBuRnuiW3KnRgZ10I=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a25a270-e152-4e4c-8d47-08d73ceb31ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 10:21:54.4318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s3oY9Ozpl34Vfb9pv2vf9mswJtl0DDQgjo+YibrP6vxsVNHr4gK07OQnU+vmH5MhPlQRUrYvLM7Lvlhc26bwYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4486
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/19 11:45, Hannes Reinecke wrote:=0A=
> From: Hannes Reinecke <hare@suse.com>=0A=
> =0A=
> A scheduler might be attached even for devices exposing more than=0A=
> one hardware queue, so the check for the number of hardware queue=0A=
> is pointless and should be removed.=0A=
> =0A=
> Signed-off-by: Hannes Reinecke <hare@suse.com>=0A=
> ---=0A=
>  block/blk-mq.c | 6 +-----=0A=
>  1 file changed, 1 insertion(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-mq.c b/block/blk-mq.c=0A=
> index 44ff3c1442a4..faab542e4836 100644=0A=
> --- a/block/blk-mq.c=0A=
> +++ b/block/blk-mq.c=0A=
> @@ -1931,7 +1931,6 @@ static void blk_add_rq_to_plug(struct blk_plug *plu=
g, struct request *rq)=0A=
>  =0A=
>  static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio =
*bio)=0A=
>  {=0A=
> -	const int is_sync =3D op_is_sync(bio->bi_opf);=0A=
>  	const int is_flush_fua =3D op_is_flush(bio->bi_opf);=0A=
>  	struct blk_mq_alloc_data data =3D { .flags =3D 0};=0A=
>  	struct request *rq;=0A=
> @@ -1977,7 +1976,7 @@ static blk_qc_t blk_mq_make_request(struct request_=
queue *q, struct bio *bio)=0A=
>  		/* bypass scheduler for flush rq */=0A=
>  		blk_insert_flush(rq);=0A=
>  		blk_mq_run_hw_queue(data.hctx, true);=0A=
> -	} else if (plug && (q->nr_hw_queues =3D=3D 1 || q->mq_ops->commit_rqs))=
 {=0A=
> +	} else if (plug && q->mq_ops->commit_rqs) {=0A=
>  		/*=0A=
>  		 * Use plugging if we have a ->commit_rqs() hook as well, as=0A=
>  		 * we know the driver uses bd->last in a smart fashion.=0A=
> @@ -2020,9 +2019,6 @@ static blk_qc_t blk_mq_make_request(struct request_=
queue *q, struct bio *bio)=0A=
>  			blk_mq_try_issue_directly(data.hctx, same_queue_rq,=0A=
>  					&cookie);=0A=
>  		}=0A=
> -	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&=0A=
> -			!data.hctx->dispatch_busy)) {=0A=
> -		blk_mq_try_issue_directly(data.hctx, rq, &cookie);=0A=
=0A=
It may be worth mentioning that blk_mq_sched_insert_request() will do a dir=
ect=0A=
insert of the request using __blk_mq_insert_request(). But that insert is=
=0A=
slightly different from what blk_mq_try_issue_directly() does with=0A=
__blk_mq_issue_directly() as the request in that case is passed along to th=
e=0A=
device using queue->mq_ops->queue_rq() while __blk_mq_insert_request() will=
 put=0A=
the request in ctx->rq_lists[type].=0A=
=0A=
This removes the optimized case !q->elevator && !data.hctx->dispatch_busy, =
but I=0A=
am not sure of the actual performance impact yet. We may want to patch=0A=
blk_mq_sched_insert_request() to handle that case.=0A=
=0A=
>  	} else {=0A=
>  		blk_mq_sched_insert_request(rq, false, true, true);=0A=
>  	}=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
