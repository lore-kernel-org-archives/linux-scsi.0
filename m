Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B651C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 00:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0630B60EB6
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhGVXTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 19:19:25 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:54481 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbhGVXTZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 19:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626998399; x=1658534399;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=2m8CP31FVOTVCKD+tPr49z5IHQq9d83qM0NPhDSDqPc=;
  b=MF8kxaAB+72vFbfhWnsbEoS783ytO3QrNIqE4jVyzX7zeskemBu4cUvv
   LXRvHOQ08xtX8XdSmCpwKG1+ZTkr07Wc059AKg3ubBk04wn5+2ZEPCRKd
   9I6uktrj1PW4acCSD8Hoq8SK4G+H+b0zlKPPPAqbP0GKGH4ks+s1ibGr4
   tYVAbsiaSpUzPztYp22ejS1zp544w03pG+TxTCOg9/OEpXUuxls7gLOLd
   /MI/ijSdR1EFP3yxJ3EA5eVqzoIS1BQoyzaw9+mg4drhVRXLJG7ckna9o
   kpTBFquLc6FIg3Do0/xbDPJCLrrpU0hPjyKpSVHqfpdAdREfXUbdskFY6
   g==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="286846686"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 07:59:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fq3bFFnY+OhB0so/u82uan4IgkAJlWoANzZtCKMI2uyamaD3LP4Qn5V2OxzVyJZtT4leFZwPdIxo3N9rH5bjw7CCOzJ3D7YaGi3/6K7/wEad4nallnjyh+Hpbz3E5EpbTRpC+/TF23D0mxO42uZ++9WgLL8/n00zz8YqEU+ihsu2vKg03SzVmaiDNSCkdHaqXtOz45fUdgMAlOxp7Tt9LG7mdnrw4dp/1AKDLwO+MYOsuKfnvJNq67WpkUa8UsEeUPFPE4Ovxlyc3qR97L8gs7hrx2tMUGzGixT9ojIssAuJmJJATFLtSJpXl2+91ZNzhTeJVT9r9ZbljJnzsxYXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JcJmhYUGrSpsWQdWFX1XeNXw1BeCWuc9YRjiwIfOP0=;
 b=WJliJGZysDvmO0UosUf0O4MEt1uPhDTolv37oAjacqg4IXAY9VOWEPjUQn8gbB/9T81jhnPeefcVbM0l/smD/dkGFGqoKbXLkzSlNsDsY01i/CdRoG2Ajq3LrD2Af0bV6Wwdiypa5nhjllMh2F1AId4Xx51We4+y5teJA0xuW13EPS3Q6T7ovhCGzv/uutcJ0hxW2tYiCYALbQiGl5BeIH9mJS1+xwqFDx7PqDAk9N0uw+F5oslzwL/z5y6RDJSM4B89/xdTwHBngi1PcxsjHrLOr9TDyXd/AXsSuo4aOtHtvuMQRA/qw8qCcdSSGzVMMBtUWyoVfD2J4Em+bhwztQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JcJmhYUGrSpsWQdWFX1XeNXw1BeCWuc9YRjiwIfOP0=;
 b=sxuxTMWk0rT5Vcr/qcB3XraNHklAgNZ172uA4CJUOgGVvI1Xo3bszzW2y9YFL07vB7EV6rj5FVg9QMZWwPvXiQdBoSl2Vqe+LWHFXmIs9d63RRPBftZ7wJCg1i8chlD0/+O/1UPmMlGVgf3l4k7BdXn9ZrYb81nOp5BM2g+cOZ0=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0445.namprd04.prod.outlook.com (2603:10b6:3:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 23:59:56 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%8]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 23:59:56 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 1/4] block: Add concurrent positioning ranges support
Thread-Topic: [PATCH 1/4] block: Add concurrent positioning ranges support
Thread-Index: AQHXfh349TdNW2Fsl06MHlDcwZsxSQ==
Date:   Thu, 22 Jul 2021 23:59:55 +0000
Message-ID: <DM6PR04MB7081DFF74BFAA77539DAAC0DE7E49@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
 <20210721104205.885115-2-damien.lemoal@wdc.com>
 <811ff538-bb0d-d575-faf6-871c2d3b5221@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d7acf87-8aa1-4917-2d34-08d94d6cce2f
