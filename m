Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23409C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 16:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiACQC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jan 2022 11:02:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229746AbiACQC6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2022 11:02:58 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2037sxba028615
        for <linux-scsi@vger.kernel.org>; Mon, 3 Jan 2022 08:02:57 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dbw5w70ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 03 Jan 2022 08:02:57 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 203FxqV6004397
        for <linux-scsi@vger.kernel.org>; Mon, 3 Jan 2022 08:02:57 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dbw5w70b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 08:02:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLyL6Thsm6qyYtlT/L3bSzTwErL4jrTzljSqrKxIJPksitpStentrh1Q4n0p3eQDEWoIGA6FvD5fvNx0M6BIXRqXsOKlqasbLr1FPLBLOQYgNd4meX5WnE2/95XM2TIuvqVQmNdYNLVEO3S0npHBizMZHWl425MDKUCEJaqtHLi5OMCdGSnRpqkOT/3RqL13xSN9gnJiegSL1XxfLPrCIdu5q7Q80XssaiYY+ZDy+gSD0tF9K/EftdtmlQt0Jtq30CNR229o3rXh28WZ62oNeW6ldjD8QePR6YK7yqwgHJ5Ffb6ZkFE0Ad70nK6HocJT6yDc2kBwqTYWAWq3fz87wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TExIdDWhV7xGvkxNnHULUhbj/5npUUPffRrN2tVkE2I=;
 b=R1vmzRMsiIIR2fNugeeEAplIjSyB/zPpbdK00H2wFalOAjm1a6wOKRHaaOWieAwrJ/MVs0aednGNN2l34PzLOr6FzTojmew+7dGexBeGnhbhrBaXr53/s+Yi43xvd3LGxcdpJyEhBRyqxdHZCPw7NlAl3IncJkVy0o/oBMtaeRTOAnhhkoDrx4xqqd08xdKnA0U+eUzjeXMe8PbBPNpABdLY71q1EaP3hGoD9iBFmO/mqoMvH7OIk/2SgMLMPfKAUDyAKZjCmSEszE5iIfcp/dbQZXqdijrqJW6cOm2SgWmcvyBiz2e2YrTsw9+S1MCHuEwDamTityp1ZdWghskfpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TExIdDWhV7xGvkxNnHULUhbj/5npUUPffRrN2tVkE2I=;
 b=FsoZZxcHj4dmHKhrHQdPseDlKYytBQxuxAZvz+tM/qy7FXwQ48N7N9aquMj2G7fiGxKIGRB1Xp2rzWvLXJVBHynWERDOuuYHvF0ji+SV7szEkY8JtzAbLvV9em+LB2mWgjq8iFaUMmOQYhAC0lqA3gP2Pi8A2ImVosNTvGh01hI=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO3PR18MB4846.namprd18.prod.outlook.com (2603:10b6:303:179::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 3 Jan
 2022 16:02:53 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::c860:ab95:dee:7353]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::c860:ab95:dee:7353%6]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 16:02:53 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 14/16] qla2xxx: Add devid's and conditionals for 28xx
Thread-Topic: [PATCH 14/16] qla2xxx: Add devid's and conditionals for 28xx
Thread-Index: AQHX+JT7iTyZK5B03EG+kSC0sLdzv6xQhxgAgAD81pA=
Date:   Mon, 3 Jan 2022 16:02:53 +0000
Message-ID: <CO6PR18MB4500BED43F4987F90909BE24AF499@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-15-njavali@marvell.com>
 <46AAF253-04F5-4B3D-AD45-FFAE1FD43D4F@oracle.com>
