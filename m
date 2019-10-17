Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4207ECE599
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 02:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B73D21928
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 02:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k4G/IQvW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jCApJUp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407272AbfJQCjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Oct 2019 22:39:06 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:57128 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392198AbfJQCjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2019 22:39:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571279945; x=1602815945;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=O6jgexmDCF91LW0yufro4R2CgVXXiSAVcyL0OuaH+CI=;
  b=k4G/IQvWThLKrRNf7iHWdnV2FSZh33kHkC4nk/hU/dlnri1j5EMm0kUY
   6UU9eyKaAybrZfXk3ZSWIzZ9hCxrKf1G2ykdrHuyJqiAfTgQdYvH0J/2P
   rOYfufFge03t2gxYqJ0cIPNGo7gqEXkwAwuWbcNv/OUGPDBGcN+UjpX7R
   /IbEEFzs2sVFQbBDOJ6igxHc7p4WzcAqeb4cjaCakcUmP4dIy94k0enRI
   v+yNip595KpXphQvOxYZ4rozpDgs9gbHTfL8nxDnWKDJn8z1vWV9pyzlh
   IjkpCi1hfFhTZx+iyB9UanNgvQh1hyAGXdtDczMnKLNeHHrVB71pz6jPh
   Q==;
IronPort-SDR: nPUbn3FVwUQIRJWV8LzpOLopzdhcao6nU8MZYHOxBsCrcCU2fy5/9v7quDQOkNm/kLWXjHsWJu
 w73pmY+DHF9vTjV2IaQXeGN+cRteaRNVDxiMNoUBSE5IMAwBMGiJzH4kAGzuqK3OFhmbVuqT3G
 PcMDQkc53NY4Qgs/nlrFUj4r1mfsoM7HMPK7HMrR+dFtt/VfIKMQEKKrgra8UqhSzh0Fv2yuHN
 BH5hDnwhGEi/d8K0/xCGwld+0C230IiigkIKMB9clltekei7R5kcnaSEL43ppDPaXvZNL7mrYo
 D8A=
X-IronPort-AV: E=Sophos;i="5.67,306,1566835200"; 
   d="scan'208";a="227775231"
Received: from mail-by2nam05lp2053.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.53])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 10:39:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfABKx36UFnKm08niOojD2y4379N/rUqadr4KCok9AcLFZVoHoC3eHdBoBKHasmSPnPQdn7GZhGyuNqLsti1N4UGN4Cs9xm/ICJjKGTE1YO+YIJ1fybj/2S4aeCURGOOF42UW2cLYcdxGFDxhji4HbTjnDcgy2bbyx8I+4XmBOL1WgC7XDBO89q9LorSlCWvMOPz94n0iEQEl3tJ0kY2pQi4Ss+ikmHFm21D4jhdXaNZZ6xphZprXKj3jwJ4hPAgHqkEnwn7vpN4OpIPUF08+BgWnOnzV1s+3vp70RgRA3KoQ5bw2zg/yYTp8veh4u2YkLNVDLg0zgkCHdRsPAdNnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI2pujzCwEt4kR2X7iX0HvHdW+0kGLaSgCmLjXQZaQc=;
 b=a5hpXNtfHZXBl3fbbr3FP8OEf83KJqnmQKLP8CP5PKYoum+zFl/u9EHEya1tBeVV6CP+gF0dcg05V9Ds3YnJnurUvGWk8rHk/Oj0QIoL++pCMr5GR7Ztdgo+bY7WbdfjxqWlq3Cs9pF8CXZIxMC0oGApztDovT+n1yyHm2jjeg3XeAWKTEjpPcyG90zm/+9NHYqJfFduxRn/c6wkAaJrFyKfpg7oAGmSOxJQX3ndM6Ni7cPWHp9dzuG82zePYe6Qk6G++jYD3txWYgBEwJJYsBaoXMDTetz6yAUPTrFMVY22uh7A4gRf/po+MGIsJK0EyncGsGE8JOR45HpSvMyfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI2pujzCwEt4kR2X7iX0HvHdW+0kGLaSgCmLjXQZaQc=;
 b=jCApJUp1FEoNVYWOlgSQePoGk3/iXlVFoGsoARsWOSYbKLoAN8zfdJAKAUn9jm8DO63AI7dWnssnfqbPZonU90tdo7FOWwtSmjcB83n+fmeO3pFoA6pFA2yPnH59ONCWgT3IiYA3D5h9pTLu6n6P07G1GYbtgeWJDTjBd2GkQnk=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5798.namprd04.prod.outlook.com (20.179.58.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 02:39:03 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f07b:aaec:410d:bcf3]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f07b:aaec:410d:bcf3%4]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 02:39:03 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Eric Farman <farman@linux.ibm.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     Ming Lei <ming.lei@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v5 5/7] block: Delay default elevator initialization
