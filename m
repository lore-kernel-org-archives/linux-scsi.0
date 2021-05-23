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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2080C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83703611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhEWR7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38938 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhEWR7o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHw405156608;
        Sun, 23 May 2021 17:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Z7ZbLnM+B++0OKzyUlOpgfFUs5xglmUncRUWYRecOfs=;
 b=JP+Gmz3atzSS3GcgXcoIOQ8pER0k76m23C8pu/RbgPXsWyFbTynHAJglwXU3tduP+NAm
 NST7sf+UjO43PwIitex53eY1ndv6pOnbbie039To9eAEp8IYuu9R9P9+9NiI9H3b6v4O
 F0cvCkW1n15UZ8/RJiw99d/LLulbjcVxYf20vLNefMw7qh/cehYlB2QA5n1ytXgAgN1h
 yMw2gtbQv9WuQWihFnJ8wyh9viObqs3Qs0HCFBOLT1uS+L5X8UlJZTyoyu4Ghe5yXFBc
 3Sroazm8GWiu42dX0ON8zzGleCC/YkWVBVxpfRgY3e8ygTQfSHw0jP42VAYOWIEvTAa3 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38pswn9fqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuctw161854;
        Sun, 23 May 2021 17:58:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 38pss3qbn6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQaMsscgzOGH/lxC4Qrl0WQCxGLCEchgwacDHhXfSRRn/vW2n9A+HahGn7ScBESAwKbkKMPqPAcqChgvD/poldDyBpJS6y+sJXg0X8gNGkmmVIHl2k2AAjQc7riBwEnho6VHkzHC2p7Y+7EwsGJxbkD3+vE83cBFDW7BZzkIDB/XU+3BCZUKvbVgWgDsTEpch2/zA1p0FJDHfYbUS95mQXwXeeV3mcwMF+fQ3ZzoPWiYnNVV+kMJNwSTahxDxtmbXxp2SZyLhZx6+06e5qjl/zaXgZ584dZlfJYMyWXvQ7u1F12wNM0d56v8PtFOIiDpJxL3piDOZnHcD8Dofc6+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7ZbLnM+B++0OKzyUlOpgfFUs5xglmUncRUWYRecOfs=;
 b=DEj9a8GxZpZ1gbVt06vUv7ItdcuCpV27scWcsWXyJLi4ih74yToZmnwKChV+o6KiE3WW2muehSUvUz1ppv/ZyL7FAFSfshLKqLWWlpvRAGduJB+lo14qWy7uSMHLBo64XaB+Y4T76KDoce/FiThSo97gDrdXyvlGVNeY4W0WCuU2BK/+V5Ef3lP7X/AKi4sUBedE/GqaDUJD2jqpRNqhKvoiDYOtlhLIjfBSpx5XSGCgSag6cW0a9IAp9eZTgqhyXRGuPcR5QlJEK0go2k4/zkuG3/ANT6/IEtnCZnlSkRqTxV1PwQTHEVBUhV9cb7IXH2DvmAa1VlDz5Y4K1VgqmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7ZbLnM+B++0OKzyUlOpgfFUs5xglmUncRUWYRecOfs=;
 b=PERAYv9r5UwDSKN1yZu8pJn5SbV+Jqyt97sUWi49hXYjC7cdHZ4hVmf/sdb+sRrZR9Ai9olsxNShizHw5+ISTiZAk4WlqzopDZC2tlJGftobgUQxRBHrbkmP4ItrVkZfZr+JzUaZCVnlBtYMw8X0eGViyxwFKHvrLdz6IhG5cg4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/28] scsi: iscsi: Move pool freeing
