Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2406C4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA81611C5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 04:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhHFEAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 00:00:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50514 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhHFEAu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 00:00:50 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1763uLlH012215;
        Fri, 6 Aug 2021 04:00:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=S+9lNb+zqnvUq1Ow16XZvYG/4MPRZPXvOBkNHWeCBzM=;
 b=lRF1SsIGWmdReuHqh1mOnb2JuAxhhssZxHZR513fAGoOtvr3KEmBowdgl3jNK+iDsggx
 Jwh/7jKV84yL+cqvsiUo7dU9rTRcPAgO6wr1iP0PiKlL7nwgCMJxdN+jenS+MPlsXCXt
 eNen+YeEgR+Ae5llXAws8ewHkPt8x9m9gWCDFOoTn4EkbnXefa7K4xHPjpnZv90geiZw
 wJ7P9+Az2N5siwpRPZgIJ5/HJhK2XojDmHAbLWBjxJeDxvqnEneo8ltHAwo3WPEnBtGU
 yjpZWKz+0o1zAuAeVRRviVzdAki3Bv97Q5ZxNO65x/H/JjD5cUrUS2XLYUEzwFj4ZOUC BA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=S+9lNb+zqnvUq1Ow16XZvYG/4MPRZPXvOBkNHWeCBzM=;
 b=HaZeCPtpdiEbNlyTNr3spkkqGtKohQLloCuxgF5FAHVCSqhEieaz/A5msuMLCZxw3nK7
 eLhiy3Hz5ORAAP2I/Pq8Xklp9lq8YvJqXWODY5is+EAIvE5Ekp977KX2/8mTJ9hgkWYs
 5tTtuMFTFW/p8XQVyiqzKh1ZQxrO5RMlT4HYp9WyeyUDLsoRAfGs5soQXXvs9ukgZI5P
 8Dr6I7W7rV65qTwERm8iIycVjYdxp1BjXYz/bTx4QqoxChZfYU0+Lp0HV06+cPl7gxkn
 yZ8kKVnwhUVGl4pHF98kgUIo/GCRyLOGfs3G8h+rpPTsoov7Vp+BbX/TgGr1giu4qOy1 Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843pay3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1763tZHH085580;
        Fri, 6 Aug 2021 04:00:32 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3a5ga1g8hs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 04:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/VIry2ZAHz57B6HsldKqkGSVNeeSlDBENz8kiA1A/+a+ghHGBU0RyQYoYmNM02GXSSg/G2NxPLs/E90z1+QL6oZ+wDoKdLEwPXYg7cmr7UQCMCsNqKSE+rKLy4/3AHKJhti7K5V3E89D9l1MCgAcqxlqFTXjlZVxkxvzUE4Gk6/xMo9k4mFMWYq9WFdWisdPBLnGEqx3qKF3z5tEY8WuqWI7lbkn3Yioy2drecFx+qf2bN7W4f8AS9bkfsV7u/IsOb0ZikBljTVGhyVXenZsUYUBMxDZ8d0eyr5n9EsRHW8G6o5Tqk70XM/GFs3YbzdIw3RX7tmicSoLWLbOhpYyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+9lNb+zqnvUq1Ow16XZvYG/4MPRZPXvOBkNHWeCBzM=;
 b=HXWF6b+ewHBDGICMvdPV+MTXmTZoVbZyeSZbiTytfy0U15+TEizpzc5Gr8adbsnK+VAmZRmLj2scCI4eGYgj5ljH8uAACwTNFtsugz7L/Rm21VJTR+Lh0wpiSg7jU45OvlSpg3modlGXjMfSli5fjbNILAmQOgm1L2EM22SnM9YKtRRae0mHoi9GzqnVsfo8B9x153FZFV97bJFxUFO//MQ3zSMqBAeZRE4cmsg403UGmM0oltC7W4rnIFmhGKKDcRO1iqA9tDcsnuvibWll4xMXGpm/iV75C72SqRDoUZGCd0z1UBezRZQxsFu/qcP6x6zh2hqKIpJQkZTyJMvXzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+9lNb+zqnvUq1Ow16XZvYG/4MPRZPXvOBkNHWeCBzM=;
 b=vZhsFrTy2aF+FdlFsMAsUWZRi+NA4yFdT7vlpwKHsJjfWgjqrp9WszBWLfFAnt7uUTmjbAPROy/iDKe01s8hUPTIGXEKgjq1khxinavXa2ZMZo+lp2oMWKKhokRs7l0+AIdHysuKvcRmIBcsqINBzWusjx/pSOu17c6BFu4Dxwg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 04:00:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 04:00:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/5] scsi: core: Add helper to return number of logical blocks in a request
