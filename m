Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E550C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 00:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B8D6103B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 00:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbhINAkQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 20:40:16 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18048 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbhINAkP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 20:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631579936; x=1663115936;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zbwZm3P0HTq1CYomwPwg7iRzcA8pkVxz26ib3wULEnQ=;
  b=lZJ2vY7K3B7DHo3Yo5TFoY+Y2GI3mIaz7gcUe8aGaOwrOjVYA/RGuBmF
   g+rOiTynxRqNLYHKV7YqvTemHFnOyRuCHQl6YVtV4jsCYUGxPDj6EX0Bv
   LOGSFs2EvtfE1IgwW+wHdKLRpISV+U1IdqCi/8VdOleGd/5vkIdENvr+U
   FM/bPTjgzyiJbHTw7LqUQfthr2yQIqBCIpz3WCRHuX+Okp5tbr2doajMm
   nKGjfutn5ozoZcdTm3PrJfkc5mFbQ0q0/Gl9gE8/HZMhOlZv4bXe5Hph9
   +wFvHTMH19vVgx6m1OsaN1ZUDXjng2X3wYMEq7wyXxdppEPQM44+X+Kpq
   A==;
X-IronPort-AV: E=Sophos;i="5.85,291,1624291200"; 
   d="scan'208";a="179905457"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2021 08:38:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YB5CzL/ecTgN9XrkDP00kcJfUxT/KpLatU+2JofQgV7Dmg/v1yxgfeupMQ/XZMJ+0y6KdXlCha7CpH3QgXOF2ryICLrkKa3BJwX38lhzFhtrw7YIqnjtU0HPpo0iOe07MFK8eIlGsYCpbhZQogSYMk5ah1+ThDD8sTYiWjoLuodsk0KcKCRPPM1lQ8PGDdcJCSwVDoS47NqZgsgcbEBEpirEZLg2Q+xPNzrdDr4pH1VE6IFFITkxjM65qqwEUjkIDWWFv777tIlMEkCcKsMQKGPSs58uQmTzzIDR1SZinpDiHL8qxMZ2fyclr2NiyxrqZn9U00cT3DHzv62j7wM9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=spwsd7Bez9m7ypWvOeVSaA0WesD8Vong4FGZKU2pqIg=;
 b=Szw1qYCFlVwlUKofXYH8LjhgejW9ikJEh53QCu3LgSVpVR1vymiiMfxkpl42ywvrFKmYEUjZ9+/4N/YfQ64NRDbWsIJuUGcI0dv4FtO8i9vIy6SPcGB0ZSASmA0rioYFys0R0anUU4bLjNjjMeoDq5Fnh+Vby0238eHMLnNGOgs+r+8hQOIq85H+BJquNM+SNM31koQHgj6ii7YbPfDuNYl4+XYfBm64uiwO5kY05CqPRW912U1ECgQ/lLq1YoFhcCgnOLdnibguNgfoHdo1R5FdBDDscsjIgtLpNRHgpZBlIJ3iJsZFdTNU5eJ0FKsZN+3/4YriB8Q3N5H8BvVT4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spwsd7Bez9m7ypWvOeVSaA0WesD8Vong4FGZKU2pqIg=;
 b=CEncH2OiiRoRlfF8u+pG3iM7tEOQUD7R/iRGvFhKrJ9SEUyndfPlPuGHQEfZltrK8HlQtm4FE+rgbnzvAsf6mffy8mYktvmRHMZ9oRHXpah3XFC7Y5SRGM9qxSwGCb8iRHv5oQai9JNdr+zMG+/Y2Gi3eKXIFzQ7Dolb1x9ZAqY=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6777.namprd04.prod.outlook.com (2603:10b6:5:24b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Tue, 14 Sep
 2021 00:38:57 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%6]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 00:38:57 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXpSNp1F/8/yl7ZUm+rTQKOyPDvw==
