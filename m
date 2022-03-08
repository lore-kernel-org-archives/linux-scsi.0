Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C4FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243562AbiCHA3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbiCHA3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE69C2612F
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:12 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L3BB9010003;
        Tue, 8 Mar 2022 00:28:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=HZBNKRckkxaCHgdQBskpAVHvKijhUBr0XO7fEsPyfVI=;
 b=EZWaFKfo9g36YJMfhHl5g8REO9pjP+cNKRwdu93lDn/DcTVurWp+KbEZxKywhfrPnK+3
 1Kn20JMLMajFZ2LZZVe64gBUMmbtFCNdVy/dL1pMH+ilQ2IEYpnY2a5NsTE8L1q6mDyT
 MSPGifNWuEv06o9sYJPETFCe1WlCPKEvRq8/5QnbFwceQQec7l7h5laiEPjQR9feOpLD
 5Z1LYmh7R4I30b3161p5P4WojPY/A8aJrbfIO0Oykiq34SAXzdGbgitmwXA3bX3lmP+M
 vG/oP/IRyY4eR1epNSxIEubIfMcolUZZaWNp6hdR9ag/CwoE2JiKUCE0ATjZKq0gIPQe 0w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0dtwjmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ9B134548;
        Tue, 8 Mar 2022 00:28:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaB/3jPQlTOahBHqQ6J3ACzTHKO94ODBBhCAUcNlg9UXkHG0UhSTORotNHxkz62/QKzIUq02devnPytRy6iCwgG2PUNaUwVpff6E+qLsGnCH0glnAzChty/NF35tiOHDs55hwSSuhRkLrS3tRXlrmnGlfqLCjMLd/YAdm+ywnNHGaGBk4GV/FjAUBelgSnIDsaJw3CvN4AiQjz66QoYnUqQHWE0xPyAMJvzBX4Y6HcE19V6MmILE7xosWU2BbdqtjrYvmNpT0raiAUy6gQVHYTmtcOZOUOsPc1Aei0QmIW5vy0/PP19iF5ImkmiF8Qcbntfe2opK4iyFlF9PgmRTzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZBNKRckkxaCHgdQBskpAVHvKijhUBr0XO7fEsPyfVI=;
 b=P8KAVZQVTha6lifk9tcVtgF3YQzxjPdoZQYccMJosasP1DANy6rSCQDe9biMtAUyHF2trf86vnJ+hfZBOYNJeaHCYn7/rCn+VW+uvCvYruF0jdiDndZuDTlTf6vfQNGx3m8aJF99j96783r38iQ2c1N05fsaDRPP4uLjX+WtmRIjtem+NnWTLL91ZNzQIgcuBPcwqAqwq0J8VACfIrW6KyXdymp/vFACRYJbpObAmFfukUDq1dHTaizsa8CFX7r6XeUwnnDDZwa49G4jPS627fzpW87aHWwC/SndhSEO+05K48hlebsCBUhLGtKSw5u5uj070AinIyj3sxrhiY8q7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZBNKRckkxaCHgdQBskpAVHvKijhUBr0XO7fEsPyfVI=;
 b=u4szMxumjCt+om+EAJBISdqGm1YurpUJ45lPnvtn6gtblONIBMSvYy6a3MlvaBg3Htw9IP2kyRD8h/0fD+cFMASVCGf+a4uVsbmbcCd6Ga35kE+axZNEPm9BNQBo1rvqJmqtYIkHqOatOQufBrFWkgekBVBGdKUpqRK+PxjiPr8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 04/12] scsi: iscsi: Allow a recv and xmit work to run
