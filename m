Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E1DC47083
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 08:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C10F61424
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 08:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhFDIDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 04:03:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:22171 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbhFDIDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 04:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622793711; x=1654329711;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=DdJ8Z6uzMtjy+ZvwQ0GS6ZjUKcvBGa+ysMM9JIFd7Wo=;
  b=Jcku6G8jFrLOstsnQ32etGUvUcUdE/P16tulxsMFUocVP4ZaHY3B1T53
   7sbSJP7CBmde4/KiKSnbJSFTdyxQITxly5U7XjQCXwGn5LHOM90VkJHMm
   DCyk/t5knTWtN9OvopBeJeouZkt1SRffYZFNHB/GWH08rPDmfZFfS4uwo
   LV0Hokq40bFNl5oziEOcCQECESbKxcs6JDudcs/x2SOuLUBO8Fjntl6Kv
   iYILcyIEwqMC28ZO4LxquwGFSLu1cP4CDyx98wErvNxTGEeMv0TbTq1dK
   gLTSxkaIqrRVtxbwwDwE8Lx7DHAps1I0S4B2EhG57U9eP7ffnytJMJdza
   g==;
IronPort-SDR: zxOSqwE+l2E/YsPppyZ+7FGX/RW05hMrfIZLzEII1OH5pKkKElWFeYUg00O6fXpI0CWWIBqS6p
 vFwYQlsLl//7f42OsKbnRxYRqZ/FsPAgCdmWwkwlHoU/tBf9PV3wOzKoG84j/MSn9Qxg7mRhi/
 5k+/oE/bQ0cy8Zjl+94ysBfHJrJIOCz4DWG7l3RLMbSzdPwawbok1evU8dce0XrDU2FGmWYKZj
 XvVFbGRMj/1FgK/HQnw4awrBrCiwqohcXmtoJUS7bGsmOWotTKEiACQ2J7Rj5x7krITqRjQ1m/
 324=
