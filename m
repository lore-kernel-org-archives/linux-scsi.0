Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C859C49EA6
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 22:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A190613AD
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 22:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhFXXAJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 19:00:09 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:60053 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhFXXAI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 19:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624575468; x=1656111468;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xvUZSfGDGMofOYDlUCNDUV4HB1QY2FD7xtwlhz6Xe+w=;
  b=V8+/UbSYhJ8JvW/txRmZ/kw7XT6fdUzs7BYwzUKbvyRQwxbiCDo+ym+/
   MM6zckVoHgXV5BcnLthk2BUPehn2WrQ6A9hhf83U+QLBHgttsupx+xVkC
   d35/xaqJFedGGqVbecUmBzF8k67nXgFiE5oI2xJkzjCP8pA63L5CQcanB
   jYnnATikoQHuWNZvlCSrZ5K+gqQC2ILdkra9ygeqG/cfQHMUYWHuJ34Gm
   lXFG0Kk/ahVfPQsjNFsdmlT/ArTkNEOB4UbFnxvw83xrkuUEKI3kcds5O
   /yY5tZiUkOOa+NMgyL7M4hiY5gUYx1n+uTjpD2uAeDYVWDa0AA/+5zWHP
   g==;
IronPort-SDR: Q3A0rdhXK78NNQBl6CySY3IlGT9UWViAZxjs0EX3mFHmjlqP6SSYdEQBh/aRldifiXv+mW4vuv
 2r3sLxxVmRSHKAetdn2hjuHoDKc2359wj3kAVYfEsEiTE00E7jqDDmpo/DoSxDz/Kdjl/vYMo9
 zn3RdvSj74voV9pPj8qScT+DF75uTu40Ari53IQQuchHudSC7bzGDEzMbmRgqmBG2Kd0LING1Z
 HWtQIxb+ITfx4fmG52Qtk0IzMdI4cUIjZWrCZOOmHonislvtZWLh6kcOy+XrfgHba6G03qmNsP
 iKw=
