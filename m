Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C94C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 05:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D479F22C9C
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 05:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbhAYFg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 00:36:28 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8352 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAYFgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2021 00:36:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611552968; x=1643088968;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=+f706wx5W6XRm5uhLzvZVd/YKAdoOhKibiS6pl14wwY=;
  b=eJpia83TL0ZCcg6frgxVWAjooCuikLGp2+uo/7UuiKuU8rMwMoNoZM1A
   cy8fAKBtu9kHkAZjr/2Wp1IHi2wLNehgLMaVv4YS+Ny0PFujc4hDHHAqI
   4DD/HTTtPovSZWMWgNgdUhUG816lbY8DrxMhKqQv2XHwI1S2rrY5jZF+e
   UnKktzsFjIWS1Tht+y9Qs34zT1XmgHOCbDnCzs0ScD/txJer+hMPjtGUZ
   kwuPalpaHxassaXfmVv5vxaQCcNWoLXiWfRI/Lbdp320CqRyGtfnBpkm9
   UyY8uKydvC4XjM2tRvBYL6tT7RbIyqDEhJA4WrHNNQ2a3vTldQhSH4DSM
   Q==;
IronPort-SDR: t4POpkz3zxbV8zTR6t9DRshvts7QGejhjxhlqUcALdPvSWfP9r85OcefJQqD0aM2HM5G5w2c54
 6c/2Jn+7bQxOq/qxaKoyPxksDEo/sLxz6sGQ407PupnaCenvfMtzC3XvTHUQs+3N/vfXmNr1tM
 zTNfTdVuGQHBjuUukBF5O16dZaFHI4bqCWSvwk9f+K23BRaYJx4iI7HCeqHpledEl0TbInFDaa
 VhgO1MvwXTAOyPeA+N+IW58JaPcxutc/UiuGR9ghNBtTwUNwZ0hS7+UL1z84eVoNOOWoF2bFVb
 rt0=
