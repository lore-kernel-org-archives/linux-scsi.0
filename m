Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCEFC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE4364E6B
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 07:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBLHb3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 02:31:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59902 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBLHaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 02:30:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7O1ZA169926;
        Fri, 12 Feb 2021 07:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=wYnbMINgEO0lpQsQZ8oqujXyqlQ+qKigdJjFNWv2M7Q=;
 b=N6JcEPhFcNvK/600pQHAHbe90n52LnBN3lF/7odIa2DybWKwOWyymVthV/musWtxPYJM
 VYIoYaxUBPXXfnAGlr861WhGJlKWuia9j3A3Xv9+Q358JyRtLW+raatjhfoBAusBJgpv
 x8J81QnDK8OU64gho0TCCVzb4IB4HNtb935Af6U2PTAstoQSfJ3UI8KXa3wpqXTn0ZUr
 B5bwFIE1n53jt/nShtJ5BCXD6fCVqDJ69wrtCFJBfelKy9E+xAcWd7HyvmK3YK4+LfvL
 wyAUYJiMXlFOQ/eBvIpDRFCC1okhp8cO1zut4vsVtIo/ZAAsnoA8UjIVP77TrQe2vPy3 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrna55b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11C7Q9BX090048;
        Fri, 12 Feb 2021 07:27:12 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2173.outbound.protection.outlook.com [104.47.73.173])
        by aserp3030.oracle.com with ESMTP id 36j4psn5st-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 07:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kB7U+qPWxLJtfTkRWjG2XxJeAGI2kOBeAjk1rYwE96Io46/tYG9yWpGLRalSrEzdxr5VT9KULFOxhDwrggYO0UanidNzUYoZ20zZy4i5DaRmaWNsmYJuVg8SsxKpLlCjGQ1j4YyXQ91UpiFZ/CB3m2IclTMrWSUit0/cyzpj+MBhKOMqx7Wt9+gW7fyAvVtkFJlICTMq/io6G2O/lkknDwOHCpk7JnaC68PtL79hsKAo5RZKl55nVCdLOCW+SsaCn/5xbH7Jf38d7+afgLH8nzOb1OAj2umGRIvIq0P1Uc8Smr9HkJdDn0ojwE4yXjz+ki/X3BLRX0eO9Q+t3b0sEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYnbMINgEO0lpQsQZ8oqujXyqlQ+qKigdJjFNWv2M7Q=;
 b=H3OTP7OCiEFV/7LPSUzBy5y7prqj0Ss6vbnZXKWXnJcDvqLYetYvHHuk+0ZFFYq87vTeUIfYvMWWOG2G/CRxbGVTGMJbI68zHIfCcZ7vK1Pvl7MI/ldsyukUsN1nGPlSeqEAtjSuK0nvkfy1Q0TLpAhtaUf/KCHKZBUCZUIGxHXAZ3XxQCZZw+f2BpXGRQLBynBsIpRgmooR09X3N1W2hKYl/GCM3blZEjTV7G3zNGwvhsS0vYbKpbzOswPa2yWkIpS69ah7/W4a5a0t2ZmVf3YkiB9GYeySC1ieXGiwS5nFQp87eq9onpoir4dw7nefv5UG0UkLcU20OuuBSz3wcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYnbMINgEO0lpQsQZ8oqujXyqlQ+qKigdJjFNWv2M7Q=;
 b=FSJWxBvE1fXEPsr34salXbelIPt7ZkWmjmxJf8oJmByiZVI6kAGFySgLWbQXjF1XLyEtCTrLiXeTHnRQQ4O5/O5i/3TQvYpN6MDrF3gS1Jm9LzhahAaAuERmFT59q5/raL8V+S82cYKjo/DkuSZv0bcUMMnEqWjwcIZjAL4ZJuE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12)
 by BN0PR10MB5254.namprd10.prod.outlook.com (2603:10b6:408:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Fri, 12 Feb
 2021 07:27:11 +0000
Received: from BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495]) by BN8PR10MB3570.namprd10.prod.outlook.com
 ([fe80::513a:2259:52d5:e495%4]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 07:27:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mst@redhat.com, stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com,
        hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/25] tcm loop: use blk cmd allocator for se_cmds
