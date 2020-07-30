Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924A7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 12:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46C4E2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 12:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T3LJdarr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hF3RuTxN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgG3MdD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 08:33:03 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12962 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgG3MdC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 08:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596112381; x=1627648381;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=NgNZbG7n+J7DYWOlOFf3A6UhADCJ3m0aySZZEiDZnrk=;
  b=T3LJdarrejW0B9pEmyjDW9NjJj7NKmLxDdsga6s15mU26Hju7LJMTqDp
   g5vXheaA6cGnQ4GYDcTsdF/oCdIn+OJVQ0/7A6B2YCaLLCtCwaMfAGXP2
   32jqKZwhnWhBamwBkNLRXOgnogN62tJzAVG63nTiYnD9EF+vuwRS7XOSk
   qZwBHDegBlacjpnmqub6jhDF2EXkq5YlEgXc2DUsi/9rCUNXvU6zBwkC/
   hGY+sJ1jfRAr9hxPtr9uDNdDIgW1+HIFQFcgtAzh3F5KBRJJecjs8RnYu
   PS32nsSLoKQXtkjrcOFa1YJ1iKDNIBHqrRDCyTWPmfOJGgpLj3OAeqKYw
   A==;
IronPort-SDR: GOZAsH8DYs2wXKpFomUnsRvaXFR+xyzTgOaQ0oKY5f1402x9J8EawrXDh6WsbXlP8ao5MiQcVP
 9e7dhGlzWQyEhNVlt1vPg22+a6tjA27tha48vvia6MJ6/9ER/Fi+GEq7hcwqiJ8u6fbcYfPGmm
 D50d7vZcm3IZTz5pXwKksQ0mikLEKQ7X0GoD/uPpE0cn8Lsr87z4GVgqKjvRHJYh2jv1daLswG
 LgGl+ph+AiF1fcffWvjfT0RBkq5vauiWYlh6rHhr+3PQ3MNnvo4S5EfQs2SLM1DrIlbs846r8t
 f7g=
X-IronPort-AV: E=Sophos;i="5.75,414,1589212800"; 
   d="scan'208";a="145000386"
