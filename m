Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4FDEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243349AbjFNHXi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243337AbjFNHWq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEEE2708
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kCkU012076;
        Wed, 14 Jun 2023 07:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=WaqqMVzCBGxC+EJtedsgsFpRmiuDCvfonBqDWNise4c=;
 b=Jrqm38ee8BBCqB/Juxc2l2tpnryXiEmkQsomxVvB4ZjPszj85QTCsAh29P2bKcYDf4dS
 mFqm+jFDahBAHLiJVhw8xQ1RYDLsJgF1SfyKaG/YfLU/BdnDv2lTwC/8c5BlF66SQ+q6
 lviXwKv5Nf/cCL6zLxer9rw+rSbdEOk//mAIJNopwznpWdd2rBLUpMF7+an3qdGdxNIB
 P80yd0YOyx6Fnr3e5hEoeXvx9XPOqAUHAnbqiBjjkfXjCx1Iw14rftecZhToqBNXsg7L
 Jlp/YJk8CRulqwjW5srKvnVxzwFCukeecd9jMrrisbH4aXxjLAW/dmxsddYOaAGiK18y Yw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fs1xxx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:38 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXh021593;
        Wed, 14 Jun 2023 07:18:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J04Kmfm0FrLo8x+mfN79080LeEtne2gpfzMz3HhBMr7BRG5z+1UI+HLQVE1BZjd4zrhymLi/oKFsNPETZKeM8yA2b+a6JEb8nA8n2ImLKz7FgRHXvjsJEuvrePv4pY4xFcCj46joYX3dGQZKFo8/ziSPub0sNF3TbiKwG/ZsVkOsI+2ch73SJcsQ2HNPFbRQ7fWTbMJ++xYJj3JNTOtPP3F1PcHIXpdcUd4NjU2DcZmsA+pyVP+b854PIMLD0uUwjY3DBR8HrzqrC0Am05hQDAhylMJMO9CoeI1znYSdQGzst1YL+jTyXdCz9A3L15HCvgrHxE7kVdJl5nHLSIsb8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaqqMVzCBGxC+EJtedsgsFpRmiuDCvfonBqDWNise4c=;
 b=QL7hyEOYHp4jhgd7l7KQEcV8zgcwrxEKzairGy34/Bwd/WeCzxZ6NR43fkoMwsmXY3YUjcqEOYKuHl1eiYJaDfT0tXvcK5gGzf5S8YhCQFurKBsjfxRPm0VOsIrerAohJ1f5P63OvXDGrxwyuFq9ra8gNLbALwZRgBorLQX8r9l50LuoW9E2xo15mrL5rt+qBi1j9LxBzKenYg2ENV9HYRoAagtiVkkh68bf2JWzugdhcWNRAdDQpnXN5Bx9KfCr04mRNL5vvAx0cFZNyups8jcuPuAcCp8braUE/XIZfeoAry3zn5mFEz796cetEAXp8+QWaW9btAG9/ryrke436g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaqqMVzCBGxC+EJtedsgsFpRmiuDCvfonBqDWNise4c=;
 b=xPD4I4JVGhqG6nTLwUkbO3zQVb/bzGrQq4kvO1N09v1ZOShpC4uEYEBDbH2O08iJVOzBft/dgfcjj0SK34TnA/+cbZPk70FakrKj/hzDAfME39LJ0nBJJUpgeVV8TKV4+mRFq/QUTc77rnagkLbSeLBdHjXp/lVtLEYGm+yrfxQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:18 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:18 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 33/33] scsi: Add kunit tests for scsi_check_passthrough
