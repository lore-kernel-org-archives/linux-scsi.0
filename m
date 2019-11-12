Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4FBC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09B1F222C1
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lgYYIZBQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="p7+Bz35l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKLH4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 02:56:24 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33348 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfKLH4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 02:56:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573545383; x=1605081383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xo4723MIEjy1AmXB8GcrN7cuj2VJ0dxw8UlO6wWQZB8=;
  b=lgYYIZBQ61LoTg0hihj863+j32NBSghaocpDIq8eSY2iPEUmDRgSjKBc
   eIbqHieSxMBoaQgltIobnXlGSVpgswssOLqfTkEt4E14x8mQJVwRzjaX2
   GLEgGV2HIKqIkGr1XjAVzXxMS5uvD8u0wqLCrsyXPDZSXtfTPfe55Yhrz
   PEagbXkKs1s2C6jQVPrBjJ9vLY5AK/9miH3EKI7E1BzOvIKqb9YfkcPqh
   Kj9kanZU0UcqhEtB84LAk/IYvCw/QkERcOu/adjkjlH09Mj34cTdB5Ntf
   q1rE50mqkQUCvWKjhZ0mGm1V1JuGcVGnQ56MHpHk903CDfPBLEDZDp8+P
   g==;
IronPort-SDR: sAK3/PzkJAq3rkHks7s/ZKnY85BNEnn7MT+pza3tUNKJx2U+mJfSRIHRigpokP5YB9F1jFkMfK
 mFui2aDYxeSpGAlAN2sE6caOZ4sLCc5chMETO9Itx6+F7aDofXIsuCBQ4BRcjwdrzJxzv14Hp+
 4S7r8gBKQC4dGmX/QBgqpUFVDt+nyQWpld0WalygmJngAUq2iRCw/plx4/ExHZ0tlvqJSlqncn
 PdTkAoYMLPPqXhsZtAwGqCqan7qB9ab0WSClM5tL7GdM2f8E1awAJpAH4F7ViH0bTjF0Xvjt65
 PKI=
X-IronPort-AV: E=Sophos;i="5.68,295,1569254400"; 
   d="scan'208";a="230030896"
Received: from mail-dm3nam03lp2058.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.58])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2019 15:56:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9bEj71n2U1XsmaYq5nIgs8+sF/lsebqbA0AWRhT521H5rFpjS3hfh6QuvxmTPWf1ytglWNHC55r1wCeseyc3a1SdKeyJ6U4gOkYmxQ+8qm9mQBbxd8Kka16cEfOgJ11a8vEFVdO2PjDOZfjPAISX0/VMmyg7lXQIYJTi6NscpUtxt+IHUK7ipmjmS8YnaLbJYPiqqiISAaqx6TLQX+Ae14op/TWQ/Amdup7k5pIWJDkDpo1gdDZ3+5W+C9cJTuSoLVQRLqiFMBexe483QfOlXkABnAu60Z6HaVufK78//yfBoHH79TrEvfS3vwqJ634AXz1jDe5nP8A683iuzCc+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62AHCGlNBCrOKzjBhcLi60undlF+HVEc2stf8QHm5e8=;
 b=lzdipWTZ2UBtMTd1YUAFof4+qTX5Q6qAqbGINs8VbaDg3UGoWEkYorldBXigLiOmPednt0Xlkf0mPZH04Vc4PLeytwoLnX4Fm5rwX73TVEGyqmIBU0TleYhjmxopKrxTnUxYy1x4TbONTGdJ3RLtc76f74Yk60qvuenxNgu4DPYZFlDRi5OSPgIH/oFf5wNADE2SYf0/lH/QQV0KE+goI7SEl+jWKCbxxXT63crmfPIqCy0TonEiqAEnoH8qS9bLBvzo4rAtujd7+vlDHl1a/G//l/3EJ4a7O3l0dAg2yB39UfJtLN6rdJiXHdx0NEFmXBPm/StWDNHgV+WHr/BE5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62AHCGlNBCrOKzjBhcLi60undlF+HVEc2stf8QHm5e8=;
 b=p7+Bz35lGNt/IhGXvgl+7Y7k6jsim+yv+8QZ3FRopDX8twUs6M/ZN3PJbB0w6y499364OaoLdN3keuP99DRuaTUJ8kBSpMWS1rxaVhnk6H0nJDQMcaNNhij8aMyxQYTjk8J1qaTtogRo47msJ0Mj1gjRbtKUGuFU7MbdGp75JgE=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB7022.namprd04.prod.outlook.com (10.186.147.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 07:56:20 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 07:56:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 3/5] scsi: ufs: Update VCCQ2 and VCCQ min voltage hard
 codes
