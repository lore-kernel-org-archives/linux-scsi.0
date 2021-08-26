Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2B9C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 02:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB022610C8
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 02:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhHZCIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 22:08:00 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:31490 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbhHZCH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2021 22:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629943631; x=1661479631;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=hAAUL39FmgoHecE9iKkh1fv/FjTc4TzM+axumGTDIeI=;
  b=TBaLGcPehq030q598ncFAdFFTts4FUai7qoH3l3yTr7LiPgF1JFyMq53
   yrt0xdeB4cgT39Bnazp38hUO6XoVPg/yKXeuIAx5YFxhukopnOjTOXXE4
   2jYBzDJF5MhWdBfMB4bxGYBwqFIqzeIBAVz2+Veea7KoDeLWXEq5jqfoR
   yfzGnMICzWnXIINzYd9Fje1mGxPkzMVLUhOH8ZPQ3r1DXr++2CYlxMA8s
   9/WiHcikSglPY8gbECHjItjfrApDAVbP7rZjaCybPDvlEESn6ojTnd7Vn
   rUU/B4Bt/Otd7wvxaPmGvMC2iBr0TVkdf5zPdw1hSBBYbHoOHA/UThZ+r
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,352,1620662400"; 
   d="scan'208";a="183204391"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
  by ob1.hgst.iphmx.com with ESMTP; 26 Aug 2021 10:07:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzYhCdLTCwoFHwOpl82XWlqASW+R5u/HOlbaagAzs0wCFZScYNIemMFZ4nP+T+d8qlMSAcanxVLdxSxmQlMMOqR8uJJOsFz9FpZEYdY+nCCQ7tvuGGZbLzlXDSyXGxMyltrlpMpFKkNw4sVwxDMOrxWr5qsAnMWARkfYSJeJdD6Z0XhpSI2eGh2XynI+tqnhdnHp9R3yxXWds1hcI1fCRk1Q0D2NwNnHLImpegizKgSbIFdWDTuFfcayYx8Its6ScE65rcCJQ44WaFeEXR/NylkkjisZ5NJn/iZ0MjljRS2ARpUdAO4e3F2jhMgyR5L8KDbvQfzn6Ry2pqTOZoiT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC6Rp0RqLVIchkC1cDbCGlmNilvQX+ahe25e7LkMWQo=;
 b=huIeDU0aZaCKboZt+BCfj79uM2ZmjpAiGvfMCjePYMbmHmz9o7f434sp4ElbtG6fTMFAZ9gjDnOcnH8yz7WBPnQOKyOg5+6TSPCrq05affC2rouf2ZjXk2zY164yughLePqMU76SZ7i147N8jp1xzXDxcXT13zEN1MIzc1IPz4wb1Y2saXn/RCXpaHp9AAWKeipTdrj2dK19/XQU4ivAPKwMqHs85kyydIapGw2fr99WhUYBLUJQB5pd0BgB6Qcu5yhivvqcYlKXQRbYYya/rAG0K6c1B+mxXPesez9Wfo2s6AIYpxfroaONAMvGr55EEPHaVFhf6xLi3Zx3htFu5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC6Rp0RqLVIchkC1cDbCGlmNilvQX+ahe25e7LkMWQo=;
 b=VsbzL3RGepu5Z81dBH2MDc42Mi9yagyh9dW75u4ZOw0zAz4Y3E4/jYXOsvzCDtbeHm/Y6XCUHCvnAx5mn/znrA4CoWJEVfN+I4hDIY5R7sFqVORQ/hz8hPI1KpKBHlJeNappQbvgGMQWkiUkyVdnr1xtPNLWtd5qFDXeeMktc1A=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB7084.namprd04.prod.outlook.com (2603:10b6:5:242::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 02:07:09 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%9]) with mapi id 15.20.4436.027; Thu, 26 Aug 2021
 02:07:09 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v5 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXj060+x8p8fG9EkmgObG6vBUOOw==
