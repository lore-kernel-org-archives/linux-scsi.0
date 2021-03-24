Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655BAC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35C79619FF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhCXPrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:47:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33534 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbhCXPq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 11:46:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFZP26161060;
        Wed, 24 Mar 2021 15:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wWrmAd0qz/MQ66vhz8JIWk3Sulqn6PNU0xtsXKitZqU=;
 b=k+fj2cDszRJzMOFlJXGIyipgUAJUuZ4MgRtwKF1Vt/TFrbXpQALi2aFvtHRGpferUS57
 7rLdBbkmpQ/jugDlOm4LrH4lDP6oKC+p5IGrqP32MpKaQqwcxhx2Y+xW5MnyUTRG1x1v
 UxLW2EVi4o2CJvcp9paZOgJIy1sWjMTMTslK4FgVtMDT2z/ayophCqyn5MQu0s1KBst7
 8dJ3CYMt6AAv5mlCXUsZOirWxEinVKrAHetK11dzH+jKeIjdqRM7MngwWe91DJ9SPeur
 lV2vQdf+gyIr9+Q0efDyu8hJ266I7OZbcmeMfZ7HnZ+guXSpErFFTCMEEvezDfRD7VUb ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mk78q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:46:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFZFJe157666;
        Wed, 24 Mar 2021 15:46:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 37dtmqyw5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjwIw91hONlPjcBAeG73B6CgNZryceEBLvzuYOHTR+CnRZ6RSqXOhzRWgfOy2+Fxl8F5b+qGIiBxBtd7mYvPFqOv+u4GWzrT0Ro3fn6780LAnLs+I1G9JwRUrkvtRQdq7+OjQvjOEopcov+LQeVTG6r9yFV9FX2bas3ppWGxUAOytuM5PTmSaV2yoRI1hEr+pQaAT9mwPnEJkq1fo/yBcOx1ZRslb3nHxOapQ4zVfIIbmffDvcCk3vcYKgDGUQUklSa4tKBUml1qxgYTlErLBscDDesbTvTFaQKxB6nGfky4/7tZQq7JevemTSw+eFlr1Kt3WZfKu2xeVca+D8WVzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWrmAd0qz/MQ66vhz8JIWk3Sulqn6PNU0xtsXKitZqU=;
 b=aQWeehfiSHlQHIZwde0v6MOWNFSteUFtPGXH91K18Bg3COHUfkOOp85AfEJHCOdhOnFpCE3PDkcD9oghmNK9xC0w9aBrGAv6omAECsa5NOeqtayA/VsaWpP2f+HaNhVVruN7JgWVDT7hTnSLPG/H+ulLgmo+FLUbZ7xft0poD3LV6k0Bjyxu7QJ6pD9rnQB+prq4rwsjdBdSZdAQ5zL0ymcvIgznvTxFG0DvAhfpIxtODDOcgK+BT+rTrdipd0hFDfx8rKbDE/uWYpGKUk+sP2IL7UxXn5shz6ftUWG4WEpKBK1g3R5yrrTRiawmISvVLgRVX01/9kbEPYrSmKt7bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWrmAd0qz/MQ66vhz8JIWk3Sulqn6PNU0xtsXKitZqU=;
 b=v97xYg1/gqpKcahr9wTPkSjeQX2ra059P3kOUaG5gUJ/NNZ0vwYu0n5qpYYzcOUvXtFMWAqTrsAYc09kseswcPyzmberUuaOsBqpwE19JhyIfa3+hdAyGHfCr4MT16S4dnsUSh9r1TFjr5Uc//Jj06qJNiZMG9jANnNx0leS3vg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 24 Mar
 2021 15:46:52 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 15:46:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 01/11] qla2xxx: Fix IOPS drop seen in some adapters
