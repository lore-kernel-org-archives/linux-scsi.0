Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9C9CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DE6C2087E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:09:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ub/lTWZR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bOPHCDfv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJ3LJV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:09:21 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37367 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfJ3LJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 07:09:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572433821; x=1603969821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oyFv4rvJG1bYiLS7umy7qO9zjKpiioFSGN1JxG19pMc=;
  b=Ub/lTWZRiX6ODF77PCJPXedTrGeu6TBARrS1UZktBssp/G0O0VAiZ2EG
   JawiWQREJhRrDJliEaDH3ksPzJGwR+Cz8LM7G9aV0kDXD/svSl/TFLcOU
   B5ssNIGSlopMc0hgDUPXXu/S5hFJJo7+trZTYB34Npi3qrmguo8TtY7rP
   mzJ75P8cfxvadmIUFz/PQ0cptzGLRZlpS2HdMqTtvFz5Ut0Rh+bgV9ayW
   46Wn1fkGZDFhtOFroy4pwt4ZSmvqEKaEB8OeybQrZcJGVfK8dFDjpTJyd
   5Dzq52g9UoK7bUJFinavX0u/emyshMXBTKQFZKPdtD2U7rCS8u7ZTGCAs
   A==;
IronPort-SDR: PwY8W33nRuyqLb2mVgQWWsEWVQvzx3uI8xRqUUaWFZMr7PWkCcHI0RiZCTgS+DjbEEbwet5Adi
 BehfY1lSdHssKGMYypYBJjPvL6iIzcUupCE2rK+xCmm5XBqSjGHJ0hRBi0YKWz8gLzUynevbpa
 7mBCRjHyfq5FBq58zpR/58nfr1qe3mdv/FZOA+5RypcYCREsXO2j8QTEzVILBX7ntSkYCNCXOO
 ex3l/b9DZV/paLx+S+tNU5K5nM6K3UVte9rr7PHEez1rMhg/52FO7IoaD0wNaYwkfeq+bcr7+b
 vqo=
X-IronPort-AV: E=Sophos;i="5.68,247,1569254400"; 
   d="scan'208";a="222818633"
Received: from mail-sn1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.54])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2019 19:10:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTn+ltL3TQzFT0Nmjtun5cdmMhRRc6Djsq/oXzNUTjqqAU8BBcAQ09x40X8ujQ5/kHfHUGbqiVHGCLsu0uJL0HXJceuIR0D08I1outXdV2THwriQcP0c4OCkKGVtnMvS/zcFH/37CE5jLWx94d5puqcIx0hifLECpfa+QR4rCneKQZ7mAl0NJBo6VqK7xVKR4OC2btKYPH/RyWl9n/ewu7bgBNqPKtKpsZpGd0GYT+juadBIL9aoVN4PlofakizTcdC9xXjkWYsK6owJsajOBRvpFEjczdAAFk6wFKzI9tAt9A0HsBdTcQJkM/ri/06zG5I3j/LpVgVTIcirNVyzAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyFv4rvJG1bYiLS7umy7qO9zjKpiioFSGN1JxG19pMc=;
 b=itN9CE/hXPo3mMJExaQ+wQc2fRDIqw8t9B/ZfBVQInkZJ5JY7TcG9R5RYDy6GmMMSmPVEHtm5gQsuE5vP/UTyZ7FoIpOVe8soPiAX5rXF7c9BZHBirMfekOWb9LM0QDFbC/BvO4QWEO6CQh+E9toFhPFeHtQYC87ge7JUbOCBEh8DBTVdQVXYHMYgtawje+yXjWEVPsthbB0tAqCGbPnY6no2103+WdMBalWDwxKYcLdpCzevYLTOU4sLHkaC7kZ+17rJCUUi2ei3nbB/M3zxzREINzo7CncKTo1UUYCm5LGCw/Llgoaf5XGOnQ+qqxRQdTsWQ31r6+AsyX051WxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyFv4rvJG1bYiLS7umy7qO9zjKpiioFSGN1JxG19pMc=;
 b=bOPHCDfv0hxJxIHnYHJcEdbBsusK8ESMKXyzqBmX2+64xB5TSrZ9Y6bF+2YGKncsx9Ltid2BTpmxfTeMr0lRfki1PtkCxmAQALC+YE818Pe2Y5MRo8A+vjBQpEAahzSMsZuKaQQCnLlnlgfu5y8Yma8gkFYrOyzMJieAutHA/54=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5855.namprd04.prod.outlook.com (20.179.23.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 11:09:17 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 11:09:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Pedro Sousa' <pedrom.sousa@synopsys.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
CC:     "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Evan Green' <evgreen@chromium.org>,
        'Stanley Chu' <stanley.chu@mediatek.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH v1] scsi: ufs: delete redundant function
 ufshcd_def_desc_sizes()
