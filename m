Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2625C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7423264DD6
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhA1FN0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:13:26 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:52233 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhA1FNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611810799; x=1643346799;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=eXtKBzYrJbUvj+rQX+ts1NvWSJXxgDx/HXi2Koaq/ik=;
  b=k4YOJctgXjzPN65lzvImh9dGVFWxy6p1QyEiVLKg1HUVTKzXgvMMRjXc
   P2lXM+0MjD3AgqmNiPY307U6rjQLaoNWYYJr+DNwyE/ZqEhXLwWRZnAM0
   EAetWT0IfZ3ugzcbyJKDT/3St3nVC8rTbQ+CpWBgAHKzc9RhJ6gK06a8M
   aBafjBzrhXPga5MKWjP/harZqWb/kP11UuQpsfDNw6aSvEWcXxuTQvnrc
   JPoi3YtK+jGpcOnN6OpkZ9HR5H4gWLvvsMkRJ6x0n5OmI5CwYrEYFEXd1
   s90nlh/Bd1XdJf0lqd1mmAMFpyJqVEx2/D+SkRry3bMhE2LrnEjwwa9WE
   A==;
IronPort-SDR: aYPDCFr4Dit8xXVIDfeRgs98MGYjb0OKx+vFEc9X8BGUT1gqBqaVa8BBxoJhfomQ72HgIPk5zU
 sGx8wwChAg5auqF+Ut5NynAUI9PqTjkwPYolRaHRcABjmb2lFtkb9hh9BPe0hO8YZbyh3I0BTm
 4oDMxlnI3Y8oL8zBJqQPUuadc++DcyYiXJZdFNXl54WsFh9uYr24yIm49QiW5Dt0+e6izvHpQs
 c+XuXaw+TwgV4eziMikv3VahncwgAUrGyMN5eGyBiFr4Z306EAbrIp1dipHsUlKW3OHiVIC7Wh
 2kE=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158510942"
Received: from mail-bn8nam11lp2177.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.177])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:12:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/X8SAY6PKfy6HRWWhUjx3qk+v1xD1AceIpAG+vzK8UrVvqNSZVU/0qwCCgy837qEOWgk2oWF0k/v7JzHSFgnGSC+TScLQR4kkfCHLUGTASfVeZWGtJI+UZFYobZr45jolTiIpgtbP9/qOsesK53ebPzBnpI6B5vaC7iHHO+izaYq4avt4cCu3m477QmK6gq8G9gdjH97p4sj6WOWbZGn9RufLI7o2iaIBoI7z+VkB4oQChsN+v6Z41oO25i2XuBX9Dkm6S1M7MZqmes+njgtkUiVD1K/NVckVBbD0DjuMhcDn9iScNmRNGGC4LHzQYjTsqYhmEx+Nc/sVJmT/w9Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXtKBzYrJbUvj+rQX+ts1NvWSJXxgDx/HXi2Koaq/ik=;
 b=OIIdE8yFgIQWFN95ReAzvIZ8yCRV1+1aZGNkrJdJI8TrUnuH5IWnQWcOcSKb0U0O0Z86MOrvOXeGZG8ba3WlPLGilmOHrhOKT9JvOF/REDEL45qJIOnkI0co4bEqWJeIGUcSnF7XrrOP6sY2190a7Pms9GzGz6u4HZLe6G6J3sMBBXm8irsDLwRg3mCBiOKKgfzZu7KWDQUUGE7PSByOmGqLsk1/m416bRYsQfINKou+hQ48B2Sqk+sGgRNsN+YqqOh02v/dnBJtXw3qrRvIC/csxgEuz0/bW4H0YTN3EFJpeHIhwH10APt0tJwIkZuKVw70LLR9JiqSN1XEPb9jmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXtKBzYrJbUvj+rQX+ts1NvWSJXxgDx/HXi2Koaq/ik=;
 b=VQeCiqYDsR2T0XzrDYOsTcLEBdBLZtDGkriYlolD8gR76+Yc4ZDWefqFuOyTkdtxTx9lVKm69jvT+tfD3V/Te753YjjGPtlui6Yzfpg6S4WTEj5Wm6MYQk/2Fc88WKATvPCIBZdy7oW73yf/8iJBJNyO9DT2JUAfUCS6oW2Cx9c=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5591.namprd04.prod.outlook.com (2603:10b6:a03:101::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 28 Jan
 2021 05:12:07 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016; Thu, 28 Jan 2021
 05:12:06 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 3/8] nullb: use blk_queue_set_zoned() to setup zoned
 devices
Thread-Topic: [PATCH v4 3/8] nullb: use blk_queue_set_zoned() to setup zoned
 devices
