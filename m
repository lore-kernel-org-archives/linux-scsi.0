Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9898C3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbjHYBYj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbjHYBYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:24:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E223CE7D
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:24:22 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEYHD027013;
        Fri, 25 Aug 2023 01:24:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=3UNiG5VqL9hj7ISIhwzioqN9gAlsHk8NuCrlKftInSk=;
 b=E1KHge6QP4mTtOu63q7jxHDHXXad7ErZOl4DpGvU9VZAI+7x7EE4+Ho5TPr8X4wGaoUo
 0ft8M2rKkODFr0zlQppZo7sqaZ0dMC0+9BsuN4wOYOxPI1tRGBf/OmUVRTvJQKnHdKTC
 Ld7/8EwFu0+FLNyUYFEQ5LnoARU/qC71pdWCtGZ0cz8zFvaTz1fl/FzdnIZtoEXHhtRd
 C1kUOfnnJ3bedPbkaTnY6EWcAOhp7yycCqziL2PfEFDDks8+xWpBlhUYBkFUM0KgYRzx
 WjUPzTjbXK3rMm4E+oJ2mikZWtQWq9EvHZ4PZQZjQvldgc0q+vqwEbUcTSQdf6nhGGnp VA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20ddd52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:24:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0H29A035753;
        Fri, 25 Aug 2023 01:24:20 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1yq7bpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:24:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKJYVVo5bYmsvZg4EcvC4VjVikO2IJ2b22JOEYkrRwMxYBwkAPz5G5gnHz+lQQvZOud6hsObljjluq8BRVC7addJLJX76WQ3oyatYRv6t8Ql6PmAxgQgUq4zfSgWMxw9fFE7DoFZnWPnfLRj2DdZY7TpM1Y+zCXyQh3JRBbNsqEyb/FwoknWNQyF2ZY5zZD84PqJ6cget1rb6oxtYs64Y7y07+C5M3ztBpi3JEZryf7m+ZhoVf7SqRcqA/0CZreIHSSp/ue01IaT9YO+oVgvpVxXVmkNma2EGLY3cSAT4IxsS3kCSI+8w5VyzHpeEhruIz6CWNr1bbC1dgboUHoHAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UNiG5VqL9hj7ISIhwzioqN9gAlsHk8NuCrlKftInSk=;
 b=ejLNQttgJqnt/zPs3rW6cwcHDGyuWCQAuznP/ZTbrcqXLWJAkYe9rT6ESeSLEj16tHFj4L/qJfTYXfiugD0Eq2fYquEZ2Cfy+mpqH+XIQbLUx4QEaFLIvEaim28he1a6aLS0ysM3zeICwfnkUcVe1BL5Yo9yFCqIi0gmhmHyzaRUFuwjg4jtlBo+3YvMwCc0P7ZHU6vnfflttuOcCTXxSpgK2n5njiXio1fz635Tg2U37+XSkTENtry4NmswGr8QLzEGSHN05rUICLqm/uqaxeQCprXs0cpB5dhYNWovVlDEEtr+x1KSnn6kvEa7bq8PSnZ//hcpqWze4DZs3GPCEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UNiG5VqL9hj7ISIhwzioqN9gAlsHk8NuCrlKftInSk=;
 b=eDUS1wR9bW9unoRPAVTaVESBiwF8KgezpZAFO6+apBQ5DtjehhyOI6tdMmvPsn6hwY+d4pSJYWz9t2W8p3cVU57HaVeXwoPHVCMEtzkM9ZRK75R378eM9kCgYK4vIalt/h2gnR9zrjGpvLs/unXpLZJ7VAX/YS2r6AITMHFMiek=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4366.namprd10.prod.outlook.com (2603:10b6:208:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 01:24:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 01:24:18 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH] qla2xxx: fix sparse warning in func
 qla24xx_build_scsi_type_6_iocbs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15y535328.fsf@ca-mkp.ca.oracle.com>