Date:   Sun, 23 May 2021 12:57:29 -0500
Message-Id: <20210523175739.360324-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7437c61c-fbfe-4328-3a02-08d91e1452a8
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40041EC4794C78810AEA56ABF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GL9Cwr4qCut8gupkBOYWy7NPHq3oKS/UFzbkeY0LuqYTWHIIfDYpcA+VOtcm/FXrv+deYx0NvmGnelgGTSWWSXiBpZWINUsSM0AutfQpg4JWKuoBaGoyCtW20+zHfR5uumQIlRPvmawCSJQ2ZD5S2zC3uhAbdtpCdMnkv1TPWW0U8wc+YsPo7jO5IRfcoOvk+oM6yRgA4VOM3mGtky7I0liBumLbVOIFJd03kx4e5jmmnBiQRuVb/ITFNt9sXw/+Zn3AayTLWMz5FUXj6IzYd1d7Aa0EbrkIwT/sFYjfSuPYFCYKxg5o2Ka41iCqmxr1LOduiO3O+DhK80rV5bbvcMEbrKvS98Et3jEN2smIrwOPn7slLmBxYWVZJqBHx94yy53su99+7+571BciLXlA3J3YvP/wyz7DXS56vqaOodsSIUNVGZ9kmfyIJ20pQYrBJOdu9EBIMUNAl3O7GJbcI8mDLQrGNZLh1ZVgGF9L7z29uJrfUyz4Cj/ExKfmAuk3FYB7q87SUBaoR2LXn35rlM1Oca4fhmsj5aO3Nd6/716X1bw+jP6mCzODbzPTzRz/blp/jVcMOtmfmQZSCyo0b3J4HWDaEeUj026C7GRh+S+WBlNV1Zd5TC26pAlNG/Qh9n4IGtCtHnhiC+WI/HTOjYdL6y7JlpGGodwXPr8xAsmBKcDNFlp/+uVVcsUG/r1Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(4744005)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cejpfBKzMLvEJ1yhf33uXdiJ0htwkxWb8/3ELDo7AUhVyRTmVHdME42JnC1D?=
 =?us-ascii?Q?vb5CuMf5/92eKf/W6rk+eo2fMLfOEzPMJ4nsWVjW/8e3uxS2iHBKM2w2heuH?=
 =?us-ascii?Q?reBDMSfr8h2YsccRUJITRftiqQiTjFhXBD5hWamuxWWLK+42SwFNcNtP+TVH?=
 =?us-ascii?Q?NrN6FHl7A40hSBm0EbtvnJBGjQfemgf7W3zKv6uNJYM6xCMhkd+WOQn2H5V5?=
 =?us-ascii?Q?044yviT+GnzhlvUiQYTvDxDQb+gMlCKbxcicdsWoNDMPdNUlh57XMzurp91A?=
 =?us-ascii?Q?rmOGKpRDIhRzG89VGyLncjSzYnXFhFzuIAUuYGzkGWm69VK1Sob/AjW0FyWd?=
 =?us-ascii?Q?Qa0QfT6CVm2Tq/U72sGDi83TZTh8NQCKi3C/0RxM/4ZI0p8+nQ39xnAc6D46?=
 =?us-ascii?Q?M6xdhiymZA+Ag0deX2LxG9J7vYbwY8fz6Xl6fiyVOss2OhNTyJBf2hY9ify3?=
 =?us-ascii?Q?b6lJh8qD3njsOpP507Rk1Kqx6YO0fTtHKJsv1QMkt3kfl22RO9m+SKJJwCV/?=
 =?us-ascii?Q?X6E3vh9b5i2SGX3s81wJdb4u1IXgM2c/Nib4aioKZ+wXyu+JnlFQ2y0BuGHX?=
 =?us-ascii?Q?BeUSMNxM1BBRqTxLE9KGemgEXpsnsCNDyXpSs67pPfrKsuKwYQDkOfnw19QV?=
 =?us-ascii?Q?CRSKDucM8/To0kKWYKG+tnqSB2V5B6JRHIUnOyZFvoJ1UxwFHYX21zy5Z9Ci?=
 =?us-ascii?Q?CzcATM9fWl0vH3uOE47b/tQxZvKiWNxEOCtT2WtqqoRagQTCO3t7yuMdBQRY?=
 =?us-ascii?Q?kFhArg/fwPuLztgYyVXKg6AZY3Pss0vcXnEfSY5R8IpELw6gPj41MYSn5MXJ?=
 =?us-ascii?Q?wNk43iivlpVBx9POFfKaGMjg0DK998HQ7QHdFaX9pt0krpevct+pqzVO5NQV?=
 =?us-ascii?Q?yWNYcGXfXdeJlQ/f/7M+lcYpXvaH+a+FZEDLWEuH1PrIyrW/8IOx2KIZsid6?=
 =?us-ascii?Q?/gObeXgzWrxE/7OE7VyjatMoex/Yx7eJqslCyxGjSUUxIr7oSJON4CyCf12N?=
 =?us-ascii?Q?Pc/SCErOKWJX4cMTWtqB0QaMJvY9E/w1Ntgagj5nePUFjYCA+iXLcaTxrVh/?=
 =?us-ascii?Q?7mdB4Ei5t1toRr9DqD7pOZ3hvbI2bm8/EvHCjClt060tStF0x+nyLO3wJF58?=
 =?us-ascii?Q?d0D/AR2xRAoH/vVhUNcgURFewjIhFbg96RkjifOZ8i3TZa8DjnKN1IbwsutD?=
 =?us-ascii?Q?5gLwCP0EcNIkqnGn+WMtjJvQa0eiu6GNwX4I94a4mMCErU9WdTMFXOYhDtr0?=
 =?us-ascii?Q?H2JaTAJOP2Uyj8Iuyso8I77qmw9hPrl0DrPG6JLdZp9hRC+HS7qJUTOqYz8g?=
 =?us-ascii?Q?E1nBizS/wP362v2i5bjOTIJs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7437c61c-fbfe-4328-3a02-08d91e1452a8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:08.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: puovSZhj1EkkJpMOo94F4i2E6Xwc9yjAZjxnOe2qKAFzjDTHODG3WbwePzc3VcU472tOydPJlJ53j1fautASdkYFELe3QdwoxaALwJamvy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-GUID: E135UtxDJkoaliYbOfqdswxaflVhsxva
X-Proofpoint-ORIG-GUID: E135UtxDJkoaliYbOfqdswxaflVhsxva
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This doesn't fix any bugs, but it makes more sense to free the pool after
we have removed the session. At that time we know nothing is touching any
of the session fields, because all devices have been removed and scans are
stopped.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9247f70d2daa..baf2a6838c90 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3001,10 +3001,9 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct module *owner = cls_session->transport->owner;
 	struct Scsi_Host *shost = session->host;
 
-	iscsi_pool_free(&session->cmdpool);
-
 	iscsi_remove_session(cls_session);
 
+	iscsi_pool_free(&session->cmdpool);
 	kfree(session->password);
 	kfree(session->password_in);
 	kfree(session->username);
-- 
2.25.1

