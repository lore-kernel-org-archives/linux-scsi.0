Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D880CC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E1D64DDB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhA1LdL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:33:11 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55605 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhA1LdH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 06:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611833586; x=1643369586;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=FrJMMbA/GuBbdvKezjUD+Xm/PipOqqGo7L/jnygkYUYRj85pZvOX4CO0
   MwA+fg0L0MZgrPV+M3YRU2xRhe4FDPXRofLbQnNaeEjhBtZ1/KTvAeVPG
   skphxT9y47gj2oL22+fzzFuXWecoP8ltsjhPyJkxBElITDKgoM4mf88+p
   0EKZctJ8aRZRpWFrOeoj9cPXudBbMcAPzgzn2uytPASD1owRcYje2hQ7Y
   2KfVNe6CUJigrYC3B8LrBfdwEPkiJEfgWoSdEo8nJ2n/fyhgFNczc3Inh
   E9AnNCniYU4yeGY8jQQ/Kx7QNpnAmVG2nlD4peQ8QbL+J7WOfEHZTPNCH
   Q==;
IronPort-SDR: Wub1INvGG1q/H6n4cAehhzTw1hvfxIr6NzH1STmR0n9Ec3yT1O1bfzHA/6qQc1wkRLDQwnSrWd
 kfILL0vss0gzrgDMHIVa1jH+xeiy37ruh7PZcJu0Rz9GGh9jNb2iZcWzfpGC24GgKXX8bLcGHs
 WE8goC6O/xFnl9XSLfZfXYO9POYXY6CeRx2dHVi6sngIXU7/Gghc6Zkm1H87zHRzyBPPCYRnVK
 fuWXFtgMFkmrMBwmWJCdzjRzQREfuGTSWCsxGyj5hrllaG0JMBAw1sWPu3C7tecdOU04plIhCL
 LQM=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="158536130"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 19:32:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgveYApL0CUHyyAxh/6NwVkVqlQA1UKv4Na/YiAIH6OcYHD4c6HqaYuXFT04FlGDIuu1m+bHScl/UNnNyydfAaUgmtT6fdJZO6gvcMO8KssOjdzJAlOhJc4ujHuni2jeMuriQnpKV7tVXyKVF/DmR+L0HTWeML/QfsE+jY4ZbVtgfFpFXy4nYOVAwxIfN9Oi1x64bsQcK2at6hctSbNbqEqBsyTVaXqj3M7iKMlpSKgk2YKx5cST1q/stG7jbGtqZsL9ylzCyAjHzcL6Vl4KV5wu5mk1/7lzdhVpuMVTSQJPrNyRE4QXs3Q/KT+MYQRgYbtvpi+IU40eqwe0ZSNUwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=izWcN4aPxB8olMYkgdHNU8JjgqBuYZF5ILtYED7qHL0hTVfBYwCREK5CKhHYOi33jHGykhqEvQhhofcJgnUoFMsSmzM/uy7ic94Yonkz3w6PQV7vi1S03WJ1l3ECMSD//y+4ldfL/izDSGezrGGysVYHT2NNQMwKumDeB60vubkTpYQnu/IyQfEI1BJlPpRhy9/KW5wFgBc3HhQl8B+PqBdrqA7RxuXfrOBvZA8vqqxIc6QK8HtwiVDJhp8/Ypo+LiOe8vze06zJejWjTAX2CJLy7D9dEL9+bUKy29xdIxMw1ImK78yV26oufvWSFVxwQ8xJ9db1UqXH0ENhIQdy7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=DCMZ8stRIR3U8ujV7RY2S3TfWev+g+t8b0hcdek+5YRGxcLERSFExtwUJ02b0FvbRdHPZXGCH14UlMJ52CaU6oQkmwAzRXMrVn4lOMIT9TQarsdjaRfN+aMA3vEzJ6fdBtkpGf+DiYEzrTZ3yhq0f6NmR5vorj+puLbK6T9puvQ=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN2PR04MB2143.namprd04.prod.outlook.com
 (2603:10b6:804:e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 11:32:00 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 11:32:00 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 5/8] block: introduce zone_write_granularity limit
