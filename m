Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C77C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1163E65108
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbhCPQak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:30:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhCPQaN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:30:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGJKt7111488;
        Tue, 16 Mar 2021 16:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8e3DcjcmZ0uq0OrC3r+bRaRxotrtOiEanf4EiXrvojc=;
 b=ndF4a9YlxlRcu+z4TkdL3q6bsoJt2oT5IXYIuzBpUBITRMQah6IMSyZpoqQ2OEPRRPdI
 FTxomD6KfIrgM4TET8QtASPcxN/RMbW80RkKwz24wu8V2oO3sxVK6s4GoBq2vzGcxRyp
 iZQuc5Yg/yC8NhdJIkhN6FlZDzTAvFvOyG+XAQzgPOPkskI5GwKcpF9mUF6lqfgosEcb
 y67hiq0qqBo9DFjENvzMWLSMaiLkTQQ/1IS7eXGujIJ8h3hUGA8oUKQ8WYdd0eENnX8P
 tjR228LNSUZ9dUZ1+ujsdq1c4DG26qBlNh/8ZfJrGWEd8oBwsnryXOBJQjnJRjdRr8+A 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 378nbm8vxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:30:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGKxiI184205;
        Tue, 16 Mar 2021 16:30:05 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3796ytp56q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:30:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OubVEHe0sgbkstnnkl0YgKd8vJpNornSzJYZn38frDKTnsTvGGrsDGjl5RlfbGnJk8xcVBpgX5hOG+TK1jmK+WxcmpvvXrGOvj1ZbSjuf09bVF+qCB7mv+6wBhIAAoY4FML208EAE9K2/howrMJP+XmV03O746RCAhzm6bx66Ln1EFzViwL4BIm2pDAHGiwaMsWfxnYxYc6ASWyZhUMjebyBUEZGOTr0bAN0V5OOmHRznlnC3G41xjE3MwbFytRLDwQ4tOBradrbbhgggqy1vNrXLqbyCo6gLGmo0tzyZzED0tuwIfbSrtCBh7TswfFMaDICaroyoeKB4e5T+nN7fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e3DcjcmZ0uq0OrC3r+bRaRxotrtOiEanf4EiXrvojc=;
 b=UIFSXdx95M14NuBOKAMH+61v5xnKjEvAyB6Ijv6pX4Cl8aLITTtHtco2Uh1j0xDducqTmT3t9kpDNmjteaP82lzkMEaZgduNbLxiaK8H5AsB0lsOUIyTguJ03taDDjJv2nhh/tST1B+Xm6ivGOYG0+NHX1u9oLf1HxcTwyzQ50WoKG8YrUKW+53RiEKFwk5i/XEdBEnjLzo+TuNdKW1hBPFkhU2bJjmwe2U1K1jZwosxY/slgRtEFFFdyOAV31LGqqPHu8JP4En2BXx9Xbl6itmz9Aime2nPnfIBJMmbTixi3vlYxE0hvf6GJrBrWOWXN5zsbMnN2wrKOX8qbMEIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e3DcjcmZ0uq0OrC3r+bRaRxotrtOiEanf4EiXrvojc=;
 b=W1Lt4oon7iu0KP3Ev+ZrJVW52YPF76+h1pUssa+LuOuTo+4Vw4a8S/voNF2VMCPYCddhtnHeClmi1qkCB35ieTXJoAKf2NOAMieJ0RXnxYfwTDou4iIMK03tMEQMj14x/q8soqlwJ801TCueI6GmG0eXoZT7iqk10LAFu7hKDNk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2911.namprd10.prod.outlook.com (2603:10b6:805:d7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 16:30:02 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:30:02 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 7/7] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
