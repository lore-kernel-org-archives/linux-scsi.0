Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89674C43465
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 07:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467B221D43
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 07:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P9nkTrmF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="E9X+rxcf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgISHbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 03:31:55 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26391 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgISHbv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Sep 2020 03:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600500711; x=1632036711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DpmDv03ZFQ2rDcR5Sq0h1+5dTe0xhR4W0aRl3pnlwcA=;
  b=P9nkTrmFr7eWaulN+kRAoIRmxxy4ktAk//gEgG+EyaMLG+YzTcRxTQXr
   dKv5hNkioGAs7rcgpFY/ejDVJF44pZ2R+bbvFy1UvUQi56UunTUZ10Qri
   PvFcw2+LHIV0py9q/WfmUSSUcaAE2OIEN/m5UwgSG8b3+LxHoZQ7QQI8G
   jVIzzljM46t1JrlGlZSnzrjLwya8K09ZUNm51WEDEYYtuz3uw009kGqBZ
   8kI/KCBcY2yTyW0xbshhSGKlIFJao0uLno8mzIvX6EE7SUSKw62QxSjIR
   oBo8gfAcvIKiuKV5zOpttCVeuifh7EooOxsY+QxLcrUvkyS6MLzASWMRj
   w==;
IronPort-SDR: OVNaurijh8eNuASHcxF4mAt9TRKRvhxi2Jf/AroaV7SWKMYok9AxLRblx4jwZHTPkmw7fsz/FI
 vX958p6CyeZJdnkCV5Sk3hNTPxjHXCnmaZbXHxRN80MU9Ce9q7uiZi+Q/7Zii35Hc7hLaijjN9
 lFC0XwDkgJk6go3OhDmzSjvGu3cIo0OUALctcm1Fb8BrW1/QWo78+PtAbjED6hKWWmIiq5tNrV
 0S9dG9MSVp/bjEU0pCqLk1VEFHP+/Z7WwgDrUXZPhi3HG6T/4GRAiBDh1LgRhLd0wa1j0a1Mc1
 lqU=
X-IronPort-AV: E=Sophos;i="5.77,278,1596470400"; 
   d="scan'208";a="149016429"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2020 15:31:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpCQqfq88AO//yAn9IjWe6TNWjxD+hiBcsUrJzzYgdQNdcUDdSO8N7uBQKnwESpgYTK0vqNhMIxB5D7UDt4wLH2CcMeZW+k3XfcjcWCIWgpXnj+6YWmYvQI+eUj/lv+ug5bsR95CjVIuxXE9okh4tqwl5LyVf8IkL4xmeNBbUuYAExSo6xbhk2tesqe0V6Tet7pWdSmj73YrY96/sG3oovJPLuyuNWeo+EavpOeIQBXkcieq30mIZewXsga2POH/l+Q43KKm6nKV8YA/w4tiOwRieJy/Pt6xcFrLeID4E88HU6mAGdZIDh4yyMgPzBqIiscTNB4D1WKQndFIJnvkjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpmDv03ZFQ2rDcR5Sq0h1+5dTe0xhR4W0aRl3pnlwcA=;
 b=k61F23T8gIj+lYNb3MPPQNRGxS8f9xYGD7htsE6YyF22AAWDVJsELACB6MXuS3pNznhePircGpHatRIxqSxr7i6oY19gwgP6wqTy+LdA2kGuHEAToVXJMB11SD28DLU0Q5d+q1MRDm7/pNBDBN850IdVaxwQB5pbWcnED7mcfp5lVhjjckpiMbfsbm29ZpTzlUJ7ddQVwudA9qMtruOAXg0RV9ZLB2b1a8nS9Im61Xs05o44nVpUH34nXLziGFRFAOnG4CSC8hgsGbt+aL920WfyFn8CojR4jfkVE7Aki4pg2ycELes6l2qiyXai3237zJXlESTshn/PwD5lBmJHPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpmDv03ZFQ2rDcR5Sq0h1+5dTe0xhR4W0aRl3pnlwcA=;
 b=E9X+rxcfUHZoNlR9EhrLpJLce5/x3bdpFP/1SzMfNq0wTkKFirILZxT4/5pbpdDMAJ55yLtY4mk42crvI3zcGJrg/9GSscoCYdPL0GOzPQWbKoR7T/A3KA+DdNqhu3g2vKkSKprc9tErw1jKAd2VZaE5dAMUqwREmqe1BKqMaBY=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6454.namprd04.prod.outlook.com (2603:10b6:a03:1e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Sat, 19 Sep
 2020 07:31:45 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0%9]) with mapi id 15.20.3391.011; Sat, 19 Sep 2020
 07:31:45 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH 1/4] scsi: ufs-mediatek: Eliminate error message for
 unbound mphy
