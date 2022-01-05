Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9CCC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 09:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbiAEJ2k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 04:28:40 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:9667 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiAEJ2k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 04:28:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1641374918; x=1672910918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AnoBohTEA2HRCVccPCXGX0kVcbqjDanecbmwPqIdeIw=;
  b=ZIJt726T86yOcXpEOhqppSPcXGmAhitpyXVdGlIBNkkRjkQmrOvXfFo8
   /43aaExZ3p4IsEc5GahNkQsd9RxRilU58BQTdQsTiP2josWE6H0wddPEI
   a2Nc3E8G9jZ1W9uYI0hSNiR25LwXkxNEtOPcG0j6zVBy6pmcJ/9n+96AC
   japts9Cq3OqxDlDleR6qvyZKXmsAtFFKTWuZBNVIf5HwvlTqkigj4FcZq
   avvupT++rIcoDC3b5Qjr/AUcHoZnAUL6OYtxmk5rHMMKsB5r0jLDZ1wcm
   iQ62pqgWqBJo9pVnx9XmFIdtfza1/XCprRC2PhMVy3k9QEg3WE4iCFE1K
   g==;
X-IronPort-AV: E=Sophos;i="5.88,263,1635177600"; 
   d="scan'208";a="194536152"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jan 2022 17:28:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBzPTkHmLx2Mhta2LZELcF8rCHEPWsOawPpJHnvSHT0RZ0+mWrQuSIgTPE/7NNyAquCPYVMytvf9hBIqZaIobXmXoaPDjo8FHFFA30OkofQK3kW2++lECHNOWnVuaibCZe/kQrvR8HFhWmsr1zCsPi3w55NakpqoQI4LVlXwlybxenrmJkjyNfFdAHnZOo2zT222x2ZwHGweuB4GYDTGBvXZyU2kem5dWwAt4pxZ0pWld3KQy7BDwPN+QVqCNCXsk0yCecztkH28I7RfSUClLsMnZPtg+OH7nN0A8v8yhqnXVMw3BFZp6rCA9Xun5gsEs4I1y3tB3khn/Hmo6raSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnoBohTEA2HRCVccPCXGX0kVcbqjDanecbmwPqIdeIw=;
 b=ILDzAagW4pclLbi4fkVhDL8ntur2dvAs0dHf3S/lf/BoHljhER/8NiUsjEoNcZgsrg1a7tUKaJqRfJPfJSwyz+J8FeEaxsDKu2cnJzJs6ajCeJJwXRvmqGTfwSuW7oaSbH42M5681euiSPP61csJRCixAqS4PbpGcjuwR5isTtCTtNYmBqGeBSt631rrGSJGo71kl2W+HaAAEHj9IQVksH9G1eylMoihdEHGMkqirl6xkfsWiixKST8VNvfowdypEb9dnFUcNsUJFoullVJdvxXsvt4a+cJNzMBtcSeYPiDP2mJhr5Tvy/SThH4CbGgRVgm2i6ZM/7P68SsCzOj6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnoBohTEA2HRCVccPCXGX0kVcbqjDanecbmwPqIdeIw=;
 b=Qj9YCRYM2aI3RiDOWjkokdlZU0KliBz/PvdfvI3ekUWXud/WXoKKCnldNrhE1Vbd2ckkJ51AuD36Nr7xf5B3ZjhZfwxLux5AU0rRdewFLWp0TF/h3R9yNfJiwcJYPwTImpSNwdJjMBcItGtmVNUrxwmQ97EB/KE02iaHWmV9yVI=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM8PR04MB7816.namprd04.prod.outlook.com (2603:10b6:8:3a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Wed, 5 Jan 2022 09:28:38 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::51ef:6913:e33f:cfc]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::51ef:6913:e33f:cfc%6]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 09:28:38 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/9] scsi_debug: change store from vmalloc to sgl
Thread-Topic: [PATCH 8/9] scsi_debug: change store from vmalloc to sgl
Thread-Index: AQHYAhaeuDEZqbOKaUiOI3wp0iwxog==
Date:   Wed, 5 Jan 2022 09:28:38 +0000
Message-ID: <20220105092837.q57qfcr2eldjai3f@shindev>
References: <20211231020829.29147-1-dgilbert@interlog.com>
 <20211231020829.29147-9-dgilbert@interlog.com>
