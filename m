Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9236C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C0086199E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCVPr7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:47:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40452 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhCVPrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 11:47:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MFYCN4153627;
        Mon, 22 Mar 2021 15:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FS3DpskHjEAv98pWfOs7xvmXil+uEuvmZjWhXUEj78o=;
 b=VLmnN+khjyHcMczaxWPhB2MJSGkhpixvJJEhAkFRUfpRK3DsaZLqD1CktemZPD6DdKkV
 A9T4BsUfL+fuho5W3d6mreUpJI2jY4i9PaD+ZdAs7MRxfL/YAZo4Pbhb7+brJstPrz8k
 1f8jDSUn6lTs17++8ZyL9fedkgSUSLQtt0F8yaMD4zpzEpBUESVE/gRbUwnKqeodxfYY
 6LJp4+Obl9NxTvDGfnbeXzm4e2qSR4TFpJrgZWLnbdeOhia8ckqpyMV13qEuCHznUxyP
 ZBheuokzooHGn9Fn1kU+zA8g+sceijOPnHCAdgRWyJbJGGb4wE/OJwv5yqg8yT+gOn6z cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37d6jbc2h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 15:47:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MFZ4PT001826;
        Mon, 22 Mar 2021 15:47:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3030.oracle.com with ESMTP id 37dtmnc83k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 15:47:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXVMjt8DVtgBJ9T+wze08i11LhhIpyArFq04Oug0jeOGVR+eNtMyAz6XPgLVp7QsYbzpayvFip1O9VAdVUONyc4ZNRMwRkOuYCg3PScLKGoLniYzDlUVbasnBbYDRfKF084SwjxAXomdfuj9YUQum6Fszx/RjtCcMlZzxL2U6sY/B3fJPhT/NcJLPu+B/eojRZmTiuQ1KnPCwt7wZ2PY7nu8CBppoJ/qdYJGJWj7Uv3B95xxj0aYd7il/afCM0kzAeWXzU1TJGJTxhFOlgwZPugt0u7/sCiQ3pVGoXA+HfVHLGGZNF1gZ/SQ1j/Dtq1CZs9bNFQBnvmJE2pqAHHBwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS3DpskHjEAv98pWfOs7xvmXil+uEuvmZjWhXUEj78o=;
 b=gWsFoDSy0ksSB3+SREEAY+N85XE7GVONJSInkPLDGQRq/gXY59L943r7u3oOWa+Uhnd78njPW+YqGBGT+fBAmqudfZt0H6X8P/FH9u2uUncY82zmGs0YqHD4uu4pk5t5Lq042bxsJqpxA++Bi6IQPB8x9e3UTqFuq3i9ZIKLZ5XdiNjwnoGUPc45R3vQrou4fVI7Mwb75N+iwk7i4R2f7ej2fNF8kUOn0LGlGyAHhVjxv8mDyapo6PMXYnqoAxF58S3895L4qoVwBbz+gUQxgbYiZFIl8ZWZ1GKw5b8lVlRNLryCqMTgJPD1wPw5SOV3BK5z1p/+FoBQiLSj0tQUUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FS3DpskHjEAv98pWfOs7xvmXil+uEuvmZjWhXUEj78o=;
 b=cLdXieEfsDZ2BGVUaFp8XjsdBeN4t3h6FeCtuWNtWTh23PV2LBhKLAbmXuIZsgrFhPhS2HtXaiLB7fb4cu1ESShevMCv4nCvJDi435HX3Mvfasbcq3GAPgGGiSICDuJG8JE7Pqzjo11hMJPNrGx69Mj5mcstiJ8ntzb3M8Tic3k=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2912.namprd10.prod.outlook.com (2603:10b6:805:d2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 15:47:19 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 15:47:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH v3 7/7] qla2xxx: Check kzalloc() return value
