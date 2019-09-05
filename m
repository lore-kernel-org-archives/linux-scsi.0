Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BAEC3A5AB
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 07:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE462184B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 07:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D7nioPJS";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WXpMJk9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731901AbfIEH6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 03:58:33 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39525 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfIEH6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 03:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567670312; x=1599206312;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Q0AiLP0bQ9HsDTlkg7Yjt+JiQRG1e0oEy4oWXDVLFHI=;
  b=D7nioPJStnp7l3w08RC1Q7gp49idrkyLoizWxXfXv3djgDoL4DhSIID2
   etSklaTK+LvLhlrkJm7Bz1WBlZH8V2xBp+EpdGDfMs1wMSFiY2dqg8hfo
   NV5Dwt8HmpaVkX+uMh7fBGNWYkTVMeSdnWDPxbFSiMe1xaEEblfbuyfNu
   AhG16Dcm2DfIqGE9yRf1MybgfI1Mj4z3Z/d6jNBcEBIfrTsxqEcv7Cb+L
   5li/jwrsPwx5491InIzsD4pfGU/wy/LBx44gDkabzFHhRTGzL5qlFXobH
   409BHKHIENJRo4+iBktHzz9BAHlHOPuyPKT0rVDGnL9n5TRRY61ajsMLM
   A==;
IronPort-SDR: ElboP8c5JSw0arzwF6WYEbH7gA386A6+ddEIiNPiGXmUMyOy5bqOHuRfM8kG+/RfplVOzUmVSd
 CYGs/T3H3ANv0jcjQ9i9vstaGlAaqHat0U6TmP7lVq0nTzCAj6NVO3OOq3oWpbZ3oHOGhfpZTJ
 xAXprkwF89AJ1wLraKPE7Ww02zKC2+hH2lQmV6+Q2zCY3xnoPDNWquFshNafDQl1PWxiyoA3Lq
 veCSPt2bNoqrCThWXvQOIyQd2Rocug09dLfNY1M4IGM2hQ1/XZy5qB6XBw7wV6K5nb9zFi+7v8
 WE4=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224257056"
Received: from mail-co1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.57])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 15:58:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqBGxJhRfsi29ltt78kxqoEoMsDfdtc8zmJKLrUAw6FVyE0ICMZib0pIv+ercVuOSzfuf8HtSADI/fmeCx7ggUkx7YbQOa466H3ryIlHm9LS+XN3+Mq9XSMkRyoaamtxAgBsprWndlT2mLAclgdn8eVN07YHJFtvLSSiY2GMidw09ImIqNRaexesLXhHFbQ79oxPf+POR+KR1CCN1RMZbEBeoXp/DvJvhsLBRuB1A6XDI5cYJnog5bT3WrExSWQ0dglvFaBEYSYN2LDNmC7id5XiwB4Ux3MpeXxPCaIEwELK9BlhnAQnxr/lu/y+Wm8lm29U8qFKeJRsoY3SDB0xvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9Gmtws++kMbOxYJYvsDfieC05c/FQdHWjJwkTd41Dk=;
 b=jNgIF29VBYs9j57MFyVUv4F56kpYm/f1We/qiRXVlSzCS9Yp7xB6Q8lo0UK69p8wYkYxas8BZMykSGs5DVzJIP0IDrHuLvBBtPRYFuvCVNxWtTWCXPzNhlby/LvC9AHyfYvcILyvph2NWLxbXxg/NjhEh3b1GtOn7324OipP3atxxQbYwAYo/JLvuXQklaT/6UseaCemgufLDATJauuT8hj1pCyUNC02+/BUnqMQr3923fGFBnv2oEdiTu9PdY9cc/QsmFICW56TZuMLa1GH35/KngqRnSuLM8UFW6z/rvEsBdKVeMo60A3XzfWE+wLMMcdxOKruF3EXyBwSxRLcig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9Gmtws++kMbOxYJYvsDfieC05c/FQdHWjJwkTd41Dk=;
 b=WXpMJk9wIDeYA8v0qxY59qK0PMCULOBiyv80Xr/juUD72qmOTID36Ix3povSNC7g1IwLTWJ96BmEPaAETIVkhNKW8+zcsI2+kyNxCijxpn+psipjSeCdp+P3Bkh4KpMsLMF3d+LhG3aRfGKjqd6Hs3rLVyMkVuhkucsDBrs5W1M=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5336.namprd04.prod.outlook.com (20.178.50.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Thu, 5 Sep 2019 07:58:30 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::50cc:80d2:5c1b:3a10%5]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 07:58:30 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 5/7] block: Delay default elevator initialization
