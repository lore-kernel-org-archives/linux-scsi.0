Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E8FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 07:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiE3HpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 03:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiE3HpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 03:45:00 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCB318E24
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 00:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653896698; x=1685432698;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=Iz66ftkOR3lDqleoSsrmJG1gLSylTTWbjP67zLCq8hhqn7LSKv6N/VvP
   uw5K1glSTeeD7nlFMleyulwZi8Inxulv9QVsetncNLEIfMgC2ImX3KSCf
   +00uF8YakktzvC6cZ4/DtY8rV7ClCj7Blhw8Uijks7cRApLRpBqGITmke
   vWOKrjnWK5jkt97JjDSzDbLMHUMQBKx4FyXlnWTi3yUfkCT9uvZ/ezew4
   VkHgaNwWiZT4VYvqDYbWof79WFJTo25F5CdxPRtDrewDpjqldYH46IO4h
   GLBdjIoaE98DH7/cCpwpjW7OlYcUtBFRanEJLAsYupxTzPpF301BJOd1A
   A==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647273600"; 
   d="scan'208";a="201782449"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 15:44:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcnNXoFA5Rw6QI9NB2SFZWEbZIChZG7TvT8V5w++ZQnqhmAaj/MUmrHaX/9czV5HiE5c1BaIAhPBHm4T152IooJ0nG69RYpF35mML9WTu7N+yTtA6dWFSpa143NkJOFamJh1W2f3486NtM+Tc4Jrv0VUx0in6cZtC53vYTUBT7UVnPhUkg/OL45uN5YmC46NNZaBXOYJ9C1FZUyGjNPBsYjfRaLfk+8RDGH/VI/KwCQ2FEQ/f6Td5VjUiHs/tjD4Wj/uowApd8LoYMFlYc72kHur2f6AArJ0bY6BKztpznbjXLwJH1711eJg1hC/pZfW07i4/lAd4qfzTqbj1zU7HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=QT1IqQeXTEVGST9XyUIuKd1RSPwZkl2wyKRvbyAzgYGy5UgUI0QoVZi5zfPeYSKuus5gn5OeNiVd/qVL4yWWwvOWEkWUPqqSdtN4aA8M8vjcsWQQS2lsODrfoXJ9JU1SjwgorMzMhYV5bJO+SER1uUHOkwOO7vck+S8EVxuvu085Zyy443WOFITBn9p46nNBXTFHUrNr49aCaZCqIVIVUkQMED8MO57R195Qj2EY7wtSJwe0fdTcnN34e20gng5pMzoXRAa2i6OtMc8szOcgLORKnbdm75p81EmFQ9xKjNck+GLmwt2KnJ4yqzriDFU0IFGdZPmzeKy1RSJ9Oc35jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=Mufdij22yVaE2btNczInahJF7e6KiUZ7ZG2hI61dta0DGoOOA5ZV09Gb5SN1sjAb/qJcDm2NQmAZ4dn6wRIPxmKmwTohRjjh2N3lldTONIB5xeb+cZh7h3JulPGZPdkGZrJTS+c0bcaz1sqN98Km9+BpnPF369Xn2d4ff/EkofU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB5249.namprd04.prod.outlook.com (2603:10b6:408:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.17; Mon, 30 May
 2022 07:44:55 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38%4]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 07:44:55 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH 1/2] scsi: sd: Fix potential NULL pointer dereference
Thread-Topic: [PATCH 1/2] scsi: sd: Fix potential NULL pointer dereference
Thread-Index: AQHYc8a5Bh5at3XT806PD2sFMEEl7Q==
Date:   Mon, 30 May 2022 07:44:54 +0000
Message-ID: <PH0PR04MB7416D9A91207C48C06B351C39BDD9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
 <20220530014341.115427-2-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 584a1552-901e-4981-d770-08da421049bd
