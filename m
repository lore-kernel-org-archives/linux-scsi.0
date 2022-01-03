Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4238C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiACArz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:47:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36924 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACArz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:47:55 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2029CSHf008576;
        Mon, 3 Jan 2022 00:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QscKUacf7tXHVvvI0J8sD78JYj3CDhZe7ltLVgw7P4o=;
 b=vkvUz9nFwxpgu7Qy6oupuQcop0hN+eMu/81/qXyEoa23VOBT5UfZlLmlLSyiFe7xreXD
 WVjy/J6qdIZ+EO8p/GqEQfwj625PIoTk34ydGeEJ7e+XPjYLHzVk/wx1T2cViXiGFIUQ
 n5rartUtuauryy1WKkEbxJc4FjIeiLN7lYnfvFTNR3RWum2U1HMcljELef2roomN0thp
 cBTvZ/EfOp/dR5w7VzfMxfLWVDOSqa9NJl6p0I3Mp3JvW/948YJo/qy/12qoHhjfOOX+
 c8wLwjRI2WB/A/LLowr2mvxd0Lm6EMQOIsFDGvOtl9PsKE0KF+RPbHv/N27O6d2wtx2z PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daeuahpe5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:47:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030foX6118643;
        Mon, 3 Jan 2022 00:47:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 3dac2tujrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:47:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtjDO6D8xarNlU/V2pjekiNKPPF+5r16S1bDYqUpMaWOWmZg6X+E4tJzLc6nWsPHO/R2OOoESmdcU2HLNVd1W/AhC0flWsdBCfzx8lCM2hk5jSZlbotrQ5Mh8H32AL/8qntkYJaYlxVn3V+N9GQFLukQo7ourZWtfNlc01p72kMO65K2ZZFGoaS3lYN2myTWkAS3dUwQSnDv4lv5Wt71KU7s8950BUJ2g11OW8OBNnASDAYwn5h8Mg0gNFHbEAZRfWM+mTIoIMif+Nwm+SHhPq5wPtDhPPTwe/LYDOAEWrTco55UQrnDD/WKSBzG6PukpRGa2D/zqT1a05d4/8uOcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QscKUacf7tXHVvvI0J8sD78JYj3CDhZe7ltLVgw7P4o=;
 b=g5huxRPD5C8ol3mURCS0iDjYWh/DII4o7g4vX4RNFscrJTVoGyfDuZ2sWV2xB/3wvNH/XaKZZgl52I1CbIUI2KxO8B7nO2jiudlUyTF7x5IGwIkP/vj9j4iQ7uezBUGmNykGSgeQ4cVp50i6vXjr5n0+/ezAFxlcDr83+KtPWt/oROdIh+fkDKWWQ4zk5nE7NjaBnKjoz0HWpHVqmfimfowdTq5uRWhyo+F7mbMybDsrllfmzu0AEPqDBrn1AP9JKwZ0PdhG1epqxHcqfn7DA6Yx6RW6/UPRFC2C2Lf+pMZEbcgOu/RYtKMw02qcAR0b6gW7zX0ExnM80iJ3xqACQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QscKUacf7tXHVvvI0J8sD78JYj3CDhZe7ltLVgw7P4o=;
 b=wcS69LeJoDnzhhy6LOAZRXsotWgi/TrqGjKKONCw0ssqvvwwodrG0rXyhqshphxkGAiZztKUSHV+S5hUkli+Xmt7rk0P4bBm1XXWEfcINpHwKAwthaWuG8Pv2rFDlaqW3jS8HV6LWw1NJv8yEu4F8eo46M6Ikp6p622rOUQEueg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:47:49 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:47:49 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 12/16] qla2xxx: edif: Fix clang warning
