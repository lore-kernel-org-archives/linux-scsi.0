Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA8CC43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 07:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DFE322B48
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 07:12:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cw3R2VbK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GaCw90Wy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfLEHMz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 02:12:55 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9051 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfLEHMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 02:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1575529974; x=1607065974;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=m8lGo17rIh/te0mgWzy5ZlVP2Ry6PWXYzWpmrxIrT+E=;
  b=cw3R2VbKN0T8CxVn4xfClnLPMaC7kM7k2N8E25Ys0UWy4/JtRwbUQfWC
   FKandQqStGzlZcxDIHt/To1t/nDJ+c/5RpF5t7ylC119GtRZiBaSdWKHi
   Z7SBzQrxlZgNx7GzGJSZd480DaGJwV8Ai0jPv/GJCehEfYO1FoGVHOjGb
   LeNh/CWuc1iACRZC7HtyHJQC8JAalslzV3QjJheDQbW4aMFlI+LJySl8T
   ihfOFGBLjEoiMugjoFoiMg6WMF97nGBiJn3U+/ubIEDBfOcUzAE40CFHJ
   46oYhhMevjGEhoRnyt0KjxpDC2D233caKVQCPbj3eEUXuwBqKiwt3x61U
   A==;
IronPort-SDR: MTcS36HvSr+U9AdAUY9jAFIg631DyI4pnmK0ONlIW+9xkSU6+vHf/5IfH3gybyWvvwkWa4XUJ6
 akMBmZ5NjJzn4hyf2tIXUMM1xlP9L75ZuYMVcObw6o4UGGnxJgN1xrOgE5zKCPf2IVeuO1ofK2
 r3wTLXEj3MA8XU42tO82d4ZFzQHMxpXHd3QvrZz/NnXXznLW64VuMvQwOx2n1yoWEac0xAJv4J
 oLtqEu91xjSSuwCuvjB0iVogZrslWdULV4Daiyx4F0S5uIhq8o7ptRC7Xe95r2M6dkhs3tVgIN
 5yc=
X-IronPort-AV: E=Sophos;i="5.69,280,1571673600"; 
   d="scan'208";a="232165785"
