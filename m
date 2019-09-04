Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F74C41514
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 02:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A44821897
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 02:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fwAEKRfA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NVRMXHlf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfIDCHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:07:44 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:24038 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfIDCHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 22:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567562863; x=1599098863;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5PvmtoUnz2ikgbcM9fnzoiBJKiru/RboBT0YZfpvTjw=;
  b=fwAEKRfA34yakghwfVw6z2SIV5KybWknZhIiEUC2autlm+GaDV83R8Z2
   YT4nnciQvZOKWZX7bpGnTtJfJzm+9NNH+P7ulCLfvPSRFnWOw3ZfsBeSl
   o1vDGtt50MuWUQGSoTUfwbjBWkXnx1fSP3ZFGOUMPaPGwT8+BMV3FHFGB
   BKPlPpIPFq2sRoNH08KmpdQ9c4+668nm4DCBgMQkr0hYC1jtFs1Dy9YTb
   OzjenkPfteVccAzN3dKG4T/7S6jQ06fuIOH6sR4UJmC+M1Hf7/a2vddrW
   JKc1EBbG6xRkwWMcA+5PAs6PejVB7q7Cr3mplGDiosjNvFHMyYGPRjLje
   g==;
IronPort-SDR: HhPKxIJmUw6kGqUzscmW0C8rGlAOSlOFbBdL6+jWpbvoj/k9KMQyJIPJ75B5Ycyct+jWoVkM3T
 rm+gM/1Rw2kOUbrRBbbiFCTeJQHFmZdobKVFhd5Ny6zkAuOy64T/viigNQp9bnPYLujsLlAEuS
 SfIHx3RGNt+IeaiuvUZAEAmX3GGiz2S8/lZziB/XzEYvOpjlHFNZlQ7q5jur/NDGW43IWXLA+Y
 /qNjGSNBllrbxO5yT32XPK8AS06l7YiSF4m6mmUJ0xI7uUcjwk9Y3C9ADIThYmS/aCRtgXycmz
 0ZQ=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117337646"
Received: from mail-bn3nam04lp2056.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.56])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 10:07:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzHy0vV/Fo2UXVZcBlZe/0xsQp0QA96NFUNHa2AEisds1Fh2UCbD0F3ZznrknFQbSIm1XjHpQaFMGESt8uo/PjMwtX7usuaQ2od1rmfvHB3RzyEgHucLHKoXmhrAv9oBQcuKo8YpFZoPAKY/EkanOzP7kLwNgKC8vfXpPqKdIcV5kHCd/3yhkPSmaqi7ErcbkBstYE/wS29rRZixNCzdeZwrkWbZA3tGLiPcCNh4RzISzEw4v/tHNCoOFnlyNeI97wSwLDXtMkdc0I4RiyyhI9RJMmh0AwkvrkgSIEH9Q1xOQqgU4LfP6a4CECezyoXPfbJcuYYDb9yJ5G0Y5riZSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25C9l2Zkv7Lo0uhbrFoGyDIxuIb4lVxLHh74mq50mYo=;
 b=nrlbmyOOnynVO3oR5Si168pwTROKm7k3xHZb9mH9HABYTCH1QRhymmYC5I0VOhRosELbQfS1o46AsmG8zWH/utJBm+IJegmbXm05UC6JuyjkrvBQa9IhqiYAaSwIEJ+JMwr5ptHAI0XGEjYyrZmpm54KL4BVNp1posK4LSkX+jjZGGc3RoLW2RyA7dM7+LBhLDwCrXP7cYNjWukn7qQxQxqaSGwU2BwidsSQpNTcDg/m43ukvJySh0jKXoyZ40dCZ779aUcjm+6qzxIR7LfrJ028SWW3F7oegCEmd3ryiCTuq9kbDUjkt8mbXXfaSoRaxdu65WlM5ZpxLnptAYnm+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25C9l2Zkv7Lo0uhbrFoGyDIxuIb4lVxLHh74mq50mYo=;
 b=NVRMXHlfuF52tNsgdGrE/w9PukW+Zt7TGfzqcwvzkZxlOGNIvoy2LW+Do0kopty70SEo8KHVYssK7+/23rAUBqSHifLRW7yEO3o/17pWIQuQlR4p0FmTm9WXj7fsfinCm20oruIPUeZCx76FYCPINpFRU2hGREp1nxSvVro5tTA=
