Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29CCC25B08
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 03:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbiHWDfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 23:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240119AbiHWDfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 23:35:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D406B5AC55
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 20:35:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MNx5Ag029415;
        Tue, 23 Aug 2022 03:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=0f82bc1Ubwc1loQ+fYjtPiwUls2ecYXyR/3XJhfM78E=;
 b=BL4mS4BOeT5mKt7xj/r8ULCz1J/SxBkIRu/cNwAPkxrOFmPHjKz0lhXliaR/El/1QU/V
 bnpMJ+Ug7YNtuBmVSYUJBKDOlPyIQBAOyW5/4d6tysxl2VxBNC++xHQu4XkBDFnHf4x2
 uzzIU1AfRtzXkByg1D2PxWHTCdokYP8OgT3W+O1G9CKOp/CCALTH0dbpvIEzWKTv8A7h
 B+lStyeRAEM9bLhMIHFaEfPMUKEvDullQBeBse5/My0l6wYsLiRHPhq1d9MDuVkkI/Hi
 oKX8n0jtxAViZ+rhdUYz9uVHLP949QnPOxfu7T+JQP9/GHS1lj0ASGwWUHLW0Axqd91s /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4e8c10w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:35:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27N0tDbv035336;
        Tue, 23 Aug 2022 03:35:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mq2de6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 03:35:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+6tEcmsIgpSvWsr+oftXJl564PyOMJXlJkePIXLq/7CF221slFSz2nIpzfxylD1cpd6Jf8mwE15q4aOiyJB8ZQWL4saW05OZHYaWEC5GJUjuaObFhITiX4jD36DqYlCjUqwUtAny6JqZ9I5M3ToImp2bwhETRcqJL1TQvc09KiKnJ2pfxgvUWvWhhSkpxlG0skl1qKge6S17m6IMk71akqfMPr4rOE5Q+BqAI4q4r8uSqM/4CTRgnmnY9tUPKcJpw4EK2/xJPaPE3nb56/1U2nc60yBpFPDiBPZLx0h1xP7IyZp6QTxgtIXJ+Jz5Wno7ZKYY4Z8VUdNZ6wtRRiYiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0f82bc1Ubwc1loQ+fYjtPiwUls2ecYXyR/3XJhfM78E=;
 b=K5vI9Nh4p9KKLLNpgKWOniuNfJaSXWQme/H/swDO9/Rq2Ym38cwg2D3ToTTd0a/H23AmrBmeRRtjjHBxgDutYihgdKZ0WiyDUNcy219/zfS5ACl9Ln1eWKtr0EUb38fO/yhLtgx8zO+XhyTFChYOS2ndtkP3LRS2kYGiHCqDLQPYvNUdmx19T3W+cyC/3DDXCyW6dNBLHHMdx+W/DSrHF+fkUOXPK/NWE+0z3OsqL/6jFVLcNABN3GPCxGpoZG48N7nFMWe68c4DKF2SujQDGklNwsdlLZj92k3ePv7vKPa0oIRnnuix/Q3KqN1q/xp8Qh/FK8QGkubDCUkfuhXuZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0f82bc1Ubwc1loQ+fYjtPiwUls2ecYXyR/3XJhfM78E=;
 b=tMx8JovJn8f5WNgI4/ueTnpyDt4A9iBQ1iGPTR04bMKKVanTYJcVMD9a+kapii6I+YuuBE2bDD6E+f58bQ/iQIxjkZB8KdfmVGfroguGb3kjLzpAXw3Zkp89nz1+nK8U9kdLYkSg8B7ocJLpMNntwIk6udfq2tiBxb/9xXlHV38=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4481.namprd10.prod.outlook.com (2603:10b6:303:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 03:35:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 03:35:36 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH v2 00/15] mpi3mr: Added Support for SAS Transport
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu63aazw.fsf@ca-mkp.ca.oracle.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 22 Aug 2022 23:35:33 -0400
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 4 Aug 2022 18:42:11 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f3c46bd-3d9d-403d-d259-08da84b88a59
X-MS-TrafficTypeDiagnostic: CO1PR10MB4481:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCFkpY9PpxoE//65qXgoHc8F9JAKCyRAntW9MiT2QJpYpR7BMLb3u7QfcaX6/l/zp0T9o4LqvpA9V3qUQsW/6Z3lSeROGDrBZdaqVbVBW14coHtrV0/rsJz93B3sC7/HXTFYxnORmurzwEyqGd6UNaWWbgGKkqcKD0FnlFHsujZN3p4inbo7Fl4KwpULhP989pDe1sJM4hOykKHvdJBPBB7nfsVfsN614ZKxuod8QKPIs5zDHS0EDwD6fBNUnoz4hmx46e61YJxwSfTCvHAAYCepR8Z51NJYy7h80W5tcsgcXd2dzjgF9LQGHlAauhC52v5nD6J3rpqWNCt+CPsCCTuRVYRFlBmgBWnf2seBAhhIKmyepysmxa8L7D/YKZ2NDo9xI2HLAEzfIDRpvMuW17LhX6YnIbufcbW5/WORYCDOicWB0Uj+jqekQufmGRBRK8X2Egpz5arVknh0iS0X4YCWTBdnihooLhP/gbVYkWxV38vYq4LaPSFGAJ026ixLh4ZNwes+7hyr40TC70przes6vMwnav9AnDQOlqPemYRUlRDI/86KHwT+AuIC1SEb92OJGqDfZWe8iLUaupN1SuwJTrPsyJEluCOV2RgvcK679xjTyYVzdLsKPbNRUgOXAQAQ8cOyfbBB6B7BsfwwSyRQtiqxX9ECtHpS9CHqdrEbJULGddhiwZSmlKqZldwO6np1wH1zVjnu+Fw+ltz5G6iJ9MSzA9SMh18F62sGj1uX2UyjfV+WpvlqaQasGIwTfwq9hLMj61WTwKDwT3wt5wW5Cf4R0xCoEzQlkXIAFcM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(366004)(39860400002)(346002)(66556008)(66476007)(4326008)(8676002)(66946007)(38100700002)(4744005)(86362001)(6916009)(38350700002)(52116002)(186003)(6512007)(8936002)(26005)(41300700001)(6486002)(6506007)(107886003)(36916002)(478600001)(6666004)(316002)(2906002)(83380400001)(5660300002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l9InEMRLnCEzj9aYCCJaGm7x6Jw4X8WNqLQSw42UNz2YRETKShGOBs0qvyqj?=
 =?us-ascii?Q?X5X7efUGjzsAwJEgr6Msnh0eHd9qVZSwqGpKS76jVrsOwDjhwt9uOM/Oqxsk?=
 =?us-ascii?Q?DaIwb6hCwt4+cwYDdUfSB3CBn5gHw6P2zu/59ZDJ9rkAMwKghorcRKEbw6OW?=
 =?us-ascii?Q?lQVJ6k7oP/vQ9dcU5JXx2VZkbanfuCcWMfaC08dR8mXoC/bN+0Ic/OD3zppy?=
 =?us-ascii?Q?TvP38nEQsDS0bLwCuPDBFZRrGvzJ2ZMu8uE3Qxkw61Kd6itQZSvzphxC/lBF?=
 =?us-ascii?Q?P+YqBYViqPWM45WVacJX8rZATbaueFqwrknjX4bKut+sD8nzuWRF+J01fP1w?=
 =?us-ascii?Q?2TWSgzl2xzhyQRER+dRKXkLdbjgtbEpuwHFQi0Bzm120w4W4fslZh99zooK6?=
 =?us-ascii?Q?xLPLccCqCBl3gh4Aye/WMSD3MCs5iwCvpN730zuMC8pXvjtoSsFk1DZuuI01?=
 =?us-ascii?Q?ObLPseulOrIW6q+HSDyKNcxsjT65WL75yOT2qD3UJiAynePdKkHJafj/tzZN?=
 =?us-ascii?Q?yGgPhRBG725RJrUPcqgnMFFH+brwwDanVw7FZFAyX3fKlc2F/rQMf/r39VDF?=
 =?us-ascii?Q?N5cLYATEVBVwgOcpn+grrfA4Vug44sOQiI64GBngZAshrM1gCdDhe7vLNMKv?=
 =?us-ascii?Q?1FjOgJAQ6u1+dbwCdE/b9eAajaSJ5jecafcLvzjmvTfCGiGbVvbmI2lIiOeE?=
 =?us-ascii?Q?t0Twq9if4Gog9avEL0Sj9VvQSpVCKh+zdA5OgkCJ7fCyEnZz+rZGEBM8blun?=
 =?us-ascii?Q?prD3ZrmJLJyiztenhDecLJCU+2ihfQgXqRO2en8fYrqclkyuPg0EOmRrSEVo?=
 =?us-ascii?Q?khSASRGF96jb2lMpy9HIacxgnrRTpb1j8s9cNj+yK/apS3ZFTwMYZD5LtTOY?=
 =?us-ascii?Q?6DVc3XunuocZW6vEtbcpNi63flZl0hrs+0/gtYmR823Yypdg2ttVJJiLdZ23?=
 =?us-ascii?Q?AOfxzzAq0juj8++uz9yBhDLQIbUD2BIePfY8+O7dE4w8RLoo0sbshUT+xF2c?=
 =?us-ascii?Q?aoki/WaWKFApKuAu6eS7ZN9teJflBpc6q2A5RG8DEJScSbjUm5d8K064kxlL?=
 =?us-ascii?Q?RJ4mnzXnw3aYdLYSrnDt7chCGvgfaJGZ0DUb3Pjtg3z9H2Q4Cae3MFN3NVNX?=
 =?us-ascii?Q?tPI/9X2UxnVHaa4NHxKvYRqvCtOVPYfCeHevFcS0os9sgBItnlqLA4whKksG?=
 =?us-ascii?Q?u94GjmRtpzNB0cEy/olGcIcZWztpPEAUjwnq6I/eJFQlnHrY6A9FPCoYh+Sy?=
 =?us-ascii?Q?3AIGy+H+d8VOhVA56nL95DX1Co18IDb0p/PCJ0yUoPwd0+e+WAAOCUW24O2/?=
 =?us-ascii?Q?3RpHU/Ze3qiUeII4/b592CZZE6j+tDPnYOtw+tQuyEuM2e3X7DSILk6Go2wE?=
 =?us-ascii?Q?vd74s2q9FcofaSfiroUV5QbAX9qlhSM0VRn5ejU/bluOe0DRQcLbVbn3GdAB?=
 =?us-ascii?Q?6+8Az3SlmVxogLAj9p7yuXrObVj1cdnplSyd4FoGZyZUdElfWeLEWhQdcLan?=
 =?us-ascii?Q?1BsiW//cbk9kY57zja3pwU68FpGqqgxW671ALLF6yVWOnl+OdvalGbYdcXUw?=
 =?us-ascii?Q?4HDTszeWBF4lMJOBZgYwnu/0BzQEVxKLZQsq6WTHIIFeslxIBavSFdRZ4tSU?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3c46bd-3d9d-403d-d259-08da84b88a59
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 03:35:36.1336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aB/JvcAJa69x3WIijOJx5sLDV1+65IOVvaHl5wjjGQA6sHbJhfGqHIJk8zqBlnhbeTHAnIt6Jp/b55Z2skpi7nBE7T1OShtms4Z+mSVxpn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_16,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=919 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230012
X-Proofpoint-GUID: TIVPgdOhsv4ii-NMrXy14HVxnPk6knxx
X-Proofpoint-ORIG-GUID: TIVPgdOhsv4ii-NMrXy14HVxnPk6knxx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Sreekanth Reddy (15):
>   mpi3mr: Add config and transport related debug flags
>   mpi3mr: Add framework to issue cnfg requests
>   mpi3mr: Added helper functions to retrieve cnfg pages
>   mpi3mr: Enable Enclosure device add event
>   mpi3mr: Add framework to add phys to STL
>   mpi3mr: Add helper functions to retrieve device objects
>   mpi3mr: Add helper functions to manage device's port
>   mpi3mr: Enable STL on HBAs where multipath is disabled
>   mpi3mr: Add expander devices to STL
>   mpi3mr: Get target object based on rphy
>   mpi3mr: Add SAS SATA end devices to STL
>   mpi3mr: Add framework to issue MPT transport cmds
>   mpi3mr: Support sas transport class callbacks
>   mpi3mr: Refresh sas ports during soft reset
>   mpi3mr: Block IOs while refreshing target dev objects

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