Thread-Topic: [PATCH v4 5/8] block: introduce zone_write_granularity limit
Thread-Index: AQHW9TElyiGWuQiAlEa6HDzIi6KoxA==
Date:   Thu, 28 Jan 2021 11:32:00 +0000
Message-ID: <SN4PR0401MB3598B9246B4F80F2A9A0BCCF9BBA9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-6-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0df3d2e3-118b-4796-08b7-08d8c38053f5
x-ms-traffictypediagnostic: SN2PR04MB2143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN2PR04MB2143C33991E42F470287EC269BBA9@SN2PR04MB2143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggcCQ3T3lWoD+hOe2e+YP7jzDHdsPjRtzWMQt94VWaPUvwWgIsKxYz6JW07UZ/yeyo/Us+fk+aQzz5YoXGZw08IxALjUpRpD0MBa5nlYssUhiU4ZS39s3qbk5dwa7gY5tip5qqF9zIe1pfJnKSiOOxmU5LwqRaMcFrwxuKYwClI5NkNypLwCsznOmFs2AjHc9NaFeTFxh97n/iWrf6SvpWmFy7nn8pjp1l1tan6u/R7zq5AsxqFfMDahPJ5XPPHsFu9dbJzUbU3nJE/Hp7zrn4OSTJdY+2OG98w3oAAeo1SlE2Had8kpNdQ6OG2I0MHxqAvFc034RvhaXQWs5tlxKxab2Ef/09/EdNhLVt6FECuk8+OubsvZGb9SpGBD2fI5M2LqeqbEjOqePV618q2lM7H4D2LzfqCKI0s6vB/4jfH4k3DBkSVYIabrMqYNapkp+ufHq/9zsW169FSSkp9bOXDjr+Lh7cFC/LqQcV7ogGl1o6fEwa1kO9+y1IUX0REoO0zmhwhNeEtiCYw+2YZmAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(26005)(91956017)(66446008)(186003)(86362001)(5660300002)(52536014)(66476007)(66946007)(66556008)(76116006)(19618925003)(71200400001)(64756008)(110136005)(316002)(2906002)(6506007)(33656002)(478600001)(4326008)(8676002)(54906003)(4270600006)(558084003)(7696005)(55016002)(9686003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?s4HY2lUfDwUyiFcDZSJUvAippW1/xkuraO3hGNgG24J8fcwaXHePizYbOVhU?=
 =?us-ascii?Q?A2OnYHh/koy0sWg/GcxcYi7TpOi9z4ZAyG5qk4/RqaByx1IJHpSQMTqPyVDL?=
 =?us-ascii?Q?VSgXlbiG+12CSfw9iw0DWiY1c4eu4n6xvXTR+CJrrhZyY/EjrwdPohsv+ec8?=
 =?us-ascii?Q?CrLm96JRVzmXVO1jkACwtIlFfnnK+WEtyOe5/FNxl9LomgDkPNjZo7Z2wJuC?=
 =?us-ascii?Q?sfJ2e+pPOCnfUFS8tuJ6dz3X5TtymM6BUWerI1NKQ0WtdYmNF2+MHd423ELw?=
 =?us-ascii?Q?DUozTR+f0hMMbWxz/kblXMWUjQyDBV2mKQa6gH6re7TBB6eT4V53Rt96MZg7?=
 =?us-ascii?Q?eYVnBX8obsIVkahnPX69edVXvWvPtWB2sUiJZtKHdnUt+GHHcfzRSOQF1CO3?=
 =?us-ascii?Q?/Ihld3ZxpxeNCgu23OTiCS9kEXQ8lRyuv+ELPEeyqjlnl/FnGmV1R3wbSI9E?=
 =?us-ascii?Q?mrooN6kmVR+497CcMuAjIELwRsv+B8dKruSMIGWgXYAMObR63J5r/CwPQ0s2?=
 =?us-ascii?Q?TDULFtbVS12T1W1tCW/otK3UbqJOgUgi0EXWCt+Y07VQJHZCac7ttrY5POZd?=
 =?us-ascii?Q?TZkb0X27FVDX/2qagyXtLUdOXfuM6beVhuNSLiNc1BleKWBCarlndXT94ENA?=
 =?us-ascii?Q?Uv2eT7QdTQEqg3gO1qr2zcw++tOzDeBSvhJ4OcnCawymU69rlP654+F8m5gf?=
 =?us-ascii?Q?fSP2d1lNN/fFvWtJ7QbEp3FM2EqSlCFScwriN1cadVv/Se1BLuhpB08PTOEv?=
 =?us-ascii?Q?3nNGoccNvMuU6bn0W44bYaE7PLWksfJiiB/wDYUGQJCawWmMatX4M6qnNV5q?=
 =?us-ascii?Q?GLn5p2KC7behuAr/VobZ4g9NpLkJdfIAGyaycImxqlP9FHDDkTl2xUM/21h9?=
 =?us-ascii?Q?p068B6Sg1cvfSTU/1faf2BRgRp4iIIP4xomJjsexNvCCzHxTqr+g1YN2TJ96?=
 =?us-ascii?Q?T9ISBYgV6V8oK+3FmqE6mbp5mRB5CX6zDJHJQtwJx/+cVWN7Bh0bJjm875iT?=
 =?us-ascii?Q?UQT4CxK8lmIkNrOkchKsNXyDkXA5gqUn5m+uBE2qHe8E0qorKafRsBczWyXM?=
 =?us-ascii?Q?x1GJ6puTfWX+N8vjiW9dyZmb4eZHew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df3d2e3-118b-4796-08b7-08d8c38053f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 11:32:00.3803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8UU9A1x2QBP6smZTKyeUCvNbM725vHlyrCEDa6p56aZbLB/p37wHS9Cy84SOtHRvMQIJz0Ky65EFsOoasKyo4tflcNoFxLaEiAr11aJKwkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
