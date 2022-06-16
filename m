Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE78BC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379159AbiFPWqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379150AbiFPWqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C46262205
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIm6DL032726;
        Thu, 16 Jun 2022 22:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=JCRsGOWJ1NTG9Fa7EtV71ZLam/8OEdct4i79GPCrAao=;
 b=ONRhVgZ+ab/wmqAzvbUWf9G2RsZc261bEICTEDbuR1WTannxBLpC0Jl56IMIALYZYcvC
 pJlw4EVwe6NU5uxkbzEwzoahit7Ypbaftmh7wKioRA5eSaMRVqmB4sPeKlFn7SA3h1Pr
 FWHuGklVmT7L/py5xd3P0imubY762lHCb6XPYQuCiKi/GZdku5O2L2m0v2sbrW5vXhdn
 ZLyFUQhklVPhU7aw/KtMtoNtB+CODx7E6cd5G6nQL8IkEbPIfw/rHTVUUsDAupYmtHZb
 SIhnksMwrYtV13SmuTbNjbBjwoe3A+lS4kJiNzvZq93GQ37s5ckFfEzeCtUMLYd16YPH ow== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2vmp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaPd3035724;
        Thu, 16 Jun 2022 22:46:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf78ckl40ouUjEVqtWGpZiEKKER/N/S4SWxIBfDcvWKH3pLbzKydNi2/mJWQbqyu26kVe+SMIJqhgpcrSUx5TOTKAVDZ261eA+OvR4CZXkWyK+DFb0kajlbTOKHJvH64g7UdCSHqaGrWuYPztHH958r+b5ZV3jHdMM7Zoe6W48YLnoRgTRxq7fIJyTY4dzKPOK15aPMaJW0c6XGPgyFl3uXNxtZPjL4QviLgIK2H4841Cch/2HYALTrbUXvkBZ+rbP0Z6REej9RC4n6oms517CSrfj+/ZH05Cw7kAUVNd7w2N31r5Oya++i7KbKqxAhJX0vcwqC3XaGgbEgApb8eaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCRsGOWJ1NTG9Fa7EtV71ZLam/8OEdct4i79GPCrAao=;
 b=MvIyxlHbbsVaBMEukr7zDvYBpsGDYKQ04iSYwYpLCzr3K6Y2m8zXd3iQPYHFFse4OVFtOJxLVGpCZ0P0ScfDfDUVySUp6Yh05bWImZBmkkGLRFMMGI0bthngTNE7Jm28jt9+zwZT0LfDUZaRtvaPqw33lPetoouW+IDb2293qIbVGf9DU/Osw9G2y001Nki+ZDY/UVbG7QFvT0pV6dZQJbnfks61mpv8jiYOnUbzuaerXnttbkjjpows3CpB1YOgpbi5auh1ON/dLa2QGe9+8CFJVWBkwzcE+gai1wg2k2ygIGoMvbOxMhpzEFZVpqNaZN+PD0sbLFAyXjbYxDUF7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCRsGOWJ1NTG9Fa7EtV71ZLam/8OEdct4i79GPCrAao=;
 b=mJ+rCuoaAd96vbc+Sxyd60yTP+4x2PuBymdGlq3Kwa6E8QZDG5ZK/458shZlj12tUq6ZNuQSh9uL00gcmEuh077B63UTY8RGGfsAT4Ndqz6NtwJcUAhYLhNksNnB6Qtr5tcVU82uvjyqAZXAOeo0lUlfF/GOz9s6fVg838LDqqU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 8/9] scsi: iscsi: Try to avoid taking back_lock in xmit path
