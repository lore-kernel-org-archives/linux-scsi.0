Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C44AC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 04:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5696A610F8
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 04:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhDBE6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 00:58:38 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61111 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhDBE6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 00:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617339516; x=1648875516;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B5kueMAlnr5gkmqDNN7RqUft/fkWsT0vhzwb5LEo65A=;
  b=U3n9Kim2n6w2jqFMluptr8R3PM8wdK2E0mgrvSp2ZbgZ4DYEjyhgAQtg
   G4XBaNv5fUDhRd0t4Saqp5+kMuPoGKhLHzM8ZinvGE5NiAP5jCSrfCEQF
   vmFz6PODx9rLfdO4+ZWfEpVcho3lfk28MOsHTnGqlXmW44/4ziA12qlUl
   1VQjqbexo2bmoKfZ97dfF3/uSD3e0O+tuIrqiQnVSKVkdye2jzJgpZt1W
   g3ZoGM906KvD9hdNm/p4h9rPXmc0ynVa+6VLHnXzikrbVLHLxyfwO+3Fv
   yJQDxyZ9ich2g1yh9Eot0Klws2xGE9zXjSR886ZJxaKdqfP+UjAzmZFs4
   g==;
IronPort-SDR: VM2IsmE1dRZfw3MWzEndmxn7DBYxC4aYecDw1gSFoaNHeAPAhdleQpWbpFEwjhMO3Ls0HtT6cF
 oMgp4BGeX7tgl/5Eb9eB97cTzKdf/dsOq8+z0cbggE8B0i+VNKOEPT8S2NZVRO/SXmBXg1EgFD
 QM9YU8td5tK/O26A6w95+53wmNXpF219tLUD9u8XBQXnTfuClMI1XqqeolpcQc2JeVYxHi2mza
 XkBuASX/NXu2O3Fu2HAj4Fsjah4y/XpbJA4BYyxUmGj1hIdn1inuOa0KkBV5LLeMC86IZ9JCXO
 9Rg=
X-IronPort-AV: E=Sophos;i="5.81,298,1610434800"; 
   d="scan'208";a="109439360"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2021 21:58:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Apr 2021 21:58:36 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Thu, 1 Apr 2021 21:58:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hbe/VF3tNRrihKCTEWdbyYR+BGo3A2ejKxa9iBOIMeQa83Kke8SUQ/6M9TUyMzqjufwL96NC6D486IE1uw/MG4yUIYf6vmywTwhbzhw58KBccNbaoaxl0AqetqktJlg07INv0lKcVWRNohRIkNQeeYJGrE3mRj4LNbARyPDMBmVnRXdOh1G354dNN4HtuX3dHYmidnCOpVu2N9dWAYiT3dd2TYcqTc0aTv3WER/ExvTQDdt2jsNu6NXXcvCPw2AwjlfNh/XKrl+FDSmFy6xbaz76wG/0Y624Xe0IU7FJf4ElH2/5dXXKTmfdNQ8sQXzeZV1WV4Q5ZqMFV4fdFyQIKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdUxSYNrDqAIXPwGbR18iZ4Z0gqV3xODJvZJQHkuyUA=;
 b=L98M41ARH4r+xo54Udx4srMUXtEs255dlzgB4eMjP7lbViZRu3w7qgpIicrh16/yy46TrEdCFmVCRVUVS+bf17RrObdPBgh3ueRlVRzNTPI3SYqF7avrDGnrV0ZM5yfw7pycoK6Ml69mYOn7PueghWxfBqmx81mcwdTnSYWxuNfxeECFPIR54BoetE6UPWLuskAuYPuhurO5WTi9lAVrScQOMeqawdwoWG3pKF71utEHnyvBnLXZ8KSXuQdXOJrKqVs2MvHtI8LLsVaR3l+oS9BKSuDMydJDm94vR3hImRP1XK/H0pIt2Rwq7FvPjAhLmu2pqDs3yjNjmaQcdMmClg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdUxSYNrDqAIXPwGbR18iZ4Z0gqV3xODJvZJQHkuyUA=;
 b=upXomWfW/Kwr2BYUUPDmAzX4tjM4hM5uH1iOFVkMYjmNfOZNxww3rilS6rz4Lm2xjgTN/NMIfarRbBXcbOWJFohzt3B8c+sZS05TuOexZ2V5Bs4GgWPi1OHdNxQBj20PlYlb8CIHfNKlb0GZQkGmTLZFqcbgVD8PqRy8T4Gw+04=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB3389.namprd11.prod.outlook.com (2603:10b6:805:c8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 04:58:33 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::15ba:4e34:c20c:8cec]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::15ba:4e34:c20c:8cec%7]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 04:58:33 +0000
