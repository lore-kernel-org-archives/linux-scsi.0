Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398ACC10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1216B22464
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KEtAsBsR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="e7S5aD9F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgCKGkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:40:46 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27019 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKGkq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 02:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583908846; x=1615444846;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ulKrvKoa3fJif9y6cYn+AUnYQe19AQvlm8UGzCcXTko=;
  b=KEtAsBsR1I6lNthe8/DZW+L3GPwsJtKO7N5drolT6TzeP+Ljp9U3xfQ3
   adK+oSC/1xAafbeHOF27NYZVpm5ixOxAPQLTzgwVSCNhWFhFtmWOqNtlF
   DBeeX/Arx7B7lqQxp5giofDUZwbKey0lwP20r4DjBKjghsbg4O89p2KS4
   WTlaKBcxEKMmWeoKtSYyhXE52jlRWMzQu1Fxd9vvPDF5Go0HT/Kl5U8ay
   dcfksyfqSzVH6dIvAQemP7at+Ef7e8c5tDCaUN9/fTBSy53vk6hcEooAa
   pRP7yXRfIlzAzISgMEZXjq2XnvixQETSNcdO8R7gmgI+d7at/fCoht9IO
   A==;
IronPort-SDR: eGkTnhiVzaw/SLABo6PIzDhDoMfTV9KJRpWtmWWnDiRhYjjE/CPnWxTLhMJZrBNiQOvn/D2GzD
 hu2JjPbxGSv10+AczP9S0U38YPblXsmNmIB5+1zhjFEjeHzw4cg1NVkRzueHwIXyfhzwhjFtLz
 Rs2mn8aJLq343Rmcs4Ld9PbdBJwKmQY6PaDfS6h6LkdbX5LzBX/hwagPswOE4TR/SLvqYsWCLm
 L7WYzSKQzLiaOqgRYP7DJ8FEWeXJ4QbQPHJo7o7nC60/ll2QXpgz/nR414pG4LRSFu2+GcHwah
 xOw=
X-IronPort-AV: E=Sophos;i="5.70,539,1574092800"; 
   d="scan'208";a="132593071"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2020 14:40:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpG7Mlwij40eNvtGvyMp3ZvRWql3S3aB+oUMG+uCiolcLguFboa8Ws4/bEik1W3n5Cgtz+fxqU7w1p2QelLTiZ/ef4KnkzXLAxQmQl/e7XFFySjKjOGIpeWg9qkenT4j9mrEvFQtrfiovioAwb4ojB3Inc5hWpbldYDg/2sQRxg+eAYH7gDAZ77U63lmT0rV6P/H3mLZVK89Ry/uvJ3olWiuOo5QHR17aFJpCrelY86kO94a80tUih+y7bg7j8NC/0ASi5tGkrvPAwmHLNZPrrk5chQdU542aWMizVINv01XdoG6zb2Dg8ZNhzAWF7juFsZpibUYy2W9rQOlgjmEaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulKrvKoa3fJif9y6cYn+AUnYQe19AQvlm8UGzCcXTko=;
 b=UCgHgWEcAZdkQaDQRKWmico2Lkwni0oEStM0uLwhYwLLAJ/KJac2eiPDOWXLfCvyoW8tVviYQbnJIz/4SYw4V+ANhEzaTDxfJmJvAZqdLPKLfN4gHdsqvBpN0VgKqR9bqEcT0+kYuhqvypzkhjdfOPqcUwcFNodmjZJ231JD0xDQ3o/evcR2dExOubT96qakleaKtRxuXt5Dcis7JijG0B5RpqnDwUUErmqTkOGiE4bkZ0VuiZz5ewl/6G6QA0aMY7kYUn+YObUhySb5A8AVCqIRHheebwIfnr3MxYCRxYzaY2awlo4r2HfRAi7ZJektYnAVehd8gMkOUpBWK2X4rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulKrvKoa3fJif9y6cYn+AUnYQe19AQvlm8UGzCcXTko=;
 b=e7S5aD9FcwJY+dJ+kzH1F4qKHoCwW7BDFNYLjfoEJwSYSEFi91gFaSatgob7S2YbUe5pBy12P8IuyPUFnNeZQlvqRSz/yrC/mPKRP+rgadBcQx51PbSjnsa80kcKNeo/LkKU4fOk3osCEDjyE+A41YtbzAPNLUY+mBKJdWpXo68=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (2603:10b6:a03:10e::16)
 by BYAPR04MB5477.namprd04.prod.outlook.com (2603:10b6:a03:e1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 11 Mar
 2020 06:40:43 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 06:40:43 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/11] block: Introduce zone write pointer offset caching