Thread-Topic: [PATCH v5 5/7] block: Delay default elevator initialization
Thread-Index: AQHVY8+T2S3IbSTbq0KOEOMIxhuwmg==
Date:   Thu, 17 Oct 2019 02:39:03 +0000
Message-ID: <BYAPR04MB5816A2CFCDA1D7ED10455D93E76D0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
 <20190905095135.26026-6-damien.lemoal@wdc.com>
 <9355c25f-61d7-b290-7d60-552ef4206e8c@linux.ibm.com>
 <f5f3a25b-19f5-bf29-2f38-f40f59860aeb@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe3befb9-e04c-421d-6c65-08d752ab2c88
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BYAPR04MB5798:
x-microsoft-antispam-prvs: <BYAPR04MB5798957020A707B33D41C462E76D0@BYAPR04MB5798.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(189003)(199004)(6436002)(99286004)(25786009)(66066001)(52536014)(66556008)(64756008)(8676002)(81156014)(7696005)(76176011)(33656002)(229853002)(9686003)(66446008)(81166006)(186003)(66476007)(66946007)(102836004)(6246003)(55016002)(26005)(6506007)(53546011)(76116006)(4326008)(446003)(5660300002)(476003)(486006)(8936002)(7736002)(71200400001)(305945005)(74316002)(14454004)(3846002)(71190400001)(478600001)(86362001)(6116002)(91956017)(2501003)(54906003)(2906002)(110136005)(256004)(316002)(5024004)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5798;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mmlBBpGDmy4SjlybHokU4Ar+ghewI/xbTZNCa1M6eEsPwxDqtgdQnV6yXmaF+CR0K+A7xOn/9/P1mPaFiri1zXafrsI41HS34CVYzdsW/09B7T4sgUHrNIKuH2HSfU4cLwIa46sZ+Ily8J2CSlBjXNovkxTwmT9bG1XkCRdJuvJWlFhnWNe0IvPvnz5Pqa/g7Ujx3zXShXPAFFq/uScjHKmAwpuv4t8rM0KqfLTnvRGYOUVuo0Qj0S9uIKJf5JKvmMPhPzIfpBYM38BYvz48GlV7m0l1PJ7z4EpgkwvEvFQRzvldfxG0QiFSS6vN/ORu8fakkPBkcd+kg8uCCTYNcmHz5o2vjjQ6RthGsh0f/rofs9wuHrx1RqC20ISppMTUWUK13NZyC6h448VHf562K7nB3MLMQcf4hFIcTieJTeU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe3befb9-e04c-421d-6c65-08d752ab2c88
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 02:39:03.4568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wrtWdYM9wsmAEI3x2PG/vFsREVzNiSOJu0j3HWsue//PA2tHYI79TPk9poBwyuIUUMuwAxGTVHBj8EuvEx07w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5798
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/10/17 3:51, Eric Farman wrote:=0A=
> =0A=
> =0A=
> On 10/1/19 4:46 PM, Eric Farman wrote:=0A=
>>=0A=
>>=0A=
>> On 9/5/19 5:51 AM, Damien Le Moal wrote:=0A=
>>> When elevator_init_mq() is called from blk_mq_init_allocated_queue(),=
=0A=
>>> the only information known about the device is the number of hardware=
=0A=
>>> queues as the block device scan by the device driver is not completed=
=0A=
>>> yet for most drivers. The device type and elevator required features=0A=
>>> are not set yet, preventing to correctly select the default elevator=0A=
>>> most suitable for the device.=0A=
>>>=0A=
>>> This currently affects all multi-queue zoned block devices which defaul=
t=0A=
>>> to the "none" elevator instead of the required "mq-deadline" elevator.=
=0A=
>>> These drives currently include host-managed SMR disks connected to a=0A=
>>> smartpqi HBA and null_blk block devices with zoned mode enabled.=0A=
>>> Upcoming NVMe Zoned Namespace devices will also be affected.=0A=
>>>=0A=
>>> Fix this by adding the boolean elevator_init argument to=0A=
>>> blk_mq_init_allocated_queue() to control the execution of=0A=
>>> elevator_init_mq(). Two cases exist:=0A=
>>> 1) elevator_init =3D false is used for calls to=0A=
>>>    blk_mq_init_allocated_queue() within blk_mq_init_queue(). In this=0A=
>>>    case, a call to elevator_init_mq() is added to __device_add_disk(),=
=0A=
>>>    resulting in the delayed initialization of the queue elevator=0A=
>>>    after the device driver finished probing the device information. Thi=
s=0A=
>>>    effectively allows elevator_init_mq() access to more information=0A=
>>>    about the device.=0A=
>>> 2) elevator_init =3D true preserves the current behavior of initializin=
g=0A=
>>>    the elevator directly from blk_mq_init_allocated_queue(). This case=
=0A=
>>>    is used for the special request based DM devices where the device=0A=
>>>    gendisk is created before the queue initialization and device=0A=
>>>    information (e.g. queue limits) is already known when the queue=0A=
>>>    initialization is executed.=0A=
>>>=0A=
>>> Additionally, to make sure that the elevator initialization is never=0A=
>>> done while requests are in-flight (there should be none when the device=
=0A=
>>> driver calls device_add_disk()), freeze and quiesce the device request=
=0A=
>>> queue before calling blk_mq_init_sched() in elevator_init_mq().=0A=
>>>=0A=
>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>>=0A=
>> Coincidentally, I had been looking into a problem that is fixed in=0A=
>> 5.4-rc1 by this patch.  Thanks for that!=0A=
>>=0A=
>> The problem was a delay during boot of a KVM guest with virtio-scsi=0A=
>> devices (or hotplug of such a device to a guest) in recent releases,=0A=
>> especially when virtio-scsi is configured as a module.  The symptoms=0A=
>> look like:=0A=
>>=0A=
>> [    0.975315] virtio_blk virtio2: [vda] 1803060 4096-byte logical=0A=
>> blocks (7.39 GB/6.88 GiB)=0A=
>> [    0.977859] scsi host0: Virtio SCSI HBA=0A=
>> [    0.980339] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK=0A=
>> 2.5+ PQ: 0 ANSI: 5=0A=
>> [    0.981685]  vda:VOL1/  0XA906: vda1=0A=
>> [    0.988253] alg: No test for crc32be (crc32be-vx)=0A=
>> ...stall...=0A=
>> [   24.544920] sd 0:0:0:0: Power-on or device reset occurred=0A=
>> [   24.545176] sd 0:0:0:0: Attached scsi generic sg0 type 0=0A=
>> [   24.545292] sd 0:0:0:0: [sda] 385 512-byte logical blocks: (197=0A=
>> kB/193 KiB)=0A=
>> [   24.545368] sd 0:0:0:0: [sda] Write Protect is off=0A=
>> [   24.545416] sd 0:0:0:0: [sda] Mode Sense: 63 00 00 08=0A=
>> [   24.545456] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=0A=
>> enabled, doesn't support DPO or FUA=0A=
>> [   24.547033] sd 0:0:0:0: [sda] Attached SCSI disk=0A=
>>=0A=
>> I debugged this down to the same behavior described/fixed back in 3.18=
=0A=
>> by commit 17497acbdce9 ("blk-mq, percpu_ref: start q->mq_usage_counter=
=0A=
>> in atomic mode"), and for the same reason.  The delay starts occurring=
=0A=
>> as soon as q->q_usage_counter is converted to percpu for the one LUN tha=
=0A=
>> twas found, while scsi_scan_channel() is still working on its loop of=0A=
>> mostly non-existent devices.  Exactly when this problem started=0A=
>> re-occuring is not certain to me, though I did see this problem with 5.2=
=0A=
>> on linux-stable.=0A=
> =0A=
> This problem started occurring reliably with kernel 4.16 because of=0A=
> commit b5b6e8c8d3b4 ("scsi: virtio_scsi: fix IO hang caused by automatic=
=0A=
> irq vector affinity") which forced blk-mq on for virtio-scsi devices.=0A=
> =0A=
> I'm able to reproduce the behavior (fixed by this commit) on 4.15.0, as=
=0A=
> well as 4.14.0 and 4.9.0, if I enable SCSI_MQ_DEFAULT in the kernel=0A=
> config.  I cannot reproduce it with 4.4.0, but didn't chase further to=0A=
> see why that was the case.=0A=
=0A=
This is really strange since in 4.9 there is no elevator initialization bei=
ng=0A=
done for a mq device. So with SCSI_MQ_DEFAULT set, you should end up with n=
o=0A=
elevator for your disk and the presence or not of this patch or variations =
of it=0A=
should not change anything.=0A=
=0A=
This patch may be hiding your problem root cause rather than fixing it...=
=0A=
=0A=
> =0A=
> That force_blk_mq commit went into linux-stable, so SCSI_MQ_DEFAULT need=
=0A=
> not be enabled on 4.14.y or 4.9.y stable branches to see the behavior=0A=
> fixed by this commit.=0A=
> =0A=
>>=0A=
>> When I run with a 5.3 kernel, the problem is easily reproducible.  So I=
=0A=
>> bisected between 5.3 and 5.4-rc1, and got here.  Cherry-picking this=0A=
>> patch on top of 5.3 cleans up the boot/hotplug process and removes any=
=0A=
>> stall.  Any chance this could be cc'd to stable?  =0A=
> =0A=
> Please?  Anything I can do to help with that effort?=0A=
> =0A=
> Thanks,=0A=
> Eric=0A=
> =0A=
>> Any data someone wants=0A=
>> to see behavioral changes?=0A=
>>=0A=
>> Thanks,=0A=
>> Eric=0A=
>>=0A=
>>> ---=0A=
>>>  block/blk-mq.c         | 12 +++++++++---=0A=
>>>  block/elevator.c       |  7 +++++++=0A=
>>>  block/genhd.c          |  9 +++++++++=0A=
>>>  drivers/md/dm-rq.c     |  2 +-=0A=
>>>  include/linux/blk-mq.h |  3 ++-=0A=
>>>  5 files changed, 28 insertions(+), 5 deletions(-)=0A=
>>>=0A=
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c=0A=
>>> index ee4caf0c0807..240416057f28 100644=0A=
>>> --- a/block/blk-mq.c=0A=
>>> +++ b/block/blk-mq.c=0A=
>>> @@ -2689,7 +2689,11 @@ struct request_queue *blk_mq_init_queue(struct b=
lk_mq_tag_set *set)=0A=
>>>  	if (!uninit_q)=0A=
>>>  		return ERR_PTR(-ENOMEM);=0A=
>>>  =0A=
>>> -	q =3D blk_mq_init_allocated_queue(set, uninit_q);=0A=
>>> +	/*=0A=
>>> +	 * Initialize the queue without an elevator. device_add_disk() will d=
o=0A=
>>> +	 * the initialization.=0A=
>>> +	 */=0A=
>>> +	q =3D blk_mq_init_allocated_queue(set, uninit_q, false);=0A=
>>>  	if (IS_ERR(q))=0A=
>>>  		blk_cleanup_queue(uninit_q);=0A=
>>>  =0A=
>>> @@ -2840,7 +2844,8 @@ static unsigned int nr_hw_queues(struct blk_mq_ta=
g_set *set)=0A=
>>>  }=0A=
>>>  =0A=
>>>  struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_se=
t *set,=0A=
>>> -						  struct request_queue *q)=0A=
>>> +						  struct request_queue *q,=0A=
>>> +						  bool elevator_init)=0A=
>>>  {=0A=
>>>  	/* mark the queue as mq asap */=0A=
>>>  	q->mq_ops =3D set->ops;=0A=
>>> @@ -2902,7 +2907,8 @@ struct request_queue *blk_mq_init_allocated_queue=
(struct blk_mq_tag_set *set,=0A=
>>>  	blk_mq_add_queue_tag_set(set, q);=0A=
>>>  	blk_mq_map_swqueue(q);=0A=
>>>  =0A=
>>> -	elevator_init_mq(q);=0A=
>>> +	if (elevator_init)=0A=
>>> +		elevator_init_mq(q);=0A=
>>>  =0A=
>>>  	return q;=0A=
>>>  =0A=
>>> diff --git a/block/elevator.c b/block/elevator.c=0A=
>>> index 520d6b224b74..096a670d22d7 100644=0A=
>>> --- a/block/elevator.c=0A=
>>> +++ b/block/elevator.c=0A=
>>> @@ -712,7 +712,14 @@ void elevator_init_mq(struct request_queue *q)=0A=
>>>  	if (!e)=0A=
>>>  		return;=0A=
>>>  =0A=
>>> +	blk_mq_freeze_queue(q);=0A=
>>> +	blk_mq_quiesce_queue(q);=0A=
>>> +=0A=
>>>  	err =3D blk_mq_init_sched(q, e);=0A=
>>> +=0A=
>>> +	blk_mq_unquiesce_queue(q);=0A=
>>> +	blk_mq_unfreeze_queue(q);=0A=
>>> +=0A=
>>>  	if (err) {=0A=
>>>  		pr_warn("\"%s\" elevator initialization failed, "=0A=
>>>  			"falling back to \"none\"\n", e->elevator_name);=0A=
>>> diff --git a/block/genhd.c b/block/genhd.c=0A=
>>> index 54f1f0d381f4..26b31fcae217 100644=0A=
>>> --- a/block/genhd.c=0A=
>>> +++ b/block/genhd.c=0A=
>>> @@ -695,6 +695,15 @@ static void __device_add_disk(struct device *paren=
t, struct gendisk *disk,=0A=
>>>  	dev_t devt;=0A=
>>>  	int retval;=0A=
>>>  =0A=
>>> +	/*=0A=
>>> +	 * The disk queue should now be all set with enough information about=
=0A=
>>> +	 * the device for the elevator code to pick an adequate default=0A=
>>> +	 * elevator if one is needed, that is, for devices requesting queue=
=0A=
>>> +	 * registration.=0A=
>>> +	 */=0A=
>>> +	if (register_queue)=0A=
>>> +		elevator_init_mq(disk->queue);=0A=
>>> +=0A=
>>>  	/* minors =3D=3D 0 indicates to use ext devt from part0 and should=0A=
>>>  	 * be accompanied with EXT_DEVT flag.  Make sure all=0A=
>>>  	 * parameters make sense.=0A=
>>> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c=0A=
>>> index 21d5c1784d0c..3f8577e2c13b 100644=0A=
>>> --- a/drivers/md/dm-rq.c=0A=
>>> +++ b/drivers/md/dm-rq.c=0A=
>>> @@ -563,7 +563,7 @@ int dm_mq_init_request_queue(struct mapped_device *=
md, struct dm_table *t)=0A=
>>>  	if (err)=0A=
>>>  		goto out_kfree_tag_set;=0A=
>>>  =0A=
>>> -	q =3D blk_mq_init_allocated_queue(md->tag_set, md->queue);=0A=
>>> +	q =3D blk_mq_init_allocated_queue(md->tag_set, md->queue, true);=0A=
>>>  	if (IS_ERR(q)) {=0A=
>>>  		err =3D PTR_ERR(q);=0A=
>>>  		goto out_tag_set;=0A=
>>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h=0A=
>>> index 62a3bb715899..0bf056de5cc3 100644=0A=
>>> --- a/include/linux/blk-mq.h=0A=
>>> +++ b/include/linux/blk-mq.h=0A=
>>> @@ -248,7 +248,8 @@ enum {=0A=
>>>  =0A=
>>>  struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *);=0A=
>>>  struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_se=
t *set,=0A=
>>> -						  struct request_queue *q);=0A=
>>> +						  struct request_queue *q,=0A=
>>> +						  bool elevator_init);=0A=
>>>  struct request_queue *blk_mq_init_sq_queue(struct blk_mq_tag_set *set,=
=0A=
>>>  						const struct blk_mq_ops *ops,=0A=
>>>  						unsigned int queue_depth,=0A=
>>>=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
