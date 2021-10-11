Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438CFC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 07:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C12C60D07
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 07:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhJKHwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 03:52:14 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21838 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbhJKHwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 03:52:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633938613; x=1665474613;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ya0Aiu3CrD5oGOZzsd9aGhtzcbljnrhklKa9oax3clI=;
  b=WDa2slFW1HcqywfyuBYHDc1WIx/htLW3LcbP2euIm+w3ihJHqdIaVxcy
   fEvX0DBe3Fph6rxQANLGc/K5bZfl3Xe8bWfSelg7Ad86TCRFi04Z0i8m1
   jOmhp2USBaAzCfYmuuCu/BDOEIyYAq3ncJljIdtAmKhkU1zFEf8nvPVuE
   esYyBQjqvIy9RmNe92/06m9+B52RNyxPmZjgG+RjsDtwf2jJ2MoWvd69B
   Um3csQnOcADr1TXW24o8MGkK7Ny4I/xmiqaoo2yAB0QJWjYmFYdAUtPP3
   8FQfRSo9Kc+oW0gn8BDcVOqMUTz99Go/u23DEaysDCG+khRM8p1RbTM4x
   g==;
X-IronPort-AV: E=Sophos;i="5.85,364,1624291200"; 
   d="scan'208";a="187242654"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 11 Oct 2021 15:50:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXjaGXOkc6jR2ldNQU4zozGLIwjl7j71awJZwK9k0wDW1xSvZ6zR5WXMG4WQj/M7RIRpoQMwqndGzdkNGuYuFWbQI95Ba77zFkWn5BcmSe+S7QkpXwVxnZS9GGJZUb+5JtxiqDsBCAAiKJi06cMQ8e2CqnfqL4WSU/wPnS5kRl4KxUMfA8KuZdfuUrJ1+H8h9uxPCehfJo5ojcU/wD+KRiEyCWvboOQ12AiVm3sQRGYYFIk/z+K8FP6NLYSQYHfnaCULjcSHixsY1/0mpWRHkHsv8422cbjChEm3jGHNdIhKPeymNtR0LceDn4c2o63SJ++8d1FcqAwn/eW83dvzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U/6TY2m+/vzIXvk2fY126nWDzDNlWiplCEARXoOwvLQ=;
 b=PCbHNyq5ogAxgSTwCiarQi7vLE6xCHmhmbIekUboe0yIHOSV+nBZZwSzOIIzyevCURG1ooxE5zlEH0qTjJWK5JlujeeI7om97nC35v/hy4+pvkL3tBxU2eLns0nIGg8eD0zIKeq2kesYCyx8SW8cGybg2nRZF031x7yKjSlsGkMNR8RZOds8TY3ECAMqrRjiJUxkVYGem4hYA37F/b8O5AKqDNZhNhGGLpZNdlkEFnZZp0S9r+wd3uBd/wna+48xV5X1ykqUWAT0dtNd51L/saaiH7Z92LVqY+vpwZBbYX2FiDp74iGsolOehWciIBigZpePgwoNoot7VXBr5F1hbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/6TY2m+/vzIXvk2fY126nWDzDNlWiplCEARXoOwvLQ=;
 b=hJkhZ3W253fBFd76MfXwFRLQKTmNaTnuGAJfUBRm2joqqRhB8g2X08rHfFufaIMiET+VzG8oiM1hXyaDEFhdRiXPoUeoQo5KX4bsggA61NQeGAls1Q6j/+KMQ7kIvR7DfILdrDxzqqq8pzbfvpMXWgdUC1qeom2i3yC0sqXbQUs=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4924.namprd04.prod.outlook.com (2603:10b6:5:f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 07:50:12 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%8]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 07:50:12 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXpSNp1F/8/yl7ZUm+rTQKOyPDvw==
