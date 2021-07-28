Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10AAC4320A
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 22:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F54060F02
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jul 2021 22:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhG1W7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 18:59:37 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28485 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbhG1W7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 18:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627513174; x=1659049174;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=EdJNC1fpmDDznh9Jz1Hln1CMA6MM+PcXQvimyBt2Q7Y=;
  b=J0z0BNvuN8hXQQdH5fIjiux0TD1f2TJysksFY+Hsl+o0txZFWb8EI1HI
   Ak/F1l7SkAFj+X8LNyM4jBgFDvFpLBSphO/niUzDgIuo69TLP5nx2WfVT
   erl32TJ3/USEHG7JB1s3eBuLn1wE6ZYDOQne99z3rTXQeQC6WapMdXaHH
   MixZvl7boFAWkG9fvffywTkTn+bdZO2y03kEO4dvs9B7um9VD1F91Fb4X
   k6TrkGPzO0o5iNjeeSGcHg0zE0yIK5Nwp7/PQJS2+cgd1T5VQn3LyboVN
   VnmrKnedCR5rdSRki2cKuRvUlPJ0EVPdjg3BcQpIH10eI2UWkKJQqNZ/8
   w==;
X-IronPort-AV: E=Sophos;i="5.84,276,1620662400"; 
   d="scan'208";a="174948804"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2021 06:59:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrXnF/Uiay0XPe+708P/4zyWprxIEpEqKy5BwH8klDTmK879cPk6Z41qJI00dMN7FWOeJ1D1kpNjqSpPnkUM8fi/m0a8pugone4oLucs9hdBEwm+uyEq908uq4wV6MM3r34+CXHXyYwJ5ynd+9FE4JMMHpE0IdXC5OctvMo/a3q/o5FQclSgP07VRno+hXEw3x5Y2Z4xntQKPTjwFMc00lw1Kh1g8DZGDqUGgKSJ234r1pspCN/EBf+KwV0flRHwwtqy8KTMLHWC3AqAFJy84HTFVmO8ZyetlHsrUjazcMFM8s1Oois7bN/kfOuPzXtFuAHxDlkuT+I4HzEvxQI+5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dqbJjoV2auh+urWExxJSPvhsmz0ZCd3/ohQh1rxwAQ=;
 b=RKGUsG3xgwaHcDrsrnuR6o4ddybrEiCzAkTT2y0i2Yf8Zw29dCZu9Afladg0hw/RnGixboHDQToMe3dqVB9h3usFsOI1jp6y5nNFlHsBz5RpE5uBD8LomV926/Hx4w5PcleizSuTL1WkicGWvQg7maEUG803OtJtMdkAV1gG5iWfEag+0vg9T1tdnYHrNcLqQ+d/Wu32+yMghId3QCiyjkG3g46DHRS0MKbMPV6cisyCc6ErKSseWcShC50NUWYwsGlcmqumit3bPh0T2lm4Hu/3vmpwal1BGuPZ2E2lXYf9TJCDJJBYIW4JYrYvR3EwHTolo+vErfJqvmtrBdFaCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dqbJjoV2auh+urWExxJSPvhsmz0ZCd3/ohQh1rxwAQ=;
 b=mwMWE8pRFS4GMAvViQtnjxTOk2lql6W+Ty9m7t+OroI6O+bY/RMhwe6jgoYa39DjDPE3rbYGvv9+keWheaWvpIqRjjg7cJCKejT+Y3VNXHSVFZLyoD/zAkBXdrl+bIuebWUNCVSZuDKNhmWzSQETaJswOrJ1+7+Z/yf2oBab3vQ=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6859.namprd04.prod.outlook.com (2603:10b6:5:244::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 22:59:31 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%9]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 22:59:31 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