From:   <Viswas.G@microchip.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Ruksar.devadi@microchip.com>, <vishakhavc@google.com>,
        <radha@google.com>, <jinpu.wang@cloud.ionos.com>,
        <Ashokkumar.N@microchip.com>, <john.garry@huawei.com>
Subject: RE: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
Thread-Topic: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
Thread-Index: AQHXJS44krViESL7WU20hDLaDALwHKqglAmNgAAaTwA=
Date:   Fri, 2 Apr 2021 04:58:33 +0000
Message-ID: <SN6PR11MB3488C8DDDA4F1C6F241691E99D7A9@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
        <20210330064008.9666-2-Viswas.G@microchip.com>
 <yq14kgpfk6o.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq14kgpfk6o.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [103.151.188.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0118a1d-c2ac-4af8-2ac8-08d8f593f793
x-ms-traffictypediagnostic: SN6PR11MB3389:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB33895058B39E2D803B36437A9D7A9@SN6PR11MB3389.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n6kAnXOU45ahFGo5mViXRDT7NfT+QxKqQB9Wi8GfP/rUHmR4yrSmBJdyb/J5da3ryYGlG0uaxV7v0XDmgMnaZwy83jVUzsxi3q3R1ajnwgvV23ARHS+ypHc1Z57QOBdPPIjm6bIv9r8rwXstIarHBdnM3tFEU9YUpa52GX05DlBsEc4WclOD/zZDT4LHp7qSoF64wHN7tVi36cOSlMORGCCbGcWE7AH2h69yMfcixXruD78NYh2rxP0P+zR40eG9uYUA+HzsXpedDylddB+/Aewt5k6tJHRWARE/14yHt5VYvh4E30fLbkCJPzvpID23Mc0SKObCV04LJiFwlB12GFrOUC+4Gaw2bQuqat2AwcJ57duUgSkkC1Jhyv4mRqkLu39hD70JlT7TyBz1EusI/00FnfBwR2mhmMHw8+1aw/nJ2uPzhfXqJQR6tKAH5aOmClJS3n5bYP8/rOmPTFLYA3EPT4hUVN1ybuePt6wGnhG6weYejpOcf5Znh12WOSK1yyQsWwg45sA0wWnsgG8eCD66IeqkO0a7zJJf38F2geIvcbM0LuTdOYxAppY8yBl0KpyOr4MaVuRg1y4hHnaLxXk2vYoQBUdzqVI5YebHCVmoaHUFuDIMLNfFGbWML0REQ797L/y3Ko0fF8n7JJqwGTBoqoHWkDEiXdTwfH9Q+/g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39860400002)(52536014)(8676002)(8936002)(186003)(54906003)(71200400001)(55016002)(7696005)(33656002)(9686003)(83380400001)(6916009)(26005)(2906002)(316002)(478600001)(4326008)(38100700001)(66556008)(66446008)(64756008)(66476007)(6506007)(53546011)(86362001)(76116006)(66946007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Db0bKsM94V033Bcjy38B37PxmgE9s43KkoHVIc30C6hX9Oh1y8Yvyo/czAsP?=
 =?us-ascii?Q?cx0q8uBTOY4yACXTNq6hCz28K8KKenljcSZfI8GUv9yivfEp/eND0iJOJJvy?=
 =?us-ascii?Q?calZsIpgMfelkFR9zfGJVwXb+92c4U+ry3Uy2zESsrlLrss7wjZkBbKMC9CU?=
 =?us-ascii?Q?JC/mYoa261QGTy/7Pz+RNfiyx7J1J1gziQBYaT++/Yr9izpRmUgbCOdCTiKc?=
 =?us-ascii?Q?d9vfPBPcn9tpvPAoHjoKvHFPFFEihahCmiz3jQii0xLZF/OUyJSx1aurPITH?=
 =?us-ascii?Q?ba6lPWTNxVmK77nQtaUS2tpWo5jM/uHZF5/z1qnltBT1zhtaTe8phjQAolKm?=
 =?us-ascii?Q?IIcTlFC9uevnPrBwgkbXjh9f8U/Vd096lEZLV089sRD3T3/EIrC7fkUm/7/3?=
 =?us-ascii?Q?boufAxs2xjbpv99SXglR2xdhSxf7OPI8ZFCl0wRrF2EZstV/V3LOgjP+RqhL?=
 =?us-ascii?Q?ALl7uYcnKgMYECos4OhBW6G5w5F/QvKqW4rsLGNq0OchZGVWEkNj8IAK7lLQ?=
 =?us-ascii?Q?b+jUu1puQtEE1gIxe5YAjzCQZQ4v39zQqMazalZTpDq00NOu3fRwR3zG9m8R?=
 =?us-ascii?Q?6vL/u1nsXmGW81rxS2WgW/bSY2HOnnrnJviXS+NPqXZH81lFnzdWq7kIy3NJ?=
 =?us-ascii?Q?FQNWg/rVV5olj7ojwRaRCIMk/fdXLWsrObLGPwx0uU6GO8pAzUrOPBTpsN0z?=
 =?us-ascii?Q?80jBGOtcWFHgbZAp40hUeL8Um4lQuRmHmum1T7zQ0cFEE8BZcQypG9zgWSqo?=
 =?us-ascii?Q?FWoKTf+FHWVMN53fbHklMNVrEZMwzkjO1haltJNhiSLfGAU3XN1OqeofZn9/?=
 =?us-ascii?Q?l+Yec13r24j4ByaAysePRpaSIverqb/gJOWEKH/OKav0zt7bcFyjJfVkNg2y?=
 =?us-ascii?Q?jDwufDHNi6vXvkQBevC/Ma1uOExkFM+ReLC+852m+HRRT3unW/LgwZwnThkk?=
 =?us-ascii?Q?aBTSYkMSCJoxFWT/hnz6AMMPb9+GhRTKz74mX4ZWGN+l9JJg7FIHwIYMOMvF?=
 =?us-ascii?Q?tX72cMZI90u+KcX0B6/AcfgBuZISCQGXJEoUIWQXPJ+xE0GEPpqMDNfrwQhi?=
 =?us-ascii?Q?ulIWAxdyETgVsy67ekG4VeP5tH8tqoXA1rvy+Nr+LtI7B/DZ73eY/Sa4UnxG?=
 =?us-ascii?Q?vzDQoj6GbJcrDGnX7Y37bOeVPSt+btV6vBblWHpFZZ91wpMV6jXNrmbWK2Lq?=
 =?us-ascii?Q?mFdgdAWJyitJfnso2pe+KAZqP+NHH4X5HR+SP7AQj06JF4WkCyWfnBhWNDsg?=
 =?us-ascii?Q?pN/UlM53w8Eg/v+wfdGooqZ078fpFrw83x9SxEE/FZNqkn2QYf04Yjc90Ovr?=
 =?us-ascii?Q?lOtWGIoJ8iHmdVytltCasx/U?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0118a1d-c2ac-4af8-2ac8-08d8f593f793
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2021 04:58:33.3810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUtLTjMASW1ZQV2hhu1ueTqH91jzpR0FbQNOQ77LIC3W8tXX6xcDpCFrE7eCOGx9RSMXUYxyGHk9o/CoWpIk5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3389
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

HMI_ERR gives the error details if the MPI initialization fails. Do we stil=
l need to spilt this ? Please advise.

Regards,
Viswas G

> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Friday, April 2, 2021 8:50 AM
> To: Viswas G - I30667 <Viswas.G@microchip.com>
> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664
> <Vasanthalakshmi.Tharmarajan@microchip.com>; Ruksar Devadi - I52327
> <Ruksar.devadi@microchip.com>; vishakhavc@google.com;
> radha@google.com; jinpu.wang@cloud.ionos.com; Ashokkumar N - X53535
> <Ashokkumar.N@microchip.com>; John Garry <john.garry@huawei.com>
> Subject: Re: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi stat=
e
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> Viswas,
>=20
> > A new sysfs variable 'ctl_mpi_state' is being introduced to check the
> > state of mpi.
> >
> > Tested: Using 'ctl_mpi_state' sysfs variable we check the mpi state
> > mvae14:~# cat /sys/class/scsi_host/host*/ctl_mpi_state
> > MPI-S=3DMPI is successfully initialized   HMI_ERR=3D0
> > MPI-S=3DMPI is successfully initialized   HMI_ERR=3D0
>=20
> This should be split in two. Only one value per file in sysfs.
>=20
> Thanks!
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
