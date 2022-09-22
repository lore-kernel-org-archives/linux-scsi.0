Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB45C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiIVKIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiIVKHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE816D5749
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3roW018118;
        Thu, 22 Sep 2022 10:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=oLmGK2mjGBrrs4g2bkJAZ3cHlkVqWurQsPKIjgFf3TE=;
 b=P2k/9PCb3SPwSbVpUFhiSZpRFEVCW7RfjpBBDu1wJXBL8SCQ74ajVa64KZIrPFs/gJ/S
 Ik0iDfyly9Lm3T9EfQPpVwj6mdoYqtCLEzbyHuihzZAP/66KWsqsLFeYx8G2kww8nuTW
 8biCiJapUWFP4YRY/IlaTZuDU/zOmStsC795S00AKyDtupdx9EF/F7ibONy+FzeNY6gS
 kJ260tyybeiApZlA36ePdC208bNLeRKc4kCMrg/EZlko/OLQnQ0uierXdLqA9P2lPW5C
 jS8PVkKbLFv4YjDBpMRNK8OcTMuET3PBfldmLSFpJ+iqAphYQaJBeCszrUk+YLNejzE0 wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3WZ007436;
        Thu, 22 Sep 2022 10:07:29 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39sm21a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpRR5ezxy5zyxAk+LYixWbo7cTB7Zkl1c42UG21L3FlW6TFZrIWjxC1s6BOjiUVykZkalfXsBcNlO9ONgxADQmQ5CHZ+C3Hh0QrSvFVEG4OQRMJqaGxFsgU7FcISr4JON5G+Z3cgenSZQegdxFm1gc28Kvl2y3qII9UeuGSAwgBqx4J+kBziN/XxecSfBIDuT7jKWPdxVSu7nQSlcgGcGxjR++fk4aGaIvqmIgRS7QSILT17qYqUbuEb5AroAtoulFNfzPm8H6kY/q5BMUB61bWK+jtlySNvIOztb5A0viL3o3NDoeY6sB1g4DlwSffX2ruknIy22V5vYJk/LFMKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLmGK2mjGBrrs4g2bkJAZ3cHlkVqWurQsPKIjgFf3TE=;
 b=ng5OEdpxwGB1XghTidYnpK53xDh9JOhS21LwHxZY2OXrA1QoXWDBoI9tVn4eJb3SWCe0Ag9NI8QI+8/yziDz9f/17m1FwpEP+uFnF+Hg+98Z+hEVfoLGLKAAV9qG/iKuEPVa7qdoVned/8HArfkvtz8IKTmx60zs8EGCy19ksLAjsLmByPdhsKFjatRZ0F5uz0u/CEJkcyncQwHyr5I1QqaZng7nsaPmn7SRJ6A3LPt9MV2/gHLPMCoIyHAUKivk+RCIr0jPgBZSbA46pmpSXMFks2vGEzBUeat6nrS8pP7NjY/pcSTlem25C6lLF/hlfdydHYpiNqZ5v/oSdR0pZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLmGK2mjGBrrs4g2bkJAZ3cHlkVqWurQsPKIjgFf3TE=;
 b=MeMEDBmZHLUxW74wxUPKN8Bf0TrrFM1IS8y4C+7qyqow3vANggBosnD81iVQL9Hn77rM5Uq1fdJwHIu2uzi1FYczLUZypw5LEarRIN2U/VgaVKIWe5gheAxbAH+PmKMzFF8DuD4afoz3hqZRifhf8ETwwvwwrVfNwxE7+lnUIBI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 13/22] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Thu, 22 Sep 2022 05:06:55 -0500
