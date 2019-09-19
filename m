Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65DFC4CEC4
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 21:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9873E21920
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 21:11:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gd9fLnon";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lE2bjEfu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733012AbfISVLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:11:43 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25945 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732924AbfISVLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 17:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568927501; x=1600463501;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=W1AcZAx52vEfDw8WGLLP1KHzjOsjeBYyEzUWjN5aiHE=;
  b=gd9fLnonZ+bZoU0O582hN0n9mX8jmOrFBBQwytNnA0WCBLBwjJwZyKTH
   217L1Eyww9sK2v3cSYEOYYTXR1AKmc+bYEqwaPl4iWe5oURAnlxkLEwen
   UBnMk3HGktgznX/qerWgGlfYZ5rw8HSVLiEjV8cHtevyeW4PXVbj1Oem0
   J1CNFrIxyXyPB5QukCf4lx0x2ktXjywmTo+StRg3suIxCNqXBkXt6ilW1
   oMuZ15E8sjO8z8gKSkr06WYwp6U46jy6GqDi5/8OmZ5ej+x2c4rZ1Ijut
   ikDj3ASETuODb+bLo+JdiFXIEwg4kntrukW0gMqmIoRrwDkh1uVB/OEf7
   A==;
IronPort-SDR: 54a2iq2FNE0Mipp3U28MVjiUOfBaKz2smBJA2RMckMqJ0zmdI5eQp4YeAf8PHLu+T0cEWUtit5
 r9J+RVRhHQKa7qwOGd0jiur9a5F72XyuW0EpyNBWtGjLHvIn9ufYHIMvsZFCUTwkbvCFGojy6g
 kt3t2rg+dFP1S3TZNc/y/FMHTGWZ51zwzmzVDF4xFEEzETHnzfxDWPJVgeokgxCXv73NyVBipp
 Mh0yKu5KxB3WOLOOjBNgeEYdASvmKt8pu8q3PRGXAlFeRuAnQ1ExNYPcDL6UKlvEzakgs+WN7X
 B40=
X-IronPort-AV: E=Sophos;i="5.64,526,1559491200"; 
   d="scan'208";a="225495370"
Received: from mail-co1nam05lp2059.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.59])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2019 05:11:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0KWDtNbMHgRj14xKwkj+TfIYK0yL9lZYTayQGlxo6VwCfEmre3JX/rnhggXGSW4okD8NXC0+m3G1wVSH44RCL5MgAAOEF+Jfjh5rlm/mYU01AWF7jj4Z0MS+oDoEp+YpVubEcfsBYh44I+4x2bfdRgaCgDuKGGuh8B+z0D7CXHd+qsny1XpFfp4BMgpgoo4KZFjqvdVe+WmgeNBipz2RGLhla5i3CQKr1qz6vnkIKUIBJoyheXGUK21pefnTAC7VIu5+yusocBA2f1zqjNhc4foA29R2gfVbH2jhhk45eH/UNeQ/bHQSOOJyRsRDfQAja6lg5L+vPGgX7suRy7geg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp2Vk5UyAWnC31AzV7r2yfddNMBBt2vW0DIMQ0d69UA=;
 b=BW2u0LEtWo8iRbzhht9No6n8aFDYTSR5q4yP31IS7zP6Fw3LkPU+WGH/WObKmENhW3yaHGu+WqcOF130Pc/pTWF8hqlXeYouljZZH7ZEwj8AYn5llWMXi/FzAzEz/5jvfRGRSfocMG1azGVvDdqJ0Vx+vhkk2IGTFdMq5Ts95FIdkZwJC4eXqwLXDTnyUtkfOUvtn+hZyJPEP9LXiZd2j79GC95xyMJRk7RcF3PM+2j0w+Bjxb56GInXx9UkZ4wzmGL+TH/MsHr0WVSV5LijPNEUCDpBEvMyQO5TMA6kAgiGt+75btor9GH4GXY8p/ZpBlNMAk5h8WwO7yMKHiEq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp2Vk5UyAWnC31AzV7r2yfddNMBBt2vW0DIMQ0d69UA=;
 b=lE2bjEfuJ5FR57dWjlfqzwH/KTehVmgspQI+QKiqVqSq/l8H5T9O29rFfweYOGDuT69B6y3bFtAG/a5YYx4e/JrJvMqbS5q1k7QZSt3OaL9+7wFDiF5tLds0013dPfiNoRg+YomA0vxzIPr9TWlh21H//i60NtTszBXInX20jwY=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB4455.namprd04.prod.outlook.com (52.135.238.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.19; Thu, 19 Sep 2019 21:11:39 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 21:11:39 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Topic: [RFC PATCH 0/2] blk-mq I/O scheduling fixes
