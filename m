Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B2EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 17:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8FF960F70
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 17:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238132AbhHCRRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:17:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64432 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238113AbhHCRRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 13:17:17 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173HGSNq010314;
        Tue, 3 Aug 2021 17:17:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oVnnyBd3QJCUEN98VDZcG9+8OOMc0NtrXCuRWyLfRyg=;
 b=pkqIhczDkKaMfqymxkasFMDmR7LZXp4vUmIcc1E9t0RRPa1p9puFMQ+js/MKBHN25Ukr
 nU5BkKJDIJ3AsljyvKgh+Vtwn9R1GIjmnLbZFleQ4a/mSdT0JU8phdra6FkSCZQ+yQN7
 LeBNy6EAAlVEXIGwX82dzbmE/frEPsGRJbd5NwPn84ilHYeSr4tMZXRc0jitXHA5q7op
 PE6PbjeOYAxlRPzd0AHWBu20M0GzyypdA290IZZAPPVdxKFBXACOo8Hm53M+YG/BbfLI
 FdMF2klBbbgnr6vzDjj194Wk3G8frtJoPrAg4Xte1Hh46HLfoRVqPniDVc3Gf4QVV+Fc 1Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oVnnyBd3QJCUEN98VDZcG9+8OOMc0NtrXCuRWyLfRyg=;
 b=Y91gXdLBLrAOR2Xzjgn+VlNTfgsIMfITNz0oZzaLm+NsAu6W9/aDwecjq6SK4DYK+Wjw
 PdcJvqmpreja5aczZp/5DZSiOiavMO9tzxq/kcKRCZaNGMwHe0Gkh8zI0sEiPWZBdl/G
 c/VvrUmHS6fO3LD7oCbFCi3t5Dbe5S8QkiF2R/fD9Hsa4xf+VAkEFadEmDWjrvHl8gF8
 S52I5roSCB7avPFW9CLbAY5yDMJUSNEHXNqv/t2pgFjg+LFSBQi7Mza6jbUuRI8en2PR
 669KCneZSQHNxNnb5AWF5/7V3S36N858kcuQnV44M1Sj8uWSisRmlAggsvH/tqeHnNiT jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6gqdbsd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 17:17:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173HFK98083447;
        Tue, 3 Aug 2021 17:17:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by userp3020.oracle.com with ESMTP id 3a5g9veqyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 17:17:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1k9HVnzlKCCAJu5Qetj0Go0Lko5kw+Vf4i3twSsUtvJUosdErI/8IJ/Xpz7VJKRjtHZcN6e8IhTrJ4ZkJ0snH66ToiGbRHW0ynkH1QmUHsClBiIxg3RkUKoS72wEuGgmqIYze89qhFRqH+EBea3kxizL5AzdSdm87jlArjmXbOkivp/BCw8ejYlcyhWtXzZBIxZNRJe4F/YrCJXjvqjmBGVBBDyaMeIN9AN4Xs+wPpQ+r0uX09PPUMOmMDhlHFkkeHfTqmEIbpjNgqpufMnnE6YfLquinEhm2jQ1tza/zOnD8VLC4+MHgHHSl01Giayfr7MRfcpGoA6zAqCokt1ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVnnyBd3QJCUEN98VDZcG9+8OOMc0NtrXCuRWyLfRyg=;
 b=l9/70oBSYNN5U2H2JuxppX+9/OKACEDcQis0wzB80BVq34h+H7AzB+D74HfQEn+eCzxryjVOD7UcSkvdaIiokD9NIlw+LxsipE0botGxynr8u8/GIdyuwBJQRpZ2A7Z+6/craTHHHrzqX8n0vAutHwnv0uVRVsW2qQYs5GG27kVLprhcrLrqO3nqWYhC+JDmIybWrOSuapeYtpe3FEEeQzcc4HTQorgvjvrMOtLen4XbeEGCzOg18f8BdkyMopO9eQqWFL+SZYenmtslL6wFZTKdV+r+K5YzQQoMPV53oLzSnHFlKO3foSlYb0XjzvfRPAODUoS747huL1lSNQkYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVnnyBd3QJCUEN98VDZcG9+8OOMc0NtrXCuRWyLfRyg=;
 b=XJLkHss2pblKCBaI3NQMD27aFFOc3ijOlnGRYEPEdBa5R/KMlMF7RB+x9ooe1oPQS9soLz9wjGgyu/LOgkvW8OMZN9i3Scl6pp3TeNw3VVlF7Gbp3whP1fDuBmhYZgdw3K6x/VKY96T+2u06t8kQ1vhpuJraonPcAV61kS376m0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 17:17:00 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.015; Tue, 3 Aug 2021
 17:17:00 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Fix use after free in debug code
