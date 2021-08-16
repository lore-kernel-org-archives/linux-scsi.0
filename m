Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5AEC4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BFD3600CD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhHPR3A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:29:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35858 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229733AbhHPR27 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:28:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GHHxh1002225;
        Mon, 16 Aug 2021 17:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=sHtU3NO9YQaLQcHM4/f6A5TBgJmwbUNYKM1EKQKPq9o=;
 b=OpI7DgU958Zwm9HPcw8sc9GluVnelSex6a5nqcZnkKrA1yf+s/XVja05CXYWJpV9wcWr
 S61zOMMJ5IFbTjAk8u9IQs7QmyLTOEG5eNLf62TziyhioEESlxjAtqeYC/TIG+H2EPC+
 vehSHzIAfFBGObbTv+fotO2k6+nH4Zn4jV6gP3a3mGdXva+oP1NF5f9w5ZOx49/W0vmJ
 bWBTUms/rs3rlSFmH1VMPDle2GbrhZK3SQc4UYDUslyZhO7sXO2BPVVxkHTK4Ur0uKgi
 LZt+FiXp27knNN2Hw6uUhkB5MfOppcnZ7uTz1UuYEfuZai+3R85cICSAZ1g8hJpWM3cU Zw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sHtU3NO9YQaLQcHM4/f6A5TBgJmwbUNYKM1EKQKPq9o=;
 b=Y9U3j2TBeGYpzlX1bzKp3NNdOaWQgGbecL+pPvg1K5DGyhRQd0tz9/DHfmTFdjc5FhbF
 /TRC4DKlLDmreP/2EGVwLXrKSYHfUI3WRG7iXR5JzPQWK651bo26utt4fjKdZRoBLXfM
 iaWmY4fxBoNOKefncF078Rkxx2CDTJ7LNUQDVV4ydOal3zaj8/NYnedyZ7i5miaqULiO
 +LeCbv/18nCDnSDd3tl8NmqPfV8IVUViDx14FCBbjFGbVDiTuzP8PMuq94shBt3+ms3B
 8Vi75A0heAb+I5jHZiW9VzVrxU2PkgznmrdiEb3wsyeGzn024I/Dd9Lh4NyAzUmwTLMM CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd22vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:28:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHEsOp158433;
        Mon, 16 Aug 2021 17:28:20 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3030.oracle.com with ESMTP id 3ae2xxkb0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:28:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TL1h0GonyyX1a0memn5spY5tbT4Yk9wwoPpjBEdoEm/bYK5pSsKdJUIj87mC3ATc6G7wgBvwSaCTlaC9tpadekoo+tmT0BpYw9mMUoEZuPRJCiJqsw81J9GelHTN+ocK60LgaInLmh+Y5xzWuXQ+W7PFmmmTatVfEWQtk4k3VRRc9SnlQFSQ5LgDokw4H1jfQHv+FzNFWH8Eno/15gpwjZ8QNrSRKqf00pxKn89g0klbX0SQ/XsQATiHnxQwGEWgw99kC7yiZ3d6gVCiuMQSgAAgO9yT1QE9n75R6qzLd1LODPLM2fTIiwshB4a/Dadr2g3fU2jjCJc0zhTuixbdpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHtU3NO9YQaLQcHM4/f6A5TBgJmwbUNYKM1EKQKPq9o=;
 b=I0f4Eqv/0YE4Ai0eftZcwYeDcsjlRIyc+36u1RaIDWR9HZOjSmyp8bk1M/LSy6LmHGeQyhG2HVicji1xNLPADzWmkT/Y3To3DD0Q/JLKBMVQnnw7a0a8aDB/22Q1lCnAKC7NB5aLCGdXK2R5oqJen1k/lpMHQKbwt4dCg/lFVe4B9mIL3/gvo3NXP4TH+lVoeNamUomhhBT7ccPT6Lw0WBayCQY0rKA2MXPEnDhYsVl5ZI18j8F1vZ2InZYIO1dTKcKpAviWUeer34SiCaj3rTuVN86k1SP8oLx3QJ36GGmjLr99V0KrfLcsRaAk9lVK9ihPKSkZAGL4yYugnUt68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHtU3NO9YQaLQcHM4/f6A5TBgJmwbUNYKM1EKQKPq9o=;
 b=T3DPdpcjJn2u0CqXP6sO13/5PvBDu9QjLACmSpZsEMB0DtJNJC7P1A8mGgBte2V4qlvj7LDs2Y4QRQRQSgsegu+Mxt0rVxXSgUfGL1q5hCjZkdWdd7C3+RlDQKHjrS82nLdAp1+F9ZiZHdESD4axOiJ0MeisqC/9yjD83FBwbLI=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 17:28:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:28:18 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <manish.rangankar@cavium.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Arun Easi <arun.easi@cavium.com>,
        Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: qedi: Fix error codes in
 qedi_alloc_global_queues()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6lhpae3.fsf@ca-mkp.ca.oracle.com>
