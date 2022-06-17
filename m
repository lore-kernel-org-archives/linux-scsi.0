Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3EFC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 02:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiFQCLj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiFQCLh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 22:11:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABC664BEB
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 19:11:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0SUG9009843;
        Fri, 17 Jun 2022 02:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qQQnK5K9G1sSol5QePAYU+oni+SrC8aEaCM6mNobILE=;
 b=BywroCTXAjyWMov7Fn5/YDnMf3f4jW6mLrIWJNbfe3MoJNHmiHqn+DzWX7Tm/BSRr+/f
 Xc/PflWVcgTdp1M9vcN91sxeLxK3cvxH/GSgSrQM8phKNtBi8pdW2rE+NDblTuEaNffm
 6FneEiQbb/NN88AqKQN5i8y6cuxDEq3btgMO9+5pq3TPp5pDkCsvm+Rmo1jnAv6ur8UX
 cAN/dMS2/RguaPYglbIZLBM7NS4RPEZ0OOOc+ZkRhp3EPsVzU+KuGMN8VKoY8nf7p4eB
 7WD+FUmk6ozER3uBwS7abf7PMztSDrA5tPQsAii94PSruWLn0s5sPbtiq9pRCa2c/znr 5w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktmrm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:11:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H25rUq010143;
        Fri, 17 Jun 2022 02:11:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwcpdev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:11:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjLK8kgr1rwFThlkvEeNqpJIqlsP4f7FLzMfe3SUKHXQ9vXv7ffGKUhr3PsFpOCAT6fGYKkw1UTF1xPHHTfsEs0tWU4skprG2tQX22bfnazlXb2Q2fGEsvdl+dWyOR7CEOKCGeqXcXnBfTSdnih86TLOxEDM0Cyd+6ZXNasvIOPcL6CaHXuAKEPxqTuaIc75Z90xdIUWA+FGsE8qlxXz60haLuyI9vM4gGKrVqsklptc5bus/tIRXz9WHI1sUwnmQFgtbmTLBdppgmJKNR9Xr0oziKO5UkIdvwin+CVez0Y0BCBD4QHrPqIVQX0epWZQbtWUUU5HebdK1L9PsZCB3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQQnK5K9G1sSol5QePAYU+oni+SrC8aEaCM6mNobILE=;
 b=CUuQDv50ueXpqWMqkE5isrKpQYy1UB1LOv28wMITgpaalm9+q8Geww7BXdkMMmGlyzzVqhkqjrzR3UYMKdSxmo48/Ey35DqRtxXxWuRT3N8Wdg5870PqQIhuHPgJHF0qjO0mDU6Gos15+rUcEe3sqsrAe31FJFXG8TY+OGFA+2HzBffJnXN+7V41jig4Ub8jzHtwYrqDlJs7bmnI5YwFWbUBan8zbt1SwrLGmdR/DtIKjo4I25xXOPgSnefvV+8G3usXHXrqSKKAdIjhLRfdNJ15Y7VX/woyN50R3kCBAcBrTGfvj1fkZY2niUgQzFkRhmGQC7hEA+sXWRxDP0e6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQQnK5K9G1sSol5QePAYU+oni+SrC8aEaCM6mNobILE=;
 b=uqIkhkmfH0wjoMW1foTBiK+cbjQgCkzb/k06tm/cYfuwaTso6bCQT9wD9d3L7GQ5ZrrNogNFY83TTrdk8Hjk1bVf8IqsWNLjbbYM+QvkQvAT8qxyVRGUY842hsevD80+ZNoYv6oZ9wC06E/xHfaIYtkwRUx41QQVIP1kNJB/8yg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3580.namprd10.prod.outlook.com (2603:10b6:5:156::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Fri, 17 Jun
 2022 02:11:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 02:11:29 +0000
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <michael.christie@oracle.com>
Subject: Re: [PATCH 1/1] scsi: iscsi: Make iscsi_unregister_transport()
 return void
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1letwninq.fsf@ca-mkp.ca.oracle.com>
References: <20220616080210.18531-1-mgurtovoy@nvidia.com>
Date:   Thu, 16 Jun 2022 22:11:27 -0400
In-Reply-To: <20220616080210.18531-1-mgurtovoy@nvidia.com> (Max Gurtovoy's
        message of "Thu, 16 Jun 2022 11:02:10 +0300")
Content-Type: text/plain
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16dff165-92bf-478d-d052-08da5006b0fa
X-MS-TrafficTypeDiagnostic: DM6PR10MB3580:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3580D3E74BFFA8B51B2113558EAF9@DM6PR10MB3580.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aFcJ9YRXq65RaICafyry2Q/vU2TAh9bE5+YMX5zvRPxmULDsRrEeNJQOcqxgLF158uyUy+bIjTyr71tV8109wxHgDB/dfhPJLHjvEE5ae8ZMZQ/pMK8z6pVVU7WQO2y8ZBFMVVOyyI9v+t6MOgYbX7qrfDLtipspFsjsJ4hkMR9cOoHDjoX5oYCu7X3jaH/U7PESu1O54uKswYSyEqy8+fdz2wJ590Zyuw9DMCd9BQT7K+wK4sGX9zpplFD3f768c3ACP+XzE/1EFsIeH4oQbg8iHiVme5HCQtM/9qNJb3BWmumIv52nhGpIeK0OtDJ5DQEkDelZxG0ogi+AhibL4rIn0QbJXQ1oGm18A2NLm0hOPXsZII+uFjABPs7HfdCuLmp8qgX11c5/HMB8IsWTWGayJdy0goTtMcGYAfr7QVsIxu/MaYuUgh+CI2TuJBb3crrQqaeuweZCp6OerAfRE/bZXM59sqFGoxKH12/14sUlXLWHh+UtVFqS5kzHhpeSpWQ4iiXvuiP8inTp3DffMRs8cTI4I28po+UO3tseztr4WZFRDqSKiEj0OlvFRb593XOuSTohxtuM/Q7WxLTFKmal6Xsiat7z2QkKttWYzoJnOExm8px2icy1qSomYsqItakkwIfckw0LDjRrC8RhbJILKaxNNpGY6tXaxepe1xuGBq73tZ+wY7jBsukaboBY4Kv5kqNxklW40BvRRPYRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(316002)(86362001)(558084003)(66556008)(66476007)(107886003)(5660300002)(38100700002)(8936002)(38350700002)(498600001)(186003)(4326008)(8676002)(6486002)(6512007)(6506007)(36916002)(52116002)(26005)(66946007)(54906003)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mB7gzJgGxmKDbPkC6OJ8mP/AheYhez+u+1V414bjm1RGNyQtNn3pFFFFY7Kw?=
 =?us-ascii?Q?5IXgV/YDH438GXkFZFVaELDbD6RJk4XYlTLGVBkXiBmv1XqW2ym7FFP3L6RU?=
 =?us-ascii?Q?qmy7w8HAvhmCk6BRtYamIue2neLwqsL+yQJPME77F3JdgNzAEnbVgbiWRaJ3?=
 =?us-ascii?Q?nOYTsMCjSvWFaGECTinsuK03xmqpk2g6D/LlyE0ekFoLHKlsPFiMUfQWkljm?=
 =?us-ascii?Q?5I8gvZSprzc2dcSKdjTtNyzeiQP7OOOevoWaxFSWCZHCWiWs7y6lGiQ2rZu/?=
 =?us-ascii?Q?A81HGN7V131XCEqprJkEj9QZE+emUIJ3R3kGmAh4oFb39lJdRkmu4aOzdLHL?=
 =?us-ascii?Q?4jW3IB9JEhW2cUgSEGnucfXg6jtArkJBKXiT/w8ZLfMLMs92uyQMn+HIhLKp?=
 =?us-ascii?Q?6YYqx9vTRAgvIcryYStAhf9DrkdM4wWTevUFyk69DzTMi+uR5TGnnhOGRMo5?=
 =?us-ascii?Q?aacV+g3p6zz0f5a0mnMbj4ih8xuvjeN7Q3adgAV9YdE4qLQ65PToyN+x0GhG?=
 =?us-ascii?Q?qasGsZo6DYDMSBzNXVpEvMLajSjCc4UcclkjKyTCjEjQDnV89jzP9toMOu8x?=
 =?us-ascii?Q?DMuofZ2Y7W2N4E5Omi2cpcrW3DHiVAUHlxN5ko4vY1lI3Ds1HD9QMyRPjFzg?=
 =?us-ascii?Q?kaPGS9OFL4Wa0NURz+wG2EiTsA0W0MXk4Y8/3O92Ybs3dYS+yWA7Ol1TkMq3?=
 =?us-ascii?Q?8jMJ+Cyx67e2Ue8tG0b0nvQ402w8zbbBxQx29gHeg12cfZDciTI/wXwf4Vk0?=
 =?us-ascii?Q?BhKGaHaxVpICcO+2Pfcff8xrkk0eDxIMJsOQbOJcqiXHmin/bEBOy6KUmjU3?=
 =?us-ascii?Q?JAxwhpDFbsRe0LY1NTgdFQXhhJw4xVyPvpz/BM3/ul4DW2JS7uTx5J9cZY6p?=
 =?us-ascii?Q?HclQVwUnpyF96TiWHS5YCfr27yJDj4LyfRKAlReNhNNF9LftRZxs3w+mc8b+?=
 =?us-ascii?Q?CRahYqIsUiRONfBNsesWu1S7P/ohTqA51Rjak7s9ir0i/VffiMwXAFQOD0H7?=
 =?us-ascii?Q?YM8NPflhKj+jf6ANAIQ+c04mavV26OUQLxJ1+kwyRr8b17Ma0TLbn73/qZl9?=
 =?us-ascii?Q?e++bNn8b6gBot+8+pM1Mbot8E866aiLF8avLNHzR2z8uv8EwOdvZTohiIokj?=
 =?us-ascii?Q?CcY8SXWn0O1DOBdeFq2XzfGfsPf9bm7bBZOKdSF75NjT1QlAhJxIW1WNEidO?=
 =?us-ascii?Q?6g/Npz8MoHXfiUD6WXDXkxFZkKt/RpdUNV1+tNzUE/qNDY/UbqDVvLZQWFqx?=
 =?us-ascii?Q?7UiZknO6OHpukLilrOsBifbOqQZsV1jGnO5x5eiks3nOfwvFnZMg65h/c8g3?=
 =?us-ascii?Q?USQTvDZbsWl6+FqT6tQndMaTX/nUwwUUyyyMSvgnNEQliuqDW5z6AnW0jlLE?=
 =?us-ascii?Q?kJXllkaM0Y2cB8UsIZPtP7BijMvcdvX6Eo0Ojrp32dhf9OjA7uONXdAZk8w8?=
 =?us-ascii?Q?lD4078nfo5AMq68KfTJxVlPBHIFrdFIWPqzuoYLtcs4N3rvCQ1WpvjlnTiVl?=
 =?us-ascii?Q?DPub4Dqx6VIrxI8fHiXsmhoWuS4UnNHcDAicrw9Ufck2lMnXMaZac1Nzg0xI?=
 =?us-ascii?Q?cl1evb5d3yegDPCzS9E13WosJzuTm6ipSeS8cD1IisszfuMlj2X3JR3xGd8u?=
 =?us-ascii?Q?iWemIR9IHcJmewkBRkF64Vh1EnDk10UdyKwedzC7XR/KCWQjqW+wg+zTI6u+?=
 =?us-ascii?Q?cv+h1pP3YnoLRcw09RK1EJyJCDWHW72dODzhjZsioXyB9T1L55AlRxS6/C9m?=
 =?us-ascii?Q?x4w+TF8xmi2Y/ZW1T33PtSmx3fUtYzQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16dff165-92bf-478d-d052-08da5006b0fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 02:11:29.7005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VM1D5dVArXuiEp0MHTVFeJi5qRm6lXKuRD2Lv70pL/bC1ZrNWNEi4UXEVgGwc3K2TCwusx/SrPot4X3tohahLlAlEBO5bKGG5zkmNitvox8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3580
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_01:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=827 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170008
X-Proofpoint-GUID: ymr55UzJ3LODKcQiTkQWfnjE7UUMTrGL
X-Proofpoint-ORIG-GUID: ymr55UzJ3LODKcQiTkQWfnjE7UUMTrGL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Max,

> This function always returns 0. We can make it return void to simplify
> the code. Also, no caller ever checks the return value of this function.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
