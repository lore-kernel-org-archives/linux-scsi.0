Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAA3C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF098214D8
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 11:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lUxBBO/3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bFUpf2yp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfLKLLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 06:11:31 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55934 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfLKLLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 06:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576062690; x=1607598690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F6fcjZXSymfVTTzKhizoyBBZp3M/jsP9O4cjmq3JhKw=;
  b=lUxBBO/3ik5E0cVArQ9f2B7NugSUHR23x5yPhfgu6QakOK56lCs0sj8/
   wRRgQxz8ZxPNwrBF0wcS1mIuajhZtQ/cvavMJtTA9fzyKFUD+E0PSJD+3
   fQMHB5Bp5KtiFJdTzq4VS8ZG9E6CH04Xe22ryrHPYGbecXNKWC/JqOke8
   ACVUjRl1cDSb4N23PWtFxjeKpmSxF8KRPumZhpJcrIiXlXjgV6qox/vJi
   zxc089gpkxEh/vOJdNz1nzCgxbfqtpfoK08x5A/i1qy9Qbnz4jQn1cnpX
   ZyLEJlSC4z3iW3G0dTJwh/GGLZjwshjXROyqB4mta2tajqV4u/ceSPEft
   Q==;
IronPort-SDR: GKqMzr8tdsC8v3g4AgaXd3hFab9kLgOFe5tobZvP3YrUT+PeHQVCKHd8iL+SaCSGByvBVNYIw4
 fsN/F3ILPZ+nnTJJTUxw2eWi3bvYiYnmKhuKjHX5BKHqmpHRj6MiVrz4d99zQTZzVZilFk15Od
 w+SrKJ/+mBsgTm/pIdGTgmVjYYKgaH7oGPaEjiYDp2+iHHTaxvAqb7uC7rIteU8XdAFiKgCZIw
 UFzC7nUcFLfvvfRX6L5b37EcT0Mb223ibet68KQKgmdAWU0SjEQAWQiJjgfmcei077qDsuM/Ot
 Xkw=
X-IronPort-AV: E=Sophos;i="5.69,301,1571673600"; 
   d="scan'208";a="125088031"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
  by ob1.hgst.iphmx.com with ESMTP; 11 Dec 2019 19:11:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG03D1BUyynttjxnvz5YYO2/t8uQX9sKTqR3hFj8PBMw+uBGNc7l6MnVhzLZZaUy12fhhJfqjJxaO/lg7suIrg4XpgXb/Ag/fUdyTxjKLir1UGX1qUeI37KSIg5zYQQeFa4evaO/LcD/0atpmgkTUUgzOWBoUKdd3ON/R0YsoB0RzW3BnAgZ6sFsjHqoqG5T9Fpg9hsqdPyuT2IboNMYvwdPZF5uh8Tx9vQB7vmiOgajyLRxoBWUyewJdLD+pGm/EW+XKfPEsV1M2j9Ktf35gqcC+WgNFTBEt/JkR3p6ZJ0i3JuV3NFp8CfN2RgTc+BMwNnHQf0monBpdfCKhCuPTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AI3rPJ4ZKfDq3iJHa8M6ZMhTmFZQSaPq9T7Zp/SnQMM=;
 b=VU+NkZiz9T2FVUSpRHZXmw8VXQ9qkiNmwRkjLPJJO5WQIKVDfjp9GPKJUpivrr/n1uKNovE311r/w4bf2jil5c764qAXn7PvCpbfdgTpInuR87OwMDxCTxHXqNtwS9Z5//58fyFaYt+HcDC1pfN+B95fBZgktD1JNjpheEmzTFNvrKE9o1s0sNKmUIe8A2yYu16Z7EF08vDLU5oGgk6Qs/1hUfeAMGxXKdDFHzSSGZmWuorR139Qh5qkNpY6S6X5jIWI6vfkZ7Js0Akb+w2nUt4SqLhmIsPd+lDoJiVx7H6JnFdChIX1MxWNiZ/MmLzRVY95qLRBVl6g5MhmfTMnSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AI3rPJ4ZKfDq3iJHa8M6ZMhTmFZQSaPq9T7Zp/SnQMM=;
 b=bFUpf2ypr+v/WZnn8j6QRnR5h6myrz7wb4Q0uJ7hjLGQTaVRlDAS7zHcYLCnc4DmGQ3FZDsdWDGyFz5oYbr6wLAXU/ZKTwAUb06qgi0VNrp1x4U9aT7ZHacK1AtUtgbNyz/9S6VbguDKb7s7sExbL8Jjsw0fcQ3dO2XrFyM/qBI=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6078.namprd04.prod.outlook.com (20.178.248.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Wed, 11 Dec 2019 11:11:27 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::9447:fa71:53df:f866%3]) with mapi id 15.20.2538.012; Wed, 11 Dec 2019
 11:11:26 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Maxime Ripard <mripard@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        =?iso-8859-1?Q?Cl=E9ment_P=E9ron?= <peron.clem@gmail.com>,
        Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
        "moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] arm64: defconfig: Compile ufs-bsg as a module