Thread-Topic: [PATCH 12/16] qla2xxx: edif: Fix clang warning
Thread-Index: AQHX+JUCag2/KCy4kUu2vASHuQbbxaxQheQA
Date:   Mon, 3 Jan 2022 00:47:49 +0000
Message-ID: <103B5576-64BD-4A40-8826-65E75C00CA34@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-13-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-13-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 935cdb5b-5041-4dbd-fe7d-08d9ce52aa85
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB57109BD6F536019F099791D4E6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:191;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CBQc61pUi+beoZIONzbUYd+qBlOuTPDitks1ltJ+cAkfcw9FbdlarhTOXEkV6Vl2tgnV+WugyHV1QRh+RS3uWLB/Qbi9uW5iOODNokqqEf3oRdDGa1stnQyBxJ/k3rpwduRd2dHRXpGLEiiyQqh54e+5YJmK2Sk26zgIWD1o7hIK5KXrT13TJaIqSRo+ywJAfVG705EGzn0JJ2hA2S/qnmYuB6aa+u7tIT40ZsrPIsgEqbJ0PLwJO1MxECCyufdmKLj3NURBjcv3eUUD7SbWbH8KbhKKAgPI0OT7o0ui73T7ZHLXftQrD+riwQEfebVyxj4UF2UGvRUuKH0rnGisEqIcywYL9kv1+J9FtfjVu4UvzdMGxlcNburqGy57w0w5kkfPe2MyLXUtBTG+8JEB8YAREqdk5kiQMMBcuECYn2vljXqRpVAx+2mmgLumLkEg0diNrhikJwV/SpurJkCFtpy0xfxPJVTHyAPKqh1+vTzNOLkSW0N3Ybeopmr3zc/7Fsr3x7tiQnaWYB/TcqkB84N0/B0QgmGvRnyjy/shevdaUCwHqzj6t+A6I3gvV5DtMxll6usZE4ZHPtTPTWk13znLBbf1veZNmYxKkhoxOzrTV7Kip+I2aprUWDxK4eUSB2wSp9q4JJq42dC20mpS+OFIt50LQPxlnCqYpAdVflMMCZi2QUGkcTMkyJntgVjtmWO8Nq02eOfnRUMDE3WrzdtjpPLleMzB1/UuqAbN6kY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(71200400001)(122000001)(64756008)(186003)(66476007)(86362001)(8676002)(26005)(2616005)(38070700005)(6512007)(83380400001)(316002)(53546011)(6916009)(6506007)(66946007)(66446008)(76116006)(36756003)(44832011)(8936002)(2906002)(4326008)(6486002)(508600001)(66556008)(5660300002)(91956017)(54906003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7LeILtecromE2Wj5B7Qt13pE29r+rf+v8zJXE75YrcmV5E4+fvuyLu4ww316?=
 =?us-ascii?Q?nsdG5N42zu5zKEfaZHTk5+QVnbocDzSBV8bstljWp0sFpZxJsJa5JfZZf3sc?=
 =?us-ascii?Q?uKgMZSEh4QF1y36Sp1hnvuMikdP4HDcKDgH/NxslcbEdXskvl5yC8KyNzAXz?=
 =?us-ascii?Q?sbwJaWqppJJgkhvMdqtCd2aPnkFv9o01yDBP+6lUTARxs5SgZsl/b3ghKE0b?=
 =?us-ascii?Q?zsRVjPV+fB9d2lOK9btjdChv4Va1YQ6F9kF5CN9z6fJwWamtSCASIgahfEF8?=
 =?us-ascii?Q?KSPipzm5adXQ3UF3cMQqJa6kAStI1TH2Xwc1ifWjDKKFIlob1fL7kKAg57eg?=
 =?us-ascii?Q?bCsTgKJqlg1YsV3rckRZVYiXPzJCrH1TyMKQ53AQqWQkbTcZh39nbScYGCra?=
 =?us-ascii?Q?jDG4CUgcg1YDC7gvT2KWEZJofzpBlCkJxjJvjNJ+zVokfBBrm9t4QjLP4N/t?=
 =?us-ascii?Q?06WaNSyHakvR5tPOg0VeUDz2slq0YJNWb0jx64aMOuQsNOqNYKgzl05SX38q?=
 =?us-ascii?Q?HDnNkoGga5KvW3dKEyBLlmFEXkhA7+Zf27jsTOO/t3yZvq2qpqtOagl8IyFQ?=
 =?us-ascii?Q?aGvHuYD/2+s9RW8pwlRpejUDfLjY5rm7CEVVGdGhNbNfswmyuQ2JGKfKPDI0?=
 =?us-ascii?Q?fPDhFN1/NL442dOUfNvDmBxRtLJUXziEhJoRBnxlWSz3CEfxEheWAxhn/HBM?=
 =?us-ascii?Q?RJiPjYhnQ+MWjA7q+2HcACrJ7mN/QEB0zyqPLzCysgfAKwnE63U4AeAbBLOj?=
 =?us-ascii?Q?i4VPH9bi1yu/km457XJnAYrQfr+HDoSn15b0zc2wFZ4r/5CdYSesHypuKy7R?=
 =?us-ascii?Q?HylOYZ26LB7PKgDC66MkKPo2ukTxUMdFtujw8ZolC5Vq/1GeXuid1f17wXhv?=
 =?us-ascii?Q?fUCtg+680zhC48bH4bEB5yNFFHUqG+sJWiBzxoniPuZz6PMS2AOuyrteVcSS?=
 =?us-ascii?Q?A1Er0nY4sq7nMevomk7/qvoZ4ff6iuyMqVSPSlnBZvkW7BTq32BMwdzU9smi?=
 =?us-ascii?Q?4YHwvMqetSEYFzVfW3A/XKNzLhQh3elB49huhA5Ny5EOAa/odkScqAg/+yGT?=
 =?us-ascii?Q?t2mKWd+PfAn/JkBH4LcvBUMyoz3EYgH+5oemjxcCpOaT1RrueAHVh/wyPTzA?=
 =?us-ascii?Q?fFfGey3F7CI84bcCKsf23A9LtttF5rMxMCLiVrwG0uCtx0qkxuO/vbT8kQJc?=
 =?us-ascii?Q?mKswzr0R4aN6BpuO2gye1dOHAulRryndLE5ITOKUDBDvas7GrntaqOyDdjAA?=
 =?us-ascii?Q?Tdg5pMmsE6TeTBk4nvCOP43Z7Uq3mlSaGdImmKiMD0X45bmRqweNIfHj2+a+?=
 =?us-ascii?Q?LOgCT4bk0q7pYTiGWfBA4p0DLRVFlMfIUuEU0Z1XUo5SWudsYx1DS9vNYnY5?=
 =?us-ascii?Q?9c6HyelBhGOhvQgyfCg8eS0atADaL++dk9slwrNBobHcdtxhi07Q07ywOT/p?=
 =?us-ascii?Q?yJZqsCy+URT2eQcLxFXAm731ta60JIavEB+nGxnV+a7nnq5+R/uJZjof71NN?=
 =?us-ascii?Q?WrMn1G3J6uJa9Nop3vKlFPJ+5sCRw7ubzwkO5kG5mzU3x7RTBuBaUfUDENNu?=
 =?us-ascii?Q?q4TTHJHwExWdler+7xIgpq8WfcU9Xec9VaeEZLwrLVNIEGhZjCMnSn7m9x9Z?=
 =?us-ascii?Q?bjcDIO1Is5rYQzD+76O21zKbxQJjYO5wfK0TG52I/w7iu0Rr2pYlcLcQvUE6?=
 =?us-ascii?Q?i0DxNZPNBzAPT75USX5xzetR79U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB0E02B50A190744A9183D82797F083A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935cdb5b-5041-4dbd-fe7d-08d9ce52aa85
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:47:49.2715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqLkdX0i34nV9nroXS8KXrhLfQohsRvq7b/p6E+jWcvvME95OPPNgMvZz+yqPTiyUwAej9hOcyoMSSW/RrgHSgSFtjMX+r9eMK3erh+Ga9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-GUID: hpOd1NA7EWInGFtFUHcXXL9xpvDrsvWY
X-Proofpoint-ORIG-GUID: hpOd1NA7EWInGFtFUHcXXL9xpvDrsvWY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Silent compile warning due to unaligned memory access.
>=20
> qla_edif.c:713:45: warning: taking address of packed member 'u' of class =
or
>   structure 'auth_complete_cmd' may result in an unaligned pointer value
>   [-Waddress-of-packed-member]
>    fcport =3D qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);
>=20
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c | 22 +++++++++++++++++++---
> 1 file changed, 19 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index c04957c363d8..0628633c7c7e 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -668,6 +668,11 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg=
_job *bsg_job)
> 	    bsg_job->request_payload.sg_cnt, &appplogiok,
> 	    sizeof(struct auth_complete_cmd));
>=20
> +	/* silent unaligned access warning */
> +	portid.b.domain =3D appplogiok.u.d_id.b.domain;
> +	portid.b.area   =3D appplogiok.u.d_id.b.area;
> +	portid.b.al_pa  =3D appplogiok.u.d_id.b.al_pa;
> +
> 	switch (appplogiok.type) {
> 	case PL_TYPE_WWPN:
> 		fcport =3D qla2x00_find_fcport_by_wwpn(vha,
> @@ -678,7 +683,7 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_=
job *bsg_job)
> 			    __func__, appplogiok.u.wwpn);
> 		break;
> 	case PL_TYPE_DID:
> -		fcport =3D qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);
> +		fcport =3D qla2x00_find_fcport_by_pid(vha, &portid);
> 		if (!fcport)
> 			ql_dbg(ql_dbg_edif, vha, 0x911d,
> 			    "%s d_id lookup failed: %x\n", __func__,
> @@ -777,6 +782,11 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct b=
sg_job *bsg_job)
> 	    bsg_job->request_payload.sg_cnt, &appplogifail,
> 	    sizeof(struct auth_complete_cmd));
>=20
> +	/* silent unaligned access warning */
> +	portid.b.domain =3D appplogifail.u.d_id.b.domain;
> +	portid.b.area   =3D appplogifail.u.d_id.b.area;
> +	portid.b.al_pa  =3D appplogifail.u.d_id.b.al_pa;
> +
> 	/*
> 	 * TODO: edif: app has failed this plogi. Inform driver to
> 	 * take any action (if any).
> @@ -788,7 +798,7 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct bs=
g_job *bsg_job)
> 		SET_DID_STATUS(bsg_reply->result, DID_OK);
> 		break;
> 	case PL_TYPE_DID:
> -		fcport =3D qla2x00_find_fcport_by_pid(vha, &appplogifail.u.d_id);
> +		fcport =3D qla2x00_find_fcport_by_pid(vha, &portid);
> 		if (!fcport)
> 			ql_dbg(ql_dbg_edif, vha, 0x911d,
> 			    "%s d_id lookup failed: %x\n", __func__,
> @@ -1253,6 +1263,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
> 	int result =3D 0;
> 	struct qla_sa_update_frame sa_frame;
> 	struct srb_iocb *iocb_cmd;
> +	port_id_t portid;
>=20
> 	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d,
> 	    "%s entered, vha: 0x%p\n", __func__, vha);
> @@ -1276,7 +1287,12 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
> 		goto done;
> 	}
>=20
> -	fcport =3D qla2x00_find_fcport_by_pid(vha, &sa_frame.port_id);
> +	/* silent unaligned access warning */
> +	portid.b.domain =3D sa_frame.port_id.b.domain;
> +	portid.b.area   =3D sa_frame.port_id.b.area;
> +	portid.b.al_pa  =3D sa_frame.port_id.b.al_pa;
> +
> +	fcport =3D qla2x00_find_fcport_by_pid(vha, &portid);
> 	if (fcport) {
> 		found =3D 1;
> 		if (sa_frame.flags =3D=3D QLA_SA_UPDATE_FLAGS_TX_KEY)
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

