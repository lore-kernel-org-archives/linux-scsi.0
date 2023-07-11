Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FCEEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbjGKVrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbjGKVrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A90170E
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:04 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID2G2000841;
        Tue, 11 Jul 2023 21:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=il/UorR2+lH80Gk9VhFvTQj5XNB5FlEuuo3w9PXrNHA=;
 b=jO/aJs2Qej7KMWzJCb8VruHtvHTNMH+yFrDqZqwLPbcQmOZllLLkjX3ZVgQPb5F1F2Y4
 CzggbOFmxT+CJPinaeTIaFZ5yhpI6GZruCZT15LuprQVfz/greEhrtgqDtdQVAO2nQ9l
 oyPh95D7IfmBMWqKbOvymdooh26ESHmZJN1zRr42LCwBVKLR1TcZSAcfK7lNQenHJ8IA
 p0InA/je/zwfqTnz3FVL3erhhIzyjeeRuaHovFJ2dov6gMTny0LB8AYXaLbMgldJMzBy
 1hD938rpooLFcrUyY9CaaOCiUj9woyvZwtdUc7Ek5/W4A8QinVd3pgtVbO8ouumMjMGL aA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud647y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:54 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BLjb59004275;
        Tue, 11 Jul 2023 21:46:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bt2ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmtjHoalOoZZLdavws88yqM+4fSQAIDhyXDBPG/WFEhQluPjFz1TQuB6a73RS4EdttF4DW1MSAIXCn2DuOYi5eT44JjGbp1K6P6GWPCUTgbDv7yrBn3cLG1M7kOB2liosAsKpTC++OcUEjeaCCsuQato9PQpOOBN4srvytFO1il4Ggn8VRiA5s42zZwDkqNLTPR9rHxV+J1ssLVPuMNajuj+MyAPc95vrDGK6qD3DfswTofsuTBICsW/VVXUdjvTcVHLB2gqYgGPSIxb1ip0SUxTSVL1ijGdO4518irsXbnGfu+UAnt6EmmlWBahqSMDKykjZK7BEEW9aMIIULks4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=il/UorR2+lH80Gk9VhFvTQj5XNB5FlEuuo3w9PXrNHA=;
 b=ctVUza+5SElTDiVsdjPtfv96Ah7hCMUKDHrwKLRsz0ANHWwOuenHg/qRurDAUae7ZN2X9VWYNVMAE28olP52dj/1loNNMcYhgaBalWBmO9Urj1FbWZ4HkIeBijXS58///9anAIEs3NkY5UFzuuKbvoMfTj1R5+Egt7fR3YZuZrNtJGJ69DOv2cUaPxqJJcTk3cjwEGmz2r5eOe8eGdlcug03yrd3z7mQePxsq1GMGcpFRCQbboQA0io/YmZeLa+mfRUX+fAQqOk9CCg3PzhL8SBWGIV6O1Ko5odCsTTCKWaMVxiHfDQB38uOXU/l9cl+CESmIBj53Kcc+N2sblBlwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=il/UorR2+lH80Gk9VhFvTQj5XNB5FlEuuo3w9PXrNHA=;
 b=PwicKC520Yk6MF0wYbO8jc3nwKPMNUSDLPU4khq/8p7rB8WG5lF6Pp2YpsbtdN6AbOZdWUZ7+KUgIrRsz/U31PImrkwsO5wEJnVWAaEGyuyGOpmR44sZo/J+8sjO6ACMT/wGFeAA4e8i2DGtVSml4+KVp6qqCFa0Br/nL22PUQ4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:50 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 12/33] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Tue, 11 Jul 2023 16:45:59 -0500
