Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0C5C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96DB2208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 08:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nNVpFdS+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="umdqrOs0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgGaICP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 04:02:15 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:24458 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731479AbgGaICP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 04:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596182534; x=1627718534;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SXAg9Q/o/eCDfBpZK2xXuuFxFxxix9aoDeFzeJs8mVs=;
  b=nNVpFdS+V4UGDd08FOP8iCpnpahCXfjiBPdR8IJwnWbe+4/LMeXSdJY4
   pHmyByIhyyu4IwW4i98/7WBsRKdlQ4ZWgXL4dy94dapAcsfh7BIhcjJBa
   g6p4Mgpp4XpXyvi3bN2oS1/8lfD96it5zuAKL92k1/gL/5KbJEVMouJRR
   IvaKJCdSoz0sxpy3/LqY+uIxMjGuqwp/MP7lq0nGQKSS6QK29J70A3h1R
   zU3rZZtyRf6ebx4dWZ9Jeya7hz9lFZ4sL1wSZyAMdKq4uyMfg1Z+J0K+6
   JzsvozgNDFKR4qoWUt/EK/guEeBAdlSYTRGe9c5KN14nDISWQAEytpN3m
   Q==;
IronPort-SDR: mSmuukzt3MNAogmH/G2dHlvqMX4e0GXTh8wSrMitpgtBh5sMO4tvyCTCS5219AG2Rlcc431rjw
 FozHljBikAweJmPfKdX+681gO8KIRxhv2Ii663mRKexUWy1Seh2OLa7hvRK4GyCGYyk8/HDgOy
 ERUoNq5R16+z1qg/NJnX4bUeLhDZZzjud7CcaAisq+p7FpHi+/GauJKfyV7sbh6+dNFMQ7DLGr
 wXIusLH0FNO5xjDqzRzwPDm2hMFVF/wfUGwARK+lCNEIizXLuvMssJNm7X8x11cgVgjyEdFzUF
 CSM=
X-IronPort-AV: E=Sophos;i="5.75,417,1589212800"; 
   d="scan'208";a="253166394"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2020 16:02:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKHKLxzTmpuc2MPcfTNDapS0JHTAXQBbtoUOc1pbVFu4l65vVtTSIafxxEAD1w4pBYvVoQOABkEROTcbAaomdq6DGmRnkeNouUEfml2xi7OH1uB67iXEASytBfvBfBDjAUBb6xwGjpKuSw7aEZRvTqpDaEF2M+nbEp2fdVFBAZKQ4aJtpYefs9ZLDaVB/933cnnac7wGO2UFbV6BG9vs8pNpoyMh7/SfWhS1hMHMUX381IfmO5OBfFzMqhQ/dPzKk7ChTbnsNvCveRNnxeI8jZJ6cLWc/98xo/6UzwxGGnRfz6j54S5cb4devq1Kcx/Fe88fkZbRBf/O5152HcMTIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNtzbKxfLzI4clOtMfno65RnOurnSqc8dS+uWl8I3ao=;
 b=UcH8q4LEyFiCRtagwiHRJkAwqNFFtF3HbYGR2/GplZBKtxbPnccpd/uI52QmfmEuyttANuPcmQNwc9OpNUACvF30ehXyOjLkGU9O7SOz70fryNKQ4atLkWGRfs4Z921HoYlmDEiUhRScY/iyFsCcWS5of+4Mf8p/kcnOhRvDznRIV0on2eS/QC/FRoTp9vcfQKIHpmUG55rfzVR0G2kKpsIZTQiU/w/MXRu8ljZ5NnzzB+LSoaUP46KZt0RjP6OVgPX6NiDtaCPJnbqjxXqmyCnp7Qc5kU/evYD1kAFIO2p28YlC6VvrA94F0QF94O92LCUj8YxfzaABjKPL5QDesA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNtzbKxfLzI4clOtMfno65RnOurnSqc8dS+uWl8I3ao=;
 b=umdqrOs0JjTLVvhlht43PBHvU0GQCY6EMecZdaTm5LxQdrqFX8gmX8fdV/a0fpfOf2ZbcXqiK71xprNnMTn/kCmypicv+GqvKo78K1IcMALALWzMMvkOiFs2JPAJwG7qOKnTqwLtOQGH7BT2UvRZjIQP/yi+FDfXvVZSVTNFnE0=
