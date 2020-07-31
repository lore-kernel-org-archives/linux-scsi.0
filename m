Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DEDC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2531721883
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="g7X3n/Nk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="hiz3wmMT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731897AbgGaIlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:41:46 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:47332 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731112AbgGaIlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 04:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596184905; x=1627720905;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=s9bi8UM7F4O/eXPdpqslXtYxv1jGgTqdW23lG24Dja8=;
  b=g7X3n/Nk9kjwi6Yel63iZlYtw+IT0ZKuH2BjUvsKKiqoCqCWJiAqCcnQ
   Cg1tUcnI0GwheOsOu2gzrIL0PQ0U6rZcYU8GGQWpzABbaPlp5T/473zQT
   St0pV6+aG6qlkHXaVfvr6rNqshqsmvd6NLvnpZQ5zBXdLin0Prf1Oz3Nj
   WkmZZV2OgrlJr6KXgEUH+sSuQt1pPJ+Q/W5DOhnbVdKz3OLGayGg1i+qa
   /+IQyRXgPZFQaCxz4CVt8RRezERcIb3/JqpFO3HYGjPTm7ZFx1O+WbdWj
   vIJdVYfcegj/XZ+bP2f5FAKZOwVYm1gXwJw9b9RRtlFxFm+A1cPj/a1rZ
   Q==;
IronPort-SDR: ZzeNAjdo2oEjcNG+iw/obdma4W43yD2bIsPgMrHSV2RuVK6Px3I1b3ClP2E6CkkkK7ep8SMvND
 7tYPLY6FM7jNhC38bL8QmCPs9TSXUXOdcjvrgwV1RkH4dhQLe3GOB8sO7PW4CvmRt+khaS+414
 kpwAVQy20KQ6Aw3CbcurLNIXoklz/43mZjiqnoMb071mavkJoN9xCACmWmVKWuWwYLD5cWfU0P
 07ifqEVzzbra0Zf5+jRs1eyL9NHSJmqXr9YhAigoYzCCh6O8bB5NcoiqQc+flVVAs1wa/HDBLJ
 6lc=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143910467"
