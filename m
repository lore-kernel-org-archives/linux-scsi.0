Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BA0C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKDXXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKDXXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA395FCD
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7eL012102;
        Fri, 4 Nov 2022 23:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=QNGzc15PacKj7inRAMIB7zStEj1d/RXNgpbOWGYUQevA5zoPiFjVQUrhy9ZVvuyEBPEA
 fTdADGnZ2HffJmu1+iVfABU1C5EaMqvOuvAtLs+w1PiSDu0W0TKZas6NGpCWnYTunWvF
 eygCrVmmz87HYTLu5y9Zch+Tv/s/RJ2Ifj7PbeI/eNTnCzAqbUxmR45SKpMoSXKkFhIE
 Rocy/HEqalHamcf7heA44SavOcYOGh5n/8RNJXdAAUIMJPiu2CLsZgfvw1BKgbGGNHB8
 mAS6uFn56Jxwo1GZ4KmZENXCg09eIe6SKgSzjC0EU8hUiHvN74SlQezI4QC57nl88iTD sQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgvqtshvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4MI2F5012011;
        Fri, 4 Nov 2022 23:21:34 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8cpa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxmVlevXBMHxvSf7FgF1VFs1ZR5kzIqnGmYKm0nHgvDkjrSUfZe7yIdS/iQfLLNbWhkV8F5xK2wrJWHxo6vtEjh7FO1D9khX1wWJCLa59av2Zb/aaLa3tXGDwLiOx8jS/Ibr8lgmAhmwruqcsmjb+51oG1lyKGccahTL37nwVZVoXnCy4iu9WP4/nMBpsAQu1gAPnyUjzpPMkzAQIYl9gy3wS1mcqKqVmCFtz4EY608fbEC437m6uzoZXu47rnK5fnkhr74s607DqyxGpn4vwKGi6oGbTl9rMM3qehYZ/gPh0lnyqpFzxnP4TJNCKsQJ3Qmw4OJabeM5Ydm3vg3vLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=busYgwlwBT9c5AG6YUcN8ZGVaGC3ezROgv0Pk43k4ZNCDNRn02hITZEdlF9tPEwzeW4QxrIs4XccKzmvvGKsiWLTrbT78mJ3Q03WZXBRyZkjx5c8mzHKpswRSZ3YrobMjKfyER2DlG+RPnsWELX+J7oNsFZIIK0MpNSz+tICRt2F24wRY28vfmZih8W/jXtBlbuRgWPTULQ06vNoLGSzS9FbHuy3sgVcYZbll4z1dEz+LaHr3XviYqnaCZYv+D91kpqGW+y6NM6pMXi/scNVrUIDKAOG9SPFsE1UPL7nRjpHRU5LNAJODeA1g3alXGUaJIZgsVKDOLVjz8Swf632tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=o58U2ml3G4/5eyMZ0kSLTEeSOzvr7CvNMZPMQ5UVOLryOOFguX9ZANcqnDDMfJmtLGIZRDPlixCC8fpnhG6IaNiW7c0cHw1lygxehif+XPty4gicD4sbdPgmLf1vw2JlP+V16wiwxd/V5BnaltQKtoAWX2Hkir4MYwt3VoSbIlE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:21:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 05/35] scsi: libata: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:18:57 -0500
