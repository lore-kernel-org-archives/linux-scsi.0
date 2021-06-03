Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDE2C4708F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 01:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 124D6613DC
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 01:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFCBlF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 21:41:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36346 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhFCBlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 21:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622684360; x=1654220360;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=kTeSNIkk/pyBsZVR3QqSyCFmqkyS5TXNqHaSxgnTjQ4=;
  b=qAnMbw3XBnL6VfCYw3rP3WomTeDdysbMBL/4O6l1JLNRU607qkyj1mjZ
   RKhex8VqAr8InXGT1lhihu9hkYDBRK78kWwNWViUT+fMtp0UmRqPIbTcv
   LQ+RL2c+UcIKbLKw2+ZfwhSOjHCG+hQgk9KSUCpGS3veQSu5eM8G+YkO2
   pujqi+jV6+6/GCmBuNxzULejzlx2v9zMhzjx07CKo5GO3MSmN9SoErEoa
   zx39TO9zSvMt8/1sDtueRymRtEesTrf5SPbijK86bt7S16fDGOSHkOsCo
   PESUUbDOC7Hlekd5m66MPoztikoL7/sRW8H5EVDhr3qfHenHhSQuTeAS9
   Q==;
IronPort-SDR: vHtpklf86QaW+p3LwRIwgZPqdUord7jqIevbBD04WsU6Qo8/HsfrF+8BTFTgPPbbu92eVWauP1
 Ud1E3hUjYgJvvqyE0D/yYBJNLPj7hTILu3BaWG8IJCeUYhsH5AYcdaP2OvDeRsc5zWKek92GHo
 mFhhIG8xZPkb2+oX2YLtgA6gxIcoQcKOShjqg79rWbqhdrXjWiHRupxowJSB92kb9Q0ulLo9fB
 VVsWlotx7F4AGe6xBPKdA10o6t9qpY5mLsUSV3o54ThyP05d7BWBM4zXIM1W+t0KPtbCSWg771
 +TU=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; 
   d="scan'208";a="175234531"
