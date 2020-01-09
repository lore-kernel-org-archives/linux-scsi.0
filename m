Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22EAFC32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 10:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E45A820678
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 10:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mVTHQXis";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="QNfhEEtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgAIK3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 05:29:37 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31365 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgAIK3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 05:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1578565777; x=1610101777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hm+kTmCFMm62y0tbiD8AiRSUukM2NkV7k0tGZZJmt7g=;
  b=mVTHQXisQO2OSmgB7pDpPIf/H290PUDmVomqHdfnnsWTmR/xzU7EtI/B
   OKCn2vwj1TM8p43kT8OMC1UtmTltUG+gtyZOR0xT0QcmP7WgOd4hKFHXm
   LZIkZAkkE+a2XsR5WfDN2LX1utsjTxU3VgJsCzZz1iaQZ3lh52rSy3Us8
   d5hj2v2RUvOheOJ7EYdVh5JcSwDWg7JPGsR1pltBrv2CUFzDe7Wq/MoWn
   9kdDVId/M2EHquDKgOgE1zUzBxLdFIUdE7HViNT+vhaSoNIEk1xXWkgmn
   OOXK3uR0X2hlnGnlrg7fy0y5Bl2Q5fnhE5BwybfH9LiG5cA8bbCELxT6w
   A==;
IronPort-SDR: wIKoFr84K4zN+Rbx8+z3ba2uuCrWP4baEQ8G+ySaDmse4x8Xi3Tk1GpcMuf9JtWPazHmUzPPGR
 Kl/Q9ewjITLrvIwiSESklVB6EBJp1l3D9Cg7hxbBWnTp302OPmV3JOhWoC81s1uy0HNhxSxk5F
 Ii/kzME+uZ8oC3If0P4QlVu2BOWlzmgaJNeYfVXFba73X7Z651s4M69MO9E5WO5MTeb4tRmnO9
 wPPmc2sYa8fSlGDko9/zNS0/eb2yQLV/t1KSWUrV5tgS1UCiLYWUT4NIJBPuCIB2bxbjc2ofjR
 DWo=
X-IronPort-AV: E=Sophos;i="5.69,413,1571673600"; 
   d="scan'208";a="234837854"
Received: from mail-bn3nam04lp2058.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.58])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2020 18:29:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5Q1VN8VYe8Gd/ux6TFr6n8hyGEUvk4JPjntFcbsKpCUYU+316NYQ2un85Gq3qZx+tLv2hOxMlgVQkYuxlHReQNSXGSJc0Ev5975nrJStOjguisTjplE70vAhnESXmBleD+/RoDon6cCgeDIscstUXS/SBClkIQtKl1RfG/dChoiOcfKVLwXmlKoprD9c1Kn4LAkgYsipewhNlFVBmKjuk6nwKseopEBp6Rxe3qoUDOUd91xDy2f7JN8zUWOeqipFiSf3oj7myOTjfmtb5DxK4gfyt3U11wZGY+lgzNKccm22CbJaFAeK5bLXRTi2Zf7cyDROSF3kwTl+CUomb3i6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm+kTmCFMm62y0tbiD8AiRSUukM2NkV7k0tGZZJmt7g=;
 b=FMdsbVdNjw5eXoFCYCMndt8OhJwGXlMNSucK07nvPpuhG4v5WBhw1o4VpshJGtbITZSAMwLAZlRJr++M9Ue3Vj3tKphqNvG6oMYgvXp9WHP0/S3y3Phj2MhnJS9ej0FvNk3rfxDJYsG7FT6Xs1EnrVonTrUfUkTA4XLDfQ3EdHttC1ojv51az9Ru7FozxnyaVtMAgXeueLt4XmNb4aGeeST0udybx/74UZpPduWNPk35neBfbgrZpzwSVJ+jU8dEDlwpFIxavZdkpxQR4D20hSd1jz1C2po2gKPsxYJ0S0qXzXSHizcPAxzoOOeFmpRUqb47PORUu2kbIJdH/Wo48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm+kTmCFMm62y0tbiD8AiRSUukM2NkV7k0tGZZJmt7g=;
 b=QNfhEEtLZ5TKaJYs+MNvE+QTMnHEtei9RNF7PKEEfYv4qimTXuegA/RcbCnVqRvI7oqfYhhzuTy8wSWekZ9kVGfaNj//mC1L+tw9vH0bQLXTWNV1bPdfuKYHxWnoGkNWOfvs0DtcwuvIe2Kwvrq1/UVTLCZXlc9fwCoDMMJd8Rw=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6208.namprd04.prod.outlook.com (20.178.248.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 9 Jan 2020 10:29:35 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::460:1c02:5953:6b45%4]) with mapi id 15.20.2623.010; Thu, 9 Jan 2020
 10:29:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH 3/4] ufs: Simplify two tests
Thread-Topic: [PATCH 3/4] ufs: Simplify two tests
Thread-Index: AQHVxZBGk9xqJBwGUkWiuFL0By7Ne6fiJBAA
Date:   Thu, 9 Jan 2020 10:29:35 +0000
Message-ID: <MN2PR04MB6991A9D093CFB40883767E59FC390@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <20200107192531.73802-4-bvanassche@acm.org>
In-Reply-To: <20200107192531.73802-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 153bd145-c8cf-41b2-e4fb-08d794eed2c6
x-ms-traffictypediagnostic: MN2PR04MB6208:
x-microsoft-antispam-prvs: <MN2PR04MB6208B12335886A254885F845FC390@MN2PR04MB6208.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02778BF158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(189003)(199004)(6506007)(7696005)(55016002)(9686003)(26005)(558084003)(8936002)(4326008)(52536014)(71200400001)(5660300002)(186003)(316002)(66946007)(64756008)(8676002)(66556008)(33656002)(66476007)(110136005)(478600001)(54906003)(66446008)(86362001)(2906002)(81166006)(81156014)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6208;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PsVvRLE7LhfwN45RutC7B2ORs0mPGT3qDyBXymYNzRJoXDG8E0WPfur1wEHjwxecBVdCsT6+twIZA1IK7Dtu9SdMyU7whfjHgLyq0Pcsqu3b/vhvKLW3axnTToZ/V78ouL01D65VUQYgJOugHHiSMF05BIYXWqBrVZnq46OefNFpyvjVI1MShF40zG59tb0dBTNZnajMhcImDm4um0p7BOM77WLMXhWxG5pX5L/eGoUH2zj+/vtJZtKHdjtlPqbp3CVuEWks6ecB11xcw217Ltc3KkMyhTgphB3mPcEzBK9Kl+HrXhjv1fIcm+KjiZSmI2EkUJkj8IFnV8x41F03WV21Z9r/JfFDzXKaFQyESpcQerIi3iSFvoWScvWTRycgahJtzYA7E4EDULoQUqr4Wtab1cB+hwSk51Dsic1szqNuPeGxoMKf0mTEAVWSboEP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153bd145-c8cf-41b2-e4fb-08d794eed2c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2020 10:29:35.5213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c2mvR7Z1wzD/mBkD7nrTAK/t2j0iTYN+ovxp8M7/GNozSPeZb13Ro76l1+ElblwyAK7MgvnRXZUs2p825zUhyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6208
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> lrbp->cmd is set only for SCSI commands. Use this knowledge to simplify
> two boolean expressions.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
