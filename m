Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD5BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiECPqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238700AbiECPqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:46:23 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52112E093
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 08:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651592570; x=1683128570;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=pfsLIv2fHX5qTkDg9bIRK149POs9LcaVpgiEpUJZJddi1zAecTa1uuvM
   pqvmZGnNB6Imm88J6qWHobzIpjIry4KQ0cCNkBTm0BUyjmLDHgNtl3Qzc
   89/xucoTxDYf6rVu9BJoca4JYFD1NPxNu4D88HeX0qe1Hdrjulw6KvcY9
   tlEhvAyPMov0W7ddSJcbV9RlWIMayPSYhdHG9ZsVH0LJj2bcZlCihsL6s
   neGlafKFc3ky8QYSlsYd46ln8D2D7o0t9H+0mjtTRC0UKva7lsATDUMIR
   gaXU6Cs4eIoKli278+g7+n1tye1uuaa9pvQCZLrgnRVDCJjysnb3mcnTR
   A==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="199430738"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 23:42:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKkOR3Hrn5YLtOH0KYmKNzAjU/6azl3gh0RvLRZM8OBxUR2JGjXsD/gNcxAR4jNnXK/deBDRwYqOXWvWQFw0/xaSzgZAcT0a6TK5Z8oV9oqeOsVvWdeh6vG16jvu3bgZuomHOCoiK8ry3oMOtnWwT92uGsnMNp6ZQrbKXE4bOYbM/XFwkttKmFdr5V+QYIReAO/tu2yoygM8PaKzPA39eV6df0SPr83A+wwU/QzUvC/vveAUHCjtD/KfsWVxTYqquiIYCLLvvcaxVRPLMKFDj0nlb8FWqcaknUh2o0K9JvStiiqxXT0ahoMpjhlqEISgIihenZQJfyCmCJTVPUmjKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=dWs3urywkCEQCKCbnTtkJ+aE01oMT4AUg1mqwVPmxdZzQFcO9FWGfUuPBBELl+cs80tFI6n0tGK8RknBuhVf9wBUuLv0qksgEfCStPCDg4L+FHwNQhYv+s0dLxEgDqRFVBsFQMVAwLKwqUVyxkM83hkdV8Z26PJ6GoY0ATX9bARUSAZP/UkCxMbKHlySRzswouhJAw9shR7Kf3NF/rYeKnFPPXm0QnoieGgyUsSPak6sZOzNJcXkKucapmPhB9XvIPf/s5NPv3En1ceV3E2wM8xo5lv2MtNr9V2X/9DPdaHmwl0NWSnj7+jZ5+IAR/0rcRG3WHivleG+ZWzEBD/aGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kDG3uHgJ1CMSt6iiyEW0hvQSm6Lb4nT4lmtlvmGHB+tJJt+Cb8SHwz7RO79XWNLguZrf7iEQEPc0/BaL65XofekEtjfi6sx4P1SJ96LmBfUFzi4E6jMJfRpNo/hUi5hBVghZFxPlQSt+6LhhAR1wb+TwaLlcghGXiSUrbwHLdbQ=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN6PR04MB1012.namprd04.prod.outlook.com (2603:10b6:405:47::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 15:42:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 15:42:47 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 20/24] sym53c8xx_2: split off bus reset from host reset
