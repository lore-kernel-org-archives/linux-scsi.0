Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C62C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 07:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D77F6208BA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 07:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731764AbhAOHol (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 02:44:41 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:56422 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731680AbhAOHok (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 02:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610697149; x=1642233149;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=HcBXmKW4OBQmnVfbBD4pSik7wx3o7MmMCp9HUTi5bVU=;
  b=mQp+NLh2GxkmX9j8qD5ZxQO+aCnGRBTOY3QrwfRm3ccKNxFYusEfbOh0
   gElXzJvxFh4SznjzXXhaStloJDdzhMrtzfZr9k6802uplJj4BfprVr8Qa
   BGkDgrHgrk21Jzmq6/v0BxG2rzjt1lCE5JDtTpIvT1WZqOVempOcDJJCN
   VFEJiY1PVnJezxDSSL+sLwlQ9U8t27svcHruBor/aY3gjClSjJFjEH5Tl
   JonIi2HwKL1hllsm6K3EwiQzExXyPvMj/TE+MD6mS4+1enzwbN/EeJ295
   JMm0P5Gm7l3Qkzm6t+tzgzpOqr1QCXKpi5hpmENfi9ytUKNJSk+nH7wxk
   A==;
IronPort-SDR: WBFFzWRuTciZzfj6nI3fVyEIrne+dY90X2/1eVycG1YJU6eaS0Nyy54BKVbZOvmY9U0etLwn03
 iMwMjaYYSM1WGLWjxMs5vDaQNgg6x/b1YqmtedtPMUU/iSnldBbzQ/Hzat/DsZMJPnEBXv3ZPN
 D47X8L1tbdQmvbbi8F4a7eaX/ntymBaqNcN5FrYq+w8nLimxAYcszcUtHFkq2pqM/BK92bpbvd
 xvXs8l7WjXqJ4hUX4kEVkFJFp9Jxpc/3KLvrYLrF1ovSF8TEL1Q0pOxjY/LE+5T3eyaiLXUfCi
 qAk=
X-IronPort-AV: E=Sophos;i="5.79,348,1602518400"; 
   d="scan'208";a="261422638"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 15:50:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIaTMIMClZpdlUOE5CphyQIOX6gWAp5M6En+/TCV18UaAQRi1FYPpywsRkvjsrbaU8Os+VYBHYjwnA8UCU3lV23J9H3cq+mH1z221KNTpf5UKpOyb3x9YTrOtANkK0ZPJUjf080Ekh6NsDFEsn/g0QooE5fXKzYtph8DpN6ZT2t1FzP0Ro7YBSeC9g6I8xdl5bB4RP9cpkl2V19xSaZrsuIIIhuE1VPNZl0cNOw+ZRem/0NcZOkzpVwolv8PZhlqcw0ZwQ7yyZU6RQOwYnOYQ/ScTw40opkHt+DKHQrUEUQcBjvE0jVSWSf6gSyuPDHbXmpuGfRjYDrXljNb33Onkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcBXmKW4OBQmnVfbBD4pSik7wx3o7MmMCp9HUTi5bVU=;
 b=kuWu+o6/xYP3tVD03uZuSzNnRub+6WB39zhCWNYp8R4CGXEooWk8WbmHFTTIC7c6sP3DEGkFsfyVyOhZDr43Ns2DnauyO9jusHNJXYZPvb0588roMBZQ5J7WwIr+JkC9Q+0/k+KSMRIauEnx7tQ1H2J/owQr0AVd2ROafA3wQcVO6WIHya2uzdqViFC9RtVzXIz+bHvPmsF6yH4oYd/KvaQ//P5s8OduS+7QSX4u8vncJaCCmmUdoGYRQVv0CuaAxS3xtgUnkxIxaV2STPFgiA+pNBHzkKCo7F7MF5OmafrxxXv7lBpW5t5sYDCJBMcU10E+3JcvkzBcoNqyc9Hbhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcBXmKW4OBQmnVfbBD4pSik7wx3o7MmMCp9HUTi5bVU=;
 b=LDkraOqABQhnNtKYC76iykeLxKVd47H2aWaijEgDci4usuH6nAPNZosLmfSl61xOs3ta2VAfmY73NAkcOcxc9YBrkr/diVUcMrkBs4GKOz8YQi+X3xICidCWK91kR/ZuC20ZERJBEvMz+LuvJPZQtl20dcQFKCGA/Xz3aFqeLsI=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5591.namprd04.prod.outlook.com (2603:10b6:a03:101::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 07:43:31 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 07:43:31 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     =?iso-8859-4?Q?Valdis_Kl=BAtnieks?= <valdis.kletnieks@vt.edu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: iscsi: Fix typo in comment
Thread-Topic: [PATCH] scsi: target: iscsi: Fix typo in comment
Thread-Index: AQHW6w2J+ggJgxd38EOuf8hCGItS4g==
Date:   Fri, 15 Jan 2021 07:43:31 +0000
Message-ID: <BYAPR04MB496509208A16D378EBCF5A4186A70@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <2921.1610694423@turing-police>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vt.edu; dkim=none (message not signed)
 header.d=none;vt.edu; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [75.54.103.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e50f99d-4e00-487b-7016-08d8b9294199
x-ms-traffictypediagnostic: BYAPR04MB5591:
x-microsoft-antispam-prvs: <BYAPR04MB5591D92FC56A73D7CEB8B61886A70@BYAPR04MB5591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I+q4KOXEcYQryCZSMlWNjPoeC9r4NrLpEAAyKlp7Z4/1P3yJIbjsjLhHCw/IzQJdgnG9SdyRZBK+p4YNk+hG2gJwpLvFcBYjJOy4zEYaZSSfeC47svi2fWCfLdvRDgyS5Y+/8jHQ55H3KP07TyhT6yJuyhG3bmiqMA1aVtXZ0NmRwT5RdB12Ivn8MuXeb2kpqWnIBQ3B0kpsV3A3ccJfDqFWdige8zgRvVlKLfKVfHXQki+MpVhdMCWsxAiOqMzZA3im6kcyUE7GuwxMNbZn8q1TOcYDftDOzcZjLcryU+0yqFrRirNcE15aJ4u0KYFxqAhxFXmb0lZ4EbZar4eunDAiTcIKMT+Lj/UtspF/vC5g2JhGJqnMniTqAOVTJjTb348GYBPdyXBa33oJHN4sGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(6506007)(186003)(4326008)(54906003)(66476007)(33656002)(2906002)(66556008)(76116006)(66946007)(52536014)(55016002)(478600001)(26005)(110136005)(8936002)(7696005)(86362001)(5660300002)(558084003)(8676002)(71200400001)(316002)(53546011)(64756008)(9686003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-4?Q?myF59c4XUc7sbHGJXrntx6hd92Wcf+AqxNBQD4yMKbJZvJscJBkEmgZCFj?=
 =?iso-8859-4?Q?2KEq7NrnHanENTP6LDbBV1gnFDH/GoCxySHLYC02LiHyoD24L/tlNEJ8PZ?=
 =?iso-8859-4?Q?xWcGaOLTIqB/ZREFgul2/HZ5kHtJ/yVTW9+1btMHdOD2pMsox9MgI6jMOQ?=
 =?iso-8859-4?Q?3AQwtMcu+mmhQSOKBNZ/EvVlYaf5Hzj21SEc1cdnyMC9v5KkQgOgsSxtLR?=
 =?iso-8859-4?Q?xtnRD2d1wARielKX3mSb7sz+BXtYl9/eTzKg1wKZxfSVmkgXAaU6Xr1fSy?=
 =?iso-8859-4?Q?3abgkHSJe/1i8bQjBcvQGJ7dreffjQHpHROfhVzJgdDCnsJGqyvI9BMSAn?=
 =?iso-8859-4?Q?jtDFxtjEy6CoSR6qy7sZzUYCjjtLBsf0kgdSK7jbQYinHxtXcIwhERYK3Q?=
 =?iso-8859-4?Q?slb3QafKHvmu1JHlzYEy3e3lxzD77BU7EntDRRJCVcNa3Mi/6gcjIPFyub?=
 =?iso-8859-4?Q?dCYzYeC8FEDECfP/so/HRraLrLMVHcQlmSTFLJahh3yQ1JrGsIVxADlx5+?=
 =?iso-8859-4?Q?kEH4fmCEeV0RuyV0sqplmvB9T9a9vi2QeJUFIfCj667H6qMs+Gf6H/vJ73?=
 =?iso-8859-4?Q?O6NvN09/qStwtj8PmYm9DGMT7Q99xx3RNXtrnTm9twB85t8LsoRhZrszg5?=
 =?iso-8859-4?Q?gX3LvXlKIJt8BMbWmIjrBP+y8r8s28zfrT6+orq9rKGFvAnffmlV9JX0TR?=
 =?iso-8859-4?Q?ko1I3+60GrDh6sjD/AZu+Z74Jw0C0ZF6IJyQ9Phrmme/dmRV0ryxqQy9gN?=
 =?iso-8859-4?Q?Qsy6g2sw0jdRjWVdIri50xyol+nTd+Cb2YKlM1PnEzPoIZDKfS9GXVUxsQ?=
 =?iso-8859-4?Q?fXfbPjq1B7jPiI6rt+QXg87sC9oY9GnEMf5VTpVm8B/cpK8GLwcYjYF107?=
 =?iso-8859-4?Q?FwNcpLVH9MLiRacoNEeEYlCY5/98RR4RYOt6Hfki3OzF/pgHw+et0Qd431?=
 =?iso-8859-4?Q?XiakqArjQAdghgO9PAISFkKgyIIZz0V2cQDdAD3UQJzcvgswtUKq2b4qZm?=
 =?iso-8859-4?Q?HS4uQEb161cmGfb/P76OX5hv7thFQVdRnX+N5o?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e50f99d-4e00-487b-7016-08d8b9294199
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 07:43:31.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZE5r5buK/jyrGxR0dZq9CySsU96r4ui8uJp7B9JXXYD3aolnvq2kGwmwCxGWHnH6TPSVw3z6T88YF3FMXV9ntiqYuRCrvcPiyJN92rSKKOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5591
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/14/21 11:10 PM, Valdis Kl=BAtnieks wrote:=0A=
> Correct the spelling of Nagle's name in a comment.=0A=
>=0A=
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chiatanya.kulkarni@wdc.com>=0A=
=0A=
