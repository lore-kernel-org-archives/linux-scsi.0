Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE6DC77B73
	for <linux-scsi@archiver.kernel.org>; Sat,  6 May 2023 22:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjEFWoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 May 2023 18:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFWoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 May 2023 18:44:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C6D156A5
        for <linux-scsi@vger.kernel.org>; Sat,  6 May 2023 15:43:59 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346MXtha022911;
        Sat, 6 May 2023 22:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=aB4NwJCW9QO/6pAPW9XiG8DN+7h29v5WVLuBKqs2V4w=;
 b=y7HmpWSwD6VCLHLPmcZ+H1Vo3Op6sB5x8mm9kq/ZV5HrCpSc5DOM0Ot/Raawoa/K3JDf
 YbM7ej2f20QYJ894jmGYpGu0c4yTG0G0H1JxVPvzqTmiNnAj9Zmst1ZoRek+j7bvvp7C
 fAyhBGunakZ7K+YwXK9qVveFrDWQSpoBppetY0Z6MtbsnpQ745Iq9pIDtRyraXqjd3gO
 Jz+TCCNkgayTqluul7FjedciNuAF1YsxQ+9STY0z2l6VK+VG1/iAFbD+Bl0ND51n0OgY
 9L7lc3mxmprTS8hpOgHAET79KoFoCLFluixZmZ7FK4LcsHy5rPz77qmgLBmEhlajD36z SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddtch04f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:43:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346LBQNp023359;
        Sat, 6 May 2023 22:43:47 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3bam6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 May 2023 22:43:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEvAc1VaeYvP0hXj93TlEd5pfwt0JVfAjX7ut0jw47nxxtxhuJYulqa/zf1oZTcj0/E4cugdyYJeXTdnq7Qn6G0j7jVrvjT02SI5im9VA8u1lucB9xDTUwnRcGFZzrMa28cDtIFx6ZzSqyh5WA0iDf1yjHHJDL4/vhoSuSpjBQVkW7/Sd5Yarn6A/u/3jolSU8A0t/Cd0+arx/oblhZoLJ2TY2n5DtdWTueCwPqdWvALoqSJbQEvHB3ZnVWyskmYIAujDZqgMdEkkcW/dT6mzteivnv8NgCzkpOiD376PjXQ/lqHAy1C9XlPVDNgk8UiplZopIBpDHnKEklrwzYdFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB4NwJCW9QO/6pAPW9XiG8DN+7h29v5WVLuBKqs2V4w=;
 b=n+sMcYMnkFuZPq1X2ngfOvsejJWdUtSUi7N/vcB6IrRTHr5WbNb0onEMIkJ+PGpyYZQ6sHbrI8TQDnbWkL+ycPCnjPJF6B8SBnmOF8TB5FOcE8tow56mH7lEjPABaq4s8aclwUrpzwWeIKxV49IyZjRpVatEunSVRCBBp0jwRZuS7aQPjBuFsP1M12LVnYuMsXXz3e6W5HMnSRNPxpiFohvKKCvMdoJnhniEr8pbVy0VVY68JNDGlkVfqB1NWJTiXpmoOSFSgVRlyDKWY23FX3hsvmZydMV+JEc6XlXHh/YcteP8pReJHtcs/Lbvmdy4WBGFR2gCvCMi0rQ7MzW4Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB4NwJCW9QO/6pAPW9XiG8DN+7h29v5WVLuBKqs2V4w=;
 b=SAN1k/JGm+Tq5C9iG9HTUjKGJGSsMorRUzCbygqlJl4/tMfWcCepweWCZe0ykloy/C4vHd6URWnuQCmeLR3+I9JPdH0UfxO0+foOfUynfOnN4tV9cfdnF6BYoQh/+UIlaTK48ezqfb1HT/jA/I82QCq7SJcZBXQ1Gj3iaxc4BOg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB6334.namprd10.prod.outlook.com (2603:10b6:510:1b1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Sat, 6 May
 2023 22:43:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.030; Sat, 6 May 2023
 22:43:40 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <david.strahan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/12] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lei12i9i.fsf@ca-mkp.ca.oracle.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
