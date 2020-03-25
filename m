Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6835C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 23:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719732076A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 23:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OGI6d0XY";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ZG31uReT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCYXTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 19:19:03 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:16884 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCYXTC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 19:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585178342; x=1616714342;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IVlV+CmZxrd9kBtUBLuclg5Vz4jmgAF9GBLThA0axoQ=;
  b=OGI6d0XYHuak6pLBHDeR0fwOHCRjChPF/1wI3p10A1Eh7/wcRGz+co0J
   Q3mkoFyBOtE/BJRmfMYG+iZ1JXRlQlpYUc5bp4nkhT73b8mRfG0VEhqKy
   j0hAx3NQkRohWWJEfj0g1GOL6LeRqo6X4TtW2Nh6ghFXGkhyYIaqMS2Uk
   pW7VQVwyJMtGVWbeDoI6eQIpS3tyzw9uWA5TOjrLBqP7SuFHEqMJ2XtGK
   w1CuQnt9WdeXtpdk3VmYwUdFbd36l1FGszGY5RM046237XmCqI88xpFex
   AmO+uPMyiqKp+phSH+HLsuI9p2DhVD52vEXQdJGqu5s5A54OA6HhAXNV+
   g==;
IronPort-SDR: u6ND7yk97Jawc4pIbDZFI33TpyG/X+1jutlTa7kioOm43gwm+w0jniogSKxFpYN+faG1otxoe8
 QvIPzzNEGvPs7ccQYhb79Eou+s+jo/hA9bSy+9ir7giEtG1bZqh/poPu6OTqhGHUDqkkJXhDkO
 Ju1rEOXaKV3mX9SAotnYQUKF2fZS1hVrgLP9FgaORK2hxH9L7myCaEwaQ9CkbjfJDmfTm3iK55
 FuR8jfPn+OwVlN/apDyKoeuq5q6lQG+JgC0KDb2qNZlTg9IbgTv1odHxiehKXmLF+GqjEisVOZ
 LnU=
X-IronPort-AV: E=Sophos;i="5.72,306,1580745600"; 
   d="scan'208";a="134953997"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 26 Mar 2020 07:19:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnRKRyf54VbMv9+YrIDQAK6BtG929K0IYtnJbgm/5w8OVAi09fntEjPb/ogE/okiAr/dLy/IfFXpCX+ZA6BkXf0c7z487nrroMgW5bVMZHteVDOBgJPH5CXFva+rzae9sFzC/OOo74+aNni3wqjnW26JEf6I3rG8llyxmNdDrr96LNzVYp0J6rHfp96ZHYS2zFlSU4i1WfcxqSi5q91XdJwyEoGx+suoKvDLrFT+uRVgap+pmoEoquDpWju3JJ2woLS3V1gmjX18CrLK840sVbfFBWVXaD94XUuORECxHOuA3Ju5PLlOhJMMh0SWLPZGIYWuQpVsrgLK/oOWmdH0lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVlV+CmZxrd9kBtUBLuclg5Vz4jmgAF9GBLThA0axoQ=;
 b=GTX68yM6uzvi2coxS3CPB5KZndjikQ7QPDk5aPbT2IBmJBBrrh0vbQxApSm/PLaY5wz603yI7N55Bazgw5erq1EN54Tln8YxQsIiaoN+S1ygiRRnW4HMV1lWAWMzQ88NhJSg5h2q4lp5NlYfVfpH9cfgu7GMSxIchdT9xM0u7rHLm3iPHylivF2Ls9OSRr+jXfrKwwtJPo+rv1z18Zh+xSdQJCjV1BSn85A20ktG8VWgVmaZYR2PSNzAJchev1J8RpPVcRl7XJsAGQB6WyhoiWs1NWEhv8jI619gJ+AV9wJo9ebeb43QgHENMD2GS0xMW72z9adXyuoZes6aherMGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVlV+CmZxrd9kBtUBLuclg5Vz4jmgAF9GBLThA0axoQ=;
 b=ZG31uReTnHqvoWv6P6POM8D8FuvsO6zlcdmKQ4No4XlLBWT29dLepGcO19YyjqcVQWqWv5ItT17HBjmdn+RE8mZWuD5NzrZAyVpx3MBYvrAxK0sUJTYegG4rYNbXxeA8vHhRX7gHSxHKVoU2KqBVbxD1I9Woh2DSVcfQD5252uY=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4446.namprd04.prod.outlook.com (2603:10b6:805:3c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Wed, 25 Mar
 2020 23:18:59 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2835.025; Wed, 25 Mar 2020
 23:18:59 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/1] scsi: ufs: Enable block layer runtime PM for
 well-known logical units