Date:   Mon, 11 Oct 2021 07:50:12 +0000
Message-ID: <DM6PR04MB70819BAA37D51638C5D8A081E7B59@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d72c6fa-6d3f-4926-ce38-08d98c8bc195
x-ms-traffictypediagnostic: DM6PR04MB4924:
x-microsoft-antispam-prvs: <DM6PR04MB4924BB077EE24E376F93EB1CE7B59@DM6PR04MB4924.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CenTn+57S7D4wFqvbkZ2BPUFZbsPpKKPaUxQU09HNgXLlQJeolDX47k9QezAK8cuoqVCVnMwwwqnpCAGNZ6o55ukS9WwpC5JOTZ0F8MZIoovn9wy3fE+PkLdvdaJv4lXlRh4nTDuEZeBzqHAQqRNseDNW/EC8MM0T92ACIFdS28rUl2d39+rbth8RVDwM3Z5+bzJe1sSupgi7/YPLvprXkCTuhAquKIb6aVzItcClMX8B6bCEjlYM9Psor6aUDMG38jpMtvxsope/F9K2yrltIe6ExoILrNs+gra9FosqL1x0Ww1Sk4tFkN/Qq2/A4MWkFapFwWB43S7O36dHLR/Oyqlyl+m4L1RJ37bYBrQ4DoJPOrYLCLMZK3TUZWXP+xYNqfvQP4XNeBa4jbFpYTE+N51FzoUftXEmH2CLi/hCVnEwn0AQWTQsILr7OA27151xNJD1gNvp7w05DW8bFtOe9wNPGG0fYM1VraetSU1YPJzVRT6onqSrXtYlG0kmgDhv17xGc+Wu0pYg9SIyxeX1XwNsNFax4HSKDl6NoHLhgMuFnK9x1eCGqIAKngYWEuX3ybFz1MLROkRrE29YTe5MMOZ58OnQIvPyPcz9SOwg6r0IXRw5l5UsU5I7e+KpRFfJzQPmh+WVv9pMMrmklsR9m4QERgZIS19grCxIksUM6lDmBoJuQnwH1iJAfTY/G6CFeYRge4+TFIjrU37UvF79A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(508600001)(8936002)(66946007)(76116006)(66476007)(66556008)(64756008)(7696005)(8676002)(186003)(71200400001)(66446008)(9686003)(122000001)(6506007)(53546011)(55016002)(52536014)(86362001)(83380400001)(38070700005)(2906002)(38100700002)(110136005)(91956017)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5UngSSK/zvgnulN/Pk/C+lesw0QS5h2lVLHDTp7V3C0XW9mclQhOtUtd+dEU?=
 =?us-ascii?Q?XS6UwYKdNS2n4pUi+LsT+XcAf0k29AJYvL3VxQsvChgQ1EGchr7gwnEYr0Jd?=
 =?us-ascii?Q?YPOsvbGPzIMEKoLKlh+QViW0EQMwWte7DATe20WjJYFmCjGPFMCQQCY7/I6b?=
 =?us-ascii?Q?RGhXvG5aIvZ0UidOq16bQk8opvFWt9n5Tvr82Wr35ZfZhZmJYTL6Tp7ALnw2?=
 =?us-ascii?Q?vTEer3IuT4PIsqPAymwX7HNO/dwNYnV6jbI6Vz9W5s1dtZg0NcXmrdz0F0fM?=
 =?us-ascii?Q?PYrmDxca85LNxKy7celWnnA67iUTQtUX35cPQhzIk0QdocO2NaMS186nTrZy?=
 =?us-ascii?Q?8/VbRCh92oEZXdnGJc4yr1yhD1cDylAeNypyVAsHYBEmk2QJy28LLw8yV7MJ?=
 =?us-ascii?Q?WWBC2o4yMEq3Wihn3jJT5Pjtw9LIKTw3jZDC2YAJxvp4L2a8jULrbffEVpu2?=
 =?us-ascii?Q?CZx4Ga8wkQRVxiXPwrmjy4Oi/R+JPEI5SIy3owA6Pd+l3l7BVF+4eHKbEQVU?=
 =?us-ascii?Q?Z66yGvdh+BMaOitaszalbiQnX8rvcH2yFTE42VGVzwvWGT5IpRAMwS0EEZjF?=
 =?us-ascii?Q?GgaDBcMNNZvHJFMTQROwnzJ+RaRHZ1UYj/gRZgl6NtJWLvYqhNlc0tMEqaAe?=
 =?us-ascii?Q?sc/ffMVigj1jjD/T+Is3eJxAObpFybBCZpMebHIrheSOCxZ5pT2lIhI7Gt0a?=
 =?us-ascii?Q?PDxNbxcppecPKQ65bs8kG5FmYA6HIpY9hyhMkzd2JBgJMCWIhULrK2XvZHBl?=
 =?us-ascii?Q?AZWcgdBV4HhHoKL9+0zV35tD1X2denDSTDLPQdDG7QdarB41S1BYgeEG661O?=
 =?us-ascii?Q?Oe5wCQq5ywO3oW4OtDtvKkWaf3EPhOorOz3GQh/fYV+RxAHYJNXwbje78R0W?=
 =?us-ascii?Q?B9B3bleYolJBzWv9eRUEYkzqem8sVX7qctOyejppvFg5pzM+BWm6VzB+TrGe?=
 =?us-ascii?Q?FTXgpotNR/APX51W9JQdkBPm6UCDiPggPpNxLYGTJL2B5TqM5sBYHWgtjK4/?=
 =?us-ascii?Q?nfEzmogR2rc5yLx61OvfelklZ/+a6G63C1GJzIodsT/g5xunVNpSM33Pcjad?=
 =?us-ascii?Q?vJ7QMXQVZ/b6cF6hzKzyiFtLcPYexbYFfu2m7IfaCPh0F3Kh2zuppOQD1LRk?=
 =?us-ascii?Q?gOYY/bv7NIhkX9+VwtmdyveQC5cRv68wGKx2q6jbeqgR6zKpksrSl6FJUhi4?=
 =?us-ascii?Q?4c7l6OAr5A6DgLr1RjrJxQ9NxxYZH9gNBAhxo2WJOp9GH1SdBrjq0hGC04Wy?=
 =?us-ascii?Q?Ec7rN0ZWnRO4/9gFHHR+ADsLtZiCU6wwoth9/PMNCJfJJnreddiMiF6eKcWz?=
 =?us-ascii?Q?gJFyWR7/Wdg+Lb5+PdoDmhVgBdU+5+ZqZ5SWcfna17FNNDbdR8MANAP565dJ?=
 =?us-ascii?Q?0xgsDq9vmomOwznDTF1RWCeLGcJorCEL9www9w+4kITSqKgRoQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d72c6fa-6d3f-4926-ce38-08d98c8bc195
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 07:50:12.3986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DoDdoj/+bvZjJGiAPM8wGP4P3X81oLd/xQJPPi8bBb+L7nYAqrjkQ7cPbkrWIPLvXmPkOZ7L1XGNTpsYzWT6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4924
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/09/09 11:35, Damien Le Moal wrote:=0A=
> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
> multiple commands in parallel. This capability is exposed to the host=0A=
> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=0A=
> Each positioning range describes the contiguous set of LBAs that an=0A=
> actuator serves.=0A=
> =0A=
> This series adds support to the scsi disk driver to retreive this=0A=
> information and advertize it to user space through sysfs. libata is=0A=
> also modified to handle ATA drives.=0A=
> =0A=
> The first patch adds the block layer plumbing to expose concurrent=0A=
> sector ranges of the device through sysfs as a sub-directory of the=0A=
> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
> related to this series).=0A=
> =0A=
> This series does not attempt in any way to optimize accesses to=0A=
> multi-actuator devices (e.g. block IO schedulers or filesystems). This=0A=
> initial support only exposes the independent access ranges information=0A=
> to user space through sysfs.=0A=
=0A=
Jens,=0A=
=0A=
Any chance to get this merged for 5.16 ?=0A=
=0A=
=0A=
> =0A=
> Changes from v7:=0A=
> * Renamed functions to spell out "independent_access_range" instead of=0A=
>   using contracted names such as iaranges. Structure fields names are=0A=
>   changed to ia_ranges from iaranges.=0A=
> * Added reviewed-by tags in patch 4 and 5=0A=
> =0A=
> Changes from v6:=0A=
> * Changed patch 1 to prevent a device from registering overlapping=0A=
>   independent access ranges.=0A=
> =0A=
> Changes from v5:=0A=
> * Changed type names in patch 1:=0A=
>   - struct blk_crange -> sturct blk_independent_access_range=0A=
>   - struct blk_cranges -> sturct blk_independent_access_ranges=0A=
>   All functions and variables are renamed accordingly, using shorter=0A=
>   names related to the new type names, e.g.=0A=
>   sturct blk_independent_access_ranges -> iaranges or iars.=0A=
> * Update the commit message of patch 1 to 4. Patch 1 and 4 titles are=0A=
>   also changed.=0A=
> * Dropped reviewed-tags on modified patches. Patch 3 and 5 are=0A=
>   unmodified=0A=
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
>   block: Add independent access ranges support=0A=
>   scsi: sd: add concurrent positioning ranges support=0A=
>   libata: support concurrent positioning ranges log=0A=
>   doc: document sysfs queue/independent_access_ranges attributes=0A=
>   doc: Fix typo in request queue sysfs documentation=0A=
> =0A=
>  Documentation/block/queue-sysfs.rst |  33 ++-=0A=
>  block/Makefile                      |   2 +-=0A=
>  block/blk-ia-ranges.c               | 348 ++++++++++++++++++++++++++++=
=0A=
>  block/blk-sysfs.c                   |  26 ++-=0A=
>  block/blk.h                         |   4 +=0A=
>  drivers/ata/libata-core.c           |  57 ++++-=0A=
>  drivers/ata/libata-scsi.c           |  48 +++-=0A=
>  drivers/scsi/sd.c                   |  81 +++++++=0A=
>  drivers/scsi/sd.h                   |   1 +=0A=
>  include/linux/ata.h                 |   1 +=0A=
>  include/linux/blkdev.h              |  39 ++++=0A=
>  include/linux/libata.h              |  15 ++=0A=
>  12 files changed, 634 insertions(+), 21 deletions(-)=0A=
>  create mode 100644 block/blk-ia-ranges.c=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
