Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85837C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CE1D64E24
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhB0RFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:05:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59346 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhB0RCH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH09ss005231;
        Sat, 27 Feb 2021 17:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=9ROJe34rBy+wJHGYiwS9ievWK9z3GgeKUC3bgZLnp7I=;
 b=e9IJm5a5P9u0n58PwtYSaOoiyCEiwRxE4TxHUDoh//q2oBN15Yasua4jrwjObqP7KKWn
 ua8r/47DA3jI2zztMKtZwPcvM86E73Qu509nMEyOwBiXFWtPT3n/xYUCZy7w2cOccJUX
 9Q77cvp6Dq6kafKgTes0LweqA9F8lMMpuh/2KADoI4QYDZY5ul6mQKYeOXybT5fXbBF6
 ZFQmpkQBdetETTLiBTNL9PepBR/vW3pWSmZTemsgDbL8ZeJOuxPSNaBlSSECq5rv2GUf
 pDRRja03OrAzR8EfSJWhI0t2Qj+lFvMJmq05mYHvQycwH9atw766qP0NcPxVnDBSsk79 Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36ye1m0qpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RH0MBP173116;
        Sat, 27 Feb 2021 17:00:34 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by userp3020.oracle.com with ESMTP id 36yddhy8rt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5xEJxE60G5yewLBD+NQT4MNdIAZ+B01rVnPxUTA4kYX5GJhIFlkzyQPSkJyJjTOB3NNe46jnWpDAM5RBa9AUXnOJb3MyB5fgXAu2OhCbXXImj2racdGpQVp+orCiLmwj2GTUjNGi2dQdOIY15y/svLODc4n7/aowunwtvmX6ihbTuzZx6Mb+xk8sukxK+XfI3Smj6w5mZd08cbIhoKM/Zzb9GJcQUTqETwjAcpqNvrjM5J6SvvoFBW9utAkGXo4psQe6k4sWKy838Abo7o256OFON8sgAHsbSMkwsbELm7cBwbpUszQH7G81s/2KK3tcV+rAoedDzJv069XghYlkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ROJe34rBy+wJHGYiwS9ievWK9z3GgeKUC3bgZLnp7I=;
 b=cjGxLUt7+XD2TCbLSfA4hpX6OmnB/LRFcDJJb7ElYs0AH61TiShsJR9QuTseb/32XM6W1CTnlgfY9iJN6coe21+z/yT9V0qUWb63yduWHkiEJ4q+p8rPTzJbLMDp+Bao3aT0Pd0GjNjrqZblPFAh8gYichRDrHhcskbiuNjNao4Cwotk0TV2OEk9LDK+L4315StSB/YGMzpQn+sMNQw4m1NwVEUiSD2DfHGEbuBbWDAWNjV97WPgaNln04V6xsM9X9kDR3k4pSJf31N0W6Y9IZE9HZb1gWYJUFaSECxsSa6Tvh6x+KfjQ4Fw6izkNoGLtvlipJRGePBFpYvkaVdjhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ROJe34rBy+wJHGYiwS9ievWK9z3GgeKUC3bgZLnp7I=;
 b=pCErwY71M4fWDF6twAU+cdauJ08HhGDldCqOUSFjhcjjSyzbjckYs1y+Dzow0LedWKCBCKple90NYUV2hZ8qrZsGuwg980th25kA2mUBwJgKn5ciNSPf+LdEICXdFOK8/chPVa3mi/OVPWcDUAoX0S/W1qz8Vgdram4FUd7RyGk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:31 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/25] tcm loop: use blk cmd allocator for se_cmds
