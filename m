Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7548DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jul 2022 13:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiGDNEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jul 2022 09:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiGDNEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2022 09:04:39 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579C4C2A;
        Mon,  4 Jul 2022 06:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1656939878; x=1688475878;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=RbcMzP4qdwCh0pLuQ58hHzwPb9LZyqY7mCLqOtcQ2Yw=;
  b=KesiQyp8hw0AkKjFuOlzPHojQUnG84UZKy6strdRIjCHZe9iL2iKvN+/
   4L9ek9eNeJafXqLOsPlGa9j2Cvfo7tOUy4iWT5NfnZi16OIbjHlnnOiOV
   Uk/IJ7rWk4eHB8eicyT1D2RpDVk+Tp4VFd8buv2kmGL6aXRrMmrdYmnba
   ayeZHEA7MNmJIfMdhuzYCl+U3zgLYHC0IFgojjWCemICt6ulSzEwF8uSl
   0OuLgzOlQnDt2/1nfuSH1Uh7bJ+zWfAskZArEUwRRPixwKTuRn3WwEtvk
   +KX9D5VhDNd4OP19yhN1qczireGh+cD6ychwF73jIzzCSNmj3B/HQflbb
   A==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; 
   d="scan'208";a="205480790"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:04:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ax/M/71Cv8IwaqeHInOxKe/1rVLKQ/0DxmJ+1mhsRBOrSKh0gU7qTEUl0ZCvlOB9jQAfp67HUtaIBHBTSxNMXrEIqTVpBysVvq3DvlajbxYiRMOAq2XrJl9h6EvL+JcHT7qRrSTBR2fuOy/Pnnj33rt1cVmeL+ApjTOqWNymmHKyD0H0Phn4APe25Rd9Oxq0HVqGZvPxe+N81eKNwRUse9HsKe1ED/kgT5qTg7fmaQlJTbJvltOyDwXZgBgMmq1J2lN7bW+L+s4b4wxWZgKpPMX4SeQPHzWhtm2dRBE/scJbzev2o56LR8yQCcqx20xU7QAG3baSX65CN/2yWYeEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4oZbPEgcGZ5y/MfmCtR15h5EYb0X772PdleywIkKQY=;
 b=F03CtaYfV/60fmoGj6sUFVY6YCISlhTzhhpWdpF6YGuKud/RAu3uoihcYi/bA+C4DdGBqtRwT4+jCCntYekBORxLa01lE0SlTXRNxd1oqLimaOI4i+F8zm/MPcRdXPk0YCNGDff40YU4jMJcngq84hBzfWcHnN2FG5T3DfhpH7Kp7hrsJ5hQv6GqpJzTrMIqQM2VTfCqY0NEj1v6R7vWaqkFivmn+ChdJ0wUosO6QKObTh228OT+wka6/iSlFXFccafPI6anRTwDJCTcJPisk5k9mXwdzQw4lTx2+alawG2kJpw3pWjvoR5zQKJY+WblHZh+r/I7YmXiwxbbvQbw5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4oZbPEgcGZ5y/MfmCtR15h5EYb0X772PdleywIkKQY=;
 b=dPpGU7k4IN4/ms3jWV7EkIRDt1X2qnk+kZohgR2NrCQTXKWSROALj2TPOVKMSc4gJwnqmyw/K44f+4Ypmf6Agl3UbNEE/6KdjTMfkItjqwcbvimJIxP/GPqmp2F7e1WBP9kVEpplhSI1np+YacrIjQ8aI5SCv2PC6g02rm9vLSg=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB5249.namprd04.prod.outlook.com (2603:10b6:408:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:04:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:04:35 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Topic: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Index: AQHYj6PpBGDuTXPD8UWi1k2YGkh+6g==
Date:   Mon, 4 Jul 2022 13:04:35 +0000
Message-ID: <PH0PR04MB741615DC0E795F0B6B5010C89BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-2-hch@lst.de>
 <PH0PR04MB741671715E7F16D5335002509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <20220704130153.GA23752@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90120368-38f2-429e-577b-08da5dbdbe9e
x-ms-traffictypediagnostic: BN7PR04MB5249:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B8lvacmMDfiC3AQzbPwh/uKYY6IrDaupFFT+yGTqBHLrzLrTamuMp5OLjmyJZmW6EPct72pqATmILhjmEu2PyVH/f29WMqLpqkK0cXxWWzAP5mZyATHWQkbVCE1TCPTE6GL/j7Qvx1LVG5voPiax0BmuOMZpGZFnbdBsUWpKlfkb2GLBbfyzX0/fMbws0Izf85qiBfbXbnxKvkI6GSeXY0C2ZZKj3snvqtOIEVsFuYUM/UQOSo+RM2Kt/3uk+ArO/DGnR5m+5SpWFZdsHa9xSEEnk3Z7I+eXdzt7P+ZS6MrAYvWmVIHtF75nC1s6+I+EUZTXdrRVkgEAquRSL/9UbjOB571WP3TefgbqoyVrpOpbyovnoCiG/OPyTXb0xXOJPIsGVG53QF4CFi72U7+x8DeU5Siw7QWo4C6Jxr1ya8VX2Iy3auXHmEtgb+16IboILkTiXptCUjkNAQ8OFhRkmTpxgEWxF7p+IsAYmtjU+G60GzmH/GM2hwmzQxEH+3u5nNR2yA5LlGLbt3Twu0vVWlQjJsNDw8iN6hesM4bghQBL2HM+D153lrSvLHndPuHIknokohI6WZdrXi5c5B14g9whKqpfpRh2K7ebCFAWea/hFy9k1IFfETT1Tyx4YlEYZCzdwbO1xOHoLRKx1/Cr3SrKuwZhyY31IEHYlugO1qtavdWXsnVJXPYAZwGF0DY/kDNmMtNx5vOiqRKQ2gyvyP0dFHds+uQxDieWIpWBnxcYHOvtPBOlYFKSRRTIgxKYWxarQbTzoUqZ2iH3X6vTP3kSzUVZMmg2xpE4iwm1KxSSf3K3PRcFQvhPq+NHYcjwnOw9W4xUjl8VTi82N7nV/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(7696005)(9686003)(53546011)(478600001)(186003)(6506007)(41300700001)(33656002)(8676002)(6916009)(91956017)(52536014)(8936002)(66446008)(66946007)(76116006)(86362001)(66556008)(66476007)(2906002)(71200400001)(38100700002)(4744005)(55016003)(122000001)(54906003)(38070700005)(64756008)(5660300002)(316002)(4326008)(82960400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1V+IA58JN3eDJL1XQbH09DXDCJ0MPJMxI0JPq2yPQPDW18ecInQpqQfiq1Z1?=
 =?us-ascii?Q?QWFu1NjUcD8L/yhOk1CRaSDPRar4hObOLr628W+2BWr5u7V4D/on/DtfTIm/?=
 =?us-ascii?Q?+xmzER0YCgCNU8V5QNRGa0sr9AOGq9iX5rGj591k8VWKoabhZ6kOHcBKJ60E?=
 =?us-ascii?Q?XUZ5sqy3Jvuj6RgPsl3s+QeChZ0QQ2sEZ143YgsEKgfOxgsLJvRH0h2Qo5bT?=
 =?us-ascii?Q?bTSuP+2RoncyviMxjmuhmt8jdWjVhxwpw9ccMXsfSlJwrkYQ8pSpY10d29MN?=
 =?us-ascii?Q?v9L87SMtufAUmdaKJwWivBC9tZKV6UKNp7s2gIV8svAEqDgjVbeRpbLwkfBx?=
 =?us-ascii?Q?KJmHDUUy2fIpi5kQGbEjeyBanQc7VE/X+KQLHjXNIY+x+bkiSIQ8yflzOWpg?=
 =?us-ascii?Q?+h8zhkmsVW9BdG+8ojzl2sjawoy4b4jzr1BDWyaTwQZSdp8Q7FpWYr+PTSQw?=
 =?us-ascii?Q?Em0yYNNNQ9oMqauXPMCzNtz1QAniLebtcETK71Ais985NFOxEKg+v2dk7sZ0?=
 =?us-ascii?Q?tquQ+6HdMCrZUo9ZMFsABN2qxM82fzelSNn7lDq1OZnm7JiYFZKsr7DpemNa?=
 =?us-ascii?Q?emFOwLSPUPFwPdegT9Ia5ppWrwfb2BWJOZrBI6QfdkfxqD13Pq6UaarvpMkW?=
 =?us-ascii?Q?ds+cpFiNX/QVaCwE8BbOH8//wJ3uBOdZ/BAzmiSQQ7niIb325jQFwxtSVc6v?=
 =?us-ascii?Q?qOhJKd9pnIq/Q9R11JtE1RGG69ERqB3qWcyymqyHuV7ocKTCJZOBi7bUYQ88?=
 =?us-ascii?Q?c8Iyfm3WO7ahI0/lr3HFz3a6txSSWvvX0l4OQw0lwnwG/HGbg7wmsOmmAevV?=
 =?us-ascii?Q?7KmZjAH2T+C0uvl70toJtpC46zuWkgTL3fpgvZPdYH2ItyDawXHI2XqsGZf2?=
 =?us-ascii?Q?4yUMP1q8UeRiDHTHC49CacZPJoFAeVk2MO9N0enOOqeBhITNN64GdWbK7DRO?=
 =?us-ascii?Q?aXdalh9DveQn0g7ZxRSfp82wKXCiyDq+8imQzYMzZ1DU6ENtr66cBT+tTalP?=
 =?us-ascii?Q?NlGOIxJpzLLctWjQAMSB8+iCQye/EVSXLy91XgLouY39tqpTkcQ4SJEjoLuU?=
 =?us-ascii?Q?OTjxZu/5K70j/TsraV2GR/BlsPngk/9eIs94xvNqm2a7swryw3bsreLy6k7n?=
 =?us-ascii?Q?x8pimBw0ke1PhNcq/wJckeLIdU31VMOWOouSK6TkTJ48g0Gafdtfnlp4+YZa?=
 =?us-ascii?Q?7FnWQt5gSr+MvLcpgtkJj0jBcODZtrdS/4GZhPrQ4040TAzf3nNoIAYUg1FA?=
 =?us-ascii?Q?cj98DPpjxRLsiN1j3adsVyerBl8htV0Fj7/z+f2BkB7TT0RjJepA8wvEsw5s?=
 =?us-ascii?Q?q3MRLuRODAdwuYVwmasGTzFV+KdZSZqoCRju1r9bsIuikmwk+6eaty1A2sDL?=
 =?us-ascii?Q?f2GC7nOzjYbdQoRai3AIRODJ5xYNkEsyq6IUvl+dm/ohZPZRhC6FQF9aJ5r6?=
 =?us-ascii?Q?K6X29Qk97s2MmNpY9d2Sb+VTRaWbLiX4AdnbA6NgoC/rj5FB/4yf4+WeAy2i?=
 =?us-ascii?Q?w9ZK1nqtt9HEOMLIKYn9Fbe/Ea6g0NY8GPqEjfTPTSb3I1TKP+D0mOTZTD76?=
 =?us-ascii?Q?Hy34P8eF8nHNfTSn8zBYUYKW0VYqXL46KXh9adwfy6aY4J4LEyJ/zvj563gU?=
 =?us-ascii?Q?Rm6pWFllSk3YM7+KwAOROHu/cShdiLDASFQX19ArG7jqnFtSWrNcdYMbQooA?=
 =?us-ascii?Q?H2nFe5cSWrTSlCtbTCJBJ4i6lJk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90120368-38f2-429e-577b-08da5dbdbe9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:04:35.4440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +JpoccJNEbym1JfK2bjkOmJYKyaU68I9rksg0eN4CDV24OLHbzDMrFLXpkE7gxZh6qrVdzCR0T213ff5GaKIRI/H+84pWShDzMtK2SwoMM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5249
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04.07.22 15:02, Christoph Hellwig wrote:=0A=
> On Mon, Jul 04, 2022 at 12:58:40PM +0000, Johannes Thumshirn wrote:=0A=
>>> -#ifdef CONFIG_BLK_DEV_ZONED=0A=
>>> -=0A=
>>>  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */=0A=
>>>  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);=0A=
>>>  =0A=
>>=0A=
>> Won't this break tracing in null_blk, which uses blk_zone_cond_str()?=0A=
> =0A=
> How could removing an ifdef and exposing a prototype unconditionally=0A=
> in a header break tracing?=0A=
> =0A=
=0A=
*facepalm* the trace code doesn't get compiled without CONFIG_BLK_DEV_ZONED=
.=0A=
My bad.=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
