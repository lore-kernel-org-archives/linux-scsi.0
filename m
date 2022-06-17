Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5112DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 02:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379468AbiFQCBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiFQCBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 22:01:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A0060BBD
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 19:01:03 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJUUoE022342;
        Fri, 17 Jun 2022 02:01:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=aZ0ZzO4EZZ4BuT9Q+DT5urB4Ihi+YFjasZxnscjza0s=;
 b=OyOi933I+2nrbeKNhuCWo2aTpdGMygf55/7RGmx8OKnzAzwvjpegezXYBdkqzy0XyJkf
 MOQzia4TWDhXALp5qKVHJ69+KL3HLt/od565i3iCDROkjGJGYtCFzy0OH6GicI51I6Ya
 Dzc/Eoj94AW8J2RIiZrsgu+t3p7qiUcKz0+QjFlGXtzekudSZtO/2gSmEEIrJLvZE1aD
 +BnF1PU4FY8FawL+AoOEmnfXLPRpZiw7oSuTiEfrcAOYuXI1l1XgtaeVIbBZdSAYsjV3
 Pwnc/NhSPIgX7Enusu8V426Luh5Yz/zcml372LjAhrt7ED2Oyln0VIcEmIntHW03VuY2 dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcvk86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:01:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H1u66j025820;
        Fri, 17 Jun 2022 02:01:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27hy12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 02:01:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ho+LPOz/0UM+U3JHLNniUrW8hS6B7gaQWH2uBMLneOtiJ+oVJMtdMBH0LlD4UZo+hxZJ1y84ZLffIxtRZM3PxLkzoVyKI6A8uil6pMMbRHSPy8uFtQYaZfK8h41MX7I6+J3JNgcI7O88/FI1vVM3UqmisW64SEvzph37eFZKDHqilXpqZJbRolWhl0GCssyTsrZz/jBWnD2FUNSSMnNVnk0hac3dkYdCnTYBzUMFV6dpsSSIfSOvYehqCaqjV+r+KLV43Z8gpA16SnRN7nZyDM6R3lSOTab0TxJgBjaLJBNhhgER1PCYWUraGpCZPlTJW2hFwtT9MY/Hw9ntTV1wOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZ0ZzO4EZZ4BuT9Q+DT5urB4Ihi+YFjasZxnscjza0s=;
 b=W9T8DKtcV+pjTO3ZzWUykri0QbAWWecEXywROjIPXEv3g4hCIjX1cevRj8+eh4+zsaLju69JOHp9ULDStn+NDq//NksHx1gom1sHKiN0WJuvvKbWBvMKwwyGBYu/34vnF2vHWLe95NbVA1hmzH60W418vFCckyswtRR+KatEhwxI/Um3gs0OJnb7NQMNc567td4NwrCIFOcdGiQtQSZUqt927W+XsWq3eZVzqq6ACTSMlvNz8hpteDIjORzBl/P19H3+Aioxt0qHyud/bl10THVPFuMr/8P+Ndy13MnZ/OjirXvWjRd4FexnbuRlOUH/v7IVzU486ruu8z3zbqzNfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZ0ZzO4EZZ4BuT9Q+DT5urB4Ihi+YFjasZxnscjza0s=;
 b=RcLlMHlMrbVa15ch4hWXD5cr/Aa7bI6vk3iCvKD7PIildUDieefdfZ+m9itrftlxXERwiA/4yJ6rTA4rALKJocKmCL6ecyJxokHWqM2g+98rcrku43C6bFaT4Glf0Y+7qg8e5SLX4vO/v30PjW6EoS/X6sRlzA3cl/wTGdwjDvo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB2028.namprd10.prod.outlook.com (2603:10b6:3:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Fri, 17 Jun
 2022 02:00:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5353.015; Fri, 17 Jun 2022
 02:00:58 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 00/11] qla2xxx bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135g4oxpy.fsf@ca-mkp.ca.oracle.com>
