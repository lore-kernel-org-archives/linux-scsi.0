Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B87C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Dec 2021 11:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhL1Lb5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Dec 2021 06:31:57 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18184 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229490AbhL1Lb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Dec 2021 06:31:57 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BSB4dED019537;
        Tue, 28 Dec 2021 03:31:54 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3d7u7a13cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Dec 2021 03:31:54 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1BSBVrW2004065;
        Tue, 28 Dec 2021 03:31:54 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3d7u7a13cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Dec 2021 03:31:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOg+75VKKwtLoV7vxfebESNZPsOZKaMU18mIbQ+OxO2C7ZXvFSLoi31LSgfqPVGLgP3Qzw5IxRFY1RnPkCH7REkNLIgbG4F8kfSJngLOq4TgLwVuT9bwmmvWmbBye0qk7T8CWGSqN8Zas9YcP8dXDAJaXQY9QDTk5x8lLf5kulxDbdxyweIJuWn2BPln3Ok63DYcxKiyQmNh0VRBahc1iGNmNmglRCyzABAGK0syvEPHniCL38nPOlAtrNBnTdFD2DK+JCNpvdeBte+19HiPP2kMnxZ5xnyjRzJT1gAYf5TFMgz1oarufJh/QbcIrFmXoCxnjVgORYBd8X2B0+Vo+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEreidtlBDfUsBWJeWDpq0nCCzpR0+pZqVJTWzTezXg=;
 b=JzN/58T8/EBJrNm4Y2m3vnIbZRV30d6iFjZoaHkm2ow/u9WAqOro3+PC15EjQrBYjg2CqQYCBDQRRAuP+ctGfpRRVcFcZJSo5UuuX9BmdSBztpxbK9ciBJqQwXd4nixaUzITql45WW2AKnnTG1EF02OzXYWJRkiJhQjSkGzRHA8oMJyOZ2pDrFV6Vc5ZxmmAVl/QCtUlb3405XuWIiKci/JWqQsMR7ecmGiLSWj7bJv6gJETMBjxPONXahcrJ4ejfgEyHFyr8mwvYgCqg2WvK+QiEXVsiP4rBW1y822+WYQKSE9ZOd2adUz2eqoe0nxXv03pKnHleJRGT8wxzaqang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEreidtlBDfUsBWJeWDpq0nCCzpR0+pZqVJTWzTezXg=;
 b=bUVucGq0jUloM6jTEmFEeNnBi5Jbaz062zCuuuza4CheLL6l9eSmdHi77N+vN7UGREuvaWQJAmrX7ttllFFZxGhc4rr5aU+BsPAel6MlN8DD0h65+bSdzmR9FdEyEcoob9mzAst59xshwA1pCK+vs8FPi0J8sDshDPgKi9qeH0Q=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB1162.namprd18.prod.outlook.com (2603:10b6:3:29::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.22; Tue, 28 Dec
 2021 11:31:51 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c%5]) with mapi id 15.20.4823.023; Tue, 28 Dec 2021
 11:31:51 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Topic: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Index: AQHX+9vPJ9RysIPwNUCiCsm1uAhFo6xHxOiw
Date:   Tue, 28 Dec 2021 11:31:51 +0000
Message-ID: <DM6PR18MB3034FC02E5B315AEAECD1BEAD2439@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
 <20211228111226.vga3wudmnq27czrl@carbon.lan>
