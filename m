Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3AFC4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 16:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 823A161156
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 16:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhHEQWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 12:22:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30604 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229437AbhHEQWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 12:22:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175GBcMG015070
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 09:22:29 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb9m0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 09:22:29 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 175GHc1x024813
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 09:22:28 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb9m0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 09:22:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFJRhCHF6JW0hcfbZq9vGCVFLS2dYaoUf3wmnr0fI8Unj6r7ggEvVJNTPuDSTsDb5K8S9TxlfU6WzvWtMXxsF1xHhqpVcQQy+rYeUm52VoJIY3SsXJw+DwDJuRavs5Ca4DGhGfQKbytTlY0dpKMAdOiMcEfaRUHTq2hi13ylmaLhliiumJjoxEmqKigqFsFnIi7zbIgO9gFbZxyfTpD/lgHDbZfgzFohQPz9hsjMNqoNzhueAEgFX+kFqJmRbq3QAHpGS3a2MAmnj8T7hC7RcvvguY9PIo69CFBCta4l5qFG20lrPqATOcd4uv7x4pirKmvnlc/dzTlbhbdM+uOlWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AV9ujKmvQO3p61kk4B1a3ib+mkae+AKmZoL/EnKNAPY=;
 b=gYeQKZaPDXE9huVn6zXbCjuCKx5KaVkaK+2JDhDVpqzfipAUc+lU4TvLhRCTrprPgMJoPVLbySLaG85yzIdnOyyiQv7ekGpQasAS5Q+CtkPQGD+ljwkQjTvVJubhHmZJzUAdJCljZ2wi4B1EfvvSpfOc38red8ftADEISStCZrbeDgdqnowNqzXcamfNCJ7xpMyiRxyaOanOdkD3ZhdV9dsi4+jffLOcZN90drZS/klg0SKJ2Vp8Cz8Tp0YvOqZGhvyTnibTeoKhx0ZvUc+/FZ24VKbDW6Y7LLFI3iDWYg5MtggGmoAc8RRu95qpOHbH9eKa8j8mZKG2Pv+YMekBLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AV9ujKmvQO3p61kk4B1a3ib+mkae+AKmZoL/EnKNAPY=;
 b=lWSjhpfRErjLetZkHjqszD8Z649PQfZ0FE7WTzYHC3+FlgF26bjOdewpLS+CQWQuiPGgpoFU5euEPmic+jXTM40376FtmTNIhNTRhHPci4cxi1vT0FHj6U6l80JLfzyBzCcCVI6OKtqFQj+A9sItBBFSsrlufCBS/pHcb3BB5aI=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO1PR18MB4586.namprd18.prod.outlook.com (2603:10b6:303:e1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 5 Aug
 2021 16:22:25 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 16:22:25 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 14/14] qla2xxx: Update version to 10.02.06.100-k
Thread-Topic: [PATCH 14/14] qla2xxx: Update version to 10.02.06.100-k
Thread-Index: AQHXieRP8sTHsDGCqky/4Z4Le6CZnKtlEZiAgAABKqA=
Date:   Thu, 5 Aug 2021 16:22:25 +0000
Message-ID: <CO6PR18MB4500D0C33034F48ABE82377EAFF29@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-15-njavali@marvell.com>
 <C4D3D8B1-2DC1-46D0-BFAC-088137F8D72A@oracle.com>
