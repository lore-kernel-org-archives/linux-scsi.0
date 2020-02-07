Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01102C352A2
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 11:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24F020838
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 11:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HugGRueY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JCdnuea3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgBGLvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:51:36 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38129 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBGLvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 06:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581076295; x=1612612295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7JvqbgDRKRepoNrQpOvxzpbeaHw2H2qrK0DjCcAYfMY=;
  b=HugGRueYkc1QDZPF9vOA99iu9oH9hjxHNxxkgjt7DOTvDzfIZRNqWuFO
   AHL7VnbQXFBZWNm/Gb0u/1RrmwezF/2cRB7Lrsfcohgvioy6ZTh038514
   IX4n9tFqjUKccdWzllyVvObmP768oithMeL0HX+bNfZOmQcvgRenU9VeR
   MWn0aQHH+dUyDoe1iJvm+FhTS7NPcoO5n+nIhYQP/Wt8PNaK0AgNk8gJL
   nsRqEbSct+L7DoZBsre72R51F+EOuqaPXiXE+8wF+BbscBidrxa9FldEj
   xsTb+udzgjSZF2Wwuijn3xIzhHGltBpQ1R5kHztatp77FzMpQ7HaLFD/i
   Q==;
IronPort-SDR: BdFeLyp+V364DIcYxnn1L4lO10uUBuADUaa96c4qw8R9LLrAoJl4c33ifimf/wVpmWq7cetpg1
 ctFpjeClG8PHH3ViDmq1SR0O+ofSbosbZdUagX3gAPq9R3ZPbh6LRjfR0Y1kRL0K3o0YTGzI0x
 ARIbG1jqbb9qAi55u68g+Wq0SqZ867oFEBL/KI9RTVrUkayKUkqwDlnhD1pVVeWqW2svkePuLN
 FRkW/C3b7zt8A7srkInz84+2R2KzJZ7joKVP60UKZulC7X3FguR5QXV2hnq/IrjqafvWc/CMZ6
 RmI=
X-IronPort-AV: E=Sophos;i="5.70,413,1574092800"; 
   d="scan'208";a="237332414"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 19:51:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAWR+T2KG8OIcY/VkrDaEyGRLVwBj7hCxYaH+JPKRg8D38eJfx5Ojm5sW5T3SyaxZMx2X+U3GRMJ4SgxsD4A2zRSr0q+fNberBXywaKFbQAbGVDHHGNzq3hY49mXAHfzt2gBbkFReaMxdeY435lHqW3/mAxjW3uRfZZvqP7S6h6mW2vO/p0rzIrH4sxsdi7SANntv26LNhGmWXlzEFHfr/EiJTz4HTb7xLIggu/YLYHwuGdnPYM9E+he53bDRQaLSYuAJL+1H0nmH6+891tepXg3mP7as04LIfXdxTsR3nur/1isc48Ew2T5HCe0LZw6NjzhzHM5HwirXGNj+xcsPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JvqbgDRKRepoNrQpOvxzpbeaHw2H2qrK0DjCcAYfMY=;
 b=O2WcppJGk3nU7OG2TeMMKxrXeCasQPJ3EFcbG7QWriwaxt+3wUn2hAN9f7GSTyDPsI8H/wVIW4HSdrXXpuZQwvxr0zKJb9WtJzYNdXJet5qKxP3KNqdw93DG9aMaHEruToN/GlXSnsNWqimFTVDcIpHMSjnUOKY98FxMias6ZRh5bYglxDgLj9hCls+0liPM3sSfqToo9h+0jofy0GJ6ODsjxr7xFGTffVKHehnmfuZKYhTQZoBBwTgTm15/8HrzQ1tB/+FoTgAzlwZSguwyUD+vqpT/RrcjTZGDe+hRGyiOPDpxo4uS1OWqgdAjHHaEKgFVtGdzN65bvzPtoDGIkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JvqbgDRKRepoNrQpOvxzpbeaHw2H2qrK0DjCcAYfMY=;
 b=JCdnuea3REoijYaYOkXPo4GnN1WwhsaZz+sGMmWvoxi+AY2TgM9XB6ZRjpYFvx73ujI39UaNt1ePk1Foyvlf+f/JBFYg52UbFf6tYCurGTtEAzn1jmwPuyz/WQLEqCnSbJ6A3s39W5i+XdZGbs69px7U1ASsZM2WimTN/XkXdJE=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6256.namprd04.prod.outlook.com (20.178.249.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Fri, 7 Feb 2020 11:51:32 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Fri, 7 Feb 2020
 11:51:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v1 1/2] scsi: ufs: ufs-mediatek: fix TX LCC disabling
 timing