Thread-Index: AQHVbxKAhx4vysnHSkm7uztjC//ffQ==
Date:   Thu, 19 Sep 2019 21:11:38 +0000
Message-ID: <BYAPR04MB5816D32ED736029EC31B9DFAE7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190919094547.67194-1-hare@suse.de>
 <1bde2781-9958-9bf1-2d89-8c4f9f0d8cba@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 496b1721-ddb0-4933-48fc-08d73d45f66b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4455;
x-ms-traffictypediagnostic: BYAPR04MB4455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4455CCC3402E0E778BE92D24E7890@BYAPR04MB4455.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(54164003)(199004)(189003)(53754006)(76116006)(9686003)(64756008)(102836004)(66556008)(66446008)(14444005)(71200400001)(486006)(476003)(74316002)(71190400001)(91956017)(305945005)(52536014)(55016002)(256004)(229853002)(6246003)(446003)(4326008)(66946007)(66476007)(7736002)(5660300002)(8936002)(99286004)(86362001)(7696005)(14454004)(76176011)(3846002)(26005)(66066001)(25786009)(81156014)(6506007)(6436002)(81166006)(8676002)(186003)(6116002)(33656002)(478600001)(2906002)(54906003)(110136005)(53546011)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4455;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VyV/0Z9x/qYwERonTNZ6XBidk1eFzgoYkv19gWfuyqrOJURs6FHlPGx/ssWsryTwk1U2EntK9iXOw6ReVIx3n3RNZ17umc1dghZzV9TNbGxBsVAXeDZ0rUSwrZvIgr29ZctCG2lhjNuMjbO4LEbbFUmjzsnYvS+uW6SNFJV33jS8Y2yA4gEhI3Z5/QsvFVULy4vI6eSygUuyGJ/NbF+4DT43FMEAr08zqeA1i1yjuuSZ/ew+gf18Qp0sjnKProYQPft3TvxClDJ5g4kVhY58qZPZalyrjwYec2ws4/fBRU7ztXvCJCJZgZeElnnT6g5kPTHRor2ksx0bBYxEuy6Wb6bLihiuElI0AAsZoKj5/l7KD6NGNKDv2XLkCjuWXY0SWphmUBIt7zb2ptM27eGLcZxcX45QAPLTUod/asOebWE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496b1721-ddb0-4933-48fc-08d73d45f66b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 21:11:38.9939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: El3QgJ07uCItkcSFSvmBFljXfsNqkoZEdmp76ycQlSRRh8qoNMHpTSzDwDtMOjYEQJBbN5RAyhtkmzFfoo4Jhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4455
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/19 19:48, Jens Axboe wrote:=0A=
> On 9/19/19 3:45 AM, Hannes Reinecke wrote:=0A=
>> Hi all,=0A=
>>=0A=
>> Damien pointed out that there are some areas in the blk-mq I/O=0A=
>> scheduling algorithm which have a distinct legacy feel to it,=0A=
>> and prohibit multiqueue I/O schedulers from working properly.=0A=
>> These two patches should clear up this situation, but as it's=0A=
>> not quite clear what the original intention of the code was=0A=
>> I'll be posting them as an RFC.=0A=
>>=0A=
>> So as usual, comments and reviews are welcome.=0A=
>>=0A=
>> Hannes Reinecke (2):=0A=
>>    blk-mq: fixup request re-insert in blk_mq_try_issue_list_directly()=
=0A=
>>    blk-mq: always call into the scheduler in blk_mq_make_request()=0A=
>>=0A=
>>   block/blk-mq.c | 9 ++-------=0A=
>>   1 file changed, 2 insertions(+), 7 deletions(-)=0A=
> =0A=
> Not quite sure what to do with this... Did you test them at all?=0A=
=0A=
Yes, Hans tested but on one device type only and the bug in patch 1 went=0A=
undetected with the test case. Patch 2 does solve our specific problem whic=
h is=0A=
that sync write were bypassing the elevator (mq-deadline), causing unaligne=
d=0A=
write errors with a multi-queue zoned device.=0A=
=0A=
> One is obviously broken and would crash the kernel, the other=0A=
> is/was a performance optimization done not that long ago.=0A=
> =0A=
> Just going to ignore this series for now.=0A=
=0A=
Yes, please do. This was hacked quickly with Hannes yesterday and Hannes se=
nt=0A=
this as an RFC. We now got plenty of comments (thanks to all who provided=
=0A=
feedback !) and will work on a proper patch series backed by more testing.=
=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