In-Reply-To: <20211231020829.29147-9-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b145cd32-5d1d-4c1d-fa22-08d9d02dc134
x-ms-traffictypediagnostic: DM8PR04MB7816:EE_
x-microsoft-antispam-prvs: <DM8PR04MB7816B5BAD80F88FB8BE4C4FCED4B9@DM8PR04MB7816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: blsBvShoy6QcAL8kPwZJeg5UIE1wPX5j2lsGJcH72KgyfH02SrVWRnZ/u2d0tj0wWy+wXAiWpw0eYAPpSUbz8geOSDkblWgOcx42qkOLOFfodOwsv+881a+0ThcFEH3Z7mUsgvCWSch6Gtg2EuNerrh/Utq5rvX4CrD400tSlgzSzGxMvuCoiuTJdi37qAzrji1aM+BEWp/5mrcgnJnPwI56tAfGkBZi4KyW88Ksn085BrIM7IXH9aL7byfGL2bxa2emhIWT+6Jh7hqT473GJZVAoB/HjQ5rbwAQMtlevMbeiGWLzZex3Anp7ilJ2R+1Cmd5kPkF7n1j4fbsIao/mH3byvrArvLldkUEzB29HRLVWnsVZa33H6UF+ecQlKzHI2XXsKyCaG2yxPZdOwZhPs+9gxRU2Hj7VRFMnX4rPmRIUSd/vGqfXYTgU7KXXhJdGS9K3/6UKHp4+YgU7oNYHSXTXtBrskPd/UYg6p9lF4OXXZPY9i49tXbfQjejVBozewq/Ix0Uh4QmRtB3xMY6aBWkmcUgFZTU53Dmyh4QWpg1vqa95yUX4qB/LlFYCF1lWD7xVI/y8+wY1Ha/RVrLAfBc5ct5eTqwoSEYRPVDi++4hgcbgn2DkEwYWrDvD+ksYcQ65m74YdJeUtnfObONBmM6LeMqESRt7N0kLGHV96lIq14sDC8IqIWyCRXGq5zmDLSV1QbvZcfu6VZVV5G9Tg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(508600001)(33716001)(4326008)(8936002)(2906002)(64756008)(26005)(186003)(86362001)(316002)(38100700002)(71200400001)(66446008)(82960400001)(44832011)(6512007)(122000001)(66556008)(1076003)(5660300002)(6486002)(9686003)(83380400001)(6506007)(66946007)(76116006)(54906003)(66476007)(8676002)(91956017)(38070700005)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hbZTUFl6l9dMp3+XAnp/8/XyEoMdkSwwYduYJ2xzsIPXkUmAKmxOw9OCPGzv?=
 =?us-ascii?Q?nrPGvJZkR/fg0sjz0n+vyuRTLAPnMJWvsUc4f7e4YxkVoeLEI+zejDOIe7yq?=
 =?us-ascii?Q?VYgGllSL86MK9S782Fae5kNXEKAOaFrCkAXAreTWAM34TULhilQhGDOTwxwH?=
 =?us-ascii?Q?vOqoFVdtsaSiprBjz7Ygm9ZcnT1arNP/KIkt4CL9NnWscRZc6dCcAy5WOeR1?=
 =?us-ascii?Q?JrSUVqferqRYJLprkSWZkdBEx1//RBd5KfPTQ6IEzMayTHjtwi3IlvmkJPKB?=
 =?us-ascii?Q?6suE3CltZY1rvkIRHI2wO6+hnOuW1dmBVKcUPUy3+R2VYTGFZlqvcxSbY8UQ?=
 =?us-ascii?Q?Bo5yO3lRw716kkXGkB1a4Dpmvk7ZZVh3Q5H8kVT6ZGb7BQcWrvmWyl8/GE3m?=
 =?us-ascii?Q?tgwusa+MauKTk1pjyXgdmtDIlVc5RNbYJ76kCRCOUXmkH9xuPSvfLn+50TWJ?=
 =?us-ascii?Q?n1hUMkU8k8rCXLa4tSXkik/pJ/caSVoK4/CEoQ+IzJxWBYvNJfD7uPdedY7R?=
 =?us-ascii?Q?mvFpOiJ1CZhQuV/v58cHZEZpODbTR956mMFplQzkfUPRyrj7OsySnd9yYM5z?=
 =?us-ascii?Q?U00jncPYifVtwa8tBgDl/bXBx61ilTk67rx6EYVaqDQRVDjO1FjGj2dCe1Ce?=
 =?us-ascii?Q?SDiY4OTanSwlP+yH4OkzMUKyVejnH98CikCIEYz5278cxG1aI37FKvecXUWZ?=
 =?us-ascii?Q?zFMidibP7dEfrohmiXqe/Ys9WMLzl+PdjV+z4hWf1OGDmDWvrSBQUJX+eFbL?=
 =?us-ascii?Q?9SaZ0hQDH+kaK1TEH9aYiG+CNA4vXHacOynb9kNyIygswAtkT8tInhHpKsDE?=
 =?us-ascii?Q?oNAX1+IGc6rFEF/l18PE+UwYfpdGOYgc7mzXm7jSORrltM2oZNmuC/QHOyBz?=
 =?us-ascii?Q?i/MeTQuaK1QXAoms2eIEfaj/bqb6qddst8JT/3IiFN+PIOVCaAiWiddfMnDM?=
 =?us-ascii?Q?2fjtdttKBkm/+CkPNtueO9B9NBa7icDSyHJt+Y/PfpqUSq74hNvigZp5bpqo?=
 =?us-ascii?Q?C+d0t2wRlUNNmF0mTe18gP4Sb9em8npTfn/GclL2tv8EFnh5NEl8t4Qv9JNh?=
 =?us-ascii?Q?D08Zj0xAhqMZEALEOXSgIHZjmReg5btQ/4ZfRI+/3yxcXqjQnA9vDXjY+IBe?=
 =?us-ascii?Q?WdY5bOXfTl6VSHMVgi933YMo2HPwSyJxB6sjAMIWqB12aWwYFqq/7x7R6Kyr?=
 =?us-ascii?Q?k2v9Nd+ZF+i9lOEevHW9OiBS0YTVvllj5zIymLpfs0Uy5f/m8tQzfKIo2e1Q?=
 =?us-ascii?Q?NgwwhC/aWNLfVgCd4NEFMY4dApb4Q91AIAeYNbtvU0A+I3/b8RS2JGvgFvCo?=
 =?us-ascii?Q?jDjAB4yDQP8jzdSieqFUhgp6wSZ3pIkLJp6JosKSt2lByZR4O7p312NuK27B?=
 =?us-ascii?Q?JFClt2nQfLncfEQ4U073grzvdFM59EQL4sNdtkI+oWIcv/eXirQHpt4oMIRh?=
 =?us-ascii?Q?8eHXvzaA18bO/BkfLPsrayWdDmkKxptdcHw0DGtlDJv1zxTGCBKlV3LgAL4N?=
 =?us-ascii?Q?yWRM+Bh08d3d+f8VSVV+UJcZ63X1xTfs2Ci5BVV73ogst4iO3L1cRGiticmy?=
 =?us-ascii?Q?vMseCzd4TZZBEf4Km3Kg+ODO8fZNvrTJJ7tkFJifwvcVEEtCZAkUwwPMrKjA?=
 =?us-ascii?Q?4foqtIsY9FMyR7572RdyI15N77twyrP/bil+Kgo5ogFqQdfNjk6kqWjSMQBF?=
 =?us-ascii?Q?CNxnvDliue9TEQVKalxgQOpTYok=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8908989E0F546C47B0F05A6C4B8C63BB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b145cd32-5d1d-4c1d-fa22-08d9d02dc134
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 09:28:38.2278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aSyLyKtfIqMgQq19LQMKcK5p6w6RKLmb3CRwHa+IXsox7q+Pt8a3UkY3qhgpYkn+MlNtx3M7AYzDmJurD/8pACsKwTfjJwV/u8lGh4OrJ7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7816
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Dec 30, 2021 / 21:08, Douglas Gilbert wrote:
> A long time ago this driver's store was allocated by kmalloc() or
> alloc_pages(). When this was switched to vmalloc() the author
> noticed slower ramdisk access times and more variability in repeated
> tests. So try going back with sgl_alloc_order() to get uniformly
> sized allocations in a sometimes large scatter gather _array_. That
> array is the basis of maintaining O(1) access to the store.
>=20
> Using sgl_alloc_order() and friends requires CONFIG_SGL_ALLOC
> so add a 'select' to the Kconfig file.
>=20
> Remove kcalloc() in resp_verify() as sgl_s can now be compared
> directly without forming an intermediate buffer. This is a
> performance win for the SCSI VERIFY command implementation.
>=20
> Make the SCSI COMPARE AND WRITE command yield the offset of the
> first miscompared byte when the compare fails (as required by
> T10).
>=20
> This patch previously depended on: "[PATCH v4 0/4] scatterlist:
> add new capabilities". However while that patchset is being
> considered, those functions have been replicated by the previous
> patch with a "sdeb_" prefix so they can be used by this patch.
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Doug, thank you for your work on scsi_debug. This patch touches the reset w=
rite
pointer handler for scsi_debug ZBC devices. I have confirmed that the handl=
er
works as expected after applying this patch. Good.

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

--=20
Best Regards,
Shin'ichiro Kawasaki=
