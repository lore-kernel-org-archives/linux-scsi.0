Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6893DC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 20:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3248C20716
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 20:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QZ2JaXJp";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZxOYay2L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgHJU7C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 16:59:02 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37291 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgHJU7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 16:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597093141; x=1628629141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0FohuZoPBfwK4Oz+oXKhchVmpsOsG84ZbQ/rE1JNQvw=;
  b=QZ2JaXJpP0xhb1flozAh5LSPCiCps/FTOUro1u88TmckIk+gGCOGwx/S
   N7u3H5F65ixlVUzPs+NpjWoZAnhPbnswp2dVUYosMOr8XO3raBY+ZJU1P
   9+1xTovQu34rJk6yfv1iFkv066m/36TuTxol1UfBMPbn7j3nubPa0A/lC
   NGOrO01lUIdI/sndrAdvPdOTE+7SitaDFBDNTzPX/yWHR75VYrn4txHHE
   pewW69kYthfHEPuMut8860ccqazPF3F30rG0Q8vogMEdYR0EIoe+1JG5n
   8zOsTiFz7qxT5qRQqLnEYBYn8tMUQKQA42MrrURyPvPl0/ivW3Ec9Y1rT
   g==;
IronPort-SDR: xEQXW6nFhxVE10SdrZVyjXdxoLjPq5F33p22FgfNhJuFfhYuMAi//WPF8eyXDRqwIAUlGr7YLw
 px0Ez9HckPRKfW24y12qk1I58+dXVZAjAvQGfGdXY/0guOu0PnzEwzR0w7UCZsgS8nkHxTs2eU
 h7zEI+vpDxbNqbv3RITn/X1HQrlcEzjzvszWNJcaSK/qnMVeLUdokoPMWXUqD/EwFHkS4Vqkr4
 2KpsTin4Ef4r3Z4/VCr84rMyE7WysVbl7G8o6T43ajM4nav2pR7zQ5uWoWscInaDPnFiTWUGZf
 gBk=
X-IronPort-AV: E=Sophos;i="5.75,458,1589212800"; 
   d="scan'208";a="144657934"
