Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75683C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 21:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ADEB619CB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 21:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhCWVZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 17:25:33 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:36328 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhCWVZM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 17:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616534712; x=1648070712;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=pTf+blGRkZXMGsXBqn5yXtwGUYCiuKA0yq2ykN2jKsQ=;
  b=lTRo92wpxg4FUWS4cm8z/oun9QGT8Sy6ByQFHzbOfHW4am1eA3uLBAVI
   dZCgHScC0ngUt1ix/FYjLIn/wFGTmBSQCo0OC19BFPCyLj8fVr2lS/l2G
   FoUpqRk0VrjjihAXgi+JkegbzxYKqbGF9D1PrUXu/XIBJFEGe2w407wSc
   l2o1r3xfQQoNO+zom4KJRH/BRzi1YVemZLbc+6490T2jGhePM7254ssJk
   2szQ1I4wZUDt5b2AlM0CjhZIZuY6yOTqn62P0gFg7hxZHxu8ZGIC7dLwD
   YJUT/LuX38fgIzdcLQhrHu6rfPZLAtpvVM+3Rils14PGp33zEAzKk27wV
   Q==;
IronPort-SDR: tVkb7ZsHMkiQUMzlSRCjBD2clAnPDlFJ84NuCCv6yg4qlqT+C8wm+8rIMkz5ooc54b+pTpNPvW
 KJvwOGISnyQOZYMwzxWDHOVYsZO82rIbXGwC+NcMTvtwwwD7qRSm0xi1SIPo7ytnaLLeY60Pmv
 m2dEqi4euz3w9ZbLtkfAUh527JvJnoiKlJw49dcPBMbkNOJbbFXGrEMxdB5CUM7m6a5aKWD4ZS
 8KXkOKqRgDNhHaZSe2tcMDatO0GFygmjId1D/RrkrmlyyKZpx1UYMNB0cpaz4cZEDTa4LjD6ow
 CbY=
