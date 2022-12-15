Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEC5C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 16:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiLOQ5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLOQ4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 11:56:51 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8303D397
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 08:56:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn45A022200;
        Thu, 15 Dec 2022 16:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=R3BGilcb5CyoB2EgP/lHqU8DHhjyh8/09Ob9WalpQ0E=;
 b=l/52z+x39QH2onx2gyyqzSFZtMU/G2YucrUFRWY2Uy7VyGJoP6wkc1Ut1JlbszS6YAIp
 mCoJnLaW+fTt51adqFf11zGgkYn8l0adgwqZ3rdY78eI74qZmPre5yuetC3DRgtleBdC
 +1JwMJg4kJ99x7/IFW/dKSytYkNF+J/oOD3aRH5um0TrCLICcjZDfG30OnU03ilO3fjD
 lzIcTEBUKaI0qDBojpY2Sk0Pfjc4g9J7Uqp0O+qvXWtrtENyb/SxEre3em7FS/ir7s9I
 u8WU0fQk08RM5m8qWO3atiHJrnDc6lAlz9BS30hd+trASomBUFcgV/SIWL+DEwsxv+yv AA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewwkkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 16:56:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFFtP9w028856;
        Thu, 15 Dec 2022 16:56:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyey1tju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 16:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMT3K92/9K3SoKUdaPzkUFIZxgq+GFk9USlFsIY+7Oof+bhoRblYBIMtg+9kUKDM78G4hs/2Yo631rfkdc1YAWuYSIKYGyc6fuon2elvqeE/qjJVd8DFitJMcunRJnlqLaw7dR1HCbIqdIOPUtNzP2pJrpYYG3GwsKZ0qoemaFGHbZl4gml0q6Inpkxwilmm01DJug79iIulWiZGPqq78JFG34F9VgLsO7OXGC2tzGtkRgqqKWNddlviwk3berPukCyCgFnmI3YdCexKX72/f6xlES22Ah1FI2A5SenRT4i1rjNrK3CBNfVrVCB9ALadAunWLGeQmh0zLOPjQX2ySQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3BGilcb5CyoB2EgP/lHqU8DHhjyh8/09Ob9WalpQ0E=;
 b=girPA1XaFVZmKaCFM94BHmwGy0jReLnWYyWUB/+nO8XKSB86n18WY92K1Wdms1JPJw+KSR2GfXexpw+6NVM96ttAAsqI3MB24pua+bGocPnGSxpUAnrYLMRwJ60A+d9qlHeyS1+f98KYKL7le71X+aBqA3c72XHuZ9VcG7VfIIcgbJoFV3IZq0IfjW50KR3NfYg1xLyrJ09AhYu680P4/W5cXMHJrrfBE97+rvNmqKF3rYnaxyEqH/EXKoA8W8b/xXSN9qOfb9fXuGZjDfuG9C6J+5rTJ++AHYdcpYz7gY0XG14Pf65lre6MFCyATXnUFWUFDGfqQV4/wf9kyl5KqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3BGilcb5CyoB2EgP/lHqU8DHhjyh8/09Ob9WalpQ0E=;
 b=DQ3mldCu3jqMzVf27dm7c/um/gP5bgNVNSFa9pSuUsbo2z4TMCzWRvSEJhbAR0Db0Hwwbl4e2RhRNCNaf0GV2BsQrTl2dMZWnbjvbcZ4i9mWGhyTKcodaF0b061T0PouJSLM2slg8qvDo8btSDzyqiNiy8bXEQFTw78+9/O95Z8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by IA1PR10MB6218.namprd10.prod.outlook.com (2603:10b6:208:3a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 16:56:42 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 16:56:42 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 02/10] qla2xxx: Fix link failure in NPIV environment