Date:   Sat, 06 May 2023 18:43:34 -0400
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com> (Don Brace's
        message of "Fri, 28 Apr 2023 10:37:00 -0500")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0252.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: 18c5d42b-8aaf-409e-ef7e-08db4e8356cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9w0SJVIxigGQZA18q9jjO6Y+4yGKo5naCSt3P12W1tPu++/fUE/wwsID3X+iea0NkyGxHC6mqJ6/WEQEl4vaFFty40jIYdrRO97zkx+B431kBmI9jlyNlrUEq2vj+W+WbZ3eznxy9q4OEoU5hR0a5PeKUcPgy7tPkA80oYaWjltHFZ61wJWsfziAOYYXx8S9p6e7I+4oSWy1aBLckmQKqSvaDOezXRqjJEDqfjxnuLJuo9MPFlkR7J3rXcttI1JItJR7h8x57hHq3qeuqQ+nIFGMzEHW70aXX+KGv3LX+nAv95FNvNJhmQDv4724B18NVrhBpaPIDj9XLwRLZa85NJhyeq1DBhI5Z9n6D4Ij1wk+YBP1bh+4trbEZ7QbgJFenGW+DIe8/jbdNbTiOtWAJ+sVKqqzlWrfq02q8ZwMXlPnz+BPt2haI5uabLqmfPDMiAnxc9VXrjRETIwE4U1c7YIUh37Xq6c9Q5kDLaNy0OGbs6HTGTVFOmtd0LExVfraCXVEteY9yKPrSBG6gzDnmurV6wNHRjb/9DKzmHptk3qKxyTdGymX6f6wfyzVeOtS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(2906002)(15650500001)(6506007)(38100700002)(83380400001)(5660300002)(6512007)(26005)(186003)(8676002)(6486002)(8936002)(7416002)(6916009)(54906003)(4326008)(478600001)(6666004)(86362001)(41300700001)(36916002)(66556008)(66476007)(316002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mBKLIzE/2i63a1tHmxbki1D16ge9hY7lXWBdMp2fI6cncO8Ao+VZ8J5DWvzG?=
 =?us-ascii?Q?QyM/jH2BzAY+gNTe3mjc8xdz2BB/ECGgt7kAm0b93phC+t6smL4K2drlukeH?=
 =?us-ascii?Q?RmRu/ZtJNghi5Nr45Mud9N/hZGNpYbnwkFmBGO8IAE1ICkxHqmsTht8P1s88?=
 =?us-ascii?Q?iiyLTb6/307Cv64vvZDNiywL9KTE6auQR4K3ETtoP4xTQLusPAebm4UgAK5t?=
 =?us-ascii?Q?/HnFFE8IbtXVWsuKT50wDpsd63jBcAPWPXkkOZ3HFeoHCkIhVwzfEXRGoKU0?=
 =?us-ascii?Q?rxpvo+giZZtN0g6aol95jZlZckJe4qVqTIss3dS0yYHE7dd9abctytO2uHDF?=
 =?us-ascii?Q?36K7UoUD1Ovo/TyjKbiDZQcFLT8ffrps0Mg1JgZT2XF2WZOzbswThZHx+lsM?=
 =?us-ascii?Q?rDQZHb9xDZV0+XHMAEyaPy1Y8SuekiUb4e/lL8kKoFnl0iRfaQsaTqpT3OUH?=
 =?us-ascii?Q?FDA9aaoHpBFMPRCXDlSKhuTjnJaaP8fleAGQG3XhkDHi38yTzkC1mII/Ix9g?=
 =?us-ascii?Q?lltQae4BQUMn33dpZ4JKwiAS5F+s3ehrIxPAr7LLhFbqL68j77Vl7A1DCk9c?=
 =?us-ascii?Q?TEGausNsod9RoCGjZUlDhFIr9S7rvxexcEmxPcnvCd+uZb3QdraJAIvOiROs?=
 =?us-ascii?Q?dja2thOH1qFpmhnLhsOk8dlcmswAgQL+dIEhe6biPj7ptBiwotFMbquFKOYq?=
 =?us-ascii?Q?mUBMUdIpi7Ak70jVGRoz88VcFVr8xl7+chIeUwymdM+cUwaaqYWv2fE0gK6o?=
 =?us-ascii?Q?iih84EefnRWH2H56VR6+Cjc5x9QEgYrDm3KQMPC8wMcitQP6J170YkNMCXRU?=
 =?us-ascii?Q?GB3n0+/a0TDGen0zkt17pJPj5eNeC8EjFGC56Bh5c0ke0raKlY9F7TtDOzja?=
 =?us-ascii?Q?sd1klf12mkcIzhrA9oVfwW8UI7u8G0vNW4UshNyjYJfvWydX10yC184u9FNP?=
 =?us-ascii?Q?FkhNIhpln09WcToUEzSl2bzAVu/agzPmP/mFbGd6tFwSktV9Ieksh2ROfDaQ?=
 =?us-ascii?Q?fTf/LHy1PLGEfb0eOlWQhGbCzGdwZca47kf41qLsKQHR3VsCKcEXpRsM3lt9?=
 =?us-ascii?Q?hIJvdRHor5+feLgNSR3oSHlFIpHcyMioJtKqJrBSh0iOi7rWB9Cn3HPuVrzj?=
 =?us-ascii?Q?oTc2LDIc9wWYyDd02jteWZUf0eVaaI9z3/NwMA33EGEmgufidIZhQvqMHElv?=
 =?us-ascii?Q?NPHxLKeXqW7jmAOYk03++ZVKlazLfdW+mXayhhBY2hZ+y+aolahjNo47qq9V?=
 =?us-ascii?Q?UsARN1F3pYGCqSAUOfWi9G0aTO81B1UaFndGh62EVDzDWhwyRRNltouHB154?=
 =?us-ascii?Q?JcYqHBArV0GKS2oNvp4WoAhBg2CpEr1XMRn2cdj/Ok1pLaHI4YjktOK2c/um?=
 =?us-ascii?Q?dun+Fiqp19+EYUCiJ1Yq7nJ5MFCPbbfnBZ5BLiEm0bpBNpG7jrYmw7L4Layk?=
 =?us-ascii?Q?q9j7ykXLnS+c6YlJYyeQI/wvkAZ+70wNhh701aFJcQcM/W0PWLreuIlyQKMp?=
 =?us-ascii?Q?BwiHA+odj87n2mzKSxHmScaBRzOCmCxwxWqMSK27g+otqjX51bffEb7MpmDG?=
 =?us-ascii?Q?A+RnQXZ9dap2U7+iB9Kjsabr8HUQPN2vFZDiuP7TyQi/qTunlwn4ac4K1DLl?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Hg9OO1RmhlUOdS7Jy0VZ1M2ita4fI1D0rXNmWrresZF0GS8s/rUJHxL97jxr?=
 =?us-ascii?Q?EGgH3GWNPuJIU6OX9QWYrmk0l9oiGBXB8xFAre5J6gNeJR73V2ARPjQ+e8Ad?=
 =?us-ascii?Q?pJ/04mnrX6ZT2a2WwlSDH0W4jUKtVzUBVHROlEedRGEI5uLQZoh0SzT9GKz7?=
 =?us-ascii?Q?jj5JAtwvPJtNVL6e/9zhwWnQ9iqGZUWHzGipQhr8MnArJ7dCwEDDV2JhJT5B?=
 =?us-ascii?Q?T99WQNsnuiIdBn9aGo3MNysbv9m78RdIwk6dHlC0OVL+Td4NH6UIzPZq88mc?=
 =?us-ascii?Q?JbRObePeAG8XCgXN7YjVsvu0XuPVN5w6l9m74/NSiydVPc2ac6Xe/6Pb/urJ?=
 =?us-ascii?Q?PVsnbtwhx+iY/VtA2sTmtfMV3THiJdxKIOCHZ4U5O02wdMbCnRInS12mxUJd?=
 =?us-ascii?Q?XT1yyeCiacooS4XhfisNok89I+Pe3n66TY2Sc6U8vrUgDEY/URzrgzviiabN?=
 =?us-ascii?Q?0EZxtHnUqID2HSHNuYJxZc4PYzr3ibHBo80/I3t7HFUeF0FQd7dSAvPkwEXp?=
 =?us-ascii?Q?K1t9JqpoLqrsD/1wrLZqBvlRl4BgXivsKo0THsnc0LP/Iu2FVP4mLdA8B9US?=
 =?us-ascii?Q?iDGdjW7aPV37mBUs9sfKfAZm7A8CplRG+dgjkRFmxEYT6kQLOlQJzdGSsdPB?=
 =?us-ascii?Q?AbRCJBcEpWnF/X56mBjJQT676ZhSD6z1wHEepMorDPAHtZ1LobCr351Ym2XG?=
 =?us-ascii?Q?BV9GPcN0vWEGIWRmu0hJjEXn2eYXP3X5tEjMYWTtruusCJno/jFdeO0ELVjo?=
 =?us-ascii?Q?nNreBCS7gjtAbLOwyX19/b7DICr9f6ARQ5Jy7CoxoaMacb8nyj5rPM7HJhV9?=
 =?us-ascii?Q?KDgKgybeLSbYZrMwwJyy4uMQxyTwA8fA3agLfMUpKRiG7POt6CFmSBmp0jzQ?=
 =?us-ascii?Q?QJ1z9zbuI7/FaQK5/XuKpmzgrMOhboco8TIh4qiLvX5A1dtPTHq6R/s5kAnL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c5d42b-8aaf-409e-ef7e-08db4e8356cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 22:43:40.7985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3U7nH3cBas6gzqsbRJUHQAZNPoQqCIm6Jh1zRT5CUsdou+VS9rpt/MEySBrAaIXw0yt9+jHDjOTGV87byVpaA8X7BvPOQfB8Yf57c8IC37k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6334
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305060177
X-Proofpoint-GUID: yKQ1a2w3AJJbqrZMSORxXXIkHgvjzwv2
X-Proofpoint-ORIG-GUID: yKQ1a2w3AJJbqrZMSORxXXIkHgvjzwv2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> This set of changes consists of:
>
>  * Map entire BAR 0.
>    The driver was mapping up to and including the controller registers,
>    but not all of BAR 0.
>  * Add PCI IDs to support new controllers.
>  * Clean up some code by removing unnecessary NULL checks. 
>    This cleanup is a result of a Coverity report.
>  * Correct a rare memory leak whenever pqi_sas_port_add_rhpy() returns
>    an error. This was Suggested by: Yang Yingliang <yangyingliang@huawei.com>
>  * Remove atomic operations on variable raid_bypass_cnt. Accuracy is not
>    required for driver operation. Change type from atomic_t to unsigned int.
>  * Correct a rare drive hot-plug removal issue where we get a NULL
>    io_request. We added a check for this condition.
>  * Turn on NCQ priority for AIO requests to disks comprising RAID devices.
>  * Correct byte aligned writew() operations on some ARM servers. Changed
>    the writew() to two writeb() operations.
>  * Change how the driver checks for a sanitize operation in progress.
>    We were using TEST UNIT READY. We removed the TEST UNIT READY code and
>    are now using the controller's firmware information in order to avoid
>    issues caused by drives failing to complete TEST UNIT READY.
>  * Some customers have been requesting that we add the NUMA node
>    to /sys/block/sd<scsi device>/device like the nvme driver does.
>  * Update the copyright information to match the current year.
>  * Bump the driver version to 2.1.22-040.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