Message-Id: <20221104231927.9613-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:610:cc::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 9332b72c-8194-439b-2e8e-08dabebb4f1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqzuU38AovqjHjDmi/wC37C4xXXecRQ+CjmjDIEUVrkNYDQ3M2ltlv2PC1m+DL7YhjxiwSSv6/GnwkpS3TS8Wl7LDVIy2ZQZLBvtr5igv1cIwLU+oWDMzVeuKf2OqKjOI8xxPNgZ1IFAEZnPjFOSsYef36GLXXnXEBugjEU/AM54UhJaU0dlznXhh7q/QRzjx8atnK6D4ZHRa47OEUgAstFwA+ENMUMvHrDrmPEzqAKhsOqspP0Cu9HtLPgx1r44cmQ7TsWPrK2f5XYDMHhEUmaLju2zZaHm9NC4a6dhX4DCFMHP8skwFQhebB38aqkGMf2DVbwCC57eoWne4+8YzkB+E5SGiu9wBWEJYmyQXDF/aOtXkh2M3JoL7k+1eBJyqVooG78wzpVZYEeuAlyj/2J4Nfvpb8opCs+qiXe7ucv5A8WuXRJePr/1j99DqkGBjP5g4CR4Tk2T7YPJvB2sgESg8sZvoXd/lBs4A8qcE9ywCYQARVLn/l8vXZpBBvNsOIJv7JZdelmXomQ66R1GoKbhCZtJFt9IHmrxCGZZ0w0Gm1LmwzdGo+nmU+C0lZi8A6NsPI/lvOmuwtWXyTMxlyZGiTcQgyE5Q5xpzbvu0xhO/Km5brA7LaW7Kfkohh7t4h/qa4GZ1k7Z6Aq+FrBPn6jOeVwj1Bi/woiVTiPdcZcjLs5McGS0LdeBQOSJJADb4f2AQcQNGvYsHJjoFG0beA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wfzuBFzghimf/Rz7lrIS5dCCZtv9FME7vZN6LHE/wWaKHPl+S9H/bRa8X7L/?=
 =?us-ascii?Q?SylNJfcOY+E9A36eQPbNOQEiQ2o9lyMQJrSwntXEHbks2ijmLFueq8pPe4EF?=
 =?us-ascii?Q?M/5ld/SB0QQmI+ZvaPTJj97YQ2WH4+9qY7j3xxQNSumIGtu7OdfVMcBnZNMp?=
 =?us-ascii?Q?uqcomCB9aeUKLXMaFWu6B6S7fMZ3+rkVzM339659pTctRuxYPAO2e0bm7NL7?=
 =?us-ascii?Q?SDyu4RYe/zCFDSr8hUJzj2PkfyQqYEnwDbaBKwNbbk7wYPealqjUprz7irO0?=
 =?us-ascii?Q?LWH1b9vl1PE+rUEX6WR9OFfksDm1ZasHLWNL2lXsjwV+KDyWTRyXsHZfQz9m?=
 =?us-ascii?Q?EgjblN+5u1WJUhCnHJ5A1pVapvNFX2eEw/coSeMMPFaAZkYeTjTbvUz3zIAH?=
 =?us-ascii?Q?IkOYdceVudxbRA1TnQAPijonFKzqECvvPQnrGx0FIDojDw6Dy4JKTjXTAG30?=
 =?us-ascii?Q?lgpjUHtuSetYbgKxv8MeSH5EU3n3BpVJLWqEqBeuvDh2X9bVXZiuTHqHaCgI?=
 =?us-ascii?Q?EqjHxoTTUMK30XHiyTQs/IbCmJplNBITjNPwdHzBKKi0rrQEJk6z8z+VJAS3?=
 =?us-ascii?Q?iLv5QFTBMUvlMjtJWforwZjtaNpP8M36iW82bk7TCrqK0Y/CoWwwWzd32HHw?=
 =?us-ascii?Q?b55m9W1Jz6AEPHUjsQQaNOu88F5bT1WcstYS4DxL447mdt1uEFVWw74KVY1j?=
 =?us-ascii?Q?WcFYn0B4RzxH08kQyEDsA00zvYEficKeZJUd6qZZk/KE3FwuCj5cMiPUw9OV?=
 =?us-ascii?Q?ZtXoDP6ZT7JdaAcbNEba7rYKjMAEYA/K2kQDIe0Wwm+KuwOXoaZs/u+KmZly?=
 =?us-ascii?Q?OIzPbULzw22Mq5JYj/wsdoRfTYvZl/j+q8RAJiY2EB0jDAjVWqZzZF5+7TVl?=
 =?us-ascii?Q?lyazp2aqWUENm5qx3gJukSG/OXkxx0VGEJ/1pitz+VBQghwhsY/lg01/lUp9?=
 =?us-ascii?Q?BpkhOte5USP6jGwJSuh/jYE5Eq26Os2W3n4NTQ+rEO8mFyWi/4d99a8FiXtR?=
 =?us-ascii?Q?/B12zd1y3ZxeVo9od3RZaADs7K0lrWv2QN6LxyXPqGSnZT2N6Irn3XoGE5K/?=
 =?us-ascii?Q?DWyk9oZO7dmgNqf42yme+/6IWXwOtzWRL3d46g9wm7K6Q7sJmvUcTGHy0koi?=
 =?us-ascii?Q?ai7z3di0eNDH6gEzY4NYW+Tsv04CShePJTvTagelkfUzHV1UxrXZeMudSb5l?=
 =?us-ascii?Q?HMUNRug2XSiuV+DZbZWN2ydCu2BNTu5wP8/QaWrDsjpb/9+ocqE0isa86lJ/?=
 =?us-ascii?Q?iufayceIW5Nr9CjuvJuuZON2DSXoAGWmmQkaB8BQEJ/O0V9llIQ111v8/xkP?=
 =?us-ascii?Q?V9bInHJIlwv4xUBmvgQ8nSX2NpWdjNyDXu6525qKEkCnYh2mo8S2k5xMVvaB?=
 =?us-ascii?Q?GiOxPN2cvYkvAS0oEebGNy0NuCGky8FaziAN9hCTly3xbiKlurVjKIsPkQYz?=
 =?us-ascii?Q?oEhYsLf618R8N9eyR41ptqzcOp3C5MSV1wjEF+q8DM2eHCbp1vXefGt/uzCz?=
 =?us-ascii?Q?qZlrD0ZO4QDIEyk5HxiuSbFf+P4U+H3hvn8Z0MJtLefYAtwYKbbwK+d7MaUE?=
 =?us-ascii?Q?RHV2ZNEq0xC4lhguAdvrETl2eP7efNThF3ABJU5wFqUSfs36xx0b4KqllZh+?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9332b72c-8194-439b-2e8e-08dabebb4f1d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:32.2914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m76pFqpB2iNgloN4rlUCmHyReJHsFnX4rOSiOID83ztlOXpKIzL2uplUayfO5VJy9dOmcMg25e6jJOHhNL8d9/EOuAbdJy2tU+fppdZp6l8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: U4cxkYFTA0TcNPt3Q02zkWd0m7vr-rgU
X-Proofpoint-ORIG-GUID: U4cxkYFTA0TcNPt3Q02zkWd0m7vr-rgU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert libata to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e2ebb0b065e2..3057f703982d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -413,9 +413,17 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = argbuf,
+					.buf_len = argsize,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -497,9 +505,15 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_NONE,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

