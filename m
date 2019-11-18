Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3B7C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9852B20722
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 07:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lWzJlYYc";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h1MbaMKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfKRHQJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:16:09 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10386 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKRHQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 02:16:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574061369; x=1605597369;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8rjLmbOXtBXfJZGE6rLGO7lYLjT5R0RQ4DiIiUkh2JI=;
  b=lWzJlYYcnut/ZYBeX0u+IuBGbcjseop0o6VXyfVsND/2wipxVHtXaOhg
   Y08M/x2k5GdvX1V8ASI8mSP3jzxRL24bMFuVxTl1nKE01ihQBwPPF1eZm
   o6Dk5hkzhr8sAFZ7nS6C2Gcre99BIMfdqsQHOITJIDU02i0+n3Ts1l4Hk
   tOGGsciTfp34b76Te1EoioLbf33lJRsD/eCNHtpzuAmkMnuhpc8rhJzyx
   +wSjTbPCiTetTMbJ5MuvFpV0W2C8GcXumBt1zhOL2RQ112FIxkOqX+PEo
   jbsOglmBLRuMGRXPGSj0XNUg8cZ+G1DaSr+45A0mGCJz4DZ0vyPCZADo3
   Q==;
IronPort-SDR: J/+9pnCcJpXXGWnp/Z/re1OpKvPbJokUvEnapXKYl0qUhqHzaGIVCcfxfgUnhSgI9a39k1CJjn
 Gmh/SIVIcaujSA19TL2uxqd2MeDWUmXBovnsXk1PmIVPMUGDu1+jjDLKY8Wpl1O3Ct0UL24TVj
 k1CCANtgJ09C21OW6u6b4xd1eJWD/teQetYe/1G8XMxmdVY9n1JVwgelgzaMFETyTdyXM5FV04
 o8u7aDI8L46G2iW9v9I2catKWUd/yg8tRc5WRvaTlNryMP7UIyuhXYmYvFFlkRypDWnLzd4Kpd
 lyU=
X-IronPort-AV: E=Sophos;i="5.68,319,1569254400"; 
   d="scan'208";a="127721081"
Received: from mail-co1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.50])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2019 15:16:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZcVG9m4wTbStN0Loz4OpV9mawtT4gu1L0XCJ+A15gtbNEnJG2BoYLYnsH0W8qJMH5szroNw9iwYIamgRLmhju7W0/GzP0u04yI2mXjlIPdE5X9jHHNNsgBbOcf/LfsXSsbftg+aX6fTy1GLPFeTxqFM5ysRCkcntoDYeRWGXHYoTHumpOCE7YMRXVmaCn7ngaNgGh2HqzXeho/M4Rd2psAP8BH7St7rGlwEkh/K3dPEb/zWOS5z+d1RWIdil6e5mTgZJtzeDdJHyo8OdU2sP/zY0bTfzlwHNpaARLi/fW+cc9FsioToJkhn8e+2TcUCZjFhkt5dZ2StJQYFGr+a3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rjLmbOXtBXfJZGE6rLGO7lYLjT5R0RQ4DiIiUkh2JI=;
 b=RBVP+71zYp2IaalqSy2v+Lji7vjsrJPHd4BgzGC2szocS44eUPcIPmkKcPmnvMCdhO/iKTKXMFIMiOsONSF3jcL5yvmC8IvHSFYRZ8cGcaPW/82SDfQLSY3639WqvnUw3vwQD7PsFaABD7FFZZSelZrd/zLJsV8Rjo3ibC60tU7kEnD8TxTmytReopTJlmZZjTfUeXwlCBtIdfq2gJ/EeVj8S9nvK5G6BtdVpppJ2ciqrfk2+y6ERWB8y2Rn34TctfXAyRMRk+aAbZCFKpGeTzD+RsGhw25aGvv87C1KLlN8cuIzQ0t1Hxr1YtUVTsOD1MInXOtAJ+ZG64bECO5AlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rjLmbOXtBXfJZGE6rLGO7lYLjT5R0RQ4DiIiUkh2JI=;
 b=h1MbaMKDZQYi4Db61ujs4maHNLQ7M0h3DwOU4anzwrLpHhK5HWCmt1fQThowBQy2Yvj2elLk01NShPM+7nhOuMndLeXlT1HCEikZ0PfSkqlnJtxDaqBw39ewES1qskGAQl8ectz21HD4HqS30FL64sqjt25HiFvZ/a/fNJoYyx4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5998.namprd04.prod.outlook.com (20.178.247.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Mon, 18 Nov 2019 07:16:04 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 07:16:04 +0000
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
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/4] scsi: ufs: Avoid messing up the compl_time_stamp
 of lrbs
Thread-Topic: [PATCH v2 3/4] scsi: ufs: Avoid messing up the compl_time_stamp
 of lrbs
Thread-Index: AQHVncNzKUsnzSPaJUSBchCDzH7Vf6eQhFzQ
Date:   Mon, 18 Nov 2019 07:16:03 +0000
Message-ID: <MN2PR04MB6991EE8B731D6465D8D669F6FC4D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-4-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574049061-11417-4-git-send-email-cang@qti.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1968c416-271c-46dd-c9f0-08d76bf72c58
x-ms-traffictypediagnostic: MN2PR04MB5998:
x-microsoft-antispam-prvs: <MN2PR04MB5998F2362653895C1C0FDDFFFC4D0@MN2PR04MB5998.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(189003)(199004)(8676002)(74316002)(99286004)(256004)(5660300002)(2906002)(305945005)(52536014)(110136005)(54906003)(7696005)(76176011)(102836004)(71190400001)(229853002)(71200400001)(3846002)(2201001)(7736002)(6246003)(86362001)(6116002)(66066001)(81156014)(81166006)(11346002)(7416002)(8936002)(14454004)(25786009)(316002)(6506007)(33656002)(478600001)(4326008)(6436002)(66446008)(64756008)(66556008)(2501003)(66946007)(486006)(76116006)(66476007)(186003)(26005)(9686003)(55016002)(476003)(558084003)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5998;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qtwqb79d3SC+j56x17x+bBjssh2Aem9IOWuFNhGg37tpsvoGWKuTPiR6siFhgT0I8BuUm6bh1XPg5I8dcppu21DZyqkSlsAatx1R+UYYzEcv/UZ++AZBVYmvbAOD5fltgXSBXEBnu3MrFdE89bA5qq0gpQ0hR3r8g6aZ4dkY4s+gaK+vZwaHLw5KNMOPRfX3Nsy5wEKsnjP5oxFcitlJjNiT/KAX79EstcdljoQEji/JBVXX0s84X/6g7180Hw31BfNDa3xjQOXFeMZVcZYoGGfENacIzjK/JE6d2C633m80Nyad1Shsph3I62x1LwCoEywgT4vNynmo0x/TLQtkrjmWL/WmRSDM/NKBitFESZoRau4anCCtgsX4oEGVk7hK97pQVarJRjWa/Ob2dSkdVnBb16YwT6qYzUcUmOt7W14zY2Xq3JyC5d+DlFcR0++A
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1968c416-271c-46dd-c9f0-08d76bf72c58
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 07:16:04.0239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: raSR2P3QxS+aaKBh6ZNUI51M8EmYn9lUAu//k4fI7aczBCs+nAfPYQ6rjxASTRut0oMFo67lD4XWa+msOrzDQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5998
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Can Guo <cang@codeaurora.org>
>=20
> To be on the safe side, do not touch one lrb after clear its slot in the =
lrb_in_use
> bitmap to avoid messing up the next task which would possibly occupy this=
 lrb.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed by: Avri Altman <avri.altman@wdc.com>
