Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B855DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 03:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiACD4N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 22:56:13 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229515AbiACD4M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 22:56:12 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 202Mo819013971
        for <linux-scsi@vger.kernel.org>; Sun, 2 Jan 2022 19:56:12 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dbmvsmcwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 02 Jan 2022 19:56:12 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2033uBW3008987
        for <linux-scsi@vger.kernel.org>; Sun, 2 Jan 2022 19:56:11 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dbmvsmcwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 02 Jan 2022 19:56:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht4dD703Mmc4uY4bacUfLMv0T6Jkxo8Spt09P3ciLYbRn5aycjsFisjWM/exVNzaNSQAxhNbk3I/k7Evh7VJC/3W56pNjNE7N/j7Eq14zUFKvMDtj13gVpqIcukhELC+bUjnl/d+Aw8s42B2pnLYr2BTSZERKOOsBlkNVsLMiFQ7XZqUmrEse1uy1ix1tTfrljSOt/YEa/iLhuIzk85j1d6/BtDow0+dOYcWyB7HkYFTRb1YgCnGGgxHnAL4Nqy1QWB6/XheN0QXwkiNH34so1omDKcs6G1nBmZZrfdE0gR8EKdT9Jq75yn5oRL4Z2NPlifHxVHCv1GvjvotYaxD9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bT1h/OyJUpjVoJ4fbCU0JA133UfGWudG4feYIFx/F8=;
 b=SgaMO0qqlQTdPbQ9sO6B32t7/YHNrWTPgsNSGNjxHh0CnYFyEZLLrKDo1EGG0W3uecECjHU12FlfoUgIcG2h5+L542zw1fSP3ujmaWLg1XbuGY38R41G62HeYmH9bt8jMEj4fJfYvsuPmxen5oar3iMo/4IZ6KCUQb+iX/+mvFDOhTQmGtJGJhqGyHc+tqV67Sclb5X6LSZKPurKLlLRjw+AfxpUHnNWw4Q+PO2U8x790LCz/lnm0JIAkp8aROoVb10QdfPA8ZVpptRVK/xCHmmnPTR10UQJ75SvDqAewfUwZCfhdr1Tapg+NRohLT27Al6rJsUr/5gV/cUxfv7oUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bT1h/OyJUpjVoJ4fbCU0JA133UfGWudG4feYIFx/F8=;
 b=ad5L4uNQ3IgHxhezI5d1UEh988ealSgDfaiGExWqhImHOVcuXMXTTloRGr5EOdjnNCsGrmEuaM3n3hdw394LGsuV2s2XAi+Clb2W02YWTrf4UtyBXjecsYjiV5HXAF5655YNGP0KozD3FmVbQx4hA/JKwLunAOBjJvqZFGf77WE=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB2278.namprd18.prod.outlook.com (2603:10b6:4:b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 03:56:07 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c%5]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 03:56:07 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Topic: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Index: AQHYADllJ9RysIPwNUCiCsm1uAhFo6xQqSSA
Date:   Mon, 3 Jan 2022 03:56:06 +0000
Message-ID: <DM6PR18MB30347380BBCF7EAF7EDA92C1D2499@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
 <02990604-CC38-42ED-B3D6-11CCA0C5D43E@oracle.com>