Date:   Wed, 14 Jun 2023 02:17:19 -0500
Message-Id: <20230614071719.6372-34-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0180.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 87874479-fc64-45be-6bbe-08db6ca78728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Y9M01olw/dX6mWIHhfuncyECuac1zFWVWAjRGC09LP27iC5xyoFihKsRM6Bx6bXfqtsOlGJJzkrJSZhwxRd1NemW1Zv2/prNq5zOpio1MUW0m2IITnMJqyGu5JkR4+QYRzdHr76K0gUDcTglJYdBYneXIAvYql93B/nhsiorkME1Ad7K59XT22N1BR/7rP1PxANmo6ZZO3IADcPouRk7KMzM/XRar8U5HKvq2GidhSwNu15CMghoS9yr19nbmMcdXmhLhmhEORfR8zJyU8PYPAJGXeFjN50zLQFNugBlTV45Z9LELFBK8zl/LinTUJeI9yf1kMURFMWya/N8Kq4o873qak4VNFJupHMQKVXF+YCmV3ScEqE7P/sLy9lrG3wdSwGYkg17lO7KGJ2LwzzwN30thysMsQFa0ZXt3tkwq1g2Q5sMhVJ3u6mdXsIMVzmWVaWkFnIJaJ4UW2oS39dg+QJsgl2ZW7mMhoZjujsOSUwNwf8B/gCxY3AJQZv9flnKXHso8P/rxJoHOW0mAd8K5HCLsRPqr8eKE4Ovma6+1uEsE1Ci+kxlKjYmPDU38P3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XsD3cPxsXg0F1vU8/ItOz9QD7QDqrF+njUMvxeFfSt8EeD/zmx2ghdKDJemG?=
 =?us-ascii?Q?fHdpqG0OCdLDMPIdCQZjDdc0G3D5x+vm08xHc469b4DTCTAJUamZ2vAHLaV6?=
 =?us-ascii?Q?u9FzfUcHB1Rsff6Om+alc6Bug6nHw+xP76ECJhevTK3HeS39w/QS6RAWce3R?=
 =?us-ascii?Q?N2FQXaHgzgSepqxkeMQVEu5Vf083OlFnSAs3FXYG4rc4hYLbxBCunoz4ZUZa?=
 =?us-ascii?Q?HztnfLqJxR8EriJB+0xPmW3qJCxLlyzVIFDBLoUDp03/mRsN0fzQYxdrAlv4?=
 =?us-ascii?Q?hMLuAECnMR9q3A7ez8e8W/szvbpsGALNbceM166JvJuk9RLqgqG8e5CgmVsa?=
 =?us-ascii?Q?mq3Llneyl7/2j1I0HzswCDve3c7C9M6fUMF7aFrVpt/9k1LOCS54O04wd0fC?=
 =?us-ascii?Q?aipgOwJUIh0uJ7qhikKJ41MusG/3wtlm/mREApgbTdJUr4g0EngBoV7s1APb?=
 =?us-ascii?Q?sYspIn0F/V77gCQCw0LQZh25SgajV/CazsFiESrPv97CqF/ND3S5Y2Uy28lT?=
 =?us-ascii?Q?9kcicMMwmtAz+aSCuVx4fskDbAk00sM8wEBJmig1UEo9YEfwKLsgIdPazU/d?=
 =?us-ascii?Q?0urPJRo+yIjj8DqRfxb3uuLPjPfPX0F/gaPEoUmOi3wGcnj+4DpAzU+cF20p?=
 =?us-ascii?Q?Sr7hjQpyPsUldM86VlA/LEge8CFF2IVxMU44X9LOArn0lGIjbcAv1qfiXz13?=
 =?us-ascii?Q?ozffZn07H819h6O7PTXBoWEqDMlLetJWKip7N6wFP62tlakDea5rI2yikxEu?=
 =?us-ascii?Q?viLe8QHi9wtz5PTAwQ169/LZ0yJ7MH2x3E9LajnQpc7Q8bhvU6l3jVmIzM9u?=
 =?us-ascii?Q?6dWWBcw1bYJRjKZlKs+xa9VKk8Nvui4YPiuwzEyBqUu4UZhi4L2lwU8EnVym?=
 =?us-ascii?Q?BiwCMSGNpErRyLngYKY1XbmzP1/IMXATcpCzn6ssRIx5WMYonVal3JcZHG6y?=
 =?us-ascii?Q?Vj5NNESOqD8xHlpSMi4F+7KlxEbve1RZHfk/dAd7FtlVjg7TuGVuSy1x07iw?=
 =?us-ascii?Q?e6OC3RmX2pPFCZw7dqWHGMNZsz9H88enQH7OKvjVGnDZ6by5HWa6Z7bbjEvH?=
 =?us-ascii?Q?EWZSnOOdOnji6c6Yy+2COiMqGs9tENFnIDxmCcxpRLuAMJVxrioVIaGaYwA5?=
 =?us-ascii?Q?jq5XN4anSGzWQsfnKc3AYn+Wcm/j4wCGGBrzdjsVROOD9N/eMLU/EjgXD3d2?=
 =?us-ascii?Q?3tUNgrrRFEKLQfdLnsC7/j9aLqeUpkW8yI9KYWbnXyN2zGYUnCVPbgRRtla+?=
 =?us-ascii?Q?XWB1ObEYkGAGn/poKnj4o3yqwkXPY0Xs4uQzWlvkMD62VPB3yPeJIGa4HDdY?=
 =?us-ascii?Q?qt6oLkH3PmACQKF3djxx90WaAiBEtMy+FVKS30TKZYwyvSrZdx0lSL3Y+/2g?=
 =?us-ascii?Q?StpWwjpDfVKVzUn9cN6jb5n41gD3IfN+W/X/VsoivQ6k04SSYUPU66kqMAzl?=
 =?us-ascii?Q?8wxVu5McjWQrj1/vfs2a/c1ldq6zG1wAH3mY1+YkQOutw21pv5QIqVjE4ram?=
 =?us-ascii?Q?eY5ucihH6lQjicy2/1MfVjj0vKFmlfXGZWlpnPY9fjbAqUMCX0n9xARXLBo+?=
 =?us-ascii?Q?hqND67FiHIV5x9mNtAXhNzXWItndKLlaZy6wOetNLfl9s+gyxyZqejN1X5Sa?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yH+dXuhJd8Oao1KUGzxcKXrTwgfciT0wrItPqLdP8/BTm5BYoLz/qmDF14t3P9VrzSt6+uU9fF1KG38kHCD2T8pxlyMOFDLuXSDv0+Rpz0Y50sDbJvQYAnNS8AhntgO8mldojSjm7TcuVQsuc1LyC/RpPpWs7RnaswiqFT+diyYMqlpPXw5vYPlU0lZE00VWToAt0ddB5AxUx8LO+pWrMMDseuK5QaBxRuyMYEWEB/N/kmjJp4PIUvSq5T1znMXhaZIwkbkEdiRrBnYUNMm5rNElO9IxnBGqjmGYqSZo7LfOzpo5kCE8tDzLhHJmacI8YM2tL7IeDiGm+4eYfeA2sQIxC+dOKgxnXbhPNk4PALqIXiQk5yvJR1MXmLDsroerH8FW4UmfIAUua5YUp9n2AM7n3uulekMfeRtn8g2xEOitZnm1YzWhfPSkfK9lxVEncmnDL+tYvP3ueW7MF1a1jicMqh0uBz//SqgSwZAqHLxELJPIeVaORCYTomT+xLSvwNySd8XlZe/RpWsGEUPkG1R4azv+Elo8olx4W6hcedRNw0nBfEgzJc6W2DWuJNI749IhkRVT8cYRr1JSWKQMb81nAJ4iEAVXEOpU7iZPJ5XjCX+8Lkz8T1G1j8V46nuubgevrzZBS4T5tk4K6tP3gXK7cOEZyNgW/1/ItpXOM1NI26+4DHQW3J9bCeB6pPdNFJa+v5187Lfif+5OGXxLQ45vafEjmWToGDoWwTggyc/0eUTnXKiL1FDnodhx8HqnM3igQYsDY7Incl4sibp1yi3s8TExz51xk6fCDYWo6RQBwv74NxztuP0I6F6jZWY8i9EZny8OQGoDNfjn1+2yzEwAaLziED8DDoB/m+sViZFvmAEl8rYCB5NYaffHMGgu
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87874479-fc64-45be-6bbe-08db6ca78728
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:18.6918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXvby/UKrZlswkcStb1rAcO+ys08vQl1JksnG1we2uPgGYVKJwCiH9cSi+IXpUgxfbSI3mW6yrBQoRd7/1fvBYoA08vWcgK0W63vLYKzRS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-GUID: 1dbxEkjstF_uI8piF_sf6nf5hmLAKVmM
X-Proofpoint-ORIG-GUID: 1dbxEkjstF_uI8piF_sf6nf5hmLAKVmM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases it's difficult to replicate in hardware or even
scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig           |   9 ++
 drivers/scsi/scsi_error.c      |   4 +
 drivers/scsi/scsi_error_test.c | 170 +++++++++++++++++++++++++++++++++
 3 files changed, 183 insertions(+)
 create mode 100644 drivers/scsi/scsi_error_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4962ce989113..be9b6eb2fba2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,15 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_KUNIT_TEST
