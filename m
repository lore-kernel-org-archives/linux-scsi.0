Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B16C4321E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 08:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00EF56115C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 08:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbhJOIZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 04:25:21 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23679 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbhJOIXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 04:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634286054; x=1665822054;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=UxDqqvhL3T66I4NYmcnwxoXS+X6QoSCmbFhkQu94Mac=;
  b=fUMjg/aw4bkVkRHGtsjHHXgyUc3X6V1u2BiFBloa9BCEkFeMBsxU22Rl
   8IGfsaLv0SqZmBjPhqIkpuMIII0Qq4f/p1/gZHZ5QnXe8fazgHRg23vPr
   drVFH+XeatMMUI4B67APkcTfOkWw4+Ry51z/AteHuOb8qupuSMPJ8En0j
   lB9F0N+JhtJqDI/iRWo52Mo9SoscP5brbvnmVuodP004a05WWD3iMaVY/
   knm5MG4WF7CPMR1o0i68vdnFnl6GsF8Z7NH8GAE8JvlFVy+nrqcdB6uxV
   BJdLyMAsYDSW71sUp4+yM1IPasi7UPz00k9+RL5qqOayz7xEPzHKXV/nd
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,375,1624291200"; 
   d="scan'208";a="294666461"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 15 Oct 2021 16:20:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtPn6R992zxzvOFNSgcxMFy5FSArrwp4ugZ/J35Fu2tjDSoReiJHXx/QE6HrkZgpGOk3/N/tEhaEMhi7wbZlQPyD8wqe6Ki65UT9F1tXc3fBp+8t8iTHg+GbCodoDpfmzqCxVN1Kfly+d2GOZHtFyQ76I8V49+kPXkSRymKgSCXPvu3vkfH5mrVtsksFovCfiZWrIt2pl5zhRc17exkA918BJpiILa6b93VH+D36SdWOjzHyOkFEf4E0q5WhKTer0Pq6AnVpK9Podx5b/YV+LoULtL4JkVSijlNCK5gQ+cWZz2SN3dB2hpgurPzUTZgrxu17mE0kV1eXOe2ATbZRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTOab49P3VH4xrZ2Gb1dFUAVU4KSO4IwwqzUC02RAjs=;
 b=nDiGQb3pOYJwKjREaLG11gXj/YeSfZR6tlm00/IogcA+D9SADvlHD11iUFNbgX3BpPsnPP9KrQZlL4wJuS8zOYWFaILVcCot6CPTcVJ5o3kXR8LwEOQQ0YoaOJPP71n164oasn7yCtCXK+J6tNPHZMdFyArBrSfXkCpnJ1L2Z3pntLNbEJZCxtQcDM0yQDWPU2Tow5RwkZk8RAWqKesTTF/XFAGR6RRkAWMrRhTx4G8jrohmC2KefejlbGrcOzd/aQq+OQqYSgF3J79irgeNyQr9FQsAHnDnwxRdeIW8b83C9r50333lic9e5fp/ekt3faA0/K7ay4bPYdL7cLZ/4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTOab49P3VH4xrZ2Gb1dFUAVU4KSO4IwwqzUC02RAjs=;
 b=NllnysC7Sj+xT9XvvG1DxoXO/zKsbl7Kl6tNTB5zZV6UEwhEecmefUCqKi4lC0T+myXOQr1CDwfcVf0PUQc2WBXyIbaDUQDFukufHq/10MbvGwVNdHNYkyl1+xTcsN/65NmD/KHqRguf5HBmk8kMoSpjI13OttUWBNYR6lHjQFw=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4923.namprd04.prod.outlook.com (2603:10b6:5:fc::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Fri, 15 Oct
 2021 08:20:49 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::5034:7af4:3e2a:b1af%6]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 08:20:48 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXpSNp1F/8/yl7ZUm+rTQKOyPDvw==
Date:   Fri, 15 Oct 2021 08:20:48 +0000
Message-ID: <DM6PR04MB708152FB28709432522589C6E7B99@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
 <DM6PR04MB70819BAA37D51638C5D8A081E7B59@DM6PR04MB7081.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0d647f8-17d6-4f46-d5d2-08d98fb4b1ab
