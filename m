Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80DAC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244506AbiCTAqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244484AbiCTAps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6C0241A14
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JNXM2i017596;
        Sun, 20 Mar 2022 00:44:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=MPAHj8opUt8ttBPOP/UarocMIbLF3o2V57d4W0jh+zs=;
 b=FWMiJhDcD5Ce3FlrSh9lRPrwhfAa+aenanmo+PdzhW/zcR6o2cheLny31FQZ+sS72TJC
 EUHhokShd3/BRgw2nOhiG3VTj1Lph/K227ooL2k5iec1rW1wxSUDnMlT8W7nkSQc6NVQ
 wLUtnttG2nqTGcapUbHeemJK+oFnLYRt/s135nnCzj0jpgfDT0Xo9y7AvD0WOgMu4nBa
 0lRDFN7rMbc6m4XmLpk4NDOPr/p0jTCH9eC0aBiugdvg3pfQrSFDaP4Kry3BECOz1qq7
 PwkIkAN0UphllyrDhfTw19o+6Kjy51NMFzMNcan290CtE7BvFhbD0jGCNaMvjr+S3P4y Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew72a8vrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffah137063;
        Sun, 20 Mar 2022 00:44:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OajxQ3mLKiAZGcsNVl+Xn81Zs/8YzcS6YoiusE9/r1TvugvLeYykyHk/S55ENVhlD9zFtw++OdCUQapYFp/pbBxYS/IPWl+4zayrAQL1kUuXh4UhI2bLscZ+gAOnzEp1XS+Wus5rZ9koyb4Kd22HmByFJELrCpXH8k+hxg4KUJEpQ46GImkFRL34p6oL3NqSU3ee2+md4spTQXCbf8Fd53Gi1Gq02KEWTzFI7TAydSjOx24GiJLfY+t21kg/BYapfaN4ukXXNjToKRvHX0kt4a0QKVhGP0SolMTRRboMnvu38L3v5U0IuEHppBIC/eAKfeoG3Kaa5wh4jmOD+SlUuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPAHj8opUt8ttBPOP/UarocMIbLF3o2V57d4W0jh+zs=;
 b=PyLXFHmJdUYBzLlQkuXh2A0eFtoXjhsLlUC9ngQTW2E0VAiKMuud2zMLIg8B6/UQ/Ufg6lpMHlZicjORun9lQU5Z5B3UtbzokwSYPOHWVTYnL7G1gTuHAK7Vj4YjEU5gP1eul2UeIJSZj/OXmN3UKaq8qCjDav/8v2Fo24z68Qv+2ca9LMDvW+22UjofS760x3UpmyfsLbXhdhR/DQjGPyAQFogAeGLZYQ9SSD8ITYkLIROgeE4BitN5cmDThroRxeyMtrG59wBTXJPfA1XXX3tSpMcENjwO0TnAPRrgL/jaH/VmJdWw+iFgh2+dHEdSBQaaTvIS78aCpfKA7G/W2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPAHj8opUt8ttBPOP/UarocMIbLF3o2V57d4W0jh+zs=;
 b=lsQd/zWrEVqyIKhWPmsQrH8HSIC8MmZAyQ6jl4ZpsiRa+ydX0kmKP35apxUc2bnkQJpUNdo0yXrBkeJcDItVUXURyU02Medae9/OTZsczv2EH4XxEf46cePs3/Kosq/mOV9wALQSAD/nJZqylIthO00LsY/szmqQfM3x4wj1t0g=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:13 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V2 02/12] scsi: iscsi: Rename iscsi_conn_queue_work
