Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A4DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiEQWZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiEQWZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04BA52E4F
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKTuFr012482;
        Tue, 17 May 2022 22:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rwVpXPQz+ovPXjwqTcFprCI2d0/MaY6/euKpOGg+E68=;
 b=GVLsvinOUsHJWN9CRSWNmM1fzsJ2ukmYhtXJwuQA572taFwU6EjGFHplyqKHYE13kG06
 Yp1+Niqyjk+KT/Lj4Gb6iGBdSBDPqfLFWebtzHhqYcvFp5dsXUQnDDrejdjg9YiHbW8z
 O9Y9jtR0rrGaW6iPABF9QnjD+PVXXy9pD+NYeLBMxkDAkExtleHQrrhhlcAyWsfJLF7x
 6D4d5n3cB5OYTJs8LpCatnDiz91HnHbfD4blvBSdxdydnmXCT/rNviOoXsdP8U3t4AiV
 zd2w6ayKZhThntyux518CFTU8ComPJWzk06fasqijkD5IZkR/mVgb6tK+gBfLGjsTgWb tg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytqqv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLgi3031743;
        Tue, 17 May 2022 22:25:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVzFdOJUlJC93oz1deDK4Swym20Kh/swswnJNkM4OT8p6yChO5PaI4mt1xYRrpbHgamMuDSikQrDZNTQIyJTc/8735tr3KbISEKXCytnhX1iu5I4NIl3Dmp4/bqzJl7TOqfdguD/jYe96g5IYQ31CemDgcr1YoetNf08cDSDjpfiP55NITNBRIbu26W87aTkIQBgE4DPFaagN0dS7e+U7FkUnZSrs9aoA/VDASNKaShXVdz8wz8W8P9T0LLSYdC4rEepJXXP11MboqxF0BnwVygSk2QLuhnclS9d3QFsnm9gLU4/lQHU3BVFmzOVG23EHMqCB3ToOZwCHM1bBScu3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwVpXPQz+ovPXjwqTcFprCI2d0/MaY6/euKpOGg+E68=;
 b=FICWNzTIGoxoPde1b1B54xg0iOw5qK6Fq6XrShz2YxA7Aya4nTGAXGkbJ6x70F/+bw8I4/0ary5yhC8f+gQrRDPYWWta3FiYnKbHmnsncMGHgx3qoGM8ZNylMvh6Tkiv55DUyGanihAScpwetdWE8Pr18URRzqkWRsQOMnhkqKGCVQYCs9JZ26ePwXFu9rT/bIcbeuonZga6L6V+sdkwT+B2DdXaYQ3Km9muUkn6s/Trzsu73vykBAtv2PVHEezRRcWuMRBabHMBZ/HV4/IsGnZqZscEmtLyahCt6njL4pf4R+xbx5lLBhTLC/PO75JLPY3fvWcMQQIKN99FbSwhdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwVpXPQz+ovPXjwqTcFprCI2d0/MaY6/euKpOGg+E68=;
 b=VNCA2ciB280KAfwHl14tJjhk7zRLqsCOyo9kMLOMkUGPqnBrL/icC0DLpNwEnbuaxgmXbUTTmoKJ1bRODPMg54/9Uljf+mDeZZEeAIVKdb6Y5oxOxMRSYX2GYOMEOS3qwgaimrNdzV8rW96ny5o2h15bDFq+z24poIoOeuPJnGA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/13] scsi: iscsi: Add recv workqueue helpers
