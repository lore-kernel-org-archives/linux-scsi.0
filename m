Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040C8C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 01:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbiHLBBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 21:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiHLBBH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 21:01:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFA97FE5F
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 18:00:57 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6D1V002866;
        Fri, 12 Aug 2022 01:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZcNnnFZCVYS2fHrwAKP4btbO5qxuVmfOlo2VbqzM0tw=;
 b=Pz7oh1qDF6qZk0jraG8TA/EyLVp2Q70h47wqTUJ+LNmnYzsvHzbrWkyzt51GeM0rUV9t
 GfoMZGv6IYdVCRKOQnlrrS+UkQLV4hQvXlT6KfFSBdYrySCD87stmsKJXjyCy/JTOjjC
 GnGyHmw1Xznf2K+1pj1xTjiKAuJgf0rb52bP0foQhOq/hYk2JPKOInue7rmVPdTpEw8C
 a2608PqVigYg+/o8+L3lUGW95byWmyQtOhFKc7lXJHPoM83oLRJsVTnOeCqO5rwP+TMb
 pp3k8H0ZsO76BRXC+zyF32U8e0GhtFy4sJ6HluYvEPboVb2/4FYCFqLwBxPsKjW+1L83 og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdx97m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C04kYD020473;
        Fri, 12 Aug 2022 01:00:45 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk6bmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 01:00:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaIxI9ll+dMgBCFtJuuK3jS8nUQsark/6KMDcPzYHarm48h0bO8Lkp8fiUHm1FbC9acKnq9ZDRz2A5TwY7rS9sPJUyEp6prEhARdYi2ENKmD1rAbj4cp+16mhIIoreoql6Qu4L1/U9pKJZsP0+dIGuKjf3UajHr0q2qo+FM37BDljj4Yw6D39gtYCh7uh+lgtxluzlZWGl1e+cYa3gibmvkrXwpmH752cfw7XBle70Ag3RD0Xk25CZizRl9/UZvZzE36+VzmtW8qtof6PCsA2pgYszkzpxaGEeqeR/urQ6eErpyrFputrH6vhZto17vjyIRnXkdacPWPrG5zqQwJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcNnnFZCVYS2fHrwAKP4btbO5qxuVmfOlo2VbqzM0tw=;
 b=KFdIYJaeTE1ajfrq+KjS0alCXc4gp3/bRq4VGwpr06gCZcCZGiTYX2VOK258Em0CC9TMz9lVM4Rx+lvF8ZcLDYLnTeDV1mhob0ifjxKCMDCIawN4uzcVT9xoKM0AChvciFizejENvO6IgbSi+sMPQitaBlyjuo3omW3PITj0PH6/hEcCX9ZnxvXZjhEakBt+VYlGMuW5P33QGp9eGBDur3w+Rr9a0SxyipAGKP8QUeMNG+xLMwmMrXuWXXvcmnuDRAzriqmbkXrmV0ryhEJe2BFoKzk+uliNq3dqYjLdMNvKEPiC31ZIeim80yHiz+Vj2j+7vax6lVK1McGweJ0vRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcNnnFZCVYS2fHrwAKP4btbO5qxuVmfOlo2VbqzM0tw=;
 b=Ag/E3tf2orUwiPcVEWui7CI/lD/7Q4ypg6x3Nh2HN/vahvPAVsSvEbHVJHpgvgFOIugbPfQur9bo75NVRRebSovfqMf4DSZ5Zjltc4gIib8ICsAXh5XjYQXfj2JDTkpXXZxbmnkk+5UEQWPwcaCFBI95VfKpalnHlf54bb+VyhI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5386.namprd10.prod.outlook.com (2603:10b6:610:dd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Fri, 12 Aug 2022 01:00:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.024; Fri, 12 Aug 2022
 01:00:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 10/10] scsi: Remove useless host error codes
