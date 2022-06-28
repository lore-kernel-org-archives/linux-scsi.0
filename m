Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EFFCCA493
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343748AbiF1Cdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245048AbiF1CbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:31:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E462529C;
        Mon, 27 Jun 2022 19:30:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S19MfG002132;
        Tue, 28 Jun 2022 02:30:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=whTYCkuc2PN1YhPwWr3BqNljE1zisoZXDAexTpoI9Pc=;
 b=GtnXa4KDm/aR0Koyi+cAjlmhumCzx+k8xr1Qa9zCSY/7LsnLhbNJDgjeHHTtXfTK/dQc
 bq8qDfoERNP4WzoDER4/yjjOVa9GrcoDHpfjbQP5fog0xzmOjqjA8IPlG1F7MwM1Hb6n
 3n9756lbgbEHqcilybAuxbXAXkAjvGiI9RmqfGpXvfHUXTUMWF7AYiAN0qi+pYinP2L5
 3fOvYFioWj+yVYr1sqB7188dRlze2xrsBITaZQtH3Zn84dB6hFXy8rvW4AxK9jMiDAO0
 tSFdvdHSu7KITPIFroOF8GbUu+cWn+ijywWHx+AYfmrdXvsapMLL4KSeFHIqQVpKMLj7 0Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gws52csph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2KJsA018705;
        Tue, 28 Jun 2022 02:30:02 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1t5vh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxzS7gMko/egp9xDh2RFpH2YgllgkEx058gbnLc4NPNta8kyPphDR3f4fqm/pkDAHf6DdmCKwVaWjmaCWa3tErV3t754/nQjMTmKBiL4wde+Xn96WeYGTK4DmYjy6Jq+V9St+0ZAiQcXH/dmR4NL6wqBCP5biVQNV1P2FtTn3qXKNNjNhIWTWrR2+tzUD2d6d/OVRUYdkGEajoVnqWMUauuwV/qSt+JgaC9U4gSmTzWu9FZ8HRxbKQ6Rw/eYxwta5WriiXrK+v0mLtplu5CmolLTXNMsSEPSpehN8Nh5TBcIWYRC272aXkoBc06tIv5J3lHMuhy2YyP/4gIp7nzjGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whTYCkuc2PN1YhPwWr3BqNljE1zisoZXDAexTpoI9Pc=;
 b=ar5w/gm71GqAX6+XUAMwXoFdjm5PctGcSS8+FVIpntMfU95/De/ekTTZnFWATLKNnL0FQGlMN7DNfSXneVYCdP61k5wy+tK2zlDBZtRuIuqeI53ID1i6tf6g9Rb6gUUry4wKIk3ZtLIuFokbGNr2yv1svPfwP1IVy5K3BAHydffm/5y4Eu0KoGYvtSkCVFcKy9HdFvJo9u68IXVV/16vI/5aZel8FbqzenQl/f0J30ij0Wcr5S4pmIStO72WcPS3Wx8V0Gs3lUQtb00imjkeRTYSFoxcoOC9JoWqF82Y9oldLg9k2Ri3tAogIELJZFCobcJ+UccHfC39t7QVX/wT8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whTYCkuc2PN1YhPwWr3BqNljE1zisoZXDAexTpoI9Pc=;
 b=NmCYK79RgDqM0l4ktryGDxNx3RRl2qlqRRGU6B0ZhGq8H5YN/mj6IKVnSNgbiF1Rzx4hv0FjUFZq7tDKvpW6Khm7ZRfhuvKuaKOyqQBdf9Q/zAVop+Z3y23IfO8MrfcpvIqVTi/ctUIgauZzsq2n8g8mSzi78TD4rRAOwCcD5LE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:30:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:30:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/5] scsi: target: Remove incorrect zero blocks WRITE_SAME check
