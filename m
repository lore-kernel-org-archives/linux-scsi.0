Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A352C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 23:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D58660EB2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 23:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhGVWkR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 18:40:17 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:27587 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGVWkP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 18:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626996049; x=1658532049;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=mJQGzSl13QWbMQh8nr2qzmzuCMeJdvHkinTm6KLi4w4=;
  b=XxGnm/sj4SjVAEieUW5Vk7SwrFoF+3aHDvq2vjuewPf9WQ9hxC2DYL8x
   M4zzU4FudRjp9NchiHN564dPw+5uN0t7P+rWNoBymVKPU6dpxS5f+B6rX
   D+n+x8Sr9mkNhGIbYovHYA68uEmLZWKEKGdsNP/Xo6TT5D/uuZQLNDIdh
   cJrQas/nJR/wlcQ9o1lGT0cUJpK9YIYWom2qFkL8Txtfx/0DiKB1RLfk5
   n0bw+EqYCB2ouu01MeqqNUQeu+okxOTWesgEq12d7oQBF2qc9JAZu1m7c
   XarC7rECJOK4ddDtXDkagn8Uw8kE5xOc4/vPuKPYHiWe2vFt44fb/BN04
   w==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="279113459"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 07:20:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8KVhklgPfhuPzEIG1aj9N4xBg0/1ars4yr1PzsHxmiFh+MvttMPK01Myh15PRl11UAjSbv7PB+m8nr4/uOoJJYN2w7d+kJW5S5De6Pj44bA4A+3sWhaCmLPOX97hdK8WfsQlJPdVCLIChcERNgBZhXfPpMnH5FnadS0kZNZPVAsnfWq2JZ3hqf0r5UGGPCh8VlniOvHfrlLFgy+dqdR0Gc9IL51ZeGjQicqGlZmDMjTrBM35W8MbH0jketDU09niB/AdKcnr9BmReJs1/687v7hGsYCNVlFqJfcvx1Js8TUyU3FGREG70WDb2l2YjDzUz6+B2Tt3BzklVbUNS+EuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2USIcDjls+/u17cAYK4pkeUprYyyu+i5b7BlxZHmp8=;
 b=KpUpZIXYS8An1zs7NOBdAQOy05iUOWsoXqLVYZSWSaVVpw4nP+pzXel80B84Nwtml5fxEdoAcVsG2kwAD12VJ69n0A/0S9TR5ka/Je1WSW3scS24palv/JblAHxJIGVIE94cJReAMlLhu1dwPhUDzABLn0Pr/HPxqKqJoC98CyYJmBTrLBd5ez2Pw5Q5a1WO982wau4ZvKcA3o5kCrLY4OD/nz8wHEnsamizEeaj6NIB+fsBsheW9v1WtEpKxz3ez1BxbsFCxID7ICfF0tTvTllTDxdNZTrPrQAFyiofoFtCQlaFGxUg3x/G9ilzLf/m6/v+uS7R9V0E6dFN+CvMXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2USIcDjls+/u17cAYK4pkeUprYyyu+i5b7BlxZHmp8=;
 b=E5cvGT9NnCXAer9P3dG5S+hQcoOx//Go7oJMITjE8gqpTPO1HpunjMEB1A2wyylJmI03prz7avvsnsBbxpx5WVIMAjtsH1LK5CkgkUKnmoSgNT15eRodrmhX+840R3FzeqYlKNodwooKaq7ipOfUMQBAvTRCcTMZscqwXHPBack=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6940.namprd04.prod.outlook.com (2603:10b6:5:241::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Thu, 22 Jul
 2021 23:20:47 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%8]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 23:20:47 +0000
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
Date:   Thu, 22 Jul 2021 23:20:46 +0000
Message-ID: <DM6PR04MB7081500741A0DBA7F0731BA7E7E49@DM6PR04MB7081.namprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 5aea4822-e57f-49ed-78cd-08d94d675616
x-ms-traffictypediagnostic: DM6PR04MB6940:
x-microsoft-antispam-prvs: <DM6PR04MB6940306D2978B415E412E361E7E49@DM6PR04MB6940.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VsnnfEgNAk/gWiGlv0hPrvk19RLu/o0qLiFGUTUteVAQ+eXGahxQy/APEWcdBwG2j81Uohjwyb8DK9GcU6wOnnm8HNC9UndKjSbRknBpTV9s4Go6fySlOUhrS71EZeC975Rcdv8Kqn4VT654ydzfZpDsMC/WIpDNXMXjCmqqDPwRv92W4KMnF4VHzBpUsq5Yx3LusikJSOI4icbyJi20CmVtbWdoWKNPs119KMfdSjMb9jNOOeQPll6T9jVfboV7C0Zt5UgE3+yW2ax22EyuTz1Exi8Gy1iZdU4lGMOglTrP31LjLLj59+0+ufbMlTTeRD3q5+XZSoIdx8fWzUiQHKHkjp+SDVWQQRTNUK8fQhki+7dXiSaez2+7bsygtOwX4VoUnKR9jvIulGH3LRFeVsvPwYjlcplGI4vHAPW9f5NvImIAfhqj0MwCwAGZfHTVdf3h+toiDM3ZBqpHyGdD7br3oAqDXxUZGlEUOm55hGveg6V5NYsrP5HbIu2ywSyqd9TLC055wjskHDxqH14ZwaHpWhgzQgaRzTkgT9/4lfpTvtyZeivgK2Nkon0uLANaVKKvxFxICdS/7snzWWVI8umiQAF7+n9SlFBXsp3rlZ3fyVfuvn3wuMbtDN9R/aXEARNNl7nfqQmiH87IwkVZdFktW6ZdfSOMOQ/jlseOEC/r0pbJ9Rx4lhj4O+stEJ842THVTTa36QxWFIB3pqNmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(5660300002)(30864003)(71200400001)(53546011)(8676002)(186003)(122000001)(478600001)(110136005)(33656002)(8936002)(64756008)(38100700002)(86362001)(66446008)(6506007)(66556008)(2906002)(7696005)(91956017)(76116006)(55016002)(316002)(66476007)(9686003)(66946007)(52536014)(83380400001)(38070700004)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g1o4lBBqKb56X85w4v+3K/EK1WW6fNEr6ubqeKnoOsBiFpyMkTQoP2EZnQeZ?=
 =?us-ascii?Q?+tHofDNgp4ASG6MZVV9GecYuMnFE+r4U7OOHwtzS2/wEO2FSWHW4sEKiwieC?=
 =?us-ascii?Q?Yl7zFJQEapBMDZx//zR32nBWmhSljCLRqKi+43xCssZ9mtPa/bBD1wvisUhB?=
 =?us-ascii?Q?T1LCfBLXqHXmb0c/owzco20U806hYVXkCm4vyRtcsQgfOudEbL7cX2+y/kmc?=
 =?us-ascii?Q?NUCsFXk9CGrdwd0ysiJcvi44ERZ8AgH5eCZrPC6vapVK7/4uFniO/5thlzFX?=
 =?us-ascii?Q?FeAvRUoTQc6aHA1N4BPq3oHmmaH68WF2tFqCT4lgFnHGVjWva6dY3hAjan0y?=
 =?us-ascii?Q?oNol/3fCHURLc4min2k1O9WDS8jOKaC4a5uVx3QUFkHQykQ21lzntY5chxew?=
 =?us-ascii?Q?RKcviuz9UIn/gQ8SsZyoIM79dQYIA84Sj+73jXP+wD2rRit0s6H/xGtX9bno?=
 =?us-ascii?Q?V5Y8pBNDzY8HP+1gvhQELEHCqypHy8erk4HJ4OE0950gjE798FLstSp+rdvQ?=
 =?us-ascii?Q?NMLio7mIkxJqxJ5j7qSVs5rJHpUnyVpD6izjCmJBOiehPhguwD2orA86LUod?=
 =?us-ascii?Q?PTaqTjW+PxAiUpjtM/U02LtR+Mj6X2P/FIigngJh2Gu3QJSI3hBbXg6RG5fk?=
 =?us-ascii?Q?MZeTQ2CUxrfYxNSAQeB/SYu6h7MFfAzPJZzzra8dY4kLi6DV0phswtyyXd8C?=
 =?us-ascii?Q?rpLKejgdxCoAaTV3XELpJ8aghtfsyyVS0+NPlohEI7wkXBYBDJ/arHctCZan?=
 =?us-ascii?Q?KhWjTh1DeVTBQw5TDqlDduh4CYzIlKLuP4h0b9hOY7bKkZFcGrkXU969muLk?=
 =?us-ascii?Q?YhjoExBiVZByXyP/O5RgzL2LRMxf/aI+aLZBeRTOtmAEnsl1pSbcxSZq0+dH?=
 =?us-ascii?Q?HebXsV3GreNCdDGImp/B82bYHfpaKvjfrUNLgy2fOIObMB7nQ+C6+/+PXD3Z?=
 =?us-ascii?Q?dyhakCgCwfsU33ZcPQazpsl0eEv9JkX7khKHY0k7GdMtWXBMWcKh7C2CX6zP?=
 =?us-ascii?Q?ocD04NNZMsYfDMDDexZjmrZxRqMR+gOF1kacjbA+anbjLwXZ+f76AzWQYXmq?=
 =?us-ascii?Q?Nc4et1ioHARdrP9OyGrmZfTzcbK0XvsYncc1G88lY1LBrOkqBxEaq1lPjlAa?=
 =?us-ascii?Q?okTbv5QSqBXXj4LYSJoAZ/a4c/wimaoM+zk/tt5Zynnry1ps5hZoU2EMI7gl?=
 =?us-ascii?Q?KfcCCVLZNvOcU7gGe3lWokzu2KN0XglMgKXqmlMdSH2Leq+4uYObfkdtLgwQ?=
 =?us-ascii?Q?rrMhB335E5Bncog8pZhZql+PWmkpi+BMjYemVWjl8Xlw60AcGH+gzcgxxFnm?=
 =?us-ascii?Q?5yOIO1CoAU+7rp3OcU5WYw4Oeo17LZL3WH2299OxlYvgqRm0BBvH0HD+PyPR?=
 =?us-ascii?Q?iYYVv/mGbhDDPlH8we2y1503r3Nzvadpexv0l9XOFB2Ik9L69g=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aea4822-e57f-49ed-78cd-08d94d675616
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 23:20:46.9575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I/37GZUq8nHRznaWf9zGVJG5vNBZUrqgM2uqNuHz4pJII6szHETsXM3xI5w8sdX3nGAfpxdZLJcN54ROTVZBaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6940
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
Indeed, it will not. Except after a reformat that change the LBA size or th=
at=0A=
depops heads. I was also split between what I sent here and a flat list. In=
 the=0A=
