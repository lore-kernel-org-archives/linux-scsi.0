Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB9DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 19:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347805AbiDATpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 15:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiDATpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 15:45:06 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7201D2047
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 12:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648842197; x=1680378197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DEXVeMJFlpFRyH7aq9gLWv+3J/llCxlKlArsp7hStvM=;
  b=nPB3WA4/jytVkXunXLFzhNqfe0mme4ZKBtvkB0DlqZ4A0V8ElRdTNFT1
   0o3ljiB+3rJefHzsbYOu3N8ZXYOa48fa6X70+Ft9z0bDFPYPKkrd/hLoE
   X6jQ0krh3p2Z0P3HnA47jxtI0/krPOLbzi2itnG7+2jmX+ctlX7Jy/DGS
   q+KEdPCJx9yTyU/GzJ6R3aHP8i613kY7ULubJp6oU6GFk7wfsH5FybXiz
   ahak5j6FgqfJwKHm40w9im9A4v2YxD0se7h6t594iL0pOkNsQNxVTFyps
   xOuG0dnPW/lzCExqgewEdAX2B7Ky3195K7ZGNmOyTVyIND5I4kFRe2U//
   w==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="197778819"
Received: from mail-dm6nam08lp2045.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.45])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 03:43:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK+MdbePwg11+7UDGvlK/m1GeY8THghx5uasTbz8WAZruzJZ5Z+GYGQzi2Nc1dRUPHsDZpoRtnp3XPlUcSHXcCVs5oi7gZ+2GtXJSat9FoPQ2kxYsokIF6BKHFgweOUCZ8LhwviVRPySgHMkj9EQSlJEWA7tp7sLwebbHtQIVJ+6xIDZGQ60pJgA1YNJbD0I6FMYwdjDxs2yjbPhT6Zj2tr16dq3MbeUqmcVchGyTteoCQ210eWEy1SeDpbEh2apy8Qcqv11/PZUwmKHgPJtNqespmxpKFJqhdtHLO0J2XhwseGrtrooxgZQQ0edyx212vc331xrBmnfde21+1ImpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEXVeMJFlpFRyH7aq9gLWv+3J/llCxlKlArsp7hStvM=;
 b=dZIvRSrHcTqyLp9/ISj+B3SHcmsK+DgcCmLMIwTpFUxP/ql8WwdK509zadae6ryg4EpGlHXyRnWyQE6GfFZo0n7/eLVZviG2a00ibvFdnh/re+Dt744g0nG2INZ++TdtCnw8m4kzJbVwsVRkLSxCWJ5ASqst+EOHs5foozXtEEQV4PeKjH2JrE5GLlYM70mglJGSSZBYSEHihTX9ekj2Bnfh9Q3TkY8Nd6rvQu3vXSwrvjSANoEbhm10NcC/P6psGm3fHXpvOGGlZI9k3hDs1fBp3R8JuJPYys6R/LqjrIDO3I2QI9k7i1mTFNKRAQcvNlJk9t00VyzRZwsALxIGCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEXVeMJFlpFRyH7aq9gLWv+3J/llCxlKlArsp7hStvM=;
 b=kzFuCgI1th49tEBQttPCJ7RKrlKeIDWQUAljytji/J3nrHhL6T2XqVLDkO/XKio/HCUP6APm2a67dRwEIvGsLhYxN8FC/cAlAP0qd8JVlc112KaHQNG1b4Nu4EZinfZp0MOf0Ksw7A0eLJ9TS9uyVkfb5ZV5vf+eY41YN2kJZGk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA2PR04MB7691.namprd04.prod.outlook.com (2603:10b6:806:140::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.28; Fri, 1 Apr
 2022 19:43:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 19:43:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 07/29] scsi: ufs: Remove the UFS_FIX() and END_FIX()
 macros
Thread-Topic: [PATCH 07/29] scsi: ufs: Remove the UFS_FIX() and END_FIX()
 macros
