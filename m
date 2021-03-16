Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1389C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BEA65107
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhCPQ2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:28:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbhCPQ2V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:28:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGJnGp134083;
        Tue, 16 Mar 2021 16:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ag+K9Ia/mV7oKioCY+RMArW12PjQ9UK0kr79CE/oMIA=;
 b=GmoY3jOeJDGw/Dv/bn5xsLou49MhrKuTyl3Q/j4TXitCABVMcofipPh0JW/dJXVcLghG
 rur+b7een7PbWHQ+9VyNhlnM8ZoO5YiurCNrNd5Z9Ka/FvAEKU2N5oKpxbsB5ZH95LsV
 6nBtR2G/t46SWIZlveJXVOIewi7FBLT+EHNXhzEXtMwbUGqtl/lZRw2fB4NV/Py2xgMm
 IIywYrnnOxNKcesLrHMdmm5VqgVeepv+tkgBpDGGp4PJX/PBRheV930J45O3v5IF5qFt
 wPTXTbRvtyBIh28yGRWzz2JWlYunWjpmbCrzBLnW7b9JTRvPRz2Zf5KE69CXfjhSmt8G bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 378p1nruuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:28:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGMBPJ180986;
        Tue, 16 Mar 2021 16:28:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by aserp3020.oracle.com with ESMTP id 3797a1dwbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:28:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIofUG+ouZ2PLDt1xnVBg7+yXQr7J0tiCE9Fq+pVTACHVK9TppnmqeabfXgO0S9vkXeyHpbW3xy7WsfppbCoMXarBISw0eG5RChjLnj0O/FKUWjSaipjn8Xd4uvWGbpfbijOr2qjwHMVs+K8U/GkJ0VAtTBRJajb/aU8KmyjICb7EVV7+TIqOAUYLqEG9cQBH6LI/E/1e7wsexFYRbKnoFTbewKuirJWRtBEKgOV4/SBiIVXqeC25NdqRXq1RH9flPVt4ju4ccmBk8DUv5Yr4uN/mfjirmJISjxa0T29qy7NMImTJ50wG4jE7CzrIi/NRE4ZpkaQ5wzRqQGKs38dxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag+K9Ia/mV7oKioCY+RMArW12PjQ9UK0kr79CE/oMIA=;
 b=lIZl/bIfp/b/Q5GNukPf6/DgeTSg/aJzFmlivT2HHF6/Ne5ZJaTLsjln3BROYG0zl5TdVB5oyCF+MXxgqPjRtF8pK0GppFnkvPMbsy8sz7PW7GTdIylC/IZs5wWloOMd/hFUqaemcWpyUHtDx1yRN/yHOlqQmoLMAHBMZ+e+HMa74979tAgnJBiMxtzIBEz0D2NXXw9QlAuROCLoyx7I+PMozaMQGqElvJ5qyH88zFx2PHeQnYvuowOIFmL4rePYxVEjvqD1XohK4KIBHwOY1QqbKEGngh5aH8Ok9VlGD80fRE8Hp1Szh+DspOz2FXGrJCSmLPXW+f8ZhKYIGkbOow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag+K9Ia/mV7oKioCY+RMArW12PjQ9UK0kr79CE/oMIA=;
 b=WzZJzpgvXyESr1tw3KXccDc/GAIA8F+QP6sFJRtjy2J57moTD3V5Z02dLRcNArD3hmHzRVbtw9Q/9c1uF2WzWIBWhWwEohP8YS9qGoCRsQnNKPXpPWBVhqfM60gAtS2ZBqIrB+N5EFu6hxY1sX5vXZ3wMg0NVUbG7pxeK0lmnuo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:28:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:28:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 5/7] qla2xxx: Suppress Coverity complaints about dseg_r*
