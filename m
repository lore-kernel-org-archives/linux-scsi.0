Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B43C54EB4
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbjAWWLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbjAWWLd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AA239B87
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:13 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi79Y022518;
        Mon, 23 Jan 2023 22:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=MTfW6axGo9QcKzmrt8pr0el/vEl699YFzwnb47Igr1g=;
 b=BhrGUnqQghtfPkR56/bxhd0GW4q35vDo0ulKu7kcOi4aA/m6J1ZooGmbaA4/FW1xRDKh
 E9JUJLSEyEOpwFW3EDM5JNkxwfom8GxlIJsPULYWy9K/4klkr/KfpGtosLBwhoB2GpJ4
 PEls7LNsrA+h2FU+V9D3f4KRv6CEqpQ+/F/qei4XbZJqxfzZvqMIRMFDGcJjowSdo0a1
 PxXF1JUEg3yzISsmLSyxZ0D5GrpApidzcRJnghw2015m+X2FBoT+9UyfyUdIuX8eRnrl
 9Fnp5x8PBIA608IM90I28nmuTvpG4DGGl194jZSki3zSX5SvRwTxY4bLTl/3ZUF93+gu 2A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa417h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLAo0W023249;
        Mon, 23 Jan 2023 22:10:56 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4e43b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCnMpz2vrqUmtwPqLFMb/tHuBFf/bxEnvkr0SauWy0Y+5a4zpRvI4Fdy9rNJgDWpccfWU/gYzAhoFJRW+E3kGgMh3ANAzx3MsoGKOi6iMYOnB0lJNqgppP558xeo46bK90FlB/cY59EKozOSeHJ1r7bq3oS9risC/WWSKIeySNCaAA2AXINu8GscXyYhomW3QBw+cjOTHD9iVIv1gcfpiTYkg9xYbklStxgEvUBcJJtH2bUumg6+LxXSPFpYp50jQy6oDgzvH81slmUbgwWDDuoW5HquTGvEMf+ceUYovKRLaeND/Amfy3EU7WSyFN0oc3LhPMNWt5z6ainut7jy/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTfW6axGo9QcKzmrt8pr0el/vEl699YFzwnb47Igr1g=;
 b=CAn5cMK4ejKmBjwr7snc1RwK7wRGHb+RBt8guyDPuAeabVbMKePC5G2bJdxScbxro7NO5DmUJaJdPkrOrhFjkQxoapUF+BAxHMisGUW/4lOUjmBEMqplyLCTmKqt2t3M0t4mzGVFsa8DELWYEAgZqrAmKpvwxrURX62F2NvTWx5BlPdWc+tevBJtc/3TCr8H+pTTAtmCbjTTsPVTSRTa35FJ807+OTXOq5Xb9KrERswpKy47aFr3G5Yv+3UoKKnC8ftN6W7wHPLAR16rv5eowRgAGbCEGxw8NcSGuGSwfE6w4DyowRSm93yY8AEUhVSSLTuOQuqUSVkPLzrZWGCtIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTfW6axGo9QcKzmrt8pr0el/vEl699YFzwnb47Igr1g=;
 b=tqBRteBkHwifXB1TPebU9wjaV3UzNPFiIT/no9waIfXNKCx+GpWhT8ZSEF9AgI5utaC7HKWIZK2V0xKcvb4rn7+d6YDhqT6khtwm9DMY1ljBbYTZ+Og66xrf9d49kQAqaLSilccLzut86Wnx4P6mGNubfl1TWABHCCgK6z/oQWI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 03/22] scsi: Add scsi_failure field to scsi_exec_args
