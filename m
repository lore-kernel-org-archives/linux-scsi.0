Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68709C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321122067D
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P26e1bK7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JQ8PKGsZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgGaHnx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 03:43:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42642 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731789AbgGaHnw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 03:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596181430; x=1627717430;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=AWM99crnjZeLyti8MnOh3WfMAIsfIauI2nkaSYRKdyI=;
  b=P26e1bK7j/tkTRGli39wJNEF5HPnrRcEiorpDz0F8js9UeWseqgC8NEA
   cmb+ziBww4ZVfZ0eyn4kU33G7Q87hePR2uV5eFx41Gukhqi8NJkfdR/+C
   AsLiL0aok60e3i00rMZSuPYjdOq4PiKBX2KZzNNkjqtx1O5UwNmz8Kpak
   BMZx3/cocNWuYA6a5NrRF/uAinGkAlTl3foyBTG+a1yzDNjozLKAChR0g
   lWijtBdMfH1dO2aretugfD5eyatOBWwhIrcAJl2TdtLPXA/Sw47Kb2jqa
   EZZDOmQc67t6AqDt/oVLWKAwkBu/7Aslg4zJFMWfdlCZn+NCTAE+Pdyx2
   A==;
IronPort-SDR: 7oMhbPNOraFa5lciYAQP+abe8OnGBnhsAWFU0dHbMG6ibhOifwDVpt/vKlX8452FxJ7fWfL+ed
 Tjt1cOfyz+I8T9XzocLUaHKhuoL3CZad0bFfo4Dblf5gtEE2oaDMDv7jw9c7IuB66rhqbyGpW3
 J39x4YYC/00MRI7j1W5cICxyVXMW/D9OZ9kOUY87j4/FJWHThsz7kZd5frNuGpaLyXqbTCpMDg
 1p2+gfYAKyiRfG+DUTzjf0XnMxLwV73kE179ZqB9PmQR2aIqqWNZweD9GbVjA6ub/ubhT4LUEQ
 IBk=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="143906531"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 15:43:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFGj4ryyfOKqWcvPUj0KtDd3j6Wftpo/Hlo3uAglTLrh9efcmqRMGY+tonvOaq3FxHd7j/JMlpDfmW6Zt6fPgceDe5/tZ2ZKq0t5d1992MtRIbvnTq9wqqLxLefgVKV8E9Ru3QVwu4P0TVWHUQrsfVGENqmoRsA/SkUciwazlP0Zh9WPNvgT2MGBxueUflTm0cjlFnWy2lWcI4wXkGDRK0HjxyAaVbBD8HHHGZdP5RJG7q6UmXyDr5M4G1MOjY6K4COKAmg6ENQP4V1PNYr6ag230FCj2ZOcWam+50LcUJPh4o85kG7nIgg2zKrXgjTZCsV1rVeZ+JMb4SDs5OpyHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqy6wrLIV4Hh+unQSYxzX+Bh/1v0zrI9nGBfIlfnKGI=;
 b=Nl9GxeX7gW+1tZNbYGqNVNOoBwCkJnwe5IS+yF+OucnEALHpciLYJKkjiMakuzoRZrikYND33KOPRs1Rwlpwn80APn84Y3Hso9g2S4i4ESWBMEyfUgGDVXuNujxUXRmYhTu8ne2XOUGZbSVdQp5QpN3tehZfwSyILUuADgvm/TXaiKVXmwv+yFgcvZ3wZeU/MnQK9gU/oYvWjmAG03cawmFRDEgpsyq5PXrPjWoZVQl/b7OXrxO6Uvely81Ov0c0GPmwzviLj81cjHRqgOZg0dXeCyKq0FrDWTa9aebZxGHecDmtB2ATQQ/6Kk3WchC3Qt/o3q7IzqhrzU+WASukPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqy6wrLIV4Hh+unQSYxzX+Bh/1v0zrI9nGBfIlfnKGI=;
 b=JQ8PKGsZxg9N2bmdTVrayD32uGHtXDHbD88diLSmNODSvgI4np+8q9b4r/mvViD71i1GOqHrptoZP+/VdWBeYCsboVEbRYTj0CZuAdCFs1K95ETJsKuuEGJl8/m/VSZOY26oJPn9gjhAJh/sh1u7FjYNl7UdaL5Zefi//C4GOBc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3966.namprd04.prod.outlook.com
 (2603:10b6:805:48::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 07:43:49 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 07:43:49 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Topic: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Index: AQHWZmQf1G5/ewlc1EevY10BGMxP1Q==
Date:   Fri, 31 Jul 2020 07:43:49 +0000
Message-ID: <SN4PR0401MB3598C060632877CA0C46918A9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200730112517.12816-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751A56EDE1C372CB7531EE0E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1828cf0a-5fc9-4c4a-a18d-08d835257686
x-ms-traffictypediagnostic: SN6PR04MB3966:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB3966A42EA1F68726C3C5EA6A9B4E0@SN6PR04MB3966.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: st7rNszKX9DQo5kjeoJpemBXGqwLjN02F6MUTlY97umy2S7FCU5b0OOMUXDqqob3F2Rlat366ln64e1jVIsbmVfTOSoRW/vFxSwt2Mc6mz/3RWfC+xq7moa2eBPG9JL6cNFTj96wzQ/bauK+lOVx/mZPgmNgw6R6wYh5EBYmJE/dM++4nv0C0gj0ahQiEijy5VqFAqigkfClei8NdKun/QR1lEC30m5I20ZshJAo3GbqECznIO9lnOaZSoOA1wXdghV7nrlLY7wtL9ybcio56kU0de+vwcxZQiasAq1XDc+c/b7F3p21CLyBABoL0wEEkzhAzLPWvST2hyui1P5lVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(71200400001)(9686003)(2906002)(8676002)(4326008)(86362001)(55016002)(478600001)(6506007)(26005)(110136005)(8936002)(52536014)(54906003)(53546011)(5660300002)(66946007)(83380400001)(66446008)(64756008)(66556008)(66476007)(186003)(316002)(33656002)(7696005)(91956017)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Vn2jMEN8qXBk+1ysrATnesOSlckI+711rXDEjr44c5dlT7+ah+cmkJJffHyEfMUljb7gnsynhk5+VLvwVJUO5hHi+0XpFkeAS0pONrPf3VI7Ad9zJ6askV1qA/d1TFiML3iZX4fcRl/oh9xPjAmoiyYyvOI5oyBRhai5s1t5a8sOa0yqC+OVjIY1juYAe0S07DDxrlhlAJP0Gq/VRvvR4WXZsvd5icYUHBivsR74uvre+cBjiD+++eoLnyu/wshbyTQgoJbIN0QM6QkG8xiRItPIW1k/5TDjfoh2xOCamMITC5ez0AsuiMzq2tEiPl6v7iXxRQDQqUBEfL8+D9McC/r5vSOlQkSJS+mE5K+XgX2Zc5/1nbichqe87uT2WQEyRdMtuEzh2axmWqLOhq+DATIb4K30tpa7itkGnpxUSeOwu0Rc8y/L2OCKrcGohhuIgkP5qBT8CaZTbRkGop+s42+h/aRnSw+9+iJQzoNDNVoq3LjtKHqbfrFk1dXWwurvVYT9tYC1L88MUHmTLnIle5n0ZXojHwbC8BCZG/57LTViTLikg2ojEeFq+YIhXV98uc2LvysbQa8OTuHeuH+95FzKeX6f57pTM2bK6X1tK7h6+S1LbhZqJlbuiqZLIUakWivaQuxBwwyVvt21DmCQcw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1828cf0a-5fc9-4c4a-a18d-08d835257686
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 07:43:49.0172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MyniDWQiTZmMo2GfU8dQcg6/t76O6FuXMOFcbxrjsLry38SJc9liZfDsYgd24owzsSkLBkNZoOjmgvXpAg9+e3x9bqnMWcfJyHPgxhTjea0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3966
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/07/2020 14:33, Damien Le Moal wrote:=0A=
> On 2020/07/30 20:25, Johannes Thumshirn wrote:=0A=
>> When we loose a device for whatever reason while (re)scanning zones, we=
=0A=
>> trip over a NULL pointer in blk_revalidate_zone_cb, like in the followin=
g=0A=
>> log:=0A=
>>=0A=
>> sd 0:0:0:0: [sda] 3418095616 4096-byte logical blocks: (14.0 TB/12.7 TiB=
)=0A=
>> sd 0:0:0:0: [sda] 52156 zones of 65536 logical blocks=0A=
>> sd 0:0:0:0: [sda] Write Protect is off=0A=
>> sd 0:0:0:0: [sda] Mode Sense: 37 00 00 08=0A=
>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't sup=
port DPO or FUA=0A=
>> sd 0:0:0:0: [sda] REPORT ZONES start lba 1065287680 failed=0A=
>> sd 0:0:0:0: [sda] REPORT ZONES: Result: hostbyte=3D0x00 driverbyte=3D0x0=
8=0A=
>> sd 0:0:0:0: [sda] Sense Key : 0xb [current]=0A=
>> sd 0:0:0:0: [sda] ASC=3D0x0 ASCQ=3D0x6=0A=
>> sda: failed to revalidate zones=0A=
>> sd 0:0:0:0: [sda] 0 4096-byte logical blocks: (0 B/0 B)=0A=
>> sda: detected capacity change from 14000519643136 to 0=0A=
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>> BUG: KASAN: null-ptr-deref in blk_revalidate_zone_cb+0x1b7/0x550=0A=
>> Write of size 8 at addr 0000000000000010 by task kworker/u4:1/58=0A=
>>=0A=
>> CPU: 1 PID: 58 Comm: kworker/u4:1 Not tainted 5.8.0-rc1 #692=0A=
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0=
-gf21b5a4-rebuilt.opensuse.org 04/01/2014=0A=
>> Workqueue: events_unbound async_run_entry_fn=0A=
>> Call Trace:=0A=
>>  dump_stack+0x7d/0xb0=0A=
>>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>  kasan_report.cold+0x5/0x37=0A=
>>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>  check_memory_region+0x145/0x1a0=0A=
>>  blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>  sd_zbc_parse_report+0x1f1/0x370=0A=
>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>  ? sectors_to_logical+0x60/0x60=0A=
>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>  sd_zbc_report_zones+0x3c4/0x5e0=0A=
>>  ? sd_dif_config_host+0x500/0x500=0A=
>>  blk_revalidate_disk_zones+0x231/0x44d=0A=
>>  ? _raw_write_lock_irqsave+0xb0/0xb0=0A=
>>  ? blk_queue_free_zone_bitmaps+0xd0/0xd0=0A=
>>  sd_zbc_read_zones+0x8cf/0x11a0=0A=
>>  sd_revalidate_disk+0x305c/0x64e0=0A=
>>  ? __device_add_disk+0x776/0xf20=0A=
>>  ? read_capacity_16.part.0+0x1080/0x1080=0A=
>>  ? blk_alloc_devt+0x250/0x250=0A=
>>  ? create_object.isra.0+0x595/0xa20=0A=
>>  ? kasan_unpoison_shadow+0x33/0x40=0A=
>>  sd_probe+0x8dc/0xcd2=0A=
>>  really_probe+0x20e/0xaf0=0A=
>>  __driver_attach_async_helper+0x249/0x2d0=0A=
>>  async_run_entry_fn+0xbe/0x560=0A=
>>  process_one_work+0x764/0x1290=0A=
>>  ? _raw_read_unlock_irqrestore+0x30/0x30=0A=
>>  worker_thread+0x598/0x12f0=0A=
>>  ? __kthread_parkme+0xc6/0x1b0=0A=
>>  ? schedule+0xed/0x2c0=0A=
>>  ? process_one_work+0x1290/0x1290=0A=
>>  kthread+0x36b/0x440=0A=
>>  ? kthread_create_worker_on_cpu+0xa0/0xa0=0A=
>>  ret_from_fork+0x22/0x30=0A=
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>=0A=
>> When the device is already gone we end up with the following scenario:=
=0A=
>> The device's capacity is 0 and thus the number of zones will be 0 as wel=
l. When=0A=
>> allocating the bitmap for the conventional zones, we then trip over a NU=
LL=0A=
>> pointer.=0A=
>>=0A=
>> So if we encounter a zoned block device with a 0 capacity, don't dare to=
=0A=
>> revalidate the zones sizes.=0A=
>>=0A=
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>> ---=0A=
>>=0A=
>> Note: This is a hot-fix for 5.8, we're working on something to make a=0A=
>> recoverable error recoverable.=0A=
>>=0A=
>>=0A=
>>  block/blk-zoned.c | 3 +++=0A=
>>  1 file changed, 3 insertions(+)=0A=
>>=0A=
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
>> index 23831fa8701d..480dfff69a00 100644=0A=
>> --- a/block/blk-zoned.c=0A=
>> +++ b/block/blk-zoned.c=0A=
>> @@ -497,6 +497,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,=
=0A=
>>  	if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
>>  		return -EIO;=0A=
>>  =0A=
>> +	if (!get_capacity(disk))=0A=
>> +		return -EIO;=0A=
>> +=0A=
>>  	/*=0A=
>>  	 * Ensure that all memory allocations in this context are done as if=
=0A=
>>  	 * GFP_NOIO was specified.=0A=
>>=0A=
> =0A=
> I reworked sd_zbc_read_zones() and sd_zbc_revalidate_zones() to allow rec=
overing=0A=
> from simple temporary errors and avoid this problem. Will send the patch=
=0A=
> tomorrow or so after some more testing.=0A=
> =0A=
> But even with that patch applied, I think this patch makes the generic bl=
ock=0A=
> code more solid. So:=0A=
> =0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> =0A=
> =0A=
=0A=
Jens any chance we can still get this into 5.8?=0A=