Thread-Topic: [PATCH v3 7/7] qla2xxx: Check kzalloc() return value
Thread-Index: AQHXHeAqM2oxpWrIyUqbm0HOt2bqE6qQKYYA
Date:   Mon, 22 Mar 2021 15:47:18 +0000
Message-ID: <6CDA8281-53AC-4A22-A4F6-7B5E5F52F033@oracle.com>
References: <20210320232359.941-1-bvanassche@acm.org>
 <20210320232359.941-8-bvanassche@acm.org>
In-Reply-To: <20210320232359.941-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82399d97-356b-415b-946e-08d8ed49c671
x-ms-traffictypediagnostic: SN6PR10MB2912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2912CD9BA5B17DC2B261047BE6659@SN6PR10MB2912.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U4pGMfBBIyn9AfzkeHYCceJbCXmrJGXP7r5RGk0lp7R5AimYWLgR9NlMiH0Cax8JUSdtOAOUaF0ty0mdoBtifBkHY5nOw4q1yNTGS2j8sefN7WJHtVz4xWqsu23etHcPQ84N6u1zTyaYsQDDU2jm6VDnIgMQJGANmrKwAz6279qzM4ouYV9PyWwQIGjcgXNCVTVcsqsebVmIvn9/te1OtKs4eKZDo5NkmggxvKCCslmbFpn5u/M+yvnH4b8DxRBxgAJOVY76YSWR5xtmNGjB9fQHo+vTnnNRdbg2P+n06lTLQ7csh1O6focL2rhqt3CMiFvHbc4RdCzR7kthlKIH9G3eHy091Ym8rKN+jXfqGIUQ4rjvgVkNV74OHwHsh7Y6b45/fYf6Z8Pa7RDaUidxQZK8QFOqZs9TYVqfVyfO9/DXeeRKlrTBSY+o/kk9giviw8JwVzYe6RIkNVNE9EykftP/4BCt+jhBfFkjNO0pVZsNUKpPP77lq0cBK9UmIPPty+T+UYqnJtqn2UX7jhiA0RZ9+wZc9/CnE05vwE0IIQe98PMpAlrf8gT1pqzR4wnQgbhhB3BLU9yy+gIY5ZQrwOHBN+NrvPiKfXIUTu0SFSiFrzbEa0XDBlkWo25DGJq4tdjxTGeFBmtCZmJ0jrrCptwVxjY0YvQIFnq5hkz82GQ7ZYTOX62L0Hyhv9BgKbYl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(346002)(396003)(64756008)(2906002)(66446008)(6486002)(53546011)(71200400001)(66476007)(478600001)(6506007)(2616005)(4326008)(66946007)(86362001)(44832011)(316002)(33656002)(66556008)(76116006)(186003)(6916009)(54906003)(8676002)(5660300002)(36756003)(8936002)(26005)(6512007)(38100700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BpCg5q0N+g++VbES0rDsidVON8gYuqS3mkDfJZhZH8Yz3HYeprlQd11EO6Jw?=
 =?us-ascii?Q?9QFPctFVonYodgnx/fDUj6NxI/DDe0qWZOSeALQotSiG0G6LPAlkyk5VL4Ev?=
 =?us-ascii?Q?oTk8YqgijNTmyu1Pt0l6sxf0B+iGCaCQM2JJN4G97BMzQTnVKLyFICUTuA9X?=
 =?us-ascii?Q?9D4HpWJX9MiD5wFLBw/8GehQtZV654vZiI48sFlh58Vg0Y+FRVYKkL8vSqXh?=
 =?us-ascii?Q?iQeLOCrpLwzq3dL2ouoyGJbeEPpi+eqDO2seM1n3ks/IjhDMhhYZltrNsPbA?=
 =?us-ascii?Q?jFzMMnvO05FiJulaNRbLVnMHrVI+D0+r+JpQJE+PNiHE0kuSP+w9JV52e/vI?=
 =?us-ascii?Q?30WuOMnDNoBPmdgNtXd4KyDo0uryGFlqLUW99X/iOdv48BaGTM6Xd1Mo7mXU?=
 =?us-ascii?Q?hfYeyMgZY0i1acvV9bLdlKlgqP4V0MLSlcmgJqyEPgSdNNtsZ09kRYeQcqTL?=
 =?us-ascii?Q?ePKi5x6dY/IaFX9HrUWJtatn+GAbboyeQFKnt2SNXn2tQ2VvGVZm6IWG07Vt?=
 =?us-ascii?Q?QpfGEWLQVwPXiP5xl2mqVE3ectqXJ866jNzAj48JljdM6DPkUY4iLtxP9FzQ?=
 =?us-ascii?Q?nHQmyelqDvwzWoxd873GomcLBHNZaUj+CCvmvKA+3JC4Lb814ob0Hz9OhOuc?=
 =?us-ascii?Q?dbGxB6//8XwXISApFTtve5sbvj9jOEYGfavr/1YNP7BQ3PRbQGfhe7F2bR/i?=
 =?us-ascii?Q?QDqtTl1QuK2smOWcdketZKR9swuVeHFRKp6DFs14uCDtxLkAo9ziPPCwrH6v?=
 =?us-ascii?Q?9chVDatcND2C7LP/aukqVPVtxyzV6vPzk6Hqh6jJfAsH9Xp5DzFclj/4kGS6?=
 =?us-ascii?Q?ueL21qIlyq3ZjgHcYmLF4AhxnTxoou/hEUWMdWxpK8ZvGaOJAtScmjJbDA5h?=
 =?us-ascii?Q?o426oJiqOfunyhh2+3rpSfzVMILOKb3MJ74dzNf0yd5/GmFeyvqC8MfnbE1F?=
 =?us-ascii?Q?3M8C0P91CSK1pcepf+YqFRQQLbXAT24o+Gkxyv36ZIejTO62ssYR1MHt3Llo?=
 =?us-ascii?Q?0kJzEKG4fSwXUApaISr7SItn0sT56zRBBWmejJHlWgW+nNNwLO9k2aqZ7mxt?=
 =?us-ascii?Q?FSuxox/GVUUjrJd0UTzMrZaLdAN1kbfzC9sMIt21em7q5nfZFcviBbunKwyu?=
 =?us-ascii?Q?gj0IKzqPWvDIcgB4Q3LcDNpjKyh1wCB2/dRz88+CIiSH2nlTj5GFy/TT4Bcn?=
 =?us-ascii?Q?MZvi0CIoWyMtakoVF+6q+WK3Ubyn2T9RLLKy2XedDiscvCn5dsxVk/CSOubL?=
 =?us-ascii?Q?MqurQTnz2YBXXqam/K/SNvhUwjI/qwK08xTmElueLGDwj2gESQtvDppJweIs?=
 =?us-ascii?Q?r3FfMzvOmrSIc8urerw+a3H1431M9vIX2Qvga29jA2BAyA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D961C7C6745364D8EF9E17FE7F8E9E8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82399d97-356b-415b-946e-08d8ed49c671
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 15:47:18.9423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0FeOGbwrJEOy/UY0RChqSXIN4l0caYZvbgyJKpSoZD0SkMLKqsIQnH7Wv86XpzuXe4zVaFU6UuhPK8aw22KFNC9u3Z6xybbeHs4p8+wEIUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2912
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 spamscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 20, 2021, at 6:23 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Instead of crashing if kzalloc() fails, make qla2x00_get_host_stats()
> return -ENOMEM.
>=20
> Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage hos=
t, target stats and initiator port")
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Saurav Kashyap <skashyap@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 4 ++++
> 1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index bee8cf9f8123..bc84b2f389f8 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2583,6 +2583,10 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
> 	}
>=20
> 	data =3D kzalloc(response_len, GFP_KERNEL);
> +	if (!data) {
> +		kfree(req_data);
> +		return -ENOMEM;
> +	}
>=20
> 	ret =3D qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), req_data->stat_t=
ype,
> 				    data, response_len);


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

