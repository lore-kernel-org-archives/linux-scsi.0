Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BDFC7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 02:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjDCCFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 22:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjDCCFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 22:05:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B669005
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 19:05:29 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 332MjCFU032586;
        Mon, 3 Apr 2023 01:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xQi6W1mlZp9NPSPSUXet4+wp6icBIpzuks+oFW5jg7o=;
 b=Osqxq+CUW4NLlOb+X+dco7lEYk13bQkBs4aBv/TnKst5GIY4mGaNGsOg9d++TwIKMGTV
 guFlIzszR5SOPcXY9wGGn6rkb3F4Eah5mBvjJbuRFf1xfSbSxFnh1btiXIun+aW7+Pc7
 dlWHkHvVaEEvv9oIDfqw1yeM0aUNHtp8PjMVO13A+vUgq7pblp4WMWxpFON9KEA7iA5h
 WZtQnnxQGsUWN1bHTeaLrGOtaKdqrZIKaj1rtxZ5zSkPNqTU0YQtpEfs6rmwoEPevfMG
 XSM6giDW0CQSnb4BHr9YFTtmySl/0lq1NbFdoOfPVHM29C9uXmg8XKOKmNEVU40SD3QI +A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dhy00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:19:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 332L9IVN027834;
        Mon, 3 Apr 2023 01:19:37 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt23vhfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 01:19:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdCxYLBIIAH2njj3IJgHbeCAyEwDATMS4wd7m+wN2HUtwvmMKlT8jc92Q/5ycEpaDy/Rb77GTQk4sUFAcAc1SVaJ0wbKlTKBXHmdfPtE9mLpWv6QGuFfkag9RAkFlYaxSOO72138eqg1u8n1OIxCRk/KYYRCanKj8TYbStCYaah0Zw1TYrf9c4ROEB9aiQAK2yESOrROBWA+lT0zPzIZuAatXQkNDEGo7lPCAa8X5NGrGygbV1zryGEu8uw0WbMEyweivpEYuu73aL/ExaGB+OVUeuelrmc/P7GWtWmR/nlSF89W3Fu04ndq0xgeqCk2X8UhlHCG6RdLU0QGtjDk+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQi6W1mlZp9NPSPSUXet4+wp6icBIpzuks+oFW5jg7o=;
 b=YWXyx2fTqwf26ryQOdZgYkYHyjAFVSK2iyBmiAPvyVLcUhUstMpf5kxdohvejy660JGKgOfUYITBv9+0doUwfvGxNUPI2FfwEiyLTkeGYORh1y9h7gLKmwezGYcDLkKQxxsHdswy0ooeJAppKGZ8bdaKM3Vp1548VGxp6sjkBi4XwaDgC+Hy7NQnCRWyW1DOyakayz+23wkPEGOa3XEy9z71MkRfkUhQrpSyEa0E1XTUzTaGat0Ho7jjayyrdsLBg8JxK0rNXIhlrsAETVXQVaw6bvqfIGq+lioVpoCApaqfYHNVujfQqx99nrFFYSpP6jOi1IP8HtOwHo3V47xjug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQi6W1mlZp9NPSPSUXet4+wp6icBIpzuks+oFW5jg7o=;
 b=rRdIoVB6ugV1eotKMbHI9uJZXU8Lwb1DUyuuS8OIDEexGtXCgxzB8H2XOvTyQOx1DfPSvEN043fZW8DWiVvrDv6SdmFRrXL/ejDnML+iq3Gk8AY5lSNM4X4sFSCxgo+2Sc7IL8amXVPfCcgpf5jc2BePEFxh4DZaD68JF/QwAiI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5080.namprd10.prod.outlook.com (2603:10b6:408:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 01:19:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6c5c:93c2:3d1:5e98%6]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 01:19:35 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>,
        Xingui Yang <yangxingui@huawei.com>
