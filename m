Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF06C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiCDJaA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236851AbiCDJ36 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:29:58 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF3615F088
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 01:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646386151; x=1677922151;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=HIHYjBLXuba2vRnTs9PYbKPDRAA9RMbMJly1NGKg/3tS1K1np+1tAWXf
   i13lSmdbcbbWpFrVG9ci1rnylkddIdoMDsAOyzgcIncBEvltUeQSP3aBA
   EaLOuzvnSUvSsbBkmP2iCwYuip7/SukTsk7eQC/OJRtf0hRRgdAE71VLC
   7f/oFKDoidLBKY/hIyjB0NsCi/Smj4CMyqJgkQri5JlWYxu6vbS04KDfR
   bz/oPbWpa54+LSIGqcoal27e/ouedMSixbGe143YOyMx5h5eH73M9hk2i
   zl4Ha+HrfOJvn9FDX0fDf7dumsJorghrMsFs7MCWzBofZvQ/LEKTrfna/
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643644800"; 
   d="scan'208";a="194484076"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2022 17:29:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMFRwgStGgXrSVqza0wZ/9dal/HwfjXx6ZXwR5pPbfqOzVUVvdE6GrG+LC5UZEUC9knmdCMZN1EspvONqdW9Q0LZvkyHL3YwTP1kpCduvxg2XpVO8d69ygQozSL+IMl+Cpu7zsyeVCXoJvgr8zHstpgZPlsQBQu+kazYeF69e29+eqN4FbZOnv9KEjoy1XpIjtm2PlgZjw6EqtWdkaIpyIsoFFETSnOH339xoNq1Fr6i2ZWpvBuMnFKzKuBcuVNQvbG4yYa6SOwKl7otWice0QYilSm51zeEN0MHryX21VofsyoXWqgyl5IxEQMR8tW+gGVwbO8f2m6TygeTc2r+xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=WhfjrEM9DzxilH+k/dZzl1hgBbLtwg+/tzjdAeFPN5lPGdJBUUd6cxbebqq0PzoBw023yGe7XBtCs4No7CMWXBcx1xe/xUO8prVtJD0Azn1LNYR1ktCkHBHdDSOk3RzFVEuPGT5B0Y99j+mNgwdL0+DzbhhMdNXQKLgToNP7RadWrW7Vb1PSoUSH7vJNsIoeleA+KhWl5pvUAK1y+eEe07kLdpPNxnj86BAuoIf66bg3F4QJLXuPv9v4j+tngisJlOp2vB69QHaDRdKHCMoYaUAx+hljeb4xneRjoA2YIEha4mDDT2Qx3OrSIiYh8HUghtdmsr38+rW6CNnk1BSN4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=HIPTUAwgn7TZ35HFsujlCpOUytrm+MSKs5mN5l34y1L5hoiIe31C5KaCGdC58jb/PPjZlvXUHSCu8WSvfYAvdIa4kATdrBneBwqLz0IMUv+hNjnwjjyY9hGEk2g6Dxt4tdNmAgODG72vsD+7+yOyRnsgPgES8+Ecd9DgqmlNmtk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM5PR0401MB3703.namprd04.prod.outlook.com (2603:10b6:4:79::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 4 Mar
 2022 09:29:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 09:29:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 06/14] scsi: sd: Use cached ATA Information VPD page
