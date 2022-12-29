Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8DCC3DA79
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiL2TEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiL2TE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5197E13EB7
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:27 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxJgR002285;
        Thu, 29 Dec 2022 19:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=h8UV6YWruBfiRIztZ/CbSAO78+wxDQYMR8ptCya1mVE=;
 b=FpXn4LeRpka0DHTG/be5r4qPizXFH7g5PDoIessKqNR6BIRCYKFHtGTW3tjIaSGqd+ow
 VPmrshGG+72+3fOll6YSxLCo0cjTQzaZaSGicE0ex+vYcIxtt4+J318qpgwe6S5jvAyJ
 Ft9exP0RiBTgZUGJAuRpxDwnnaN8mUSBnwdsniV8BmlNJpL0auWJih4kAwSkgl0nk4yr
 SfhxuACfJlKYbY0qfFWotzVh0l7yin+NFfTEvkA3QCZASVql/OwOalZfQFTfnhoXBoMP
 /ACYjcuir4Kfl8bPJFe+hhb3Njr13enjVhmqm13oY7Zfb7fmM9G+wN86ppqFkN5fRGj0 Hg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsfcfa8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTH7LYl020403;
        Thu, 29 Dec 2022 19:02:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv77kdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1YX8B3HqTFgigHZVz8SAk1hpyBsYwhxTfFjJPdsCY7nuSkEW0lflvx4vQNz7mB5zCAI8kbWFSMZ+ZedfHCAn+12YYYNHjJ9Wq3cZoyEBwoXpP2Zu5DZ5Wcf9DAWy849aVYksoqC9vcV6HzjAlpXVjTA7NT79nVrf4U8ytztUlnwqXc9mSMcg28/EnBKPMR6y//ao+gaLJdVRtDXTXqUCC8t8SrTUHy+Ev5ImE9Xd8plHekIL30HLIE46xhLSB8sb6T/3upcS1lChlCn9sLZfRFTZWpsNx2eyZLqIMBT1xVxCQXVxlPybZnPEDhV8Q2mSkPKX6GcTaY3E9XFOCZibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8UV6YWruBfiRIztZ/CbSAO78+wxDQYMR8ptCya1mVE=;
 b=QSeDerSX48Sbw5RUkosHCbO99/RmMl2BFLjkcNx5la4sJb/8BsAev1QSDf/yuDFB+hrMMdF4RL/xD8gQwj3/OUOSmPOA85VHIqgkNEn/8b867EVhkenISFB88taczz35x5E1cclDdkrb6a0HglE01fz/4GL2n9K4JOfpUi713SVRS0Ol+sqmgwTIlaHgMMYhUU4sTzfVzmWdMH4hWu7wL0d6tXOdthh8RDA76D4JiC41gVTUoJJn6USjuUCcci0OEMPmKKCchExq2wyBMi7yCFhihQEVb+d5TcWKXg9OnnfAbG6Kl1m8fEQUViNHGDaek7+l/KfDFJVhlWu7J8MOTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8UV6YWruBfiRIztZ/CbSAO78+wxDQYMR8ptCya1mVE=;
 b=HcQYx3RuasnfOAkEWTU8fwwIDwv6vK6nL2JGMAT50AT7L6YkC0eInqLyuKHbT2sl2MyfJR2SW26/3IJYaJqSELtKrMuvxqzRAfObe7smWrrcqDFOu20VRIFj0a4AsTM2wfvR+LSeR+VDQ6CV7DpMGWygGjVqn+kcCBUoZ3lcIp8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 09/15] scsi: zbc: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:48 -0600