x-ms-traffictypediagnostic: BN7PR04MB5249:EE_
x-microsoft-antispam-prvs: <BN7PR04MB5249CDEFEFE231835BF4B6789BDD9@BN7PR04MB5249.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v2Y+I2ZnZqwNYsQ1jvNbDawtXiIUO3bT0WDP0Hb60LBsrsBgsnCfh3GSLsVEWTnIg6Rirsgb1FdHDpm9M11+ZKmiv8H74IdVj/7ru6ST8ojqVrTbZvARiE9kgr7jFbz22ZuxDrMPVPTFClB/YkOPuZHStj85BsLRJk/aWj0ejBeUw7jtu/95ckySQ216CmaeHaP0JPH/EQpLeW6ClZpFm9M8lLtImHkoal1LUEra1jEXwV8mDvhxt3fbKO8eWKX9y2iNrL8c/TJQBoakFEkeWsXtxiMh59u0bMYblotvaKkIOtEWCfXHqWn+LFPhT/s+QGNeLzZsc2OZGWKtwANxd3BBbhgFCa9u0eUR1LM0l3d8iLx5GoDhxOhfXDLkEg3CC2cMEdflQ6Z8vis9l0T6tXd+qtc0azn0vOjwpMVjSqUMgjFeH9LzxxtR4lccJTNSvfAF4LEFayk4lUMkfQcZkXd+DuYz0RDE+MXoWfAOd0KXvKGdkG1HN87fFVm9zLyLbt7oMVtPqDyZQaDUIGshRyebWqxg17B9U46vh7DLAsWr6iFAEETv1cfK7gyg+Jm38bxsw3uUlQYHndgjgJzuUc721ob2WHivHSDbXl+aIoXCTPVwhRbgOO9amsJeZm6S2dH47QfWirZVpgEFMCg2FXninF3CU4TDZiCoLb0GXqW8KBf54lae0Ms9wzdsNlRcub+divQWPO1gm9a/GEjgbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(558084003)(110136005)(66446008)(6506007)(186003)(38070700005)(19618925003)(71200400001)(26005)(7696005)(86362001)(508600001)(4270600006)(38100700002)(9686003)(5660300002)(52536014)(8936002)(82960400001)(33656002)(316002)(2906002)(8676002)(64756008)(66476007)(66556008)(66946007)(122000001)(4326008)(91956017)(55016003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vSFIwXSgC2bxlNTZdOGdVRTOQkGcdxXldwnog3DeCT9SuLo7i8O1lFRPOB58?=
 =?us-ascii?Q?W3KZE2KBpM8ik5WkSPpOUfIYEMlzjwLSIMSpwko1MQt/2aYU9EcLZRkIkTp1?=
 =?us-ascii?Q?etTaZ407MDlc3ay+DYO1dmvpOQSZ0nkP9jN0fX0u2W/XGzeAifd0ctdiDNdj?=
 =?us-ascii?Q?fHeetBcqwHXOrfzwduIt7+Evj1wkCaOgvH1YjnVfeC15mIFJE18ZsqnokbkK?=
 =?us-ascii?Q?H9YsbFlf+yZnRE5sTfQxKie3vWMpE1iWIxUuQrVQJg2hDSxHz8HVqXauklFb?=
 =?us-ascii?Q?tTDEbFn6E91e2d550GSpDHaXb9CiRxNuOX6plGUL00+NjdTIGsQQygGG28eY?=
 =?us-ascii?Q?JqyBAtVN+oDHGl8Cask7zCe1VzdfaGwijIZ6WrHj80bY1hsvHeHgFXEOsyax?=
 =?us-ascii?Q?+HzTQGW2cC1i0nSakr3xGtRojOlYBAZT+/JZWsif/FBvx2wjqr/ls0qEVfOD?=
 =?us-ascii?Q?Z+IGTrcs6peizic3vxHK5dIt9wIadpuGt4166lxaTFFEE8xCFWnhoNQoalmB?=
 =?us-ascii?Q?3KLOWnGifQeJx1JuUDWxfKrYLHleuVgwg7fKdRoa/CmGTLIErynXHMjHblTA?=
 =?us-ascii?Q?5VWnYGrQvF9zx8RK+KGcdy1fmD3PjhenrBDPkr7ngONA+X4MkGFCSGlEvznT?=
 =?us-ascii?Q?NNleqeloa87FKBGXj6IPDgBRfal0xeLAgj7kiGgr2Sm32g4OUjei6rDSVQyJ?=
 =?us-ascii?Q?kav4/dGav8Z415vizqL34bPJAAs057l+bJ5qbAl1aRXvRszw17Ho7S3lGMcE?=
 =?us-ascii?Q?yUdujN5MuqihrEVoML0KU/Vxev5OLMVJzEPezwCnzqaIw3cVzSE0JKy6D/dL?=
 =?us-ascii?Q?uz7SdE969jmZ3eOCAZXnXecYbKhwIujQaNcj+anlntwcUP27+kCNqUiRRM2j?=
 =?us-ascii?Q?wACkNBacy0moJAhspxEx0IPcq/4OaJOdzBDTYRQLZKtglVPFzTVVnuBz7Axy?=
 =?us-ascii?Q?YfIi95WyJ9szkNvg5YjoZdzmnW1+nMoofGHg8Dx11OnxDxF1J0ItbwCH9ntu?=
 =?us-ascii?Q?aX4I8BFQLtdubE+IMoiaApiWDWnj9uV94dsg49WpWrQojqyt9M7mNCIxUhr0?=
 =?us-ascii?Q?9mws3yCCArmyiIYDLHIknCvB1QeGwaKflL57zdC5/uYjn0zxY2ZONA0c67ND?=
 =?us-ascii?Q?vZZvC5hOaiK5nxWk06vq6qFiivUj2clKNYnAXrADKXC9UYn/nW7nISzPAMJl?=
 =?us-ascii?Q?KrE5kiHYdXRnNYkVKJgS3edCkfIA0ndTMFybnwnvqzMGfQnPswr3T2JzSLsx?=
 =?us-ascii?Q?fAP7ajSWxbpy5T8SUYVmFKQ132OteMU/iRrqq/LVK8BJXwJ0Ed2t/rYID5K1?=
 =?us-ascii?Q?/I2W2inv53tCK8XYM6WQqGg1aznrqEsyAIjbKRt3h8ws3CtvwzHay8SPPAkt?=
 =?us-ascii?Q?slbasCwZ7nYaAaXG+I47az+h6dh0pIFKPyvoC71ILWXB9IoyjGLpOQ5HaYWu?=
 =?us-ascii?Q?h3VjLZ0bByLrYQzJ4qPLwcVqcuZdEuweVmbCQ4tjO8ZIvivaltIDSOf964ys?=
 =?us-ascii?Q?gtIQks3W6MC7xHCTRX42Alx4q7e8ppzrW0EkDVb2oYSOjYSgAxxqptOaI5Js?=
 =?us-ascii?Q?Xnyj1NCWpJrjUA2OrROzcpgxLVYJNemF0/Mi71b/fB7eoVWnq17XQNsP135w?=
 =?us-ascii?Q?kt1Rf+rxd8DEiAFPAUcuDxtVwaVXMqZ/8MNV5Pcpc+XJtmma3VCT5r8GM06K?=
 =?us-ascii?Q?FGwJqCY0usne0LiYjW0ETrI7vON+gUNRshi6a5FavpOAnDqX3bO9w1IDKNQV?=
 =?us-ascii?Q?88svs1BNeP2mJmjTusF0SnGRKi8S0w4Jn4o5sgNigRm5WtFxb3Jb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584a1552-901e-4981-d770-08da421049bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 07:44:54.9966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B+MplzcR8D86P5Zo5uma6q+2RCDEwnawlOcrVD/sRMYtVO17AKIEsNbp7jD+GgTkzpbbYDNHyuli4//e86S7cKMTOaMNP798mdbl9z3uLn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5249
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