Received: from mail-bl2nam02lp2057.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.57])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2019 15:12:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8KICS/gu0SPz47G0q8RYuT4GIvFvNsZuEgH/V6mtGgfalYC/OImU/RQ04+rse23lPp0CPoik/2j6haThXHnZBcnxM/91XtOkkB11bSbnIBSPcgFiVVpWy9H5juk98SGstp0XXwd9lLA8y9RW+ksvoziQC+E8z+Rpx6EBpUPwoVuRi0wK4D11TL0+flHsSDp9cL2SUaPz699owGjNr69RlVCVf+IUk1lU4HG/KwQUtiFk+9GEsZEU6i9SulXhGf91+DSPhZvH/aeRdKwrfpO1PHricZW9EWdPKj6bYalZeX8i9V3GOUNj5fhAfVjXumIYy7wxkwXN21XOg4loAVFcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxhXssUH1BH0RthwU5MhDTEmAeEuheySibycJQv9hPw=;
 b=bkoKAuO9IsTohPkL4OqLxYpmR3Am2YpCdaZfmVT3stJ1CeTHOhU0pGf5zwEgoaLAhuiyuUUdQ2SsNbogjrlaG/eWBAbJji3iF/jEds7wQ6qhOsfekpGfWOSs3G5GvC8W/a8f2oIanq+bjGA7u+UcbEjdO2iyIsUZ0X/iXZx3ssL65YP1N7xcViWSwcCRJzztT5AV63zZmgwFDy843LWv4l2Kjr+xNX3SsTUdgDuFhF4cvDDWvgdYh4xOsA8J1fA/o8jgMUGdeVGK48uvXbYreEqN1TkBv7NDgiqA/Rb3hS8d1fEsEOmgQcmV+0X/7SN4nG8hqo9YtlwL94bSdDIEGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxhXssUH1BH0RthwU5MhDTEmAeEuheySibycJQv9hPw=;
 b=GaCw90WyY5RQlGqoijmB5e9hjEGMbUqiFmK5bMongIuoi/RUMRX38miYC7YqvCPLyKptKreYG2uhxoUnxDNUNtl7+HZXxgbNbNNPAv8omlnoC9bg0hay79AzIqbidYup5/zCs/T1AGULH+XZapT3X2iB7n7hgplYXEJU/wpjhH0=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB7086.namprd04.prod.outlook.com (10.186.147.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Thu, 5 Dec 2019 07:12:49 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 07:12:48 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
Subject: RE: [PATCH v6 0/5] UFS driver general fixes bundle 1
Thread-Topic: [PATCH v6 0/5] UFS driver general fixes bundle 1
Thread-Index: AQHVqxG3+fJSQaWReESeiNB3bVqxdaerIDAA
Date:   Thu, 5 Dec 2019 07:12:48 +0000
Message-ID: <MN2PR04MB6991BCD9C91239380228CB3FFC5C0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <0101016ed3d62f70-fd63eb46-fab2-4d40-afc8-25a5faefe5cd-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ed3d62f70-fd63eb46-fab2-4d40-afc8-25a5faefe5cd-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f6c4419f-e41c-47a3-e4f2-08d77952890d
x-ms-traffictypediagnostic: MN2PR04MB7086:
x-microsoft-antispam-prvs: <MN2PR04MB7086EDFEA0193282F76BDEDBFC5C0@MN2PR04MB7086.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(189003)(199004)(7736002)(71190400001)(33656002)(71200400001)(81166006)(52536014)(14444005)(305945005)(81156014)(5660300002)(74316002)(2501003)(86362001)(2906002)(8936002)(2201001)(14454004)(99286004)(66556008)(8676002)(6116002)(6246003)(9686003)(102836004)(66446008)(11346002)(478600001)(55016002)(26005)(186003)(76116006)(66476007)(316002)(6506007)(229853002)(66946007)(7696005)(25786009)(110136005)(64756008)(6436002)(3846002)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7086;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z5EN6ST7KzE0rsah3TW5NUwz72BbYE8I1Bnr/cJwde7qGkK7ALE3qSiZg/90kPjs/f6rS6VIsPnr+H2i8kjIMJi+k7fbFNrCHpCpYUfcyM3D5yRsLF2Ee3cjGgURDCqpqF6+/pVikhy5lIfEN0cj/p9FnWOzl+KP/IkktPRpv1Kdk5XB7OSvsfiR0mbVyangu89Wz+UeNq+QZEUWwGJP+vgnsWf+rsvOG/8YpwlQYZdNtZFNzYBd6hqoZxPKrKDi0exidayTkfT2oGZV6szOMe+Lm24aA4lAE3u7NZoHp/DNU7eVV2lrtn3uChALF3xPvJgvzFnQAqXrewBVUFXFDPp/N356UIXQ9ncxOOjreUgwGyH27SIL04zt0YwuUCXMuTlLZ5cPaOCMiGoOLlgWD9oKx1tf2rrDtCXpTIow76jpxKD0W1TKzB8rYpqq8whM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c4419f-e41c-47a3-e4f2-08d77952890d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 07:12:48.9245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tbgwlgf8KBqIwHPzHGcwUWD6AqD/r0YgaT8egl9Dgmu0T3WXHuIf/Y5l6wzTpGCEtqY5L3xnXgeP0hz4dmKRlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7086
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,
This bundle of fixes is all reviewed now.
I hope it'll make to the next merge window.

Thanks,
Avri

>=20
>=20
> This bundle includes 5 general fixes for UFS driver.
>=20
> Changes since v5:
> - Fixed a minor typo in Reviewed-by tag from Avri Altman
>=20
> Changes since v4:
> - Incorporated review comments from Avri Altman and Bean Huo.
>=20
> Changes since v3:
> - Incorporated review comments from Martin K. Petersen.
>=20
> Changes since v2:
> - Incorporated review comments from Mark Salyzyn
>=20
> Changes since v1:
> - Incorporated review comments from Bart Van Assche.
>=20
>=20
> Can Guo (5):
>   scsi: Adjust DBD setting in mode sense for caching mode page per LLD
>   scsi: ufs: Use DBD setting in mode sense
>   scsi: ufs: Release clock if DMA map fails
>   scsi: ufs: Do not clear the DL layer timers
>   scsi: ufs: Do not free irq in suspend
>=20
>  drivers/scsi/scsi_lib.c    |  2 ++
>  drivers/scsi/ufs/ufshcd.c  | 42 ++++++++++++++++++++++++++++------------=
--
>  drivers/scsi/ufs/unipro.h  | 11 +++++++++++  include/scsi/scsi_device.h =
|  1 +
>  4 files changed, 42 insertions(+), 14 deletions(-)
>=20
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