Thread-Topic: [PATCH 02/10] qla2xxx: Fix link failure in NPIV environment
Thread-Index: AQHZD3ee/t43k3amPEmZTQZiS0d8tK5vLXmA
Date:   Thu, 15 Dec 2022 16:56:41 +0000
Message-ID: <22B2AF9B-14FD-421F-BEA1-9DB5BB3312D5@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-3-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|IA1PR10MB6218:EE_
x-ms-office365-filtering-correlation-id: 89018bd4-bab1-42b0-bc9a-08dadebd573d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8vDSQLaYUm2n3k5wl87KQVe1o1EzqKVw5UvAeT4wcOTakFP1h3yyT1D5jlV3UR2/U8614IUap8SOOUATYPxVH2CpNw/kk/O0SJ/QO21EvLLl4gMUyhkRKOVlwS3tiFSMu9E5Ef6m1uWcknU55ZAXlSKsmXVr9+sWbsuVH1v+D9KxYLBJ3bd1wJglLIdjPcgAqmILuzkm4hvegE//dm2cdg9aAfgHg7Xm1zuMlnmxBBF3vT27Sv0zPdHPHxmg55eVo+afje+A25yF8fnGEfxe+BHr0hegxXkX3Zbc1NifLNDlcVO4SFCVXBkey4zz0FQyatHYqS5JMz8Cord116tokImu8iLzo7YLQ8poWY9iX5XWjsJmSppkH2ZwC3XB3ZutF0/Bwrs4l0Xkg/7VEJU8dRcNFxa1d3/F7MV3Sm8u+rjgWfPhNo6+xYv//BWBqrArLp8Py3/aCtDtjjeo7FZHHw/PSWdy9VgXFQeNh9s2rfPfA1tyHGkThd+sgqWjV/qFtJve9soawSjRukBQc7noT3Ee1icHWJPaVthJwodzFdeMzK3fs3LLOFwftPB16IM+kLO8f13Z0WPrpxN9FwP62YnbFjq6605NwLXPHlINZsLxTWLezY8AHznQFFD8TTdmpCyepd8i1TLWszOEvEbGEV1N7ldLlH14IL4A877zkydYjd/uIh1AAtbtOb/CtWJxsoV6diSshGJxIy38nT4ufyWjxlarbE47HwMbqxl7XUQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(71200400001)(6916009)(316002)(478600001)(54906003)(36756003)(6506007)(2906002)(83380400001)(38100700002)(122000001)(33656002)(86362001)(2616005)(186003)(6486002)(6512007)(53546011)(38070700005)(91956017)(8936002)(41300700001)(4326008)(5660300002)(66556008)(66946007)(66446008)(8676002)(64756008)(66476007)(76116006)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kssWLVQQESDnocI/r1SDQU1wKkzKIyOUKWhSqL3CG/bcZN4EgcT7XevGVuSQ?=
 =?us-ascii?Q?pItogE9IrB+Bii6l+PXHTcbirI77lI5R5Y8cihhf9st0gOQNHMFWM2mbrzID?=
 =?us-ascii?Q?4GqDnrj4bBIIgDGYxbnmvEpgg17ue2Lcpa3Uh8OA7VnFm4iMPHU6NtIdl/lw?=
 =?us-ascii?Q?01fB1tz9CPJqDxXmiX+xQUqP0as4BzcFRKkeMHTTh8hhf+D3iDDaixxIBejt?=
 =?us-ascii?Q?34n5a+9Q1+n4judX+dAerO4xsUNFl/zSWs/kLXNkw9dI/ceyNLh0XkbUCn79?=
 =?us-ascii?Q?7NUwyPeJvW7a3J693D4uMHORpzVvMTTYi9aJLJ81uVzgyKc0/DY87OePc2Fh?=
 =?us-ascii?Q?lNVwFF8Mj3cjUr1L12luyV2KWpoFdZrFCfLVKSW8YV5yyd1QXm6EGfIu1rqC?=
 =?us-ascii?Q?y490duBVLuBrzTUMXIYDt7MuxKvt3s7NNzhCmAU42vsmTCUT/ZrGDJZs25u7?=
 =?us-ascii?Q?IUnq2vDWI/geIpi8UuqfoqDTHFVZG2f+iIR5DAMbk0Aiv0fcGOWI0HdeC+zJ?=
 =?us-ascii?Q?7Xjl2XGawasRTSK+YSqjYMWLh8tcwMNo2BGMsFsG+cROCx4D5S+4QfNqHUNz?=
 =?us-ascii?Q?xz2eQ+jO5hUgaRYOsx8ypJkpUdKQghnOoNvP6lDZIeT6EM6TmBy9rfip129e?=
 =?us-ascii?Q?jw94dDA9dNEaSN5i2IRNh67O5bfy64LG4xtxofOEIVQyG+cVPr7yWBTheORl?=
 =?us-ascii?Q?umbB/F5ILP640LvYJMJ7YaIDdJZEPaaV4Mn+BLnZlR7hqcm5yeweEb109rNd?=
 =?us-ascii?Q?TBFuWrZKmTIsxNKzCE6rUsJA9jHb5PwZPrNLgUzpQiA35rHMcmE9LpKLy1Lp?=
 =?us-ascii?Q?V7pKxzJS8Mz05nvs1++EPvafAcKl8hwuEnVsXEjri3I66oO8d858dW62uR2W?=
 =?us-ascii?Q?bgOshkU5YBMIuhDfWUc6OjnwPRMsQneVh4q/n1bwrpCzbuoIbkSCKQH+PfIX?=
 =?us-ascii?Q?SNfwuKviN3y/1HYYchw1z747yuZTWDpi6s7RQIwX2Tj0Pdz/F0gfY2BNo4Pb?=
 =?us-ascii?Q?KQUIE6kc7VuBxfcZ/vKGyf+6wO7urqnNyCAIbPc4cR0V6trMgXsmDsLqNEbP?=
 =?us-ascii?Q?Hb8BJh5xvKaO4/ibmbMSdeD5Dk9wTTn3k+9YKOlspkxiD65FB1w9na/rbWKN?=
 =?us-ascii?Q?QRZZ3uuwoLnyCAzo8osbeQ3O0t2+Z0zvxvPAv1/xKE/6IAZiOhB2G0b0rX1c?=
 =?us-ascii?Q?MnWOYE//eYPKNyfwgzHfrf8twEpUPUjd0/MFB6qPZbjoVREymIcnBO54bjmk?=
 =?us-ascii?Q?FCEWj1yRINBqZ0sgLDHtFM0Ugkd7yuICrcs3+6F7HXCoNtBAhPR9gRFCHb4K?=
 =?us-ascii?Q?sQJc0tbNftF95Y425302+UQznCA/f4Gs0i5EK6FUdRHNXVYQhGLNTYiw5YhX?=
 =?us-ascii?Q?AfaV9DyhiKonfMtcT2xANhswynYQYxg6b0zBNovsx+FA/PqD0itz3WUNfv8W?=
 =?us-ascii?Q?QQyXwGuU/i3ziM3f/SPPAsPp4f5eFi3AjBUJ/KCwsBNkFR0UO48jT9uhpVWq?=
 =?us-ascii?Q?vfzodOv6iIzGOW09WisYK99AJxp8g/J75e0pZmdCvmjEJ1undhj1WfQKS9nG?=
 =?us-ascii?Q?eSk8IZnjN2F5EoxIsr9njKLo2GITv6fxsTP3d+mT+E3LIQD+vFpotpch2pWC?=
 =?us-ascii?Q?g9cZxRtWLUK7P6yMijnRzEtl3M1K6OBzqmWNTzRnru9M?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <00C16C1EEA04E140BA60417A466834AC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89018bd4-bab1-42b0-bc9a-08dadebd573d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 16:56:42.0039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SLvA7rvA8aBvYYf8dZmmD6dcTnvOBrrLGipF52Ue1RNoKEaRBeEh9OH+QiGkyMITSsJrJec/yXc27h27oB09HA465FHLxJCkLBqld7In+Ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150140
