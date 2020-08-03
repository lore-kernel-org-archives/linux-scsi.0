Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30D9C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 08:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B26682070A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 08:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DHL0GDAG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gDpDOT3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgHCItG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 04:49:06 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51881 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgHCItF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 04:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596444545; x=1627980545;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=vVGgPzMLMVkglQvBUxn0V2zf6bpbMCoJ/5pDnAqH9IE=;
  b=DHL0GDAGosTzU5UQu0ZcmQB5PlVsRo0pvFVDrlgqIsLgYXGrdDOB8m93
   uws14sX/aVBaeb+y52F6sLfVNkd37q/exZ6tDI7/j+zuvuqbwiHqURNSe
   k+ccMAVQEXy95w8KirZaRE2KKgiI7jBqQD1TtLJduPnznEI5dC7jddTJA
   tvM9fQknbJi61hDaUnJB0I0Vr24w4BLL5ao3aJN3QjfI1ps4rpZ5BukjD
   gth3mdJyBxkqbYDfMriN1xs8QWbrnRhfkWBmc61bwTIdseI6Vi8b+pXx/
   Zf4jvUZ/iobXKcSZcQSw0pf2HOH6n9/cg9JNxWX5IRksN3ppxhcjQ2ND8
   w==;
IronPort-SDR: B3oReA5kOgFOvZz5rApjmfK1MoJDznSq/BKIHy3Ai2Ti360hDBA1hhxNLYX53uWeJwUFPOWXsM
 2PV607xBKR0YFcxT4I5/re96olDGxoYwNAvlUKbpzL9weETJvGbvhWiP27FNNLX/K+UsbNwqc0
 UYoXKLIX8e+e0CWvzCLSLUoO5FqEZ3PWDShUofSiSL8F+chA6lf8/QjS6w+rnuSsNX/UL19sqH
 gcB++aQBe2NK8gRTsAqSOkimVWRY+K45IlUwMWd2LvWtVjtWOlK2XDnsv5CJeDzgS5/dzYHCDN
 2V0=
X-IronPort-AV: E=Sophos;i="5.75,429,1589212800"; 
   d="scan'208";a="144075628"