In-Reply-To: <20211228111226.vga3wudmnq27czrl@carbon.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94d3fd38-ce0c-4fb4-9000-08d9c9f5a46f
x-ms-traffictypediagnostic: DM5PR18MB1162:EE_
x-microsoft-antispam-prvs: <DM5PR18MB1162FF4B7071CD096582A566D2439@DM5PR18MB1162.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrbUmKrLVCD487IWG8zwAPi8/r17fOr/PmMPNHREUHKDDUjdwqyeCOrIkjLJlJeVd57EVWS1bui1xtdL3jIKbkegdZXl9f8Ceejv0bfkc8+C5gEbEGXul7zh6Lwf3Y1ERkhWx5Q83AMyBk/XPNEbG349B9QwZFiRW0DaCIZhB65w4gcmIPKfm7RPhM0T1BVsVbDq9Fw3Tha1U5B3+NXL2YYFvHTEqYpVRpSGtll/uvx4SD/wZvNDGlF72Usxh/6T/awOCJ1QpToNynve6g4Jihry3x/aGCCy+wCw8xmKW944d5TrB5/ym1gSNtMXKL9tZUe/a/T9u+NP9jptPnvQFv4LJXqaN3gn/D/FN8GBqgwchoUjoa743ERfYxS9klnF2PD0RY04JDJu6iGONpP34jZU6NA3WOdhhEsyX8qasdCNsjdZKa+5SvDMT/OuxsYfBGh9G0TdPnkgxrV05Y47m1sAa1YMblym9/Aw2u12fRdAM+lgRZD50h55x8CxX63VWOCXIRBzJ+sYf5OwLd7mNvLFaUiSQnslf6Tb3cpo6LhTxiTXRl3x/7HWvQNDHyyR9PxMy2kzkL5ERr3dbhMqAgbh9XoepxHGj39eNKEG3My1R2pWDUrC14hoN3F6snqAg/qH/NYNdx9x+n9YxPgSuxZyxM1oomA6Gu2uNdt0HglpSMKVrtBe+w9X2QDixYonYUSqeF7J+2bSAm5xa2vi9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(71200400001)(9686003)(52536014)(5660300002)(8936002)(26005)(83380400001)(316002)(107886003)(8676002)(33656002)(2906002)(122000001)(6506007)(55236004)(53546011)(54906003)(110136005)(7696005)(86362001)(4326008)(66556008)(64756008)(66446008)(6636002)(38070700005)(508600001)(66476007)(186003)(38100700002)(76116006)(66946007)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6x+bn3mnB3bstJX/I/Gs90zmRfZO63mFrpFyrpTandYROkYAB7ltopKsw/Dp?=
 =?us-ascii?Q?ofPOx2YzBqJNdrP3R2KxkBsdicgbzbFsTEspLBTZg1WvxIBrA41QWEIaYGng?=
 =?us-ascii?Q?0Tge6kzP3FBN4WYtcN8lx8CveAJtIbPiAKZ1W/18l8UpzHJuLwC2k2qKN/cu?=
 =?us-ascii?Q?UePTbb1PDfu5+4vNdKIMJHKl8MtN/g/zwhB9ffThZ4umJSpLdRccDmvwLc5w?=
 =?us-ascii?Q?Atqx8VhebEX5m2ouEl8dY1Ns74nAI62C40GN5x+5y8J67qxsGDZ8CLblmy2O?=
 =?us-ascii?Q?p5GdH9MD6ElAZXTIGfX5MI76IQ7wenKdsIbPpuMWukteWnu5cGK3W/dskI89?=
 =?us-ascii?Q?HQeCTMiTQ2OT86JmG2lWpa1t00fAFxnwEK+YyqIQU8597EVIcdq/GQ1SNv4f?=
 =?us-ascii?Q?iGnVJIkGrVGtnt3hl10EYRfyPwo76W+vojSqHNbdOgf4Y3PtZRGGO1NaYxls?=
 =?us-ascii?Q?8x7dUB10ijaXX7+U1jPQPANp7wTrTRmDA58V/zxrQ9ddtxGNyw/fc7y+7z+6?=
 =?us-ascii?Q?qwZRzz6BeLmapg3S1pbE73+ZmTmNyrEZe+pun4mQ4UUAOJ0WWcByeVLVvA7x?=
 =?us-ascii?Q?MY/hT3X+7tYuVlNPcYTtyU/tkyVhYYXFnsdBqWZlUUODcydA9aypPaYHTNXP?=
 =?us-ascii?Q?zCl0var56NBATK/KrJ7svnYXkTjAwL4XL3w3nvzKk7++DkHK97dF7MRvt0iP?=
 =?us-ascii?Q?Q52Aeo+OXRtPAGyUbzZ+VDgikO6Xr5WmBn6NcfKyBBitJMeNwsUdFnVfBIJt?=
 =?us-ascii?Q?Sbjj4ipu6ZfSmzYt0qbNCuBFb2iQ8Xv//DGQxhNpc+zccMJ0ozS4OLf6WO5n?=
 =?us-ascii?Q?lw5cXG5jgaDgQloXeeqLOpJnK0Acjg0OR305vhv19y6a79S76KqwotbUgsjN?=
 =?us-ascii?Q?HuRwMRJdck4PWK/vwVSUjJfo6UanL4puHOnf2PBqtfjf8oQWGoygdYhnFwmn?=
 =?us-ascii?Q?61zQHHcWoiVvKJMU47rJlkuJgBFqanfwWL/YOIddzXaHVDAwro7PReWb+4NB?=
 =?us-ascii?Q?To/0ZO5BWLfXC4c7xDQn6TlRrJtoxb4okMYQMt1D0V50BkG15OFVz9xJTM0j?=
 =?us-ascii?Q?DLLcLlnxn/ZanVmzN3WtpN8r479qZKIBoFIrYgFsq5rUCNnHcQdIJSFPdWzx?=
 =?us-ascii?Q?eOntkKtrYcf15b6ONQt9X6sVTOrgDEB0GEcc3g/FVwxnUL4vksMpmRqfS1Vf?=
 =?us-ascii?Q?OqrSzx80cJqFKfZIce3NbwVBwkFIuCnKKT85jGUWji2aoQw41YJj4sPaHfyw?=
 =?us-ascii?Q?bqDaJ8sv31Ps5KyK0cDhfL96+n8L70KvnT8o6dyciTmyxAh+68zRfoU8LYSV?=
 =?us-ascii?Q?+XYAysPkqcsg9LnGLmkxOdKHzbgx4/V92sg76lxHdMj/ecga/2TqByYeQoSz?=
 =?us-ascii?Q?tJke71jBUXxiV7TjUqGkerqzLUL/OzZuHUPXM1C2WmTZpIHTBX4DwMP3sws7?=
 =?us-ascii?Q?ZnLzrIasGnfaWHXyd2hfXyhNL+zdIxj+x8xv2FqXEGzY27t35Q2ZTSRoIB+T?=
 =?us-ascii?Q?a0ZtB2nnFRcF3H7hc2GZsmz/tAO+yiz/Rc1jsoL+n+W5lKu3oHsPOOrnd+xL?=
 =?us-ascii?Q?sjIr8RyVuIN6b3bhXXBWT9BKFXrKwfTOa5CcHMWpJRexL98ie0eC0wOIC3Vh?=
 =?us-ascii?Q?KQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d3fd38-ce0c-4fb4-9000-08d9c9f5a46f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2021 11:31:51.1487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kGZcRJ6QCCOS2+mmcX6VjUhrvD4LfSCpoPU52QdgAfkiRqZwSNa2sMAJKx9Jno9MQdfAFgIhkJ51mgS9geCjIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1162
X-Proofpoint-GUID: 4NJ0iywq4DAjTgZVQ4h0RDRlF-m7vZre
X-Proofpoint-ORIG-GUID: ec5usikGuGKW7y55Ce8xcSVUd3Z6YWZR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-28_06,2021-12-28_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

> -----Original Message-----
> From: Daniel Wagner <dwagner@suse.de>
> Sent: Tuesday, December 28, 2021 4:42 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; GR-QLogic-
> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
> Subject: Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
>=20
> Hi Saurav
>=20
> On Thu, Dec 23, 2021 at 11:06:58PM -0800, Nilesh Javali wrote:
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
>=20
> Thanks picking the patch up and getting it into shape.  Highly
> appreciated!

Most welcome.

Thanks,
~Saurav
>=20
> FWIW,
>=20
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
>=20
> Daniel
