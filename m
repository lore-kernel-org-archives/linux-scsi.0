Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEACC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBDA86113A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbhI0JTb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:19:31 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39408 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbhI0JT2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 05:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632734271; x=1664270271;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KkKe2+Hb29wSEFOD03aajrkysprOWoikL5nD1uOQcc8=;
  b=nDCYU/uOI0gw0VqSfhlxWiLi6X4ImCkFhLyZ21H6ZrCIMezwoMdmQznK
   0LgNt31+w7QBtJhAAEkCPi+ZWxJM27W3KYWGCzlCqymhqRCzGNVOeWS6p
   bfxOgQ7Rnki5OkNs3aL5s2Mu5Qa1IoAdVXisbmPp/9kYM1Ih+mGO3TkZ7
   zDTt3KuRXrNBgagtbnUyMDLCq20Dt6xlb0VpVUot2TIiBTBXaqsMkhYUA
   HhlC2PvuKgRlrMjeQqoDLUZHc0P6azMr1pUArKRHipGDfu08A0VcptI+B
   utVim6spiF8XrclNUuORzgTUaVls+O3C7rb/NwEBVB6ubihw0u3eWTXXZ
   g==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="284851902"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 17:17:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO/Hhd6gTn5E1VPLqfBSRJR12HG0xqeO5PUbPTTZNl/bFzpZOc2+wgi5dsJbDFksX6ubBwdUJ4tK1O21DgHXV1yzMh607lon4jMWEQndGPUBjT04lWZDgESrFrR3ES1Dn4fAPrkpOJD3wxIYIjOT2Y3mKFk/bgAjOMu25Gf2OHYMek4roPKK8wqQNh3WqtARnBhVH8rbg4wUpe9z/dDeS2lrHC+DQGStUJ1ChIsnM0JBZ0XJR2YxDLi4/leKidcfzR0eojd9T79TpvUvVtqUsf4mLgCpnYRhG47IppmV86zO+/aVtREbQwPDDwX4+0f9ye6+Hs7t0rSMx9ZveyrCuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nNx1ax0WqGok69JsbB0+3ljY412zhuYNND13Ahh0GYk=;
 b=EZElFWAJ0QLH9hGLHWVgAoPGzxiH8N0aKGDJq6Qg/o7JlTZ95lQXlbGXn2PhcrwEVWLr+i/aGwZ051pEzjuIrGq7CA9ZaVLIUdT9aPOm0M96PWy/y6VHeQLyFlpX4H7aru94iHkrDiT7pBOUDRo9WPCdOS0VyyyUDYupE/XuCmouet2GZkRPa3s04NOYMiLXNMJ2z6HzLf3eov7eMtZZ3QaAcGsminETG80oj0ZWEP5XNklvZ862qs295yJVf+EhQkkhlgSfB1M+1T3E3ddtFdefnhJWenSHZWPWey+l2EZEX73aGp/iN2tVkzwgCw4lvdSdwtXe/oiXX6R00JcjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNx1ax0WqGok69JsbB0+3ljY412zhuYNND13Ahh0GYk=;
 b=I4b5XDOrv8n+/6NMFtrqwjlH1PsMSskgvDkI3brl2crUAHbp0Gd3oT77bwiWYmoj6JBIFtTaB+ahFHzBeQkZ64BuZfdrRJm4/6rafqbwgqccVjCrYPR1TOxkz13yTWLw4RVSKU+F5gSDynrP5tF4tu3alIh5cRxLWogWDWahrvs=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5369.namprd04.prod.outlook.com (2603:10b6:5:10b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 09:17:49 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%7]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 09:17:49 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Topic: [PATCH v8 0/5] Initial support for multi-actuator HDDs
