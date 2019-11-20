Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D80C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 15:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1844F20898
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 15:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AyJ80CuW";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="jaMSfDiA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfKTPDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:03:18 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:1050 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfKTPDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 10:03:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574262197; x=1605798197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r+gUdHNK7JnqNk2AkDUJuinvfNTSnARQiTuEy558KMk=;
  b=AyJ80CuWWr6uAJ9LXP5V95S4x4Im1Cr2bfHSaTxm+nJ3Bi2P7PuTpqCl
   bb10E8IsyW6Dw8T52t7FxEyTi4un6R908jaoPIcca/WWdSaFoE4oJQFSw
   lb4zaGpNugWpts38gu5XpoTfkp2jFq4D0KAN9RPxet3tmxpwOn3vgrDQy
   9JfKdeKGv5HTenoe3vFWEy1L5fG+ZtCXiJ9Ie9sMBGlWmGpCf1m8pflpt
   Z0p5B2uFHY0Hnwu5+AJP+phAZd/UnmvoUB5iwEBJCJoiXC4CIT8kWnU7L
   1mwauax2OuZOZDZxURrxttPhQblJr91w6V7LpnqFN7IqKWBKOzINCxOo9
   g==;
IronPort-SDR: LGCd6AQnvJSJzMxy+Rmo8l2GXBgOLwCp2DChlJJ1jRNteLoXUkOryoh37EYIKN9GunroyZUIAZ
 vj1ZO7FSkBpTxdcbuyBxgSXWeftPbkJrvkhkQEJolatWxCenjTpO8XMncZgwmdgfNhnjpTXLFF
 Ratmxa3I7FY0klskIEFBNp/S1gaZgd5HskPgKfh4SZCd18UVJ2AfrYKq+gVPgTQ1PIgPTYfr3J
 I5esdZhtIqdNh+V4KkhazScr7DNB+DCvhftvehG4R992SUTqBhKp37Z6TVALREblryPrPn9F5n
 jE0=
X-IronPort-AV: E=Sophos;i="5.69,222,1571673600"; 
   d="scan'208";a="124308923"
Received: from mail-sn1nam01lp2051.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.51])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2019 23:03:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5HLECaiI+1WdauXPojsWOB/YbIpKTTqUNCKMBeKggIFfnSTyUbrJkesrc1zjkgYqAnNnCaMnnuMh0iBnFPcEvQFTXaTgPgUyOGN3nqTxiuBjRXN+zZTElsxrstkY6kLP0xXQfWsnfFT7jTP/49emewIpz4+39NpHgCRFQO/8z72A4h1QUFcCYy1dT4rRPgMUnXLIwSgSFDX2Egs18nIpQ2VHKsBz7OzfCfO688pXezsgrD8otM7YU13W473UYhU2kVpJkKNHGHQSHxTlUxTukB3EU9noHoKJu32gUER9mZwCzS7GpSS2dLCK6GGyWm2YEtUWVFQemGKgOa0j++McA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+gUdHNK7JnqNk2AkDUJuinvfNTSnARQiTuEy558KMk=;
 b=OFBvwcCNVhYSiiss2xVxNolIf4Luw8tfN8h/67CLNG41sjGfz9KkZg8wPpN+SA1vpE7MQq9PaqMarrf++YmU+Yrn1Bbo+zmsui19VB3ufvxTzrt6nIxJfx807IoO9GYZy3NRfER6l43gP8+5Dy1cvDWv1aSHaeSA00lHK5KUnE/ZExlk7Qshg1knhPjrw5HohNMHkFQLyVybhbmN3R6g0J22a0dVeEsh6hePrUyBh7Lpd3OKy8z7Cey+7UhzSW3F8XNAN0jK+GHoQ9l4waL07ULZ0Cn3oZgpk50bbBLo7lfMyTbNz9mZqrolIcsj/yoe6oIPjm6HIiipvEM36cn6Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+gUdHNK7JnqNk2AkDUJuinvfNTSnARQiTuEy558KMk=;
 b=jaMSfDiAqE21N5Wmc1r1jRON8rxk2ziiJ5wzqXOgiPsciKu223U8PD71sTRh2HkTSy5d6xfbpo7VUJAPmbT6E+dvxLyNSvDgq9weZ7qLWLEO6NrhYZnOuIg/JBC7e1IfqKvhjbmLgZp5pvZ649K8EAUi95GCJ2BY845lM5UqFy4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6960.namprd04.prod.outlook.com (10.186.146.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 15:03:10 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 15:03:10 +0000
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Thread-Topic: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Thread-Index: AQHVmee89Uj0xO4g1EKSBfsTmVIai6eUMy8A
Date:   Wed, 20 Nov 2019 15:03:10 +0000
Message-ID: <MN2PR04MB6991C35EC2DBBEA17A611755FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-5-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573624824-671-5-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c49cfe29-7737-4104-273b-08d76dcac1ff
x-ms-traffictypediagnostic: MN2PR04MB6960:
x-microsoft-antispam-prvs: <MN2PR04MB69603545285762C8A2B0951BFC4F0@MN2PR04MB6960.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(189003)(199004)(6246003)(54906003)(8676002)(76176011)(2501003)(74316002)(305945005)(7736002)(6506007)(102836004)(11346002)(476003)(14454004)(186003)(33656002)(486006)(76116006)(25786009)(498600001)(446003)(81156014)(81166006)(71200400001)(2201001)(4744005)(66066001)(66946007)(66476007)(7416002)(7696005)(66556008)(64756008)(66446008)(26005)(3846002)(86362001)(9686003)(99286004)(6436002)(71190400001)(6116002)(8936002)(52536014)(256004)(2906002)(55016002)(5660300002)(4326008)(110136005)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6960;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PjGgofKSF5bGnhBatLDaKqgSBDOfA/GtOSLaNnQ60xOfiKpjUllrpqTCTW+1kiMnn7Ka6pQrPQosleKatuXqRHN8rSpWIh27WbaCDX5rdz6JUboi2GBEB8gedNePWd7iaUBVaCTCmVwvc5FfKWVG4sAahdYoX2MhdZW6n7bDAGIvyemRgdSYH9ZI06qJaKgV8LN39Mic3d6JTapY9qLwtBRowkIXKhqlSxxYNQfC512XyEC9GLq9lE8moWrFRWPoA6lgUWQGsfTWhoZFXMHoCQ5TgMq51406fOF5wXUQ+YP2mVE8HriejegkU2RLmTPYqPuigNz6txto+TyIVwL1sx+dTxBvXHV+tqCSNilthoXVp9vqxeN5YfeYNy9YX7BO0z8sMP8IfxIoKidPs7OQ2yE4D21mUYiirxW153UYgWxRweym53jDPY/sWeNBW/nT
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49cfe29-7737-4104-273b-08d76dcac1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 15:03:10.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DifD0Mb2LJD3bZh914n8hohaGr9cWy8UU8Kp2rZgu8ZXLWT1FcBRLBk+pruch4Bc+ntNmo+zD6moZK3Z+UZulg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6960
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> During power mode change, PACP_PWR_Req frame sends
> PAPowerModeUserData parameters (and they are considered valid by device i=
f
> Flags[4] - UserDataValid bit is set in the same frame).
> Currently we don't set these PAPowerModeUserData parameters and hardware
> always sets UserDataValid bit which would clear all the DL layer timeout =
values
> of the peer device after the power mode change.
>=20
> This change sets the PAPowerModeUserData[0..5] to UniPro specification
> recommended default values, in addition we are also setting the relevant
> DME_LOCAL_* timer attributes as required by UFS HCI specification.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by Avri Altman <avri.altman@wdc.com>
