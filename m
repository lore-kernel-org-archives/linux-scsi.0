Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BF6C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 566F361038
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhJUOsu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:48:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29848 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUOsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:48:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEYM9b013671;
        Thu, 21 Oct 2021 14:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jhcjKU3/ooq8kJaJ5RqLQuFusA331F5CVcwm3TiTmxE=;
 b=gVFohxa69DJ3a5oFvPrQv0bXldbyaD7DiaK/aB7d8VlPpGRjKbw+w7Qg9LIvlOOS8SYw
 2WUEur0Nya8R9bktpniblAC/j+GLCXonV1O7R0uHDKhywd91mCVZjf6RKa7cOem6mvwc
 NRX861A24I7YMJXFh6Hz9ETvqKwdlQWPuyVDgRzzLlL6+g81qKuUiibm7Loi1HMMNErT
 xKQ/W9TAUR9KYSiylfeDZIvC3M2D9y3997V9HfM1qsc7JdyHdsyHsvqxPorDJNRSnF55
 QtiZreXFE4vGirDDYBJhfSZwGBx26YISt4x3Llgz1Oe7UfvCRf3ef87fddJ2tH1Je0IT VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btrfm5aet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:46:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LEZMdj173347;
        Thu, 21 Oct 2021 14:46:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3bqpj8x617-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:46:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzwosdodbXMeiWo/jBgnoDIq5vvv5G8yfjrKDdPBKLV3gbKmy5ilCY3Np46q78qn69FdN/pGmQsXjIlKJTkOmaJU+dLmu6k+wFTdLYdWXueI4AO/xH+MymALJa3jIqIuT1Vx8ZPG8U4PNlFA4VAdHjZiC7wvH+Lp5tj+8gDtdUIZk2hTuYtG+AAO1YiuBs7reFhGgeyQOSCDahIPJykA8m5XoJ96m0m6H0NQlqEolj0BOp9SF1qbLtWgc56wEyTXzyyAy+7w24icwZTEwcUghFbOxmBfhH+S3krXGpAOplmBm5Cq5tqOktUDuJAmw8FE5505E/eH4y/lbbP3ULLvWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhcjKU3/ooq8kJaJ5RqLQuFusA331F5CVcwm3TiTmxE=;
 b=DE2O97I+d/lRwFW1lRP29BMaAo32bo0ymXagwuo5X60BRXsNZ9PRJQIUe+aaODWi2qNAYdUWYB4DHzg+9oJaRJ6V6AraDQIZRTN8t7lnfnQLWwCTUjZIPn0oC03ue1oOglkg4aAeD5pBL5e4wHZg7cOAeYbDMDW4QMmHJhbWszgQI9DC4kAIQBCVn8Og6M+dsvZmNEcnQ64i5ZAjmnu7QSQ6irX0VSH9fQw+GmU6duXXTV2yRf3IEK3I6EjfHA/3JzbnIUyjZAkpcM5asiDZY4pSgFpjbesYsRo2sheBO9no8HhOSk4qbKIq323GMlX0AidNh/tdzU8EPMFDvJTxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhcjKU3/ooq8kJaJ5RqLQuFusA331F5CVcwm3TiTmxE=;
 b=fJO1IfIkt0Ckb8YAa6axX7OD6T+rXoyt8s3/8zg3JQY+iBxt2OjeCgCGKF0XzZISnjqdcXouq6yBjYddr1OxLLZiGFyFMRvlUNIXqjX469m625t8uQTEaJtWWQpt5qLl0irPmNBeWV07j0uG5sAWVdkTjFuXjfn0vOrOEjYd+5w=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB4351.namprd10.prod.outlook.com (2603:10b6:208:1d7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 14:46:28 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:46:28 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 12/13] qla2xxx: edif: fix edif bsg
