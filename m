Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BD7C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AB686124C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhJDMof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:44:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45740 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbhJDMof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 08:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633351366; x=1664887366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v3IzaXtdoDNJHxMDwuQ5MCAt45ZQ4fcxs0GHkurERXo=;
  b=Of2xDaXnHeRMIPUiGwRc6zO546BwTgNwfzhjfnwDB55e4YCKCK+byjz+
   2Hm2JXCdD7fR8vp/iSS0mad2miENIs07uvCFqYd9JFVk0phMUrexIyE8h
   NOrF/j2tayWFC0+31ff1J71sJ770sMWMvaHHMZQBW29gggo9GVOO2fw+G
   P42oqOaWvyRVZjUk9k0FDAtqe3GExkWmX2nBkQuRSg6eCCSzQ4oRoCCfS
   rdcbP1cH3F4/B+RTF3rH7q1DG642798UL9jtgeGbJhq6YYul+JdjhsJuz
   Od602kFRemf3HBc/m9XkigUFcLw+dPk4bxtmqQLukXZTyS73jN2rENva5
   g==;
X-IronPort-AV: E=Sophos;i="5.85,345,1624291200"; 
   d="scan'208";a="180826544"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 04 Oct 2021 20:42:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT2/6mZ8yXT366cFcyk7vFPICJfpQxRhazbqJhDg+wsRHNo2YAdXTjZ2AU3xr4H/6LdeD9vjzLMP3nZZW0QkiAcfpcf7jruW4Ynu2vUT/sVG3qq+D99284RnvZALLEYDqbhzIYObkzVFQmegbtDgIXqlkp3wIar6GeUuUVNDa5MCWM58tuPq96D5fWjh4cDm/gpl45lAK5+bRq67Y4+pTbdtdMHbAIgxFtwBohLuG8m1VSJMNg4jH3OK44xO7Zrzy7fBsd3if9nziGpcblLZYdHkzVChL34H9S1YwiYPNdUR/aexwGlUJuvu2pRq5LAA0VyTivUQ/uKRW0Cpof+FAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3IzaXtdoDNJHxMDwuQ5MCAt45ZQ4fcxs0GHkurERXo=;
 b=JUizX+XRJ8+4gcP2O+PBrr7MKHM1EIb+FT8FMhg93S+8bM26bGdTPtawJIxaXR2OCRufTslEpFBbRlHLD73wOT3uQd/1gUD3ZLUn/NsB/xxPWW1yvnlC0OdtYVq8k535wXufwzP/pmpRuITATenCAHWcQ29IKK+jBWu+1vCfiQiOWs1XhdLEfdoOb+xIBa465bhnJJt3xFlrAW+yD/gBC+lzLQjuy80CppcJshI9VFp/5gfjEpaYpSGPCjJsoCALlwMCd0NZZHT58/B6+1idn+oD/Erx0wYif+LVFjuvtdyrGlIonZTEW6VcWkMVZ+ZZ+T29T/cxe3p9/W89PR2yqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3IzaXtdoDNJHxMDwuQ5MCAt45ZQ4fcxs0GHkurERXo=;
 b=g7sV4UXPO8rQPjDFvZXlCpLZe4I6xeh6eSrxf+uXKPoe2XD8oTnW+T1FLVWaAC6wyj/bbHjNzfFuV6+4pzIEqZIMVPbeV7bVZntO/F88OG81Jyw396g4+hxJ1BMCp/PVVZg4FqS7c0vqWefG3YCy06sQBIw68007wRNk1fokvng=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7004.namprd04.prod.outlook.com (2603:10b6:5:245::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Mon, 4 Oct 2021 12:42:41 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 12:42:41 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH RFC 0/6] scsi: ufs: Start to make driver synchronization
 easier to understand
Thread-Topic: [PATCH RFC 0/6] scsi: ufs: Start to make driver synchronization
 easier to understand