Received: from BN8PR04MB5812.namprd04.prod.outlook.com (20.179.75.75) by
 BN8PR04MB5588.namprd04.prod.outlook.com (20.179.72.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 02:07:39 +0000
Received: from BN8PR04MB5812.namprd04.prod.outlook.com
 ([fe80::59e:5431:4290:9bcf]) by BN8PR04MB5812.namprd04.prod.outlook.com
 ([fe80::59e:5431:4290:9bcf%5]) with mapi id 15.20.2220.021; Wed, 4 Sep 2019
 02:07:39 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 5/7] block: Delay default elevator initialization
Thread-Topic: [PATCH v2 5/7] block: Delay default elevator initialization
Thread-Index: AQHVXUh/f+lPYfCZbUSBIxaGfN/7lw==
Date:   Wed, 4 Sep 2019 02:07:39 +0000
Message-ID: <BN8PR04MB581263CA0FBCED3394722EF9E7B80@BN8PR04MB5812.namprd04.prod.outlook.com>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-6-damien.lemoal@wdc.com>
 <20190903090247.GE23783@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86a948ab-855c-47db-449d-08d730dca9fa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BN8PR04MB5588;
x-ms-traffictypediagnostic: BN8PR04MB5588:
x-microsoft-antispam-prvs: <BN8PR04MB558801DC3736110031DD8097E7B80@BN8PR04MB5588.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(6506007)(99286004)(102836004)(6916009)(81156014)(486006)(446003)(26005)(476003)(76176011)(81166006)(2906002)(33656002)(8936002)(316002)(3846002)(8676002)(53546011)(14454004)(6116002)(478600001)(9686003)(53936002)(6436002)(66066001)(55016002)(5660300002)(54906003)(186003)(71190400001)(7696005)(71200400001)(7736002)(25786009)(64756008)(66446008)(74316002)(4326008)(305945005)(76116006)(14444005)(6246003)(91956017)(256004)(229853002)(86362001)(66556008)(66476007)(52536014)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR04MB5588;H:BN8PR04MB5812.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KpaAUInWYb6Xj2T5DM/eeU+efUhwD2nOB1eVG7Muf9pMiIwFT/u16rO4+/qajoV/i3DvT1YM2z6rIzLfalHQVP/QxTtWQXHx+GDhtJJeSWxHl+wlWyCG8cABqtVHYY6yGFTm9zYTUlxFKBoRUIGAvEPsNwjGqgO7CemNsQHph/X1XL6p+RjgWSJND1Cj3iqvyoeJXHkFbioDf4QJnp/v2tLNomm6nwx7WdosuJQRcM7gNOKcBOueLiSf2mNWdbKzzhJY22UQmmt5foBSoM5KsGTW4q0XiUwbxw/hT6sij7nLl29R4XL1hQRkmJCCV37N8Qtlq18siSIlcjpyB+2S5XvSclp8oiI3uFNK2acER2UJ898YFJ77mMChpbwj3Kq2nQqDrhubMAQCtjGC8iOp13cTdIClCsjeyDdcPLcL2vY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a948ab-855c-47db-449d-08d730dca9fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 02:07:39.7264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykPb9JN4m4Em1mn2NR/Pbk8QOYCHI5X9zPrDkaPCD+cdKQV4xjjwwx7AGJChBF1a/jWHYiSm+/M1XwAzr7fMuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5588
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/03 18:02, Christoph Hellwig wrote:=0A=
> On Wed, Aug 28, 2019 at 11:29:45AM +0900, Damien Le Moal wrote:=0A=
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
>> of the device request queue prior to the elevator initialization.=0A=
>>=0A=
>> Also to make sure that the elevator initialization is never done while=
=0A=
>> requests are in-flight (there should be none when the device driver=0A=
>> calls device_add_disk()), freeze and quiesce the device request queue=0A=
>> before executing blk_mq_init_sched().=0A=
> =0A=
> So the disk can be accessed from userspace or partition probing once we=
=0A=
> registered the region.  Based on that I think it would be better if=0A=
> we set the elevator a little earlier before that happens.  With that=0A=
> we shouldn't have to freeze the queue.=0A=
> =0A=
=0A=
OK. I will move the registration earlier in device_add_disk(), before the r=
egion=0A=
registration.=0A=
=0A=
However, I would still like to keep the queue freeze to protect against bug=
gy=0A=
device drivers that call device_add_disk() with internal commands still goi=
ng=0A=
on. I do not think that there are any such driver, but just want to avoid=
=0A=
problems. The queue freeze is also present for any user initiated elevator=
=0A=
change, so in this respect, this is not any different and should not be a b=
ig=0A=
problem. Thoughts ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