Received: from mail-dm6nam12lp2175.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.175])
  by ob1.hgst.iphmx.com with ESMTP; 03 Aug 2020 16:49:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqXy+j9eZLKgHRjryJAbnZSt6FxVlw29R7+RmDfDZ3UJFVlPWfRNXAkehgtXRRWWJuoditE9wHG5L6rgczKVz4WxjBuixlZ4hBFi0mde/niqzBvmSCRwUZwxdyEEns3fds8LOR1pjY2GYM7W70slq7xMeadcKc8r9MeSzIcM/2LzEut9ieoAuaSM1qW9vQSgyM13jD8kHF35cEYPYB1J6zCZ5yy7AsVLC/NRPWaU/w2M+HBBN7KSm6D3pNWJ9p35k54RfwOSJRaMV7rJUedZeUZmLHImo9nXrqZriwfhRiG/vdbko0zZYc8tbXU+moVBUVHS8+EuqZ71+JU71rh6cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bpi27uS4kWqLBwBs7y4ngvIh6o/40FYUp1iFadgNduM=;
 b=C1lhj/DxlPJkVw8q5wzdLai6KpCh/5bYSW+viU6JSbJJ3ljlFI5wV2sOHacwcyz4yvSSgFXtyRRdegCb15FlPKpHKAnJ0T9Rj+pab9GodKqB2XUaRK/oM1VNl6sip95q/Bs1c+LhdhcuokA8qPVX9xgfELjn60XuNlik2bSSc0GIBf1t8D3pijL3d751pk4cNXyLx/jJziY5Wy67GjXUhX55kQX3edzZIjHSKTHXiEjmhhwLKOQqPH2jzRfY5LQky/v+ttkvKNrnqePMhawKGreD141cVuqfYZ0HRcrFlw28p47ybT3ubYYTtHY3gcDV4chYE+mC+osi/jZDvJVQnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bpi27uS4kWqLBwBs7y4ngvIh6o/40FYUp1iFadgNduM=;
 b=gDpDOT3Eg2fMqP9yiMbqQfvLqB0oHj5WBxXKWneViYRO7ilAo1lNwwUtLHl0cMUMMX2gI9SgNx3XdVSMymplsdg0SeCSbJ2iGMZ6xT6st2Lk67QkNa6YHDlq2eR9TI2fAReje+AHSPaXHiUfQRj0vqW2l79LMht95sq254Cic6Q=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4047.namprd04.prod.outlook.com
 (2603:10b6:805:46::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 08:49:00 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 08:49:00 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Topic: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Index: AQHWZmQf1G5/ewlc1EevY10BGMxP1Q==
Date:   Mon, 3 Aug 2020 08:49:00 +0000
Message-ID: <SN4PR0401MB359890918C5497A31D894E079B4D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200730112517.12816-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751A56EDE1C372CB7531EE0E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <SN4PR0401MB3598C060632877CA0C46918A9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <a3ad1a03-d279-b57f-152d-ee41ad8883a5@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 53766830-f442-4c74-afac-08d8378a1161
x-ms-traffictypediagnostic: SN6PR04MB4047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB40473219D4A6CD3220152A199B4D0@SN6PR04MB4047.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y990JBQl5ZHzFgT/crNk2NO1T1DQ3QaF/ZcaIsWVyCjO8nxxHQCW+5VHXjP8UCNCfN5t6WRAWo+WZcixvrk8HAifR3R1LsGcuzdH6QFlLhYRrNx9Xqmo2Eo9ACrgBA9BBNVZF5wHEIiazuAa4r3TAV8nbTqjHlH6N2P/Jcon/IFSK57YdCU9Y/tzPAJ1BAaNpFnp0wMwx6F7j9nq9rcDn32tAw2ipW+wHZg3QsV4OI7lNQ0nQdni1Sxr8UcsEu5BPlPhYHozpPXq7/trgMPkmw/REIWt+L/A7IP0VS/NXCXezhwsEP+b/cjScQemFyzoSvD+RSi/zcllc5h+yWLmyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(4326008)(6506007)(26005)(76116006)(91956017)(53546011)(86362001)(55016002)(71200400001)(2906002)(52536014)(83380400001)(9686003)(33656002)(5660300002)(8676002)(66946007)(186003)(8936002)(110136005)(66446008)(316002)(66556008)(7696005)(478600001)(6636002)(54906003)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DBm8avpBUfo1qdo+zyQ0eWnYFMZ1Xk4jgM8QmT9lWQ2fccicSbe3NAxlpDnYREXGMN1gR4dgeK0+Vt0jFJ22XPpHzPFPduuACHUMhj8mOXhpQS5+ISQ6p/FpNOX+3obEtDtW0E6rUyBOXxRbZtQ0PP0zgGdTzZBXV3qwmk3LDxm2CJcseBiOUL31RJHOEQw14D3GznosLSHzZHnSV0Lxpmqb74sI6c5PaZwMUiBIS29xhiN1b9XZkkvf324BCHqOfTe9Nz1EhFpRuA4dSbPDwRX0/iCHkI0BZlW8mrSDnlvUP1Io9zdZsD1lEBR8t4Y9hTyxr556sVz46UVnxK3n4VSHT2LJTeA9g0TxVFhzjohXY5LSFAwUkyqLIGBn1msllU23UjVH3u/tciOMgdtv7cyvNCnbxFArrsR0wXWeW1nU6g+d8KLHa0jpZReskzaH0igObNXCdANiBS1ompIeXfGIoUlaeKHJ+fKWLIL0PuKlIWzbjjVD6xQwrDmNPFqrGTvneHZTn5fnEvC5KLjcNwDUk4mUBTXcHz34BIWafwiN2Dwognc75/wlc5ViuznYOFzLIOyhklTOgZYf/NigeHYcsqATkSEz8jJOeMhZK7ERuHtkMEg7EGhND4IqBzGSG6kqSZQaakh+ru9+3WOq7g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53766830-f442-4c74-afac-08d8378a1161
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 08:49:00.7785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g+K7u4Z1W9eztTmJqwsdHJ5fmIe/l3yHC6IRi/IylP9bC7DNhse4mmM7osQu9AzQ2gNU0PSBjkIpgjywEPUT4xenLkbtxMWRkBcgizxkZpc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4047
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/08/2020 00:33, Jens Axboe wrote:=0A=
> On 7/31/20 1:43 AM, Johannes Thumshirn wrote:=0A=
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
> I'm not going to push this out now, if 5.8 is being cut on Sunday. If we=
=0A=
> happen to get an -rc8, then it's not impossible.=0A=
> =0A=
> But this isn't a regression in this merge window as far as I can tell,=0A=
> so really shouldn't be critical to get in. Marking it for stable etc and=
=0A=
> queueing for 5.9 may be the saner approach, imho.=0A=
> =0A=
=0A=
You're right. When I wrote this I was still under the impression it's a =0A=
regression I did introduce with the zone append series.=0A=
=0A=
Anyway, thanks for pulling in.=0A=
=0A=
