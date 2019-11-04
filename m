Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E07CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 14:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A08C5217F4
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 14:28:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PsRGarmx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gXEZF5PU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDO2S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 09:28:18 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:50108 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbfKDO2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 09:28:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572877698; x=1604413698;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4ePJuGTEnSrCP5e/TpRKSH58LDheLCb2m1vAnSTjr+I=;
  b=PsRGarmxp+ajd+mlw+ATsF//LZwRsTNnP658yVWAne62KDUUzV5RVaWC
   Y4tSr0uNqRy5A0O6ft4oAn6tHfgW/y/r8U1bu2KE2/FjqahDSBtjH7naM
   Ija/0wL5xE96+RCgVcs16Lln/lNQHAMMMi8RjaJ274+ReXsqfjTh0Gx1V
   iCp7c1MeghQ87dJaArcDznRPZHQxB97CIPLa5n5bGeqMpBdapMW6uVtKO
   xQTRxr+dyF4kftxjjQ+KhkQlIhJyjxitstTSbxcOjPPRnqkdvevn4OmBj
   11ddoCryxWkVkncsVcmQ03MvY92JCdgtQGpO3NP8BAAYm6Jtv9+Orj0Em
   g==;
IronPort-SDR: BYlkHa7IFegNY8K3oULLgI52p/XLCyVSrk9YMF56Ndm001VqIiKyDmY9aU3T2O13fGLB+19SlT
 LQEy4WxdPAZuDr/ON82lXkQDK45tB/TCiyPZQOrUArxxBD92i4Q1WVCLej5az7xqVPsxiPwjXK
 b7NfD58OO7g34IGA99cKmDUUn9d7GhoVoH2wRLPJR5uDF1RSmdXrEczeqpH6J53PAXgv9lAwuC
 tonC6Iw8fIeqi/uNZpzvj4ROYg77Ak9xCRRATmnx3HO8PJ6ebNe7o0IE9mIAQ6vfQDBAMMtB3C
 o2I=
X-IronPort-AV: E=Sophos;i="5.68,267,1569254400"; 
   d="scan'208";a="126481471"
Received: from mail-dm3nam03lp2055.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.55])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2019 22:28:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmJ5Kta6493BWvAXwnuMMjHR1AKfS7u9BlHSuHIy7rgYw/MV/JDdxkg6V0DCYgqV6Rw/NMh4moRLULHQq9udNHPfSDCaSdjZc7kwNEHZYNvWaCi4CSpqZMxTQPi9/Ww2OJX8CRcelAMUQjVGckfaFMRHd4zNMojJbbl5Z6Daj7DrxzV2hfRiRx779S1rt3ecwKK4efWr7jnvkbnEt/8FV6aknZ29+nE8TpWsujzvgIauhRSbq9DM7pcCXvMHkxrU2tY7bZ7ADkKFn9IQo5dSUQyEFHuOVT/bZCxt0YHqFwB7vX3F8T7ZNBqfe/FOj24rMpl/RXyLBViHA/oeF/Zgbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ePJuGTEnSrCP5e/TpRKSH58LDheLCb2m1vAnSTjr+I=;
 b=WaUZ9/aM5xh9WXXiJpxxyanOR3/Vx4xloQZqRk2b8L85O05Ihiyjs9fstHuizdjHd8z75rt8LDsUdJfteOYX8MLWYYIM081Uy7E385LjSIPY7+96347wyzMAy7QFecQeXueUK07/E3IjTtSUIy77sVJZOlJfyQIkk9ch/ZWjjYhlIkPMIME95L+848hFKJKTg1UyrZ9bKaVFz2IOgJm/pKpnakKhNW1DlqgQnDX9coRxpeiF4cnsOdZqOJ41TnoGImfoQsZkWGcYczZ5aQOTmjQpEiE8vj7HtaC778eWKbEWMcPHlWexy1AcgOVK9MRGVf2aFiV9im2h+rWSw1V1tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ePJuGTEnSrCP5e/TpRKSH58LDheLCb2m1vAnSTjr+I=;
 b=gXEZF5PU/05+PQkFiRGWGImFvhWeBykt+pmsHAEAC6eFEFxCyPzMPDNqYXWlMNrVMRluuomLTmu8LsXdBY6jrjV4+lRxhha3nudbVDlWtLLnh0iWmaXULm2vZ/Hlm81xJ2gvS9b9z/EZ5oEzGcCTFOnQ7pm8zz3UcE0MGbgTdvg=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6189.namprd04.prod.outlook.com (20.178.246.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 14:28:14 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 14:28:14 +0000
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting host
 controller
Thread-Topic: [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting host
 controller
Thread-Index: AQHViVhK3N4s/twt9EelChx5eY/COKd7IyHQ
Date:   Mon, 4 Nov 2019 14:28:13 +0000
Message-ID: <MN2PR04MB69911784473463D0926AE3B5FC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1571804009-29787-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fac78512-0550-41d2-e39a-08d7613339ff
x-ms-traffictypediagnostic: MN2PR04MB6189:
x-microsoft-antispam-prvs: <MN2PR04MB6189C99551CF173BA08C5F04FC7F0@MN2PR04MB6189.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(189003)(199004)(81156014)(486006)(99286004)(81166006)(14454004)(8936002)(476003)(446003)(11346002)(7416002)(8676002)(33656002)(25786009)(74316002)(186003)(6116002)(305945005)(110136005)(76176011)(316002)(7696005)(6506007)(102836004)(26005)(5660300002)(229853002)(7736002)(4744005)(3846002)(52536014)(71200400001)(71190400001)(86362001)(66476007)(66556008)(2201001)(66446008)(76116006)(256004)(2906002)(478600001)(6436002)(2501003)(66066001)(55016002)(6246003)(64756008)(54906003)(4326008)(9686003)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6189;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ov0RNLxZI4/3Vaa17cORttmZX1V3u1xSF3XUCMvZIbZ5pkBE5GwMm5NEKq2wRH/rd7HNaECx39vU9v4NXQvIuM3VP/C9dKjnTDp3X9hK959RQeiIeIoD3xd+XECO7KjJBuavCUaEdiWWQLBM0q3gpN8WTK+DVroHs0KB0Fz+Zp83chhu9uRecBetNnL3RyHqECB0e0ULBz7h6z3DHLdRzZId5HCEZz1l6rpNMyxZqmpkioX3J36BuNH5L30KZ6G5orWA4INb0ct2aE014SI4X/obB+yDEeqjv6q5r2BNm5LTnJyvNq2v/PcAjq+9r749z66vdmBQ4FEa9ido6hn8wUSYVRdSRa33bB2gO6cAaogqrgIZSnsuxQjhmOl5l5astt+PYj8BdwByEn/E0zF4GZwsNYZ2NBGTz19bffdZr1ucb7PTXlf1HTuv+8qLrqC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fac78512-0550-41d2-e39a-08d7613339ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 14:28:13.8575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S2SPKTe6AXX/ptbHxBxEwRwaosIwgtEUBmzWrrv1Mr3+p8AJR7m6ChxVfdxpb01JRF53AaWw5iK+XoT+q65IPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6189
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,=20
>=20
> Some UFS host controllers need their specific implementations of resettin=
g to
> get them into a good state. Provide a new vops to allow the platform driv=
er to
> implement this own reset operation.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Did you withdraw from this patches and insert them to one of your fix bundl=
e?
I couldn't tell.
As this is a vop, in what way its functionality can't be included in the de=
vice reset that was recently added?

Thanks,
Avri
