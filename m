Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5239C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjGNVi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjGNViR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B863593
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:15 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4bbF014922;
        Fri, 14 Jul 2023 21:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=jShRc86RcpXJp2CZoTusRJciBGwHWbF8uDVpgqKyir4=;
 b=c8iz/k15Kek4wJeJy7m3VA8vrT2pC3VPswtqbhYkh+VSKGer/M/X2ASz49ezx2f5qcpX
 9H9t9aPk7F5wTS85yZ/19uQoapsCmJx6Kko26GJnUNqpwqcqmbZiIYyHQZXJEpGmgqNl
 lqNimZy/ypoRuQFocAUqb8Tkc6Tt1nwDdpuphJMeNHVfiJ/Fp1ePDL/+SdZehfk9J8nR
 cDV5aB/f8cwNVpGNVBEuLXctUFJOO1WwAZVrbEwyWDZO04Wfu4zmjhQYhoRBMvOkVjIw
 ngFMey6NOX7JBUKwSKvuHK8AcK9wG2zMJzJyca49x5cryVQpvIy7fdafYfSXX9dTQQTp Yg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1gsT014020;
        Fri, 14 Jul 2023 21:35:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91yq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+R0mNZ2lJYNv1JSQAL5hi0SsEvGEmB6kbLYALoDjlqQkN++tWy5Q22E1g/j0Ym6Wxg4E7uttNGno3COf/TpdBBn76YU6W1AXeyrdGcoucY7oQ3N7Pe8DdX/jJBphPegPgmlFCsZLV0pJW/dgnO2yHiBlNcr7IEtjofyzNgGNbN1RXBDbFZRsi5thUDGlfKVql0BHrcbA7HSxJ4D7qX5mgigEocl8gn7ku3cnqsmzFZWBUr4Hk4WL61SmsFLLMbyaexVSMjYEpcCVtGnK9ADaq7OZ+y2RV+JYZgQZ/3hl3o5owEbrW7k48Vu92Yn89GitYPxBE7zh9m5YBpz4jq5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jShRc86RcpXJp2CZoTusRJciBGwHWbF8uDVpgqKyir4=;
 b=esBK7fhSiP1t9PmsBlobFrhex0vwJZlmnEDTTO8nB8WGgZl1oiZ4EMK60/jJAVHBVBHOE/F9GSv0FEgXOHhBtJNvyeRxzF4KLi3qJS6Up5R5bocpsFDa7x3pW3B/qzgkVIQVwGf+p/Z7RAP7VNAZkRvmzBm8lNMK+Jb3bAVEneCfyiiigheVAal3Pp34XmFeTVtJ+fckdDrIGiruGYVwmSGUiwx+rW/DElsYpW13h0IpVjtq9P882Zt0NbZswHO7oXOm+qFjWno9agtVAAvsYPsUUUjOl1skdDinvmsN9bshvZ3yGFPGV1NlBwR8yCuIQ/JBlKfCMj/VS9nOMPoCsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jShRc86RcpXJp2CZoTusRJciBGwHWbF8uDVpgqKyir4=;
 b=wFjIHtf0Tq3rEW8tP7YMJ/NkE3iKUtHAk98A/1eB7hcHWOhlfQhfkSQZJPSUjPKH5m35zDngCZsWwEemoqDjWpBbAhxwzsXSn3sPn8Eva4YOmIEN6mO8YnpU3ARD9Tx3GAqwRRlmGUupUzuS3n6r4vTv5+wUYCRxzGYs0763PW0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 22/33] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Date:   Fri, 14 Jul 2023 16:34:08 -0500