Date:   Mon, 27 Jun 2022 21:29:49 -0500
Message-Id: <20220628022953.20948-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628022953.20948-1-michael.christie@oracle.com>
References: <20220628022953.20948-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd5f4021-b5a3-451e-82ec-08da58ae19d3
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dtaYiIsVFvSvfC19/9kFs1e1n5FAA57HtM52l2fVMRP0sK/v9WC7X5lA06X5Eo4+OLc9nGeeJ+zqpkTlc81twK9zmnk9QYWWfKPf/ZUZaGEB4GAuG5qNo6Ue9DwHhHhTAbItVRhyOnngu9heGrdcW3KbL+Eb/3RbtiTOPezsU7lpZfjbo47l86h/wYpcjylFF6ZlulSkqBlt72zzDPo2NUg7K+SYBLHj+/sjf6AaM+2aLewgs5m5wkezrrjgcKLFV9MRDD5ia6XL0GTJqEdqUEwkd1+huZb329QyeG9Sdf6BoRGyR/Fcs1D5t0LL0/w64xCJ23978fS8i+yRx0mbRRxeuTjY34kJvOmiQKnfSA1V/zmBwAhu/cdlUrCxO6UnjoArf/75Fw1iGVaZTHVkSW5N3dI5IFPxGlnoSEmGuxhmFYhwoCAOilYVlnu5zgmXJGhz85kRUBJJk+9Wesbu4kq45X2a1R7jHcaOj1V+C/bLcoRPFd0paAR7cQVRYfFVBvyLFuombsvG9DhPjrEjL7HnqoSFgsuOg7euS2CdmcqSnOjwtYE5T/yLvQenWxHrbKmzLeDFgqzwd+LRKjgFOYBBbDdDFfxjLrJX8gxgvVkj1dhKFfdyJTHHV5XFDCrK1tCQ9vh6IvPPI3BPNXZaLlmwZf5gaHyHlZdM6x2uRYuj0gpfuct6Rg8IZC2ewcu26L25GFT3EYQlHW0SslYsDNXatrA+Aes6pRlPW/9kTq1knTIX9+f8VeicbtGDTigjepmyQNA2RyB8l/9WvAb9DXcpLKKf+aYXBIVF5g+0Qc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(26005)(83380400001)(2906002)(52116002)(107886003)(6512007)(6486002)(4744005)(2616005)(4326008)(8676002)(5660300002)(186003)(66946007)(6666004)(66556008)(8936002)(1076003)(38100700002)(36756003)(41300700001)(6506007)(38350700002)(86362001)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l2yk9qK1mjtTynl1bFqnOCtAgpEmPZktbdvGR+S+t8KIyBagq8R7wGFIjCnj?=
 =?us-ascii?Q?NwGRxWxxLEAgNUlZsJhYokyFAfYuCe8RMgcSLi7oMHM5tmFzBYka7fZYDB0L?=
 =?us-ascii?Q?A3PSgaEm3IBMUQD0365V+YRpbH+f/nSRetgj31KSPDuDt98/E5VuBHGo3nA1?=
 =?us-ascii?Q?y9s+PznrHAo+bC/2HJyZu72MduYfnXeLHr5dhvYAYpbhyk0cFr2+/3AbKyHY?=
 =?us-ascii?Q?lhRsZRa+Cw8WTiwB+2nx3C5QnsHfvrF6EmHQRGGPNb4D6Y2biHa73naeKKXM?=
 =?us-ascii?Q?CCaFXzCFW0F/MZ+E7vjH4raOSE31Raj/AY5RAkUWrG2AcPRm5anmELDSNFPv?=
 =?us-ascii?Q?+c0SWgVZUdDa3Hzn79bMPn09VBPE0E3Y3AhJJeEeVBO5tZnJIb3YhI0BwMFg?=
 =?us-ascii?Q?hGYiUZlH1DVL0JK4mmCsdASNmWYoAIq2ZKQzZKKvoV6ITu0NEncymnW/wH1A?=
 =?us-ascii?Q?TcZA/O/jdO3Q7/iPpWr/9jsqAzzY7WN7b408ZLGZte3d0R9klX0WOWalvQT+?=
 =?us-ascii?Q?kosUT49I67CGj9ba3lSlD3NqX+Kk93+ERGk/3tsJAOHSZwGVZKwtjSeoru2w?=
 =?us-ascii?Q?p8QJxkx10c6CqS1dV95shHqnvAG8V24tm6GmXS+ykK46/pKRAR0BkcI7byAQ?=
 =?us-ascii?Q?Ycky9TEzeJhQdzMs8RK5R7A6d4W7gB+sE027K11hMG2gNalRclpsbeG5ibG8?=
 =?us-ascii?Q?A2CUOp5XUWJDVXsE8/pJ80e21unPm8qJzNMne3NcNhF+VI55nyAc/hQSvXsu?=
 =?us-ascii?Q?nC26x9Fwut3uxuBFaktXv2EpkiRKcRX1tNiPYFcouh30vdKskOta9lVZtX1s?=
 =?us-ascii?Q?VU4xHALyNAuRYQqLv2eOlssMJlV3+Ml01zS72Jqaj87jZJr5sZLE8PUJZIb0?=
 =?us-ascii?Q?qTn2nPnchfD4bWW8NWqCkL1KSnWR/wPWn2cnV25b5FvUDnJwmHUGppkQ6a2w?=
 =?us-ascii?Q?kpsRF90yd3yoFZMBS3TckuQTCe/NuHX04qzOMkpfZSKcZjq04vJjNnZtINFt?=
 =?us-ascii?Q?bTcKzx+VVQ9JEkdDGPXdDn+f5DnSixvAU7TQ53TIwZ3S1A2DD6i0nuqbljF+?=
 =?us-ascii?Q?LiwIwzzMI5zEJWTP9qxp2sN8VNyCkzndv4d2jdPdcx6tKTF3K1OU/5yxEChj?=
 =?us-ascii?Q?r4WIBrYxhhKvhLMKz39tPFSl9EBEyggJxqm5qfeYQXq5DkCVTpPnAY7Y1soU?=
 =?us-ascii?Q?OA0I+4/q2s5+IBsXfN9kSj88PpN4KDLA7+AWJ7JVwYwJOCSiZDdmtet61bda?=
 =?us-ascii?Q?KmCO4c9j0c4gDh33Xwx98nobDibC1cJfp1oYRD1I3AoDX7oaZPPnoB75fAdE?=
 =?us-ascii?Q?1pl8VvzZxbpCL+jfV9wM4tnRGia6q+Shu3bL+xJ4jOn6zAxRBczRBjgTMcc7?=
 =?us-ascii?Q?b4fz9X+Z5ZWw7BusZtwuYjiGzcIJ/hJOuJzjx45AB5Pu6PutsknNN6ce8MN8?=
 =?us-ascii?Q?KKgHS3VDVNIaMhxuIBkM34dSRrlx3hUOtdo3ChXwOerOUaQCr8wmc4qLurQB?=
 =?us-ascii?Q?eTy26FbX/tpHsev9vYKVGJKPLul5AG47XPr0j/ZELrccyTJWkAWQ6ytvjpx9?=
 =?us-ascii?Q?vVgI0/eQ3AHDKfYReq7xBdWPUKPHpSr9rS0FEBJE+yvS5CkGSZDlsXIUY4vO?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5f4021-b5a3-451e-82ec-08da58ae19d3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:30:00.9379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nzkcPW5k7Z8UIdpDz2iyTm+lYkA3MTIzku7uUhV4cdYw89F9zTxQuEgXbfUqgNvNeNRVkHEUgUAxmPl+N+41uBqHvygL0jDU5EInwFPIXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: lAhliTK-cZjfwqgoFJZYGv9E46kRD4FM
X-Proofpoint-GUID: lAhliTK-cZjfwqgoFJZYGv9E46kRD4FM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We use WSNZ=1 so if we get a WRITE_SAME with zero logical blocks we are
supposed to fail it. We do this check and failure in target_core_sbc.c
before calling into the backend, so we can remove the incorrect check in
target_core_file.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 6c8d8b051bfd..e8440e5dd804 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -438,10 +438,6 @@ fd_execute_write_same(struct se_cmd *cmd)
 	unsigned int len = 0, i;
 	ssize_t ret;
 
-	if (!nolb) {
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
-		return 0;
-	}
 	if (cmd->prot_op) {
 		pr_err("WRITE_SAME: Protection information with FILEIO"
 		       " backends not supported\n");
-- 
2.25.1