Thread-Topic: [PATCH 09/11] block: Introduce zone write pointer offset caching
Thread-Index: AQHV9sDra0scjax4s0mPI2b35IGa0A==
Date:   Wed, 11 Mar 2020 06:40:43 +0000
Message-ID: <BYAPR04MB5816FBEF00A0B434BAA6C5BDE7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-10-johannes.thumshirn@wdc.com>
 <20200310164615.GG15878@infradead.org>
 <BYAPR04MB5816F62B4BB0482359F85AD8E7FC0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200311062406.GA5729@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 393d152b-676f-40da-0da2-08d7c5871f86
x-ms-traffictypediagnostic: BYAPR04MB5477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5477229993FC10C8E570E8BBE7FC0@BYAPR04MB5477.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(316002)(8936002)(54906003)(5660300002)(66556008)(64756008)(66476007)(66446008)(53546011)(76116006)(66946007)(9686003)(55016002)(6506007)(33656002)(91956017)(71200400001)(7696005)(478600001)(52536014)(8676002)(86362001)(26005)(186003)(6916009)(81166006)(81156014)(2906002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5477;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d4NHzGMOReY275v+qOfSeNcwocSwOxJxcmSQQUkdMyCYE9p/83Ti/uTh29wxzGHOtgf64+sTxSrHUSb5IbbAmts09UZcb889ZPfuleRH/OUbjAjJ75Hlx1uMoDC5AaOpAxJxMbVa1q2bK/8pKmjWYHcQsd16PgwlqqeDtSGb0tlhSpzXYuBBX44RlcwEqDdlGmGkn8nnpwKVsOHXLBmxDoPEMTa7Mo67Vb4xvj2RhAnl30Js2teO+4+iTBXR1YBoZu3UJ2BBjULCyBJv70IhrXkCBfCJtce1BLrxbfvcy2MKoiLxVuTyl8PA4Q4nXKBWzJI9Z8C450P/5/iRFhV+lgYeKNv8GyJCWcGIH0AVi2Xxjz2+sWg8p+rodVyWm46BTdtv+slkSoqzp2iRDE4tywO7wBpXyRsO+Y/PT+T4DnPXBFyrlDPhDokF/fR/TVHB
x-ms-exchange-antispam-messagedata: OjLKLMt5X6nF5JX4i3EAnkJDx4WzlZHLDO5yCPt5oeNqDUCI2oXvTXorcwsVphO5kwjqVjf1V9gWPz5e3+kDoVvkKtj3mHjnp3Am773pDoooalQTFvWE2KiLw63d9Q8Tmc42kfUXKdX4FBQ4ZUpVHQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393d152b-676f-40da-0da2-08d7c5871f86
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 06:40:43.4631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q/1xIvUw8GAKwEkoP/jn4g28+v4AYtlDjxVOJz/WjPIPUfFKYomXXLhyJpbXjr5YmEJYBrhjCfhP0PnEvIGSJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5477
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/11 15:24, Christoph Hellwig wrote:=0A=
> On Wed, Mar 11, 2020 at 12:34:33AM +0000, Damien Le Moal wrote:=0A=
>> Yes, I agree with you here. That would be nicer, but early attempt to do=
 so=0A=
>> failed as we always ended up with potential races on number of zones/wp =
array=0A=
>> size in the case of a device change/revalidation. Moving the wp array al=
location=0A=
>> and initialization to blk_revalidate_disk_zones() greatly simplifies the=
 code=0A=
>> and removes the races as all updates to zone bitmaps, wp array and nr zo=
nes are=0A=
>> done under a queue freeze all together. Moving the wp array only to sd_z=
bc, even=0A=
>> using a queue freeze, leads to potential out-of-bounds accesses for the =
wp array.=0A=
>>=0A=
>> Another undesirable side effect of moving the wp array initialization to=
 sd_zbc=0A=
>> is that we would need another full drive zone report after=0A=
>> blk_revalidate_disk_zones() own full report. That is costly. On 20TB SMR=
 disks=0A=
>> with more than 75000 zones, the added delay is significant. Doing all=0A=
>> initialization within blk_revalidate_disk_zones() full zone report loop =
avoids=0A=
>> that added overhead.=0A=
> =0A=
> That explanation needs to got into the commit log.=0A=
> =0A=
=0A=
OK. Will do.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
