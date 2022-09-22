Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F26A8C6FA92
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiIVKIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiIVKIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88334D58AE
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:50 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3roZ018118;
        Thu, 22 Sep 2022 10:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=plC3WQSRvEDYbqIGNRhGkYdKilU66HlgQNOCltIVdLc=;
 b=MCGzcZdRF4zapUD8ZWMJjKlLNCb6FUDGtmVb7QdoGXZLehK13X+fUylzarCqMrjaV74G
 lBKmPEBb2NH3W7Wf2gzS9Nk2Xk+A7T0K8ZoapAH/0XWi9i3n/alVXPMyV/HV4CuKOKOl
 LgbCy7nCR8XZNmH2EL+K4l7QR8yRLBBX528IaiIpPkNV2e46NC/DEZIPRMVpzWL641a7
 UmCix9Df/+IkyCPwSMySKpx2SGEMEYoaWeHudGH/fhCV55HxC09wTV8h7K18F38MFKN6
 XPkr1H8Cy2xVQGU8/KucJr9qHQORHUGNcKGq76MhAXqVN1kLsHYzKVRzD4rhES5muOro 1w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3ui001237;
        Thu, 22 Sep 2022 10:07:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cb3fwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSU3smeqXIRRW39lDRNo1ffw6MhvhaDfC2NNXUk0LgpKi9ftXa61jpB4K1XU9AD+bHSQWU/z4UG8f5sM+PBcSLLfae0eYo97pKdLZDFMUEoKJmcz/ZwUIC2Oooy/MaYgTfX2X6fKU+TUP9AsSrh5baX0r/qV80AU4/ExlTGITcuLvJDOck+i0dlkF9WQy1Y720CnzfJhKQvtuIkC771Yoa1rxfV6GF2c9XpsmRU5ADxtaC4NUCplHdSOqsf6dGmFt45fGkeYntFNoaCAogKPqsk41tbdhZCycoHV6j1WeEA0Ov0oczv/SJ0v/ttwzAbUsQkBKrAlcikWcOq07DhjqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plC3WQSRvEDYbqIGNRhGkYdKilU66HlgQNOCltIVdLc=;
 b=H76VvwTs5Qj0EMjhrGqJQP3G9VLxrkfpyORMyAl7JRyvoT7/TgCSiljiKOKEBwUYv4m+9LxpSDUfYZSWbUjwe/jSrE0MdfdmzVcFORe2iePGAYSgi18lPMOZik+rAHp7Flv8FWV6BRSTuHcWNbOTIBzrvfxE3uHLbaa7rhIAws3VlqL6m7hMBYAPm52EjwFtQ6Qs1kYY/iXHAxuGnyibUt+/4TcYFrgbqProYCE+WOA1hMmp8vvP8mJjYpOjjTpMZmMeNjAAMawaUjXTkQ8+EFsT/Sgr8UCZ2MekEqYku4ceJ2p9jkVXSx3OeIvUgKGJcHnMpnP+KZE+ajIVPLE5jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plC3WQSRvEDYbqIGNRhGkYdKilU66HlgQNOCltIVdLc=;
 b=g83eR2s1PsnKUbFe1/9fmK+U8xNTyj20/MLUIzHDW5jj2hhWM6xrhYDDUOsL5ZvIpaoCBz4KxLiBst4mkehZNjefSCqEsZw4fO8BfIJt0pbEtyigwJ9fCG0h7LnhM91EhtPqIkUlN+eodc9UtgVnK9hBfFnw9NtL/MpxymgfIbo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 10:07:34 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 17/22] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Thu, 22 Sep 2022 05:06:59 -0500
