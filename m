Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AE4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 02:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiEQCKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 22:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiEQCKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 22:10:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECAB44A0C;
        Mon, 16 May 2022 19:10:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKqhYF017447;
        Tue, 17 May 2022 02:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Cv5+QbIl1vXWOYI55AfZzqOMfbG9tEYxYByTsbpdsrU=;
 b=CSrSkvEw0Lp1d5JvpgZ3lmGmXpz3ZoE1XtOGxrtdapv6RTYSjr91a4MqOD4Hv054+3Yj
 C5mvg6PL1yYJVySetn27YdcnR+d5Wn9+To8kUW7g5ug0j5fFNfmtzbuPjIiIJMwl86d1
 R3EOL/gDurKhO5C51uM8qDdIIvGYkuR5BcEdvxRq86i3JfuGzFbPz+ad1Jr3vw4545sh
 UQO57r9CZuW/3bUFGkceqFwDOdYdQ8Y/ZuWnip9ZcZ0K6+kRbyTgPBDhMOT+Qo06ePYR
 Y8sdtZXWCKqxmYZHtFsP8ZPu/9UdjDwAavLX8Zi0evWxd3/oPGU7HRZVZAJP3lsMqfNe gA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aacuqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:10:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H21tDI023880;
        Tue, 17 May 2022 02:10:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cp3f7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:10:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbPbd0+npwoB3UCm47TdRiUJKRKFxn5gxMdzADssYm/oeP33Hbm0wcN4IVlXv9w2zHZGwS5qVHDe4IM5BHqfDj5vzI084kdWNFn8aIp0Yd4/1KiyECGyqBDADbrakFtusNlRcl3MFvEGEO6HIHx210kTfwW/pCbxYEbyTYp3y8uwNNspvl+gCyKN+RdEVqo19SwT9jVWOYKkUU5yiL4xp/WvLwfgLNBdbV6Lvf+4iPBwDcqkCUXVHxex+3u+33UzdigRCy5jPIlnb+eTdTJ37e3N7qByl6l+inAwgC/kNy4VyhBfWgZTS0oTRA9Iz9jtxp5ExJHW3OsXCv/ZFpCwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cv5+QbIl1vXWOYI55AfZzqOMfbG9tEYxYByTsbpdsrU=;
 b=LVcKEaAltnN+6MB618Py/yC9h65W/6FcacCpp55R6tmhI6gaxpbmN3eEp6ozgG7g+lKNiVXn9D3WpmHW29ocwLo3vxJ2kG2a1/JCPo9RgiiFNGNrpPXP8IyE6D72a1FAF0OGAXUpCBciOAMNa5RbgD5NpZoAghMwSAR0HSxu37iad8yF8Jt5ojLEbQVAqUpgf+r4ZuLL3kW5dRm5Af5NO2ckLEGjZn9oN3A6VQzNZaiIPNZgkNSKcqnfNEnwHOLRS7dawY1EK7+bDfBp8eQ4PZkpQkrH55ShzKdxsO1sx40e0mcSsk7O2UmaIFVzlibXn2bX60FSThoZnR33DNJwAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cv5+QbIl1vXWOYI55AfZzqOMfbG9tEYxYByTsbpdsrU=;
 b=JkQipltC5Ymc3sP60l51VxJW+sCGSadP6YlCt6ggKAXxtiyG/g6YIvqKp1SL74HTmzcwhAe8EnybHF/yxWVWmcCPRAGZNb57eI63CM08M3gTXnFMtW2iZMtaeyQRb1TkSu3YZvY8lMdrNQQmAKddG1eXCIFGsEC4BF2/LDvfNJc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB1457.namprd10.prod.outlook.com (2603:10b6:404:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 02:09:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:09:58 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Return error if dma_alloc_coherent() fails
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rr0rjtf.fsf@ca-mkp.ca.oracle.com>
References: <YnOmMGHqCOtUCYQ1@kili>
Date:   Mon, 16 May 2022 22:09:56 -0400
In-Reply-To: <YnOmMGHqCOtUCYQ1@kili> (Dan Carpenter's message of "Thu, 5 May
        2022 13:25:52 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:74::47) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 780420a1-80ef-4063-98e0-08da37aa57b6
X-MS-TrafficTypeDiagnostic: BN6PR10MB1457:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB14577053404B1DD9E4FC45ED8ECE9@BN6PR10MB1457.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXqXciR8KwwtVJBTDW/fCf8mdJgziGFKisiAae1DB7WDX4eizbvqO1kdTqRusRW2a5NM1SctMu/dTNBncADM+XvXgm4r1a/Mg6TLtfEMBsTwIMaw58zeClNnN9h/XFeWI0NmFqSGFmil4uyaLI4mijJMfE+563YFKcYieKvoWC98kPY1e/49hTqOIP1XW5SZfIsDKCTmBhaiGgcOknrD3HuRET4Lut6xZ84uBURWMvjlweMbuQDsS5CAvyWYH4n2P+uewtILmrYje6JJ47++cGj4+/A56iqJETzRxU2nOzXit/UWc5d3W+BR8SqUZnnQYychUqBDZxPmI3v0nWEQ/Bh32BVOeP02BJOSMH+QItjxeVt44bdEIRcBYK4sM459euW0w2hJa0CzVQDBiOZydh78f716hJAuwr6LoKOsV42dPGhSpVt4I5xT+/CiizbJG1bdo7is2Xdwdu2EY3cAQQpz/0PU6+VQimUFk2L4lg7hw44+1nhoVVGFy+/OfVFyAjp+LKwdudCtW4YdLdRE9l+nMVTHd1+WqNoBvVjdNenwbsh8EQS02Udu34ykj+rAHnjlF7MDtLlcOC7bN++L1CBmAD/wHevk3ZYSi3YvEPAYryJgQ59oDcVU9wDAmOuvDHvYS8/BVCuXSAH/htREJMaLbgvCl7uz79h5+CClUrPTWOXgFI2RvC3eXyTnzJNueiDtbjc53X2yulneTxHJB15+2bMZIJcwhKaa2aLrFSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(558084003)(52116002)(36916002)(186003)(508600001)(5660300002)(38100700002)(38350700002)(86362001)(6512007)(6506007)(6636002)(66556008)(4326008)(66946007)(6862004)(8676002)(66476007)(54906003)(2906002)(316002)(6486002)(26005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qih4wsSWKgV5BrvdQw+4bYHgSAYdxcsdb88E+BpFBv1A5HvLGN1UtDYAWv9E?=
 =?us-ascii?Q?j9WBh+HXBRNicT9G+27DzgXQxLbvfbGyT2VXJ10Wqdt4ug/98JUzbMiLLSJb?=
 =?us-ascii?Q?dq5OT/vGdwihaVVAFZbzi3Pesx+EOojXe0oG2VHrubsFaBd1pP0qxJAbUC8X?=
 =?us-ascii?Q?q/4tcGo0gx7TFd1h/HiZNF4om6AfCXqfiTGTu6wxuDABh8hoUaA2JNFyi+zR?=
 =?us-ascii?Q?GLocsSClFu30Tb2SSBZ0N4R/OG5lrRNGN7XbWCn09dKyO22UWlQ+o8f07ZvH?=
 =?us-ascii?Q?GSL8pgtJpBxiSmGt8+yIY+yDC4YHSvNtC+HbFYHTXGC6KyT4H0CITPXHMZ9e?=
 =?us-ascii?Q?ct9gJFtxVl5vLZwyuorECRYlRSy28JXqXrPBkKukh5p9zxwgVKsKiawVhY4Z?=
 =?us-ascii?Q?MzzR5C+CBGxEt/ZRBYIjnZVVDEScUnLokrCUGgPonKTFMNEFYWEoCJEGFgA8?=
 =?us-ascii?Q?fLBrSEiIwVzAfgOThVqYKtrLCtE7qkyrCC871zwpNMmb/1MAKhMSZAM6sfUt?=
 =?us-ascii?Q?Zu2y8yr+Q0lLjmEdqs4HU+pAejhkjwf1Lh0zy7YDVviGZJW3Jje4RCu7SERx?=
 =?us-ascii?Q?+a2gvlLC1x7kdn5KVCwIGBZCg7cc+lgUA+z+uQt5qU3sD0WvCGH0njZsiqWe?=
 =?us-ascii?Q?zwTeDlqrCGjXErNFrySMhdHB3eiV0ztgTICp3xMEcggfPM0+Tlj9crGzfYZG?=
 =?us-ascii?Q?9qCD3IkkDLz1qhS7DlGY+q3qXux2fQLRF89bcTxrxY2gj/bKApkFj54meVSe?=
 =?us-ascii?Q?PiqN1bQW8AKkWtqyQeqatBR+U69BYJEAy6njMOpSoyoD8ADO/oczcROnsk6b?=
 =?us-ascii?Q?3iA4sjbi2MRK3uI5FnHlVItMBDmuqZrT3iuIyBQX9xKMZbzudIuJEL3BxbLE?=
 =?us-ascii?Q?vTH+0O6O1VXMu3G0f8CZZouOuRLlZXT7wajF1kAfyF4cn+L/6UI6YX8HqS9f?=
 =?us-ascii?Q?pGnnHu+bEdQjP/27wG3sIkyPbImHwQ6nHcTOA9XT6g/WJ3UpdYbzTO1nd+Lg?=
 =?us-ascii?Q?QEgag/GB8vC9MO0c4GJDfpmrCacw2bhloADUSY98/UfgGChsjANEB7RCY5pC?=
 =?us-ascii?Q?NnXbRFJlrpx5pEmTYyUuUunRuyPfwxDD52v0H3ylDAYKLIvupBkoYU/3kt6O?=
 =?us-ascii?Q?MIipk4GgoDQyqBpDh8UHVWuvqAmIKgUvLmmo2dTfD6XJ7J+LxJ0d7NeXTcGJ?=
 =?us-ascii?Q?CVhAsmuAGLhczwnECW9W+jXrb4ECJgvftoNM+VnO1uRYL3VVSdk0Aufo3cta?=
 =?us-ascii?Q?RIUA3/1J0fImre45nNJwHMsbcf6OcY4zlFcOR6+eAFWG8oqIjbD0xKOHrygk?=
 =?us-ascii?Q?3KCaM8OPo5Lzt7HjJaQKCIxN6T37mbgBjp3kAEWKMaxfIN6Aev4fGzMO4pA8?=
 =?us-ascii?Q?kVfAxJiVDWK5M9o+FprdQWa5k0pMlS4RgSPjyGQ9KwJHIN/x/SCtOtsYzuMB?=
 =?us-ascii?Q?M6LRA7ZqRXy3c7uOvaDUWRtyvz/ATVVg40BgekJbDnIISeSPQIuBoNroBby8?=
 =?us-ascii?Q?yoVtgqayHeG8AOZN4YRHvYutXCIynlFxBbbOjEdftBszfAJ0H74mlqBpgErw?=
 =?us-ascii?Q?q0zVUSyrumotYklzbj2ZjnY2/l6PCVwifhtXI3qyqhE1OgZkWPLqfCql77h9?=
 =?us-ascii?Q?zto6N3oEbrsj3hZTn4MIqlYRD1o2Vyeqf+Oi+UazZig/X37jcsKi4XQYoXNt?=
 =?us-ascii?Q?wVv9oJLiES0tHcnxVpLaX8QsrSwuWhq3F9o3t7mraovJGANvO+3YqhAi8mOG?=
 =?us-ascii?Q?G6Y6MEeXvWCKDdm3l2bhzJJXqSdIoIM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780420a1-80ef-4063-98e0-08da37aa57b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:09:58.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlwmDnSbhNQqEidJ2tMErT9I01tZPxx86HW9CxsrbLFdW0fo2YS75hHfG7967ur1lDaPjHhZ0QiPt+zjaeL2QuySHz9Xn/y+YEdwXa7PRhk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1457
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=870 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170009
X-Proofpoint-ORIG-GUID: uG3V882_5bi5JPrZ_yxU_DKnMgWsfQYI
X-Proofpoint-GUID: uG3V882_5bi5JPrZ_yxU_DKnMgWsfQYI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> Return -ENOMEM instead of success if dma_alloc_coherent() fails.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