Thread-Topic: [PATCH 01/11] qla2xxx: Fix IOPS drop seen in some adapters
Thread-Index: AQHXH583EL2vtdObU0ODt/TKq3dy9qqTSpIA
Date:   Wed, 24 Mar 2021 15:46:52 +0000
Message-ID: <A1070793-F934-4ECD-8A3F-1DC351595F5E@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-2-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7b7bd23-19c5-41ab-b32b-08d8eedc0bb0
x-ms-traffictypediagnostic: SA2PR10MB4811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB481117E244B42DFBADF47378E6639@SA2PR10MB4811.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:288;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dgkuhz3ASYgwo0OuvVHPFCmn043xxdVArh4Rx9CFFltDjJUU0w84ALxQDhk54UAuXddXeaLT1+EjfRnVamXdks3l0sElnDeI09f2s9gmGVstQITtIAlLbTFqEXmFZaEwd3spS2KbAJlGYjSfUfbd+Ye19CZ9sy8Oo1Zwuwyt9Q8DCAWbWCuW19R5E1AXaQAvPquG91mhVzHsje1iuWTMNEsQTU0UiwWTLKYQH8xGmAkB+3c9dNLNLaaKyV7I0CCqnjum6FHRx5I4gcY/1AKCUMvjHID79MjPHmKWvThDcsqHxgs//46NKQnxoSQIOLNE3PgthWzk1iHqgCauky1iTwWOhWwmTRpXG6VMhO4e2IYAW03w0aGqwV4lXGQpERk8tZPTOzsjNEU2JCGfvlQbY9/Xpe4JAu9n7bvw9rrtuqcL5wTl5nkoHZE96AxqOL9OZK23QX5loo7Kdn9ms+Sm/90NJVjnRVLd4GfigsG1RoIlTHSkGuNTTnXqpvAauNds3DG0iS5//xlJuamHhjJGtnbIE1U1MMra9YzFSOW7kvcGd0thyoQp8AC7OleTD9M+nxo/Ubc+l1fgGL2euVtSjN6saZnNys0lm7sFv7t5feS4vCGqTe8r0m5FLqhni3J05GcX+hns1RgbyVtixIxJYrTatM8ApeFX/RuPpbK4yTe2Cr16v0pUSJLR7CPB1LO2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(39860400002)(376002)(2906002)(64756008)(66946007)(6486002)(36756003)(66446008)(66556008)(83380400001)(2616005)(44832011)(8676002)(66476007)(33656002)(26005)(5660300002)(316002)(478600001)(6916009)(86362001)(53546011)(8936002)(186003)(4326008)(6512007)(54906003)(38100700001)(71200400001)(6506007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RyTahdcF8HrdmNVCy+KALPXoO03qKDfBPpri2dTIohRHXzziBvH/MmZiWLi1?=
 =?us-ascii?Q?GNFNz1mGpUUlMsd1+buCoLk5nu1AI1sJ7To5+GAlLdEP+UMb7V2yzrDGeka5?=
 =?us-ascii?Q?HFu5AbDU/JK3wOB4vYx+VNuRpDXeJdDKOM7SlypjKhQF703vKbfYY/SWlKe8?=
 =?us-ascii?Q?AWMRIHvxtMsqv0Yl43PmDlIa5oH/N+2co7wYiovwpgn79slBmH6jRmRUso85?=
 =?us-ascii?Q?+zw+JG64OkpnVEvP3rvDkDYEmDqQ4kdtVc5Aik+nXl6w/tO3sdZn/qjjR0o6?=
 =?us-ascii?Q?xQYZfFJ4MYMBB1kEmsyV+wm9Wc+rL6oRRU54o3in1RfqDDUKL4LoYTYuWMAy?=
 =?us-ascii?Q?nhCdnyJiDUhYRy/6yUQqiAkj2q4hn2hQ6L48h35tyRCEI6eHYGBCHvUa9Xk/?=
 =?us-ascii?Q?ABBASYcjMbY9EbpAhgYsTH1nm/3WFSv6jebp0yD+NeZKQ48LWIuheSfDVFqk?=
 =?us-ascii?Q?2gxnMhY4z/R61DgtzS+xMUzYtlRWwLQSgNsLlt91p+o2w5Y8i6hQjMOij5az?=
 =?us-ascii?Q?/Euwmsc/Se8WxympTkPuCpmj2DSG5+zqlk4sQ3AtPLfwhYpQl7q+lOQ7aJMD?=
 =?us-ascii?Q?ijaJjTImYMyCPVsGTW176EbHzDPunbpgj3ut3CamwGhob3JTN08o3ix+KiU2?=
 =?us-ascii?Q?uU3ZcxquqgzmQ9HtD7upNbjv4Qfr/vBELJSsryGFiwf0KjJO4dtvFQPY+OBO?=
 =?us-ascii?Q?eU46yjw74QVF9SoqNepIaySQ5PoSMSVxrqlLwXT4FZwVmQw18TXCyss2WFSF?=
 =?us-ascii?Q?cB7mYZ/yHj1QzQSzVv7zdaGRLQleBsyo0jWrRNCjjg/thxjqHmrjZ0KofPzt?=
 =?us-ascii?Q?GseIkZ02xyZOV1YoARKqnFAUd//6LiFx+HyLpQM+ZzVpgwo7ErPUBJIt2MqJ?=
 =?us-ascii?Q?dRVFpWPsnrCquwYqgRpR/ZcfuMyuSIECrqVCS5RUAJ3f6Xrt96wBaS7WiXTG?=
 =?us-ascii?Q?kdrDD86u9euHsvsIsO2b/VzH0KpTpIwcGkbu11CRdPFed+ZL0NTEmZ0qBUES?=
 =?us-ascii?Q?SSB6+o0LL7aeijBEq0yHqvuY/EIha2YUEao6Kqe6kGlodWcxn9hBDoVBE4yw?=
 =?us-ascii?Q?gdfBe5JcWNWZttWRjka4SmT9VGQvsdncLaRd2jZFXfrDSvWMX+LNh+CEJbAV?=
 =?us-ascii?Q?yjEADoLx1BXy1XuchPICrmAaavdCTVFEw9hUNDKZjh4ba8LDPYM11YbAHUEM?=
 =?us-ascii?Q?UKbCdhTZU0O9pBHI8XuBTeHmaj6sHRsPrcWZ0Y8qsH7MBOwu2ucOhA5jW9H9?=
 =?us-ascii?Q?QhpBBfadX5oZeyC5wLsSCZXQxaypic9RUKwfnqxylN2ViGfmTY4XiOKKAeGb?=
 =?us-ascii?Q?yLeKHoKdqTtmXt0nPO2/5Yjw?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B9608ED060ADCF4AAC190CCF0EAD8810@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b7bd23-19c5-41ab-b32b-08d8eedc0bb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 15:46:52.8441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiNjno/1+jNupf+izbKPPPlL91P3g6L2pLUjxUMdfyNVDjopMcCNxeQ7CEfXxbCtaK7r7xDg1nRqJbKwi9tLQTY3BJBeuHSiKJvlC+hnfDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Removing the response queue processing in the send path is showing IOPS