Thread-Index: AQHW9TC3nr48jKQY6k+YInneMhhiJw==
Date:   Thu, 28 Jan 2021 05:12:06 +0000
Message-ID: <BYAPR04MB496523B7A0DFEB865B89EE0686BA9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-4-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f3ba47af-8738-4cab-c6b0-08d8c34b41ee
x-ms-traffictypediagnostic: BYAPR04MB5591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5591C6FD3E77C855D7A53C9186BA9@BYAPR04MB5591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4gnAKUyl0LYgL87bP4kHASXz12AM10d4lkNhVQqXGplrPB6MhSfJyGkRKPgwu6rYmgoVOLpcOAqc3WqIxZTjvt1/vmTzviGQEaEjY8jjjHfZ29Gls6fTICfr2ZVFI8Rpr0tr8NjjpHWkerBSdSOMD2rS44DzCNs8P5BOQgpqCqRoYUcTRrZmzK2WEtHclE6rRlMD0aZLRbVnbbGuJbcWpOMCc/SY/Gcd9hC8XGxEHJhCNZhsMSBDZR8Aowuf5DrYtvr5PadXe/DfX2mLWnX/BYqaQ1wAgYKsRcArKeklpwiUHjqJi4EdTqnThclQve1hiBJORqbWA6EaYHvuo+mwnczUILLigP+Sv0nWOrZiS16UoLtuXpDUC1zeoqSOiK3Awz24w27kw9p2eqeg4yY5s1B5Q4RljvV5cBdyx/x3kE89G24+Nhyfw9H8ho3r82rTX9rZmncIdZG5/qLAGsWiJ5hy5R6lcSg3bVBsXRGSyO10ow8u6muWAGUM841GZA7TDnh+yuPyfWK6K0S6ZRBWZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(186003)(66946007)(66446008)(8936002)(26005)(5660300002)(7696005)(55016002)(91956017)(64756008)(76116006)(53546011)(8676002)(4744005)(6506007)(71200400001)(33656002)(316002)(66476007)(110136005)(4326008)(54906003)(86362001)(478600001)(2906002)(9686003)(66556008)(83380400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eR/BXaU88yHDD/Sbo5WZKAp36buy7U382N7xYePBrTUsHyoUqxxOHKNyT1C9?=
 =?us-ascii?Q?0Vf5XBm/Q0QsMHu5zzADCdjlgvoe5v1Y0epSqQuctUi6SdIiG35pOJxycaFY?=
 =?us-ascii?Q?kflhM4MHWN/p4CRHUbqOhCug2zYaFO+rneiwWdAqVOrToTRcp21EGMCcT+9J?=
 =?us-ascii?Q?FonBMU4CR9/5c9wBvIwXnX7+Z1BfWGabEyjuakolr1LjnYtxg3wbw+viSVlw?=
 =?us-ascii?Q?A7x0tH2XEMmk5DNBOsFfVlyIx1wHIsbA/18ama07kRlKcJ4l9Vlq6+lIKqwq?=
 =?us-ascii?Q?R8cvES10gMokh6XffqGSjdvrNcF0KxdGnqpSZ6sShOIdLEmef30yoa9osjoR?=
 =?us-ascii?Q?fqvNQNGD5wN+GP4F4eA6J/zNNYhJbzfMl18oK2E/Q1RQdq5tHalpjHDkgf6H?=
 =?us-ascii?Q?QYHbmh9KlNedYY2jRenGBdQkuMILW0WX/za+Uznqz/P0DtOQmYdqTIN9RZbP?=
 =?us-ascii?Q?5TV9tF7CUK+McnjjEYfzMTDp2iR4Fk4c5s5Daipmn15eT9B1PFU3DveEUYDp?=
 =?us-ascii?Q?XKpAGr+B8wmtLCDytyp2lNR2yZLP1KhXX8CrmVBh9mze+tYdse+HPGsu/8tm?=
 =?us-ascii?Q?WVHSGXeatNVOqdz0wnLSQ/Tqsd+0LYbBiwJkkCJWJ9SI2dDwc1DbhYvoyJ4S?=
 =?us-ascii?Q?AAtOY1T10XSe6YpyEzNJvFpZMx5G3oCDNETNo7kdQ5awmPH3Cp8exFxKNVco?=
 =?us-ascii?Q?y8cg0+Hjvtfdpk3euyF7kdyrhbvgjPJJDCzB5VECjgvryHZEharHyap2nCMJ?=
 =?us-ascii?Q?IOs/tBhJfKi1ojOWyrgAe4IhrafDxwty+w0v6vbbsMu73Yp7hxcJKYHa9YDd?=
 =?us-ascii?Q?lO/g3TRzlibBiyxJtgXxy1epQDnmKMD78XRd9XKyT9Lxes9R3RKfdIp1kOtG?=
 =?us-ascii?Q?ora+5v4iBmPXDKt2Cthmw074VLgurRPZZIr5WN7fLreWzRGjDC3IOY3qNsdc?=
 =?us-ascii?Q?CV1irXIp+1Xw/hgnuBBCLySrU6G40C8AY9laOlZSxSCUPYWYSF1PJLQDj3T0?=
 =?us-ascii?Q?h3w3eeCF87nXeIXediOcojt5igsObKdgaDQiF9BdVt06THJx4XvAlInQSFS9?=
 =?us-ascii?Q?yhWP4XVfwqM+AMlOUC2x2dApxl28Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ba47af-8738-4cab-c6b0-08d8c34b41ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 05:12:06.7796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SmVRGjM1x/H8eisBEUV0EeX6vHke6Xfpp0sS76XTkcrs7ip3C3BwqufeGKEDWS/8lMRANm2BPh80MqGNColWMTAONwzt6yhdwsvzvVEUQP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5591
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 20:47, Damien Le Moal wrote:=0A=
> Use blk_queue_set_zoned() to set a nullb device zone model instead of=0A=
> directly assigning the device queue zoned limit. This initialization of=
=0A=
> the devicve zoned model as well as the setup of the queue flag=0A=
> QUEUE_FLAG_ZONE_RESETALL and of the device queue elevator feature are=0A=
> moved from null_init_zoned_dev() to null_register_zoned_dev() so that=0A=
> the initialization of the queue limits is done when the gendisk of the=0A=
> nullb device is available.=0A=
>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