Thread-Topic: [PATCH] scsi: qla2xxx: Fix use after free in debug code
Thread-Index: AQHXiIAm14zZm9p/FUmgNYkpWzi/tatiBbuA
Date:   Tue, 3 Aug 2021 17:17:00 +0000
Message-ID: <203E8A94-03F6-4AF8-A092-24F708470C81@oracle.com>
References: <20210803155625.GA22735@kili>
In-Reply-To: <20210803155625.GA22735@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8dd2d6f-1753-4f8d-ef29-08d956a28133
x-ms-traffictypediagnostic: SA2PR10MB4796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB47962AFE0743D492B2E1E73EE6F09@SA2PR10MB4796.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1naHMu9qdlONm+5xImiROMOCmVrTq08wGWIxOmm5P2tVUnJperRRJvhDqlU73OvCeIHae/1XcW2CGvXbjx5Z9mrAcjOfO/E97E9ZjY025Z9M6PrSktwDS7cwzwiwGVBH8I6GiQFJOfqVpX1nU3z/k9SrmxzG/nPmXDFiq2dd+9Ud7hBIfY6hU3KTD5kjvHPpL6JsGErwWbcwKMAOqfpAVqlAgJ/e/QT3ZDQWE3Hi7xWa1cwZwNkyYE9JARXL/6ua8cTNFnyrrElGnTKRhCnQxIxO0jUBryMCA8lPIu+7vdo560Uzc60WxE1Ap9FJPx9ZFJPRKNszmUAxUIGaU2lJVNOAlYNQXOuN1R+CwI6laj9i+h7INAjhB5J4ipaKnXA1x2hhctNSqXV5FE+XNmrRls89HjlGApE57/Bob3veEDfFzkOXWz3Z4Dk3QPKREm9mZnuKJXO0080wlKkfACBDn3V5g+eIPtkRusck25y0WJpZqOPFyQikENe9g7fjiK8VkXn8VDcVK67ZS5Exxd6kkjCRmM6RLUgUc5uDxo+3u6aKWMIGxFvVT+96rukYajNDcayZ+O6oM3AI2t8RH90HfqIcARtNfSmSYTXFQJFBmH9tOAcPgvQRr6XLoOePfUAZ+n1WQ8LYA9IFQaAmGvQvOSzuw/9kTo/UoZEK/EOidhIokd0r+g0BCe7NqvTF0XTP6uIYrs7BmucfdNTMWvgfu2as2SxvXycB8MlWs+2TPOg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(83380400001)(4326008)(33656002)(86362001)(76116006)(66446008)(64756008)(53546011)(6862004)(6506007)(66476007)(66946007)(66556008)(5660300002)(186003)(44832011)(36756003)(2616005)(478600001)(6512007)(316002)(37006003)(2906002)(71200400001)(8676002)(8936002)(6486002)(54906003)(6636002)(26005)(122000001)(38100700002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NSQc/v4LSgAzNhVurMLcybyTAHgsxHQbmFlcuVOHM5nl53+fCqTv+O4IA6s3?=
 =?us-ascii?Q?QRwl4yWuhT4bZB1zSx//MRWr0tudChmILYOSlxdcV2rHWNoDH6B8oMYGITzK?=
 =?us-ascii?Q?z0PJWZaSJlRH3AcDMF2YK4JGPgohFE+yqvkhhtycwPCWQ8OJ5MQGGIF5AQCY?=
 =?us-ascii?Q?Hjof54stw891cciILnVWhUucx4kdUFLNnKjkmnJf2Mplhy0z/klHJfWJag+Y?=
 =?us-ascii?Q?Udcw00dFKl3Xzefz1spztKcQIAhxZKmNYTCzu6RlvaFaBNAfaAz5zkgxyA7N?=
 =?us-ascii?Q?E46Jf64NL/GyyYdxu2F8Z/xn15HMoZzFM5MUewiRN5xYU09jjDFZ2LFHNGyD?=
 =?us-ascii?Q?XrM7vq//zK67LGm75VzddokZEwSMygGqEqkmoKY06GRVldP35wjBPYfQSq/R?=
 =?us-ascii?Q?5SUMvyMufdJ+tvJb9HBi5UfsIHyJ4QjLCBWNwzI24YqsKVRyeO9J+ly4oBDJ?=
 =?us-ascii?Q?oRn/6oMED+NU5eDPvmUB3aNjgK14rCLCpS7aoEYi1M5PloToXl51wQFoJ/3c?=
 =?us-ascii?Q?Gg+SNG4ly7jd0DGcVB8cr/mHpX3cyGb3LH3kJtRqYisQTM87AH/ghHBMz1ZT?=
 =?us-ascii?Q?PqhX6EQfALvOd4uvVtvwI/xoO31i51MKH1OvJDnOfkHFoBPrzU9p6gooS1ob?=
 =?us-ascii?Q?9aN0GAAKF+LwNjvaCmvADXum7WUzSkHQDsn2vKfbnHGl3egetjMBr+gv/dqO?=
 =?us-ascii?Q?2/MAQ9awXuVEgoTUf/ncYb78LBo9GZ5Ae08YAD3N4ZRBOIuHTvTS5xGmX0FU?=
 =?us-ascii?Q?tuBh4d/anv88ywGucaBhJCIhJ8lb0z2hcSlZT/2DkG43JBCov/15XCRNMXEy?=
 =?us-ascii?Q?iQlqCHVicXKKcOUrgEA7kQIghwS5dYwA6k+u+8ghM7kTk2oSzevr8LMe4ynA?=
 =?us-ascii?Q?O48s/FpqxFFV4IpAnxSFpo0f8+31D6QC0QKN9Ozc4xXMsQGyQ+m4vyLlWut7?=
 =?us-ascii?Q?3GJ8zqkaK0D5eTvZq3sfd7dXd3wxWY1V0w+IbCXEd21WUhtBgNioG2S1BP69?=
 =?us-ascii?Q?0Y9vEIrMwvXDIMl0TiYnUlj/u7IHt0BKiIidwENQmh5+TKT9+fRgcIZyo6bh?=
 =?us-ascii?Q?8QTVVhwwrr/qfhuVfJ8VrZ0K7VTyFT0AWeOTR2g6fUJkxEArBD7aqxx7oUe7?=
 =?us-ascii?Q?J6xdq9QZAC/C/TeHniSR58tyUcj8PlLmFsqDXsOciGGemFRHd2FDSZJbpDp/?=
 =?us-ascii?Q?SStddW1oEOASaxdf1LJeZFFa9VKCL3WKshocuCQJHj8uMhnKcILkwGAbgzSm?=
 =?us-ascii?Q?chc6drOaD1vJeLqbVsR1EJK+e9YmE+19F6BJPUQR8ttOuYcQduzg0t/4A09D?=
 =?us-ascii?Q?fbKXlWPj7CprI7G3FKB5Pww0?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C1B47283B2974498DBE74C3DBEC4A44@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8dd2d6f-1753-4f8d-ef29-08d956a28133
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 17:17:00.0471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pw80ZEw7KiCl3eqF0m7kL+uxWCChTI3EzvRUt8Cjb+cvdvjavL4VA1ReyA8mfbI7Kyg75r3scCs52y0uU+aS90ZV/gQ9BraDM1zvLsIep04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030113
X-Proofpoint-ORIG-GUID: swX14HtfeEjphWqLFvSEjJaSK1JMPgy4
X-Proofpoint-GUID: swX14HtfeEjphWqLFvSEjJaSK1JMPgy4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 3, 2021, at 10:56 AM, Dan Carpenter <dan.carpenter@oracle.com> wro=
te:
>=20
> The sp->free(sp); call frees "sp" and then the debug code dereferences
> it on the next line.  Swap the order.
>=20
> Fixes: 84318a9f01ce ("scsi: qla2xxx: edif: Add send, receive, and accept =
for auth_els")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> drivers/scsi/qla2xxx/qla_bsg.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 0739f8ad525a..4b5d28d89d69 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -25,12 +25,12 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
> 	struct bsg_job *bsg_job =3D sp->u.bsg_job;
> 	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
>=20
> -	sp->free(sp);
> -
> 	ql_dbg(ql_dbg_user, sp->vha, 0x7009,
> 	    "%s: sp hdl %x, result=3D%x bsg ptr %p\n",
> 	    __func__, sp->handle, res, bsg_job);
>=20
> +	sp->free(sp);
> +
> 	bsg_reply->result =3D res;
> 	bsg_job_done(bsg_job, bsg_reply->result,
> 		       bsg_reply->reply_payload_rcv_len);
> --=20
> 2.20.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

