Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92982C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41C4964DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhA1F1V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:27:21 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48179 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhA1F1S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:27:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611811637; x=1643347637;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=H6zp0agPc0nMTkB+YVG5ZDKA894T+5ElMB4yzFvsI30=;
  b=gghyFDGm64Ydjmhz3gffyXwiPD78sl3UiX6diEOCkqMytie854Mm9L5t
   yJmFWvvpw3MJXxVEOTLeWeON2Tb3ymGvTqXGjTqBRPK0bAGDEK2MlVm9P
   NNfIVitjl1PaCrivvv1//zLOF+xJ2KrB+M3FsBelWUo+Q1ssEcmNiGKSk
   jHD0hwRToaZ9Gg6Ht77Hxz0MDQ8YrgJvo0U7ZZxiVb7tSv3GMqqDWs4/4
   1HAxMH6eDXqTP4s+MYqxOkNRrQpRRaCNr2BJazfTmU+wVYRB7fMYepzxG
   W/4bYPE/Zu8vv8BokwmWLM8bkE8JrraMR6nZSAxnPLgIRHpYkhtAFo9/T
   w==;
IronPort-SDR: IflXg25q467Bs1FMKAviTUa0vJIMsx5c6cLuLzlSlFtvxF2q2M3Z+871X3EZQYN7rwiYMMSpA3
 lh9UrOBi7TjOQo7Lw7gztxXfCrc7aG2J2XbNPiFJi1DXt/EEmqluYIcb3P4IN0w7nnLz0QLpTH
 ycz9fkoaxOO91wzGZzzmyfjYqcBjS3c+U1cquOpQvq1FN/60vo2Be5aaQcJl8TvMfHdicFIklb
 ji0yZRbD7l5CUpCEzmHi3ukczHkmyIwReF7L8luv8uSOd9NSRgg/opTLUWZAJOGey4vg2auyvI
 Qkk=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="162957535"