Received: from mail-bn7nam10lp2102.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.102])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2020 20:33:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVLu9lCneY74iGFoBzKVm55vpvtZdZSljjN784mcmuE031AJ5ER8pNBdLm1zMP2KQrkh3J+x8h4dwXh6jTo8MjiN7c7OHWLuW9o+U2vJxfJP6v0e3MPKEyLBgeS6r+yj8+cYchiuduZm+YFV9gex0zhZDCcEWJ/WLoiXirWyWX7blFPPJaiPaozd1/0JajISZRb9dTIlfSv160F+19nY0vneNONBlnUg4m7dptaoZkrUlDcU4brYYxIGAMupLO375t2jkiP4zWniHhKCSAgpayp/gFj31p/gEOwUvHp9d+nWq7cFvAlqQsy7DJc5Fl23CcEfUxefysecU3lbiEEQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxufhMVOX0jtBd7o2hTUO1zPYVazeUZrQho1IxR9Xys=;
 b=Wl2ql4wnLE5HEbH3/dvTGzR4DizJWUZAz4hNDOQ7eEJaPpdszX83whkN+g3vHBaiRQ/J3odVjq8cClMccgJmAD/Sp07952xCCLe7KefUCxH2JVkf4q1GoyLVpEhhrDcoKP9svvu6guwpX9u12uqqMvjJshHubrPp9MoxFWbmbanemeUoLzfLulnsngp8LF8mKDQ5i51QQbZNN16N8f2R+ODSm0FCXHH0CFUz4vGWCZ0mslamVxBhBbGy7JJ81oWiOJba/DImgXLI+7NTJ5Voq17n4NcFhpabBDLtK3oep8221sZDXAk/JcM4u8T5esdlobACripQFVpETJahCizukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxufhMVOX0jtBd7o2hTUO1zPYVazeUZrQho1IxR9Xys=;
 b=hF3RuTxNB37Itoh4oMRayli9dUDb3H176nmUNVdpWuUWYIy6dfPbftnvCoq1+T7NRjhLYYZ6j2y0R2881ma1/eunMtrsWrp1OgzXgFDV7TBZsYv/xi1NNYVdk6o5/1Gpy/FGZblA8mJPt8rIDa4G02uZjqJBEMgRlG3mxq1eDCU=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1257.namprd04.prod.outlook.com (2603:10b6:910:53::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Thu, 30 Jul
 2020 12:32:57 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3216.026; Thu, 30 Jul 2020
 12:32:57 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Topic: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Index: AQHWZmQfso33Lb4oTE6/FvtKreElsw==
Date:   Thu, 30 Jul 2020 12:32:57 +0000
Message-ID: <CY4PR04MB3751A56EDE1C372CB7531EE0E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200730112517.12816-1-johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f1a20ce-8475-48f0-0ced-08d83484b0cc
x-ms-traffictypediagnostic: CY4PR04MB1257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB12578555361CA29D876B0FACE7710@CY4PR04MB1257.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4TkD9380B/YFMDSmexWbxEGy2F7uNfcO1t0mmppGlwRsM1aXhgB8OVdR54dAeONp2OzyvVW0PU2pfkmGE9QOvpK/dTxcplX70Qoy0HnsvONE+J78NTTZfTTKYO2S1W0J61I7OH2QkL6BCUY3aoTggbvnxxqTXa0SdJ6Wo9sZW9dFRDXD5lx7G7gxq5PCSU1IARnW5eeihuLM2ufIkrJyssrx3C5ehS3tCg7AY8WNF00bmZ8oiwiFUbdSVhUnzrJYIEZrsJIejh/v9baHgn9qZJSZ2G6+IygIWoIHcT5ZYHmyoPI0uDRuCm9uUfPXg6ZHDMpN9gwZaDLrEim8cJTXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(26005)(6506007)(478600001)(53546011)(52536014)(33656002)(5660300002)(186003)(8936002)(7696005)(4326008)(8676002)(66556008)(54906003)(316002)(2906002)(66476007)(71200400001)(83380400001)(55016002)(86362001)(66946007)(9686003)(110136005)(91956017)(76116006)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2+F0B+8DgLTkwgxktaYTC1QtBtOgY4D3l9Kyn+HTi1BHR5kLIV6l/4gCstDYJsxOxAHAC6MLqBX57JsdG025StJX2f7T4ilsVjqUw5BAmLHAlYq5fF1b00C58nPFLH5P6c4XXUQa6nMbKh8kpcES3LwD9Y+5aCwrTRpULHmwgQBHK9jXFig+TQItinFc2kIHQAPdRObS4ex1y/EX54A3cHVYhNUB4co+Wmw7bThaVxCbJpPRYfMtDJXkWdP/MkwqR+0G5vwUASpssUaNYH4VYXpJJFarA+RT/OSNN4uLVo7AJNt6KMigzGVOd3cVcbobFIxkKR2vpLHknYfr866dWJr7cFqM5djF+URkEZu8IdNuNa5dmjcxl/u2hxNRj0pxAPpL6IzESmVelM89jt/rWRNZr31ktBqsdA6Oo5VClqVcPqelgIrnGXbkw1BzhXQtoIqAEAy7kKYM7jzqnfp5/yRmGiTCwZdBLjIMPie/DcZjl8/pxLEHxfd5JZGCOXRn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1a20ce-8475-48f0-0ced-08d83484b0cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 12:32:57.7646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f94pp1AYFi7Rvydc8sKArPl7D/aL7gUJdL/8Nnke/pgoT8e5mBy2TjcFQuEv/26KtfVEGRrnYoiKXzofP0AYVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1257
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/30 20:25, Johannes Thumshirn wrote:=0A=
> When we loose a device for whatever reason while (re)scanning zones, we=
=0A=
> trip over a NULL pointer in blk_revalidate_zone_cb, like in the following=
=0A=
> log:=0A=
> =0A=
> sd 0:0:0:0: [sda] 3418095616 4096-byte logical blocks: (14.0 TB/12.7 TiB)=
=0A=
> sd 0:0:0:0: [sda] 52156 zones of 65536 logical blocks=0A=
> sd 0:0:0:0: [sda] Write Protect is off=0A=
> sd 0:0:0:0: [sda] Mode Sense: 37 00 00 08=0A=
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't supp=
ort DPO or FUA=0A=
> sd 0:0:0:0: [sda] REPORT ZONES start lba 1065287680 failed=0A=
> sd 0:0:0:0: [sda] REPORT ZONES: Result: hostbyte=3D0x00 driverbyte=3D0x08=
=0A=
> sd 0:0:0:0: [sda] Sense Key : 0xb [current]=0A=
> sd 0:0:0:0: [sda] ASC=3D0x0 ASCQ=3D0x6=0A=
> sda: failed to revalidate zones=0A=
> sd 0:0:0:0: [sda] 0 4096-byte logical blocks: (0 B/0 B)=0A=
> sda: detected capacity change from 14000519643136 to 0=0A=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
> BUG: KASAN: null-ptr-deref in blk_revalidate_zone_cb+0x1b7/0x550=0A=
> Write of size 8 at addr 0000000000000010 by task kworker/u4:1/58=0A=
> =0A=
> CPU: 1 PID: 58 Comm: kworker/u4:1 Not tainted 5.8.0-rc1 #692=0A=
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-=
gf21b5a4-rebuilt.opensuse.org 04/01/2014=0A=
> Workqueue: events_unbound async_run_entry_fn=0A=
> Call Trace:=0A=
>  dump_stack+0x7d/0xb0=0A=
>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>  kasan_report.cold+0x5/0x37=0A=
>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>  check_memory_region+0x145/0x1a0=0A=
>  blk_revalidate_zone_cb+0x1b7/0x550=0A=
>  sd_zbc_parse_report+0x1f1/0x370=0A=
>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>  ? sectors_to_logical+0x60/0x60=0A=
>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>  sd_zbc_report_zones+0x3c4/0x5e0=0A=
>  ? sd_dif_config_host+0x500/0x500=0A=
>  blk_revalidate_disk_zones+0x231/0x44d=0A=
>  ? _raw_write_lock_irqsave+0xb0/0xb0=0A=
>  ? blk_queue_free_zone_bitmaps+0xd0/0xd0=0A=
>  sd_zbc_read_zones+0x8cf/0x11a0=0A=
>  sd_revalidate_disk+0x305c/0x64e0=0A=
>  ? __device_add_disk+0x776/0xf20=0A=
>  ? read_capacity_16.part.0+0x1080/0x1080=0A=
>  ? blk_alloc_devt+0x250/0x250=0A=
>  ? create_object.isra.0+0x595/0xa20=0A=
>  ? kasan_unpoison_shadow+0x33/0x40=0A=
>  sd_probe+0x8dc/0xcd2=0A=
>  really_probe+0x20e/0xaf0=0A=
>  __driver_attach_async_helper+0x249/0x2d0=0A=
>  async_run_entry_fn+0xbe/0x560=0A=
>  process_one_work+0x764/0x1290=0A=
>  ? _raw_read_unlock_irqrestore+0x30/0x30=0A=
>  worker_thread+0x598/0x12f0=0A=
>  ? __kthread_parkme+0xc6/0x1b0=0A=
>  ? schedule+0xed/0x2c0=0A=
>  ? process_one_work+0x1290/0x1290=0A=
>  kthread+0x36b/0x440=0A=
>  ? kthread_create_worker_on_cpu+0xa0/0xa0=0A=
>  ret_from_fork+0x22/0x30=0A=
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
> =0A=
> When the device is already gone we end up with the following scenario:=0A=
> The device's capacity is 0 and thus the number of zones will be 0 as well=
. When=0A=
> allocating the bitmap for the conventional zones, we then trip over a NUL=
L=0A=
> pointer.=0A=
> =0A=
> So if we encounter a zoned block device with a 0 capacity, don't dare to=
=0A=
> revalidate the zones sizes.=0A=
> =0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
> =0A=
> Note: This is a hot-fix for 5.8, we're working on something to make a=0A=
> recoverable error recoverable.=0A=
> =0A=
> =0A=
>  block/blk-zoned.c | 3 +++=0A=
>  1 file changed, 3 insertions(+)=0A=
> =0A=
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
> index 23831fa8701d..480dfff69a00 100644=0A=
> --- a/block/blk-zoned.c=0A=
> +++ b/block/blk-zoned.c=0A=
> @@ -497,6 +497,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,=
=0A=
>  	if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
>  		return -EIO;=0A=
>  =0A=
> +	if (!get_capacity(disk))=0A=
> +		return -EIO;=0A=
> +=0A=
>  	/*=0A=
>  	 * Ensure that all memory allocations in this context are done as if=0A=
>  	 * GFP_NOIO was specified.=0A=
> =0A=
=0A=
I reworked sd_zbc_read_zones() and sd_zbc_revalidate_zones() to allow recov=
ering=0A=
from simple temporary errors and avoid this problem. Will send the patch=0A=
tomorrow or so after some more testing.=0A=
=0A=
But even with that patch applied, I think this patch makes the generic bloc=
k=0A=
code more solid. So:=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
