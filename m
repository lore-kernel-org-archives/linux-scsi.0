Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF83C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D9460EBB
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhHJDsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:48:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34310 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234613AbhHJDsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:48:14 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3gcDb001996;
        Tue, 10 Aug 2021 03:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ZsSVrIgDNLZY/JgjZIlD4xLZDWg3uWy5Ixb66T/TQS8=;
 b=n9iUSlzog4I8Wl7giYlj00cag7Y4F2zH6BMzoBz8CtsmEM6knHOpKaZOUQ1Q0zBJknX3
 2bdFKqmFfJjTA6A+OY0th0WOlNc/yxZn0jwiDrtN3YMZs5/9C0NySGiug8SatS2POo27
 XEkO2RcCc4CPf/hZCBmWbbaRpdSXC1Pn9p4ZTy28byDaM3BRHvyITEZPL7zeA7JLxuQX
 LmM0AMc6rSTNo0sMmu73Xu0DSWQ3h7SAcW0pKAav45P0VNCCrK3/nxcq5EEUEq5n+TZb
 U/jzg7htRAZThd2vpYpgSYFEzWn9WPXmGqBe+mkKVLUuN2aT5YU231Xsxu4piqZDbG5a hg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZsSVrIgDNLZY/JgjZIlD4xLZDWg3uWy5Ixb66T/TQS8=;
 b=TVkq+BtbHPk01n42nPxB8lFN24Pz7WwtqzY/Vu5I6AcI8WTh2JukKh/AE63JC8ftUWSa
 A6S+sWzIfnIA3+8HqigiEYlsCuI30103OA9dOPE3Lc4T1L7GcR7F8AfcEG3HSSjTuIu0
 IDh9m+mYgMBYGxJ3mWPMGJDZ/h92C9WvZezopde3eBDZjS84afeoQoHGNypWNJo6kElj
 7fqqaiU9ZOoR8q7czveDZUhdDJ0jgTs16QJKQGEhHLTsWTM9sEDRZs0QGeYfjfPIKrmS
 2JD3L4mnPE643RID0bHbgyODVSHhprPihNu2xAFgSPz9GB/1fFbW3HNeyi4NjymI8VSn Dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaq8aaupy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:47:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3e7KO150120;
        Tue, 10 Aug 2021 03:47:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 3a9f9w4288-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:47:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZ2MtZZ3pzJf1VvLLG57qL//8rsT8uUS9JP/nCAvyVwYwPS3fZVh4uGnqJQxHqloIDXa0cjNHJafpP80TC+2QF5MwMV5S+FhQQa0V9cbMj9ShchUi3ABCIKTDOqHfyf9IPzdFZH8DFln1vXGvZsv0rtbKVIn6aq7v89kRtmQmvazcyLLued5sops/Bts8sdo0zyg4tM7JaUjHFUehPes4KL3nx0Rb/QoPMC0mHOOnKcsrK0ciT47UaFm/nkSBXBR2D5LupG28bMi5T02l3cmTSWOvJ4wWjvVB55zM+GWKNOqNrkgQfiCNX8uXL/iUQauXb2de1nX5vMFe2UB4tTTfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsSVrIgDNLZY/JgjZIlD4xLZDWg3uWy5Ixb66T/TQS8=;
 b=oN/e7gzkx/S+3WLO28K6wb714raz6KO9E5iIWNZAUGKN4ifklNhSkGhINUPoOUhwR/XeEeTlslO4wrMSvOLMwP/xVPxNWJGGp/r0x25G1nmUtADnKKVlu+LxPEZOorNrMECMqVPe6dPRFnikB6VotAy7XeIxOJ49+eOTtclVz/pdjcfErC8xM/Nzl5yvPgqR8q+m9FD7LGX1F1+J58bFj7EVIpuohe8IoogTA/ShOQAbozWMIXpGLg7SV1X9Ds5XsHPMBCX+3WC8tkngrURjLQ1l0yADZmgiR9Iaa0cV1O9JGTVK+p5cH1fPh9TcmBng56+Ly9ohh9G9p1rTxf730g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsSVrIgDNLZY/JgjZIlD4xLZDWg3uWy5Ixb66T/TQS8=;
 b=mAwozYmaMsLpY7ahwbKkQs0ibiPEvALacDNH6TBlVubfAZEMYzCKhfkozKldcw4v/jBWqSw763v/+Osm1k1I+wpiMC+b9cBL7MQgu+/ppqskHGyPFkCe7yIfeNopiZxPEJPBDqFjOpWGrEw1odSUwo4fge3u8Jrj1M45T/7SINM=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5577.namprd10.prod.outlook.com (2603:10b6:510:f0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 10 Aug
 2021 03:47:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:47:44 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Remove redundant initialization of
 variable rv
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1f2ufje.fsf@ca-mkp.ca.oracle.com>
References: <20210804143319.115340-1-colin.king@canonical.com>
Date:   Mon, 09 Aug 2021 23:47:41 -0400
In-Reply-To: <20210804143319.115340-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 4 Aug 2021 15:33:19 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0223.namprd03.prod.outlook.com (2603:10b6:a03:39f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 03:47:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d49f94e9-61c1-4883-ceb0-08d95bb19c4d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5577:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5577C7894A4300E537E8C6798EF79@PH0PR10MB5577.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMLvBdH6ytW+qVz4jI4TGhIq10f9qBY1rcjyq7ISWvpTNZ5IVMaqTY/9vtKJt1Ihb2FUu17hZ7Vn+ls/YvSOLMoSPVPYWHJO6bLcC29v8dYmHYXRjrvNwBzrqX9qT97kKkEk/3VBS0au8XlwCnucX6hIQLUb/tuZBJRIjmO1CGgiZGHNaEuwshBYooToEDLg5cqCcfyckk6vTTHAk9z9Gx7mqb521Tt3zG6+DMg4TylePaZ9I2FLrNE8SUEdOO6wFiJRIezzZYc7q0xkAKDXl6BI5ezYXjmX/WSfsnYYOiI5Di2y3Zo5pqOt4DkgKi6S6RQefgMeureKB3VS2ZQJ+5r/383XPZ0Y49IMkZgkrKiQQgSO7v11wgbXt+gMDUAGyZ5UHqSdy6j+3YfDkcBFEmEwByTSsSq9MZkzNdAGK91oXAfM3af77jkPuOa0m9kATBNJapsNhsV0s8QQWpuUcVh3iD9+QV1aEhe4vjtgWR9Hkdh2C/V94BILdahrih/RVW+XsBqXr3FztpmbovESGKiPzd73SIE46V17lBtFhW+0IMVh9vMphd20Xu7IArUig+JwKsqhk4Ns9kgSQUBw+HXHqtQ7Aikx1z/0n0zWljcSkZwExVkZtMO5KxwjyWNNfR28uNSXBXt27CriCnYjAjefDCNZoePT2znwiM+ck96Jnz21CIvu93dR2nYRg2MrcbJF9rBcdysOrpGZqCcBtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(396003)(136003)(55016002)(86362001)(66476007)(38100700002)(66946007)(66556008)(38350700002)(478600001)(54906003)(83380400001)(36916002)(8936002)(52116002)(558084003)(7696005)(186003)(6916009)(316002)(956004)(8676002)(26005)(4326008)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ou89fJJ2mJh7fMjaEiklfoq6XeCd0DxMPkugeSVHEqKDH5YqCKD/ATZw7WRH?=
 =?us-ascii?Q?/Z22fqT/n0cf21hqMPAqyB8TJUzOk9MvLdJ1Pmfnj8w47KXEJhy6k8R5doTE?=
 =?us-ascii?Q?m0SkwACzKsitopdK2lNWUJ2piYwCQEMgVSdiqW9Jyu3S88vi5sVMeCiQYLYY?=
 =?us-ascii?Q?cKsIqG1v1NhECUTLW7sglLT4mf4/eKCzs3SrYbcMFxPiMTYBr0AFIXVOQh8Y?=
 =?us-ascii?Q?YxjYyGpaDXiL1gPefFnkgQDw1SpaEQmI+5Y7ddAWQNIPoHTjifyH5uIDRYZ3?=
 =?us-ascii?Q?1TAJ/34jFMFsqUfgcSmhdEjWgfqHqzS7e64pbynbrApz7FNrszNBeuyFF8PZ?=
 =?us-ascii?Q?EPAwQYJwQ36UJlBJlVM2ql8kTftipEnHXJ7sKl03q4FfqvWLtyWLEmG1F2E8?=
 =?us-ascii?Q?WsCYGkFSi1IS0uFG6cWJ89X6iyI9j2y70O0M8tR7jflfA+Lfip/9Nih82viz?=
 =?us-ascii?Q?jjF/5QvPWyZkvPhfPdWKl1WfzQ5iI8Nxs2FdYbH4dMn/y5eIzaDO3rKD2Ehq?=
 =?us-ascii?Q?s7XcomiJx0GyaBR3k44vmXgKPTHGTyTvisq2xQll4+gjOnu/OigAnF7pUeeU?=
 =?us-ascii?Q?RpX1xUlYXQ2XvnAv0HW/jSZ4CaEn6wEFtQkYtLrUuWkyJmYB3n0qMOhsq+E/?=
 =?us-ascii?Q?1jPMHXPtKDnKyd8iE89nKt1HTwXEVAgapzLBO0VPM6idv/LzvQKs2GjAZQfj?=
 =?us-ascii?Q?uuHNzmrO3+Nr29MlSCcElVzZ93JE15Zl9HRzeu+OOqpzo9WLEpfeDnbzLKAq?=
 =?us-ascii?Q?Qxna2ra+bum1XTqOcTVILqfatZ3OhJ8O2wM6jA+YeEtLxyXJ8UhIUmSpiJPa?=
 =?us-ascii?Q?VaUodsWcYmHgDSzYEIEXT37JYX7NE7jK1BmzHusbRo7PvgZXS1G6+DXXlo5V?=
 =?us-ascii?Q?gqjvZXbksQrAxlDZ/Ea9IQHV5MKLnuFB0yQvYPCGIxHhta9xMl3GI3kqc+XB?=
 =?us-ascii?Q?ZjW5F1vvzvyGZOfi2uA/5NWZiPv0oGbTqhi08tCLpAtDhNMK5yRXzVTSXDqn?=
 =?us-ascii?Q?/piLJub5C1jJdSNm7u1jKCAy64/firWTnwloxYy9ZvpuYoFomducvrJBuNVg?=
 =?us-ascii?Q?suxqj4AuBP/9Pm61p6vAIBBfE86kvaGXQK4ML091ceamco+kZ+VDF6eUwmdr?=
 =?us-ascii?Q?huH67fotcULPPlL08zTgtFM/2JZ8HEELTaaDFAQsvlEgWMHGAZv62i7nMrYE?=
 =?us-ascii?Q?otuMkinR4gEr6VeNQC6BuXLYO1O3mLpzjPbbEFeYrONTRlEQu3/ULRaUfM7V?=
 =?us-ascii?Q?uuTNOL0EUGu0tjntdAeE1IYFkTACOgaZMTEqbBbJ71i3HsIImdFsTx6QKpCq?=
 =?us-ascii?Q?k14dmGsvh03bApiDtvM3bxrL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d49f94e9-61c1-4883-ceb0-08d95bb19c4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:47:44.0663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UrZcWY4dhMXh6aIjxo2dk9T4on+G1w3BCPntBgTrVfdYCY2OF/O/TDQZ+zA072R9uSrgxXsKNzDpRqUrpNxlPWwoZX4koBCBTtjAbH+D4jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5577
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100022
X-Proofpoint-ORIG-GUID: potp9cLwXaHelCo1m7pJzXSuubg3QXcp
X-Proofpoint-GUID: potp9cLwXaHelCo1m7pJzXSuubg3QXcp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The variable rv is being initialized with a value that is never read,
> it is being updated later on. The assignment is redundant and can be
> removed.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