end, I went for this one as I think it is more elegant and also allows simp=
ly=0A=
swaping the old cranges with the new on revalidation (more on that below).=
=0A=
Otherwise, with the flat list, we will have to mess with the visibility of =
the=0A=
ranges OR add/remove attribute files to the queue sysfs directory when some=
thing=0A=
changes (and the number of ranges can actually change with head depop forma=
ts...).=0A=
=0A=
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
=0A=
Which is what blk_queue_set_cranges() does :) If the new cranges specified =
as=0A=
argument has a change from the old one already set as q->cranges, the old o=
ne is=0A=
dropped and the new one registred in its place.=0A=
=0A=
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
=0A=
For the structure lifetime, no, we do not need separate kobjs. But with sys=
fs,=0A=
one kobj =3D=3D one directory. SO I have these for the queue/cranges sysfs =
directory=0A=
and its sub directories (one per range). Note that there are no kobj_get|pu=
t()=0A=
for these. It is not needed. They are only for the sub-directories.=0A=
=0A=
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
=0A=
Yes they can. The standards do not forbid it, and for a good reason:=0A=
split-actuator drives vs multi-actuator drives. These two terms are often u=
sed=0A=
interchangably, but they actually refer to something different:=0A=
1) Split-actuator drives: On these, the head stack (actuator) is split in 2=
 on=0A=