> drop. Add back the process_response_queue() call in the send path.
>=20

Can you share some details of what effect this change made into IOPS?=20

> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_iocb.c | 19 +++++++++++++++++++
> 1 file changed, 19 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 8b41cbaf8535..f26a7a14fce9 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -1600,12 +1600,14 @@ qla24xx_start_scsi(srb_t *sp)
> 	uint16_t	req_cnt;
> 	uint16_t	tot_dsds;
> 	struct req_que *req =3D NULL;
> +	struct rsp_que *rsp;
> 	struct scsi_cmnd *cmd =3D GET_CMD_SP(sp);
> 	struct scsi_qla_host *vha =3D sp->vha;
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> 	/* Setup device pointers. */
> 	req =3D vha->req;
> +	rsp =3D req->rsp;
>=20
> 	/* So we know we haven't pci_map'ed anything yet */
> 	tot_dsds =3D 0;
> @@ -1707,6 +1709,11 @@ qla24xx_start_scsi(srb_t *sp)
> 	/* Set chip new ring index. */
> 	wrt_reg_dword(req->req_q_in, req->ring_index);
>=20
> +	/* Manage unprocessed RIO/ZIO commands in response queue. */
> +	if (vha->flags.process_response_queue &&
> +	    rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED)
> +		qla24xx_process_response_queue(vha, rsp);
> +
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 	return QLA_SUCCESS;
>=20
> @@ -1897,6 +1904,11 @@ qla24xx_dif_start_scsi(srb_t *sp)
> 	/* Set chip new ring index. */
> 	wrt_reg_dword(req->req_q_in, req->ring_index);
>=20
> +	/* Manage unprocessed RIO/ZIO commands in response queue. */
> +	if (vha->flags.process_response_queue &&
> +	    rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED)
> +		qla24xx_process_response_queue(vha, rsp);
> +
> 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>=20
> 	return QLA_SUCCESS;
> @@ -1931,6 +1943,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 	uint16_t	req_cnt;
> 	uint16_t	tot_dsds;
> 	struct req_que *req =3D NULL;
> +	struct rsp_que *rsp;
> 	struct scsi_cmnd *cmd =3D GET_CMD_SP(sp);
> 	struct scsi_qla_host *vha =3D sp->fcport->vha;
> 	struct qla_hw_data *ha =3D vha->hw;
> @@ -1941,6 +1954,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
>=20
> 	/* Setup qpair pointers */
> 	req =3D qpair->req;
> +	rsp =3D qpair->rsp;
>=20
> 	/* So we know we haven't pci_map'ed anything yet */
> 	tot_dsds =3D 0;
> @@ -2041,6 +2055,11 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> 	/* Set chip new ring index. */
> 	wrt_reg_dword(req->req_q_in, req->ring_index);
>=20
> +	/* Manage unprocessed RIO/ZIO commands in response queue. */
> +	if (vha->flags.process_response_queue &&
> +	    rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED)
> +		qla24xx_process_response_queue(vha, rsp);
> +
> 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
> 	return QLA_SUCCESS;
>=20
> --=20
> 2.19.0.rc0
>=20

Patch itself looks good. After you add more details in commit message you c=
an add=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