Thread-Topic: [PATCH v1 1/2] scsi: ufs: ufs-mediatek: fix TX LCC disabling
 timing
Thread-Index: AQHV3YTNtuZK4xh4g0avcKgj0kme+KgPnotA
Date:   Fri, 7 Feb 2020 11:51:32 +0000
Message-ID: <MN2PR04MB6991F49245F71086ACC7A8F3FC1C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200207070357.17169-1-stanley.chu@mediatek.com>
 <20200207070357.17169-2-stanley.chu@mediatek.com>
In-Reply-To: <20200207070357.17169-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.137.114.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ffb25cf-de4e-4aea-f1d1-08d7abc41348
x-ms-traffictypediagnostic: MN2PR04MB6256:
x-microsoft-antispam-prvs: <MN2PR04MB625649283DED088D37D104F9FC1C0@MN2PR04MB6256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0306EE2ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(199004)(189003)(71200400001)(5660300002)(6506007)(316002)(8936002)(2906002)(52536014)(33656002)(478600001)(26005)(7416002)(558084003)(186003)(55016002)(9686003)(7696005)(86362001)(66946007)(66556008)(76116006)(4326008)(66476007)(54906003)(66446008)(64756008)(81156014)(8676002)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6256;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 77hneixuK/VoH/VoBMlua/LeXoYwkFED5iizP85hbCEpoUuAJrPW7tsRm2BsARuEIW8IhTy0GwU8R3JFJQXZSxWIYUOwFmD8ShK21Pg7yjNixHjrCO5+l6+18OV8+h617yIwjlLCGhgJIZjxFfs+JvkaLGpNMvOjngk/ATLHfvrwE15qJ7Y3RnzH5EsapUIOgWRW2tyKo1n7oLFNerO0PGbfUGX4BrdmSVb4IuthF+eziI+UlUHC+NeMPR5aSlmJnV7H2H8O/zn53Wyr5A1BymM1fhCvc4LtED1RTECj7OpuiLB3uX5AMSoJd/szH3fn9JoxwLVi1Z09MN6uNUuepCZ7rC70h4UZl/DwefyWCPqA5+qjAQ2LlXLLHagdvRc2E6qqvlAsufmvLltmDFyoVyseJb7Jlojo2ItVuq11IKhMdOO4fteeDGmUDF57HAyg
x-ms-exchange-antispam-messagedata: o5Ls9GzLhCtzAHunXBo+M6x2Bg0VuT2NIhpSdRyr54DjZOLoUDAa9F5lFuiCfmjkv/DMj78quBVVErFHdUlaHeVdNGHb6ElhR6fBUqDR3fsYOX8yqQ+ZW+OMEw1BSroyMRPH/RxxvjCevY5mL6yDXw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ffb25cf-de4e-4aea-f1d1-08d7abc41348
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2020 11:51:32.1283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tv4BQIa/CwpzhgOG0jItlvAXc0zlOQDtvtyoEjQ8cmP7RxY2GXQRIaXM2xOoc8Eoz7XkGzm0Yx6Q0GAEFm8RBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6256
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> MediaTek UFS host requires TX LCC to be disabled in both host
> and device sides. This can be done by disabling host's local TX LCC
> before link startup. Correct TX LCC disabling timing in MediaTek
> UFS driver.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

