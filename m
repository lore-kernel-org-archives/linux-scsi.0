Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615D4C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E9864E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBJE5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbhBJE4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tYpO139919;
        Wed, 10 Feb 2021 04:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=bibvLdvh7ddRrmJ5/mzHEV5UGwgIOEnoXpzXIIaXNXhQDl10kaRC7eIg0ZGDZEt3j6F6
 VexX6qs6z+l7npTBpW0YAVvYGFql8Aw6VVDw5DOaajdRCVGafHmZjFMiVUHbGatbbvyF
 z9ZWkvQOAGarZTTZr/WtOtGtGntcD15FQ1l6K/npVTRPvRE9sDPncXJYiRL6lJxLDPVy
 wuTXKXYsMwzmNaQYCJH3JRvt0AmOIKXglrnIc4U8uVu5/2pXOaJ81+4KXRPYyNmzxDtT
 HCpDsq3yC+Pr1INUyXiMNAHD9h6EzQmCdo74sC3hb46SG/AJfsf0fjhtzSJmJz4uUM60 Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36m4uprdff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB8048727;
        Wed, 10 Feb 2021 04:55:39 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxKrZSyPEB9H/0Z7knZ2Vrkg+K4+NBweXNMnM8CjSLvTnX4+Has4DpM8eVOM0FWO216TSg2bdI0pfqX9WkA/e4AQYTS9UfRIie6Vlrw8nWQJxU76e8i2M3Y5EIXOblbvkb9FdHI1wSXxlBLoZQLJr6cFWHcUz6lUJSFTy0aFQ94jToxpGy9QZyS9UvU/mdnreXFBxLqIqnsiPwLuZyhnnOq+IGB4N5EsiPrkuT4Z+c4iqsNzy8Fq9srBKCf1RI9tOm0CGC3+g1UrskP5i6hflrfgNVNpEKGHV5NBMKF1fZ129cIzkZLHCB9vX257Ygnt2pZu/qjuE2lnq4EsuA9IlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=hHvC5I2Lol+pBtSPqydUDqOcWPHGZQqrXIekzHyTnwpmShdCvslgUA3o0rv3jzxRZQ5YEltewx4guyYqVOurIJpkd8keKTxTRYmKukNswE7+ujJU5nTelhCKdI5nwigKucLYXLGMlJpwyJnZdk5WwEEu8Y1u0lQa/0W8hZJ65XCM2eVBTrWV7dyfhfmEyGWk4hBW8FolId5ahG3q52T7fHrz1yLiSgroDWD3KViveopD5gf36qxYf9ui5dIYCJFPI4YgjHXiv7WwcVbEjcpdW8xatCUzvdIj/XfHvaNRJrv+rv5rRkMIR4iNExyZ06UUqpqvQhUGQBm73QDOLK48dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AakTnBcU2oH3AQ71ZMPcSB4AA5mBPEJzCX8nCoSYz1U=;
 b=ZbA/6Jrgfwea87a02wjRLpiYMGB+qmmFmQ2jGjJ0zkNrytJde9dIXEVAWGx0lbv6CAWXp1UW/FfPvj1MeAkmQ835X2PbOK5ziX5g7ae0ppjAiy80f1k0XooWRwE8yGaMzmjjFggFU1ez+PC0IQ785oSy8YvX1jAHL1vtP/zdkM0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:31 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/13] tcm loop: use blk cmd allocator for se_cmds
