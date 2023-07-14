Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114DDEB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjGNVfE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjGNVfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:35:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215273588
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:35:00 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4E8C003214;
        Fri, 14 Jul 2023 21:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=/sZ9717gUsbKAIbR6r5pw5kBb//q+6sjoyz/512Cl5s=;
 b=M+5dVpI8ePccNdGeKLlEXvhxNWHkopiYDt3FdcCJ21qfUZxV3OZE9RCNBqIxEqEOe4QI
 6rFxiSI0xLJnDBuZOgLl/INmSwW/1U8aiclqgjZehFbwmmW5W+g2iXOqD20IqFkI8yvc
 QTWAb7z+D6BzynsSuErbviy9/zZEZ2V7MXHhT0k13TeLRzmpHSevoy17VWVSD7uw2git
 a6chR1B5xOPLAMtzlUHie7+ojYbc0r9O33YhcrK3H27CU7Pbs0I7lh1XqKC+D9S8DhUw
 yPNtXDnZzzVw2nVBTVpG77qAzyxPN+Ps7j+XinVKf7u5Rc5ltY23Vjkon5A7yNmylp39 QQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK3hSl007714;
        Fri, 14 Jul 2023 21:34:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrvv5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HBB2dvT2Ov/jGJyNJI0sRZNoxbDgtcZI0KNwQs4v21saLWKbddT/pTJe2AdPiD1SEz+ULeQjTpjCVB4qKL+0VgVrEXkH9x3bdaAb8uMpEqsSf9E2mtY/eVHNJk6Oy106W3kLRNtJKOanEfvxSc/3O18Wzm8Fa5hFWyEJ/dk3jgmEDx/VEzrXlWZ3JHOX5hGCt086HACuOydtzuxQlbGDUt2iA4zgtI84J6skEzv5gWauKYJYA5o4fmZ7iiCwjiE151xEXTbsJDA93/H9duXb7YXRTNuqlXr1jKGZnYqJIvMMFjSxRSljAyLxcf+NRX1DeTOHuJpgytVpTe6cpE3CXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sZ9717gUsbKAIbR6r5pw5kBb//q+6sjoyz/512Cl5s=;
 b=QsJBsuhM7t7ENRJpHBEK9pcxrvFELugjxJaTimGjsuLfOVwpbKPDJnttlSWcWeBiHLpjhRh1BateB3w1q860gE584B+Zq9yLlNRgyde5VEQQaKhUB8dqEE+EyJ50+1bcUc8+0aWk7cKTpCYG4DnwM5bURdYUMjbHC5MR2+7BIjr1B0YBpbHITfvVOI0dhds09e9lAyD/2xGetHGKdmOSm74dh0dRJPKJmxDAl6CFbcasGMItzMXW4hmsuu2LqWSe4qiywLJzPwyl2J6cbYTuxRPacPMuDvfq7Hm4pVgon2fVh1wLidXKRzMyIn/bxLoHV0vHzwkpYv/XfAJTqcH+6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sZ9717gUsbKAIbR6r5pw5kBb//q+6sjoyz/512Cl5s=;
 b=Vfs6NTiCcmmBB2QWZcb5fWva3mXCbU7hLXNMpJ6/JqtlLKDC3PFZomiRcNpMkNUYpat+ku2ZPYm5ObulLse73HW7GAocAo/pD/3rBcb/LzYImKFkm343EOzAP50Cjju+QH0w6Cr7LEBWdaDMA7VJ01lYnS7SvZvGJpm/u2T98hw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:50 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 16/33] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Fri, 14 Jul 2023 16:34:02 -0500