Date:   Sat, 27 Feb 2021 10:59:59 -0600
Message-Id: <20210227170006.5077-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cd23031-8519-4045-d107-08d8db4130d4
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499CBA56D19958A2C1E9649F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wD7z2L3Ga4dd/uDYrrQKk4ghvYhGTjOX1ugZ0HCpROHzv+3cFB8vnTD1tWOz4KyaMWUnh+8XiAmCo+TNVcsRNnOGZL5B84zBnVCu/LphVjUHeHdx2E1rfStNxAa9bu/oWOgDXv4eHJIWF+GuXgyz1opZ9QQyXi9AF9mPdx5WO5bj1VPbB7P7/dIIaQVAQfJ8rF4sa+9q8YeuZS0UXG8SVDe7WL9/SFthnzFMUh/dDpU9do4eqc+gsQGVKnEsGRkzfFknkgq5htNf9/vYqnYc57cfs0x+NLeDg2+oWc5BC4inZX54eabVL3deRDNu86H40JlblNFgZdFpCN4MZHTckHVfqETi5wnftlV++usgmMfYE9PBydLdpl5xUSMUGx1gdsiI8ILJBrRHuL2te9KGc01YewCrOLIyYoiHtS3z7Q7xCuCastwHxE9XzxQTYENAtxIDUFw9DDrDOoLNrehO763NTAldkMBIdUCQRhhTuGzwctWRJzToPne5S6dqjIH9Vqw9uBmvRMJwimd97R5NMDrUmDSQLBFRjUz8N1KsxQ0CG+7SFRBHF/of1Qgr7DwkXFIFLQ0usIBCYf7laXsBtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?t5bVcnNUB20Ix18lYYIjRDdI3leFITM8mb9bxpJwHJ63XhkIdhY2TDCPp/3U?=
 =?us-ascii?Q?SbshrDikHffKxPfwZG+cdsQCixR+N3AxehW+kveEsuRJ70jbn1mNMp6F3QeB?=
 =?us-ascii?Q?Q/ZqyTXZ9YRWTp8Cn5Xr/das1ixix2apYWA11BY0aYRJZzHPIP28P1S1F+U2?=
 =?us-ascii?Q?rN1FTRtjLvL0SjEXSyf7jY+lwkvNU6yjD7Xd7eyyypC4+9lI2dhZfajZ37wi?=
 =?us-ascii?Q?i511V//Dcy5Rq3oMGPm6Mh1vrubozVifoCJfYxrYkB/yxRmr+ZoroFomfbV5?=
 =?us-ascii?Q?NM+M4pNAtXfL88COPaOX2R7SJ9Pl18cHVC3Fa88i6v0ZDaze6eHjZVUThu1w?=
 =?us-ascii?Q?1wOUnUqmA7oBk1bWiYcMMwZsQzCqYcKIB8ILmuCa77CbBJ300d50DuPelxiL?=
 =?us-ascii?Q?SPsIxSGM4i9Pfuxb/JjT+/5RIQ336Q8s4wuu/3U/EEyDRp9Tp/5WNIJX7EsA?=
 =?us-ascii?Q?ag+utyOBGJQ6Lx7tfGzaN6i/UHOPBued3nPIdd67gAjMae621qlexxa3xxYH?=
 =?us-ascii?Q?Xk55jv10aEIUl/98jlPL+5x63/ifWjA0E3lmDh2+bPxoZjq8P/3m5ieBomzD?=
 =?us-ascii?Q?T5sfljoQdlBsv00cZ9OMFvAZj1eqDanekQlLSA4ZEg57E/5BagRPgXofBh0U?=
 =?us-ascii?Q?tNMKjhE2QgYpb0fMHBZHqKNFM4XF1NRHgQJnbrVyGxPnXBFyN4Os67Wq1Ir0?=
 =?us-ascii?Q?LKU0ju3XR93p0KuXjyl+6IefQZWZQ25kSAC0KaDIPU0eHeXolgwGcYTGS90j?=
 =?us-ascii?Q?B0adOKGIxx27Q/jo5A2USJ6FHAYbqeqpvsufRMJicCFUJhMZqCr6qTntTqRv?=
 =?us-ascii?Q?4GS3+AZ9uysPN5V2T+WAvEGlPo1bAfNKyxtrSH4UKR8sYHksT84OzRQAXtXx?=
 =?us-ascii?Q?Oz2RotA5L+PHaIQj9qGgxL//zATVjZUsmBqF8gSTdtY19nVIGhWqqm1ilcJS?=
 =?us-ascii?Q?XDjCojIy+OOKvV8LAqaD+sr/g7MnQPdb7k7feAGo+QlJRHQs8/M2yd44XwHQ?=
 =?us-ascii?Q?oiWQN+6/Zw/w7dtsDdg5z2vZTT3Fq96QsEBzHHGFsqXoGKgEBN9iqs282n3W?=
 =?us-ascii?Q?qf39FW3ubYsL7Oe3hT/wBK8f1yzbNf7LJBzVlFwJE8TNWGTGEHgsckp79vrq?=
 =?us-ascii?Q?MoL0aWEHm428tJoONiBMnphxIvWBy6z4N4OVsUciEz6BFa0EctiJTx02g7g9?=
 =?us-ascii?Q?Zt2rAnNQASuW2l6591QFudqGup6gn7kiAKhU1LIgPWIWyIU7Xmj7M/nwHqAN?=
 =?us-ascii?Q?/5HTPSUoUdflKzGoIsR8WthD34PamV7Hm6GghBkn00GRxg3yCvbY6AaBgY0+?=
 =?us-ascii?Q?tYZneInnGlJlCdbO8gA5HleT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd23031-8519-4045-d107-08d8db4130d4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:31.3444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hneLJIpuFphS+DN+SdUviJMBADd0BG0jAi3OuIW2jAsjlt1ZMvDkhW90ba9nF+K6AT40EdoPwARWkhg8KiuFRbCBaJ5K8QsLF/mAMT+A8TU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just has tcm loop use the block layer cmd allocator for se_cmds
instead of using the tcm_loop_cmd_cache. In future patches when we
can use the host tags for internal requests like TMFs we can completely
kill the tcm_loop_cmd_cache.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Laurence Oberman <loberman@redhat.com>
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

