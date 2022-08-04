Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BED7C00144
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 03:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbiHDDlS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiHDDlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 23:41:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D373F31F
        for <linux-scsi@vger.kernel.org>; Wed,  3 Aug 2022 20:41:15 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741i8Lh011151;
        Thu, 4 Aug 2022 03:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=HNokNoARkreuRPmaLBttJ7B8kDle+c3zaUCO4xZNAlY=;
 b=jMnfa6z2Pl8ix2dQy+bD1z6RiEcSVjzsqAsk6h+VxA1wyAaUl50VjginE/4+ozBYUwb5
 Fg3n+6a852tYQb80U9YLt2LJ3H9s3I3K8HeBjDRKFU/BQ+NQvIM8zq7S6g+8U7uD5SkV
 pyrDrCM7r7E6lIaVw8ELusYEMZerHY3yO2jkg/Iyc+JliLvMk0HdhHA+6M/XDkd8WHIC
 8WMNZ6pJhRpfqVqi0T8LIdShNGj7xQwLuvOqm9z8aimYyny2AN+OXmar3pAg8+3+PgVm
 BSqH+GlBEcovUI9CgjZd5uc85DzFIipK1pR/rKrCwcdxndXiZ6CScs2uK6FPcG2SnLBL Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmw6tkpw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274007mF006766;
        Thu, 4 Aug 2022 03:41:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu33m5me-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 03:41:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpJ53hnouM79C+vyIgQmbflMNZqWXqGdneOPzPTxRL9WFXGYgfs0woqeI/gp9pksY3rs95M5vnand8u9QJhNKmuldC7GpBnPQLn2k0gKeEpkiNzvZFYtp1NG+mfWLaZyEZRfeGaTNVdjmz7da0xAn4kY/oShSfWSUGR6eOLJGaMnzb0T4qU4TTkMalhP+UzOI/pBDa70xn037z8JXfHH10cIWB4bke+x+jfb/WuX6YoxV0+cdLi8xj+DB8Qy2mqqUnERilJfBshSxfT8GbBjDesiKGbEuxIIeNHiLqqcyZb4j1bT4u347BoUQP39EGyasGfhqJLRlUjfsVNdBjcuFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNokNoARkreuRPmaLBttJ7B8kDle+c3zaUCO4xZNAlY=;
 b=n0zS8lIr3eRzx9O9TgN0POIxMEb7YAZYTNfwkJQB+47j5/DP6AZLJBVInGm/PJoVEuXDmtUICwkVhrgQAeR8X3C6my8BNF1lbmb7W2gpAT2E50O9hemZsixtUgG5JRkX9GFu198fgc1q85b4dCqcgRL+CEoAmX/hoAFuvbrWm6bD6Q0YhBzo6npPM65mA0ulDsWpoi/EoHRyR70W/HQ/FR4lHqL2dghEyz75Wj7SHmUYLvfiVpYoEvG5BxrlssBEiLIwk1OVEEpU648OPcPLi++dhE6GuM644fonwBnu8KqB5Me61imV2DAkqtKBCmId1/FyzgARGZM6kuQiI2+EyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNokNoARkreuRPmaLBttJ7B8kDle+c3zaUCO4xZNAlY=;
 b=Hj0Jl4oISUwY/07+eTzAMOMxif4Sn+nrOWC+/n8oiEaEwrY7Woc6ZCNdn+PO42nlnf2uKZFRzoXGBjlUfea/ZTSZlXK9khBmYw9pt7Jr9H1QGqHP8l7R/ydeM3AE4ruNBii82d9GqSaBaAyVd4jQNgODCyw014lUUsYHeAyx2yU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6037.namprd10.prod.outlook.com (2603:10b6:8:bb::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 03:41:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 03:41:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     jgross@suse.com, njavali@marvell.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, stefanha@redhat.com,
        oneukum@suse.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/10] scsi: xen: Drop use of internal host codes.