Thread-Topic: [PATCH 1/4] scsi: ufs-mediatek: Eliminate error message for
 unbound mphy
Thread-Index: AQHWhaugYPy2JozBXEmxUsUiMtnzqalvolHQ
Date:   Sat, 19 Sep 2020 07:31:45 +0000
Message-ID: <BY5PR04MB67052FB35C97CA914F037FE9FC3C0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
 <20200908064507.30774-2-stanley.chu@mediatek.com>
In-Reply-To: <20200908064507.30774-2-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a81b0a13-69ae-400b-6eaf-08d85c6e0ff1
x-ms-traffictypediagnostic: BY5PR04MB6454:
x-microsoft-antispam-prvs: <BY5PR04MB64543AC4671E50206466EF0FFC3C0@BY5PR04MB6454.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FCdF+3d1r58FHvzLAR4QkAkV9sjZfVWfoWbAU3uYjvtYSAKLGOvIkNS3J0TFIPvfTTUzkIlMBbzAD88KxtPvs0tPl1SEPuiKZxn8Ir7WiOXyfHD8wdDrUJE08PVA3cLvUMIUIdMleVPbv0CvvfYJQAonj0ljb+FixBR5Ink7z15krMNCH1WS5vF7cWaOyZZg8YxVCdEgEKKFGd32CONaeK5rTHXgkcYeDMn5zfob924yJ5ZD90fg227UxB9AYlkBfjvpdZxwrmyKgQTwL+FOHkApDOcjxpVaeJ1jos6cMRH5KuVunZosmJbFhp0ZrdSuTY5pLNGLspkEjOrlAtvM/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(4326008)(66946007)(52536014)(7416002)(478600001)(71200400001)(7696005)(33656002)(5660300002)(55016002)(9686003)(2906002)(6506007)(316002)(186003)(8676002)(26005)(86362001)(8936002)(54906003)(64756008)(66556008)(66476007)(66446008)(558084003)(76116006)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8zPCDG3Miu1JPwrS1pwuKcdmbcLxuY04MiUS5OFLiWxqMBat8ms2s7j2cG9USiAGaTnlJASSeap9XCW554tF1V7sjNxZgcVH1WftskarKON4z03kSTjO+yNIg9dNi9NF+Xw1CsFyDVJZBSlR+tW2uja3+JXkorGYUfVZyAl0BdZnetHGRktmjF11p9/Cet2Yj7+jrIAVimGvIOqo2cK/tCoIVH0xtymMu460+yhBxf2tDKLO736hGGPwyEsG+OxcelmAZ7L3jbGC7kLwFZU5SM9cULsibw3JT7Gr7jFesBpam//4oYCAwZV46nvB4zmcE2SiMbDR/GgldDzatGRe1Gj3qMXeve1/DVb/OuK/gLoi/C2OKlZJyGFQ/cT0iV3UDG6RlTp1vnzwkYr4OTgwp3vjTYgi5GHcfZQklotNZmEoElLVW129wzFlhzeVqLCqjwVY4V2DCm0GpL98DIQfvPgMs1+mXkAYsUvJ7nhf/y0l+upVWLqfLGa16Dk+l+B1WWSp67iJSolPyWj2Qt96B5GxQEOI22umXS+FOLZEQ/tN/VNwR1szPkrXOu6Vb74av8X6XxOvMSEXICAV7p6+jtnfgakfcDogaDvI3TtudrRW/SrcILsm/BbeGdO9LUX0s8/guTDhtNcH5xF/60XWzw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81b0a13-69ae-400b-6eaf-08d85c6e0ff1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2020 07:31:45.5020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gFGqjkWH4KAq7nTl9KFkqRvRxFrKoN3YgmRWqXPWcGg1uRVbPlbNqjWjPGuJZjA0IPGwxh2/h8hOYh2lVPFL1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6454
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Some MediaTek platforms does not have to bind MPHY so users
> shall not see any unnecessary logs. Simply remove logs for this
> case.
>=20
> Fixes: fc4983018fea ("scsi: ufs-mediatek: Allow unbound mphy")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