Date:   Sat, 19 Mar 2022 19:43:52 -0500
Message-Id: <20220320004402.6707-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79fa92e6-dd07-4480-c627-08da0a0ac0ac
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992E808C6022FA1B9815979F1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: il9vqnIDbFUexR5t39Mjd9Bj9huDIXUd76Cp7+L1EL8iLeCwXRn9ptm4mFi8uFqwXSw6jtBG1EabfesYXjubIUCn5zuntz5IPQyrrRw7j3tavG+rEOssv8tKE+et3+puiRBR85TchLgmhsuMaVXRBLyjSSLjNvNEZAhGM53Gq/0YoXbj3HSpETFrPFpYw0zCD1fMii0w1Rk1LeNq10KnzembBlhJ7IVHdYyOgH78VBsVKrI677glcM8aBtr14K3UcYiot8o5QLeoSGh5FiivN3s6cwSJlWIVii88mM4zOJ2545kWzVMWTykznehiSaR7Na2r4S21QE3h6NDx7g0mq6TrgqPLtMJC8cOTGJNBd4kRcrtyiUh33yYY2pVH3MTR9ayCdCFcU4IiKjUEMIiGYyLRvLT/MHEtO6+u9Dq3Ts3BYBFU9eGIzgWcCSaARAFB4lPZespiieyy68asQN64UU7qvXRRkLZjNWgAYP5xssF4rva39V0aJfp9IKBU1Ql6c3k4DIen4ujS8LrIMYX3iTWUXc/q1rmsVNld4JjuL5j6KKDlGpSCFkrgeI1RB6ROP/+V3WNc6G+IGC/rGbGJkhXlUJIEDFuDEFwW/axyleVXAjr09tctpPTZf7+P6/N9/kWLmkXfTKgDA3/ZhyahwALYmpLMBw/q0i+loPFMC1a6aS8V24ltmW0V9GdgbqbveX0MHRlkzOEiopHzEThsyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(54906003)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dNWXYJl2CAqzJ3tOisil9x35ZnAWNUpBuhSXeeiU6i7lqYbHPHeHZ71CQmVz?=
 =?us-ascii?Q?zin44ZtItjtfYhnceIg5pOilkl/j6pCSMIoMsqRX648recWmkp3OgCxh07in?=
 =?us-ascii?Q?djG/KkRZfGOwbo9vS+3UJjuuZMZSH58E8Mjj3Q9EPdii5nzNlohbnzsoWebC?=
 =?us-ascii?Q?tBqUUDxUzTQflsUOYjiHdAUBCqN1kC8h8+jj17434/gW9q93zU35ODZPTJiB?=
 =?us-ascii?Q?MTPEiX0BIbH3mcHbvDHL+pggGkDyz1oWbogt3zbrnbAPrAlYcFdKkWcWTqNn?=
 =?us-ascii?Q?LFqjYO+1BLF3TI70/07v5U4FtuCEhP2xv33UVyzOLG5EjqGT9c06t8rELPID?=
 =?us-ascii?Q?6mGp8xNci5FfwjmINQJtAaWbUKyy5RG7cPeYe2Tdj09CgYvdUG5cCjf9l09v?=
 =?us-ascii?Q?QnexR3n6CT0lEDTmw3Ypnh+Lmg4WMYsqrkMSKgoHoVepBGYFZTE09O+X1dAB?=
 =?us-ascii?Q?+uf5A/h2CalC9lzc4vj+m93+TPCGPonMqU1f5TBroFmj2hCeLe6+63Oxz1He?=
 =?us-ascii?Q?hrKO58xgcSkVPr/SEeZ3Dkw2wnOmGd/LVuSQWLX6bC8o1OrpCjAUeRJeXqjN?=
 =?us-ascii?Q?il50SBPKoPttCZt5Lru2NY1a/JkNzYD+26/evx9pPpteG/xOoGHQNDTrVAM4?=
 =?us-ascii?Q?0YHMvHU2Fup/RAWHz4o25S5FxZtDeTVNKmjBXgMGUaIjmFl+oIuXO4qQj501?=
 =?us-ascii?Q?07GA4Nki3FiK67re476jPjXLdWI7agfTEb3O/9Ppyze/bCGlxnIhMjYGginN?=
 =?us-ascii?Q?ghDPwVZP3XeQ1A6O/gooqH5hA9QCuSczpgCRNm4m90YuY7CBy90g1CDbs2jO?=
 =?us-ascii?Q?m2mXBxpo3hgyPNBeVshB6fUT8j7vcq+O0HyIY7ufVs5H8tH1hvCQtZaQWjiT?=
 =?us-ascii?Q?4zQxChsJrd6moI0ccnKNv+Izu1bHTDmeWU0t44LHPkNmq0h4RzKP7xlmVnPO?=
 =?us-ascii?Q?DF2cSW2UzMDw2FJQechgGAnR2r0I7c4+UPF5H5Ema3fAYniW6gJ+HhXBsI7f?=
 =?us-ascii?Q?8GwzT8qs9TP5H0gRBO/WdGDG/C7Zb4WLN65r2iTodz40KFNSAuVmsIUQCubh?=
 =?us-ascii?Q?qIgJOgOe8k3RSnSIY3U4oKLVIS3xKymDirw5c1KsXS6MQJTBkJ3Ay5YvWj9I?=
 =?us-ascii?Q?SDlDhlCMoBja37PgjU17Iws78rJUfYiU2OaMRgFWun6HYnxsKfdVByTq5A9Q?=
 =?us-ascii?Q?qi0o6zt9aPA0RlQ4c77qsOJcp73Oioq+f8lJXWiAGo/I1fJLNs2TWQBSYKcC?=
 =?us-ascii?Q?+1i07FzebzGXvQ/N8JE5RmPgrvIcDSVbBDcLY4hVNpkytz8scYbQMNCnsGNm?=
 =?us-ascii?Q?fvTDK3GAc5zEQ7MSwhScLCuaQ2nI1jbCOVpvU5Oa0nvZP511KeGEWG+CU2Fb?=
 =?us-ascii?Q?PU6O2fbzOLQ3InAvwhDIjWWxTMA3fNAv5Xv7fD/fIjjs8nm1rvgYu73oDT8Q?=
 =?us-ascii?Q?+KWx6h0kng5QzJ8F8qN7G1RMrO73pd/ozqPU4MnxJxm0Xty3PH8QNA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fa92e6-dd07-4480-c627-08da0a0ac0ac
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:12.7657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l2wT271EfAnj1iZ9uc22w2g2RxKWiSWQJ7GtjbhEDFUDdIwEjXo6a/DRPF/DbhpIlDQS6ipBLXU6UDplxx5PF1xaM1AhA4Oz98mXUpc9DYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: 84GBtk6RvQXQ7Ll2PVudJ_j13s3RqHIz
X-Proofpoint-ORIG-GUID: 84GBtk6RvQXQ7Ll2PVudJ_j13s3RqHIz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename iscsi_conn_queue_work to iscsi_conn_queue_xmit to reflect it
handles queueing of xmits only.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |  2 +-
 drivers/scsi/iscsi_tcp.c      |  2 +-
 drivers/scsi/libiscsi.c       | 12 ++++++------
 include/scsi/libiscsi.h       |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 4365d52c6430..411b0d386fad 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1455,7 +1455,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *csk)
 	if (conn) {
 		log_debug(1 << CXGBI_DBG_SOCK,
 			"csk 0x%p, cid %d.\n", csk, conn->id);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 }
 EXPORT_SYMBOL_GPL(cxgbi_conn_tx_open);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 1bc37593c88f..f274a86d2ec0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -205,7 +205,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 	old_write_space(sk);
 
 	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 14f5737429cf..fa44445dc75f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -83,7 +83,7 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 				"%s " dbg_fmt, __func__, ##arg);	\
 	} while (0);
 
-inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
+inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
@@ -91,7 +91,7 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 	if (ihost->workq)
 		queue_work(ihost->workq, &conn->xmitwork);
 }
-EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
@@ -764,7 +764,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto free_task;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	return task;
@@ -1512,7 +1512,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
 		 */
 		iscsi_put_task(task);
 	}
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
@@ -1781,7 +1781,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-		iscsi_conn_queue_work(conn);
+		iscsi_conn_queue_xmit(conn);
 	}
 
 	session->queued_cmdsn++;
@@ -1962,7 +1962,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
-	iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_xmit(conn);
 }
 
 /*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 10a9b89b7448..b567ea4700e5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -441,7 +441,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
-extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