Received: from mail-bn3nam04lp2050.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.50])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 16:41:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiqG/bipg9culjTCccSCcPTKpfmBGn+vQg03xhJP3SiC4AT2LgeSsCPo5TK0a4NygGbjbOQR8jQP1RyHcrVdiF4fbG79Vdc2RIhN1x76vbWWnN663Jtrv/SbSBKC2EyYR1Z6aDWHcftWO5waVs1PmmDEY8vW/osPNBAUFzmLQLbiIYRzdoF34e5qqpMlb8J9IfPqShtTyxfk05/kqOyrLIB2cmpiZnBX64Gas+tzzH4N3+GU4sor9JIVksiXMrrIc32qCCPabgf0LhYwLr4Zj4/up+Nt6CgaZ8O0G8Tfd+jp8Kr+E0kr2nTbjJ5+Z/wCJnHb7reQP5avNAvzXFhyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeprLU8l5SN7BTKSL612NWdBshMeX42uaj8CYj5PSGw=;
 b=QMFmm+Z6qyvlBqucTHSKVYrBS4KpebT9rFXIaEeJYAtIC6EFWcKgNlaF9M5D/gabVJdEQ85LotYXlFWjMakmeERxueZumtDDgAz9LQJvSCQE95cSk0r4aM0bSmnZzi76441CM+hQ9zQyGR7PLIMXXvppbaKaNUMpA386pLP5tkOnl5+SDgX9Vj2c3MXXiK5+aWzoT0T+u4y4PUOYiB0HjHsgA/NCmnN6+SYzcaFcTs4aTdSnpoRofEDmFl95SecDEdTt6YvxET3E24E7ONXXMaR1zi6ZWTeCsbPCpSG0S0QfwA5NgG/+FDD6bcNDB/Lu9mnz8AfrTo/UoCUfL3J8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeprLU8l5SN7BTKSL612NWdBshMeX42uaj8CYj5PSGw=;
 b=hiz3wmMTtQ1GjIuTEQ7kyPBFieVouoaaAk76FBxRNgzAdAvBl9aq7p/VM2hahy4xht1oOUrZVnZMk+QuzAbMrJDG0lStMgWrgXs3ruh8436h0QGGRY8yKz4rDMXSBtiFOp7M2Aw7XribBFVAUdniR2vC27nFxkMspxFzDc4FJEM=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4687.namprd04.prod.outlook.com
 (2603:10b6:805:aa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 08:41:27 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 08:41:27 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Topic: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Index: AQHWZmQf1G5/ewlc1EevY10BGMxP1Q==
Date:   Fri, 31 Jul 2020 08:41:27 +0000
Message-ID: <SN4PR0401MB359839E29558531A690AD3A19B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200730112517.12816-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751A56EDE1C372CB7531EE0E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <SN4PR0401MB3598C060632877CA0C46918A9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <MWHPR04MB37588ABB75E6A8B1E587AEDDE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 92618923-7e05-455b-fc78-08d8352d83dd
x-ms-traffictypediagnostic: SN6PR04MB4687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB468753A24630AAB546AAFDB89B4E0@SN6PR04MB4687.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7aMSZGXxXvoEfjYsf8BTKySzokxPixPXYA/ocgk17gIzVBHF0PcyVwgRefGQUL+WDBN7YbRJwSIOSsNBwOv+ll2JU5bw1vUgmpcLBMUXr0ifA/PqRKcQZGsBzr33gKEaUdCugSPv4AHMVlKYBNRli5YKLJ8sRklR5ZzBrGP6df9YsI/FSQhPaqKKr1tBZcWVoxhdcZLp8rV3dkK8densCroDNt3KDxjo00BOiC7FIeQmCY5g5akcurZqpcsdsZpe94UMNYimgjFHBHqlVVB7/fFsksxN6WOFyMaRbtosk7cgEly+eL/nSkX6VpCBCVoQxXFwmPfJk/tcc/HLQVjxvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(316002)(8936002)(110136005)(8676002)(54906003)(55016002)(2906002)(9686003)(52536014)(5660300002)(26005)(4326008)(186003)(6506007)(53546011)(478600001)(71200400001)(76116006)(66446008)(66556008)(33656002)(66946007)(83380400001)(66476007)(64756008)(91956017)(86362001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UYqn6FQnLkEp8syK/VIEo2P+UeO1jdu8De4cTgQRjpgURku8E0LPGn8auzoDRZyNm29WC0VKIx4aDy6FiN0JzuQTOmpUbhW8R+Bix8dkLOohCcF7ZUT9V1FmyE3N1RFh436gSU/cJy4XnKiHMTxn5CL6NvmCowmucaZdZnfCiNAp2U7LOWYh8X0Lk4O1BZT1lzMGqfP1FiuudRovzQza5kUwS4+TzNe7QS2eFzPucXxiuSBrKuX8rA0ZuXTVKFzMk16c+LEX0X/rb9qFpbKIQxLa5JMCGYWeNQPlNclJWVCdRQNigxnHThbaLGa6+Aex/4Fqqh/wnDIcmB8EywAp1J2m3dg4yrb3vBhtwibqhA7Db21PsvSvFK66KlxFTeQYutqRqHkZ5EjE4yAEdR2DkOkphKOTT5cA6LPFuHiszdqSEBjz4x4I2nhdi316b3MR9bfCTPB/8BA2Wy9QMZhku+8o142AnoJ5CfKXYWrEQq58fWd5K/5sTR3cK0nwnZzb
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92618923-7e05-455b-fc78-08d8352d83dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 08:41:27.3789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 21UY8XbYhD2x43z3+0s00z7785Za3BrReOfuytZwuHiDL3cDeTNe8fLZucoFT2Y3nFBeGmS5liqqfMA0XwHSaoaf2E0m8Nml4TNUCdh1Cks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4687
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/07/2020 10:01, Damien Le Moal wrote:=0A=
> On 2020/07/31 16:43, Johannes Thumshirn wrote:=0A=
>> On 30/07/2020 14:33, Damien Le Moal wrote:=0A=
>>> On 2020/07/30 20:25, Johannes Thumshirn wrote:=0A=
>>>> When we loose a device for whatever reason while (re)scanning zones, w=
e=0A=
>>>> trip over a NULL pointer in blk_revalidate_zone_cb, like in the follow=
ing=0A=
>>>> log:=0A=
>>>>=0A=
>>>> sd 0:0:0:0: [sda] 3418095616 4096-byte logical blocks: (14.0 TB/12.7 T=
iB)=0A=
>>>> sd 0:0:0:0: [sda] 52156 zones of 65536 logical blocks=0A=
>>>> sd 0:0:0:0: [sda] Write Protect is off=0A=
>>>> sd 0:0:0:0: [sda] Mode Sense: 37 00 00 08=0A=
>>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't s=
upport DPO or FUA=0A=
>>>> sd 0:0:0:0: [sda] REPORT ZONES start lba 1065287680 failed=0A=
>>>> sd 0:0:0:0: [sda] REPORT ZONES: Result: hostbyte=3D0x00 driverbyte=3D0=
x08=0A=
>>>> sd 0:0:0:0: [sda] Sense Key : 0xb [current]=0A=
>>>> sd 0:0:0:0: [sda] ASC=3D0x0 ASCQ=3D0x6=0A=
>>>> sda: failed to revalidate zones=0A=
>>>> sd 0:0:0:0: [sda] 0 4096-byte logical blocks: (0 B/0 B)=0A=
>>>> sda: detected capacity change from 14000519643136 to 0=0A=
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>>> BUG: KASAN: null-ptr-deref in blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>> Write of size 8 at addr 0000000000000010 by task kworker/u4:1/58=0A=
>>>>=0A=
>>>> CPU: 1 PID: 58 Comm: kworker/u4:1 Not tainted 5.8.0-rc1 #692=0A=
>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0=
-0-gf21b5a4-rebuilt.opensuse.org 04/01/2014=0A=
>>>> Workqueue: events_unbound async_run_entry_fn=0A=
>>>> Call Trace:=0A=
>>>>  dump_stack+0x7d/0xb0=0A=
>>>>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>>  kasan_report.cold+0x5/0x37=0A=
>>>>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>>  check_memory_region+0x145/0x1a0=0A=
>>>>  blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>>  sd_zbc_parse_report+0x1f1/0x370=0A=
>>>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>>>  ? sectors_to_logical+0x60/0x60=0A=
>>>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>>>  sd_zbc_report_zones+0x3c4/0x5e0=0A=
>>>>  ? sd_dif_config_host+0x500/0x500=0A=
>>>>  blk_revalidate_disk_zones+0x231/0x44d=0A=
>>>>  ? _raw_write_lock_irqsave+0xb0/0xb0=0A=
>>>>  ? blk_queue_free_zone_bitmaps+0xd0/0xd0=0A=
>>>>  sd_zbc_read_zones+0x8cf/0x11a0=0A=
>>>>  sd_revalidate_disk+0x305c/0x64e0=0A=
>>>>  ? __device_add_disk+0x776/0xf20=0A=
>>>>  ? read_capacity_16.part.0+0x1080/0x1080=0A=
>>>>  ? blk_alloc_devt+0x250/0x250=0A=
>>>>  ? create_object.isra.0+0x595/0xa20=0A=
>>>>  ? kasan_unpoison_shadow+0x33/0x40=0A=
>>>>  sd_probe+0x8dc/0xcd2=0A=
>>>>  really_probe+0x20e/0xaf0=0A=
>>>>  __driver_attach_async_helper+0x249/0x2d0=0A=
>>>>  async_run_entry_fn+0xbe/0x560=0A=
>>>>  process_one_work+0x764/0x1290=0A=
>>>>  ? _raw_read_unlock_irqrestore+0x30/0x30=0A=
>>>>  worker_thread+0x598/0x12f0=0A=
>>>>  ? __kthread_parkme+0xc6/0x1b0=0A=
>>>>  ? schedule+0xed/0x2c0=0A=
>>>>  ? process_one_work+0x1290/0x1290=0A=
>>>>  kthread+0x36b/0x440=0A=
>>>>  ? kthread_create_worker_on_cpu+0xa0/0xa0=0A=
>>>>  ret_from_fork+0x22/0x30=0A=
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>>>=0A=
>>>> When the device is already gone we end up with the following scenario:=
=0A=
>>>> The device's capacity is 0 and thus the number of zones will be 0 as w=
ell. When=0A=
>>>> allocating the bitmap for the conventional zones, we then trip over a =
NULL=0A=
>>>> pointer.=0A=
>>>>=0A=
>>>> So if we encounter a zoned block device with a 0 capacity, don't dare =
to=0A=
>>>> revalidate the zones sizes.=0A=
>>>>=0A=
>>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>>>> ---=0A=
>>>>=0A=
>>>> Note: This is a hot-fix for 5.8, we're working on something to make a=
=0A=
>>>> recoverable error recoverable.=0A=
>>>>=0A=
>>>>=0A=
>>>>  block/blk-zoned.c | 3 +++=0A=
>>>>  1 file changed, 3 insertions(+)=0A=
>>>>=0A=
>>>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
>>>> index 23831fa8701d..480dfff69a00 100644=0A=
>>>> --- a/block/blk-zoned.c=0A=
>>>> +++ b/block/blk-zoned.c=0A=
>>>> @@ -497,6 +497,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk=
,=0A=
>>>>  	if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
>>>>  		return -EIO;=0A=
>>>>  =0A=
>>>> +	if (!get_capacity(disk))=0A=
>>>> +		return -EIO;=0A=
>>>> +=0A=
>>>>  	/*=0A=
>>>>  	 * Ensure that all memory allocations in this context are done as if=
=0A=
>>>>  	 * GFP_NOIO was specified.=0A=
>>>>=0A=
>>>=0A=
>>> I reworked sd_zbc_read_zones() and sd_zbc_revalidate_zones() to allow r=
ecovering=0A=
>>> from simple temporary errors and avoid this problem. Will send the patc=
h=0A=
>>> tomorrow or so after some more testing.=0A=
>>>=0A=
>>> But even with that patch applied, I think this patch makes the generic =
block=0A=
>>> code more solid. So:=0A=
>>>=0A=
>>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>>=0A=
>>>=0A=
>>=0A=
>> Jens any chance we can still get this into 5.8?=0A=
> =0A=
> By the way, this needs a "fixes" tag too. And probably cc stable for 5.7.=
=0A=
> Looking at 5.4 LTS, the bug is not present since there is a test on !nr_z=
ones=0A=
> and the entire revalidation is different anyway (callback was introduced =
in 5.5=0A=
> if I remember correctly).=0A=
> =0A=
> =0A=
=0A=
The callback got introduced with commit d41003513e61 ("block: rework zone r=
eporting") in=0A=
v5.5-rc1 but looking at blk_revalidate_zone_cb() at this commit I think pas=
sing in a =0A=
gendisk with 0 capacity won't do much harm.=0A=
=0A=
The correct fixes tag will be:=0A=
=0A=
Fixes: 6c6b35491422 ("block: set the zone size in blk_revalidate_disk_zones=
 atomically")=0A=
=0A=
Starting with this commit we're calculating the number of zones based on th=
e disk's capacity=0A=
unconditional of what the capacity could be.=0A=
=0A=
But that commit landed in v5.5 as well.=0A=
