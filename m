Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97390C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F11564E57
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhBLHbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60542 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhBLH3x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:29:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7ODtv176445;
        Fri, 12 Feb 2021 07:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=Com9l92nrEWstuwbvXG/f7NfTZYIRBHd8iREgbVeOtj3akMFaBa/9IDXctQu41iTl1SS
 XurtSE6mW1ACO2T7iBrXs4lFEgk8KguhvV5sDtUN2/n9IFczew1Daft22ZaNYlZ9BUI0
 2Pw+Pe/5DRmHPZ/PvFHLjlzn7+dL9lt9qkPipPLeNfUpqqopS0wSwY5M9c16RrDz16ik
 zcYdFs4O/Gc5F4Pez3dbJ/oaRMD/bXP5cdb3oVvFSjBtlloxz4JIoWitGdd+FQlUsjGa
 PUpFLYvW+NrOLMpVz1S2aS/iJQ3XWJ+Te4Sci+HS7jGz/PIPiVWmAZAyXu7Fh3iqQ6gX Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36hgmataw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7OnuS012963;
        Fri, 12 Feb 2021 07:27:03 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by userp3020.oracle.com with ESMTP id 36j4vvcbub-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B60Vj0us5trCSBg5wWVCsZF+YLq2YiHlA8yocDd2v73YVR6GUMiYwg1YfQFsYWLXhnKnSZL2VV0ST8DyzlNQQakcxilPzwukh84QOKACrcwTb6f1ukzPN+iB1Sydkwzj+qkjqOGnwfhW1ApbqXg+UwcbpuPab0MbUVherK9zZt7kYrCSY8I+tSVtHfMFlrkeqHlZFJt4tAMTY+xfzPov97RcN9f5xbiG84J39FzdePkg+xPDfXKaH70dragO7XqVOxDlRsGOEkSwmtMeW8vk1soscudekWThb2regF4+FVzASYI6wdVu1+nVYZI1BhLsh7u+FJaQrZr4T3IEaV9V8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=JiehVUFbz9NjZjQvm7AQvaG5UfNTp9UDKd3faov7pE4WBBrNTt0ygX5q400TwK/gnpRFdkeRVUzdWNOqoOQ4q4doSOjAgkArhJ/2YfrFvHuTJSgYOI8fT2xbdg4j2tT9bzhUsFWF32ZdLdtbJVnxAlztkQXuKBvnWdHrBJ4I2c9CTHqDgimo1CsUNSER01PghEQR5raCmctedfkRXw1dr/k/IY317TJT2ZdnqQdWtDwis1OKDT+g2EDYzOD9v5IBW3WSi34IvMRRuQHwa37A/yWRVdsk0+YK+RBX4GyrXpWyIgjcv31i4fOjahOeDkMguwu91sDlLZSqOhafhFp4Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REChbTM+nyS84aN3X8b0x4n2j/YKp8W1E93Zib/qGds=;
 b=wYCISQJuPTtJRFl+4R9qY2AgH+t6QcnWGIB6REMvbuR89ekzXo3d+3oE6IOaE2QXr/tqKwkZHbok76rE7jCGpcauVXmZYitnyc9q3xuYdconWxidM5vI6HE2AeEngKXr2P//Y9nlajD8iaEvdsZgP7dHXH/BaV6GW0I09YxxAxg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:02 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chris Boot <bootc@bootc.net>
