Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88F0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 07:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CAB064F97
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 07:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCQHpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 03:45:41 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13197 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhCQHph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 03:45:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615967136; x=1647503136;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=qbLHWMLNR13P6pvYyHR6/sC2JpIfFBRAb+6jinCq8W0=;
  b=BayfcYo/J0RhZhgzMc+j+fct9Qm/LLy6HyJNYblGQUdYMPZvWiJ9HNld
   UJdKNMCLjWCsBi70xCTqk5vRp8h1R23PtGPCJK6pcdKTJZpMtVn4puv4f
   L1FVGi39im/ZvdPI9/gkshrblA2n82+w7zxbe5Nblp1btnsP0u7EpPTWH
   ARq+dS2h1aQb7KUVa3QkpjiLSIUTx6Ced542PrTkM0/PzI2gKCcluGWP4
   RCw+JJH2IRpxRSdGzeXwmaBdQyi+oV/8CtPjQhkpRWue2CUwyMhjs+W7/
   1cMudg242HkxvH5qo7+eTSIdgANVVnpv8YMUmELah56vSjJcpm/PW1qNn
   A==;
IronPort-SDR: w/n5ecNyjcaIiB23eL+eUsK5Y6rVjdmaewQv5nY3MrGNUgfifwv20dNTu1bAp/J4ynANqaGNsM
 P6ZMr741zwtoCl0l1GtwR7kvzQssL/xYC2PddS9QBHbQ/zBoBrfijGQya7jfDadGF2BQIxYxsN
 fktzqaKE6uhJacRs7BhmBv/BKnmghmZuYT83AqRTj2kMxNmU+7N/dp6V/8FK0+9eqk0dmmZSV4
 +fXQKLSu3FKStVJYK5toWWkYBoLx5liZ52t2EUSE0VHGt63sbPmIfLt/db2xyoAyfp3Q6yhjfy
 qvQ=
X-IronPort-AV: E=Sophos;i="5.81,255,1610380800"; 
   d="scan'208";a="166830149"
Received: from mail-bl2nam02lp2054.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.54])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 15:45:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5yi8Tk9Ie5/IYqkFC6IwbTClO/4nLF2GSLU6oofSdD+Opbkp/xkBBBE6i6xXST1nO+5IznxXzI5iJLOntmv2+0BB8jzUxGfKBMwYklQ1Xkm2iDtOcw3ilZeVrNjo7RXw9ge9ygU+TCrdn3X6tNXvQHiv7nkGoQGko8/sIBAHvp0EF+PR60Z39sgMVa6K/k+GzQh2rh/o+8KWbhjOIDkR+hd9wR8V7QkbidMDZTNiBAKkw31/yIIZNaDboHV05zl56hQ2YWab/+3CHTrUD+oC3j7pACcR/eiq/Pzsc8Bi++CnBCmeK/AerGmHbWD9d2aGV/GSkvZ7mX6ySx/p4AoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbLHWMLNR13P6pvYyHR6/sC2JpIfFBRAb+6jinCq8W0=;
 b=BbblM7LiDYR1fl27weAQ21RxJLuWi+hN/9e4zr+aNfdR9WyYwTtyy2g2QvoylJ1CNXiuu/nHnsOzwrmuSNJYzuxQIF82FgPlYZ3ZyO22NFjOgsyzAj71Y+2/VqFN+Rc3D3ouu490OIUP6Ph/2Sl4MJoBjqz4LIEZCRFiwpICt06S/k/mKX5y5CP4J68W6xA2ZXIl6UsIaxkKoeqChKoeZrzKlIZL4hXpaQOvTYgzQyLZqCn+gNnAA5L7dD93FuJGx3b6qzQZF7woSy8dHQ16emFkNOb3rCMJjEJUZF3xx8lCW3X+gHePqxV74rkD+R40G/j6GtBTJlae5faBsFaB7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbLHWMLNR13P6pvYyHR6/sC2JpIfFBRAb+6jinCq8W0=;
 b=IRCgDk8/WoI5XEJcz5yTJ5WoFbYhbwviwcg++NbwMo0f1m/ko8ekKdqty+K6woo7bWJMwivQOFkLVtj4BozyuVZpxwSB/BzVIKpEaPKGBBH9vwzzqN212+pzXOX2qW7UeVsOaksVbLueRttiCBPBwHclGakJsi/EuwPYgkdIn+I=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 17 Mar
 2021 07:45:35 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 07:45:35 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Wed, 17 Mar 2021 07:45:35 +0000
