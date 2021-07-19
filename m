Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B94C636C8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C7966113D
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 01:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhGSBey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 21:34:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24436 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhGSBex (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 21:34:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J1VfbD030539;
        Mon, 19 Jul 2021 01:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=G/e9BuedRifjwOulIhD/SbGVQF9PS8AlvXyaAOCpycE=;
 b=bEvGHU4THSPlnupj17xc6mKMz8zOGFh/TV/OlVv99StZNO1TJM9Ney29ygKxaHENAleE
 DBHeHFq/VbThE/pYZjNXP2p64bFCWehT/mAMQlhGaji74LZIaDKmqzKDspP29ol8JTtA
 wyyuO21aiDMiAm6qhL/C8BNZ6gRP66GVUr3yEaXerJMMyCx4/OJc7mQbfc6YGxL6Rp2/
 1XFEi1x3iHKXwT/e8VE+ynPIicxfYR2B2d/x/IHnp64gaZHNvHykio9KlO0C1upcFRCg
 z09gHXFhe9hEI7iI99t0GRITUCFcShQNry9uS+OGMTzoAPB/nNXq4RoZOEeQEQeAZmkC 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=G/e9BuedRifjwOulIhD/SbGVQF9PS8AlvXyaAOCpycE=;
 b=XyYJ/aNNPfY1RMmTdPtBubJ1eaqmQI6eOHI+/uwuye3BROThfDo7EcQetZkVagtYs3Sq
 l5FHIQzaMSaMwfuSwN8XeBNLZs+cADHgfh4xpEVz/vXoGVuiuvKbwK+IAIQLcgTFv7bY
 R92DsUYig3HTPAog1OInv+fq50MTszgBJz2up1hgyS+0Gh1mTxqfWEHznR2ZjkFN87WO
 Th3mIHepWyfrzWHxr+BOdzKa1STErAZ5SvLIoMGkB/51Z+FTYiMkMcYM74H4tKHNhjaT
 MaZNY5rqN0p1638ld2IPIo7oOL5nL+BRt49Nu2VglPFRUYtc5w6kEBV4UTftexDkLyvV Rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39up031vn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:31:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J1FBGi120216;
        Mon, 19 Jul 2021 01:31:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3030.oracle.com with ESMTP id 39upe7b6nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 01:31:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihLk1CnTBHU9eKx8LDuDAngkiDJQhPZvduxt1wqZn9IYX4bAN3PJFp2s7DNy6i5kzPadhx3gPSCKgLbZs5iiyOpXc2n0eslFmVa2d2QSTOToUE2HMr1BXFIi/X8h/BBzb0nM2H62poUAmNZlFymRPGrWkG2UnKQmP5wFmgjLu3MMfEiPZoaUUvFgpW7SvS3kT52ZJLmNFU0A8HA3bLHhftvB91p/stBELaAAFU3urzY1f+LpahtXEclWC4UmZnHJ4eOXa/4LfLV/D+38Ewi1xYpixSQjmVTVK5eG5P+jD3zKtGxpoauuj1z1CPaZVq99xGprvQP7cCy+doNn6OrJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/e9BuedRifjwOulIhD/SbGVQF9PS8AlvXyaAOCpycE=;
 b=RPxRsgb0as7eA72vhby5E+Zwj5eXsnP8kMnFLOH/PdoX3lMMOo8rj/03XZsxa5g1MF6kDlfWDaqKpjkonJGoZSdyAm7d7KOZYFke2BFgoF1FW9b/N6VvBpVkk5QXAhjZurcMfa4Y1V1DlspwWvcBc8JuX5VE4b1ivB9CtVxCmXwlAke1HhtZBE7DNWKYe/PIJSyIGa+imI7qHilvhBMQ32vWbK1xc/L6pS0Y7ZuKsyyRvU4UL1c9CF2h3Po+6Ftm72XV9TfOJMxqt7yWC7BHnwPFyDgsDfaKTaW3ioqXbjkv8ZVi9I/uVJIi4z9eBqa05yhEnLF4eEV29M/vUBkDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/e9BuedRifjwOulIhD/SbGVQF9PS8AlvXyaAOCpycE=;
 b=E9x3px0LSx/T0FZOAxvJbXAc+3L3raIuKI9L7r6vBJulXvc3jbUVsALlcGB+hojycrmSN/y4MMxgjE1Z64J9bGeUXG3zz9pARFPbA6c5L5ejXZvi1+wMdKFY1Rn+zmPkzVXX2kUmSDNWRTnATJYD/I9OrmIlfOWIg/sA/5jQVzc=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4613.namprd10.prod.outlook.com (2603:10b6:510:33::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Mon, 19 Jul
 2021 01:31:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 01:31:48 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove redundant continue statement in a
 for-loop
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fswb143s.fsf@ca-mkp.ca.oracle.com>
References: <20210702131542.19880-1-colin.king@canonical.com>
Date:   Sun, 18 Jul 2021 21:31:44 -0400
In-Reply-To: <20210702131542.19880-1-colin.king@canonical.com> (Colin King's
        message of "Fri, 2 Jul 2021 14:15:42 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0097.namprd12.prod.outlook.com
 (2603:10b6:802:21::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0097.namprd12.prod.outlook.com (2603:10b6:802:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 01:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d386158-9b8a-4452-3a55-08d94a54fa10
X-MS-TrafficTypeDiagnostic: PH0PR10MB4613:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46136C0D596D5081A17DDEC78EE19@PH0PR10MB4613.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MO8B0jXJ3DdpSzrFzmOZ2JeXuxrWNnM2OAF/lJcvrKjCKxifpmpoz1u9K/57DvkoPvEuA7mm/zx/jdXEHqhad+t3M7zx2wLMuRisYUsXlPcOrbpKwOUoVjZAizlVCebXsHyVm7FqnQ+uyLFXeAC6khBaNH4zvqDNVnBdQvuL2RoguxQSgtY06wBBr+trCxYoxK9vNRzCdcZWUCobNwKWlQmEa1bhCFcpNWxgzaWteoqTr6GPQREP8z6dvJYtp+Ix74Qxp+J3tYWTSpfKLweZCgXbBGjNFj1ID65ulPgUy+IR+PJQ8piXwCIXVnilox/RfsTRpgGAwXFSowXgQjzWsgyQwsjoq9ObByUxh0D/P0arYWD9q3yaFvRsGZmX8edB8YpyUOQorQGenOO/7Eu3jnRkO4ifJhX/iOVKxLFbUQVK66vAX2UrbtTyHYKNFIwJribP8qId2Uh52NAnTZWbLA4XrkechvwQR7ty8O/POfIOq0/aA3FtXSr+q1lkGop9RHDGKuAvfl15j1Nz5bY7hPsFKzwlt3ihITsh+oXsa6zpGke59FZ5+f4rxOis7Awn8+ExV9xWlmQ1n6LUklnLVKXfPANPcUO4xcyizcBfQxITpTm3xDxj63HY8zgJx2YNQPfPTglMaVlKZ0LEdA8S3r3iIz853+AdfEw3r7SlFkZIeNk0WoYq+JKQUuZuPwJSCJzuKenVCUilm/Z9p/239w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(396003)(346002)(8676002)(4326008)(558084003)(55016002)(38350700002)(38100700002)(8936002)(86362001)(6666004)(6916009)(2906002)(478600001)(66946007)(66476007)(66556008)(5660300002)(956004)(36916002)(26005)(54906003)(52116002)(7696005)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TSPjoszhgKkf9EPrJrCjPTjZ1ce2xLTr6XeQspFWVA4WWL6dLvsAcz0e4e7u?=
 =?us-ascii?Q?mLUiUv1d0iqUje0kX4IL1tsaXSHGhAIxWvnnP+9wxJ34LYShhHhuEj+QQUpH?=
 =?us-ascii?Q?F7SJrU1ZiZnaFmG5IyoO4dnUZx0ES43MfxBQXIlb1+jeD5kFkuYc4MMNtKut?=
 =?us-ascii?Q?vgudIy1plpsCqFGZrx1U4GA8aqCZveOOhfBTV8IeZrivH+ORlgdfIzGSFHTv?=
 =?us-ascii?Q?sThyCWdtLK0Crlh2i7hDVV+3l1xtEm0lzjJiUrCOewKz23pJWitrif1qISdG?=
 =?us-ascii?Q?Xl+ZP0o0HTKiFUyZ+JLbUzJ1zVISYA7jteuK9ok4NtiWQ1FiOY6WryE/+2rg?=
 =?us-ascii?Q?ve+LQYtZvAkHqsh8MejJoDcdDK72d7YT8X8XNT+e13EcGaCacBszKWPZV3Be?=
 =?us-ascii?Q?65I293ohNoryMbmza+DWfPhUgrNY3wWgQr7UYXcMJyXO7fxepai0BYB+wVs7?=
 =?us-ascii?Q?/EY72ugxIV1256Etm/ebV+3gHzP67LWEzMkapPcQ9aFpjJaQOvSdLG+19NGa?=
 =?us-ascii?Q?b8iwQ6Vqz3OJkrFrzarjynZyGI4j40sw9Wg9gWF81ItO9Z5VXkRNhWwGhNLQ?=
 =?us-ascii?Q?WBagD/GeEbYQlR/WGPj6eLOXCnwZKBi+XLdR66CUwvQ0l5cJUEatLKV3ldb4?=
 =?us-ascii?Q?jVyoJhlObjrSuIe9ZzJidthsVAL/pAsLNMpMjDj7Ps0Cxu8Ygb563wpREy9F?=
 =?us-ascii?Q?cmh8k8gK935iNKZpFL9uFw+nO1++YModRwXyLrrtxqguAZLSVL3RqAT3ICHG?=
 =?us-ascii?Q?YH91jIpOesK9PMnDoMwPtbaT0LsStVPw5IoLq1feylptstGT5jWTAqAoZ3Fj?=
 =?us-ascii?Q?Rq2+xnqHWYIN/SygiLRvgmfPEKg9P6UoMMxbhg5MNrVKJvNRBz2LtN7hngBW?=
 =?us-ascii?Q?RBj4hvenBHhq9kcRIL5KTJKShlGVj6q1uzFvWnrL+xOjHz7jJUetsYB+dVDZ?=
 =?us-ascii?Q?A82qpLLXKS2N51hjEvvTa0U5UGSYgVZJV/SOevNm+C299Zq7AfulICooqt6P?=
 =?us-ascii?Q?h3uQEHQxZtXp8Hr6RGSy/pJciLzgqfZ8tWe31ln91w1Gm5cL96oZcpSzXwue?=
 =?us-ascii?Q?MMClqMZ0X8oP/6hJNYboT0enDF+1v2J87t29cZ1Y/zGoj1xsGH7W6FDgCcg0?=
 =?us-ascii?Q?HreFKQ19+QUx/bDvjj4VmOy/yGzJTXOKAJ8HOKioVRG5kLO1GoMimrTb4wVz?=
 =?us-ascii?Q?bnySBReXav61ezfQJS8Va7RwUU/JwPLhI7CWOtYvMvYFjtxUfC6ikAh0DeAt?=
 =?us-ascii?Q?oHQ1n7GdLAGpjpcJWqgI3lyFYF0mJHuJJy7bSDwxNzzIsDkAWANdrARPGaCK?=
 =?us-ascii?Q?G0hw0oX9/+gkJMuc40uezz8F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d386158-9b8a-4452-3a55-08d94a54fa10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 01:31:48.4215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dMettjGrtuPR20roHzSuF5aKSjPcbqjKL5QaFXx4CQn3kVFqPhLnbmXpeY10xrsQaPnIp61YU0sdG/8vJ5tsdR9MkwqMvrwYKZ/oYToXQ8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4613
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190006
X-Proofpoint-GUID: utpO84LMmZ9W_PZn3p4ZL43osipQiyvy
X-Proofpoint-ORIG-GUID: utpO84LMmZ9W_PZn3p4ZL43osipQiyvy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> The continue statement at the end of the for-loop is redundant, remove
> it.

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
