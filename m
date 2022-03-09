Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D609C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiCISoB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236744AbiCISn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 13:43:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1753190C20
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:42:58 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229GiPQV016960;
        Wed, 9 Mar 2022 18:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BQVzhSITi/wwVMTXF9qc4A6K3I0sK4a4TfsdRAqm00U=;
 b=MCfq88/uHjMTTehFSKB27fVbnK2tY7io8qmPzw0PbC+mLU0mT8b34PXY5Q/YJq+BOP+T
 XKr8a+zP73ccWk6NFUZQwVfEqvOdB475HwlLpbRLoJUofozMwOWHbEvkFfcaFF/evsPw
 Okt9EojHtnfdWYONuZ2uS2AN0JCtdqYy2p8v+kyLOh1y9RX/MjLs/pu+BJ/2o0h6uUBl
 O3v61lb0/1aSxLW9W8cqvzE4T2us4fYLIjO7bUVOMJj4UPcV+OX8WmYxm2A5apBE2vtD
 4kl9/VCfo07oUvGXuxFVTH9I/wjjO7/nttwXePlAOjDTdSRf2kiNVUWDHYhVjGf7igDP Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cjvr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:42:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229Ig7YY031573;
        Wed, 9 Mar 2022 18:42:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by userp3020.oracle.com with ESMTP id 3envvmq4tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:42:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnvrpoQxp13VG8D9//Q0hC+o1CVnKKpCAcyT2fFRKpx1E7YjgbzQnuHa5MFxiQmhHu029v9CrOdB3n3QtwHjT4HAUgxRqiq4oFgIzteL9RoYdr006Bd85WGR1UdpTS3lJWu6aQ9CsR6/kUVSyNKbxAxZnygI/7wuJ5BjC4RcQ6bjS2vncuubstBI7kou37Xxt5eZKgIjEqsXRCguN3nxQ5GHE7/6Qa0eeuo5aoWB1NGq7OM9a84+gSyDh3UuJUHZg0ht3SCYAQG4yyvI/t3EpvHiBS0xU/y/IsbWGU+v6aqhJ9u/9OQXAS2UGlcZqE2uwx0KsorI1qg8BSSYrvrK7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQVzhSITi/wwVMTXF9qc4A6K3I0sK4a4TfsdRAqm00U=;
 b=jqrohQHaqhYmz7Ojlivr6d5vwwgM/6LRqrumSkT9egSjpQ7fPBmnZRwi5UxrtvLqRRjwkM3ZJ7WI5IgK3AVAVR5ol5e4KXgfw8xigOkmZN4rLR8G13jsbs4tLwiVAV3lq22ila9i5bFEBNl3Z08vuJjdoFk8UZISz1LGheuIj0zQCh2DcF4W1kkD0TeoVquvaZ5Q8EvdXs9fWerGbRB8DrHMNzIXARkY9YDJYfAXxV2wgQR0/SBiifkqNESoTkNFQQ2MMyMsrXf7C6x+Bo+FceOrs/hxIJMdSU5Cv7Qs8evVtpRbM2uvtK5eTkTwgD6A8vlDvePSzM4olAjYlNyK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQVzhSITi/wwVMTXF9qc4A6K3I0sK4a4TfsdRAqm00U=;
 b=HgAGTLS7jA0DDduOEUxTYAlBaE/99jw02aWwFv21R3phvaf3qSvpesaGJtbV0weGX3VwmrINeoTb6dlDVDiRo6T8mOysVhVoA9L121VVh3xpH0aH4wbXsV5shkU1QWcZDQSHBKZtueAYnXbuz4JpmF9Jl8Oi/KChLpLn/FdepqM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB2422.namprd10.prod.outlook.com (2603:10b6:a02:a9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 18:42:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:42:53 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 05/13] qla2xxx: Fix crash during module load unload test
