Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7910C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiCTApo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244482AbiCTApm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E7241A0A
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:20 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JEhZuu012459;
        Sun, 20 Mar 2022 00:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8Jy/+JVXk9IAC7M0AaOgj6YuDq7rEotAwYIHeNzP9lw=;
 b=laFuP7eiZ2Y4odBSF+YuasJxM+Qlw1TFNgVUfIj+em2idGvWvE+Oc766yWAOis0Cjqef
 T+jbhkPSlHoi2M54ngqvO9zg6GXefrNw27rplh5N5DMXp6dmsznBvLzS7YZc247Q5vgQ
 LbkI+GykifN111lq+WGxjh5bW9u1RoL4Nccyeuk3ZFW5OzJU54bvQZce+8Djso5fBNrj
 wJ2ZzqkMNmBmHKXdGtPNtD3pAkY+lRyQGGRYr1inG7fXUlMJoqRUClTXZR6LrC0QFgSR
 NqeHdL5HnSJu8V9P45HoSvo9hwGkdy88JGftaCdxDxFKBTEl9KsF0tXv1hkhw7Piwa91 Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew6ss0uwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffag137063;
        Sun, 20 Mar 2022 00:44:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkH9/Yqb1GuvHB8o0wiV2sRWPPUTKkCPprb3IDlZ/yGT8xe+kwKwZUdP5yLpKis8OFmj8kmTrEo8hNLRnr8maDCfn25CPTlhhfKg37ErZh5LAKfZlzWudwXAQCRp4rlWz5XohkcR8ITXSbrqU+pCToxMoEVZNbSbK0H3hhNR1S/lWiAHV5P0fSEq+b4x9sQEj8Uq1YZbLUr7rfAnwBMRaVM/O/bGVOviYzXmR48IxwUtClk4wY9NC0FmQ1s1/ay5v/fN1T1FlVd9nU/oByOZLN+qVSCWWTboObR2IEYn2NCELApEk7yd+Wx2WAKM8r9CAN0c7Tj7xJugc7hfscEh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Jy/+JVXk9IAC7M0AaOgj6YuDq7rEotAwYIHeNzP9lw=;
 b=VhUpZTgo39WEkDqACMIoiIJCSUo1drCJ5399iM2t78ltfxJLUxl0EJXCN4gTIhWu5TyeYi1+m45Au7zvPE805J1VgTLH4/yNe4g4F60xh8QJEl4f8ootURL7MJ9+/VfZytPTUvxdYPUaFQDcDtrsVjJoqu+pTl9B4Uov5CpnEpOQxSkRSPaai959eORZqzXhP3Myepzw9SFyqFbaWxWIlQ/7zLF+QyV40lweWlV8aul0O9tIOcucRGNVbh0tGm1TYVDxtxNlDyHDyWetz5uHrtNsevD+UTq0kWUmwkeReHFNyOhunvov1poBXlSlnIptNYJ0BjSPyVofOg0IUvZmNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Jy/+JVXk9IAC7M0AaOgj6YuDq7rEotAwYIHeNzP9lw=;
 b=wRArBEb7Gy2J7noahicjBe4cI4Ej7El6DDNIz3m8TuI1SlGaamkLfT3VA2fztP6HZy00Vzw6XBm4oRDCNgyo1qGQwLwqj+9xgrLEmlvMtYoJxi7RwYHi3RcgiCzW5WgEVz1vzVcBW+OEQnAKFJvU69Q8YEfKXb0jBiiRvSJjHIQ=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:12 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 01/12] scsi: iscsi: Merge suspend fields