Date:   Fri, 12 Feb 2021 01:26:35 -0600
Message-Id: <20210212072642.17520-19-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by CH2PR14CA0050.namprd14.prod.outlook.com (2603:10b6:610:56::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 07:27:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31902733-1aa1-426e-ba7d-08d8cf279c78
X-MS-TrafficTypeDiagnostic: BN0PR10MB5254:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB52542261082DCF12CCF83FE4F18B9@BN0PR10MB5254.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3TCfOG7rNi0wki4DvYz0dct3aL/aaMVjb00j9aAG3IysM70BqizuIukSuqcMbNITrNz6FMbAPr6JUSmPLKysq7yIK2sFypPb+rl57ZHFVj7gleFKgVzoEXKVWFi9sG1yfvsxWyuANmjpxJ61t0HSinPQQE2bidnCLMp9syG3Fjr8VZYXi0i7N9W8QFZ8TF7dJQ/vwbS89+aZ4YzMf7isR+IF5MI5UtjiP+mf4+BnTpzmgjfn+iFzn+9rC9u+MVAVV7Z74gop9gYop3ExHealJcuDcYH8jrr2Tk8ls/PNQvZPlb6gtCHlP8n9DcFMzl9zBW58fnySEHM9hZl6MVF3XNFk7x6uGbVbddoUcKlkB1amar28dADbUUJWPR05PQ+eckzh4Hx9vphBvj9Ftc5/XNORVhTzTjImXGb6BqJIn4xwbyQCA4W+kZ4UG/pjusRfqNd8mf8pzUWyotDoR3fdwOWpIlrkHP4qGxXhk5xF8CRfOJ+jAVAo1CN7JxrXBzA3ju6xx4KqkaZSYP6VWw9J24USpoDF6PR+ALe8RPIFXi+73rCcXl8MoPIkenqy2L1hgRA1rN/r2dQlEjCSB/gWBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3570.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8676002)(2616005)(4326008)(316002)(8936002)(6512007)(66476007)(16526019)(107886003)(26005)(956004)(6666004)(69590400011)(186003)(83380400001)(36756003)(5660300002)(52116002)(1076003)(66556008)(478600001)(66946007)(86362001)(6506007)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OlpQPKGVDYH8xiFHX/yw27Se1ryS6jUuX0Mwl3mAzxE2ij2AFmarclo3oHMB?=
 =?us-ascii?Q?i2NZa9XJFU+XTk237QlK+8ugL40C4DrRyu1cK4RYknEPdmBucPaICGkPoqHj?=
 =?us-ascii?Q?LH+vvtfgiV9EUrl2gAYttT0ItP/Lvxx30UxKidXRom5ZTxNNsMifLufZUZaA?=
 =?us-ascii?Q?GidWGVAd6a4CTDs9JYL4ZR+Eci+Kl8n23fSpnLJhmkwoEOLReCsUkE6Fgs1M?=
 =?us-ascii?Q?SGz+3pWhva08XYjFivj2C4wSGahVh+kTzs9uzResLoInB/X9Lo/Qs2U026D2?=
 =?us-ascii?Q?DDj0HPk3FaoBUu8cryWh075qoQWlsZ6bVuhq+iHfGGrSyDygFI9K3bDGJE56?=
 =?us-ascii?Q?IxqQIsIIZRCFez2YdO8fbFaGBdquZxRzAsq86nN+bOXjOhEv5qxsXE47hyXW?=
 =?us-ascii?Q?WE59FWXSQMckcAN0fGEhwYFLJkk0ChE7j198CUpL2bqOoWvaHqJnWz3CtHPO?=
 =?us-ascii?Q?6+zFn47iiNk7+EhvGNtVrxbyY6YiXGk+RyHX4g1udDd/rt88axiTHtHeFrpM?=
 =?us-ascii?Q?0daHj/PteDtWDMXTun6uA69ZVUYFLd+NQV5uVw0VT8u+bDPZcNr1KHfzmpJt?=
 =?us-ascii?Q?mKtbPDEi5futd287mHV2UohArZ+h1hM8tttZbkFmOft1/5URGG/FdFlwWFWF?=
 =?us-ascii?Q?lNCUAPWwTxj722Ap6zZ56y1qt/voSXrrJTXbzlMWG0S7kgHe393mHtExrllL?=
 =?us-ascii?Q?VHWmZQkUVvdBRXRunxgQISsoXOt80vanY/tsqwLDa3FC6P79TSGZ/RfJSzNR?=
 =?us-ascii?Q?IRHB47gkUPdgrs38Usb6HP71qbFrlyQ3adZUQraHQWRoMnX5AptD9IYT+w71?=
 =?us-ascii?Q?KvLGXDsMZpY/Z3WCnqfTJq7OlPYT3uz3tswPhS83QG7gye/6Ndg7Iw0J2nEE?=
 =?us-ascii?Q?VsHvHboP4e5ujVQkVBmPob0qTa2n9WuYWe27Nk03BRm4aWmXwkPVAxukxj6e?=
 =?us-ascii?Q?UnOImfI9tIrEPObbczi7jGRxIPFJAP1R7Zy9lgHNAtzRfp0ERcmwRu7TvNk6?=
 =?us-ascii?Q?IhcwXp1/s5wbLR7mOeUw5FRaSBe6exG61gEdFCbn1YJ+I4Z91DyEChhdWPzx?=
 =?us-ascii?Q?MQAMdNhXOV1r1IM4GKid43Yl7mB6Am4bPuMvZRfyvAvWdFMyuVzhhxj8uxM/?=
 =?us-ascii?Q?8tlGh5dwo/K1KryQFfOoKpcBoEZCszmxtePD8tKetg/63kEQBagIzkS2cMpl?=
 =?us-ascii?Q?/YIA4T16WdEx3iI6zA76lxi/qyC7z5kD3gwT/NRLorQ4d53puGKq3FqYn57+?=
 =?us-ascii?Q?AGxNqcZkoIW10NMPcfbt+85w9DnNCmbjyS+nBOvRvzZ/HEDC5uf4jettUhTc?=
 =?us-ascii?Q?Kupbm1t1k6QBLJZHxKPnj5Ah?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31902733-1aa1-426e-ba7d-08d8cf279c78
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3570.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 07:27:11.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXkCi7XxWoQvL0CL17mSxV5MBCjfzajj6cX4y1Eut9ySXZifK5/SFoWD+xSa3zyK1gxgEQg0/a2E0EkmH6oMh+riu6U/W7L7CHbE71cr9yk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5254
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9892 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120053
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just has tcm loop use the block layer cmd allocator for se_cmds
instead of using the tcm_loop_cmd_cache. In future patches when we
can use the host tags for internal requests like TMFs we can completely
kill the tcm_loop_cmd_cache.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/loopback/tcm_loop.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 677e4b8f0642..fb877aec6321 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -67,8 +67,12 @@ static void tcm_loop_release_cmd(struct se_cmd *se_cmd)
 {
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
+	struct scsi_cmnd *sc = tl_cmd->sc;
 
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	else
+		sc->scsi_done(sc);
 }
 
 static int tcm_loop_show_info(struct seq_file *m, struct Scsi_Host *host)
@@ -164,7 +168,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	return;
 
 out_done:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	sc->scsi_done(sc);
 }
 
@@ -174,20 +177,14 @@ static void tcm_loop_submission_work(struct work_struct *work)
  */
 static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
-	struct tcm_loop_cmd *tl_cmd;
+	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
 
 	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
 		 __func__, sc->device->host->host_no, sc->device->id,
 		 sc->device->channel, sc->device->lun, sc->cmnd[0],
 		 scsi_bufflen(sc));
 
-	tl_cmd = kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
-	if (!tl_cmd) {
-		set_host_byte(sc, DID_ERROR);
-		sc->scsi_done(sc);
-		return 0;
-	}
-
+	memset(tl_cmd, 0, sizeof(*tl_cmd));
 	tl_cmd->sc = sc;
 	tl_cmd->sc_cmd_tag = sc->request->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
@@ -319,6 +316,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct tcm_loop_cmd),
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
@@ -579,7 +577,6 @@ static int tcm_loop_queue_data_or_status(const char *func,
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
 	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
 		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
 	return 0;
 }
 
-- 
2.25.1