Thread-Topic: [PATCH 05/13] qla2xxx: Fix crash during module load unload test
Thread-Index: AQHYMsWBNBj5Zg8unU+Sp4Fz98dGIKy3ZW2A
Date:   Wed, 9 Mar 2022 18:42:53 +0000
Message-ID: <13CBE1C8-C584-43FF-A812-CD1B6A0C0970@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-6-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03e087ae-711a-4ad6-837c-08da01fc9f00
x-ms-traffictypediagnostic: BYAPR10MB2422:EE_
x-microsoft-antispam-prvs: <BYAPR10MB24223B9A9DC8F51FD5368BE9E60A9@BYAPR10MB2422.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 42o16L2yESc7w/q++1OATrANDeanc/C1bbKl+g6T7aAh6eS9fEp4LgSB5wa7GseZUi6ha/R+k1gzp6gc3kwVJubNnfDvwxWvUN+SwROGVibWt7+7iifxAZkv7PrV2mawmrLv/07lERx918sEcAmAtveTaa2jBjGQILqlnuX7Nh4foq/UMQ6Iv0vWcqK0t4GUnHMjwSNyGVckqe+VtuvRNZb4PdMyg9FlQzzO0uR6v8bewWg7H9Qbq5+WaDgyD1ktc11puZXCbSOZBXcn0wD4momlBrmRqAhlAvH0qqOh4jWHG666dRwKcbyrlmGFxwdLF7yiU/rq9RI+ZM1jlkSprBkq1OtlpP+TnXFpr75BwWEDS/Tlt7dAZL0r99Gve9sxRiTo9TroiInTnuAKok+lDut9E4YLzcxDrodopUdyjQNsDPKHtNV3zzGYKIR6ffk16LjIOUOtXsXlx5xzhExYM55ax1/MnlgUpYSi4zC5ZRoT41isS0s41A/A/zEFL9s79PNIj1ZfRhXMF1RsFB+cKpuySGQKoJuhwFnUx63ob2NCDu8Pe3p0sl64r6Nofj7JZKDhUYMVKPNsiOyTOkeIuPrs6vMPqqpLM+jiUUy2/ycmaUw+dY0YiPU1c9vq+GqelWTDNn4y+w6pv4YsNOEf3UZpOLx+qU89HIMyk9x5WIr5uIxikg6jcstcnFbsGrC2z57k7aaonbZFz+YBsGFcAQf7tj259BibZKmJGSFreHpJUFiGvmT5SLMWz4Pczde4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(4326008)(8676002)(6486002)(54906003)(66446008)(66946007)(6506007)(6512007)(2906002)(66556008)(66476007)(76116006)(64756008)(38070700005)(91956017)(122000001)(86362001)(83380400001)(2616005)(53546011)(186003)(26005)(38100700002)(8936002)(5660300002)(33656002)(6916009)(71200400001)(508600001)(44832011)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mZl3eunzgSIYiVxyH6X91Qr7Ecfy+PFhshXzA7m/ChUSVLdTRhstbJ5ZgWZk?=
 =?us-ascii?Q?8gBfaL7i8S26RaTHfbDzqp2Nzl9vWuqTMm5FiRbeQrYGDpld4tE4pPWfONEo?=
 =?us-ascii?Q?dbWMs8DS9/WOx7NNN1fDjsaFxo5LPgEy1ORCogvBao/WGsP30UqKH08oQh1N?=
 =?us-ascii?Q?ldrkAjZ4W9duukqckdh3Fc7bSEGRZc7H8o8FnezebLMNGXarlHmBv5lelp1U?=
 =?us-ascii?Q?L5jo4hUIEHPOe1qTT3Z4+QCz8VRwjFqpvklwNdoJ9dX7u99o2tKUcWSz0GT9?=
 =?us-ascii?Q?ZpqoW0Gvpyp/YL/5iiaVix9CFSmMNQN9/JVe/tfUkCMoi2N7gAVfvb6hNVQF?=
 =?us-ascii?Q?w8t1feI0lrvH/OtTQa6fKGsv8WdMFPBhgTNhfOoMQMCme/FweECwPWjxB0oT?=
 =?us-ascii?Q?EtvOONuhpoet4jnVyVkJCW8pZobrcpzvawQnz/rOdGeYkWmCMIvMz3fPchRA?=
 =?us-ascii?Q?bQCdtCxhuzWzZav8Fu7jMLm6jR1PrAA1iNzWiS16J+aLJSjRe2SAqSTwfLjj?=
 =?us-ascii?Q?WecK9Ac+Nz9LNdfqMEq+gAVEdSTSZQmgzfjdwMGint9BlbdWQnk1dzP5ZU9+?=
 =?us-ascii?Q?4Eek4hlTkY/sY2SgZvjMRMjZLBXWBIqvVMneq3zX5V1A4jyXTtcgvVkdhGdv?=
 =?us-ascii?Q?uKrAk4lBvo32F4sUtgRQYuhXAi3ZfQyrfQlBO2UOZrad4DBpCRnbYWOHYxxE?=
 =?us-ascii?Q?m46RhY3LxIvg3rwZnJLBcAJhSQtJLGMgua6V2mHK90sCgedF5JSFK0NXTeqz?=
 =?us-ascii?Q?JaFe/bN96zsx1qfiXI422B69bLiKRvEx3wzXUSVe34QL44r634B0Twx28Mbi?=
 =?us-ascii?Q?ffZZcXHmcvCaPNJ5smMdZ81oy2GA2rVRVqebNxua0j3bATLQi1EIaZ0BjRhG?=
 =?us-ascii?Q?KZnxcJ7uVEZU0EznnmefDKnSwep5jusgeQk0aeSaH++2HP11V30ub495Qu+T?=
 =?us-ascii?Q?jSmNmV3vKdcqTVEIOyYKhsINsWOVbbhCyU7YqNu6AMvV9uS+uSE2GW+sFzvL?=
 =?us-ascii?Q?C2o8Z9zzF0as0GgVR+iZxieB95csBgf1Ll9hIi2c/RjE7gYLXio7Jq7b6u6B?=
 =?us-ascii?Q?iqQSAummwtYzgwM+ZI3B6WI3Qr9VWY8kcAb+SblOS4BRI0hlsf5N7M+7W5wy?=
 =?us-ascii?Q?yr9xZYfC9mRwk4gLRDaIZLkHQDq3L03ubBzL225gf1yYGp6Pq6ibiXyjTVTr?=
 =?us-ascii?Q?NXIhm38asbdkvHrzSJuC048IU6fWqw01Z89dbtVilw9b9yf8NMtQLLb8V/DK?=
 =?us-ascii?Q?mhDiPvr6I5AXwNq3M2AYFYEiKApqEk4tsDvKMwn7EOyCQRDM+KWRfaxwtzpe?=
 =?us-ascii?Q?sd8LnJkKX7SZ3suWZCdiEFtiVLWSw87aZui0pJVQ7keD9OS6m4EQEFp2rXcD?=
 =?us-ascii?Q?ubfXrSbwBRBc8DOV3B4AlLlCXfYJOeq8ASK3IOeBsX49xkT7Ab72yZRTriPJ?=
 =?us-ascii?Q?VE/YoqOR2Nigw1ELowJbZ4+Xm4IOeasryxAGnDcr/E1SEjTwPri6s8RFTDnI?=
 =?us-ascii?Q?aoc+WEK5IOD4UInDQfOXOJxYngKLrECxnvauMDd7ZfcjJHzJe0hzICetPtPY?=
 =?us-ascii?Q?ucad1uqlM5KBqB/6mmH10GYupYmY7jXLMX3+2CJyMsEvqLYWYx+m08uD6D8F?=
 =?us-ascii?Q?q07H1SZJ/GdrHqaBj42hH6bcy/0s4t2Our4jThZXPs7GaVy56A3tLLYrNMMn?=
 =?us-ascii?Q?HOmtKyxV05S0EqhREEEOLuZq4Uc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <92C30D2B499FC44B9ADACF7D0C393989@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e087ae-711a-4ad6-837c-08da01fc9f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:42:53.6718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7mnt4qyUj5Due5eswD6SMAFQQG4DKeQulhKqsAPupTQU1UjxyR8eivuUG4538Hc6dVbSNkabreKNmB4fHm/lLnqIEZIPkGpI7eFOsqEPKMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2422
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090102
X-Proofpoint-ORIG-GUID: GsMH68ngwm2uafAz4qIKh6E1dudpPTNg
X-Proofpoint-GUID: GsMH68ngwm2uafAz4qIKh6E1dudpPTNg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> During purex packet handling driver was incorrectly
> freeing a pre-allocated structure. Fix this by
> skipping that entry.
>=20
> System crashed with the following stack during a
> module unload test.
>=20
> Call Trace:
>          sbitmap_init_node+0x7f/0x1e0
>          sbitmap_queue_init_node+0x24/0x150
>          blk_mq_init_bitmaps+0x3d/0xa0
>          blk_mq_init_tags+0x68/0x90
>          blk_mq_alloc_map_and_rqs+0x44/0x120
>          blk_mq_alloc_set_map_and_rqs+0x63/0x150
>          blk_mq_alloc_tag_set+0x11b/0x230
>          scsi_add_host_with_dma.cold+0x3f/0x245
>          qla2x00_probe_one+0xd5a/0x1b80 [qla2xxx]
>=20
> Call Trace with slub_debug and debug kernel:
>        kasan_report_invalid_free+0x50/0x80
>        __kasan_slab_free+0x137/0x150
>        slab_free_freelist_hook+0xc6/0x190
>        kfree+0xe8/0x2e0
>        qla2x00_free_device+0x3bb/0x5d0 [qla2xxx]
>        qla2x00_remove_one+0x668/0xcf0 [qla2xxx]
>=20
> Reported-by: Marco Patalano <mpatalan@redhat.com>
> Tested-by: Marco Patalano <mpatalan@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 62e9dd177732 ("scsi: qla2xxx: Change in PUREX to handle FPIN ELS r=
equests")
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 ++
> 1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index a4546346c18b..d572a76d0fa0 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3904,6 +3904,8 @@ qla24xx_free_purex_list(struct purex_list *list)
> 	spin_lock_irqsave(&list->lock, flags);
> 	list_for_each_entry_safe(item, next, &list->head, list) {
> 		list_del(&item->list);
> +		if (item =3D=3D &item->vha->default_item)
> +			continue;
> 		kfree(item);
> 	}
> 	spin_unlock_irqrestore(&list->lock, flags);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