References: <20210810084753.GD23810@kili>
Date:   Mon, 16 Aug 2021 13:28:15 -0400
In-Reply-To: <20210810084753.GD23810@kili> (Dan Carpenter's message of "Tue,
        10 Aug 2021 11:47:53 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:74::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR05CA0042.namprd05.prod.outlook.com (2603:10b6:a03:74::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 17:28:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91364d14-18e1-4621-ef8c-08d960db3c7d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4744:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4744825F1C14BB1DAB5A70908EFD9@PH0PR10MB4744.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKbbbv4XqnUcSZNI7RwtUiKbhiLXnuVn+yo6yjWmsErqT/yOJqovU9tOi11QNd8WWawooeOejNB6mnp9CxHR6UV7LoSr/NmMoxp25jVyVLZ10NIPLa/7f3k23MLpS3FDHs+0VXMZQe2tAQk5wHxDwGe2+h/KZ4TMi7OJu1GmLpaZXE273gELpeS04rbvI9V8rCmW25V93DejR6iUxp/Z/LxYV280xDLcpKhFTCAFpZ3S6KjZKpmHSTCEPxwNktbGTqCey9PuAXcv6Glw3s0bwfEyNIyRcL5XJpFgj6L14zuKwfmhrwy2A3Z60tNglJj0HoZRxoi7xTVe5e4eLd0z85d/5eU3G92BnA8VZEtqS9ppiUULTOeCW0jOvzH9qhvmYlpjfcj0TbuoIUXL1tL81txrI2ykdpJNmKutkBkS44U/8aAbzWLJD7Vo+FDHFe20/op4PEyqRaUiz0WVF7Xri6CjE4lyac/EPTWZRjOi62ERP6Zex3tOQ3X0eEDNHWWHy1zvpUM9kC5xuCmHxgNcuObldhgZ5qETmZ4HoeOX2Qw4qTbnxibs/dNrBuYvtF78v88ttlvjrcjAIFGikFCBiTIPSJ24oZseDwubU5kLA/H9IIZL2AdAMOb9khh2F67THF7APY7AZFa+ebaMiIkMgFLCIQh4hf+TwYglI8D7VuPFiiFmQ2opYLuAS95QDQe1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39860400002)(366004)(8676002)(8936002)(54906003)(956004)(2906002)(66946007)(478600001)(66476007)(66556008)(55016002)(316002)(6636002)(86362001)(38100700002)(38350700002)(7416002)(5660300002)(7696005)(36916002)(186003)(4326008)(6862004)(4744005)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g+YIlKINgorCI8Z7guKINeJiX80deCKrD7UbJ6JZhAClgHmrZPqbYi2T9Ay+?=
 =?us-ascii?Q?bRkDW0mu3AWEC/ci4XrWQASZDSxoyvv3tjDZ2ULcN+YWBSviWDzubD4/OV1b?=
 =?us-ascii?Q?5nY+cMHKzaLJKLg45LF6Bzc/J2bkvW50QAkZzq5W04f7S7Tcz/mGahfHuGMf?=
 =?us-ascii?Q?7WsCNAESLk67v1W20g1Ei+s0u1NWmGCwqVDo1NRk8QyEabqvUICUnTiJEorw?=
 =?us-ascii?Q?mptx3vaq73Rtce7wSr/wer1TSlQCNW228kB6pjtc38hahy5KZTV95Rg+Cx21?=
 =?us-ascii?Q?wvXYVchg0wg0IOc6XVHbhaWg7agqiUevHrpHdBY9mcgTUMwL/P+ZPcF0A8q+?=
 =?us-ascii?Q?eNKwCwFal0EJjk5scLZm6W1aw46QdNCeJGCgEmAx3QKgQXUROcCiiy4TQYw9?=
 =?us-ascii?Q?3c4gaO6tiILBadUK+/ybpEEZFY8wyWEFB39Srfl3A5EI8c7cFsZvzDO2Imyz?=
 =?us-ascii?Q?D7RH5reF66SGLlSLRFmberDuyDNkYsu7CjHgAuC/LPc6vhq7Pp8Zw4LICIgy?=
 =?us-ascii?Q?+8rra6XKgD2LWrCxTJz60FL7Pj83rua2YoHJJAMZGQoccnfmHNGz0BtQ1mcG?=
 =?us-ascii?Q?QBI+AcDIxtn2xv9qsw+U5+OeS/gC9EmP0PBluVDE3e/W3lW59qZwSV7+G5zw?=
 =?us-ascii?Q?BKSsjypWfODN37jAtRyr6Fl1m1ZrdCQsU99FmhWkHqHZ9KiFGw/tKemM8vPt?=
 =?us-ascii?Q?9ZwGxMJdf7LW/ZwrJhQfduVsAPc7mToewLzIXYOifIW+jK94O2m4ZJDlLFCW?=
 =?us-ascii?Q?TFOKnPkfTqHurCJt3eZg+Ql/hPAHvcnvS2wjS/JePT1Vi46k0wU9oOzLkFDD?=
 =?us-ascii?Q?zSesv3ApPlYS/JrzFKzuJhtXRkxbRsQ8e2Z84tKarDeUlCajv4sbMkhDtI3a?=
 =?us-ascii?Q?NyxpuD5UV0fnzP8B09sFltrCjHzhd3hXcC6DO9JFfX1buj2/g3UFdcB7BmAT?=
 =?us-ascii?Q?NTLxHx/kQ/0aSP6O8gI2lLSZZf43DJlOdTh3a+t3IZL/nJeurF5ZrZla/wvf?=
 =?us-ascii?Q?8n+ZovtIUqS2NU7vk6jjrrWMZYNkj9JF7iOjPeCQ80EmV3gxzsp7ri21T3IO?=
 =?us-ascii?Q?5OfBVAIt/WILQWrd2MeDvlc7fqtqURIxn1vx5vvqLCcfDguv/AGVL7Xu1MQ1?=
 =?us-ascii?Q?0K4d9chYpWVRRFpDRjSEAgKSmYWiG9xfOhOPwaN9MK4hFwH1/XHrmoHXS0VV?=
 =?us-ascii?Q?m+PHPbprVQz0tkIR6DIZVemncyJPLm1MRaTLMjWfRgJXo28DHfYBW0fIkIuE?=
 =?us-ascii?Q?XMOA9I3xCCiQdjYtr8Djhphgn0+Pc+N2wNmWdVNYNx98p8zct/zpS0GI+UZq?=
 =?us-ascii?Q?G/eB1sv9VCPorVeu1PulOUGu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91364d14-18e1-4621-ef8c-08d960db3c7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:28:17.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEu+e4zx2FS4DhATehXjlHkiIuWzhYLSCFoJ1pHRtLvQqAzfkfb2yFd4HtsFTaMbvwwizT3Lqyf12IAgkfmVIH6efH50N0SygMaDZiFJlMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=857 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160110
X-Proofpoint-ORIG-GUID: cgseW6iCiV_KqCEQxK-T2ntEM3jBn8Jb
X-Proofpoint-GUID: cgseW6iCiV_KqCEQxK-T2ntEM3jBn8Jb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This function had some left over code that returned 1 on error instead
> negative error codes.  Convert everything to use negative error codes.
> The caller treats all non-zero returns the same so this does not affect
> run time.

Applied 1+2 to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