Date:   Thu, 11 Aug 2022 20:00:27 -0500
Message-Id: <20220812010027.8251-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812010027.8251-1-michael.christie@oracle.com>
References: <20220812010027.8251-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:610:4e::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 036fc111-ae9f-485c-3466-08da7bfe14f8
X-MS-TrafficTypeDiagnostic: CH0PR10MB5386:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYQUMyK2sxazxr0dKqqVPxT2LZvBQoSdHv0eYSMeSX0P4d/VBKeLPk5QSJmJYBW0iNFm3ByAtgCGq6YLXsyGW3f2iKiMC4PTxh/4YlhWbZPF2xRMqNAaqJrafn3F/gXdhYKFT5GeLBsxKp8LemUsBAnK5kwyKOVDyqwrdtQvd6Mat9hzomFtzEZE3Q576ufY2Y+ixONciZ3kLByFEaRlFmc2wAbGb20x2+wbdthoCTnw58xv87zDxQ0kOtJ7mwb8P7TfJcZ7yVw3wzFFhfrmX6FCDH9m9PJqHpcsJG7+hNZWkYBOtvRiwvC/W6zMC2Dqw900KfOlVkG9fr427K4NphiumP7yjSkTCA/at+wpdYbi2DUzK36RMbI9wzYQVhPY73FSswQOKZlmEHhvmflL47G95DtobbOL85B+cyloV8TUuz8fAtcdgYwQ94ptRcmItavS5dQwsEoYtxAcu5wkBAcJKwA+F2tcKeDgQDl/z3Npk5KCcR4khF03tjzAANvVT8HM7ypPTzIgKK+86aBy8AgAobH9ZtblTkaWFhpd38W6/ttAZNJ4XrGMEBCO4E3uQCBplMkQCDoYjazVO8JP9xGpmUbPPh3yS7ANHDO47bZrfoG8aoEc3vR5vZEXv1g50HlNY8aBVO8q3IJxHx+d0LgG59n0LnkL6gyNwmTIF0RvHukPY0PYdmKPDgdMN0vEEZYAtwZb0j2nVcfWO02QQDx1qW5XLQkUvvsah0Xoz3yXv0FT/fUPxcRTtwHxclna5ZylncVE6sIkboNnzHYokNZEvV8coKWPUkZKZde+FrM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(396003)(366004)(921005)(2906002)(38100700002)(54906003)(83380400001)(316002)(4326008)(8936002)(8676002)(1076003)(66556008)(6512007)(7416002)(186003)(6486002)(2616005)(478600001)(41300700001)(86362001)(6506007)(36756003)(6666004)(66946007)(26005)(5660300002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fE9fKyL4W4NHe5xpKjnQYEjDq7/wAb+MQaJUWCdb4DTFPUKRnzjKYIk6hZ+3?=
 =?us-ascii?Q?EhGahfQX6klcDQWidMOW8am7XJsossThHWQHKYnV7L0btiQ8S26cvD9kyjar?=
 =?us-ascii?Q?o9fL4+VfoziUvQbWVs4mAzBQQFUQBwB/h+CEvgdQtuvaJqIvN6VhcEEHhVbK?=
 =?us-ascii?Q?cwKqHgyERWTGNI72n358mgSv0ZzAz5H9qYC01l6TiDCLhp5q60AqTU29q31c?=
 =?us-ascii?Q?pCGZsZMzBxyXXnandihGrPkaHR40NZQEYri0lVZJQ+RwioLZBvgF2uPbmBk0?=
 =?us-ascii?Q?NOj9Ux6t7HgTniIQy6SKPWFBtMjH/Q6Nv8ZnCgCCkaAutU6JfUZnVL3oIIL/?=
 =?us-ascii?Q?6pcL2FtL5AQCmIcbMGUAQuURupXD5/3/eJ0VlXv80SkI3v2LVVzOLaekIJQG?=
 =?us-ascii?Q?Fx+fnRCCy6RzNuStws5FrMOSQXal+qry+wi2CIN9zXeuy0s3HW8Fns7YV/TK?=
 =?us-ascii?Q?YDrFBJMe+Kh8qvzw9lTLZGNge4F8Pkdbb/i8nlg6lOy2u6fGoWAhJs3WtYWT?=
 =?us-ascii?Q?oEgyn/SCTAZoLn2S3zqGy24hJsmVPNKOoF+km8pavVf5NhuzScfzGZn0Ovil?=
 =?us-ascii?Q?agCjnT/KEAcGNh25pdaWXexRT/t9AthO7LJG1WPFb3D5SQVPMnYlnlnyROY2?=
 =?us-ascii?Q?/dfd3+8wBMjsz0Crr5v92+hr/2I2OESo2qAMMAcvD/eRQYiaFDm4a2xQYrNB?=
 =?us-ascii?Q?9/KSVc9vUD+5SrJRrHgL03Oxs0ntKAVrGNniWNBX/cUBKPYn9Ng6PxZnDno3?=
 =?us-ascii?Q?UVy3dW/9usQx0rpGdWexI9WZrKQFHYzb8eWVPjsrkj3EtohZcTtiYl+yVBDh?=
 =?us-ascii?Q?09abe9jYj09HK7Ht1JLyI+FIaojxJbeyDxOebYB9zPBwXfWIoZN+3WhdkF3Y?=
 =?us-ascii?Q?qCQTperidgm9hGSt3+kev/FqUy4DQzOIpA163Jc5efzkKZu/hJiw0edTSBB9?=
 =?us-ascii?Q?pPRzUgnYaq2mr94erLfMjFG5fqbfysEhjEzA08sr9K6/NYFoaX68S5vFpBRz?=
 =?us-ascii?Q?Cqr9imZ7g5Fx4BexiMQy/PJnaRUDXey3zwDdxLw5jBvkPOSf2l4BR4vLpwzQ?=
 =?us-ascii?Q?Vf8OPDbmmiAqpoFm5uzEST8o91zzk+IJvVXunWvei7FGzeeo4b2ENF8GXQ/k?=
 =?us-ascii?Q?pibHq9ijEZ7b9ZOv/DWaFMKNdO/3Jn7xdc9gY2gTjM0sif7h//52ccIWPEPd?=
 =?us-ascii?Q?RT813fofjj5E7MggQsH6xIedo1BX72Kqz78y7g0YWBJZ2v00YL9Alr2zfUA7?=
 =?us-ascii?Q?tn+v2cQjttqydWAoKKt6OOG27JCc+Cgb8Ch0L6AnAcOu+m8wxexBtjWA0A5v?=
 =?us-ascii?Q?ILIocHwW97t5km2ZCqEsBOgMIkR9f9ZUSsIut6jPmK8eN9G+tthCw/1OL+B/?=
 =?us-ascii?Q?hOFf3229hgCefbLT10YC06b//XRi1gvAQjhdMhB+Qyyg0/Ubi02wiZBpll2P?=
 =?us-ascii?Q?AnMfmVKlahamLpS3iHnVb9QJt2l1KYkhuWGg6G4ISP3Nt5skk/2i4iJ1JsMv?=
 =?us-ascii?Q?vTv/+OtCeRxUYOiTNcjG0jidTAO793AfsbB53/TkCtq6RU8qWA+D5YeahfsL?=
 =?us-ascii?Q?Ganspfb3YVInRROKxnqQG0ce+V1HP9+QnMLf+IT6Uf/6vCmp3SjQi1QOhaQJ?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 036fc111-ae9f-485c-3466-08da7bfe14f8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 01:00:43.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQ5pwR5QL/q1WrFmhGjtrtZwxZs6yrrYqAdZSSg/JclAZYfOrSC91XcjN7nXDdx2fNSidLmh8JhzRQJBgqtgvKjaALZGx1ZlPA4ijLg3eLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_14,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120000
X-Proofpoint-GUID: mFDs75KZMz8-QppDAogb6VtXiC3KLOyz
X-Proofpoint-ORIG-GUID: mFDs75KZMz8-QppDAogb6VtXiC3KLOyz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The host codes that were supposed to only be used for internal use are
now not used, so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_status.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
index 31d30cee1869..9cb85262de64 100644
--- a/include/scsi/scsi_status.h
+++ b/include/scsi/scsi_status.h
@@ -62,12 +62,12 @@ enum scsi_host_status {
 					 * recover the link. Transport class will
 					 * retry or fail IO */
 	DID_TRANSPORT_FAILFAST = 0x0f, /* Transport class fastfailed the io */
-	DID_TARGET_FAILURE = 0x10, /* Permanent target failure, do not retry on
-				    * other paths */
-	DID_NEXUS_FAILURE = 0x11,  /* Permanent nexus failure, retry on other
-				    * paths might yield different results */
-	DID_ALLOC_FAILURE = 0x12,  /* Space allocation on the device failed */
-	DID_MEDIUM_ERROR = 0x13,  /* Medium error */
+	/*
+	 * We used to have DID_TARGET_FAILURE, DID_NEXUS_FAILURE,
+	 * DID_ALLOC_FAILURE and DID_MEDIUM_ERROR at 0x10 - 0x13. For compat
+	 * with userspace apps that parse the host byte for SG IO, we leave
+	 * that block of codes unused and start at 0x14 below.
+	 */
 	DID_TRANSPORT_MARGINAL = 0x14, /* Transport marginal errors */
 };
 
-- 
2.18.2