Date:   Tue, 17 May 2022 17:24:41 -0500
Message-Id: <20220517222448.25612-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e248aafc-a2b0-4cc0-90c6-08da3854138f
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5517495903200D200ECFDAD1F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQiqJ5sNzEhnbGE2JUzW6SdnREHn+eHRdJK3edrt7fFXVXCN443H04AQiPQVCsGBGF8DbTPQUN3smcj8HPUlT8shA5Jc+amfzzmimNLGhHTbdmGObG9JUQsNWZTan18q0XZtrcE//JYlVKUsOLSE0XsItJPh0HOjKK/H83+3tl3uEta2MkSkFC2BwfCZiyAk1MVMbSSD0LpAPm1v4GVVjzvtcCPdr9+7O8lCGcuq2cLf5XTnhAYf2twh5/o61jwfgrUExcMAjCoSuXNLuDFrsk5Ii6AmeqW2HmtL0ox6EN6j95VJRopavWF/QVGfFpp3FsfiA8mHW53Z3c0ACn/FfDwlofLkzM26n5qZkm7yXDbthF8kfOl8VlYzvDvKf7SoQ2xbmWP7DJX57llFh44PPRm2FPimgKeo9e/MLeM/+Oq7392DFOauzrCrX5m55N+cpnj1T8s6nCzohe7GFnhZvj6GJSYnQCDq/VcqjWpoUvYp25ltTWEP7ohCEYABcgS56PPlSvOvahWjg99+IrxJoqBp36rZyxJmV3dJsZF4P1W7Xkk0CXGh9h7Hd8T9hIRoLGCjNbcX+dgu+TtrOWA9JOh1ckMvuB0vbFNe56d8mimRMTsAvxR2x5YI3HyMoN3Xmm0K3FkjL0VqEFnkrHLUF2Pxtm2flse0Y5+I/bm5d+2f2tVsFETowsWmeR7EDkZuOAk/QOAIzPdb3dNlv0bcxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eIQzz2xjBdj73PWKXhdigutRGZdRPZiu8lHb73+9t246lSPRyG+hQ4N7R2UW?=
 =?us-ascii?Q?cbUZuSlsoK7OhlMkByd+Ia97XOO3pqwwyxUeWlb9GYnscvbQN4dJs9t8DI2t?=
 =?us-ascii?Q?aKJDBjVRfhrbYifZBHGUgyc1umTLWDeh16u2b4ghVHZ5RNbHA4FmVTluX1uu?=
 =?us-ascii?Q?kKB+cborSjWb2fHQUagpKb256IBAUfvhOMzPvKYoSSY6raCb0h6VpIuCaIzq?=
 =?us-ascii?Q?djXNF5R+r8NWK7UyLZS9JJkHKJPqh4PopRpiuvJolzV9uEJJr1TeVoAVxMME?=
 =?us-ascii?Q?j2gEMIyA67H1dtnywM18maYegnEbLDwEnicXIF1q7oBK/YqY50xHPS066hwh?=
 =?us-ascii?Q?KG3L8EMtjXdL2ZNU2fcpVw6e1LztnRcT8ytbZW6kzTc400WiOf5GRvZQUbIV?=
 =?us-ascii?Q?EgW48Rbj6qdzdK37+SFLtc9R7mI5LTOJ5ot1nV4qs/JgY6qYAP6ciAgZU+Ef?=
 =?us-ascii?Q?+X18+fuyMuqnksTWju/j6SVcTvb+AP/+GSS1wiXYmnwWk8HUsDvRfngG/g1o?=
 =?us-ascii?Q?8UIw7csZLmc64U3BMlCsmoyhhqc4HCdsuyO6/eGmZn4u1nYCWr9/Hs4w24Ot?=
 =?us-ascii?Q?S967AXQnF0+GhNcKoHZmb4tsCyCCyaTHnBYlDz1VAk79IVIPJQ8aBQ6gi/dU?=
 =?us-ascii?Q?wywGc8QXeVv57mMBI7RjEcDGOzqBnf5uTfoYWDmHN75FSd1/JzwDqqUekFwy?=
 =?us-ascii?Q?58w1oCiwJNo3W89W/SaKWV+M+TQhJ4TNOjjid+gBUYqDO+WsAb7Q02cO7+Z8?=
 =?us-ascii?Q?P+2KJULylXbG6MDIui02TujBRVTlCc5m8eOoWB0Hc9JdDSfzluaga2nquZsG?=
 =?us-ascii?Q?GgDtwTWkDXkuuv13r0jWuqpqpEi5Rdgi0dklXBu+fQaW7wcBsizRH+d9VZfy?=
 =?us-ascii?Q?m7hY8OtsVsgCqq60nU980KposLr7kmeYLznNQfLByDYEiMLEwCh5dzaThu1l?=
 =?us-ascii?Q?hQMsxo5McQuHltnr59dmbesH2ZqTiqWlzqSLyh2dPePQrW2Aj/8w62pziLXr?=
 =?us-ascii?Q?+oELWAGrNj4tSSDF4rp2uH2eEkAxuCz0FBJ4zY8d4pSlVuWfKs6Hb7SW+BHw?=
 =?us-ascii?Q?A57rySJOrGRIdkJRhNMjABcy+Zq4BxN+J0pLZ88eSdtUaqRxLdFSZj0yWr8k?=
 =?us-ascii?Q?PeQS4w+KKvv7B9pol4FyIcBxHYQ15g4fwgarDwvT4Ytjl6CSM0VxyGVQC75I?=
 =?us-ascii?Q?G6VZGMPqPwdGpOQVXVCg9IqGpv4hmFApWlZ+g08H+sNdzZqBsgRud+gkDc9C?=
 =?us-ascii?Q?yKwpssBc4nHHNuxJPO27fIhyQsju+pHvJ9rYbSM16PMRZeEhQ0yFpv+hdURn?=
 =?us-ascii?Q?2pxa0j3/EeUi8DRxLzrmWj0MKI57TE6loGb5ueQ7us/9DQQ4m3/p403NwOmy?=
 =?us-ascii?Q?hoV2M4OIZGHDuacDKOpY4+vb/myNFxsMWXdbMGy9CeQrF8+Hf8mYwfuNdo+/?=
 =?us-ascii?Q?aeOpX7ePn67w2FmCpb3F/O8IejKdcF8nKlC5ytM0eND3WrIKbwqqvI90kQGK?=
 =?us-ascii?Q?6RctZO7no31BTBUXE7LOcyoCfJRF+VAaZIAYZiUncTNhi0NaKcFHhPbiqVgA?=
 =?us-ascii?Q?sOmtW0MtNMe6E0peoFMUcl1O9PkyMPrhUsbWxIvaZS45f2tRqHvVgE323qmz?=
 =?us-ascii?Q?FPz93qgOuBaxlWBoJOZJriFwUW1PVjJwUyMn71Oji+2kBwPnBja1qVAWM0X6?=
 =?us-ascii?Q?wcEUsQVI15M93/Ne++TrarVp+cKtyEo2ptNa1wn+qkk1eAGr4jqkKGVaximL?=
 =?us-ascii?Q?d8Ap+/JGFCm7sd5by3a5lFG913Gmv64=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e248aafc-a2b0-4cc0-90c6-08da3854138f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:58.4493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G6PiMst32tSxqoeRJnUm6bO6xALmZRTPWjdW20NVVU+fOH7QHCIRJeOqugsHfs3nKXNh2Xcn315+1W9zKi/4LSAJnQIxMeu2kqOxOlcN8us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-GUID: s3hbz07wBP_7FLCLFDYhW30RhKSC0992
X-Proofpoint-ORIG-GUID: s3hbz07wBP_7FLCLFDYhW30RhKSC0992
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers to allow the drivers to run their recv paths from libiscsi's
workqueue.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
 include/scsi/libiscsi.h |  4 ++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1bd772d9b804..8f73c8d6ef22 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,6 +93,16 @@ inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
+inline void iscsi_conn_queue_recv(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	if (ihost->workq && !test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))
+		queue_work(ihost->workq, &conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_recv);
+
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
@@ -1943,7 +1953,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1956,7 +1966,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1966,6 +1976,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	iscsi_conn_queue_xmit(conn);
 }
 
+/**
+ * iscsi_suspend_rx - Prevent recvwork from running again.
+ * @conn: iscsi conn to stop.
+ */
+void iscsi_suspend_rx(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	if (ihost->workq)
+		flush_work(&conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_suspend_rx);
+
 /*
  * We want to make sure a ping is in flight. It has timed out.
  * And we are not busy processing a pdu that is making
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index cd1049393733..1e7c5c7f19ac 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -213,6 +213,8 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/* recv */
+	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
@@ -452,8 +454,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_suspend_rx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_recv(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

