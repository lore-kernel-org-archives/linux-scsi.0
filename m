Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7E9C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 23:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8051230FA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 23:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbhAEXfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 18:35:10 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:63001 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbhAEXfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 18:35:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609890479; x=1641426479;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=psEs2d+0zgxdFClIxSEI5heJG/J2EwVtf1QxqeLv+Q0=;
  b=UF0tuMQwVh+AvybXdSjeBiLJDraZFia4eh8gCSdyK5DUsGZrnTM4A3eb
   EhlzQ8/uKlR3oEfuItN3yJoMeQUYU6O8VRT50z7GIs8VGLJjH6epi//jj
   xSB5Ygbuutp+5m/rkb+LrD+OdHh+uGfyQDxZGAekChlhwvFucHgoH7WKZ
   89REmpdTqL9aRjGZFk6ZZogPSCRltHW3K9I5BfSFxrDYEPTiflrvKNXEC
   kWpsJacxpSRKnqFvXGMS2mYG8VMo9KmFlNKd5vxT1vJTamr/onvDha2OE
   nSl918nB7lZjOxKXL77mXBSiqfzv4tN8Zg23/Rxw3dSjUHPGuuAzH1jfT
   w==;
IronPort-SDR: BLEkSgpdCav+lIQvaPAEpTjy6dcracGRcdKg/1XeWgCuwi/I/qmWl03RwW3t2k1/r8HE4O7ZgF
 U0LZnCH8U1U/LFiFi1IFLK5nbv/VCb55G3ka2zVJbuwyTSA/uo8lKiztBet2Wo0MU/vG0HD6FB
 fTKNeBzRPIZxdIQz5KVb+wFqibDeMM/W39Rgznkxioj9NWOLTf/Yw3pZPRr9nq6gCaVoTBk6ny
 HLMnRh2DSCmdjXf3UrRrzgngL7hO491sKjuKiSDaN12cgZ8DrGllhP9Zv+BptVEMhWN37cTOnv
 8uY=
X-IronPort-AV: E=Sophos;i="5.78,478,1599494400"; 
   d="scan'208";a="260468325"
