Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45970C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 21:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiKOV2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 16:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiKOV2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 16:28:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402F0C0C;
        Tue, 15 Nov 2022 13:28:46 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AFKcAZ6023866;
        Tue, 15 Nov 2022 21:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3U1Z+Wf1A7Rg2/sr2QAOlhV2Xn4XQzweQrXl89XIfnU=;
 b=DaYuW01KwFnCCdkMPp94DsPzmqI/oli5S9weeDR4Xv55i34AqA38GyjczjWIR6pmINqc
 PDhXj62qaxhhc+1ihyotp9PFh+xwvIWqsNi+cqcpOWXKHrR3p/RwwzyqZZtzekaBTl1a
 AEkmex94B65lXpvADBLHanYOfg9R5PYuACBDIdOsIwvJB5Rx/zNrH5S74gwT5v8Dro/5
 Pv+Yw6yAq06l21Rj5JSMGEoiNlDych+Eb7ft6QUda8BBOki1ZOFlKr8TiwzL6nGOK0lS
 NYYcU1/iZjGHm9hnFVWjbuBGiHKUdGZk6u4AaoEaTMjeDj7hQssdUQMUy7kv6OOrIQid pg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3hdtspc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AFKDURd031804;
        Tue, 15 Nov 2022 21:28:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xcg3dg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Nov 2022 21:28:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0ip0HkGU8bJwzshYniR1iVfocrp7uID/Jfd8ExHmIwpDXCqIuvXOvjDbPYYQK7e8M3wpI9F72QHOrEq3HdNm6Vlyom1FfuI9YyB9m2mp+fk0RfXw5ANAn77jG1Q+a0bfXNvRNXtiKEA2aIOwo4L1Qj/80DEZiH8D9OcIZVa9jlbXnl+Ag7BrjkdhEK2rvigi+gNX6j8yXsKG1ww98gyMVbUTSRxhwnsgjL4uWzO2JhjHA0esjipFvc5hVwjUyKnrKx7FyMSys5O6aG+i4WxHu1VnyHt6PNn8XGaLDpcURl+YxC9W7MbV8ss2PxzEl5cfwsYFS9h/GrDAN5vw7daPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U1Z+Wf1A7Rg2/sr2QAOlhV2Xn4XQzweQrXl89XIfnU=;
 b=WyG1W4VfcRZ+YNTOVm8x2GdxVZkZ6zxo2JXXb0VzOCoIN4WcBky8apHaChPhXHCDrryH0VkphpB5irDN0/wr0gh2GACyS3oHlvMpvIjCrXm3Jm97ScxIuA7WT0mdz4UAO2u7lLAlHwnnhDZ8RUEiAG4byAHOB1jSpwsxmkQ9iMXV7ABkWwTCRQERGktCg3Oc9W2PQNapzxOUs1tW9ZPcupYfVDOkL3uUuXCHyF+WyqyayF/4QE2CNE5aLcgHJSf40YFT/mEcwxOm3qlAeGK5N3ynRPq92alcyUBB2B1UadVZPxX+41hF+ANY5GkrmG97yYs3v0Pst3LmfCuWW8EQNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U1Z+Wf1A7Rg2/sr2QAOlhV2Xn4XQzweQrXl89XIfnU=;
 b=tqbdOOJtpA54sf1oEiKJ2p2swif+aHbXWCIvVLDb0dMO5YoG0B/VrTd+tfuak5YqeQdVE5S3jQnZWrUPZeTg7n5bljjFiLPr1xPhvqFfm96sExrmWyGv8MSXrtQBhgzrfnbyEZ7iS6AEc4+COHW59igeFn/aaMKREK8/xDV8pMw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5368.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 21:28:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 21:28:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/4] block: Add error codes for common PR failures
