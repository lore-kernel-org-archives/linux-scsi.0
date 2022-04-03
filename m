Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6FCC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 07:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355427AbiDCH1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 03:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355404AbiDCH1e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 03:27:34 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE423193A
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 00:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648970739; x=1680506739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YoMO2uHTPysPbU+irFM2mk+ikrdXtLel7xH6KdW6LhU=;
  b=PMLb/z6RcGD7zkVaWd4L0mB60IpeSM3Nr24myvY0zMpGlduqb2aVGYVY
   1+7fBnNOKNMuforYpxAKRH8Vt9vAV1l2wSAwdlhOcAXJkZIT/asWD1/N1
   O33BL3QpvKj+YItlejvx95aKe28r16Nmxzbur/nT2bbDTY01qGmTU8cZf
   P2kRNpR9m7MGs/MgHBLcUC7jFOJyYNT8HX+PQF2WEMjdrWF7xkDGKBvQh
   NVKLB/Zb2Uqbo4J/c/FZt/DZK3nisedcp1fNP4JlsU87RLA7U5tnQJJZ1
   AclBETSivCwqiiLVc8RFDu9pY7Ohxins1qlRf+KGXTKYk+hOOO4tyuI7k
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,231,1643644800"; 
   d="scan'208";a="201788374"
Received: from mail-bn1nam07lp2043.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.43])
  by ob1.hgst.iphmx.com with ESMTP; 03 Apr 2022 15:25:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKU0Yhl4UgOUEZFu02akoHw+vDELv6QseHTMVbAee3TIddkGVsIbRp5UmNcJZNpaPkWtSvwcMeySqyekGxwwvNDRe3UWjqEcwghjb+dBaVzBGgatj2+KzdEZC8GhHtsVjishXHME5qQAFq9AM3NK5OVxN2N/RhzZ6pgftlYKD+y0kCweBzI/6nGPFPGPb6k86gWEID/E4R4cTtZPUxheBfKCgFK1KSj7ZA+MvCsr6tbvDq5x0lK1wDIeY+31H3cckjtk+qkoRvDY3tLUT5WKoom/O5HxIJLipjS6WPPG0aIueDqiUAmxISSaoAMrIVQ8LzqqGPijr5trXh7LEzr8Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoMO2uHTPysPbU+irFM2mk+ikrdXtLel7xH6KdW6LhU=;
 b=C/8hLDSKXutnsDl13h68GVv540Mbkfrdp7hTP5p8GlKe8p00odrm1nQCf+xhSEWZpXagtRprFPHLj2q2RRQbvXVdfim7OXgEnzC16GayHAw7uQ/enHg9vYyv6EybSN0iylNRZmrLdmQHP+eMrG78a+xFAdH+wbdiXEW1puVVzzjx0MbAkCuEpJUV6ejxSUIlYsYrJJmKw3HS0f2Y8Wgc+0w4WlGGNTN3NcaY/djJsngowo4w44puGXEFIjf92bXUPPij71c6ZIsd/CJOXiyGAC1UQbhKwUCWOriYfLsQfRkwD7Hu3j4urlkQAKVafCKq9TtOKozMTaOMWiidaLOM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoMO2uHTPysPbU+irFM2mk+ikrdXtLel7xH6KdW6LhU=;
 b=r9ZjRThWAkceo4oBCo2PtuL/orrcjDRuNOJZdkwAiJ1vwRiMQXMag4N2S6l5Q6c+KN6n17ngCN3VtnwoJWJNztAXTFHDkdX3OUfnRzawYP02UoOR90TmoMb4b2ax7De8C46rD3rnf7jaRt20+q5YXidVZeDVXUEQASkSzsjiY4g=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MWHPR04MB0352.namprd04.prod.outlook.com (2603:10b6:300:15::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.30; Sun, 3 Apr 2022 07:25:36 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Sun, 3 Apr 2022
 07:25:36 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 16/29] scsi: ufs: Rename sdev_ufs_device into
 ufs_device_wlun
Thread-Topic: [PATCH 16/29] scsi: ufs: Rename sdev_ufs_device into
 ufs_device_wlun