Message-Id: <20230714213419.95492-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:8:56::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 3038d500-c010-4a18-88f2-08db84b22720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1nHCNIXQElLF1EgAxvLcIaP6xu/V2SHEF0R6OkLxzuL3vHX87VOv5xG032BfG9zlXzuUWoD1DpgC1MUbsUH81l+aipbBxOkvPMZo1GcXeug/fkikSbBlKggrbO+8MHjR9eAjIduevpnG8JSoZc3YP8oMwJWFK6eU69ubYUl7CsSJ9GB8G39exW18x4KGlYgXCIPSQo++c1Lqp9tLR8AcjJfphZL2UkyMjRsd9c9y9bRyDKlsyzkdShgavy+i+E4+mEZSs1LWgf6oHmYazCHL04Mr0wuYkUckTU8DL07r9n2UHB7lew2oTyDi9Rby6qRYudK5wAMpmUO7r+wpJXI5kCYOW2kVyNBH5V3dbKQ+DRCsJ/k/XoM3Fj4wMz5dAkml6av6nCj8mOlLFSQFkj8BeMXGbOfp+ZYiaXxCwDTVSWS4aWR9yXkXn0FKg836MLJseVOr+pecf2VSnsrWE6tD9GMUbAm7Rrn/7TSeiHaT6hY3blL5rwwxNF7Wa0DwiObb/TQ3VTLg0Ks8Nys6Y6/aHN86qg3/X+aXSgzca4blEMzTvsFlwqOK7Ah2VmM300SM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qc/gd/7twUHwlqcz7Y5MVWMY9EvyzdjlRdqeQZKZVwcfCp6DgH45tnl4n93r?=
 =?us-ascii?Q?KysauexhpxELsg16qXduXRMM6GPe0Du/ncUdOzrviEnCGs8UinsqE+JwBqV2?=
 =?us-ascii?Q?2W4k5C59QvHttGpRqiQ7gKRWG+jEp27dUAMVn5oF0tNNmnM47psjGBwRtPeI?=
 =?us-ascii?Q?jepAnOlx8XYDrlf1d5ndL35ES9WbGY9JhUjzBdyygJQqeeG9q0qYDMvwuwiO?=
 =?us-ascii?Q?Fd925uc4XOKPhTY9u5LIJAlmS71lyAgIdPnYsp6zN39neOW/Ym9MES7X7CHh?=
 =?us-ascii?Q?eoxl4J1JIKgeujyEzSFVcpiVizk0yAt6ijP2Lolj+tmmhXJQXGdDNmX9FPDT?=
 =?us-ascii?Q?zXKBj9+QpcieFR3p97vH4eS+0Wctredg32GjxgoRu5MQsEggIxAdt/UwR8QH?=
 =?us-ascii?Q?AafXx+5MI3NFTZs7BUZnOUoa3OnwkYDb+WHweNPTNDhZY7LL9KTTiCpqZxlj?=
 =?us-ascii?Q?beNi67he+4isARn0bEWkSwZv/hHjcEEe8tfLoeMN0ooMLNgln/R98YR1Jopb?=
 =?us-ascii?Q?BAR2kb6DAdrIYHUi6avqrIyacT1MRb7XK7Pw/kCqZc7dFrOnX6vA3Grgb3Ef?=
 =?us-ascii?Q?ozoyRdSs4lZsFn94NOt0SbBkKnhSY2i9wfzT5OXaj5bSU5Y0HpSuz+wcIxxt?=
 =?us-ascii?Q?fJ/HIy9AcoItb5hweu2xFUcDFJBe3YzKp7k63oQKUSFig3TC2Kstqfe+oFVS?=
 =?us-ascii?Q?Eyy2FNr5el6W18UXlOyey1XFK0OVNyw3dsE7Xv5N/UCBm38UG/uNrRfdqAVI?=
 =?us-ascii?Q?2P6w6n5Eu85uuOVuO+E8+MDItVald2Xweq/m0DPInw7WI4MksoxiZIpBtfSl?=
 =?us-ascii?Q?6i1o+8Uke0Yhg5kdg6WHblFxLgP068S0XAmScw8OBw8sW8r8DJxcHnHl8gV8?=
 =?us-ascii?Q?6oXDlx+GCTTurdlH3lh9DJ5DSqgScpWfF/m/McvfsC8625EVrrttKrT50L9q?=
 =?us-ascii?Q?4YsaADZ/RXBcMXdQshE56iy/hxQXwFhMOrGTfIdebNfthbt/qRgCuCtfJ/bm?=
 =?us-ascii?Q?aATAVjj/7WrgAmyGrS6fk8gWCYJTWb/TilLmTA0gsHlB/7szfm2B6wq8QD/A?=
 =?us-ascii?Q?+6yKgnm9SpoRdt6vmPVwY56hl8TPqaYK9QzW5RbKHMosd0n6jGLLfIA2a55Z?=
 =?us-ascii?Q?Ry1e1kHJKkLkaBGfKHdxQAozIg9ESLapGctI80UhkDep0hR7huReWGcaIzYr?=
 =?us-ascii?Q?evnxlx+yAMvyuBGYQ5w2l3D/VzhX/PT3+r4PD2YXNx0FtS5YM7+PRVDLBtv5?=
 =?us-ascii?Q?2UD4V8Ea1ieqDMDrAJpefoTNmLMRQyHOl1y6L8rimw8r38bpsC9gFY6SffbL?=
 =?us-ascii?Q?l/eDhrucITKRfv6i4CRdtP7h9L6aqq/cnrCXww0Fiy1r62u/YN/eagyZ+DK1?=
 =?us-ascii?Q?Ue7nnyFFdAifFItLeGqscRPVvTt3ekFi/XLBeF69eXG9OnOTiTGensK0QRae?=
 =?us-ascii?Q?fcVuz5L1XHnyaiX4w64M4VN1ns5lees0iL8tZK9g5vD5OTdXKKsvAFMEHp0E?=
 =?us-ascii?Q?kuKhDVJmcFiw5zYjKJUiS/7OcGGHO7XRl1QE/OfSI1Bs2UG5UudIrI+jfQq2?=
 =?us-ascii?Q?iRb2aYtuB3s7iLdOfps6/LpLL7NLs9HC836LSFUVLIyv8oev64/Kc4pqi1Zw?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GCNfZwz7kmvsK35kITjeNignPcvYpdmAu9kX3QFyHKhZoFsuLavhcgIAdBhLtV2bBvygEtEkHIDYzdJV6uKP9pL6uEQhNofv8C8An2n2/EidZIb9R4MQKx7sxLriYV0GRuG1Xm9eusWrjzP/w5AMGlK7X62MAnHYl0k6cwKvI4eXmSO2A7udhl9XpEGiM0GBVi/tw0zlyGcInt41w7N6xI9seg5ei3NvHWCJ4rmvZ9DPiZIyhqCjzN9YXtw6tu5hR1Ih0JyRpjLY+w1xbbyqmvpRRsG97dTVnIm0G1DlQieRhnfAB/HhmAZ3PJmbaRgyk2TjDUeseNnKcHx4E5vrt3CBimpg/ma88r9TDh5kFhOC2eMOQQYkjRupimPF7UBiGwZFBD5dUdk5zPrVmF97XGUAcqimk+l/DU40zP5IyrYaAroaJlJTTZ1VJ7NJk9pZovSefPrGHhMhkxBlQy1qvM05sEfYbqRswt8qPFmPCRlfaslxXeMr1MoOQPtYngFiASjr20GbPwDSnKZnVbK+qUCXTGrx9W9TXxIAs9yboJeHZwUSSyYaFWSDrM5OC70PwHAuduZU/quKg3PzCluDJ5b4OUPqgD9tnUF7QF1koG3C8+qLAMRkt4LfSbHxRjC9ykDeFw9cJZeR+i5/xgvRuJgnEdW+AhMWxIcjL5GPEwE4MDnpgEr0CFKCsJQ4IBBIq/M56557W2jArHJYsfwqvUrSMkIZVTI4ZsNz0ORP7VyEVcsFtWANUXSIpFWy+/9SfdqkXOzi872D+GfMW2QWjQG5d1hCg5XP+AUl4PI1yck9ayXq/DQTXjG60QznV8XGuSuzHbtq4OuSKFpoZSxf8lRe7kp4fo+3g1ySJ+ZN05yLCYQGTZQiAlEmVFAEqkUY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3038d500-c010-4a18-88f2-08db84b22720
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:50.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJkJIfYqeDYkrSFKX3NWOIZ02uIbF4+G7rICpbULFGbklaG7rGWB0dfkJHdaXJ+heQIo0rB25hPWU/IVIbceL6If4w13NxWD5ZVDjOEYmyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-GUID: BljgZ8G8ALf7IuKEfLSEVAGRKGZe8MW0
X-Proofpoint-ORIG-GUID: BljgZ8G8ALf7IuKEfLSEVAGRKGZe8MW0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f668c1c0a98f..b2f5c1d2b451 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.34.1