Received: from mail-dm3nam07lp2040.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.40])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 09:39:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB0DfHNGl0RA+B5EnQe/zLu2L5MdUARhy6ovNuTICiacjvv4I5bKm06uHkEvBKbaN1pNET73xzeocKw+FOgYhIZg4QCCV8nx5TX1dKf5LE7ESWuPFkeTv3yX0XN0Waq0oYV/SwSZJU7R50etWo5MTgu3XDxg8j5u7SC1220wTydq3gHl/WiKAkjAcSskW62bxle4A3XIBTEbUSDqOACaKoV8uHYuxU9hCdEm9HII9PWETo3BbcuDzdB2PtjF0EBgkJy+iQlTIjGPQYvTuIcgPO2xWCYdGWKA5eP0OAu8lPyo7tj4AEIYZwsMqUXryREmcdMiStNwrbQantTvbdM1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKz41lsvj4B/h0MB9nUIe6QHIlANIEFRbhxzudegwy0=;
 b=OshLv8YvrghZI3WZEIKy4ZZYvjCGH7UHG0l/KP7jZIq1KkeyzCsGTnK2QNdsps6JORH1eftET0DygxxCCXkAkQ5Hk1I+Gw7Jq37HmSzkRiVc7Vsn3lEdVkGpyOOFJfMGOYqqMZqnr1MXgRpgxuCXZitv5+rcq1IIKbib/r+jSktdcF84qFylX1cYljTMQEqcUg4c90WUEr4OA9RVxf9jhutPxNAe2imzf6+FudmxBzvPiBXiuOQl2MmfdkpccHWMY6Gg1S8uiqIDNX/MJcHZUw6h56azaUOmwapwApxIQ/exAdgSJCOi6oKEX/9Js60A81UphdeKEHjwrLhSYJuqUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKz41lsvj4B/h0MB9nUIe6QHIlANIEFRbhxzudegwy0=;
 b=librKUWmQW/of9YPJeVS7wmV+Drr7Fp3CZseCLIFtb8uD9irBFdWX+0+nWL5Uxk4XaMnVvvszllnE0ym/hunUK3GJZwkHsVjf6o3HnSE9FGI0MKg/JYQIi2J/P1KuKrJb/yvgBy+PRyoCkBJE4a7VBbZojDb+5BRh3z9620sxHA=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB7082.namprd04.prod.outlook.com (2603:10b6:5:24d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 01:39:19 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 01:39:19 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "sysstat@orange.fr" <sysstat@orange.fr>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [RFC] sg: add statistics similar to st
Thread-Topic: [RFC] sg: add statistics similar to st
Thread-Index: AQHXWBWNXzrZy6zhGEirTMPK7lf1mw==
Date:   Thu, 3 Jun 2021 01:39:19 +0000
Message-ID: <DM6PR04MB70811F9D882D85FF1F29A62EE73C9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210603011223.390826-1-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:467:7587:9599:cace]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b26c8bd3-feda-4714-0c33-08d9263067ff
x-ms-traffictypediagnostic: DM6PR04MB7082:
x-microsoft-antispam-prvs: <DM6PR04MB708223FFFE3B5D7CFB0EFBE0E73C9@DM6PR04MB7082.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:494;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uFvGghXjOQDlFQAQBYybHGXB6+tUfkiaOMfnaZG0tttFW5sSKAqqvVJALsQL7fnJFRALVzJj0PbVfMMIPnp1nVXkiWTHY3BHmPZ8lS/NnAmBHpb/Qoc2BklT7zC3jcj+aTQDKtsdHnxJm1WcFLBrB34UB320XO2PRo3WLzX+HQWpPOHZdqGVMYjSMQLrR6tihO84YPDsiUBypmpQDzh1C4E/6ISI1q7MTf85UG3pdcLskKbZJ4zRNzOK38zly0FHXLkopgtjh8neMgadRSxYeUaHSjKp6yp4mO/YDiM2/hGxJCf8PQQ/YKNguQmdnHbgUtpLC54c3FLWuBvrNq0JZa6UZEXBiFGcPrZt6jFsgauZEKnXdPLyjmkjtV9KIe1tFhx2MVcK1d7+6hxwA+5OjrH/tmc9HxcgzOvciQHI4zSmy0GBfaSmVnJW4k434+PzFhz/I1BfZgacdGfb3YZdxQnyk68ile8W+HOcmf+91jk4lqzRxEGgWGV8/gKY3pRvMLbi7GKF9slBBlc0Q2LDpdeAyRF2wzaaEhC7eK4VPVzFqeK0Ytgg0ED24QFdvAmYJKtK562WY1c9NSDrzoCYZre6x9OIBmP4SE9piX/atqA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(33656002)(30864003)(71200400001)(478600001)(66446008)(8676002)(66556008)(55016002)(4326008)(5660300002)(53546011)(186003)(6506007)(2906002)(8936002)(76116006)(7696005)(86362001)(38100700002)(91956017)(122000001)(52536014)(110136005)(54906003)(64756008)(66476007)(9686003)(83380400001)(316002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?EAawzIac+vcsw7zs9Se6p+wVHEboKlR5xvneG4sM1AB1/jPNOJi1o1NmYJCf?=
 =?us-ascii?Q?naSSJyRQIHZfgpGaJrn06ZapefYBXhS4scR43oBgenKGtMVT43t1ks5oPWVF?=
 =?us-ascii?Q?QJMAEMbk3n1eSBlh/BFXOv+1kHsApS2kArgE8+n303OKVOoHdxu7cPGnLMHb?=
 =?us-ascii?Q?ZAJ+9KEsYHloY1YkVC2D2Q3VIC1J4fskf+uFbUkvENShlIwH4HQRDQeQBTdG?=
 =?us-ascii?Q?vM827BXynXSSuiMBc7rxdQvBy7f4OKFWiHDbDsXytmKSt5IFAgVvY8+Kgo2X?=
 =?us-ascii?Q?bkmeXjpo/JjnecyAcCplBoAuloOO1NPfhdmJcHg12IBW0t90514xobi7hvud?=
 =?us-ascii?Q?coZWDrEao/LXPI0iR6K4G7LTg/Anq+vDAkCAxULfdjXVmPnj6XjMcatGUXNH?=
 =?us-ascii?Q?M3PRYzYYAlVQmyV/R0YB8wXWYEFvKyWhGZLbsIgGmoqgwnsteVBSt8COJjZR?=
 =?us-ascii?Q?AdFgHwzm6mZswnYep73sVHGyjRKgBf1ONUNjXUNzNE34+LnpwZv7/V3b1pLN?=
 =?us-ascii?Q?wuSUX+Rgxz+jACiX3z31VMCH3B20oOItlPdz8TfLVRNTf2friaQZjtX+m+ZC?=
 =?us-ascii?Q?VDR/EvczK95cd5nxaLZ4H5Yp35bbrz3c8/p2KWjIAc+HuPPvvtgIuYjDqhhv?=
 =?us-ascii?Q?nghY6o1G0lgNzeXJCQSEEEg1nze5tyZ+HL4Uk/TaiOp/QRb6WR19+1mWHXvh?=
 =?us-ascii?Q?yOZRt9KdjQuHSERpWQPOFl3i/ANh9ZTWBWoL/shVcj/Q7T8LRTcaGns6CM3d?=
 =?us-ascii?Q?ma8vC9lIjbcva4lH8NJ1pjtqdNLrkluJfmmFL3ra+mA18CVE+IxjaNseI0sF?=
 =?us-ascii?Q?gYjzC9a+S/5VfVl/fyFCXi0jDmdqXjR8dNA+5yMWlvEQ3omKvqE1LH7k1iho?=
 =?us-ascii?Q?U3wphsCRddl8NNLTnqjP8rLbbP6OMxjNhjuGexUCRfIxZEBs/CAJv9RcyebE?=
 =?us-ascii?Q?zBYfpxR1SYm6sbn67EfX108OA8pHd8RlY2aJgC/L2T0qNYebKL1vtYnhiHej?=
 =?us-ascii?Q?kUIhHY4/fInob5fWxsEUcW0pgiPw8eVb/WnpXcjf9RcUKU9GGqbgoMixmPr+?=
 =?us-ascii?Q?BPyJp8g+Krz0NS8NtWUaydXVvUJGGQUbRgx2YzhMCQEKQPbmlkYh4FgX9L4V?=
 =?us-ascii?Q?dzkNemZT8AcwBxO4BBemaWpT8lj7d4qqrnU9wa5LaQ/G5BrClO+q+vmPUSfa?=
 =?us-ascii?Q?fHs6hGa6Ai5Lf2NAznfwGZkOzEBxHcS9yE4giiiNFZxQWcRZX+OdX5YMsIR9?=
 =?us-ascii?Q?Q53vVkFL1T6kNhs/90rGRMnNlBLBuuFZooij2PVvs47KUVD8CXOq9TIB30sX?=
 =?us-ascii?Q?06FbjR9A19OaSbC8tLuY/HN18Byut6BAIf6rDhK0/HT6Bp8gs8rKgZTpjJML?=
 =?us-ascii?Q?2xKUcZmZiShRkOtT9kfjEaMxDEgNR+QNHLC68QX0Z2CWf75SZg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b26c8bd3-feda-4714-0c33-08d9263067ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 01:39:19.4112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qfWz/M47SzOD5IfHaAKbS2I97F6n+DLGcn8byDRRuiK7VGRlONrQ4w+VUgU5MSlfrvBMS9S7aQCzw7O6mcg4Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7082
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/06/03 10:12, Douglas Gilbert wrote:=0A=
> Using the existing statistics gathering framework from the st driver,=0A=
> collect statistics for access via sysfs. The sysstat package already=0A=
> has a utility called tapestat for presenting st statistics. Its=0A=
> author is keen to use the existing tapestat code for showing sg=0A=
> statistics (rather than write a new utility).=0A=
> =0A=
> In keeping with the sg driver being SCSI command agnostic, the "read"=0A=
> statistics are compiled for requests that have "data-in" user data=0A=
> while write statistics are compiled for requests that have "data-out"=0A=
> user data.=0A=
> =0A=
> A new module/driver load time parameter called "no_stats" has been=0A=
> added. It is boolean, the default is to collect statistics.=0A=
=0A=
This definitely will be useful :)=0A=
=0A=
> =0A=
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>=0A=
> ---=0A=
> =0A=
> This patch is based on my patchset whose cover is titled: "[PATCH=0A=
> v19 00/45] sg: add v4 interface" sent to the linux-scsi list on=0A=
> 20210523. That patchset is against Martin Petersen's=0A=
> 5.14/scsi-queue branch.=0A=
> =0A=
>  drivers/scsi/sg.c | 259 ++++++++++++++++++++++++++++++++++++++++------=
=0A=
>  1 file changed, 227 insertions(+), 32 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c=0A=
> index d47efed3a3ca..eedeeb1872f7 100644=0A=
> --- a/drivers/scsi/sg.c=0A=
> +++ b/drivers/scsi/sg.c=0A=
> @@ -143,6 +143,7 @@ int sg_big_buff =3D SG_DEF_RESERVED_SIZE;=0A=
>   */=0A=
>  static int def_reserved_size =3D -1;	/* picks up init parameter */=0A=
>  static int sg_allow_dio =3D SG_ALLOW_DIO_DEF;	/* ignored by code */=0A=
> +static bool sg_no_stats;=0A=
=0A=
Most of the tests on this parameter are in the form:=0A=
=0A=
if (!sg_no_stats)=0A=
=0A=
So maybe reverse this and define=0A=
=0A=
static bool sg_stats; (default true)=0A=
=0A=
so that the tests becomes simpler:=0A=
=0A=
if (sg_stats) ...=0A=
=0A=
>  =0A=
>  static int scatter_elem_sz =3D SG_SCATTER_SZ;=0A=
>  =0A=
> @@ -213,7 +214,7 @@ struct sg_request {	/* active SCSI command or inactiv=
e request */=0A=
>  	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */=0A=
>  	u8 cmd_opcode;		/* first byte of SCSI cdb */=0A=
>  	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */=0A=
> -	u64 start_ns;		/* starting point of command duration calc */=0A=
> +	ktime_t start_dur;	/* start time if before completion */=0A=
>  	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */=0A=
>  	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */=0A=
>  	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */=0A=
> @@ -258,6 +259,7 @@ struct sg_device { /* holds the state of each scsi ge=
neric device */=0A=
>  	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */=0A=
>  	struct gendisk *disk;=0A=
>  	struct cdev *cdev;=0A=
> +	struct sg_dev_stats *statsp;	/* NULL when no_stats=3Dtrue */=0A=
>  	struct xarray sfp_arr;=0A=
>  	struct kref d_ref;=0A=
>  };=0A=
> @@ -275,6 +277,19 @@ struct sg_comm_wr_t {  /* arguments to sg_common_wri=
te() */=0A=
>  	const u8 __user *u_cmdp;=0A=
>  };=0A=
>  =0A=
> +struct sg_dev_stats {	/* copied from drivers/scsi/st.h scsi_tape_stats *=
/=0A=
> +	atomic64_t read_byte_cnt;	/* data-in bytes */=0A=
> +	atomic64_t write_byte_cnt;	/* data-out bytes */=0A=
> +	atomic64_t in_flight;		/* Number of I/Os in flight */=0A=
> +	atomic64_t read_cnt;		/* Count of data-in requests */=0A=
> +	atomic64_t write_cnt;		/* Count of data-out requests */=0A=
> +	atomic64_t other_cnt;		/* Count of non-data requests */=0A=
> +	atomic64_t resid_cnt;		/* Count of resid_len > 0 */=0A=
> +	atomic64_t tot_read_time;	/* time spent completing data-in_s */=0A=
> +	atomic64_t tot_write_time;	/* time spent completing data-out_s */=0A=
> +	atomic64_t tot_io_time;		/* ktime spent doing any I/O */=0A=
> +};=0A=
> +=0A=
>  /* tasklet or soft irq callback */=0A=
>  static void sg_rq_end_io(struct request *rq, blk_status_t status);=0A=
>  /* Declarations of other static functions used before they are defined *=
/=0A=
> @@ -306,6 +321,8 @@ static struct sg_request *sg_mk_srp_sgat(struct sg_fd=
 *sfp, bool first,=0A=
>  static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);=0A=
>  static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queu=
e *q,=0A=
>  			     int loop_count);=0A=
> +static u32 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr=
_stp,=0A=
> +		      bool *is_durp);=0A=
>  #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)=0A=
>  static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);=
=0A=
>  #endif=0A=
> @@ -1020,7 +1037,12 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_reques=
t *srp)=0A=
>  	is_v4h =3D test_bit(SG_FRQ_IS_V4I, srp->frq_bm);=0A=
>  	sync =3D test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);=0A=
>  	SG_LOG(3, sfp, "%s: is_v4h=3D%d\n", __func__, (int)is_v4h);=0A=
> -	srp->start_ns =3D ktime_get_boottime_ns();=0A=
> +	if (sg_no_stats) {=0A=
> +		WRITE_ONCE(srp->start_dur, 0);=0A=
> +	} else {=0A=
> +		atomic64_inc(&sdp->statsp->in_flight);=0A=
> +		WRITE_ONCE(srp->start_dur, ktime_get_boottime());=0A=
> +	}=0A=
>  	srp->duration =3D 0;=0A=
>  =0A=
>  	if (!is_v4h && srp->s_hdr3.interface_id =3D=3D '\0')=0A=
> @@ -1194,11 +1216,45 @@ sg_copy_sense(struct sg_request *srp, bool v4_act=
ive)=0A=
>  	return sb_len_ret;=0A=
>  }=0A=
>  =0A=
> +static void=0A=
> +sg_do_stats(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)=
=0A=
> +{=0A=
> +	int dir =3D v4_active ? srp->s_hdr4.dir : srp->s_hdr3.dxfer_direction;=
=0A=
> +	ktime_t kt =3D READ_ONCE(srp->start_dur);=0A=
> +	struct sg_dev_stats *statsp =3D sfp->parentdp->statsp;=0A=
> +=0A=
> +	if (!statsp)=0A=
> +		return;=0A=
> +	if (dir =3D=3D SG_DXFER_TO_DEV) {		/* data-out, write-like */=0A=
> +		atomic64_add(ktime_to_ns(kt), &statsp->tot_write_time);=0A=
> +		atomic64_add(ktime_to_ns(kt), &statsp->tot_io_time);=0A=
> +		atomic64_inc(&statsp->write_cnt);=0A=
> +		atomic64_add(srp->sgat_h.dlen, &statsp->write_byte_cnt);=0A=
> +	} else if (dir =3D=3D SG_DXFER_FROM_DEV) {	/* data-in, read-like */=0A=
> +		atomic64_add(ktime_to_ns(kt), &statsp->tot_read_time);=0A=
> +		atomic64_add(ktime_to_ns(kt), &statsp->tot_io_time);=0A=
> +		atomic64_inc(&statsp->read_cnt);=0A=
> +		atomic64_add(srp->sgat_h.dlen, &statsp->read_byte_cnt);=0A=
> +		if (srp->in_resid > 0)=0A=
> +			atomic64_inc(&statsp->resid_cnt);=0A=
> +	} else {	/* no data transfer (e.g. TEST UNIT READY) */=0A=
> +		atomic64_add(ktime_to_ns(kt), &statsp->tot_io_time);=0A=
> +		atomic64_inc(&statsp->other_cnt);=0A=
> +	}=0A=
> +	atomic64_dec(&statsp->in_flight);=0A=
> +}=0A=
=0A=
Instead of all these atomic calls, I wonder if it would be less overhead to=
=0A=
protect statsp with a spinlock ?=0A=
=0A=
> +=0A=
>  static int=0A=
>  sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_act=
ive)=0A=
>  {=0A=
>  	u32 rq_res =3D srp->rq_result;=0A=
>  =0A=
> +	if (!sg_no_stats) {=0A=
> +		const enum sg_rq_state sr_st =3D SG_RS_BUSY;=0A=
> +=0A=
> +		sg_do_stats(sfp, srp, v4_active);=0A=
> +		srp->duration =3D sg_get_dur(srp, &sr_st, NULL);=0A=
> +	}=0A=
>  	if (unlikely(srp->rq_result & 0xff)) {=0A=
>  		int sb_len_wr =3D sg_copy_sense(srp, v4_active);=0A=
>  =0A=
> @@ -1625,49 +1681,43 @@ sg_calc_sgat_param(struct sg_device *sdp)=0A=
>  	sdp->max_sgat_sz =3D sz;=0A=
>  }=0A=
>  =0A=
> -static u32=0A=
> -sg_calc_rq_dur(const struct sg_request *srp)=0A=
> -{=0A=
> -	ktime_t ts0 =3D ns_to_ktime(srp->start_ns);=0A=
> -	ktime_t now_ts;=0A=
> -	s64 diff;=0A=
> -=0A=
> -	if (ts0 =3D=3D 0)=0A=
> -		return 0;=0A=
> -	if (unlikely(ts0 =3D=3D S64_MAX))	/* _prior_ to issuing req */=0A=
> -		return 999999999;	/* eye catching */=0A=
> -	now_ts =3D ktime_get_boottime();=0A=
> -	if (unlikely(ts0 > now_ts))=0A=
> -		return 999999998;=0A=
> -	/* unlikely req duration will exceed 2**32 milliseconds */=0A=
> -	diff =3D ktime_ms_delta(now_ts, ts0);=0A=
> -	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;=0A=
> -}=0A=
> -=0A=
> -/* Return of U32_MAX means srp is inactive state */=0A=
>  static u32=0A=
>  sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,=0A=
>  	   bool *is_durp)=0A=
>  {=0A=
>  	bool is_dur =3D false;=0A=
> -	u32 res =3D U32_MAX;=0A=
> +	s64 dur_ns;=0A=
> +	ktime_t start_dur =3D READ_ONCE(srp->start_dur);=0A=
>  =0A=
> +	if (ktime_to_ns(start_dur) <=3D 0) {=0A=
> +		is_dur =3D true;=0A=
> +		dur_ns =3D 0;=0A=
> +		goto fini;=0A=
> +	}=0A=
>  	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {=0A=
> -	case SG_RS_INFLIGHT:=0A=
>  	case SG_RS_BUSY:=0A=
> -		res =3D sg_calc_rq_dur(srp);=0A=
> +		if (test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {=0A=
> +			dur_ns =3D ktime_to_ns(start_dur);=0A=
> +			is_dur =3D true;=0A=
> +			break;=0A=
> +		}=0A=
> +		dur_ns =3D 1;=0A=
> +		break;=0A=
> +	case SG_RS_INFLIGHT:=0A=
> +		dur_ns =3D ktime_sub(ktime_get_boottime(), start_dur);=0A=
>  		break;=0A=
>  	case SG_RS_AWAIT_RCV:=0A=
>  	case SG_RS_INACTIVE:=0A=
> -		res =3D srp->duration;=0A=
> +		dur_ns =3D ktime_to_ns(start_dur);=0A=
>  		is_dur =3D true;	/* completion has occurred, timing finished */=0A=
>  		break;=0A=
> -	default:=0A=
> -		break;=0A=
>  	}=0A=
> +fini:=0A=
>  	if (is_durp)=0A=
>  		*is_durp =3D is_dur;=0A=
> -	return res;=0A=
> +	if (dur_ns < 2)=0A=
> +		return 999999999;	/* timekeeping problem */=0A=
> +	return ktime_to_ms(ns_to_ktime(dur_ns));=0A=
>  }=0A=
>  =0A=
>  static void=0A=
> @@ -1678,8 +1728,6 @@ sg_fill_request_element(struct sg_fd *sfp, struct s=
g_request *srp,=0A=
>  =0A=
>  	xa_lock_irqsave(&sfp->srp_arr, iflags);=0A=
>  	rip->duration =3D sg_get_dur(srp, NULL, NULL);=0A=
> -	if (rip->duration =3D=3D U32_MAX)=0A=
> -		rip->duration =3D 0;=0A=
>  	rip->orphan =3D test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);=0A=
>  	rip->sg_io_owned =3D test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);=0A=
>  	rip->problem =3D !!(srp->rq_result & SG_ML_RESULT_MSK);=0A=
> @@ -2502,6 +2550,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t stat=
us)=0A=
>  	int a_resid, slen;=0A=
>  	u32 rq_result;=0A=
>  	unsigned long iflags;=0A=
> +	ktime_t start_tm;=0A=
>  	struct sg_request *srp =3D rqq->end_io_data;=0A=
>  	struct scsi_request *scsi_rp =3D scsi_req(rqq);=0A=
>  	struct sg_device *sdp;=0A=
> @@ -2528,7 +2577,9 @@ sg_rq_end_io(struct request *rqq, blk_status_t stat=
us)=0A=
>  =0A=
>  	SG_LOG(6, sfp, "%s: pack_id=3D%d, res=3D0x%x\n", __func__, srp->pack_id=
,=0A=
>  	       rq_result);=0A=
> -	srp->duration =3D sg_calc_rq_dur(srp);=0A=
> +	start_tm =3D READ_ONCE(srp->start_dur);=0A=
> +	if (start_tm > 0)=0A=
> +		WRITE_ONCE(srp->start_dur, ktime_sub(ktime_get_boottime(), start_tm));=
=0A=
>  	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&=0A=
>  		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {=0A=
>  		u32 scsi_stat =3D rq_result & 0xff;=0A=
> @@ -2683,6 +2734,8 @@ sg_add_device_helper(struct gendisk *disk, struct s=
csi_device *scsidp)=0A=
>  	return sdp;=0A=
>  }=0A=
>  =0A=
> +static const struct attribute_group *sg_dev_groups[];=0A=
> +=0A=
>  static int=0A=
>  sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)=0A=
>  {=0A=
> @@ -2714,6 +2767,9 @@ sg_add_device(struct device *cl_dev, struct class_i=
nterface *cl_intf)=0A=
>  		error =3D PTR_ERR(sdp);=0A=
>  		goto out;=0A=
>  	}=0A=
> +	if (!sg_no_stats)=0A=
> +		sdp->statsp =3D kzalloc(sizeof(*sdp->statsp), GFP_KERNEL);=0A=
> +		/* don't worry if NULL, probably a lot of devices */=0A=
>  =0A=
>  	error =3D cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);=0A=
>  	if (error)=0A=
> @@ -2723,6 +2779,7 @@ sg_add_device(struct device *cl_dev, struct class_i=
nterface *cl_intf)=0A=
>  	if (sg_sysfs_valid) {=0A=
>  		struct device *sg_class_member;=0A=
>  =0A=
> +		sg_sysfs_class->dev_groups =3D sg_dev_groups;=0A=
>  		sg_class_member =3D device_create(sg_sysfs_class, cl_dev->parent,=0A=
>  						MKDEV(SCSI_GENERIC_MAJOR,=0A=
>  						      sdp->index),=0A=
> @@ -2749,6 +2806,7 @@ sg_add_device(struct device *cl_dev, struct class_i=
nterface *cl_intf)=0A=
>  	return 0;=0A=
>  =0A=
>  cdev_add_err:=0A=
> +	kfree(sdp->statsp);=0A=
>  	write_lock_irqsave(&sg_index_lock, iflags);=0A=
>  	idr_remove(&sg_index_idr, sdp->index);=0A=
>  	write_unlock_irqrestore(&sg_index_lock, iflags);=0A=
> @@ -2777,6 +2835,7 @@ sg_device_destroy(struct kref *kref)=0A=
>  	 */=0A=
>  =0A=
>  	xa_destroy(&sdp->sfp_arr);=0A=
> +	kfree(sdp->statsp);=0A=
>  	write_lock_irqsave(&sg_index_lock, flags);=0A=
>  	idr_remove(&sg_index_idr, sdp->index);=0A=
>  	write_unlock_irqrestore(&sg_index_lock, flags);=0A=
> @@ -3919,6 +3978,140 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_st=
r)=0A=
>  }=0A=
>  #endif=0A=
>  =0A=
> +static ssize_t read_cnt_show(struct device *dev, struct device_attribute=
 *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->read_cnt));=0A=
