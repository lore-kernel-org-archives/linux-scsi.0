Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5444FC7EE31
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 23:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbjEXXe1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 19:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbjEXXeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 19:34:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8867699;
        Wed, 24 May 2023 16:34:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ONQe5K028334;
        Wed, 24 May 2023 23:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=lVtMzFf5PydljQdYfKbIak22kteV7ToFIumrNsqqCyY=;
 b=BmgklH5pWbLuX671hxV9D6kI1fabsyR5fMpjqvQsaXk7nttmseFIP4O7VcnoKkCzAVJ9
 KqrTVip1As3ndO5q0dq7jsEBEBSEP8FayFJfn1rHK94a94DvIImGw/UA1FbK/ugXyxhs
 19eVs4nst/2XybBATOVQJJpkM53RK6sm7j99a77Hqs2Tt28nqTX7vDjKxncMwraXL2El
 wT/DhmfwhcdxbMMeRMQkqNa8/VYrZlpsINPXBaxTO7DNlntQj28YBnePwa+no9IBhqUx
 VpUU4J6lG5o1a8n1NKvrmXIbhpnx3Ba7G1j1UMY01R3sYedsBdD1Gfx4mq3HGOFoqeZX 0w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qsux680u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34OLBX9d028577;
        Wed, 24 May 2023 23:34:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2t52jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 May 2023 23:34:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGYTCpy1Q2lPtY+7Q6qP/CDfUlzq/h/1LKXnygczS1Fxs5nzvTqMzo+jCRTG2TxUV2UGrwhyWeYrZcq9WgjMUp49Mhu0KcAwlyXWHsn7Ju92IPtLHfU97Il5dRgDLNjNYo3kNSQiMMlmpe2OJI1fiRtGklRDWVJVh0vCwBPcNg+D58QcLy1ga0S/BHrizCTAcTAEMUN1+ANwQY2c1ITuG9gzlnEJVj1Q3QkGakNrYWAMmKxBwsKMFpWdJCNHjbvXXb55pQ+Kf0uKo6zjvYN63vdCMUACzr+zGbH+SysXVOV8WDIvZSkiNrK6xWRlcUm2cjYGD3SbxYvOjf+Z0pXKqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVtMzFf5PydljQdYfKbIak22kteV7ToFIumrNsqqCyY=;
 b=itgHSoxlOjOZG9gAyJG+MM00e6OpVliX1Hm/TOBFHyW82hLLx8NAxgalw0dFhjqHNCB62kpiWsO1N2/rQU5YQWHo06UPi3WuseJeT1GbdPMHLzZ+0z8paKRvyYp/gyZ7CruFHuAC7YCetb0hN0mYMY7Pb2LDIETQBeGOrNnkHQQhWDyqraGZw89Ox1loGbupMnIEJxA2D68emIdJQJ6QqREyLoYHRczDk9RJM75NfuX5HKlHkXcdVJutINMeOfLeRhNebshdsCRCpX/HnYLKbsPJroMmKBUwHcEA0Un4WXp7N+2ZMwmN4ovERb0uOtnPf44RPJSkENvMt8peV8NDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVtMzFf5PydljQdYfKbIak22kteV7ToFIumrNsqqCyY=;
 b=AeIM6dxi+Qz+XUIgpl0zSptKcavbXuqqv6KeUQOtB3wekJ9mUdvNNWJlXBouV0OdkfeTG/v2/qqedXYw+/nBMClY1g9H8y6gzJ7+f7y95jRwchbAuBh3dQpWzv9fOR1E0Ho3PMm4lz8CMwuEGJRcUcXvqvvo2ZnLk4TFYi7IB18=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6114.namprd10.prod.outlook.com (2603:10b6:208:3b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Wed, 24 May
 2023 23:34:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 23:34:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        stefanha@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/3] vhost-scsi: Rename vhost_scsi_iov_to_sgl
