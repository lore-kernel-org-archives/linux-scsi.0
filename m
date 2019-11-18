Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 291DCC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB74C2071E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:15:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bEkFi27R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ltgRqdei"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfKRHPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:15:08 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63140 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfKRHPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 02:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574061307; x=1605597307;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7y7HPWG4VLX01Bfo1EuvKDJ7XpPAlXcBTgcDrInAWdQ=;
  b=bEkFi27Rgm6QuixQ4wT3sklAMVyob6erGsEyXxnOtaGkP1IHumfYA5QV
   6M1Q5QrI1TYd625Amf3GfOCXTZbOxaEaEuUHeI1nkwdx6CMjtJn+qrTkW
   avLC3XyjFNlcloUk4hqytyyjonS6t5N4azAF2E3Ah6c267MQBUTkIOAs7
   jdFNsl6Xoj+HLhZHqhLTm6yqZqN69XnLN7TlFgjUOsvd1R6xjv+YWvMb9
   jRSu/VXI92LVN24MmkgkVJnQGp+bC1qFTsE5WwI9kh5Cz7LvvABQ5Iq1F
   U1u/tR8WW5vmQOV3tBxm49/0Shw+PhnQKFy83Ih3KcUyL+4P9YtANDKnd
   A==;
IronPort-SDR: 7Ha4qYbeNxc9aD8aMg58pdT/XUJJf+KKPZ9UYq/YCIvzo3WjE+tflV13kIGKD6oH8xoCoLskxB
 ZVvA9LBTJEgCuDtlkCzf6yz1BbRDstmYFFh8zZ9J9HnFxwG8pT4klUGfv+zuQGQti9b8eXYW+u
 E9BHFyCBriVmWxuHdUDQc+sgsCobOtNQHGP81GZfhzsv54J+uugy1lihpC7WymOdRwmovRqaXZ
 YcrLgco4Il7Um2EPFf4XnMDaSCe646e93vOFhlg66DnUpxXwb0o0d+B5uI6/jkIXhlcqTxfkYT
 348=
X-IronPort-AV: E=Sophos;i="5.68,319,1569254400"; 
   d="scan'208";a="230641629"