Message-Id: <20221229190154.7467-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:610:58::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 7806ee8c-a1e4-4079-37ed-08dae9cf314f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rb+x94fxkMv1fX3SZWLxfIn5eaFcQXRwLPn246AxrHQnsSu8tfw8AFLKTpjGpGMbe+Q6IAek4aFMaB9IB/hMQN7dXJD43Ffxdvv8FTSNqXjChaH8yhAux1P3mumtVofnqH8qjGce+JakEW34Ze/tvRkJbUw4CtAzKmzQ78Qlq9qaYU14MOUuvEtvku4NP1doWczyYD9t3qNEcoK1saKDzcAYA2XKQ+PDgym8yHNjOgq1+wD4H3jcTHwii2Ci4v0gCE56DRPOHTlpMlVPcVyAxuCVRPao8WTDCo7XJioFAXFYi4z0BejFgc1puc7BeiAZR51fCYfFvfjjsuxdxAtNSYYFdaQxrVHJV1NJ4wWhCY5TfGs7jFF8shoNyq1akFzllqkUAQYmIYqGXQhdY7lTd5/Gki5r6aO1X2utOziJpg9ihoaOv/zu4lPu0a9UmFVhrgjb5u/xy/txKM1uEz39j62Ocyrbuem65F5XFP4khkvBmPpZsFQBjJkKbpfNH6EqdNAvOkixbR9ZDsX3CTMVt6FDi8ya7JY4JGREXSbyjc1ChNy9e34n8UZGPdAFtXHQhY97lFuBgkHaKzXaSiurWxFfiez+gL8lKyClvZ2WHgkMwZ2rhUzfdKNSvGDqwFxjIlfB8fkgxzNngAPcJ6solQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TeCyGuJgciNcwL1xaRvi0vqVnUETIirzwUChU7HV49tN/FGN1z1rlnAHz2O6?=
 =?us-ascii?Q?QUMUaZU1X+Z2iX58yQXhbhqnqneksqSGmXGrhSIR9GyXWL0/FqTGedKJNDON?=
 =?us-ascii?Q?qjuvkS6EvGe6hWTyM/784O5kR5zDYGOewGRRXd1W8gQfTpL2O7J/E8cWTOWo?=
 =?us-ascii?Q?99BHg7bQ9XKTEeXOpqif2sj8hPPM3NdaNo/DgDBkNn/nAlyMtish7DPrOb4P?=
 =?us-ascii?Q?DtN7IgvK+j82Mv0kYQQfHP3WaFG4OOSw1sf/nA6Pk1UNiw+G1MHaqG3U6XZq?=
 =?us-ascii?Q?aBzSQLiT38wZt6WI3qIIsn1NbjQDSFKMl2FyFL1IXDmIizXen4iFzuPpTUTU?=
 =?us-ascii?Q?frPmrG4lnVaRLP5Sa6jM3rxfasOJkr6svRSxxj2+xmpvQYhpBDm1C//UvgQd?=
 =?us-ascii?Q?GwHYL7iJVkLxilYrwkfnFuRdXj2SDmCX47Q1OK6H/7eJFZ4IyOa/pS1LA+AG?=
 =?us-ascii?Q?6I4o4Pv0ZRH7g4A7Xxlg9CPeWBpdwJqJQ/poLNaA/hc1oVAIIM2NuLI7M9wY?=
 =?us-ascii?Q?Ue+YJmntj979tpGko/tNN4Orl8yk3nq8NHKc5ZX52A4Y9lDGCFIxOC17I58k?=
 =?us-ascii?Q?WpTIQt60nxOwGEvB1zKj79S2L+Hm26GGAxfaA3S6H1llckP/bK3V+3Drpe98?=
 =?us-ascii?Q?TR4PHHQZVQW2gCiqTaPUgHZ4z3KH3NiGhrRYpRv4HyM82w0aNeVIBQcagXF8?=
 =?us-ascii?Q?y3LJJc4tunKMIdjYCewW9XHHQP5SIg8ZUPfTjCIM6JEUeySmiM/aQAVQ7wrb?=
 =?us-ascii?Q?gkmxfrt4RliiOp/oXD1/Xb/s5ZgDVdBlNb9XtmLwUmZoYNHTvBbd49dDMerR?=
 =?us-ascii?Q?cpPe1gsBQLBKgdY61ctQAfXW6Hnu/CVMJ6/jjmxNI/ItLcBJI7TuqogpKbqq?=
 =?us-ascii?Q?3/nCu/9M//tmg8Hl0N24SAhr31glczfxPVV2DEdX3Q5Zw+wx6Xo+BPvgvOzG?=
 =?us-ascii?Q?sOZLrbwLnFo4WHyTylVq5yZwd6rvPItSxdGMi3D3b0qgsZLu655wtG823K0D?=
 =?us-ascii?Q?KMDtOx251M1ZCS+S7881Q59d6lO+UrDzMArKuJBUwlwLFatg4twl2b1e8ZRp?=
 =?us-ascii?Q?Mpjco+gZuinJI9COxGmtrDnvo6OQzGh4mqiU+w/07CeVpLamNS+aUTt7YDTz?=
 =?us-ascii?Q?H6dfnxQvodAbrXv63LxO0oFfrkGJAU2yHaZOkacL5WBC2fgpoCFu1o54geh+?=
 =?us-ascii?Q?nYPpfgSQeyX2EpdxG61ZBHUCJkpOEs/FKh8obwrgCr5ElR9BnewNRK8bADmH?=
 =?us-ascii?Q?McJVa3hx3qQy19DmIqqZGoUbbtcvlG6kHvxULTIdEx4RAjy3/PnPZIkNYAhH?=
 =?us-ascii?Q?S/4a3GS3O3IlQ01yHK/E6bUo1zn8a5klkS5m25Y06objbPYWPvnKGlbXMva/?=
 =?us-ascii?Q?rdrdGPuwmwo6QFfnn2NB2KnU69g7LI2EzQWcBbuAWREKqiBmtrDUCarWbBU6?=
 =?us-ascii?Q?AS4ismxq0Sjw6dABGHRMeg1XrtVvXcqAikPyGpxlu4G2oUoUNDMC9jTz33P4?=
 =?us-ascii?Q?rj+MnxBVKAL8YcDhY4cJZ+42kQW8N27bUd6MIgZsz202JvcSzEQO3CLwQ8sj?=
 =?us-ascii?Q?KsIl/ZCzPe0uRjQC6dXsNp7pNPuTMwgzIVoAuSDgRlrsBdlhz3Rd061Hy3lt?=
 =?us-ascii?Q?XA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7806ee8c-a1e4-4079-37ed-08dae9cf314f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:12.2529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CV8kyifwjSxpiFa2lwwJTWl+wKazPSFk8JykBeA8195d5LVQHsWsCALBahfv+3toKkDfWgAUs4eOqq3sJmFFi8c7hfhG/FOIn8OYbUwwHBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-GUID: wDzcTuOPSiqBPBpeItDumJMqyCf7baOM
X-Proofpoint-ORIG-GUID: wDzcTuOPSiqBPBpeItDumJMqyCf7baOM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Conver zbc to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd_zbc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 62abebbaf2e7..6b3a02d4406c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -148,6 +148,9 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	unsigned char cmd[16];
 	unsigned int rep_len;
 	int result;
@@ -160,9 +163,8 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buf, buflen,
+				  timeout, SD_MAX_RETRIES, &exec_args);
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