Thread-Topic: [PATCH v1 3/5] scsi: ufs: Update VCCQ2 and VCCQ min voltage hard
 codes
Thread-Index: AQHVlgzHvpRg/BPDb0+DCvULsLcOEKeHMKbg
Date:   Tue, 12 Nov 2019 07:56:20 +0000
Message-ID: <MN2PR04MB6991D2D4444BB8E319CF916AFC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-4-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-4-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71ae4d72-6de0-4a26-79d5-08d76745ce52
x-ms-traffictypediagnostic: MN2PR04MB7022:
x-microsoft-antispam-prvs: <MN2PR04MB7022DC15D6256C6838A6AAE2FC770@MN2PR04MB7022.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(3846002)(6116002)(4326008)(66066001)(64756008)(66446008)(66476007)(5660300002)(66556008)(66946007)(6246003)(55016002)(76116006)(478600001)(74316002)(7736002)(86362001)(316002)(52536014)(305945005)(2201001)(7416002)(25786009)(99286004)(110136005)(7696005)(15650500001)(2906002)(229853002)(486006)(76176011)(71200400001)(102836004)(476003)(6506007)(14454004)(2501003)(6436002)(33656002)(9686003)(14444005)(186003)(26005)(8676002)(54906003)(256004)(81156014)(81166006)(71190400001)(8936002)(446003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7022;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fu60B/AW0tn3fed0qPiyMz1Kz8gMGbXcToqolXM/y0lLktDvIodXzEKIa/hlzTdGL9PTKk2CgLupQPx9JvMySMgPKoAZ22KJIxpEcdHfBtz+Zy/PYYY86BQQngpocXqRm1f15I/9gmSniQDUclpIsf4nzqwFFqYh/lE4K/JjbbIkBjLPj3CLfqcdFUSOXVcdD6hlDJivID7LLAtTgbaWwqeVadxfWmzjgdLAL3R1H2nh+2bfj31Rc5UwnrKwKmAKFmlAzlM6Q7wg6rCktLsjLa2r1XNharlHn1aXsMXoONy1ist+SU2lIciTOAHDRoBDDwragGHmxOEl9JSTHH9qNiokmwfX/dmx8hQ003elQM0j68LBu8E0Ydmvhpgk1VrdOLKnKhB0TKvc+bJSNKKsEZhnmlDB6mMdxmMZsVQZUiq+IYOwwozoYx+CKSjcDORm
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ae4d72-6de0-4a26-79d5-08d76745ce52
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 07:56:20.7134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4LyTW9ywmDGIIp1p+T4+RgkJB2w3sH7LkKmooW2fWEuTQynqivFlrYIn6DUv+wuEPufv6hKjzLdPUdSASaXxZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ mi=
n
> voltage is 1.14v, update their hard codes accordingly.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
AFAIK, Vccq2 is 1.7 - 1.95 in UFS2.1 as well.
Current constants applies to UFS1.1, as indicated in the original patch.
Vccq is <1.1 - 1.3> in UFS2.1,  and <1.14 - 1.26>, so need to update the ma=
x as well, and =20
make the assignments in ufshcd_populate_vreg depends on hba->ufs_version?

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

