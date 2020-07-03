Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C947AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 08:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0DEB207FF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 08:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qjupdTKU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="qgdj+eeg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgGCIWu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 04:22:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64424 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGCIWt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 04:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593764572; x=1625300572;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=2XV5a+eW/p7nol3EkIDC5MEqFzTg53/I9V5EQ+dGEMk=;
  b=qjupdTKUuPO69zkN0a1Jl53ROOh2LhLmvfxfwBKgrx9rxO+RPEmlkOzK
   JFwoIY6s/AIE6KdSUUaZKVRBxwgs/1thwj5gSowZ6CmDYY3cInJ3THHbK
   jqACMBzki2AgmQEi4Mw7RmuxpGI5nRh6Y72E4pUT4uUjM3g5V9a3Jfaql
   efYikrm8GppZe5sd3+HWINmcf6I8EJXBpeSTaIaa8lOJCFhPvGCwS1zd+
   HyxTXcctLaRCdGYr5dZH+pRItf0el8wgUSv+g2SYbeJmicp6Xb9aS1JIx
   aSoBFLPG+j0pRHYHJZ7cEsuGkfmHDJUqj0YTSBSLWkQajbZ2319FbZ+EK
   w==;
IronPort-SDR: oea/Uvs+HoMvWwgQPfpeGsAVpM3Ck2qVgPVq2lOpJsTTVGvfEhDZ45LnDnG4+W2rLivqiuozXq
 YiikaPuVrZKXdq7aClnDG8tqwv9OGW3/bPM8mrO6LU/9Kki0YH5VJ9pu8ci9OgqcpjxLPjQlS/
 VDCDmrcU/xjYRDqWZFEG7gHp+imHtLDS+NS3StCwMD2neV6wyk1/PrXPMPNGFZQsA9589inieP
 PGV9km1xWRPGHqm0sLKCmqmq+yY6Hl3igCFKSUHU3b/kEIxnHguuV6TBYFPCHt9p8YAml7lgVK
 BsE=
X-IronPort-AV: E=Sophos;i="5.75,307,1589212800"; 
   d="scan'208";a="244580756"