X-IronPort-AV: E=Sophos;i="5.83,247,1616428800"; 
   d="scan'208";a="274572565"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2021 16:01:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kF7+C7q+y25vT5RtyyAR9mcuTksmDqv0S3mu8Shnwb9Y8Z3DuT09cgPga7BFuGgOBEh3vkcf0zqytL5ESNZIX+84xzwdylvE4VXohTyolmXmcL/+Q9sagjXGpuniPbq1lGYs/EiQ/+dFViYfwWoLAqLA0AkxVEoZUoxama79OXaAWt5BHaVooAsjcFhbKdcPdfro5PAwciSvytor6ZUSuFPZgbxAsyVqRHV7ihpzs0ZZmN5wEh2BHooB7lqZ8jd4sEQ5W3PusGi2RPXjJKbjJuUk1gHKoerrwNsGepiUOUre62wNXttSD0+oZtVU98KpqkBto8MnQllM5NhkefblUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOACXoiZs+pVmDevC2Sik78SyKX+5K75YgczeYHd8fA=;
 b=hN9GHdaPxZW7QptIeZ96U2jwSQTKpAwFv1MOln1hVSZPEBbx1E8g44MPpuca08x7+Hb2dxGN5LTC8AgimeyAMtOC4h+J8qbBBdNmiTikCIrjl4n0NWR4/XNGjDvbSTZkIXliIxtLF0on2fmjmf9Txt/fmFPD57XPrY1u4OCGAnIlL7JC1zTV+BTjmOM3JiRzgWb6Tkwv25UBJaqDZENH7eZkBJUaBvdLy0upbrLH/weBQYgngSrWncUIxR/2AuksjpBWPaGqJiPEyFyuQKWc3kkHtDYhJkgKH+2Swlwt31bKVndUZvKXbkAiuAvmkRIBlLo4nFJujW3fIFoy1grH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOACXoiZs+pVmDevC2Sik78SyKX+5K75YgczeYHd8fA=;
 b=KiTl2MYXIVmBYwxmTMe24Mp/BaEjTMMph25VlVoZQHW86e28sH6NVvLxdra1wVwHwniZiW4avJvQrQTNAcNNrFM74QT419UHVkSKWQL+TUCJmyup1sNKNyf/G9l014VsJK83/H3/hXd3PtYnXywp98i1jpD0p9qG2o9sSMOhgXs=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB5241.namprd04.prod.outlook.com (2603:10b6:5:10e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 08:01:25 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 08:01:25 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Changheun Lee <nanich.lee@samsung.com>
CC:     Avri Altman <Avri.Altman@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "alex_y_xu@yahoo.ca" <alex_y_xu@yahoo.ca>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "bgoncalv@redhat.com" <bgoncalv@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "mj0123.lee@samsung.com" <mj0123.lee@samsung.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "patchwork-bot@kernel.org" <patchwork-bot@kernel.org>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yi.zhang@redhat.com" <yi.zhang@redhat.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Thread-Topic: [PATCH v12 1/3] bio: control bio max size
Thread-Index: AQHXWQGQYa2LuZQyw0qIwaPlt0+d8Q==
Date:   Fri, 4 Jun 2021 08:01:25 +0000
Message-ID: <DM6PR04MB70811B0A9F77D8F774ED11BEE73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
 <CGME20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74@epcas1p1.samsung.com>
 <20210604073459.29235-1-nanich.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:f9bc:fd30:41b8:96f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7824596-90d8-44c7-df59-08d9272ef399
x-ms-traffictypediagnostic: DM6PR04MB5241:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB524173C0FC967A816280820EE73B9@DM6PR04MB5241.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hb/UH35gYMnaeI6badv0DhMU/aQ63pq+2LtlVJt458CykKaRtnicu2sVwO6XlmjrTPL5VS1s8SGTzpWFl5bJhO+h6a5xw6nrqpNEsXgpBKVIaNvK4Z32n7pE5B89ITjbcw6TKjhNyiexbR68WnjWPSTqE1stZhHrYgoteTSvDm3KVa4C5Rue9qYePmL8XbpY1f2aNlBK4BJ14J4doVwUrQZ8u4eIjw5j2+4z44LsCRHWcAQ1+rBFU1+A9BQ+k4nrmV3afCRhdxbGoHYaL2KOg1YR/4Y+3GACFX2I9evJ/sAaFCfsbaw1QvPSURW8M10nfcbzIIh5p66BYmJgXeV5EjBAXLWjJeymT1Q9l4lXauDQd70TB4vffNdi2KBKDUsQDAQpYv6apRUPgsM9QmGS0Cl0L9CWR3dFPeJXoTR8C9gYNLLIr6MuEd4usP8n5AtMWwbIHZBK9jxg2bK0IJrKkH/9RSNX3S1qoTWbjwafo2lwP8HGr/BZs3nYzZQnWubbYRGBtv1j3fnEpFmebCUFlMULeiXvOL6Dc/5jgPnqCkjbelBH0Ubk/JW3Xohx5vouZhXjopr2WUFTjhRrx3MGXOKTYhxTmA3MG7wPcxfW5PY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(66476007)(66556008)(66946007)(66446008)(53546011)(55016002)(86362001)(8676002)(33656002)(64756008)(9686003)(316002)(54906003)(186003)(8936002)(6916009)(76116006)(478600001)(91956017)(7416002)(7696005)(6506007)(71200400001)(5660300002)(122000001)(38100700002)(2906002)(4326008)(83380400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?agTJ9OXFjx/CJwzStzYjdOz4eqPmmIT79QvU+GbZK8CiqZK0tUVYlfQBY3br?=
 =?us-ascii?Q?HT04yqq34H9/FEQEO3gqP62Ws9lAsiaeBLF+qIE1J4+2g+SELKXNy1HmGKof?=
 =?us-ascii?Q?EYQAxjZfGLJKnTtUiEgIv7ILnM9pEGVb2ffKlZxBkR5cwNW4eivA7z8qwFCN?=
 =?us-ascii?Q?AE2AEJlGx6hvfrASbBT62jmtjK9OhQhItsnGj92vwMBHEwV6FJztlz+i2iYD?=
 =?us-ascii?Q?UVNqLuiFkr60ZFcZWq28ZXm3XWHo/WdHSQ1oAtFIAMkLo+p/qmtUM0kB/vPC?=
 =?us-ascii?Q?Es6kbptXXrFREVorT3XseUHuYoVkqle88oGOhXJv4SCjyI5BKnHvAre7ny8s?=
 =?us-ascii?Q?ZyrKXUmwYLpfxCc+3mnZMxDa1JmBocDdhbQlGspbWNZYbIt/lx/gvvG3k35Z?=
 =?us-ascii?Q?F/3JCN5iILmkSrcdKmOM3aN0Y99gGPN6YzbXLPhRqS03Wa9B7muRy8DrBvqL?=
 =?us-ascii?Q?pOQkrZDVHeoDD4B8gxhzShzTuKdsoSGdLHM7LikwmC5d2xP47Lbi5pJaj5U9?=
 =?us-ascii?Q?4rK03mPznNzoNwjBbvXGo7nsaOBLjhxJfX9+AWsYLq6xc03UB2O0U42ZOjZD?=
 =?us-ascii?Q?0556GhCN/3ZqNK3xwNmvUGzrD+Ed1VkNfN6weo2c6TppPc7NtXqTttyebI/J?=
 =?us-ascii?Q?iQVS6bGqiQJ0Pz+WMhjouUpQPoKduzpxXDRXpSqSmJCwRTq3QiTvHnZa9BqC?=
 =?us-ascii?Q?HdWvqzUyXkJnXRmvV25e+1QFXJXqHJeiM549tTM24mOgsiEoRpMQF4PfA/v7?=
 =?us-ascii?Q?gFUH/j0loN2TidKrHrloHslCd5X0jsrW9ChTtlKjdHmuvMXWReq3RxrE8dYK?=
 =?us-ascii?Q?Bx2ooYfIR0XWFpxufEVUxEEPaUWh5RbYTGHYuCiAthR3WiUTEOjKC7y7MCgI?=
 =?us-ascii?Q?iddJjeBdJ7X1IC+3NjR0nAqdaQ5749h3gV5YYlIq/ytuqD1oC6zuXWHu2kff?=
 =?us-ascii?Q?8YwAvuH4+Amj4HzIbuYMC5nuqH4LkxolPqZm2Dv2DfjgtSkg5ioXsRZi6myD?=
 =?us-ascii?Q?+UZpX/dUtFJDjCYJeShG/g5j06C9RLHXhbXxpszBWuoUHSxmWJT5eeKJyMU8?=
 =?us-ascii?Q?bCXALTIoCV+IS0aCmKydS7haDKGuYJ6hyCe/rNx+/VzTh+/hs/NFcWj1NXx2?=
 =?us-ascii?Q?u8LjTIuNjY/d/FTMyGgvuZz0OmJoodlVRlOPFAt+BnMpZ/N1ZO7cKI45ohK+?=
 =?us-ascii?Q?mvJ81amT9L7BcqhE5mr8tCwR2jRerDfMAkIQgfCPVfKaw2MpZBuJAyRTEiZ0?=
 =?us-ascii?Q?h76oOe60R8Ij2/bbR1Rkxb7r4Xj1hvY+1LdZdCJiVgk5C1EeelAJUw9qrkIJ?=
 =?us-ascii?Q?kbC4gKF3ySKaTPq1o2OoinNDzM4wTazBd5hyYfc/EeXppsQOq17o1S3LV6Dz?=
 =?us-ascii?Q?e6xub5OYRegsU7bELF641+rAJZQVAIaG11bS+Wr4iCAfGswsyQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7824596-90d8-44c7-df59-08d9272ef399
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 08:01:25.7238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQuFoDazG+rHJ1izJOiYbPY4kVLJ1clhP3nKmecdZkWgn65IvIpU4ezSZsg7kePIk02GMlXxZjaYnJ5MjaZ8aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5241
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/06/04 16:53, Changheun Lee wrote:=0A=
>> On 2021/06/04 14:22, Changheun Lee wrote:=0A=
>>> bio size can grow up to 4GB after muli-page bvec has been enabled.=0A=
>>> But sometimes large size of bio would lead to inefficient behaviors.=0A=
>>> Control of bio max size will be helpful to improve inefficiency.=0A=
>>>=0A=
>>> Below is a example for inefficient behaviours.=0A=
>>> In case of large chunk direct I/O, - 32MB chunk read in user space -=0A=
>>> all pages for 32MB would be merged to a bio structure if the pages=0A=
>>> physical addresses are contiguous. It makes some delay to submit=0A=
>>> until merge complete. bio max size should be limited to a proper size.=
=0A=
>>>=0A=
>>> When 32MB chunk read with direct I/O option is coming from userspace,=
=0A=
>>> kernel behavior is below now in do_direct_IO() loop. It's timeline.=0A=
>>>=0A=
>>>  | bio merge for 32MB. total 8,192 pages are merged.=0A=
>>>  | total elapsed time is over 2ms.=0A=
>>>  |------------------ ... ----------------------->|=0A=
>>>                                                  | 8,192 pages merged a=
 bio.=0A=
>>>                                                  | at this time, first =
bio submit is done.=0A=
>>>                                                  | 1 bio is split to 32=
 read request and issue.=0A=
>>>                                                  |--------------->=0A=
>>>                                                   |--------------->=0A=
>>>                                                    |--------------->=0A=
>>>                                                               ......=0A=
>>>                                                                    |---=
------------>=0A=
>>>                                                                     |--=
------------->|=0A=
>>>                           total 19ms elapsed to complete 32MB read done=
 from device. |=0A=
>>>=0A=
>>> If bio max size is limited with 1MB, behavior is changed below.=0A=
>>>=0A=
>>>  | bio merge for 1MB. 256 pages are merged for each bio.=0A=
>>>  | total 32 bio will be made.=0A=
>>>  | total elapsed time is over 2ms. it's same.=0A=
>>>  | but, first bio submit timing is fast. about 100us.=0A=
>>>  |--->|--->|--->|---> ... -->|--->|--->|--->|--->|=0A=
>>>       | 256 pages merged a bio.=0A=
>>>       | at this time, first bio submit is done.=0A=
>>>       | and 1 read request is issued for 1 bio.=0A=
>>>       |--------------->=0A=
>>>            |--------------->=0A=
>>>                 |--------------->=0A=
>>>                                       ......=0A=
>>>                                                  |--------------->=0A=
>>>                                                   |--------------->|=0A=
>>>         total 17ms elapsed to complete 32MB read done from device. |=0A=
>>>=0A=
>>> As a result, read request issue timing is faster if bio max size is lim=
ited.=0A=
>>> Current kernel behavior with multipage bvec, super large bio can be cre=
ated.=0A=
>>> And it lead to delay first I/O request issue.=0A=
>>>=0A=
>>> Signed-off-by: Changheun Lee <nanich.lee@samsung.com>=0A=
>>> ---=0A=
>>>  block/bio.c            | 17 ++++++++++++++---=0A=
>>>  block/blk-settings.c   | 19 +++++++++++++++++++=0A=
>>>  include/linux/bio.h    |  4 +++-=0A=
>>>  include/linux/blkdev.h |  3 +++=0A=
>>>  4 files changed, 39 insertions(+), 4 deletions(-)=0A=
>>>=0A=
>>> diff --git a/block/bio.c b/block/bio.c=0A=
>>> index 44205dfb6b60..73b673f1684e 100644=0A=
>>> --- a/block/bio.c=0A=
>>> +++ b/block/bio.c=0A=
>>> @@ -255,6 +255,13 @@ void bio_init(struct bio *bio, struct bio_vec *tab=
le,=0A=
>>>  }=0A=
>>>  EXPORT_SYMBOL(bio_init);=0A=
>>>  =0A=
>>> +unsigned int bio_max_bytes(struct bio *bio)=0A=
>>> +{=0A=
>>> +	struct block_device *bdev =3D bio->bi_bdev;=0A=
>>> +=0A=
>>> +	return bdev ? bdev->bd_disk->queue->limits.max_bio_bytes : UINT_MAX;=
=0A=
>>> +}=0A=
>>=0A=
>> unsigned int bio_max_bytes(struct bio *bio)=0A=
>> {=0A=
>> 	struct block_device *bdev =3D bio->bi_bdev;=0A=
>>=0A=
>> 	if (!bdev)=0A=
>> 		return UINT_MAX;=0A=
>> 	return bdev->bd_disk->queue->limits.max_bio_bytes;=0A=
>> }=0A=
>>=0A=
>> is a lot more readable...=0A=
>> Also, I remember there was some problems with bd_disk possibly being nul=
l. Was=0A=
>> that fixed ?=0A=
> =0A=
> Thank you for review. But I'd like current style, and it's readable enoug=
h=0A=
> now I think. Null of bd_disk was just suspicion. bd_disk is not null if b=
dev=0A=
> is not null.=0A=
> =0A=
>>=0A=
>>> +=0A=
>>>  /**=0A=
>>>   * bio_reset - reinitialize a bio=0A=
>>>   * @bio:	bio to reset=0A=
>>> @@ -866,7 +873,7 @@ bool __bio_try_merge_page(struct bio *bio, struct p=
age *page,=0A=
>>>  		struct bio_vec *bv =3D &bio->bi_io_vec[bio->bi_vcnt - 1];=0A=
>>>  =0A=
>>>  		if (page_is_mergeable(bv, page, len, off, same_page)) {=0A=
>>> -			if (bio->bi_iter.bi_size > UINT_MAX - len) {=0A=
>>> +			if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len) {=0A=
>>>  				*same_page =3D false;=0A=
>>>  				return false;=0A=
>>>  			}=0A=
>>> @@ -995,6 +1002,7 @@ static int __bio_iov_iter_get_pages(struct bio *bi=
o, struct iov_iter *iter)=0A=
>>>  {=0A=
>>>  	unsigned short nr_pages =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
>>>  	unsigned short entries_left =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
>>> +	unsigned int bytes_left =3D bio_max_bytes(bio) - bio->bi_iter.bi_size=
;=0A=
>>>  	struct bio_vec *bv =3D bio->bi_io_vec + bio->bi_vcnt;=0A=
>>>  	struct page **pages =3D (struct page **)bv;=0A=
>>>  	bool same_page =3D false;=0A=
>>> @@ -1010,7 +1018,8 @@ static int __bio_iov_iter_get_pages(struct bio *b=
io, struct iov_iter *iter)=0A=
>>>  	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);=0A=
>>>  	pages +=3D entries_left * (PAGE_PTRS_PER_BVEC - 1);=0A=
>>>  =0A=
>>> -	size =3D iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset)=
;=0A=
>>> +	size =3D iov_iter_get_pages(iter, pages, bytes_left, nr_pages,=0A=
>>> +				  &offset);=0A=
>>>  	if (unlikely(size <=3D 0))=0A=
>>>  		return size ? size : -EFAULT;=0A=
>>>  =0A=
>>> @@ -1038,6 +1047,7 @@ static int __bio_iov_append_get_pages(struct bio =
*bio, struct iov_iter *iter)=0A=
>>>  {=0A=
>>>  	unsigned short nr_pages =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
>>>  	unsigned short entries_left =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
>>> +	unsigned int bytes_left =3D bio_max_bytes(bio) - bio->bi_iter.bi_size=
;=0A=
>>>  	struct request_queue *q =3D bio->bi_bdev->bd_disk->queue;=0A=
>>>  	unsigned int max_append_sectors =3D queue_max_zone_append_sectors(q);=
=0A=
>>>  	struct bio_vec *bv =3D bio->bi_io_vec + bio->bi_vcnt;=0A=
>>> @@ -1058,7 +1068,8 @@ static int __bio_iov_append_get_pages(struct bio =
*bio, struct iov_iter *iter)=0A=
>>>  	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);=0A=
>>>  	pages +=3D entries_left * (PAGE_PTRS_PER_BVEC - 1);=0A=
>>>  =0A=
>>> -	size =3D iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset)=
;=0A=
>>> +	size =3D iov_iter_get_pages(iter, pages, bytes_left, nr_pages,=0A=
>>> +				  &offset);=0A=
>>>  	if (unlikely(size <=3D 0))=0A=
>>>  		return size ? size : -EFAULT;=0A=
>>>  =0A=
>>> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
>>> index 902c40d67120..e270e31519a1 100644=0A=
>>> --- a/block/blk-settings.c=0A=
>>> +++ b/block/blk-settings.c=0A=
>>> @@ -32,6 +32,7 @@ EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);=0A=
>>>   */=0A=
>>>  void blk_set_default_limits(struct queue_limits *lim)=0A=
>>>  {=0A=
>>> +	lim->max_bio_bytes =3D UINT_MAX;=0A=
>>>  	lim->max_segments =3D BLK_MAX_SEGMENTS;=0A=
>>>  	lim->max_discard_segments =3D 1;=0A=
>>>  	lim->max_integrity_segments =3D 0;=0A=
>>> @@ -100,6 +101,24 @@ void blk_queue_bounce_limit(struct request_queue *=
q, enum blk_bounce bounce)=0A=
>>>  }=0A=
>>>  EXPORT_SYMBOL(blk_queue_bounce_limit);=0A=
>>>  =0A=
>>> +/**=0A=
>>> + * blk_queue_max_bio_bytes - set bio max size for queue=0A=
>>=0A=
>> blk_queue_max_bio_bytes - set max_bio_bytes queue limit=0A=
>>=0A=
>> And then you can drop the not very useful description.=0A=
> =0A=
> OK. I'll.=0A=
> =0A=
>>=0A=
>>> + * @q: the request queue for the device=0A=
>>> + * @bytes : bio max bytes to be set=0A=
>>> + *=0A=
>>> + * Description:=0A=
>>> + *    Set proper bio max size to optimize queue operating.=0A=
>>> + **/=0A=
>>> +void blk_queue_max_bio_bytes(struct request_queue *q, unsigned int byt=
es)=0A=
>>> +{=0A=
>>> +	struct queue_limits *limits =3D &q->limits;=0A=
>>> +	unsigned int max_bio_bytes =3D round_up(bytes, PAGE_SIZE);=0A=
>>> +=0A=
>>> +	limits->max_bio_bytes =3D max_t(unsigned int, max_bio_bytes,=0A=
>>> +				      BIO_MAX_VECS * PAGE_SIZE);=0A=
>>> +}=0A=
>>> +EXPORT_SYMBOL(blk_queue_max_bio_bytes);=0A=
>>=0A=
>> Setting of the stacked limits is still missing.=0A=
> =0A=
> max_bio_bytes for stacked device is just default(UINT_MAX) in this patch.=
=0A=
> Because blk_set_stacking_limits() call blk_set_default_limits().> I'll wo=
rk continue for stacked device after this patchowork.=0A=
=0A=
Why ? Without that added now, anybody using this performance fix will see n=
o=0A=
benefits if a device mapper is used. The stacking limit should be super sim=
ple.=0A=
In blk_stack_limits(), just add:=0A=
=0A=
	t->max_bio_bytes =3D min(t->max_bio_bytes, b->max_bio_bytes);=0A=
=0A=
> =0A=
>>=0A=
>>> +=0A=
>>>  /**=0A=
>>>   * blk_queue_max_hw_sectors - set max sectors for a request for this q=
ueue=0A=
>>>   * @q:  the request queue for the device=0A=
>>> diff --git a/include/linux/bio.h b/include/linux/bio.h=0A=
>>> index a0b4cfdf62a4..3959cc1a0652 100644=0A=
>>> --- a/include/linux/bio.h=0A=
>>> +++ b/include/linux/bio.h=0A=
>>> @@ -106,6 +106,8 @@ static inline void *bio_data(struct bio *bio)=0A=
>>>  	return NULL;=0A=
>>>  }=0A=
>>>  =0A=
>>> +extern unsigned int bio_max_bytes(struct bio *bio);=0A=
>>> +=0A=
>>>  /**=0A=
>>>   * bio_full - check if the bio is full=0A=
>>>   * @bio:	bio to check=0A=
>>> @@ -119,7 +121,7 @@ static inline bool bio_full(struct bio *bio, unsign=
ed len)=0A=
>>>  	if (bio->bi_vcnt >=3D bio->bi_max_vecs)=0A=
>>>  		return true;=0A=
>>>  =0A=
>>> -	if (bio->bi_iter.bi_size > UINT_MAX - len)=0A=
>>> +	if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len)=0A=
>>>  		return true;=0A=
>>>  =0A=
>>>  	return false;=0A=
>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
>>> index 1255823b2bc0..861888501fc0 100644=0A=
>>> --- a/include/linux/blkdev.h=0A=
>>> +++ b/include/linux/blkdev.h=0A=
>>> @@ -326,6 +326,8 @@ enum blk_bounce {=0A=
>>>  };=0A=
>>>  =0A=
>>>  struct queue_limits {=0A=
>>> +	unsigned int		max_bio_bytes;=0A=
>>> +=0A=
>>>  	enum blk_bounce		bounce;=0A=
>>>  	unsigned long		seg_boundary_mask;=0A=
>>>  	unsigned long		virt_boundary_mask;=0A=
>>> @@ -1132,6 +1134,7 @@ extern void blk_abort_request(struct request *);=
=0A=
>>>   * Access functions for manipulating queue properties=0A=
>>>   */=0A=
>>>  extern void blk_cleanup_queue(struct request_queue *);=0A=
>>> +extern void blk_queue_max_bio_bytes(struct request_queue *, unsigned i=
nt);=0A=
>>>  void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce l=
imit);=0A=
>>>  extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned =
int);=0A=
>>>  extern void blk_queue_chunk_sectors(struct request_queue *, unsigned i=
nt);=0A=
>>>=0A=
>>=0A=
>>=0A=
>> -- =0A=
>> Damien Le Moal=0A=
>> Western Digital Research=0A=
> =0A=
> Thank you,=0A=
> Changheun Lee=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