In-Reply-To: <C4D3D8B1-2DC1-46D0-BFAC-088137F8D72A@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 228272b8-aa88-4ae4-a332-08d9582d3655
x-ms-traffictypediagnostic: CO1PR18MB4586:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR18MB4586F54B9462225B660AE7C3AFF29@CO1PR18MB4586.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V7NYB6o7U4hULibN2Exj8UAwVeKo2WPnWtpml8BsJGQBdUW606V7hBUrJS39z7vEnrCG0voRc0KFz4vHS3dPPbpX2toElvzR07jaH5bggGxZZlB1XojZz6FFlfRVJ0T48vcL6pyS0edRBCj8sWKnUs4NCNQjxqz0DxX+pfjtjq4TkHxYc1AASYDN90BT7NNXTbAqai4v6oispuQblWSlHH7fPGy3GPD/mAQFoLcbxd/e/aD8V3C7OmLNJZMdICXj2IqQ17caJqLP4ZgdPCP5xHMl3abBMxbOG+ItQrHnZbIOExUC+uxFLPch7H/PrQVgGW/78HhAGF1KzM3E7Vqb0Z868QEIMjRlMY29pwwWZTZNzTVxQSRXG2A/oii6Me9acn1R5oaRCg7qYYuKzPuxsfMRUSm8f21OKr8I/EqqneLgFw6dQWKv+DtYUcTtSuDfODYfaZaYBGMJRvYx3W19RGwQl3NCb3MHPOvePFwxEDOVSqiFBCuIsRN6+Rvbpv7oVet907ctv0q+MvqzqEnSp19x4zf39VoTDMbsA/AaC5o5pyc34OrfrlkcyZiQlWMS7+W6PGeItU0+5sEkJ0Wuj6MhfHdonlliKhzcXWBwQOh//6LWgHvjXm41GnKmLGHBTzdZ2q6r8exNKro5BYvdDbBQg0AHb3A7j+6mOoDFyIDK3jsYr7cJ/AvkA/9Xbugv17J/LHDh2yYTOkQUSiAKGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(2906002)(6506007)(9686003)(66556008)(38100700002)(64756008)(71200400001)(66446008)(122000001)(478600001)(55016002)(7696005)(4326008)(15650500001)(316002)(53546011)(66476007)(66946007)(76116006)(33656002)(186003)(26005)(54906003)(8676002)(83380400001)(6916009)(38070700005)(52536014)(107886003)(86362001)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IbRmV3dmmdDsKmGnWYUdAGHsU7LTEOGXX9Vh8OMXxEPcuWZhPkIE4NI0JW9N?=
 =?us-ascii?Q?ndC/D+BEH0dUEZnSP1FF5E8DvjlTeSOtJsgbTx8iM6YdPQxoxeaMGtCGz5Q4?=
 =?us-ascii?Q?mylssNMbUKMncJQ2jq6jAV+Gc6vfURoJoQp2mcR/LV+MkcnjZ+7GQWtE5NgC?=
 =?us-ascii?Q?gtmovw3z0r0jEh13/6qM5VtY72WfvalCPQ80YeKNs6RYqaC11xvvirQWB5Dv?=
 =?us-ascii?Q?CLfAUqZgKsMTi6whG75Y7Wmqq4yhT4BHOpg7fTm84oMSzFQ3QRPZAh2Jj5QO?=
 =?us-ascii?Q?CYQnhsOdgqEBmFA0+uxeNhU3Vp+nBvqH0C8lyLltaBEXylM87lx3/DOFSPPS?=
 =?us-ascii?Q?1tWhSaUMBdg2HBtRqbdd+zbGSnsfM6Tb5f1rccOqbWyTrsbnj6H0eP9iwy5K?=
 =?us-ascii?Q?Y/rsKT6j+WeusnJTomrjUmM3fliG1LTmdcz3cp2lGW/PM/FQGKO9QX1JY5gP?=
 =?us-ascii?Q?g7iQ+MZ+W+Ka5HCSB6P3YZzv13eqHYwNKx5pOAgbAsRriYcXKz/HQdz2hPXv?=
 =?us-ascii?Q?ynNUwxdMTJ7qarIVV1qoAMnuUDiIDYrVqx0A06MVUHyu2XQNmmHGur2Sgb8N?=
 =?us-ascii?Q?JKHM+oeZrW/819teSCPCFGpasNY6riRWsWtzz+9Jj5CKrjRiz74LOEGPXFAu?=
 =?us-ascii?Q?xUz4T6fBDCn6zDPtx0R3pta2lmYhh5uSjz7aKFJlrzuxCBzATcP1pM0IQkYb?=
 =?us-ascii?Q?LRDYbSDz2nh4nMHuDP1zhpB1PKm+JEQqQ9w5N49vuGUYdAODHytrtojSfG6X?=
 =?us-ascii?Q?10smTa2I9wOXhqw0t2iU94TxshrYpBuaMsF6ewxAH6PFoMmOalTmSQjECrJ3?=
 =?us-ascii?Q?Tnj1PYLI3NHmYKcEJJQAaqJ0vy4f2xHbSNyskhTqNZlDqpR4SXKQkms0b+ty?=
 =?us-ascii?Q?7LQVdTvvY++RzyNlDWVT6vFpAodE1a2c/hrUIOXzPDYNwwx8Tu99j6i8dOP+?=
 =?us-ascii?Q?JD0YsEzKmndkt9oMcOuj6ITjLcez7Ue+vsHp+GpAN0PlDFVJapKjtcI0bRpP?=
 =?us-ascii?Q?Xq9hIx2JLmVW0CoaM80WnQaaz9iZGjgyqVRvB+ct2rCeznjmcWkW2KJehc6q?=
 =?us-ascii?Q?HAAfKDmvtG5dzRrWdZcWZ9cCosbLdYip0SW+vnWyxSNq19FfffnlQWBrHv81?=
 =?us-ascii?Q?+teJKofETgFsGi0SONg7F45DggUoqHesuKPuFXevRqm1zUdUE5/UcStRBNmE?=
 =?us-ascii?Q?I0RiUtKKVMuDGiEtOgK5n1VgYJEaM/aFbRu21KJba81eB7B8YfLGUHFTwwAk?=
 =?us-ascii?Q?nL0f6i774saalAmu9h5BQ8qdTztvygI1DoE9zIcMs938pUHJWDDI/Z+HLwWC?=
 =?us-ascii?Q?ctiA7r1Bnjbqkswfwit7/QFZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228272b8-aa88-4ae4-a332-08d9582d3655
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 16:22:25.7034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CVMW8eDdeACLEcRoqyvaRfqBZotNoXzk5WqrS9r4ASpsJ6fLuygdO++YMXPRky1BW2NgB2mXsqrI4jEvXvz4mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4586
X-Proofpoint-GUID: 0uaT22O0gJh6g8Sipyl_AeiVS0tGEQBP
X-Proofpoint-ORIG-GUID: 5nf-QAf573-tImBVIXDmfZuDhdNQE1sw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_05:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> Sent: Thursday, August 5, 2021 9:28 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: Martin Petersen <martin.petersen@oracle.com>; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH 14/14] qla2xxx: Update version to 10.02.06.100-=
k
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
>=20
> > On Aug 5, 2021, at 5:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
> >
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> > drivers/scsi/qla2xxx/qla_version.h | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_version.h
> b/drivers/scsi/qla2xxx/qla_version.h
> > index 2e05dd74b5cb..8b0ace50b52f 100644
> > --- a/drivers/scsi/qla2xxx/qla_version.h
> > +++ b/drivers/scsi/qla2xxx/qla_version.h
> > @@ -6,9 +6,9 @@
> > /*
> >  * Driver version
> >  */
> > -#define QLA2XXX_VERSION      "10.02.00.107-k"
> > +#define QLA2XXX_VERSION      "10.02.06.100-k"
> >
> > #define QLA_DRIVER_MAJOR_VER	10
> > #define QLA_DRIVER_MINOR_VER	2
> > -#define QLA_DRIVER_PATCH_VER	0
> > -#define QLA_DRIVER_BETA_VER	107
> > +#define QLA_DRIVER_PATCH_VER	6
> > +#define QLA_DRIVER_BETA_VER	100
> > --
> > 2.19.0.rc0
> >
>=20
> Just curious..
>=20
> Why bump Patch version for the driver? And numbering does not make
> sense.. please explain

This is just for internalizing and identification purpose, to keep upstream=
 driver version in sync with qla2x out-of-box driver.
The combination of major, minor, patch versions (10.02.06) would let us kno=
w association with respective OOB version whereas the beta version=20
would tell the series number (100, 200,...) for that particular patch versi=
on. It's for internal tracking only.=20

Thanks for reviewing the patches. I would send v2 for this series.

Thanks,
Nilesh

