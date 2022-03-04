Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22EAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 09:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbiCDJkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 04:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239315AbiCDJjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 04:39:52 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10191A6FAD
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 01:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646386717; x=1677922717;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=ALrFT2CulxeNY3gf6nsAqWkwF5P7hj8jSQMaQrE82/1FTpm9vSyCEQ+g
   TJfHXUNGnmvPKeO9Kbefw1m9iqHDrPMsg5sCQIzOpZtrN86W7Zf+JpM80
   fbtHpCkdtoXDdjjoFGkmAxV5u9Ie7O5eRzP1iVOurz3CcLCfPO3tY9EKq
   N9UgKqtbxo4Ko8jdE8kA1ViogllBuBkCgH9mR9lIFSDnq4jEZSen42gkH
   O6xyn/sNlhJazMEB7PPQUkKKpZa8YmUl4mJ7kY+ktpoUbUy+YkF2aAnBM
   l34T1Ou5p/SqQm94iJxju2XMaaVXTS6GajULRVhrpFqnnTp3YcA60QsNs
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643644800"; 
   d="scan'208";a="298613810"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2022 17:38:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xg7I74IfYxcL4rEVYp/s40S8z6QTmfSmq/yFWICWVOIKjnfYd+fV3+QUVaAdglUUzoBNzO8AEt9FKfwzWA0WTh4EV1dXGNiqv9EUuUO9H/Z5UOdhQyG8OP3NNvtzc/VX3od1hxtDaLV/mGhnA7qirL+a5g1hJGZKC4hcpr7vgxPGR5X/rt2yCe8D3N3e/d/gZMjVMoCWBDwuDn4bSyvIo1CNKjQ5ybwOpQUz76E47yQsa4naLXDR5Yxjhi2p6LukI1J/X5wyhSbPeLuwYlM5CsFvHYaJMVeidfHuu4URKLAhrSUUvpkT3Xorl6WI2xoBH88UwgKE+6YkP3d96kpFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=lWXzGAK2UlMVQHrptShJGb/6arQ4SnIM7FUNUOfMfe6KPY1oqk6csCgg60OVJgTF8j6sYET0Va67cWGRHBfbY3FcS2YiaDbxXXCBF3sUrzGtW0yL8SZRcT8GvKwIfDhyUwkuuhbGRm9GWpP6V7ei5gmyHAc9y5hXhwoRtR6GSn0nJlyAvuiTggxoP5iQgBzgzAWTcs4KLw2ao5nBVSehXaFRQqtrdfGjnXLilzypj2air5pjBveI2aIU1/rlZ6zFCzaXKkmK1wKYNkfqhOKs0K8jkxt2Ec26jpa5mUleUy0hSWGf4LfejyHsS/Ti14jwvIkI78iz56/v+8w6Nl83rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=BRxT7c1hb6rkLxF+j/O5jrBNlf7MQ09ilLIF3wPc0LVcJwY/nb4KquwkPw+W5pha5eBgXfoRpYPwqgQrE5+f6vwSUq+1YBuGLMpJyvSMfaVz4p2WaX1PwAB1FFY+xvMpnnrfO8jlcDnkD5aHIZpYuNpd6hw+9fC2d3FZ8HO3Jmw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN8PR04MB6305.namprd04.prod.outlook.com (2603:10b6:408:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 09:38:34 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Fri, 4 Mar 2022
 09:38:34 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Aman Karmani <aman@tmm1.net>, David Sebek <dasebek@gmail.com>
Subject: Re: [PATCH 14/14] scsi: sd: Enable modern protocol features on more
 devices
Thread-Topic: [PATCH 14/14] scsi: sd: Enable modern protocol features on more
 devices
Thread-Index: AQHYLfeGU7I/dpoJpky8Gyl5zVX9Pw==
Date:   Fri, 4 Mar 2022 09:38:34 +0000
Message-ID: <PH0PR04MB74160D875920D3FE8317E2749B059@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-15-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 717b28db-f19d-4264-496a-08d9fdc2c08b
x-ms-traffictypediagnostic: BN8PR04MB6305:EE_
x-microsoft-antispam-prvs: <BN8PR04MB6305BCF77F146BF80492E0089B059@BN8PR04MB6305.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gJC2wLaOgOatlc9Q83XC3h+EnLhGtpa6Ki0jhejCm742ssMjKvH64PVdBMHXVUBqnubVobTWW0SydimxQkEgoj0ebeYdeI759CMMXC8yC6stnIlP2kz3iDEFXkaFvOyiKtAs0M93/WRSXYWov9XkUUXbOOD7XyHF6G9HeQwza6wmTNVkcqWM0k9VgJ9jL7rXBcXDXVfDBdHXU5UsNdQRVqq4E07yoCZ3F2QhREgXvyoyQcGylAHsb7NU9okIyJlIjuStMUB+smPdMZk+P4Frk1dKFFY0aazHcmNhvny2xfp/mFlO9g41raxtsYD9GE0DyKXBBiQl/thwQD38dDF8uDhr4nwl6hA1ZPkVghLqEbcRJNiD0+HGXanWgx5nVjB31sYWkg49XmQPXtwBSohxyTKmzUdYwQtD40L0mMKFRN2e3tFYlpvO5big/0vxgOP/c+ldbGXCsngdfXhoqfM0R4/QWnSur5lSeU9Jl6qxEmkEjuBMWiAKn2sdkLe7Kzb/uESngBRV25oRA6dcudS5LC8ySJWIgtLAE5yVrce2gKTQHe7CEMn5lUJm69VqrXY/9oS0b5iIjY+FfScPLDcHEC6jK5362rIkCL1dltTI2mm3ezsHIcJ0GhrqxS5LWVAMAbarjSnePJaaBNPKz2bgdEqSM65EO8y9RoNaIpQP1Ltl/52SiWcwECOf+vRgnkq4syIufvi6benb0E4T/2z+6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(9686003)(5660300002)(4270600006)(66476007)(6506007)(4326008)(8676002)(64756008)(52536014)(122000001)(7696005)(33656002)(66446008)(8936002)(110136005)(38100700002)(82960400001)(54906003)(508600001)(186003)(558084003)(71200400001)(76116006)(316002)(91956017)(86362001)(66556008)(66946007)(19618925003)(38070700005)(2906002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wUfV1jqjdV/Eh+/UTGCSRMdFyUdMxUVeMOqtcWTCWvazHy9jhs3QsgH2iFQd?=
 =?us-ascii?Q?4q+NhQSkl5bYFbPfRazpM9SHtJW/1PQ/vWCCghC4Tsjy0jERKuKWXmisGxqY?=
 =?us-ascii?Q?D6Z0UCGfYmpFeJg37k0A36MFwFfsthAZGG8gK55G+K5XFZGqNo0pKFBVif1c?=
 =?us-ascii?Q?mFAcY7Nk6o/9UyZipRqzcc5iqkdmnK3jD2zK82tZCjaapr+at7A1Rp0YpUw+?=
 =?us-ascii?Q?4Sy4s/SOTkIsHK9AYMSWIpSyVwKsuxP3mLsRSEHyfO3hfO8FQ/LK+O9JwE6m?=
 =?us-ascii?Q?bwvLWKVP4Q5xsMu7rJsVwPSJFFCeYJGEmNQSsRZdI/2U5H13sLDNhboWOngC?=
 =?us-ascii?Q?f1em59mZ/6TVmkDVIiH68f5cUeBtp4D2OBwDLix32XMFjDM11MLps8G07uNB?=
 =?us-ascii?Q?GmZMWlZxU0dIm6CmuLuoMc3bW13xPrTT6iyK0K6p4v7no/mYMEPRWluUK1rw?=
 =?us-ascii?Q?InaSFe5iuyj+rc0PXR3NW2CuHy6KOunmVKPS8TxhPHUWJpMd8BrZiC6MN9EI?=
 =?us-ascii?Q?kZacVKpaYJ7cCH0qMo09Tov3m5fcYp7r7DYh5gxQT9KMsPyvlbvNGna6mKOX?=
 =?us-ascii?Q?vHYMit9Zb0yrGHh5yiV/edxhmf6RHSJhqdWhEzaEMh+V1B7kXs3BWwEs6Pr7?=
 =?us-ascii?Q?KPqvUNbs/YFZSr307gAlEb9tIFUK4gZ+7ax+M1oWtthAUBnPmrTl3ygH4hKf?=
 =?us-ascii?Q?f8DCSayDqaf6A+vDf684E05uKSZU90qmQMBBxFYPI8jZILc7erR3tyWk8ubp?=
 =?us-ascii?Q?sQAf4fscF/gLrk/x7VOene0j/PSXJlhRbk2p8jAl0RqVOFiAH96HIs/FBA0c?=
 =?us-ascii?Q?KjAPSANEzwk6TKDxd9XwGMxtDpY1ZeHTfgr2g7Mz63NnZQXrXFmlzJegvWoN?=
 =?us-ascii?Q?9xEW+FcspAngM2gC7mTR+2oHU4Gm7hM6JlnGInMSNPMhOE6HjgVX5+0NKM1L?=
 =?us-ascii?Q?McwP0WAgYdOgjt5dWkUw6ybYBfHcl+/1VkLAXB7bkdiSAVhSlKvao2eLOp9b?=
 =?us-ascii?Q?1C5YRPyfSfGMBImavMgTM32OAgODH3kXjh2u2SkDKrFVI2XceWELjdl8/mfX?=
 =?us-ascii?Q?zVObsoYRCTTefLxAZ7UckVIm/yFvkG9ZexMLySpQN7esOp1IUDIO7fsmqZOk?=
 =?us-ascii?Q?n7E3u8q0+5CAaOSLkHmwtT2/7+WG4jULttPjjT/do7QvppVJDLfiTGl+WWWg?=
 =?us-ascii?Q?reuEJ04qIeAyctK9Wu+glzsGI+MAhuPWKt0T2DdEYkCRYQ5u15gqJPEIKuiu?=
 =?us-ascii?Q?SY6XD/GiTmbN/eCsgx2+oG/6npgAXKuDFlYAKT9j+2X1y8/aYHLq85OFfVPF?=
 =?us-ascii?Q?PaglNy1LoHY4V76kMxA6/OREYay3Fv9aT8SLEYKGqsgeDj0IXbgyaYN6Ohzv?=
 =?us-ascii?Q?8T0+nPabS5XBSsYfY9RPJdedJJXJ78h9DtInv+O7RKG2SziYNj4gIezEjsiG?=
 =?us-ascii?Q?LE8dbCgTp2V3cjmyZY5RrSzQvjvWr1k4vBSk8TBGZy/3hyo4iaGPOZTfjA8f?=
 =?us-ascii?Q?nYtJkafeYIgsBcKg3zBjzOKnhJZJKx9+vsuUnFMG9Sty5WUjrdF2E9GFqOnl?=
 =?us-ascii?Q?HTB/rxwS3v6jtkJaUj9KkUfpVglNUFbZKTyO5B1eBs+LgIzgTr18inWn2ghy?=
 =?us-ascii?Q?P2ECyyVzgAM708/f4+qMIdh3wkQ0CtQwQo73yTQe5e4aeaF5a9bRbpkEv3Ha?=
 =?us-ascii?Q?80OgwNJvCtMHa69O+UN5JAJOcqkEYLivGFNMviPkRN9b6WgfFxv3gG/xETYr?=
 =?us-ascii?Q?cY5mk9pyJiL4QtPRw0dPjU8rDQTZLv0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 717b28db-f19d-4264-496a-08d9fdc2c08b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 09:38:34.4378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XkJroV1ERBNEKNXmCuPJtK77yX84xu4r6kvipNOgObgF8hExJMoZ/G5lG3ef0yG84okgPsEh9DvMKm6759/arLET+r3oG0subZP/IhkyZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6305
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
