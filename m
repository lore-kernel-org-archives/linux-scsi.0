Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38466C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 23:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiGZXxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 19:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGZXxw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 19:53:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AEF3A4A9;
        Tue, 26 Jul 2022 16:53:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKnEdk009464;
        Tue, 26 Jul 2022 23:53:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ZxtKYt9KcVSt/OID49CoQLB6xep49Fva5bS7MNW1UyE=;
 b=hH9Y5UmvVDMYXcOfbpPlnM8F0txS9biQkk/0i6PiO0E3euQ0T5yJY9Tz70uJ2JTtMZ4z
 djw7FPS/iIUntifEO892X1HJpAc56mXYVrPHgMjj3Tr00p3yhZPv3sNyS+PEzgf3G3tc
 NvJ5orGhOnMv5m7IpfhjPrYi4vgvuF+zodWiCKbW2NzLYIrCRTM61SRCceVaptY7mFs2
 haDX2bPv43yNMw3qCpQuiXA0CIFGDxpob1uX04pC8Lpuri+2TCfRLv87fyl0IyG/ZSWt
 XWF95zIEWxq2nJzEwa/GQctnxWxz3IfOhlPYc7++PK6edNMZDnCKChDIQzkmkd/8f5p+ kg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a4qyp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 23:53:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKpPNN034634;
        Tue, 26 Jul 2022 23:53:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh633gs9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 23:53:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lItqhw9M6msp1A3HzIOn9kQ6s0tjf0eYPxqjIzmm9VlyEe6CXrkTSbtKp55hKNZ/CucjB3hsFT7ARmfTDUs1PnR7KcB21Q4jMwuBv5Ob4BiD6l+ymPLu2W/CXfsyn4J91QbqQ6bZ7otia0LvY9eJKxo7rB3T6Zu98q5AD0mWIJbhFaNWb1zeB5ufuZ0hSuDjb0QYVAhYZx8VEd+MEvK1NqEfkEA6XjBWRyUtNErOxD8y4+8Ipc+8b9qTY3u7kherCqTr5jA+5JMGFDg52etHbzjkZaUEzX8Ab2z9YBv0kAuHonkddPLkJjhV20JPw7QmT8NokHhtyPI2eTYopzT8GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxtKYt9KcVSt/OID49CoQLB6xep49Fva5bS7MNW1UyE=;
 b=ofuZ4uV3nXReMZsqY0i2S4DQUm7/h9d5uBURf3E3ob/CIb8/zWKzl2uEU+N14HbiIOYIYD3g9wOprMCMEkxYnpj14AMyCYCuVxUL0T1u5kTu1j99+WxhglIKtqY3Bh5A3NseKomN3JIrAmQoPC9gXupoT9SDhUVPumo9IByWsU3FLUmy1i+f5KjuvOPnCR/R9ZbysyBZHjFrFgHwnSMLMOS9IrfJ4xsAOcE/8I9D+iIvDVjzMxbv8KhuIiwPY72Pz+aVHIQdsoTdDbv0x45QviyQSMECHzvzEZ/8IfO1nujiRzqsrrXAYd6c6nEVE2RvHSP6uuh4O7oC5uWVoVzRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxtKYt9KcVSt/OID49CoQLB6xep49Fva5bS7MNW1UyE=;
 b=pdnEhDftHM1Dn0tplyYF1Tv12dWYkDfyah7NB6Potc3Lfkrip6o89nSuikR6cO5FOrWkN2jB4s0q+V3QudPeEZEawIalEm05GAbQcaiKo6HpvBTqNSwQSQuhA1FVRfvEnFMw6KSzzGjqdvs3SA3p7c2oj07a2rHTXKDPr3pd3h8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Tue, 26 Jul 2022 23:53:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 23:53:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: target: Remove XDWRITEREAD emulated support