Message-Id: <20220922100704.753666-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:610:5b::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: 6af00396-5dd3-494e-1263-08da9c82451a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2TyEubpZSpiuWwVUfh2I9zgi1/3DDem2NGhGeoKMY2tWYk5TiXGu5vT+eYG6QBxXjBJd0mM+HJiWqmugjfoEgZbFQHvt+Cf6xdAUjfYw02XA1yN00iQDsjR+oNtl2bFuoJwWKhmnq/N37VAZlv1FIQzZys4VODp7kSkEVhiLKfi+P10JZO94tDZ6A08rd3vbF9junYBlJK5JU37L1udhEYTd/S/ZLqgadtEL8Rfz2Y/GuIdObKByYl1VQpjaws1HoNrzkRwR8XQKWMJEeUlcTMSkmtQvl8Wr9+LdwYC6EBlZmQu6aa9osADh6g8SismXPlFmjjM4U3TuLVbvxyKKhNenrgTOdGwdiIJGyXkC4G/qpTlAlGFklFX8TSALnTZPSSQe+HlQ5vbFnxWrQJsQRoowclVT5NZmwyr/Zpq80H1iY4cvM7zMkMo8q6LpioqylirSpy7BPi5vcxx3RmlsoiAK+DErI2XcUycXaKmFvfThHew6hPsOT5ZPDdwKmZOTolINyfPpEMLAFabpjfIKhNkYH9+PXnz5zvbSNa+1yYF4f0mSBO4L8xUt4oSFMYx6yPYZ3hiuB1ZwtArm7WMcTxeIy4loehOY0/SUCR7nAyJt+OiyTQ5lK272LcluBr5uQDPWhMjIRY6RjB8T52lvzu+IdHbEr4+bLELW9hrb/IfaTkqV6weRl7/oN11pXCjBPo0ARxfslvq7k5LfTSjuIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(86362001)(38100700002)(8676002)(6506007)(6666004)(107886003)(26005)(6512007)(4326008)(316002)(2616005)(6486002)(478600001)(41300700001)(8936002)(5660300002)(66476007)(186003)(1076003)(66556008)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xUM171hW15+rlTrjhTnyFUZyxbHUzGuZPsCyjfXp8p+e2iGAjeHfiQbNoiyM?=
 =?us-ascii?Q?sNRlnlvZ0xnXhqHYYzv2QmlaSgqHnzUQ2xQvKIqxAsrYO5ogq6bJL4rZBxIQ?=
 =?us-ascii?Q?S66Tp0zdbwl4oX4OUB+ZhdwaFo8IqbCaibjXAbBVD5kkOApVujcxkctfzuLZ?=
 =?us-ascii?Q?hVrVpPtcTS1Aj8/5bZyO7mmOigcjDbBOfF/FiBtkP1J6q2yZVGzCl+V+pIs7?=
 =?us-ascii?Q?LfWjT5+PjehxISXtEu6F1TybRr4Y8Q3J/0t3v1nMFcZkEW0VZ1c8Z1zx7tk7?=
 =?us-ascii?Q?BWQ0xY9EWOAXFDodtVuifcA00us8pok8kURW//HFu5nYJGOpkT+chOT3orZW?=
 =?us-ascii?Q?Csv/sPq8QI4f7wg/Slipmzc411FfuX88k3AlxVI4Ax1JvIjAupuTihVaAEd4?=
 =?us-ascii?Q?sDUao+bsC6XQXSp3GdQjour2hjDgg4EbUqhW9lyxVZkzserSIaChOZuGfxyZ?=
 =?us-ascii?Q?tpJasjeTmjO/DdDUOPDp6snnIMc3NRyN9mJ51AiSVOnb8fLjwqm5bPMPAjyZ?=
 =?us-ascii?Q?QDDvWeOTzaJULojAnlg3sHdYfVwDMAgIYzbUsy5WoqblPo3qNaBLAqbODf+E?=
 =?us-ascii?Q?IHbIW6HE74Rieq6O3XAjVAKL/WKKKzYizLGFPSVi0RXn9fJEinHLPoWDfent?=
 =?us-ascii?Q?qRYhGBlr+hz5gZf9kGQdQSuPD5a0RZqgIS5e22LjKjDDrB78FNdc5YVofQXX?=
 =?us-ascii?Q?2MPSWRQyUPlkMK65TqFlst4eeGMG2VP8Pbk5UIa+ejVGqOimfasPHja51yL1?=
 =?us-ascii?Q?nGbkzXWBWwaV2ZKNVUcVujRCbelYSab25hon/WAXav2AmgVAtrZFxouYiGff?=
 =?us-ascii?Q?bNPYN5wM/VoQImZWK8W6T6XdjfbgY91d+nRk8ue/OUyhhJ/6sRUqhlhiFspO?=
 =?us-ascii?Q?0B8PowkcmWnszTFX2LKze9iKNB1Oj85Gdz2ywfJzFChPdQaVHA/iW01KqPrl?=
 =?us-ascii?Q?skYst4nI5F+2qpoP8L3Q50cx448z6RYjm/NuaRxN7NkG8/k8UB9xJyvMQd77?=
 =?us-ascii?Q?vmCsCyxUK8M58LDAwzBuGGIMZOwE0nAxxecqzid1hWKa5SG6LHQjpEHpO0cS?=
 =?us-ascii?Q?hXEtWHYGhRxDMh5G+3E2EmBUC+tSIG4lYu3X0/MQV09dKpQfSW/qHX0JmsjI?=
 =?us-ascii?Q?TXMNlNu+NBqJa4MSe9fHJGuRQY3d1wI45W1P5DihoDNLiYa2dlMd6Cm570xp?=
 =?us-ascii?Q?sKg2QT07oyMuWX+Qk9+Alfk5gNEFV4KiR1MGxUSBPw0d+ae8nL4ZYw8gWHKZ?=
 =?us-ascii?Q?YfWcENdYD56hfwf/saIPk0NMmxh/GZCU2nqOmR8y/cfvMH5HOoi62XlrZyxq?=
 =?us-ascii?Q?I+Vo+5dVYlWDP6Gn7/4jhWZhEbj6C8IogiRaRqmzLSCVxbmIGLhukK9Sb/VC?=
 =?us-ascii?Q?KmzNx46oKHkVGV8aI0pE7HtokXZshvRtbpW7BaQnjaA4+PKCsx77pk1ZUmB2?=
 =?us-ascii?Q?jD7FJlWVi5DvBpA00qP4YAkhlXn2Fl+JtQ61oZHl+ClU+bsLNdVzCBVWaX0T?=
 =?us-ascii?Q?re62mHleckdZXRQH8N8tQJ1/kiSY0WkMXn1k0UaDGFKUV3AhzJlBTO1dLHYL?=
 =?us-ascii?Q?cDKCRa+F4/4i1Y1XxJ5eAsp+PMm2N1vnviHL7kH2Tqj+YhlMc0ZDYr08Gg1y?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af00396-5dd3-494e-1263-08da9c82451a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:34.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2C4p/kwe6nGVFrzSu2tyhdnNW7nPw/UBxzCz1heKfxXhF/60eVhtbnz30BjwdUOyCve2KcJgPZj5GxMMkyZAFMOmeIVTp8c31y7Z97akyng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: 1alUv0gYKAA8tj3oSZOTcbIxBm9zbq_B
X-Proofpoint-GUID: 1alUv0gYKAA8tj3oSZOTcbIxBm9zbq_B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 42 ++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 744fb8b469db..836e03ca73e8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1408,13 +1408,22 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret = 0;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1483,29 +1492,16 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL,
-					  NULL);
-
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, lun_data,
+				  length, &sshdr, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  NULL, failures);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.25.1