Date:   Tue, 15 Nov 2022 15:28:22 -0600
Message-Id: <20221115212825.7945-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221115212825.7945-1-michael.christie@oracle.com>
References: <20221115212825.7945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:610:4d::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: c7903ba2-82ad-4c46-64b6-08dac75056bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUYQE1lzB3vbEn7w9oD1/NtL250nrMZU8kkLRPcSslej3r9+aPbJRsSGWtU/kRuqiazEjcNChzdJARv5gH/cXQV1uQJX/HfY5vJ26qJZTXnBTHBnKqscwAbHeTs8zVvn1TFC8RcauOpXxCTN/maLAIq6PlaAKotjISqr0no9veAYqP0ggSZQW/LmOaAv+9kiQPcf5VnCDYgHZzrXHq3Vf1UtVK1BvvXKtPlSNEbYKkrTsdyDK1oEntrPmD7XJ+vjlEoYGjeGCimtXk7BFvZ6gtbhwCouADsb//aGJVgPfpaze9QuPZHS4IezBXjAt1lj6ao3yxQMp9+zH4JywiaNGLHpUQSaYuPhDXD++gA/83DsgcuPCJDd4cj8BVQkC0lPuY8IMYAD2DyBa2luDmSRtk+QwRmzhtUNwCpT/NxviF5190qYJmm7wDWi7Xd9K3rlihAcYUkbVOtsTq6e2M2uh9sRAcEjmkzHdHzKyGcntucTzEbDRfcu66Oi0EoqkEumlm3MR/tDBQU+RMqfovb6KfzF3ogKSr+c1pKIlZCPsGeykytuaVYwdsP/bUYd14+I3UwUbi8uzIsE/j4vTXnzLCg5j+w065SeTpJOxNdxuOG+ix61JtKg7DGpBlA74erTsVG+bLCJx8zAmSyKmeZ2mj4+szEZ4A98RLW4n3X0Fa2GI6GXrQ2JG+I/AYXSr4YMtWzeRFAoXZ0oo6OBhpe+nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(1076003)(36756003)(83380400001)(6486002)(478600001)(6512007)(6666004)(2616005)(107886003)(6506007)(86362001)(26005)(186003)(38100700002)(8936002)(41300700001)(2906002)(5660300002)(316002)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KQGV0TUxYwSjc/EdQMpcXIoqcJq7QNHHeH06M7h7t4hX9IapzGzrbk22Qlre?=
 =?us-ascii?Q?NHBshTyzUb4SLWgkDsS9ghK2SPX8sIXyL7wt//DR5UCI+it1B33sGHSxN8YF?=
 =?us-ascii?Q?ZQFe2x2qA01vHDFxQJi3Nw2yw9Qc8pLiX46FA28BtMWPuXziZjxjtARSwnIn?=
 =?us-ascii?Q?BC/7FOMn62eYmu5kIkEhuyxDEwQv5DCWAdyG2IGTKh/SnNWpcrdBXHMnheDd?=
 =?us-ascii?Q?143Rh0GB6I++8Bz+W/nCpkTKaaBhO6qfVDPgb0r7FYjp+etGYcLgVaJnDUS7?=
 =?us-ascii?Q?f0s8FAS+Xg4QPrRmDavnG0viKiPCwwdErdknLd72aTjOYbdRCCy3Meq1sf+t?=
 =?us-ascii?Q?U1KzZa3xq8/zfWZojsQMVcEQCCbV3VjEza2ljVaBnkzhQdKgGrImIc4+HVux?=
 =?us-ascii?Q?NDAc4n17kxvJwiovxDwGcDKIWWgnBhoviKPZRAkNwE26PQNZbZ8MDSsUoWvn?=
 =?us-ascii?Q?jl1/c7jFNHngpzTGeui1u7VO4zICxJKsIYiXdWdiK4IyF1Scxboo5qjMNMZl?=
 =?us-ascii?Q?AEhqVTvOaj3mja7r8d7eIFaHKHkm9YdWJIvpNAu7dDAn7BKZwr8SvP4CkL8U?=
 =?us-ascii?Q?Aqbr33ck+Az+QMQqj0l9osSU2o8AcBnMXA8fNCnN684klezaYk8mCz9k8xOk?=
 =?us-ascii?Q?oOowppxJ79noVenLN2p8bb97ciVn0YyrxrsOsIzE8G3+CH4t98ZNqdUUU5En?=
 =?us-ascii?Q?uQyUKcsC//cFCqYwYvcfXlxHUaeWSAuFAec1fIxebt1i4XP0pL01xOn2+0he?=
 =?us-ascii?Q?+imsolZG5SlsQ9AmTqpC9CkmJRBsS0Id4KUanBDes8Fn5TH11h7csj7IbEx/?=
 =?us-ascii?Q?JZm1kyXZUdgYBxcVM6Mb0FDMtMeGdZaiQ99ZD9udS0V1IrsGRL4lGWaH8Bo5?=
 =?us-ascii?Q?zwXMbFMl6EklI0eX9ufz4fvu6+9WDUdgjaDrNR2ZxXUTteRJXo3Ajf4esXwV?=
 =?us-ascii?Q?P+Rc0Woz+zYtRYtndZ8yt8ujJtghBhtiC7Wj9eflV0mma+lbAUbdDGl98bT8?=
 =?us-ascii?Q?atVYrBmMhyKuv6ADNe54DpAh2N30uDt1o0KkSzdsfAxslccIY/enWsYGkGms?=
 =?us-ascii?Q?CaKOqMQCp+3Zyw6R8CyE1lLXKuH7he7E6hrDpWvUJUunOVrQL3oHGv/mEi0I?=
 =?us-ascii?Q?rjN4IyoS9o5kdPHDbj51u33Kt0S5j6iSgfmEx46XjTwlmWt5Uz4urxwTXQn2?=
 =?us-ascii?Q?/9McXAD8URzOIuXZBWsmVziNCUsyDcQZtIfSsxPMOWTcXZAa5yAChPhyFPZ3?=
 =?us-ascii?Q?qv3ui5rmsE5i0ofpQnctMxvgIVNIskH98Wt2PofZJk0kKYUjrmBSJntJ0c0/?=
 =?us-ascii?Q?gL7JdbqGD4jvvHGH4pKpSGriG8aRYkZDx6NqcRTHVP2tAjOeG3z/7hKFxTOg?=
 =?us-ascii?Q?2rfcRF/sM1L6HDSGfQ353k4b9Myhq67Ec8KHlqn2wbptu3q6d6OHsY5mFlxH?=
 =?us-ascii?Q?e5BapD1foRU5fIeGxCHW03JvD6gXn4TEoyFvj8/LqaBbuw7roBvGnUlnuEbc?=
 =?us-ascii?Q?Gh0JvUDTxjWUbEHPoZUzxz0ALijdMqoRB8Qi8ZyNKk+8Dye+DQug3wgQtabN?=
 =?us-ascii?Q?SwE53BuxjlMTYH8Gb/VPP3N55SNQSVPwRYXrbFNgf3HPwPPfrmZv3wQg6R7c?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ly3h4Jnapv27IX6eTZcfwsC+tjGlQNZMMbGRwEp3AWj8Y1JNdhCNrPAlhej4?=
 =?us-ascii?Q?BdAGWeh3RT6w+hDKW85AXLUObwY0RWwSsT4NwcLGrr3ek3ELBNJnl4YN/0IU?=
 =?us-ascii?Q?Qj4AqHqDO5b5IkaF13vVWiVj/sn/wHfw0tTc1RdX2yVt7zHqnZV6D79fXOIN?=
 =?us-ascii?Q?zbJV/gzwY7NAuhVKrrplmT0ZJ50OZQ5LZAM8oStA6NY4umQvqx/BmZI8RVuy?=
 =?us-ascii?Q?lnehP/ljiMyXyMzD0+DQL5lQPVX5SSmibNlDqhPadpbtJ4x5kpb+P+7jJjxr?=
 =?us-ascii?Q?SleguiAorrmltI24tFhrnR7P7z2hBJGnzBqpDLkRAGAll0zXwpcjDFX2EoS9?=
 =?us-ascii?Q?vHOh3RAT5BbyqU3mAYdB0Fr3qKSsZVZNCmU8Ok740cHqLd7c0eFvlcTVAWpR?=
 =?us-ascii?Q?fGfshI347Sqj/aO6PrzQ6796dXO064VX9Q3wcLS57KZ+RE8MuSvWIT4Ol5Cf?=
 =?us-ascii?Q?XtpWx/9VTNEvMk1MO0iLjWWZiS8StnREyRmFnRV5/L4AtCd8OVP3/fEUDva7?=
 =?us-ascii?Q?g1G7Hr/uJOLh6SAgF2pxxOZAghRLLYt3ADNZqhEhZ02gmJnh1KN4Rt7soCU4?=
 =?us-ascii?Q?rf28TIHhI+mOOIWXsdRE6vTyzzgV5xv0xe39pLIdsW6QyF2la4Q1uixNggCf?=
 =?us-ascii?Q?3Ala0wgH2uzJNKEWkQwka0s8G4S3LAmWxc7t30Tm6AE68d4XSxyR+2z34LA0?=
 =?us-ascii?Q?Sj9RI2Pfx3GTksm1LKVIyIyGOsAGkD7P36I3CL6BGUsXCFL00XNX5T4XntEW?=
 =?us-ascii?Q?4rMJs0ooX4EUd/FQqDBG8+h1hbX5dMvXgwwrWFi4DtXBgkK8l07O3u398vX0?=
 =?us-ascii?Q?PRMxX1t8/UHZJJv6UkfHtW4IoPZTQ/mwz+zBcKt4+LvSEu3ZHKLut6/4aSUD?=
 =?us-ascii?Q?zvAdfkmv1XhMkN5gEAM68GpHJG5t5JlDMQE9MWHZsgdQmzxLVrDLGQAaaZje?=
 =?us-ascii?Q?42cU4eYFyzHFaqbV6e1h3uDbOCgPKP2Uzkjg9ey2BkZdim3vSNM2NMKR32YJ?=
 =?us-ascii?Q?Ed0A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7903ba2-82ad-4c46-64b6-08dac75056bc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 21:28:29.4250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ajj4q/sX2XXMAovfBimxB4zFHn2QJDfOjzCt50mImtaJ0LgiKP8WHy1rg8lw/5rEr6v5LaUnk33/SZ1575VVQ4xljYefMnpp5Ko3WoVAq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_08,2022-11-15_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150147
