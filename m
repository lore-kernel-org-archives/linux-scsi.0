Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A46C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 11:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B143C2076A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 11:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MLBbvEsb";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gPnxNtl3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGILJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 07:09:24 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:39800 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgGILJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 07:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594292962; x=1625828962;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W9bIVcjMLF66t5ln9VLgWcuzP1iCx1NxlRfonIJDFQo=;
  b=MLBbvEsb2lhBQvOdJXUAh2LbPVrZUKKep/oo364xX5r1CsL94VWIhqd3
   DSYvdBLXcpDJQMwscdetfKzGiiH2OIX0svISjvncVRIXQ6qBHga9r9y3b
   usQQfyPS7osyMTdnRp15xVwyvDChqLtnKfhPjfU3XtSotvGkG1rUOqBFe
   jx3bCE9n9Fy65GjEZUqQLRVeEVZ7gbkoVBZ/2HBIaAHC8MkD9EUUd9Ybe
   emJdDh11OtBJ2VK14Vz1dyPL6B6HRdl6gOufpFiNrrR61RHddANPQwZUi
   KbnOTG17MOVSomZ3jMIKnt3RsBCXm+eJEbW10kAF5A8Yon3V0N1OiiRPJ
   w==;
IronPort-SDR: lSiTNE5bzgXXJw3jgvxdfKV5xPYBU/OEm3GRzwK/jKnCzSGsPEX7XyC3nLFNO3wcmWKBEIONzR
 cpZU705V4btcxNOx4VpF2Jhr92UTtZBJ0FeZtIL1bgpyMnjDATvAZzQAhFBkj/prhCceX+sCEd
 jwwKcyhLHEM37bfNAderSSjGLonpC7ReBr+/fOzpg9r2Ck1ru0cXUNzkkixJ7OdsBgvij8NT9c
 4ayvJNXMlduHqlUyBy0ZAf/NJ70XQdWcqlHIP5SjRgA7zNCk7K9k3DoZ0Gl0d1Q9Y1Szd/Ihh3
 wk0=
