Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF07C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641D76198D
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 15:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCVPqz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 11:46:55 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhCVPqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 11:46:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MFZWDa103047;
        Mon, 22 Mar 2021 15:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7xFts4wy/TowqWkFr+Pb1jBfN6CMey0PDAxTsm1d9kM=;
 b=H+B8RdWzadPOsVDiqGmwBXqrad1unTggQeriW5b6NBMth/lPdFhXZosocz7uyQ89NRK0
 8GYGotBA7brjmjrxea0WrS/PXCA6YMeCzN98tLiSWvNuBkVyHdxfKLs1e5X5L6JhleUr
 3Jb5MFwyBI/Ifuq1gUU0sc9J1pCIFd3JRah7MEV+gt+6WRQ7j4rlxMANmDjmQzRMQXqi
 kxa20tRR4EVUF11AJzvVhMg60kXRc4xu4MIxjQA47h7GPFEzVUx/KdvF6b6JX1F7TFv9
 FtGf0HjYV/SZ8rEB806Py8+aXYnqnkm+lbB3ZGgfYMj4ikzpyAqvV4yevdAZpnuAwRTF JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mbxc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 15:46:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MFZ4Mk001874;
        Mon, 22 Mar 2021 15:46:17 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 37dtmnc75b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 15:46:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DS7EBMq9XhT+3Hx8BARSxbAQTyur5sw2/lbt2NesN+3f/Pg4S9IAVBKVVvFo75v4ckuCAI+0Sa/tOji9ZQj7SAAjdhP1/rnW8aKLUohj8k8JZ1Atw8rY1fF2JAKLrc7TQNiy9fiTMvpijelD39Cgv9kzYhrXvMrDtm1YxcI1UceKGI6xaMT5S5Dqbx5tSA2ieHLPBeCkP6IeXPcwC7MNFgwARCeTiHPwr2cSFDDCoy71TGl1uk5JhOdK8wcoXWUPc6NLoDumlmU6CLYEMJrc9UmRDKbkLjjsI8V4tIq5AkL/qer3xgyqdJUYQ8ofcQYvhm8AWO/oq8PkbRZ3JWcG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xFts4wy/TowqWkFr+Pb1jBfN6CMey0PDAxTsm1d9kM=;
 b=QBBgHk+99TSQxWKVQmZozdRSP0onZij6T8UjR6xMt/zlHTWcAPZg2umbqUg+p4BoKiMJ5dKJVoBfCTSbS1wMLVbgEH3+3+fEkOio1wszkOxLOAKxu7A/dkChzWbykjcYUawWa+WhyMH7Ny550bEIY2H0lNNU9FF++oNcxctBiJrEfe/q5czgptsfGW1ftJWnX9m6ehkDggfZP7Kn3jl0IWYtANJOXPGJeWzan39pNwOHi0hr6Wlxs1O6YgUao/V4/vO9C1rAAtKxkihe07BBv/Zm3C6VXHAdnjisi/wjTej2lIptBhCxgwc6wlTFLJC9Iu8VrQ7JjLyj43te3WtzAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7xFts4wy/TowqWkFr+Pb1jBfN6CMey0PDAxTsm1d9kM=;
 b=kdTcKL/rKiA9grm+ZcLEUV3UfUVHPnArIh78/eMvEG9uvQWKtadrPCTSeKgrlfymxj/Fib/QyEYy2XhbpB7Ya/dEnmZ0U39jcGcJ5nFhqhkEDRA/fGPte3euMJp9So3kT2Qk3ScyumCbeOij7vp+HBDRY/fod0TaBPJpnGWNcjY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 15:46:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 15:46:14 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH v3 6/7] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
Thread-Topic: [PATCH v3 6/7] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
Thread-Index: AQHXHeAoO7EZTKtiRkqYDEN2zVEfBaqQKTiA
Date:   Mon, 22 Mar 2021 15:46:14 +0000
Message-ID: <FE260986-80D6-412A-8BF4-796BC77056D6@oracle.com>
References: <20210320232359.941-1-bvanassche@acm.org>
 <20210320232359.941-7-bvanassche@acm.org>