Thread-Topic: [PATCH 5/7] qla2xxx: Suppress Coverity complaints about dseg_r*
Thread-Index: AQHXGhhz/GCn6ww8RE2sUOmvlobNraqGzoEA
Date:   Tue, 16 Mar 2021 16:28:08 +0000
Message-ID: <6FEA46FD-AE2C-4435-A566-B44635814980@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-6-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e4410ff-c547-47b5-125b-08d8e8987c17
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB246482B212D954850F531505E66B9@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l+a+SI6ySwBrvKJ5bYufurs8BGJjKL58W1mymDS4eaUT/IGlnNloka8RkE/HE9adwrKctGLe+EilsBuckc2b8wxkNIfKAFd1BKAejpmM7rXSZiEXyWZAKCUBUVrWHk5xeMXR3e90qRd7knXvSyqhWliJvsduMbcpcQ1m+5g++6zUFCtJ4dJME3kd7nSE1nmzDD8appQv3iziUNk/gAzAgT/iH8MtzNejQzi2R+4hJeUGkCm51v48S0Gx++XzWUbt87DXRBbC1TEFvHKV7syCXfR2SB5UVlnQnaMzfz2Qq5AhIHHrwjGjAArLlZPcIXkHzrHFvALKTzRuXbghymGhrlj/yTaWb8I6Yx047rV4/oJaDhMNbce1noUSgaF0TZa72xrm+yuqIyklpb+v0rVfuynemjEhwqHYm950cnG8qOK6evh6j4V3E0Ljwn/WPf3ELjV//c6SCcJ3PpyVyu0OuVBYW4zOGF6SI+7A9KMNmdf5T5Zw8LrRFeeXiVUjZl2wmNLDkjhLdgzypc6+CZZOx0Jch5qXmag0EO/BzEYWRgvSTfVYKg20MRwejHCGzcfq/s1tQpLsxtzhYsohQWCuYcYdX9BQZ3Zv4RMfr8gZdAiUTxseRBH/Q9JfUH4e5hGe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(66446008)(66476007)(36756003)(6486002)(66946007)(8676002)(6916009)(316002)(64756008)(66556008)(2906002)(53546011)(33656002)(71200400001)(6506007)(54906003)(5660300002)(478600001)(4326008)(2616005)(8936002)(26005)(44832011)(76116006)(186003)(86362001)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FSDZlZ741TdGJ24q0h9uASKkRdE/NWb223P5jZMX7VchIJFkH1EXp4WRDXt5?=
 =?us-ascii?Q?oYE9hoFcJy81NgdyEYJRSoeZVQJ1l5eP3vUnjuX64tLewHh6krj/RkFU0jEA?=
 =?us-ascii?Q?RN/HotGQs8ya7uQN+8HncK/ZAHDFQbtgxIIWCNv3eIYMzffW1n5Nyb16Fy4t?=
 =?us-ascii?Q?6j1YRsfHTUOXGc6BM0P2XAJp9l57VInrgzlib1jjvKU7L9GVs0imkGV6bf0N?=
 =?us-ascii?Q?QhE3lStfbSCpQBxd9JTahSjemCRkR0DSQgmZ58PSn0XypPWWc6FriM0NsqRp?=
 =?us-ascii?Q?lJPjpTS3g1cfJzvOo2IxWQnvgkseMyJqvREzQxd2+Jb+ZF26ajLWjFqZByWv?=
 =?us-ascii?Q?Vd6gdUZ5zyQkClKCIOsxzd8ihzu7pKAA9PUApNtBSaNM9uSj04Xlogmp4RDG?=
 =?us-ascii?Q?+ly8cL2JsHlqIocnvlzELTbCvxal3i4jwjqQlt2Ce2TWIpNUnbmF7o/YKZ0v?=
 =?us-ascii?Q?UE8PEMBVUB96qI2tDQ6fDRbUAwrw8fFqgMo4yScm9m4BU+GzzacIhh+Vaf/z?=
 =?us-ascii?Q?YgEYcsXQzMnhB/12HJlWbwx9bR+BGduMkJRvdfQVDQoeAH9lDwO0Zv4rCnQB?=
 =?us-ascii?Q?UQrob/jBmn+HwA6/fhPdHRcvpcgQEJ7y0P9jGc5aVBmtgszKBpMFOvVIaE60?=
 =?us-ascii?Q?tqiUwdgTOrZnXuvTW1yWFnudS46J3k3U4GJ9emuvjKkS44NVO7/ofS3Dzat5?=
 =?us-ascii?Q?SXSE7DAQIgC5OucK6PtIri3lTv7tLOJQfRyFUpPyB0ViidBvm861xs3UARc6?=
 =?us-ascii?Q?invgBgZ/+WHbZWa0ivwrYcCZeExhnMPMQGvqWmsriiD700g7/2yvI7JxCXCC?=
 =?us-ascii?Q?WvJCKMj8Yl6McTq5uykMSOzWQPzTyMYtdxqBM0D/ZqGrs0qcagWYWNT0p84j?=
 =?us-ascii?Q?Majeolpkjj7UNvK72yRWYUcQ3qyuTTSSNAawHbaKLeYZmv44jIBlbYrC+XIE?=
 =?us-ascii?Q?LpukMh6ft6rckdEkzg5WLIKO5Pnb2CykQ4E58exWPDHBmi/B8N9tFrpHjgwP?=
 =?us-ascii?Q?YEUfeoFmcDyy06SBd0uHSASUq4ASd0rdFIsWo8a/ulUnlrE8DYWZ+HcITmgY?=
 =?us-ascii?Q?NjeZRbvyws4cD9z4JiX2jYruyCMms/+i0xrR1LAQ3BUWS2YJUAYHalwsxGgN?=
 =?us-ascii?Q?vqzMiqHY4EAz77dul1SIBZIku7BQSmVJCtAx5OlSnA1N31PDywcI8IyqXejS?=
 =?us-ascii?Q?0CVxS2lMGBjthgwssDyk7DQwq79hIPHJJGBaBfulh+ja+3btA1mvOJhhlHfV?=
 =?us-ascii?Q?x6dCfWrVd28w9ul+MnRVkIx/0I4/osFSuT51aoMDIolTeCyguwrPTFedP9gT?=
 =?us-ascii?Q?sIP7vzZGFa8PZs2zQ2qtIJCm65G38ar+ujHvt5QU2ye9gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D83F4E3112CC54F9367F381F3AAC1B6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4410ff-c547-47b5-125b-08d8e8987c17
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:28:08.6385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DjTpsVfy8bXlrXWS2msQiU46D+D2vYXxQNkP2RcxRjun8x981W0WtWeyd6skQfEW7ylBAf+PdY4CatxfHn1++yCBvcVtj1mqxmBbn5xwLP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 15, 2021, at 10:56 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Change dseq_rq and dseg_rsp from scalar structure members into
> single-element arrays such that Coverity does not complain about the
> (*cur_dsd)++ statement in append_dsd64().
>=20
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_mr.c | 12 ++++++------
> drivers/scsi/qla2xxx/qla_mr.h |  4 ++--
> 2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.=
c
> index ca7306685325..61eaf6c4ac47 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -3266,8 +3266,8 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_=
fx00 *pfxiocb)
> 			fx_iocb.req_xfrcnt =3D
> 			    cpu_to_le16(fxio->u.fxiocb.req_len);
> 			put_unaligned_le64(fxio->u.fxiocb.req_dma_handle,
> -					   &fx_iocb.dseg_rq.address);
> -			fx_iocb.dseg_rq.length =3D
> +					   &fx_iocb.dseg_rq[0].address);
> +			fx_iocb.dseg_rq[0].length =3D
> 			    cpu_to_le32(fxio->u.fxiocb.req_len);
> 		}
>=20
> @@ -3276,8 +3276,8 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_=
fx00 *pfxiocb)
> 			fx_iocb.rsp_xfrcnt =3D
> 			    cpu_to_le16(fxio->u.fxiocb.rsp_len);
> 			put_unaligned_le64(fxio->u.fxiocb.rsp_dma_handle,
> -					   &fx_iocb.dseg_rsp.address);
> -			fx_iocb.dseg_rsp.length =3D
> +					   &fx_iocb.dseg_rsp[0].address);
> +			fx_iocb.dseg_rsp[0].length =3D
> 			    cpu_to_le32(fxio->u.fxiocb.rsp_len);
> 		}
>=20
> @@ -3314,7 +3314,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_=
fx00 *pfxiocb)
> 			    cpu_to_le16(bsg_job->request_payload.sg_cnt);
> 			tot_dsds =3D
> 			    bsg_job->request_payload.sg_cnt;
> -			cur_dsd =3D &fx_iocb.dseg_rq;
> +			cur_dsd =3D &fx_iocb.dseg_rq[0];
> 			avail_dsds =3D 1;
> 			for_each_sg(bsg_job->request_payload.sg_list, sg,
> 			    tot_dsds, index) {
> @@ -3369,7 +3369,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_=
fx00 *pfxiocb)
> 			fx_iocb.rsp_dsdcnt =3D
> 			   cpu_to_le16(bsg_job->reply_payload.sg_cnt);
> 			tot_dsds =3D bsg_job->reply_payload.sg_cnt;
> -			cur_dsd =3D &fx_iocb.dseg_rsp;
> +			cur_dsd =3D &fx_iocb.dseg_rsp[0];
> 			avail_dsds =3D 1;
>=20
> 			for_each_sg(bsg_job->reply_payload.sg_list, sg,
> diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.=
h
> index 73be8348402a..eefbae9d7547 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.h
> +++ b/drivers/scsi/qla2xxx/qla_mr.h
> @@ -176,8 +176,8 @@ struct fxdisc_entry_fx00 {
> 	uint8_t flags;
> 	uint8_t reserved_1;
>=20
> -	struct dsd64 dseg_rq;
> -	struct dsd64 dseg_rsp;
> +	struct dsd64 dseg_rq[1];
> +	struct dsd64 dseg_rsp[1];
>=20
> 	__le32 dataword;
> 	__le32 adapid;

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

