Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D2EC3F2D8
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 07:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7355120CC7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 07:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Joq4xiF3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="k55NTSMO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCCHWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 02:22:54 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:46803 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbgCCHWy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2020 02:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583220190; x=1614756190;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pc6+4J49PN+F1vvVg2OLQRpRbHQbulJ/KzpHKRjX/a8=;
  b=Joq4xiF3Q0Ddi2CtDfTAcm+JDl+pMXdJcH2buG0Um1bh+BVPArGKiOVH
   mCWNqawcZb6/WKmg1Uc4Upj2MuK+sFA7OBTfQGHtuP3d58d0b71Z5mLr0
   rkmxw+Cv6ufWvUa2DpB4+zU7Q5FrQuOFx9JQK27PIciPw32u9FONWStNu
   ZqjnV4fhLzNVOuQXs7kxsFMEs9q11hT2rwTkbEDUD0bbRIhjsvqp3kOnY
   yP3/uHYHkejha6yt4hcebxIY/u5QQrwHFEZZYi2BIIlYnufpxeItDetyp
   Vjx4yM/SHTeej+uqgbou8THtVnlOikK+h9aDfyFy+Kc2kgFHBleV4mNXP
   w==;
IronPort-SDR: At82wve4fBmXH+oeWlL2u55JpNtce17+qrfzkDz0Soi/7C0i6odMkEtHpc1KxOPav4Y9bxDfLt
 Ews6+AXGMRWZzq2x4FaI6G15RD4nej5qAQyrcD9gKcvdJTlZBiaDQqpzCdSrojGUzgACefE05i
 RoGhq8Ek1a/AAQr2xAjKhi4thkc1CEH8b1xOMySX09u7pH2eIT01w38EDoAD/sY2TAZaDIDk2+
 m7x36tvqcUo+ADCE2mOh6C4DU2yHANrfW1LXzDK04bh5+gX72ObUGxYFCNaygDX/Y6u9chqLqr
 hiI=
X-IronPort-AV: E=Sophos;i="5.70,510,1574092800"; 
   d="scan'208";a="233191584"
Received: from mail-co1nam04lp2051.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.51])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2020 15:23:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioMWZwmimXpqxqly4+p9nZb87yquL4u4UxIYRS6GtzBNqv1Hlf8nljHyYblzIRaHq9ZV4nrFZITakp6zAQl6TU9ljfHE9ZV9KRKWAYPcTqjbLuD8u5JgB+VOZcm1mdDKofElQjuXjqUepegLaX71LYX75pQG0BrNuyDRaYzUWNsBrlFPzL2GCfEWj7LiWRf2v9V1KsJV1cPfD0UKtj7dPHl45rFz+mXkjORpAfuc121KEDQGL74rSh1zJcczI2uZ4N7P3gbf9UvPSrnlw4T37LUKhkMjaCzI4VrMtEO/oGqDKXObEXVYvxxIswmu8LCULMxZxD+ByKvETNYcIvJy3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pc6+4J49PN+F1vvVg2OLQRpRbHQbulJ/KzpHKRjX/a8=;
 b=TdoxgZLK0g/oBug+vYeb2TUalTqPXwoXcF4cVOGpZQmxwwBgUCQSA70gBIYdRk9LweeI2VwyKrvbyCACj+BLLuSpyBlnBNAQiQ7TuIVWI+pJlBhLFWFVrLlQVs8+AD67kypAgLEOWT3QxhC93fWmuXuhP6xbDneAU0SZQDJ+EPh4Qiw4wPIo3jnbvjrX69m/+3Wgs4YlKbA6zF50JRUAX9wkE07eE/+KZ0NiURwLEW4X7mpHUtIZBUbrx5h8PZWy+9QBtF34iwHgFo//QVUwqINDFm22p/iW03bCzqQlNo1GLSwxDXo0FP9ga3mWQPYHEVMHX6aOWW7LaEaoGzX/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pc6+4J49PN+F1vvVg2OLQRpRbHQbulJ/KzpHKRjX/a8=;
 b=k55NTSMOTARWByw8zTc2q7h/Xwo7ZTdJHtvL9EGBFmI6AoUuw01Dba+XeCf2krxbp6Dn9LWRyo88aBuRTW4Mcc66iMdfZI6OJMnYsF4wlQfscVX63Y7xnm9mIxPD7pvphAMzVy1mN7WctVgWJk02utZIXUUiaFKgi355JcxVeng=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17)
 by MN2PR04MB6912.namprd04.prod.outlook.com (2603:10b6:208:19e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 07:22:51 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 07:22:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 40/42] docs: scsi: convert ufs.txt to ReST
