Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0423C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 07:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C99020717
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 07:08:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mXb3Su5K";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="AL9aa8I8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfLRHIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 02:08:21 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:28599 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRHIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 02:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576652900; x=1608188900;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S6bTXvED8GBzOjBBXCmPzxc4JU5heDpTnSHkn/py9vo=;
  b=mXb3Su5KPMyWGcxENMDS/BpTtTopzFvZoXy4qw+V19dTYWcOXN6f8iUJ
   2dSH2XTNK0iWm3BRP5FlGvK9Rmy+uPg0X2OChAJkHqwLhOcmbiTolaTfP
   DXMbqdstViMuNKdunbXm7yuJvIq+ORlyYU+lrn9xsxDDh4xscSPmjBiQY
   jpKwROy+VfR7f8YEK3LCJ2+iRIKbY4uHa6cCtJ69cCyRKbFOp5MrHQO5v
   eCJiSE4bDBS1SQBRDKgz4DdDBC6LDa9HCecLY4fu3CnY3AlbZbnpx61dk
   S4sKi9CZnxNnW/jJno2pU4zfydGiVR0ylf9zJH715tGW+C1meVlK5ZFkc
   g==;
IronPort-SDR: x5NmbfCn7LbZS1aMGizD7YB5yf8XahYggn9ZuP0rv77917WpyWBpN5nkK7znI5yArWpugB9kpY
 gQ6giMEtzRCnf38Sl0ROhLojGYndg+7KdYqmS98u5SFvQHmZdC18tpIJVH+zAd1p3FVbLMf2+N
 s8rd0bHFhR4yoc0WJez7RBbj/tcwKF25E2vTYeNIR02/zN0Gru26sXOwyHpDMt4WU8NTl3i8dK
 mUD0C5+fpN+Q6i/L8puFvp7ZfoO+SypXr4DeDjFmZNeOh/6uU4cTDh4JvrbdZwRlay3u7pB2d1
 /HQ=