Thread-Topic: [PATCH v2 12/13] qla2xxx: edif: fix edif bsg
Thread-Index: AQHXxk3WLoZxylkuqE+8qnGvd5UoV6vdiD6A
Date:   Thu, 21 Oct 2021 14:46:28 +0000
Message-ID: <170996BF-0BF8-4B01-B487-9D8D7ED4ECDF@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-13-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-13-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2970ef64-9f67-4db8-5788-08d994a19066
x-ms-traffictypediagnostic: MN2PR10MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR10MB4351BF9EDC24B3AF91C02CCFE6BF9@MN2PR10MB4351.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TSmhB1DYsykvS+p7Lk/O809TKSeYf0kTZdL8L/5Lk2+jFJQ8gXi4pH2jNd+7dueQYJnX3fEFiOSCm5SSehnEA5+nLR/Q/E0ni6Oe+6rgyzeWYcNVEq9v3LL36FlfCmDe4QAZjZUJyvjOQIuQtmRqkhh2C9x4ZTfYDgxoE1BaRV/358FXxkO2IDTjkxuvZFceyDGRB+ySxd1EPjfwbWlmUy+EH3tzB1GvG3w0CQ1tBjZ2YQ4ltEAseZvhFV8AieF0qxc4pumqGozlSw1/Z+HgVU2fKPt7YXsR30cN2z+InBUv8GrbT+TtCqDqtiBYN6JWPt7BUxn+7K/1XlpVBibbnNMmUCT8CkqXqYdLKA/bLZvstWd0FhtkasSGN7H636mDWYe+cegTtosLtg/ZoQja0SYDg7YmE1nsN6lJ8jP1JbXTFJ082tqbt+wQs1SVVwyIpLkUK/gZjvDAER7pGwqva5YtmdZzBBJwag5BAsgNjeMtfGM8/qBsPeYPad/BDXgtRRNC7bHze/9vy7sJXlm6aKuxp/19DcZVnjHmPTMyWnpEiK983qI5c8etQrDg+lTwKLbjVvoPfevkEpCgiC6UvjrxZ7QsTYknaL3fWOcJE3JVliObbhiOabvc5Y46A82t7/OkirrJWwOMn5P34E+AomADtzYFHMCS3PwulKpYX1O5BZLXSxgJfwKFSGxRLvPQaOwjGe1pNL/MZm/5KyJR5to8Pv62QYT+X20a2fHD6i2NdJbdlE+tmmmFKwi4p/mB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(186003)(8676002)(53546011)(122000001)(33656002)(6916009)(76116006)(26005)(6506007)(36756003)(38100700002)(86362001)(54906003)(66476007)(66446008)(66946007)(64756008)(4326008)(91956017)(5660300002)(508600001)(6512007)(44832011)(83380400001)(2906002)(6486002)(316002)(8936002)(2616005)(66556008)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g6WAxyVxkjkNmk2OO/5YLWY9VN3GTyB/we7+8OvBjpEbmTJNe307SHdoZYhu?=
 =?us-ascii?Q?M/AnanwfgcbLG32bla+52fNe+om88s+hhT/+gHTVmcwU1WUKRzct2IRb3mYJ?=
 =?us-ascii?Q?T8AuVOL3VVvm1pwLM7DXb6e10DTqh5qECWoog4Zd3eiN5b2dx/ZhlXngkdkn?=
 =?us-ascii?Q?19EW7aZC4hpXL2TXqf+bEiLjqFaGwT/LT9Rd5ZurdDIyVCGrn4beCNUxDhIP?=
 =?us-ascii?Q?ER7eZ6LFPO8Hib6ihObOmLLDF3nKiFuo8o4zjQWf+8Kb7LYyjsjM8lj26oGJ?=
 =?us-ascii?Q?EF8N9Qn3Yo7nuMiJLlpLP6ROXVsc+wwql5Z+EAKXdXjCHMNhHIpFAA89csbE?=
 =?us-ascii?Q?PTiobFbJuOYMZT08RVMCDKpbinVgTgorLhc1G0ZkTXLkyTLDNIXLHO71bfFi?=
 =?us-ascii?Q?OBzUW9Ose8ruN1up/VBz5Bf8fOWA17xI2vDVNPVWU8Gxw5ZGD1v4uWM21wTV?=
 =?us-ascii?Q?xPR3BPrcYvIkYCp+lsBVF6FAKwxDeIH/wmP9pcGVneYyYWeRyYR+kVDniDOr?=
 =?us-ascii?Q?22P3f2EpA2vI1ylZ8XzvSfN87BpIL3jtc9X6Jc+l2jB9jwr5+ydOHysIrSg8?=
 =?us-ascii?Q?PgbIiL8sGAxf4J0Znb/FpBY+ul4V2m5OvR5t++xYlPRIOHO+NLgZlAQx1B58?=
 =?us-ascii?Q?xYKq+DDb0UZet1kHg4tWYZYqMezgRdo/GSrxWp6f5yEFu3q2eo4OdRswdfX8?=
 =?us-ascii?Q?G8ZGDISeXty1bIbnunnTt4CkrnMDIRmg+9Pa2JJH3lVVwlEpC+fqLGkVSrXU?=
 =?us-ascii?Q?lZFw9/tDaFrYj+IRZ8C3KpFeITJlAugYkA7IzW2FdrLtbNx1ze474Oq2uDfq?=
 =?us-ascii?Q?jvrlles997FuD2gdiJfiqTLKuugQ1nVjtawDP5rZDrPEtrdDpT0DNm/1mnUb?=
 =?us-ascii?Q?fCspXqw+0WAWGFa19y+BVjYu8GUD78QUSNgNYO3OxUFeTvToLo9pDHIza7dH?=
 =?us-ascii?Q?nU0uUSQrU6ejJWZKB4nG78IJnIKBikirjwyaMq2Hq7ON799ng6gM5ezrwuB6?=
 =?us-ascii?Q?KzZ4xYDG+7Jj1JW1Vzeht2obrGo1bMD3HQH3VO4WIn9xMEtjOzOEgB9oajfx?=
 =?us-ascii?Q?3sSDa5RQ3U0ajmXrE9w12VtLtMvnLlpp97DpnAGRcLcg9dNNlBrrRXFjh1h0?=
 =?us-ascii?Q?u8eNeHCvJHZ2/rjvp9gbvzoXgujj8VPPXca18CA6Nn5aVCPN5R0Kzz+UPGWd?=
 =?us-ascii?Q?GhX6CCl+Nb+UmWRxVo0O+gOcNGiE6TJSs5uLGXqMhTKkIJQm1Tl0IFrvnc2S?=
 =?us-ascii?Q?oajbIfka8bELQhuTLgDcJ3Zaxr3McvBVkugjkHA7HM7fbjiahngy96KIL7G7?=
 =?us-ascii?Q?k38MG9vxhswPKHng7A3jD200a9OWY4pqPklWvMczjA+0Hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E0EA01963662445B865F69E24033011@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2970ef64-9f67-4db8-5788-08d994a19066
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:46:28.1518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4351
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10144 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210078
X-Proofpoint-GUID: ZQ2Hu6pvwyQTWZJASIGZ3KmCnQpSN4N6
X-Proofpoint-ORIG-GUID: ZQ2Hu6pvwyQTWZJASIGZ3KmCnQpSN4N6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Various EDIF bsg's did not properly fill out the reply_payload_rcv_len
> field. This cause app to parse empty data in the return payload.
>=20
> Fixes: 7ebb336e45ef ("scsi: qla2xxx: edif: Add start + stop bsgs")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c | 49 ++++++++++++++++-----------------
> 1 file changed, 23 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index 440a3caa28f9..68ae7ab43d0c 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -546,14 +546,14 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg=
_job *bsg_job)
> 	appreply.edif_enode_active =3D vha->pur_cinfo.enode_flags;
> 	appreply.edif_edb_active =3D vha->e_dbell.db_flags;
>=20
> -	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply) +
> -	    sizeof(struct app_start_reply);
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
>=20
> 	SET_DID_STATUS(bsg_reply->result, DID_OK);
>=20
> -	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> -	    bsg_job->reply_payload.sg_cnt, &appreply,
> -	    sizeof(struct app_start_reply));
> +	bsg_reply->reply_payload_rcv_len =3D sg_copy_from_buffer(bsg_job->reply=
_payload.sg_list,
> +							       bsg_job->reply_payload.sg_cnt,
> +							       &appreply,
> +							       sizeof(struct app_start_reply));
>=20
> 	ql_dbg(ql_dbg_edif, vha, 0x911d,
> 	    "%s app start completed with 0x%x\n",
> @@ -750,9 +750,10 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg=
_job *bsg_job)
>=20
> errstate_exit:
> 	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> -	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> -	    bsg_job->reply_payload.sg_cnt, &appplogireply,
> -	    sizeof(struct app_plogi_reply));
> +	bsg_reply->reply_payload_rcv_len =3D sg_copy_from_buffer(bsg_job->reply=
_payload.sg_list,
> +							       bsg_job->reply_payload.sg_cnt,
> +							       &appplogireply,
> +							       sizeof(struct app_plogi_reply));
>=20
> 	return rval;
> }
> @@ -835,7 +836,7 @@ static int
> qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> {
> 	int32_t			rval =3D 0;
> -	int32_t			num_cnt;
> +	int32_t			pcnt =3D 0;
> 	struct fc_bsg_reply	*bsg_reply =3D bsg_job->reply;
> 	struct app_pinfo_req	app_req;
> 	struct app_pinfo_reply	*app_reply;
> @@ -847,16 +848,14 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct=
 bsg_job *bsg_job)