Message-Id: <20220922100704.753666-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 97aecd0f-4a56-4af3-3250-08da9c8240f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSId8qRV0e1dVwbU71AKSzk0GOlNbjgUhfJhAXVQ+oFzcyeiQLJT7SwUlCRPJMtY3kIDHfvOOlPHT09qzSX9eNkZR4EA3smXnM7PNCcSHBQjEglg4pyurLVUxrA3kkRh+PDH+QRg1/kpEa+n8RCcPNc9uL9SFdz20vrYxMlj/OPZMXAIwawdwdQJmmwR9HcZ6Qt6w/yNPjeksjfljrA7XfluJQIZcbtu6Q2UeaTjUrgwIRGEMgGdL91T74VCx20xLVkcCyMctCDOoJbd6GW6YXIuxXiA+gj04YbhKcwTPZ8M0tYXrQU2ofb4z0W1ULOadvKMJbGexL5einP+utNc5Bz7hUfm/bw222DQgEx36EnUwDTcUWJp2GPaW2LAwDZ+O9bP/tuu8TxV7czwsg1qYqQCy+Jvt0yZES/4hhaXJEFwpZmAX5YQv2JJi2bHZ51nLi0mcAnUlz/I5rPm9TDUvQLpdTWKB2Z/ENzIHKPmtF3Z5RiPtaxsSMrqzE+lp/6kjgkVsU1eSDzJSF+okbzmPqeb+mPD7t6KCfcjMjmFrUz8+Ltclgz7G3mfIppoTSlzWlt5P5c9ut4K4HXtMylDov3zColNHR7SXsoWw3g7TEuz3NQWv9L7oSO4C5rAs43TuwqvjNiHeyV5EAR50OL20y2S5COsqytRuJQqLMfTh4/U7LzSaXh1/btB/chaQOkief4YLRWDWQumttb5QkYI4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VQ0rFDbxH6Ce+ERMdSmTOhOSA0aOZHOYwPsWwM888lt7gO+dQDDNecLu3cSY?=
 =?us-ascii?Q?BN/lI4Usl68wgpI/LBYWWBxh/DrsGxKtITf4awLBdPRuSxlAJ0w9zWoQcQ+0?=
 =?us-ascii?Q?vEX62OIQKO3v61wb9/4+HWPfJDuYF8BG5baj/RN596HEL4fkbxCLamGxwBkm?=
 =?us-ascii?Q?l1L/sCZ3/0ejtg04OZeCJxVQFnrhGUpUp/CdqYKBSsCeFmNW2hzWjuUxtkgB?=
 =?us-ascii?Q?1s+oll5WXHwNwUsKW3X1T/EBemKcQVZU7+LkcPu+blu3EyCjJB5bt0WnTQr+?=
 =?us-ascii?Q?aGEdr4jmdmSbbgW4Qv+Q8RDIyHgOcrAjZA3hB+Q3kCeKj0EaYopHQH83cDZY?=
 =?us-ascii?Q?ntNPDG9IVHUNScGi2fcMdBLR3WsOyk1lOufC6A3Ntgjzebg1C/xu8ld5n7a6?=
 =?us-ascii?Q?w5oZ7du8k9M1muNuBcZcJtNQD7eoRjH0fBy8tdh9JL3aCLTCzRUF7OAW5eRi?=
 =?us-ascii?Q?jyLvmiMUqFMQqLWMljdhslZUxYiBWgA2qhuSS/DFCYLV2h0eHbXSmtjfqQK+?=
 =?us-ascii?Q?OaTMza5Tb7XG/9GKflqndrwmKZQsG8Yxt1st3xfACpeJ8iv2ZUPyBKlpSvjM?=
 =?us-ascii?Q?MMNlvrG1vfDFLvWwcPA3zk4hERw9u/zAMvB5KFYwA3Xf9IzeeEJevrroFb0n?=
 =?us-ascii?Q?gtZK1BoV8Yu8ctuVqLgBqibEw28AJ+Gp+0Bw5Kk6Aqk4VaQ4nGqSAhnxtg/J?=
 =?us-ascii?Q?98vUHTxFTcxY0QUbiAUaXhEdrp+ZFeh4ELh+cmY1krJwj8MTGBr61sbhU5vb?=
 =?us-ascii?Q?nRo71kFUHHpAEVbdehlS1lnNzGZFGwXwifDtuqmF0+7jLhMQIJ4Ekeh0TKDp?=
 =?us-ascii?Q?VjrTHonFJqz+29oGem1rqRlt7xF1geArJypwJ8GaxBBbRB342VA24lj5tIu8?=
 =?us-ascii?Q?97VPi8IbDXRpOrFDG1FOnrfihIiUAorE4UjS+WCXTTri/1M8wMLkg71Axjx/?=
 =?us-ascii?Q?lsa1xRXGcOHTLrfVw9rLS/1FnvtoHy/+BZDRrLlckVsq5QWZNdwN4HzQiUZg?=
 =?us-ascii?Q?P+crWrI70dJAhO/rPp08i8J5W4h+zJ4vAOLV4jupBZXQ8eKv9ZPFHWV1W464?=
 =?us-ascii?Q?NgeSiqN9A4YDOkAjYql7O573kNffrmV6gG5em8dGQCL/9XtL6pMpdRU5dbuf?=
 =?us-ascii?Q?Xi1t0EppIhsENSrsTvIjNeQyK//ryDrRclf4jOmD7RAX4aHtvXhtxgnatzfu?=
 =?us-ascii?Q?gTVhFdgFzQd7ogGSY3d9lPg9TjzxSsJFAK4Iykym5IX4MXfyzVRTEKI//x0K?=
 =?us-ascii?Q?OAfs4bBHwWyDkdlOtKNwT06OQJxhCwxsN2zpzM2YrKpTZujnfmaRk51zOImH?=
 =?us-ascii?Q?nAHEjUr3MKtczrMv3KxMVtps3t4zM0unhzPcxvzAEhbNx3zU4vhheoG+GofE?=
 =?us-ascii?Q?MVVSaUO8pKQptEZfrhTlSFxaTcOmMTjdP2g+HNlXETjWzZEYFo9WXe0Ddcsh?=
 =?us-ascii?Q?gSepkt3Daj4IY9lREd8xHGFyfFHkOMp9ffEP+PaWSZQzWYHHpP4CbXC+9NQL?=
 =?us-ascii?Q?U39wwSKSxLXpiMw71wMJRsK70YyVxSE+UZ5Am1aV51Ow17ROaBRuyG8EtlPe?=
 =?us-ascii?Q?1o7JZJtnYugZO2sxUKZmZdskUwjdQjn4EnRgWOFvOUHO6zeR6wKK3wMIZ8gE?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97aecd0f-4a56-4af3-3250-08da9c8240f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:27.7088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/DUN+W3Uq2QowHPfF15ufR5Et5fCy650S+nRsjI52nnLc4KoIrvFGHaOlQI1BCdGV97ghZxgIBhjc8DCERmGsUvT4j4x5g5yLWk7BHeKHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: poZkCJmTjhjrD60yiwwg9hUKaBIDDtcz
X-Proofpoint-GUID: poZkCJmTjhjrD60yiwwg9hUKaBIDDtcz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 37 +++++++++++++++++--------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 4f4c2b155da0..4df56ee4eaac 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -109,29 +109,32 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       void *buffer, unsigned bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	if (!sshdr)
 		sshdr = &sshdr_tmp;
 
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL, NULL);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
+			    sshdr, DV_TIMEOUT, /* retries */ 1,
+			    REQ_FAILFAST_DEV |
+			    REQ_FAILFAST_TRANSPORT |
+			    REQ_FAILFAST_DRIVER,
+			    RQF_PM, NULL, failures);
 }
 
 static struct {
-- 
2.25.1