Thread-Topic: [PATCH 40/42] docs: scsi: convert ufs.txt to ReST
Thread-Index: AQHV8GrfdZ3FrJEOdkuChcE//woOQKg2eAYA
Date:   Tue, 3 Mar 2020 07:22:51 +0000
Message-ID: <MN2PR04MB699177B6CD676EC86D52DA3AFCE40@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
 <052d45576e342a217185e91a83793b384b1592a4.1583136624.git.mchehab+huawei@kernel.org>
In-Reply-To: <052d45576e342a217185e91a83793b384b1592a4.1583136624.git.mchehab+huawei@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4300bb6f-96ab-4ca1-3b2e-08d7bf43af32
x-ms-traffictypediagnostic: MN2PR04MB6912:
x-microsoft-antispam-prvs: <MN2PR04MB691272422899369A18E3249BFCE40@MN2PR04MB6912.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(199004)(189003)(55016002)(9686003)(33656002)(5660300002)(316002)(7696005)(2906002)(6506007)(66946007)(66476007)(66556008)(76116006)(64756008)(558084003)(66446008)(26005)(186003)(4326008)(8936002)(71200400001)(86362001)(8676002)(52536014)(81166006)(478600001)(81156014)(110136005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6912;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VceNtpI2a0n+T0Ud+i3HcmpctHVGwQEMCMk7HlmyNdFOo9hGlFSRi+o7C7a2WDa2GwZYNWmKO09jRSIGDIG6Fc6P8NmEsQhED/HugkpvCK/M9OrCN3tVVWSdaZYHPkwLzaW8lTMAHFnHyw6qToHXVZxWSxpzK1xp7B7rI+K85PQ8xk3PcIaHs6Pu/WPrZqS8VB7AUCzhO5oEEAsDp/mN6S0Fk8xMWS6nVcShVM3Y1qy8MJKv5J996CfU923x+Y4hj8+FxrWtgY2qMRjKuhftEaVe894H44trWOoTNKAkBd95HfUERdLatykiPHABZ2Wn3KocTxHrNei6f1chLjSxqpqv6WlBcFmAxNwpf8geBI3GyzNzlQq35mmquo/M/QGYpXf8xqVtnN0ERKkuJfSvIcVY6HTwUJXIVjHVHwOzxSA3QjNWl0N+17Z3lDiCHOSo
x-ms-exchange-antispam-messagedata: ekZ+okmHTqJjgcF6Q6WxrMhSK6446qnt5KpLXfUncXJ+yYhB1Qc04ei9B0o8GuekpKpagz2r6Rr13aCrDuHoSxUBX9INQbNJ42N0K6nwZZGTx3+rHc+OjiW+sM9W+ejXGmdjjr5BTTZAzfJITFSpPQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4300bb6f-96ab-4ca1-3b2e-08d7bf43af32
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 07:22:51.7939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JCdeiSgXvdXbvMWf5e48NmLJeGRHwfKo3X0g9CfrVTVVi4TyPzN9REnG5f7XN9Fl9lGi/TYeay8RwEoFz918Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6912
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: Avri Altman <avri.altman@wdc.com>