X-IronPort-AV: E=Sophos;i="5.81,272,1610380800"; 
   d="scan'208";a="167313705"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 24 Mar 2021 05:25:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQ/Y3xeXo0Qm+HN5WE2aRLCRlh7lA3dRQyfcu3Givjg2ZvEKpGGYUAEFD1kCCViCca62GMMqAaVPswqwldLIzZWlfCSemkKS1pnojRI34VqyOZcW7DypccXdaqV0CeYnZ/hoskRUVOQLSoQlEveCq0eH0XORLU9G4yoNdTZSKvmkinIuT0vut4q690gSeXr09FxxwR/sm/uklLsi8JrsZwG1P52HvaChKnNo2BNiDDTaxymn8zutPxBubayxBc2a3qr5kjuts/XddK28FSjm/RphUzvNzPjXlOmZ9jE01ZCvo80flqZS0kaeJP5ovurJk+htKEdHgOEtMaov8xvvLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTf+blGRkZXMGsXBqn5yXtwGUYCiuKA0yq2ykN2jKsQ=;
 b=JAFsQbeU8EtezqLKlPxPuEIbF96ppSqsbKMbTGPygAgCYWen58co4pLaXrhKX6EBqRKBS3fKqHQKQd4NK6esZh2OtzuijOxCIv4WHI3M5yN630CTj6o178dpu86Z4SHTyBXaXzeEgXAIHIZJyBWBCH0J5enaCzcwmeLFKdPIk7wyuOG7RDDtNzCRgySWeQmQCxyig9+GQiDmqVSl9PpRiHXqSEZ1rounawk/cLYkf/yU14iCAOO8Us91qT9LqKmfDT68Tvznm3tJDnUwvyNokJf35/Uqx6E/Ggo3UbYrcQ5MCe8tdyaxTfjjQRgRcP9m2OZ/kKFMrfGRTmzvdg5kng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pTf+blGRkZXMGsXBqn5yXtwGUYCiuKA0yq2ykN2jKsQ=;
 b=zlVUPOygdFu5FmT2tWUreosxeBZvtGTpZTjcekXrHbkI7um+aCvq6+G1odamRLe+ewJ9O+PrvvBCVMhw8BKOt6J+EmhTuYDUhbNJW8vcBPDMg/uOeAdD6/0mkb9MjJoJt5TkczGmSbzUmJZCLoDinto1Br12p7U/ImJYh5jyYhk=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5830.namprd04.prod.outlook.com (2603:10b6:a03:106::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 21:25:09 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 21:25:09 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Martin Wilck <mwilck@suse.com>,
        "hch@infradead.org" <hch@infradead.org>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        David Disseldorp <ddiss@suse.com>,
        =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Subject: Re: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
Thread-Topic: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
Thread-Index: AQHXIADQ9AUBq2tQrUa5SFdtPvna+Q==
Date:   Tue, 23 Mar 2021 21:25:09 +0000
Message-ID: <BYAPR04MB496545980C9EDFB07AFE2A4186649@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210323162203.30942-1-mwilck@suse.com>
 <BYAPR04MB4965DC898570F11C1B4CF06D86649@BYAPR04MB4965.namprd04.prod.outlook.com>
 <225fe1d4a8d579308583fdad4f23221596355931.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24482799-ca7e-4584-a5b3-08d8ee4222de
x-ms-traffictypediagnostic: BYAPR04MB5830:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <BYAPR04MB58302D75D654E6F2AD9E95C186649@BYAPR04MB5830.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:374;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MdnU0FZquL8z1mIGq0JGJ9xiTmBrjj14ntdGbS4fTM6BF1MaDOVQCVpF85WlWVRoym18vbKLQpBPkWTmxeAf96fVNBjDRSFasb7fAvqHyE6NvI2iyj1k0Nvu9BEsplFMdpjJR3/GHBBqtW5BTul/AejkLmKFw4BvFcJlcsSsvoM89UBljkNnqbvPQLV4Ctv1TMtP/kyouhCRwvY0uzGHAaLLQMHKQwYQUqzlHGUys+DRLSUWHFYtZDPmaQMk1oLZ1yEETWJ1xWFm7EayS1C/87fBbjObvmbQajdle+acs7crVnNAP9yC7jdSUcB54iV2zz1V20tKH3AVELlkhHreivldH3B82xbOLbAvInD+4QQrTxU7loUalZhe7jXH9Ob8kLPE73v237WS7SSe8jI8S7tn2gh/884Fg8U8Hbpi4nEGoofsWRD52Tsb4uzFVFLzZ0G+xWnr2wr3o+HWRhynEFfmcIMazPOZPicPMr4tTwWOGeVm2+98HSwwY6KvhovePg3JszUMNEPSHZoRtRtEAh52Seauuqo/gmiF/bbvss5EQPjcWBD3Y6yhIDWR4ySL217I4CFUxi7fjXRc7R3BhIHYr6mozM2bepm6rt08+VZlClbfsbcqewsLhy97N4jtTga7mRCX5KxDacG2Mw0GbBQesUZMpjUXEWVoBsDbLpU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(9686003)(54906003)(71200400001)(55016002)(83380400001)(76116006)(478600001)(38100700001)(110136005)(7696005)(4744005)(33656002)(6506007)(53546011)(52536014)(26005)(66556008)(5660300002)(8936002)(86362001)(8676002)(4326008)(316002)(2906002)(186003)(66946007)(64756008)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?f2U4mHdLtuFUaFtA7FTLjC3PS/ecvXLyuhf4uHtdepJfZjx8prcfeCDHiz?=
 =?iso-8859-1?Q?7c58cmF5ZPrw6c+X2LD/V7pOyAR1YtRpZkmTI2F273aBxohW7cbsBPtdP5?=
 =?iso-8859-1?Q?p4T6GKwIJ97OnOvYbTLsjM0p/n3w/z8u2k0usUm18zPfjXGN6q7WgdYiLL?=
 =?iso-8859-1?Q?sNnc9yC9k3r2+DVVVXTVSDN08LLCdzosHmccjpoxLT1NMIgTyBzKt5AH7h?=
 =?iso-8859-1?Q?5Wyzg6FqKnGmWI4KBLkrLScdwj+UkzU+M+NJ6aKvvxEh1SsWzGF5WjJMMd?=
 =?iso-8859-1?Q?f8pwM9ZhOYBu0t8BhazIDQ8p/2ifX8xJbQ4yR6Vx8PqBoL0cuzDY0bG7v3?=
 =?iso-8859-1?Q?j5goVBMlJLfBrLihaB8gmmvZiQmTF3YSPHR5GX8tNr/nwRLopxHJaoaqgO?=
 =?iso-8859-1?Q?GFpDwpUccbgA5t3VMtw7933IurlQc4mPYp1GKOwLIft7ctMBPIoQJj4pbh?=
 =?iso-8859-1?Q?kjXWc8Q/DY2bqoSDAJa2yL5ZN50XUI+RFKDJjjY6I3Bth4SnKxdRSgh8mn?=
 =?iso-8859-1?Q?hPvefLN5VC+3caiYHmHl1Y8nexcFFI2z3RIbWEDvSmDeEQ57aV3wqhSkt6?=
 =?iso-8859-1?Q?xTkjAjXSiVw8mnPBwMYkQWLXxFOpl0CeuOPx8w9sdN8D3rzyE3/u3ixNb9?=
 =?iso-8859-1?Q?/DnJnE6R2h/52zwNW+Xlf0AcmbeJY2PVk3mVkpC+xARE+o7y6Hy4RsY3LD?=
 =?iso-8859-1?Q?GmrQ84q4EdX2NhmLRWRS1zF2zJFsGv9TYKhDmTQzfX9dAzPGiKMCzz5g10?=
 =?iso-8859-1?Q?Q/JRJ5Jx2lwVFQ8JMOVS7IiZF7I7zAM7Rr+JnZz8cg5uv0c/wekBM1tJq7?=
 =?iso-8859-1?Q?XCmDKlYm4h5GKtK3VW6XeWruVD30DzHmz68s26BwEhDw98iUjXDE/6506W?=
 =?iso-8859-1?Q?0SoqfSkksFcllzj1PC0legGEo8i2oxenTv+BSNsj3tCbUmBrwoP272Ttvj?=
 =?iso-8859-1?Q?TRHTA+6FxkD9oLMeJI0grtF7LEjH/rZK7aaPGwxHr99Cu1nERss1fDN+YT?=
 =?iso-8859-1?Q?4jx/tmC3Z9ZcoKhucCV3Y+1F4/Y7gCsVWvTaHLiD0pb10+XdG36srIjhBJ?=
 =?iso-8859-1?Q?4mwC8HhGtN2Md+AAiT59eWWV0L598mvS68jY4qzbfks6X2KHBClayMoN3E?=
 =?iso-8859-1?Q?EZtPQJyaQ8z4WRmBzTIQJMeTdoQBvHBHaQmxeHwA7XupNH3eZDkeSzgOE7?=
 =?iso-8859-1?Q?vwX3Uwsj496pr1RLwTmNX5BHHQPHQihMuwozSrfrMhtkVC6IN1pZBEpE+6?=
 =?iso-8859-1?Q?5oeHs2pvQeU5eDjLiq19TLf/VvkBoF9OtTQIZGeQbWcDpxhLFlcqPNopfX?=
 =?iso-8859-1?Q?6a/s0xFHloZoCCALpOothNjdDUZumJ9omyshQT6fCzmfhKt8g9luhSe0AI?=
 =?iso-8859-1?Q?s/1GPmw+dl?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24482799-ca7e-4584-a5b3-08d8ee4222de
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 21:25:09.1305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TUtX3c+kLUN2M1hr6utB78kfoHvgSEB8CzhIUMjsKjqC/IPpqqX4OWkTXcLSCQecvhq/+CSoQeH151HsOj5S7rMFYt7pdMPEprTKMbDdqnU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5830
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/21 14:21, Martin Wilck wrote:=0A=
>> I think BIO_MAX_PAGES is replaced by BIO_MAX_VECS with=0A=
>> commit a8affc03a9b3 ("block: rename BIO_MAX_PAGES to BIO_MAX_VECS").=0A=
> Right. I made my patch against mkp/queue, which doesn't include this=0A=
> commit yet. As this is just in the description, I don't think it=0A=
> matters much, does it?=0A=
>=0A=
> Martin=0A=
>=0A=
>=0A=
>=0A=
=0A=
I don't think it does, I'll let you decide that.=0A=
=0A=
=0A=