Thread-Topic: [PATCH v2 3/3] arm64: defconfig: Compile ufs-bsg as a module
Thread-Index: AQHVsANQIZ1l2EY9sk2jTqldL02xFKe0xiRQ
Date:   Wed, 11 Dec 2019 11:11:26 +0000
Message-ID: <MN2PR04MB6991B27D797044D8FFDFAE8FFC5A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <0101016ef43c56d3-c7064a44-6025-4349-afd4-a2c91a9d9ffe-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016ef43c56d3-c7064a44-6025-4349-afd4-a2c91a9d9ffe-000000@us-west-2.amazonses.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc6a3802-eeb2-4168-e924-08d77e2addb4
x-ms-traffictypediagnostic: MN2PR04MB6078:
x-microsoft-antispam-prvs: <MN2PR04MB6078B2DB1F5285676C33C75BFC5A0@MN2PR04MB6078.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(199004)(189003)(54906003)(26005)(2906002)(81166006)(8676002)(478600001)(8936002)(81156014)(6506007)(7696005)(9686003)(110136005)(55016002)(66476007)(71200400001)(33656002)(66946007)(186003)(66556008)(86362001)(4326008)(52536014)(316002)(76116006)(66446008)(4744005)(64756008)(5660300002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6078;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZd3RE466ZLj07r9gq3MFbRlR9Q183v939B1+bvszqVYNmm1E6vcr92+qBX+kmTU+EUnRe4F8Xu9oDaITIsNzS4NpwCa5C/pKs+DKu9D25/wf9mkZSRx8HSwA6ROV9kJ5PwoxA9DCwAsx6ElC/h5ii8kWaGTj5qCqPYO3hPvKYTkUvj2BGv5BE6YcqOAVn+xbFgUTpKU0PNLhldj/Cuyz6PmKRkOuVzFUBN+Qks5/lkhGOtzVOpLM3FMQ+MEoj3uppWB5NlsKrQwdRkTYJfVEPcpGDf1r7zkmg+wkpvMontpaGdPV+PMSkXd3lPoFZOoogz4PGCNWuS3gBs12PqYg0o4Yi7nYY91Fc8k2zFfB5gukE9iHgWqW37fqzRQ+AxZEucAZ+bQkmGHOK4DGQpdq3yLfVCQsIbCP0X0WYuulFZF5XQO47KAtCzkNTXNvRGX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6a3802-eeb2-4168-e924-08d77e2addb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 11:11:26.6624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SzgqeKd1kwH+YAJ1onq94n6Vgheph73PZYNH2xiDne8D8rtOMlLc2xBNz01DdPWEU2pRK1fklFum2dn2IHtxRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6078
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>=20
> Compiling ufs-bsg as a module to improve flexibility of its usage.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Not sure we want to make it loadable by default.
The platform vendor should decide if this module is available or not,
Don't you think?


> ---
>  arch/arm64/configs/defconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig =
index
> 8e05c39..169a6e6 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -227,6 +227,7 @@ CONFIG_SCSI_UFSHCD=3Dy
> CONFIG_SCSI_UFSHCD_PLATFORM=3Dy  CONFIG_SCSI_UFS_QCOM=3Dm
> CONFIG_SCSI_UFS_HISI=3Dy
> +CONFIG_SCSI_UFS_BSG=3Dm
>  CONFIG_ATA=3Dy
>  CONFIG_SATA_AHCI=3Dy
>  CONFIG_SATA_AHCI_PLATFORM=3Dy
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