Date:   Wed,  3 Aug 2022 22:40:51 -0500
Message-Id: <20220804034100.121125-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220804034100.121125-1-michael.christie@oracle.com>
References: <20220804034100.121125-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:610:cc::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a43903c0-931d-49e8-6216-08da75cb2836
X-MS-TrafficTypeDiagnostic: DM4PR10MB6037:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jcrk623YexYmm4zi+8tA8Mt5nrYIN4FIDMGjQWxwxBOINc+4TZLPd3V0AgoawVZEghnxtnl2zymNmLigIPtv2NhgM8ffgpcm+HBbzR5E8VBABnScN4LcL7v+W9DehMzKIAtSrOGBsPsHA8wifv/AvoISdE8KjaA0miAAIy4CRZnH0UoVSnMFwYRpET2HaSt6TwjPPKAHsLP+JlHBF9RABsapUvlKyUEZ7G5HswCf5gzj1rmEvpjVndun+Y1mlRaa4wSatlaIrlQw2YqrslFQKHS5OXwBgL3QM2qLHdvEhVSbcojVPhhNSoKM+UPNDskwbIqGKKEG2u8E+wLLsh3D1/0gOx5l+7kZAozYg68v1gwacMzeLLD4F2jZL6xciDFfyBHVvJ887EBZumS+RaMnn8K9L/pB638UzV1JJ0Cnf+7ZxLG/val7tv86p6dqhSbh2qpGOtiAOU5gqHplzUUumpyUf7kr2ZHWBbhlpgcx3SJGhE46CXX7w4MnVgWpxRrhRDMuLe+5Gm/gdGgWmrZN63snNI1W6twLVYJeoWonSJhmk3HhXwwfNgHx62fOEu1dcfUNMCyyg047VAlyiGpZO9cTI/5f/fqi6XHk1alLAAYQeEdNedaYoYDQkpt1YYSRzxZHK1Lxj41/pcJo0OLwNbKMlldwE/MKdA7GMG7PyYzrAKDdALsmlTzKaEMHKz6QLcmjemr0J5I/35jTgidgqIz+Ww3UmlSm4HDajCJuChPggBIyq5u1pkGM9tOZzCCVGfklv+7K9rg5zzk2uXf/T2+M+LeYG786cs7pBF7Y/Ck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(107886003)(186003)(2616005)(41300700001)(6666004)(6506007)(7416002)(36756003)(2906002)(5660300002)(478600001)(6486002)(4326008)(66946007)(8676002)(86362001)(66476007)(8936002)(38100700002)(66556008)(921005)(83380400001)(6512007)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCDKLbaIdeIP6ezJ64jI43Q9Xsk73FM0oo3x1wR+lOMBiWKWGigxWZuw8z4n?=
 =?us-ascii?Q?8I7pJPfkr35KKDHphBCUB9hqnq0Vv2/LWtCdf85Y1BvfiIyS6DRHtLMivYkT?=
 =?us-ascii?Q?vrtz7XlWnzrl5Vf62btnux/kgIbSwL0ly0+F/5CGmi4z5qumcFw7OgyLezn0?=
 =?us-ascii?Q?KFik3mkwWnrrmfIJ0GNUE63LjG91eTKypX6ALPw3aBFuC7MmoZmw4NoYpMET?=
 =?us-ascii?Q?Z6+fskqyB0P7wBNhOMxcpfUNyy/RiWdkqojcgl4Py60UYtyzWzy31rJY0Mnm?=
 =?us-ascii?Q?DzllneIX+7TX0uA5KUtKIe5XNndMu6/embFEskbxQSvv8IlxPBukzsPZYWe1?=
 =?us-ascii?Q?fiDjB/RPrvzwTZOY4T3msKKCcNd9bfop8JDC5LGoN2FV+AJ4qEvEIL0T7lOP?=
 =?us-ascii?Q?q7tHlVGuzudJQ3VvuKXCzc56TuNAYV4+eTuTpWCnzNmWY3kROT6b4v8nlTDo?=
 =?us-ascii?Q?gy5T91Z6fl0MTnBrFkjrIoiNAzEd+bf9ePxC0+O4iV2IetY340skpshgo4hW?=
 =?us-ascii?Q?jZ+UsbSuTWm0XthSyUeQ2nDkDprRy671RGn20vr7E8vaCtZPGE0+VWBYJSzY?=
 =?us-ascii?Q?/Fw+9u3PwrkWF1G7wxZRxRNCBNugBWa7zh0pNCtjJtJ6w6earFPnbH9M+6bA?=
 =?us-ascii?Q?9Q66jD5CKOl+cF+JwIYvR/3Vkq7LbeEEz76QVVbUSIQg8qooSEMLQ2YnqEL+?=
 =?us-ascii?Q?3SUjJHw5d9ENUITX8irIDn1SAS9FM0jLatG8qOhCMlRc9UEXVRpXF30afNEk?=
 =?us-ascii?Q?gWN/DdIMIPccfaOWcF00493R4bJ1OxM8YYaq/nlAvjiG2E1us+PcadETHFb3?=
 =?us-ascii?Q?ZwEvUR8UmdRH9MMicyfAgit1YGokHzK/Zrt7ZmdYIG/Kpn7th+o5oswz/3Uv?=
 =?us-ascii?Q?hoNGKgBQx1ixJZJ9ShWY0QwxMA/hrnHUQ75KHcIyCmXOpWIQTIdNXD8ZuG01?=
 =?us-ascii?Q?ldKLIayoYEZpQfA1om4iZtnUbSuFaDf72Se1352NJ7hbKlmR27FUnoaWZFj+?=
 =?us-ascii?Q?1Fz8UphGKAhbHGW/mnXzQ72b/cYJuZngYqyDO8P1nuBDYOLytA2+CgTKMm15?=
 =?us-ascii?Q?QdVl+ISLKN2HrzAxfxsLfaPJHzm3dCcgLB3pAPCun5xqtHpjltal9pDH3G0e?=
 =?us-ascii?Q?RYR0nxH5QETsiUfykTOH8r9tNmyHe7xsE1CoIizBzc8z2ZFIprZpX8VA0Cbi?=
 =?us-ascii?Q?QQ0gLk/7WSACmvjGH7cSSPl4FXp0F2/jA9lFzuSTiRzJHJcn3puDTqAqAK3a?=
 =?us-ascii?Q?/KD33YMJunTjiHdxDCPvU6jiLtRlIK15TKtajoYw2Dd4FOAb/QOfuCZhnw+Z?=
 =?us-ascii?Q?KOXuSC5vi0/ipQafOtPsCxd/M5dFS3Ld6oT9RtkMwfCn3jSkkk6lWxkE+1aR?=
 =?us-ascii?Q?B8UX5eqavuhyWordItaRzQCn5iPxzNK+jtLoY7ZT+2EWqWgiObv/LSyGC2X0?=
 =?us-ascii?Q?z96tEFjJGFoObEA9+zT4J9Qu/Mw3cQBBPmSO7tAnEtMjYyDkqORvsnX4Q1U+?=
 =?us-ascii?Q?P2mGmTMi4v2I7L9XmyxdPnYHiSToF2m6FOi75il3AXshNBgdGLloUUyui+6J?=
 =?us-ascii?Q?Vg83vj5/79N3EKMN+bJLQ+DVLWDaXOVh2pTh22rRxtkOoSY/MoRy52PvTpeP?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a43903c0-931d-49e8-6216-08da75cb2836
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 03:41:04.0747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: up9OX1/nhMa3DbEshHdCpnWHbZ7N79NWdMXVEdAyvRjdvsN/YxypyNR7d3MrY5LaicVdTbfPcoq5hVfkYUCrp6y4trbVI/d94aedJ5vo0XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040015
X-Proofpoint-GUID: 1E-fAdwxVJHOQNmZSAlAuCt6K7YEQwbs
X-Proofpoint-ORIG-GUID: 1E-fAdwxVJHOQNmZSAlAuCt6K7YEQwbs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error codes:

DID_TARGET_FAILURE
DID_NEXUS_FAILURE
DID_ALLOC_FAILURE
DID_MEDIUM_ERROR

are internal to the SCSI layer. Drivers must not use them because:

1. They are not propagated upwards, so SG IO/passthrough users will not
see an error and think a command was successful.

xen-scsiback will never see this error and should not try to send it.

2. There is no handling for them in scsi_decide_disposition so if
xen-scsifront were to return the error to scsi-ml then it kicks off the
error handler which is definitely not what we want.

This patch remove the use from xen-scsifront/back.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/xen-scsifront.c       |  8 --------
 drivers/xen/xen-scsiback.c         | 12 ------------
 include/xen/interface/io/vscsiif.h | 10 +---------
 3 files changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 51afc66e839d..66b316d173b0 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -289,14 +289,6 @@ static unsigned int scsifront_host_byte(int32_t rslt)
 		return DID_TRANSPORT_DISRUPTED;
 	case XEN_VSCSIIF_RSLT_HOST_TRANSPORT_FAILFAST:
 		return DID_TRANSPORT_FAILFAST;
-	case XEN_VSCSIIF_RSLT_HOST_TARGET_FAILURE:
-		return DID_TARGET_FAILURE;
-	case XEN_VSCSIIF_RSLT_HOST_NEXUS_FAILURE:
-		return DID_NEXUS_FAILURE;
-	case XEN_VSCSIIF_RSLT_HOST_ALLOC_FAILURE:
-		return DID_ALLOC_FAILURE;
-	case XEN_VSCSIIF_RSLT_HOST_MEDIUM_ERROR:
-		return DID_MEDIUM_ERROR;
 	case XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL:
 		return DID_TRANSPORT_MARGINAL;
 	default:
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 7a0c93acc2c5..e98c88a960d8 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -333,18 +333,6 @@ static int32_t scsiback_result(int32_t result)
 	case DID_TRANSPORT_FAILFAST:
 		host_status = XEN_VSCSIIF_RSLT_HOST_TRANSPORT_FAILFAST;
 		break;