Received: from MWHPR04MB3758.namprd04.prod.outlook.com (2603:10b6:300:fb::8)
 by MWHPR04MB0878.namprd04.prod.outlook.com (2603:10b6:301:3c::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Fri, 31 Jul
 2020 08:01:59 +0000
Received: from MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137]) by MWHPR04MB3758.namprd04.prod.outlook.com
 ([fe80::718a:d477:a4f1:c137%7]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 08:01:58 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Topic: [PATCH] block: don't do revalidate zones on invalid devices
Thread-Index: AQHWZmQfso33Lb4oTE6/FvtKreElsw==
Date:   Fri, 31 Jul 2020 08:01:58 +0000
Message-ID: <MWHPR04MB37588ABB75E6A8B1E587AEDDE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
References: <20200730112517.12816-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751A56EDE1C372CB7531EE0E7710@CY4PR04MB3751.namprd04.prod.outlook.com>
 <SN4PR0401MB3598C060632877CA0C46918A9B4E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 77b5e50a-1a3b-45a4-9212-08d835280017
x-ms-traffictypediagnostic: MWHPR04MB0878:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR04MB0878BC634272BE6A813442CEE74E0@MWHPR04MB0878.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fnEwHTGOVzlqBYplSjR1mOHNlWZF2DgKdvbUVC0RAwULrmNDLM81z4IJJ3ozhmYeamtSroGQsrNnCahleXmGgE7Q/i9zXPp7lcOIPXHNwNOCeSXkGMD/4AfheEIhVZYcAlbc2qoXTfrVMf+Ee3RAgKr8EH34YwS22Pz38GoYhMQq/FY2odYPQ1a8f8JlJQYaEVi8LcsWmKucmFNggCT0+JGFQJEZpaZc0GYGiRLnlyO/5icU24HwiD8vmTdtDdzzSIf4H83HG8h3R5webHuFryan8g08u8Y2HM24n+3KpQSqQ6/zRBa2XF6dSQFbgTAbJbyAdx/63A2dDur+vMLYEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR04MB3758.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(9686003)(55016002)(83380400001)(8676002)(86362001)(8936002)(4326008)(76116006)(66556008)(64756008)(66446008)(66476007)(52536014)(66946007)(316002)(5660300002)(91956017)(71200400001)(33656002)(186003)(2906002)(26005)(6506007)(53546011)(110136005)(478600001)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tYf1fH2WaA9lfN+nS6Xg8ojlLuNRzLtV8CWFzZ2ZA70ZyMd1c6nEblmEuKlC1myjhH5SKu5deUzizxFo331eLk3jn3IQcWil39phly4/vJJHZhzdheIgtO7dSiC3qaS76xPY3TQgR7FbGD2jnyBSC+1iiElAaOFXx9mKVM5qd7MRtI2L7I0D/JmQ6lkzEysHCrL3QhOaeVj11AVTqgbL5V0yMvwHk/B4hN27TqbfR7ufGYuI7RLrqEKLdlye2V2DfKE3TkYFd54rIbpK9dnwql3A0SaH4xl2Uxr8CMJ0OW9/Gc11WMdsF0WhVjCEDGpxFU9cC9yvrO0Nctvqp3AnPBENmd5lqKgxT2jFw9fK5Gea32+vhoj7IJ23/eMRfjD+7KTxyZ037JxkHhS0dzADG/49NW4a6/0RQ0Xe+zT21u3eSwvcFFLDnh8aVb/e3HZVq4otpFrINDRsJDDNO7MWM3unP7et9Tv0d4Re/lOmC0phVRlHMuoBVio0j+kaZ2ojDv02F7Bdjii5S8Sp9tduv2Qlr0MHnDJBQOk81RZwW5qsV9qS60JApb/J+3GuO8jqz6rrgP860c1pWRhedRb5UYqn7nL4ZtMSCE2t8CLJIemuuCOykRwRzyaODrjg9iYCF5tGkFCpu5wYRrNFs4y9jA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR04MB3758.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b5e50a-1a3b-45a4-9212-08d835280017
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 08:01:58.8154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MbVTBxZWS1qd0YR7o4GesZCfltZ9KQuF2Fh4vicR475Vt1QI/CXfWTHsNiv41ItyMhePsRsdxKhoNsTjxpgJeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0878
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/31 16:43, Johannes Thumshirn wrote:=0A=
> On 30/07/2020 14:33, Damien Le Moal wrote:=0A=
>> On 2020/07/30 20:25, Johannes Thumshirn wrote:=0A=
>>> When we loose a device for whatever reason while (re)scanning zones, we=
=0A=
>>> trip over a NULL pointer in blk_revalidate_zone_cb, like in the followi=
ng=0A=
>>> log:=0A=
>>>=0A=
>>> sd 0:0:0:0: [sda] 3418095616 4096-byte logical blocks: (14.0 TB/12.7 Ti=
B)=0A=
>>> sd 0:0:0:0: [sda] 52156 zones of 65536 logical blocks=0A=
>>> sd 0:0:0:0: [sda] Write Protect is off=0A=
>>> sd 0:0:0:0: [sda] Mode Sense: 37 00 00 08=0A=
>>> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't su=
pport DPO or FUA=0A=
>>> sd 0:0:0:0: [sda] REPORT ZONES start lba 1065287680 failed=0A=
>>> sd 0:0:0:0: [sda] REPORT ZONES: Result: hostbyte=3D0x00 driverbyte=3D0x=
08=0A=
>>> sd 0:0:0:0: [sda] Sense Key : 0xb [current]=0A=
>>> sd 0:0:0:0: [sda] ASC=3D0x0 ASCQ=3D0x6=0A=
>>> sda: failed to revalidate zones=0A=
>>> sd 0:0:0:0: [sda] 0 4096-byte logical blocks: (0 B/0 B)=0A=
>>> sda: detected capacity change from 14000519643136 to 0=0A=
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>> BUG: KASAN: null-ptr-deref in blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>> Write of size 8 at addr 0000000000000010 by task kworker/u4:1/58=0A=
>>>=0A=
>>> CPU: 1 PID: 58 Comm: kworker/u4:1 Not tainted 5.8.0-rc1 #692=0A=
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-=
0-gf21b5a4-rebuilt.opensuse.org 04/01/2014=0A=
>>> Workqueue: events_unbound async_run_entry_fn=0A=
>>> Call Trace:=0A=
>>>  dump_stack+0x7d/0xb0=0A=
>>>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>  kasan_report.cold+0x5/0x37=0A=
>>>  ? blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>  check_memory_region+0x145/0x1a0=0A=
>>>  blk_revalidate_zone_cb+0x1b7/0x550=0A=
>>>  sd_zbc_parse_report+0x1f1/0x370=0A=
>>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>>  ? sectors_to_logical+0x60/0x60=0A=
>>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>>  ? blk_req_zone_write_trylock+0x200/0x200=0A=
>>>  sd_zbc_report_zones+0x3c4/0x5e0=0A=
>>>  ? sd_dif_config_host+0x500/0x500=0A=
>>>  blk_revalidate_disk_zones+0x231/0x44d=0A=
>>>  ? _raw_write_lock_irqsave+0xb0/0xb0=0A=
>>>  ? blk_queue_free_zone_bitmaps+0xd0/0xd0=0A=
>>>  sd_zbc_read_zones+0x8cf/0x11a0=0A=
>>>  sd_revalidate_disk+0x305c/0x64e0=0A=
>>>  ? __device_add_disk+0x776/0xf20=0A=
>>>  ? read_capacity_16.part.0+0x1080/0x1080=0A=
>>>  ? blk_alloc_devt+0x250/0x250=0A=
>>>  ? create_object.isra.0+0x595/0xa20=0A=
>>>  ? kasan_unpoison_shadow+0x33/0x40=0A=
>>>  sd_probe+0x8dc/0xcd2=0A=
>>>  really_probe+0x20e/0xaf0=0A=
>>>  __driver_attach_async_helper+0x249/0x2d0=0A=
>>>  async_run_entry_fn+0xbe/0x560=0A=
>>>  process_one_work+0x764/0x1290=0A=
>>>  ? _raw_read_unlock_irqrestore+0x30/0x30=0A=
>>>  worker_thread+0x598/0x12f0=0A=
>>>  ? __kthread_parkme+0xc6/0x1b0=0A=
>>>  ? schedule+0xed/0x2c0=0A=
>>>  ? process_one_work+0x1290/0x1290=0A=
>>>  kthread+0x36b/0x440=0A=
>>>  ? kthread_create_worker_on_cpu+0xa0/0xa0=0A=
>>>  ret_from_fork+0x22/0x30=0A=
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>>>=0A=
>>> When the device is already gone we end up with the following scenario:=
=0A=
>>> The device's capacity is 0 and thus the number of zones will be 0 as we=
ll. When=0A=
>>> allocating the bitmap for the conventional zones, we then trip over a N=
ULL=0A=
>>> pointer.=0A=
>>>=0A=
>>> So if we encounter a zoned block device with a 0 capacity, don't dare t=
o=0A=
>>> revalidate the zones sizes.=0A=
>>>=0A=
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
>>> ---=0A=
>>>=0A=
>>> Note: This is a hot-fix for 5.8, we're working on something to make a=
=0A=
>>> recoverable error recoverable.=0A=
>>>=0A=
>>>=0A=
>>>  block/blk-zoned.c | 3 +++=0A=
>>>  1 file changed, 3 insertions(+)=0A=
>>>=0A=
>>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c=0A=
>>> index 23831fa8701d..480dfff69a00 100644=0A=
>>> --- a/block/blk-zoned.c=0A=
>>> +++ b/block/blk-zoned.c=0A=
>>> @@ -497,6 +497,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,=
=0A=
>>>  	if (WARN_ON_ONCE(!queue_is_mq(q)))=0A=
>>>  		return -EIO;=0A=
>>>  =0A=
>>> +	if (!get_capacity(disk))=0A=
>>> +		return -EIO;=0A=
>>> +=0A=
>>>  	/*=0A=
>>>  	 * Ensure that all memory allocations in this context are done as if=
=0A=
>>>  	 * GFP_NOIO was specified.=0A=
>>>=0A=
>>=0A=
>> I reworked sd_zbc_read_zones() and sd_zbc_revalidate_zones() to allow re=
covering=0A=
>> from simple temporary errors and avoid this problem. Will send the patch=
=0A=
>> tomorrow or so after some more testing.=0A=
>>=0A=
>> But even with that patch applied, I think this patch makes the generic b=
lock=0A=
>> code more solid. So:=0A=
>>=0A=
>> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>=0A=
>>=0A=
> =0A=
> Jens any chance we can still get this into 5.8?=0A=
=0A=
By the way, this needs a "fixes" tag too. And probably cc stable for 5.7.=
=0A=
Looking at 5.4 LTS, the bug is not present since there is a test on !nr_zon=
es=0A=
and the entire revalidation is different anyway (callback was introduced in=
 5.5=0A=
if I remember correctly).=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