Date:   Tue, 14 Sep 2021 00:38:57 +0000
Message-ID: <DM6PR04MB7081FA3D112B77D86CF4126FE7DA9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 742ec288-f99f-4bdd-70f4-08d9771809af
x-ms-traffictypediagnostic: DM6PR04MB6777:
x-microsoft-antispam-prvs: <DM6PR04MB6777FADB7FE6D54B6621413AE7DA9@DM6PR04MB6777.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fAeBsKnEyD38zwJYSCx1+IVr3jZI6yjW/t2bafGeiTGlMLbROeH5/L+VZMOvKDgYevIJjSOokr2bBvqxTVLPf59toavQec8qluHu1bArcfAINcxShMSui4lHkYCSYwGXAU20tPgvHGXJ+GDylSTN8cLpoWGC1eRVCSuVqKKNA9938r12qwKRwKCMRU5Hn40JMlkY0SkHYXJs2enRg+m16UgzC0mQvkW/uOrgekzcsUoIZPpKLevc9FP2nqMrEaRK/pT1aDRLt4gVVFR2R+nAZi7hEzETH6EGQRkb/L5w1y458cQuLVD/bzAdjKbBwChd5nnWemWHQ5MaXCnKd6xuS/irMhi0wTUzw9LSxtDSmdj+bdPHrOsG70Y4DMuI1k5LDcXyWa61wB3N/yAe4BuwU217LMj/foT1erPsjNzuJyIFZnYSOW68CLuUVkiYav9KPMMVQXTeQGCTHH2IJibA/Zt376vuHn5cMMvGE4F6gLV3zOmxwgaTxdnZQ6t9HsmP5BitAeUIiuTyL+zKeP2oWsIxlunbOFiR8SDdj9rkFlGd0VvO1J/XLvkvOuv7IK+8qLz//JmO6yOAfW8y36OCDTn+WJ2EGvNMQEf5VHoSSE+nGcltbzewbSG4SwA+5lJTezejkqwMd32Z6vwb7nLLbudMnnf/aWPVxEkRgvovENNslTxEcYShQP9ONKJUADHUveLfpqgZ3PsvzP5SwpiG6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(91956017)(38100700002)(33656002)(316002)(110136005)(186003)(2906002)(71200400001)(52536014)(66446008)(86362001)(5660300002)(66476007)(38070700005)(66556008)(83380400001)(8676002)(8936002)(7696005)(66946007)(55016002)(122000001)(508600001)(53546011)(6506007)(64756008)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5rOuHYnTbjV5E1uiWXwYK6vPuZ5llr/J3j/tZf7nNhlLoMR+RLTRMp37ZdYZ?=
 =?us-ascii?Q?E+Lh7ir6YBEftJDOqg1j+CnwJddYl4EGRLgGfdshdEYexwA6McaBhAoco64s?=
 =?us-ascii?Q?RD1pCt6dBWR3EXmPbx98ZlGuCQZRZR6OI7+2xwBdRASF+18APLho231fy2tN?=
 =?us-ascii?Q?Od2yOyrYex4nXKHDCO6Ai55It+zzrXcb7hUSUGRz4okar9HN61Z2vsmMGOhj?=
 =?us-ascii?Q?w/w1s6rQJ3veTFlragfpxkstWC430+RW8ndk4mJ1JvLgQ6hbx2wuwwWpaZN1?=
 =?us-ascii?Q?4kvnJRFxwfRlIO9JwZWo7BGNc3O+69HDMdt6A60yQqnT3Z8/GKr9z1MZQMmP?=
 =?us-ascii?Q?kHHH9+7S3XAn/fXP9F8pyrELTCFWJMhl/XMkuLRfqpfVU6mtYiI3BH1JCzl9?=
 =?us-ascii?Q?DdUuPtw9T6FvognW2mc+iPY8bSNxKgwIWIPZNEiV5YUWNcZhELiNCCWXNCLv?=
 =?us-ascii?Q?szmg9YywNzWmOyFlxReHo7fmlKC+O0fu7T3eo+TY59xTm78gtWKko1utVAQ9?=
 =?us-ascii?Q?DaQ990GZ1+6zS54uTAooYG+zlwCm7W8OHlSBcUUybIL8OKNH1Wuu/oLIqhlG?=
 =?us-ascii?Q?dYsH9C0cPDdHu6u5EIKH4n2MGRyquXZrGQAElcUswrayV7Kc0BpmzOcLwYx8?=
 =?us-ascii?Q?FNirKwHOdkOrWO5xwmWoV9ykzgS2aDDPfVin2uR+twRHg74F/cub9Ek8dtGt?=
 =?us-ascii?Q?pJ9lBVSj4e5v4aooPNtKCAm5aTbaRhBj2PtWWL59Slcb9cfIEllF1WGtyJ4T?=
 =?us-ascii?Q?EXbBWzRvjJP2FUgyg+fBuqkFLJbpf/TNYAoGQbF7UazgOPfDf1hGrekRZXVg?=
 =?us-ascii?Q?hOxHL9wiJ/7lHc6HBvEqUvgVoc5GtOrHolCPytMgpoaeLzVxBCGaEFX7wts+?=
 =?us-ascii?Q?lGWRrkytFlgVaVzt/1EarppChOd/tWffVbHmLs1KFT6h+vAHyeYG46BFZIpP?=
 =?us-ascii?Q?oGJjs3jGZDYhegSn14alrrgsQ7aWQMvZ0mGcdt7pyerLPUewxiZplRMeFPS6?=
 =?us-ascii?Q?lDA0DRz77yoUtZuU1vM+yc/oAdZKES3DPM1khrZ5wYf4EspaNiocprJOVqrd?=
 =?us-ascii?Q?OJV87cNgbNDN1In+VeHLxkTV+ghQiJ3u5Oh8wNvwyjsThygFinLxLa1/QYbf?=
 =?us-ascii?Q?kSYl7+uKzbkWnuFeP1w95PzSSrr1SiKStk2z3TOdgRtG7F09Bdo8gz8tEJBD?=
 =?us-ascii?Q?z7/oj++43NnduruXczSwOA8GSCPSzY6JvLNZeVTzSCbyAz0g8zBeT8yfknDM?=
 =?us-ascii?Q?Q1TvobTRNZ9FnTYsDDa4USJqhQbmpJUw4OPUbgzHdqZMOVeDU4xMmsKbPw/r?=
 =?us-ascii?Q?gHq4zXTDROzmDob3/BVKACDUt3aMa3yi1WfmgNKwmdQ/MduRH5mj3YyTWq2J?=
 =?us-ascii?Q?ele7gxvGsErjlrK56jhbyf2a1bwZ4CaGrcXWob1NwgCRW7rT3w=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 742ec288-f99f-4bdd-70f4-08d9771809af
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 00:38:57.4381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xj7VoIxuyUPlfgVS4zwhCwTemaa8cwhO6VbDdWzEWMyE1twhRJ/M6jjzbpChUofYhUAxEiv6dwNuybP0X/C3Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6777
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
> =0A=
> Changes from v7:=0A=
> * Renamed functions to spell out "independent_access_range" instead of=0A=
>   using contracted names such as iaranges. Structure fields names are=0A=
>   changed to ia_ranges from iaranges.=0A=
> * Added reviewed-by tags in patch 4 and 5=0A=
=0A=
Jens, Martin,=0A=
=0A=
Any comment on this latest iteration/renaming version ?=0A=
=0A=
=0A=
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