References: <20230824151626.35334-1-njavali@marvell.com>
Date:   Thu, 24 Aug 2023 21:24:16 -0400
In-Reply-To: <20230824151626.35334-1-njavali@marvell.com> (Nilesh Javali's
        message of "Thu, 24 Aug 2023 20:46:26 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: 64ce88a6-c6eb-4f11-5dfa-08dba50a0083
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ygcEGeNgHrK7UGe/7q61E192baaKn4eal3Xybqjvcjb/iJS73/6HXxEsguoijhOcap19wgeA5uLyonyzNxa6Q0T/O7LXNAFeuk9JxQFh9P7NHXiQJzi52KaGFCVogmoh+6Tbbh+w49tvLe7mMP3QdF2Zv4RHT9PfPmyytoMQGY/slcz3xCFkOVyFXzrOCW524FeKqzvhw6D4B6a3MbuI9gVL7AiD88KDCogll54XzNW9UUtywb1zbh5tLeWsdERwMh7z1+aSjqt5FnloM5K8iyLKWIsn/56acpv2mIxchQIiRVfx3L7Czpxqtnz8wTi1omJDgM3O6LgPZnmV+tc1l5GDiRs9+MW6V1BWHLoYvZAIIT5crXaTKiQk+BpRvYsSERtlcuVmeztTD/rhSycZl2tdtp0cDu9yLdF4jM7Itpd67T/w4b7JSwuPCPh0HCHe9UI+KsoPZoHhzaFERN4+50X613aqeCHz5nsTeX1X19zFkDP/TV9bIEkz56WobKyFWl+scBjUiZ34K9y2XUopEF/eziS6fLiW3nrtiOL7awQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(186009)(1800799009)(451199024)(5660300002)(8676002)(8936002)(4326008)(83380400001)(26005)(38100700002)(66556008)(66946007)(54906003)(6916009)(66476007)(316002)(478600001)(966005)(41300700001)(6506007)(6512007)(2906002)(86362001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gwT7UElBJsSMOObmgl+esrnpG+aWayU5PMO+Vk/l1Et+3t3unPdRjzj6vV9x?=
 =?us-ascii?Q?cX1iMLbUEV2NANy86iZUJv48FK3hmRoxXqb23xRCaI+jU+RcOxuwElQUYdVY?=
 =?us-ascii?Q?ZY1WBZ0IOb3aEsYAXfNEfGtA2WoqAEzCm3EOa4zWAfPcNF7A0QwFVZT2n7YI?=
 =?us-ascii?Q?ZdpA1gbTaiiZmbAXIekl+/0zUP765lEAx26dH7wUvSATvREo4UWcmj3geDWo?=
 =?us-ascii?Q?B7ZDDsTNnaB5X2y/T/bbArojxvjSs1AQlB3kTDTXfIYlvaAQWPSa6ErzF3KZ?=
 =?us-ascii?Q?JUrsBMXo9ctI/jvDt6XiyoSfv6FZfgFPHmBZS7K3DYqoU9Fv65lSVn08GP0K?=
 =?us-ascii?Q?T4D+k0HwxCWL2wjQg/A9f3j5ylO/Oef+Mo10AeNbR/DB2AE3DFQXQA9/+Eex?=
 =?us-ascii?Q?qo5rX5nr22IuaECORJn8UknigVJLhjehJ1UyUtLe8+kx6C8/N2AaA8OaJ6Sq?=
 =?us-ascii?Q?5Hli18IbFtmr4j+4x3+q+wPOD26hfIsdBmObst83U4DbTTUWTPOWkPOTvWoT?=
 =?us-ascii?Q?JeuGOLQzvIcFFyNn+daCxoD7yVSRsXk7zXiQ3W9bGrsUiSx/YlXi5kSEyAGD?=
 =?us-ascii?Q?/TJdmcLyvpy9Ysge69VottmwYQsAefYTxKt+DuUvWyaqThhPiQLoGvxXqB5n?=
 =?us-ascii?Q?9g+i4/dTda3cFNZWQUbJzK2sKPzaQWmGWgbWax7rtIOaZc+m0b1cIhaLc4hl?=
 =?us-ascii?Q?S+UHCYIKR+GLlu+9IaMx+1LvOfVNN9h4w3VMBvVLcEWmxuN2qi48aIuWEqE8?=
 =?us-ascii?Q?1clTwX8nb79s+ccfUd9fGdaEMFykUw+jbAYQ3KKn0IN570smEC31m0mEkL4Z?=
 =?us-ascii?Q?mnIqOcOPva4SzOYhO4rrC1U0m8dSmf1k/MoN4cauZb9n0HM6i90/P7QZTbq3?=
 =?us-ascii?Q?YRLmoRlU0K/nTCuUravqWVGRjiBgVYWibDy7YrCc19lhFVA5Ahn7zY+iH/cZ?=
 =?us-ascii?Q?ceDYBgp0P1+GNADfskJhb0F9OC4xZLn0Vi3ml8e0lyH0yZaDIOAXdGT4kBQt?=
 =?us-ascii?Q?QZEpzhx0Kn1NvSnHuppl+hkhsBBtvnZ8rLR1fpEQzmfVw7NIeUiofDR3YK1w?=
 =?us-ascii?Q?QZtUBgrSoD64g7+NG2pKG9Uc61ckIEYKd3fr7SDbgDR5yDmX8z4ndMChW6rO?=
 =?us-ascii?Q?QmdmcId5taYjvdfVPXnVn2PeUXKSdB5Z/9vh4NVNGydzioaZNoNpmDN/BboC?=
 =?us-ascii?Q?kn6nRb6mEmyHQ7qfbebzbLgWGbwv3VEfRltMdPuq0EIKTVY63OTA7LX4wZQv?=
 =?us-ascii?Q?QvUcGdkQvIhkO9JSIqeY3RwS5kzT2V7hyuIcP68o82NhC2e4+KsS8qYF0epH?=
 =?us-ascii?Q?KBxv+8t3qgjLRihRa3hIaNIWm+MB0mP8BZmAjOA2wAPDyJDf+RB9IiATcu1n?=
 =?us-ascii?Q?ZxrGCXsRKvyNzlLtjcsizJkJkEyP/kQ+8OPaq/Z01YnpBTJ6kYHyWHH7p9AX?=
 =?us-ascii?Q?H+kFq/SZo2yyErPr0hwIVpjxAnLAC5ftnb6njohIk48tAJE1qF8Bd4oywrLa?=
 =?us-ascii?Q?fIqOmVUwVJesaYlEX3hxGuRE1BRsOBpXVtC1MpP+6Uwe3SRESg13sPC+yoS9?=
 =?us-ascii?Q?VhuR9ODOPjTLLxqXAfskYjDpUq+S1atJWkSdqHSbw5Sq8CTzwA4l/8PvgRCt?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TvkpCY4vQ6IW0bQimbdZGcBF6ey2qD3w4onNYiNJBGn1sOwJ61DhjtONKamphhevtfT5SoU3BBMyKosA7Ibzy4PXN5Uxn/8Ct7A5mq51vsl3UZFc6mMFSaC8n7uFmH/uSLYdw/b2wveUlB4LJRKG9afv1+/MBodUJb+8u2qdzVfMIXC9lkGKZwTXmq3AD5454KQxEfqZJKNt5/u9izvcGgULf8NG+oPcGOMEv8gskZ0BL76LQODUuv7GSFuTXjCbGxUt/7AP7X2MOCwDuoVOp/gnfsNpE+kHxq0B6TIf583HpXVjLeVAcarLqvykPbTQu1FHA83BzxRTSWLw8JJiStVT1gihwzK0l5WmHp38pl003alkmMzJJT1yFlxLhNqKw+/naImpk+iKY6V2RHLae8LH22UxIQOGR9/qbp7+00EX8SdznOhOk/88cDjSM8ei4J58xXbzVrpFjnvCqC8zafbT+59CuJldINrPZ6qVA+dxJpIAKLlOeQ+LbH7xWabGav0NWn7Z7+08snMMCEBEckYRuY5zK35GOVDmDMIIfEbFQiwoRA5n7FHNGwL5w47etMW0aYy+ZK2/54jJym6CtNux2HZ/SMwHcPGbHuieA0KdfyG5b1tzxNSi7mYsg5XtXfhReVPJBgtIrM0GQ8PWn/oFxYsu0IrsfeAMY/b3y/xQM/pS8m84JaiXEV2ZTQosAjBn/4Z2lTk9W8R9d2uKO0LIT0QHYN/8RN1d0meaeavqPyNhkBUBiXo+AIfT6H4QGQOfRVB8SBWTuNXr0kITKfkUUCoMIOR6wr3BH6AqjRM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ce88a6-c6eb-4f11-5dfa-08dba50a0083
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 01:24:18.0890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1ucnGgTxNuE24oqBtdV9Wb+u8gNW4uDALoOBhMDfKkx65FzdIyM5JBEphnXjUh+Ff37ztvyzOoqbu9g9hLqMTgkSH0w2J1xITlBoqA2wVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=748 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250011
X-Proofpoint-GUID: afqO8G4zYgNS74RAkluCnwxA4BlJf5Zv
X-Proofpoint-ORIG-GUID: afqO8G4zYgNS74RAkluCnwxA4BlJf5Zv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Sparse warning reported,
>
> drivers/scsi/qla2xxx/qla_iocb.c: In function 'qla24xx_build_scsi_type_6_iocbs':
>>> drivers/scsi/qla2xxx/qla_iocb.c:594:29: warning: variable 'ha' set but not used [-Wunused-but-set-variable]
>      594 |         struct qla_hw_data *ha;
>          |                             ^~
>
> Define variable 'ha' before exiting the routine.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308230757.VKMIztAB-lkp@intel.com/
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 7fbd917f6e1f..0eb8df5ee73c 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -591,8 +591,8 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
>  	uint16_t tot_dsds)
>  {
>  	struct dsd64 *cur_dsd = NULL, *next_dsd;
> -	scsi_qla_host_t	*vha;
> -	struct qla_hw_data *ha;
> +	scsi_qla_host_t	*vha = sp->vha;
> +	struct qla_hw_data *ha = vha->hw;

It doesn't appear that either of these are used at all in that function.
What am I missing?

-- 
Martin K. Petersen	Oracle Linux Engineering
