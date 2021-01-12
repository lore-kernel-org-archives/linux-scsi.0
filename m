Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4753C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 21:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940C923122
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 21:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438092AbhALVhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:37:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28918 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436939AbhALU3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 15:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610483386; x=1642019386;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2kUBsFjt2v15A9SR1//l83nSAtyN/KoEDs5RZXakUA0=;
  b=KafohG4CIRGGNhdKwI4CICXppmVvivMboi+j2LZrg204FaAnfXiMA+jF
   odGEYkmBqrjNV25yIwrcP635OARpUr7xdMmXOtduO/OIp/d9aHz8+CdWA
   dUEYFn4zrOGNuUh3e2otJlR6T1LQutXv+Z86b481Elosqr6pFXwRQMvro
   wADlzraaorcibvosGC9ITJO1Ef5t+LrmJKDSNDkseVKf3Bmir8TDbluGI
   N3sWQZl4GTtaiRfWVxxeGy6Eog8te3+XnH2gtvmcbtXaHo1LCGT6hQy2t
   OXXJaSSFpTfh/TYMEQ3j109/4U00dOfB06pJoZEhp7ZTHV4NcZo8FNd5R
   g==;
IronPort-SDR: wosV7lSJDtnyTnLXJNiNLjGo6x9p/hWtKR3EfjXY425tOHaJHOF6vjeYBHL7d4y8mblraHPl10
 MAH9EOxqRUZM7N3VbFf5Rqf7D+pFR2c4jFD/eam00F1/JoTzsuUR+D1NMdCNbTMjVZU3A2Nc5+
 z0bTF1l3qatdlZbqvp3nFGbLO61spIS7RS5jXq9CXZOnCFhBPsUSMh1DJs5xSxo7IM8btvW2Zs
 yMYZ0iQyLoZhZdBHDmJ6gFKPWk1SgwKVK3WTexg6aJG44IENVV8e1TfXOtPp7f2bSNy935QTdH
 XjI=
X-IronPort-AV: E=Sophos;i="5.79,342,1602572400"; 
   d="scan'208";a="105197711"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2021 13:28:31 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 13:28:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 12 Jan 2021 13:28:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bX7tETxKrj/vwTX/yobscFPSdIXaX/U+wXGVF9ZHBIDm7K8VEq+Fd2uzk2FF8lq7D9whwyLJj4z4ai3eHV6m2d/tKZ6ZGupdr8p7lP4M4pPldk8qNVKd75X/ChioCJbQLVudSAPy/wCUR3YB3vaDWX8fcAVbs9jOcCsvkS+qcmrMc5r/jvLsj7Cd4UAUJ1UwUTVTtSQ0HcAW4egwAKy1qArDEIIlNbqrqsjTVt7DDjO/WVHTL+SQ8lxaqvCVvV0qsLaC0igUv/ftp4OlEzW9TFik00RbIPSTfTnb8Hmzso7J9ZZgmRsCFYUIMs0YUDy+sDwsrK5zVGinMKTRuTIzZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kUBsFjt2v15A9SR1//l83nSAtyN/KoEDs5RZXakUA0=;
 b=Hgc+IkhK8Ts4NYCgTS++Kxxi+wx8OG75ZQ2X7s9Y6GdFqJ3EZVccTsKqIBbS3AVCkmsYHu95Bj/cMPbclZgUy0gifxxJNRinpn1U9FY7kiYirapD5O8j+kTCTe63m0i+e9dhyjU1yE8cK4eMOfwtE251SkbRWX0qr/GatcmYVJ2Ly0P0ITMX3ZK5T5jdVIh3Q21j8m1AcxI2l/kd6NdEd5tBz3KRyDeHPgweBDW54S/+2erAuxHQq5KzRUpSBV9SBC8FEN7/4Ov983z4nW1tRP7ggjVf6UivuHUYnwlMoO9CrLqIew0V6g8UTtj/DCx1TIVn3JtG9zyqAFMnMb0fZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kUBsFjt2v15A9SR1//l83nSAtyN/KoEDs5RZXakUA0=;
 b=KbRF8OB0tT6gtw2sdUh4QAyN+btvnPSffsGJOwuuu1XELDf2LtRHq3Zdmeq0UH1h8l96IeyNPuMeJP9cugrdg4hCXWT1P3NJYtYkrZok48qLkukLHI+KPW76kPr86JT1yDIQotCGgyV2wDns0PC8kboAhxQjr84TxxeTihZU2kA=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4922.namprd11.prod.outlook.com (2603:10b6:806:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 20:28:26 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 20:28:26 +0000
From:   <Don.Brace@microchip.com>
To:     <mwilck@suse.com>, <Kevin.Barnett@microchip.com>,
        <Scott.Teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <Scott.Benesh@microchip.com>, <Gerry.Morong@microchip.com>,
        <Mahesh.Rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH V3 11/25] smartpqi: add host level stream detection enable
Thread-Topic: [PATCH V3 11/25] smartpqi: add host level stream detection
 enable
Thread-Index: AQHWzzSpgFifm2VufU69hB9kZ0+hAaodB9WAgAecV1A=
Date:   Tue, 12 Jan 2021 20:28:26 +0000
Message-ID: <SN6PR11MB28487FBD31C5348DCCBE4D44E1AA0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763252438.26927.15696823365021360866.stgit@brunhilda>
 <22b679e6047892a385b9991bfae4d9dda67a3259.camel@suse.com>