Thread-Index: AQHXpSNp1F/8/yl7ZUm+rTQKOyPDvw==
Date:   Mon, 27 Sep 2021 09:17:49 +0000
Message-ID: <DM6PR04MB7081D82E7BD48376A6FDBEA9E7A79@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6122f3cb-f628-4208-7ef4-08d98197acf3
x-ms-traffictypediagnostic: DM6PR04MB5369:
x-microsoft-antispam-prvs: <DM6PR04MB536918A83541EC485E5DD7A2E7A79@DM6PR04MB5369.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41wN2AshVDjtMYML+KBxkujJUaHzWvKEMYH2KhgKlWmDicHEVnS2ROlrJOwAT3ITBZc/kbU0ZWF5XdAz8VBlFZHeAvCyAolFUuU4ZFV7A7uDXH24KWOjKWnu6eWmvQaQv78UXigibzBclbs4f7QENkxEvaOQLPkj7Wl0K2oUrBX04ctABRY6SJWrHwD8nl+va/Diu1JygurheewGIdZ2vBsvzcs2LY9OcWSLesxhoylTXFO87XcmNNn5UUvC0cmZ0Y8NSDcjLGTSMwp4Mrke+K3NUKdIGmlKbuTiegFi1CFae7exYueOKkD7m4tNVceekM7CN40Usd5szsT/jqZMVdMACjraI7u1S36TS8wn8ciMVu2YKu49/DJT+xDDzCj8OAuka+BXxWj6B/aBfFW/l9RJJJMfyWa+fSKEmn3fS+UyjyTgaSUYigXqEKMfEUba4W+KoBxEv7xxphd2vSYKCVZQoVEG15ofm22Ncxx1EaXGW2lMd/CbvxLp/QISqCpC9z2qk40pqJnP8dYik5vqwumKZGis86AYUldMUsy3s7j8+ZQeCyPWknW4V20UVOVSO9UXarkA2v880J6NyZf67wvgy7BwhD0rAMToLnPxxASVtrO7le4eVUaIuMyiRcBOrhe/Ubao5VExaqaR0tHLijjOy/0eXRuc2QxhLT6rpaGCCLJpDXchiObLMOytRFICHMkImaAeMGGz4GUlmM4rHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(5660300002)(2906002)(66476007)(38070700005)(66446008)(64756008)(66556008)(8676002)(52536014)(110136005)(508600001)(55016002)(122000001)(71200400001)(33656002)(8936002)(91956017)(86362001)(186003)(6506007)(53546011)(9686003)(38100700002)(76116006)(7696005)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pIaYCDQBJGekzqe/GTMqWPO2EM9L/toy55fhjlkuYpmbWL8ykztAAIBp8UYT?=
 =?us-ascii?Q?LNlbu3XJYbcNDxu0SxeXhU14NfMLJPcMcvNSKvQjl+PSQRDECu52knyONlK0?=
 =?us-ascii?Q?LG2/mQkwB43FrlHkoj0qnvlq5zubUH947y2R/anuJHFzAoql4xrpJCe+G5OS?=
 =?us-ascii?Q?2OR8/pipXZs/YBdCC6QXMJ242FWmUTr2IY4RZRT+m+2KqUXQF18wu0rwO9Aa?=
 =?us-ascii?Q?Llty7N/Yg2ERTn3vSQGRvQC4brgHCgbleUcf1LKVkiuWaLKk/wE72j5OK9YJ?=
 =?us-ascii?Q?F3+548nFnoHkbzQtQ1dDajwwTYdH+t2iAQxuTAqudnR1zCSRkxWqiSbEgWkb?=
 =?us-ascii?Q?iw7xZ07pJAlYPmK7iTordN4bFq7kgo5pG9FXkflWTlpTqQSYRYx4Hr1ndnv7?=
 =?us-ascii?Q?z6vFS2VdReca6YPT7tX9uB7LbbUO7QBM7Mpd8PpEsMsbkNHgx/KnTF2mkc07?=
 =?us-ascii?Q?L8uNta5+nQD9+QzpsXKiSXQrNUaLzKyEXOjqDxKSdqCJn5/uE8VhTQzl7CAu?=
 =?us-ascii?Q?vcLJP3jofE30hjxoUHIu/f51czxDJDl/McSDJm7joIVh4dywmnc9vhB4EYRc?=
 =?us-ascii?Q?rHEP6A6R45Eh/HCGKaHKp8Mr/HbAud4oSASkLsPaXcAmWZ3+7R1A16p0QDGT?=
 =?us-ascii?Q?Rr743FChyEHbXftZ06B1iAiGVgCVxIIHk6ixlC2oN7fCp/94vB5lvXL2LgUQ?=
 =?us-ascii?Q?YSlDpBeo9gos2owmhfV0yvJgc4KipMwIIvvrPHlJu4RcZ1xVPRBqthJBRAsi?=
 =?us-ascii?Q?iwcp2NG8dwvJ6SnNUhhZpF3CnllTj97VJSLSuDzueUJzbKlkTwIxyYbj/fJ5?=
 =?us-ascii?Q?vHQpkQRVq4ie2oTt3Qyfi0yabf38UrCSbK3FzuRjokANP34y7Yyy6PrhlK1P?=
 =?us-ascii?Q?91xM0tO4v1rEHFNP9HeIMwuioBtPtWAxLNmXLB81kB+FdBPpVPr+HOPjyOlI?=
 =?us-ascii?Q?oQ9HbdJjnsfY2r4ijaP55jqCr7Z7+1Astu4qbL30MGBcXWgH36KAmKFlDrxU?=
 =?us-ascii?Q?Rk4xcGzYZSpbw6BeIlPZpkrwbJuebQu8Tf5gHMjABW9E1wJMWbgBAOQRl2Kv?=
 =?us-ascii?Q?z88BVtJRYYQ5tO8/X4+bdx+hMAJw3AZHVTArozBUS6io3NjligkArntCfhNR?=
 =?us-ascii?Q?TZiG10pi8Dams1oHNzmg2er+IbhpVJiZlsQk8lKO7nS63PRdJova6Uxd2dFP?=
 =?us-ascii?Q?t9JQ+A8OKgpb9ek8BGOWIgE7l7Q4i84xGzs6O0gtRO2enbYv8K/eZDGUmqLY?=
 =?us-ascii?Q?3+ZV8A4zFygZ4jcLFY5qVmspPsm1BFHV0uv2M39ibhKSC/6RiJGmvYj7Es0P?=
 =?us-ascii?Q?Zoaa8H2kKOzDTRl11ZCSChDdjCfC0YVWyyFEIZV9QXANPA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6122f3cb-f628-4208-7ef4-08d98197acf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 09:17:49.0413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9jzIQLXM/jqNTthdD9JqXtefmN42KKPETheOzNSExOxSXgwPm9bP6pW5Ub602EfhHMEJBqOVK+md/O4VKHJ1YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5369
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
Ping ? Any further comment on this series ?=0A=
=0A=
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
