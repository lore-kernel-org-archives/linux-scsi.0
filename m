Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F75DC07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 07:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6097761418
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 07:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFDH0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 03:26:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31222 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhFDH0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 03:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622791472; x=1654327472;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XuDOU5XJlgyRphvQhipV0QwC5VxFBAnjAsSFKlWorSo=;
  b=rAxj1BMBYFphjFJ7bJs9DWwe3z57d+GnTPyVf6yGyqHQi3yJ7CYzCHv5
   HQJZB9sVPd74LsAu7g22MPAIrDPLlet1UWxWOnw8ay22f04gQpMywsQG9
   YJnrI/gDvcZGIStsglgMnFEdO0xxgZjiqNkaOs5G6LzvXfvwqfjwWuHTv
   TKbfMAe6SQUKhw8PbpS/y1sAsG3HAl4xmVrtaMfBzEHTSkT/wgWWFu/Lt
   0CHmIYKUEUKVR9Dgk24vPYxDOP8fB0My4KrdzFvo/9xSikB6GkUjZWrAq
   nv277Gw6+fXNa80Qe/LsPuAsRPnCSK8VzaCYgk+ghx6eeW7OpXoE5sWR2
   g==;
IronPort-SDR: VP95HyZKRPCgBJV3BWFA1UCc8hqERaJET7iDv8EVUSCbPc94b8kNg2pdBz4/Lv9ZFqh2HWB0IA
 4ujFOBNKZceKev5Dv7AVn08MTNib7Zsn61kL2TgAlt55fZb9xJ2Oo7d4A1Rmh8LwTzyR2t5NWY
 EVgzPora5w8f1/N/eeXGF4t5Zc065pxF7PhllfQxhWmEa82jFvD2YnTtUzfCAIAfUaCEvPi9ho
 LXVkfZakTcbMDgawmJEPgub1+ekLvMxKiChRdhuT62gAEaWfHRoOKXSKNLDts8nckEa+JwKAoI
 B9s=