Thread-Topic: [PATCH 7/7] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
Thread-Index: AQHXGhh0ZGxMUORwjES/RLVlTQLw7KqGzwiA
Date:   Tue, 16 Mar 2021 16:30:02 +0000
Message-ID: <E7BBFB34-AA1B-4A5D-8E54-07D44057D623@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-8-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-8-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1ebc0d4-ac47-4918-116e-08d8e898bfa9
x-ms-traffictypediagnostic: SN6PR10MB2911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2911F0414694C29359B323CCE66B9@SN6PR10MB2911.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ULSXbAk1O9jGx6Od+ytC3LQMj+biLLl/jn1zDYnqBsG/X3CYgX+XE+oxLyWSLzP9A3SKbGWIXNf+yspw9uPPaAJLvuD2ZhmxIAIv9TNNzglZ5KJXNTzwNAv4mYBnkqgpWDFk4eQ7Ci1SF/8rQa3/YSu3kcREQx3EyDmnSJK7rq0T8dcnLMX27Lj5xg7DFOLhF5v0dwYRIdCunTeOkCbLNnv9ja2pZvzs9FNOoQuahIdr7x+1LPgvs4ElJEROeBAUXkDAVTjHielbVVoEVFIaqxYcvh1/q5OjvdmZ2PyV7ISrsal1Y5uN8sg62aSA2+nzA2n7w/9ZiliYeO1lLIq9ygHKhSJqN+a02On4Kjo25RybFCcCzw8LraHDOrYaGIr41CfEfwirvZSKl9D/wTIFYMSEG9LDqYfz0Cn9LHEGaMyPiHZDtUIxgRtZlgRfHNUAT+GH+/Jpg8RaXKNqYtESBUQmHrzMSkXKDwIz4PKiEK2QZo/y6MeEdMvKyxHo1EamiyqDRLdcke9GraF7T4fw5l7vUXZzCyqqoxfq79+M2E5BUlJP9jxaq7nNYoOx5HTLrtN6P+Su5w8ru1Wkwoy7Hz7OBJUq4hcrdRfiJdki82ECB1KkmmQRjaTA102igraE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(396003)(136003)(39860400002)(6916009)(4326008)(478600001)(36756003)(66476007)(5660300002)(64756008)(316002)(66946007)(66446008)(66556008)(26005)(76116006)(44832011)(186003)(2906002)(86362001)(6512007)(8936002)(8676002)(2616005)(71200400001)(6506007)(53546011)(83380400001)(33656002)(54906003)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KotraxlHbCc41ZnuDDpU4fjdxhwOVTuHAUya4zCSqsP382NAzqPsDJ4jO5/4?=
 =?us-ascii?Q?p5GfquewAs7giqcXdaL3PwJqUnaBrwp+Yow+fH9Y/CPkJ4N6mIoVmDjGA6qF?=
 =?us-ascii?Q?Sh7S6p4sy3urfv0JeEMEN526CC3NCEhcQfFp4MGmew/QC1Xd2znxXoKnqy8h?=
 =?us-ascii?Q?lcRYcvXEh6Su67KLvQA+Mysn906mGlcBuYTp3WlZOSdgn34QO8HTqH0Uw5wk?=
 =?us-ascii?Q?YLHwWdbVsSvaWIk7Vig2qdadQeYzfet+HXldnUY/pxwDBgkfrII5jrQxOC+/?=
 =?us-ascii?Q?5eO7f/JV6jwovexXvQxn2vckLAbaITIja5p0BSer5kh8Jn6XW04GX2lGzamB?=
 =?us-ascii?Q?xOLARfnWNllwFxygWFc1ro8EYPQ/bzv/ZjuK486t2W5t7ShgVBSkUfkHqjgV?=
 =?us-ascii?Q?S51Zbvr9BE4L9raIWH+IocKvAOKgz3LRR5GVkurEu2cSxMsAbu1emavGjAo0?=
 =?us-ascii?Q?/dSZbuETOdO48BolaaIek+lbu3O4eU+FN+DVcTzfhS+2l73bQRfJL/2xbVyv?=
 =?us-ascii?Q?2OmOhALU/AvBv97wzfzwsoNdx2/8zmWKwqMqzKrWRd6+80rOFTTLsZhKEszE?=
 =?us-ascii?Q?9rIwq03WQJbaaiH8/sOpJu4TmJePgWTOGk6rwIrgz+P9YmdJofs9pDil01C9?=
 =?us-ascii?Q?X6uSimZpcXl8JNUbcCbxuIDvJvLXweil2mkFijB1wzAQICGKLlNfEXoEGhG0?=
 =?us-ascii?Q?resSk0B75U5tL0FfPhrr1TXGwzVOlS/s6hE7QTf9aF1pZyHU8//emcz5Jdfn?=
 =?us-ascii?Q?ikvwW9e+x9vOpJNq8dVuVSxtaDBt+L15UL2+HKSA1BFY6nh0tRK7qMqcFDTc?=
 =?us-ascii?Q?a0RrxfPREm4jz6hNqm7/0f0VJZ68CE8j6oCVizpjHvnC1V2NP9XhY96T+2rD?=
 =?us-ascii?Q?s+Wz9HMG/El13rW9WzBDU9vFg7SPJPHEu+N+XSUM7IELSshs6bl9wr56ia7B?=
 =?us-ascii?Q?MHZQrBTf9rJ9vudPipFCHQv8qCep40iTuFJBRqcG4M+ch8POEncwNDTvjd6e?=
 =?us-ascii?Q?ns6wVaNkFop71XuuPRjKV1kkNuBU9BjC5uRajbWh+V4OXpQYtT9NyAa7z7lX?=
 =?us-ascii?Q?/g8LYZRKilTWpLq1hBYsdqQO/zB9x7it64Ntva9OCdbIBwo5o6swua8CrxXX?=
 =?us-ascii?Q?GOh1uZy+vtaQ04E7YCAt/78fcAqnqMi6KiLbi54P4iIihkI+UuqYzPl63RhZ?=
 =?us-ascii?Q?AW4VG++vRWW7mWu0Qi3MC0jq8dtsLRYObR5SK4RJxZcdjU9AoXYJGBIEzbSh?=
 =?us-ascii?Q?E0bR3IG2wd6WaxX3zFBUljLW5jgaDspDkyPzoClPYV4AgURZNlMsMJlBgeBC?=
 =?us-ascii?Q?uU4Dg8Cdv+kHSAabcn50Hx9gf2tLc4rShq0GLXLRwC95DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <769CBFBF83BCBA46B3D3615782145F0E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ebc0d4-ac47-4918-116e-08d8e898bfa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:30:02.0436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZHPRld+ywcUnghzhG3hel1n4d9QZw/4GiotL4MxHadKaTZN4H7+EhT5M4Rw2tq0GmsGNdrK36zHZpUOrA7vPWFvKAjKTLH891toHVgaEv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2911
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 15, 2021, at 10:56 PM, Bart Van Assche <bvanassche@acm.org> wrote:
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
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 63391c9be05d..ad57111f8cb9 100644
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
> @@ -2873,7 +2875,8 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
> 		}
>=20
> 		/* reset firmware statistics */
> -		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
> +		rval =3D qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
> +		WARN_ONCE(rval !=3D QLA_SUCCESS, "rval =3D %d\n", rval);
>=20
> 		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
> 		    stats, stats_dma);

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