X-Proofpoint-ORIG-GUID: XImu34Qe1pFnrj3PqBcgZxJuapgxlXhb
X-Proofpoint-GUID: XImu34Qe1pFnrj3PqBcgZxJuapgxlXhb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a PR operation fails we can return a device specific error which is
impossible to handle in some cases because we could have a mix of devices
when DM is used, or future users like lio only know it's interacting with
a block device so it doesn't know the type.

This patch adds a new pr_status enum so drivers can convert errors to a
common type which can be handled by the caller.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/uapi/linux/pr.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..d8126415966f 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -4,6 +4,23 @@
 
 #include <linux/types.h>
 
+enum pr_status {
+	PR_STS_SUCCESS			= 0x0,
+	/*
+	 * The following error codes are based on SCSI, because the interface
+	 * was originally created for it and has existing users.
+	 */
+	/* Generic device failure. */
+	PR_STS_IOERR			= 0x2,
+	PR_STS_RESERVATION_CONFLICT	= 0x18,
+	/* Temporary path failure that can be retried. */
+	PR_STS_RETRY_PATH_FAILURE	= 0xe0000,
+	/* The request was failed due to a fast failure timer. */
+	PR_STS_PATH_FAST_FAILED		= 0xf0000,
+	/* The path cannot be reached and has been marked as failed. */
+	PR_STS_PATH_FAILED		= 0x10000,
+};
+
 enum pr_type {
 	PR_WRITE_EXCLUSIVE		= 1,
 	PR_EXCLUSIVE_ACCESS		= 2,
-- 
2.25.1