Received: from mail-sn1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.55])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2021 07:46:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mskciRyczE/29jrcrHPwVl9g9/7w2bre+u11KOa2jd6LY0MQtdj2oIuRIakBR1cDGrZAdhQcOpU3XXQHqlMVVfvKg/JjWxTbJy3dl64db8QaF5nYMRVWyO65daCg7NFF+NSwKc1I/goNJeQKUiRhwsS/nP1T2/VPsczuU/5zlb6WNjAcImvVmOlpWt3W/hWG2GSkC73rUw7fvcUo0lAHe4/XPx/n5Mkj8oZKMDeqQ19xRUF/qpTeQk6N9c9Z5knQt1Qgzto/CrK/krgbRTPW2qFSIwo6E1rFz1IfGGFDRETsAQ7o/HjLxf8BMIotCkniJz7lujG2SxF5yymPd1QBeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3qYlFH0F0lQJwMt0hLXmPYM5Wx3L4BIKxlLZNGD4mM=;
 b=P3LinirVVwRXluwN3ZnAiIaPYl9dxtdEW6v45g+maj12RDdw7ZMFXCH0suy3Zt/GDce7MjAx3P4b2a/opsIA5F0BE+8gulhal6Rh+ycRpiBBO3uqUWuI8lK9hanuq2gHLvugkuaKHdmb26poi7s7Vvn8yPrzNLj+qeQmJSFW+33k8gr7NcoVs7AZuTYslzxId/7F+TkywPAcDS+EJzPMeRSU/Rg702DS/xxSbKN0XuQKtyo7LcmADiBO9ms+5qg9aSYBpOs1nSq7UIGrL1u4kEiFslNuV6EMplnWJA+TmAFC3w1C8Qh0749oHTGnfIBD1x/HKJugVmgz+X2jBq+WLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3qYlFH0F0lQJwMt0hLXmPYM5Wx3L4BIKxlLZNGD4mM=;
 b=j3agv33T+EmvO+vRNR9LOCbbG5W93JIoXdq0gSDkbKJaOOHEdNIyGJmHWzaAC9zAPZfVc+pZu9paUSEDRz9tCnEd4IhA/96BLc6tGwdRro9Y6jtV7cKfSTfBP8sS9Pa+lChUNVzewiiFn58H/tutpG8aDo7LGfcmC/k8IKEZFR0=
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
 by MN2PR04MB6415.namprd04.prod.outlook.com (2603:10b6:208:1a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 23:33:57 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0]) by BL0PR04MB6514.namprd04.prod.outlook.com
 ([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 23:33:57 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Selva Jove <selvajove@gmail.com>
CC:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC PATCH v4 2/3] block: add simple copy support
Thread-Topic: [RFC PATCH v4 2/3] block: add simple copy support
Thread-Index: AQHW4ocZGQHbBBU/JES2xoCYHwM80A==
Date:   Tue, 5 Jan 2021 23:33:57 +0000
Message-ID: <BL0PR04MB6514233D8AE368455EF35AB6E7D10@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
 <CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
 <20210104104159.74236-3-selvakuma.s1@samsung.com>
 <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
 <CAHqX9vafJ9JwkT-oDJRfbLV0WKym-6FiTQqngcP1pk8J+zgbxQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:78c3:a7df:f52d:1169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51f69e64-7d67-431f-86b8-08d8b1d25f93
x-ms-traffictypediagnostic: MN2PR04MB6415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB641567A8D9845D79B33FEB52E7D10@MN2PR04MB6415.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RSQVOL/XD7BHC327oOnUutZyoMh1w6qi68EJEPLgtoggC9fxTFTxFlqWO7TgOUcC1FtYl6zlIumWK0DUf6pLBuJFtxhTgwpPZfkY8FoTMGygUVFNhuX60r+FHP2IndQKlg2ySz3rXejHmhwsprcoPV8wMPREozMZntbxtJYf/JNZ+SxG+XkWnXTD6piiyfj39opk2a6W2ylIRkby/jLk4FlAG3rn5nWDx3AM+MtBPMBpTGQPw16PqhVs5t+dWsDpSBSjerVE+knmqm0HrUefOjLoavFFDAs2lNt6xjJJuYLatOKb+PfqncHswzhaIc+6+6/RidzvueZ1c+RdfVgSqkQjtc+f9Kv+LcFv3xlJtJvTlqqQS1OgoUVf+4nt9fEdPtS9MCgoqLzv0CObyxSKIqM+wFBQsdbh3nd7++1I8NUGNuCcOcy/CLF0pVr67+wY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6514.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(53546011)(6506007)(66574015)(6916009)(4326008)(8936002)(91956017)(76116006)(86362001)(2906002)(83380400001)(5660300002)(9686003)(52536014)(64756008)(55016002)(186003)(7416002)(316002)(66946007)(66556008)(30864003)(66446008)(33656002)(54906003)(66476007)(7696005)(8676002)(478600001)(71200400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?vpG3TdYvkB6EYwMlj/tsGk46dduzVtwzmDKw/hPwD2Q/JuC9N0MUG78b6x?=
 =?iso-8859-1?Q?zYhUTVwn+fpwsJSKPYWJn5er6PeGBHjBAUOnBaWL9s/cwrBqag7fivcSh7?=
 =?iso-8859-1?Q?u+MCs8hSYYvIiCD7hYMw8Fe/51m5Xw+sRNj2D2KEHAD0mdwWhgQXD03fMJ?=
 =?iso-8859-1?Q?CyAFT3r1T4Z5xghZlCenZqSvZv73nTHtXMdbHhbCD6PwrL9ljfHMiW7NzY?=
 =?iso-8859-1?Q?pXUjPYsWOt0SsZmthKHDowpLsgsUWBD1+XSCRR1mj9/9dBcPrQkWAyX/3T?=
 =?iso-8859-1?Q?C5XVBV5p/uACquz3T4okGvon456sr6Z22eBppiSK8kMZ1uJHbxrIjUjgUq?=
 =?iso-8859-1?Q?z/UlZ9aVoCoXReSeFuJcuOqvq+shK8c/DY6AL3zk19qQTPUuRtdJsyu9u4?=
 =?iso-8859-1?Q?AH3sNbmv0JAKgyBIFPsaVnc73mki6lx7IClWbM4CzryN6b0xT0N5d3fUKD?=
 =?iso-8859-1?Q?cPt9We9lmnd7KF/2EuZbf8wMWSv9UO2mRtrnRktpEb6/+Iw4ZOH0gKth8n?=
 =?iso-8859-1?Q?54UPyB+QLb2Yfsvm4g8WxMz/EUUQoNPRliH5UkErcdij0H9JE/O7B2Eum7?=
 =?iso-8859-1?Q?ujS6v82uKHFmmjgL97VMAsRMSMt+sgFmIQd7HZRa4ZbMiOmQRuvA92RyRL?=
 =?iso-8859-1?Q?V9BaGys4KtY3B2BxB/9WtdDSsAdY7/4gj3XNo71kNUHf3iq99ap8iuyBvP?=
 =?iso-8859-1?Q?7bQWY5UlDmouoyKsECP6QovGUHMWtzC1PVD1VjLHNFcBEmJFUloUKhUg5B?=
 =?iso-8859-1?Q?AW6igkSK6Wt/QJMyBupBmS8vzxYC8kWqx5Nperjy+r9HF92boKjvjkef/X?=
 =?iso-8859-1?Q?mi3TWMVrZf4KT/P9+RZdblQyFPK1Kj38iFGTJMl1gkTDRlyt2ZkOE3LosH?=
 =?iso-8859-1?Q?tu6xGYkh/siqTT/sK3GmARdg8KPlUGFOGrmPaK6sRBKf7TJJQA7RV3MFPN?=
 =?iso-8859-1?Q?ORsLto/E/f7B6alCnUiZowucUggCJF/q/oVvzs7pd/q7jJHkopYaspXCez?=
 =?iso-8859-1?Q?LCg/LoOQuGstf8aG2FNXw6ondHxbkAaj46U5UPovJIwWxT2n0FlVwuWe8I?=
 =?iso-8859-1?Q?/8ZtJX1NjREWnKC6NWlAEPnJOC1ZwPXHgkHp5rPi9QVN?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f69e64-7d67-431f-86b8-08d8b1d25f93
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 23:33:57.5984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rUpWRjsipFlxK93Aw0CrX3WVaJ6e5W+rFEZQRQjAPaiNWEc/xGUqVlE9V3qRReqW1j+BM6TionLE8q9RIU5NIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6415
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/01/05 21:24, Selva Jove wrote:=0A=
> Thanks for the review, Damien.=0A=
> =0A=
> On Mon, Jan 4, 2021 at 6:17 PM Damien Le Moal <Damien.LeMoal@wdc.com> wro=
te:=0A=
>>=0A=
>> On 2021/01/04 19:48, SelvaKumar S wrote:=0A=
>>> Add new BLKCOPY ioctl that offloads copying of one or more sources=0A=
>>> ranges to a destination in the device. Accepts copy_ranges that contain=
s=0A=
>>> destination, no of sources and pointer to the array of source=0A=
>>> ranges. Each range_entry contains start and length of source=0A=
>>> ranges (in bytes).=0A=
>>>=0A=
>>> Introduce REQ_OP_COPY, a no-merge copy offload operation. Create=0A=
>>> bio with control information as payload and submit to the device.=0A=
>>> REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted=
=0A=
>>> to zoned device.=0A=
>>>=0A=
>>> If the device doesn't support copy or copy offload is disabled, then=0A=
>>> copy is emulated by allocating memory of total copy size. The source=0A=
>>> ranges are read into memory by chaining bio for each source ranges and=
=0A=
>>> submitting them async and the last bio waits for completion. After data=
=0A=
>>> is read, it is written to the destination.=0A=
>>>=0A=
>>> bio_map_kern() is used to allocate bio and add pages of copy buffer to=
=0A=
>>> bio. As bio->bi_private and bio->bi_end_io is needed for chaining the=
=0A=
>>> bio and over written, invalidate_kernel_vmap_range() for read is called=
=0A=
>>> in the caller.=0A=
>>>=0A=
>>> Introduce queue limits for simple copy and other helper functions.=0A=
>>> Add device limits as sysfs entries.=0A=
>>>       - copy_offload=0A=
>>>       - max_copy_sectors=0A=
>>>       - max_copy_ranges_sectors=0A=
>>>       - max_copy_nr_ranges=0A=
>>>=0A=
>>> copy_offload(=3D 0) is disabled by default.=0A=
>>> max_copy_sectors =3D 0 indicates the device doesn't support native copy=
.=0A=
>>>=0A=
>>> Native copy offload is not supported for stacked devices and is done vi=
a=0A=
>>> copy emulation.=0A=
>>>=0A=
>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>=0A=
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>=0A=
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>=0A=
>>> Signed-off-by: Javier Gonz=E1lez <javier.gonz@samsung.com>=0A=
>>> ---=0A=
>>>  block/blk-core.c          |  94 ++++++++++++++--=0A=
>>>  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++=
=0A=
>>>  block/blk-merge.c         |   2 +=0A=
>>>  block/blk-settings.c      |  10 ++=0A=
>>>  block/blk-sysfs.c         |  50 +++++++++=0A=
>>>  block/blk-zoned.c         |   1 +=0A=
>>>  block/bounce.c            |   1 +=0A=
>>>  block/ioctl.c             |  43 ++++++++=0A=
>>>  include/linux/bio.h       |   1 +=0A=
>>>  include/linux/blk_types.h |  15 +++=0A=
>>>  include/linux/blkdev.h    |  13 +++=0A=
>>>  include/uapi/linux/fs.h   |  13 +++=0A=
>>>  12 files changed, 458 insertions(+), 8 deletions(-)=0A=
>>>=0A=
>>> diff --git a/block/blk-core.c b/block/blk-core.c=0A=
>>> index 96e5fcd7f071..4a5cd3f53cd2 100644=0A=
>>> --- a/block/blk-core.c=0A=
>>> +++ b/block/blk-core.c=0A=
>>> @@ -719,6 +719,17 @@ static noinline int should_fail_bio(struct bio *bi=
o)=0A=
>>>  }=0A=
>>>  ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);=0A=
>>>=0A=
>>> +static inline int bio_check_copy_eod(struct bio *bio, sector_t start,=
=0A=
>>> +             sector_t nr_sectors, sector_t maxsector)=0A=
>>> +{=0A=
>>> +     if (nr_sectors && maxsector &&=0A=
>>> +         (nr_sectors > maxsector || start > maxsector - nr_sectors)) {=
=0A=
>>> +             handle_bad_sector(bio, maxsector);=0A=
>>> +             return -EIO;=0A=
>>> +     }=0A=
>>> +     return 0;=0A=
>>> +}=0A=
>>> +=0A=
>>>  /*=0A=
>>>   * Check whether this bio extends beyond the end of the device or part=
ition.=0A=
>>>   * This may well happen - the kernel calls bread() without checking th=
e size of=0A=
>>> @@ -737,6 +748,65 @@ static inline int bio_check_eod(struct bio *bio, s=
ector_t maxsector)=0A=
>>>       return 0;=0A=
>>>  }=0A=
>>>=0A=
>>> +/*=0A=
>>> + * Check for copy limits and remap source ranges if needed.=0A=
>>> + */=0A=
>>> +static int blk_check_copy(struct bio *bio)=0A=
>>> +{=0A=
>>> +     struct block_device *p =3D NULL;=0A=
>>> +     struct request_queue *q =3D bio->bi_disk->queue;=0A=
>>> +     struct blk_copy_payload *payload;=0A=
>>> +     int i, maxsector, start_sect =3D 0, ret =3D -EIO;=0A=
>>> +     unsigned short nr_range;=0A=
>>> +=0A=
>>> +     rcu_read_lock();=0A=
>>> +=0A=
>>> +     p =3D __disk_get_part(bio->bi_disk, bio->bi_partno);=0A=
>>> +     if (unlikely(!p))=0A=
>>> +             goto out;=0A=
>>> +     if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))=0A=
>>> +             goto out;=0A=
>>> +     if (unlikely(bio_check_ro(bio, p)))=0A=
>>> +             goto out;=0A=
>>> +=0A=
>>> +     maxsector =3D  bdev_nr_sectors(p);=0A=
>>> +     start_sect =3D p->bd_start_sect;=0A=
>>> +=0A=
>>> +     payload =3D bio_data(bio);=0A=
>>> +     nr_range =3D payload->copy_range;=0A=
>>> +=0A=
>>> +     /* cannot handle copy crossing nr_ranges limit */=0A=
>>> +     if (payload->copy_range > q->limits.max_copy_nr_ranges)=0A=
>>> +             goto out;=0A=
>>=0A=
>> If payload->copy_range indicates the number of ranges to be copied, you =
should=0A=
>> name it payload->copy_nr_ranges.=0A=
>>=0A=
> =0A=
> Agreed. Will rename the entries.=0A=
> =0A=
>>> +=0A=
>>> +     /* cannot handle copy more than copy limits */=0A=
>>=0A=
>> Why ? You could loop... Similarly to discard, zone reset etc.=0A=
>>=0A=
> =0A=
> Sure. Will add the support for handling copy larger than device limits.=
=0A=
> =0A=
>>=0A=
>>> +     if (payload->copy_size > q->limits.max_copy_sectors)=0A=
>>> +             goto out;=0A=
>>=0A=
>> Shouldn't the list of source ranges give the total size to be copied ?=
=0A=
>> Otherwise, if payload->copy_size is user provided, you would need to che=
ck that=0A=
>> the sum of the source ranges actually is equal to copy_size, no ? That m=
eans=0A=
>> that dropping copy_size sound like the right thing to do here.=0A=
>>=0A=
> =0A=
> payload->copy_size is used in copy emulation to allocate the buffer.=0A=
> Let me check=0A=
> one more time if it is possible to do without this.=0A=
=0A=
If this is used for the emulation only, then it should be a local variable =
in=0A=
the emulation helper.=0A=
=0A=
[...]=0A=
>>=0A=
>>> +             if (unlikely(blk_check_copy(bio)))=0A=
>>> +                     goto end_io;=0A=
>>> +             break;=0A=
>>>       case REQ_OP_SECURE_ERASE:=0A=
>>>               if (!blk_queue_secure_erase(q))=0A=
>>>                       goto not_supported;=0A=
>>> diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
>>> index 752f9c722062..4c0f12e2ed7c 100644=0A=
>>> --- a/block/blk-lib.c=0A=
>>> +++ b/block/blk-lib.c=0A=
>>> @@ -150,6 +150,229 @@ int blkdev_issue_discard(struct block_device *bde=
v, sector_t sector,=0A=
>>>  }=0A=
>>>  EXPORT_SYMBOL(blkdev_issue_discard);=0A=
>>>=0A=
>>> +int blk_copy_offload(struct block_device *bdev, struct blk_copy_payloa=
d *payload,=0A=
>>> +             sector_t dest, gfp_t gfp_mask)=0A=
>>> +{=0A=
>>> +     struct bio *bio;=0A=
>>> +     int ret, total_size;=0A=
>>> +=0A=
>>> +     bio =3D bio_alloc(gfp_mask, 1);=0A=
>>> +     bio->bi_iter.bi_sector =3D dest;=0A=
>>> +     bio->bi_opf =3D REQ_OP_COPY | REQ_NOMERGE;=0A=
>>> +     bio_set_dev(bio, bdev);=0A=
>>> +=0A=
>>> +     total_size =3D struct_size(payload, range, payload->copy_range);=
=0A=
>>> +     ret =3D bio_add_page(bio, virt_to_page(payload), total_size,=0A=
>>=0A=
>> How is payload allocated ? If it is a structure on-stack in the caller, =
I am not=0A=
>> sure it would be wise to do an IO using the thread stack page...=0A=
>>=0A=
>>> +                                        offset_in_page(payload));=0A=
>>> +     if (ret !=3D total_size) {=0A=
>>> +             ret =3D -ENOMEM;=0A=
>>> +             bio_put(bio);=0A=
>>> +             goto err;=0A=
>>> +     }=0A=
>>> +=0A=
>>> +     ret =3D submit_bio_wait(bio);=0A=
>>> +err:=0A=
>>> +     bio_put(bio);=0A=
>>> +     return ret;=0A=
>>> +=0A=
>>> +}=0A=
>>> +=0A=
>>> +int blk_read_to_buf(struct block_device *bdev, struct blk_copy_payload=
 *payload,=0A=
>>> +             gfp_t gfp_mask, void **buf_p)=0A=
>>> +{=0A=
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>> +     struct bio *bio, *parent =3D NULL;=0A=
>>> +     void *buf =3D NULL;=0A=
>>> +     bool is_vmalloc;=0A=
>>> +     int i, nr_srcs, copy_len, ret, cur_size, t_len =3D 0;=0A=
>>> +=0A=
>>> +     nr_srcs =3D payload->copy_range;=0A=
>>> +     copy_len =3D payload->copy_size << SECTOR_SHIFT;=0A=
>>> +=0A=
>>> +     buf =3D kvmalloc(copy_len, gfp_mask);=0A=
>>> +     if (!buf)=0A=
>>> +             return -ENOMEM;=0A=
>>> +     is_vmalloc =3D is_vmalloc_addr(buf);=0A=
>>> +=0A=
>>> +     for (i =3D 0; i < nr_srcs; i++) {=0A=
>>> +             cur_size =3D payload->range[i].len << SECTOR_SHIFT;=0A=
>>> +=0A=
>>> +             bio =3D bio_map_kern(q, buf + t_len, cur_size, gfp_mask);=
=0A=
>>> +             if (IS_ERR(bio)) {=0A=
>>> +                     ret =3D PTR_ERR(bio);=0A=
>>> +                     goto out;=0A=
>>> +             }=0A=
>>> +=0A=
>>> +             bio->bi_iter.bi_sector =3D payload->range[i].src;=0A=
>>> +             bio->bi_opf =3D REQ_OP_READ;=0A=
>>> +             bio_set_dev(bio, bdev);=0A=
>>> +             bio->bi_end_io =3D NULL;=0A=
>>> +             bio->bi_private =3D NULL;=0A=
>>> +=0A=
>>> +             if (parent) {=0A=
>>> +                     bio_chain(parent, bio);=0A=
>>> +                     submit_bio(parent);=0A=
>>> +             }=0A=
>>> +=0A=
>>> +             parent =3D bio;=0A=
>>> +             t_len +=3D cur_size;=0A=
>>> +     }=0A=
>>> +=0A=
>>> +     ret =3D submit_bio_wait(bio);=0A=
>>> +     bio_put(bio);=0A=
>>> +     if (is_vmalloc)=0A=
>>> +             invalidate_kernel_vmap_range(buf, copy_len);=0A=
>>> +     if (ret)=0A=
>>> +             goto out;=0A=
>>> +=0A=
>>> +     *buf_p =3D buf;=0A=
>>> +     return 0;=0A=
>>> +out:=0A=
>>> +     kvfree(buf);=0A=
>>> +     return ret;=0A=
>>> +}=0A=
>>> +=0A=
>>> +int blk_write_from_buf(struct block_device *bdev, void *buf, sector_t =
dest,=0A=
>>> +             int copy_len, gfp_t gfp_mask)=0A=
>>> +{=0A=
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>> +     struct bio *bio;=0A=
>>> +     int ret;=0A=
>>> +=0A=
>>> +     bio =3D bio_map_kern(q, buf, copy_len, gfp_mask);=0A=
>>> +     if (IS_ERR(bio)) {=0A=
>>> +             ret =3D PTR_ERR(bio);=0A=
>>> +             goto out;=0A=
>>> +     }=0A=
>>> +     bio_set_dev(bio, bdev);=0A=
>>> +     bio->bi_opf =3D REQ_OP_WRITE;=0A=
>>> +     bio->bi_iter.bi_sector =3D dest;=0A=
>>> +=0A=
>>> +     bio->bi_end_io =3D NULL;=0A=
>>> +     ret =3D submit_bio_wait(bio);=0A=
>>> +     bio_put(bio);=0A=
>>> +out:=0A=
>>> +     return ret;=0A=
>>> +}=0A=
>>> +=0A=
>>> +int blk_prepare_payload(struct block_device *bdev, int nr_srcs, struct=
 range_entry *rlist,=0A=
>>> +             gfp_t gfp_mask, struct blk_copy_payload **payload_p)=0A=
>>> +{=0A=
>>> +=0A=
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>> +     struct blk_copy_payload *payload;=0A=
>>> +     sector_t bs_mask;=0A=
>>> +     sector_t src_sects, len =3D 0, total_len =3D 0;=0A=
>>> +     int i, ret, total_size;=0A=
>>> +=0A=
>>> +     if (!q)=0A=
>>> +             return -ENXIO;=0A=
>>> +=0A=
>>> +     if (!nr_srcs)=0A=
>>> +             return -EINVAL;=0A=
>>> +=0A=
>>> +     if (bdev_read_only(bdev))=0A=
>>> +             return -EPERM;=0A=
>>> +=0A=
>>> +     bs_mask =3D (bdev_logical_block_size(bdev) >> 9) - 1;=0A=
>>> +=0A=
>>> +     total_size =3D struct_size(payload, range, nr_srcs);=0A=
>>> +     payload =3D kmalloc(total_size, gfp_mask);=0A=
>>> +     if (!payload)=0A=
>>> +             return -ENOMEM;=0A=
>>=0A=
>> OK. So this is what goes into the bio. The function blk_copy_offload() a=
ssumes=0A=
>> this is at most one page, so total_size <=3D PAGE_SIZE. Where is that ch=
ecked ?=0A=
>>=0A=
> =0A=
> CMIIW. As payload was allocated via kmalloc, it would be represented by a=
 single=0A=
> contiguous segment. In case it crosses one page, rely on multi-page bio_v=
ec to=0A=
> cover it.=0A=
=0A=
That is not how I understand the code. If the allocation is more than one p=
age,=0A=
you still need to add ALL pages to the BIO. What the multi-page bvec code w=
ill=0A=
do is to use a single bvec for all physically contiguous pages instead of a=
dding=0A=
one bvec per page.=0A=
=0A=
Thinking more about it, I think the function blk_copy_offload() could simpl=
y use=0A=
bio_map_kern() to allocate and prepare the BIO. That will avoid the need fo=
r the=0A=
add page loop.=0A=
=0A=
> =0A=
>>> +=0A=
>>> +     for (i =3D 0; i < nr_srcs; i++) {=0A=
>>> +             /*  copy payload provided are in bytes */=0A=
>>> +             src_sects =3D rlist[i].src;=0A=
>>> +             if (src_sects & bs_mask) {=0A=
>>> +                     ret =3D  -EINVAL;=0A=
>>> +                     goto err;=0A=
>>> +             }=0A=
>>> +             src_sects =3D src_sects >> SECTOR_SHIFT;=0A=
>>> +=0A=
>>> +             if (len & bs_mask) {=0A=
>>> +                     ret =3D -EINVAL;=0A=
>>> +                     goto err;=0A=
>>> +             }=0A=
>>> +=0A=
>>> +             len =3D rlist[i].len >> SECTOR_SHIFT;=0A=
>>> +=0A=
>>> +             total_len +=3D len;=0A=
>>> +=0A=
>>> +             WARN_ON_ONCE((src_sects << 9) > UINT_MAX);=0A=
>>> +=0A=
>>> +             payload->range[i].src =3D src_sects;=0A=
>>> +             payload->range[i].len =3D len;=0A=
>>> +     }=0A=
>>> +=0A=
>>> +     /* storing # of source ranges */=0A=
>>> +     payload->copy_range =3D i;=0A=
>>> +     /* storing copy len so far */=0A=
>>> +     payload->copy_size =3D total_len;=0A=
>>=0A=
>> The comments here make the code ugly. Rename the variables and structure=
 fields=0A=
>> to have something self explanatory.=0A=
>>=0A=
> =0A=
> Agreed.=0A=
> =0A=
>>> +=0A=
>>> +     *payload_p =3D payload;=0A=
>>> +     return 0;=0A=
>>> +err:=0A=
>>> +     kfree(payload);=0A=
>>> +     return ret;=0A=
>>> +}=0A=
>>> +=0A=
>>> +/**=0A=
>>> + * blkdev_issue_copy - queue a copy=0A=
>>> + * @bdev:       source block device=0A=
>>> + * @nr_srcs: number of source ranges to copy=0A=
>>> + * @rlist:   array of source ranges (in bytes)=0A=
>>> + * @dest_bdev:       destination block device=0A=
>>> + * @dest:    destination (in bytes)=0A=
>>> + * @gfp_mask:   memory allocation flags (for bio_alloc)=0A=
>>> + *=0A=
>>> + * Description:=0A=
>>> + *   Copy array of source ranges from source block device to=0A=
>>> + *   destination block devcie.=0A=
>>> + */=0A=
>>> +=0A=
>>> +=0A=
>>> +int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,=0A=
>>> +             struct range_entry *src_rlist, struct block_device *dest_=
bdev,=0A=
>>> +             sector_t dest, gfp_t gfp_mask)=0A=
>>> +{=0A=
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>> +     struct blk_copy_payload *payload;=0A=
>>> +     sector_t bs_mask, dest_sect;=0A=
>>> +     void *buf =3D NULL;=0A=
>>> +     int ret;=0A=
>>> +=0A=
>>> +     ret =3D blk_prepare_payload(bdev, nr_srcs, src_rlist, gfp_mask, &=
payload);=0A=
>>> +     if (ret)=0A=
>>> +             return ret;=0A=
>>> +=0A=
>>> +     bs_mask =3D (bdev_logical_block_size(dest_bdev) >> 9) - 1;=0A=
>>> +     if (dest & bs_mask) {=0A=
>>> +             return -EINVAL;=0A=
>>> +             goto out;=0A=
>>> +     }=0A=
>>> +     dest_sect =3D dest >> SECTOR_SHIFT;=0A=
>>=0A=
>> dest should already be a 512B sector as all block layer functions interf=
ace use=0A=
>> this unit. What is this doing ?=0A=
>>=0A=
> =0A=
> As source ranges and length received were in bytes, to keep things=0A=
> same, dest was=0A=
> also chosen to be in bytes. Seems wrong. Will change it to the 512B secto=
r.=0A=
=0A=
Using a byte interface seems very dangerous since writes can only be at bes=
t LBA=0A=
sized, and must be physical sector size aligned for zoned block devices. I=
=0A=
strobgly suggest that the interface use sector_t 512B unit.=0A=
=0A=
> =0A=
>>=0A=
>>> +=0A=
>>> +     if (bdev =3D=3D dest_bdev && q->limits.copy_offload) {=0A=
>>> +             ret =3D blk_copy_offload(bdev, payload, dest_sect, gfp_ma=
sk);=0A=
>>> +             if (ret)=0A=
>>> +                     goto out;=0A=
>>> +     } else {=0A=
>>> +             ret =3D blk_read_to_buf(bdev, payload, gfp_mask, &buf);=
=0A=
>>> +             if (ret)=0A=
>>> +                     goto out;=0A=
>>> +             ret =3D blk_write_from_buf(dest_bdev, buf, dest_sect,=0A=
>>> +                             payload->copy_size << SECTOR_SHIFT, gfp_m=
ask);=0A=
>>=0A=
>> Arg... This is really not pretty. At the very least, this should all be =
in a=0A=
>> blk_copy_emulate() helper or something named like that.=0A=
>>=0A=
> =0A=
> Okay. Will move this to a helper.=0A=
> =0A=
>> My worry though is that this likely slow for large copies, not to mentio=
n that=0A=
>> buf is likely to fail to allocate for large copy cases. As commented pre=
viously,=0A=
>> dm-kcopyd already does such copy well, with a read-write streaming pipel=
ine and=0A=
>> zone support too for the write side. This should really be reused, at le=
ast=0A=
>> partly, instead of re-implementing this read-write here.=0A=
>>=0A=
> =0A=
> I was a bit hesitant to use dm layer code in the block layer. It makes se=
nse to=0A=
> reuse the code as much as possible. Will try to reuse dm-kcopyd code for =
copy=0A=
> emulation part.=0A=
=0A=
You missed my point. I never suggested that you use DM code in the block la=
yer.=0A=
That would be wrong. What I suggested is that you move the dm-kcopyd code f=
rom=0A=
DM into the block layer, changing the function names to blk_copy_xxx(). See=
 the=0A=
current interface in include/linux/dm-kcopyd.h: there is absolutely nothing=
 that=0A=
is DM specific in there, so moving that code into block/blk-copy.c should b=
e=0A=
straightforward, mostly.=0A=
=0A=
The way I see it, your series should look something like this:=0A=
1) A prep patch that moves dm-kcopyd to the block layer, changing the API n=
ames=0A=
and converting all DM driver users to the new API. This may be a very large=
=0A=
patch though, so splitting it into multiple peaces may be required to facil=
itate=0A=
review.=0A=
2) A prep patch that introduces queue flags for devices to advertize their=
=0A=
support for simple copy and a generic api for simple copy BIOs=0A=
3) A patch that adds the use of simple copy BIO into the moved dm-kcopyd co=
de=0A=
4) The NVMe driver bits that probably will look like what you have now=0A=
=0A=
With this, all DM drivers that currently use dm-kcopyd (RAID and dm-zoned a=
t=0A=
least) will get free offload using simple copy commands for sector copies w=
ithin=0A=
the same device. All other copy cases will still work as per kcopyd code. T=
hat=0A=
is very neat I think.=0A=
=0A=
And you can add one more patch that use this generic copy block interface t=
o=0A=
implement copy_file_range for raw block devices as Darrick suggested.=0A=
=0A=
=0A=
[...]=0A=
>>> +static ssize_t queue_copy_offload_store(struct request_queue *q,=0A=
>>> +                                    const char *page, size_t count)=0A=
>>> +{=0A=
>>> +     unsigned long copy_offload;=0A=
>>> +     ssize_t ret =3D queue_var_store(&copy_offload, page, count);=0A=
>>> +=0A=
>>> +     if (ret < 0)=0A=
>>> +             return ret;=0A=
>>> +=0A=
>>> +     if (copy_offload < 0 || copy_offload > 1)=0A=
>>=0A=
>> err... "copy_offload !=3D 1" ?=0A=
> =0A=
> Initial thought was to keep it either 0 or 1.  I'll change it to 0 or els=
e.=0A=
=0A=
If you use 0 and 1, then make copy_offload a bool. That is more natural giv=
en=0A=
the variable name.=0A=
=0A=
[...]=0A=
>>> +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,=0A=
>>> +             unsigned long arg)=0A=
>>> +{=0A=
>>> +     struct copy_range crange;=0A=
>>> +     struct range_entry *rlist;=0A=
>>> +     struct request_queue *q =3D bdev_get_queue(bdev);=0A=
>>> +     sector_t dest;=0A=
>>> +     int ret;=0A=
>>> +=0A=
>>> +     if (!(mode & FMODE_WRITE))=0A=
>>> +             return -EBADF;=0A=
>>> +=0A=
>>> +     if (!blk_queue_copy(q))=0A=
>>> +             return -EOPNOTSUPP;=0A=
>>=0A=
>> But you added the read-write emulation. So what is the point here ? This=
 ioctl=0A=
>> should work for any device, with or without simple copy support. Did you=
 test that ?=0A=
>>=0A=
> =0A=
> Sorry. It was a mistake. Will fix this.=0A=
=0A=
Please make sure to test to catch such mistakes before sending. It does sou=
nd=0A=
like your read-write manual copy has not been tested.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
