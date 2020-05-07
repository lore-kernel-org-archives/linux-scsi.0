Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B9BC38A24
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 07:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 099B62080D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 07:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="agxVSGPY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ttv+XZMh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgEGHzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 03:55:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57857 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgEGHzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 03:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588838114; x=1620374114;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=agxVSGPYKAX00SDZxxqoH4eZGn1Bq38frsglNCLUIAUZYL5Uba94C1Jp
   5Wv5jgrnrJSAV6NiELHf4ZkIUs7Tf6fpEA6LsLkcdFIcDetEXVrtKdxUr
   AfbNp4vuMq55P/MZRp6flhZYBqPbvXrOGy6isowo298xmClxRQjG+O/TP
   V8jEPXvfb8YJj3E4YaCbiReTsq1928WZQiwhp8hDFw6pslqbr0KySK0o4
   f2AJ3pRcEl5joiSujraEnLVin798QXLb9dRXnA03+jYJv4QVPpO+t4OSR
   WXmX1dxdoqx1mI59lQrG9nlsTp1oiI6bPDGIK7OuZG/sD15smFtVjsvUC
   A==;
IronPort-SDR: vI44EgBAtSmKDW0d3djVPOeuWynDpvcQQG7mTPjbCdbOESzaD62Y4nu9VdA8MJ+kTKPA6DjeSh
 JSfVrIdKIlYcmtci88hhXXGzhqxz+1wmrWpIDcu5Dk4hGjyktfB9s0EkO6zk6bztzKhmDzopkP
 7v4nG/OLaBMu7ShDjaoGVHM5I7riwNufTOc27st9HVFi7+t97bRavQs11eLXlleZcxsJEZd1Y2
 v0UajXw01qhcO8455uV9i/W9cOp5KrDcxwHdnEUIj0AR3iloMrNw2DT4D6Y6ci/v1xWyHqH6TP
 oYk=
X-IronPort-AV: E=Sophos;i="5.73,363,1583164800"; 
   d="scan'208";a="137447332"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2020 15:55:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHo+e622KmM9/WPI0BM+q9AKahwRwuIcgcOt0Isygn+Kt5Kvx8N1ky8eASUdPwpAJtPEIZdOHvw9V2TzC2aSyRDXicDuLbUXVDYlCYF1ry3mG9IXARfF/MTAlmpm0Ym5V2XOqv+4kHOV0stpHwyKMau19MXSlpEDPkWrkPf26N59xkfyTOHD8SrbGImmyzVL3bTBsMEiLDVKc45Aos0SuNGlEu4eVkVjWgnIAf9xeeCXKslSpr+hshrDY7KJsUL5wDm7DCWRwUjW8airZ3iCantwi/8UZi5Ems/KAC/QJTTPrRittTDD2DjsArLCm/05hQh9aSs/6lC908fX9i6lYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kKokfXzVvdBjKYFfQv0CVqiUaJ0ZpZhfTKJpTo0Q2n8WXYwSN/qKhHD6XTv2YgWaoM86PnoyUEyPMyxPIjQOGBPIOgeBpKWY3aRe+4f/af5JFVYKyaEjxAH40q6TUgNrwfKKxdRw8R54d/pMjLgXY93Z+6i88L21eiFY3SQUE9QwpsPGaopdQKyWbXDhxSTf4ZJj/9HXGwezhw8VjNqoVgxM+7auPjLiq17ETkhiYC0CVB+/IUo8WmGf8fH79ffIzbBobtzpZ56JlBW3rwHgYqA6EFHpHtQGKfXd4YPFuKwyBFcEva67uh2/yVLj1XmhUJZKVe9K0dUzLB2Nm1+OBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ttv+XZMhdPh3HlmekkrTVhXK3CLZK7ZLnut+5Cy1lrKz5+p1zdW5bsXgsUD1Xx0T8rXUFpEZVKMhvzemDJVIOL8zd/fvJSbWJZ3iBiek3OaYMcGK/TICm4C29dw399Lvcwg3Nv/SuafgK28uFDT/DZHmHNdPbge2phGLq+zZS0M=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Thu, 7 May
 2020 07:55:10 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.2979.028; Thu, 7 May 2020
 07:55:10 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Fix compilation error on 32bits arch
