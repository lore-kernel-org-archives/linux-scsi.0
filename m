Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FDEC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D73E920661
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XOnAlseP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jkQPe4x3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgBFNVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:21:30 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10753 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgBFNVa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 08:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580995353; x=1612531353;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y2N4sYKQTR3VkS1UnfnzEdzH6qS8YfuaE0YLbvxPjhg=;
  b=XOnAlsePsT+3I+76k1v5WqeF+X3Lnv/r9+/8NGb6SZJK3EO4kjG9hthz
   /gOCM/66s5Tz2z5hhFRsBS7GfRafK/nqMIi8iaXelcIUQoq1KCZ5OyLOL
   BZF8K9fsdtYvNwbF8abSoFyNNpHrK/zaSwDguPdZrAvvcZlWUlmCmLNOJ
   qajo93lwnAyq372tNWVWjhyHf6bMzk+df4kALjzXYR2Y3KLe9OI67QK7D
   PYAZ+pJtJuOXrvl48ItjAFwEWkPCaFv0XAxbUDCMA9XE67tenHlHzmuuh
   jPjG/f3Z1spqN3iG5LaxVjBi6oavj9HXZM3Zt5M0qONs5OPJBaZalVGyW
   Q==;
IronPort-SDR: 4NnxnfyorrawhHdbeurSnKhh7nVxLUkMVpVg0amSR6CyM9vIMbqOWY1/IdAROLYHsFl0wyGKdQ
 gixiVcd7z4m4reta3nb4dIaPFuz5yVNpcZDhoAjDemSTLIffC5NlKAL3K43eKVw95g8ZfSlFhh
 gnyLTnQNsjgvwWWQgp6qH6lUKYLTBS9KkE2PPhY7sb3wQtKzQQTT+kHHqdzRgxcxRRR2pLNdlH
 tKQSucx07IlU1pkK77JFtlRwPhcdPksbcF2TbsJ39Ytwi0B9Pp8XpNZxS0l/JEXqrGL3prvtUJ
 9IM=
