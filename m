Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92671C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6203823332
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbhATL0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:26:44 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:17377 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbhATLCB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2021 06:02:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611140520; x=1642676520;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8jpX3r/Fdy2oj9h4r2jueQOqv+VSCe5zL/cp1W0AlZQ=;
  b=UXldKJC8+vGXwaKwFa4uBDPbBL2/4jc0sCvjfC/bpD+6aPEPM5OqTtT5
   kGBVQHdSp9T/++J+qZ14mqPE9sq02G+bca8vYEI0CVmHEaKA4oWOZmt+Q
   ldnsxQbGYJPf6ltw4FUvpTIGHMKqAkrivUJ2tf4wrEf5arZ9v4inoU4vy
   EZFyi7JZ/X7ytbsF0nOtgkeX8ybFIAqeA06KHAbuO7naT+y9dXgUQFvsk
   S3GVz1gzYGV+8pOyMsw7mFy8PITXmDFiwd9BI7ZL9e64EKPmNS8GQ0GJg
   /SSRoCJznO+xioe24WYCprOa2mls9WjvMf/It9IrLmHzN/64NShQkx1H3
   w==;
IronPort-SDR: 9AVa11qkT4Gind1hiJ+fW/RxGYgI58ipMXOzBYNzQ6PLbAYbggoSuTLLOuy7Fjn6xyIBLjitzO
 GBr+ufMUf1DjY/vatJ4Q0IX1MGcPGQH1KvTq6k5rCwpR6fcVg8TPxuEO3WX9aPPzZP7Lc+ZF7S
 M/f73f9aDE0TroxKkKQ9E5d13ScZQc8iqnn3chDWVIS6Q1EHp1JHkzGW+TpjtcR6RKtXO9Xxma
 SdT2xPR0CfVthoG0tkx+HvOXEmfDKtMXieXkKYz8tYf/QRXjIxwRvIourylPswOdY7cVE2pL4M
 27w=
X-IronPort-AV: E=Sophos;i="5.79,361,1602518400"; 
   d="scan'208";a="157883284"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jan 2021 19:00:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhZafvGGR1aGv78YocXSOSRE6XT1lNEswB06PAlPsoEwO92JEZMlvLf/vSUthHZH67dSG2J/r1LrjBjDbTOVheQrpM+f+oDqKYBCsK/IJbXyb9Fsvi8R3kCK0h1ZlAF5qQLiHHmY78jXVv+Mtzw68WzjGoOasYuYCbZcyKDGBEm/nKZ9cl2LQVzQwcJ78vUyzLKKVYeV5fOEU8qx2/R+0J/wL/WybFutWklBHNTlVmAh/BMZXVA/3OUcrH7a5JaUE6reUowFP6kDnrSNV/nBFWp7LW3yR9lZ7KVUr0bictu3nyPIwzW5A67n6MXg89bIQQbKMfYCgylrZLGo6SMtFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FShjsUXU5pG6/QH7Vs4MSuu9XmYj3yeif3wWOkYF8lA=;
 b=DJzCfaFNlitSIAjfloL3fpNTmCT9il4yGMBegAWato1T22gS0A+LYuT6/4exFa2t3tpPZk+jeogEwpygE1PW1Pi7ElpEoZGDqcZXmd20sFeQbDiknyzaTHyxKTMMe9NvfRPkDwxcbOTKRbdBRUvpRrUCzbIN9JNBbRii59Qmr6ipqVOqAcfLPLrZjT1XqTJTLNgW2wc1Sx3QLqsLJTCXuR2G8hCuLOaSPml+JSf0JYuiquphFMsXGps+u6yeeIKlINTndMCRB3fhfQOCcoM6xZSRPZIG34R/qMOqnmOqQEOwEWXA8cM8Yp/q3AcDYUH/8ZrSpmdtEjv9r4QimG7kIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FShjsUXU5pG6/QH7Vs4MSuu9XmYj3yeif3wWOkYF8lA=;
 b=QuSHrPn0x3vrHLmFM7tbqE0gmIWZ1+froy0dEJR3aaKS/RTeHoweDFnlacUkP7w4qOyVHG2u2DoPj+81OsNZP+wWbbYsOFtfvI1iFyUc8enduNx78piF2++Mys2HYaMt6v19O3+744repoOwVmAWkNBr/4vA6USidWk5HrKkfWA=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6862.namprd04.prod.outlook.com (2603:10b6:208:1ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 20 Jan
 2021 11:00:30 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::b880:19d5:c7fe:329d%8]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 11:00:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v2 1/2] block: introduce zone_write_granularity limit