=0A=
If you switch to use a spinlock for protecting struct sg_dev_stats, these c=
an=0A=
probably use READ_ONCE() without taking the spinlock, I think.=0A=
=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(read_cnt);=0A=
> +=0A=
> +static ssize_t read_byte_cnt_show(struct device *dev, struct device_attr=
ibute *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->read_byte_cnt));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(read_byte_cnt);=0A=
> +=0A=
> +static ssize_t read_ns_show(struct device *dev, struct device_attribute =
*attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->tot_read_time));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(read_ns);=0A=
> +=0A=
> +static ssize_t write_cnt_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->write_cnt));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(write_cnt);=0A=
> +=0A=
> +static ssize_t write_byte_cnt_show(struct device *dev, struct device_att=
ribute *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->write_byte_cnt));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(write_byte_cnt);=0A=
> +=0A=
> +static ssize_t write_ns_show(struct device *dev, struct device_attribute=
 *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->tot_write_time));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(write_ns);=0A=
> +=0A=
> +static ssize_t in_flight_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->in_flight));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(in_flight);=0A=
> +=0A=
> +static ssize_t io_ns_show(struct device *dev, struct device_attribute *a=
ttr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->tot_io_time));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(io_ns);=0A=
> +=0A=
> +static ssize_t other_cnt_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->other_cnt));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(other_cnt);=0A=
> +=0A=
> +static ssize_t resid_cnt_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return scnprintf(buf, PAGE_SIZE, "%lld\n", (long long)atomic64_read(&sp=
->resid_cnt));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(resid_cnt);=0A=
> +=0A=
> +static struct attribute *sg_stats_attrs[] =3D {=0A=
> +	&dev_attr_read_cnt.attr,=0A=
> +	&dev_attr_read_byte_cnt.attr,=0A=
> +	&dev_attr_read_ns.attr,=0A=
> +	&dev_attr_write_cnt.attr,=0A=
> +	&dev_attr_write_byte_cnt.attr,=0A=
> +	&dev_attr_write_ns.attr,=0A=
> +	&dev_attr_in_flight.attr,=0A=
> +	&dev_attr_io_ns.attr,=0A=
> +	&dev_attr_other_cnt.attr,=0A=
> +	&dev_attr_resid_cnt.attr,=0A=
> +	NULL,=0A=
> +};=0A=
> +=0A=
> +static struct attribute_group sg_stats_group =3D {=0A=
> +	.name =3D "stats",=0A=
> +	.attrs =3D sg_stats_attrs,=0A=
> +};=0A=
> +=0A=
> +static const struct attribute_group *sg_dev_groups[] =3D {=0A=
> +	&sg_stats_group,=0A=
> +	NULL,=0A=
> +};=0A=
> +=0A=
>  #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)=0A=
>  =0A=
>  #define SG_SNAPSHOT_DEV_MAX 4=0A=
> @@ -4623,6 +4816,7 @@ static void sg_dfs_exit(void) {}=0A=
>  module_param_named(scatter_elem_sz, scatter_elem_sz, int, 0644);=0A=
>  module_param_named(def_reserved_size, def_reserved_size, int, 0644);=0A=
>  module_param_named(allow_dio, sg_allow_dio, int, 0644);=0A=
> +module_param_named(no_stats, sg_no_stats, bool, 0644);=0A=
>  =0A=
>  MODULE_AUTHOR("Douglas Gilbert");=0A=
>  MODULE_DESCRIPTION("SCSI generic (sg) driver");=0A=
> @@ -4633,5 +4827,6 @@ MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);=0A=
>  MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element size (default:=
 max(SG_SCATTER_SZ, PAGE_SIZE))");=0A=
>  MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd=
");=0A=
>  MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow)); n=
ow ignored");=0A=
> +MODULE_PARM_DESC(no_stats, "don't collect per device statistics (default=
: 0)");=0A=
>  module_init(init_sg);=0A=
>  module_exit(exit_sg);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
