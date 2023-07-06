Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F3CC0015E
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 01:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjGFBbJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 21:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjGFBbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 21:31:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F86102;
        Wed,  5 Jul 2023 18:31:07 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 365NNpm3009016;
        Thu, 6 Jul 2023 01:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ou6tNpuPPx0oU67eVmJRc+94/5UYqwAebhRJ6yE3S64=;
 b=LtKN5ifIvVN/BwTLpabNmiIeBkW5s7EKqPjBGmy6gy69e1lt3lktsb63qhCkdO4bhO0B
 GQe1/7KdcmeDSEhYMMOL17xKR2UIe6ShtFJMnnuKaB2aZEz2gWik2+qsfpohfflRPq+X
 pg1zJqq9RpbtqmuxG5l89+Gx8b/cpqksFh4BPVhdVlOL7vXtSK8BosBRdpPBIzaGgAqE
 vKiHcGulK04XF5E9CK+dI5Bq1J9qsuznyE/7WQpwvmazffQq8Ch1owhAqyaQjtjVn7SR
 vRxGY6QKaOjdidPKgetALzxkFD4w1TMmnkZ2W6vCOjO4tCHYQSXJgWatl7ZpupONmFs6 kQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rjc6cqrre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 01:31:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 365NZSFr013429;
        Thu, 6 Jul 2023 01:31:02 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rjak6b02v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jul 2023 01:31:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQGPJtZP8zzN3y/bI/CYea8F95YJ3Bf2p+x+x/X6ym+v6F1hZArVlOj362MloN5AhBSoXqTM8tAnjPq44H5Nj6POzFB1+q1qfrbZkL3MLTp5L5fTCtXZMLGZuwPpp43CrObs9XLJxc+vc7LqgcUmepIK8j9WQVx4yMjxj5+DwBRigUA8chor7hy7QG5kzVR7L/PH7IaC0AAufEw9OWxq28eLJGKN+wdjcRGD2zj4WpFFrbtNRfFTm+26YF4qHya3IGldyt4xmrb1JOtAO3fFrvDMYStLq9mJ/Wd1Gvdq2g1WZ/PzE6ircXAeftm+6JX6YaBU84vHKhDIrYGbj45U8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ou6tNpuPPx0oU67eVmJRc+94/5UYqwAebhRJ6yE3S64=;
 b=BByECeaeVrAS8SkZ1a08nHiGTvJrTR7ym8dwiXy9udFQpHeMhvf9risP9r+JoHzhda//ibrxyrIa7XPfAMT/oN/PLVNBgu6bEGDA1aXv+RYTEZYYvjSJlwrp+NkE4MgfqyGqymuHm8d2L/rMxUC2kUMcCcxlsa9w1tGHD39Uv9C8sYrXlD/oSkMzHMiqL1ykHHpaA990Txv8lERQIbthv7McdNQ1KAuoWWo+IUiRbaPg13eErW82vMg8eudGhTYytI2+PTtX4bC1SIdpRw0bLmc6+bd0JqK4GPbe0EYkWV5+nASXzqHSnlDq21UeN0Y2txb4rsGI+k+XsuUGq2HoQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ou6tNpuPPx0oU67eVmJRc+94/5UYqwAebhRJ6yE3S64=;
 b=K2rLx9YOgKmJzQXoOHI60M5S7guviV3JGYeq7HCpUbJO5TvWxztP3Sl4RYUdYLIsEhpJRgyRiOO8eXPOFtAyJAqWZHXC9gy99nP9rk7Ia7vsRcYMcGbgDlmD/kfWyblFMffgDQUKa20t6jXGAIsuj4+0PXKChtKYJT5GFqwyYLk=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MN6PR10MB7466.namprd10.prod.outlook.com (2603:10b6:208:477::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 6 Jul
 2023 01:30:58 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::9f29:328c:1592:d5bb%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 01:30:58 +0000
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: qla2xxx: Fix error code in qla2x00_start_sp()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8exltbs.fsf@ca-mkp.ca.oracle.com>
References: <49866d28-4cfe-47b0-842b-78f110e61aab@moroto.mountain>
Date:   Wed, 05 Jul 2023 21:30:55 -0400
In-Reply-To: <49866d28-4cfe-47b0-842b-78f110e61aab@moroto.mountain> (Dan
        Carpenter's message of "Mon, 26 Jun 2023 13:58:47 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::13) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|MN6PR10MB7466:EE_
X-MS-Office365-Filtering-Correlation-Id: b8d6b14c-affe-4a4e-776d-08db7dc0a698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9XDL/9UOUva0HuBiGRmLIM16+x+xqTrFdPXUMHMu/FCUQLF9whPna27Kr1WFdBLtl0dmWlDk/bR+b4+euvuQHVk9sIQtWV/S0y5drdCYOY+pTRQ+W+km/QMYKPoRfEsfqETI7pGkeiYJ5pDpQcYuh/Vitx5BOatE/J2adRekkGrKhkYbtXD3gvJTNrmT2SKGYGkYzijiEKnQDX21Z9RURW+FTaoZWEqypit+gkVA7iGgvlxEYNGbjumOmDU2jDGl2D8JTeXImBVFp2fZlDNndlrVQnv41Dxav/2obGMHQ8hKtJrNhs1TPUeecIT0RyTYFfKG0W6zunRyeI7f1k9AAOYUOUwoehaa4oMND/Unl/TdAKhhgIMBXbjBN84/lQVt+B7MYa4Y4OVofr/56tWVi3z/qV3L2EfaDasTp/w339qbCO1zy2pO01ND8VniXSdgd2SEnlmZUQgoQLE9t/KZD1U5P+lfsmo9SsGi4YzgQxBgYRJo84wNtgur89ORA23wNa1fMA9ub+1QZfGOvdQ28t8CM7Ec5Otl3TdBubby+so=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199021)(66476007)(316002)(6916009)(66946007)(66556008)(38100700002)(4326008)(186003)(6506007)(26005)(6512007)(6486002)(478600001)(6666004)(36916002)(54906003)(8936002)(558084003)(2906002)(5660300002)(86362001)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QmWl581RZ9XiuoQRiBZzs1TX5YqoHait9WbqPX9+0h23uqN+nIKX+4WIO65f?=
 =?us-ascii?Q?XmXr/fjT2kjbFKpSbYhbwLx3ef/b70h6St4jkyoNJ2PsbtjPtb2ztWBFV7WB?=
 =?us-ascii?Q?W5TveCC5/UH7ZsjyWFNi/ube5LiMx6Q7P2v7o5bhIWEpRaBBl752QfytmlT/?=
 =?us-ascii?Q?j6O6TOejTTkoaT2uh/W2GmqiPg8LqixljhOm3AujEACv9ps/846SYF7dd3nw?=
 =?us-ascii?Q?ydq94pGPjno1z315xEZBtZCTW4h6+BrENgH96uso3TDUe7cIyIWdgUb+sNjg?=
 =?us-ascii?Q?Mr4llVYn5aNitocVAxDFIOaMNOh3Jryy8jbK9Fka4I686g/eZGMmOBqOS9TA?=
 =?us-ascii?Q?CzY5WBRR6E8FnJoSSQqDax4aYJAWPnPQwTJcI8FsuH+AdU2wWKAXO+ngJiu6?=
 =?us-ascii?Q?pqxYRMjj0S/LMXESUiTPw/QErVBRPbjoNRs8TqYiYALCjjiPNMWk7xcNKLT4?=
 =?us-ascii?Q?qvGhdnLCj7S2UTjdev6k0I7dYGjKD4LLIdyvmGL6+8HHlvqly77oLqFCvr6h?=
 =?us-ascii?Q?VBDDZgloGQUPLyIIbljjatHNYTqflIbk4EPB8iE+nLAnNVTmm7KPaEk5yjlh?=
 =?us-ascii?Q?DFhvUnygRLfD+FsplcVvHuDQIZ4HnZ50NnwiubVBGFd3AtP+OxyHwpbQrFEN?=
 =?us-ascii?Q?IC1v46AgtHfmuY+A+ZRMKAMnzPmMsPLNI1vMwd3vKB5RrvDB/5bFvzYfhL1d?=
 =?us-ascii?Q?xA4MHkeGAgun6KxXjW/AvY88gbt13nCw3iJPy9nH99tvVICimwkvMX9mGCaC?=
 =?us-ascii?Q?dYmCFgXSpu6gscRrnreZcZDOYlm4FQJ5OYcyp/t1tEIwljgqI6yhU9m5T/xg?=
 =?us-ascii?Q?DzBJ4KiufrY1HZcRG3aB2vO3OQ4+NBD31FI/0yO9b8+zqT3Yql8yl9eKbR5C?=
 =?us-ascii?Q?waV21ql8RnAGU66TEkCPdLU2X0JZZyaHYc3zogdsvc+FrfVx6LNDvDZUs74W?=
 =?us-ascii?Q?TdbXqwu8SyY0bNIQvCxz62rr4tJb7R3bS5advuAQ1E7MX6pU5WU/hXdfAUsh?=
 =?us-ascii?Q?WMIMDsh86WixPhbD+8d3dpxytjG3HaOIajfMS7b3J88SiepCJdeA3nB/SFig?=
 =?us-ascii?Q?H5i7tEKkdS5qKNscAxw+wZArmMFMlFnsy41L4D+rmwqlb5bMp5Ad1NvAsXgV?=
 =?us-ascii?Q?kIHddV5NfRC5TRf7ScCAcQ5vNEWXYnwBuHMaK8kAeZwq5RmZXjC9uulla8SE?=
 =?us-ascii?Q?PUXrynp0iNm48tzJpSBijKM69AG9M5msTdTCRc9x6H/cQ5wUx8NAnnMZv3Ah?=
 =?us-ascii?Q?nhbwTBxE6PHKZI0J50WEaVLlWUl0nz2J2EbtdzZ1vtmgBTPtIelyExL1w17t?=
 =?us-ascii?Q?IXmCAb/hYqVBfAq1/8IVHnngKViLOHtU1hD3D1HIe4KgZFYOg66Uj+1kmueO?=
 =?us-ascii?Q?kU/51XK0Qhp8s948bybPQNT8aV7lQC1oxvJbd2ex4U9uzoUhmGAmIRcsK6yL?=
 =?us-ascii?Q?u66GAF26sHfiBoIg6lraQcxmzi+VeNmWqtyduleKamkGku3d7K/1v/eJPfHt?=
 =?us-ascii?Q?t1lHGfuxY2sJ79sNy/ORFXH117I+jzFN+0HP2XA2WSumvNTDr6CeAcZGTvqC?=
 =?us-ascii?Q?Fdrc+EK6lyUiaRmUocqZwako+6qt1L2IyplX7Yse+yuAjKSFz6RGCTHlJnaI?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fn5gfCjgDhCdXwEwF7TlnfDVNov9wWXty7NlcQW+VrEV1qL+LXy+FKJit2rS9pFIHVsa2+mi1p3l/v/0bVqGm9d1qoPy4bbVIquYJOPQrlQLlaI8+loMxX89yYb9+eI09y1/pCDgmpo+e2ykX2IcydCt89N6NZ80uAYZNgaVprfUAlVaPB936DoN62XIjuMenPWKDe/eKqWr37gqalYKoKgHs9S5YLoOcg6oV3KR7WwEUCK5ubRRL83NVZ3CMrpc3dBEMnp1cjME2ZeCA7M60RP+KK7vTDV5pAstT517CHgk23oArr62N6gaF8CRgPtXElaC8KZVuHwik/mx1P3agwReDU2gK4J8tWg+tVEncU52wYyRcCSA7iO/IFUtovCMxxCwGv5odEKdFs/FfjBY+RKgunzHoa1VfE78gNRhevMJce88pErdg6jPTRwfa4pHZ1JbqiX80EY9tXJ+Z7B5E57wyT7gKYrYOlivJdHraP5aiO3Df3Qk6Tf51lklGFbGt2ogoshSvY+gnEkj7ewvPGhpgbU0qIvNb12HbXU/MW9vl13x7Gkx/oapSrnxRkySvICoBrjqUVlMQUzdJUhDqH/PsoUNV6Y+894jpAgKdzYAfkvZMqvF1jjGAq82w/xU3Qv6iQVv+fzyOnXv/it+EAmIZM+XyoHtnXsMdzRhu7xegXaAoTUInnw3e66ZL+jcqoK+cT5tsqmeCxoHjgjAn6nC6QWFLr7H7tQwfV5GZn8vCiod7VAtgntiv7nWGFnBuAl7Ul7luULTLcBoPVZ+KFuQbaMRlIJ7fFbjM7qtRn/7htk5J1TQvEb6SkTCSqiBfIV77a6ua2m+wi0s98PEnOWGbSdUw2TBW3YqVvFc29DKo5niwhfHHmTP5gjCZhkU
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d6b14c-affe-4a4e-776d-08db7dc0a698
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 01:30:58.6405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3X8JPDDtPHPAjyK1Wrjely9UuqJAo31lrFGT7l69llF6RW2c4qLpgZllSnmrtMPkiqNiR8k2YcYeUoun0NBp10+Be6W1M/g9uFJ/abV7+EQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7466
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-05_11,2023-07-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=628 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307060011
X-Proofpoint-GUID: 6W23E679QBMVvB4ChKqJK35aUcQrSksy
X-Proofpoint-ORIG-GUID: 6W23E679QBMVvB4ChKqJK35aUcQrSksy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This should be negative -EAGAIN instead of positive. The callers treat
> non-zero error codes the same so it doesn't really impact runtime
> beyond some trivial differences to debug output.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