X-Proofpoint-GUID: UvJeZ7JtENmI8Tz1lr3I7W1-SqL8F0TP
X-Proofpoint-ORIG-GUID: UvJeZ7JtENmI8Tz1lr3I7W1-SqL8F0TP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> User experience symptoms of adapter failure in NPIV
> environment. NPIV hosts were allowed to trigger
> chip reset back to back due to NPIV link state was
> slow to become online.
>=20
> Fix link failure in NPIV environment by removing NPIV host
> from directly being able to perform chip reset.
>=20
> kernel: qla2xxx [0000:04:00.1]-6009:261: Loop down - aborting ISP.
> kernel: qla2xxx [0000:04:00.1]-6009:262: Loop down - aborting ISP.
> kernel: qla2xxx [0000:04:00.1]-6009:281: Loop down - aborting ISP.
> kernel: qla2xxx [0000:04:00.1]-6009:285: Loop down - aborting ISP
>=20
> Fixes: 0d6e61bc6a4f ("[SCSI] qla2xxx: Correct various NPIV issues.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 96ba1398f20c..1fc4e6209db7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7448,7 +7448,7 @@ qla2x00_timer(struct timer_list *t)
>=20
> 		/* if the loop has been down for 4 minutes, reinit adapter */
> 		if (atomic_dec_and_test(&vha->loop_down_timer) !=3D 0) {
> -			if (!(vha->device_flags & DFLG_NO_CABLE)) {
> +			if (!(vha->device_flags & DFLG_NO_CABLE) && !vha->vp_idx) {
> 				ql_log(ql_log_warn, vha, 0x6009,
> 				    "Loop down - aborting ISP.\n");
>=20
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

