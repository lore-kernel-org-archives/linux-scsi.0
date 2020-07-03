Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2869C433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93BBF2084C
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 13:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gi6Tdxql";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bBK3mbty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgGCNlS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:41:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9323 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgGCNlR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 09:41:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593783677; x=1625319677;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=aIUEzT+4BEUQWe/t6TZ7cUr+IAWqd1ZFu06AvzUJ/yM=;
  b=Gi6TdxqlIVmZ/WaOrBd8BZEAcZlCUgE5aZFqXsQKn7bql28odOPYYSVb
   ac8CPCm7zaA6+SIzhzqm1beocOTGdirOfgM8ZEipFfljxeXf7WMc57twi
   UV1AMdsgjTtQSTwYW4JVotEZODE1aSKVKqjawRh/ZPDPRAz8wVKKegkB2
   h9xdtmd5S6HSVgUAb+PGLkeYVVbd5SBHdteYXpxiYlpnlqkvBCF7meN/W
   Vt6Ob2onNNYgmgWIxufJobRODTQO/kYfUdHyoG1F1FEyggBWbAg5Hh2YR
   b21vQY7di+UmXVBqWSpAKIAOV72rp95TrELZGm/DtKna6wB1cTHib7Mwn
   w==;
IronPort-SDR: d6V3jlkX4NKqImZVIfMSeNlT1SrCxnX9JgSytMLjxh+Psbi1zABocr/o6J5Gzb6hmftlFgEzMU
 yjwR6rjuwd/XBoy7EORXVLkiyKEZmeC5TYXSCl9mvJhHYmcpBbzEoVmKZh3rOH4WpALPPA/Jt1
 gaSqP5/wMjGQ87Ds73JxovEX29V8QWF6GObvSsZKV+z9wgpu6GzfN8ndEfs0NhQw8k4v8WG5O3
 gewQ8zCwDbb5rYeMlYgIYk2XU9T3+0L5XpJ5nIocBxIjgLSPsSAEeSrt/EEKaBB+gDfkHh/4x1
 lfs=