> 	    bsg_job->request_payload.sg_cnt, &app_req,
> 	    sizeof(struct app_pinfo_req));
>=20
> -	num_cnt =3D app_req.num_ports;	/* num of ports alloc'd by app */
> -
> 	app_reply =3D kzalloc((sizeof(struct app_pinfo_reply) +
> -	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
> +	    sizeof(struct app_pinfo) * app_req.num_ports), GFP_KERNEL);
> +
> 	if (!app_reply) {
> 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> 		rval =3D -1;
> 	} else {
> 		struct fc_port	*fcport =3D NULL, *tf;
> -		uint32_t	pcnt =3D 0;
>=20
> 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> 			if (!(fcport->flags & FCF_FCSP_DEVICE))
> @@ -925,9 +924,11 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct =
bsg_job *bsg_job)
> 		SET_DID_STATUS(bsg_reply->result, DID_OK);
> 	}
>=20
> -	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> -	    bsg_job->reply_payload.sg_cnt, app_reply,
> -	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt=
);
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> +	bsg_reply->reply_payload_rcv_len =3D sg_copy_from_buffer(bsg_job->reply=
_payload.sg_list,
> +							       bsg_job->reply_payload.sg_cnt,
> +							       app_reply,
> +							       sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) =
* pcnt);
>=20
> 	kfree(app_reply);
>=20
> @@ -944,10 +945,11 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct =
bsg_job *bsg_job)
> {
> 	int32_t			rval =3D 0;
> 	struct fc_bsg_reply	*bsg_reply =3D bsg_job->reply;
> -	uint32_t ret_size, size;
> +	uint32_t size;
>=20
> 	struct app_sinfo_req	app_req;
> 	struct app_stats_reply	*app_reply;
> +	uint32_t pcnt =3D 0;
>=20
> 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> 	    bsg_job->request_payload.sg_cnt, &app_req,
> @@ -963,18 +965,12 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct =
bsg_job *bsg_job)
> 	size =3D sizeof(struct app_stats_reply) +
> 	    (sizeof(struct app_sinfo) * app_req.num_ports);
>=20
> -	if (size > bsg_job->reply_payload.payload_len)
> -		ret_size =3D bsg_job->reply_payload.payload_len;
> -	else
> -		ret_size =3D size;
> -
> 	app_reply =3D kzalloc(size, GFP_KERNEL);
> 	if (!app_reply) {
> 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> 		rval =3D -1;
> 	} else {
> 		struct fc_port	*fcport =3D NULL, *tf;
> -		uint32_t	pcnt =3D 0;
>=20
> 		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> 			if (fcport->edif.enable) {
> @@ -998,9 +994,11 @@ qla_edif_app_getstats(scsi_qla_host_t *vha, struct b=
sg_job *bsg_job)
> 		SET_DID_STATUS(bsg_reply->result, DID_OK);
> 	}
>=20
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> 	bsg_reply->reply_payload_rcv_len =3D
> 	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> -	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
> +	       bsg_job->reply_payload.sg_cnt, app_reply,
> +	       sizeof(struct app_stats_reply) + (sizeof(struct app_sinfo) * pcn=
t));
>=20
> 	kfree(app_reply);
>=20
> @@ -1074,8 +1072,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
> 		    __func__,
> 		    bsg_request->rqst_data.h_vendor.vendor_cmd[1]);
> 		rval =3D EXT_STATUS_INVALID_PARAM;
> -		bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> -		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		done =3D false;
> 		break;
> 	}
>=20
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