X-IronPort-AV: E=Sophos;i="5.83,297,1616428800"; 
   d="scan'208";a="172095107"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jun 2021 06:57:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOAm8P/TsvFgsqiuuUtOn3avFz+Pnokb34pade7ZzMR7vC+HMkOmLFYgKg/hz9fanC4I35DC0Zn/vmEpnBLwvYAXUA1f+mO8ImSg2LuGgGXoQT726PHDYPJx7wVfGZ+vWJuy3r/QiHEBOdEbtuE68kFM1/xZUcaLLth1Lk4TwinjqpuAdZA+WSUj8AOP32Cl0ZgWWG9PoyPJcpmoCFQpkZa/fA1dqu+MWp9/vpOSqWNy1PGnRJEQ9xYV6idc62RW7sm4pWG1dm8WgwQMFS9qebmg4wnwUTKFXAJQzjkLpmAbM+lIdN5FXaJ10NSIRDjNj0+LrRkd/gnnWAuLuZf72A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvUZSfGDGMofOYDlUCNDUV4HB1QY2FD7xtwlhz6Xe+w=;
 b=ILjQP0yd8YwQjwan0wikGD0s8xOjpqE9askcTkeZJBxTL0OvNQ8K+YwkgAST4mOb2MZWtETwE0upwk6uuJCR5FsO40e5VwvmzDbRxorqMjb7159obaFTTbwqa8/suj1X0lYh/gZpSMco6qhPJ7/APJT5YhrF3uteBg4nh7Fje/BQRQnrTGSQfJeb9TnhpFyk2MQ2VrzDELWBwIPyaVgHHxQ4ZIniPLZVU1hv9zaTkd7ek1sN6CxMeoIAVfot4GLyTcMzXSuyfqD7qFYdpeuR8WB+5DLYU0vv8tQFe2KDMMYhpwv7/s4CVu09F9kzd+aDrjDO1YQLVebffJJ4lmlZ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvUZSfGDGMofOYDlUCNDUV4HB1QY2FD7xtwlhz6Xe+w=;
 b=OpfOdlrD6yqOAdUA/xKJvFS6BQWMOxX60S2z2KVuu4B2NqlgsHBJkU8Cc38AG8g7c0oDZ+HY8xdtArZzGrhGNnTajJay5eJqJqkcVEqmugxOR/SuVJZPAXOn+UjxZcDgTsxqER3YGssJZ4isPmWUQkb1LWDdSxs1pYhDJyDQnoA=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7390.namprd04.prod.outlook.com (2603:10b6:a03:293::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 24 Jun
 2021 22:57:44 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 22:57:44 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: remove REQ_OP_SCSI_{IN,OUT}
Thread-Topic: [PATCH 1/2] block: remove REQ_OP_SCSI_{IN,OUT}
Thread-Index: AQHXaPYTe40vQEid/UOduABFoqYimA==
Date:   Thu, 24 Jun 2021 22:57:44 +0000
Message-ID: <BYAPR04MB4965F273BBD2CBD0958B44FE86079@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210624123935.479229-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe13a4e5-ea8d-435d-4592-08d937637a7c
x-ms-traffictypediagnostic: SJ0PR04MB7390:
x-microsoft-antispam-prvs: <SJ0PR04MB739070172EEFD678C4B7915386079@SJ0PR04MB7390.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DE84yEcXN6djy8f6e75wyFneMx3S/e3bwEgTWON37s0Rx6X7TuDppRduYSHBIkShC8IcoE/y0dbfZu7k+wqDc8oy8s0/LXZusO4hC0DQpo8GUnZUVq4cn8ZUfi9loNjvnzpWq3cP55wqxBSCO2cx9rl0DS/0KGQaxtYrGf0o0UJU3VTTmEouWwWSydSTJMiSAumZTLvtOr6PdO1OILUV4ngRtm3qdAhFdLmz+dLNHbcChFtWMuuc3cyh3A/aZxwCWNqW2XDx4ifoC44O6Bgh0UkcFZTFNHqFx+QkbvaTOWWV71s3NXx1e6T22ywqX+Th6SsL/WlO0OH3GkZ6onh8o7vta/t3fbjOawDkPcANyj3lqzRWMfSof3CgmnR1GroUex8LYcj4TiQvOIy95CI+F+V2YaqPqrGSllqg3PXC/3kb2H/aoZostOMPu0nepnNMXNHs8Cp5WAQhbG4tzJ7tINgsO90Dy3jilb2K2zyZI1lZotk4oeRkUfRNy7phfg0vNceGElqXa8/AIzeV0W/Mab7qFy5WVffA10EtHEJg4H2hf7mtFXBbd2F0ruEZiomPNExpUHdRR/vp9nGwSjfMIlIJRgpVITPvo4E0yfuC0Y4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(76116006)(55016002)(66946007)(9686003)(26005)(8676002)(4744005)(186003)(38100700002)(2906002)(5660300002)(122000001)(110136005)(316002)(86362001)(478600001)(8936002)(83380400001)(33656002)(54906003)(4326008)(7696005)(6506007)(71200400001)(53546011)(52536014)(66476007)(66556008)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jmMexB70tq5wqeaGJ4SNH0O9FOpBusBelVJnCiaXAVrdt0YWLx+kF/azhYdy?=
 =?us-ascii?Q?iuMs6gIDp7hH8ToMvkwZKkZbyMTYgBN+3KJjGj4wuUkjF8KAK+hhLCj5arYZ?=
 =?us-ascii?Q?ojbhYjrpBMjBX3JrYpMyqFhOjFqdhjwiCPIK313s0cctnu8eOf7a7LFq9i9f?=
 =?us-ascii?Q?fU2CJ/dvrKF5g7oR4HoEuELjrbJo1Hx7Ya4aK9115v5t9CPpr5FYmjpBvnOo?=
 =?us-ascii?Q?EA5oIRKnC2MSIkAnosB5w0P2pBbo8uOLXgPnPFpP3lKt/cu/SAkN02sSOSRR?=
 =?us-ascii?Q?ypJmav+a0HyPY7sw81tSiJMzyDvUi+RL5cTBg8NCQTOC2HrFfIg0+vBL/Nzn?=
 =?us-ascii?Q?WDCBzfPJUEhBTjEjlk64a6Hoz1MeY3sL/1TBkyL/vJBBHsgp//PMrwZ319s+?=
 =?us-ascii?Q?J3nLOYhU+bZgYgZh3FMkF78BNvIIUi5MY0Z0Dxiw7w6j/d7N/S3s6qMS0p9+?=
 =?us-ascii?Q?jG9i53kXhxH7ZeYmk1EeJeCmhDHoi7ai/CQbobH8eU2JM9O37OgJq/J8C2vM?=
 =?us-ascii?Q?4Hur8DQDW99lBg2lBQWh+h/sbkHywAnD+W2PfeG9fGUzpHYDv6jHsKitw1BL?=
 =?us-ascii?Q?grdLZYPDZQJztkiMbuJGTNYU9+mjmCamE5+jA/HYViLTH4GyXRmOYgVs5960?=
 =?us-ascii?Q?Q6GaIrAXKlOvfrBZD6vQ1uS3aUWqvdCD9oSGg62yLKVJETnFPMSy1ZQTI687?=
 =?us-ascii?Q?BkjQEh+zReZux2/mLjKDRq4xYD6KC+h3j47vn8+IYUHjLfCym2L9f0fsOVNy?=
 =?us-ascii?Q?MWyZWJVHhEzSSGWqDnPYSxcchiYfQTjz4fWgQWGv0Kzr+pFDgSq+Km0xfVVd?=
 =?us-ascii?Q?Yrm2z1WJlIMM1VRf15g3DDEzzGdYJ1mWGRgdkZH3cbHwVSBQnAgkqHV1e4oY?=
 =?us-ascii?Q?GJGY6aW1U7crOnuWhIFjhzRK9JpCHkhK9rJJa5Q7FzDSodC7oCKEhDEd0O7T?=
 =?us-ascii?Q?kCQiZqA5KPnTvbxuC99+bEwruUBv9FCZ27IeIXpY4neRBSOE+UnON04d66Tw?=
 =?us-ascii?Q?CmPg1x3UUGScUq313Wbb5NBjNGLE9T6WcmNtA+4qrCqcyNbX2joMNXm4pbpm?=
 =?us-ascii?Q?RKVKeNSGEejc8jPkw7ZIxrzRY3zppdB9cI/gWRv7HgvSJ/fKqGZongkKPUmG?=
 =?us-ascii?Q?aRYSbY2eZ/taEW49b9oLd18dDyGqi0rRwAmnappqoHxyOA1YvR6vLRQWW28Y?=
 =?us-ascii?Q?/Ani6JBYpLh4a0g+NzDxwSdB8LQW4546VVvWSSwXPLx8iInzLhejh1gxqyKn?=
 =?us-ascii?Q?ak375eGvTH65yijzhjj2tmO9s/X3hfhYJfn6V/LusdmijbkdWMuRyGe4Ysqi?=
 =?us-ascii?Q?JoiFD9QkFtk0wyhpfEE/OEhO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe13a4e5-ea8d-435d-4592-08d937637a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 22:57:44.5020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UaIF3my5Mpkf4kt9MPip9AfjW0ethKVMk7QWrI5oK0bJUyRucxXemvJQOHbVChlNqQ7131hct08ey4e2C4MapX8HhekvbPkFz68i9BcmqAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7390
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/21 05:40, Christoph Hellwig wrote:=0A=
> With the legacy IDE driver gone drivers now use either REQ_OP_DRV_*=0A=
> or REQ_OP_SCSI_*, so unify the two concepts of passthrough requests=0A=
> into a single one.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
=0A=
Nice cleanup, we got two bits free for new req_op.=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
=0A=
