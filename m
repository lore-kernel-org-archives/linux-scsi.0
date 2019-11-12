Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA95AC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4EA21925
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:09:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l3BL1Qpr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vy3GX5kq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKLHJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 02:09:06 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11762 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfKLHJF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 02:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573542572; x=1605078572;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r8tqbKzIxlsbsGLyCrGHNMxKD2tTJEQ2dFgOR++f6es=;
  b=l3BL1QprssvRKHhJeNAjCeD+cnWgbKTKN7JcxRtcUDfjfwMTy6lOpZTV
   nT6FHY3YjgISlYZ2fDM87mP+2jMOqMlr8M3s6M+yqtTJ7zClrPmUEeKz9
   2KfFfU1sZhUU3/Rwazffv4PLgwC/1VRU8EBN1y2k9yn4X4+VsxfMKgGet
   5PzMdmOx9WD5mmmLtbNxGfTftCKaUU/15eY61qZr5UY+fisCdoqtNd5Tq
   E1v04tyl8bOzkdVcf+ytJkC2kIpr4NaFqfPm2yiOI/9Z0F2Qb4y2xH0+X
   zSxSoK6pje00ihNGaPkT/hCsW6VtqH1ULvxCoY3m8pioIfI0TRjZxK1cS
   g==;
IronPort-SDR: Tucgrrw9s0PAPpJCVGQFvCT7m+Yl/CtkEVqSVdd6DgcEDUgy3DsbTsfQXJTb0nvga+PoY8Cf/q
 IOC/JCJ792/O9afAgmDhz3Lnn3dlt5z9QKRzpBlLPb2AjHSZ8m2Tf8poa+ANG6sMSclBeZ++wp
 yLHchlS/o4k1QY3nsT1lsyT1POBREIXwqLOTV7jrii1A3gEwfFnvbldGGM1JCPbKvl3lp8Ih17
 mS9SY0r+OTFrSpEfgElzWe5f8e6vO4cfyE2Nd45ZFKjglCI+z2F8abE6Y6QiSEXBMAZAABIY2w
 3Cc=
X-IronPort-AV: E=Sophos;i="5.68,295,1569254400"; 
   d="scan'208";a="223985777"
Received: from mail-sn1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.50])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2019 15:09:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCBZ0ziAlWEbmA80B/McVRi9WEV895TqkPA+y5QKvzphoIgvDLMGp0W5Ts4tTIMuUwJ9jJL4Dd7WGWINKHVrSf7qX9yiTE8NpMOb+ImWGnkG/Wdu8BpuLNGT72Jt7TQnbf/zArZ+dsHfgWVhkP4xwjYm7tL/OI1NhDV1Ok/GA6IK1ElJnMkiWwtgz4rXKzIyR0FUCNFQHyGJiOBRUV2UrM9usA1gIZGAIbDNZK5VuujkT+jPEDagg3Tm82FxPUX+nlFov7Y51MyWIJ+voSIfWdg9SYXAhiyVoXJmMOgiUGH6iW33l8Yu6tYvyjWDz4W21vzqQp0A4XcEDhfTnZjMJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8tqbKzIxlsbsGLyCrGHNMxKD2tTJEQ2dFgOR++f6es=;
 b=B9AazS5IorAWaHh8pO3l0JeTtv8ulfgnGNjfvxpi1TNQ9R59skTqJ0244JBi57+uqAoZHO8101HS/hhrWp5/aGOPH/UG5+SmPHyob5Nsr3MoYXOyqcg0tKMawdbJUakGKT5MItWLsy7MTGY0y0tLyJTCcyvK+SZ0exmyjqy+e5Lz7COc+2WKHn+M5cu/4u9Jq95Zl7vp7mfrb0WdoIOOkFCjAUly7F58z+ZL0WGvP30sNfnhZqeaYsVWDEAEYAN5Mg7okETS2b4nQl9QxJXTgqXAe+YdlFEcUm/g0HWNtqfEViQtiR91Ic+KRByC2q4HcMntg4ANhD5UT4jFra6D9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8tqbKzIxlsbsGLyCrGHNMxKD2tTJEQ2dFgOR++f6es=;
 b=vy3GX5kqtnt/SAfhorupfIhv+0Z/gxZmGykexJozMZ/cwd0Yt5v2JCHoCgqAt792uEyeZ80jysgEMI3KY5FLPRfYdmcXLV4HMDDrqdlFHVHFF8iafdGQZ4zPlWIdR4JobbTPRYdpvcdgk2RQ1HheM1b1pkngEalfsQ6YgL9keQ4=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5664.namprd04.prod.outlook.com (20.179.23.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 07:08:47 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 07:08:47 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Janek Kotas <jank@cadence.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] scsi: ufs: Add driver for TI wrapper for Cadence
 UFS IP
