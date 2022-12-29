Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD9BC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiL2TEn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiL2TEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF7BD9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:36 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxlvD026482;
        Thu, 29 Dec 2022 19:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=kSIl4oR03dTCjKvm/u7nwT2jpvXvfUROV0G6Z3X4yCE=;
 b=v49/BqEPiWyCG6T9DnUOHev0bd7lMoK3UCJg42qi0K6DQdtpGvf7UoQAXmcojUYLYKZl
 v9hAEw/zF1SRR/VVFT2siiQfI5xH8ZRyYurMn66WHHqnuFcxanzC52B4oo18B9AmT4K+
 OS63IOBsbBiPFRgQYjhXbOJgxEXzvtjJksUUHSmFpBcClSPHN1U+aXvU2266KA5GQmUu
 wmjYSTcBfkD9bFdX0MEDfXD/ARLJEork7OkK1LWDdqnOF6TymWOcF3uR+QXuSM/lTlQo
 RkSJMpjzWmXIhOV864nB6ymOvQlmsU8vYhfyQh/KnMJMJMYItKgQSDWWjt+cGAC47dSO DA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnrbb7aq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTFddqh024216;
        Thu, 29 Dec 2022 19:02:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqvd2d5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieXAMMbFYbiihPpNGHLfSjQxnYKQtw9BnqC+c0nkpRMQdZqURMthjJZyacGusJVc7YNsI+qhxKm8YRqFqvJW3u8jGgQQhaVxhmx5wtvpHaDaf+5Kj3QSIqfYXoqv2HP+nkitfhxdYhaIKaAdPWnQDBlVSu5ETXvPm39rYuW4+yXCl3BI4s/vIYSfkU+QKlJkI2YtzxOTvR8VIhF+qGX9tWsB97jRb47A7QQ3bb+m0P9vN3IRiRSnKs7r+EWxyUP2q0yd4EF+s8GQ4wcvaslg+cL3qTIIzPHIEStGvtx0a8yh/56Mvq9U3rTxCB9VrYc41i4ObEd2Nr4TfKM3/nVwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kSIl4oR03dTCjKvm/u7nwT2jpvXvfUROV0G6Z3X4yCE=;
 b=FB0pITS7spVgIPnqGKM/L3JxBJ3wO7LsSoM9s3CBMonMfZ/1CKuBWAiKTu66VIB1LyGFE+BujFrQFk6rE40oPe2HnPfghkeB1ypsx0x2xvbym9tYCBBJVwLvO/RWftd+Fcxq5JnrJ4oS6OkGMeIv8eWpYojdNWyBlsj3d+LER7etmhelyoVbW7hSswj2ck0LCqm63ayLlHuZGRDxK1V4F0VsnoZL6j3xKgRtiKlaSo/uaPYgmHSVt7jWV6AYRvXOdbR6ejrWBLMhPXjB++tzKAcImoLQjRJ4m8VNlT3mN93yhPanDuvVkvallmohvn/7pjhXS/DiCn+GplHW/A29rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSIl4oR03dTCjKvm/u7nwT2jpvXvfUROV0G6Z3X4yCE=;
 b=dait8/nyCgSwCr/VNPy2j5dX9PlkS3CKVAZfX01XKmW2JLOwiCt5Q/ta4oW96caVjHjt5TLkgN/qACOEWvsvHzbKP4D7rLt8fM9PnECBVoQqFgeuNpbb+H92IG9DE0rLYHKc3mbJBPIb1ML6EPv1jcBhu5Zss1QIs9QkxmRguKo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6289.namprd10.prod.outlook.com (2603:10b6:510:1c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 15/15] scsi: Remove scsi_execute_req/scsi_execute functions