Thread-Index: AQHXuRhrakVUUbjAJk2JE/Po9HRjw6vCx6mA
Date:   Mon, 4 Oct 2021 12:42:41 +0000
Message-ID: <DM6PR04MB6575172F68B25EA1E4A258F1FCAE9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
In-Reply-To: <20211004120650.153218-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6344eece-e47b-4f05-c9c3-08d9873474c9
x-ms-traffictypediagnostic: DM6PR04MB7004:
x-microsoft-antispam-prvs: <DM6PR04MB700477A1E1E0C6B62DBD25A5FCAE9@DM6PR04MB7004.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HBVxOKg9AUW7jpSHWaJ8YCEyLllWhnqCDWlv6IF2e5jzFXe21w8ar/xNxCqTmeAmBKbC3oX+uN9XuC66Wm6bzoxHL9zMeJxrnMRO9FDiDQWNpKMzb6VKtyF1dBALzHvJVAguquzMcImfyZfDJOLRS2TIJ/hsgLO3rJsUoyqda0nBO9+jwWFsxTZyQst2Y8jhbbpvF/2L25VPFR4labIilfDkxTdGGgLqrqbqq/QbPHjD9GC5VwrWRf96QEOxSVxgpC4lPbbi9d0lR8sVGUetmfr6llpD6ZzuJog78pHlULkqIzbGVjoaNrixFaupKdAJBbSqy8ozY0IuzaJAYH+jubBM4WIeSVqF2S2ltidFEUKXGJOPWZ7FT1Z88zyZPqK9beMKI/DaUhjk/Ye4WIJEDgCSfClw/RSjxFdS4EQQrY/G0Pv/8DOvb2MqxiPjfo1TOsKsuTpkpnCIYleGcUza/8SHnabQo2A8lhhh1UynB07+I7v0DNSYLW4RTj1J/3+KRQ6/7pNE+xxccUctRSFXQQeIMe8tm0dPKgiEG60V7RhY4iVWMGlwb7M4wrMifHF80m+E/ODt+VxlxX+ObPFpB/W9uXRfehtlD0jdv4RzDcgBipx+tqtO+Dv5FFGEdHQWoO/uB+Jpx9Xkee/0AMdYRK7zVwqlgh3z4F9aL72mL25jA2+oUie+hwn5YAM3AJJCA3IFNyJzljLJGaOkm5/PvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(33656002)(38070700005)(38100700002)(86362001)(508600001)(9686003)(122000001)(2906002)(76116006)(4744005)(4326008)(8676002)(8936002)(6506007)(5660300002)(7696005)(71200400001)(186003)(26005)(52536014)(54906003)(316002)(83380400001)(66946007)(110136005)(66476007)(66556008)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pKFXqvuBsrGQuqikoVSutdjE4lAZ7rqDYOPtQ4uzXGset4sVJRsdMXrU7gVt?=
 =?us-ascii?Q?aalPF/sLR3TN7XEI5VO1PyATXovebnUr0WfymWyOq4xqwluhfs2N3PKxeLzP?=
 =?us-ascii?Q?mLCOzOhRjXl3zEPdpDXlc+GuPpYqvSKEJNzP7206EVrFcm2SWbMexnqcXrmS?=
 =?us-ascii?Q?b67eJgTfpZmbV37Lnd7jVavQ5Af7iUuedMvO2rkBnmNEtEnG32uiQckczwGv?=
 =?us-ascii?Q?M1iXSrXIivF3p7GxXO7ZobzTz6S596E0vr+olag3eSkMw+tlBGVrjPlbx74U?=
 =?us-ascii?Q?Hd/F+h8Tpihz3eKn6fLR5TT1/yQl9hksCWueAc0D8RjRv2i66g31Ghj4/MwK?=
 =?us-ascii?Q?zXrYl75N8COwxbu4GX8W3Xa1+skD+dFISZ99Zb7mdA6YaV9vXfMLxrtGZ7a4?=
 =?us-ascii?Q?88G/8CH4avYSDgSsacCn2WHA5szVR9IVQva1ghA8hDoeg7hsTF2a7Ipu+pEE?=
 =?us-ascii?Q?yZlI5h63smtMSLhMelEVw6GOtXbC05nkAcf959JYQ3iw3B/CUmMOWvGZ2eIz?=
 =?us-ascii?Q?UpJ6njdIH4F+wGSJqpV9hfKhetAJuhljYdicDj2Sdar+s8jB0jD9L1Ush63D?=
 =?us-ascii?Q?zD5Fra8zDaViP3GyOyUFAeKp7UAIai5gCrfpicB9yzSffhPAc15hdhJhl5r5?=
 =?us-ascii?Q?UWp9qTerv3fPtEWhkbYXbNA3k6JqNDRVRPpHrVYCwLn1u4yXRQxIZcluKQfI?=
 =?us-ascii?Q?vcIa5bsbe6q7U9syk66CG81NJPRR0JQCi31nrJiNvzWSg3CMhQSKRk8XrIcK?=
 =?us-ascii?Q?DDKIrJSmOAJFiclnr/qmIRzAAwEsOCiw9nYCF/ADW7s7uD88YCaLNuuxCeT6?=
 =?us-ascii?Q?eUi/zfVNvJv1pXRKuWWKTHDFDbzTN0q3To2JAGCtCHSwasApAEPDuc4QWzTl?=
 =?us-ascii?Q?xct20z/ppbDcVXmTYC/r1UUlSZXa+sLk4gobllEkYReIRmAc0k99oe4hGc1N?=
 =?us-ascii?Q?6U5p2T/N67NlBAXJhIOjZK9ZhkXam0PVlgsTDFLdIJkAEp2/uU+oJlk3NYGd?=
 =?us-ascii?Q?KwbjIIFgSSrkVzH0UFJQt8wlljVpKOr92+CMkm8cna7uLkBXV0MUXU48elfU?=
 =?us-ascii?Q?ey5iDhee//yyoGSm2+On66AMwFHSscCUCpUQZlzPU18q2oPA/lzdxBhsyuWK?=
 =?us-ascii?Q?Vxt2G46E8e9heViuKF36Q4a2lLConrzjYL0H7EZijBSVJelDjXDWjCuTMuzG?=
 =?us-ascii?Q?3e3QrIbv/6P2z+V7tCUi2QrpJcG26xONwNH3n2rH99ZigV2SeEVyyT+gDeLI?=
 =?us-ascii?Q?cxsVgyv7YSGkwm+iydLQfwSQibfc1aPHW3C0SKLvnLozd3Suj8QGjdTR48FF?=
 =?us-ascii?Q?81YzAaQ+yOp9bD0HM0pdfAuz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6344eece-e47b-4f05-c9c3-08d9873474c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 12:42:41.6409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xXDd815BOcXburJE/HD56ZUNHUxJcbkr2dTh+fZWyvTVwm3DTyfyEBHqgfst7GSATgue11IuHN2XEUA0Vtdp9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Driver synchronization would be easier to understand if we used the
> clk_scaling_lock as the only lock to provide either shared (down/up_read)
> or exclusive (down/up_write) access to the host.
>=20
> These patches make changes with that in mind, finally resulting in being
> able to hold the down_write() lock for the entire error handler duration.
>=20
> If this approach is acceptable, it could be extended to simplify the
> the synchronization of PM vs error handler and Shutdown vs sysfs.
Given that UFSHCD_CAP_CLK_SCALING is only set for ufs-qcom:
If extending its use, wouldn't that become a source of contention for them?

Thanks,
Avri