Date:   Mon,  7 Mar 2022 18:27:39 -0600
Message-Id: <20220308002747.122682-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05ef9daf-c58e-4630-f969-08da009a7eae
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4361B0AFCF7262F9FA84C1BAF1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SpALv+uqth3Tf5+4K5m4YEQ30RXTJlSfzXI1BeN54Sd31/y8BmdxfJDs2aqS5bf9hJ00q56iLBrKfGNO0uqi3U5JRBtYHfhsa9uYPs3uXD5Vs34G+FQEzujaqVaE4ExEp71raV8buuL5nnrwPQDZ8yBbrxY3qDo5tFUg+DdroByq4nt73D5XxtSPT6sjAKbOIPOVbdGspF3ZXBnSjfibc2DNtAlowsfqgAyOfKQ2CECMpMnbuysm2M/rrE51OhjaaHawCFKswtQNyYXCtKkQQwbrZNYMwnS4ssF99TtQfEN/Av2PqARh1b2vmXwCvxu7YgVdszrQ7wvoNrxOUnFsAp2LMWoe5xPLDtEdvCYeTzsEaWyRgdCnks6PloG/4iSHjQWl5U4U2NNPCwVMpQH00A1mc74KM4X2lA3Zgu7slNHOyakgmWj/5qCWRx9kIdoEN1aGmXkhpg5f7v5Zk+FKsgfYBjPuN370h/N1ErhaYBu3dSR3UhnMOEi3XSRZunFZ4Y75Y98UMYYBTZqhs//xJBEttIOsaHkZEqu0oGXnBujGKJIH0OAViZQhxfXXjF6rjA4tpAIvrrEAYuHp/7TsSvrbUKhFJjudcUhkCrL+5pQvYgc9WrFg6Z+I935vl0BfCWzNZboZYES9AaB5mzAPeS+ioyYZd/EWf3Mp4Q6DIEliDGsWX4YZCOqzCZAaltWvi41LTnKR0CzI0Z0FoDzt4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(107886003)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(83380400001)(6506007)(2616005)(8936002)(5660300002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(36756003)(4744005)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A5jZ3flm4vZ+mtNQEikk1F4Uv6e7n9hlkc+yUpsJlF2QCkpAKlwW5zrfK+O/?=
 =?us-ascii?Q?natkxe0N+WJUmF0LpBeOJuhv47dsJP09aBUz7/+viXEFGg9J87kgmx1j/7b7?=
 =?us-ascii?Q?XpjTU1DKVvdShrUjVtn55x5vIWFFeTfWBfUIMN7bdP3M45Q24WFKoaNlHO9l?=
 =?us-ascii?Q?3soBRr2bX3T5SWkL5ROX0s/zLQKiV3DGcUakt9kAKBQ2mgFEVsU3vXbytdZC?=
 =?us-ascii?Q?1XQ/iX+Gi0Ke0NhrovscJ1yePFoKKu25gO+92t88l7N9Zxj054ymdXOfTcSd?=
 =?us-ascii?Q?wnerXq+7iWh9uHOhya/MpSW5KcRpnwt0nFNX03z8sNqwPSBkIhG5vJru9/v9?=
 =?us-ascii?Q?uIF/1XYR4ErnFlif36jWg6AZBK5+vjMGz4SjLf3bUXc64SolQawWDYHYT6pz?=
 =?us-ascii?Q?rcyatV3bZdwSNj4WtsSGa/bvyCaRf8tb4Ru4lISBKjXuVOy7HlhPitIUkAwY?=
 =?us-ascii?Q?bKZOM3t6jLrH+FBl5fWx0/AI38TwaeeSWikkOwiQ8LKXaQr2HweQzwNf1uGc?=
 =?us-ascii?Q?HC2MxkdoRr1uKt6GrpSl8bDmidILljSYAEzDoxISCyDU5h05NnXjhXygQA4I?=
 =?us-ascii?Q?Oa7bi8+t2tz3MjUgz84yHm0cu+NRDd6wEn470X3GY52u3IWQBmeWkpXaNKHG?=
 =?us-ascii?Q?9W8CP1NtzRpcFRt72Pb5YxUhEKZyqvuNoBGCiiapMjCVIs5lWmFHD7IXcDZx?=
 =?us-ascii?Q?UIAD6P5xcH+b6X6e+RGg+rU2TTAfQK+bPwyYXmoEDttbnZS+Dp5FdB39kli7?=
 =?us-ascii?Q?S3eXZxUWcREJihD/ZVt2y8ITOikghBdirdrNEXNyz7X171wWFDEndWIDag5w?=
 =?us-ascii?Q?W/EZSobg58IJBYgAdcK2L0ISrwX1ZhYTSggR1cTGW5RLVtWdToPKZP10AsTG?=
 =?us-ascii?Q?9Q3Pabi17o6yGS2E1RpDra6w3WyFAy0zHsZV5ErJ2rATfUqgLIE3A0e/E5kW?=
 =?us-ascii?Q?uqHk0itSHUpZhwXC/uMTRfIF64ieVg/y0E5DR8/fa6C1Rfc+i2uAFPZSjMA+?=
 =?us-ascii?Q?GaKa0MiPKwUDFCKYH9l6QZNIEJHB/spGNqsriEPpjlPwE3tzdxD/A9iFWyiJ?=
 =?us-ascii?Q?ABgJcJGUkyCbD5Ws+TvkVxF7clagq4RiHEd1BWW3Y2jxetx5V5yGXqsBucUX?=
 =?us-ascii?Q?riiQdOUFVGUA1uFYGlQYXIDje8veqB+IX+pezHa4g0n3o/lUp8NYVksO886q?=
 =?us-ascii?Q?Ml9NBkkxbLGNCcUSMsclMMT+h39gFvqL1StfRd8F0DWDFwaeCLt8hgsp4akh?=
 =?us-ascii?Q?wzapFth1m6kHxoZx4kOHbhHmMTQVxBvtqqUfNySveHP9XGVqbh6kQIRdA/P/?=
 =?us-ascii?Q?R60xpuLHYeMGetFkT5WkzL1ejHIrhZ/H3asEbctUfClXq8SMvxVBJadTkOQ3?=
 =?us-ascii?Q?gA1WSUz+ICp2XQd7Xfj2/KwWrQek8cX8URAqb0RsUPvX9R7yGKBEYaTfO9kP?=
 =?us-ascii?Q?Sm++raq/LRSnDnvKP/9PXZV3+9ibszeXjxhSy6DlK19LA08bUjkOrQV1bD1J?=
 =?us-ascii?Q?1RPZOYxe2SQMvjKuUuJyfim3QiEtv5PKFwNUI0X5sLV2njcApxFpcTD/+Ssl?=
 =?us-ascii?Q?U5A+2vjFNswjVbmf51PTIJKmVXOs4EIXgeHH19PLhJXA5gfSYDmUfkiy0xEw?=
 =?us-ascii?Q?8nlRHP12TmtKWukdvX9rlbSLKosM9MspC/XFXougCNFeRcMD+vBxwysZJ5AL?=
 =?us-ascii?Q?PU7iew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ef9daf-c58e-4630-f969-08da009a7eae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:57.7956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1UWG7JCCPDursQZBpl6aQXWqGXAwi6VtCVpzqkRJP7AxKw9uJgG8acRudrtiGD0fH2WqVxKNovfTEDJ8K3+Mx0NThRb9NEAQnhcziyWfRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: 2o27SE4w0oEC5uRfDXm4rbeL68X0d_EB
X-Proofpoint-GUID: 2o27SE4w0oEC5uRfDXm4rbeL68X0d_EB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the recv and xmit works to run from different threads if the user
has set it up.

This also removes the __WQ_LEGACY since it was never needed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fec64cbfa4b6..0a0076144874 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2824,8 +2824,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 
 	if (xmit_can_sleep) {
 		ihost->workq = alloc_workqueue("iscsi_q_%d",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, shost->host_no);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, shost->host_no);
 		if (!ihost->workq)
 			goto free_host;
 	}
-- 
2.25.1