X-IronPort-AV: E=Sophos;i="5.75,308,1589212800"; 
   d="scan'208";a="145911029"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 21:41:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DW/epK6xGkv0hVTwMmr5L2MsuOd4b2mwspk3iR6ggO9tnm/LLsSGU8jfLKd1/oZJCYbDcBbH3CmRe1jW3xTgcsT9ctkH/M2AKJTwZA9VNKdoWAJalHTwh8a8lbNraDyHuU3732WDBuAKYgPPNGW53g9j3GLcBCgT/mt6wWEw8yZxSwGtshzDBU0p1ZaG1Y+egVhTaFZTJNQOLXG5EoleLsNzjSOBo01e5C15c2H/WdU1qwvSjSOF097K57WMxJHyZqSL2eZQRo9tHaUtWNjKHUNUjeis3RWDLvR3z1DIWXVHewrGPLfloC6aODv5NvIDwg4o3QkTs5jKmXBCPaf1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIe3d8i/Lj48zTZFVmS96ZJW6z3w9L9Z7WLXZULwSls=;
 b=AFYM/VeKSOkLXfesMtrGvALaOHSk5qJDyOp2EDI5+bQ00PEovKffDjfRio5IVvBnW65rUyqenivSCC5UTnugg3YW/PtcBcIQ/xIyGeoApZ/pYiqXPycK7w5w6MVYawP200svrVuTv4I3uK/MRCj99k5GqAzFYZNFh6/lI5mmGiBZ9cdEZom6Z80g7CDX0ONKuWez1qp7esbgYSTyeJxSddy9X7rQtq5XExJ8n+CsDHQqyh6VvA/4vVTbnFT07EJoHk7Gs2gqOOSgh+DJRhOs3NCCToPVjNokysMR4tnzy1XAs1hkmv7wuHPrEKTuKV8F/ZhLZzMHbHMU+Cuj4gxaOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIe3d8i/Lj48zTZFVmS96ZJW6z3w9L9Z7WLXZULwSls=;
 b=bBK3mbty1FsSYK53UmSwGcqbmqWbNgJUqmYP74v5MxpqpatF9B1j42coMSg2PrKj7rp4RC5CWyYgiyLyeFZm/7gZbtBor4106+H2zVV7nLOjCTIiPTlQTUl/ZosAnmg9iP8nvxnwm7fdkatmV4aGWVUXOl7BmApYBRuCYuonkjE=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3519.namprd04.prod.outlook.com
 (2603:10b6:803:46::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 13:41:13 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.028; Fri, 3 Jul 2020
 13:41:13 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWUJ1laLSAJw11LUObxsrvIlcW1g==
Date:   Fri, 3 Jul 2020 13:41:13 +0000
Message-ID: <SN4PR0401MB35983A6201A6E2AF2611FECD9B6A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
 <20200702181922.24190-2-niklas.cassel@wdc.com>
 <SN4PR0401MB359886C77E3711DAF16D9B9F9B6A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200703092353.GA33841@localhost.localdomain>
 <SN4PR0401MB359801D165A0B9882B43B3719B6A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 528c3708-eb81-49c4-7f47-08d81f56c0c5
x-ms-traffictypediagnostic: SN4PR0401MB3519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB3519CBABBB6FACD27274725A9B6A0@SN4PR0401MB3519.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B8is28mIbLp2LlKFEJthuAFIT/sX3CuK74xVpaqAOlUSBvf3jGx5yQnYR0IOjgYfv0cs9tjxY7fc46n1tfVGZ1G2wADxdEPQvs+Hcx5n9QZpcgVqVz6aEar0ExjVgEqy/+e+wwWWt2YpEBC3xQeNEd6nfV571c4RvhWPlvgdgowjQrDV6zmWs8d9O5kS1XgKhnB8vLnsU4v1s2rmq0zmDEU4u74MsqHi7DMaTbC97mAHPbyAufvbB2obM146KcXsa+G5y2NT9p2xaolxHmGHkGb/4v5b1eyQFOaTl2m9+Ir7aWT2AJ1qrItz8UEQdazN7AgFXhibHxrZhHFBTJ+u5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(71200400001)(2906002)(4326008)(54906003)(316002)(83380400001)(6862004)(33656002)(186003)(7416002)(66446008)(66476007)(52536014)(91956017)(76116006)(86362001)(66946007)(9686003)(53546011)(26005)(6506007)(8936002)(6636002)(7696005)(55016002)(66556008)(64756008)(478600001)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tCMYlUnzuNkSfhBFDmAguheqohMTL78IsVUYk2I6lCt2/wvq9NMhu0bf8lbIsm4fT59zX9mBviZP2TIYAtOAReRtz5MGn7nBKF2h0Nj8++Wm9w811ieFa/CZnt+TbyKxdjC2Le4/EHFMWc06v9bI7JFcnLSrdetbFEnssoYmnFXjOUG2OUYZuwubJsrhrKiLfJyiq+21wCS/ecY/Te8at91nTJ/m2Ssm/36DpqnRjvV59upsrOSaOfWDTE+fOyDnjXhW9/Xx0ekd9k8DVfkVqG5XA1dPojWlq4xA+fXCpH/cl0rAZnrPWlN1lQL1twSozBbUqlAhSTctpJqgj8iJfSGiL08Xt1trti4+p132JMZmcfU2f4ZuRWz0dexm7V48xmugbo3nVGa9L/hivqeERaErwzpX/UwvXz1OQwJA55NLap7X20IyR6SjHQiUK9v4MDzBYfVsJyiB71hBaBx2zElnwpdIy2LaRpt4NSVg7kD50VM0pVKYHWlTZCW+d6Fj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528c3708-eb81-49c4-7f47-08d81f56c0c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 13:41:13.3250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4KUl4QosvNFeXGnoZuJn+nEUKuAs7xzWWfLYXQGelvdX0lJi9UFogxfv5vK0MPAsEhm+BbKPU2PdUSwIAAqfYcS9OW7YGrc7MVfN+NYEdcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3519
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:09, Johannes Thumshirn wrote:=0A=
> On 03/07/2020 11:23, Niklas Cassel wrote:=0A=
>> On Fri, Jul 03, 2020 at 08:22:45AM +0000, Johannes Thumshirn wrote:=0A=
>>> On 02/07/2020 20:20, Niklas Cassel wrote:=0A=
>>>> Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>>>>  block/blk-sysfs.c                   | 15 +++++++++++++++=0A=
>>>>  drivers/nvme/host/zns.c             |  1 +=0A=
>>>>  drivers/scsi/sd_zbc.c               |  4 ++++=0A=
>>>>  include/linux/blkdev.h              | 16 ++++++++++++++++=0A=
>>>>  5 files changed, 43 insertions(+)=0A=
>>>=0A=
>>> Sorry I haven't noticed before, but you forgot null_blk.=0A=
>>=0A=
>> Hello Johannes,=0A=
>>=0A=
>> Actually, I haven't forgotten about null_blk :)=0A=
>>=0A=
>> The problem with null_blk is that, compared to these simple patches that=
=0A=
>> simply exposes the Max Open Zones/Max Active Zones, null_blk additionall=
y=0A=
>> has to keep track of all the zone accounting, and give an error if any=
=0A=
>> of these limits are exceeded.=0A=
>>=0A=
>> null_blk right now follows neither the ZBC nor the ZNS specification=0A=
>> (even though it is almost compliant with ZBC). However, since null_blk=
=0A=
>> is really great to test with, we want it to support Max Active Zones,=0A=
>> even if that concept does not exist in the ZBC standard.=0A=
>>=0A=
>> To add to the problem, open() does not work exactly the same in ZBC and=
=0A=
>> ZNS. In ZBC, the device always tries to close an implicit zone to make=
=0A=
>> room for an explicit zone. In ZNS, a controller that doesn't do this is=
=0A=
>> fully compliant with the spec.=0A=
>>=0A=
>> So now for null_blk, you have things like zones being implicit closed wh=
en=0A=
>> a new zone is opened. And now we will have an additional limit (Max Acti=
ve=0A=
>> Zones), that we need to consider before we can even try to close a zone.=
=0A=
>>=0A=
>>=0A=
>> I've spent a couple of days trying to implement this already, and I thin=
k=0A=
>> that I have a way forward. However, considering that vacations are comin=
g=0A=
>> up, and that I have a bunch of other stuff that I need to do before then=
,=0A=
>> I'm not 100% sure that I will be able to finish it in time for the comin=
g=0A=
>> merge window.=0A=
>>=0A=
>> Therefore, I was hoping that we could merge this series as is, and I wil=
l=0A=
>> send out the null_blk changes when they are ready, which might or might=
=0A=
>> not make it for this merge window.=0A=
> =0A=
> No problem, I'm just working on MOR support for zonefs and though about h=
ow=0A=
> I'm going to test it. This is where I've noticed null_blk doesn't really =
=0A=
> expose a config knob for MOR. I can do some temporary hacks to test my ch=
anges=0A=
> and wait for your's to materialize. =0A=
> =0A=
> =0A=
>> In the meantime, MAR/MOR properties for null_blk will be exposed as 0,=
=0A=
>> which means "no limit". (Which is the case when a zoned block device dri=
ver=0A=
>> doesn't do an explicit call to blk_queue_max_{open,active}_zones()).=0A=
> =0A=
> =0A=
=0A=
Another thing I've noticed, can you please introduce the bdev_max_open_zone=
s() =0A=
and bdev_max_open_reagions() functions as well?=0A=
Like this (untested):=0A=
=0A=
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
index bb9e6eb6a7e6..612f4e36828d 100644=0A=
--- a/include/linux/blkdev.h=0A=
+++ b/include/linux/blkdev.h=0A=
@@ -1522,6 +1522,15 @@ static inline sector_t bdev_zone_sectors(struct bloc=
k_device *bdev)=0A=
        return 0;=0A=
 }=0A=
 =0A=
+static inline unsigned int bdev_max_open_zones(struct block_device *bdev)=
=0A=
+{=0A=
+       struct request_queue *q =3D bdev_get_queue(bdev);=0A=
+=0A=
+       if (q)=0A=
+               return queue_max_open_zones(q);=0A=
+       return 0;=0A=
+}=0A=
+=0A=
 static inline int queue_dma_alignment(const struct request_queue *q)=0A=
 {=0A=
        return q ? q->dma_alignment : 511;=0A=