Thread-Topic: [PATCH 06/14] scsi: sd: Use cached ATA Information VPD page
Thread-Index: AQHYLfeA1bgXtCFY4EODDdxzuqEpqA==
Date:   Fri, 4 Mar 2022 09:29:08 +0000
Message-ID: <PH0PR04MB7416A2A66B7E96B018F0C12F9B059@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-7-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc4503f2-7531-4cea-6613-08d9fdc16f06
x-ms-traffictypediagnostic: DM5PR0401MB3703:EE_
x-microsoft-antispam-prvs: <DM5PR0401MB3703DE9507420879A81F26B09B059@DM5PR0401MB3703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bqfmS8KIwXhLBCl2+cT13+FWrhL13j77ff68ok5Iz2vIiML6Yrc3nEW/odo+3mwBr4WtBVbiq+GH94xtK9g3/RMRBk6eiUFLJQJb/21xxthIGAKfPasYpLJxlV0g+OAQ0gV62zCstjkaGb007W18l48fjRMSMSsOf887loTa8CtPWqn0DcamqkZ6JHF7F7kqI7dazeCalMdc8ssDJqE23yKPM6riy/R4eZAPGjI3zTfNEXHNrceCBJQAIf45gX3k6h3hPEwq5wJlEtyB9+WSufNqED+k9EktUsECQr5NhHBH1wCojpBx+hfZygUZ9USDL8s/KLaIZtNn6uZzI641RFcfqDSnJjcmSN6s0Prw6u14boDnUJ3x/RGE96HdPl9X0Oh0tSU4O++Srn/DrxTOXFD9X8q/G1G3tgg2RZNE2VmzAy/cSAh07Rst69W721NL6MEPHiUyvGz9krOiKIfaANOvi2iqsA+12Me8LhJr+SP7jJnC9GqMaxjKa0BoI8iAgpl9WkA5jBWf0M+ispR3Na5NArL3BNmGxSlrzhlNzhHRg9gkjIJPZqgYasUsaMSdGLPrGCUtMSoPTrFgji0ZXFVW8LIxm3s1ouaP6jsB0iXCpmc/JvtR5IqhQk/vhUTxqB07RKMABiG4jGvUGiw8dBMRRaSypJvGmmf9S/vTZTMSJsjBc7v500YmwrbTuTxQfX3nFRKe6sBLafEkFg4jHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(82960400001)(122000001)(186003)(8936002)(5660300002)(55016003)(19618925003)(558084003)(2906002)(33656002)(52536014)(91956017)(508600001)(38100700002)(66556008)(86362001)(71200400001)(4270600006)(64756008)(66476007)(66946007)(76116006)(9686003)(38070700005)(66446008)(316002)(8676002)(110136005)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Vaggp/9lliqQxehVosAsDZoTWk5fjlHKjJ+gQrZyUg+uUFva8WY7+QucXrV7?=
 =?us-ascii?Q?p0tVSB3Tz2aEQMxlTgfee93mLawZL2M8Hgt5Xy1uxCikxWhgtxgnfQXy8V8r?=
 =?us-ascii?Q?DD4n+aDwBziUWfBC6w5aLEzu4jVy36UugVXZ32+h8IcK1euoTz+SQY5vmIbi?=
 =?us-ascii?Q?p/Q5q1uTVRDxIS7j1MlyV3Jb3iizncyXIO7oJWEuhKk91u6CvZ1DmD+JQAT3?=
 =?us-ascii?Q?qfjFbFZ3YKb3IbOFJlB9X5Qkr5oxuDks/HcewHb/5lDFIPIw1/wPcOVjRpqO?=
 =?us-ascii?Q?gbXnKBC06/O349N89OjNkxva6Y3hqyOolFZEfNGRZLh5NgaK8M6Ajbu4yiNB?=
 =?us-ascii?Q?8tGKRyhOpqX5pf1u3QM6Na8DTgqOu1FI39V9225mf31181w702lKBCdx5saI?=
 =?us-ascii?Q?shm6hXn0+DaSLLMJ6iCS3EG64R1Lkkhz2aAVLZ11tcnT8JEJunWqHv5rnjSd?=
 =?us-ascii?Q?pT0qolDZQCuQifznXmYrcLHDN4G5AH/Nr51Cb5P+4rKdT2yCy1Q1rNrnEYKR?=
 =?us-ascii?Q?VJsaotSxg6pH++YW6hGRloC9lit87vwLy3rVkjSMH15fra1DoN2ecxjdB2Jt?=
 =?us-ascii?Q?06RfoMcWrjvzcGCBYzHMzYqenwf3iwKlRV/mMN2FaAxfrFIWm+PAzXYdz6Y8?=
 =?us-ascii?Q?tWnK/tv80Rg2lxnO+j5wOATNvHGG2N3rUJkGLTvHaePyKnmSOpHqBbFOJFyC?=
 =?us-ascii?Q?EEkHXTY8gEIasrm1Sl60CJdLtRaL4R5vVoXi6vtVW7QYoQAiux7/wUby5sAz?=
 =?us-ascii?Q?J95pnXAJZ5UJRswRIq+3dNjzLHGXsayPZrlUN1lbm/ai1tHT2LZnD4IGGEy6?=
 =?us-ascii?Q?sX4K1YTLkk44lHMMBQ77MITP9cleogVt1eo1JI76SEMFyFHMh8853Svt+7j7?=
 =?us-ascii?Q?J+5ogmAS9EnhY9I5OSQjvDQw77XRe72ICxkPHNZxdx4ggzVhVfG/iyDvrCjB?=
 =?us-ascii?Q?3mECiWOlL1Aj5TJeWp6577ns0JUWvKsso6JhSsY8H/6HtCH1Gxm+RTPWhH9v?=
 =?us-ascii?Q?zJ793Phr7JRZsZ+USSi8kmRfrJnbzPIRLTPZ8F5x8ptuP438iTF6h4LtRgyB?=
 =?us-ascii?Q?R4/9AX75hVb6qcsLzmKUgbCi49bODP7LAIuy3VPmIhoxAVQBzo4w9d4ewLt/?=
 =?us-ascii?Q?ezOJS0qRLnzDg9O4aLbZPuAfCiBYpL0nZHzleXey1SWnkhbXFA9TKnuE9JTJ?=
 =?us-ascii?Q?bOOx55M5hN9866bdcMsXSlD+Wa0rkM7JzmZY8JjUVDUFWjB4oM5yqIdFOBd9?=
 =?us-ascii?Q?i6ETf++YF4kVoho/sbR/zwMST4M6ZMxUZC+hn08X4p7nk38OEOos+9oV487C?=
 =?us-ascii?Q?psnaNBUuarqy37Uq0V9CzpGOltfRjS3e0zRq9qURWIzIkfCcU9gI/o6UweWP?=
 =?us-ascii?Q?Tp9W1bIldQd4PW0I7MLu8dihb3oETuIe6SqsVFZGvYcEbOm3s+1A0ugClESt?=
 =?us-ascii?Q?tSU/wjBD/XVuvh57Db/UgxcCm8j7g2ZEt9mrmp+QTofvLi4pJrekfJFKc+1y?=
 =?us-ascii?Q?YBU7vfxdNexFM+NmbScY02yRDuT8NOT3/NEr+5EltEuVfxITP1gjgcexSwsw?=
 =?us-ascii?Q?WoU9Ozna+1/SA8dHS9BFl2jPDSuwEjXWiDjyuwTTFStpxRwJKG/JXb8AShIP?=
 =?us-ascii?Q?5E8x4IdZOya7oymfeNvWgIbl2A7omJWy1+5YZuQmu9d5Af7EemnSwg/pIZcR?=
 =?us-ascii?Q?zoI+YMVBqt7sd6bYKo+97Fq7MzrNhwBXv5oMJ8ZGJSdbn+OXyvUTV/RG9LQU?=
 =?us-ascii?Q?3wrNMKk0JgmU4Ro1KK0GHcSS6oDleV0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4503f2-7531-4cea-6613-08d9fdc16f06
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:29:08.1591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NflH2O4XDdFuADBWcdoXGi/mWLQlBgrpDaeIV4Iz5GRRAAbYYP1+iZo4teBU4pWZSOlaJvp1ZNdPcVfSgIB0AO7a8+M1smv0EXl0ITDepU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3703
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