Date:   Sat, 19 Mar 2022 19:43:51 -0500
Message-Id: <20220320004402.6707-2-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5be6b446-e14e-41b5-1c62-08da0a0ac03f
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992AF42C5C63A0ED820BAACF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5QD+slie23M0sUO+rnJL+RHmQDgdjvfQZJBhrxdzUTBp9+1gbADI+oQhc3pvlwMFYHFvZ9wCvvHa4Y6+RcZJqpYMnUNr0aDx33az4txscFE/mGlZZQKYHr1NAH8GoNCbVnnTVtz5B8RLNFuHCirNyNfgsHF5qlBViyyZitKZEnQ9Fsfx8q25LN/ZODYfyD8qNUcFIcomZVsfWsn8HR0/7dibBlkgcxA1R+PPs50QBc+c0L1ibc8XG3rM22y0Ih9nv7uymiasaj6Fwy9my40WeJPn42c85KNDVB2D2kPWzs5WsM9WQ6IVS7qK718vIjsPJU+SKm2lkdu41ucK8N/8VmkA/gGmrenPAGE1hCkH8Uy7/myX6W1JRErCZLz/TTbSPRAnsC2VxFBPo3jsOJa6OWsYP9ibE6rNDkUrzMziaPD8xUJyDyW0Vh0MbBpF6HfHWMMixS8s4n4BicZCt2V7ueR+aPZtoCbjIMn231Ddf81UnP02ZuMQfxF9R9CKhgAZydoZdubt91Tyx+xFKJjgil11SOIvtVUlKR2+OHB7AQ8xt9wBiE3RqLYF49ieetamI86Wz9FMImeIBtwDhxzJb6Yotj4hAwB6UNirmSuC6STDIYW599aQNZUxQRPtMF4FsE3cMsHHnHn92vQczRPeI34e7d7UXk5GI3DM5F4CjX9CCuWaxugU7ovFLP7apLM9N4qgo2Bj0A1uuODHUAUI9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TZP5HKZeW0M6g9xGg4AnL4nNfxYfC0CuShxyyJsyFWYav+bOG2JoifRvBZO5?=
 =?us-ascii?Q?8Zfn5FCtzoDG6IUtVXRcM1cinu2t0aFNUgDy9z+Ge9LeHuax3h6kxqTzc2ZE?=
 =?us-ascii?Q?wV9cNx72+R7KAYpp6xpFDfLvZcAg9NslAECphKxTxL/UuuyxPFuY01ik22Xy?=
 =?us-ascii?Q?tvuNJN+jugCYNDGYLJmS0ELpGqqRSZtZ20KZ4Odgq3E7Wdt0VpxQnreaB0tf?=
 =?us-ascii?Q?VylZPUnt9B7xY4HKZAobryXzzMsQFMEfCAf83KnpWILZrnpuoCQHS4otp1HO?=
 =?us-ascii?Q?puR24XFs10XQEe73CRpGEJOh9+eX8WKT370HW+GbGfyZOoKLpiAVbettxAv6?=
 =?us-ascii?Q?nV//DcYhX4Fnep/Twg3UgvIMK0dMoAD/vps2LTUpHzmF3C0wnz0vqMFHUS1k?=
 =?us-ascii?Q?EwIlY0JMOAmLRoID1NpdJW+lIEg0xG71ZF9Ek89r3Hd8veAFZp6mYhjILzHO?=
 =?us-ascii?Q?ES/qcuoIpC5Oic0raYcBxkDDcNDYNnuEe0esl98F6cT8eabLiVd5ZAiEcXXm?=
 =?us-ascii?Q?xIK9zHEY+1pM1xM6heP7UKQOKot/j/VtqeVIF987gqxQ+yokGT++UhgHjm1g?=
 =?us-ascii?Q?k9Mvq4eoOv+8oRXPbd1R8PQOUHeuDKj+L5K3J7UC9tERXK3DoRP7VmWEDyOv?=
 =?us-ascii?Q?o9/z4C5VBg/Yw8zyKUgdx/Lz+ihy4uIs2poROMY7qOoEKpcYDl4I6O3mYdXY?=
 =?us-ascii?Q?0nC/9cfF47B6mz4IylspyZNVQlkMgwiV1FcCGTwg04b/f07rwf64APYKdqD0?=
 =?us-ascii?Q?UknTYW2PhL+XxME6QcsXbqsLRMLYmIiBD83E+r3CA3m+UeJ9c+lTn/Y/J6FW?=
 =?us-ascii?Q?f6+2zMwYLxqF4gzUDe8wO1AQddVjVooOfm2MXWIBkfVKbyVObEpJ+WH+29Pk?=
 =?us-ascii?Q?RFf7igIfmE/LifIuntsk+1DgDsXExRa9TV8f+ktJ6Z/h2wK9sqcn/24X0wXp?=
 =?us-ascii?Q?OK2DmSMoP5w4XZ5FgL1ynScJQaTHxTgXhCJU2yNpp+jgcXb9Rh+Bt/0UhA88?=
 =?us-ascii?Q?5gGuGUFmxXKBGTwtzHhCEfXaRdf8EqtgMPyhRVbfD/3oQOUUebgALyidK+94?=
 =?us-ascii?Q?YsCy/WNXGBOngEcC8rM15uWeGNT8a4Yw0z5jTTZhMsWjlKhU+PyFZbfPPSc8?=
 =?us-ascii?Q?uoWPlVwH6N7IaMvDKlI6fcaPWuogd07cA3pvIpnNOvUDfDz4UKe0gfgMDQ7H?=
 =?us-ascii?Q?dF6hU0grCXIxiSWkzv1aloV6I8R1+qab8Vgq1DQiAuBYt79JB64yin8qIvJ3?=
 =?us-ascii?Q?JF9jfFFYmn/vbqIjT1pXQWmp0hbIQlBenAWKYGggr6k5/3dDZqjh+Oaej8pU?=
 =?us-ascii?Q?xOmkmfgFmusPoVn7nV6MpwvPTD8BoXl2EYMqg+zLVbDdbSdMZIdiqhicHvfR?=
 =?us-ascii?Q?LGVhBBX6Y+xn+d/qzTOsdbaote+6uV9kz0TwdhItMnHvIeYnzGPMfmEK31Tk?=
 =?us-ascii?Q?NfIcnE5JDmcYAFFn+7gFe2eR7K7RaDnH5TS32RddhzGfqm1Fb1eaOw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be6b446-e14e-41b5-1c62-08da0a0ac03f
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:12.0158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ee8zHRJASz9oPwb9OUbkqxt+iW3sV2DJZwtsGZ8UdmJtDRz/61MuMkdib3Vtdygvp1Bigp5Z2KeHCkti8W6Q3LCXb3Z6tRzlAzQ0CQ8uzME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-ORIG-GUID: ruRqb7-MBGMh3DQ8-8_mLyBjo-rSzv4D
X-Proofpoint-GUID: ruRqb7-MBGMh3DQ8-8_mLyBjo-rSzv4D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the tx and rx suspend fields into one flags field.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c    |  6 +++---
 drivers/scsi/libiscsi.c          | 20 ++++++++++----------
 drivers/scsi/libiscsi_tcp.c      |  2 +-
 include/scsi/libiscsi.h          |  9 +++++----
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5521469ce678..e16327a4b4c9 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
 		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
 			break;
 