Date:   Thu, 29 Dec 2022 13:01:54 -0600
Message-Id: <20221229190154.7467-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:610:38::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6289:EE_
X-MS-Office365-Filtering-Correlation-Id: cf3acdd8-c236-4f78-5a66-08dae9cf3747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwUcga1LdQHhaPjNReEZNaAwtaUUSuuLQ8cIWM4MaTPiX1rSCIJ5bjTs9lmnW3e1RAo/AHvshmkDkMAE1hOAxi/r4mvnD8KyZqPFircQ1MuN/0Hc2biWB51A3zcn9pW//Eq0cn2e0ztm7Gw0565pwXurHDU2UqMD6XsOEClfqwOPUi+u9LPWMKbsi0fS2ozLyD+j7vOrxO7IotLUPa6HxSqpPvz1uNwxOiYrgbDify9keiNbOLweRsJX5ca3SkFHPWOpVWdESjPjz5AagmZn4GKYFLSfsXk1CmseOiABIYXQeuxzZVoBMBAiqJ3H5eLcvympZ0JJBil8E2BplScwCrKAS2pEASQ+J0rMcqUIHu8r9BredAfG5uSdcgUamjLD2qn4P4JMyCJh6LtORWcITT+AWFyuaK3hT1pr7WF7oMDAw2O1vdJH/WdNnDPK9O2zgRj+zDdhqCGVuUsgGIz+qHqgTXbF5UaJpBjyCC4o31eaMmN8/vPbUFjsIdRqiDeGJ8DU/ULrsWA56sT9FZKRzm1M1isuBimB+9j+TZ+gWS0xXlrFovcZsyHFCemlP4NAm5VCY3izR4tUTCBCslb+xEqvp/IwN75/2hK8dvdpiu3jTCxC2x4dVnO3e0rf+Fb5oNJ85usvgkNYot7lKgiHAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(36756003)(86362001)(66476007)(66946007)(41300700001)(66556008)(4326008)(8676002)(38100700002)(83380400001)(6506007)(6666004)(107886003)(6486002)(478600001)(2906002)(5660300002)(8936002)(316002)(6512007)(186003)(26005)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ccjDXJUQK4tddiCkG5sjVncc3eIRPmIHAMTCW/tqwfNxp/eSFuktJLeiorlJ?=
 =?us-ascii?Q?OYlUuFu3qa3QVV7VJ61HCxJfZYV3GmFIIysjDoV60zG0OeoOHGyxoaVxFoIo?=
 =?us-ascii?Q?Bw9mdvVJ2LWU2e2FTktRUJrn5lor30k5phkEJFlSpx7NPM/n4i+h4OP6Lzwp?=
 =?us-ascii?Q?IIRenNrJBAwk+nTYwF3bGt1Gw8J/SBN2F++SZMSJLrJ+iqGZYnSK3u/ouhdO?=
 =?us-ascii?Q?m5+wOZvZjhDkOg0vfvguVbzwZU/xxgpmfeNVDJRrXTccLyByEFZk6R0nVXhA?=
 =?us-ascii?Q?82kmFPOTOxzUvwTqTFG2Kmb3Ek9oaCjOyFsiEZhjLZCsIIstN7ev2iwAjjwm?=
 =?us-ascii?Q?MUUNv7doY43pF2eCHkUzG7znLH7FFM0hpwES6mwlnarVSFoOqPq0a88C17Qg?=
 =?us-ascii?Q?82Lbi9RNr/O/zZvL2WfoDIaLIjGDzZNLzYH+lJ8fTEDmPyiL9fQZhi/YPm0V?=
 =?us-ascii?Q?KsbxgaxatBj02drdihrStaqCIxV7zCnOpbrk8yX1NfhmSuzC+TfVzxaIXp0M?=
 =?us-ascii?Q?6Jk0rvFUuc01IOwCrh+6pHuqxPRuzI0IVJIZHH9vXLwqjoTTxiKIDMDjO5pt?=
 =?us-ascii?Q?fJKpDUjoRKaW2b+WTw+WDw6a27rQw4aksqjvXqNkJh/0R2upk65Dj3llIIs2?=
 =?us-ascii?Q?XnaQR/CT+dTUoQqvZKNVA4xbETzVdoTHsf5cUMdnFONtttQxNV7/+L2moUXM?=
 =?us-ascii?Q?mLOfTuDIEuDLwo3CRmIM3DJOUAi1HMidE44amTnFJewx9aKYKjnnqWGfqaBu?=
 =?us-ascii?Q?8lQmMrPuJGxNZoGAmSjPDTN4fIVdA8Cv6Mxt45Bq5g0fEnOQyHKs2keVW/2+?=
 =?us-ascii?Q?BSM6PiUTVue0rTv+OzbGlK8di+WcMH6sLAgaUJduM4tiR0gCGdiZ8LOMOW3X?=
 =?us-ascii?Q?YWvD7tQADrE+3gdZrVYaxsl4l8Bq6ipcNcm51Nl8A37QCFIbckia7M+Uql8U?=
 =?us-ascii?Q?XXGtn85sXX4U7lh3hYHym0ZZfvHgqt4/tq/LfwuHaURR0dlfnV5aP1udURy9?=
 =?us-ascii?Q?W++ricyUTZIdheIVhFFg+gDYJzyFAhIOTkwaZmqh2OzvtkkGMRS86u0yVt9r?=
 =?us-ascii?Q?e7/Can/vgl5epB79IqcGzT/vsQ30d4xgjf+oh5KsjwldroOCLwIj27mx33Bx?=
 =?us-ascii?Q?SLw1ETv5fTij8+F2i0ofa/JTCa8FvaoEptXCBGxwKrAUOH52nqQXxey6X1K2?=
 =?us-ascii?Q?WSdTRc9cXP1EwZWLQL6WqOVi9/u9Jm/T8HdeKa1xDRL9c8JZblFbLd9idJWG?=
 =?us-ascii?Q?tLmcdMScekph28WPLcr5/XnnyR8c+OZb7ENo/Irrmp7dyFa+9TsWjTkK8buV?=
 =?us-ascii?Q?xucwzSbyYMpAtlz6QUSMLtOVLgviP6v/PcMxpxUDfI/xPEddRcfWU501f4TK?=
 =?us-ascii?Q?rO0I09MGhvlKWepyONjL2UoBBQ8/F5+Cr6WoEI5BFywB+XnjKIi4Hpk/l2TV?=
 =?us-ascii?Q?arn+EOWpChVa2E+8HYowE1Z1eGJla/RjF3Z0+CVQXr54fR61kMoStkk2tVu0?=
 =?us-ascii?Q?qzGa75usHmhPoJEXL9dDzQlgyNK7l0MZtDFlnCQd8AaO/OL1AhvkJpqE7z4v?=
 =?us-ascii?Q?ZoXty5WkRG7zBp6YJDHEAlrEOBVK5pSx6XIs8ATJk11REbW1MSpLhw53TNOP?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3acdd8-c236-4f78-5a66-08dae9cf3747
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:22.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+jpf4rQDqgAT3XzKNqXHP92SGANBoM2qTOp6x2pvfIz+F/niuWWyZ+zfKQxJ7Hfn9O5dz4f8lPOrdkZ269yyMbyF1Uk+dllFh6gOBLx/+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: N3cckSQiIvrKuFrVzpZ8_pfEmUJfcx7B
X-Proofpoint-ORIG-GUID: N3cckSQiIvrKuFrVzpZ8_pfEmUJfcx7B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute and scsi_execute_req are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/scsi/scsi_device.h | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6b33c6c1064..7e95ec45138f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -470,37 +470,6 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 		     int timeout, int retries,
 		     const struct scsi_exec_args *args);
 
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
-			 REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
-			 _buffer, _bufflen, _timeout, _retries,	\
-			 &(struct scsi_exec_args) {			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.req_flags = _rq_flags & RQF_PM  ?	\
-						BLK_MQ_REQ_PM : 0,	\
-				.resid = _resid,			\
-			 });						\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return scsi_execute_cmd(sdev, cmd,
-				data_direction == DMA_TO_DEVICE ?
-				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
-				bufflen, timeout, retries,
-				&(struct scsi_exec_args) {
-					.sshdr = sshdr,
-					.resid = resid,
-				});
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