X-IronPort-AV: E=Sophos;i="5.75,331,1589212800"; 
   d="scan'208";a="251254663"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 19:09:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+lruQujze4sA3bsQqWO1WNkAqblMM0KSXKUAUTVsnyPehbLzFlbhULYedRi9V6/lbW9iNqZD1dbyc+VBFSzZEBXCwTXy+9UyT5X86186uK5Y8RkMRR+W1wtli6pcWuk4D/o0phDq5fR/yrc2c19bLQcAaPt8F42tg4hP38D5HY60Lv0iwR6tVttzkY4OYgQgIb99evJvs9ckSsyD33o2/jGBmqZGhgcejRAiYYBgZCWUUBaVle6uLrp81h+VjaecGnxvhyPZHUe8nBqR4vWYVngI3EGtrKBiMr8cwY/ceiJuibs4DWV+c24IGA3YNyuzfX5wXh6LJFARalkavwVbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sglOC196SCdpj9I4HskwHMIiPN5E4p5a8l4wEV79t4A=;
 b=W891gJ618oE8mo3EM1e0JiAQgRzFKHtZUQNwyjhxb7+r3kWdoKR104HRRutrVwmMsw8S9V14iLGO8a1ZNSkl6wj9cReFKKyDYe2k9zTCU4aM7iMPsiWbNryiMinu09/RBxnXrTlJzqJDRCj+6daPOr5C44HYSSLEpiaI513CZg4VZ1guyZsUDesI2jmASraLJghJ+ZKdxFh526Lcmak9q9ZOaGJxVjEPSuYFg3HDJSqFE2LnnbevSqt5EMy28g1DYojY5eWHT8NPgXwPrR+dm7q2Y9p89ceIKUcflzG86RpUsrXwRUJ+zqRR8t3aMnJaT583IwWKHhiHPPIgHPPaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sglOC196SCdpj9I4HskwHMIiPN5E4p5a8l4wEV79t4A=;
 b=gPnxNtl3DVs8qgVvaKb2NL4lKTeaDN1RCVTdGSoYQfTImT30WqFEOLIHbs+fmVYBWsLFUGsD5Izes8W3x1+ATO6Iccno76B4tUrmyVCNnmiClNyLxfSWWPth5hu9xI4Pufi1PrxmfR1SHy32UlMVAR/xULSW4Sepo/+qd3htETg=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BY5PR04MB7043.namprd04.prod.outlook.com (2603:10b6:a03:223::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 9 Jul
 2020 11:09:19 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::40d:aa59:cf3:2386%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 11:09:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
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
Subject: RE: [PATCH v1 0/2] scsi: ufs: Fix and simplify setup_xfer_req vop and
 request's completion timestamp
Thread-Topic: [PATCH v1 0/2] scsi: ufs: Fix and simplify setup_xfer_req vop
 and request's completion timestamp
Thread-Index: AQHWU1uzfqR14Wy2LUeMjMJ0UfNXgaj/G/cQ
Date:   Thu, 9 Jul 2020 11:09:18 +0000
Message-ID: <BYAPR04MB4629D34091B0059B077CF98CFC640@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200706060707.32608-1-stanley.chu@mediatek.com>
In-Reply-To: <20200706060707.32608-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 293978f2-bec4-4c65-4f94-08d823f8868b
x-ms-traffictypediagnostic: BY5PR04MB7043:
x-microsoft-antispam-prvs: <BY5PR04MB704333D7ADDE62DB68A34EABFC640@BY5PR04MB7043.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xOzvkWKkOv1p+ddqjs1FMNcWZX2tvJaTmGgFHkOLlkV0FFDevXv9NjVge+Kou0M8giZYGysv3PlApLyz72WrhbtGAjzr5+m/uizlK4Y80qB6FplBI66ngbnMBE5pzX957A9F4OjvYygM5rSPYCv2PZdT2yQ4kmlZEWW/2TLlsNVKHXoA4qCajrxvdldRHPJKscR4zlkdQATLrM3OjxKZTuu5sTm2YQMGhxed6JgpznjgKNF+tnseuvWszWbg+KmFOx38ECHYmBuL7lnErcSpRfwt5AzGWtaj7ldzqHsAco/XaJihxB7tiWpj8nzRyXseoA1tVX4wC6CDabYIIy7p5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(186003)(8676002)(26005)(4326008)(8936002)(86362001)(71200400001)(33656002)(316002)(7696005)(4744005)(2906002)(5660300002)(478600001)(6506007)(52536014)(7416002)(66476007)(66946007)(76116006)(55016002)(110136005)(66556008)(9686003)(66446008)(54906003)(83380400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /GlEsgG5NMVAeiKv+NnlS3sSX5X+elVsRXEH5Cep+6wmj9VTV95xjwKu3n3hJ/AeKSfCXOWYA6ahmwmvozYayTLkY2N/mPkH62WMPW0OkUPd6k5Oxg5AI9Cy76YOUgKI7PHHavF/tLzl9T9paSgSBC+KSSKX8NUXE6r5mhDAatSXpQYEXKwM/IucdHPSsBq5rbIjExyEkMpqnNNF7bTiLLcgZNtpc9Ids9bHSSuO/nFLJ6poSfPP8XmsbCJzuEYt5KS3KnQ8VsxRgt9xjVtDWebwxKlI09H5o+GffL6N1IouLNnAZVNcMZi0KKYXFlwp46ONMRM+fTGWRIy9lmTZjgEXXPqxeW6Dxa/hsQ2pt+BgvHbuJrOds8rb65ok0zGAIY1It9gOXJ8amSagsq+Qk+MPs7ESkQDGi1ZxtH6kWZWZsLiW/G+iIrp/WxzMz6TY8b+gRINPynsrLz3/lsysAP3YxIYCqCMH8cabrfEOLm2+A9ltPgtSJPsRHo2gVEX3
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4629.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 293978f2-bec4-4c65-4f94-08d823f8868b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 11:09:18.7014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3NtM1ssRg/b39hiivGZyCn3V549XHCbejncGBGJGsGx5RvsUmO067AzQaf19187p3pzJxzze2N7YlEt42nEh6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7043
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good to me.
Thanks,
Avri

=20
>=20
> Hi,
> This small series fixes and simplifies setup_xfer_req vop and request's
> completion timestamp.
>=20
> Stanley Chu (2):
>   scsi: ufs: Simplify completion timestamp for SCSI and query commands
>   scsi: ufs: Fix and simplify setup_xfer_req variant operation
>=20
>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> --
> 2.18.0