Date:   Fri,  6 Aug 2021 00:00:19 -0400
Message-Id: <20210806040023.5355-2-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806040023.5355-1-martin.petersen@oracle.com>
References: <20210806040023.5355-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 04:00:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b85d974-0f30-43cd-4534-08d9588ebbcc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55157CC55AE8104FB78D6B988EF39@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:561;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XjjZ3x1Yb0xP6OeK6RTPOEEbFA6yJ/UBoqn4RAt31PaI1TyvJs2EE1IEL4qgt2IRJWuIxfOH538UhTTLnGA8mwzqO/dGkhrkU+4+NZsLP4vdTlaTP2yapxJpUy7klLWLBSaLyVuptu89wDTBTtU75bgAyGCdWBW9yzoBgMgDIoaql8As9Pyr+cH1LG+rmUAelYzLSj/XtUjpqQ+Jb8MqaX4MPpfyE8WSIxz/jUbmsaudOL7VeIKYnW8fa/kcSaTl2LX360UHbPYdCHR0A/BhMVNIfG7aHE03Va2IGjbmM56f7QJoEYQssH3H+/XQ535KoyeWz9p+ZjTO7x5CNoHa5sW8X/jXY7cf1CsueTApWxvQIPC3wzFPVv5oJmvHqz0kJvMeHgxoydC2dnqwtPuaDfI9gsnCCqHXgC0xMJlZmYFcRzvqmGPRHQ55Jl3RnuIdqBwXhGrybeZ9Hnwm4AWmoMnJBxSvTe/NfzFZn0F9KpEqkTLAJwhFrJZBOgZ4SlvjT0hIK27u2Rf0KayC54+Bx1fSTj6UM80SZLOjShJ78iX79spTfmksKX2A0CZquJJzY443t8fyg6XMyB/PBmMLBu/XstjN+EEEaC4oRRpqGv7QlEl/LTchbsXA9XcADHeWUHfImF6RpPKX36lb4QYJC9lJ+inmawdtRi4YSe24hl5hbM7xqjM0hxzkjTSx05a7M073dZNCxICiVTedfhtLzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(1076003)(8936002)(66946007)(8676002)(186003)(6916009)(4326008)(66476007)(66556008)(26005)(6666004)(83380400001)(38100700002)(508600001)(956004)(316002)(2616005)(36756003)(38350700002)(2906002)(4744005)(54906003)(7696005)(6486002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hZwQmzTkcCHxf7bgERBRVgM/XB8coN7bXf89FVa1odti6WVmpqK0HJqKkLFF?=
 =?us-ascii?Q?bLT4vW2Ru4vB1rGFbOPP0uipBwCMev4PnkS6Oc+4v2fX7D/M78D1sKgN+Lx/?=
 =?us-ascii?Q?DDxnyHq4iKCqTyKRvB85xYCaKR6OyYBYSZJqt3hyJFiRE7yvIBlccxyr7Wub?=
 =?us-ascii?Q?jCzyGakC8ZsZTNEwidIdNM71BNg6toE3fdz3EYUNW0VpuHjD67BzxHk6xZ9J?=
 =?us-ascii?Q?NkW75wa1tCN45AO9cp1kQfA+qhzNo1ekUGMHUPSUPPd4hm0u4NFShp0BBtfG?=
 =?us-ascii?Q?deg8xlh3RNKwK0wVyO9b3w55wAaG5Mri7EKSO3fe/Qd5iFjNq8w2tGiR8vvp?=
 =?us-ascii?Q?Zed8MQv8+jlNW3qEhX1rDGsFJLJA9Alo6HeC6N2ktRLoPOyh/JEhg0PsCSsF?=
 =?us-ascii?Q?EJvAUaDZ0gDea6FJxcK+DpZ8drnQx0EKgQIn6C8C3bRlZpMZffYv+pSArR5r?=
 =?us-ascii?Q?vl+SHZE+r5rlFV+J/r6c6vwg/wb9ROl0rFTQVu3vjKpszV9ZJF0VhXSoHQic?=
 =?us-ascii?Q?jFOjZ+RyaDYZygbL8v0+tLv5+E61AMbi8fNud9LMgVl2sPsL7lUDE1i3Hhgw?=
 =?us-ascii?Q?0IhUevF6u+PdoL725QcZZ++XK8kx0NvXcFxNfy+t7kl0bB0BePAHYVlMsklR?=
 =?us-ascii?Q?WoRJfsW2Ts99qtVvTAojqq+ZEctsjptbnw/o9PwfP+w2M6i/VNekiXHM4rxq?=
 =?us-ascii?Q?6M83UdNm9fe6mNXL4EhG3onGH9EWZX5gcZNh8b1PhCj8j3Lf3jyagU452AVD?=
 =?us-ascii?Q?YYKJf+w+TAWdmqZYEPTWeLQM7XKx7ODqCGRZD5N/HoR5PE00mrv0UegZmSsq?=
 =?us-ascii?Q?ClnGRYagFd4ghohFR+Tw1XHjkBVBRSHtS9x4hyKNd93BKcIpcB2hNIIHINrX?=
 =?us-ascii?Q?Katp8sfy6KZirm6Eb6aP0GG/ziNhdxtL7O044wvIEh7i1o8DSR3kDRWgbVm/?=
 =?us-ascii?Q?DyDW8Tq4rx89BS0NRotZVymiSQEMxBBtf37ngqJ9vuL3T9WUw2NZjarmXKiJ?=
 =?us-ascii?Q?Ame1E6+BWa8hLjb/b60gTmjDqMpzp5WaDFtWbDZkvYGNgO9KIajgvjbnpa5Q?=
 =?us-ascii?Q?y188ro1gVS4X5hUhq2SJrz7IgqX+gdXbfgS2xn8T+KfrIaztlHAyfbfKihLH?=
 =?us-ascii?Q?yx0mm6QWgpKM8Ok9kbk2tlljGWwDjoKIKb1vZPLVYgNFf6q3MIdwwlhzG3mp?=
 =?us-ascii?Q?/rbcGT8SjqVTxLbI+1XSrEXH/JR1Gaf29ShS276yT0nZyZY4Zouo6xh/HCKo?=
 =?us-ascii?Q?AobQwD+nWyjMV8JwmjSuoqalRhDDNAuxGD9N6N3J49vL7juIrKpeNSLU33VZ?=
 =?us-ascii?Q?DNgVxXzXabnCuEkiC8q1Bkxd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b85d974-0f30-43cd-4534-08d9588ebbcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 04:00:31.3642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+YiaxNjzy9MzZ4f+zLHr0igTDV2BQEeGFCa2X2r/VmPbtfXTWK2hMjTI8tiOlJzx5wV4+eyRYJMtYNdi0zm9li/OSG7LiiYVrXcAzspHlg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060024
X-Proofpoint-ORIG-GUID: NTBT-hcBbhCcliAHIxjn5-Qi7xHv62_D
X-Proofpoint-GUID: NTBT-hcBbhCcliAHIxjn5-Qi7xHv62_D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_cmnd.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 90da9617d28a..804b2b33da4a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -232,6 +232,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request) >> shift;
 }
 
+static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
+{
+	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+
+	return blk_rq_bytes(scmd->request) >> shift;
+}
+
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
-- 
2.32.0