Thread-Topic: [PATCH] scsi_debug: Fix compilation error on 32bits arch
Thread-Index: AQHWJBgufO0GOMryO0Cj6r7KxBed+A==
Date:   Thu, 7 May 2020 07:55:10 +0000
Message-ID: <SN4PR0401MB3598CEC7C9C3279D12A950339BA50@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200507023526.221574-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 735f8b12-9f75-4afd-0785-08d7f25bf7a8
x-ms-traffictypediagnostic: SN4PR0401MB3598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB35983BAA7694557B6DADD38A9BA50@SN4PR0401MB3598.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r6a4zvX1d45Me7HCegZGtwyBy2XqveeECu07swwwB9z4CVCsO3aXabp4q8IwERyWWwAS8JEIhFO5oOW7s4hQCItzRtTqFePUOkNJsMNbQEYH/b0cY/WDIpMV7FJ5mssdV1xeOSCcYjOJ0fPzKUzl6RAn4nq6mK8Ze14GW3lmzm2KL6GBe/koHosDcLPSGMb4zq3ANX4VwrfmO16hjkT7lWxlBMyu2C8VUyTUt2VPMiWBAv4A7zq9HBAonBF9+bHKTcKoxc0k5Ya0WDkmCZxa1qAF8Qp72Srbh86tQxb0Eh6RIJ4oWB6a2FCY4vq64ExXXERW1oKGagXxo9xKUdQl+jQg01GpYH1xcuFyVEVPbAhCrG1Kkko17EjErRBXKJld+ExEU//e7YJLQQyOIqZWQlankL3KWcmq1Vx2DAcS09FRBSre1dJlcZV69YB1E8yPoYBUBStMqxFHNiiOF2osLnfS2KBPHCfS+OWWwZlTxKKnHdd08+eEqkInZX+xu63chLsn3tm0ZMN6nLS/jG8jXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(33430700001)(558084003)(2906002)(478600001)(4326008)(5660300002)(6506007)(19618925003)(83310400001)(83290400001)(83300400001)(83280400001)(83320400001)(33440700001)(66476007)(71200400001)(316002)(8936002)(9686003)(66446008)(186003)(55016002)(64756008)(66556008)(66946007)(52536014)(76116006)(91956017)(7696005)(8676002)(110136005)(4270600006)(26005)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LlVtAMkzLkrN4CppwE5ADBA4tORPctNfRk/1C8m5SBpmXmx95xryOuh4UV9sTJq5B6M/rF3tzyq65uYQqVR9b8e1XRWoaqMs4vqqKP8VsuAAaIIrPb5ZYr5YLndVWkozMalQbLTcZxq+2LXtjEhncFrf6GAHjO8tO5omrvzt287fH72b4X0lK/IVaVHHxwJiKA2vFsm+VbDt5aPs3j2g04Ok91kapS+8SeKLQHs5gS7du7OX6JeHwGBa9JSmHFzQ44Mpnb3jS/X4l5fAl+MN1HQuvk+E5lv3fMaSixD/wnuuXwQE+RWmATjG7SUThkP6PnoWsbn7qW0VymTI8D4WQamHO7k0qR1JBCTzgdMpWSUzwjCPF/HAafZ4LLqbdSyr5B6kiIs8iLma0KLzEFpBlFpYobDaTTcWPkB1EiG9S9+26jT767J+pB1iO42J46rmy7buirLbL3kYekr5xi3zUAcqunTg6Lb2Ca4DZO8SMHveq2U5IxR5sVLcpPLOCZdrn6nOJslo0aMe6KemUZ2UIjwJHaPdwnQieJjHTHKiw1uajpOjiuoQ41VSketAPPQyl/X9cX5v6vm6nuuC47Udb7XF4A4++/Q9l9SQ2ESGs1xsw/UkXZ3L46lHVo/ebPJChfA2l8RkqWcIECGB2nlcIPT7pSLELB67v0wBnxLurPBYg6LS64Vzp0nV41bDh+gJN8rC1QL6shBhBe/NF90MZo+LkcY+itmbCbjZQGcGrZ5cPvlZJ2VeAK9FY7ThYi0m0q/BvtVyagq+9Zmj+2ejohpiDPZQaWJDVNiCqlhn0mY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 735f8b12-9f75-4afd-0785-08d7f25bf7a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 07:55:10.5695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nCmgn0KY7QzivevOIWOwGgRynX0cyPUW2FVPy41BpTx+5YUGUp+p+fJSfKDrUruHjVs5bXYt6+Jb5Htyp8LT4fuBBw0h5Xo8R2zntplcb5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3598
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