Thread-Topic: [PATCH v3 1/1] scsi: ufs: Enable block layer runtime PM for
 well-known logical units
Thread-Index: AQHWApnW8d/lojckW0+fOnV7WNzy26hZ8Txw
Date:   Wed, 25 Mar 2020 23:18:59 +0000
Message-ID: <SN6PR04MB464005D38551AFBCBBA72E2BFCCE0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1585136153-24852-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1585136153-24852-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:188:9241:9963:f968:2096:7a55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 086dd241-ce40-4bda-9d89-08d7d112e5eb
x-ms-traffictypediagnostic: SN6PR04MB4446:
x-microsoft-antispam-prvs: <SN6PR04MB444627B0B719443E066C8D0AFCCE0@SN6PR04MB4446.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(71200400001)(478600001)(66446008)(66476007)(52536014)(66556008)(186003)(64756008)(8936002)(2906002)(4744005)(33656002)(9686003)(316002)(55016002)(86362001)(5660300002)(81156014)(66946007)(81166006)(76116006)(7696005)(4326008)(54906003)(110136005)(6506007)(7416002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4446;H:SN6PR04MB4640.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RBO6UV67KIAGw6gPq/1/7PHPobPyA/lHhefHFYjGYztVUuxnPg6keOPGCV4W/I/PfXqvkTWx2ZmY7yImg93AoS8LfKsyAsNd6M2VeO+EsDldHSmuxxLiIs6mG0DQLj4SuPnRvxdoCMi74j+Ci8DuJCSZSlXjAgMPE12jWJxp07/z4I3TcMzXCQg257UucxFC6QFmroC/6gpiVyU3iZvG/z7rRsWSzarvbzpv7xX+GvfqI64Ok4wP6fAj+VuZYvVF34PRVmBPwSQi+Xaa2o6IcBNeptSusPfYwYUzJ75jSGNpHyLHpvMAifiO39e7qkSvadTz/gO8957GucOEXaiDURgNipW1BlvMVHBq/kTu4AqBmlyCYThT9BaUqBd2lBHC0xoZi1Ex2DOEPy9N+LC+fSQZ6GKHGC1DGTuYDK9B9btjWCR2TMH3d3YfFDo0Ut2c
x-ms-exchange-antispam-messagedata: elMZs2baHWTiQEZnrG2mbS7nt77Uo+fIRCoBKxy6V/g/9xsf4aFf2tgYNVGGyhu2CdX+hdwux2RGwi+0/KPG9BaHBPFpj39S4t5dntZOBVhVD3SusOf9+CntgkmsBmO9hP4qz9WF1e3YFEpWEU73pFaPCcbO2MfAmjKgLRgR+a+RedOf+OUkJGG/l54uZEqJikhvm9xh7xwL4zKp7ba9ug==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086dd241-ce40-4bda-9d89-08d7d112e5eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 23:18:59.1503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qw6R05iSUujVU4q0RtLd4qMc/863z7h/iPYkDI+Gj7lA3/tIW91ghxvcE1/ap6blIUEN9ivOw+d/2xbKbVmG0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4446
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Block layer RPM is enabled for the genernal UFS SCSI devices when they ar=
e
> probed by their driver. However block layer RPM is not enabled for UFS
> well-known SCSI devices.
>=20
> As UFS SCSI devices have their corresponding BSG char devices, accessing
> a BSG char device via IOCTL may send requests to its corresponding SCSI
> device through its request queue. If BSG IOCTL sends a request to a
> well-known SCSI device when hba is not runtime active, due to block layer
> RPM is not eanbled for the well-known SCSI devices, hba, which is at the
> top of a scsi device's parent chain, shall not be resumed, then unexpecte=
d
> error would happen.
>=20
> This change enables block layer RPM for the well-known SCSI devices, so
> that block layer can handle RPM for the well-known SCSI devices just like
> for the general SCSI devices.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