Date:   Thu, 16 Jun 2022 17:45:56 -0500
Message-Id: <20220616224557.115234-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2c43f00-d94c-41a9-1076-08da4fea021e
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB56173FFEA5D5E92FB2DA61EEF1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lD6A9EM4yEoPk+UGZm4L1XY2PolGuSWgxauptNoFMyaSh9KwkCDRt2Y8Sj64T2mNcq8zI+fo/EjuqUhzM0T+XAk2X91cooGPzeCpi2S5529JvnkU6PoUuDAhkNQ6Z3eMRNZWvUewiEde0OMxaNLX5/NdcfHch8WKtjOjroQxJn+BGUfF6nCE+/zS2r/AKpnItLZ4y7pQ6Dkf1uG791ZYnq2zpQ7XGBAer/VWiT5RuGG25qZTe1i4eLHpMEsijcHLI7DGsOxbq+dw47KK6HIGsuNQfXAQTwdv0C+VvsDD2/ImFwGOln5LRzvxMY9MRgQBH2MZTwgbglXHszaE/Fa3mxg93FfqKOAGCSi65eSj1qIzA9WgHj4Gw+VA0j9UTfCKXxw6L/chbxCiaT8+y4jJwAUHPObZJUajAUMup6mt0WRpyb7v+P+x6lV4Ua7KFQIvmYQdfynJXO9vyVPK5TVHyvfz4nyN5ilw535I6eIoa+E1e8Dwq712MB2nnRDEvbH7MUakZm+oZxR11PcMyKE4dyJhO53jkF10gjtfU/igSiE461cd7h3eu7p7o0q2ySIvS/ad3aTHwU+ME4IPx8lWAUH+3umGjmYXeoiaKWljmqIPSSqhgc1iqYzAzTuCmgYO2OKvO9Xtq47vD+Ig6q39QYP8F5WtIDIO2+h3b2vlXWXbYDPiKygaAofG7WS2lIGuoT/66WCKVtnfnnZmLrK3sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(107886003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Syfs0AJm7tnvPz+xSTAbUxxDcZnPWWXysozwOSCHbjGSb9B8EU+o/DEBWwaW?=
 =?us-ascii?Q?AciM2CCORKlXWRpsp24jDKebLhfEdoRcx+QkWRpr5pE4/4+bWKIPz7IuI2V4?=
 =?us-ascii?Q?A3INv6kIOQhPO3AX1Obut7IY/TaD+avYmkeP1t/v996TDgBK0OwzXIDmFKOl?=
 =?us-ascii?Q?JigMixDCa9X01mbaiZf1hZIg1Wowheu0n53KuV48p0WCP8qsyr7rm1rRgAnW?=
 =?us-ascii?Q?abgj1TnXRW4gbXVempsJvxEA8Xy9Jw/cS3HBBe0hF5uRjCuzDPSWrz3dFLjP?=
 =?us-ascii?Q?1VLeks4wMAdY3Q/j5Q1OUrqEWlVVOHz/VOCCpfpHeA1bo90wer5oWRryuDqV?=
 =?us-ascii?Q?7Da8s39UFuPs9qlVARH8VnA17xmtXLzVPb+EMD0hoQ+cNzBxI+7X2Ve3wPyB?=
 =?us-ascii?Q?jlPbmRYDMcveOBO1UHPNrnsqJJ9N1inQtaOXuoDhzuCCM4jvxIQ1HFbqzXVi?=
 =?us-ascii?Q?URqMnmbDwFzRbCWzr7fMSeh9DGQcV2Jsm1iGQNNE3csC7ZLF6qtp0R5PdAt1?=
 =?us-ascii?Q?UK4mwRq6LzRRKRvu9k6pDlu/5QZgMNSGzwVxo0wr7+M9/fLRxqFUOz2/q8uf?=
 =?us-ascii?Q?AtSqXm4mNyQ07u6JXV1bH5N3IrBo722TGip/eW7X0CKmMVADfKo1cplinBRp?=
 =?us-ascii?Q?nMW1upIkJSoJCMs4LZ3INSuAhTwhc0vAxbzk55AwYb8U8yFDw9lIIB+pXwA7?=
 =?us-ascii?Q?l4wvnPjqFZvFjMg/ihF+PUC8k/MPM8TvIlBdzz9hh/OLpwapU8zepOYhENgZ?=
 =?us-ascii?Q?tXqZfj3dNkuyVwhQSiflir/sG17Nsmovdpe4hlOL7oHGFx52vG81Hq4gVpeo?=
 =?us-ascii?Q?8u3GO7c3P/C/t85mQ6XGn9vs+bXh+KoM93nrto2DueH0FJmLPNP+vn0XBXcI?=
 =?us-ascii?Q?2RTKE7P506sEIPbal1+YozTNNq1+bFna/mgGs+N9xcopZP3Idpyo0ny7kPgg?=
 =?us-ascii?Q?enemKFMj8ABErirSbSQyxvIStzE1wajy2VsCQuytJYmtzq58Xrmdadk1ugZF?=
 =?us-ascii?Q?YisMGjWVIn8VhY8V9XEG1sx2w6JC3e/CaARx2GysdAHBKdA5oU5oBvfH+yNp?=
 =?us-ascii?Q?ICSyhy53T1K9C+YaF2VxHKPs31EtO17GiggmFdQz6UlQQInMDRMv/PctTMne?=
 =?us-ascii?Q?wRd+ncrpSSpgkXCbRHJfPBZwUTyVnoWu2klrqStLEucJ4CfRnqSsIbOBE6Fq?=
 =?us-ascii?Q?Q+cUY5QvRGzjywsSfMBPuolPI6WqULIA0V4yEn1ndD/4CslkfDkfGiPynPau?=
 =?us-ascii?Q?v07exvPoXrDQXzS3bHBHeKDb+eA3iTqWjQcTa/UZ72SdsKlJgIV9bqQ9soEI?=
 =?us-ascii?Q?gcHhCF4cOH0NFJy90+NmNF2y3YpMbqdT0rdWyvLJDzwzmGJcOCYT65YmSvO9?=
 =?us-ascii?Q?/AIC7Ly7wv003LBXcK+hwtwtbTP3joygbbwnzctPvfjYwDqGZsj12f4+gMqW?=
 =?us-ascii?Q?nka25xCckEsqYZtZDKU/TSLeEJk/qge95kgH+/Ln8ys5eMDzF0HWEaIFjVzF?=
 =?us-ascii?Q?aWOdU1oJ5wBhvvSuwZsYdV5qo9l91F6eEqJAxyKalCc87aBkrHESHkV+q974?=
 =?us-ascii?Q?I1vURCwcR0UZiaUMjRtAOo3D7i1/8s5QWuU4KCedZx+sq+eh/L4KwS7egUrv?=
 =?us-ascii?Q?CSiwzqi6bgJLq7kiHc83b5rYLV/j3bS+ZFF1FzbkMOvtEBlCHip5rm2/F+dq?=
 =?us-ascii?Q?yhw7d1hT7Z0FbHPTeCp+U8Z+TwBLhoWqMkzgQjc9VkuHaOg6DTKCp7be9gwx?=
 =?us-ascii?Q?E5oEttOAf/vlr7hhUWwfgIATiQGfKPE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c43f00-d94c-41a9-1076-08da4fea021e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:10.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /iuohUXkofAlSLu/zCLn33fDyH126bGWyBdC8HK63l6TNtrraEp52G7mBYsKHjkGdZhCy4qLeXevajPX9AXi96BG/FUnhdWd7o5OZWDm90U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: P-EVV3nJOR_3gMh_VDZmOauWyh0TiHcc
X-Proofpoint-ORIG-GUID: P-EVV3nJOR_3gMh_VDZmOauWyh0TiHcc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need the back lock when freeing a task, so we hold it when calling
__iscsi_put_task() from the completion path to make it easier and to avoid
having to retake it in that path. For iscsi_put_task() we just grabbed it
while also doing the decrement on the refcount but it's only really needed
if the refcount is zero and we free the task. This modifies
iscsi_put_task() to just take the lock when needed then has the xmit path
use it. Normally we will then not take the back lock from the xmit path. It
will only be rare cases where the network is so fast that we get a response
right after we send the header/data.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 07fc78aa1aa2..da292761995f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -490,6 +490,12 @@ bool iscsi_get_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(iscsi_get_task);
 
+/**
+ * __iscsi_put_task - drop the refcount on a task
+ * @task: iscsi_task to drop the refcount on
+ *
+ * The back_lock must be held when calling in case it frees the task.
+ */
 void __iscsi_put_task(struct iscsi_task *task)
 {
 	if (refcount_dec_and_test(&task->refcount))
@@ -501,10 +507,11 @@ void iscsi_put_task(struct iscsi_task *task)
 {
 	struct iscsi_session *session = task->conn->session;
 
-	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	if (refcount_dec_and_test(&task->refcount)) {
+		spin_lock_bh(&session->back_lock);
+		iscsi_free_task(task);
+		spin_unlock_bh(&session->back_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(iscsi_put_task);
 
@@ -1454,8 +1461,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 {
 	int rc;
 
-	spin_lock_bh(&conn->session->back_lock);
-
 	if (!conn->task) {
 		/*
 		 * Take a ref so we can access it after xmit_task().
@@ -1464,7 +1469,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * stopped the xmit thread.
 		 */
 		if (!iscsi_get_task(task)) {
-			spin_unlock_bh(&conn->session->back_lock);
 			WARN_ON_ONCE(1);
 			return 0;
 		}
@@ -1478,7 +1482,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * case a bad target sends a cmd rsp before we have handled the task.
 	 */
 	if (was_requeue)
-		__iscsi_put_task(task);
+		iscsi_put_task(task);
 
 	/*
 	 * Do this after dropping the extra ref because if this was a requeue
@@ -1490,10 +1494,8 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		 * task and get woken up again.
 		 */
 		conn->task = task;
-		spin_unlock_bh(&conn->session->back_lock);
 		return -ENODATA;
 	}
-	spin_unlock_bh(&conn->session->back_lock);
 
 	spin_unlock_bh(&conn->session->frwd_lock);
 	rc = conn->session->tt->xmit_task(task);
@@ -1501,10 +1503,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	if (!rc) {
 		/* done with this task */
 		task->last_xfer = jiffies;
-	}
-	/* regular RX path uses back_lock */
-	spin_lock(&conn->session->back_lock);
-	if (rc) {
+	} else {
 		/*
 		 * get an extra ref that is released next time we access it
 		 * as conn->task above.
@@ -1513,8 +1512,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 		conn->task = task;
 	}
 
-	__iscsi_put_task(task);
-	spin_unlock(&conn->session->back_lock);
+	iscsi_put_task(task);
 	return rc;
 }
 
-- 
2.25.1

