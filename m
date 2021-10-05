Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D83C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CFE61462
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhJEDWr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:22:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13348 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJEDWr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:22:47 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19538vR4010243;
        Tue, 5 Oct 2021 03:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6i4rwOWrDF2O4ut6t9v+KGzhc3NoxIPaQldLzNmPmK4=;
 b=z1J1v6cQhsIYcu21MkDKHcy5Jn8LLO2dGwe0ugYLR6YdhaS4xn0mCP5X4D92xLkuftEW
 rnUezA10uU3LVCHOrtoRSRf0upywIf5AO/vcw9kT7CpqesdeNtKswqtrIazcj3SqqZMz
 1d5n4ox/mrGeeUQCd+o33fBvTXie5GnPRXeLa5PRwzMKvb5GsMzCTJzAKEnCptR5HIhw
 K9cexdRQC8ifLEN3FaLtCVeTIyUpwVRN9c+o/DCXxk6m6KmfF9J4yrXVP3N6Aj+1npqN
 AxE8eYF3rUkG20xwdj4/SVpnLVm2hqlNzssEZQHDKkacRnMhH+JLjxhgF9Nb/WwSccmi YQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3upvg01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:20:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1953KeWn078501;
        Tue, 5 Oct 2021 03:20:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bf0s5tsm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 03:20:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9qy6xWTWtpDTyJX7H0H8qvSi97ZMew+t1Dt9LWdJGV329d/pK71p4sM7CXGkLe3xGg0ECkULTU6WWkRwMCm+xfp8EoeOB/rutr5aGM2a15ayd12crTYJf1Ro2X9mdrmUcXk8GkRVRxw6sfAD5++Em7t66PILVujogHl5cfe+Cdz/W8ld3wTUwlThysPnfYkTi4S3WeKeTV8nI19mSGwIwXETdQNPM0ElJRff5KcdmYxOSOqwDlpmh392yMq3Jkz32V4y1Qpb5YHHi4KyonveJDf5g1gWcT55HaqPnjQsRcg22hji8FOvdVp6+kgtTduSdGvDGWBQRgA06a8/Mp/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6i4rwOWrDF2O4ut6t9v+KGzhc3NoxIPaQldLzNmPmK4=;
 b=DOfZdWIA05bbOxZN9hhnlHhA9VLJwOfr3hPci0QaOH+Z51iyhy2Xf/C6/I1R4toNZogIsvz/XSeMMzGBydiQ1Sv3ingx3qLNH9f2YwNBo6JoOzVi4ygfPtygwKAejLS6rEpWgxPwLRd+LhajAVojli1LxQrpunmzgyHfY6+gN0d/gdoN0bMYSsNv8biCMYYlCMVio86WPWlEKv7IetiVSviDVnUBxxnz5cqFAVVHMnChKoj0l507EZlVI0Pys39wOPN+sHHcI5z3ryMhPOIVinqj3guPMQogsAkYY7kCA3ZFI5TeiR3ol8eO0VZGiYrWX1CgxFJT48JE+s5LPD8Diw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6i4rwOWrDF2O4ut6t9v+KGzhc3NoxIPaQldLzNmPmK4=;
 b=QG0/sQO5pWGwyxqSHOqtX73/BWXhUt/VfgMCedN7ZZzAEQyd9X5p2Ve279sxoIBwZXa8O8AwoWd4YiTu4CgVx4Q9fSE5HmM5OCEtwxBrXQ6yN5Tuv6SkfYrtawpOiZ3QQiN10SOZ0i1ZgWj2sCki3Pcv0dqd6dwDgDFSrcIotaU=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5403.namprd10.prod.outlook.com (2603:10b6:510:e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 03:20:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 03:20:51 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, chandrakanth.patil@broadcom.com,
        kashyap.desai@broadcom.com
Subject: Re: [PATCH 0/3] megaraid_sas: Driver version update to
 07.719.03.00-rc1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k9w88dw.fsf@ca-mkp.ca.oracle.com>
References: <20210929124022.24605-1-sumit.saxena@broadcom.com>
Date:   Mon, 04 Oct 2021 23:20:49 -0400
In-Reply-To: <20210929124022.24605-1-sumit.saxena@broadcom.com> (Sumit
        Saxena's message of "Wed, 29 Sep 2021 18:10:19 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0040.namprd16.prod.outlook.com
 (2603:10b6:805:ca::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by SN6PR16CA0040.namprd16.prod.outlook.com (2603:10b6:805:ca::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 5 Oct 2021 03:20:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77706de5-0074-40d6-673c-08d987af2268
X-MS-TrafficTypeDiagnostic: PH0PR10MB5403:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54031E9F894003720CFF4B188EAF9@PH0PR10MB5403.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRUnkAMPnRxFJevB25JrGeROrwXNtBkabYC/OXxDwNbKeXhNwxSZmzPrfANMnaPQDfmPP6r8irr/WS5x+uFWowk+Zt2j/hZIKEjizte144JJNn4N1kn7UbiDJ70iiq46jmW3iEStmZF1F0jwEupmE1NzntVjwBP32+7MGtk4Zmmm70ER/DQPRzR/M8Dy7/NADS7HF9JNvTzDWmg2OXXBWe7sCCMoE7oUS5cMudPNh434GXTGkUOMLfoP2oMbYCmC+5nXVSfEd7f3oFjmXLyCinctL23qm2OPGn+h29byCTOrfJrh/SSaXU9hfmKp0OFJcFrMf4vImDUOXkk8XTSwYZxrWCGBUjXcbsWiW4m/K4hIOwXTGsEjViAbra6yO0BiO57m7GBZby1myT+JxZo39Bg9kTwzredDSG6oTe1SZDbikqXu9XAGyEH2+dp+rXTKroyoIV02nrrCLWR7KKop3r0lOH8YWMNmCkrPMb+z2WRpygug1N5w0mEQUy4j9LNL686f/NP5WspcyR8KU3BYrqpEuIGGIo0XHVBjAS/PQUoK3WquBNiQFAMxUOx0CagFFVIMacZC7vkuAdQ6EH/0L6ynPT22fqYsy5a/acwjKtaYqZhES7a82dcWjK2MACo9K6D3Ij8+PtGeIO4JjBAUoUZZ+O2jJ5sK3U/cpTdm5RukIeGaJFtviA1Bk/me/Jv8VrK6KU8IS1oOVNeTr4O/kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(52116002)(5660300002)(38100700002)(38350700002)(86362001)(8676002)(316002)(36916002)(66946007)(2906002)(66556008)(66476007)(186003)(558084003)(6916009)(508600001)(8936002)(956004)(26005)(4326008)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XsEc4DAuc7ScgzSq+Gg3OqpnG06wbKUOaxdub/fxTf6xPSiN+Xg3up5SeZ4V?=
 =?us-ascii?Q?z0oFImcUmtKZ4J4aWA8MO2rBG9maOjcyDiqG3s+Un9Eslh8ymzFW44VyN904?=
 =?us-ascii?Q?9O27hOT6OWlIJUawgxMCVCJ2JnLsTneeuElNKjBrKQctgZi2NEG0yNumkXWY?=
 =?us-ascii?Q?+XgtEIDd5X3rNtmNyxsRN0DkBXPsDb0t/fIaqkOCxIJPQBgi5kJxV7JQ1uPZ?=
 =?us-ascii?Q?/JtXHZ1ghXlAxsRG0i5gBWz38nSpNb0S4sXTfBgdaD6vBqwbStHG/VDd3kAT?=
 =?us-ascii?Q?wFMdkzQgRmHBJi3r3Dsy9oxEKHk7C7BXCdrUCTzuZsPhMskLY5SZhVumlSZc?=
 =?us-ascii?Q?wMnlm7NaYbPgZnorAWgXwi8O6xMPs4v2aKpJ7AY9ISEWroMgcDFgWxdjdU/X?=
 =?us-ascii?Q?Dtp8wBVtBsT/n/5qqi2pODmMVQAwAtP1WrCArlNdyL/hPimZ1J1riPt3z5Sf?=
 =?us-ascii?Q?nSJPVU+6wCqDVnVm9c9nH40PV1Iljj2d6DauPIgnXb9+VqP+DFXhvbVScv4v?=
 =?us-ascii?Q?9hjr1LYT96f/qJLzBQWB/NvFixaED1OpZtCGQgM/33IDP1n+ljiR5JRDKe93?=
 =?us-ascii?Q?EFHqzBDWuSt2cZMd5K3JLtoTMSW8w8D7BEHExSggsZ5F0fqHwT1ZpimbQ7xH?=
 =?us-ascii?Q?jGXKoogRC10G/1kNk1bYBn3f292BKzwWHd9o2YMOMEKX+2AGY4ZrMRbsIjee?=
 =?us-ascii?Q?iokR4sizJ8IPqAIYBbX3TOhZ47DUK8CpYWrdIiRXlG1eiIGMuWCXEHjuCdhn?=
 =?us-ascii?Q?xNecuyqX+asxUd2MhesU9TMgkG+mCQ0CqPFeG0M0JNZNc7QdE74S2rgEbik4?=
 =?us-ascii?Q?vaeymSRu1G11Al4DTCW0T3H4DJBgcVLABqO5D8RboceAcp45yq/6/FXGhD+Y?=
 =?us-ascii?Q?lepMNU60RQwHks+49ueuBJ4jCTxzxnLUfhjgAGbHFWWPy8cAqCDtVvXnJxJ8?=
 =?us-ascii?Q?+q+wNVSwVY5mHETLqRax7iLwyu/cZb8gbzJ8HCvZ4RwyoC/2lyCgxVLNUP9p?=
 =?us-ascii?Q?f2rfomC23vpvInZJWpU1KjKbfxnpOlEUwys7H3Cwh3y2n26bBqI3ZzupCZbQ?=
 =?us-ascii?Q?dym/7156s8FUAik+XRO6fK6UcFtdyNL7TezHCmQFY7TuGKGj+ogJTs64FFE4?=
 =?us-ascii?Q?aMnBB1CQL1LqLh1O5J8cr2xBDXZ6FGZ4AioC0jW5JGFpEcq0RoyDJHz9Aimw?=
 =?us-ascii?Q?ZK86eYaq8+ZUiFlsq4E8t3X3rKuGMplkMf8pJ1mm3UAn8ROFVxHYJOtRCQFY?=
 =?us-ascii?Q?yfV58QwQ7Xvhgvlo8VCBPd31b5l5m4qBzlRfWTKlLdNyF6XQ9hgDDJBHv760?=
 =?us-ascii?Q?hL+OITNnxhetTcm0yV/M4J9q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77706de5-0074-40d6-673c-08d987af2268
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 03:20:51.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spTu4HJvyctD1SwHz6dix00wVAVY9utv8ckl3FLVG6DiWU5EsNEic27FN3DMoRM9cSEMoWrvdbk/SJ1/btZbl74uvFEDCdDf1JVdQwG9rC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5403
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=842 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050017
X-Proofpoint-ORIG-GUID: EOk4HQzOAbrJRTa33BQ16TGbslsrluul
X-Proofpoint-GUID: EOk4HQzOAbrJRTa33BQ16TGbslsrluul
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> This patchset has a critical fix and added helper functions
> to improve code readbility in ISR.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