References: <20220616053508.27186-1-njavali@marvell.com>
Date:   Thu, 16 Jun 2022 22:00:56 -0400
In-Reply-To: <20220616053508.27186-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 15 Jun 2022 22:34:57 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:5:190::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 252c8d46-368b-4f1d-c44d-08da500538ca
X-MS-TrafficTypeDiagnostic: DM5PR10MB2028:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB20284AD211EC3E3934CC22F38EAF9@DM5PR10MB2028.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vssZ3QqOboPtU1ksuTdxW31u2YHKVqUT4xLfCROlNtwXdRt8b2ntrzeTXpavgeVeneLSj84OynyQkrrsBSk8IUTH6/GeK81IU44HbHs5AFtmlojR/fKQzPYWp6GhsdwqXMkHPgMcQyfvFu5QgSxLhETAEvL63CSBBhGm47e1bDBRs+9/odomRHXwBBUmEPjFfq3PhXWTecYqUmtAhqhscIYzOFX8qKt5oRmn7RVDlaOEb4496oCPsg17cwMl/Ttnv2y2pZKl6c/+XigRabsXJXDj0lwZ8Przm36HBCpBqFnxJ+FUFF1sECpaleiOMECy+2dcIhaOZBnKBd2Y5l43czCCkFrBGh4zZ/Y2lCcbFSISM0nJ9CqOhNgQbrEEMv5K0MJU4mNZ+ZTz5lNE7ueV1OxfWActh8Aavp6Pyfq4iRyUDQRDQZUCLUoD0hLGjStHepsbzFPO/qZv/ayWzuvfv+dO44Gw1OyV7ZQqZp61zylYxSLiLco1OINgwSF5VnkZoC33bISrjHMnnFbKUZE4xPkoVma7HDZWt8lzj6ivfNvFaUQ9JmhVo+I2Zt9s5tANSjUe9J5pM6x3neU4JlY6ioBx8b5OhQGpBTdnhhKAfQhSyV9phM752I4i/7kJxE5zJzTOtBBrkMLyIxvLdDn/9mpQLBvYBXeSIRQGyKWcTdxUMy36v9+lS04sTM/v6uY5/CvcgPKjXs501dBWbHzZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66556008)(186003)(38350700002)(5660300002)(8936002)(66476007)(66946007)(498600001)(38100700002)(8676002)(316002)(2906002)(6916009)(36916002)(6512007)(26005)(54906003)(6486002)(86362001)(558084003)(6506007)(4326008)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?32CWBXXda6kOC81iCsKVw08cewkBqJo/9ISqsr0EPqxNjjUQVid7WTDJujPT?=
 =?us-ascii?Q?deSN20nQvngGk1n2WmgERkFxhGv4XXVhIDNbqvQQK8CiP08EAUFuoLKyxg9I?=
 =?us-ascii?Q?z16//bpScshTv8XN4s0pppEz94yokHcdbrd5PwR4l23LplgjIfcvt6Mc9T93?=
 =?us-ascii?Q?p+1Tx8dM+mJmzKkvZqexCJwpWhEh/EIj/TGt5DZTJpx5622xxOjrLpOA6peI?=
 =?us-ascii?Q?AMNNBMBdpUEGNLZYvFQkPtulXLzO3bwV7hnuKspM7HPmY9wauOr9JJYTpOe/?=
 =?us-ascii?Q?d4Xg4qIXz5WIa14Uwjamlp+BlXIRQ4kmGJbE5+qwjGYzh7Zh7R6V1m0oPdvK?=
 =?us-ascii?Q?HMy5jyhn1iqtzFYwsbOcDEwM0RoAuArhpAaPy9advwVKGQdKiz/6TuCCQR3h?=
 =?us-ascii?Q?JVT1siEdP/TbZLn7Vf6dg2GbpsMtwCFzpKDLIhHrL0G3R8Wu3VBCUrjD8DKw?=
 =?us-ascii?Q?09uY7aGRlnT28GhP44UgzY023w86wvenq7iDIQvfOCozewMlNV9jkw4SAFhb?=
 =?us-ascii?Q?y0YLi5Avlh7HN++CkQQGbYQohp12xBasBajONEAi/lIjC/qADS0KuG9JXjW6?=
 =?us-ascii?Q?FOEuWiEOxcmex+P23a0o4uJ2RwGRgVi82FuUjsxcaLDkm6Gh0LcqRgxwvW5Z?=
 =?us-ascii?Q?PtXcQjrq5HFi4gm9oUDSQ8qD+JXMOb/jirUOd8w5Jv9goASYiUFiV0g+UNuP?=
 =?us-ascii?Q?OTUFpsVxc/fabe4uVqt9zW2ZSwF5kNyNdXCL1fevyguAqFGwyoRZbFGw0m6W?=
 =?us-ascii?Q?RGj3XNuVFcKwyHE2AID1fvXU6av7BTkbyvu3gZZSw0/WeWBWcBwkVxy9Rx4n?=
 =?us-ascii?Q?4PP65W+bOxxJTz+Cntc81q6UFwIotWroBumGjgVTjkmvJZPOiLKBci1aiCVQ?=
 =?us-ascii?Q?PtlVAaRkUsY4rxMu169wauSvBs1HNZGINDY5mCKhI/pes17bQKxy2ISGIIwR?=
 =?us-ascii?Q?HgQ3tiO1WrzZlPkt9KXt/aVdPP9/Eg8KH3WWWHWAMBlTfgWK3bn2ThdkSQs3?=
 =?us-ascii?Q?p0stZ6U0m1aCQjKw+6xlPyb0BYlkDRBpBXmItmWmI3v5gapYpon5mT3H0jTl?=
 =?us-ascii?Q?Y0ubFd69en9xlaCueRgd5VgB/e0xxvtj8HTsLqqnqD/G9pBWTduw5mi/prm1?=
 =?us-ascii?Q?+gnVAmodt05LAN3srD1TWfw2PYa4PYoK6IM7AHQXzE8W9JLR6udF1pIeA2df?=
 =?us-ascii?Q?mD5Fzd7hlKeo1F/P+7iOl+cjWcIqReHuqfoDfZuIgEgkw+5bMtA2/9T2xt0Y?=
 =?us-ascii?Q?PAndMSjAAa6n17Cmt7L82p57UCS7OUJ5MCNEQQLIopMQ/PKKhylioX9C8shj?=
 =?us-ascii?Q?Amcmuh2zmS5EcXlurBwLwZeXGgz0yw2mVqOVjeBQOA8DGK/cSlFyC6f/aR/b?=
 =?us-ascii?Q?BQm7JUcFAGvU+ICEet5vKFeCuSBFhjYoMk45YFUgpTFu4pK9OKjvJ/d0yNRM?=
 =?us-ascii?Q?K+KVAVVGRiaz+eikbz1RxuMtPHAl958nqT9vgvtVkrLWfPmGbkHDdbMPspaH?=
 =?us-ascii?Q?K4r9Fx+cPjWhMos4ax77LCMdDLhVjwZDUHbgUKnOnhfNGeMhWvxhHH49GYTO?=
 =?us-ascii?Q?hjFayMYkck1exqfs7RgrdbKZD5iwNNQJt9BbeaClDXqLZ6rpwjbiCv/XFLfw?=
 =?us-ascii?Q?L6kPBSzveT5m5W/OEL5JJl9PGaYuH2sINXSzv8urqlQUxKYnG1nGMJEO4tVv?=
 =?us-ascii?Q?0OZYvHiPgb4yzFVt5wfT7+GdH5AKoweUGuD04M2kGf7BRu0k7WKsaJo8dd3i?=
 =?us-ascii?Q?u08/oqAb/Bpop4yKgtKQS4hjZBFyhKw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252c8d46-368b-4f1d-c44d-08da500538ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 02:00:58.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kq8+qDU2I8ixY505vDgIGIE3eTWDdXPO/xSHkd9mBVtSgcQX+8UVCRGaq3IE4rCNhoXp7BA1cnOpchx+IYdgfW89R9jzj7JBg1iY2F6lILI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB2028
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_18:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=683 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206170007
X-Proofpoint-ORIG-GUID: EGmHqEUbftqNdmaSiheBFeeAMQb0rooK
X-Proofpoint-GUID: EGmHqEUbftqNdmaSiheBFeeAMQb0rooK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