Date:   Tue, 26 Jul 2022 18:53:39 -0500
Message-Id: <20220726235339.14551-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:610:b0::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1c50bf8-dcb3-46ad-404a-08da6f62148c
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s2PeburxbjMYo308b+S9XeHwznsihwfRhr+9AyqhCXX6XDscTJooC3CjIt7/VpVq8ZE3Csy5HWEON/pdGOMhe3L0VunhVFZScO72rfNtDMkIXoH4kynlk0lWaIMc0fuz5sj+CVI2nKDOszDujfS565Fayi7DpdvOhVuwYH0LWrUvb0pG9wMubbcZS9IfcRXbufHOMkK9KznwAHZUWg9Qeul8ZQzaqOJne8XXu9qdhBlAHt/fy1Y8nwmBAqMAnjihQ1bd7oFdTgJtVzZx5lsifWgoYOIeCgTzrDJLcBYsD4qXpoTOSAXExUg8qY0vsySK17F8PHz/4vGcTDQ2xAP/FHX6hgbH0lg9ReNJRTotlENo5fS0dnxtesd3Ixg76XH2PZioc4JIOYUBS1F31u/HwJ7f1xOxzuEa9jq0HQhMddi319HB+ZVf6dxSlH/ktNCzKDzftcxweYq9dTOqNuLjkjXwnQd33jtRQ7YAX+Xvl3Y84SML42cIUyek2lPEYaGcyxyf3MF7uAl5xamZ0voSnZ+zQRyJan9PbwB33dEV1ybV8Gm0KDC5YZzHwUZI8FL3yGex32fGtI/BllitRMiIsHDPZsrjQtglGCBaOaqm6W22kv9b2Jqodh++/Cd2EcqnpztFk6gOttJf5zoyXfuxtq1CNTMpqAcOrr/bGnzb2MKIU2Kvd1575IfufNb6CWcDLAuNsDEezcOz/8OHbINkeNA3LU2WFa21FgQgHIunm2LIHOTk/tX+ltDp4VHb2GCuBxf1NOfuO+K/DdVseJnKNeBdyR7SK32YLNFPinDJ0otUsjw1hE2/FpNsC25O3+Vh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(376002)(136003)(346002)(396003)(316002)(5660300002)(83380400001)(86362001)(38100700002)(38350700002)(8676002)(4326008)(52116002)(186003)(107886003)(1076003)(66946007)(66476007)(2616005)(450100002)(66556008)(6486002)(8936002)(36756003)(478600001)(26005)(41300700001)(6512007)(2906002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jgr49VZ86S87DLSrf6skLmU56+2pXV12wnRDmcAz8qto7mRWTqhjJRElEd/U?=
 =?us-ascii?Q?YJEpxHoUefsRTlsjvowzIS1tLsp6UF1xG7RpowF/FDAtF0Cwer0W2qhuUyr9?=
 =?us-ascii?Q?ih4xiAuz1dYJjvYD0ioh/rkylk2QxKe97KmUJB5mde70vNRfGq0LV7jxAI4I?=
 =?us-ascii?Q?+q67FlnA8PZUMBahzM8w87sa2aWYbUqFEINLuFrHJmdSYTXTovOenuOAMN12?=
 =?us-ascii?Q?FFH3tyfk20TJKdY4LlK7q1ZrNY+FZO6pp2d6Kwyn20ebRfP0AnSQh8CyBwdY?=
 =?us-ascii?Q?a6/1imSUQgAwatHmD5NTWsO1amZ6rTKW/EJlpwFvwHctk73VQC7Y2fGTWhg9?=
 =?us-ascii?Q?l2hYdWN0LnWLJOutnglM0YZsZJohlL05j0VaexPAF2tP4a9O4owkK+Bp99Sq?=
 =?us-ascii?Q?7Mci7tW4Dw9RHatYTeli33Fk/GkpOmn8AlW1HOVCAYKr1+gDMMwrHeyzGwO7?=
 =?us-ascii?Q?gnmlJdNx4bksttHx0BiOHEsbAf8fgiGI2F+9q7JfUw+muUXP/Pc6wkGKOQLB?=
 =?us-ascii?Q?zQoFXeNkmac09YLewjUdgnL0TTL0scUNBllMLZIO3BEUizVP09cN/tjo0deC?=
 =?us-ascii?Q?51nElGgHPIQBWxpGctX9PfmjTg4QjNzUgVGPIWLZp6WfS8yegTtbi9/KG7m/?=
 =?us-ascii?Q?e5qsrKw8VrnvUSxI7C/WdvLtjYzKd2yanggu6yMsoOXJWPRJcrDFKXQA2iFc?=
 =?us-ascii?Q?I/qQb9sukfHIG6dv8kK5rky/SXr24wjAZ3aHfR/77UkSJNvOZvSt3KqAkS64?=
 =?us-ascii?Q?7XicwcjMiQjU6FP2yS4a3jqwr6JOpzc5CBn30qD29GAw4m6fVDDaryFAuxYe?=
 =?us-ascii?Q?jM+xJ746oopv6Rhq7aShCHaz9JnbyNZniLLuyYGqDTAx4dJeapXjzLWYtZWa?=
 =?us-ascii?Q?5ksQ/ogeRI3rWPshviUj5aT1i4B1h4YDdrXTd2/bbtulJQnEtH8Ox+dOB1rK?=
 =?us-ascii?Q?CMNedi9CWfqBzMKy+dcwiE1VUG+LnIC6aZVFaazSeonsa5F1bdpE15vVFa/0?=
 =?us-ascii?Q?geKv3OkzHQSsdIb1wdBa68MeLQFefvSl9RjqayD3ZqqrsbkT9LVbOcyCiwwc?=
 =?us-ascii?Q?8GEZ68ZE3++LNcKbYEEwl1nGb6UxzRvetyE9YCCrVqnk+fokWoWhgZbwRgNJ?=
 =?us-ascii?Q?UgIrCf/DD54EMerB5mJn5/o2GNUcvvitqbZd97yZce+yr0WDnM2jnlJ6Y6x0?=
 =?us-ascii?Q?kcTs1E64XUhG5NlOVbmrcBh8BJshmFdVcx0eYZr4sQ0YI+lzldQ0BGeWE807?=
 =?us-ascii?Q?li/sskBBjqn+wc6quJkbzaFBRcNlqc4yrzCn+ljdAWtJQiyEHHtyEArtHFAL?=
 =?us-ascii?Q?oqg1y4NVGPbUAKDmyu9xnbf/E31bk40kI2VQSZitO13CSnbXWCxqlIf5T2lW?=
 =?us-ascii?Q?jwkj9o1xiPoL1wqGIZoglJ0S/HKKE9nTcxQDfK0lUKf81M4zDQKKV3cvucTT?=
 =?us-ascii?Q?82p9mPU33DA8rmZKN/vWOgqV9gmw/Mg9FwhWjXLYnE33fX0+bF0UPFIbfvik?=
 =?us-ascii?Q?pB1PJ+xEW8p7GmzLAxoOEVX3CQNj8JMlZ5zG0BIN2GD1Kdoh6+M9sbHdGorn?=
 =?us-ascii?Q?AqiXtTFJ/vNYyzfsmWal1M0HPvvGUr6IiQyXlM2Onde0VaagHh+zPop8Z/9B?=
 =?us-ascii?Q?3w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c50bf8-dcb3-46ad-404a-08da6f62148c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 23:53:47.0435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wVpYgTBQBvXxKUrMR50ANtHOLocZEodApaIbrSgmvK0qTARL3Lhz3HO3TXiRYp+umI/Yq0hVdtQFOESR+vC9uHimXwsq12rrvCrZjA+WK3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207260091
X-Proofpoint-ORIG-GUID: alYOEun-Jw9LhGcAAzM1cHZWf747fQ-U
X-Proofpoint-GUID: alYOEun-Jw9LhGcAAzM1cHZWf747fQ-U
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes XDWRITEREAD support because it never fully worked when
it was added in the initial LIO merge and it's been fully broken since
2013 from patch:

commit a2890087499a ("target: Add compare_and_write_post() completion
callback fall through")

The two issues above are:

1. XDWRITEREAD support was just never completed when LIO was merged. We
never did the DISABLE WRITE check and so we never write data out.

2. Since the commit above, we never complete the command. After we do the
XOR, we return from xdreadwrite_callback and that's it. We never send a
response for the command, so the command will always time out and fail.

Since this has been fully broken for almost nine years this patch just
removes emulated support.

Signed-off-by: Mike Christie <michael.christie@oracle.com>

---
 drivers/target/target_core_sbc.c | 99 --------------------------------
 1 file changed, 99 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ca1b2312d6e7..786ca58008b0 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -339,68 +339,6 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char flags, struct sbc_ops *op
 	return 0;
 }
 
-static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
-					   int *post_ret)
-{
-	unsigned char *buf, *addr;
-	struct scatterlist *sg;
-	unsigned int offset;
-	sense_reason_t ret = TCM_NO_SENSE;
-	int i, count;
-
-	if (!success)
-		return 0;
-
-	/*
-	 * From sbc3r22.pdf section 5.48 XDWRITEREAD (10) command
-	 *
-	 * 1) read the specified logical block(s);
-	 * 2) transfer logical blocks from the data-out buffer;
-	 * 3) XOR the logical blocks transferred from the data-out buffer with
-	 *    the logical blocks read, storing the resulting XOR data in a buffer;
-	 * 4) if the DISABLE WRITE bit is set to zero, then write the logical
-	 *    blocks transferred from the data-out buffer; and
-	 * 5) transfer the resulting XOR data to the data-in buffer.
-	 */
-	buf = kmalloc(cmd->data_length, GFP_KERNEL);
-	if (!buf) {
-		pr_err("Unable to allocate xor_callback buf\n");
-		return TCM_OUT_OF_RESOURCES;
-	}
-	/*
-	 * Copy the scatterlist WRITE buffer located at cmd->t_data_sg
-	 * into the locally allocated *buf
-	 */
-	sg_copy_to_buffer(cmd->t_data_sg,
-			  cmd->t_data_nents,
-			  buf,
-			  cmd->data_length);
-
-	/*
-	 * Now perform the XOR against the BIDI read memory located at
-	 * cmd->t_mem_bidi_list
-	 */
-
-	offset = 0;
-	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
-		addr = kmap_atomic(sg_page(sg));
-		if (!addr) {
-			ret = TCM_OUT_OF_RESOURCES;
-			goto out;
-		}
-
-		for (i = 0; i < sg->length; i++)
-			*(addr + sg->offset + i) ^= *(buf + offset + i);
-
-		offset += sg->length;
-		kunmap_atomic(addr);
-	}
-
-out:
-	kfree(buf);
-	return ret;
-}
-
 static sense_reason_t
 sbc_execute_rw(struct se_cmd *cmd)
 {
@@ -927,47 +865,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
-	case XDWRITEREAD_10:
-		if (cmd->data_direction != DMA_TO_DEVICE ||
-		    !(cmd->se_cmd_flags & SCF_BIDI))
-			return TCM_INVALID_CDB_FIELD;
-		sectors = transport_get_sectors_10(cdb);
-
-		if (sbc_check_dpofua(dev, cmd, cdb))
-			return TCM_INVALID_CDB_FIELD;
-
-		cmd->t_task_lba = transport_lba_32(cdb);
-		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-
-		/*
-		 * Setup BIDI XOR callback to be run after I/O completion.
-		 */
-		cmd->execute_cmd = sbc_execute_rw;
-		cmd->transport_complete_callback = &xdreadwrite_callback;
-		break;
 	case VARIABLE_LENGTH_CMD:
 	{
 		u16 service_action = get_unaligned_be16(&cdb[8]);
 		switch (service_action) {
-		case XDWRITEREAD_32:
-			sectors = transport_get_sectors_32(cdb);
-
-			if (sbc_check_dpofua(dev, cmd, cdb))
-				return TCM_INVALID_CDB_FIELD;
-			/*
-			 * Use WRITE_32 and READ_32 opcodes for the emulated
-			 * XDWRITE_READ_32 logic.
-			 */
-			cmd->t_task_lba = transport_lba_64_ext(cdb);
-			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-
-			/*
-			 * Setup BIDI XOR callback to be run during after I/O
-			 * completion.
-			 */
-			cmd->execute_cmd = sbc_execute_rw;
-			cmd->transport_complete_callback = &xdreadwrite_callback;
-			break;
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb);
 			if (!sectors) {
-- 
2.18.2