-		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
+		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
 			    nopin->itt == (u16) RESERVED_ITT) {
 				printk(KERN_ALERT "bnx2i: Unsolicited "
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index e21b053b4f3e..a592ca8602f9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
 
 			/* Must suspend all rx queue activity for this ep */
-			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 		}
 		/* CONN_DISCONNECT timeout may or may not be an issue depending
 		 * on what transcribed in TCP layer, different targets behave
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 8c7d4dda4cf2..4365d52c6430 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
 	log_debug(1 << CXGBI_DBG_PDU_RX,
 		"csk 0x%p, conn 0x%p.\n", csk, conn);
 
-	if (unlikely(!conn || conn->suspend_rx)) {
+	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		log_debug(1 << CXGBI_DBG_PDU_RX,
-			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
+			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
 			csk, conn, conn ? conn->id : 0xFF,
-			conn ? conn->suspend_rx : 0xFF);
+			conn ? conn->flags : 0xFF);
 		return;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a75b85f0a189..14f5737429cf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1392,8 +1392,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
 	return true;
 }
 
@@ -1454,7 +1454,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
 	 * Do this after dropping the extra ref because if this was a requeue
 	 * it's removed from that list and cleanup_queued_task would miss it.
 	 */
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		/*
 		 * Save the task and ref in case we weren't cleaning up this
 		 * task and get woken up again.
@@ -1532,7 +1532,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 	int rc = 0;
 
 	spin_lock_bh(&conn->session->frwd_lock);
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
 		spin_unlock_bh(&conn->session->frwd_lock);
 		return -ENODATA;
@@ -1746,7 +1746,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
-	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1935,7 +1935,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
 void iscsi_suspend_queue(struct iscsi_conn *conn)
 {
 	spin_lock_bh(&conn->session->frwd_lock);
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	spin_unlock_bh(&conn->session->frwd_lock);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
@@ -1953,7 +1953,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
-	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
 		flush_workqueue(ihost->workq);
 }
@@ -1961,7 +1961,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	iscsi_conn_queue_work(conn);
 }
 
@@ -3321,8 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e9ffe3d1a55..883005757ddb 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
 	 */
 	conn->last_recv = jiffies;
 
-	if (unlikely(conn->suspend_rx)) {
+	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
 		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
 		*status = ISCSI_TCP_SUSPENDED;
 		return 0;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 2d85810d1929..10a9b89b7448 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -52,8 +52,10 @@ enum {
 
 #define ISID_SIZE			6
 
-/* Connection suspend "bit" */
-#define ISCSI_SUSPEND_BIT		1
+/* Connection flags */
+#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
+#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
+
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
@@ -199,8 +201,7 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	unsigned long		suspend_tx;	/* suspend Tx */
-	unsigned long		suspend_rx;	/* suspend Rx */
+	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
 	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
-- 
2.25.1