X-IronPort-AV: E=Sophos;i="5.69,328,1571673600"; 
   d="scan'208";a="125606931"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 18 Dec 2019 15:08:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2kbKXHUvxwVoVrUz2hI/0bbbrtn35Ln6q02QcgAQ1S2NBAM6LUWjVnxjqLo1UNilJbhNFwCAcbrB5GNEF16nCAR18DrtfPwJs3uH9IzJiNZuV0YyLo2GuWShPa+KGUkf4/Nh7rzoFk2i/GQ9VXfBqHEb0U6KwpMPDuTPRh4kNzgefveylUqwHPHlJm/OpMTc4Mzk3DcnxIow/k82Gbf1kWltvh3W5PUyCRPsYC0q5IsQ/3ypgjHHuKrMvLYUww9KsCODkwGEm7zitxYTXum4Zinc550rEEe/1+luLeA4p92Wvwzhw5Hou6EqdeOHwJ9wU8xQZQQyQ2svIk3UWFk3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYInGyhDAMLJaqAhKNG5tetI3WSvM5cBRjwkGz8Vjko=;
 b=QkhdwpBCcKE0SF0OMaS0vbglC0XUt0HdyAm2i7G3Wj8JOO/2xMBkhpWoazxIhwQTP2mPtn3hAi+koB0bunRPriBTNB8P2M3ZEvDZLza/p8uk5YeFibtP0gJPRCrLNgctbQYedx2L049YJ/8FsA6Sx4ZYtH8OUBIYvjZF+jChqOHEC48HOV4RpjtDmgo+dmunwSJdwsEGx6saUOIpSJHkFX+FKPnfUNQKfcQkzQl7D5yovksqQRwOnNbjgu9L+Gt+6qgg02ECpry4SEInWJ28cU9oYJUw7VlL3fhAUEfVZj9YBl+GszFPjeTJT5yPrg1x2FRJWLscYfOBGaZhbgiBYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYInGyhDAMLJaqAhKNG5tetI3WSvM5cBRjwkGz8Vjko=;
 b=AL9aa8I8fnqs7K/o9eJEsIS6JGWrnbTrWrBy/SWXjhQEG6aChPJ4X/ZYdzE0NP4TfYWuMWEx52vEOvMMzOwpv5H/fir1/WPeG0lTjpb0M580awGiLM1BP25VH1vSMPrOj8vHcnnPQr59RNSOeW64pUHz5S99k+OR5s5P54uZxXE=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6111.namprd04.prod.outlook.com (20.178.245.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Wed, 18 Dec 2019 07:08:18 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 07:08:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Sheeba B <sheebab@cadence.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vigneshr@ti.com" <vigneshr@ti.com>
CC:     "rafalc@cadence.com" <rafalc@cadence.com>,
        "mparab@cadence.com" <mparab@cadence.com>
Subject: RE: [PATCH] scsi: ufs: Power off hook for Cadence UFS driver
Thread-Topic: [PATCH] scsi: ufs: Power off hook for Cadence UFS driver
Thread-Index: AQHVtANSRUyTGWosAEOUELZ0k1qeaae/e6aQ
Date:   Wed, 18 Dec 2019 07:08:18 +0000
Message-ID: <MN2PR04MB69913D1CF1CC38F30A74331AFC530@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1576491432-631-1-git-send-email-sheebab@cadence.com>
In-Reply-To: <1576491432-631-1-git-send-email-sheebab@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d2fe8eaa-111e-466c-0f8c-08d783890f3a
x-ms-traffictypediagnostic: MN2PR04MB6111:
x-microsoft-antispam-prvs: <MN2PR04MB6111BE7E7F836F02181E26C1FC530@MN2PR04MB6111.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:330;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(189003)(199004)(8676002)(81166006)(71200400001)(81156014)(9686003)(8936002)(110136005)(26005)(54906003)(316002)(2906002)(33656002)(86362001)(7416002)(4326008)(7696005)(64756008)(66556008)(66476007)(66446008)(52536014)(66946007)(186003)(5660300002)(4744005)(478600001)(55016002)(76116006)(6506007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6111;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iHm/tOeaDISnBjnlmDP8ZFcCzSmK+hDfIfzylhiDy7dv0UHGRtIWJfwXJh5jtJ4aKhumCBM98ajGOZmR0IOBtK7brYxChUH6bBk3sQezZ46gs21Cwo1+dg+V+/rmV1r8eglCEhzzz9RcgjgCVNbp0hocuAhjYB7VgVV1gYZzbZBh+yfKguZ7C79YSqdOouOIoPlKTj38YitHSHPKb3KfM/M4WwhxuQRiBiRcH+gD72pFcWBGIMX0jHGJVYEa8R5iz8T6pBKLRiynyIRzuVpw26hA7Bp2LgcJwIzBh3uoPkyub2lLdaYOFnscWiB7mvr6OUymnr4IpEhk98lvZzV8tfjDxWMcW0tZzeLL2V+OY6mGjJ1k4zPW0Nrk7hFDd0JV5UfqxODqPRpjsVvveolyTFz9AtY/hXaGA8LIE+zV7JymJ798sMSoshpXTkhhczkTsGVmPkSUDJzXy02lS7hkgBQx8n4LyQMnjMnoTDT0vaEmtfMlApxEdDphN5EKUYgX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fe8eaa-111e-466c-0f8c-08d783890f3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 07:08:18.3464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RAKeqhyq8PcBGD2qZEqQfpmjP0wTjjUbTudulSxEI09j85LDvB7O3DbLRhspiMr8A6tOW2uwBEfMOHBj5T5Q+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6111
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Attach Power off hook on Cadence UFS driver
>=20
> Signed-off-by: Sheeba B <sheebab@cadence.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/cdns-pltfrm.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfr=
m.c index
> 1c80f9633da6..56a6a1ed5ec2 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -325,6 +325,7 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops
> =3D {  static struct platform_driver cdns_ufs_pltfrm_driver =3D {
>         .probe  =3D cdns_ufs_pltfrm_probe,
>         .remove =3D cdns_ufs_pltfrm_remove,
> +       .shutdown =3D ufshcd_pltfrm_shutdown,
>         .driver =3D {
>                 .name   =3D "cdns-ufshcd",
>                 .pm     =3D &cdns_ufs_dev_pm_ops,
> --
> 2.17.1