x-ms-traffictypediagnostic: DM6PR04MB4923:
x-microsoft-antispam-prvs: <DM6PR04MB4923A20DEE4480B7C0BB2843E7B99@DM6PR04MB4923.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vNgqZNkKFk1HeqnM7Yj42KF32I2M/b8cz4RX634Dnf5n85b8ESjiLlEkiVHMx1M2AGNqoMd9j+fq8L7MqLgcAv8g//M3CZ78cwvdwEkkxzf63mr13QFE4R9vNmoYr+atkr1G6To9W4cS49GG4fV0kYcke5HjzfRwgoxbRvhOlaFwFtIUSNctrjVmYPgHAsNAH3hLxaL1YupptSw5Xgot6v8KBstD2/wsUdFQFsTGdlbDmGjTCh1CLlfa0bKmpQjd36KPrj8Z9IPgHiA7EtJU+C0RlvXdB2WfLgCNs1Dl3U3CB9JgflRltyH4ALrjfKvIelJBtw+ZOlRflxNTf3ZV74lUBYVMYTeL50hA3iZpmJJi17oUNe0JRxyXJTsJjbZSWVzy0n1xV8Hjyw26y845yZDc+n4UuSL3YmGRCpQRgwSRnlt2EIJ36edeARoad9X3TldE53XGoU/rx4/XBXVzQG46VG4xUhlVw6EPJGidfXpVEKuJj5778ZkL2iuiFVIZ63vZxDBSqyy4BaIt27Q3MAEV+33d+Ep4cxybYA4hoQnTD1oFH2GZhTbTOmgdCI0LlvKqgTFzLb8kHZRkd27QgRhXok8HAfb5KrkUBIP6bsYXTV7dS0XSfOp+8nIFZZIpV6ZDJs3aVk5fHxqtKGsQ+LYORyng0SHSTqNnn4S8ajmf+DXIWf/evN3RNSpMUPMFt/jQvIsX/DYXX9KRpZ/EQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(55016002)(66446008)(8676002)(76116006)(52536014)(316002)(8936002)(53546011)(86362001)(186003)(66946007)(33656002)(122000001)(91956017)(110136005)(66476007)(66556008)(64756008)(38070700005)(83380400001)(71200400001)(82960400001)(7696005)(9686003)(508600001)(5660300002)(6506007)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7NQan+IFvP0e1+Sw48l/J9KG7LG75W6odnPaqBBZobc+F8IbrNct8FWppC3Z?=
 =?us-ascii?Q?Kf7wZtufQ79WLWAGGIZ3FmETSLultDbuRiIGPvGfYSFD0CyyWh89QGBknVGt?=
 =?us-ascii?Q?Ho0s1Xie5e4sK4JKOLl3pJgkLlDkOjBVn1UaFSTl+KTEOhRpmteKgxWS+ePJ?=
 =?us-ascii?Q?+WKYPOKXP9pWhyutCG/WXBAkjiH3Hd4N+LHBx8EDNBuaXZ4jpGmok1s1n2sc?=
 =?us-ascii?Q?UycDQBnSUn5zQoB5DB8Svp0Ms1WC7u7v4WBG/UO01qdNkgQzlWC1aCuvkLzs?=
 =?us-ascii?Q?LbaIH7+BTHv0YZQ96/o0srvS1UCHAI202pcqXGEbe2QW032T+IuPGxcsltdK?=
 =?us-ascii?Q?AfNDmkpxqkDPFJbIXR4sPK8XhPOGe4uRwYbOj0qortVeIWIoyl18l7XWBtv9?=
 =?us-ascii?Q?QM/vg/kh6nxa5OeDoWK1sykdPx+T+P9hrUFrjjqVtCFAdJ3nBuXiPHJDDnPd?=
 =?us-ascii?Q?4mwW7NamRZfjPqLGF44ic93Vle/UFPQMaFtph18n9wWNe7I7nQWpMVU5F00A?=
 =?us-ascii?Q?eWK3ThvbhQRlaw60lWjtkTnk0AbUqRcVsPPKZjYvcniWjI3oNmr14KhrfOjy?=
 =?us-ascii?Q?MFvlOKd9kd97ZQAevmO/JShR6WTUCpcLzEhr4Ud3d7BTZ80+VhcIOEDKdT7j?=
 =?us-ascii?Q?lxV/QAYhdAA/r9L0G2cNOqK5Du1d9YaPGrwe3+7qv3u6X/2XcirkGbxVIfKv?=
 =?us-ascii?Q?G4RusG6wpIPEFvN6ln9z8phxdUCHOo9POTrMh1Q0oRhayvlmiQ72hIqkgpmo?=
 =?us-ascii?Q?Z5dUg5jzaBA9HmKrxLvWY8WXdQdlVrfS2qfLsvv2zVb9yRvFkyZiANzziL3T?=
 =?us-ascii?Q?ZyARG4r5jd9BGZ3P4YhrPmp/HNoz2Vm3Fxc2RW79r9hpxAuTmbq0UuIFwFvq?=
 =?us-ascii?Q?Lt5uR6ZtsxkfX0cO3tWTKX3E7/rgwvHM42B+/t8BFh8IniEPot0y2fkBrJ66?=
 =?us-ascii?Q?kaK5bX7N+fGnMbVqToFkEvyx3TvNwhIolk1QmaXQPEtDakt/JFDcDfN1Ce7g?=
 =?us-ascii?Q?1CnSUcpjcHjeTpowUQI0gZqyHOG1N555MO9ZjZ4Z77uBtCYwM26i93yo0S+t?=
 =?us-ascii?Q?bEdMR0nKaMwDh045mLf4/WA6dTYLqXY8uBk90HXbSUlcaEFuJLJPLx0ysPwZ?=
 =?us-ascii?Q?5hAwyCfy5SR9iD09MFV+XjfbVdnC6lM/0TzDq4Y2xuwpwHSBatR8uQsQ+njK?=
 =?us-ascii?Q?6g4EnBW0r/kjWArgyIwu79u3+wqY2cSTCznUyb5kjLK9dTraeEap9GwjLnzm?=
 =?us-ascii?Q?xQoJa+w6n0jrbDBT2j03a0HgwLZMk5hDGciPWEJVJAPHYajAiSq2LQF0bxiV?=
 =?us-ascii?Q?GonOWNczvU2scMkhRQFBdmWefkfDMMTMtJQCvXBa8AybFg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d647f8-17d6-4f46-d5d2-08d98fb4b1ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 08:20:48.6583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kvweif6sqJdMGNztS1SK2lZ7KSTG+FC4bJyJmiQ5OYSsS5uy1q807h68mDgd0MGTrEk6IO4F7s/mPtw1tK2kcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4923
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/11 16:50, Damien Le Moal wrote:=0A=
> On 2021/09/09 11:35, Damien Le Moal wrote:=0A=
>> Single LUN multi-actuator hard-disks are cappable to seek and execute=0A=
>> multiple commands in parallel. This capability is exposed to the host=0A=
>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).=
=0A=
>> Each positioning range describes the contiguous set of LBAs that an=0A=
>> actuator serves.=0A=
>>=0A=
>> This series adds support to the scsi disk driver to retreive this=0A=
>> information and advertize it to user space through sysfs. libata is=0A=
>> also modified to handle ATA drives.=0A=
>>=0A=
>> The first patch adds the block layer plumbing to expose concurrent=0A=
>> sector ranges of the device through sysfs as a sub-directory of the=0A=
>> device sysfs queue directory. Patch 2 and 3 add support to sd and=0A=
>> libata. Finally patch 4 documents the sysfs queue attributed changes.=0A=
>> Patch 5 fixes a typo in the document file (strictly speaking, not=0A=
>> related to this series).=0A=
>>=0A=
>> This series does not attempt in any way to optimize accesses to=0A=
>> multi-actuator devices (e.g. block IO schedulers or filesystems). This=
=0A=
>> initial support only exposes the independent access ranges information=
=0A=
>> to user space through sysfs.=0A=
> =0A=
> Jens,=0A=
> =0A=
> Any chance to get this merged for 5.16 ?=0A=
=0A=
Jens,=0A=
=0A=
Re-ping... I understand that you are very busy, but nevertheless an answer =
would=0A=
be appreciated. Thanks.=0A=
=0A=
> =0A=
> =0A=
>>=0A=
>> Changes from v7:=0A=
>> * Renamed functions to spell out "independent_access_range" instead of=
=0A=
>>   using contracted names such as iaranges. Structure fields names are=0A=
>>   changed to ia_ranges from iaranges.=0A=
>> * Added reviewed-by tags in patch 4 and 5=0A=
>>=0A=
>> Changes from v6:=0A=
>> * Changed patch 1 to prevent a device from registering overlapping=0A=
>>   independent access ranges.=0A=
>>=0A=
>> Changes from v5:=0A=
>> * Changed type names in patch 1:=0A=
>>   - struct blk_crange -> sturct blk_independent_access_range=0A=
>>   - struct blk_cranges -> sturct blk_independent_access_ranges=0A=
>>   All functions and variables are renamed accordingly, using shorter=0A=
>>   names related to the new type names, e.g.=0A=
>>   sturct blk_independent_access_ranges -> iaranges or iars.=0A=
>> * Update the commit message of patch 1 to 4. Patch 1 and 4 titles are=0A=
>>   also changed.=0A=
>> * Dropped reviewed-tags on modified patches. Patch 3 and 5 are=0A=
>>   unmodified=0A=
>>=0A=
>> Changes from v4:=0A=
>> * Fixed kdoc comment function name mismatch for disk_register_cranges()=
=0A=
>>   in patch 1=0A=
>>=0A=
>> Changes from v3:=0A=
>> * Modified patch 1:=0A=
>>   - Prefix functions that take a struct gendisk as argument with=0A=
>>     "disk_". Modified patch 2 accordingly.=0A=
>>   - Added a functional release operation for struct blk_cranges kobj to=
=0A=
>>     ensure that this structure is freed only after all references to it=
=0A=
>>     are released, including kobject_del() execution for all crange sysfs=
=0A=
>>     entries.=0A=
>> * Added patch 5 to separate the typo fix from the crange documentation=
=0A=
>>   addition.=0A=
>> * Added reviewed-by tags=0A=
>>=0A=
>> Changes from v2:=0A=
>> * Update patch 1 to fix a compilation warning for a potential NULL=0A=
>>   pointer dereference of the cr argument of blk_queue_set_cranges().=0A=
>>   Warning reported by the kernel test robot <lkp@intel.com>).=0A=
>>=0A=
>> Changes from v1:=0A=
>> * Moved libata-scsi hunk from patch 1 to patch 3 where it belongs=0A=
>> * Fixed unintialized variable in patch 2=0A=
>>   Reported-by: kernel test robot <lkp@intel.com>=0A=
>>   Reported-by: Dan Carpenter <dan.carpenter@oracle.com=0A=
>> * Changed patch 3 adding struct ata_cpr_log to contain both the number=
=0A=
>>   of concurrent ranges and the array of concurrent ranges.=0A=
>> * Added a note in the documentation (patch 4) about the unit used for=0A=
>>   the concurrent ranges attributes.=0A=
>>=0A=
>> Damien Le Moal (5):=0A=
>>   block: Add independent access ranges support=0A=
>>   scsi: sd: add concurrent positioning ranges support=0A=
>>   libata: support concurrent positioning ranges log=0A=
>>   doc: document sysfs queue/independent_access_ranges attributes=0A=
>>   doc: Fix typo in request queue sysfs documentation=0A=
>>=0A=
>>  Documentation/block/queue-sysfs.rst |  33 ++-=0A=
>>  block/Makefile                      |   2 +-=0A=
>>  block/blk-ia-ranges.c               | 348 ++++++++++++++++++++++++++++=
=0A=
>>  block/blk-sysfs.c                   |  26 ++-=0A=
>>  block/blk.h                         |   4 +=0A=
>>  drivers/ata/libata-core.c           |  57 ++++-=0A=
>>  drivers/ata/libata-scsi.c           |  48 +++-=0A=
>>  drivers/scsi/sd.c                   |  81 +++++++=0A=
>>  drivers/scsi/sd.h                   |   1 +=0A=
>>  include/linux/ata.h                 |   1 +=0A=
>>  include/linux/blkdev.h              |  39 ++++=0A=
>>  include/linux/libata.h              |  15 ++=0A=
>>  12 files changed, 634 insertions(+), 21 deletions(-)=0A=
>>  create mode 100644 block/blk-ia-ranges.c=0A=
>>=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
