Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA0FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 03:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiCDD1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiCDD1F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 22:27:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B1317F686
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 19:26:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240gEYN013345;
        Fri, 4 Mar 2022 03:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2l7jqkk8iT2t4N/kX8hkZLhl5T94xGlnm6ZsiEeG6o4=;
 b=ItnfL/VU99otr5lLgKH9l8eN9kzI0xBSq7ailLOCIK7K5pXhsdle0sBrXAs9I7PgMuLJ
 qgCEwyLdicnr9M1h3y6gV5d96p0DmzCuceUTgc6vE13XdMUn9YJJkMaFPvqSz5zpv+In
 nMu8QCw7G7K3bAt4yRhU11H3YEahsvzANYdFrLAP3mfUmGrElu+7ghL1c/Y5t7iu5C+1
 Ce9tc4m5HEg2D4TQpA2IdCfkJtvNyZNqB72pT/S7UrvUgEzRbcTtoMXBQpbfZFjOcvWn
 mhh6ZwNwQDKHk/347xMQJHSYChJhOEAuYIlxJLO7Z5oPVhMbTMDzLzbePP+Qtc1zwA1v ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hv0mxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:26:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2243G69T074210;
        Fri, 4 Mar 2022 03:26:14 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by userp3030.oracle.com with ESMTP id 3ek4jtfa6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 03:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ev+iOua44kP7QcpN0eaJ3aINU75PWZ3k7bwGTROcIyh2P2sQpR2psKFGBXZBLMQio1JTqe5693J5uPjt5v1HlvWMsdrdkQIZNblBpx3dmIXjlyr5RFSkgCcLsWG8XTL1UEdpIZe/BAIkeD4ukHw2xJRZWmiM2qTrKKcxcBGPjEMae0dCZSP/ptmTHKcYkgmPtKjjE4reQyYcSKWiw2YZhKEnQV5o6ewyw0NxFS4YrOOJwMhz3Tnhc30YR3UInkDix83MDXga2eszJT4+lYMBNhGs+iZYjporcj8VjT2dSCNv3FuAYy6bp3ois/PCl5VgIsqZ+i2VPDsjHJBDJrRIoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2l7jqkk8iT2t4N/kX8hkZLhl5T94xGlnm6ZsiEeG6o4=;
 b=fMPQ8S8IEN01RcWAEqbL8h5aTQOcQab1y+bAegPLRWTaNjh4R6UrDa9qzxS3f4+uIt+oGyqUeL5H85GEkvEAbaua7oHwwtBl/QUfClyAjfjVSMK1Ebo4CMVQjJ7aUGANpIlywU8r2upXrJbiOf60aR2V/2ajZgGwmRiMPlDgOAmcFbzf0aB2jWvX3h7XnPOYxzDPcmGwbIM06dxqfFAKVMcniqAQkGiTPhFrtDAaqYcqn7mU5sBZhWH4tG8a0MrTfFo9cfcCCD1p8qWe5o9AZs3QAViU21L0y1muOXaCMpnfh0z5Hmt2n7e5B7caEa5HZGHSGdEHorz3Xxl1q+GHsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2l7jqkk8iT2t4N/kX8hkZLhl5T94xGlnm6ZsiEeG6o4=;
 b=KqugAiLyBpAtu6XrUtosKZDXfMmz/VvDwk4EWAR07pOW8EN07nLDT+3s4X7kuXs7CP+TeJBkwfqh9kw/dsTt1dQkP2QxfTEnd61potfeNl6jWLUORyJNFuLESuNexzk+w+nLnBwLQrl9S+mfVZdHPSNnEZzXPjUZar7hxL/J+6w=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CH2PR10MB4152.namprd10.prod.outlook.com (2603:10b6:610:79::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Fri, 4 Mar
 2022 03:26:12 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.016; Fri, 4 Mar 2022
 03:26:12 +0000
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "Knight, Frederick" <Frederick.Knight@netapp.com>
Subject: Re: SCSI discovery update
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y21qtnos.fsf@ca-mkp.ca.oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
        <5a532d1a-d1b8-a153-4988-7ac62ae6441d@interlog.com>
Date:   Thu, 03 Mar 2022 22:26:09 -0500
In-Reply-To: <5a532d1a-d1b8-a153-4988-7ac62ae6441d@interlog.com> (Douglas
        Gilbert's message of "Thu, 3 Mar 2022 01:09:28 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0100.namprd04.prod.outlook.com
 (2603:10b6:805:f2::41) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 852f62d2-0f6c-4f6c-56e8-08d9fd8ebb54
X-MS-TrafficTypeDiagnostic: CH2PR10MB4152:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4152BBC210A0822B981F73028E059@CH2PR10MB4152.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XU53WPX4jrcLVYpMTFdrLyw44YnVE82WvfJ3BZYwAvntl/q17oRVBZy7RiYuKk/RLaMfApAEvqa8SO3XK8mi2TQ5ASPzzEmcJi10UwmvaTSGu31jKclHNGQPgZjS3PxzGQf7ifp3+/9SJfa6uYCcIPzETyR9Is2p9NTUgxniHxr4g0BOQ0WM/QGRv9dDQBqZrkFOfbO1MI7YlWGWJgjQYBFMENb/L0SRrltxCHnybKe1/IarUFe+3cjJm701pQmAWthODCNHJdoC0i1LgF3Pv+uLHSGIBMb5ecA7lhiJacQuv2YUdLM035xVoEsx289b491Jf3G3BLck+YL/KhevoJ4uJBPZvC3JNBgFDecqHOJ9iDJjodfe9ESg5q5N/PSjukuT9WZG9wFi66Zkw57MHQ1T1GD7DLst755Hc5vN+OAqkflnx7KL2tPqNC3giLIiiijDDa6FIk6PknbSD2WYNW+rQZB0n7DRHN068JutkEFTRTHf0YAoqtUxuw0YMvqig1DBPFbviURCt6UyM6t6AVXTyQBMD1hk4EUeh694dF8f3lgx1+SqEMGPuT/yTNmTtAV/hU8zZ+K4sJAVR1XScqJH4CuPZYEP6pBnWwPBJ9zd1Z1cnI7whrxRUgwVwHleKKeepCCzQx2/6Nk7S2VuGZ42YuPccgHMypuXDKKsWyvfnaWdyyYsHXF2PjVXaNdt8Ok0BYM21tD5yUFj7LVXkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(316002)(7116003)(5660300002)(6916009)(54906003)(6512007)(186003)(52116002)(26005)(6666004)(36916002)(6506007)(6486002)(4744005)(3480700007)(38100700002)(66556008)(66476007)(38350700002)(66946007)(8676002)(4326008)(508600001)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ci8UlkMXDvf3VBvNIIuOq6mK1R5dOL7/I/QDbx8T7iJmC4LrytkTZbelhx5S?=
 =?us-ascii?Q?KR8eIAM6rZg8Xqrecp7LRDtJbhOK/TD15s6ossjV0ftPUQpXMiSFn/jPv+b6?=
 =?us-ascii?Q?GK2i3p8oZxAVA6qdgDsDP1QYKSOjDlQP5MYUU4J6y1TcYitEKDepdYEd2ub8?=
 =?us-ascii?Q?njgMxIlzKCqEZ5RgqvBvAeTuMqoTrJPcxjrtaDvK040KJ12hTbfeAabiW1U2?=
 =?us-ascii?Q?cmGBNe/EZRHUtDYM6WUZZQ9/2BvmBVKd3Mc0I5kYNU8v9Ovitdz9Y/Ha/KCv?=
 =?us-ascii?Q?weqcHy5dfrNt4LtYQ7QLJMk5KNPU4K60FYEIg5lTOJUhPRztj1WqW4YDe4jH?=
 =?us-ascii?Q?CKqOC4nIq1nO5QwuyD1TrTP7enSmN9chuI720U3XzZDjXiNGYCkED0hGXTLu?=
 =?us-ascii?Q?e0EgcE5kjETrEqvOTdpeL3gZBbj4GZD8p5Q7pbeUogjrS9mBgA9ohtPq3yh7?=
 =?us-ascii?Q?K4hwwClpxjOuWXDMSQd2d1Ct6L+NcHX3PDvF9o4vifyPbKX1dGQ5q1viMcgW?=
 =?us-ascii?Q?vLGOnUuhNy8QQAGIjXiF4+1VY+fsolx+Bc8lLDP5aH/NUSshZCUfM9AP+tlP?=
 =?us-ascii?Q?ZnAHhoCjAD2+SCvy2gzCmjjk3yiJW/8FuwZi/xatALZXcVi2aUvO51NLe1e3?=
 =?us-ascii?Q?/tsdgA58Lqtc3wj25vX2YPdwlIWCyx3zbOoBDybv7BaYFsexZWlrfmbMWwF9?=
 =?us-ascii?Q?THvgofEi+NC5pDR/hi2NkJ+6X5NbyrmgGvmnC7LBkFxQ7bW0e0VMdG0FVZuP?=
 =?us-ascii?Q?mnee3gZByzTMJ8rkZbiBFfj9YAUlimwBZiRbCnqcLWq7/Rgq2NL7R7k2gv3K?=
 =?us-ascii?Q?Fs+MeN3/lBm4amjf+ZB3mm6Py83jk/oqs0lHmkvldwRiu7Wwu9uHv48AyQdy?=
 =?us-ascii?Q?i7Gi/NLeli6sLXPlNuEX12uWwyQONMTtUWM/Kcoj/psP6E7Y0Lqv0ouJ31+Q?=
 =?us-ascii?Q?CLG2K4exmrVbyHKbMPYqVafSwLO0jjLH66IDpl9PDHAiQepQQ00y286MF2QE?=
 =?us-ascii?Q?OFmTAtwaDfTfOviBQ5itKlzKxuInUTmO7AG8L9R++n3GdNsKBvbqC2SoEqcJ?=
 =?us-ascii?Q?hmO0Yb3TcgoWHryHL2c60xJHeWtczzudfgol3ZODSy8i7g1cMoprb6NAulWT?=
 =?us-ascii?Q?HMlys6JHO7rasuR1aXyWmQlSZRiMF6H94jqI/Feztl5MdxoAWwk9fkXDCal2?=
 =?us-ascii?Q?I8LR0mpxyuUdJopYNIrRa06+wfaKyx6NgzPKet5cbzDOWror3olUmWR6Kkda?=
 =?us-ascii?Q?pNQuZJEnscUMGtdAxGJ0ovyR7EioyMs0lakll8Hr0bwgLU7CgcWUkjL+YwnM?=
 =?us-ascii?Q?jgSGf0sBSqzj3cdoCsGsFU5U0d8VQEOPyGns0cH5F3MUCfcqHhBLpTd4EChw?=
 =?us-ascii?Q?h8BSAy+bkVNjBOeP/pCDWoeoDJ+cpXbRO7mQVftv73sM18kDcsNo8FUb/FND?=
 =?us-ascii?Q?ODH+G6mvRr1GNpENRs9LGfLanVyH09/OV/Yb7moojm2STKk/drW8L5h+iVxo?=
 =?us-ascii?Q?DyVKeLrgs64q7ZfCmrPDfBIsYkB1+J/Kvt/gluAizJ2FdUmT/oZEQ4hQYgl6?=
 =?us-ascii?Q?0DFTt+PaArqA+YRmv1zYqF2xX552/srYmymxcfYbxY3ME92MjvwPinY8boKe?=
 =?us-ascii?Q?WSi9nxieMw3JgX8dICjmPdsdnt3u1LofKD9FLbbiB+a7R/AfH3zDE1xIIYP2?=
 =?us-ascii?Q?78Hmkw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852f62d2-0f6c-4f6c-56e8-08d9fd8ebb54
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 03:26:12.1091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4Ng4YpJfI7FR4Nzm1lOg5hn2aVF833psqv5J18q4RtmoPrsMeX+umXiiPUWH5uqbeMUV5TbQId8ggkC+yLBbCSZrutY9x0wpAbtMSmrYak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4152
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040013
X-Proofpoint-GUID: kREEy5-kunZE1SJDcwqNvm9XsoICs1OA
X-Proofpoint-ORIG-GUID: kREEy5-kunZE1SJDcwqNvm9XsoICs1OA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

> I believe Seagate never supported version descriptors. Hitachi/WD
> used to support them. But I have a WD SAS disk manufactured last
> month and it has no version descriptors.

I only have a couple of SAS disk drives in the lab that implement them
but almost all of my SAS SSDs feature version descriptors. As do, much
to my surprise, many USB devices.

The rationale behind adding the descriptor check is that it proved to be
a surprisingly good heuristic for "modern UAS device which handles unmap
and other fancy things correctly".

-- 
Martin K. Petersen	Oracle Linux Engineering