In-Reply-To: <22b679e6047892a385b9991bfae4d9dda67a3259.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91a3d75d-2ac5-45df-1d5b-08d8b7389dd1
x-ms-traffictypediagnostic: SA2PR11MB4922:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB49223BCFAA814E18DD0FDDADE1AA0@SA2PR11MB4922.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vum1oNmS9guyJM8VbmhBcR8kUoeoJAezXwR9LvmBp9llZ93rZ31kHHft3SlfYICQDKjls/ZsL3qqeVvD4JK/gZ4IBxzZlQqV6bY6Z8UwricKUPvEDJEDwfTRpB0Rumh6lIZnxIQsSrOMF1tPsYx/KU7YG5aFE/uJpkAP0wH8+6w8iD0tLUs538ttDiaRS+Tr0tw2LIFUWIH1B/jiIfFJCY0LWZT4HpKmooxaS6EjdJxvvDVc958CJujlTWb6K5sFG0dHB/yYgwn9sV9pjGQAAj7INKO7maN59neBx4CJ0z0R0rGV5GrrbwnOIWiJyf4xlRPCytccGvwu1DTWACxTvnGmzdJXzth5ecvpczHpYcWKfvKuGr+aWazsfoaGVXBXTt/PP7c8AKVccUzn5uTqH36QVYY++G+2uTg9SuJKMs7oCcIo0gA1RQfW1vsamEHF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(366004)(346002)(2906002)(66946007)(55016002)(7696005)(316002)(8676002)(4326008)(921005)(26005)(64756008)(6506007)(71200400001)(110136005)(478600001)(8936002)(186003)(83380400001)(5660300002)(52536014)(33656002)(86362001)(66556008)(76116006)(9686003)(558084003)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wrBeVlhdG+lSDeYe/wAwMOXNkgYw16gRuc9iTfEitpQFq8MjCRAHQgGthPWh?=
 =?us-ascii?Q?yG3CA7WnWCZGDivDlSzTf40jwPZkBnkxzWZeCrRVeVakZgmdfU9twKKyXLJ9?=
 =?us-ascii?Q?/qCOs3eFl2mwsFW5G8CPhnD5DUGheYIqEqpQ6Hdi0TDiGOnL20MjLxCn6k0r?=
 =?us-ascii?Q?PFQF/H3tO60te5zlmzAbNPEXJDFJwEzToFmXnn/RrggFPf/OMKpc5kXcSsWH?=
 =?us-ascii?Q?GNakAfFhD6AcsKsxR6j2xXf8Jl0iVB6wiad95855lyBs3v8RQKtrIohx7Urt?=
 =?us-ascii?Q?rWlBeYo2Mv2ccYfLUiLXItYmuLhkYrx0XIfrvvkW7nIjvOoTk4W04u4t+IMO?=
 =?us-ascii?Q?wJT4JqncQL7Bm2FfXsd7wCK4EfpJaLOwbTcnFvX94BTv/LZC4RY+5Zj//xnk?=
 =?us-ascii?Q?51R9Lue0Rj/2ekOI6ZZQ3K/yZ3bGLC9uYadjM0FO0+h4DoTyoWc8VdZa0QRK?=
 =?us-ascii?Q?RYt29Sd3IEz9GcJX6BQY/DYWeP3FrQ4op7vJq648RnuLyD/4FjOtO4H14R3r?=
 =?us-ascii?Q?zoPi1ec7u31xlov9wcsNkX/FigdMB3ZVxhGAP10mC8j+KDtgklqnWai4Td7/?=
 =?us-ascii?Q?Z6qnTBLtSZeIOaC3Iq9BNNRfWAXpBT9FS/hHbnHn4wWA57SakMvIixCv9F48?=
 =?us-ascii?Q?wW4IKRDfRGYMGcWb9rPjMcHVFb03CeT4A6NlPrdYhidxci+i8Fk6tptZRQTb?=
 =?us-ascii?Q?vsiAy8d7HpYx2Z8AP31TT5NSUuS6HySTd8LKHVL5F1Rcn6ND4U2nkqB2t6Mg?=
 =?us-ascii?Q?f/cR87JrRMo5Fiwgas9lvw78rtH1ubBq370cw7j6jdyery2NvdgcJsgDIDsU?=
 =?us-ascii?Q?FuDa4uMWhIc8jWGWkx4pCbZQUJUa9dcIpxs72ym3utB/IFQZaVWBiFJkQZBV?=
 =?us-ascii?Q?9rB6jz7TYy8yDp5mYCMnBs/qaTkq+wtvm99jmRAFlsaD4iLFrZAh2HRFuWvh?=
 =?us-ascii?Q?iZWWvmaVs0DsvAG6EuiX/O4bLyGbhc7pGjlpwEUBbwA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a3d75d-2ac5-45df-1d5b-08d8b7389dd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 20:28:26.4875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FteDwgunid4mCBq2G4rvHmoNaReUAVh9rhCqPTpnQd0zdhkg/M6NsKd8OajhSgGQ4B8+rru9oUBCoRH5fIM9FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4922
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


From: Martin Wilck [mailto:mwilck@suse.com]=20
Subject: Re: [PATCH V3 11/25] smartpqi: add host level stream detection ena=
ble


Nitpick: As noted before, %hhx is discouraged.

Regards,
Martin

Don: Changed to %x
Thanks for your hard work.
Don

