Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C323C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiDHAPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiDHAPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8FF132E8D
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237Mi1qN014716;
        Fri, 8 Apr 2022 00:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=1M24vPleLG7MciYUETNjK2/4kmRowB1PxA1K4kdm0a4=;
 b=wdfZYnFF+RK87ldQk3VXQ0oe4syi7dbZGf/WbocD+xPN76O5EV17tabezr/+Q9DUebsE
 HMdJrREqa9hCrqDyY904kh+XNrfGOPseGReraEfmuscV6FP8YQNw1YBY4seCPWOV2ZJq
 YcJx2+AkSY/tYyUFxisg4WuDxSYBJv0Eq70YDwIiW7HHib6YobX2ZkWfP5Kj1c5RWc4s
 0ZivY7ITQX6pKVF7AdnCaCAuEfst3Na9BOZ0nG9mdNqihXHMRXKVhaJvKzyOzYsuNMy/
 /FvFfhiIrn1x/jku7bs48ebVrnrRyi2aT7ea8Qw6udONUvc/75Ax8gYFqtqeKNmWXAKR tA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9w454-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237NFHE2013838;
        Fri, 8 Apr 2022 00:13:26 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tu11q5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxWG3NVTtpUYqNrCGmgB6MuAoSXNi5e7oSNYoJnke9VFYR5xQaVuvhtRsBUWJU3pbG8XcZHwHJwD3SWjHi5iVhOx+sK6veI0kPvJ84cUXn5s9CaJ4vI+4hyxh3xZbywV4Xr/7z0UGEKL27evFC39LfRRTIvk0s2y0iDXrn1Jrqx/ILfjW3/rSv9pxrbhcyboUtrSpdHIoiMZBeSAPwtrPLrAj+smJqZwsPvr4R5EEMuWu5GQtZKYlC1MnGj1C+EY3yZw8UguwfU4isHcg3+/IhBcwKkRwtdUTRo6bZ3wAEBlO49tYb6PhncvJlIlwakBEz8MU3SV3kyxfoojdwXrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1M24vPleLG7MciYUETNjK2/4kmRowB1PxA1K4kdm0a4=;
 b=SoPBHTaFImC8rKLyy6/Qm21DKFvPpPImLHNW5Cvt1IjuA80XhixbQPoW0edZUuopay8jGjS/fR79MPxWAOfmhyDPMjMDR51QPgiKOxOpmSurLfSyUh3nyfq1sYTSo3Vy+drhVWNhUEppLNVQYNhizMYNK7LC55bnuE8AsiZlxL+ApZk5TeSS6xdUsafCkllLXEN62/3bielDERhEkz25buotNBdIjq664Etp8U+YsbSgZhO+LYq9rtD0CnL3S9zmCcvigA3AqQPLQ3wwRNRjF69n5o8WE+70CQ/BMfbJRaA4Npq/8Fu28LsWKLE6eDoMQzfB4QK4IQWwb5LJIktgCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1M24vPleLG7MciYUETNjK2/4kmRowB1PxA1K4kdm0a4=;
 b=T8oPalAzQXTL4yz0wJLIovUyAZgQq+0FTPNnwtOd5zzbC2+vgo16z9VBNArm9IIhzONrcPIATV6gJ417ZCNb5gtWw+nxGmcNPk9ON5LqbeLGAI7RTu3ei0ZCBB+3zpHkmvL2YAIRDTtauZ/Y0+VZWVcF85dgWY7bDYgslMEHCnE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5550.namprd10.prod.outlook.com (2603:10b6:a03:3d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 00:13:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/10] scsi: iscsi: Release endpoint ID when its freed.
