Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BC0C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 00:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiDHAPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 20:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiDHAPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 20:15:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CC412C9FD
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 17:13:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237MCjRG024455;
        Fri, 8 Apr 2022 00:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=phRPEWX0KNlZzSLO/NKoVCjTRpkyGXzd2V2+lLJVkwM=;
 b=tvfNU27OfDUZ3/E7EReXr1ZjoZdlWzMqokz5ElmNKlaFagfb/WpnTZroo+QjNlzErfXq
 TlvJbXhwUzEdMNouNAyrMbU9Kly5zLjALNJRzHnbI6F1bEedQQu0nEURcFUJS63pghft
 m8ENs+erQ5KrZfNSrwXFaRZgE/jz/7+eJ5ZYeYPd5yLJ/ikeTiAcmCh9XuJAIbWOgCwg
 +hehIPsTDevVPBI82z/xORjgWunKsfaefD+Af+F8xkAwAmDTLlvD8ge38pJCmDOyX/ed
 sC+xxB8Ufu20KxeOe/+fOyevpIBjPcICCvhw75QYe1R26qqR9YJek/eBcdyQ9OoueH+O iA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tdnhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237M7smi029005;
        Fri, 8 Apr 2022 00:13:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974erfry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 00:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0OWhBPWnSy5KV3s0slsEAN55Si31J4LiF3XRMJlqbQf5tnJfktFZy8LCnwXY5neNhGjHKTh727jBdHxOsLI0IkfXSG3eKyhS86cYgduLeRkEyq4FIWyh9Pv3CO0e0RSNnRAz4H0xlUN0+lgr3dB2F+Ihr+tbKKkfsV9FkGrovIs7E+lo+DEl5ATak9XvtATflZ9MdAEBMbxxqy1KsGhcta5V0B38AG7XniZw9oHtbG3+MvDnNpYtNnCOAxTmO+SjmzUnCEq6py1bsfjgtdcbPKPxWhXro4slH9Ag3mcDByzafw9AKtYk/Vu64VDJf3emrg1EkBXWjE/SDX+9mzKFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phRPEWX0KNlZzSLO/NKoVCjTRpkyGXzd2V2+lLJVkwM=;
 b=NZLuZAotPh/I5KO70YThaTd94kkOEAtddby6kUyjDK0TAYlwI5mWqv6SP4tInGINvC442qg9lyMyvSpl6hZRBPY6/Ind4WwYYTOPOxN1JSEvjEUibHUg17DRDNRu4ZOo72Mn7jBWRZoszmrL37nyW3Mqrtdc6pJof60NJvJurL0CH2kik2elgd3UYl2ho9JP2ukcQrHV2Tnwm6/5U1WzgXeEPc6Bw4sl8HBhPBQKncLoZYXKDNBPWcEfPXwGzXo8R/po9ZNF9G/Onke1FXCRo+IHHFLSOIiMCNLk9NKQjBsOdRLLVuXa+qFlioO86g+Mtv/bYv6aNtvuhRugpA5v9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phRPEWX0KNlZzSLO/NKoVCjTRpkyGXzd2V2+lLJVkwM=;
 b=TLenZVyJGEIbepon5XuK+FfecZAdOpG0RdxNu3S+bLZsNqlbeJ9wz2PiI7robGG3RJ553o5cdGiuYEomkCrF8FCXrkkLVAIxyAbhAIFDOQD8jl8tr03gwCW7HabSuzM1uylOWLRXYiJNeXkyZjsu8uEpGtWEveYh0lpc4lrzpVY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB3762.namprd10.prod.outlook.com (2603:10b6:a03:1b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 00:13:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5144.022; Fri, 8 Apr 2022
 00:13:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     skashyap@marvell.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/10] scsi: iscsi: Fix nop handling during conn recovery