Date:   Tue,  9 Feb 2021 22:55:08 -0600
Message-Id: <20210210045516.11180-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95e43460-fdf1-4e6e-e114-08d8cd8017f0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366A88D65C507AC00E7758BF18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qdHjSzmK0X2M0Zdun5t6RZpm4VlwPWwzeyPJRfaJ8g8LSnS9d3YBNkhru7HWJa6Vt6nTJWqT3qwrXrVk6Oqx8L+5o8KCqXAZdqckPum36UIgj9JSQS8X9cjOvBvwHGRoT5JvgOdS+Ibu0Fy6nl04YNGZUBKO0YGBuIdejMUVMaTE8XRstCFdIfHwQIoA7eU+7wtByYMwI9P1trYn0GmMp85KQ0zJ7lXF9E7mih1b5sY0zUwSFASYjdiEDm5HyjMLqoKztKEjkgNY/j09DV0d8XDODF2mBIxPkPxJyXwIUtDyi5cQL3dZDFdJywF/zJtiOVH2ivy9VmsfGgsKRAnXpHg6aK/tDaweWsWH36sSKGY2RZ/b6UWR963ZLrSWDRF7WMSpK6Oa/1TBxCizG0ScX5RbxuUKrYz40dx/4M3sFiX4/fjIrZE0RpENiQCEBNjo7K5Yxgc2Y4iNolKyhwiz/frHfmmZ/wFiQRmX2KYNLuSY+WOKA+NWBQLZeWrDBqtDZsygRvp391GAj9bQCV9XodXnDbkqx9q21VxzQfIxyXaZCcv+QFHGgF4MJVz+tVvK98TBi/RBeWj0iFn1ikNulw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(107886003)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+J2T4zxhFwGufG7Ca7KHCvnUnBTW/m7EQgiC7FCYAVP+VcWh87aAmZyBBY4l?=
 =?us-ascii?Q?Wkuga1Jf8i8suoUQnpZ45fCPjU+c+MxB61mH1/oRGGXAw7pUl6azSC6pV3cP?=
 =?us-ascii?Q?9kvsIjBS1rewlW/jfAXnMm4pDT5z+qeB2J8wjXbialfz8v3mFS9MZAlTKdQ1?=
 =?us-ascii?Q?cnohtdElJzKA1akYLiUjmFaTXtng6iCbjCViQ7f60U6e4v0lrgl+ES3iB0cr?=
 =?us-ascii?Q?3ZdZS2uYGvGqBSBXMcryvnNFpKbcnzCbZo5ipDhoOdMOOJhLJ6qEv7MIB/f3?=
 =?us-ascii?Q?PMihF707w0NFBxV3GJDv+lpSKXVavFqa7oeRnPwenIeYeYZ4zTbg318FwGq+?=
 =?us-ascii?Q?i1P+7BhAzqRjcxkvSWtVcTqQ+ksRDmvpIi1CUbgcuRi9sPKyLN59+5b5tScC?=
 =?us-ascii?Q?KeBAHwBh0yzBwK/c73i977zy2X587l3s6D8co0pzuo4lMc20qpdIcyJj3ltQ?=
 =?us-ascii?Q?n9QwR4mb+Ga4BPPkq0UPS5DqcnHIdHY4N0/0wRzDXOE1qbNnEjFinxre0LEZ?=
 =?us-ascii?Q?wvuPEQhd6x6G6iu3n2WS4V/0I5qrY3rjHXRjQ4QDsFUyA7V3eLPg64LkYunL?=
 =?us-ascii?Q?d0l5QvFNlg3kLnpSdBUrWts1/TWjtSnvAYIKhBc0TLU316F5TSXQV+Hy98yL?=
 =?us-ascii?Q?nuwQ3u7n04PfYYa4qz51xLODylAJlATn1aqttKaAzsKxtNmCsh2d+Qx9WM/9?=
 =?us-ascii?Q?w/PO4QekwIlnObqvGRMP2vmn1rJ+fLIvFenO6f/b5EZL78E5yKyIkaudtGoW?=
 =?us-ascii?Q?+rty2eWs3+VH24cpCDCVo4DWQ9PfIwOXNtd5OdmqCUkRv4XGQpTzgSQCloON?=
 =?us-ascii?Q?GhEZeKBT8bio1BpyIXdzwYuMr9vMf/WGt/i181fEAyQPPyqntmsM1SCW6kKh?=
 =?us-ascii?Q?eAtUl3eV7RAHHE6WOf9EqB1I/6rqbUehb8hYno0rgYMWyPxc8dySWE5Q9K4t?=
 =?us-ascii?Q?VYCoBmbZizcynAtStAc1Zs1eIROJeYyFKp607Bc3iECLVfApQubtSxawjb5V?=
 =?us-ascii?Q?gmzQVnlWt1xkuoKNiYLEYumxOnidm7s6/y24nBtqOCVetyr5oSwlH6l/uHPB?=
 =?us-ascii?Q?lIK59Ct2qRdBbKLv8MoUag1WzlWX/8IebCOrqCkZ+H/mDXqWUyh3vhHDHQJi?=
 =?us-ascii?Q?oN+njBEv4WL3eH7aL0A8+sipob+aUnoEVcH0QLCqCX1auDfWBdJ7gO2yHJ2g?=
 =?us-ascii?Q?hbWo5GZ73ecLTibpnPM00MPNru9BhiSj/UTwEMP3tU6vRJ/c2VLLpsDXX8SD?=
 =?us-ascii?Q?L4zgWAiEfR+zd2Y3ctBk6FtX1SbK/ba61g6ssu29VB1Rx4bKU2npeptKzxPx?=
 =?us-ascii?Q?Li+mOKmxjmJxlc4unlOBoySL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e43460-fdf1-4e6e-e114-08d8cd8017f0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:31.5944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ls/43Rwt0u0p2c4LbJ6e411ERkRXcZtd8lxfcy5PYJWmOpoTippWbzyYDf+lJDnvxlhLDDdJzJ05/B8IvdQKDh/YrGTyzUJYU3nqh74Q7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This just has tcm loop use the block layer cmd allocator for se_cmds
instead of using the tcm_loop_cmd_cache. In future patches when we
can use the host tags for internal requests like TMFs we can completely
kill the tcm_loop_cmd_cache.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index badba437e5f9..274826a2b0bd 100644
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
@@ -165,7 +169,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	return;
 
 out_done:
-	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	sc->scsi_done(sc);
 }
 
@@ -175,20 +178,14 @@ static void tcm_loop_submission_work(struct work_struct *work)
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
@@ -320,6 +317,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct tcm_loop_cmd),
 };
 
 static int tcm_loop_driver_probe(struct device *dev)
@@ -580,7 +578,6 @@ static int tcm_loop_queue_data_or_status(const char *func,
 	if ((se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) ||
 	    (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT))
 		scsi_set_resid(sc, se_cmd->residual_count);
-	sc->scsi_done(sc);
 	return 0;
 }
 
-- 
2.25.1

