Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBAEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 07:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiCQHxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 03:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiCQHxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 03:53:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C14ED372B;
        Thu, 17 Mar 2022 00:52:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22H3Dwq4030863;
        Thu, 17 Mar 2022 07:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=8ylapSsgjljZo2ZG/s8R+Jdld6UcsutKU7mFQGtYELo=;
 b=UFRuhtf5ThCcppwyiX+DS3RCbgMm1TWR3L1eXGU9diNpphP65K0t0+GX96ewm40lBwPz
 8uwkDIiQUZB+PEaQyegJb4vckv7SE+cJ4F4kaCrQKd/31m/66R7i8XDfsxzXbDpo7Nz0
 EUf6dLDnTtmqU+8Qr8C24RGs7KxC7Mvsdq0GooGQvCkyYA5cxUbIC3wcAzqe/Pzw1/3W
 0/HtgNQg+4+HUnOFRkKW/m4aKSgZKHlUpwUVG5WQtks/bkiIxCuMLXMmN34Qi3aOSHz0
 ajP8d6vK6h55CaL4XBpEIdYBIDfdk9nmR6FcWCWgKMz3dIPkw4u8lWbnN03B6bGjXY2P wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6rgbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 07:52:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22H7m95w020844;
        Thu, 17 Mar 2022 07:52:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by userp3030.oracle.com with ESMTP id 3et65q1wnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 07:52:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4UypsTj3bNsmgMbj9+bvqP2j8wWHb5i6/JdIQ9/MLolxfrdJyMNA7w/EXzOXUque7krnJBHxLk2gQxRieJ+cgOUKf8InIAb4qaM6+JWaZlicUBJ1WT4tr7/EN4j0ZlgoWFNp9uAxfdVp0SWKt04sIJC3R7GCs5GqDvboK61HVwRUR/Un1oCj43GC4zRD2vruWvLATdPen66MsfoMe60KHbcA9R++T+0TFoJ4IR+KhR+aDBR9zeC5qo1lKpCK1T3QZ5KdKRJpT+hqiV07tTAocqqgZyOHDJgsqK+FFk3yizy/9fNmA/PsNC73lKb12fMa/Zhl+MZPh5S80U1roYzjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ylapSsgjljZo2ZG/s8R+Jdld6UcsutKU7mFQGtYELo=;
 b=kUbX8hKMvOJPllU/xYOnnR9+qIyxDMkBVtO0Mf06QHP324uRgr5YB3fTZ03f8sjWs4+O7T3wy6fJAUuWf9zkupuPpRk8VX3l2libfizAAc8zMdq93pzV2cztMpqUny1Mlf441gjf6j21Msb5kkm2QO2KzAy09PgcczeCeFSTkJsjgzDSHwElvhAU6NIwB5oXiEPLBj8jUwmDXr/VvwCpEju99uBbhMjXIyrdLDUeCNMjRdnOGN0pmKlMBD9jCQqms6j0uF8xYVKANjzBfN4s2Rc2sIRM4lI1zTfBLTW9S1E43nVy3TVR4RritYKXOvpSqOoqnP2s9BwQdrMSXY4VLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ylapSsgjljZo2ZG/s8R+Jdld6UcsutKU7mFQGtYELo=;
 b=zK3cIo64iNsWGexvuHm4h7CcGMiOr9veMulCaqYrVkUsIbgOeDrRXYjs6sdqcH6xnihaHzDg3B1mL/XJvlvYIPOg4WXdi9WvMKE/zcMPz4mkhsRa1sYCvydfZy1Q8j6B0WUj4iKXx89gR4LvJ7K9Eb2CL1HW5dkeWcbHwaZBEq0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3283.namprd10.prod.outlook.com
 (2603:10b6:408:d1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Thu, 17 Mar
 2022 07:52:26 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 07:52:26 +0000
Date:   Thu, 17 Mar 2022 10:52:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: hisi_sas: remove stray fallthrough annotation
Message-ID: <20220317075214.GC25237@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0172.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e48b88a-8baa-46f8-3c7c-08da07eb141b
X-MS-TrafficTypeDiagnostic: BN8PR10MB3283:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3283EB878E7AECF4C08009778E129@BN8PR10MB3283.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: so5UOHUZfQc/5aAnUU8rTpjfiKl41JeV18i7MYGNVN4VEdPWoeszqEjQOHfrj0v/Gwyeyrpdl/XqK3FgP4q1emXMJSjRRYc1KHAZAaT1BwIQRNZszWaJFcFxM0nUek6Gh7YMeZFSXGA6qRIxxpg1wuzSrO0kUkUpHNOUecBNagfgpFWr0gwfzm3cvRnl9egBicQETnh5k/XswyNCGzXOS9SzfjToNW38lnx9K6WQOnrHkU83Nm4x6dqjSVvzvvQdMJmckj+56/u98622izObXTZniBatcJCO+UhEYMxfPYc6226QB1ZrRkxQgd6FFxesRWb8QHcoRnkTuam6SbUHlRhbaOAxJJxPorD8vE6NQ1Iun6a+TsfgAopDk2GqVXP5LHIUwutfGcYvj6Qqx/P5B5v1z4t+dWj0L9Us9AENIJ9HvjR48nsHpxEvHhP0N5kRCbcQ1IR6FLU57O5gMJ9aq14jTrOUNZ2znvbQtlh/v93q7CvYggnMdaz8UrFPtEWVuqMrS4UR3Kv/ufhXwVb2xnGy1feW9mSLwLLIiZ8/vJaT7rARMw6QR8R4uIUBPPm5vErd0Z0J7RBRkUeihsrYq4LtGju29kUryIixIqgO3atOc8nw4taZhG4gOGPwQXZFezuiFgBovMJIBKQThf2tJNThTyz6K0sDuDnYU6WmSp46G1C9pQA64tHLu7RC7l6JNrwEcbhaRxvXiF0i6qK1WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(44832011)(5660300002)(8676002)(26005)(186003)(4326008)(1076003)(6916009)(33716001)(316002)(66476007)(66556008)(2906002)(33656002)(86362001)(52116002)(6506007)(6666004)(8936002)(6512007)(4744005)(9686003)(54906003)(38100700002)(508600001)(38350700002)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NQj+5knZKPR8J+sTj3Rw7K3i8dw54otn6roJ8d0/UfkBwoQDrq1goaHAkdbR?=
 =?us-ascii?Q?visdVkdPyGPeuZy6XRAFAqBkS8JBnFewXDxUskeK6s/ylWihiaDBRlU9kqvz?=
 =?us-ascii?Q?zYJP06QoH5lGnERk8sFn9JnU6ZMpb5i0OpxsS3rj2WTR6u7CX/uQYZKuXwTq?=
 =?us-ascii?Q?ektzRxNl1HFMXT40rxYlQAYi+8dwAPZmwXKL3lt2ogkPE2bUrK+VFTU9aUHI?=
 =?us-ascii?Q?OJZG/6nBPyS1ZTSWPQruF62nXWtfzxb4msGmhXDBVb3zgry3pLnIeYEiVhWS?=
 =?us-ascii?Q?J04YwI+8eEsiEBHpIDbXfk5JcgsPuxDPqwBkH88kyVMKm2HZwCOo2D1nFSsV?=
 =?us-ascii?Q?2UYtx1tUYWjyJW4NYU7vm11YcjNB1utdcJWUa/lfr4m7UYX1vSma4FAIkMcv?=
 =?us-ascii?Q?j9vZ6MxI/hnkUVTfIGCXK/dexGuGmGXhG/Abd+h2kRYU9YdOFhWzZIrSa0SK?=
 =?us-ascii?Q?PqnCkQkicPczOM1aIeNhOTkBSrfwk7HeMvH6Ch3POkE+yXsELuKBYpjQxEB0?=
 =?us-ascii?Q?r5Ubzc3Cw4bjLh6VYcBrkLogTbLMutYNMlkGvhb9347PxYIwZq9DxHlpM7E8?=
 =?us-ascii?Q?B4/ayb1+v0WCkzqTVxA0/60njQJRO/flAmQamLVmmxwLxcJ4r9gVtvROke3O?=
 =?us-ascii?Q?K8Yf4zdYH40H70IncKJuHtO1OB4qLXwS7CATd8IhoWvI8crxadjZLYu2ylel?=
 =?us-ascii?Q?5MLJZdp901wxjfb3/G495hCpweVdJljvf9lcXiEohNjLEgpjWPAOpPKWOcE9?=
 =?us-ascii?Q?svS3hAtLd+j853ctjMXoaFwjP/sddHF7z8T2fkAi/KcGlBtvsAZDmppadrS4?=
 =?us-ascii?Q?uccV79KP4ueTHCAu1I1YwcHy0xQRJbAGzqKsg6MaM37FXxPq2Pm1C1w6CFrI?=
 =?us-ascii?Q?7Pvpnu3xPOugvVBN0HMXXNen/6Is3bWPdv43E4FFaDmtD2rvHu+C3ivA4nOY?=
 =?us-ascii?Q?W8folrY2Elacqcoj8NehMes++u2WHpNYOHI75tJzegTJZEAXNZQA2ZN5pm0v?=
 =?us-ascii?Q?1rivlIhzBLD3+4MLgS/G/UyOwhkJowXLYYZtWdknxhHUawZ8I7x5RbMagN0c?=
 =?us-ascii?Q?ZqyETTXeZrTzuZGEswvuublkeNLTV5/u9qOI8VGZABsRjG+z+/98lm8zSDDj?=
 =?us-ascii?Q?S2kn/kQHU5tVFX4xtsk2EudJB2b1i/7YdiR11aLQeeSTumF/fwx/u1s3+VhU?=
 =?us-ascii?Q?2Lf/P7dc4tEAu4lULrhtLIDXMCuyficDoTxP5gWUngtyADQ3meHN9xnTS1bH?=
 =?us-ascii?Q?Xs9ZCKRceQh1gaYa/Gkj6po0rYFOdLbBTBokYvR1SdYqrsCAOreyXD4ATXZ2?=
 =?us-ascii?Q?SzXu0ML5izujZRqd+v1EJn1aDV/R5HxoaXnEQ2cP3+BTl8PrcUd50xfCtsFe?=
 =?us-ascii?Q?qwNJ2rO0IEdkBDEFXos0oDLz1Qbk2UgV4bY2YUElISAuH2YM/EVCFPrkTwCn?=
 =?us-ascii?Q?8q8yBsnfhiv0N4OsCnMfX2GNDz4tkkxOXT1gTGyMcsKH8/zsM2hHKw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e48b88a-8baa-46f8-3c7c-08da07eb141b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 07:52:26.3634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8ljMHcU2YRZAZ5EZWV9GWH/kK64GGlv+yleFtk+CFqSQSzNPqu4/XyaYXGT7pBPCbFEQDR+QxjiwQiZplCpAORdpkvvFxOGm/C4sqdr8dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3283
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=984 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170045
X-Proofpoint-GUID: TPM5uTlKORVdt2HmOOX-fOhrX07t21L1
X-Proofpoint-ORIG-GUID: TPM5uTlKORVdt2HmOOX-fOhrX07t21L1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This case statement doesn't fall through any more so remove the
fallthrough annotation.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 461ef8a76c4c..4bda2f6cb352 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -442,7 +442,6 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_INTERNAL_ABORT:
 		hisi_sas_task_prep_abort(hisi_hba, slot);
 		break;
-	fallthrough;
 	default:
 		return;
 	}
-- 
2.20.1