Date:   Thu,  7 Apr 2022 19:13:12 -0500
Message-Id: <20220408001314.5014-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408001314.5014-1-michael.christie@oracle.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3262731f-4fc6-4e9a-ac17-08da18f49a31
X-MS-TrafficTypeDiagnostic: BY5PR10MB3762:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB3762377DC0354DA77149D880F1E99@BY5PR10MB3762.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1rLLdUuJDgbsf4J9g7jh1EYVH1Z2QAorX+X4MxhPolBuncji2PTfH17Nssa9hnUqJ1YYy0uaxnRX22XMObKuRBJhPNtMTETKHbdPKVpZ9uIJbTOaEAp7ROnxkXp9R6Bj0+1JRqvnz+5yWwrwGVT9se5iapUoLW3Vd1kpnhI2Lrl9Ob7YgFD7gX778fCZyExNBiFFz5fE4+ifKG19o5Si+02Di8UE8OioMXFiyopjV9rsFXH3fJ/yEDTfSN3jOxFgoNflcAfRnK7Uus0RxHIl+9SFESkBqKKs+/9ZalsHTbZLvCF61eFIasBDtaMv5udIH6IYqVZJlyH7++r8+nsv64y+CPhiMnKh5ysEaeA/6+r2Mde2VwCd0HW0S6euq+G9yrBC6CGtUbi3KsqRJ34a1HxWxMP8SGaRR+J6Cd4mEmuKSq6suaJ6gq+wdRWnJ5OF69DFGWb14yeZ4VPvMzgwimYItEr87tMwayrHcSwF3TZc+8UWjzs59gAUs90D9InOHlZColz0RjuFbW4vqrZlpuPH1a4kqah5f68F0T7iiFEY6UfVGPtHDxGg/y97Q5DL/W6ZZdF+n4b/xpC3Qor0Q2FHEOBYt2KKV7Tw0ti5QpdyPvNQ8VLwVqwngodLO7zyEMgKaR0TKx1eeIc/vezm05bZvEkUSi+lldEakFfdOGuEDA+qwGCCEhQwSe/BV66nLcyDrCFlxYkPX/uGWQ4wA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(6512007)(52116002)(5660300002)(2616005)(508600001)(6486002)(107886003)(8936002)(6666004)(6506007)(2906002)(38100700002)(38350700002)(186003)(1076003)(26005)(83380400001)(66556008)(4326008)(316002)(66946007)(66476007)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DVo5zjG0qAS4qeUD2rK4+UeSBKc4crxFJsN8CigzU9Us6uxolbDZMy/et/Ue?=
 =?us-ascii?Q?IsmirfasbEs5R9VO3M1zmuMkFCOozb6kaIjR/wdGvW7NpM0wNHHkqU4c/ql2?=
 =?us-ascii?Q?ONVnz3iD0BV+PYJIb14Ba6LO1t02nHtGfnZU/DFuy04Nt2KQ4FoSRyYqzYFl?=
 =?us-ascii?Q?djXnUmWGs6yWW2ZYKTAZjvEnbpKEBxAbIbE3c9WsKRpLEoYBEL2svI2NkTCt?=
 =?us-ascii?Q?Prggiva+W+vi2Iblsu4ika55X1D5CgQBH2XD26goE/IfqWrsiXaVMkehFs+m?=
 =?us-ascii?Q?zCzuc7g2vU1WSGVmzu+bLtr52Zfz0n5ncCIX/2J1LHzdYOa8e8Q8ASyjvKju?=
 =?us-ascii?Q?qZe6jgctw+Jdz/CRz+Mg013R3/nuzzJMtLdv2hVix2+Guu+FQDxqBf5s592a?=
 =?us-ascii?Q?QeyYJFKO+s2YPGFu6B4s+g+2AxnooDql8S1Um4nToFbsBLHsEfrmAbNxMtOm?=
 =?us-ascii?Q?k0cCRmU4nu05lY2dKOSHbngFn1jxm9TCC9LjhSJ5+PIfdIxwbBE4rZxkNXvV?=
 =?us-ascii?Q?L8tBgG5uKWsJ9aEDGyZ/oNVGPm6s8cIpufFgUjo5wJxxPHjzV8C/gbnPuS4m?=
 =?us-ascii?Q?hcvszS7BmED+CZ/suu1PrkYt9U2lizm6NHoB+xSQXEGwciWJWwGb41OBZldM?=
 =?us-ascii?Q?gdzxiaVmDae87mplcgqz5m8bz34OnKKL3BCHWl8Fask6wCfmx8wI/G3XZU2c?=
 =?us-ascii?Q?2VOFt3x3NekZjiD0AtTVhD9/Qawrn3xdqnkL3yf18ZSvm3Pp+3Xuto1T+PqA?=
 =?us-ascii?Q?Vv/c677XfUAe8rzQbMsmn32xpBcRB2MYe9C6A9fv5Nx+iSeXYIGoD95I+uKo?=
 =?us-ascii?Q?12HjylfdA+C8hHclSkPTADLXLVpeCVaOsgfJrn+ej60Cqva7oLcS960BsTRK?=
 =?us-ascii?Q?4LohpleU+G4aCeFOvm4Q7kBK9veKuGkcZNamvl+1TbH0bAiH3cCkGUKBxvvr?=
 =?us-ascii?Q?QQMbE0zh4brgkPeVMjWhqvY4Lo5CB4fPVoSSJAUOpCvLU+N8uKZH/3/46Pha?=
 =?us-ascii?Q?Yds3Klatqm6ikWoFVcWE/Iy0QWfva9SIIN+3Kf0KCixOb+7FM0XBlwdVVNGl?=
 =?us-ascii?Q?e/WMqXKUJKCWBjGsxSRyvAgRv6o0BDxaJjSOU7emd0qFCzTBhLOYsfPufEu+?=
 =?us-ascii?Q?7+4g4foy/byM2z8fPhsXb7s7ePZXDK/nhs8WiRimOzGljJ38tVJjhTJZEmVg?=
 =?us-ascii?Q?qqFL/oD1TxwNh+A5OI+hS1rraXd/TjmOHTGokC06xAC65SuvrfBQk/VFXXAG?=
 =?us-ascii?Q?t9F4cfqSwxVyTmqrkHYDKEQFvvWEomE5W2Nn4cb1NXU4ulIhhjSQrK2ZkUOw?=
 =?us-ascii?Q?zL5a8TLd9bRhU10Q3u3YAbz9HibhIlYwFy5XR+JPN9sk0Fj8WK1Wpc4l4dGF?=
 =?us-ascii?Q?htDPV7LJOxkd3DRFArp0QoyGx+RWxcP3F3jaAzieMB4CS9C7blIB5YOK6euu?=
 =?us-ascii?Q?hM7wHgfBDSGAKANVvuCR6/zbMdC/nUzQqclNaZm643E0CXqInzFg5WFZRFvT?=
 =?us-ascii?Q?QV5zHzkafeLsXMkMt4U9qLnS8h1iq6WWS5dyj5O3tLqd0CfrfCK3iCrmzJ9V?=
 =?us-ascii?Q?uVCnFziecjN2/3ob3VS+OnoFKMVH9MNSWaab40ZiGNg2c1I+pWh7XLHYyyw9?=
 =?us-ascii?Q?SG89C4hRmKPbLuJ4/s+J4jv/TFWTjsa1BZ3yOswJCBSxzxGnOVUdQbNMsHUc?=
 =?us-ascii?Q?/6noJC9VlmACl4m4c6rh52/HBi+qwAP7bkqBuzRirlwqImfgIEDeYVexMZe6?=
 =?us-ascii?Q?HoMqMulnEj2hwNka2RQzuL/zVPO49Uk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3262731f-4fc6-4e9a-ac17-08da18f49a31
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 00:13:26.6254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8MRWkd7M9Ce3rW1cjdEK9bPBLA3ngOwQdUKhTS0kO3Wlite5bmRB/vazxWPqFEtKCEB98ZoMwpBB2sa26fEFNcKWdmYBhvo2Sdp4u7fQIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3762
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: HyR131o2hxw5XwJVcPTf7Uo3MJdMh_ta
X-Proofpoint-GUID: HyR131o2hxw5XwJVcPTf7Uo3MJdMh_ta
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a offload driver doesn't use the xmit workqueue, then when we are
doing ep_disconnect libiscsi can still inject PDUs to the driver. This
adds a check for if the connection is bound before trying to inject PDUs.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 7 ++++++-
 include/scsi/libiscsi.h | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5e7bd5a3b430..0bf8cf8585bb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -678,7 +678,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_task *task;
 	itt_t itt;
 
-	if (session->state == ISCSI_STATE_TERMINATE)
+	if (session->state == ISCSI_STATE_TERMINATE ||
+	    !test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags))
 		return NULL;
 
 	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
@@ -2214,6 +2215,8 @@ void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->frwd_lock);
+	clear_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
+
 	if (!is_active) {
 		/*
 		 * if logout timed out before userspace could even send a PDU
@@ -3318,6 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	spin_lock_bh(&session->frwd_lock);
 	if (is_leading)
 		session->leadconn = conn;
+
+	set_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
 	spin_unlock_bh(&session->frwd_lock);
 
 	/*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 84086c240228..d0a24779c52d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -56,7 +56,7 @@ enum {
 /* Connection flags */
 #define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
 #define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
-
+#define ISCSI_CONN_FLAG_BOUND		BIT(2)
 
 #define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
-- 
2.25.1