Date:   Thu,  7 Apr 2022 19:13:07 -0500
Message-Id: <20220408001314.5014-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e819591d-8d4a-4e6c-77ae-08da18f498af
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5550:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5550F12C8C00133E6B488CA3F1E99@SJ0PR10MB5550.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4DJvJ0R3R/9frL2HGytNdh5ovycTWELZ0+akv0VhMWibIAjNShzQSPUWKxNmfDmOO8hYFrzEIiWmcmPUuIM/5SHINoMVk9rY5Elooi0uVt9Q7tGCL08QJ+2ZXCTQsqJ50loaEIEBY7oJJKGJwGOSvtV82ykl6KHcACAbgDH6CQLrtys5U9kau9dXsxHsdR8q1h7L0H1lobGeXc8MfmtSwJxfBXRiJW7FBowQ4Bmxctc4a2P02+doXQuQBD5dAKvdWumxMrJWCN2EnxwJ87qmYadFWYrsQnFQib+uUPlNw18ZQ4hOWe5be6VkqyJgsTtYZqDkZ93q9hupr30AECUbj5EhvS0OpUcEsKo7lYxEdWwTetZfZWy6M1ot2gSTCGHEut3mKxUo4z1So7ZxrldhX6yks38U6LLfSbbAqEMWhp7DVngkUaAGLslVAaPhB/1YNLNHC7HFZxJqMxTlrPM9LyNlNCrCBVQtDYiGDRbqwuOZxt53Pi00y9ItqwIq8flu8x6TqLBKImtlSnrAE/xCTLiz5uhSRWyPsd2gfG0MRO1tmh7+FdM9aqTgnioB6XsH1nxwqRQx6y5M6wj/kuL4ahKI6xuYPxkcaOmpXPzOn0NuZlyWAsC4jQp/WJb1w+LKZJxpq1FYECJwkUuL4mjemyi4/f4mvbWiqgetsFBwSQnQvcMFeD2h8huMPvvKtoi2FIaU4sTlS3OVLYMHgaVj/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(186003)(83380400001)(6486002)(86362001)(316002)(2616005)(6512007)(5660300002)(6666004)(107886003)(36756003)(38350700002)(508600001)(38100700002)(4326008)(52116002)(66556008)(2906002)(66946007)(26005)(66476007)(1076003)(8676002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?acvVqANEn6yq/Usu8d4Mg2RP9YdyTE5gYCHjmeq6O65SPu8z3x/agpc7z/f5?=
 =?us-ascii?Q?GMe38kY1wxfVbayQOEC5noiUlonehEMf5FvXkGjG/vmi5mJcwKgJeP+c3m4n?=
 =?us-ascii?Q?b6CLR9aUKHbs+4XZZP5jFbHp/l65Pr50cV0uWLk0SgtokyDWXHwi7nghC0fk?=
 =?us-ascii?Q?5uGH5DJizjXyj6T1MtiL0xKDSuIa5aKQuGJB3/sFdrZDci+i6V36XwTfHAxz?=
 =?us-ascii?Q?QRzsMX9k4YtOr4Mn65o32/K9W/UncQUS8UTdL0B57T4xD85IRyrEqMzV1ABB?=
 =?us-ascii?Q?4352MckbiirdNy++0OGBxPEaawqakUR5yU/0qfXFdxEZjV7joR2XmvoQUlrd?=
 =?us-ascii?Q?HpYcAF8EWJMYq3hdJ5uG1bajCGp5oKH6D931PMf5bpjm3YKk7dShUmnZXNan?=
 =?us-ascii?Q?ll3qE9CiYINAmE6FrZErQ1UNs1nCW4CudQelkH61dOah3lcGyMrq0OGig0jX?=
 =?us-ascii?Q?JFw3747JNnjIK4MDkI8cL2QRXXvdstswU+j+tYxkwSZ436Gr5/WoWPhRuP9F?=
 =?us-ascii?Q?SWNdUeTBKLerNTKnTI9NYas962XWEfvMj8YBhc5oCMb5Ra97Gy/US6AiW/H0?=
 =?us-ascii?Q?Vw2WUEzi2H73zM2qye3FxO3KvOnGsBHLWjQgO+eyTnMJtUcQ0g8nf/Yka8O4?=
 =?us-ascii?Q?CqjzDS66fW/JvJL7lNUBc56lfMnjtZ30U41KH0xQvmZpGMu62838P6zYNrpr?=
 =?us-ascii?Q?ANxtzJsqhdyiEvowRbpiMgLa3Mhd9VYL02opqS2UaJ8djm30MdM74q6Ye1/d?=
 =?us-ascii?Q?w5WCENAr20fBy5KNpR8ujA/sQHk+HKOj8OSngrMvWuz4KDhQqcZyls0LU9vl?=
 =?us-ascii?Q?BUhJHUxoTP2evfUtNW+BaH9+cKxzyO1sDRIIiSD0rLH0yGqCNtgHWSEGBGQc?=
 =?us-ascii?Q?xy3BF21J80nKUw9oKfsFnz5d1vxZp2gjSXhIlzatkhe9cTV3+BUW9iucUc1V?=
 =?us-ascii?Q?mJkGbU8CpJulfAQdOWmouQeSAOaiMt/aCaXHeGHLlaj1PHzgPncfwq0y2JT2?=
 =?us-ascii?Q?Il5ZC6a7LOs1EI4qB6gLGLpW8xW43uk1iow3bpgNBaxmK6tWztfi3HfvRdw5?=
 =?us-ascii?Q?W8BwSM5tEqW3zcwD8VQ5YJTQU75UdPpfpS/nwP3UwaxKW+VOpzSudisDoP22?=
 =?us-ascii?Q?9tIPykdFpGc63t1GO01WaS8qjyjbHrfgUc7z7EbalqquetjDCcUskd3j3neP?=
 =?us-ascii?Q?MqILP56XOJRecU9PlbOVMwQpJGug6ftobfo73Gf8runz6vkkOSP0jZA9WMGm?=
 =?us-ascii?Q?rnwkgPhfc9cAGqhXn1MSrgFlG+lsMtL07Nc87dYahSUGQGEo/lswQ3MVi6yp?=
 =?us-ascii?Q?ZyLLvnbjWAu6VI/FFO8NsjHi74ES9kK7yWKb7v+VVuTcRY/JpNFS3ddqDPjS?=
 =?us-ascii?Q?njc/ZQCKa9NlvfUwEPoaagoRFC8va4Z+abIByBSJSu3u1alNqilGrrYOIS0r?=
 =?us-ascii?Q?GJcJ+TPhSnKu6VFliqKZwwC5eQ2DIpS96sse7Ytv8I74nda7D7K44FeTc5OB?=
 =?us-ascii?Q?E9FYLLkk0pYnPF4T/Q/4oqVEXeoFHRoNZuiC8fHz0nLXht96QXNMzox8gjtR?=
 =?us-ascii?Q?yCTxn4ZvXC4yT2MKX2r00o0N5z1UgWLqb/W40qH+O+ifLwXhl6iY8qIQy0Q1?=
 =?us-ascii?Q?x44cCmMjcQMXHyU5mCr5UPIwbCurWPuyo9aQtMRm8eD8zS4LCY+M+FS8n8lB?=
 =?us-ascii?Q?c6R+n8BWypsz7+1B04hU4LBTJQFmDwZPgjUpxDtPwSZ/gzqHrUJAwAeKLxe0?=
 =?us-ascii?Q?cexwlhB1kjN46AWTrh8KL0rVAS077yk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e819591d-8d4a-4e6c-77ae-08da18f498af
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:24.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2MxHDCtT095o9zsJxAnt57Gm9v9RasmmRKCur0rUwojEWA1DdCOa6J2I2sfeqlpeuTAEfy76Uwyc/9DYIB+rWvfZVv2qxm4UT5kpYcbw8wU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5550
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-GUID: iC2bSY2zOUrz1sAbZuduYmUPiZl7hHLo
X-Proofpoint-ORIG-GUID: iC2bSY2zOUrz1sAbZuduYmUPiZl7hHLo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can't release the endpoint ID until all references to the endpoint have
been dropped or it could be allocated while in use. This has us use an idr
instead of looping over all conns to find a free ID and then free the ID
when all references have been dropped instead of when the device is only
deleted.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 71 ++++++++++++++---------------
 include/scsi/scsi_transport_iscsi.h |  2 +-
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bf39fb5569b6..1fc7c6bfbd67 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -86,6 +86,9 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
+static DEFINE_IDR(iscsi_ep_idr);
+static DEFINE_MUTEX(iscsi_ep_idr_mutex);
+
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 
 static struct workqueue_struct *iscsi_conn_cleanup_workq;
@@ -168,6 +171,11 @@ struct device_attribute dev_attr_##_prefix##_##_name =	\
 static void iscsi_endpoint_release(struct device *dev)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
+
+	mutex_lock(&iscsi_ep_idr_mutex);
+	idr_remove(&iscsi_ep_idr, ep->id);
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
 	kfree(ep);
 }
 