Date:   Wed, 24 May 2023 18:34:07 -0500
Message-Id: <20230524233407.41432-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230524233407.41432-1-michael.christie@oracle.com>
References: <20230524233407.41432-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0126.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: cfebc05e-62d2-44f8-3a24-08db5caf6347
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0zCIRIIwMi9V/CA+imqjZzfM0EY4mlhpE+iY5bGXbOJP7WLGF4MZsQOl1BTakBfmIiXZR/Xn+fmEAHMm5I/RQgT9QsofOHwB7g/YHgpsfwDq6RkjfFb2gqOZ7T18iqV0OcLpY3tY+P2YR/3SENQQBMxb3+Jz4/aqTz6ztNY31fGepBE1bfd2unLbi5XgMGAf5nmtqZfOLjm+x/MnRlfAfOQtoJJ6otAK9FiCCPzZ4rItzLpDG5rJeoo3C1J9+LUTBXX2KOqDXhg7ajf/NpHr0jdxYn7ObS5SWQ0EnhQMhZVrzckodtg+0OnqHvmnJ6A+CLYICt/ey6gPJo2Wu6DgeXKR4CdqKDz9lXXEkmRlYzazKe21duySyHTcPVHHHTQ/r+2uw03oFZZLA+uMXznWNrF1t1OK004W8YFa2b0GpRYHxB8wvAlbFiDLgHcwOVo25lC7AXZqXnzv+/8KfAwfIyTHg53jbzknkPC+gYg0UxYZUpFmLZpFCAiX0z3BL9JFWUeyc3IFha5STN0A4RKaJybR+WC5AQgX/YAb2XM7bvwt2XtemAmwudKcaD++CFe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199021)(2906002)(5660300002)(8936002)(8676002)(316002)(41300700001)(66556008)(4326008)(66476007)(478600001)(66946007)(6486002)(36756003)(6666004)(6512007)(6506007)(26005)(2616005)(1076003)(86362001)(38100700002)(186003)(107886003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Dox5ZzTfSJh/kU4t06QMSO8XScY3FSYXl4BAOm9lb+XNIJAsLKTSU6q5BsQC?=
 =?us-ascii?Q?wb86nlVtY5o/X9j7rjTZQ4pK7GlWP1ChJuJhxz4/4Ro0BUkpJ2G68IVoZKAy?=
 =?us-ascii?Q?7wU0+RCT5zph0HCfKB+hn75i4UDc6oYB4CenIxBsd1BJgM40sJOI/gkVsJDg?=
 =?us-ascii?Q?w/2Br90gUu0MuoRY8kPbQn0cnLm8Wt2rWzeEj1ImtlpdJpCQfWba7sQaYtLt?=
 =?us-ascii?Q?pd6XIJzkAu1DbgQPfHsWRZ3BWCHEXYbuvJ4rRp+6okpRH4FnwW7yhAnXVcMB?=
 =?us-ascii?Q?4DFkP5NjbJ1WZGLdJV3qviw6+eQvP6SN4pRL+wOKn30i6eZKdCOyXZftlp2t?=
 =?us-ascii?Q?3UR8X1I2loYFg6E5OBiizB/V0lb+I9ef29XoLiuYrMkVi3nqETPk/7xjNnOC?=
 =?us-ascii?Q?qEh/XiGDrOl//zBb9orYXrQM9GbEaKXMrvt9w0B4mFiiBUSTv9/zA8WbG3V8?=
 =?us-ascii?Q?/1nlYTUEj8ASkmnoqVG1FzJY2ZSVMY1ronjVbu2P+jMHqCQAmuIh2ehOz+q/?=
 =?us-ascii?Q?zYmq719xxzZId847ZfEA+li+a5fScuo/xQYWmE2Hoildi7yskEdd306Mtqua?=
 =?us-ascii?Q?D6rp5V8Ma6DwabKk6GDW82Ma2V1O1hXkb/0nTLQwQ1R/x7x8iuN7QPoTgOlM?=
 =?us-ascii?Q?3X094Hb2PxtSmGCG+og5Ty7wlPrfvWlMJBHuI6KXILQTCQHWM+RQYK+2hkzw?=
 =?us-ascii?Q?dxGpC1nXVVhFNQ5hTw82ijJRhyof1COiEnHgMIMO+y/6Jhppkqx9BKSfl+19?=
 =?us-ascii?Q?4U81m7IBli8zOdJovYUv5eMv4kgtR9pkVViML45IOxX/3zUytqhnEmDR8tTU?=
 =?us-ascii?Q?2ii2bjwbIglgUuPqFZCwsN/NcKVgOdRaTOCjsuhXUD5A0g6Ep7DbEca6DvVZ?=
 =?us-ascii?Q?CceiuKqwor5dRZ9jr8Z1VZ5qwKHwYk8ZfSZ6hTbHbPkbO8u/rTwxpfRsIYxM?=
 =?us-ascii?Q?9rW9/XvFIY0A98zDiV3AqsckynsDOfLjQKGKu4kcPfzv4HuYFx+7bMgox/Vv?=
 =?us-ascii?Q?qokR1Ggh4n8NJ9MFO/ReD2b92CiPZNhftPHN+79QmLDcDmv7fNXmFLwmULom?=
 =?us-ascii?Q?j6IowNGm2HYV7/dE8he5BQKHq/yPE81AR7pzY5yvrCX45UvCfvM0aMxUIE8B?=
 =?us-ascii?Q?0o2VeXh6CrG2P76h4nb/djQVF1T8K9BD2iDXeis3RnH9hh69nNEA0dZ3Zq/9?=
 =?us-ascii?Q?yhbm+Vanh/SpDIaEkRwocvahlnNxu20nC/xIob0cc1qtTZAQIGIFMH7Yde43?=
 =?us-ascii?Q?DT5gODqtwROSW6YkEPqdnRsby7ewYf77j1/Ag66U9BhSIGjynocboV2WCYmE?=
 =?us-ascii?Q?VONB5XE4VZDZir1y9f86pgzGUJ79sqO5FNysvF+61BMRboGqSPxLaqT97YWi?=
 =?us-ascii?Q?teVbpL6qRau3jWvqEHP/CK+7YD5sWEC7BTRBKM3ktInGp/nuG1hrhVl87Gpk?=
 =?us-ascii?Q?vO3TgSHsHAPdVSktb1fOzdOVA8P47KvpHFQeBMqzAfaY2n1p9S0W6C/pJUpC?=
 =?us-ascii?Q?9h0vySm1qzP/nxhwEzFR4an9PY/bXve4CJMwvw0SdZRawyo1C4C22xaH6eep?=
 =?us-ascii?Q?+mgXzNwyfCxM/MKrFdO37HbI6PwECeTyA0lQlamRlNuuNRkMrd5IUbLVKr1Z?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FxLOzyuWwLYoDqNRZkr30OnnOyKMPdWmG+BFgRTjuOtZmprY7LccryKER9o55dpPaVZ0xonNHqqvSAW/NzBIaa+I3Auq2L4Fau81X+VjUrjxZH0HpjzybKJsOcQLOpESkF5ExRO+XqBkmCHwshl69W48v75BE/vnu5uk8QrZ5+nkatKLPyusTBPqfimSHizHO4S2xM1DVdscmxPqL4byEXVgDVMbeJYfrvopJg+yBVL0XxkaZb7ISCGrdwNteabTPLXLOw7Ynlbxo6oGfJOwBPf6AXPKJCoCtD+nVozWws/60x6T7giHFRKZTOEjONRS7HMNR7SIY82pgbOCUs3cNloXClGogT9VNPT1NHhnYzB8vPPXLkg+Mo2BS9/Pfm64iACwBu05H0YEWvktPSgpvNXWaOlRGjKvc3Zd1ShXfqaDhcuGhjcucy1Ye1gK6Yk6zl4zfCGFGPk47j3fqA43d/IiD2bIllcTCQ0U+oETpoFvY69XramPObIo8sieALSewp7wNM9MSlNpfEzA/jT16uD5zNFq1a7WM578PStCpxr6b5HP5pBNd6Bu5syGYtLO+Bs1i71WRX0YGZYTG3FAT9imZ9lUMiSpVgmxvlUgKZgPTx6V7KstzoWOdJdoQHp03jJmQumriLDZN7DJ3PBvfMnFhbUhYbSFkpdh3l9w6MymZSnPJsPsx8HWlxlGu4BN54QC/w0CY6641A+N/l85qWnjo5LOPKsDo5V4QtDOf+lH3VP/bn6O5TuD6IpZSJXyk795sSZId+A0sNL5Stin9fMpwBLn40coxsQI72MHaK8nMzpBryV4NrZELl9ICQjR5TOkyN7mM5x2ViXj76M8jhvb5HWoSc30HG3Ek4o4WKo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfebc05e-62d2-44f8-3a24-08db5caf6347
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 23:34:15.8944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xHKD/bigCMjfT+NYz0QY/SbeU2oRLiUQuidavG0S2VKJ0vGh0Uer8Nd+8wgfbuY/Ke0iJ3ox12qSqDmrEBTE4ZhIkL0rRGhldGaOBQDeBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6114
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_16,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305240197
X-Proofpoint-GUID: sm_2AP8jjv4HQ69Bs9R53lN-Q-_Z_3xy
X-Proofpoint-ORIG-GUID: sm_2AP8jjv4HQ69Bs9R53lN-Q-_Z_3xy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename vhost_scsi_iov_to_sgl to vhost_scsi_map_iov_to_sgl so it matches
matches the naming style used for vhost_scsi_copy_iov_to_sgl.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 382158b39740..a4d32b96e66a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -694,8 +694,8 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 }
 
 static int
-vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
-		      struct scatterlist *sg, int sg_count)
+vhost_scsi_map_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+			  struct scatterlist *sg, int sg_count)
 {
 	struct scatterlist *p = sg;
 	int ret;
@@ -778,8 +778,9 @@ vhost_scsi_mapal(struct vhost_scsi_tpg *tpg, struct vhost_scsi_cmd *cmd,
 		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
 			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
 
-		ret = vhost_scsi_iov_to_sgl(cmd, prot_iter, cmd->tvc_prot_sgl,
-					    cmd->tvc_prot_sgl_count);
+		ret = vhost_scsi_map_iov_to_sgl(cmd, prot_iter,
+						cmd->tvc_prot_sgl,
+						cmd->tvc_prot_sgl_count);
 		if (ret < 0)
 			goto map_fail;
 	}
@@ -808,8 +809,8 @@ vhost_scsi_mapal(struct vhost_scsi_tpg *tpg, struct vhost_scsi_cmd *cmd,
 		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
 						 cmd->tvc_sgl_count);
 	else
-		ret = vhost_scsi_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
-					    cmd->tvc_sgl_count);
+		ret = vhost_scsi_map_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+						cmd->tvc_sgl_count);
 	if (ret)
 		goto map_fail;
 
-- 
2.25.1