x-ms-traffictypediagnostic: DM5PR04MB0445:
x-microsoft-antispam-prvs: <DM5PR04MB0445D927575CFC0ABB5EC2D1E7E49@DM5PR04MB0445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9VlYBeAC8SEJIL/mIUlkJ1K1SxLoET3CTXtPUL0N6DAoBqUfvVZCzcIZeUIKqfK20xlyv8fMqY4or9bH3a+k+oRP6YWDddw7K0eZH5wriqejAqkPiGou+xW4UmM7MfnzOnchmVCbzJMG1HD7Xsj17TcUvjO/pe9aWEPVN3661Us26QSfAXJyscFShL3Ldnw4Z5ccwHMd8hA0hg5YgEt1A06TyK3ja/vL8ewAifHkkXSQrm9gzFPj5ehaDzAMNT4fnL8qisiPTwQhGEvsOxC8bYABMjpzo8ST5jj5JwJZE0NqjTedQnZ5RYBA3gJuGerHE4rSvOrfmJu9FbdacBxmoaQnl8ehIKtM/KIrTDMM0LryYieUJISvHdvGxs1y13s/v56MzrTh8rOW880hwWVW75jfLgXfc6kPro9Vs8wucK6P37lYLohw3sjqYTX35skFsnCe4GgrIMG7nAUXSpTp8NwRCVS0Cpea0OGcpcA4CWIj5P/fpix3IcPWmYwa/rK4sSl9cx7qlxKJpc/+x9RHdRvm4OhcZHaOonHYvr7SPPU5wTMl7+66B+DykvBcsGFmjOVu+J8M+1vWXDXQQE+CYYc4gFwD9TO8qAJ8bRBTsFJiWpF6ed8mx+Saz9n2hw9e9/h/NBg17rBsL9+t5Rd7gTUJhy0CwrYWo4ayKl5Hh15wTzRhyYJX0L3RFTSfGvY6y3vritQThSk6btSAWe67/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(33656002)(55016002)(71200400001)(83380400001)(86362001)(6506007)(122000001)(9686003)(8676002)(186003)(53546011)(38100700002)(7696005)(30864003)(5660300002)(478600001)(91956017)(76116006)(316002)(66946007)(110136005)(66446008)(66556008)(64756008)(66476007)(8936002)(2906002)(52536014)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AeBbv/ly9xky/JTHvHe0t74LVtFq7Oi5CrnvajNL1TDS/cQog4NcgGEPmNe6?=
 =?us-ascii?Q?Qy/0BKwxwFyK99gGEzpZZzJ1Njw0m+V99lYXYdiDCCuXiG0LrIVImzYNWoxe?=
 =?us-ascii?Q?3Ord3h4L+Zx/jErx4piLiRnona28yqlZGJO6k2mwNa6JkpTUk5PkkiC8NGjy?=
 =?us-ascii?Q?BnO1cPx3CWnkj0UzTnvXhC8qwfiBcRjmKg8Bfn2wKq+IX7IKISzcqTk9w+XA?=
 =?us-ascii?Q?e1QNAqNNl7Nlxo2J+7RbSEyZZJHv28Id5TT9yt2q56ECCP3kUXcB9msgVoJ8?=
 =?us-ascii?Q?nEZCb0z1wuFlRYrpMex3den59CSk0mZfHbm8Iexb/X6frapmURdUPSy5RwWm?=
 =?us-ascii?Q?7rRz1BtjcgJU1i3kl6ho0PmQq2RXccbNM70KXYQTofeoEwfG7fZ8xwCrImWu?=
 =?us-ascii?Q?JyGMyRLaunem5i7WKngtF9Oeo2eNiFcSzZ+4owLFWJjsQJjgqszmm0u8pQid?=
 =?us-ascii?Q?n52d1zh0TALpGXUC5JdSiMxzEHb5zIlQRZAI4UXh3RACgoa3Vq4DYtuqHi9p?=
 =?us-ascii?Q?krDZ6IlIC9UkcwXLjcy0ZcUyjEGeb+ATyG12LJe18++Fp72cTMGEMrR/12ec?=
 =?us-ascii?Q?P+iabF1Dx2dx+NizdtvkuO/3Jmz6VfFpJ7Z3M2i6d80Op1AkMm3bMsc4fR+G?=
 =?us-ascii?Q?bvtitNm2mv0N9w7XYl3k2tHoG3NgTvbSrgsVLqw1P9fSBDJE8MuJgx5GN+vL?=
 =?us-ascii?Q?fvwCBpFP3QxjBSk8GEIGb9rYZEEqk25ajirmcqEJHCXMDbwsPfRYwpf1diL8?=
 =?us-ascii?Q?eHf6FNfQCCvPLElnwrk2Fgz32YHLexJMYTzxvTAFcmf8e9hInFFshRSw52sX?=
 =?us-ascii?Q?PahJdpOJCETeVxj2+MVNCDbN7qcgmCWn0+eHhPPqYk4Ynj3sm/4C7wXl2CkI?=
 =?us-ascii?Q?3szi14bZClo9MNI+tdwAjriOKD3XqielUOhAGZEc3UsOD0g2JoJ2l69TPr0h?=
 =?us-ascii?Q?/OVT20T9R0pmxH6yPUYh3+nsuRsfvfx2d+D2il4EsrE0DonK7Y3qQLfHwKU9?=
 =?us-ascii?Q?a+82Tgi05xdjr+FFyy97PPmfMPyPcXX6Kb5jxZifQeeOCVVkhJeyZxxre5Jr?=
 =?us-ascii?Q?ZvZMQPfHe1k0X1230h0xZu/sIHMD5xbxatAgRArtz9f0BrIHrN/WxWgPmjyh?=
 =?us-ascii?Q?w7Gp3OizWX6FZEF5gZx7xsvTXOZtkB+yq310L+M99yJZtT9p6PafxVfj85L1?=
 =?us-ascii?Q?O5jSyQ/0oPqFu89FrnFx4Z5cajdnnBHYDgEiMkFyAPt9kjFw90Abc9NvLDuN?=
 =?us-ascii?Q?q5JwYGCS/gH/HCv7yQSl3Do0Nl210fnMaAYzx93bBsW1NPfQ2mk2BFnYR/uo?=
 =?us-ascii?Q?vyZ0SV5Yb/B19+ie6BUdna2qt9skhuW2ZEcXTyqhmpZql23z8k30hyizGb+s?=
 =?us-ascii?Q?yJIolKZdZgjHS3mcrUrmi0U8ZV+0ViuRMC3DtM6vEY9StVqMYQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7acf87-8aa1-4917-2d34-08d94d6cce2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 23:59:55.9067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hNe6PlykjgiOuBOTsD1pCCerIQDjOo8fs21t+ErusVqqu3iu+V8qYE+kSMInspvnGmppcBVUfXOp01PPl3EafA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0445
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/07/23 1:11, Hannes Reinecke wrote:=0A=
> On 7/21/21 12:42 PM, Damien Le Moal wrote:=0A=
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
> Hmm. I do wonder if we need such a detailed layout.=0A=
> In my patch I have just:=0A=
> =0A=
> +       unsigned int            num_lba_ranges;=0A=
> +       sector_t                *lba_ranges;=0A=
> =0A=
> to hold the information; after all, I don't expect this data to be =0A=
> changing very often during the lifetime of the OS.=0A=
=0A=
Another thing about this sysfs structure: it allows easily adding attribute=
s for=0A=
each actuator if needed. For instance, the VPD and Log page advertize a "nu=
mber=0A=
of storage elements" for each actuator. This is not exposed here as I do no=
t=0A=
find that information particularly useful. But we could add anything that t=
he=0A=
standards defines. Or purely software things like a request counter to see =
how=0A=
well balanced accesses are.=0A=
=0A=
> =0A=
>> Device revalidation may lead to changes to this structure and to the=0A=
>> attribute values. When manipulated, the queue sysfs_lock and=0A=
>> sysfs_dir_lock are held for atomicity, similarly to how the blk-mq and=
=0A=
>> elevator sysfs queue sub-directories are protected.=0A=
>>=0A=
> =0A=
> Indeed, the values might change with revalidation. But not =0A=
> independently; a change in _one_ range will typically affect the =0A=
> adjacent ranges, too.=0A=
> So it should be sufficient to drop them completely and redo from scratch =
=0A=
> for revalidation.=0A=
> =0A=
>> The code related to the management of cranges is added in the new=0A=
>> file block/blk-cranges.c.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>   block/Makefile            |   2 +-=0A=
>>   block/blk-cranges.c       | 286 ++++++++++++++++++++++++++++++++++++++=
=0A=
>>   block/blk-sysfs.c         |  13 ++=0A=
>>   block/blk.h               |   3 +=0A=
>>   drivers/ata/libata-scsi.c |   1 +=0A=
>>   include/linux/blkdev.h    |  29 ++++=0A=
>>   6 files changed, 333 insertions(+), 1 deletion(-)=0A=
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
>> index 000000000000..e8ff0d40a5c9=0A=
>> --- /dev/null=0A=
>> +++ b/block/blk-cranges.c=0A=
>> @@ -0,0 +1,286 @@=0A=
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
>> + > +	for (i =3D 0; i < cranges->nr_ranges; i++) {=0A=
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
> =0A=
> Do you really need independent kobj here?=0A=
> As discussed above, the individual ranges are not independent, and it =0A=
> might be easier to just lump them into one structure, seeing that all of =
=0A=
> them will have to be redone during revalidation anyway.=0A=
> =0A=
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
> =0A=
> Warm fuzzy feelings.=0A=
> Sector ranges may overlap? Seriously?=0A=
> =0A=
> The only way this could happen is when a given LBA will be present in =0A=
> _two_ ranges. And this is valid?=0A=
> =0A=
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
>> +	if (!old || old->nr_ranges !=3D new->nr_ranges)=0A=
>> +		return true;=0A=
>> +=0A=
>> +	for (i =3D 0; i < new->nr_ranges; i++) {=0A=
>> +		if (old->ranges[i].sector !=3D new->ranges[i].sector ||=0A=
>> +		    old->ranges[i].nr_sectors !=3D new->ranges[i].nr_sectors)=0A=
>> +			return true;=0A=
>> +	}=0A=
>> +=0A=
>> +	return false;=0A=
>> +}=0A=
>> +=0A=
> =0A=
> As mentioned above: I doubt we need to go into such detail. Just redo =0A=
> the ranges on revalidation should be sufficient.=0A=
> =0A=
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
> =0A=
> And this is what you get for all the complexity.=0A=
> Having to take _two_ locks, and have a detailed description how the =0A=
> function should be used.=0A=
> =0A=
> I still think that redoing everything is simpler.=0A=
> =0A=
>> +	if (cr && !blk_check_ranges(disk, cr)) {=0A=
>> +		kfree(cr);=0A=
>> +		cr =3D NULL;=0A=
>> +	}=0A=
>> +=0A=
>> +	if (!blk_cranges_changed(disk, cr)) {=0A=
>> +		kfree(cr);=0A=
>> +		goto unlock;=0A=
>> +	}=0A=
>> +=0A=
>> +	/*=0A=
>> +	 * This may be called for a registered queue. E.g. during a device=0A=
>> +	 * revalidation. If that is the case, we need to register the new set=
=0A=
>> +	 * of concurrent ranges. If the queue is not already registered, the=
=0A=
>> +	 * device request queue registration will register the ranges.=0A=
>> +	 */=0A=
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
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c=0A=
>> index b9588c52815d..144e8cac44ba 100644=0A=
>> --- a/drivers/ata/libata-scsi.c=0A=
>> +++ b/drivers/ata/libata-scsi.c=0A=
>> @@ -1947,6 +1947,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_s=
csi_args *args, u8 *rbuf)=0A=
>>   		0xb1,	/* page 0xb1, block device characteristics page */=0A=
>>   		0xb2,	/* page 0xb2, thin provisioning page */=0A=
>>   		0xb6,	/* page 0xb6, zoned block device characteristics */=0A=
>> +		0xb9,	/* page 0xb9, concurrent positioning ranges */=0A=
>>   	};=0A=
>>   =0A=
>>   	num_pages =3D sizeof(pages);=0A=
> =0A=
> And this hunk is here because ... ?=0A=
> =0A=
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>> index 3177181c4326..cd58aa1090a3 100644=0A=
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