@@ -180,7 +188,7 @@ static ssize_t
 show_ep_handle(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	return sysfs_emit(buf, "%llu\n", (unsigned long long) ep->id);
+	return sysfs_emit(buf, "%d\n", ep->id);
 }
 static ISCSI_ATTR(ep, handle, S_IRUGO, show_ep_handle, NULL);
 
@@ -193,48 +201,32 @@ static struct attribute_group iscsi_endpoint_group = {
 	.attrs = iscsi_endpoint_attrs,
 };
 
-#define ISCSI_MAX_EPID -1
-
-static int iscsi_match_epid(struct device *dev, const void *data)
-{
-	struct iscsi_endpoint *ep = iscsi_dev_to_endpoint(dev);
-	const uint64_t *epid = data;
-
-	return *epid == ep->id;
-}
-
 struct iscsi_endpoint *
 iscsi_create_endpoint(int dd_size)
 {
-	struct device *dev;
 	struct iscsi_endpoint *ep;
-	uint64_t id;
-	int err;
-
-	for (id = 1; id < ISCSI_MAX_EPID; id++) {
-		dev = class_find_device(&iscsi_endpoint_class, NULL, &id,
-					iscsi_match_epid);
-		if (!dev)
-			break;
-		else
-			put_device(dev);
-	}
-	if (id == ISCSI_MAX_EPID) {
-		printk(KERN_ERR "Too many connections. Max supported %u\n",
-		       ISCSI_MAX_EPID - 1);
-		return NULL;
-	}
+	int err, id;
 
 	ep = kzalloc(sizeof(*ep) + dd_size, GFP_KERNEL);
 	if (!ep)
 		return NULL;
 
+	mutex_lock(&iscsi_ep_idr_mutex);
+	id = idr_alloc(&iscsi_ep_idr, ep, 0, -1, GFP_NOIO);
+	if (id < 0) {
+		mutex_unlock(&iscsi_ep_idr_mutex);
+		printk(KERN_ERR "Could not allocate endpoint ID. Error %d.\n",
+		       id);
+		goto free_ep;
+	}
+	mutex_unlock(&iscsi_ep_idr_mutex);
+
 	ep->id = id;
 	ep->dev.class = &iscsi_endpoint_class;
-	dev_set_name(&ep->dev, "ep-%llu", (unsigned long long) id);
+	dev_set_name(&ep->dev, "ep-%d", id);
 	err = device_register(&ep->dev);
         if (err)
-                goto free_ep;
+		goto free_id;
 
 	err = sysfs_create_group(&ep->dev.kobj, &iscsi_endpoint_group);
 	if (err)
@@ -248,6 +240,10 @@ iscsi_create_endpoint(int dd_size)
 	device_unregister(&ep->dev);
 	return NULL;
 
+free_id:
+	mutex_lock(&iscsi_ep_idr_mutex);
+	idr_remove(&iscsi_ep_idr, id);
+	mutex_unlock(&iscsi_ep_idr_mutex);
 free_ep:
 	kfree(ep);
 	return NULL;
@@ -275,14 +271,17 @@ EXPORT_SYMBOL_GPL(iscsi_put_endpoint);
  */
 struct iscsi_endpoint *iscsi_lookup_endpoint(u64 handle)
 {
-	struct device *dev;
+	struct iscsi_endpoint *ep;
 
-	dev = class_find_device(&iscsi_endpoint_class, NULL, &handle,
-				iscsi_match_epid);
-	if (!dev)
-		return NULL;
+	mutex_lock(&iscsi_ep_idr_mutex);
+	ep = idr_find(&iscsi_ep_idr, handle);
+	if (!ep)
+		goto unlock;
 
-	return iscsi_dev_to_endpoint(dev);
+	get_device(&ep->dev);
+unlock:
+	mutex_unlock(&iscsi_ep_idr_mutex);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(iscsi_lookup_endpoint);
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 38e4a67f5922..fdd486047404 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -295,7 +295,7 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
 struct iscsi_endpoint {
 	void *dd_data;			/* LLD private data */
 	struct device dev;
-	uint64_t id;
+	int id;
 	struct iscsi_cls_conn *conn;
 };
 
-- 
2.25.1