In-Reply-To: <20210320232359.941-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2112f88d-c431-4bc6-9caa-08d8ed49a040
x-ms-traffictypediagnostic: SA2PR10MB4795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4795925A2F0F28AE9F6059D7E6659@SA2PR10MB4795.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1QXu3D9hP2ydg0Ae8xYkU4NjXQGG1qslHKVECWXHpQI4aadAXn81DckEzTOidYcoXRsgFyqDuJAPfy256lZF8jNM2SJARw915MpCie2xIQ5/HH8vpSKMVRExvr+XxHuPrmlq2tEJpCZN1mkbubJ6oxAzMmdbQwvfHcDgJSl4MvNvq8ESyTYA5jH6yWt9w4Hmos4w64KvmBAk01ysPwe5R5zcCa9gFHWktYmxX881l4Fje/5YB0a09PPoHqrsNSG7IjOyv7at+Mfa2YjGyUW7hp5QnjePLG1PmQfPgzcYs9uPimdqmd69IxKgQTaeOBSMOvQVPlohU6LQOYenYkv3ld58bHStoayNsRhRDDr2VSdOSMHj0+2oSwYhsQUB5dMVwMA/UrZsy304twlYxm/XbH+zTkBaFUzG6GqLIL4X2Tc5uWo2lhFTwbIb3rH+43MqFgt2SpKaAwQzcKJuP+LkQxzrmZQnUWAE/fJ1/9lEzyGKoeN0oG8TiBwO/YJJHG6uDR5FEzch+8Cg7RENddEkufHzVLLdKfOfaS3SiT2ry+Ztdn4KKTeHgpOGsDHSCxc3zz8pyahpck9TtELX/8lniA73Z6P/CNMlxNAByOIOA7pQS7nmqTBd0OjcrzmqUzGwHk6m0Gkc1p+wNDgk8S3cgMtBlPU+1yLi4lNCbGlyEJvumJAfV1xB0S0/iW9CIjDT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(366004)(346002)(316002)(4326008)(54906003)(2616005)(66476007)(478600001)(8676002)(71200400001)(66946007)(83380400001)(8936002)(38100700001)(6916009)(36756003)(186003)(66446008)(33656002)(6486002)(2906002)(64756008)(26005)(6506007)(66556008)(44832011)(53546011)(86362001)(6512007)(5660300002)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?O7mHHEecXc2luaodPY7t7PwCUHnO8shLPjGSqCSRHs+g/fDzy0AirlXeak+k?=
 =?us-ascii?Q?9Jt7Sd3cgiAlDS6ZQBXN5O9/DcpYRlDr8CuaRZCM1xDEmwkz5GgkhICTRsNg?=
 =?us-ascii?Q?Maac5ymN9NuOAvt/TaUBv2LnZX17ccofTeOlXqJYKW/Bgf8Wqi8RK5xJOWfS?=
 =?us-ascii?Q?6qALFNGmuQ40ZrTFzCyLUAiZ0ncJ+lgEOaJ2lgQRR1oA1Qoj6v3NKCFh0OqA?=
 =?us-ascii?Q?UQmEUfpxtSbhmwxVzLsjxlAYxowAMgi79YKV8JxGKImZhnBRckE2WJule6c2?=
 =?us-ascii?Q?BmHLfM2I6lxhm819pfoH9wt3smQXjJsZYQJ6xwBSOR+IFTO1kWpIiBKYPgnL?=
 =?us-ascii?Q?zZfp7/Q8CJ4SsRVHdkDkoWYDKcUwO/4tae5wQiIS80CMkrA1EAQcB5aUv41C?=
 =?us-ascii?Q?Uj/ygDf5z1cR8NdUoQivLYuNzaoRWAl+PuIsAr4/85C7vSF6Za4V3UFu37/O?=
 =?us-ascii?Q?D28HA4Z8Ms1P0M6R71sB/ZCubZ2V/7ps/4s3cvFO4BJt7rK1uYF5zq3sVgVe?=
 =?us-ascii?Q?c1vwhSjAFCTBeULmmEZHRyTODCleRlxfArL2HAihLrbGKpNFA9aTz7rIshRb?=
 =?us-ascii?Q?G5MHzpAJyaybXNnhwxueTq5VbvghOS6Sj1fluacq4Y8F4nVu6TOH+a9cqcO/?=
 =?us-ascii?Q?mTJZ1nXshjQzSPffMwUwz/oSwEK3/VlEDRBfbJ+UhJS4fOqZaVcen78pHDfY?=
 =?us-ascii?Q?nhFzPd02eo2x328p9Kbz1Dc6hIptSJ+r3bCqLvoEmO+DMERoP3kL4KX9NQRt?=
 =?us-ascii?Q?8+bbKPiHoGEJbw4FzkI+jIYmYxxIpal1J+heNh7GOCrOTut/UVrwhB0qWFA+?=
 =?us-ascii?Q?5lsLfwZS17BTDARDA8laOc8Vn+vKVNvx6GK4lCAsnxo7+s9zZDJH948n9swf?=
 =?us-ascii?Q?hmJQdgE/u4Ih5uVQwAXGZamTnEpk4pzD0c6s40WRGlM8FU2dN2KAk/lDKUkP?=
 =?us-ascii?Q?3EsNCJdjNNsvoVPQ839lNkDmrjgKz+o7rLcAr/JYkiHZcy8ttnU22A69U3UE?=
 =?us-ascii?Q?ESNZuqxWLfGg1bbGjSNsnNMbWcURKX7iiUGvlhmVdhxGUGI7y8WjSi5HU5m8?=
 =?us-ascii?Q?djuPtztGdjDtUwiaJx4UK+OKOZ9WTKQ8y61xCZmpmjJ3Q1oc3DeO8cxPZSSz?=
 =?us-ascii?Q?SiidbtORn1iIUp6cMZ4lFw16T//TZFTRSAbn+O7SSFk1rdwdE8oGBNRKhg7S?=
 =?us-ascii?Q?mXW2VATinOV4Q3V2ZBRKYKTGsK5xljuVwX4qnme/9Za7LIRVLA/n//tTEOMg?=
 =?us-ascii?Q?ZCRbgedtLoqfUMq6l5Or/aqnObpmHFEQAlLpnUrx7hlT1nZ1aVWGreTBg+zT?=
 =?us-ascii?Q?w5xK5RNzn0qyDGH4f3EL8L4k6IHUlDWxDMVSLaZq7unEIg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DCD17F1EE7DA34FBF809E768540C4F9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2112f88d-c431-4bc6-9caa-08d8ed49a040
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 15:46:14.8570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hd8NCJDEG8XvJBq/kUkC44dsjr99FZT4jUTwG/ZJ6RjW8DJRiwEACXnMd6hm00a2xE3PFABodXkqB/jgen9F+34dhWRMa0dPge5GL2udJQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 20, 2021, at 6:23 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch fixes the following Coverity warning:
>=20
>    CID 361199 (#1 of 1): Unchecked return value (CHECKED_RETURN)
>    3. check_return: Calling qla24xx_get_isp_stats without checking return
>    value (as is done elsewhere 4 out of 5 times).
>=20
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 63391c9be05d..3aa9869f6fae 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2864,6 +2864,8 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
> 	vha->qla_stats.jiffies_at_last_reset =3D get_jiffies_64();
>=20
> 	if (IS_FWI2_CAPABLE(ha)) {
> +		int rval;
> +
> 		stats =3D dma_alloc_coherent(&ha->pdev->dev,
> 		    sizeof(*stats), &stats_dma, GFP_KERNEL);
> 		if (!stats) {
> @@ -2873,7 +2875,11 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
> 		}
>=20
> 		/* reset firmware statistics */
> -		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
> +		rval =3D qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
> +		if (rval !=3D QLA_SUCCESS)
> +			ql_log(ql_log_warn, vha, 0x70de,
> +			       "Resetting ISP statistics failed: rval =3D %d\n",
> +			       rval);
>=20
> 		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
> 		    stats, stats_dma);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

