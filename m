Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9906C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 08:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2EF860F51
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 08:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhGZHuA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 03:50:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:37500 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbhGZHt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 03:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627288227; x=1658824227;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zu+83RGKDYHmcZZYc5OukiX1wmNYLEU8btk1lIqI1Js=;
  b=rTQreTjQACjzALHRN7Glo/LP8PHte6V2p/mCuBj42vaWcbLBmiNb9BIO
   mIjnd0AFixFgIeE9IYpNvSbiOu78PXqtjna91YMYVRpjeZrvHVDR41Jtb
   3gfNPwA0/stqyrs6QurDs9IPqElEM4xiosllj2j0gummJaxZJngQs/6gF
   NgtB8tKIpfyCHzmkWsTg1fzu3hKX5YbOB2+H5wypoiPHdM5bxhBoQa2o+
   +k9WWGfEcORPm4B/19O3m5HLaDc1jj1KwAR4NpjlKe5e8G5uOYZfiUmg9
   fN5tO6HmuJxQBsNARvMcwVc9JP1Zx3x7tGcAWF8jVmKWEZXDT3NWf593y
   A==;
X-IronPort-AV: E=Sophos;i="5.84,270,1620662400"; 
   d="scan'208";a="287044273"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2021 16:30:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aB/+RR7zgc1zKdBVggFbh9N0c6aK3qXF3GZl8qRhm53PSnsXWXUZhOFokOpq7iRWOTbwb7XrIoJJattPeZVvK4Jxl3UGLvHNrA5U0VRE9AZWilNh1plZ8Bg44TBBVzeP17SNZjUJOVK7djBqQK5Fv+pO8WQc/LqnbS3/EzGcFJqNLDoAzDfmmKu7ckCQCtiB/FJ/Azfi7tXX4paYvzqfnzqdjEllXrXtO/++ENY3ye7Km6j4okLF+5gMwfkZugHSghHdacrQMTg6ydnAnti7YslS1PdcInqbvYX5fSCA5TZiUmE2+qe05eQ0HkpTGkj1zXmTgTou5CASLsVsILc4CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2lkIQus8EGnQBpz3eL6tt4gmHyNeixZpeMtv4/GJLs=;
 b=mP3x7W6U3d7B626cpakaXevzIJm3BGdc2eOq3hlMV+pIy2qHCMY2LzS1cggAjkLPxgYIBCi/B4XieAn1R0PemMu3IshCIQT0OG2WYDPsz4acN4zAxwS2hqLcE0WUxlX4jNHKtBoa0VtGZ8Qz0ViIezGsKegm3m0VyerV0ymAPbCsCB1zz3Ou17lUfC4JK6rN11O4qJi2+X6/tvpS/6ODknGEqVALFGNZXbO14eIAUILGHiHYIoqYLupMW3fRzRy+r3It5/aZk53rFVjZsmq2zgDR/dwK0pj77nY0NTg0ByfDC8nMXgHC19z7CsAC8CKcl3hq0R9pdEcNC/RCGVJFLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2lkIQus8EGnQBpz3eL6tt4gmHyNeixZpeMtv4/GJLs=;
 b=MKNg09W4QAq02R3pPJFwQzcd/DjQ/5OSjSGgq0I4QW6GKH/sxLe887GO3EwF5zyewigZ0eMLHQ7dayBkp96gbJmFtjhhf19vR+I7HOOyUVZYeqkva6j9Tzj4NvxRF5Y+ziGCx0dzEFCGeacNOa0hW5JuyLnD+Gjnr08Jsq4Z64Q=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4474.namprd04.prod.outlook.com (2603:10b6:5:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Mon, 26 Jul
 2021 08:30:25 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%8]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 08:30:25 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Topic: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Index: AQHXgb7rfkYo5fvxW0aRSzaXyXSWfA==
