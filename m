Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E89C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3116A2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oPZwb2Yj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="WNrt4J48"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390722AbgF2VQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:16:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57273 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbgF2SzB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:55:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593456903; x=1624992903;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yu4huEp55scw/8uKXHlX4eox41kySvoBMiL3C8Je7Pg=;
  b=oPZwb2Yja9mCWmmPHUJmUKIyvBOovEmB+gFQOf3xxQRD46s5D/PHsfha
   /e1qQq2Z3tvphkP3Y38nyF6aKksLI7LNTgfyKsyBUrPRkc/3/Cy85Qv5K
   eG6svGLroV62XNM0pWr0txC3S7VlTEZjLKqe/T5EIvdRLxoPKZbknPO05
   BoQQQnTK6v1VcfXanvuye351xMTrEUXEjplt1uCLJ25VZC1SnmJunZZli
   3ErwtsBHBkoV4mCk5DKn4u4OXpYQFm9QYv/LLVJZtcfzIf9nFpWLjYocR
   gMqauY/bBihRJ4XV+1fDC5igWch5+2XsmijRwQJl78SbfuI0Vr5D2o3tT
   A==;
IronPort-SDR: TGSsAO0QifWNbSlhVttjdXOmDKeFeN8Y0yRg+FbTMrfEJJz6xO0nEvQNk1Cl9aJcpAPPqahxxH
 9OKqu3U9u04T8FFl+HpCzDywCoBCueaQXlqd48LA7tRTlAOKojlt8zJBLjezezURko2VUCX3+p
 EzPNidm1vrhIzH9V+b1CAdIOzA5ME91hlitbCFb2SxhGVWnBvnL5z0K8hrzJogoLB8/WFEyWYU
 nffpmHmgL/xqAU+t+o+YRJtHFTLeu112YGk0SFStjhtstSBFLfyRxL/LckxIPJ4oyxNgZzAgNc
 Na4=
X-IronPort-AV: E=Sophos;i="5.75,294,1589212800"; 
   d="scan'208";a="244187755"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jun 2020 17:07:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaaAD9NLdDbdwiH9JNAohbs+xOd+NCEqies0bkqZtOS/oC5HGbdxd+ZB8Jj8x4U7z3wldHQzRBUvoR4GjVvjUNkXJMd1YkGyzY//z6yHMbsDVDFnK7UBq12Ujind5XX318kCB7+QTICzpWppbo8Z/9m/Y8rChNEWwzxd4kbziQ5eitETOFOtyRopSyGa3Crc0mT61CqR98NU8rls1k6vV9n48Ok9KVnSK27kdm70zMnwnxCVq23lEAP+I9qRq/dwLbREo7LaNWQ0jHQ1ipvhJ5LhpkGw3b/WhKUQHDWgvLq3x1nznDIEQw67JbbLXGBkXx4o+6MpDT+B/hq09aQ68g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VUAnK9OH9BhI/nrF3tJ6RRdDBblXYPZR1ANsb3YIkk=;
 b=P68amSpoXJvqof4HNwMnT55w/rP4jbpthU9fgOAkxTFlGD9Kv84oDOx8OSapbDNhi9Yw3N1h1ZCwxDSwh67bZCkT2CDU2FlmQjm6YOLcpSq1cMwNh/hu9R4wf51SPo93OwAkZ+mW3DYgEB0Bl53g9NmT3Cx3WIVlNdTgDnBxESdjdLYE+z3KQVutNsUaK7cE3Pqhzml0gzXMNtwPDioHzde2frwUZo1nvRJVzdM56rzrh5YnbJe35q1iG7WAyiSL769R3bSAjo54b8r1r86D0BWTWXjsbJwvDCaV+5+846PFlJFwfdfdpltCg49gvwnqPJgopbfm4vpocGcd0usfxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VUAnK9OH9BhI/nrF3tJ6RRdDBblXYPZR1ANsb3YIkk=;
 b=WNrt4J481jcF4qj6OiHgMKUXvoqIFcUBCvb1/T+Y7+sPjoyUzv+tQLefZe/5cKvpJHkVWcOvAWlBNMddWqfQw1Df5353B7N7r+CH4tIaQvkP5FXlTjy2YEa0b9Sb4lP2IuBCW218WrAXX4/OhoYNa1ogAWKemwwWUBKyLcCy7y8=