Date:   Thu, 26 Aug 2021 02:07:09 +0000
Message-ID: <DM6PR04MB7081E6B85744B1F86AC5E7CBE7C79@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b9b59b6-2d84-4166-29a6-08d96836360b
x-ms-traffictypediagnostic: DM6PR04MB7084:
x-microsoft-antispam-prvs: <DM6PR04MB708484FB3E554CE12E91E4B1E7C79@DM6PR04MB7084.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nqb66CdxHcrxHhi3LXwu2cH9V2f84HMphwkr85pbbJ0LDSGHZuxea0vv6xIFYRR6CmT67macvUEcmwNLxfC5bKf/riBTbDYj3slkie09vq/oHDOV+E3/hzab4gJNg6KcRfC0s1uqV6IkiOHZfgqRCymCDlk8DDZXq/+UA1wcjrHVWSYoosRPtJZaqb54C0IS4kt1ctIjOtuWrKh6Ll4dQnxizU0y1FVIrckxyFtg40s1bf49djZ70nZxYZegQOHwgfiKKbUF92A4SprcCta4vrqSPHQ7bmrx29+RaPDsvSfsyviFiGZYf8H3PIi7Re9EFly8q6gnm1inOznfF962PYEg/YuS2l26CsaF20EwwnqDtXvz5nyWiRE25EMxuvKlVtVzAyW9t29XmucArpX6PHrUd0INZWqmLEAVrBKO2CI5M+YwDNAVFuoOd5rlpIQ1AIViUmo9sbjc3AcDL3oPoVjkgLGrnrquKVnbFjryfez0ss5bwzpgfZkBuqEo8s3Y0mwgCtqRHBJiiaVtkkul7wiaWWs1Vpp7mk4Bzd6U3ovF1HNB+3X3Yi3qZaWjT3hxqXI3x7vIzO033tIRDkEYrGGVnEhLK692a+20LOz/VHbcOacHxP1v13f6xumxBzyK+qIYL9PfNLPfl59P5lo3JgPMkQ3m/0EiWebalaI19f0E9jWcSX8MAqntXRoHSRns9ngAJPiKsRkYddrmY70USg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(38100700002)(6506007)(478600001)(55016002)(76116006)(66946007)(53546011)(7696005)(9686003)(33656002)(2906002)(66446008)(66476007)(66556008)(64756008)(8936002)(5660300002)(71200400001)(91956017)(83380400001)(186003)(86362001)(110136005)(316002)(122000001)(38070700005)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CCenUJZoAvkL/RH5vVK6yDRPgLviFxxHZwPkUzeuWKQfw1Sis477AZAqIH+K?=
 =?us-ascii?Q?vuZC0pj8AYwdfUIqs6YezWRAknU+XDRO0osFd2lom8n1qG97BS962eJ3Q4v2?=
 =?us-ascii?Q?JEapX6maJKJL+3V/HxGJRW9KR5+zaM75BgBJ5wSLfPpq6XXshPbTEUMsworX?=
 =?us-ascii?Q?e8chr7wK7bt2p2ReV4KX3zbEDkwhJrAaxVxlWrRt9ftP7uqBR3JthfzZCOFC?=
 =?us-ascii?Q?stG4fCHcTjqIdcTbzQr1JTzO7P0i3/wNfi4lTOjlQrUziIyXSJ4YtIaI/8YS?=
 =?us-ascii?Q?cEkgB25HTg1Ujhzugg6+dwGP6CjhHR+MkGcbsTvBBrt+fwnjwqi59t3rTBGV?=
 =?us-ascii?Q?kL+xc1LxjdWQ0msc9IRFg2krGm6oVO3OKgPB/9ICN1MKbU5i5tGncp0qKV/F?=
 =?us-ascii?Q?fiWZTBC+H6pedVdSpFhbxUSIhzdIeKETr9lVLZstEl1kBMY+ZVKAliX3jsJL?=
 =?us-ascii?Q?58Wnc9LgZ73m3oMudAqG6mKEzOxECgm3oHNaYhvVc2IT9lcxLZgDNpT+F2h/?=
 =?us-ascii?Q?DzBbfMx8CzGV4YbvoNRieNVjs+z8CRdh5cQKQSmwe6Vocct/zgnQNVucFefA?=
 =?us-ascii?Q?eU5MEfGEZkNllAAIZDvJahnBRXnW5xvO5aKyvmoTlDLIU/e+OxmIinSfy6fd?=
 =?us-ascii?Q?CGSLo1blz1yYxfYx4V/OgnhYLGV+b/15AzGN1EjFCruRv8aXaQF1O7jWLoxQ?=
 =?us-ascii?Q?+/1STtiHUsi06DLtixxhvpUrzdM4H8bBw7wEvnqQQrz7+EdDqr9i6OEz6jaG?=
 =?us-ascii?Q?SWEBnCA/82CHE5VXdj702hSOvmjdE+Fa9Oa5ywOH0LNVlKQGnPAdALxbG+lz?=
 =?us-ascii?Q?qdZlwXGXCjxHP61mhozMfRb+r4bo5aTCGPbqs7/TdBnjRVAoJtjAecxX1ijj?=
 =?us-ascii?Q?uq79TEaGD1t4efO9xv747B8gFyH0bYYPOAq5m4+p0X0ruG1FVMfIvgRtdnqm?=
 =?us-ascii?Q?tJEHsXUf91QYG1A0XRODaDUmMyQQMhs65y+35WK/y9UvIvJIrfjtOCEIdT7T?=
 =?us-ascii?Q?IOvTjs6PHmLZJvsPNGnndA03WvkZ/i6AKmG/znECnsIo4fWoClerUFAluEXv?=
 =?us-ascii?Q?HPc57kOF2FhQ1JnLAhRITxH2tgVti4Uq4ps13h2oaK0JAOOLxwFt99q92A9E?=
 =?us-ascii?Q?CLXzBYIb2cIbg7kyIJ9QW/NFDYwdEeNKRTc2C7eGsUHaYQdTXiRPb5uU3eYu?=
 =?us-ascii?Q?PzTMpWCUzR9vQjEDl8igimJWk0lll7W02Jc6Tfw9RJVdyKgVUJ7YVzGNn5nA?=
 =?us-ascii?Q?JjB5ROepiKmMH8O51zbWDuiiKrq+We5vIrDsloefbj/I8g3uujzPZxHOF38t?=
 =?us-ascii?Q?WNbmlKjMSwQcxBs+50lhoAbFyO6hzIhrTSY9EHJYdxsMGkQbC8kAROYGNtxr?=
 =?us-ascii?Q?leG5bz8u43pfswcS4LZVtLU6bBEJvP0nuBZ6F27hKZoFAKpgJg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9b59b6-2d84-4166-29a6-08d96836360b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 02:07:09.2874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A1AU9/x+dYnmnd1HEbRpV7toMH3TiDc01m92O4Pwrrh/RgOIdPo+2FpBLV/NBqb84m9CjP31AJKn+YdgHQ641A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7084
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/12 16:50, Damien Le Moal wrote:=0A=
> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
> multiple commands in parallel. This capability is exposed to the host=0A=
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=0A=
> Each positioning range describes the contiguous set of LBAs that an=0A=
> actuator serves.=0A=
> =0A=
> This series adds support the scsi disk driver to retreive this=0A=
> information and advertize it to user space through sysfs. libata is also=
=0A=
> modified to handle ATA drives.=0A=
> =0A=
> The first patch adds the block layer plumbing to expose concurrent=0A=
> sector ranges of the device through sysfs as a sub-directory of the=0A=
> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
> related to this series).=0A=
> =0A=
> This series does not attempt in any way to optimize accesses to=0A=
> multi-actuator devices (e.g. block IO scheduler or filesystems). This=0A=
> initial support only exposes the actuators information to user space=0A=
> through sysfs.=0A=
=0A=
Jens,=0A=
=0A=
Re-ping ? Anything against this series ? Can we get it queued for 5.15 ?=0A=
=0A=
=0A=
=0A=
> =0A=
> Changes from v4:=0A=
> * Fixed kdoc comment function name mismatch for disk_register_cranges()=
=0A=
>   in patch 1=0A=
> =0A=
> Changes from v3:=0A=
> * Modified patch 1:=0A=
>   - Prefix functions that take a struct gendisk as argument with=0A=
>     "disk_". Modified patch 2 accordingly.=0A=
>   - Added a functional release operation for struct blk_cranges kobj to=
=0A=
>     ensure that this structure is freed only after all references to it=
=0A=
>     are released, including kobject_del() execution for all crange sysfs=
=0A=
>     entries.=0A=
> * Added patch 5 to separate the typo fix from the crange documentation=0A=
>   addition.=0A=
> * Added reviewed-by tags=0A=
> =0A=
> Changes from v2:=0A=
> * Update patch 1 to fix a compilation warning for a potential NULL=0A=
>   pointer dereference of the cr argument of blk_queue_set_cranges().=0A=
>   Warning reported by the kernel test robot <lkp@intel.com>).=0A=
> =0A=
> Changes from v1:=0A=
> * Moved libata-scsi hunk from patch 1 to patch 3 where it belongs=0A=
> * Fixed unintialized variable in patch 2=0A=
>   Reported-by: kernel test robot <lkp@intel.com>=0A=
>   Reported-by: Dan Carpenter <dan.carpenter@oracle.com=0A=
> * Changed patch 3 adding struct ata_cpr_log to contain both the number=0A=
>   of concurrent ranges and the array of concurrent ranges.=0A=
> * Added a note in the documentation (patch 4) about the unit used for=0A=
>   the concurrent ranges attributes.=0A=
> =0A=
> Damien Le Moal (5):=0A=
>   block: Add concurrent positioning ranges support=0A=
>   scsi: sd: add concurrent positioning ranges support=0A=
>   libata: support concurrent positioning ranges log=0A=
>   doc: document sysfs queue/cranges attributes=0A=
>   doc: Fix typo in request queue sysfs documentation=0A=
> =0A=
>  Documentation/block/queue-sysfs.rst |  30 ++-=0A=
>  block/Makefile                      |   2 +-=0A=
>  block/blk-cranges.c                 | 310 ++++++++++++++++++++++++++++=
=0A=
>  block/blk-sysfs.c                   |  26 ++-=0A=
>  block/blk.h                         |   4 +=0A=
>  drivers/ata/libata-core.c           |  52 +++++=0A=
>  drivers/ata/libata-scsi.c           |  48 ++++-=0A=
>  drivers/scsi/sd.c                   |  81 ++++++++=0A=
>  drivers/scsi/sd.h                   |   1 +=0A=
>  include/linux/ata.h                 |   1 +=0A=
>  include/linux/blkdev.h              |  29 +++=0A=
>  include/linux/libata.h              |  15 ++=0A=
>  12 files changed, 580 insertions(+), 19 deletions(-)=0A=
>  create mode 100644 block/blk-cranges.c=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