Message-Id: <20230711214620.87232-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:5:3af::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 238dccbd-5c5a-4d8a-6941-08db82585515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EcUbu4RAa6ZUEsr9CHie4ORIE5KvP3pgPIVdlrJOGdGwbngw5jprtdIWVQGfYCWuumLK1zu9BjTaX5PkpRQ8OdTeT5ZnzlZgsHVjJic2BrikigfblpBJE5KPEXtAPjKCyiDoB4kkRp3EgdchV1YCG63OMrs/4dkoYDcn7DcC30PSJ17YLVJwrSXWCTeO1XFlPdzg/ZlBZ9maG5JCOZhjmAog80Yfn9IJxaLC6iQ9qLDQfc8n6B7fi7S6wwQHSvhLOpgbNiyvZSG/K3klAjO08jjqBqUP4o8fUGlXr8Y/TlaZx9TjjaczlU4sAAb+4wg2ET/SQ8uScAlOi13YxkSvapiNb6FNQGfTp7p/QIYe0UiRsiqjuE2hNiRHAF7C2S+InPXY5AhldTRZfCz32PIrx5ynGCwD0F5LTqOuan73awzCdhp73YTKJADnCahiwGgAb/nXnwILx6+1PpZ/4+ns6GR7hKyk66rewdLFax67CkWHtqq+lsWBiwO3WpBm4We4eUy5mJPKQyR0VFgl0AkJApeH1WF2rXzmMkUwHryk5bcNAYFNTqugjl7RvtpMC6HN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FitrirLlYJho5QqVhHJNJB+OMM/1hB74XXjkppSY8SmmFupvx0hP6W5hlRXP?=
 =?us-ascii?Q?2JYOaJo16aK5+g+omPHphqnIHkbWjavE+c/sAr7m5lRlfo/KwGYh+PuPmg+P?=
 =?us-ascii?Q?4DcjJqKy1O3QV5HHTHkpsZy3Tcwnq5iIiy228jRSXRG4fgxlILrDQ7JxEQa6?=
 =?us-ascii?Q?onB9Hk6vpz5731AREkTYURyxkjF8AAriwRBUU1EyVyRzZ25bxWmvDXS2VNRV?=
 =?us-ascii?Q?PUsXhDjaXH+Dy3aEy0SJdvNbY9htCaEcLcF9OflJhpEfvN3vbRD9pzoIHIcG?=
 =?us-ascii?Q?8f9ppb0g/LU29n6BUCqmnrZwYMUi5/yITBC+CaLfzpbozdVk5jNNPxAOr6sk?=
 =?us-ascii?Q?TDFAqR71z79pVtzMgxK7fOVgJEdhs7vKzkedF4nnW7PMZkkS/jvKzSLR7Omt?=
 =?us-ascii?Q?p5lp/oh11L1+AbqS4CDCs2IlfJWvkFJHgiPOLtLbTbIQHGgvUwGXatJKYpde?=
 =?us-ascii?Q?QX5PXliQ8o63lxdJme79vVSkwNjfl/4bxVVHBGmsBa3xk+jTnTsNyGjUzsSa?=
 =?us-ascii?Q?CFzMqaa7nb+QD/wRzjLE80gfRgF99XHflcGMLwHygRsJHKgU2tKDDUFvGu0I?=
 =?us-ascii?Q?DQDIeLu1R7UfjJoR7TqTh6DCzqJYZEPBDSklx/SGRNK7IB1bnZ4SU6Zvwej3?=
 =?us-ascii?Q?8oQlq+w91jaVSXplyEJYSIezxW+bkhe8F2DYBmV7vZhvs1bahrniwwusjVAb?=
 =?us-ascii?Q?lhgzkbquubiqjJo6vUC9B9eXX0YULwk70GU1xHetLNfJhTUaBfoNvxdBTVws?=
 =?us-ascii?Q?RfhleZP8UouCgX3YZs2jPy5J5//QOsU0kBnvmrdhxS8pXgRjnlKrtIXUfXE1?=
 =?us-ascii?Q?KXzpa6jAUD4URY502kLQMs72WzTuS1+NTc6DhlEezZQNXdwYHnnObrw7YlpK?=
 =?us-ascii?Q?fliV0nNfG156oeVguMNBmxWIwwrX1uWssgnsS83YOcw3UDad+JLyldRIWuG4?=
 =?us-ascii?Q?UCFlgiLZ6QdRKu8QlWfofSzkX+OIA+r7Hy4m7zoFkR46nd7MiN/orXUvRlkl?=
 =?us-ascii?Q?2vx021yv+YgiS7ZSyWBcpTycRgtv3qIEPcLUPNmzBcDypoUc8YYRN0ajVb2A?=
 =?us-ascii?Q?823ClHdEmB8XKYKmLwm9++z9KA3CPDgdbSuw57ZTjVbwTyu1WPQECVgSRKj4?=
 =?us-ascii?Q?rlLXgTJ1spA1b2HZAz8ibz8hp5JaOWXGcWmVydOWiFX83XMAdZc1gxRYg7//?=
 =?us-ascii?Q?r3IaV04C82majCB3xBGXJxlMKTZVB2Iwvz1qbx4Ud+yFzmXzjNJXt8dz1WG4?=
 =?us-ascii?Q?NGgQ/n+t2w2uFbHrRHoOc67ifYJt6MGNTkiQ3lQIcf/3PAo9KWbiBOqG2ASb?=
 =?us-ascii?Q?qZYw4+w/kyBDmVyIgo1449kIQdHxCPhWrlq34ZEVrFv+sq67lfRTD69nkWLN?=
 =?us-ascii?Q?xClw7C/WyZaMkL+PeZT+FtlpV3MBKNP4Ld73CSvZ3Tfv0VoyO60eDQ0UJqJ4?=
 =?us-ascii?Q?jrSeilZU5G4LGly0D0jCHIaaN7uQUztPDesApvs6vKaW7Mwh/uYDJjBds28e?=
 =?us-ascii?Q?RIZtxQKe05PRD5Q+aH0pot4VwwVnsRoRWLhgXdmR3nG/MA6g3MongSvVl4sm?=
 =?us-ascii?Q?AP3bp1hFkywoFR/vyTlfEPBxGp0TiJa5pIpcoq5cjvYX7ewfC+5sbToZaTNL?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YqQvGdGZizsis6xD0NDIXlkNd7f+TddN77acMVrJEJIO2MSFBrDymdq0OCFpnPvyeBmnAVxcz3NHi+OzrSyADDmRO6GyWpaP9nnb4mdBNgot8bLuAlB+TrKT6YApT3aqluC1pRxlLxj8t9WO9e8h7o5R9+h9x724JU0bJ6luy8pm5z/LrOvRpuT+MWlttH72avP45i2E/x+jPHjoEOgJxuQg0TJHbdAtBIlV+MiGaFBZYJHrFjhuPS8UAm46pRhbN5GD9+ZPMMwJj8UPAGuRxa/8IQhPMtIvSL7xE+IGd00NGZhHzue4Ie6qikVVVGTgXRcE7JcNTkX0MACchsnLtrKHOKXTOSo/UCKrFziZz3tM0pI5KOTfeGkLISU2gIsuwnFCuYz6sZtAI+JDwGf66cfvFCLXCH/HCrkuanuuF6zgha3u6eUewd59mpBCI3w9BKipmxOD6uSPjD+15JHVbdLFl4CoE1o7vGW4T507u0lvpjc5/XAUko99Ra67e9Vk2eGWxSXszB6KrJb22Z075c6LxxjeN4JP04FvpO05YytzAzQ6enASchPTpI6aSJFHUKC+GfDOVXRQJVC0DpW5xZ5iOepyjP/Ni8nxK5YgyFAX7cbFwSA7UzaW5tsnCpOXTBtY8Kgoswg/oeWuFYFxrbIDLWj6nTm6fm0sUnmqS2X8M/bvmFf/6avHg7gChkGDiFDOO5I/OJ+jAE7bIXhk0bHQa/joy+nrK/8iC4hYmy3ejYEjTZlQY5Fra1ri6ivEvy7vGvDpBjoHnXqkQCJovLn4UDGPSCDPADCSuz3bux9p/Paqsq+62GbQ2o3w8/Ekt5bOVyLmwzo6YtjBSTwk68QxNX2Dxb534FVJ0KVeOVrGX+MVyBS2zvekKma04f0Z
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 238dccbd-5c5a-4d8a-6941-08db82585515
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:50.1666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcLSI+LZpMmMJEUOeWTQXh27zP1r/afYf6C2PBQkm5nAlMCh+h+3JH4kFIxxKLo2Acx4CQC42uMxnElhqW/vdq+NWMR+qi9qtvaLB//4c6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: XyRU-1HUS_1qtVdMqXiuEiDyVUgq0DwV
X-Proofpoint-GUID: XyRU-1HUS_1qtVdMqXiuEiDyVUgq0DwV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 42 +++++++++++++--------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 785ab2c5391f..63d146f933d7 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,21 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
@@ -105,8 +112,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -123,14 +128,28 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
@@ -143,13 +162,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.34.1