Thread-Topic: [PATCH 20/24] sym53c8xx_2: split off bus reset from host reset
Thread-Index: AQHYXm0jHvbCIyadvk+lGSRkYSdUsg==
Date:   Tue, 3 May 2022 15:42:47 +0000
Message-ID: <PH0PR04MB7416F7D78F96007E26885E6F9BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-21-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6a9b7e1-f6ea-4a72-60f1-08da2d1b929e
x-ms-traffictypediagnostic: BN6PR04MB1012:EE_
x-microsoft-antispam-prvs: <BN6PR04MB10121A2F18AF334EE2C4FCEC9BC09@BN6PR04MB1012.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ldQTGjYxRavnp9jD31vZ/Hmc3TgoXOtRtL2Z26+7T/e8Y++ro4VsyTHQtNeexTxO4qgJ1Iz3kSAyTNhEiLA69yn54R3wiIU+JtJzbUsa1fgUD3kZHzq8mcPse34ZbXKRXcwgZz6D+B8YY1yZF9EbiMtdOwAJhQ/f4riDcnC3SZEshz22dx+n65cYVWgWAjfbb6jWYG3nGhxa4e4wrPq6kzUYnC1OGptmEaDeUI2YG3c3DzRwsozrjAOUCfQ8H+1jfZiPyBUqoC3WwSZ4YhxYkgA73OwreMS1lyOWRadFTcJ2RGbKMc9CxHM6FmaBANvSUAAdwAjPBqc2BmbjcPR8v4eY0tpFOx5Od1VIsHsu8fiqj9F1kaunjjpGMZEQ4nXD+hxZBvfxMji398ezt8AHtqv+gFicGTp8ookADf8i9tw27w7LuWYRbC783mre7K/2C45x5xMwcA5qqsDeRqEi+IRYaS776ZA0kvWEkQrlqIpHN6q9k21mdcFKvSXNJsNByzqBGpdWW8m6gzq1qQJr86J4QwPlYq1TWmhm8OyidZn+Z4Z5DRQVAuo1okAexJe3TNAgNA6qWYBCkKn0FEhjoFfXgWP1/dRvwqbphnVpcBsSqROpbxrrwlRgiZSHtjU51ZiBRzrLNj+P5p3j61ogoKmYg9zEil9ZWmsTXltqxrsootoy/l3XE/v57jvowYynNGQHvBxTQZ//jrCMm0w6ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(55016003)(2906002)(71200400001)(7696005)(38070700005)(38100700002)(19618925003)(6506007)(82960400001)(33656002)(122000001)(4270600006)(26005)(558084003)(9686003)(8676002)(4326008)(316002)(5660300002)(186003)(8936002)(66946007)(76116006)(66556008)(110136005)(86362001)(64756008)(66476007)(52536014)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fHLbyl3zc1YAaCXBLp4fDx9djX+N8Z1pSEhsvZ3NMBG5dRwfPYOY2I6ZFTyl?=
 =?us-ascii?Q?vtXkMkKhIfqaR5COyJhi1E4lOllaDEjIbklMpi0BGNgzmU8eSIKy3kHR+c5w?=
 =?us-ascii?Q?Uf2AeIBbCmJ4w4hMitlOhEvTj8gcb23jjwQ1CfBRV1kewFv8ZtwQ1nvXtCCq?=
 =?us-ascii?Q?t19/KA2YRgDpSJR2y0zeTPSxkS5zHUdPu1wsTJzdiyH44Z2RzXqqHQgc0EAS?=
 =?us-ascii?Q?znpdmM3f+GLxarQEMyYRPF54emDy6ko3wAaA90+Vao5ft7ea1oLoISjZOY3G?=
 =?us-ascii?Q?zfy+rObpxvXjO2mFZGiJaUw5Y087NPRRkmEHBlAm9MZ3dG65kJu9Fe8osyPj?=
 =?us-ascii?Q?wFnu5k9UgjAVnrYXR6oLtdjte1ics6ShzbuvOumAl1/MaoBmoKUS8RPHBcnf?=
 =?us-ascii?Q?yMZlYGEABMg4upVyw3+SF6Ghx0psnbbHWQK9U+xOpJle65o9/XPRMvEvxoLn?=
 =?us-ascii?Q?7E/3q5lFhaW7BfU/JeFaBL+HfgTK9FmL6EAWaK6J4p6vlTnsNDYV31dsfCfz?=
 =?us-ascii?Q?aPD/gh/+EhvvPyUpTEZroEGoaVYY95nAwI298dDKXWYnVMHaQ3oYzsWjyEhn?=
 =?us-ascii?Q?IpBzwulo/TN0uv7ud4Lj1pwnVVBklRBH5LU8wI69DJ8ZNkZLcnTFn2Ncof8L?=
 =?us-ascii?Q?PTv6eT0oHatKrH2cSW/r9pRPJ6z2Od9BofQmj1EN7DyBhuzP28k44sTVnbhE?=
 =?us-ascii?Q?lKhiYaJYtTLXO++jsXHBI8BXvo2R3yYMDAOYqZKDwBqshI/8IOI4kHTGVAcr?=
 =?us-ascii?Q?AikG/ShXBX33a+paaGDUGeVqZexcJy0MopF3xmQBUzH1dL9bxB+u77a/2Z47?=
 =?us-ascii?Q?MHweebacDDRf6Z9o1+PsdkcXJhopXzer3K1u3+VEAmB8lYI8DXZWnG7/vm4O?=
 =?us-ascii?Q?6K5RVH4GelyJaA5JKRThDZQfGDgsT1DqFBdGV/X7mjdorWsJ+ySnyNJtCOpz?=
 =?us-ascii?Q?g7+d2M8qUkg23Eohnhvl4ze/VJDeyo7Yb2w9lFbqQ8gPeeXJP4L+uTLH1RDO?=
 =?us-ascii?Q?6vbgTOEp6F+dn19DQcJpB1ErAaLQQRZo6NpnZqGZAx74Xi1ealiTYTOYcnDv?=
 =?us-ascii?Q?wcO0ct3vYh+JwxSYTtXsxuitj5w7cFC74lRcLmUcpRWeSstoERHVL8UzEfdU?=
 =?us-ascii?Q?L48aRoPp3Gz3oHfFMcYdt7jRqQOQuEAv+uNcsvETidWTR8uOmi44Jukb/UFs?=
 =?us-ascii?Q?q2/GVru3kOITbwejhuzNP/oRAwH0W+Ih37QFj/d0qIrVJOtUAZHuf8TL+DKm?=
 =?us-ascii?Q?95Ini9ILGroxLYaYVH+GUgT5yeNLmiTupol/FF34A0vSiZtxvCKQy0+9ZyZn?=
 =?us-ascii?Q?n89W09pwyzGIlcNPyXkfoDCvlScIG62J71QCIfNyCJ5r7xbgXw+vMT+RRoq5?=
 =?us-ascii?Q?4rAqLiGoC87dFEdAPQDuDxYY5Gi0czmwWs3zszILb7UPC9ChfO1qvFMsUc7u?=
 =?us-ascii?Q?e2YKtdDMZwAVwqPFMlAlnyv0mvl00MB3jzh8QF9M4s1Bz4JJSDnxWcE3UGGf?=
 =?us-ascii?Q?QRTGL0mxEUpv3q10/APFVw2E7xZNc65xz+Rrnhcz8vy5/EHuksuFgoWlSCHS?=
 =?us-ascii?Q?tDWAKfLAjWgu+jiVdc5l7Y5TvsqN8kIiTpfRoMPJSzVmW6S4mepgR7Ttb4lm?=
 =?us-ascii?Q?PVvJYXG2UBsq143E5H1wNngCDDfMKy34R/izQFBvOPEpPexyQDZ4FJuyZlD5?=
 =?us-ascii?Q?WArpPU2kvY8dfcbpZDdJwnAszFquzsWMN6jG3VYcEviWkDmuWa+IQ+BwD/2L?=
 =?us-ascii?Q?BBeYCVk+SNzWxFLgugrXyuXmEr2RHK4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a9b7e1-f6ea-4a72-60f1-08da2d1b929e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 15:42:47.3566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: opo3sG9f/opyO98pVxeW9rd7bli6I6EOxqoIDjZu0rVMsadgY8wjsNLtLai3aUSyLGLClN2FHi9PKYJeWa8MKc/zAay7t3PANPQp3A9SWog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB1012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