Received: from mail-co1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.53])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:26:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6XzehiK3BLGDzoCDig16/btcHw29nsFAhP1aTbgIvlZSpvE3Cq0YnW86s5jnDRcR2nAp409/x7xSsNPuGD9geqlTHpSKbP2hAAju48uFgpy8AvNGEFGzWhyV1HIgm3S8GTFUK3dJfaMz9G7RwjhY4AsXT+0tefold2TtklEkTbG6iS/dIiyghIHVXNkLJZHHaJh6a5JwvICGQV2DHcldEeC8NRHl8EvwGx4GtPfFnUydNREpScxr1OsZ6qmkxqEVfGmuhuF1RJ93CiAUHjQsd6uu9gwjm2e+wtHTWUNWnx5/7bMkQDaGBUwmRcbiLkmpGUD1Gt4rwVFnMS0+ky+og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6zp0agPc0nMTkB+YVG5ZDKA894T+5ElMB4yzFvsI30=;
 b=LxwIjDGu+dXjHzEqDG7vbc7ptSEHZ29o+KI02q/mIQBcqEF4X573GxD45eYvo7atGYxHPyFo5hLn4QEAH2c+03OBPZDdpFVLKKl/JTiLPeqWovPZCFy7zDQx0yrUavcsmlonRd0Y13ISndqsinoCl9nUsGbDxev7XiCiCKsORGA2ec1yCkajBVP7CS7K07vG1ANwFa1DKRj9F+5OziE6ahh1Hcy/7oaRbthH/j91feoXdqlJakD9/IoQh3FHkPm0milZajkalp1u6eN7XVnJyQAvDKBFXJqOEkrecmLyDDIYmuZ+2y2xAQg6VH49e1ilPVGUjlyfsZG6XtAzpyv4Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6zp0agPc0nMTkB+YVG5ZDKA894T+5ElMB4yzFvsI30=;
 b=TjKpG9DZ5H4Z3utP8jhUYKJwOJ6anaX0Y17fDZaBRa+0WjCDyv3SW1J8/Xf9uJ+8k2x5cA1+YDbPqV2t2bIoEfleybuYZ9su6hWONdqcycOXc0S40aec7oCYJILkGf+5QThi4WsowjO1IqlyGSuEMsCrIn3F5zipWC2giGusGsM=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7550.namprd04.prod.outlook.com (2603:10b6:a03:327::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Thu, 28 Jan
 2021 05:26:09 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016; Thu, 28 Jan 2021
 05:26:09 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Thread-Topic: [PATCH v4 7/8] block: introduce blk_queue_clear_zone_settings()
Thread-Index: AQHW9TC+z+KJV1CxiU6HvWRe60peXw==
Date:   Thu, 28 Jan 2021 05:26:09 +0000
Message-ID: <BYAPR04MB496527AB027FB7BF084FEF9186BA9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-8-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b569713d-b25c-4b63-3fd0-08d8c34d3837
x-ms-traffictypediagnostic: SJ0PR04MB7550:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB7550A9D21C1F70744849284386BA9@SJ0PR04MB7550.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:389;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ORRGCYey6iMKXLHKda/LXZTgF3kwfYvx04o024I3ARaQO1Dpwp3Hi31L6IIfMw5IyxvDDBt3iJKpzpdLjhEFz21sRZ3IM5+exmBVPy1Lge1yZFDMIiuDPlESye1buPUlM9lWIBRbPqJXB280aWTu0awZmZkMUhkZzXedofF3zgXmeY3ZoNXj54syFae4Q4p3wWoOb2XS3X3K88vcq1mGnM7hBnR7rgSjoVWxnGpYN279cRDRSGIiTIkDm3b7lJCu6f68PHIn2uWG06ydaCOj1CC4wvUNoVA73GbOEg2Iw4AvE0SYdBAgmb6sYDQ7ApU7Ru1lVtsBbtsjh6bVdREYgmn+hqXO5gWIU9D0epIH2YTh+kzvt+ZJTmrqFtf1wI7oy5Zsro2v/ctddvOtz1Pg/b8llO6MXRTZFlEii8Ub2JGGidyb7z9mmueIu8vT5IRnOEFNA0o1q+LovrI2p9t/23W/Q1SOCo3rSt9qZtcMTBnY4poSjjQ13ZknLR0B6bH/+m01Mxk/84icSXVYmvRTwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(66946007)(9686003)(186003)(478600001)(76116006)(26005)(54906003)(6506007)(71200400001)(64756008)(53546011)(4744005)(5660300002)(66446008)(52536014)(110136005)(7696005)(316002)(55016002)(66476007)(8936002)(8676002)(83380400001)(4326008)(86362001)(33656002)(66556008)(2906002)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?02I2W4tEwC8PU7CNMb7oogPgOGxdvxR+8Mc5rvXvCYLztN/HNp8x3QbaqfZv?=
 =?us-ascii?Q?ryEowLO2rwIOuCbMYN7dnAn66aWaYx14V/k3iTARfQHVerhmD56aWK1jknOh?=
 =?us-ascii?Q?aFZ1PRoTIKMjjFuOoTZi1PSI0yEQbhkw79nEgd3Wvmn65J9oEK9oiVOK6YIv?=
 =?us-ascii?Q?G+2bNJvD9jWHPF2fFvPQG3ToPhoWprrroll6k9IjSTk9F7JMOrEf4hvRLOcO?=
 =?us-ascii?Q?iDIhZQ2z4Qylv3O4obrgGuyMXzFg/WjCl18Zufq+gD1qBPOdGV7DiD0HLyKT?=
 =?us-ascii?Q?1MMQ6so9f6WHlTBZDmuMUEZNJs7bMgGW7bnolmqXrVKXt54QaGw/TKNwR5EI?=
 =?us-ascii?Q?xU2B/EdI1D3dgSNLZqNu0+n15tXrUPJwN3a63NFJ+UCs+zzvk0Iw2sFSQ1c+?=
 =?us-ascii?Q?+g2LGawl6hSPHud0PeNLtmuvJ5lxdI4t2m1PFtUJE/aMl15IlIjt/CHH0KqN?=
 =?us-ascii?Q?SgIivMGk/gAz1qRTrHYXZmD5/kQfnqmYjC+URKj3bvCy46sTcgOzIyjBfARU?=
 =?us-ascii?Q?0n/y4z2Xc3l5HT+IR68DQZqUnJ0moJ/KjWQMw23H8m2edXyr5erajSx+QL00?=
 =?us-ascii?Q?x+UrxgLmZA+n85H1Yahv8PvFIgc8uJYfo9oPFEhMMS0KVAWtCGzNJUOfO281?=
 =?us-ascii?Q?XwL2dFby0bgBnN5YZJHTzDdMXZjojyzdfomhaCl5XNcJf6HaEl4le+AvjFRp?=
 =?us-ascii?Q?GV5APyCuqx8OZa2DPBt4QVyCsgBDo6Bg/kwxKHoIO1XFVA24aALZP3QYwEqj?=
 =?us-ascii?Q?W0hp5Jqr4c6dFUrh8Ed5Ij/SxIB4zkTxsNIFHRPmkzHG3j+OBjAY/uGx6h4v?=
 =?us-ascii?Q?CHMSTHPhFOtNd5bla40SH70KVifW+5oRwga/I8wzhfIUlq3HR3Iz2S7U3l08?=
 =?us-ascii?Q?56qXzHlrwWAevkAojfabBks+aII4MFQ1uiQxzpI0qAjjBx5NHcN7YF+T5IF3?=
 =?us-ascii?Q?rP78k8NATYixdpaHx240lpCH3sOmyLrfYT0F2qqtuNx3I1GSg8LB963cZsrC?=
 =?us-ascii?Q?wBnZV4KSS/XOYNHuhvPv2pNTbVQQS0px8VxMkQvV8RrPBt3oLm7pbatEDEXt?=
 =?us-ascii?Q?lR84yWwq+dGrMmHYwTJ5l8LqKA8Nfg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b569713d-b25c-4b63-3fd0-08d8c34d3837
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 05:26:09.4818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z+KFpkcy+fJe/jCl6H8S/o+4i2PvTIcO6ZrfLUyZJqQAX7w2zQ3eUhdF/Z/ys6cUEltzlBq6my1MtRYQQC8o6Fo7Objhis5/DZ4Tv6g9lU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7550
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 20:47, Damien Le Moal wrote:=0A=
> Introduce the internal function blk_queue_clear_zone_settings() to=0A=
> cleanup all limits and resources related to zoned block devices. This=0A=
> new function is called from blk_queue_set_zoned() when a disk zoned=0A=
> model is set to BLK_ZONED_NONE. This particular case can happens when a=
=0A=
> partition is created on a host-aware scsi disk.=0A=
>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
nit:- can be done at the time of applying the patch.=0A=
In the last line of the commit log :-=0A=
=0A=
1. s/happens/happen/.=0A=
2. article 'a' on the same line with the noun 'partition'.=0A=
=0A=
see it make sense otherwise ignore :-=0A=
=0A=
Introduce the internal function blk_queue_clear_zone_settings() to=0A=
cleanup all limits and resources related to zoned block devices. This=0A=
new function is called from blk_queue_set_zoned() when a disk zoned=0A=
model is set to BLK_ZONED_NONE. This particular case can happen when=0A=
apartition is created on a host-aware scsi disk.=0A=
=0A=
Either case LGTM,=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