Date:   Mon, 26 Jul 2021 08:30:25 +0000
Message-ID: <DM6PR04MB7081141B64D9501BDA876433E7E89@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <751621a5-a35b-c799-439c-8982433a6be5@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daee2a00-3142-4b39-8cb4-08d9500f9e03
x-ms-traffictypediagnostic: DM6PR04MB4474:
x-microsoft-antispam-prvs: <DM6PR04MB4474801666D75F7B62AAB109E7E89@DM6PR04MB4474.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIPTsbDIOPJXNkRTyfg3wRzYF3/G4FaOXIzCnkVgoyfh8YT9MZ25Dht+YYHSi+ELs80kbFzIKjPOaD87XYXxhJAjB/QlWO/HmVZIO0Pss9VXmBHSAtDPMskRpGVBY6j7sUf/ZV8LWVxKsWLMONXFNoi+LeG/IZc8NQBaCbz3HEzDwoyJQrYGBSzCZMCy1so+bSRvmNQ6UWuRM6JXiOYyoijBOFrD1gIXEK2g6eV5InBf5RnCPKem922CRDXmAysE2jr0k2uyqLI1ucK3+c4I+brvsQEh6eXauq1ZbzCKVoYAyUnaFXj+i0WpC4ifDLOVSvBbLdwVsYGHPK2PSzdOaYVyMP2ysdct0acnX2DJN0jY6vAIh6uEYnlxcz8HmPfnO/z4rC8+gEyjmw/ssHoleWOjvUgtuSAH02wcJHpNGgeweAoGA4KlzVaGZwbmJ8BiX0BULabQTuTmTEC/wUbV/66W/J0COpD23i0vhjIU1AN3c2JWR6+MEH1ADsoXeewyyfdtva8kpiGf0gZcfLC/eJxnWlVNIL4pzguw4mcRLXb0+tcHilUb2dnbojnuhDuU7c5yZ7BSRzlM8Vg4M57UJ/MmhOAA4wVl1zBh5t99uYLuIXDarMtnJFalueXQ679avieB8aDEUhzoxRqDHNxMNbXbLYPJiSKxc2dqS+YWXhS1F7CAxUWXop1fmqj+t+NDUKDtPlI/ZrlNGASozu8vRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(55016002)(8676002)(26005)(6506007)(33656002)(66946007)(478600001)(76116006)(38100700002)(5660300002)(71200400001)(66476007)(91956017)(64756008)(8936002)(186003)(52536014)(122000001)(86362001)(2906002)(66446008)(66556008)(9686003)(316002)(83380400001)(110136005)(30864003)(53546011)(7696005)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+phPRoDeXCqClnsHMbAecc0paThBqPx7id8IggTdtRqU8oqWjXnM6K97mgha?=
 =?us-ascii?Q?dKLbTSWg72wnlscsiQPZ7tJ5aDRnAiU5ltW6SSBfM/oK56pAhVF6e3oB57m7?=
 =?us-ascii?Q?eDXLfgEEkCvUa1pSFfNecGGn/ORLYWqs07E24rgd07P3oj9f7Wc65NR/boTn?=
 =?us-ascii?Q?vGjvfItcNTcZG6OUHupleBc5nitOJqC8SaMzMwyCCzHKtbTDgTUz1L34IFmY?=
 =?us-ascii?Q?oraZ02vA1GySE26UdtPLNq0S06F6FB4kgq40vccrmO6+tEJgtlP60SOor4ri?=
 =?us-ascii?Q?UMyv2uU8bXBePyAR/L4Ii4jwLKNoEyXqRaZXiY3Dz3Z2K9HQXrYQILE8EHYH?=
 =?us-ascii?Q?5kKV3tloeuS5x4NISVtE2GQZicz59h5IRVt+5GkOdkKQ37PcK/RTd96+UVy3?=
 =?us-ascii?Q?nNXoigm9xVLbV6DmNX588YTU1qptOmChu/bkN6HdAt/7AGrIjy3oRwmaMl0X?=
 =?us-ascii?Q?V0seH8DHuBdU2du5wF9T/HN21Uf+c8cswu7ouHFYmfP226QRilSSks+C+G3P?=
 =?us-ascii?Q?NUArVcNjcFswTWUytG4VB+cRUShPn0pcUImHehOABZAQGsl8ek+ZDuhlOnqD?=
 =?us-ascii?Q?0SdeYamFIzCwGfzUQbUhM3PfYGOhwT4rTGupzegl7mq0x4qhgEhZa13R1f8y?=
 =?us-ascii?Q?mVAaV3F0vg47TxpZY6S3rJzgSEJoqt5DF5VNNX4gYlSWgOikOlAGPOTQeS1j?=
 =?us-ascii?Q?oNjadJ0NCFR9tBAq07KvE/qwZDPRlIei2Rrs5udzba/L37aZNIet/+unYiWn?=
 =?us-ascii?Q?mH+HaJwxlshhYjpnaZdIOvVgLv3PN7ocAcNZb+5lxfNmwQEwTjEiv8eod+xg?=
 =?us-ascii?Q?9HbDsXKZ6mwrDp1/NQVBiTw2xGKi0HXz50BGmhu5v46bw/PkQzgpHoh9Cno8?=
 =?us-ascii?Q?bOv0KIjS+DgQ6KGmFYsXKBlZSxSpkx44YWr2/Fas8HhOmN2RN4nuCgKZH/6T?=
 =?us-ascii?Q?HHGcKqWKj0c08XLAja7qRtwxbbzWTuPCJsXJFLoukeLMKuWV9mibSI71oNOg?=
 =?us-ascii?Q?79Z4CZvbdrKUj8o1XqfJ9ySdxv21CN82VpodxU1GBfRfqJ+43BCHGWFXB0t3?=
 =?us-ascii?Q?fzmAmFm4i6HZlbDzRIuG4ZDb1plV7EMgFZw1QQ37HrjKvRXpXW3bacG54Buv?=
 =?us-ascii?Q?qLVQdMPVqlso9Y08s4+PInJv4mXufNcXn45JLl3724w2QJlIXPLHiRyA0j3S?=
 =?us-ascii?Q?x/rO5oCIldCrH1ZNfwbd0fGzvndxfdC2fFKgbzB2e3XfV/FwaSV0K1lu2vIR?=
 =?us-ascii?Q?PjVHQYfns65x44iCO0DNlJUZOTXwLz7iWmDw55eCtNLjVAKuJxe5FZJ/nkJ0?=
 =?us-ascii?Q?xlGajhW/qN84/XpeeOA1Dx6EjNCQpTmI5Ia7L2grEom6qQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daee2a00-3142-4b39-8cb4-08d9500f9e03
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2021 08:30:25.5041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zVkTLUqHusQ+ZNro1nUP8MJOQg7Dz2Z92Qaj8k4M4MqXcAAB0FMiFH6X1Ys0Rjxe+sBhG0sBwnojpx7kJvpwBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4474
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/26 16:34, Hannes Reinecke wrote:=0A=
> On 7/26/21 3:38 AM, Damien Le Moal wrote:=0A=
>> The Concurrent Positioning Ranges VPD page (for SCSI) and Log (for ATA)=
=0A=
>> contain parameters describing the number of sets of contiguous LBAs that=
=0A=
>> can be served independently by a single LUN multi-actuator disk. This=0A=
>> patch provides the blk_queue_set_cranges() function allowing a device=0A=
>> driver to signal to the block layer that a disk has multiple actuators,=
=0A=
>> each one serving a contiguous range of sectors. To describe the set=0A=
>> of sector ranges representing the different actuators of a device, the=
=0A=
>> data type struct blk_cranges is introduced.=0A=
>>=0A=
>> For a device with multiple actuators, a struct blk_cranges is attached=
=0A=
>> to the device request queue by the blk_queue_set_cranges() function. The=
=0A=
>> function blk_alloc_cranges() is provided for drivers to allocate this=0A=
>> structure.=0A=
>>=0A=
>> The blk_cranges structure contains kobjects (struct kobject) to register=
=0A=
>> with sysfs the set of sector ranges defined by a device. On initial=0A=
>> device scan, this registration is done from blk_register_queue() using=
=0A=
>> the block layer internal function blk_register_cranges(). If a driver=0A=
>> calls blk_queue_set_cranges() for a registered queue, e.g. when a device=
=0A=
>> is revalidated, blk_queue_set_cranges() will execute=0A=
>> blk_register_cranges() to update the queue sysfs attribute files.=0A=
>>=0A=
>> The sysfs file structure created starts from the cranges sub-directory=
=0A=
>> and contains the start sector and number of sectors served by an=0A=
>> actuator, with the information for each actuator grouped in one=0A=
>> directory per actuator. E.g. for a dual actuator drive, we have:=0A=
>>=0A=
>> $ tree /sys/block/sdk/queue/cranges/=0A=
>> /sys/block/sdk/queue/cranges/=0A=
>> |-- 0=0A=
>> |   |-- nr_sectors=0A=
>> |   `-- sector=0A=
>> `-- 1=0A=
>>      |-- nr_sectors=0A=
>>      `-- sector=0A=
>>=0A=
>> For a regular single actuator device, the cranges directory does not=0A=
>> exist.=0A=
>>=0A=
>> Device revalidation may lead to changes to this structure and to the=0A=
>> attribute values. When manipulated, the queue sysfs_lock and=0A=
>> sysfs_dir_lock are held for atomicity, similarly to how the blk-mq and=
=0A=
>> elevator sysfs queue sub-directories are protected.=0A=
>>=0A=
>> The code related to the management of cranges is added in the new=0A=
>> file block/blk-cranges.c.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>   block/Makefile         |   2 +-=0A=
>>   block/blk-cranges.c    | 295 +++++++++++++++++++++++++++++++++++++++++=
=0A=
>>   block/blk-sysfs.c      |  13 ++=0A=
>>   block/blk.h            |   3 +=0A=
>>   include/linux/blkdev.h |  29 ++++=0A=
>>   5 files changed, 341 insertions(+), 1 deletion(-)=0A=
>>   create mode 100644 block/blk-cranges.c=0A=
>>=0A=
>> diff --git a/block/Makefile b/block/Makefile=0A=
>> index bfbe4e13ca1e..e477e6ca9ea6 100644=0A=
>> --- a/block/Makefile=0A=
>> +++ b/block/Makefile=0A=
>> @@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) :=3D bio.o elevator.o blk-core.o blk=
-sysfs.o \=0A=
>>   			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \=0A=
>>   			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \=0A=
>>   			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \=0A=
>> -			disk-events.o=0A=
>> +			disk-events.o blk-cranges.o=0A=
>>   =0A=
>>   obj-$(CONFIG_BOUNCE)		+=3D bounce.o=0A=
>>   obj-$(CONFIG_BLK_SCSI_REQUEST)	+=3D scsi_ioctl.o=0A=
>> diff --git a/block/blk-cranges.c b/block/blk-cranges.c=0A=
>> new file mode 100644=0A=
>> index 000000000000..deaa09e564f7=0A=
>> --- /dev/null=0A=
>> +++ b/block/blk-cranges.c=0A=
>> @@ -0,0 +1,295 @@=0A=
>> +// SPDX-License-Identifier: GPL-2.0=0A=
>> +/*=0A=
>> + *  Block device concurrent positioning ranges.=0A=
>> + *=0A=
>> + *  Copyright (C) 2021 Western Digital Corporation or its Affiliates.=
=0A=
>> + */=0A=
>> +#include <linux/kernel.h>=0A=
>> +#include <linux/blkdev.h>=0A=
>> +#include <linux/slab.h>=0A=
>> +#include <linux/init.h>=0A=
>> +=0A=
>> +#include "blk.h"=0A=
>> +=0A=
>> +static ssize_t blk_crange_sector_show(struct blk_crange *cr, char *page=
)=0A=
>> +{=0A=
>> +	return sprintf(page, "%llu\n", cr->sector);=0A=
>> +}=0A=
>> +=0A=
>> +static ssize_t blk_crange_nr_sectors_show(struct blk_crange *cr, char *=
page)=0A=
>> +{=0A=
>> +	return sprintf(page, "%llu\n", cr->nr_sectors);=0A=
>> +}=0A=
>> +=0A=
>> +struct blk_crange_sysfs_entry {=0A=
>> +	struct attribute attr;=0A=
>> +	ssize_t (*show)(struct blk_crange *cr, char *page);=0A=
>> +};=0A=
>> +=0A=
>> +static struct blk_crange_sysfs_entry blk_crange_sector_entry =3D {=0A=
>> +	.attr =3D { .name =3D "sector", .mode =3D 0444 },=0A=
>> +	.show =3D blk_crange_sector_show,=0A=
>> +};=0A=
>> +=0A=
>> +static struct blk_crange_sysfs_entry blk_crange_nr_sectors_entry =3D {=
=0A=
>> +	.attr =3D { .name =3D "nr_sectors", .mode =3D 0444 },=0A=
>> +	.show =3D blk_crange_nr_sectors_show,=0A=
>> +};=0A=
>> +=0A=
>> +static struct attribute *blk_crange_attrs[] =3D {=0A=
>> +	&blk_crange_sector_entry.attr,=0A=
>> +	&blk_crange_nr_sectors_entry.attr,=0A=
>> +	NULL,=0A=
>> +};=0A=
>> +ATTRIBUTE_GROUPS(blk_crange);=0A=
>> +=0A=
>> +static ssize_t blk_crange_sysfs_show(struct kobject *kobj,=0A=
>> +				     struct attribute *attr, char *page)=0A=
>> +{=0A=
>> +	struct blk_crange_sysfs_entry *entry;=0A=
>> +	struct blk_crange *cr;=0A=
>> +	struct request_queue *q;=0A=
>> +	ssize_t ret;=0A=
>> +=0A=
>> +	entry =3D container_of(attr, struct blk_crange_sysfs_entry, attr);=0A=
>> +	cr =3D container_of(kobj, struct blk_crange, kobj);=0A=
>> +	q =3D cr->queue;=0A=
>> +=0A=
>> +	mutex_lock(&q->sysfs_lock);=0A=
>> +	ret =3D entry->show(cr, page);=0A=
>> +	mutex_unlock(&q->sysfs_lock);=0A=
>> +=0A=
>> +	return ret;=0A=
>> +}=0A=
>> +=0A=
>> +static const struct sysfs_ops blk_crange_sysfs_ops =3D {=0A=
>> +	.show	=3D blk_crange_sysfs_show,=0A=
>> +};=0A=
>> +=0A=
>> +/*=0A=
>> + * Dummy release function to make kobj happy.=0A=
>> + */=0A=
>> +static void blk_cranges_sysfs_nop_release(struct kobject *kobj)=0A=
>> +{=0A=
>> +}=0A=
>> +=0A=
>> +static struct kobj_type blk_crange_ktype =3D {=0A=
>> +	.sysfs_ops	=3D &blk_crange_sysfs_ops,=0A=
>> +	.default_groups	=3D blk_crange_groups,=0A=
>> +	.release	=3D blk_cranges_sysfs_nop_release,=0A=
>> +};=0A=
>> +=0A=
>> +static struct kobj_type blk_cranges_ktype =3D {=0A=
>> +	.release	=3D blk_cranges_sysfs_nop_release,=0A=
>> +};=0A=
>> +=0A=
>> +/**=0A=
>> + * blk_register_cranges - register with sysfs a set of concurrent range=
s=0A=
>> + * @disk:		Target disk=0A=
>> + * @new_cranges:	New set of concurrent ranges=0A=
>> + *=0A=
>> + * Register with sysfs a set of concurrent ranges for @disk. If @new_cr=
anges=0A=
>> + * is not NULL, this set of concurrent ranges is registered and the=0A=
>> + * old set specified by q->cranges is unregistered. Otherwise, q->crang=
es=0A=
>> + * is registered if it is not already.=0A=
>> + */=0A=
>> +int blk_register_cranges(struct gendisk *disk, struct blk_cranges *new_=
cranges)=0A=
>> +{=0A=
>> +	struct request_queue *q =3D disk->queue;=0A=
>> +	struct blk_cranges *cranges;=0A=
>> +	int i, ret;=0A=
>> +=0A=
>> +	lockdep_assert_held(&q->sysfs_dir_lock);=0A=
>> +	lockdep_assert_held(&q->sysfs_lock);=0A=
>> +=0A=
>> +	/* If a new range set is specified, unregister the old one */=0A=
>> +	if (new_cranges) {=0A=
>> +		if (q->cranges)=0A=
>> +			blk_unregister_cranges(disk);=0A=
>> +		q->cranges =3D new_cranges;=0A=
>> +	}=0A=
>> +=0A=
>> +	cranges =3D q->cranges;=0A=
>> +	if (!cranges)=0A=
>> +		return 0;=0A=
>> +=0A=
>> +	/*=0A=
>> +	 * At this point, q->cranges is the new set of sector ranges that need=
s=0A=
>> +	 * to be registered with sysfs.=0A=
>> +	 */=0A=
>> +	WARN_ON(cranges->sysfs_registered);=0A=
>> +	ret =3D kobject_init_and_add(&cranges->kobj, &blk_cranges_ktype,=0A=
>> +				   &q->kobj, "%s", "cranges");=0A=
>> +	if (ret)=0A=
>> +		goto free;=0A=
>> +=0A=
>> +	for (i =3D 0; i < cranges->nr_ranges; i++) {=0A=
>> +		cranges->ranges[i].queue =3D q;=0A=
>> +		ret =3D kobject_init_and_add(&cranges->ranges[i].kobj,=0A=
>> +					   &blk_crange_ktype, &cranges->kobj,=0A=
>> +					   "%d", i);=0A=
>> +		if (ret)=0A=
>> +			goto delete_obj;=0A=
>> +	}=0A=
>> +=0A=
>> +	cranges->sysfs_registered =3D true;=0A=
>> +=0A=
>> +	return 0;=0A=
>> +=0A=
>> +delete_obj:=0A=
>> +	while (--i >=3D 0)=0A=
>> +		kobject_del(&cranges->ranges[i].kobj);=0A=
>> +	kobject_del(&cranges->kobj);=0A=
>> +free:=0A=
>> +	kfree(cranges);=0A=
>> +	q->cranges =3D NULL;=0A=
>> +	return ret;=0A=
>> +}=0A=
>> +=0A=
>> +void blk_unregister_cranges(struct gendisk *disk)=0A=
>> +{=0A=
>> +	struct request_queue *q =3D disk->queue;=0A=
>> +	struct blk_cranges *cranges =3D q->cranges;=0A=
>> +	int i;=0A=
>> +=0A=
>> +	lockdep_assert_held(&q->sysfs_dir_lock);=0A=
>> +	lockdep_assert_held(&q->sysfs_lock);=0A=
>> +=0A=
>> +	if (!cranges)=0A=
>> +		return;=0A=
>> +=0A=
>> +	if (cranges->sysfs_registered) {=0A=
>> +		for (i =3D 0; i < cranges->nr_ranges; i++)=0A=
>> +			kobject_del(&cranges->ranges[i].kobj);=0A=
>> +		kobject_del(&cranges->kobj);=0A=
>> +	}=0A=
>> +=0A=
>> +	kfree(cranges);=0A=
>> +	q->cranges =3D NULL;=0A=
>> +}=0A=
>> +=0A=
>> +static bool blk_check_ranges(struct gendisk *disk, struct blk_cranges *=
cr)=0A=
>> +{=0A=
>> +	sector_t capacity =3D get_capacity(disk);=0A=
>> +	sector_t min_sector =3D (sector_t)-1;=0A=
>> +	sector_t max_sector =3D 0;=0A=
>> +	int i;=0A=
>> +=0A=
>> +	/*=0A=
>> +	 * Sector ranges may overlap but should overall contain all sectors=0A=
>> +	 * within the disk capacity.=0A=
>> +	 */=0A=
>> +	for (i =3D 0; i < cr->nr_ranges; i++) {=0A=
>> +		min_sector =3D min(min_sector, cr->ranges[i].sector);=0A=
>> +		max_sector =3D max(max_sector, cr->ranges[i].sector +=0A=
>> +					     cr->ranges[i].nr_sectors);=0A=
>> +	}=0A=
>> +=0A=
>> +	if (min_sector !=3D 0 || max_sector < capacity) {=0A=
>> +		pr_warn("Invalid concurrent ranges: missing sectors\n");=0A=
>> +		return false;=0A=
>> +	}=0A=
>> +=0A=
>> +	if (max_sector > capacity) {=0A=
>> +		pr_warn("Invalid concurrent ranges: beyond capacity\n");=0A=
>> +		return false;=0A=
>> +	}=0A=
>> +=0A=
>> +	return true;=0A=
>> +}=0A=
>> +=0A=
>> +static bool blk_cranges_changed(struct gendisk *disk, struct blk_crange=
s *new)=0A=
>> +{=0A=
>> +	struct blk_cranges *old =3D disk->queue->cranges;=0A=
>> +	int i;=0A=
>> +=0A=
>> +	if (!old)=0A=
>> +		return true;=0A=
>> +=0A=
>> +	if (old->nr_ranges !=3D new->nr_ranges)=0A=
>> +		return true;=0A=
>> +=0A=
>> +	for (i =3D 0; i < old->nr_ranges; i++) {=0A=
>> +		if (new->ranges[i].sector !=3D old->ranges[i].sector ||=0A=
>> +		    new->ranges[i].nr_sectors !=3D old->ranges[i].nr_sectors)=0A=
>> +			return true;=0A=
>> +	}=0A=
>> +=0A=
>> +	return false;=0A=
>> +}=0A=
>> +=0A=
>> +/**=0A=
>> + * blk_alloc_cranges - Allocate a concurrent positioning range structur=
e=0A=
>> + * @disk:	target disk=0A=
>> + * @nr_ranges:	Number of concurrent ranges=0A=
>> + *=0A=
>> + * Allocate a struct blk_cranges structure with @nr_ranges range descri=
ptors.=0A=
>> + */=0A=
>> +struct blk_cranges *blk_alloc_cranges(struct gendisk *disk, int nr_rang=
es)=0A=
>> +{=0A=
>> +	struct blk_cranges *cr;=0A=
>> +=0A=
>> +	cr =3D kzalloc_node(struct_size(cr, ranges, nr_ranges), GFP_KERNEL,=0A=
>> +			  disk->queue->node);=0A=
>> +	if (cr)=0A=
>> +		cr->nr_ranges =3D nr_ranges;=0A=
>> +	return cr;=0A=
>> +}=0A=
>> +EXPORT_SYMBOL_GPL(blk_alloc_cranges);=0A=
>> +=0A=
>> +/**=0A=
>> + * blk_queue_set_cranges - Set a disk concurrent positioning ranges=0A=
>> + * @disk:	target disk=0A=
>> + * @cr:		concurrent ranges structure=0A=
>> + *=0A=
>> + * Set the concurrant positioning ranges information of the request que=
ue=0A=
>> + * of @disk to @cr. If @cr is NULL and the concurrent ranges structure=
=0A=
>> + * already set, if any, is cleared. If there are no differences between=
=0A=
>> + * @cr and the concurrent ranges structure already set, @cr is freed.=
=0A=
>> + */=0A=
>> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr=
)=0A=
>> +{=0A=
>> +	struct request_queue *q =3D disk->queue;=0A=
>> +=0A=
>> +	if (WARN_ON_ONCE(cr && !cr->nr_ranges)) {=0A=
>> +		kfree(cr);=0A=
>> +		cr =3D NULL;=0A=
>> +	}=0A=
>> +=0A=
>> +	mutex_lock(&q->sysfs_dir_lock);=0A=
>> +	mutex_lock(&q->sysfs_lock);=0A=
>> +=0A=
>> +	if (cr) {=0A=
>> +		if (!blk_check_ranges(disk, cr)) {=0A=
>> +			kfree(cr);=0A=
>> +			cr =3D NULL;=0A=
>> +			goto reg;=0A=
>> +		}=0A=
>> +=0A=
>> +		if (!blk_cranges_changed(disk, cr)) {=0A=
>> +			kfree(cr);=0A=
>> +			goto unlock;=0A=
>> +		}=0A=
>> +	}=0A=
>> +=0A=
>> +	/*=0A=
>> +	 * This may be called for a registered queue. E.g. during a device=0A=
>> +	 * revalidation. If that is the case, we need to unregister the old=0A=
>> +	 * set of concurrent ranges and register the new set. If the queue=0A=
>> +	 * is not registered, the device request queue registration will=0A=
>> +	 * register the ranges, so only swap in the new set and free the=0A=
>> +	 * old one.=0A=
>> +	 */=0A=
>> +reg:=0A=
>> +	if (blk_queue_registered(q)) {=0A=
>> +		blk_register_cranges(disk, cr);=0A=
>> +	} else {=0A=
>> +		swap(q->cranges, cr);=0A=
>> +		kfree(cr);=0A=
>> +	}=0A=
>> +=0A=
>> +unlock:=0A=
>> +	mutex_unlock(&q->sysfs_lock);=0A=
>> +	mutex_unlock(&q->sysfs_dir_lock);=0A=
>> +}=0A=
>> +EXPORT_SYMBOL_GPL(blk_queue_set_cranges);=0A=
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c=0A=
>> index 370d83c18057..aeac98ecc5a0 100644=0A=
>> --- a/block/blk-sysfs.c=0A=
>> +++ b/block/blk-sysfs.c=0A=
>> @@ -899,9 +899,21 @@ int blk_register_queue(struct gendisk *disk)=0A=
>>   	}=0A=
>>   =0A=
>>   	mutex_lock(&q->sysfs_lock);=0A=
>> +=0A=
>> +	ret =3D blk_register_cranges(disk, NULL);=0A=
>> +	if (ret) {=0A=
>> +		mutex_unlock(&q->sysfs_lock);=0A=
>> +		mutex_unlock(&q->sysfs_dir_lock);=0A=
>> +		kobject_del(&q->kobj);=0A=
>> +		blk_trace_remove_sysfs(dev);=0A=
>> +		kobject_put(&dev->kobj);=0A=
>> +		return ret;=0A=
>> +	}=0A=
>> +=0A=
>>   	if (q->elevator) {=0A=
>>   		ret =3D elv_register_queue(q, false);=0A=
>>   		if (ret) {=0A=
>> +			blk_unregister_cranges(disk);=0A=
>>   			mutex_unlock(&q->sysfs_lock);=0A=
>>   			mutex_unlock(&q->sysfs_dir_lock);=0A=
>>   			kobject_del(&q->kobj);=0A=
>> @@ -985,6 +997,7 @@ void blk_unregister_queue(struct gendisk *disk)=0A=
>>   	mutex_lock(&q->sysfs_lock);=0A=
>>   	if (q->elevator)=0A=
>>   		elv_unregister_queue(q);=0A=
>> +	blk_unregister_cranges(disk);=0A=
>>   	mutex_unlock(&q->sysfs_lock);=0A=
>>   	mutex_unlock(&q->sysfs_dir_lock);=0A=
>>   =0A=
>> diff --git a/block/blk.h b/block/blk.h=0A=
>> index 4b885c0f6708..650c0d87987c 100644=0A=
>> --- a/block/blk.h=0A=
>> +++ b/block/blk.h=0A=
>> @@ -368,4 +368,7 @@ extern struct device_attribute dev_attr_events;=0A=
>>   extern struct device_attribute dev_attr_events_async;=0A=
>>   extern struct device_attribute dev_attr_events_poll_msecs;=0A=
>>   =0A=
>> +int blk_register_cranges(struct gendisk *disk, struct blk_cranges *new_=
cranges);=0A=
>> +void blk_unregister_cranges(struct gendisk *disk);=0A=
>> +=0A=
>>   #endif /* BLK_INTERNAL_H */=0A=
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>> index d3afea47ade6..d10352674d20 100644=0A=
>> --- a/include/linux/blkdev.h=0A=
>> +++ b/include/linux/blkdev.h=0A=
>> @@ -378,6 +378,29 @@ static inline int blkdev_zone_mgmt_ioctl(struct blo=
ck_device *bdev,=0A=
>>   =0A=
>>   #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>>   =0A=
>> +/*=0A=
>> + * Concurrent sector ranges: struct blk_crange describes range of=0A=
>> + * contiguous sectors that can be served by independent resources on th=
e=0A=
>> + * device. The set of ranges defined in struct blk_cranges must overall=
=0A=
>> + * include all sectors within the device capacity.=0A=
>> + * For a device with multiple ranges, e.g. a single LUN multi-actuator =
HDD,=0A=
>> + * requests targeting sectors in different ranges can be executed in pa=
rallel.=0A=
>> + * A request can straddle a range boundary.=0A=
>> + */=0A=
>> +struct blk_crange {=0A=
>> +	struct kobject		kobj;=0A=
>> +	struct request_queue	*queue;=0A=
>> +	sector_t		sector;=0A=
>> +	sector_t		nr_sectors;=0A=
>> +};=0A=
>> +=0A=
>> +struct blk_cranges {=0A=
>> +	struct kobject		kobj;=0A=
>> +	bool			sysfs_registered;=0A=
>> +	unsigned int		nr_ranges;=0A=
>> +	struct blk_crange	ranges[];=0A=
>> +};=0A=
>> +=0A=
>>   struct request_queue {=0A=
>>   	struct request		*last_merge;=0A=
>>   	struct elevator_queue	*elevator;=0A=
>> @@ -570,6 +593,9 @@ struct request_queue {=0A=
>>   =0A=
>>   #define BLK_MAX_WRITE_HINTS	5=0A=
>>   	u64			write_hints[BLK_MAX_WRITE_HINTS];=0A=
>> +=0A=
>> +	/* Concurrent sector ranges */=0A=
>> +	struct blk_cranges	*cranges;=0A=
>>   };=0A=
>>   =0A=
>>   /* Keep blk_queue_flag_name[] in sync with the definitions below */=0A=
>> @@ -1163,6 +1189,9 @@ extern void blk_queue_required_elevator_features(s=
truct request_queue *q,=0A=
>>   extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,=
=0A=
>>   					      struct device *dev);=0A=
>>   =0A=
>> +struct blk_cranges *blk_alloc_cranges(struct gendisk *disk, int nr_rang=
es);=0A=
>> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr=
);=0A=
>> +=0A=
>>   /*=0A=
>>    * Number of physical segments as sent to the device.=0A=
>>    *=0A=
>>=0A=
> In principle it looks good, but what would be the appropriate action =0A=
> when invalid ranges are being detected during revalidation?=0A=
> The current code will leave the original ones intact, but I guess that's =
=0A=
> questionable as the current settings are most likely invalid.=0A=
=0A=
Nope. In that case, the old ranges are removed. In blk_queue_set_cranges(),=
=0A=
there is:=0A=
=0A=
+		if (!blk_check_ranges(disk, cr)) {=0A=
+			kfree(cr);=0A=
+			cr =3D NULL;=0A=
+			goto reg;=0A=
+		}=0A=
=0A=
So for incorrect ranges, we will register "NULL", so no ranges. The old ran=
ges=0A=
are gone.=0A=
=0A=
> I would vote for de-register the old ones and implement an error state =
=0A=
> (using an error pointer?); that would signal that there _are_ ranges, =0A=
> but we couldn't parse them properly.=0A=
> Hmm?=0A=
=0A=
With the current code, the information "there are ranges" will be completel=
y=0A=
gone if the ranges are bad... dmesg will have a message about it, but that'=
s it.=0A=
=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