the same axis. This creates 2 subsets of heads, each serving different disk=
=0A=
platters, so different LBAs. In this case, there will be no overlap.=0A=
2) Multi-actuator drives: With these, the drives have 2 distinct actuators =
(head=0A=
stacks) and each stack can potentially access the entire LBA range (all dis=
k=0A=
platters). In this case, the ranges for each one will be the entire disk=0A=
capacity. Which makes reporting that rather pointless I guess, at least in =
terms=0A=
of optimization for the storage stack since we will be better off having th=
e=0A=
disk do its own scheduling in this case.=0A=
=0A=
So following the standard, both are allowed here so I only check that all=
=0A=
sectors are covered. No check on overlap. File systems or IO schedulers who=
 want=0A=
to optimize for multiple cranges will have to be careful about that.=0A=
=0A=
> The only way this could happen is when a given LBA will be present in =0A=
> _two_ ranges. And this is valid?=0A=
=0A=
Yep. Dual-actuator case.=0A=
=0A=
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
=0A=
Yes, we could. But checking for the change is trivial with this function an=
d it=0A=
will return true most of the time. If it does, nothing is done and the cran=
ges=0A=
structure passed by blk_queue_set_cranges() is simply freed and sysfs remai=
ns=0A=
untouched. I prefer that over constantly changing the cranges structure for=
=0A=
nothing. after all, revalidation is not exactly a rare event...=0A=
=0A=
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
=0A=
It is redoing everything, but only in the case of a difference between the =
old=0A=
and new cranges. q->sysfs_dir_lock is taken because the structure has=0A=
sub-directories in sysfs. We would not need to take it with a flat list of=
=0A=
attribute files that are updated, unless the number of of actuators actuall=
y=0A=
changes. In which case, attribute files would need to be removed and=0A=
q->sysfs_dir_lock taken. Or we need to muck with attribute visibility, whic=
h I=0A=
find ugly personnally... But if you really insist, we can swith to that.=0A=
=0A=
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
=0A=
Oops... That belongs to patch 3.=0A=
=0A=
Thanks for the review. Sending V2.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