In-Reply-To: <46AAF253-04F5-4B3D-AD45-FFAE1FD43D4F@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15c02d13-d7cf-4fe2-ed4d-08d9ced27ff2
x-ms-traffictypediagnostic: CO3PR18MB4846:EE_
x-microsoft-antispam-prvs: <CO3PR18MB48468233F340C1E23C5AD9F0AF499@CO3PR18MB4846.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G2UpdD08tDDek+CtxcqR2lg4kM9zWh6s5OHLySOx3O7gDQqcKu0Wzlj3F6HMSAyx5teYDlmGmb+nyICvqUSTRlojTa70enMdT3ebViPhmWlSvxwk5hU7cYGFbWrfPXpsZRQmqS4Oe5DZTbfOolHOfIIedJVhhrGJXMtXpqJXesvxYLUIXdRv9e0y1VSOGV7gTIELWA4K4COXxGIZgkmGJ6RN/+Zme7Rtl4EIIak8KtnAM0vnEWhHZ0IUWXn9kjQrzSVwYiM8vDFy1VfFZ5a9ZfPqxY5Zdcy6CkWyBj6nKqLanbJCq5JPVb8HP3nphmcfQmyndWUmSpcFEkFPbCaIszcArE8wtzzjVCGxFpDKbBqKf/ws9Pfd+ac4rKzSEuDRcVy1REXXba2DsJTk0A07r82Tncwqcg9Ol5GumkORtmfHklDnAaskIa8V0e6Cy/RlbipXp1fTJuQKIbJitkJ21S64567gDOJrwvkbXiWnoDba2ImMLhzheHyJTT2vL6I4EePTK4viNBzx0//PbT1DIgYrg76IB958snS0I3VH9NSBjZySSaeyzWrQeXpK2bg1x5DmTb+l5s34SkOSZ+IPzh1nD5vxGLVe9n6rYSfckalsFdiPvlG6hs65OJj6TyYYvZEflb4hN/NaW8xKAjNxFkKlysCtXmhK8jaJG3HIVaZ106OIOOb/bnogMg+uwrPn4izAzZWKMOXEbJ1DZ4GpDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(122000001)(83380400001)(54906003)(186003)(38070700005)(5660300002)(107886003)(64756008)(52536014)(9686003)(66556008)(71200400001)(33656002)(316002)(8936002)(55016003)(86362001)(8676002)(66446008)(26005)(53546011)(7696005)(66946007)(6506007)(38100700002)(76116006)(66476007)(508600001)(2906002)(6916009)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?brA7NB5Ny6GuiJfQt6MS06vUT1rT+qqleNcG/tQsld3hqOYQcc3Nt/ND+TRL?=
 =?us-ascii?Q?Ug5KY1FVy7naUrxE8AmNidgy0s061YcfwHRLS7lW3mCjyp8GAbGrGnLbJ3nl?=
 =?us-ascii?Q?weeoZqoFxDC0XOvZWyALBtGPdi31MdZmZHpLXS4etQCA0x6eek7QuPfr48Jo?=
 =?us-ascii?Q?daEGw4ZSDEZlRDzIOZjXAIsNwOkUBMkrcc8mb1Fey3P4M1VEb/Yatk1Z0gy8?=
 =?us-ascii?Q?Ftexbh0LLfzpaebi03eEVicsah1wQWjvFtcWdEpNYg+egZ+k8mTK1Rn9KcRT?=
 =?us-ascii?Q?2WAa1oHJI5AwkQmkaEFFU310DX2/kgAqnFyS6+Ejw5zEQ49KxKCb1kQrvwQA?=
 =?us-ascii?Q?pIREA3X2b9yXb/Cq8gYoWDa1F3MaDrM7ZvkE5yHqvBVCe5kAUhs9fblp6Mjh?=
 =?us-ascii?Q?e5/bRXPVu7UNTp4UjT0f1GCgvRPQhrMEvo/PZSu+NdjzSlAgtA6I+bxRiLgt?=
 =?us-ascii?Q?SxvGYNx5XRW0I2xqGJGwvzOKkRiFDOn7dBTB8Fsx6Ykf3eulGC0A2CyAjZXv?=
 =?us-ascii?Q?Wyk+nvM4TPqtSRCxmtjlRr2z2dwK5/hzbpmzB0N4wg3KHG2OroiRmTrG2Ydg?=
 =?us-ascii?Q?EmaddKUd/kO/QYjT17gmnTflOXGVXakKVhQflDAs5HWpfqyF4bJFNILm6+5R?=
 =?us-ascii?Q?7BiFwKcSv53/D1WbnZdBbgJKmGjtH7nPZPs2K8xgULu2AyVUq+wQ9ztaqVGJ?=
 =?us-ascii?Q?NhoYeVfUIgW0alNa86PkPd08Wtbo41PSUud6J5h+lm3aA8/isDS/px9F0p+5?=
 =?us-ascii?Q?YGDFjXQiV53RlqTXb+CQxmkCfmGB6w0c8q2jSdeMXo0u1RuLGftqra5TBsaO?=
 =?us-ascii?Q?ZRESxwc4gs2xwmMFTSFURYhaHAKUkV/1/QW7vqXRwofYkOdZfb7VG/mA0FU7?=
 =?us-ascii?Q?7K6CQNWghddenFwIVExmfsHFh/sLkccvbi+QkBXCCn5XmmZbqMqivqjY1AYf?=
 =?us-ascii?Q?2PZ6AAu52W36OiOc6iDplpNzEukUnpNViCE7tAa0gtOoHVRlmi9fBt91ReVI?=
 =?us-ascii?Q?AY7fD37DBR3SJ1NcSK5MC16DaC5fKH8yNJKF0wwqmxM7f9igX5LShKY12no3?=
 =?us-ascii?Q?AEda5agbGcHS6vpkYBPobgu1YIvBlZV0grE6n0Y7+V+hdynzFIGYcTQx6yzz?=
 =?us-ascii?Q?gvNGBzJC4sIKcgQYcgmrYeD5ygF1H0F/5Jvin2dMafHSfg519lJxMASsFL7R?=
 =?us-ascii?Q?zY9YkHo8l3azN3sR7IFXUUTLpvtQ7wHVKTbX/z7cokUcuyLgmw5rJYYV1aMw?=
 =?us-ascii?Q?06vBiFGUQvPFPXUJDVC11lvk2xMTOj9sLb6aq5ZfVyQ3hC7QPb4M+57mRAjt?=
 =?us-ascii?Q?gSP/hPPEsNPQ/PmtQE3s9g5YH/yW6xDTs/INXf3iL2++1Plnqt6Vh0DUU3/K?=
 =?us-ascii?Q?tmh/dqPdTNwWocgk5akFfhIZEgIBK+hiPjvXtsRycWOXyFDskPzYK/LsS/HG?=
 =?us-ascii?Q?c6oukOd4WekljrvLqdRBqm6yZ4l5GpJP2+Cnwz6U/WFs3304zPrJn5udT5EM?=
 =?us-ascii?Q?i9hWI07NNSi27J1B3WqIQS0rSmYLXd5VsmJgXYJ+3cn9eS6BU84fwyj5Gco9?=
 =?us-ascii?Q?YHXEBo/pO3AVVU43hYXWYCBo9Qzxu5TKea49riUVNpyvuW2dkd/iKzJV0m3j?=
 =?us-ascii?Q?CBRHTslkXoKXpkvPOmc3rpI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c02d13-d7cf-4fe2-ed4d-08d9ced27ff2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 16:02:53.2998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HNo0PYZU20LKixKqiP3JEXt7ZY4wPy3NoqTYcU/ERd0enK0kmcbGi+R8k38S4INVR3Tg9x57nDhSQgLLiXe1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR18MB4846
X-Proofpoint-ORIG-GUID: cpbDmuMYsoQlnSTnT75W7uqmu7iGWZ6j
X-Proofpoint-GUID: osSY1PK3R17o3jBwMh73B4fQZZkPo-ha
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_06,2022-01-01_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Himanshu,

> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> Sent: Monday, January 3, 2022 6:22 AM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: Martin Petersen <martin.petersen@oracle.com>; linux-scsi <linux-
> scsi@vger.kernel.org>; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH 14/16] qla2xxx: Add devid's and conditionals fo=
r
> 28xx
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
>=20
> > On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote=
:
> >
> > From: Arun Easi <aeasi@marvell.com>
> >
> > 28XX adapters are capable of detecting both T10 PI tag escape values
> > as well as IP guard. This was missed due to the adapter type missed
> > in the corresponding macros. Fix this by adding support for 28xx in
> > those macros.
> >
>=20
> This patch seems to fix more than just IP guard macros.
> Can you please seperate T10 PI fix with other fixes from this patch.
>=20

Thanks for reviewing all the patches.
I'll separate out the changes as part of new series.

Thanks,
Nilesh