Received: from MN2PR04MB6223.namprd04.prod.outlook.com (2603:10b6:208:db::14)
 by MN2PR04MB6047.namprd04.prod.outlook.com (2603:10b6:208:dc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Mon, 29 Jun
 2020 09:07:24 +0000
Received: from MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e]) by MN2PR04MB6223.namprd04.prod.outlook.com
 ([fe80::899f:1d14:ad80:400e%4]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 09:07:24 +0000
From:   Matias Bjorling <Matias.Bjorling@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: RE: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Thread-Topic: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
Thread-Index: AQHWTaAe7EphdXOt6kSWMdnkQNI/YajvTTIAgAAAmzA=
Date:   Mon, 29 Jun 2020 09:07:24 +0000
Message-ID: <MN2PR04MB6223CBCEA07D63E53B3AD244F16E0@MN2PR04MB6223.namprd04.prod.outlook.com>
References: <20200628230102.26990-1-matias.bjorling@wdc.com>
 <20200628230102.26990-2-matias.bjorling@wdc.com>
 <CY4PR04MB375197387D94CE4E60E836F4E76E0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200629090356.GA521026@localhost.localdomain>
In-Reply-To: <20200629090356.GA521026@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [185.50.194.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc8c23c9-018b-4b60-b6bd-08d81c0bd68a
x-ms-traffictypediagnostic: MN2PR04MB6047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6047EA7A03EAFCB0C704883AF16E0@MN2PR04MB6047.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KkPv1apo0czYDr+mVzLmL59m/23di+HkxyivFDwLu2HmUUuN6QT2w87KLh2XU0i3FD0MGNnxyymySd5a/oYHSbqVtjj2qSyCYb5Rk/Amg9OBF/yLQ24HwKRkr4qjV0Hkp022eOGrddzUgB/0rxOtkXrusdR9t/sBwPrq3YMVI7UsZYDXEOny9nRh/ntdON77e8hrkug8Xr9opZAauY3H5AU3xMcSg1JOuNBv0GS9HWk2MKfD6nmKjYGNE86orJzMZFjqVmjKgSLEUrbd4yaZ8NNO5cd026W3M+idA7aaeo3TTuC1E4opln3ED6yWFnIF5kp62mxhBP9TCHARG5yoUL43bWpwD+Ai52qtjm4Zrz566yM65kjFMiHB0d7JsdoT7H5zi4x2c0V6hj6ECrZi7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6223.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(186003)(54906003)(110136005)(26005)(66946007)(4326008)(66476007)(86362001)(316002)(66446008)(64756008)(66556008)(6636002)(33656002)(8936002)(83380400001)(71200400001)(76116006)(6506007)(53546011)(478600001)(966005)(55016002)(2906002)(5660300002)(52536014)(7696005)(66574015)(8676002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aEJr4chKw98DGlaYsxZpe99z9y7iGXiJO6YdVHpwxg+KitXsow5k5RPezkLzTlq+4ITJOiYuqrvjW45/FSKeyP17Pwr+6wZvjj9yFf7Y1T7lD8MUG8BnXn3NjJ4TdDOHFWBADLrX+09kqhYUNgzobYlSBVCSsmBi2x7rkEjPKlr/IbQEg4j9jo8Q11FZIJIJ4bLhwMC3+WXboqC2E+CoMSOl7agP0QmXkURXG2mgt13oHeQBNY80Cag46ii/WYRZel0mE+2DdoiWkd35QisX7VlAOG9KuK7VRXDYIZ7tvzuPjq6dkoc+x74gNUN49LhLcdiPel9ZLomPULgFhtqCN20GV2xHUpyQmvN71Gocv9YH4Gy6muiGUoly5tm2QZzKZN9XgUCJ/rWuY47Cvd+ZjsNkZEbbwVym3/JEtmskm7/iRgk9FSnNtbZWm08FFJ631Ivq1ncurfB6Tz5IvsAvPngCQPGyJMZvzV4lj7lFnpHW8LBcjaVH8lz4FSLo6IIM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6223.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8c23c9-018b-4b60-b6bd-08d81c0bd68a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 09:07:24.1178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O3maUdE2f9GKlEBzkUuLZWehuVX8yb6T3MvC24yJRSb0dm4rlv+ghhvhsW7njbmFW0zsCaIyPebUfNGyebbgAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6047
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Niklas Cassel <Niklas.Cassel@wdc.com>
> Sent: Monday, 29 June 2020 11.04
> To: Damien Le Moal <Damien.LeMoal@wdc.com>
> Cc: Matias Bjorling <Matias.Bjorling@wdc.com>; axboe@kernel.dk;
> kbusch@kernel.org; hch@lst.de; sagi@grimberg.me;
> martin.petersen@oracle.com; Hans Holmberg <Hans.Holmberg@wdc.com>;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> block@vger.kernel.org; linux-nvme@lists.infradead.org
> Subject: Re: [PATCH 1/2] block: add zone_desc_ext_bytes to sysfs
>=20
> On Mon, Jun 29, 2020 at 12:52:46AM +0000, Damien Le Moal wrote:
> > On 2020/06/29 8:01, Matias Bjorling wrote:
> > > The NVMe Zoned Namespace Command Set adds support for associating
> > > data to a zone through the Zone Descriptor Extension feature.
> > >
> > > The Zone Descriptor Extension size is fixed to a multiple of 64
> > > bytes. A value of zero communicates the feature is not available.
> > > A value larger than zero communites the feature is available, and
> > > the specified Zone Descriptor Extension size in bytes.
> > >
> > > The Zone Descriptor Extension feature is only available in the NVMe
> > > Zoned Namespaces Command Set. Devices that supports ZAC/ZBC
> > > therefore reports this value as zero, where as the NVMe device
> > > driver reports the Zone Descriptor Extension size from the specific
> > > device.
> > >
> > > Signed-off-by: Matias Bj=F8rling <matias.bjorling@wdc.com>
> > > ---
> > >  Documentation/block/queue-sysfs.rst |  6 ++++++
> > >  block/blk-sysfs.c                   | 15 ++++++++++++++-
> > >  drivers/nvme/host/zns.c             |  1 +
> > >  drivers/scsi/sd_zbc.c               |  1 +
> > >  include/linux/blkdev.h              | 22 ++++++++++++++++++++++
> > >  5 files changed, 44 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/block/queue-sysfs.rst
> > > b/Documentation/block/queue-sysfs.rst
> > > index f261a5c84170..c4fa195c87b4 100644
>=20
> (snip)
>=20
> > >  static struct queue_sysfs_entry queue_nomerges_entry =3D {
> > >  	.attr =3D {.name =3D "nomerges", .mode =3D 0644 },
> > >  	.show =3D queue_nomerges_show,
> > > @@ -787,6 +798,7 @@ static struct attribute *queue_attrs[] =3D {
> > >  	&queue_nr_zones_entry.attr,
> > >  	&queue_max_open_zones_entry.attr,
> > >  	&queue_max_active_zones_entry.attr,
> >
> > Which tree is this patch based on ? Not I have seen any patch
> > introducing max active zones.
>=20
> The cover letter forgot to mention this patch series' dependencies.
> I assume that it is based on the following patch series:
> https://lore.kernel.org/linux-block/20200622162530.1287650-1-
> kbusch@kernel.org/
> https://lore.kernel.org/linux-block/20200616102546.491961-1-
> niklas.cassel@wdc.com/
>=20

Very true. Thanks, Niklas.

I'll rebase this work when the above patchsets have been picked up.

>=20
> Kind regards,
> Niklas