Thread-Topic: [PATCH v2 1/2] block: introduce zone_write_granularity limit
Thread-Index: AQHW7nGonvlnySHUdEmqZY+rP0bp3A==
Date:   Wed, 20 Jan 2021 11:00:29 +0000
Message-ID: <BL0PR04MB65144D0B02939681617B61A8E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210119131723.1637853-1-damien.lemoal@wdc.com>
 <20210119131723.1637853-2-damien.lemoal@wdc.com>
 <20210120101018.GB25746@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:b0d5:1d20:2559:58ed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d8e09067-537c-4e8d-0491-08d8bd3299ee
x-ms-traffictypediagnostic: MN2PR04MB6862:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB686250FFA5F0882A8C0ED2E6E7A20@MN2PR04MB6862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0s2YYncY8k+atKJi70OSpGUR/atrvFN9+Sx1y2Si8L0khKpQh0ctFZAvqmEr7O0atC2x+Eocl6z7r1gGUSP/I64ixsZgu9upYmxfpWlzU4suYNgTxSsuM+PxSK2OKEkGbXiiCk3qWZgY+WmcTmJp9+vlOolaQu/4/ql5S1kDzCru/b1ReJgn227DBjkRzEyUMBQsKRTmp6Dh7nIOtAusQwVkRkNaBc7dSXGXFgvUywwuRFzaJOkOzs7mM7APS8kAdVeptQBxZLKSCr4fV1FSkjyOHlgAOwQydoc0kBNpWrb4eCWWxn1T9gO2dRkQiid7lkCD5EkSgyH5lCafT7Lz9x+3GfQi8xXG8TlVudGWvtfGH25XBJDgoV/TX8iRF84ypPjxEv0oE59mywVaeGXOHyDocArwWVc+Xz6CF+1VWwfV5AwHnQAwHDtedxLZOt6tsWxa93P+YYZIjvDZ0oaUBBfm3utM61jyQLfOtVSKs+LcqqmAgtipm4kM6e9KFo5BR68aSUiWA1EIrO6IeOiHYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(53546011)(5660300002)(6916009)(55016002)(478600001)(71200400001)(33656002)(64756008)(8676002)(66556008)(9686003)(66946007)(54906003)(66476007)(316002)(76116006)(91956017)(4326008)(52536014)(186003)(2906002)(66446008)(6506007)(86362001)(7696005)(8936002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fw1XkmRBs0d00KUsYKFqZSpQoxsXSuIzTbWk92dJiZ44mxH+Fa4ISlKP2H07?=
 =?us-ascii?Q?lSLHtP7OG8Z0UGWyU9q6heaWHMgHhaJCtx2KGJJPZoKyBLoVztqAGbuZKnsw?=
 =?us-ascii?Q?PJWThTMTfV7nJY+5mgAx8LaDGDpg5LbRYKlInmLwclh5J8f0reCNLo2mpumH?=
 =?us-ascii?Q?O+qyIeXNhzRZM+SdwcS5vPEhOrz9hyburczSOkYe/W3KoSGqXyJrReVYPbYK?=
 =?us-ascii?Q?kbGYaWZLR2k6bLNtjeXpGM5FdOCH+etM96u3fwu9odkroxW2SL0q2ABr2K4X?=
 =?us-ascii?Q?kcW92u2tifvRn2EBSnxhUq5KIS4PUAscRxv97eki4uWTEMylftg08SLA8WVE?=
 =?us-ascii?Q?ejgS8MFlZG2totviQauDXWMgq2DMAXRQDM60pXHZGBFv/7/F7Z1AQqDx1pJH?=
 =?us-ascii?Q?KYRsBMHqidmZKHX4O7ckgxLZa2x18yagPQwJtcjknaqQNb8zC0ofJFxPDuwI?=
 =?us-ascii?Q?10sRP7/85B/w0VBw5WKlzaxWMhy1QGQbdnD7RNxj8Nqtz+BVEYnM4PpbCW3m?=
 =?us-ascii?Q?C213t9fYl4l4cadr6hO80iu6xrXFBlNsMj/pGUabQ+0uLeXJejoNOSXKKk0S?=
 =?us-ascii?Q?qiNbRbcde3zW+qeks3/eRmQINCGLm8z65dUgmzhK/ifHMQ2vtk5KfmYPnQ+i?=
 =?us-ascii?Q?UI65sLBw0fG4FeCOnTIds1D0IQq89Gkae644oG7lzphWnmssEH6ctaaqXD/0?=
 =?us-ascii?Q?hQp0TZvy1vtQmrY2QEXQn+jHSFWttxQO+gbEjjtLxCz5HtXnb24V7sP8NdQR?=
 =?us-ascii?Q?idZ5bfgSHgMq6t1wQ1j+tykwyxxJDoSWvqulInijm+VZJ1zID9sxq8hUPM1T?=
 =?us-ascii?Q?2SW7+1u77XvY9r8uAQuwC4LIgfmQZuhHRJw1bvi8/EDSi90pfl9/uWJzbfee?=
 =?us-ascii?Q?X/nRK4DYA2f9HiCTcTIEzcrK7QQKVIibsWTlUBnTo7NVOki3EmWAxjkz6qZg?=
 =?us-ascii?Q?En5MhRn9NBKccDSyUFubDYjXLNNHrqydeo4AZSHLLbdQdBHf1MZXU9GJNy6Q?=
 =?us-ascii?Q?NPDJF+YswQrnohUwsrqRivHD5+9Xf7AylM2vpPg6oW8R4xybf4AwQgpCbqvM?=
 =?us-ascii?Q?hB76zT4hXIJY1tv1QPLiVECYDK4H5HzgVnjvlRZ+0F8KyQ4E8hwkp1fOIhfu?=
 =?us-ascii?Q?ZSMCop5JpF+JBxXTblcxP8shye+XUi8V5A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e09067-537c-4e8d-0491-08d8bd3299ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 11:00:29.9978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rfaShVThAwRkglCKO0K9u9whs8Ryg+vJyA1cRTXdLvgys+uiHc9kRy5ZIYvT2i/+qNuKvgQoecOvNCIOE35SpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6862
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/20 19:10, Christoph Hellwig wrote:=0A=
> On Tue, Jan 19, 2021 at 10:17:22PM +0900, Damien Le Moal wrote:=0A=
>> Per ZBC and ZAC specifications, host-managed SMR hard-disks mandate that=
=0A=
>> all writes into sequential write required zones be aligned to the device=
=0A=
>> physical block size. However, NVMe ZNS does not have this constraint and=
=0A=
>> allows write operations into sequential zones to be logical block size=
=0A=
>> aligned. This inconsistency does not help with portability of software=
=0A=
>> across device types.=0A=
>> To solve this, introduce the zone_write_granularity queue limit to=0A=
>> indicate the alignment constraint, in bytes, of write operations into=0A=
>> zones of a zoned block device. This new limit is exported as a=0A=
>> read-only sysfs queue attribute and the helper=0A=
>> blk_queue_zone_write_granularity() introduced for drivers to set this=0A=
>> limit. The scsi disk driver is modified to use this helper to set=0A=
>> host-managed SMR disk zone write granularity to the disk physical block=
=0A=
>> size. The nvme driver zns support use this helper to set the new limit=
=0A=
>> to the logical block size of the zoned namespace.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>>  block/blk-settings.c                | 28 ++++++++++++++++++++++++++++=
=0A=
>>  block/blk-sysfs.c                   |  7 +++++++=0A=
>>  drivers/nvme/host/zns.c             |  1 +=0A=
>>  drivers/scsi/sd_zbc.c               | 10 ++++++++++=0A=
>>  include/linux/blkdev.h              |  3 +++=0A=
>>  6 files changed, 56 insertions(+)=0A=
>>=0A=
>> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/q=
ueue-sysfs.rst=0A=
>> index 2638d3446b79..c8bf8bc3c03a 100644=0A=
>> --- a/Documentation/block/queue-sysfs.rst=0A=
>> +++ b/Documentation/block/queue-sysfs.rst=0A=
>> @@ -273,4 +273,11 @@ devices are described in the ZBC (Zoned Block Comma=
nds) and ZAC=0A=
>>  do not support zone commands, they will be treated as regular block dev=
ices=0A=
>>  and zoned will report "none".=0A=
>>  =0A=
>> +zone_write_granularity (RO)=0A=
>> +---------------------------=0A=
>> +This indicates the alignment constraint, in bytes, for write operations=
 in=0A=
>> +sequential zones of zoned block devices (devices with a zoned attribute=
d=0A=
>> +that reports "host-managed" or "host-aware"). This value is always 0 fo=
r=0A=
>> +regular block devices.=0A=
>> +=0A=
>>  Jens Axboe <jens.axboe@oracle.com>, February 2009=0A=
>> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
>> index 43990b1d148b..6be6ed9485e3 100644=0A=
>> --- a/block/blk-settings.c=0A=
>> +++ b/block/blk-settings.c=0A=
>> @@ -60,6 +60,7 @@ void blk_set_default_limits(struct queue_limits *lim)=
=0A=
>>  	lim->io_opt =3D 0;=0A=
>>  	lim->misaligned =3D 0;=0A=
>>  	lim->zoned =3D BLK_ZONED_NONE;=0A=
>> +	lim->zone_write_granularity =3D 0;=0A=
> =0A=
> I think this should default to 512 just like the logic and physical=0A=
> block size.=0A=
=0A=
Hmm. I wanted to keep this limit to 0 for regular devices. If we default to=
 512,=0A=
regular devices will see that value. They can ignore it of course, but havi=
ng it=0A=
as 0 makes it clear that it should be ignored.=0A=
=0A=
> =0A=
>>  }=0A=
>>  EXPORT_SYMBOL(blk_set_default_limits);=0A=
>>  =0A=
>> @@ -366,6 +367,31 @@ void blk_queue_physical_block_size(struct request_q=
ueue *q, unsigned int size)=0A=
>>  }=0A=
>>  EXPORT_SYMBOL(blk_queue_physical_block_size);=0A=
>>  =0A=
>> +/**=0A=
>> + * blk_queue_zone_write_granularity - set zone write granularity for th=
e queue=0A=
>> + * @q:  the request queue for the zoned device=0A=
>> + * @size:  the zone write granularity size, in bytes=0A=
>> + *=0A=
>> + * Description:=0A=
>> + *   This should be set to the lowest possible size allowing to write i=
n=0A=
>> + *   sequential zones of a zoned block device.=0A=
>> + */=0A=
>> +void blk_queue_zone_write_granularity(struct request_queue *q,=0A=
>> +				      unsigned int size)=0A=
>> +{=0A=
>> +	if (WARN_ON(!blk_queue_is_zoned(q)))=0A=
>> +		return;=0A=
>> +=0A=
>> +	q->limits.zone_write_granularity =3D size;=0A=
>> +=0A=
>> +	if (q->limits.zone_write_granularity < q->limits.logical_block_size)=
=0A=
>> +		q->limits.zone_write_granularity =3D q->limits.logical_block_size;=0A=
> =0A=
> I think this should be a WARN_ON_ONCE.=0A=
=0A=
OK.=0A=
=0A=
> =0A=
>> +	if (q->limits.zone_write_granularity < q->limits.io_min)=0A=
>> +		q->limits.zone_write_granularity =3D q->limits.io_min;=0A=
> =0A=
> I don't think this makes sense at all.=0A=
=0A=
Arg ! Yes, that is a hint only ! I misread the comments for blk_limits_io_m=
in().=0A=
Will remove this.=0A=
=0A=
> =0A=
>> +static ssize_t queue_zone_write_granularity_show(struct request_queue *=
q, char *page)=0A=
> =0A=
> Overly long line.=0A=
> =0A=
>> +	/*=0A=
>> +	 * Per ZBC and ZAC specifications, writes in sequential write required=
=0A=
>> +	 * zones of host-managed devices must be aligned to the device physica=
l=0A=
>> +	 * block size.=0A=
>> +	 */=0A=
>> +	if (blk_queue_zoned_model(q) =3D=3D BLK_ZONED_HM)=0A=
>> +		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);=0A=
>> +	else=0A=
>> +		blk_queue_zone_write_granularity(q, sdkp->device->sector_size);=0A=
> =0A=
> Do we really want to special case HA drives here?  I though we generally=
=0A=
> either treat them as drive managed (if they have partitions) or else like=
=0A=
> host managed ones.=0A=
=0A=
If the HA drive is treated as drive-managed (i.e. it has a partition), then=
 the=0A=
model here will be seen as BLK_ZONED_NONE and we should ignore it, or bette=
r,=0A=
set the zone_write_granularity to 0. If the drive is actually used as a zon=
ed=0A=
drive, then we will see BLK_ZONED_HA here and we can use the logical block =
size=0A=
since HA drives do not have that restriction on physical block alignment.=
=0A=
So my code above is wrong. The else should be=0A=
=0A=
else if (blk_queue_zoned_model(q) =3D=3D BLK_ZONED_HA)=0A=
=0A=
And I think we also need to add "q->limit.zone_write_granularity =3D 0" in=
=0A=
blk_queue_set_zoned() if model =3D=3D BLK_ZONED_NONE at the end of that fun=
ction.=0A=
=0A=
Will send a v3 with these fixes.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
