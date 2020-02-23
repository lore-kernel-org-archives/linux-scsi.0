Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB66C35675
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 22:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4F71222C2
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 22:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="eO//hbqX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBWWl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:41:26 -0500
Received: from mail-eopbgr750072.outbound.protection.outlook.com ([40.107.75.72]:55110
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbgBWWl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 17:41:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXyh43UPlYmYkmfc9X6wv+/O9nzahIws3Gd/A2Tj8pS9DTNpjFn73yHkLa8M/0EK3DulLQVrpAdQCTtvz5Wldzz7VVCglZa4JNp6juHjV4W0+3wp+7a5cOiRHj6zLfixXVsUqbVPfQrT+iLnhmTCcWoG16iSy2kPINa/FnbhykjVHoM9blrUBu3wco++sND3SmRRACBX6FFkZMlmnkG24HX5QMJeDK0ecF8Abwdg9O68jun+NU7wgupwSF229Sp8QQnzjxX8QYgLdjGd7NhIVjrwOKwLFHdPrBE+C2nM0dXqHb/NgWNf0zJ1gL+Kwct9+VXZ4kqfDzwMJAv3yjV84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAAltzuBU9UJ5UVuOceNimexpEo8PQ1CnszWESZVC2o=;
 b=G2jg4RxiTLaw484044QtHMJYrXoZgJQbewLrzEYt3MdRElgPlGN9aCkHGqXcb99qQG7x76dqnZA64FG9TMhIxvs0P/wJnquJR5k02Jq63d42tD6bGDsmLgr788vTWJeHmQEDX3QupkmwdHZhbpSYG4rBQvuer3nawcNgLRqpLdwRD9+ODEM4bJ3nJcv73Pto/Gld0Lzcd8O7aRvNr8hfpAgR+YdLjQzC5dRj0eVVpyJkgX6i8cT8m3ARQZk8EJDhIRY80nT3VBv3EfZV6g1+Suws1Rl/RtJOIFp0LrGZ1IEYn2+TJWUa9xR4/Ve+1GDpKnIJnlegSy7BHYjcGE90kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAAltzuBU9UJ5UVuOceNimexpEo8PQ1CnszWESZVC2o=;
 b=eO//hbqX661BScSWzyzNLDePtXlEQaqPlLZEPOTPWDfH9rBObX+FLT669z2cioD+TYXubUNCV4cGuzZRFTWZ4rbu7CUFvmgDEGMwMrC0ax7HsyqHwNGu/m0Bwjm/NdAfZSLN4tSmfJR2NjoVtevCL3AUE69TNs1JUb1k1klbRM8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB3955.namprd08.prod.outlook.com (2603:10b6:406:89::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Sun, 23 Feb
 2020 22:41:23 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2750.021; Sun, 23 Feb 2020
 22:41:23 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v2 1/1] scsi: ufs: ufs-mediatek: add waiting time
 for reference clock
Thread-Topic: [EXT] [PATCH v2 1/1] scsi: ufs: ufs-mediatek: add waiting time
 for reference clock
Thread-Index: AQHV5/SBWviNFUGBTUqMAMnr5wxS1KgpZDZw
Date:   Sun, 23 Feb 2020 22:41:22 +0000
Message-ID: <BN7PR08MB568451F1637CFCB77843745FDBEF0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200220134848.8807-1-stanley.chu@mediatek.com>
 <20200220134848.8807-2-stanley.chu@mediatek.com>
In-Reply-To: <20200220134848.8807-2-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTliOTJjMjAzLTU2OGQtMTFlYS04YjhjLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw5YjkyYzIwNS01NjhkLTExZWEtOGI4Yy1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIyMyIgdD0iMTMyMjY5NzEyNzk4OTg2MTk3IiBoPSJ1WHZyRXlYQVZxb0owVzkzRmdXUVdRN2Z6UXM9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQURWTCsxZG11clZBYVNxaC85aGpDRlhwS3FILzJHTUlWY0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTFRR0tzQUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33f06e2f-9150-46c2-06cb-08d7b8b18261
x-ms-traffictypediagnostic: BN7PR08MB3955:|BN7PR08MB3955:|BN7PR08MB3955:
x-microsoft-antispam-prvs: <BN7PR08MB39558E644E5D59DF4E47577EDBEF0@BN7PR08MB3955.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(189003)(199004)(71200400001)(33656002)(64756008)(316002)(66556008)(7416002)(5660300002)(66446008)(52536014)(9686003)(7696005)(76116006)(55016002)(81166006)(8936002)(26005)(186003)(2906002)(86362001)(4326008)(110136005)(66476007)(558084003)(66946007)(54906003)(6506007)(81156014)(8676002)(55236004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3955;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UzpknYlBAlnXG2qm3fgFqqtUpBPjV4czMx//ukw6QPZUMLxwhp6FMx7dW+uITzv7Vhe7aUWm0cYiYK7OHAoR6TP2XFwRkJUQhe2nWeIu/keuxhdAiRJd/McPWT2DonHMOmTPSNKov+HtJA2QouNtldArZ8KUqhb8D7KC7AU0bnqNYpImbUVB5yfkmS4DBkco5WWWt/9SDmYIE/YXxT1N7yro8qCkStyrwLf/aQ3N5I2cm4ilR7NSYw3+rw5O639lxtH/LNYzoo9jcfFX+PSOMc4ZFQwN4ZjmjRdijJcCD+3V4ScytdyBBL945IFtd51te97j1EOtUL7nX+SS6sFv3KS5HJHAWWBs5HfxnAfvhF5SRRUo+eZtaDEDjcXcsh0FUBvZBIqeRBi59Zpv19hkbVBba6uYOY072C+GeItGJBt1a5y8s8Nuy8PlFiiFuelf
x-ms-exchange-antispam-messagedata: YWTTfKBUOBX+OIirWfp3dMhqNnl8An58L1j5P/Rx1RUlAYx8XkqSUYs2QkQ7wTTlAJmiTUdXUEtxUgmLwd1TYRpuatKPBoSprmmaftA+hFTyHMpn8cCXGOmxukCt2ySYyesC9LIO10zZrwlkla2CXw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f06e2f-9150-46c2-06cb-08d7b8b18261
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2020 22:41:22.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VakhtzpJ9WyriwznLlhRdvwG4I+3LYZNm02SAcgCi8H0t8NP72P0iJ7rPts/U9tMem7E5G3zC7fQulnSkeg6iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3955
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