Received: from mail-bn3nam04lp2059.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.59])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2020 04:58:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxtFvqYCOi57m1fnYZJ+0hQZ5YBct0lkAjFkC/MITcSNjZ08EVE2O6Sgl9VkEEis3ZYVZl99hXD6hsRWP5NFpEy1oLrnM+uORumBxuAU6rJF0C0OYnxZIwgMpNUDPCdW+bR6XyeXLs5cKKSyyJRMf14YAW3YL6tEkyRMJOKKIBEPVOe0qWKqpnITVhv7n2YbNOWbqCrpUiY1tx/YESRCVmQCMpX89zwvFgkt/i1zl/TDR/f97t3RuRXaTLQtH7+0uabUXxkHKACMmps0nLehaabiUzHrHC+dxqc9glgDiatjs1HmeUK6163w9XVOUfB9Y+7vimz2Wjjt/GFXmdVA7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FohuZoPBfwK4Oz+oXKhchVmpsOsG84ZbQ/rE1JNQvw=;
 b=gvBj/nej6jJnFlDJi2CHY/5tIDbw6hIguXO8k8FoDudYsOsQZ5yEDv/WxwM9ClGmPLNArW6RZaQDeosGGr2AQogcnL4EWqLLeX1qx49hEhRfSjLs/HdCKWK0BzNHGipHiLz1qXzJSxQ4dFiX0PqUU3pERRQNw63I1LRFhRXa8xDNvqBTPGngZfdoxP5TYVdwdZswP0wtDjG1EZFOJ7num5U5LRYj39mia71XeNMVc2cPCAbLxPqzw//cdhGb5yw7hnmfJJNs2qtHBE+zx+8/EPBC036NPo+j8YzYKqi42wXX5Hanelke4X/PIdkgsllnBPsE9gCvt7bENrmGs8ztug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FohuZoPBfwK4Oz+oXKhchVmpsOsG84ZbQ/rE1JNQvw=;
 b=ZxOYay2LfX87Dz9398rBZd5/+Q8CadxQ5Y+TEEhDPtcN3BldjBhX4/Qs1qT6ocy1QyoO3bxFyY7qlUR9+CVWlsr7yG2Jf/dzvO/R0xXc3PWuACpEHKXEcsVIs95vRFrXc5l34OTYRgTh3m663gXpPY6Bw35/VJNdwPy5oW+q9TY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN4PR0401MB3551.namprd04.prod.outlook.com (2603:10b6:803:45::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Mon, 10 Aug
 2020 20:58:57 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3261.024; Mon, 10 Aug 2020
 20:58:57 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
Subject: RE: [PATCH v1] scsi: ufs-mediatek: Fix incorrect time to wait link
 status
Thread-Topic: [PATCH v1] scsi: ufs-mediatek: Fix incorrect time to wait link
 status
Thread-Index: AQHWbhHwgR3BsHpWkEyhFBMFuXwxrKkx1cJA
Date:   Mon, 10 Aug 2020 20:58:57 +0000
Message-ID: <SN6PR04MB464019F00686A7F82547E99EFC440@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200809055702.20140-1-stanley.chu@mediatek.com>
In-Reply-To: <20200809055702.20140-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f1fca3f-1ec1-41c7-c2e8-08d83d70332d
x-ms-traffictypediagnostic: SN4PR0401MB3551:
x-microsoft-antispam-prvs: <SN4PR0401MB3551D7B6AF4C4AFC2F2F1C8DFC440@SN4PR0401MB3551.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q9cz6l5XtBu/cVAcgu5E+6iroukpH4zZrlS/jyKzEXiK4pu9W6lB2X9WoFSzuvFbue0BWgnjVE0noa4A9lgwygglikzjjxXvCvRgpuf0SJOFjA+sU2Lotd8AG1HGg8MPjEm2jRS00Ng5vP63SOfcACOSX8iYhcYpClSy7mFNoqorOKliHdh9ohXC+hsQaKWYJPGCFoceB3uEq7SF+dTbGYmj3Vm1GXeOjtzeJva1x3Ok0ehkWB3QzuD6xkcn9IUuKQwsurVMnJxtj7DeziHVSiKfvJi4jSLoHKvmLPKK8eg9WeF68XsFeaQbWITrXAv02KLkGBVacZNLHgoxfZQyOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(8936002)(8676002)(52536014)(4326008)(64756008)(478600001)(5660300002)(66946007)(76116006)(66446008)(66556008)(66476007)(110136005)(316002)(54906003)(9686003)(2906002)(55016002)(83380400001)(33656002)(7696005)(7416002)(86362001)(558084003)(26005)(71200400001)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kNnqc5MvNwsS8gcLMdmx7c/i4nQ5HAsVEiEqImLcoJ+ID0iGJjt29V2xyN9RDxkI6blz6tiuEqUaTl3b7TXYqsWuOrSkB9HoOs2lUNrPVzEPDCuElwjKUKyfdEtt8WDlnkkAkxFI81fhXAL1hG1wEXmjJrOM1XTmEodVNvoFqhkqAknvq5FuPvWWlUvO0axR2r21sOIlNczdpKXwTCZZkIuBZwgiFaQfmNDNlXex30KKEs7vikfvDSGMp8vaPIm+4G7tQemnrVAqButDmpNOdDU7PZfH3OGFjwt6OSGKbRU+byKYioyq0PUPZVrPq+dyi197sGgB/tUknxYJLRkjUGx/i9kikfesqHvnRE3CgtXgq6NHraHsnI0Yo5vypzjuvpxvY9xUbpH3YPHiLKtUY5tTFduU7MdMm1ZsUdML4zhlLorPTuKEDnvEzU9G11ludK0B4DLm89YziFWq3ON0BXoy0A/IeYjB6Xep+3O/B5qSJJffoLEqYcVFoq4Njx6SSg4/5uAiD+ggTJY5HK2ElxHMpi6B4kIwosX4XnhVY5+rhWLCdgF0AZ8tHZ02N7kpy5/jj0rbGViYlZ+KjfzmA36PnHK4/U3GRoWjGjNxxImeBPcvHc3aKYg/hIDcqU4jgFtLT3TH9CXcIct3E3Gp3A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1fca3f-1ec1-41c7-c2e8-08d83d70332d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2020 20:58:57.5784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g4jG0ej/nNGObeumoWDC+XQeG9FoBYGloT+2VPxFRMce/W55J+Fck5y7MKlNZEYDim6thtj8ePSV5QGIbOFd3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3551
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Fix incorrect calculation of "ms" based waiting time in
> function ufs_mtk_setup_clocks().
>=20
> Fixes: 9006e3986f66 ("scsi: ufs-mediatek: Do not gate clocks if auto-hibe=
rn8 is
> not entered yet")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