Received: from mail-dm3nam03lp2051.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.51])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2019 15:15:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJdij1UH667ndhbGR8SzV7acWh4ves2k2WKfV575ZQ6ZCN1DjNd0E2PSKDwvrJE8wLgj4fzLaH2+yiNl3qo1h6rm3GrsRv+5KetApwskXbOcqYuafgNwPczwc3KWZ7aARbBLIzRngXkfL6ou+xEmXg+83ANLCHpMVqtFnK27yloy+h8s1BYrSSYLzsihlK3lp9n/Olys2gQ2MkFK3a80n6SDXihW0BFgEjurClSR+yAdUtvsVTtxmvDYKfMApFRBgZtYn+RpAA4UmEEBrfh3uJfmnhY+hfg9T+X+kikwoa/PVp/4BhzgSRswmPlOk1jJWffhBpt7et+o/KIP4d3q3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lvo9V+Fhjbf2/7CwaavDJAA7/b0QkRYYxHVJxKD2DNk=;
 b=gZjmut0GsunYqG0cMV6GP2bFY7Z/TmbQJx7qQQ9apzdA/FFlprPN9ycR5Ulnbkmxhj40Xv4QXmFzhq9/C4H95xad+SJvAbbFkaV7YJc7ufGcHfmsRNZIw2scdvKGkbAYEi+rWR35rEXGFXsHRMBPoC03xffHrTLUW/Fad1/DzbSZ8TDdKIz4Lm7O9maM8QltjUdxl4JKQ3jzlHyq8Q9XnxCWWXFXDpHdhoD3JCOu+sfVHUHJ/F4dpcE3RCsS+IDAMCGghumWajyOYGFsIYzgejq3oIc63aXOLfn/y1HB2fXbEDxQnewX0Mik4FsLZWSaqY7/Svx3NJNoG/qX3OXitg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lvo9V+Fhjbf2/7CwaavDJAA7/b0QkRYYxHVJxKD2DNk=;
 b=ltgRqdeijz9w0+qpOiV3AzaFJUug8NOBWRTu6fSVwzgHVmycLW6pgX9n7FWSlgB1koNeunZbBnjmh0JjK2lAkU+S6Zq2WjZ0ffp+VKv1za0VNnN08BfTatTTFWtfIVvlf9Er8bL6/DxgaJ9XAH10hzLSbAK4ZFT9Im6litWBmmw=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6976.namprd04.prod.outlook.com (10.186.146.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Mon, 18 Nov 2019 07:15:05 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 07:15:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@qti.qualcomm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Topic: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage
 hard codes
Thread-Index: AQHVncN0I4QlPQom7kOhpEw7WzhJI6eQgyQg
Date:   Mon, 18 Nov 2019 07:15:04 +0000
Message-ID: <MN2PR04MB6991121D72EA8E6DF7F6258AFC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-3-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574049061-11417-3-git-send-email-cang@qti.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c3addb9-27c1-4b93-5d55-08d76bf70919
x-ms-traffictypediagnostic: MN2PR04MB6976:
x-microsoft-antispam-prvs: <MN2PR04MB6976FFA3C06FFE0F3588B6FCFC4D0@MN2PR04MB6976.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(199004)(189003)(6506007)(7736002)(478600001)(99286004)(305945005)(7416002)(316002)(7696005)(74316002)(9686003)(6246003)(102836004)(76176011)(26005)(54906003)(110136005)(2501003)(2201001)(14454004)(66946007)(66446008)(64756008)(66556008)(66476007)(15650500001)(8676002)(81166006)(446003)(66066001)(11346002)(86362001)(81156014)(256004)(52536014)(33656002)(76116006)(5660300002)(8936002)(186003)(6436002)(486006)(229853002)(71200400001)(3846002)(71190400001)(6116002)(25786009)(2906002)(55016002)(14444005)(4326008)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6976;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0huS90htbqChTTGyl2gzrGerVcN8ApJ847cWUXB8R1dH7f81oY3ZoIze3mAdCzG4yiRpIWtQeEcOdHmv3MPwbfRvcy3tlKlkhX4FjmLQooGl9Mig3Q2qIGIdsWQ5b64dvLhv2rrfNRQLx/H4HINc48u4JxGjy1CXaNNW6zFkS74LM+v2hXeeui7MUnTLT3TVObmkAnzhRzp4tNcSgHCo6vSL0Fuvo8axsNegnFxwMW4+lTCpfTv19y6NpziH7mksXnaPZLhuF0OY2xh45oXe1utqJREbLobi0TgO1PzW9t+szWAb9yIhgya9dynomvSilyFbZcqn74u7VG3aHFELqYMW6WWUY4usj/hZUYOWT7i5DvUHFFUC+ybQ/GpGFXklaFnj5CwiDaM8ZQXIIyPH+Nbp2wz3HOk/cnO2K2Q6f1y2O5ACnXSVTH4Yg+kPF+s7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3addb9-27c1-4b93-5d55-08d76bf70919
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 07:15:04.9030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v5S6WGVV/3+sZC5ViWIdZlqowhYURlL+Bd40F0pTzCz92QdkeGSb2s2nx3fJmMJXvaI1zLECOhTb269xpFJ5PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6976
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Can Guo <cang@codeaurora.org>
>=20
> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ
> voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to ma=
ke
> sure they work in a safe range compliant for ver 1.0/2.0/2.1/3.0 UFS devi=
ces.
So to keep it safe, we need to use largest range:=20
min_uV =3D min over all spec ranges, and max_uV =3D max over all spec range=
s.
Meaning leave it as it is if we want to be backward compatible with UFS1.0.

Thanks,
Avri

>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index 385bac=
8..9df4f4d
> 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -500,9 +500,9 @@ struct ufs_query_res {
>  #define UFS_VREG_VCC_MAX_UV       3600000 /* uV */
>  #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
>  #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
> -#define UFS_VREG_VCCQ_MIN_UV      1100000 /* uV */
> +#define UFS_VREG_VCCQ_MIN_UV      1140000 /* uV */
>  #define UFS_VREG_VCCQ_MAX_UV      1300000 /* uV */
> -#define UFS_VREG_VCCQ2_MIN_UV     1650000 /* uV */
> +#define UFS_VREG_VCCQ2_MIN_UV     1700000 /* uV */
>  #define UFS_VREG_VCCQ2_MAX_UV     1950000 /* uV */
>=20
>  /*
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