Thread-Topic: [PATCH v3 2/2] scsi: ufs: Add driver for TI wrapper for Cadence
 UFS IP
Thread-Index: AQHVllSiHcw5O5TCgUaZXlQBroFh0qeHIzOw
Date:   Tue, 12 Nov 2019 07:08:47 +0000
Message-ID: <MN2PR04MB6991B7577732F25EB139FCBFFC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191108164857.11466-1-vigneshr@ti.com>
 <20191108164857.11466-3-vigneshr@ti.com>
In-Reply-To: <20191108164857.11466-3-vigneshr@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd90cc93-a45e-423d-b621-08d7673f299b
x-ms-traffictypediagnostic: MN2PR04MB5664:
x-microsoft-antispam-prvs: <MN2PR04MB5664DD18D50A425C224C0995FC770@MN2PR04MB5664.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(199004)(189003)(26005)(305945005)(110136005)(54906003)(71190400001)(6436002)(229853002)(71200400001)(99286004)(74316002)(9686003)(316002)(6246003)(3846002)(6116002)(86362001)(66066001)(4744005)(4326008)(7736002)(66556008)(8676002)(76116006)(476003)(7696005)(7416002)(2906002)(64756008)(25786009)(81156014)(66946007)(81166006)(11346002)(66476007)(446003)(76176011)(5024004)(186003)(55016002)(486006)(5660300002)(102836004)(478600001)(256004)(33656002)(52536014)(14454004)(8936002)(6506007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5664;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M14cSDgTgzd7tMTqUnikWW1CrMZ4vTvGZdF7ROiDUZwvYrMUqPIgY7tY0wg+lSQr+zalNFKsv0XPpGmGPHLrvJ+7SGDlNU8Gq0NgnH1Hqeu0Lrmu964mzxZRLJ+LQjT/vtQJ+fOOZWrnj31ifwGusG46UJBk/qM7Fe/JzDEPh1g6ohtcw+MA4nFZCz2Cvuh0nd/uqMGWg8NgpWoRNxiv7bIEie5O6AXAQ103MlFGLtzdwjZtwsRzEURMqcOIZ/W2lptgLK8I+bKAq6iSNu4Qrv2ym1rJueqhmApYYj6+jt1aYHg8Yl9iAzLEPEu0phm1DMND2DzP4BeLIT5TgrjVwcq6/QjGEPCrpfJIUUY+YVJuB0uRf4hTW99vews2p0G4m5y8pTmNXPNIz6J4IvZCxH7WcY88T9pxLa0InnqoYJziRjOMdszoS20anKL3UN0p
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd90cc93-a45e-423d-b621-08d7673f299b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 07:08:47.4218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 963z2EEE8Vicg/GMVGIaRqq5o71ty3C5r8AHPx9o87JQdbFGuP+M1gMV27BzzKDV5igAceBw81j4o+I/4Bq8hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5664
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> CAUTION: This email originated from outside of Western Digital. Do not cl=
ick on
> links or open attachments unless you recognize the sender and know that t=
he
> content is safe.
>=20
>=20
> TI's J721e SoC has a Cadence UFS IP with a TI specific wrapper. This is a=
 minimal
> driver to configure the wrapper. It releases the UFS slave device out of =
reset and
> sets up registers to indicate PHY reference clock input frequency before =
probing
> child Cadence UFS driver.
>=20
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by Avri Altman <avri.altman@wdc.com>
