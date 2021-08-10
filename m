Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9CDC432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 11:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13B9F60F25
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 11:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhHJLEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 07:04:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5827 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhHJLEG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 07:04:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628593423; x=1660129423;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=PEtUhQCF/f5mMS453ZgYj66EeiYzHFnUeTmcdIW6rcQ=;
  b=DkPPkX/ZbAMiANT+qhXXxkm3yD6INue6NdXeSixENgBrfocAsZuVW/uU
   oZ6sawz2omWb2+SeYGkG6kKX8RMFHf49FUbJrXxdpbGU6Ri9tvhLbr6ws
   0uj/QToK0fjlPS1ykdH2tm2lrjhmvLSPyyiRThz8jvbCYkg72OK3BRw2B
   Ag6JHP80J2NJ9XA0vau5cIzmQ8NUGsYLg6x2zuUutlkBCKUG3N/vLaPMw
   iIRWL64gjeSDb9I7LoutroF7mJI03wGq2Ey/4V41CcyGdZOX98ZHKFUHM
   yOAHHROAfLVhirMr0de5gKq6ok7a5M++kq1mtnozf5jVZK703AclX/bfj
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,310,1620662400"; 
   d="scan'208";a="176795644"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Aug 2021 19:03:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwcdjx3X5uc1BIrk+8a8wSbQisHSxnL0XifXWwLJwyqqElA6Yggw9POTrHOGXxxg/SePQwg+MKW/TUKoe+hwVNJiKKfvyU5Qti5OlrKh8cr7bij1vWD9dyNrNGEyLGaOeNSwvkhfKvz/By0HPCfbdVCF5Nb2mm0neSa5599bU0SVOsr4rgvsA/mQsURZJF0zT9Xg9fv7hnBZ+jXQujgikN2WN604KeHtk2NY0Kq9EAn2ktvZKRAqrMlHiLIdgeevgh/LTAXaWm30QJA/LpaD54lON5MSyPdXXWHK4pOaRwmtESLRBT05Zxc8UjfNcPoVEYqCDsTRNzVBFdkkHs/4bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Enl9+i3rxHjCzCSgVCOKi5Udrx/9wXHT2HwcMcAnuM=;
 b=oKKC0Zcy7HmBXIvZPcxQdFrtrVjJU7ZgBWCRjzmBElXPLIAaztckhINWfNlxsI9BNpr3E0TFgt8oqEVL5iLoeFgdYY5GzrVwl4jWilK4+3F+Nb87aL5XgM1dhHdHcU0VapkQSBfJiLMkSDFhb/rxE4Iyl4N0BCDFZW/9EWoNG3ClObksN+670mowEYT7tDFALpipOHhydI9bHwpqmmBdwLzpF3OuAWYTYVIX8DmlsuCAh/FeD+6IKWyPsOgzW/J3lMUjo7w0zEgdx6nselyOUEb/AEQysIpOYaKkymqzjHvTRRYtiMuqg5LjWAqewwNVHxM8oJVd3CJMIHdku9YnAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Enl9+i3rxHjCzCSgVCOKi5Udrx/9wXHT2HwcMcAnuM=;
 b=vzOgv6n2Nj9TUw+ivgSetOv2eWXkGAcrK6qYBsvnqeKr4P9wzwt9WZ3BeajQHAfuBdRo/vrOpN+nTgrm3OZM6KIhD1AGh3RzYuIz6Dn+zQE89JQjmepZ5j8338f8Jl1/DTNRdtWBGS5fQaEuNH9JghCsLtNoA+PafY/VuICUyIo=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6828.namprd04.prod.outlook.com (2603:10b6:5:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 11:03:42 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:03:42 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Topic: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Thread-Index: AQHXgb7rfkYo5fvxW0aRSzaXyXSWfA==
Date:   Tue, 10 Aug 2021 11:03:41 +0000
Message-ID: <DM6PR04MB7081844211DF94238A3FC6B4E7F79@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
 <YRI3kMc39XPRLe/u@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a2cec60-c6b8-4d77-c28a-08d95bee83d6
x-ms-traffictypediagnostic: DM6PR04MB6828:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB6828D9096939F9978626C9FAE7F79@DM6PR04MB6828.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vkFJ9Rz1aYE8Naz+LNHHcSbyFi2Zd4ldw41hhwIdoZPOe06uXF0Xj9FitS3topmYrsB0YjPGK7bZshrP/AyT4cYW60vxZefWp+ZS8gx6urbNdxc4aZcBfi2Uml9v7KFlzBDXHc+xaJvmllimyWSD724aPD9RFIrtkcNUtxHteprOQeo6JlYAeXzyE+XVvMMF9PgPnDytKqIsQX0AFqtjicdWECuztjVEZdvigZpZ4iAvRsQ+S6My53axyyTp0EsQFqzRDffDDi0S1+tdc98nKMDEl8uwn6oHK5ijmHFob2H9oIJMHgtoMAwpOXzzBE4f32IoOPhRj7OmXcAB/cuRuQBWP/Uklrzav8npCJvHLnw9xULHQgOJYS/XK6iPL7+BeuytUK9kzf/cLcWi0iaP6C80MzwqOdIAe1AUgpo7BeXR38SfkKf7ESR2uafkTbA3GnaFagYC1E9f1sWGyYn7tMrup02+3T/Lg0lOCgau0lGnmnEzn9+al5W4htgNaGwPNNMo1kYOupHQqugDyHuiml7B9/LgbY4lIOppz7XpFgW+SEeKr/JA0udaX9oZtWFL3fji2lzt9eh4D5fSdMm7Uywl1QDDnnJfIfhe+pzfsqBYS0om2woYtGfuEDF4HDN1i4kqgjXVLdMsZxjZcjfb12WZE7FsJ434DCRLQpr3ahFxTjeeKyVOoKf/5zqxCrR3fez9cAzDBNXsYwc1JbG9IA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(91956017)(8936002)(6916009)(316002)(9686003)(52536014)(5660300002)(76116006)(33656002)(122000001)(71200400001)(4326008)(64756008)(66946007)(38100700002)(66476007)(186003)(66556008)(66446008)(38070700005)(55016002)(54906003)(86362001)(6506007)(53546011)(83380400001)(7696005)(8676002)(478600001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GOHO97URcUS4fFrYZ1S6xRqx3MTpSvxU4v/2jfMwPLub+ak5anZ3LrlrQ2dU?=
 =?us-ascii?Q?kY/N8Gk7jPIevZPbXhGmf4XyAKyj9x6eFcZ7YJ933k/WSq5qYspKHii7/7yT?=
 =?us-ascii?Q?5Ba6con1fppSRasgVCOBn4yKllfBDIseK6c7gBnWW5C8HMK/gyEe2Y/pgOwB?=
 =?us-ascii?Q?0W8pJKgiUMoV04M8waGdAX869Z8mF22rPIQnQiixwwks7REsCmb9e4Ft3vzX?=
 =?us-ascii?Q?5rHdCIkC1ntIGKdLNUZoWk67cgawPuuuPrGd3tQfzNF2h8ERO66PVt7yLIB6?=
 =?us-ascii?Q?Q4995+gxPwLxKMNPtBY2yNB17QCi38TZSGEYBivdwC2lB8tIMhL21F0b6LXP?=
 =?us-ascii?Q?ADAuDOctbRED7k3g2iXt9D0Gc98EfyBsx74pb3sFHE9CwrYj6qLh9NVwvaUC?=
 =?us-ascii?Q?nkNUgij7MIFHJbgNOFT1rbiHWWgsqGlNwTFwS+s4JzP7uwzcHp+rMwKA6xWU?=
 =?us-ascii?Q?Wu23O4Sfag/MBikmntDT8JJGRTS3EVaOh6D+bN2Y5nGqhcph8t44TqBFEGuJ?=
 =?us-ascii?Q?UVeyGST7s70yAKFBjA1jpm8yupBS/tvIVdM0lxJrV/I280lfW9fC2UYNlL1n?=
 =?us-ascii?Q?+hUixQCYdnmFRGuOGBofxj4Nc/fztjR7iS3iDieVQ2/B3TVfTzaTwy+IbVk2?=
 =?us-ascii?Q?vaE/VFVQpwine0ESr2RUv/3hYcNUJkMI5R8H6Tnhfs6lbK274iArXdKZTGuh?=
 =?us-ascii?Q?rduGd8RcZINGOmEIsQFqP32YCfbsWgEWT6t4WQKjLUS3YZY8hE1pCjC3z3xW?=
 =?us-ascii?Q?Tto6hf0rKqNg2JuYnaoWzZqaSIxI7UgFzKOK/GFBhPzTu8C08wwKwRXrGAnk?=
 =?us-ascii?Q?Z9TWIZ3JyxD24yTUtr65Bo2IcIWLi5GzpqXrjNdCbBfoTbKERQ6PwQkIZK8J?=
 =?us-ascii?Q?VT0UfqwhR6S2Wsfq4LrDC4LLAzhEUFFVKwA3FSHv5pbrNfGge9ZRfd6xFx8Z?=
 =?us-ascii?Q?BncO+spSUf3oH5iNpMttq9Oq7/YuebjlMqTbsMdqv2hyLCDJetcuKpF5+ckC?=
 =?us-ascii?Q?sxtjtx9piGH3Rfba/t61FrO5wYo3a15tKikVELgyDo1f26L0Z5CVga8ymS3A?=
 =?us-ascii?Q?MYYJInV//MXD/HIEyugcVlbceQ5lYVQvtgqrmv+T7bX4NR+kDey/xbwPN6Wm?=
 =?us-ascii?Q?SzW7cS+nCkBJsNrYzIwQRyI8mIaUc3RLbQGDNUMfuQ9T21hJTB1GY3tb/K5c?=
 =?us-ascii?Q?uvu/gNGgsqIlTSFhANsBwj+nT1tA8PmWSNCFltba99DsZGdykSCgoj58reR7?=
 =?us-ascii?Q?l+kOvg7wwHsoYIBKS6mSiizhSLh15nv5/YqESE1FOyAiJH4DfUz2Bj56ACW/?=
 =?us-ascii?Q?nM98AvIsIImOGNLfY+lQLjiCFtqHGlnzKcmUegf+COXu0tDpvUVSRuQQz/EY?=
 =?us-ascii?Q?XbB7VIlI/E4OpHoQ0xXwyadbm3LLWkhgADG/I6e1sSFX59/RBA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2cec60-c6b8-4d77-c28a-08d95bee83d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 11:03:42.0047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hygrcvXijXegjRukrt0IdJVR61mFH+x5AgF9gfG67OHQJkdXrVm898Ec3dZmBxoKkHELtGCH24pO+fgTxk4+AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6828
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/10 17:24, Christoph Hellwig wrote:=0A=
> On Mon, Jul 26, 2021 at 10:38:03AM +0900, Damien Le Moal wrote:=0A=
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
>>     |-- nr_sectors=0A=
>>     `-- sector=0A=
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
>>  block/Makefile         |   2 +-=0A=
>>  block/blk-cranges.c    | 295 +++++++++++++++++++++++++++++++++++++++++=
=0A=
>>  block/blk-sysfs.c      |  13 ++=0A=
>>  block/blk.h            |   3 +=0A=
>>  include/linux/blkdev.h |  29 ++++=0A=
>>  5 files changed, 341 insertions(+), 1 deletion(-)=0A=
>>  create mode 100644 block/blk-cranges.c=0A=
>>=0A=
>> diff --git a/block/Makefile b/block/Makefile=0A=
>> index bfbe4e13ca1e..e477e6ca9ea6 100644=0A=
>> --- a/block/Makefile=0A=
>> +++ b/block/Makefile=0A=
>> @@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) :=3D bio.o elevator.o blk-core.o blk=
-sysfs.o \=0A=
>>  			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \=0A=
>>  			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \=0A=
>>  			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \=0A=
>> -			disk-events.o=0A=
>> +			disk-events.o blk-cranges.o=0A=
>>  =0A=
>>  obj-$(CONFIG_BOUNCE)		+=3D bounce.o=0A=
>>  obj-$(CONFIG_BLK_SCSI_REQUEST)	+=3D scsi_ioctl.o=0A=
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
> =0A=
> Nit: I'd find this a little eaier to read if the variables were=0A=
> initialized at declaration time:=0A=
> =0A=
> 	struct blk_crange_sysfs_entry *entry =3D=0A=
> 		container_of(attr, struct blk_crange_sysfs_entry, attr);=0A=
> 	struct blk_crange *cr =3D container_of(kobj, struct blk_crange, kobj);=
=0A=
> 	struct request_queue *q =3D cr->queue;=0A=
> =0A=
> (or maybe even don't bother with the q local variable).=0A=
=0A=
OK.=0A=
=0A=
> =0A=
>> +/*=0A=
>> + * Dummy release function to make kobj happy.=0A=
>> + */=0A=
>> +static void blk_cranges_sysfs_nop_release(struct kobject *kobj)=0A=
>> +{=0A=
>> +}=0A=
> =0A=
> How do we ensure the kobj is still alive while it is accessed?=0A=
=0A=
q->sysfs_lock ensures that. This mutex is taken whenever revalidate registe=
rs=0A=
new ranges (see blk_queue_set_cranges below), and is taken also when the ra=
nges=0A=
are unregistered (on revalidate if the ranges changed and when the request =
queue=0A=
is unregistered). And blk_crange_sysfs_show() takes that lock too. So the k=
obj=0A=
cannot be freed while it is being accessed (the sysfs inode lock also preve=
nts=0A=
it since kobj_del() will take the inode lock).=0A=
=0A=
> =0A=
>> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr=
)=0A=
> =0A=
> s/blk_queue/disk/=0A=
=0A=
Hmmm... The argument is a gendisk, but it is the request queue that is modi=
fied.=0A=
So following other functions like this, isn't blk_queue_ prefix better ?=0A=
=0A=
> =0A=
>>  	mutex_lock(&q->sysfs_lock);=0A=
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
>>  	if (q->elevator) {=0A=
>>  		ret =3D elv_register_queue(q, false);=0A=
>>  		if (ret) {=0A=
>> +			blk_unregister_cranges(disk);=0A=
>>  			mutex_unlock(&q->sysfs_lock);=0A=
>>  			mutex_unlock(&q->sysfs_dir_lock);=0A=
>>  			kobject_del(&q->kobj);=0A=
> =0A=
> Please use a goto instead of duplicating the code.=0A=
=0A=
I had tried that but it made a mess. Will have another look at it.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