Subject: Re: [PATCH v3] scsi: libsas: abort all inflight requests when
 device is gone
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5zpyd7p.fsf@ca-mkp.ca.oracle.com>
References: <20230330110930.175539-1-yanaijie@huawei.com>
Date:   Sun, 02 Apr 2023 21:19:32 -0400
In-Reply-To: <20230330110930.175539-1-yanaijie@huawei.com> (Jason Yan's
        message of "Thu, 30 Mar 2023 19:09:30 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0296.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5080:EE_
X-MS-Office365-Filtering-Correlation-Id: f64b5fb2-1ccb-4ca8-f0a1-08db33e17c8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jt6aZUSWoowntVcIJ4c3AbrFYfQrZW1nkYTQtM6J7I6PEu12c45G3dXv18DPoncd8VMGEMIVCBXqp1hWhlcetKo3yDtyUCxommR3g4CJYe4sL+3x9W2xsFg5nicvrVIhrt7rFU8ol3AWyl/oD2XNzZzofCepKwhrRVGZjZYJsZvHXNpCvdFGAAKrSzQAsyzwP+AHTR/vwP3cA4xIPVhnlvjJrPnmTjR0tozFBTgNKiOjcxBTJYqD4toDlmuNJjEjbkPj3tpC5FfTCmMifw9TO+glKV3qVmeFRIKRNNoqT8CTXGd1pqmzqu12PBXL+7TgFFpbRQUl4Ci31W9NCoePDbBUW5wgBdMWpXjs8ImQ0CVPpi4u869fuXMwP9muzGIJdaP5um7WInHqR98PNo9UlY/d/cUp21tuCT07nXRLQMLkSjg6i7Te7/5P9+TTa5+RWgcVpWf4hSyfUcCzZSrDtWJ8wyFhBwhd6YWBrkixdip3RXnvwPv8XiJpvnI8oXz1J7O+SzrPMPw08wbhRsTQPZcLITeIEcr3NaIvtacyrhxv/wh0a36/XZhpipGtnFk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(86362001)(2906002)(36916002)(186003)(6512007)(6506007)(26005)(6486002)(6666004)(4326008)(6916009)(8676002)(478600001)(66556008)(66946007)(66476007)(41300700001)(5660300002)(38100700002)(54906003)(316002)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gz/a8xXcGozKCJ/soJ4WM9tMUWzPJOYJVIP/zxt9YzWTFKhpR5T9xbPmHSnd?=
 =?us-ascii?Q?s96cM7D2enBjJjFrRNT3jIiPBNL7r0Ka3yglP9n/rmoUIctR1o0hx09QjsKi?=
 =?us-ascii?Q?llQkAjAofyUPrnAYjqnh/JQsa1D8fKQrsmLPDUgqpinLyNsEbiluq/4pBVAJ?=
 =?us-ascii?Q?RvNTud+NYpKZykFUaYuU8+LKpzxYClV0x199mKDVKQbeOKV8D+8YydTSL3HD?=
 =?us-ascii?Q?yfzAO/w3bsRrVFxsSdJ/HS9XagNzaJpllV0lxF1LyuNZaK8zpoY8sbI3oqji?=
 =?us-ascii?Q?NsuApp9tgUNq+jHqXpgvjYW6mX+RYd2fXvpTjiPSmMTugW26G7uDwacni5uX?=
 =?us-ascii?Q?qLZTSyrLAu+192aXWXV73st5JI4Yw+O78sB6LdgnHko4Z50rMCc3EnqrtkYr?=
 =?us-ascii?Q?cMCh57jgNwszW8twKxsDplP1sPyf9xd429kouHYWTQrzJTNIHv1hEJIQT36u?=
 =?us-ascii?Q?3teaieIhIQKFXvTluyDhvvPEbMUcWIPpERRmVmwxUeVo3iIicHmMGxXYSuk0?=
 =?us-ascii?Q?ZY+7UaunHa0ksdNKQwsHZXZO4i7ahGv0vC4tPypn4hjnpppmmqCx/nwxKCS8?=
 =?us-ascii?Q?yxvbBZ7lQCM1yaYDz4QwThb4l50v4XzHkIFd9yMMfaIMGUuaS1OquCeYU7QE?=
 =?us-ascii?Q?wGDZvtN0gB3kLwGpvOH2g6pntLF4uoZin4JdqZd8GOHakuxx+ACEcbPxDguh?=
 =?us-ascii?Q?t3gYvBOuRPxvbaYC3dsiEdCXyO7/KFYtL/TKq+VPOSAzZi0dWFDIpxhZpm7p?=
 =?us-ascii?Q?ME3tictbVtSkJNmWaGEv3EBNjpuzNon+2dxMHC4papubePbMUA2FYuc698rT?=
 =?us-ascii?Q?xjH01grjah1JMBWXV+JM+LFgOJi89P9UVNRrEA8YR/WeNdpeFDSa+9Nad6OI?=
 =?us-ascii?Q?CcaTXEczgYiTmm3pYCdmt4nzsmQtIhCJUEyqj23c6VxpHFUdTqaxViksXhkX?=
 =?us-ascii?Q?YIIdBXwANbD1NCyuL1MkGdaBCsJ3PiDTiEBbapnykkUqiDv/m5zG53DGIWQq?=
 =?us-ascii?Q?2We/BfWURqUk1Gmv9CgpIf7rxf1gL3uayPcOKPqZqIVhJFQcwwSAdFGO/phJ?=
 =?us-ascii?Q?2zyUezZKvciU5fwBqzAgiCkqLuH4HP2GIM58wbgW7qd+oA3i4Gg5A+aD3dNR?=
 =?us-ascii?Q?HPJvjWrNWf2Zimi5RDgzSwfKRUpt2Yurwz0R2BGEcyuuxm7jri+Z897Ua0ib?=
 =?us-ascii?Q?7eJvs1RkPxadwjrIjALXW3FzwpJ1ZO/QodEQPA5rK96g48Rds1fizSKiVNqy?=
 =?us-ascii?Q?V0eUVi+9is0xuLXwP01DaGBTc2tG+eC13jJMiQ9U6qGsPwBzZj/klplhU/Xk?=
 =?us-ascii?Q?8tZEGhY2etjLkV8bCMgIyScR1P2wMEOYTCnkBgjNbrrsUj7R3ugvGhIO48FV?=
 =?us-ascii?Q?v/wNUinXP/kuYgciWMszeD0He4GN6TxKpL0KfCmuCzd6zH8fvFoAJhnrQiEf?=
 =?us-ascii?Q?QWnrVyWvaxQgfD73rN/fPWWidDbRxUIQnNWD6ZpX/HKXcMzOlI63BmFk0Cs3?=
 =?us-ascii?Q?2dEiMcqMTH6DrgJkMWpcVVY8WC/w6JvYLWygc4th/OHlaow4J0x+pHJcjPop?=
 =?us-ascii?Q?S/ZSQDBSpvVCqtGthMzFV1VWfRTNqVlskFkfOvh2hUmCa2G+bXrArTNPOKyH?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?AnMicJAIfFTou+j/WpI0SQYCCUM/jJsHbQcZ0nM4NuwAUcJznvVXcTaaPHMw?=
 =?us-ascii?Q?xGEAuUSs6XF1CCyFrS5FC2YEM9Y0ytsozXvBanPuMcEWC7+A/vfnf6789mEa?=
 =?us-ascii?Q?cJMjGE44N0Uc0AVR1SS0tq+y+imTwlH3jvgrBejbU7Er48/G0oUgWl5RHyJ5?=
 =?us-ascii?Q?sRmmBktv9DDbPIdVXv7TTwJmu4MWzUwvb6XWVZxsRyQqKhX87M5gFDlIsCjB?=
 =?us-ascii?Q?54Xl6Q82jkMpjYCgq0sZ7jnTk/uPVNE1clx+oL39vDuESk9DIH4Hq8sZfjCi?=
 =?us-ascii?Q?foM1JrhaC0ThPpgDsNkXWUchCl8cmQhRzR3j9isdVjX1Iv32IwkAF9yfMFdJ?=
 =?us-ascii?Q?eJ+A7gzKC7+SCg4afqt0tyDclGwn0/sACBFDF1I/KpvP7i8sPvTLpmb4TX8Q?=
 =?us-ascii?Q?lTY3NBtrN5pmeayOoIhG/5CUyNsmsmmowWI5y3S16E/TPStuy4TF+u64T8C/?=
 =?us-ascii?Q?yLgwv2KXt5j4+yuNdL7xD8M9phXiBHHKsrN2C4TM3nFQgTGEXZ1joMiK54ev?=
 =?us-ascii?Q?xyHCN3zv0Qv06JdKfjH08Hf76zIUdA2P1CiZsiFi7Qh0IivUI0wktsho/Y9I?=
 =?us-ascii?Q?elaie3JoB94tqXWkbr6WammtxTSyZURPiCZCGKFQuYfFW9nnN1ppVggbBmpQ?=
 =?us-ascii?Q?4SPt6t4/1yDX17M/1QCNHgI/l4kP8oLDuGe++m7o778qgctFfrTc3iPev6ik?=
 =?us-ascii?Q?1deRyJKsrUzxEoTbQcJB+TKs6OhcAAqdyHprLjP0ztVWXJd+i5WMUhld6eTE?=
 =?us-ascii?Q?tuM7vO5VVdD5HfPY9NVhOWgUZLJNVRKvLlcbozds7GrPu4WgllCoikD9JN7Q?=
 =?us-ascii?Q?1WVXu7Aa8+LGp1+Saii0OUIUfYu9pX33hEnqPe66Oeqsqv+/lUdDpki0HxVF?=
 =?us-ascii?Q?goE3JmQEAMItwo16NQ4S7x3Q64N77v7YbXWpq/zwftBIk7L0+VU+UZ2Xp1uU?=
 =?us-ascii?Q?8axihoBwz1G4qtWahrmn3tSw8+0F42ECTqEiuTDzaXs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64b5fb2-1ccb-4ca8-f0a1-08db33e17c8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 01:19:35.4777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzLw+Raw+AsvGjgf1RkYJkDLZ0eFwyrdr+IU5ivATNMtMRHnwNTvkSNN1irkUeC5awJji41jdeEu1VHvOUPIra7aTlbZcRg1XE0o6wvuOp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5080
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=928 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030007
X-Proofpoint-GUID: 2ajwD3Tf--bDaluko-ncbJvmvvq1qMsp
X-Proofpoint-ORIG-GUID: 2ajwD3Tf--bDaluko-ncbJvmvvq1qMsp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> When a disk is removed with inflight IO, the application need to wait
> for 30 senconds(depends on the timeout configuration) to get back from
> the kernel. Xingui tried to fix this issue by aborting the ATA link
> for SATA devices[1]. However this approach left the SAS devices
> unresolved.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