X-IronPort-AV: E=Sophos;i="5.79,372,1602518400"; 
   d="scan'208";a="159403000"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 13:35:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVL2QIuAyCFBWG2xK1Pa2owT8YYnPO3Xb4F/6XaUWOLqZJF+bTIIOM/q5ZLt5CvFBWO1WrrOX14JuE+HuwI+pHiLhddoJ4pLRy3zMzTWYGkQuC4UUN1XdaZiEsqMJwGNDLYxSqt5ua7yEJF5UHKQsRMSnyHCn3CAL3gdv7zzvV6HOmk58P1DHzQwnjngH2Q1Cwf1AmNpOnqHxPSSz1R9kdsUoIZEm9aftSaP0Sml+NY+IoWmzykt2ryPo4TKXaYD+0S3MaoRKyn4clmnNbuHOKWVuseX5nEWQV9TsM7fqn8/lPcGs9whg/RQRqszQkb+ZBPk/GQbZt1H28n/J/V/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcjWsUMcowmjxd5kQsHLEIME8ZXpYak1oKLsQrcbtYE=;
 b=lTD/bWzZTVIRLMErKJ7WAepvn0PbkFQZJaa6ddEofmAeiNp3Q6etPXo4ly36JQLhmdaFoYLxyzDAS5uLPKrwge0eOAQlXRuVAEoA7YrLEmjmX1oMVBplurmqJno6QrvxFxzwMoK6ks9ctrEb+zLJbHG0s/te5Z4tTayl6rSDNjWqagNCFylWTMuTNbYGB0KQNXtf6pYQpSq4YFSZNKGe3xgsa15zW6zkPZTCUDmRqvFD6ox3xFcM7ZIK/rGgxZNoLslq223l+iRhyz/mAti5CYClCW61EmY+2A7Kx1vFKL968BbmASjxduEhASHhSYOvFUjJ8IocTGeNOShc4ADlMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcjWsUMcowmjxd5kQsHLEIME8ZXpYak1oKLsQrcbtYE=;
 b=BqGxCS9S7Dd74YeVfK4zG32y+X2GJv6UcYxGDwe0yij07a2HQWBL5xucyynGyq3cjTpEnEvht/THnRDRDWt8ujCg6LIZ6tUVCfXo8e6iXZdeTBWgNeDafHlKTCxI/Kz9KSoAEiZdTuSk/vavg4sYI4FSRCS61kBakJeHJcv6t2U=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6352.namprd04.prod.outlook.com (2603:10b6:208:1ab::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14; Mon, 25 Jan
 2021 05:34:59 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 05:34:59 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Thread-Topic: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Thread-Index: AQHW8JU6qVihsq4M3UKmhepNN6tFNQ==
Date:   Mon, 25 Jan 2021 05:34:59 +0000
Message-ID: <BL0PR04MB6514818B1A57DCE4AE9BA5BBE7BD9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
 <20210122080014.174391-2-damien.lemoal@wdc.com>
 <20210122084209.GA15710@lst.de>
 <BL0PR04MB6514A2655635DFF482E4252BE7A00@BL0PR04MB6514.namprd04.prod.outlook.com>
 <20210124100724.GA27580@lst.de>
 <BL0PR04MB6514C3C43A5E3DA84632188CE7BD9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:2db5:5c10:5640:816d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b663055-1d4f-473c-485c-08d8c0f2f4fb
x-ms-traffictypediagnostic: MN2PR04MB6352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB635200F6AE0F471A5F8A4201E7BD9@MN2PR04MB6352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: edA+IDdbSlCIUZDe/HqSOHI6YLVtAcGRmF2JvIVNORTlBZ6WeMHQlGZ05CDD1ehkoSlQmbYseAfCAvCEDWxa880J0yrHjqJkyJkXrcv6Lw8f9U06hg3zxsyC6bum28t/DjQmoRTt8aFCDbPQIHlXn1J43tErJEGvgwlHXpryIFyEmtsw6Yq4T34QvngIVQXQ16avRTzGFvyMMce6Re73qN1LcA2l1wWaGwxqHvpoyWOjvsf/uVdkntsep5vVIg+mPojxM9vLVo0GQpuxLF01wX3w/jGbsXCgZ8WCtSR5UOBWg+MN53QCrA2lv0oXf9oaKQ5npC1D8E+jSdgIN7cvfvhcv095lFM4lBacmpMTm34Z4c1h2vWKNu/Ckga1h4/skZ7Qk5MexghITzUIcVvEFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(83380400001)(55016002)(6506007)(66946007)(71200400001)(33656002)(7696005)(91956017)(316002)(52536014)(53546011)(8936002)(478600001)(66446008)(86362001)(66476007)(64756008)(5660300002)(8676002)(54906003)(9686003)(2906002)(186003)(66556008)(76116006)(4326008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?45+4o8OjDxaBzoqZssk/2RGprABVjAgpc/4+j7mvKdIq01WPDI6GEqeJau6S?=
 =?us-ascii?Q?/jHKubsL7Q6iyZM12Q7jV/W7CBM2QiYxiddHYnm+t0Ac0jxzhSJw5hkcOq9c?=
 =?us-ascii?Q?nsC+JgHQiFBXyVRUiVZDsk9AAyOmF7oPJY31KAmdvD7sAhTD/Vxnlmbxv2aw?=
 =?us-ascii?Q?Y+cxJvHg+X9HnSI1P0u20L19HEALgMI0ehfecW2wdwqlzVQ1h8arHINYnGXv?=
 =?us-ascii?Q?auBk0iBy2pq4k862UmbCpPiNmcXFGXHrfBFmTZugiN28dZoWY9ZnarP6klFg?=
 =?us-ascii?Q?BvbUAwLMZTlrBD9SocbrKx8TViEhiWgeayoJYcpAF3U1ORHN77+mOSaNQ29s?=
 =?us-ascii?Q?3CUJlyxR1UZoG6lhF+BKMc6WWQYeJILnCnGwm+iYKaC6h+9zRG/2MROv2Sqm?=
 =?us-ascii?Q?B0v/nY2xrQNGioIKaOxd76Cd61IQyudJAbU7SkIi6/PJkks7nlkkQgTMi4aE?=
 =?us-ascii?Q?vrJo2CfyuLUF7gPA/CJB9zhpG5XCAeLZpKVsyxIa1RD8WAkiC+kXMKSH0Kep?=
 =?us-ascii?Q?clHI/jetMOOtExjLvJMhRla0Eu4yIuvgYW6sz4i/H045Oq+9Ieh0rbQa4ZRA?=
 =?us-ascii?Q?oDfHVU05+/yAZ2/DBprFVBhcBcpxdXu2/c8O+Rxv3yBbuZtSb4jdlBzdUey0?=
 =?us-ascii?Q?sHPxSjm1PxVFq2bls9wxwrZxgQJUplzz9fCrsnvNHJMoq11oadR+8JA9dhfj?=
 =?us-ascii?Q?n0i45tZSkoQim5E6L0DgaqyViXIKk8Tty3gpHoudrxu6IATp2ww8Eg9jm4R7?=
 =?us-ascii?Q?GBUB+k0rrVZEv4Sg1uOh9b+VCTQHwISIt+25gKCGmT+bBi/Y3Pep/zml5e2a?=
 =?us-ascii?Q?1AmjhwPXVWR7BYfs8ZZbej3F5jIE60STJRbZj+pxLoFnqsjjnOHuT+U1Vy9c?=
 =?us-ascii?Q?dK7kOYDk6bk9NAiATWFMJ3QzZgboMUdXQKVKnjVIYS5yhOewwM3HAXBVNFc3?=
 =?us-ascii?Q?BN3iyhT1xdulmKjiiYIudu1K8vePLIT8vC5lXBNS86/Lq5t7tpbySjb8PB3w?=
 =?us-ascii?Q?FRaWym4wmlYyT3tvFjLSCQnTNA55kfccIc3EJfsiO5AIAkYB5Ode4urWqbfy?=
 =?us-ascii?Q?6vs9/cmEhmgWZMXf81LIEaSEDHQXuY2zkm5g/3yklRPzmWRCnopHnrrQPax8?=
 =?us-ascii?Q?7PWxaqstvSLF4HtIMQPAD8xGWGNq7MN2+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b663055-1d4f-473c-485c-08d8c0f2f4fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 05:34:59.6193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTDYkWpEAUENWYQ/DC2L3ldfFN+kYHjxJfhenu8P4Orp6uc5TGGMTRfJrqhRodDjMLYYOg5/GOIt24YPVd7m6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6352
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/25 14:32, Damien Le Moal wrote:=0A=
> On 2021/01/24 19:07, Christoph Hellwig wrote:=0A=
>> On Fri, Jan 22, 2021 at 08:56:58AM +0000, Damien Le Moal wrote:=0A=
>>>> This looks a little strange.  If we special case zoned vs not zoned=0A=
>>>> here anyway, why not set the zone_write_granularity to the logical=0A=
>>>> block size here by default.=0A=
>>>=0A=
>>> The convention is zone_write_granularity =3D=3D 0 for the BLK_ZONED_NON=
E case. Hence=0A=
>>> the reset here if we force the zoned model to none for HA drives. This =
way, this=0A=
>>> does not create a special case for HA drives used as regular disks.=0A=
>>=0A=
>> Just inititialize it for all cases if you initialize it for some here.=
=0A=
>> That way everyone but sd already gets a right default and life becomes=
=0A=
>> simpler.=0A=
> =0A=
> True for nullblk, and that also simplifies sd a little. But not for nvme,=
=0A=
> blk_queue_set_zoned() is not used AND nvme_update_zone_info() is called b=
efore=0A=
> nvme_update_disk_info() where the NS logical block size is set. So some=
=0A=
> surgery/cleanups would be needed to benefit. I could add a cleanup for th=
is, but=0A=
> not entirely sure if calling nvme_update_zone_info() after=0A=
> nvme_update_disk_info() is OK. Thoughts ?=0A=
=0A=
Also, because nvme_update_zone_info() is called without the logical block s=
ize=0A=
being set yet, this patch was not good for ZNS.=0A=
=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