Message-Id: <20230714213419.95492-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:5:190::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1b8588-4e3f-4f8f-84de-08db84b22ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16s9yb5S0+cWcIZdvaV/NWCysvObeBpmBzRRbDkL0H1OM11AuEhebaPkuqx8Nn8FsYwVJ7e4cCQUolF7Y+mhvHFigFxywZDfKE+24YHwZRaD5M6GQz32sn59YhIYc9PopF4QwLYFsg3NKhhHFtbjYfUSt1PV+So+OrVCidlspzArggRMivwGRPRRXsfQ7IAPt1InynxO5Y0VMrXcWkJEDE7unPa6rxan1pFqZo2QTuR/gzIpEeQbHQYVVxYMOq/OCErTxTRKwvO8oAiFDkqw1/TNCI2umnMbxLvKQ5Q2AirkYjyVCngE3suCVMbmOnbzpVYOReelsuyoIFNz7pB0/SOFVus6B8g5YQbbWEkWelD9Zvu7fp3/iDeA1gQ3KvkOC/px2vvpZW3PO+Fcov9RxHAaqWFUiTUQM7Szr3qQ/yX1V6UiWLud1ECi1UUdXDaYHI2eZgZ2ra6CATVZdnhg7nocgJpfWwKyj+J+zvQ1ceIhWZjLjFS5Sa33qAcq3g76vD68mWdwT2u05+8k2a6oZYsHxpDHZ9L1vNkuyzAuSohidX5JocR7Nn3CAlE5mTLL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ErA6/ZlmTy2CjMXwB8xdRiKzozdbGbApt+SXouimHqvBi6AveQlnQIIZrjkT?=
 =?us-ascii?Q?0tCGvTfr/Szn/vgaEg+ktsnzSM+qSf5kqaoPgch4P0UeLv2pSlzFOcfw5fps?=
 =?us-ascii?Q?Ou+94KBoQeSu5pbB6xcy4Dib6JVrCB6dySpcQ+bIW7B56xmbffzhpAHG1KRG?=
 =?us-ascii?Q?XoCBzUBc21LhEu/AzMU94NwP5DG4GCsBTR7iBBUO1Ycst+0wRhYjO/wpClPb?=
 =?us-ascii?Q?4evRHhku8uurjY7Az02PAq0u2EQZf+i+eUipjuLg8xcpJqm//ReQRtTthBIf?=
 =?us-ascii?Q?1BfESgKmfpyhA2EgRtJJcKhxsEEPswmHFWfUwWOm3tkPDDvWdvO/4W5b3RDs?=
 =?us-ascii?Q?lE1B5weDn9c9HrUXKkCj7nf0u/x76VhLFIQbEPiNbj1MqtZ0MC6+2Jc5yl1V?=
 =?us-ascii?Q?8Ixc6gvgJPC024ritdapGTk0F9iTHl7Y92qlLqxawFgIBPcyEPG/Qu1VwFlk?=
 =?us-ascii?Q?2HBxiQBteAjmqi7Hh+Th4JGW0x8XHNU4LAHm9rAkTOgolWY3BgS2ihxyp9pR?=
 =?us-ascii?Q?W1g2KuJftqenIM3ch5G7kYMOACv/b8ofa5XI9Phb0dkh9rQxGZ9PlnvwbDL7?=
 =?us-ascii?Q?gTU0WFdju9k1NccOVJYueqGxDvJlwtPL2OWITAj/LSUP5Vcf0J1kno5zDFty?=
 =?us-ascii?Q?+YfQHI19AVSBamRbMFvifb0ziGeWTatb3TdFH395Y4LkAvd/jfGrcQsNtCai?=
 =?us-ascii?Q?3wThfwCpUEt/vrzdNp3rR1Ez3aJQZrPKn7aa8pxx/lgxqut4A4OCpxNNfxd3?=
 =?us-ascii?Q?SAuofaB7iTYHHHfEXU/zRILvjCxljDRZbs0iCvfANg68Dfy67CqFDfQ90COB?=
 =?us-ascii?Q?TiFnkLkDgni2SW8j1DNuf/LVzvQBz418PgVa0cBHikYrcUnynNGDB+XnQ4hb?=
 =?us-ascii?Q?LoTKpZ9fRx79QQCDjVRVXhoDALbsARdvNcyjriqzCPsrTnOOf/qxyMUPvwN/?=
 =?us-ascii?Q?dmIXkKtL0lDgjTZow41ytmP87/8COCZvAPW269lkJHAtpW2AGPCqPZwd1UzI?=
 =?us-ascii?Q?1zHnB445TY2ct4yEpXiXReFPZ8Ef0CG8vp4xMxVn+Kl2cU1To/UcitdL33GZ?=
 =?us-ascii?Q?tTQAYV+oFzLTPX6VO4RYnsQQKKmANY+8NZCJmIpW306L87Srm8bDnBefgkce?=
 =?us-ascii?Q?Uln6kd1mXDZVufB1DZfivDu0czSzQBlKCy5w2IezJiYGV5MDLy5kNHpkcwDD?=
 =?us-ascii?Q?8R1rwHPMJ4RWAZKbqEe2TYFQG7m2Aapq1PnI/n71gASFnfTnrHwXcHpkJ/xk?=
 =?us-ascii?Q?djfqGWyOQoc4jOykoDgyLA673A7VdPZF7HSnO9hkdGpK+r9naKNs4ZPkflGn?=
 =?us-ascii?Q?jzUQTpXZ9cGVaysezbwQ/9DZJvKRWfLAWAOsPZ1RU3at8q5rNisgtE/DJ8OE?=
 =?us-ascii?Q?VZ4DMYk0OeWXaXBBosSRMNnhqoS9WoxQNjs80RWMdu0a1p94x+cPevGbGtqY?=
 =?us-ascii?Q?jwcnklyvJ5PtgERponcomeH9FtoS8Ez34Ihue7IInmbOnavrpz9Az3K49OYw?=
 =?us-ascii?Q?Egrekz2w8yt7wnwf7GnhuLh3k+VXT+t8GoFcEyOlbfafVke+45Ei3a7qC7nR?=
 =?us-ascii?Q?HOZKIMAv2fgr5LRc3RmZWqCdDnCbefXfAbUSJLERSGIrfiGhbzaUM2+U4Cf7?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mN5WoENUMepd5jfQw2hH8AfBMGEkGlj0SJ0gK0oROwWgt3f05ll/2PBppSIJV7bRCYGAfc+veVnrbLVEVOw1CM7uYmdjh29JIIrkM5gztDWS0Nrkl/fUf8lnZADohGTbDmUclGpAU+S8KSmhqTDfuS6DpJIGomw5rtEIWnJRDjLDFwFY9t11wBTd25a78+6SZejmNC6GVvNEPrAqzUm3ozM6kt0d69PD/n6VbYWmtX69Q2nsKR0Dz8RAPtdHgzxQRW/Cng6t3YsulLRL/qruFEbBE9CV1JHb30ptj9l1ClS5DOnj3JGN2GkTmAFMdJxFGwQdqZBpadn+UFmZIuPW27sX/DYIpdcoO/LVAw+kUYs8cdRppdOGGTJEt46f9Y5pMSN7fzEo1h2PbmBX3/XOZflBGfwkgKM6Sqzdcu3QklEHr7Irpg1o72P+9+f1eFjf4SwNB8Jcr5H2vfQLiBcjDUDORMk5kvK85srI5DGjkKWymuEVtkcP1Ug7oCV8QgaQBcPM3Hhz8qLwDxGoU4LAGTghZUZj/OL4/AXwdGRz1suPwJSypYwpd7noAvT2N/D+LCvp9mV0/qj24nhugxz35QvzZlUhqqxnVqEwmei7nBI4KqCIuOacSRuQL3TBUiKAJVLRtZIWoIiVTlTmjRUNemIOJFu1yrLJyb7azddZHIcoTcTft4bcNvj9n82P4s+uQg/O1Zz6NgsonsFX8Me9rR+Ki3By/1CWwqffyMwBHXq0ukJwcTGPEArgpMmqW3DY4G8lmoX8xpmLSu68FLpDRPf5lP9Co72J0Zz6v3H+iA+sppFbHXOYhwVJGVqWFg4WRqNXaWO9QTfnDtnkUs9kEIqpWmWEWS81t8SD9cYrTiUozjUDMLswFbrfSjeqgFAp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1b8588-4e3f-4f8f-84de-08db84b22ce4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:59.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RelHH2kot+c6aXBkMeqpLQKK4SL1KytyF0FrmrYsrwKHsL02bbGYrf2P2ti0eIHRSaK8XDCZuo9Ze8wdiy7XfM0Nsia1ZOTDcld1xDoOoZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 5G9ESxCgVENoQAUcxyT4m_d8mmA3TrLY
X-Proofpoint-GUID: 5G9ESxCgVENoQAUcxyT4m_d8mmA3TrLY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sshdr passed into scsi_execute_cmd is only initialized if
scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
good statuses like check conditions to -EIO. This has scsi_mode_sense
callers that were possibly accessing an uninitialized sshdrs to only
access it if we got -EIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index deac35fb520b..53719cf9d86e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2966,7 +2966,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
+	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
@@ -3014,7 +3014,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
-		if (scsi_sense_valid(&sshdr))
+		if (res == -EIO && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 		return;
-- 
2.34.1

