Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67EF2C3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 07:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C49C214AF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 07:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gtoPqYCt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IDokG2/5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDTHOe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 03:14:34 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:63860 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgDTHOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 03:14:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587366872; x=1618902872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KwU7xueAau9D+GU6TFQHWns+Dngy6h6T5a39ygBn5WE=;
  b=gtoPqYCtd2Tsy2jHywZAvWH6Lz1Wq7kf3Ejl9IG69hUGxYOTbVDZzCwx
   N6KOOuA5nE1bA2Nq/mYwF4wAKv1d5ijEPC7VHFxWvv5Rjg1r4GHiPM7gm
   Son2a60o9TWaxiEys0GaKZUajsPh9CJLeJtrPD5X1FgwrUBnvXPdspDZ1
   bBV2mFh9zoVL1KCG2N75YN+IMykPAU2bwMox2sZ1hbQArn7wtGV9J3lpo
   909016hprSNkemfY+VEAEo9SDsnrV91eIKyIqbzxd7FnXFMusY51x/z5K
   1iyEYMKcmeEeesceT2/w+Yn1AdHPrK+2hzd1KeIW9tvuVIQdcWLIQ7FYR
   g==;
IronPort-SDR: iHu8Qrvlhi6TppXa4/5HgckMMUuErJFlteZnfI2dsSdWkixVgEnPctKBgX2qqx3pbE6TVHSuk9
 pTz1RMglhQvI+F1/kJZK5ChVCOD8LEZDhcEBke1v0ZbN2vrYGUNPueLVPJM+2KWOSZph/eene4
 hgRGgUh/lfTK1E63uiUDY5TaRcFWesjwEjMXFN8jNAUQ2T6lKQT/vcdjk0Zs+NGVl60Pvm0Soj
 9dNctr1p2znfar6SKSvnEJ/dbLqMqeK8y8oyktG93ukXPDn+XwUYVqrzJVTP2hj6bKIRxoYzOD
 tP8=
X-IronPort-AV: E=Sophos;i="5.72,406,1580745600"; 
   d="scan'208";a="140044046"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2020 15:14:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/T/+zOGmkIIRzDGakv+uBc/TDirFP7HYEBa9RdO65N94vymWWyXJPF9CH8XV2bc4ABrdj25Hr9C8LlMqN4btjOuYX797/o8ANERR4qfweknAX014vDGQZBOS5kTmkmrhxAKyz+cJ1FdO22MVAaSj8Bl7ij353k7AhNJzkEdjHs+Zab3xQ8xXADJY7LZrtzJ2ntMhsxi1pSIvRavcZwAXDNf+CV0P2Tpc1jP5clU1Y0k66WFiHWaXFZYFfTWyD9+ZYrw7WbITPLZkxBpiJclqFqSVKduJQ6HVYkBf/V+KKG5v0nCTs19YEuJwaWH0+X3h90lWWF2oWR5nNZQyqNRLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwU7xueAau9D+GU6TFQHWns+Dngy6h6T5a39ygBn5WE=;
 b=jdZFQuxwtSkHUo6Cql5AGLJONR0g4mNT1QMk8jlGRwh/A8oylob86IuXS3YLX+mZhmdzUuKKvhM+WVQ6nLeahKmUV7jIJDL6mK6xt4S5ylkqAfHHcTheQLRv9B1mBh3Q1/GONLDUMviAh6Q7xCB3jLUx3Gn90pfbho0dVjc2w6lBg0E0LYeTT1igD8pmlqhilD9EX+E2RZYt/ek4yMsuocU6JXDdfjJOfEzMc2kbhM/n+KIbjxfkg/l1N+tiBbNp4XtEtpvI5xtDJ98UXvTXHpjcbIySaF1CngMKZUM6iUGnWnbjwo/9z4O0tRjJDcUEj8t9ynSTw9H4BItIiFFEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwU7xueAau9D+GU6TFQHWns+Dngy6h6T5a39ygBn5WE=;
 b=IDokG2/5j8EL4dKdnQOZWiq4HkHzdjOWqXtyntKy+q66m2bebmx75sJev4zd4z42XXVbLmOFVyzY5k60dqcZSoGplKABuu6X8pqaYKJGK3W4EWcwRg/z2hF+s/xKQRy6qXFyyKb0WeBtl4ehW5tQ1l8InIql2iH/c+x8O617lS0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5216.namprd04.prod.outlook.com (2603:10b6:805:f7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 07:14:29 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 07:14:29 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 03/10] scsi: ufs: add quirk to enable host controller
 without hce