In-Reply-To: <02990604-CC38-42ED-B3D6-11CCA0C5D43E@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0fa83fd-3016-47e6-61bd-08d9ce6cf882
x-ms-traffictypediagnostic: DM5PR18MB2278:EE_
x-microsoft-antispam-prvs: <DM5PR18MB2278A7393B5A86C1BAC00F71D2499@DM5PR18MB2278.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8u7z/5yWmGRevbn8tnAkwluBShiiroZRIAL6KMEZ2fsJBHnlgckzUjU+lasBhvpeomsVkGnIgfsaimjJk8UzjP29swZm14qLgRvsTtbN66USG9yT1dfTLEMCXWP+zpciDN5hNYDHjpDtwA1waS7vNngQEt/iFweR3mzyWJyW8YJTRAMGaQVihYHn6aapG7wUsV0xRosGYhT2xNzkHPa4lrvBGQIEZ08Hjd1O4P/0AH0hxpub8nLkDdk7p2g5IRL3XhhMxy1Iwbmna8q8k3QvzT28xw/VvTwtx4vQTZIlc4zrudhhU3VuVLWwRe5cJ+6n731RYjLC4/Tcs3M56AT5svhGthsmQeyhI8g9r3AX24WlWyo5VrfEYJ54Bykjl5HMXtjfdEjG7APsVsgxNDwC8885xnhNCKB6a3H9+8zbdLRs1S7tS3RuvQnJcUxbqoOv/TRViaI8rktCJNesIKZ5SL5K9+1T20lXrX3Z0TJyeBtkyp6A+RzfO5F7k31lEMB0+JtxBPrao1Z7jcZ/BEVewL8YhaV3lUwDvYaXx3OemhMsiF9UlPGu5CB0er412+O+RdqNp+b947d2PDlklaBg94Odllz3J31WVXmhDzj1O1s0L1lNXQW/1EnlaW0XGxgCSMYg79dQfOxVRmlAC8Nh9/5CTjeibb47ruZe6hcn8aYKFAeRpJsablO9hkVVO8tFrwriycaVxMHdWW35clRXpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016003)(6506007)(122000001)(2906002)(107886003)(9686003)(71200400001)(52536014)(26005)(6636002)(66946007)(66446008)(55236004)(66476007)(316002)(38100700002)(64756008)(66556008)(53546011)(33656002)(186003)(4326008)(110136005)(5660300002)(38070700005)(76116006)(7696005)(508600001)(8936002)(86362001)(54906003)(83380400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6AeEX9lNy98in6vqN+Sxjh6PqoKYATU+ovaies1fJlzmikezsEGYHW46GEP6?=
 =?us-ascii?Q?PdtgTah1rDsFKm6ZPH6xI7KfUj4X8GEWhNcAyE8PNt0TAKwvLzEoQ/bfnzG1?=
 =?us-ascii?Q?NtbKkGgU4XzK9HtDz2d/zsOFqIsFjIC+RDrQjqBdBKIjGUCrP4D4hnbU6j/8?=
 =?us-ascii?Q?24xuZAk3j0W5rLJCNiaUQJZlCJLBeNxPUK/qtgGbMVA6OmOG9DNyIAV0AQaG?=
 =?us-ascii?Q?nIvHOzaD0A4PDSrnDZxTNZRVu0EK8cMq009LbtIvUCaI3Hq1kb666dC0OdzW?=
 =?us-ascii?Q?mGC1r6rswgKrEJRedqjVbKcjz5y98sPEUKCjG6akTIB3TLGLscjEwgxB3qRx?=
 =?us-ascii?Q?6CBkjN1fkMMuhgOIrEGYm5z3lTLhpHs0onG2ugmvhQgFsIJHagIYC9cAzP8Q?=
 =?us-ascii?Q?10xp2sOrWgVPtwPCA1jAEuPDcvdhPE3e0Ii2EtEvc8Dl+3pD9qtLdN+PXdCF?=
 =?us-ascii?Q?3eAcjUsf7UnltGcfWfAt1PC730hoh8TYeg1C7e2+gjIGBQwN1W9rSFTGL11B?=
 =?us-ascii?Q?P9ivItc9kHFgrqkHi7+9ZF5j+Iq5QtEdnZGncn2LukuJGW6Y57iZu1gs6FYS?=
 =?us-ascii?Q?y+Ysk4aet293wUebgytuKD+FPGhep1fn2+gXMY7Pn0Hr8RpPw9QHGSItiP3p?=
 =?us-ascii?Q?Fr58/k6tvcBHHBVvwoyBdSSoe7kxqI6jb56W5UDDLGzfbvSJIDF0UjzLTjBc?=
 =?us-ascii?Q?BVsuouf0XM15HZa+cELsoq/Dt45jzIB3IqrdpHLl58a9IJjYPX5mP3bAEJUq?=
 =?us-ascii?Q?m5UnEGspgGcVoHI/HB9B3xRKmp2nsJ/uRzdEv0dzxk2xPccQGNO/el3i2CHu?=
 =?us-ascii?Q?GXD+AFWIKxjvb83bu4UYwctoPSTpMaLe84MDKJtdau4qEYOLSOAkSnfIRM3e?=
 =?us-ascii?Q?jEdsAP5xWUIO5vbP1ooXt9395oJNMqCVqlUN09u1vvkKEIT5GFXNeu1UlAfE?=
 =?us-ascii?Q?D7rn70SzMfgH7eIDSusKRIFxSSWyRgq4qmDRbKT4EkQEyJfvWgVP7RwPjRYC?=
 =?us-ascii?Q?00+mRI1BmG6lfle/YfBBKAqII4ICH+EqjiDVpKQ5mLQXpZ1QYntOL+qtYQ1G?=
 =?us-ascii?Q?GT0gggrkQpHJjDUeka404CIT9ku4swpiJR4zfmcNOdfWfimsw2Wa+hW6H6cw?=
 =?us-ascii?Q?eHBOSMRuqFv5HWTFf0ognW8zSbgUJ8Yn0OPigUyGmnImoGp9ji0dpSfE5zgi?=
 =?us-ascii?Q?+zcJ+oDk98+EdyVCHGYGVElT+/Ri7Zul1c/2I/F+KfXfPPQynK2u/rLt7i5u?=
 =?us-ascii?Q?bxt31AHqwWZMN0DJbyH1DbZna0qIPb8bWGVbCsxBWqqm7Z2qv7NANhHkU5VZ?=
 =?us-ascii?Q?/UuFUR4QvYKDdTD9m/hKjI76+E/1BiEsSFbC6H/YKrD4qvA6MSDpyq8ZyiF8?=
 =?us-ascii?Q?6RABFvGJtoFifDBvw6XrwMtizKtfuxgjB1gj/iIzHK4TOt8uTgi8DZxgoO4v?=
 =?us-ascii?Q?Iy93ppYUmIpAGSrcLL7wxQO/G2TJoLm8tK486SZlFSCYa/qYr8RVyoZE6f06?=
 =?us-ascii?Q?lau62kf51TMaTzYVW7B+yi0whr3NsyF7hA2S3miwU1CDEOU1mdPBzqWEAIhJ?=
 =?us-ascii?Q?GooJI414xPbDsNslCYKg/+QQoFzGFWGNzLpJOf6Y84u/J9s2oMEMIRWnqjjA?=
 =?us-ascii?Q?PWznlXE6J+3NXF0coim/IG8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fa83fd-3016-47e6-61bd-08d9ce6cf882
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 03:56:06.9001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FkNqzQVf2/xYpBTMPT4xKht0lxVvWKWBbQbV9MkmG/pGI7EPWB8/zgAFKbVR0hYJJchiBHhvNd4U2WLMpkDgXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2278
X-Proofpoint-ORIG-GUID: MIqYmyzNZCTvUJqOOuPnTpGmAtIvEyOV
X-Proofpoint-GUID: t9kqj84j93Mi_h8qot82BTpFFabwbRot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_01,2022-01-01_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himanshu,

> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> Sent: Monday, January 3, 2022 6:03 AM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: Martin Petersen <martin.petersen@oracle.com>; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
>=20
>=20
>=20
> > On Dec 23, 2021, at 11:06 PM, Nilesh Javali <njavali@marvell.com> wrote=
:
> >
> > From: Saurav Kashyap <skashyap@marvell.com>
> >
> > Fix race between timeout handler and completion handler by introducing
> > a reference counter. One reference is taken for the normal code path
> > (the 'good case') and one for the timeout path.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> > Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> > drivers/scsi/qla2xxx/qla_bsg.c    |  6 ++-
> > drivers/scsi/qla2xxx/qla_def.h    |  5 ++
> > drivers/scsi/qla2xxx/qla_edif.c   |  3 +-
> > drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
> > drivers/scsi/qla2xxx/qla_gs.c     | 85 +++++++++++++++++++++----------
> > drivers/scsi/qla2xxx/qla_init.c   | 70 +++++++++++++++++--------
> > drivers/scsi/qla2xxx/qla_inline.h |  2 +
> > drivers/scsi/qla2xxx/qla_iocb.c   | 41 +++++++++++----
> > drivers/scsi/qla2xxx/qla_mbx.c    |  4 +-
> > drivers/scsi/qla2xxx/qla_mid.c    |  4 +-
> > drivers/scsi/qla2xxx/qla_mr.c     |  4 +-
> > drivers/scsi/qla2xxx/qla_os.c     | 14 +++--
> > drivers/scsi/qla2xxx/qla_target.c |  4 +-
> > 13 files changed, 173 insertions(+), 70 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_=
bsg.c
> > index 9da8034ccad4..c2f00f076f79 100644
> > --- a/drivers/scsi/qla2xxx/qla_bsg.c
> > +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> > @@ -29,7 +29,8 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
> > 	    "%s: sp hdl %x, result=3D%x bsg ptr %p\n",
> > 	    __func__, sp->handle, res, bsg_job);
> >
> > -	sp->free(sp);
> > +	/* ref: INIT */
>=20
> IMO, There is no need for this comment spread in this patch. Please expla=
in If
> you think there is need for comment.

<SK> Thanks for the review. The sp reference can be taken and released on v=
arious paths. These comments make=20
life simpler during some ref issue and also make code more understandable. =
For various scenarios, this comments
helps in determining final reference count and check if its released proper=
ly or not.

Thanks,
~Saurav

