Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721CCC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D5F64DDB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbhA1FR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:17:27 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34670 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhA1FR0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:17:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611811257; x=1643347257;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=7vvV1JO6nTy23UOtjV4tg1sFf/Lx3306YMS5zzd9xuY=;
  b=CLxN53OtRJl0Aq8X/oyOK7s1A/hr0xteNWsyQKUhORxTK6xP+R5jnd6b
   txruAIJvvQNJPWFyNLVgsS+V2X2vqKRICtN+FTRLhrdAoXrwfl6zgjHxy
   zfSQBh4bvI1rinxtJOL733xvbcQ1l+IDGtgxvSQlGgwJkXgecCPoYiizQ
   5A7cgWt/8PK8LS2pKQIl3YvmkYwL1tU3qToypJzLVin0PT/mGxsgHbv4b
   jyEipwo5DgXWMuGvQfndDf5o1brAkZAxsYPa2xDJjtqOrMpIFAyLcEbYD
   gBSncY0nogQ2HkwdjLsOZQlGqca/UUOK0WdAJF/WD7wGQCC7aizi/iCAt
   Q==;
IronPort-SDR: zLLkV91klQ6G/o6TXvNlr4WlMYEpxgVTsP+lApGEkMO8tQygKZnB+YgQ3yLrVKS1bgQtjABOMb
 mqRBQdmbbBnZONTDUEK4H1B/+cKhseBqWoABG9wdc3EiJizfq/kby/E9/xCxTFWXVBxa4MHlgn
 7eWfJRpr5/POEbtlAubgzoxemYEAkmS61qrGUnpqfh7/QYrhry+GLwZW3dslaRnmzsgC9sNFl6
 TXrbx6ws/jNcCz+js/XEgeFxVp1J0yyjrsHC7Ph0RuGGFHWWWDPOlizES9wIgj/RJVz6SAP224
 Eog=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="262541904"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:19:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqrCp7RqA/jbsCY1uXbodTgleSrTAGMzOqRP+o9QjY+gd10g5rY/1gGLHG1gTdmg9BfeHzQyj1GDe7NT52o7LPqxFadgKZu2mcTeGEhvoP7v0X2Ck2VcDIAq5vaNSu2wQLclxCF5WOF5FMzPi+xNW9Uu6QXN9hGDTmEHOhWvP4++crxa54V008DZzaMyENG6coFz46j7/73yPovIMy5itwIWqmL/nKd0V3Sn9VVq83xH/SyKpZzZpZsIPjdqJyfziinrwDKWDvIlCBPIGvnQQ3QwCNUyxLFmlrQBkqfJQI5KXOzfsDwSyhfU9yelVp6/BOazwL8RSVckfTxh6YLIwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vvV1JO6nTy23UOtjV4tg1sFf/Lx3306YMS5zzd9xuY=;
 b=OMZ+F0F1GTlMiKRVoLiKT0cn/gi6T4cLm/GhrvurBPU6x9ra3gl481zvMkBGa3HZ/0HA+jy9BGh6e2/VeYWSHc6eQWF3hAxDXQtLxJxBzU/R35znBIY51qDgGIfw0oyXXJ7SpBHt1eZjYtuhepgEh71KcbtVCo4xFtAEqwxEO6/Em/llTbXrm4rDbKk8Ql2whKJ3urj4Uq2hwpz+eHvO9RyXBynJTjkXWVnS59zpF3ws2wZWYwKiTJPh5aAknpFaF0LAqmGpBveh4r0xN94Kj6HTODvyM2FFr3Dnx+j8eU/o2fi8rCM2y+Z+cIwjuHJrc7ntDHkTwZ7+NcL/pkNCwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vvV1JO6nTy23UOtjV4tg1sFf/Lx3306YMS5zzd9xuY=;
 b=Z5sy5+tOI+NXaLiN/eGo6D7p64H2+AoFaCqyTROuQUdSnPBTm2ujscD16zi+cNKZOO8X+q5AAFY8UGfmYSxyzKC5ouzHEQjUhRlq4JpyOEMEF52+nsb5A53eHKijWUD9rnepcq6DWt8BXAwFO1tD/oZdEfYvMkUKY2FanB22WTQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5591.namprd04.prod.outlook.com (2603:10b6:a03:101::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 28 Jan
 2021 05:16:16 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016; Thu, 28 Jan 2021
 05:16:16 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>
Subject: Re: [PATCH v4 4/8] block: use blk_queue_set_zoned in add_partition()
Thread-Topic: [PATCH v4 4/8] block: use blk_queue_set_zoned in add_partition()
Thread-Index: AQHW9TC4cewju/k5xkmdXovHPQbDLA==
Date:   Thu, 28 Jan 2021 05:16:15 +0000
Message-ID: <BYAPR04MB4965A5326735FC0DDF3BAA9E86BA9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-5-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 020f0cab-fd36-42f0-f9ea-08d8c34bd673
x-ms-traffictypediagnostic: BYAPR04MB5591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5591154697519C32057856BD86BA9@BYAPR04MB5591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y4rrxdXsgEPtT2S1+rFTUSAPEJzEUgX9E8MtBtKDtXbu8b48YeLFGt3nJDD8oCE05v9e+1z1igU92sQpQrx6sVHYo2ygncPeJX4nWjuiJWKledWIChgcGq1TX7bT5J+/OQZJRp+a/y9kqPHWdYD4NKh0O80ClUoX+VoRF+BIqeXdOn+Lg/0BOqpzhbAZvqO++2Gu5n++b6ngT1Pi8LR90zvGQ+Db3+YhhvGRXvWBJ08dTQs622OJOQoie22DqH4nF8QkvVigT8rwfQ+I41FGesrxI/8Y43C33yNUGdWQqcepA3NpqnJbUNjcocl6FHNb2ygCqRBSt9oc32tyuYiVt90BD2+blVFJuW1RSnTGAjlhuscuTOJBWcwr3CvIfEV33cEPvXd8W0iCoe6ihcEf1/A+ciA8vDAf11A5A0uOUw+xMkxu/5QiBdDoKyuJ9jVtrLVSGdI33u59zs5tRx8NHcRJOLf4KOmrlXcJwhjzn0/f5Qk6e56CXzcwOKzHf7CIO1vd5bCUGFf1JKyMQL5DgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(4326008)(66476007)(110136005)(54906003)(71200400001)(33656002)(316002)(6506007)(83380400001)(52536014)(558084003)(66556008)(86362001)(478600001)(2906002)(9686003)(5660300002)(26005)(7696005)(55016002)(91956017)(66946007)(66446008)(186003)(8936002)(76116006)(53546011)(64756008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ikZ/LCZzhhFGtStrrhJBWSUAgbuvhx2Y+mQ+L4EkEobYCyQrITaPOwUyYGcH?=
 =?us-ascii?Q?BFEVCcQnV4c925merBAL7dpbGGwD6NiVNEY1IUDF8LPWi+fldna9Z2q+FiLH?=
 =?us-ascii?Q?kGRDvD4lwY+FShN2aaDfXm/Upk+kpwixQCj9xM3C+T6ak+WJWKyU0S2gBzOe?=
 =?us-ascii?Q?9VhLcmhMViZ+zRQ9pHNhhfZ36eMPtxp368O78yFjrtsXdFFxRwthMfhPq4Dw?=
 =?us-ascii?Q?FcbzfAz4OQq0+dYti2aD5x0sYLo03n0M4Eky1ODYJqUEDON2EqythxtPR0/4?=
 =?us-ascii?Q?/oX1r91Nntd145QaDe9peCR7heyMJAOAhPz50hQx6zE0M/MQwCq6oGWMe47w?=
 =?us-ascii?Q?6CtQqDTXiROAqMIVL/NHhT2m77tytlEFhTgNSh3Y2Gs7jvp8cwlhS6OKbCVa?=
 =?us-ascii?Q?1nqLYoP88pR2yHva/7q4kJoiK2Rtj2X8dVbZzypFRQGZkLIapTuFHodqmNe0?=
 =?us-ascii?Q?T2zQ7SqxCzH4vU6+EPDgOe0ciYz5smSzrhFwWsuP1hc/LCkzEjOlzFPz51vy?=
 =?us-ascii?Q?Ky4OsF+QcYKSVRY/f+banFY4F8q8yBTn5YboYzOQ+RK/HvdGR77eY7yA90ur?=
 =?us-ascii?Q?M6STTrYdj/MnmUaExEALKbs9v2BBZRr3Drqhe36oO5WNooJv9iQpx9cZlZc/?=
 =?us-ascii?Q?HGEtqCRHsS9KA2gA/qgOQTn6JEHUwc/EVNHkQD1fgFAD4GNEMBUvEO/9anB4?=
 =?us-ascii?Q?ut+DtYyNWJJBRxZNdu4GTdplK3haRUM108WFdhJ73HRxzmV0UrIXrkDnJx+o?=
 =?us-ascii?Q?8Gwim7Ad1wPKD//MCJKhM5dcq05APNi2jkgRP+bcE+Zr2UwkE/J91CWWBH2R?=
 =?us-ascii?Q?eC80xxGvH5TEI6jsFdMcxJJsMS9JQfLBiM8UDuCLRq7GuW+kX3fWIEkKUn5e?=
 =?us-ascii?Q?jnF102i/KwZxJFQH/3wUCORhBs9Xzu+tGsRXSDdq+0oHkMQrZNzMwBZDsbtB?=
 =?us-ascii?Q?K8a2OVnaTYZbj36qLFzJdE8O7N90a5Y0/pwqcfveThxYfomYwUJcJhX2V5Si?=
 =?us-ascii?Q?RwUQDg/ODHmcDYif5MDFI380CAhjqCqWNriwYjiqwsUJRp9tjgb67L8l5AC5?=
 =?us-ascii?Q?4XGPKyggjpuQj3obK9LzoMf4n5R1nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020f0cab-fd36-42f0-f9ea-08d8c34bd673
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 05:16:15.5386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vuo/nFAnvgYfv5Wmp0FOxqAqNyJ14sCYn1VLqI/YPNiTn23q2LHJ6+JpUtJrXm6ZH8AKVpuvlTDvOCxNTDrTj2czZqQWX0RnaV/fn8tXZNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5591
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 20:47, Damien Le Moal wrote:=0A=
> When changing the zoned model of host-aware zoned block devices, use=0A=
> blk_queue_set_zoned() instead of directly assigning the gendisk queue=0A=
> zoned limit.=0A=
>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