Thread-Index: AQHYRU+pU0bDmWIbDUmwp8lUv1VywazbdqKg
Date:   Fri, 1 Apr 2022 19:43:13 +0000
Message-ID: <DM6PR04MB6575FE430A5071AA1C6D9E3BFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-8-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef5cac54-6386-44a6-4408-08da1417dc17
x-ms-traffictypediagnostic: SA2PR04MB7691:EE_
x-microsoft-antispam-prvs: <SA2PR04MB7691C829B4DF9F8B37408D67FCE09@SA2PR04MB7691.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUxRnERw4gJ1+O7srI2r2APbGGLSKxpRdkW2TqjwMXyJtnMLyvnueKc7QlG53A/OjqgWPRIo5vX4SRxkd8qnpX8AJiWDKrYgNa/sxsB2es3ogdBTc99aUz4mQEPUQ27MZ8Z7f7q3y+rvsBy3xUu2Omyx8wwtdoE9oA6OhkMYJyQNf0fdg2a1qbAhoTwhzSvuGpwW8GDLAtYKyma4UiV46tz0hWVzBgPHgyrcIpoQrHs1Ho7ojPR21Jx3s36Nr4pL0GU7QIvgmAj3qce0KngJ4W5l9WIRHWHnOdXp9MFRKnlBM24kXEpMpFlaP27mMVAO2EeSnRJ/d0AcboHT7fDw/u/wnqeWfIwhyr0esGUduC564zZGFDDnS8nrFpaDv43DNiq4b32GwVGDp7ZHa8IBnBdG+whXK7G5eRC/PAssN89cXNB1ktnL/pZNCK4M4xE3cLM7GMpKSwRyoVkUjT0kI9U+pi7UfJkCmIo6NM+AOV9eSejBXryTknkvEYXfbG4+qlkAI5fO6tEIu4IpumQyJ3AGM00F+nc+/kO8IxnRCr4Zmz3jNLZwT2eLbfV5RIaQ60RyY9KIOKqoqbovCGEghYqNHnZ+X192i5XIdSUfIVZeIXweaORCqqVG6mdzI7VM8FrVdA0a07LHKG8iMAX1AcaR8HypLv4+0JyS3mQrrJbxmd/fSvhNJ8N29EjdbCXrn0A35cLbKX6HljNmLWz5kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66446008)(38070700005)(66476007)(66556008)(8676002)(4326008)(82960400001)(9686003)(6506007)(86362001)(558084003)(2906002)(122000001)(33656002)(7696005)(71200400001)(5660300002)(38100700002)(52536014)(8936002)(66946007)(186003)(7416002)(316002)(26005)(508600001)(55016003)(110136005)(54906003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DpIxDzkXX5XpZbuWnQ+zFQdg4kzFKcQZOn0uzgRF9CnVpSwpt+TkalWYkHCY?=
 =?us-ascii?Q?JrGQPshJR3cyY39KPV39B7IM/ZsDRpyQHD7bXLC6zWvs1uQAN9YJcb9zvzp9?=
 =?us-ascii?Q?OEOsoQzRLOzX9EyAHlR79zfzctbCq9OqKWXl6WitHYyOgBGrMqjtx7/iPU1t?=
 =?us-ascii?Q?otcq2HzuKngj3U62wUPDCdYztfUy41MUXlJFVZJ0vSt45pJUQ3wXK0CGWT4j?=
 =?us-ascii?Q?c/b+wNOohdPpDOijrzEAkrN6vZ5SDUTNqaLuSfOUroNXxptylP+fMATu/rOi?=
 =?us-ascii?Q?nli4OX9d8ymiA+ccW7zWZlY3oUCtCDr7mkKdc53r4pcinSXo9np1jL2cztzi?=
 =?us-ascii?Q?eB59hCGwLOvj1JJgqpM8Hl+5ZxT7wxFUqeAWeQb6YB0qSPU2SXKd0/AMh9vF?=
 =?us-ascii?Q?AvAtNLBxvaseci9xHU6KsBDSn89lB+DJ4WF8FsWdhtfzHzSrV/7dQ6xDgtCj?=
 =?us-ascii?Q?C2wmDKpSXUqrxq9n4NTQ/9XUCijwlYC7DHekuRPOV5SEJIwlA0daSgAKKim4?=
 =?us-ascii?Q?N3xN5JIzqj2Dy5Xz1cJF8xglHvUQEy/eGGCPIkMm/4PkLCdCJN8Ysct1eVyz?=
 =?us-ascii?Q?rJiAz3n4eNdlvcX2eoy5qbnQu5Rcf7cbwfVjoIZH+cFJMb/qa2+wqKm0721u?=
 =?us-ascii?Q?keNOthyIwLC8q9WiPvVlZyM3vpyGuEOGZLJDs/4y3Ww4aRlXKXU/6BvFh2p4?=
 =?us-ascii?Q?xHW389ZUtEtn0hIyj+VnVv082XTbV9GRSz5/JzOLiuSKdw3N0BgwJ4p4ebqX?=
 =?us-ascii?Q?n/ZgSY0b6h7t2S8yZgJqvnPj4K07w5jU3peGCeKY7kjvwSv0N2DgLanbqGo2?=
 =?us-ascii?Q?IuQpi7aBXXAGo8M4q8x17S5kx8iIoYazxyiaSUeCMrPLXU4EOIkPj9MG8/k4?=
 =?us-ascii?Q?cT/G1DvaiN7HDaYRIFw7gTZH9gIziuWqiDyd8/1aj3qQ1V/Gmoh2netLNte2?=
 =?us-ascii?Q?9Iott8MJHwXCyykTqKjV4ZZWcTu6L2ald3KvLEYiN+yLFV/JKKMhvcpuBKqQ?=
 =?us-ascii?Q?m0CgfqvjwfdJmdYtoF87YP5KJ1ucuJ8lFb1QQIq3EorZ1OIgL5ZvdHOoUFap?=
 =?us-ascii?Q?1eEtWof6Fd9BhlOHygqwiQrbUrm8JzW1SmzNJiqyla9wobHSsGngi9fs3NHz?=
 =?us-ascii?Q?E4yLHaamgEnSmDPBFFj7YPSpee4hqkTQbN6IistGqcU0lE16jUQr+qT9tz+l?=
 =?us-ascii?Q?xCbtANBraJ4gazot8DUnrBoHQsxiXkeAJsBPFaA4hC9dLdXI7KCbkVNaJioE?=
 =?us-ascii?Q?6mwNnfITTp15mjfWfix/vQuazNF3WDGKHgsvv5kAxMcmJmrXOSi5/AkDlNIk?=
 =?us-ascii?Q?iIB84iwmd9crKEUzurgmZe7DU3nOz/NUlmevUR4d54bVkpReqZ2YJgbDOEZg?=
 =?us-ascii?Q?earshcOMs+P5AkYgEltAPUqjz91En93xCOzWkK+yj98qDNIwCgBCrCd2Jzsq?=
 =?us-ascii?Q?jikl4n4HCNMW1o8kDnKo1AL/LomLW88jbpHe5Pxgvay1mmggT03mlo9F2cuv?=
 =?us-ascii?Q?9NWn8oGcaXBDrF4qGa1kOXDqyfBavjYov4HovxvYhM/MCbYKoR/+Bml3jUOF?=
 =?us-ascii?Q?IWhbIdP1TGyEJRDNejpftQOPwejqO//MR3sCzyA/0/kWdtiKLvdonjus2QXB?=
 =?us-ascii?Q?1T+scdHJGAv5lOyBZyVwyx+N1wpDVUGgxuw7AQiLToZaC7R1zDAyl4APrBJ3?=
 =?us-ascii?Q?KoQdhELW1uDkKQUX9ol+3XjLw033MpmlTQX5VCRqcCS+G4tbsaLfEjRlhqTI?=
 =?us-ascii?Q?B0EdxXOmVQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5cac54-6386-44a6-4408-08da1417dc17
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 19:43:13.4568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hnhXtuB4bhZwHUyotXDtiK1xC8+IxbsB1/J9/Igk6BlBObu0455EBmDhO+nRNUJMv3RSONd0f/9ShsWZeqXVUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7691
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>=20
> Since these two macros reduce code readability, remove these two macros.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