Thread-Topic: [PATCH v6 03/10] scsi: ufs: add quirk to enable host controller
 without hce
Thread-Index: AQHWFON2F3tEHGSKoUec1wnTuJZOw6iBnIZw
Date:   Mon, 20 Apr 2020 07:14:29 +0000
Message-ID: <SN6PR04MB46403B55EB956336690B0C66FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181012epcas5p2004ac8f0d793abd4d58c096ff490da68@epcas5p2.samsung.com>
 <20200417175944.47189-4-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-4-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3463cdf6-b593-4b35-e11f-08d7e4fa7799
x-ms-traffictypediagnostic: SN6PR04MB5216:
x-microsoft-antispam-prvs: <SN6PR04MB5216D064E09B63E65677511BFCD40@SN6PR04MB5216.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(54906003)(2906002)(71200400001)(4326008)(110136005)(7416002)(316002)(55016002)(5660300002)(186003)(8676002)(81156014)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(86362001)(9686003)(7696005)(558084003)(52536014)(26005)(6506007)(478600001)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: imFiLJQLrq6/+8Ob3ol70vuoq2+bwySpC/nMzYbARCfJrfc/lpjAuJzwPqwQYi48juk2vTzW4bj57VLhJs2EkRqjSmoJuaobx9g97st1jWRY8QG6Gc+kpIVF24Km6wyeoXao+n3IWlmov4po2FZI1HRpC5XFkWwteBLbNHLDblJsx+D6DhTyf1mJxsL5ppXNX+cafTveUrZcS63t04YpTAcO63dBySpx+sf1BsCK1FaHWGbut4I8T0eQRsFNM+cGWDlPD9/3kia70vkDIkVfllEHbiOMPgQo1R3I6q5E3W6d23Szal/ADSmDhzrP13ulS/1gGs7bfbJh7AEIQiU/GJEIkTX5YK2kWPHhiEwNt1ybYV9TdNkyDaHlE6SaJAwxFxI6DALw4VhY2QiyQnZQMnd4XNPD41pzJiC5fJQW74GWgpxotwNZWNtarXRuAXZL
x-ms-exchange-antispam-messagedata: XdXdP1NyAWF5duhh4xXjAN9VLtPzzhfzgVZDV0J7RbkRIY7zPd0sKiUR52hfattfnulev8J99COSPwdm6a+ECEyvk77PfLW3k++SMB/YIV2UZVhILlWWaqVEjqDFQcz8iNvfb65c69VIqaLPEuXxuw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3463cdf6-b593-4b35-e11f-08d7e4fa7799
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 07:14:29.4635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /QQT87oP9Bs6Jl1I5kIp1pFJaovHZxJXliFuLBQLpaj4W/5l9ywHiYZ7gFOq6Lh7tcByGtxn1GFdnk0l9TF70w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5216
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gU29tZSBob3N0IGNvbnRyb2xsZXJzIGRvbid0IHN1cHBvcnQgaG9zdCBjb250cm9sbGVy
IGVuYWJsZSB2aWEgSENFLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2V1bmd3b24gSmVvbiA8ZXNz
dXVqQGdtYWlsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQWxpbSBBa2h0YXIgPGFsaW0uYWtodGFy
QHNhbXN1bmcuY29tPg0KUmV2aWV3ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMu
Y29tPg0KDQo=