Message-ID: <PH0PR04MB7416ADF8D9CC7F0600292A5D9B6A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <PH0PR04MB7416236DBF6578C221CC65319B6B9@PH0PR04MB7416.namprd04.prod.outlook.com>
 <yq15z1q36eh.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:e193:b3c8:606b:24d7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01b68650-5144-44fd-4b8b-08d8e918a664
x-ms-traffictypediagnostic: PH0PR04MB7158:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7158EB5925E5A4E1304440479B6A9@PH0PR04MB7158.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z6JsgPIbvzTqqXshB+UiVwOTRGAsUSQfT3XegFHBt2IJz6yhMwCHNbRpsq6lGe7WDBwGkPyy1EvKOzPNfqFucRgyk7pncLXMsi+PBcSiEKBuKJKn8oZ6/1+oCpYLLhEBxts84g0ZK9wHaXs9zmhNZe77rz8fXjeSoUcZvQOqDGYwEylD9p58fpnY1qnwrwUgrAOxlqhwuBQ2z95XdlzwK/Wqk/aZxK3zIlHFEpYJ4kaHXcnxsjJjC02jlmqeXWojoa5uNHWaaJ85+nkAKLb6x4u2YVQCSxYOkvJsvbWOt+MuB17S0TXTNcDyphIm245KjalPBm5R6ZWLFYBmmCV8MzvKUxnUIm3qaTattSCk3DFTwciRDgM9Ge5eXOACjTU138SZeTssEbWi8mteifJxXSrLW9OQLrmfZRhOrY8xtUTQ9REmPVA2uhb4NCJJDISKDMBqqkQ7aPOJxaamx+T7zjme12YDmbq7W2FnZeGJi1mzGde2rqjcrrhODlWRwRPkPUAdnGI3rmNnHUsTpoK25PZdx/h6Yrm+8alm3BSmF/TPfhH+wj1BJUlinpEPNXaC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(6916009)(54906003)(316002)(86362001)(478600001)(66946007)(5660300002)(8676002)(9686003)(55016002)(186003)(64756008)(71200400001)(4326008)(66446008)(66556008)(52536014)(7696005)(2906002)(8936002)(6506007)(76116006)(4744005)(33656002)(53546011)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Y+jQxMt7PC+NHyZk8ZISO5CXEMlROh27yDWx9gzBgyDTfTxE/DsZ+kbCyxbn?=
 =?us-ascii?Q?F4wyv2irFQ6r5zRzolP1zz42DGnNBrZRAVvQfL/QCPISqC16cRyblTAgcVLw?=
 =?us-ascii?Q?RfrOzYPml4J3awTlMWYL18Xr0Lj7JJTV8ZKiSY+JXvGFFr8EUE5GgAr7ptF3?=
 =?us-ascii?Q?KM9RoKAfNsDYgG5SE3Kdy4RqegSrVrfEIJkFBl7kfnwF5XbXnAZHRd9wW9Z8?=
 =?us-ascii?Q?NQyXaSEHjjUYzS3aGSp4tvdMGx60vCOqQzzLM+HhnUhXh8nmfJ84IuKSeYOD?=
 =?us-ascii?Q?MDefnZmzkf0ubiuMI7HbY/CEhPg+53rD1RS8qYzFTKvMmAUN8veDbEiqZsc6?=
 =?us-ascii?Q?b0FqzoUMNW54SzLWS+p5v0qL+jZ1rmD2T0E/et3zYRetgfR/mgIaDMR3agbD?=
 =?us-ascii?Q?8a423lzhoS1fb6j08OJ/o9xU94kdT9RTVVBSyfV4+puDelWdoPQgqaX3qxC5?=
 =?us-ascii?Q?n8UDnsVqv2xlhDEmWi8zivFRzFdJKhAA1KQmq1YldDvHsipClPgRBtl4fj6m?=
 =?us-ascii?Q?dqrW8UkdCJYIqqnxm5v3e818M2v2gxqNhojH1HnarpiUV5jfkLJy72J7k7R4?=
 =?us-ascii?Q?XqQ5HZaAGkqOqAaIj09p24AdMukksvI6iVyZbxV23jrpPLbOVS3GaJ81Az40?=
 =?us-ascii?Q?5QLZlziRLdGCaIEg2SscapXj1WkvJmgC0IXlgLp1SS4PJ0wPNxb/PP9tmQH/?=
 =?us-ascii?Q?81qFarWEY0L58I4+djkFsJf62z3jOHceW8U6jpwa5rOSjASdNW/x6zmxwXOY?=
 =?us-ascii?Q?xzmYZ9hI5XnSk3mM0a4VjsmdkOqDNUcb5Q4nbx6iFMciF2fth/kbsksfgnHJ?=
 =?us-ascii?Q?2lUwrD0ick5stjvm9AfEXjwORzwprnIaaqDig8dCgtV1ISz8mJJhogTZGGsp?=
 =?us-ascii?Q?A+XNkVgE7ITtUPyQEDomxNHiHDEP4VRKFvt86wgPMvr89LUIkTGUpjrSZhqC?=
 =?us-ascii?Q?hnfxpCLRTUcbknJrQM4PgQ52oIQqgiAdSd19YsnSpb7HetSjKzcm7Dij64Qb?=
 =?us-ascii?Q?yWquA84I3GR4NBDyqkfLV3PDqOoSqU3hW4UrpPsRzvzY3G9jo1LEvjarUtN8?=
 =?us-ascii?Q?pama/qk0EfWW3ZyPYuSG8OQ4RYiK16x+fJgVE7khLR0R2FwU2iigFHpP/LQL?=
 =?us-ascii?Q?/dAir1PpnllZL2n8katszy5f3eQpSKTM29F9v1sRZKnaVDPurxqkpJQGQbdQ?=
 =?us-ascii?Q?zQtAJdN/ApYB0nKbC8QKxTgieljOMXO3Z+jrG5tiiDIGp+uWXiBvgdyySQSS?=
 =?us-ascii?Q?E+8EH5p9A8eIaSN6pABBqoRccPEBpnFkpA+c7mti18GtvP/Mqv7VPRDcvWut?=
 =?us-ascii?Q?tmNjmvhDHmeQmw68XiZqoYyJqa3BvR3bRpzFAahucRUGfE3zteHVP3VDR/Sb?=
 =?us-ascii?Q?KBxM9DyDVf2ukVmBIziz9XFXAgPs/QrdMxWm65AVovIwNf7KRA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b68650-5144-44fd-4b8b-08d8e918a664
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 07:45:35.1579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QP4KJXZ6eRFYCrGWJJywgD2bAlJhWlnyIlTLx8RvRrQmgo5CJfMGIzSgs4zXirYIQodiFzJXB+wIKg0ifeUDYtTHgz1GIDucgzGIDyNwozA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/03/2021 02:42, Martin K. Petersen wrote:=0A=
> =0A=
> Johannes,=0A=
> =0A=
>> Martin ping?=0A=
> =0A=
> When I originally read the thread I was left with the impression that we=
=0A=
> were just papering over an underlying blk-mq issue. However, I read the=
=0A=
> whole thing again and feel this fix is acceptable.=0A=
> =0A=
=0A=
Should I resend the patch with the Fixes line applied, or can you take it a=
s is?=0A=
