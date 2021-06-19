Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA5DC49361
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8ED6113E
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 03:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhFSDbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 23:31:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45876 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhFSDbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 23:31:40 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J3R7cd029272;
        Sat, 19 Jun 2021 03:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=yhU0Oywi4uMS1GBdD6jmWjzTFTehPimZsxDJd/ATfmQ=;
 b=ZWYCCVp6unJ12g1ObSpa9/yzeWskq/hi7hOlXnhWxKM3grfTLX9XL/rPoIYtJEpZlMOh
 eiyHXfuGKVV+ukNNkq7QnWkjktgS4mcT9ZPkeSUNtH2TzwVW4qBX/l3Llx+snIvuWWs7
 3JgqHSFCbffakmwL0nxz6119UhL/CngZ5aN0HbFpkqjKOjcSKWUMBjwYoaafPwQbJ1Gk
 p7y6cLE1mSKWpGxtoCYcvZBTL8RQ9oRkNyVngLZxWibzKP9oduj/K4XDmijKv9SHzfOD
 sZudcUAV/sAI2K0g4iRSpdFBQO6Pa6Blpu++R+lpiGYd9mupROI/ROhYb7KB1SEgK+yR tA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39976001s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:29:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J39c1s159624;
        Sat, 19 Jun 2021 03:29:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3997wk15tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 03:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2/fF1IY2CQj+2V7D+cwKye4pw2UEKH5z8Om7IlQ8I8kWzSng4F+McYnwlV7tzgY/VVkpSeVe/71W30MbgC33iPxcBdQI7zNe/f7sENewv4T2OfenflJRxDr/q5IhWqXjWCGDVfX3+SDOo9zl30WBRMELSMoXwoT8U0iI7cZ8jp7E0Seg2Lv9/A4K2jR3ahdGwDmmtHiuTjEdsNNTSBZPIuCOXAAUS5+yw3F/cTE86tZfC6/pfw77r6777NLaWBEP7TfGuvnaJn4RZIpH+QSILq19mCStIvydrBmI23P6pqvSO3wGzeWFoa7gIU/2EFI7DH9+7YV62Y8b8yPVsAU3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhU0Oywi4uMS1GBdD6jmWjzTFTehPimZsxDJd/ATfmQ=;
 b=e/RTYOR2TWugQV6OyeAaZNpkCNnigu7xqKUOsFCbYdzhjUgPuZ7uMY044N43DF6/gJG0s7m26buiN+ocNTmzTbuqeumJty/sGteK5UZk/S3QAJ+B71elmG+HaotPu80/ZJhI6BtA9exbFjwns44mst63UdbC07AMdLtm81zUnT5afNze8lc89qjnVsJZx3yx4edAhTnwZFBz1Wrya2w6Zi/Cf7Vc9jatkQ80Gm7Ap7WBrBgQCRJamroHOY9+1IGnhib5PGsGUCr+WjF5j1c7STnUZfGD6oXJnEbeP3qm66Jzf0zbifgzG9Q53u5QOhWKbOLcjtxE/fsxNvg57Zoi2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhU0Oywi4uMS1GBdD6jmWjzTFTehPimZsxDJd/ATfmQ=;
 b=fPS9Eq+7heiq/lU/qk1fTHn172JcwLr/rum3YRojyQqDHAxHB9A8eXZWPIk2/SrwGBY68PmhK4isDbddDkXcizMKWKfcOwrZTW4VAJgHYCrBLRISiX3OXFzkZEp3NMlX1o6n2CEpe1QS0Y8IxsTRJCWMbw3kaYC0+7HAhNClYME=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 03:29:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.022; Sat, 19 Jun 2021
 03:29:24 +0000
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: ips: Avoid over-read of sense buffer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r8ywn3m.fsf@ca-mkp.ca.oracle.com>
References: <20210616212408.1726812-1-keescook@chromium.org>
Date:   Fri, 18 Jun 2021 23:29:21 -0400
In-Reply-To: <20210616212408.1726812-1-keescook@chromium.org> (Kees Cook's
        message of "Wed, 16 Jun 2021 14:24:08 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN2PR01CA0024.prod.exchangelabs.com (2603:10b6:804:2::34)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN2PR01CA0024.prod.exchangelabs.com (2603:10b6:804:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21 via Frontend Transport; Sat, 19 Jun 2021 03:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 214a9d31-de22-4a16-e632-08d932d26f87
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB546696A7709B696AC0AC02828E0C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: akzcTi2BYSIQ4YJ9sGoVh0SmvngddGucBmJQcEMxgmr4xnj9P4ibCzGt/WaeHYrVHiybBosdPVUUHQzwYwScv1RAv+fS1hvQE152gR++CR+DarlquMwwtF7mIStQ5sTfBVhHY7iWRAANOqhVB1266k2cOvIIttyF4H9//uF15yBsyibayfcg4O/+AX0hcaXva5NYYRcJMz5Farm2FG5kL88lRdlk5WU5oStiyxFGWYJyPlfP2w9BUDCCbXmWJ1QqFXTwM2uLtqRUlMAHT2r5xyHE6PUa3qE2YsfaAX76up26HvhimFhe49UQsvFgYzXJEX5am8mvu31svM48A+YqzZcZZWq+zRhxL9OSFe7bhusW8pvUgKrnoW8+2OlulggwV/rhjIm2/08Vh8LupflGyLpviPKS3dW7P3z24KIkK5P+Dy4YvaKPvyPrhhmPo2/wTUY/0cCwZPapCBL0DBcIDbdvGX/nbnorbPOYjh0y8SHDKWUTu4mHjKN8BAxM5GCnQI5Shp7YC+OPjmfIfmPDSBY5aTB1zHDhreP9cVuC3gd4D8QPLpChPASszDGN9Zbj2+H5iUIAvQBfeB1WGUGomAA79766Nl28RHwqCi2qNjZ1ffMgq/0w1EcnM/xv3J11IwGFL96foPi+uotgeIzd9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(136003)(376002)(346002)(396003)(7696005)(66556008)(316002)(36916002)(66946007)(478600001)(16526019)(55016002)(54906003)(4326008)(26005)(2906002)(186003)(66476007)(6916009)(52116002)(8936002)(8676002)(4744005)(6666004)(956004)(86362001)(38100700002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5/KdtK+RIQUysS3hdEsKl7p8q0lxdw67h5s3Re+4p5dP8bAozB2zMwwu5+eF?=
 =?us-ascii?Q?d2C3G1IqemQ8ru2xCY4V3XypRA16c1K1ofYmidJUpALkOruwI23h7LeUMh7p?=
 =?us-ascii?Q?Qx72XwbwGIzSW9gJj3SfljPMusFDo49OqVSsNIoTFxVbLCuYdWAeJCrNwtLm?=
 =?us-ascii?Q?hbJMYj7rHwwGx83Phb9umISatcvguNuB4WeY2KNqaiBQCADdOmis4mpjbtMH?=
 =?us-ascii?Q?fTj5Vg+A1oL5BrOK7ZseQdPXOzYNzaylPCUFZ71URf9xKrvTW83lzQvLqNyY?=
 =?us-ascii?Q?xQASfNRf4Yb7oLoqdNc2u7L0HvO6bgKLE26voSiz3wQ7bLpUPJS2t5jtCVLp?=
 =?us-ascii?Q?bqbIFBFaegrteX0G1nkqtqZxOOTQLA/IurlSUH6UPZ+EQoS75CiwIltgllaj?=
 =?us-ascii?Q?NSxizhQ958wY/f/8ZzFDtvPpRounBBIOdn6R5ua3dxzJc5/0ZLfoR+Wyu32s?=
 =?us-ascii?Q?OfEnfuaEcL2VKpeIv4DxpwcEVPGZtOyAlzRMyv7BWlI47pPYNe8VcmTon77Q?=
 =?us-ascii?Q?Klt+r9WS/QhJPzZfJRaZDNORlhPbdGCurRYNiYl6B7/Y6iKITBz/Cn4qPYQw?=
 =?us-ascii?Q?blIrlRF13TVmdkVPWUzVZ/+0nND+FlThOl3JmJl7YiGypF2HSnHqg4BmV/72?=
 =?us-ascii?Q?/d/uMRJ+w8ghAbuxGUekq5sZEVOqLzlqQdLjYembWE1tDBbokEu1M8GUK18S?=
 =?us-ascii?Q?sDu/LkYF+vW/jkWZq8k7m9bjGlQiQdHP7F0owGCIX5FnLidT28zrunZ0nQuY?=
 =?us-ascii?Q?ZO8ywkIaNCin27rT35CM9IpCQUe/Fc5Sa0R275xPlIe96RV5nHBmzsmQCbEr?=
 =?us-ascii?Q?pb1gSZwU5gwX3SBmnGbg0hfBY8o/NsnduMnLZPMbPMilG1d5g70jcqX1LDHy?=
 =?us-ascii?Q?ibv4BxKZtGIc1+7bF3nDxc3Leugk/U6pGSn61BXurVzMXU/gOW2af+2u7j3L?=
 =?us-ascii?Q?5CA0n7X3WJFuizqOYF2PVS1jVxS9/zBVxYAl0kOcU7FlTsC0NNDWBEDUlC0e?=
 =?us-ascii?Q?5Sc0lK9kiHETkgqy2ADArJzuW06FVv9EJP+DUUsiw58kttOBArZPATZOmYxx?=
 =?us-ascii?Q?yo8Y4ASddr5DFE/gqmsAmfZbHtYHjEtjEKzhii+4DeAPVdZWjQeahO7hrNMC?=
 =?us-ascii?Q?6eMEmPcjCqx6WUw6144qx1Qwrzou5VaseP0BLe0bCPA4O8KbGVN17S5q91+5?=
 =?us-ascii?Q?0SQ8NPYq4ttG2q7ztLxhvBYt1FMIIO05WKq1W4KFeYvVJHgcdrZEX30GCIDd?=
 =?us-ascii?Q?9WdSQnhX+RxSwYQ2GqwO9DgCXHMSfUxGS0QWzSlEmb7TL4F3RwSy/Zu/psNT?=
 =?us-ascii?Q?e0xGSjjDmV6hXjjvufvGS8V0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214a9d31-de22-4a16-e632-08d932d26f87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 03:29:24.6240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mp3P6ZVnK/0pEeSJH5DPtvfJQIxPIASu7J0V3rBr2TctD07nXfIshiLWboaC/lXUkaVC/qv8QEIwMfIFXI/61J8JS6pK7Hf29mNteG2j8PQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=990 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190016
X-Proofpoint-ORIG-GUID: OF6Pl8Sied9b9nDzJG7a9cT6r75gMPHD
X-Proofpoint-GUID: OF6Pl8Sied9b9nDzJG7a9cT6r75gMPHD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kees,

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy() avoid intentionally reading across
> neighboring array fields.

Applied to 5.14/scsi-staging, thanks!

Strictly speaking padding shouldn't be necessary but this isn't fast
path so no big deal.

-- 
Martin K. Petersen	Oracle Linux Engineering