-	case DID_TARGET_FAILURE:
-		host_status = XEN_VSCSIIF_RSLT_HOST_TARGET_FAILURE;
-		break;
-	case DID_NEXUS_FAILURE:
-		host_status = XEN_VSCSIIF_RSLT_HOST_NEXUS_FAILURE;
-		break;
-	case DID_ALLOC_FAILURE:
-		host_status = XEN_VSCSIIF_RSLT_HOST_ALLOC_FAILURE;
-		break;
-	case DID_MEDIUM_ERROR:
-		host_status = XEN_VSCSIIF_RSLT_HOST_MEDIUM_ERROR;
-		break;
 	case DID_TRANSPORT_MARGINAL:
 		host_status = XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL;
 		break;
diff --git a/include/xen/interface/io/vscsiif.h b/include/xen/interface/io/vscsiif.h
index 7ea4dc9611c4..44eb1f34f1a0 100644
--- a/include/xen/interface/io/vscsiif.h
+++ b/include/xen/interface/io/vscsiif.h
@@ -316,16 +316,8 @@ struct vscsiif_response {
 #define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_DISRUPTED 14
 /* Transport class fastfailed */
 #define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_FAILFAST  15
-/* Permanent target failure */
-#define XEN_VSCSIIF_RSLT_HOST_TARGET_FAILURE      16
-/* Permanent nexus failure on path */
-#define XEN_VSCSIIF_RSLT_HOST_NEXUS_FAILURE       17
-/* Space allocation on device failed */
-#define XEN_VSCSIIF_RSLT_HOST_ALLOC_FAILURE       18
-/* Medium error */
-#define XEN_VSCSIIF_RSLT_HOST_MEDIUM_ERROR        19
 /* Transport marginal errors */
-#define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL  20
+#define XEN_VSCSIIF_RSLT_HOST_TRANSPORT_MARGINAL  16
 
 /* Result values of reset operations */
 #define XEN_VSCSIIF_RSLT_RESET_SUCCESS  0x2002
-- 
2.25.1