X-IronPort-AV: E=Sophos;i="5.83,247,1616428800"; 
   d="scan'208";a="169993667"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2021 15:24:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUFwY9noa2dRQRCzHAEeNvlSKZytnXeKIHjjXXgkUwuBTcvpsqCCOXq+mtl14PHGhuOTftqfc7XkCG+ICMul/UP9CK7lZWNr1WiRh8xyErfSJlyiheMolvYaiW2Trv7oHcu4Oz1DYPZf4zrvvo2oyFcs3BpCtsl8NXROxEe+dMpp0EJhTPem0/ELKGl99WIt2dz8eBhOcDjqd1rZ9WbkxlSZ3p3gItQ5yC/SNEk/Ovk7mGkqnDJiY+fWv01WFXNXJuI6hEz1IqepUT5wsPPAOaIGCL2+pgcoicjncynA+9mDTV0akxjpyujrOhH7Nn6fa7r9tWTKr4/KL77rRfgSQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Atie6jsV78Y0v2chWIbzzSHDZ2I8L2YNPeq7IAmpoKc=;
 b=Ezg5OwuD+mAN4FIW8v0kCnl7YFmKLOJKh2wrH6CXIwup6cW37s52jdX3j7xgV2Foy7IjMFalA1cP21RaRz+bik6Oe0L088DYZg2+il/vX3AffvLQkouBjFdiHhYyNd8NKNzy1kGPSkHm1MdR7TuA9xghq1QvMvtPKLl8cm6xjhBvlmV1eLBCCaJtwHlEWePfaPHhQ7gT/a5RizJdmSuejOpKlVDSM6VMVYsx7KPBXuCp5En7Rx7LdTATV6v9rpIDr+CLK+kSWVNZc0nh4CY0PKEwDZmBy3ketctNIIX013QR4E692cdgb3J+ZpmR7Gq6Devepx0kPc7BTiEusGAMHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Atie6jsV78Y0v2chWIbzzSHDZ2I8L2YNPeq7IAmpoKc=;
 b=bDwr2MRzK/Q1RPRI9PVd2VfANiSb2++8pVHS2xZISC+rKRQqlILMbLn7Q4mYa7mgJJw8T54OELU55gGh9kwJryoEIFjMykwUirsWjxEV1ilTRrGwG8hIoco5QV/wDUfqbnipe4Lm8rw2XNWMQrfEji/VzYVb2Mj5YvTfbUNih7A=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4410.namprd04.prod.outlook.com (2603:10b6:5:a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 07:24:28 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 07:24:28 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Changheun Lee <nanich.lee@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "alex_y_xu@yahoo.ca" <alex_y_xu@yahoo.ca>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "bgoncalv@redhat.com" <bgoncalv@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "patchwork-bot@kernel.org" <patchwork-bot@kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "yi.zhang@redhat.com" <yi.zhang@redhat.com>
CC:     "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "mj0123.lee@samsung.com" <mj0123.lee@samsung.com>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Thread-Topic: [PATCH v12 1/3] bio: control bio max size
Thread-Index: AQHXWQGQYa2LuZQyw0qIwaPlt0+d8Q==
Date:   Fri, 4 Jun 2021 07:24:28 +0000
Message-ID: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210604050324.28670-1-nanich.lee@samsung.com>
 <CGME20210604052159epcas1p4370bee98aad882ab335dda1565db94fb@epcas1p4.samsung.com>
 <20210604050324.28670-2-nanich.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:f9bc:fd30:41b8:96f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 378ab9c3-3c61-4c2e-0496-08d92729ca09
x-ms-traffictypediagnostic: DM6PR04MB4410:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB4410000166158103A574185BE73B9@DM6PR04MB4410.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XtAKUnz78y4zIqzCLh7UU3OVBKlQgOkzEJpdtJ8xfSiPvoMbEsYXcYxtKfEhJZ7ex8+LCOZlrnv5u2RqG5fpGGa7yzRYfVANtjL8O3ZmLwSfjcRsO/OUUKmhVJsFkEL4uzzkWFqf6qdX3ZUyONa9OOIMOhQjcpFjn2oV7L8CZiYQ7noRHCG78a+9yjorL3ZYgLtmrJDHysz532aZM6pkUaxpVRqnynQVDucjPlwgbHyvwdRIgh+Xke5TPIvyjS5dZgFt5MdcaF0eO7+6PNj1hULx9f+IAItsM3Hv+RxEGj3vffI0YvILEHsSmsQ9NHbPTBtVcmYqhrHFXTr2dpsfNC2MNbG1g2yYMSBwWxjC5FPVbVB8MNLIHnxh4Dalxqwa8Lf/bXfTPJMs9ifvRTrLpN+9CM8Ea22A9WXpvStJbjQZ/aCQ5q/m+dbcPWG2pVelD4OOmKANh4gqpycd10nu3HqVqMzsKPO87AHJnB5I0b3IEMi65ZaTPZAHuV1fY2vjI1kw4MtBFsME26Wd5Xr6t5nPChI6HIIgia4+zymySp6wrp6kogB3CrmX4SPsiroeE8FASN4x55hdPgE7J6KoTcp0B0nTYlNDIV2/dRp7BBB01LNEm5WHlBBAJOk3EbGKIzezRGSf4zTO+U5LYZBM1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(478600001)(2906002)(53546011)(6506007)(8676002)(91956017)(8936002)(186003)(76116006)(921005)(66446008)(66946007)(55016002)(64756008)(71200400001)(9686003)(4326008)(52536014)(66476007)(7416002)(7696005)(66556008)(5660300002)(54906003)(86362001)(316002)(110136005)(83380400001)(33656002)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pf1eTRFZXIBRmmjlhWYwzuBvDUfta0nmlLiBVQ9GpzD1QpRcNRvAn30VVc0O?=
 =?us-ascii?Q?9j9xopGNrmrRBwHWaE4OdBcgNxeux06GE2W9wrEV2gvsJnt+gHS7/QwIvUpq?=
 =?us-ascii?Q?Ju6RtCEprpeIb5QBtgaDbm4fdLOsUZXxCoHAbMwLq1LpnTmbXj/g8fNyahd+?=
 =?us-ascii?Q?3vrKWPsJXfnA64BfOWbPeiuuJyLiXu2dI8rqWLLAabQdCqztcXvuU9CIt+y8?=
 =?us-ascii?Q?DFDisKIQ+Fd6tasH7tr5GIf34EPq64dUyJ+pCrx8m8Wrfrww8/FX76vimQkR?=
 =?us-ascii?Q?qyPfkC9MjOugfR5MvIgEdSLMl1zrRmhcyEazyhxCotNfwJ4w9zpqyKD6JUlK?=
 =?us-ascii?Q?LiTCD3uykUBfDIh4rg7Q5vgyrpGSwi19/W44PekxCO33WK26m6yXti/BPBlU?=
 =?us-ascii?Q?M5Z09iRijbcjNm4OGRviRCKMa9rqxipeHKtZzgUNhc9iGS/wkGZ+8FaUhEiG?=
 =?us-ascii?Q?2Z15DI4sxyrSlN+fcdyBQnwD5/YexYNdZgWPwIXd26tz+tBJfN2SZdf+6Rvh?=
 =?us-ascii?Q?VzRjhhOxfcnwjo8lTrfIEhoM5NCTTKpa/9twC9ljnR7AvcvETATmhYzWf1YQ?=
 =?us-ascii?Q?xBab1CwBXWG0xkBtRHdUIoGe6YXuoMKDIuypETFmMsWViUwUbol7h8ySQxCO?=
 =?us-ascii?Q?mZyTfGXPX5tZ6H5POo08a/2vubLFlPCFLvy0A1wWd7o7W3/go/1Ji17Xo3MZ?=
 =?us-ascii?Q?ORYYCxClaq0PIoPA/nMEnmphfbx3XBUnl5S9ibKec0mjCp8EF3/jOe+7Nwxj?=
 =?us-ascii?Q?zUymbCvviuaPV27IWScrYpNPdghFCBQFi6r6KkjIvd7+c3hE6vVJYOmAmViA?=
 =?us-ascii?Q?801EVMRyc8LFihC6+NmpbG2hw/WM5huucMBUp3GMYAvn3X48bGGAF5zLWR4P?=
 =?us-ascii?Q?Pq/PHzC+w2N3sodKKLVeF4bNVYnug9aVxw4n2EjAWABmOjbG7D7ozLsLKl8J?=
 =?us-ascii?Q?cTvPT8GPBTjnoGBky3SwDnqS+mwKtzM+B32EyfOKTQHH6hGdgpErEznu32tX?=
 =?us-ascii?Q?goqZ8rw7h2UQ+CzxnGFYIrYi1XpMlEEDJyoIzyRv66GSLl64PsrzuuP4oO1k?=
 =?us-ascii?Q?ONk0QCudw9BSbXkwIjg8gKKKMCnLNg/MinDi7obQldlPWPcnqc472Wyb4+Ww?=
 =?us-ascii?Q?dJOQIeCNXphaRLLLYIdvgOGRF7Af2F4FXiY/qfe9p93xO8/47qpyir/vmvuC?=
 =?us-ascii?Q?bqYCCXwceHSPXDqPriT9o8NTwCCiOjrbBamyFXlrLw6SdASn6fp5+yWKfdGR?=
 =?us-ascii?Q?ePhoXnt9goK8UKaC+wGpAmD8GsT7zkup/T3dw5lou8QzviZfTjVtEOCGW4B6?=
 =?us-ascii?Q?IjAEcA9INkyKtllZug/Sxf/LBlrNO6l6GDljdjFeGuR4gPAUZ2F0yZuzh5Tt?=
 =?us-ascii?Q?CusYAtVxD0Wg5cs2TxMCeuF6/dm6ejryrtpF1oUOAN/Ys40zng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378ab9c3-3c61-4c2e-0496-08d92729ca09
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 07:24:28.5371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ywK1pTD5ZvZNToeuZfWU0otEac86VhbfX8c1FE2srkh1ugQIyxN+TO2mUuSq1zremYNyCnLDQkJP0W24m5UzTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4410
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/06/04 14:22, Changheun Lee wrote:=0A=
> bio size can grow up to 4GB after muli-page bvec has been enabled.=0A=
> But sometimes large size of bio would lead to inefficient behaviors.=0A=
> Control of bio max size will be helpful to improve inefficiency.=0A=
> =0A=
> Below is a example for inefficient behaviours.=0A=
> In case of large chunk direct I/O, - 32MB chunk read in user space -=0A=
> all pages for 32MB would be merged to a bio structure if the pages=0A=
> physical addresses are contiguous. It makes some delay to submit=0A=
> until merge complete. bio max size should be limited to a proper size.=0A=
> =0A=
> When 32MB chunk read with direct I/O option is coming from userspace,=0A=
> kernel behavior is below now in do_direct_IO() loop. It's timeline.=0A=
> =0A=
>  | bio merge for 32MB. total 8,192 pages are merged.=0A=
>  | total elapsed time is over 2ms.=0A=
>  |------------------ ... ----------------------->|=0A=
>                                                  | 8,192 pages merged a b=
io.=0A=
>                                                  | at this time, first bi=
o submit is done.=0A=
>                                                  | 1 bio is split to 32 r=
ead request and issue.=0A=
>                                                  |--------------->=0A=
>                                                   |--------------->=0A=
>                                                    |--------------->=0A=
>                                                               ......=0A=
>                                                                    |-----=
---------->=0A=
>                                                                     |----=
----------->|=0A=
>                           total 19ms elapsed to complete 32MB read done f=
rom device. |=0A=
> =0A=
> If bio max size is limited with 1MB, behavior is changed below.=0A=
> =0A=
>  | bio merge for 1MB. 256 pages are merged for each bio.=0A=
>  | total 32 bio will be made.=0A=
>  | total elapsed time is over 2ms. it's same.=0A=
>  | but, first bio submit timing is fast. about 100us.=0A=
>  |--->|--->|--->|---> ... -->|--->|--->|--->|--->|=0A=
>       | 256 pages merged a bio.=0A=
>       | at this time, first bio submit is done.=0A=
>       | and 1 read request is issued for 1 bio.=0A=
>       |--------------->=0A=
>            |--------------->=0A=
>                 |--------------->=0A=
>                                       ......=0A=
>                                                  |--------------->=0A=
>                                                   |--------------->|=0A=
>         total 17ms elapsed to complete 32MB read done from device. |=0A=
> =0A=
> As a result, read request issue timing is faster if bio max size is limit=
ed.=0A=
> Current kernel behavior with multipage bvec, super large bio can be creat=
ed.=0A=
> And it lead to delay first I/O request issue.=0A=
> =0A=
> Signed-off-by: Changheun Lee <nanich.lee@samsung.com>=0A=
> ---=0A=
>  block/bio.c            | 17 ++++++++++++++---=0A=
>  block/blk-settings.c   | 19 +++++++++++++++++++=0A=
>  include/linux/bio.h    |  4 +++-=0A=
>  include/linux/blkdev.h |  3 +++=0A=
>  4 files changed, 39 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/block/bio.c b/block/bio.c=0A=
> index 44205dfb6b60..73b673f1684e 100644=0A=
> --- a/block/bio.c=0A=
> +++ b/block/bio.c=0A=
> @@ -255,6 +255,13 @@ void bio_init(struct bio *bio, struct bio_vec *table=
,=0A=
>  }=0A=
>  EXPORT_SYMBOL(bio_init);=0A=
>  =0A=
> +unsigned int bio_max_bytes(struct bio *bio)=0A=
> +{=0A=
> +	struct block_device *bdev =3D bio->bi_bdev;=0A=
> +=0A=
> +	return bdev ? bdev->bd_disk->queue->limits.max_bio_bytes : UINT_MAX;=0A=
> +}=0A=
=0A=
unsigned int bio_max_bytes(struct bio *bio)=0A=
{=0A=
	struct block_device *bdev =3D bio->bi_bdev;=0A=
=0A=
	if (!bdev)=0A=
		return UINT_MAX;=0A=
	return bdev->bd_disk->queue->limits.max_bio_bytes;=0A=
}=0A=
=0A=
is a lot more readable...=0A=
Also, I remember there was some problems with bd_disk possibly being null. =
Was=0A=
that fixed ?=0A=
=0A=
> +=0A=
>  /**=0A=
>   * bio_reset - reinitialize a bio=0A=
>   * @bio:	bio to reset=0A=
> @@ -866,7 +873,7 @@ bool __bio_try_merge_page(struct bio *bio, struct pag=
e *page,=0A=
>  		struct bio_vec *bv =3D &bio->bi_io_vec[bio->bi_vcnt - 1];=0A=
>  =0A=
>  		if (page_is_mergeable(bv, page, len, off, same_page)) {=0A=
> -			if (bio->bi_iter.bi_size > UINT_MAX - len) {=0A=
> +			if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len) {=0A=
>  				*same_page =3D false;=0A=
>  				return false;=0A=
>  			}=0A=
> @@ -995,6 +1002,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio,=
 struct iov_iter *iter)=0A=
>  {=0A=
>  	unsigned short nr_pages =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
>  	unsigned short entries_left =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
> +	unsigned int bytes_left =3D bio_max_bytes(bio) - bio->bi_iter.bi_size;=
=0A=
>  	struct bio_vec *bv =3D bio->bi_io_vec + bio->bi_vcnt;=0A=
>  	struct page **pages =3D (struct page **)bv;=0A=
>  	bool same_page =3D false;=0A=
> @@ -1010,7 +1018,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio=
, struct iov_iter *iter)=0A=
>  	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);=0A=
>  	pages +=3D entries_left * (PAGE_PTRS_PER_BVEC - 1);=0A=
>  =0A=
> -	size =3D iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);=
=0A=
> +	size =3D iov_iter_get_pages(iter, pages, bytes_left, nr_pages,=0A=
> +				  &offset);=0A=
>  	if (unlikely(size <=3D 0))=0A=
>  		return size ? size : -EFAULT;=0A=
>  =0A=
> @@ -1038,6 +1047,7 @@ static int __bio_iov_append_get_pages(struct bio *b=
io, struct iov_iter *iter)=0A=
>  {=0A=
>  	unsigned short nr_pages =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
>  	unsigned short entries_left =3D bio->bi_max_vecs - bio->bi_vcnt;=0A=
> +	unsigned int bytes_left =3D bio_max_bytes(bio) - bio->bi_iter.bi_size;=
=0A=
>  	struct request_queue *q =3D bio->bi_bdev->bd_disk->queue;=0A=
>  	unsigned int max_append_sectors =3D queue_max_zone_append_sectors(q);=
=0A=
>  	struct bio_vec *bv =3D bio->bi_io_vec + bio->bi_vcnt;=0A=
> @@ -1058,7 +1068,8 @@ static int __bio_iov_append_get_pages(struct bio *b=
io, struct iov_iter *iter)=0A=
>  	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);=0A=
>  	pages +=3D entries_left * (PAGE_PTRS_PER_BVEC - 1);=0A=
>  =0A=
> -	size =3D iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);=
=0A=
> +	size =3D iov_iter_get_pages(iter, pages, bytes_left, nr_pages,=0A=
> +				  &offset);=0A=
>  	if (unlikely(size <=3D 0))=0A=
>  		return size ? size : -EFAULT;=0A=
>  =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 902c40d67120..e270e31519a1 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -32,6 +32,7 @@ EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);=0A=
>   */=0A=
>  void blk_set_default_limits(struct queue_limits *lim)=0A=
>  {=0A=
> +	lim->max_bio_bytes =3D UINT_MAX;=0A=
>  	lim->max_segments =3D BLK_MAX_SEGMENTS;=0A=
>  	lim->max_discard_segments =3D 1;=0A=
>  	lim->max_integrity_segments =3D 0;=0A=
> @@ -100,6 +101,24 @@ void blk_queue_bounce_limit(struct request_queue *q,=
 enum blk_bounce bounce)=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_queue_bounce_limit);=0A=
>  =0A=
> +/**=0A=
> + * blk_queue_max_bio_bytes - set bio max size for queue=0A=
=0A=
blk_queue_max_bio_bytes - set max_bio_bytes queue limit=0A=
=0A=
And then you can drop the not very useful description.=0A=
=0A=
> + * @q: the request queue for the device=0A=
> + * @bytes : bio max bytes to be set=0A=
> + *=0A=
> + * Description:=0A=
> + *    Set proper bio max size to optimize queue operating.=0A=
> + **/=0A=
> +void blk_queue_max_bio_bytes(struct request_queue *q, unsigned int bytes=
)=0A=
> +{=0A=
> +	struct queue_limits *limits =3D &q->limits;=0A=
> +	unsigned int max_bio_bytes =3D round_up(bytes, PAGE_SIZE);=0A=
> +=0A=
> +	limits->max_bio_bytes =3D max_t(unsigned int, max_bio_bytes,=0A=
> +				      BIO_MAX_VECS * PAGE_SIZE);=0A=
> +}=0A=
> +EXPORT_SYMBOL(blk_queue_max_bio_bytes);=0A=
=0A=
Setting of the stacked limits is still missing.=0A=
=0A=
> +=0A=
>  /**=0A=
>   * blk_queue_max_hw_sectors - set max sectors for a request for this que=
ue=0A=
>   * @q:  the request queue for the device=0A=
> diff --git a/include/linux/bio.h b/include/linux/bio.h=0A=
> index a0b4cfdf62a4..3959cc1a0652 100644=0A=
> --- a/include/linux/bio.h=0A=
> +++ b/include/linux/bio.h=0A=
> @@ -106,6 +106,8 @@ static inline void *bio_data(struct bio *bio)=0A=
>  	return NULL;=0A=
>  }=0A=
>  =0A=
> +extern unsigned int bio_max_bytes(struct bio *bio);=0A=
> +=0A=
>  /**=0A=
>   * bio_full - check if the bio is full=0A=
>   * @bio:	bio to check=0A=
> @@ -119,7 +121,7 @@ static inline bool bio_full(struct bio *bio, unsigned=
 len)=0A=
>  	if (bio->bi_vcnt >=3D bio->bi_max_vecs)=0A=
>  		return true;=0A=
>  =0A=
> -	if (bio->bi_iter.bi_size > UINT_MAX - len)=0A=
> +	if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len)=0A=
>  		return true;=0A=
>  =0A=
>  	return false;=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 1255823b2bc0..861888501fc0 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -326,6 +326,8 @@ enum blk_bounce {=0A=
>  };=0A=
>  =0A=
>  struct queue_limits {=0A=
> +	unsigned int		max_bio_bytes;=0A=
> +=0A=
>  	enum blk_bounce		bounce;=0A=
>  	unsigned long		seg_boundary_mask;=0A=
>  	unsigned long		virt_boundary_mask;=0A=
> @@ -1132,6 +1134,7 @@ extern void blk_abort_request(struct request *);=0A=
>   * Access functions for manipulating queue properties=0A=
>   */=0A=
>  extern void blk_cleanup_queue(struct request_queue *);=0A=
> +extern void blk_queue_max_bio_bytes(struct request_queue *, unsigned int=
);=0A=
>  void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce lim=
it);=0A=
>  extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned in=
t);=0A=
>  extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int=
);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
