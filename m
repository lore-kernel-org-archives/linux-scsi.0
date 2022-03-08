Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFB7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiCHA3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiCHA3E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5BFB7E3
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:09 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L3CUO022356;
        Tue, 8 Mar 2022 00:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=NfSEcqewBBnrgS+10pBdHfCzoWzmwlTr6GPPTaI0bDc=;
 b=YvfpwEePUL4dfhqDmYQvFv9r9eBu7EUI25rIMRRNWHbDxpZ26jlD9wziTxKStMxjRA7j
 2xMYKsg8+O1eJ9mp0BsYZxfKaq5RlsE/CnUJHeQ+JEDrBme8nHrfp3tKh4I38l84mAXb
 C1eOWDu8UKXsur5JTXYSPpBg7outItT9107Uap4etMXpSyJyStZFlcaCbbTlCd7FPFAh
 ZagOtkWLw9SKXGlgvN1miZ6v/C/4Krt6BRp0XFzgdTGUr44Hu6ePuMwNvwQ0NdpjoB7I
 AEvVd96AeQHGs91FivxHLAWGzbZPT4EkOUthYoKl3SlY/dD4Ge4FOjVa9U9MnXwX+Ylh ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0njg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ96134548;
        Tue, 8 Mar 2022 00:28:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arOE1azK1YQuiP6oCNWDFrknHTe9sWK4gdth/bywMhGXu6U3wcD3E6qa28Faqt2P3Ic613ITkWbicnbKBtRYCdOoXd/Yr1KG99XuODNmenaX/ZMKSkFx+oGfIvFzSWy7PNNnTwWIAf0TFrtg48qRmA42GV6VJi1Ppsm8Y7sXqifHgo9cW103yVkQCs/levWsTQNw+7IxbZVZDBqy0fLl/jzFnQsJtwldUvcYmqxZZXT734NXcNIZVKRFdyh8MBTtZaj3L6WEWOKpRUCcRJ8tPOWGzmO3O4A25e8A90mBr4JVJzqfRSeYs4bYp21/IGSutGLto+UH784DzJhNpSqTKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfSEcqewBBnrgS+10pBdHfCzoWzmwlTr6GPPTaI0bDc=;
 b=Foc+03Jj2lprNw0/4QbURVwt5zBOvuE5NPu9iQnEmuOr9hIP1mc8l3L9fIwwpQQ39LiGhPuPG/8blgHCwFDuv349Z+km/lmDpDR5lX0Ef40IeUaglXce6vOeVZqChIJ+PTGqqO6X5N7sO/NYEjZmC2leGl6W+T9xIAtbZGQ5+V3+NkOvYhyk0Tq59eWzRg3+2nle0NXc9m6Ap3kFXUWwQru31ali/SglVVxLx74JYv3eUhTKEWysQyVBrJCfOBguFabTtDCG+63TFF5uDoTZSNfNi70HxU9h5SmCuE5JTC7bGpAi/baWMC4C2oSbu6Q4iVE9SChXL3iN/7BUKUYjnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfSEcqewBBnrgS+10pBdHfCzoWzmwlTr6GPPTaI0bDc=;
 b=Z31ZUYKcv93YNVFxXruinQP/qV66K1rDIBr3iofwCpNjPeBCRCnJ6KJiRy70QPn9PNKxbcwwTyOHzQhmjSzDyz0jPMPJIOI+fkhqg/zCoedYi0Gb2JNT/FuAgygjBBcI3HYWK8rRh2l5Fwm4Qa3JO7ObRyfXNiIM2Hh/lD5uxZs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [[PATCH 00/12] misc iscsi patches
Date:   Mon,  7 Mar 2022 18:27:35 -0600
Message-Id: <20220308002747.122682-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 923cd0fe-026f-4139-5462-08da009a7da6
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB436128207B752E946E0DA938F1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pBLFAtXOrdgMNgTyKwRgd3rMa5BSVbHCXrsXysNByyC6PPKGCVmRd8lWvkhmIVVceQR5T/bbMuevrL+1fWjv4reSSWvz6vjOTXYjG/t2WX6A5TSSU69ydbmqC34SwgRorHZ4AVNu2LZDNtnwYS1qwH6jlhWgeFHzyMHJmJoeopjA42GT7Cf1ed2vVWqgZwhFTzyGcp/D0z23paugFK3/D9L1PPIg0eRyIt+P4S1LWQiSN26e+fjiLOS799+8AwM4SJCqctMDa+co3X2lEpkyeF2S8Uxw2MdP/41BZIedQUQMwB7rSB2CogrPWK4KvYI7vOxo354NsaXLVhmVJ64nioVu92URHzLTY44Dg1dgnB+mJtPUOAQOl9XRfGnuIJbUnJJGWpQQGh8himnUnkUPAg4f2yTBVB9ZcbAx2I+GfghFGxOEU8oY7vTvuBsJxdM/rTYXvClRKOUeabBRZVdftw7jBYL/v6MjYGE53w73eTbi/lzoD1zMRKoC6udddC6WL/I+7TUzoWA8GXmy8p5UMHX5zJmri+FOannoQ8McriGMcqnNoTQMdh2dmfxEf2AWMrvFdBZvenZ3EAyGsGEI5NiJSRRF8JVon01SKbIJqAyx0vB52gApOEAvvgg22TMn8bxYpjAoL4J35yOy1CPqDRZrbzQ0CWiz8H/SD6SXJJZ3NiCzkYnZ51tb8LnIw7Z8x8fHOSE24MUmShPeFKFKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(6506007)(2616005)(8936002)(5660300002)(558084003)(38100700002)(66946007)(8676002)(66556008)(66476007)(36756003)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EYMe2nqsk1ZhCFylnoiJayf7rgytp7iJBSG6S1JL+aDOTZGPjs1DIy2uH39K?=
 =?us-ascii?Q?BPf4wZzHNkBjH/JyWMudgF777fOUSDKzuXSQC254/zcu3Fu5QaLGU4xE6HUm?=
 =?us-ascii?Q?EryVxlIay1WvwLZDwGeYKMlQjKkEAnsyEa6hgOxpTZLgKB9vn2DS1cgJCV0+?=
 =?us-ascii?Q?a/DdTe77O2p9wT9Rsg6rB3VNn6QZzh2jcG1Lz6eB3A7Y6oEUzxZ7cmaRHP20?=
 =?us-ascii?Q?jWS295L6uryvehNuQPpk27Hq1cvsaJ2e6MpvOBnrCq/3ni34JLWgRqvVD9Sx?=
 =?us-ascii?Q?luNaDZ+y5qHj26lZSiBo/6xdMisAJGjGma0lQTxXAQkl6hVAJhCFgr8VovXJ?=
 =?us-ascii?Q?JM93hL2WlLpTUGYOc90lYs3NXKazxoxKm5UdWzusg7QMpoHM2FpgmmpMxxFX?=
 =?us-ascii?Q?CjLBh74ey1ja6uGAWleBStEHqfzD6PFZknm2JTwMst4eOGMmph4MHx+KF7Ob?=
 =?us-ascii?Q?FY448FuWjcmTNFdW3MyYBYZz3MzM2B3644JIKIPwI0nUUyHRQcL3BQrzXMXt?=
 =?us-ascii?Q?J6gjD/xmzgDaiSfxFfN3/2HT//RBZWxYVk0B6cnIHItPLq3KdYBv2mR9QH07?=
 =?us-ascii?Q?SxRGroPKid1Jp/XgJpjhHAme/0w5CV5ntNF7A28oNkhO1ggBoz7NvNIBaT2S?=
 =?us-ascii?Q?eDR7mq/lDbNBoQGF6QlqfYRq9X0kmTOcoLClycnbRI8HYz9GnlLh7WS3Vbe1?=
 =?us-ascii?Q?AJ/APq8SnzSvu735Zsd/TN+bfFJ10jS2qcT7GmkYQTQdGXiBumE9QKEQp0RK?=
 =?us-ascii?Q?6f2jYGqbkcumlP0jodKs/25Rf1lY/LbC5+1vq1KA3Usq4uCVtkp9EN8VJDBx?=
 =?us-ascii?Q?SBDr0vYy9sFcoVU0xFZZmavAQvuGgNa8J+9WIe+/FKJHhAEgq6MDFhQatvBW?=
 =?us-ascii?Q?Z85MmEATsiTwR+5zcHCGmAldjPEsZZA2mO0OAHE51YSoF2ztffsF85IqiepL?=
 =?us-ascii?Q?TgJUrWY20STLam0xWkNNBq5qS5guCZOIKj3zWL1ReMGOjkU5jjD/YNRVyZvt?=
 =?us-ascii?Q?UTOhfDEduEeRya+yTgb4Y63foPODLScntJMNCK2sMAqtGe9C7w0aCsLlt4dl?=
 =?us-ascii?Q?+WH8tFhSARLVFB1McS/6ElCaBsFm72EmcUhkJnHnzf+4kSCyIfxzP+8h2L05?=
 =?us-ascii?Q?jdZMwFzboaXhHE20IuTt+JwXwsxvGJq4ZCsDYYnwtyhvmDfnXmWa9Xef+ini?=
 =?us-ascii?Q?MWNLGAd/KdyJpw7PnIi2P/9mIPJxE+9ozVwTkvZyV/YXbpe7wqQfVOHyZCvh?=
 =?us-ascii?Q?EiqFevBsmaa2c8BTWpIasYpILWfaXl9CFd4jU1K8/tbZGqW+JTmMbrL3dqME?=
 =?us-ascii?Q?zATvD02sVyOJyJD0vs8LALIJ/Xjt7pmKbZI2UQpyFCKoiJORCnMBfh2MPAKE?=
 =?us-ascii?Q?NVbH3TPp0/Wrtbhn/kAxBSRZIQR6IXvvwD5UE1UVHc2pSUchCdcxvreOGU+M?=
 =?us-ascii?Q?rbHIbJj3beFwZSxgolq2Rg/evOMEIbvO56tBzQpjcsBdd1zLH7RDHZDwTUO/?=
 =?us-ascii?Q?C5QxvwaHfCR+kTmPwW9RnLoFOxxenMIs/2RZpe1JqTZg9H1/TOPpBrZkyp3Y?=
 =?us-ascii?Q?QST/2dMtCWJhzLfoyDJC7g2rF7BcA9ik7apujLv3u74n41ds6FX4YO4mBMWt?=
 =?us-ascii?Q?lOyvK5ZZpxLeGvRR4NaGuESSWvTDY5Tz7HpVtyPdUoUPLrEijzpaieQvmTib?=
 =?us-ascii?Q?J5otpA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 923cd0fe-026f-4139-5462-08da009a7da6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:56.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyUk94dvUV+WZ9VtwmMCS6x4ywhcJKw6gXPDPOktBO+o7d1xEA+0wZNBvguyRidOIN1G7dy9W2D/UYUZnAyrdFrdylsYnECz7UNEZ6V8iUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=874 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: OfoTO3kOSnM6_4bPSbdiIpy_65R_5gqv
X-Proofpoint-GUID: OfoTO3kOSnM6_4bPSbdiIpy_65R_5gqv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's staging branch which
contain Bart's SCptr cleanup and the iscsi class workqueue patches.

They are mix of minor fixes and perf improvements and cleanups.