Thread-Topic: [PATCH v1] scsi: ufs: delete redundant function
 ufshcd_def_desc_sizes()
Thread-Index: AdWOYNFUHmkvcAl2Q/qT6qb+uQ79WAAsYcCA
Date:   Wed, 30 Oct 2019 11:09:17 +0000
Message-ID: <MN2PR04MB699186FEAB9E731C0869374DFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
In-Reply-To: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a742f65d-26f4-4b01-557d-08d75d299b1f
x-ms-traffictypediagnostic: MN2PR04MB5855:
x-microsoft-antispam-prvs: <MN2PR04MB5855CE57CC89F17F1AC87BA1FC600@MN2PR04MB5855.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(199004)(189003)(486006)(6506007)(55016002)(25786009)(26005)(14454004)(102836004)(2906002)(229853002)(52536014)(478600001)(74316002)(8676002)(476003)(54906003)(9686003)(81156014)(186003)(256004)(7736002)(3846002)(6116002)(76176011)(66446008)(64756008)(66556008)(66476007)(305945005)(6436002)(86362001)(7696005)(76116006)(7416002)(110136005)(316002)(8936002)(66946007)(71190400001)(5660300002)(81166006)(33656002)(99286004)(11346002)(66066001)(446003)(6246003)(4326008)(71200400001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5855;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uSpyu6KibGE4yorTfXT80ozSXa/mV3HkssgHxaajFLvUXhPqB/h5gTVZPkHFvzDPHnCqB1o81/6rpmBSYLFn74jR470DpKCfJ2AY8aSADJxhD/808TFJ48fkYzsAsJM+560g2XCSejI6Y0k8OnL3FWnfbwvPuca8QkWjhZhK145/Y8UW/Y3KKEPRKrsa7eQAQX1W1WoH4Hsv/34Ow2wuJJKx7r42m2lF/pZPk6Ge103cnKZ/3y7CO66Ou5Mc6mivDwqBPRynHl1p9b6/TR1ykJcf9WTyO8pKUJHqQhmplvn2ktMv4lOTwok/7ipLZ2qWEYLARoVi7HXn/rtXgBKwOrL7EbXyc/9h7iAZsfP+wdadUptyi5yzlT5+pN9PG/Bvk24CHlpsFpjOx2Ogy5jKfLsLdJZ8PK7iuK7PlYyxxr0kAMXn8ZNaVzLAZfMFW+Ud
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a742f65d-26f4-4b01-557d-08d75d299b1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 11:09:17.2623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VIi5aB4sFbrpGtrwEVdAUZHej8ThAvMQM2wmUsmFp4Pt1uZrM1MAXaUEkk+RQwAwvc1aEOQfQIADJm22/G2PwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5855
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> There is no need to call ufshcd_def_desc_sizes() in ufshcd_init(), since
> descriptor lengths will be checked and initialized later in
> ufshcd_init_desc_sizes().
>=20
> Fixes: a4b0e8a4e92b1b(scsi: ufs: Factor out ufshcd_read_desc_param)
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman.wdc.com>