CC:     Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v3 0/4] Initial support for multi-actuator HDDs
Thread-Index: AQHXgb7nBT0SP/zb8kqWuIxTGXvQIg==
Date:   Wed, 28 Jul 2021 22:59:31 +0000
Message-ID: <DM6PR04MB7081C28B557F73A43B2D3E3AE7EA9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: faa0974e-0a97-49a3-f183-08d9521b5c79
x-ms-traffictypediagnostic: DM6PR04MB6859:
x-microsoft-antispam-prvs: <DM6PR04MB685940EA93F7E8962B9F45ABE7EA9@DM6PR04MB6859.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jxj0dqcEhy5KJ8LTy4xj6rlldrie0ZnoeMfukv7OVfvknkpx7kF8y6Y7lX6E1axmvTKwAi5+iciTT1qYH5grQPnFfVGui48ZqJ2P5YJAvYIbKNZgsffPVYEW9eE48PkLj47aVr4dmxk+lxO9BTLgG2e3MrSECR0yoB9VgmndX1pOMppK6zHzUNe4u6itAzEc1U/iSgV8SyCkh542fpIrxND9o0EyRbb5z7t324HinpNVW2UKDUyEnM5jX8XyEux8Gz83xVXwCgoYWfKad1PG2RsOYINVD0S/RLuym1E9fVuavFEwWndyxyevRA/IkwDX9BCQ/bA3iIv//JdcmdRqmuirxuTSV1d2rnf33C8wRRixJNNCy2Wzgd540TOlniG+FXdquEKGbJXsvHjmHMWe83k4bbUKYc7yYZK9NkqpPp2rhQ06TcB6hpwnROtlBss3i9EL/mM+ZRhyv6ofM7xaGGqWehP34C+o86dUlp82k3cgeUsIHmeg9JMVQCdu69iJ7eod70W3vQI9oKsIKN6pxSwyIavtb/1yxjY4S5o2aGr2n4Mik+i5OujXnACyZgKhuk/8/pneDSATqyrgDXA/Otx3n4ewUv+Mkmdn+3atHXrUOWkEFrQjBPDCinYKt8znwBL684SlWMp8ybcVkyUNlbezf2JOo+1GIWZEQGSThJ6S5rjpXF9S3ocOegDtOjzfby82s99i7L6NhY86OtYo3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(4326008)(55016002)(122000001)(8676002)(478600001)(38100700002)(2906002)(52536014)(91956017)(66946007)(64756008)(66556008)(8936002)(66446008)(76116006)(66476007)(5660300002)(9686003)(110136005)(53546011)(6506007)(71200400001)(38070700005)(186003)(7696005)(83380400001)(33656002)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZWvX6MeDWSi8A7OSd7iwA24CG1gv9RNvW87pj428omNBH3baxh6otuFAVTSB?=
 =?us-ascii?Q?0CNVcrfjEd5op99mt5e3inmxZH+m25WMRXCTnNF5tubai5DmGYF6Nuv4QFqC?=
 =?us-ascii?Q?8tQZ1MMkuYV8Op/YPjJpL1FlFUK23ZOTF9tYgeUcqq0sba4em6dPDEU6C0hF?=
 =?us-ascii?Q?J0kjAe5PS1Gv3aJKEJ8OXNpfwAtrCj5gVw/MigqfGKapajVL07koSrgkrcMl?=
 =?us-ascii?Q?5iUEA3/N4KTJ42o+p6kwnx1LHlfYxZat1ye0WsV67h73fwcfh6u65TSSvriq?=
 =?us-ascii?Q?l7LSCIvYHAIzvTPY2NQdpggm5ENeLUaKSUHm9++HgT00rY0aLwFdTxBq2auv?=
 =?us-ascii?Q?Zk9hUDX6oC2hqTZYoIoRdLj4l0Cv/Mfyx366S8ZKyyrO2mehe0BJjuS2bF3d?=
 =?us-ascii?Q?6c9bzyodv/W0ehyXMGDR9JuMp7T72rZ/hYLUNcUEJwwiEGsKPeRSEQgXYvb8?=
 =?us-ascii?Q?8Ga/Is2w8oRqECmak/OO8u/iG0Xw5YNtClARpkAOR7Gzut5FT69N9tlfqJPp?=
 =?us-ascii?Q?xGvw32sMuLXoHOs2zKFgoOXTC51VjSw3oE0y9wYM1569gB4VDruoF/BDmKgF?=
 =?us-ascii?Q?u6NJUa3VPgTSbhX+nwwKWeeq2CKIyVjsIddg5oJ3/6J+WMundt37Afbs1maN?=
 =?us-ascii?Q?tOz33XLW2imnTCPVsFKAKxhL+L5IDkpsI+2s1DXvefQkb1u5guKfwO0WUqwp?=
 =?us-ascii?Q?U/oN46GuWhOlsUpi7zBedfj4jCK46VtosyNo+dZ1bSIz0UcmXXM56g9IQ++k?=
 =?us-ascii?Q?dkpMvtbc+kdwk7wSD0b0ME5LpdyQ9eUWlbVM8bxTMjR1nFAj+qiuB9cRAEfr?=
 =?us-ascii?Q?c7hQWenvoXfL3gnVaUBkybYSGTktnRHNusjX4zbxbJLojUndu7ht0z66kIQQ?=
 =?us-ascii?Q?aBkAKkWJhjH5ylbI2GElQo3P5FjzwcS57asIM7GVcWzMfAmqqxN+2IGcdIE5?=
 =?us-ascii?Q?PvcTpDLPf4Tu5WNSEIgNFfV3+ECyrPDgsmXm+8unvrfY93hG00Vx0Qh5vXJ/?=
 =?us-ascii?Q?noZ35uk0906HeA+XWW4HLC4XVnTOv71YgFFY8T/mykmepOt7oL58Qdz3JWg/?=
 =?us-ascii?Q?Z7cTIZd3v7xtqtCKTYQHpR35ZZgMVJE3cGkVIl4bpAdEu1S2BKOCixCE9L4O?=
 =?us-ascii?Q?ipxP78Es4TK3sI/J/O5Rg0ufbwyo9GIq2RWYdeXIQp0NAJ1ZlWoyNuti6BhE?=
 =?us-ascii?Q?MMhm7UQ126kI//gdb97zXDDx+raxMs/oZFXrbgoudZEKha6xK1/4VuFNqN8o?=
 =?us-ascii?Q?jf2C+Ep+1JbHCkVsmLt0Jl7kRSf0zHGY/Tbrm3hR+8C6wLS+Gqp04Npn+Ixm?=
 =?us-ascii?Q?5uW/VytAZoL+gM75lY41G3dGPkd6jQPpFCOqUq636lz5pOa/iC32xYsso5XH?=
 =?us-ascii?Q?FF839cwjGwQPzMuMv2LUN/A4d4IhOe5YdcdpRPIZu8+UouwudQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa0974e-0a97-49a3-f183-08d9521b5c79
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2021 22:59:31.6923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Jge4VI8n8mAPbcHl5lI2Vg/X0m7X9t1Ltqh8y4pBrDHNFOoSk+N36JgyU9HgF+vCuDnosc9/D99FN3WvrVRUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6859
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/26 10:38, Damien Le Moal wrote:=0A=
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
> =0A=
> This series does not attempt in any way to optimize accesses to=0A=
> multi-actuator devices (e.g. block IO scheduler or filesystems). This=0A=
> initial support only exposes the actuators information to user space=0A=
> through sysfs.=0A=
=0A=
Jens, Martin,=0A=
=0A=
Any comment on this series ?=0A=
=0A=
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
> Damien Le Moal (4):=0A=
>   block: Add concurrent positioning ranges support=0A=
>   scsi: sd: add concurrent positioning ranges support=0A=
>   libata: support concurrent positioning ranges log=0A=
>   doc: document sysfs queue/cranges attributes=0A=
> =0A=
>  Documentation/block/queue-sysfs.rst |  30 ++-=0A=
>  block/Makefile                      |   2 +-=0A=
>  block/blk-cranges.c                 | 295 ++++++++++++++++++++++++++++=
=0A=
>  block/blk-sysfs.c                   |  13 ++=0A=
>  block/blk.h                         |   3 +=0A=
>  drivers/ata/libata-core.c           |  52 +++++=0A=
>  drivers/ata/libata-scsi.c           |  48 ++++-=0A=
>  drivers/scsi/sd.c                   |  81 ++++++++=0A=
>  drivers/scsi/sd.h                   |   1 +=0A=
>  include/linux/ata.h                 |   1 +=0A=
>  include/linux/blkdev.h              |  29 +++=0A=
>  include/linux/libata.h              |  15 ++=0A=
>  12 files changed, 559 insertions(+), 11 deletions(-)=0A=
>  create mode 100644 block/blk-cranges.c=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