Date:   Mon, 23 Jan 2023 16:10:27 -0600
Message-Id: <20230123221046.125483-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:610:54::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: d5adbd8f-7066-4f75-146e-08dafd8eb22c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O2Fi/fuuXCgKsGXhKK82diqmJZUolQ6xmHGEs9rFGrUsiwUBD23K0myMUfd/Oaa9ujxcH6wfxnuNPGwMdlK5EkY+pHVP9mi+Uqtmg1hllYmARfK9ZOKCl7hkcBFJz4IQQN65O4ll7LAJhnzXAVMKlXfYteAIEypJ7pu1DjwsfOng56YO7XCOXrfnNEPGzFc3OZM00SeXN9lS1xE1s1VxNL//V0zjs5iYM+qCVIJ6ENvotkQ0EcYpBRvWX66MQyEhCDnxdD3ATSaiEHboNpn0ZkX/kErUWmoaesXFP216Le4Yjf7o87MyqV/tLDwzuW6r/dYl/WgK46yMBw4LPq653+mJTOTROZy0JfoFuN2WEKMKjVltRH83ypCJ3hW0SrgZ98MCVirk/RTJg7121fBAdyxZa6+y7fOmoVyaWVlycBlMvJ6N6niu1tP5nUSwrLAuM6+CgzfmxtTOmzQ6+VHpYox522Kgt9Xv6aQNojXdIxxjQqvO5XSqVSAB/jfr0kf0u7Il5nQomfZcbLJfpdR+CqkweKurUB0u11UoeNGO/pcmxDHbDSq3+jX8uX4IwVc3EmBfcTZ7tS8pJ/tHt5xuP1PqkMuyfKlG/XAadqwjRCcbf6kcA4vSkCvczwLD9+4Ip6osO3kf0akCPgOSmFY62w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nX8xPHF6t8Wz9FYQHj9H2fjwMiRcZnWdetU3Weq6m1Mz3n0thc/jFl3B6SPr?=
 =?us-ascii?Q?84+ftnOFGxyo7nZXpbABnHZ/eh2EA9IvVTvAhOscutml3Y2NIWtYBzcKpTwk?=
 =?us-ascii?Q?kHCz8JMzcYt421jSpmAL7YzFwTwQnLjsjGvrZ3y3niANF2/dBcgTvXH8XPXn?=
 =?us-ascii?Q?42ECQqlbxSjNpW56lTfPaxeVNFVY3H0YA9Pif4y0pFe6lJcbe3h+wjcKCst6?=
 =?us-ascii?Q?8NfGbEqcFlHMUf7wVCY0zExK512obcxgEv9AFeUSpJt+BNzxZoF4mMsOIQNE?=
 =?us-ascii?Q?RifLHvQ9MDOqy4g4OiUzit+LQxhfrJ7KUgMxoYDhX6PO3sEQZcxjJ103noXw?=
 =?us-ascii?Q?Ym+Z0YUP4Cxjlue/9TeKVIOaSSB4HNulpE3P2jtN7CzKbG6l80L830NSXUft?=
 =?us-ascii?Q?mYW3/0IHjNdpBDcZDAAcBgEB9rf+CYoOhdTBguFfbAN59r7J95I8Sknv26K8?=
 =?us-ascii?Q?/ABJDcfIA3cXtoasG5boeYTG2QcKCF1M7lcP++zI2VEGgacEEcrQT27w/P3K?=
 =?us-ascii?Q?2r/SC2tbc2en/VTS5Od3HTLKRQ+YV0zKyDyI3HuMnoPgIO9Jj7e0L8ObSaxk?=
 =?us-ascii?Q?BQymXNHhkat6nuy9yxLfeZXkSxc1BwCCfTTx2WSoy3V9vHQwKJnTxlFDelZQ?=
 =?us-ascii?Q?lBNX/Et+D2TBOQFaBCc4hX6AnyS3r1NmfB1iRhbI/vbTqEG0hp6lHQZGhGhV?=
 =?us-ascii?Q?fhVxPSXOnX7neRPY7+v+NMIF6qXENkZ2tzmfpX3p4zLDoa4WhK59dEkPYoU5?=
 =?us-ascii?Q?rqrESp+WtCPJkSlVJGL4ZzbpGx2kjZmNNUgvKVOXOcQNIekADADIKsKM2byC?=
 =?us-ascii?Q?q7VxmbK8XzKamr1fyNFRkU05kL3D1WqLE+N2sx6c0AXEW/7v9NsmfiF6CH8x?=
 =?us-ascii?Q?XDkR33COnpnPxNnwNflRKSiY+NaA93xhgqEL5xrHGeT6OlfIVDvVNeyMJg5g?=
 =?us-ascii?Q?airFczdhR5Wab7vcovSsnd1nhnHw7xqfcD/dqixv5XMpByuOAPKPMdPWf+AW?=
 =?us-ascii?Q?KYBmnBPH3kPU8xXndo+fGI28ZL4sAe6UDXZNIQ3FFukaOPJODw7jTsIRr6D9?=
 =?us-ascii?Q?0oL8yH8SfNIKfrDSpouNnNgZAcHNXbcZXE1GdkjSCDLO6cNnEZ3rWvBjVp/c?=
 =?us-ascii?Q?brFOA7luF+gpWrSxZyjnX+RKjDEOueZMn1cdtNp7dJV8WOezv52VZF1nT2dI?=
 =?us-ascii?Q?i9iGtHaUpfNUyZQ1aVBHI5quI2s9x6noIKQxIwWy6gbsHUmGR5bueGhw2Q0H?=
 =?us-ascii?Q?o2XoF3BzSMaM3LG8gWxUA9EwKUX5OJa75FnZsiEwkE9Rn0VHaenhi1cJthZK?=
 =?us-ascii?Q?Y0oZQm5EjVOucUGmi2WLiNLRdGUgDJB0yjIEcH7KaKzrhVWqYjvJI3FM5nrt?=
 =?us-ascii?Q?rZD9IVhv1+mT2xXO6teYst8N7v8kI8VccLR6gkbzCil55kc0W0w/9yC/Y5l+?=
 =?us-ascii?Q?wuWfmVJWXWsUWjxB/uJIZNaaT8vKK2d36N6aEQO7jg2JMm6m+qe9Sl5apGUb?=
 =?us-ascii?Q?CHPfafOS0Ws2qICcF2yalMTIsx3R9Tx8YKoOi3DaQcVGZgVmrHMgIngnKsh5?=
 =?us-ascii?Q?EK8Jj6W6TIfXEsJcM4X0NbesTvjlRT6CWVJBOODkJyvdamxfYDbROB1dAEPb?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rd9PMmiBSaHj585AmqmZlmu19uH4KSQpqLmRdTX3aFCL7cIzbZJFBQZu7SJ1i5ANPl7h4oT//MJxHnlZrgAxxnBnIROUw8OQ80EvN+6bfDu1Tm7PJYNwDha4+wt2cPjZVd5YO63mJoqrhcKEDIWpX7lpmQ6g7iWZZlj0yL8DrjhGykPj+HvPxBt/AlHca8hd35dU/GCRMF3cN3Bi4IM2HbAxFFr2/b00HIQLHjAor5P8TAmV+Ssdy6VA3F8KUCZ17BxvT83msDpTAE04JkJlie59twxBI+Kj0mB9N3j5pjawMm/ZbjpOauAVnHC7xyhM5qxJ50Yf6KhnNS/PjeeBX2R/E1cfqtU3Yzd2lBH4Cez7BmUaSCylT9x/aeg6QGPGN+u1bEpfy5jw5FYWQQUITvJJRGx7k+D2eM/gMb0urNlj3ctoMg4Syc+jvr+cY/OM4LBd14G8lM7yOnQgIt18wbbBQ+pHS3U+txzGytCmOtkqC6CeZGoIGu8tzXY+7z3RiDrOU+mm1FSCUhNcM/O1P+tBcuy0lNqqAPaIvJnEi0WYLyEAIVLY9PrTFU7EgWfbRHOUb2K31oj2iKsXMwQ8TtjK8MmTINuemzpMSaf3PUIbFvXbuYNp3a7UmCS1YoXUR9qXMPP2WP8SAOkXCuXJSh3FCOs6TTKNUYOpzSm6FPwjXXpF+mZZRbc6uirGz6lakRCGZG+bHFWFWQTe1YjJrWh0i109viF8cTdls7Yvx0BT8uIhk6XmTw3O1fY4bmk6FtMupoC4WxFtnIicCXyOqr6kGKl4PO50Um7I5sYwPisU9Nba7NUwzZYdrRCl4g9/UgUdO+rQxF/a/0C/SvIWawt+vjLYaqrxHUa3C/RoK/FaSP+vrwm9oX/7odyj2gj7
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5adbd8f-7066-4f75-146e-08dafd8eb22c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:54.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpuuOfnu4A29Rz0vV6EhZPAqW7Ryxq981ASM6pO+CjBcvuLu9vJIkJeiLtqtYx+OjaZNcvmcXLafK8Ol8MXfIZcr0pxjAgvrAzooQaazJUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230210
X-Proofpoint-GUID: P6PZHsusVUtsw4Zj0cttlJ_Dog936PYI
X-Proofpoint-ORIG-GUID: P6PZHsusVUtsw4Zj0cttlJ_Dog936PYI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0233623ec245..50f6c967bd4a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -238,6 +238,7 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->failures = args->failures;
 	req->timeout = timeout;
 	req->rq_flags |= RQF_QUIET;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7e95ec45138f..522a19b9e2db 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -463,6 +464,7 @@ struct scsi_exec_args {
 	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
 	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
 	int *resid;			/* residual length */
+	struct scsi_failure *failures;	/* failures to retry */
 };
 
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
-- 
2.25.1

