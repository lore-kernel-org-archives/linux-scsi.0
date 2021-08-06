Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD88EC4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 02:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 919E161186
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 02:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbhHFCMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 22:12:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33722 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbhHFCM3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 22:12:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628215934; x=1659751934;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=RqzOkI5ttvdRoYiqijsbefZvlSlJQIXX6ugj6QSR6zY=;
  b=hNBCSmwdyr+RDa8V+8L7zyhXhE+Nzm6DVlTN7Kk6tM/AakzBPKhCtETv
   fFMGW1g6Asoiv/zVcp2EjkbgLTg00WpcYu8mEpTTNmwIZoNGVx2lVDyvz
   jvLsjSk0LI8hmSgEF/5M9DhvtJ4bBeTZv/ufe+30ttZr0QwvbHJcm4Itt
   5TBebne51ilYlqxZ4zSDIjylI1B2fHOse8pU3r3jjef28eZxL0OVp/9Jp
   N4vKqcWArb6fP4PpV9FwN3M56w8Na2lly1bnOqEZdKrsHJX2zm34130t9
   bbwU4x1+2r+JjhM7rkEG7M44MRdXjHd7qa7mEEwtVjNWVFDUgrcRg7nGw
   A==;
X-IronPort-AV: E=Sophos;i="5.84,299,1620662400"; 
   d="scan'208";a="288024619"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 10:12:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTGjAB1XoMapTwSQRsSsUrN9B+3GIthk0VN8ZQ8iBvw5ZlKLK0nL04SzQwezo3Q2vhZB19xd741z3g53CuVXmtN/8zdaiLafSTSQLzM0j/2087fn81ubszc/FU8r7Yspa2zVTo4RWCr+ea42O3l0aUByygyUkqodx0oPGqr0rxAMGjMpG1beTtMZUsFppHl7JXq8OPvRoEUBj6peWDaCJAoBTviz9ROZZgfMVf6Y5OBLh257rCK1ARvbm7KSdwj9zOzAordh4uNvnngRV8BytRMiXanIcES29tfnoJLtxW7VUWGNnawA4MmP+M+0//jvf2wzd1WP7mg0eaMvTaAL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjjEOzKrNBPPpt+RNH0VEAuvWmi19LTVVNLeB+od4Ro=;
 b=Xf2sJqPfusIxbffhwubq48ZaGobjAzYPuu8Np+AqAw/4N5BlfH4ANsTp2ECJikP6KL++7lIAM2Te7ZJmqABMchwslbgBIq1xJsNm2rLfNwlagX2RkR45H5XgMB901+WSxCOcem7OtovI8XAGzckyUMqklhiVMK0kjNbZPe6DU6eCiTcJmfKW/yXk6x3kUVMsZd1K1Tdp2C1yy/Qe1K/UcqhmhSFGO9Qnu461IqCf1Dw24rXPMm7lnKm7tqK9mVnM2ACT5+JRY62OrUIYu+Uq2cEHzKfvkpIuvsO5Z9xwMdoF9QTx4eMZhC2C7WKdoq57JEUhoqsIPFQ7enLzFd9ZjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjjEOzKrNBPPpt+RNH0VEAuvWmi19LTVVNLeB+od4Ro=;
 b=oqKdRPp5DK+Ll+7kVKKcdTY1tBM6Qzja1Wens1ZFYMQujuoVtN2J+y4hQ5Q5OEH7R85rrBgliwes+ZgvCbQ0/1q+ePFyerdzxEmqhBBKBF2BKqbmac0t039Bcw+UyjcojHGJVbfmHO9jeVNJNVX/oBWO7JlHT4Mc97QaYNDBYxw=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0668.namprd04.prod.outlook.com (2603:10b6:3:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 02:12:04 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 02:12:04 +0000
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
Date:   Fri, 6 Aug 2021 02:12:04 +0000
Message-ID: <DM6PR04MB70810037B2C180490FD0C623E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1bb9c59-3200-4bc6-fd63-08d9587f9588
x-ms-traffictypediagnostic: DM5PR04MB0668:
x-microsoft-antispam-prvs: <DM5PR04MB0668F45CEA1C550377DEE019E7F39@DM5PR04MB0668.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mOEr+oS/VGxZks3y5zhFmn6F+JSVttv7fh0zfnUvUXiQY+WH12lo+EWw0JNRopgX9e66I4rGtNEORblW06VUwaLynTrXfmUMARPTMwNq9ix0K7EindSO1R3o/ZP6JvcxWlR8EGU6dlbMQCQlKP0OxYJt074C2m9Kwgg+acF08AeS5+JgWc6GRq2Sxyn/pQ38KvuzV1ab/CS5spUpk5MByT23BgSuxUPVVRGGXtPWM711DwrFH2hi1m+6aaqvx8qvu0wkzO5GVHxjj+H4MOn1JduEoKeAB2BHs5A6KV69nMoxFVmugLnhK5HwgNCnhs6j3ymdenfz/zTbNRrp8lAgJrjWvQg6XL7rOeGmXxZjCjmxLPf5rogDMHKiWe5rH2oXFdKeS/RwCVYByKZ5t5T8yj1HqU4YmdV9qV5gdyPpk1IXxcEdmCK3g27GMToeqUuOQdLnTDwHD+eB4SCsR0IykNGaIOBooL0ZzjcTrk3SHIiO5f6xYsHG9PCY2OhSCnTTsq09Cs4mesfoArfl2SRDn70/x0h/f+GbGbLp9yamcJxnF+vHa9W48Tj7pxyeZGaHGlZx0bOZ2GXxcBsa/1o7P+U0oYKrziTfgznL1CwI9HdOIyAJvwA8Mvrx7cunLtNxA4BmiEzgAFCSIU8yfPvCe694EUK7dr1gXT0eEC8hABKgcHtSy1VDwqs+kd2+zcGwGzgYYYI/p6Mj9XRl55sk9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(136003)(39860400002)(55016002)(8936002)(4326008)(71200400001)(110136005)(33656002)(38100700002)(91956017)(8676002)(53546011)(52536014)(76116006)(7696005)(122000001)(64756008)(6506007)(38070700005)(478600001)(5660300002)(66556008)(66476007)(83380400001)(66946007)(2906002)(316002)(66446008)(9686003)(186003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LgfqxLVve/35wOVkfpDd6Bgf9VF0cIPcoi3cbNqmaf186zjzWe1ZMGOE+RLm?=
 =?us-ascii?Q?Ds19NMsAtpEHiqsHseXwfamVOSqWiUs+SK7nGS7S0xm+zmcAWq7HkJiGsVAo?=
 =?us-ascii?Q?tg1PR33ERd5xD8PfJMymGM5wp30roLqMHCCbq2malgZQV6Q5EHQlIHeaL+Rw?=
 =?us-ascii?Q?RADmdKq5MWACyYpJ+5a0W2zkewIb07yK4f1b+i9wG2F1VBrEcpRlGaMSw1Kc?=
 =?us-ascii?Q?AWFnRL42u7jacWwbqGcKytMhI1Pb2Ec20IJ1EAlfgINjeFm1HbopbQEi9E0C?=
 =?us-ascii?Q?sEOBGQX8gcyDrjRkmCQLsZQ0tsNrt04zOeSleXCE1mG/akx/TKe4P9FpbZbk?=
 =?us-ascii?Q?i0/AqqCiBUeJHoMVIR+ipe07XN7yjrlNly3vwXFDsSg42Jmzdyw2C2r1dAsU?=
 =?us-ascii?Q?i1Ce8AcongMvfHuN4fQeqT2gS65oSZ0tjPgZnlwegnhSWxqx1mM9Y+5MhnMr?=
 =?us-ascii?Q?sTXIiE/rNFeobR9jfZUDEtt9X4gtYy5tj6qH37K25kbjieXI/J9/CNXjQfXY?=
 =?us-ascii?Q?duxb+F0FzOJsYeehZn7jiPMmCcnPrOEMB/vDcH7is60K7Y8j9CNnVW0wVfgu?=
 =?us-ascii?Q?/9yiKEd3Q2yw2pobRgHXN2LxDXRxpa34Rh8/R2w+j3DKMMAuGlCC8trOcjOu?=
 =?us-ascii?Q?eJXN7F9TVhtVl4V1JRosa1TEo851b1u3yEOtb3UkziHPwUNZv8GJvPw8xQ4q?=
 =?us-ascii?Q?uEb/sN4ay8ckOeYMnTy4W44iuWlfVUv5KFhRSTIPRT9blJXIwOyx227oufF4?=
 =?us-ascii?Q?I7hZYXJDZmoGxQONe8QQBegHefFcR3ebr6KnhceRsXhZ0AldMVjjoNoo3HS2?=
 =?us-ascii?Q?BEu/hnkqrNGqSllcgl1KdWJaGa7NvALDxzvb92K3NKAaYywvhZvdjQfXCXeS?=
 =?us-ascii?Q?XTl0ksQswQawqLD5gGnjANX96aSexpiCUh0PuBxzsIQw08AAUsP+MUGxdwcu?=
 =?us-ascii?Q?ED6eaz+bytLNKWIlxwVnqtt+4Kh8MqgMXHzliZVlq8dbattgmid7ekkmrkLa?=
 =?us-ascii?Q?AsBOSQZzsxuHPo0eP1LGSD0bboxkHoq8zlP+AVXLZ/AZhxFq9LfcOwPcJk3O?=
 =?us-ascii?Q?pCusWTupE8Nwt1/IHvbBvq+w0w71vZZlDRGjZN2fByNePhaKtvEfT+pm0Sd4?=
 =?us-ascii?Q?chqBSbcPU+UgPQVZVfMJ2xH8Eq1kKgztvIq1LNSfuJR+OC87H1WLwhAi5CY0?=
 =?us-ascii?Q?C8QiTLVq80AsNibKk8TDKZ5M774Ho6gb0KhU5oG0zIDkR1fegv0cwAKGcW/Z?=
 =?us-ascii?Q?2oSJh8vqfhrAflnGzDtuR/2Crb2OnmpOXZ2xpy0UvDMqb2K3n2CEAfjInwuL?=
 =?us-ascii?Q?8JnTSyW9PcMIWk8xcucKNR3YTHiLwzSreE7RtaX4MyHo4ZPX3BijWBp8XPCG?=
 =?us-ascii?Q?WjI+s0izwEXzk/W31DVUXw0uyd1ougHDnqIVZDEF09ZLwNG6EA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bb9c59-3200-4bc6-fd63-08d9587f9588
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 02:12:04.1046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P4aBkCS4kJ7bdZgtHif6Y7kOYdKUiju0jSYg24w9DllLvOI/gTednE42dIizx5xkie6DkM81/vmzhu8XYoqN7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0668
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
re-ping... Any comment on this series ?=0A=
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