+	tristate "KUnit tests for SCSI Mid Layer" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d2fb28212880..82111cdeea16 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2663,3 +2663,7 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+#if defined(CONFIG_SCSI_KUNIT_TEST)
+#include "scsi_error_test.c"
+#endif
diff --git a/drivers/scsi/scsi_error_test.c b/drivers/scsi/scsi_error_test.c
new file mode 100644
index 000000000000..951fec0fdeb8
--- /dev/null
+++ b/drivers/scsi/scsi_error_test.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_error.c.
+ *
+ * Copyright (C) 2022, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+
+#define SCSI_TEST_ERROR_MAX_ALLOWED 3
+
+static void scsi_test_error_check_passthough(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failures[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
+	struct scsi_failure retryable_host_failures[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_status_failures[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_sense_failures[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	struct scsi_failure any_failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_TEST_ERROR_MAX_ALLOWED,
+		},
+		{},
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+		.failures = multiple_sense_failures,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_TEST_ERROR_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	sc.failures = any_sense_failures;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* reset retries so we can retest */
+	scsi_reset_failures(multiple_sense_failures);
+
+	/* Test no retries allowed */
+	sc.failures = multiple_sense_failures;
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, SUCCESS, scsi_check_passthrough(&sc));
+
+	/* No matching host byte entry */
+	sc.failures = retryable_host_failures;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, SCSI_RETURN_NOT_HANDLED,
+			scsi_check_passthrough(&sc));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	sc.failures = any_failures;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+
+	/* Test any status handling */
+	sc.failures = any_status_failures;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, NEEDS_RETRY, scsi_check_passthrough(&sc));
+}
+
+static struct kunit_case scsi_test_error_cases[] = {
+	KUNIT_CASE(scsi_test_error_check_passthough),
+	{},
+};
+
+static struct kunit_suite scsi_test_error_suite = {
+	.name = "scsi_error",
+	.test_cases = scsi_test_error_cases,
+};
+
+kunit_test_suite(scsi_test_error_suite);
-- 
2.25.1