X-IronPort-AV: E=Sophos;i="5.70,409,1574092800"; 
   d="scan'208";a="230999734"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2020 21:22:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXXPY6Do+cABtA+BsOzWInDkd1962CkT2lHZYuLNsxrM2gLT3Arxy+vmdpWnB0CgwQgNmIrPPQTzXFcaGiNo/HTsAHFCcS3eAZkI8+RLzId6tvzelI+DqO1FH1W7t9UyIiErc7cFs2VJk6T7cT/oPPCDCxp1UVaYPVQkHFCj0PUsXf7ck2PIZWyNNzeucHyXEnRBpZ8BCY08NvMBopmYAlTqvGvRCUqxd3/7jiqDZ6wxUpl15DEcw8RdO7J2VeZmSDTcGX9fsfhLfo5N/ySdDoxHJkcemTVNmkwHiOSvWMdOo3NQQ4ui0ogHk2eylkd+Baa/6TebFMDQW8W+wOgC2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2N4sYKQTR3VkS1UnfnzEdzH6qS8YfuaE0YLbvxPjhg=;
 b=GawakTmYV/MbL31sMd1Ta+j1n9Wb01coeO5Pov0ou/A38EnYu66e5HKQH123K1yNf9ovG1xwXENEjVBnhid+ut0J9NNnQOlt/78DIC2HzL8XjiH5vBsAGZQOEaGxxJc4hSYe2edT6ShXiC/w6ee/yR9zr4vwUG4EAitYJdz43WeT310Vgt6dnhNF7cG2+1O4tqVIWkJMMoaRUBuCQq3/vW81WJBBDWS20fq0bvk8M4gRNdE+ViAq3siCqEJHjkVBP6SJWaWQWbyquEqNzJHoWlpqefHKMsh53BzGnh9cHUwOWrqKsJd9PDhMmqQJn5+WDHJnZPc273QIoYpUdD0+VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2N4sYKQTR3VkS1UnfnzEdzH6qS8YfuaE0YLbvxPjhg=;
 b=jkQPe4x3t7q74H+JKJPJuWpL4rMnRyQGDEXUjbh2CjrTLuGFgkQVLmvDWHDZNZVSUpXfTRNR/waCVmkI8Ee7cnNa5TQ8KYaAADL5T7CdM/7nqGo/BnsIhM/pGozN+EdYDnJwTAOQPYeNjlIZyR+9ySPLlkq9pl8iRXXpk4gcRP0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5997.namprd04.prod.outlook.com (20.178.245.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 6 Feb 2020 13:21:27 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.020; Thu, 6 Feb 2020
 13:21:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Enable HOST_PA_TACTIVATE quirk for WDC UFS
 devices
Thread-Topic: [PATCH] scsi: ufs: Enable HOST_PA_TACTIVATE quirk for WDC UFS
 devices
Thread-Index: AQHV3MaMtgu8HMpv5UGzOGGhOPfwHKgOJs1g
Date:   Thu, 6 Feb 2020 13:21:27 +0000
Message-ID: <MN2PR04MB699151D32EEDBE1CAE449FF0FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580977315-19321-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580977315-19321-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04568df7-08ac-45d5-1e5f-08d7ab0778af
x-ms-traffictypediagnostic: MN2PR04MB5997:
x-microsoft-antispam-prvs: <MN2PR04MB5997CB678EB8F18BB3D2396DFC1D0@MN2PR04MB5997.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(189003)(199004)(7696005)(8936002)(8676002)(81156014)(81166006)(110136005)(7416002)(54906003)(86362001)(316002)(5660300002)(33656002)(186003)(478600001)(6506007)(26005)(64756008)(66556008)(71200400001)(66476007)(66946007)(66446008)(2906002)(76116006)(52536014)(9686003)(558084003)(4326008)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5997;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H9fFzRMcRtiUMi6VzCBBizLdnG73fVyAGQVJDjV0R8/GuIR66mrkLqgglIyaSI4+y2gBVTGnPMlrlxR8xVzUrTbnBDMa5yS5J4QMXmKHLntpw7jc/TY6fWU61cZVx+uh4DkpoVKJ9ynk4IauHTr5K1D/jE9a9zLLTG7oDlybKpERYnf7Jz81AQgS2rEllQVWYX1FgEadfXeOVcruetN1jg6rkyQfno9Xea0RTfjJG1UI/6doNnhBlxkRTNjC4k/lORTp+05oUfz9KWN5dIfk9WRYqa1qezw/h2k5zPyBqenaY3wg12rHs3Xk1sBq9BnxDeZSvQvWELrx3kYW+FSDiQFevPudgz267yar8ON4lGZGWZew0AjNNH0o4WJ6a8Jb8nvHefX5u4YDCQK99NRREbc6iuL8eTZL+7T9SlD8xd9E6PWbkEz8iuZxu8ahjLpS
x-ms-exchange-antispam-messagedata: +qQLk0X8upbtkGoUk7Z7eW85mHzMrsyZb878rK4hr7mHB83qtUWhw5I2Xryk8SZDPRw9mLaz9xmshdEP25EiGl5+jJNP5+/93GWu2SflmnMm7anL3xfu8z1MDE7VH7IpBc+3Z9KTKbBBJboXew7gDA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04568df7-08ac-45d5-1e5f-08d7ab0778af
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 13:21:27.3072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zyQemKxsKDf2bMNUm7TwvAOzEO7TduoKvJNciRwPsFQ/ouxmlzhAspQs+5GZmwQeZRlpF1wabpkNM7Bg72gIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5997
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
=20
>=20
> Western Digital UFS devices require host PA_TACTIVATE to be lower than
> device PA_TACTIVATE, otherwise it may get stuck during hibern8 sequence.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>

Please allow few more days to consult internally about this.
Thanks,
Avri