Received: from mail-bl2nam02lp2055.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.55])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 16:22:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTJv+XRvn3MJGJ2Uj9m8NcvCyiKAkI8rkS/dB+7h9q3HctjcYbIKBvfJpWoXX8aoTVRsKtPiTkkFnPsIogTRtyXSyD7vELDQrvymJ4GmF35V+ZwMU6doEei9Lv7G1U67ritjwMfK/gdLD4OlF57sZ4MSHSeDU3AO3eejGX9uDh9D+c46k7Hto1Vzw6UVgq8/D8THfNnFT/WOiR5tpP1vLA4jTaCN1/QZQ6bG+Bd2TbmWXZUQi+jgI0i+srF4b6YNTbwbFTJ3Rs9uEHpc9Q4GvufanNJsnjut55ANZ2qDLLBg52jTiIjJxl87P4oOusjmSNlOMfO4GUwoQVndn+DPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BatYeEuY5YEYTq/Ei91dryqZCfEkeHO8IhPyXDwK4Yc=;
 b=H5BNJ24JDuY1YkH840oM223RPU1/BcAdCLJtrffCsXa0yMxQN619byMyLnjeJLKe09FYnWqpjXiLl8aTKAd/HbcLRQ2oHFzZOVmtwVamzXyIGih8E8r68EDFV9NqI4bLpxv19ifFuLOE/HgD78FVGkaXolhwdNohlecTj5m2hKO4QrziPFSB/1gJ7y5fSf4wssc92AEoPiKnM6QK/SETPgayJKBH9EjGGdgq4lX2+IVTATIUuH5z6dqw4YsRFBIIZ+XduWd7rsOQolkHzeYovLbMYtQ5evITQn8CrZNzYoW0KNM8mVpEsAoH3dkyy5/AclQFgwWSq3nj5wN2i9eYzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BatYeEuY5YEYTq/Ei91dryqZCfEkeHO8IhPyXDwK4Yc=;
 b=qgdj+eegFhhliLbrluJq7DuHbFObZ/3rbw2QMUe8co/ml2neNb6AHmiuqU2oQQnQtyWw1b/mLco7iA/2HXXByMLYSo7zvuhfrlDMwkGE8znpt+gAyODnwHA2JdpJnkEF5uUvDIOqUwn0i318s2f5Dyqwu50rsmM4BbbXDLQxitQ=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4927.namprd04.prod.outlook.com
 (2603:10b6:805:93::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Fri, 3 Jul
 2020 08:22:45 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.028; Fri, 3 Jul 2020
 08:22:45 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWUJ1laLSAJw11LUObxsrvIlcW1g==
Date:   Fri, 3 Jul 2020 08:22:45 +0000
Message-ID: <SN4PR0401MB359886C77E3711DAF16D9B9F9B6A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
 <20200702181922.24190-2-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f135cbe2-8137-425e-597c-08d81f2a43ab
x-ms-traffictypediagnostic: SN6PR04MB4927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4927D643EFDC0B70E16E0E869B6A0@SN6PR04MB4927.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NIvvFWYWN3MFYG9XhKUAro+lcO0PlWxj2MPUurInbQn+z8s13gMA1S0kH/dys7J5GCADFwsQ+kbZdY5KC5OvHskX11heWi3Tgd/CotMhkmz/zyQlEfW0XpsNAIf2sn5UCRmIUt1xu8B72KBzxt4QAuk2kwti6Nx/lXu8n7aukV31C+BlyNXKf/qf1iS+BTZlBhwwNcfoWuWS+eqRBPa1KlZNXm6vA0DUSJ0HB3kqHRhVZWngoeCN1Y+ym0Sfn1j87cjYgZ5nrOR9oUBZWiMN9cneyCmXB6DsF8c51u4Y6xNi6JhsDQNOxs47yQZPK/n0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(110136005)(53546011)(9686003)(316002)(55016002)(33656002)(7416002)(26005)(91956017)(66476007)(66946007)(76116006)(64756008)(66446008)(66556008)(4744005)(52536014)(86362001)(83380400001)(8676002)(8936002)(5660300002)(2906002)(186003)(6506007)(54906003)(71200400001)(4326008)(7696005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: r1cyVkEtaGvIXO3lSGZyHXbLHSuQfHySyart1n9XO7gsSNPQJAp3vHccX0wG1UolO9FG+hThdyBybo3rO/ZTKFDt6ZzN9ONBMdbbvEo671Lt62s6aU8jgugHUVzPNKtmQ9bti5HdxlMWXWH8dSRRSLOWcVQ0suX5wlIz1kUNX7o2fBMbwfjt9zreuGOCALF3iGyMWoq15XWGHk9XPlRLE1i1RShdKdp83bBKXloeJqDCzTDky/4B1wS3Rlayuoqa+SHvxaV385RTv0CL7IWVIZ3br35JUGkldCkHhiLc1Hsu7I00R/3Dhest2a274FGZsFzo0gRoQ+IQzQpaUQWpoCN/u01uRu9NMzko7hkNg8VHTL952ruTcDkbcDhzgha6TQ2PIREOI3q2RrJUjoLbdwEapDV9s0IsueeUCYSqiAWoqKYUkrjfiROr8QvAScpy526tWjEt5kJPqpTcVt+RUwimkvpA3fS3D71iNzsJXyTslbCHzDtcMoClFGEb1Kos
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f135cbe2-8137-425e-597c-08d81f2a43ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 08:22:45.5798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8m2zYpEuDTbMie2RoNuv9CSgEWWuj0Y5bWAPqKaNwn5N+5Q6zWql8FoNA33lG1Y0LDUmVLOTYQs7HtfaXHlZK3H5kn+j487IBS68LxhFOsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4927
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/07/2020 20:20, Niklas Cassel wrote:=0A=
> Documentation/block/queue-sysfs.rst |  7 +++++++=0A=
>  block/blk-sysfs.c                   | 15 +++++++++++++++=0A=
>  drivers/nvme/host/zns.c             |  1 +=0A=
>  drivers/scsi/sd_zbc.c               |  4 ++++=0A=
>  include/linux/blkdev.h              | 16 ++++++++++++++++=0A=
>  5 files changed, 43 insertions(+)=0A=
=0A=
Sorry I haven't noticed before, but you forgot null_blk.=0A=