Thread-Index: AQHYRU/hrHuhhloOFUunCtKOpIJo76zdzEcQ
Date:   Sun, 3 Apr 2022 07:25:36 +0000
Message-ID: <DM6PR04MB657505251B62C928FA73E71BFCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-17-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-17-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9372b144-c54c-4c70-7c88-08da154325d8
x-ms-traffictypediagnostic: MWHPR04MB0352:EE_
x-microsoft-antispam-prvs: <MWHPR04MB03525B730544C117D22F3DCBFCE29@MWHPR04MB0352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c3K9Ek6rGdYngSr+NMLPxozycI2xzbV0EhVG/9tplZM/p5/sHxnyRvxN9kiSbesajBAnpZDGLksG0I5rCjbuKr+/qKHp3/3epieTTQDEcQz5bHqk6sQgLQuyQp5O75XtaKLS67BkSemq8AvAJzXx6lXLkK1lpz46M4Pna4qKxiaJQIrI4xCzNPQNTeFawFWTGv+xJJ0zhKI3k0KPLpSK3LHfO4Xbcx3tBeYgtOglRVcqKKwahgUYQ8qIcyY3oxCYKEIGiQ1ifOUonZMr8Ed/OcItpNRzoQqkYxXcziYswaucofQ0NOARzqLCbsecmPa0JLQOLpDqaCpERRsLSitgWCuupFyg7uErxfW9w68PLaQFKwuK55C6qkYltvR/KYQjdCpFAAnmE5omRPFryWSPyinvf4gU0XhC8KGGHin1zIjL+rk2Gc1BKlaK8nHmwyHE3vEi0cIQ2L9f5tqeF7shTOKvoJuN0x9Aep3D8cBVBFRr47Ek5swNpMQ0I0/r7WLplCIzLegoN5+Ew+ZG73kuiE8Nwax6xa+sD44So9EThuOpHmqjJOrkMy5pm1cReHrYFW/U+9thPJqBjANfGIL5E8/FVEXCM6FmhMPD5GltancgQ1RzMnN3ig4ZuzNaSNs7578EIdFd5LkgQptIgfuYxEqgBbpEzeIZ+ZME+GFuSOQ6dHJ9zcyz59gJNAu2+AdTThqLrOTF5Dde5xMhAe4Dpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(7696005)(7416002)(5660300002)(2906002)(9686003)(82960400001)(76116006)(66556008)(66446008)(66476007)(4326008)(66946007)(64756008)(55016003)(38070700005)(8676002)(33656002)(38100700002)(122000001)(26005)(110136005)(186003)(8936002)(71200400001)(316002)(54906003)(508600001)(52536014)(86362001)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bBdPjnSNNSi8ZjX9xYUWp3CuXWW94CjVydN5OkCrfEfbGWenL6gzD6cBpDcL?=
 =?us-ascii?Q?AEDznAoCJdVfGSdUE9LEdGXATiVBldgK6vCncaVm0XRgmY2ipXNd5oloAIMc?=
 =?us-ascii?Q?zD0hKDtEgJuEbc73jXOkv+Vc5o033APWXuPakm+sAD1L6DKBEzw9R1r1f+uN?=
 =?us-ascii?Q?sTsdecQpqzbWiBS3zNFEQPegZij6pMm4si8BhJrQktEriSzV3S/iDiC9p0F3?=
 =?us-ascii?Q?CItELsM8hglsTRK1nKvWXpoWgAXgmg8nhb/KOaCbAVrSIbHoA2cOvvm4n/4B?=
 =?us-ascii?Q?Hm765GXucr01TYO5k8vGaZkQ+ymTrf8C3kDoNl4zI6p9dHMY8NSjeJakVk2i?=
 =?us-ascii?Q?WZJku0tN31EBLMd5rgiIFlvxbwvaZMcPe1sr8NnoP5EXmg5h2+Ihm8OOak7p?=
 =?us-ascii?Q?kG5Lcn83rnqP/C1z3OGIIuitWOPex5uhL1sRTkAtS2oFI+vozQf5qjktrnhT?=
 =?us-ascii?Q?tciaFxnzE4+cWQdxDuefVLOJV4heNImxo/K8ehSdAEcWH8YIPTL+Kt9JePvS?=
 =?us-ascii?Q?z0TBJd+Ekknwi4M5SLavifUANCWSXJb7etsqFqR/vDhH+O949RC9V3dt9M1N?=
 =?us-ascii?Q?wQx/f1hiJveRrEMq2snXqSysoWyekiX2GGuTGv81kvNAPxdTljr5t1jqGQ8V?=
 =?us-ascii?Q?zfEUuUqrsgGmKv8XfBxzX3tK/XPv9b0sPQdgG+GZTSc2gaWmTdn5avZYG3Nt?=
 =?us-ascii?Q?l63QuSWioT+MyQ7DNo9bvCrODNsvVSww8O3RguFMttmhtpirnsZp62zvM95m?=
 =?us-ascii?Q?VghaShN1mwxMszc72eIXASoaA97uPyJfZBOyunDKRuWjRCi3ClP0R8Kz6iHk?=
 =?us-ascii?Q?GKUVZqgpadv3fM8d5/TqOs5EYt32e1W3MFujvt0mqwU2SLcW+4dxolIzC4AP?=
 =?us-ascii?Q?LIkRQp9zWDMA4CTZ/Qb5uVziTtbXn4fZH9JdWxz0rc16u6yfJvu7qjFh9zK3?=
 =?us-ascii?Q?WCdAbk1ENx4qz2JBDZPjziNoA5iiVHYECl6/MauFOUzTc6Pjjd/37ea9xig7?=
 =?us-ascii?Q?s5vU9JlABJJgYbiboHU7gD8yMR2rFyqk/ykXGTiSPHna7599TBAdKbgsB1GM?=
 =?us-ascii?Q?peil7VyZ8iFFYTrKFtizeqCfWua7elYaRsGMLFXABKnAX8cJ8On3AkwdbsNr?=
 =?us-ascii?Q?1QTH0N9EFOQTQ4vMY8kQOhT0gnKiIqzkbZGEqKILDwYjZcTeLIGYTWSjvzYc?=
 =?us-ascii?Q?aWLhCRDrPO8hwTgS1PXdMMY3lIX16dwJha/od4owBh+eZHSts2HIDgdJA0yl?=
 =?us-ascii?Q?9c7aM/dfj1rH8WxUNvu/qF/6Fi4VZvvNfRgAI5GNaVhfM6b91bbgdIJ+tjcz?=
 =?us-ascii?Q?AszZKzD36Bxyea27XcNhGTO8oQUS3B2htoaxmdYUCD7MquzhFwmuvNThWqhv?=
 =?us-ascii?Q?IoYFOoStvLl4vx4c0yVyALFkljYZU2w0s2omWX8l9gRYOpu8vDbNiiP1eM1K?=
 =?us-ascii?Q?MkFHiCWq95/TG/bWXPAs9cbyp9lZebnvRvRqiiZoGtCGStlHKEbpyolpHtUK?=
 =?us-ascii?Q?RkSkJxS2s31VE9NZC8lD3c8xNoui8L4FQSBI+uuJDB9OvesKrDLGrGhrmoz/?=
 =?us-ascii?Q?8sstgtqp1aDwtOJ1hotbPmTSA0MJ9BEeSHErWoNKdPtst/W8yMjjq4fZo8PX?=
 =?us-ascii?Q?zlYp4lO0sIUr+MSzPRfneRtGykVpuK/3xDKBjGH41rxnyHKd4pOPxYl7wYQo?=
 =?us-ascii?Q?KhfYlkm1uldlSjKHhN5BSxYyLPRrhg0c8lWM+0qOMZ+MGnoFpurZ7XEvcIWq?=
 =?us-ascii?Q?y4pbBOp3pQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9372b144-c54c-4c70-7c88-08da154325d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2022 07:25:36.7189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L/t9Qx+JE2TejtmIbHJhOxuYbc84WaR5Xs1eR32d8QENxrCKD7gHgsV4UhsWddXmYMTvGlwDFHexvWCAPjibKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0352
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> The new name reflects the role of this member variable better: a WLUN
> through which the power mode of the UFS device is controlled.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> + * @ufs_device_wlun: WLUN that controls the entire UFS device.
An optional suggestion: wlun that provides device-level interaction