Thread-Topic: [PATCH v4 5/7] block: Delay default elevator initialization
Thread-Index: AQHVY6J5Jdv2Ped9mkuVchC9QRiFdg==
Date:   Thu, 5 Sep 2019 07:58:30 +0000
Message-ID: <BYAPR04MB581640203E7CCD2F8F34D0D3E7BB0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
 <20190905042901.5830-6-damien.lemoal@wdc.com>
 <20190905071923.GA8898@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2810797-efa3-4c77-1974-08d731d6d7be
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5336;
x-ms-traffictypediagnostic: BYAPR04MB5336:
x-microsoft-antispam-prvs: <BYAPR04MB533618C6D38A0F0A35EA8B79E7BB0@BYAPR04MB5336.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(199004)(189003)(2501003)(6506007)(446003)(14444005)(53546011)(256004)(102836004)(486006)(33656002)(476003)(2906002)(5660300002)(53936002)(25786009)(6436002)(55016002)(76176011)(4326008)(6246003)(99286004)(9686003)(54906003)(71200400001)(7736002)(478600001)(74316002)(7696005)(86362001)(81156014)(8676002)(81166006)(8936002)(66066001)(14454004)(71190400001)(110136005)(305945005)(52536014)(76116006)(186003)(66556008)(66476007)(66946007)(229853002)(64756008)(66446008)(6116002)(3846002)(26005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5336;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yMKSyFu8w4Hz2M+xDxmq59joP6XikU547k064xircwcsgKidss2bYQcQBxtyRMmk8H0tI1JgmEuyynhcPepZ4sNJMp2JOIG2Oy4mRf4SoD+LRfxLgfDekuXKe3Hqq/HhgdNcknfg/Oy3xmnagxLkNRx8P9JkVvb0caYdMNHyHB9TLGoVgCZb1lQ2UWDXolf5aWeHOumvGEAGn7SDNteI4FiK8+EHz373tQD/K02C1fHTrxXMCtbdc4L9euTZzGy90l9l96Y/Ngulq1WRp/ng+00JbhGQzmLHIuJrDJk0LcyV5GrBOuEewWWjE93bqAGuGrAVaAlknr7cyuMP7RsXSztfs3RXWpfSg2Mhwp/62ZRRCH/xc1AQh/lYaVJe2d2WGJS/ezsimkgmV9qaI5vLaMnigFtck2eafiqcxqNRQDM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2810797-efa3-4c77-1974-08d731d6d7be
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 07:58:30.6537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpyiknNZsN/K28fPkxP1KEF9MnAVehVMIISQmYQ4W6vvmlsDGbXEYFwIQYmFFenDVHLMvsygZ7AYPHZDApQi+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5336
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/05 16:19, Ming Lei wrote:=0A=
> On Thu, Sep 05, 2019 at 01:28:59PM +0900, Damien Le Moal wrote:=0A=
>> When elevator_init_mq() is called from blk_mq_init_allocated_queue(),=0A=
>> the only information known about the device is the number of hardware=0A=
>> queues as the block device scan by the device driver is not completed=0A=
>> yet. The device type and the device required features are not set yet,=
=0A=
>> preventing to correctly choose the default elevator most suitable for=0A=
>> the device.=0A=
>>=0A=
>> This currently affects all multi-queue zoned block devices which default=
=0A=
>> to the "none" elevator instead of the required "mq-deadline" elevator.=
=0A=
>> These drives currently include host-managed SMR disks connected to a=0A=
>> smartpqi HBA and null_blk block devices with zoned mode enabled.=0A=
>> Upcoming NVMe Zoned Namespace devices will also be affected.=0A=
>>=0A=
>> Fix this by moving the execution of elevator_init_mq() from=0A=
>> blk_mq_init_allocated_queue() into __device_add_disk() to allow for the=
=0A=
>> device driver to probe the device characteristics and set attributes=0A=
>> of the device request queue prior to the elevator initialization. This=
=0A=
>> initialization is skipped for DM devices using=0A=
>> device_add_disk_no_queue_reg() as this also skips the queue=0A=
>> registration.=0A=
>>=0A=
>> Additionally, to make sure that the elevator initialization is never=0A=
>> done while requests are in-flight (there should be none when the device=
=0A=
>> driver calls device_add_disk()), freeze and quiesce the device request=
=0A=
>> queue before calling blk_mq_init_sched() in elevator_init_mq().=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  block/blk-mq.c   | 2 --=0A=
>>  block/elevator.c | 7 +++++++=0A=
>>  block/genhd.c    | 9 +++++++++=0A=
>>  3 files changed, 16 insertions(+), 2 deletions(-)=0A=
>>=0A=
>> diff --git a/block/blk-mq.c b/block/blk-mq.c=0A=
>> index ee4caf0c0807..a37503984206 100644=0A=
>> --- a/block/blk-mq.c=0A=
>> +++ b/block/blk-mq.c=0A=
>> @@ -2902,8 +2902,6 @@ struct request_queue *blk_mq_init_allocated_queue(=
struct blk_mq_tag_set *set,=0A=
>>  	blk_mq_add_queue_tag_set(set, q);=0A=
>>  	blk_mq_map_swqueue(q);=0A=
>>  =0A=
>> -	elevator_init_mq(q);=0A=
>> -=0A=
>>  	return q;=0A=
>>  =0A=
>>  err_hctxs:=0A=
>> diff --git a/block/elevator.c b/block/elevator.c=0A=
>> index 520d6b224b74..096a670d22d7 100644=0A=
>> --- a/block/elevator.c=0A=
>> +++ b/block/elevator.c=0A=
>> @@ -712,7 +712,14 @@ void elevator_init_mq(struct request_queue *q)=0A=
>>  	if (!e)=0A=
>>  		return;=0A=
>>  =0A=
>> +	blk_mq_freeze_queue(q);=0A=
>> +	blk_mq_quiesce_queue(q);=0A=
>> +=0A=
>>  	err =3D blk_mq_init_sched(q, e);=0A=
>> +=0A=
>> +	blk_mq_unquiesce_queue(q);=0A=
>> +	blk_mq_unfreeze_queue(q);=0A=
>> +=0A=
>>  	if (err) {=0A=
>>  		pr_warn("\"%s\" elevator initialization failed, "=0A=
>>  			"falling back to \"none\"\n", e->elevator_name);=0A=
>> diff --git a/block/genhd.c b/block/genhd.c=0A=
>> index 54f1f0d381f4..26b31fcae217 100644=0A=
>> --- a/block/genhd.c=0A=
>> +++ b/block/genhd.c=0A=
>> @@ -695,6 +695,15 @@ static void __device_add_disk(struct device *parent=
, struct gendisk *disk,=0A=
>>  	dev_t devt;=0A=
>>  	int retval;=0A=
>>  =0A=
>> +	/*=0A=
>> +	 * The disk queue should now be all set with enough information about=
=0A=
>> +	 * the device for the elevator code to pick an adequate default=0A=
>> +	 * elevator if one is needed, that is, for devices requesting queue=0A=
>> +	 * registration.=0A=
>> +	 */=0A=
>> +	if (register_queue)=0A=
>> +		elevator_init_mq(disk->queue);=0A=
>> +=0A=
> =0A=
> This way is better, but still changes the default elevator to 'none'=0A=
> for dm-rq always.=0A=
=0A=
Got it ! I was looking only at mapped_device() in dm.c. But for request bas=
ed=0A=
DMs, the queue is prepared differently in dm_mq_init_request_queue(), using=
=0A=
blk_mq_init_allocated_queue() and blk_register_queue() afterward in=0A=
dm_setup_md_queue().=0A=
=0A=
Sending a V5 to fix that.=0A=
=0A=
Thanks.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