Subject: [PATCH 09/25] sbp_target: Convert to new submission API
Date:   Fri, 12 Feb 2021 01:26:26 -0600
Message-Id: <20210212072642.17520-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212072642.17520-1-michael.christie@oracle.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR14CA0050.namprd14.prod.outlook.com
 (2603:10b6:610:56::30) To BN8PR10MB3570.namprd10.prod.outlook.com
 (2603:10b6:408:ae::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98bc28d9-fa15-4016-e7a6-08d8cf27971d
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52541E93D49F45CC2B9B1538F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gF4FQSqFcb7k6Weg3A/xk1k03GKAGucKDbrbnxmrNHu5x7XUgoAz6pxPzPSuwPe3Namf+KHDCohNq36RPS9tuVnOb+4BpjO0Bn2lki1vOZZX4xuR4si2Hoq5JrCDUVyxgvfu1aoperx6yDtWL0K/mx1kLGerL4BQmkOZ/onimuOcxYurEU00xATPnbpSxiphza2GdkNSwkJ49HPL9qdFLDIxKM7K3X9E0YEsjfQJBS0rGvUdlZrOPlRixOSvv0FHV4bc4HLU9c7il2JIeeJO7dMUtxgIG+cujsgy7KWFivRzCSjI4r5BFip484vhigoyYtK1Vx+O3CalucSaB3/PurjnGq7QAEINzkwe2doPWaUuu0AtonZYrKTW4DPoXM7VHPFATRjHxP/U57a12a+cv+CTu/02s9N2GjBP1YjlOvBp9/g+lmCL7raE6D3fzv68vv1rG3VGaQ5Lra7ri5T5HKiIX38RsS0tdshvRALhhawWKFjpsCliCm+4vkJ+kbEt2CNioJLUr4BQ/mtnpCwTvkOGeUDry/CHjsH+CvYV6POwqOzhf898cWt7nfxRmAtRWDZHsn7YXzkUnnRjJG7Ebw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(26005)(956004)(6666004)(54906003)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y3BWqY1qyUpBIoEDE9p2NgVCyVJpB/t2P/rzjjAUT6ek5I8J26zVmpV7sVsU?=
 =?us-ascii?Q?FzaYOug7zZQkOYpbMWL6jt8gQ2mD3quK5VrV7PzipUTHmjkI75VxoRu11d/4?=
 =?us-ascii?Q?dP48s7pWs96mAE/METIvcYO+RuTavzbDdZIbm4IYECdIv65/vdJO0BVw/Iqz?=
 =?us-ascii?Q?UjGsOwA9R9LktHyhoE0kfsO6ntq5Gggk1QJQL+lxHrozswNOJXh5DA+E1Ey9?=
 =?us-ascii?Q?ncO8VmbwD1FRkha/1MEzNM1IkCAvBGEiIB4CxldArnLzxOH2BDoTKhgS2Y1g?=
 =?us-ascii?Q?7qkjoJFutUv/bznKmwayGYCAXFXPYocZIjA97HEtZbltNgyKmGFK4kne6Jrb?=
 =?us-ascii?Q?gkcIZ1aL4Tuqeqv7ShAfXBUPGYhoLWIqdfRAJv16Ha1/XWQgprfx6SLB/+SW?=
 =?us-ascii?Q?w3k53MOh7x0rvsraXtsP7zo/CBa/dsMJ9fHags1Oq8POA7ZWb9BZv7AzOEyY?=
 =?us-ascii?Q?VnNOp7cyby1i/xuzmwy4F3T44P7le4Xl6KIC8vsnxP6lqMhEh5AnRCQGc2/7?=
 =?us-ascii?Q?c06Gti/Bk/61FNyKR+J2qSEq/zGAIPuq93Cft6gf8mEC1EShr2bBTyN+DSXK?=
 =?us-ascii?Q?d1G2FyaGrW8PBeAcFirGBZCrcugRIYWDYKRRFerjw0AdYTbu89BvFhbD6WKN?=
 =?us-ascii?Q?hZ4M9jTwxnNzbuOCCp+z4PxNSi2fVQc0nNUqdhJeQqyMF7gwnPbkIdjCKn/R?=
 =?us-ascii?Q?nfe1OLk/TOr/EJ4QBoTJIGojbr6HJha9WD3t5gEzc5NJ1FAnYUspKzF9Vmtv?=
 =?us-ascii?Q?M+XgD2fGj2Oh9FSIyqbHKIcW/o5Wj8u8dCjvbRa325c6Ctq+Goi+rfbfzGTT?=
 =?us-ascii?Q?DaqbaBZaHaCLyW4hXukG6IKn+vTsNBv/J4dDYUbe8sBDvgqOb00ui8hQp7zv?=
 =?us-ascii?Q?o1wQLsNRyIF3OFOjRUInZPw7s5zJvA49onk3oU40UQkPJ3amikzWKiwbXq15?=
 =?us-ascii?Q?8vGTVYviyPu5zVrcqTWmrSbwdW6x1jTmjl/WkzWcCjic1hJ5yOT63UuNEjBX?=
 =?us-ascii?Q?wOhpYNjXFw/08wfVHDHip8hVY0IyvB9eBCSITKp8JECkoVFQ2uW481F1i1kv?=
 =?us-ascii?Q?/V0hjjSTEMc/wKSJfIYP0TCbLNUtO5OlbUk6xnUlTmz9E1XbUrvnp0Kg531t?=
 =?us-ascii?Q?cN0Dn2gXSSRNwDAD+m4j5esGgddZ8Q78nrtNQWHLlulAzl2y5Oz9jITnRKHe?=
 =?us-ascii?Q?+xdkPOKK0pkUsZv3RMHIgECzIWE0CU24wdzm6XzFFzgp+cghQb5iLdm3C3Mu?=
 =?us-ascii?Q?rq1AyXSQSnho82sWI+zALZ/Euyivt8u7HS8ePShxRlTAfcsWnU0+FLmGaMdP?=
 =?us-ascii?Q?jkbe6Nm/hN0zqmtE7tG4zuHx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98bc28d9-fa15-4016-e7a6-08d8cf27971d
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:02.0957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVkTJykZvhJrJTLR6tLy4nDywFdo4L4ojLiBJ7mNBxAi5kA67RQAclSMqjL60hVwWILLOto48Z244zybmELH2//G81Z4w5zTbARtmwjyLw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Cc: Chris Boot <bootc@bootc.net>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/sbp/sbp_target.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9fe3dfb..f467c50aee08 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1218,11 +1218,9 @@ static void sbp_handle_command(struct sbp_target_request *req)
 
 	/* only used for printk until we do TMRs */
 	req->se_cmd.tag = req->orb_pointer;
-	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
-			      req->sense_buf, unpacked_lun, data_length,
-			      TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF))
-		goto err;
-
+	target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
+			  req->sense_buf, unpacked_lun, data_length,
+			  TCM_SIMPLE_TAG, data_dir, TARGET_SCF_ACK_KREF);
 	return;
 
 err:
-- 
2.25.1

