Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7666CC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E05B61249
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhDXWTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:19:00 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51946 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbhDXWS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMIBZt067995;
        Sat, 24 Apr 2021 22:18:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=r7lGCJ9gQ3/dwuXbOcD8imlS9kd14qZ2OmO7vMUWvBw=;
 b=KfaOJ4hbNHnlDV2Vho2lOJhvIJH3+9zEQ8xRCtrmbkXHtvsWWuMo1+nsWflzMlM1+eRP
 uH1jxoMIOXJCGa5TOGpz3b6XYCzWP9bJ6AGY/EbBcES+UKPG9s6287QucEryEEJ/BGUD
 +Z5gFZp1+bIUgJhlvpRYiygvjkWZq8l2Ln1+DwwI93hR9SEZop2fc6aujZfelJKEDBRf
 X4CUwjp+sr9dZ9rqyWICqLztqQDYQJ23YrakFtnoGw/uwO/3UZAjstQELZn2i/vaEfWB
 2UKe/uOgvXiCg3iyH9UTwJX8tuMMgHdTCJTB5pUW8VsH3UAHsDnzoIZs3gW0bUwPKSyW eA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3848ubrvj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPiB148236;
        Sat, 24 Apr 2021 22:18:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csBsWWhocQUY3PV6wS3n2/1pY1ADc7O52wF14yb64slEvbfNHUxdBWt2/dz95geqJKzpk0dq9JWzHMEJVSK6MPe1oLUmVezQDH6O8yJcdWUE2V97D2t3QPr1BgRnUCBLTd+Mf0oCPys3J2fLhYtoQfOl5M1j5oOqlN4dafgcubQRC94nDlpEQ6RyCzDXf59Tt/wnvLBufI6WfAaFXpiAm6S2xdkIWzflCO7Lt5msc7p+MP3Z4tPSd7WyM88FS1gLMrWNTzU1OE381FvhGl1mXbhwSHYILJNST7/yNyKEYjY8ZbupqpAyLiOgclskTFJG9ALpS1Jbgp3eFSQHB4DYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7lGCJ9gQ3/dwuXbOcD8imlS9kd14qZ2OmO7vMUWvBw=;
 b=Jm/FBuQIPmvJxXfO/LJRilOV1Z7jL+QHkBCxyIF3S79XHG492T7r+FoCZtoqXBwHmwZHQ3Qg7/cEi9qnS4s5E0jdkXPO098MH83M7CjXajeupwJgo6cVApXZjc9rJw/quxYQfkS75kp+qNwSRD5FhXKLSvt58zAmgNDZPp1fVPTE70Aqa53Mi9sJAQ1Q5Nk+6Nm/iNLX7XXb7LS6hMfMGEQ0dl81OA/E8d46nrpfsWdMyGpZeAG4F28ei/e9qR9+nAlI1uxM92gcWyzWu2HNtXvAH/JmgjfmC8iroxcxTkH13z9riYWFNH49KMzYkZPF7n+WJJJhLo6v+EYyhlGfgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7lGCJ9gQ3/dwuXbOcD8imlS9kd14qZ2OmO7vMUWvBw=;
 b=ZtcR2k1O4aBHjB7P+pFrk6tgUbkeHx+tCQcsVvDTz2WDtqhKquHz+xg7DzWPQhR++oAV3o+3OTSrdm37mWoZvwLzvHji6moj5JJ7slHXTL251pCu9DHsMgaosAfXXe/ClIRFilR24hCV316W15myCRS/iaRd1lxu7/WeEOCMfyk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:08 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 5/6] scsi: iscsi_tcp: set no linger
Date:   Sat, 24 Apr 2021 17:17:54 -0500
Message-Id: <20210424221755.124438-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424221755.124438-1-michael.christie@oracle.com>
References: <20210424221755.124438-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be44218d-064b-4fc9-58db-08d9076ed6a7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2885D71AC631AE7249747ABFF1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dLz08wwhhGkwn3V5wIMLGnLTJ9fXD63Mlb3yP2g4kI98MXphbHjIzYov/VfvWVfPNmZgE/87BbHCMLPIlIXJNgclpeDno/FIheLFSpn++1CGoWns+fXHtw5pVMD/ZVGxnyGXcTGp6QV/gNNo0LzGZ2Zrg6WWHDPT9+l3sSW7rGri2iC+xQASBBwXnqtfZvulj68xZEt3YM+ApQzLKKGlnmqy2q+eXc2rjge5ah9BQ0dYung5XALGE7/vqQ0YEH94rOpUP6/OdxcuPoxfXf3TmPhX/dGbVuWUuBrI/uFiqIBWKj46j/BdsAlYD1ZLpLSbWWUu9y35RO1W5fm36s12QqJnNWP3ZUOlxJgNUMLQGdm2vY5jczKCt/qPRWGOcjisBBUeyk5je2Ldkwg87YnbmoKYABUBP9FF00jTea0SBh+7VP697IODiayQ32Oo3BO90kkdfzOqrFiO+7pBpiquk8hvAgXUlTc81V1UXbNU8Xdda/1FhaKjg8vVACe6fOBW84YZcnMkPaFJzPjjCEnnJyqqtiBPwSpX7nG9MY51I0Z8mXFhODhm+dQXZpO/K5LWuJ1o7UkMuRGLV0RK7w5OsZrrAZRe10B/8Uy+31ygSiPq3QPc/owQoDNFkLy1Yigxg8iczJCiVH4f87IUUWtImjocEXPLbZyUftdRRsyIzawnxIzv1oMP2Wo7vgdfiKTg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(6666004)(4326008)(6506007)(478600001)(6512007)(107886003)(2616005)(186003)(316002)(36756003)(52116002)(26005)(86362001)(2906002)(1076003)(956004)(8936002)(8676002)(16526019)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?x3v92Zo8uAPmpzB0jOqmJLlEFH7MK2n36X8NFpjPgNuySSgeoncNEvl8epYd?=
 =?us-ascii?Q?LahiAYNzIDB8DvqzrB3Z4sS1zv4ub3l24KTvymmxHtGilpTnbNgj9rS0lfSw?=
 =?us-ascii?Q?riqGHuvON7rPiyHFpdmALAUXz0Ui0HTye7Rz7UOlilY6GXhHYW/7CKqWYFqq?=
 =?us-ascii?Q?E6BgL2vVpK+UWafEn6aoGYp/FE9eSPROmOcdAWXu9Mi5T02i/EqA2V9SAxdB?=
 =?us-ascii?Q?u4rx6r3n3M1JKqJiG4yGmthj+oHCjHaqYkvn4xgPFZ0UJGB3mbBlmy5mPc6y?=
 =?us-ascii?Q?aI8BWBhWbO6cmPBA3A4QfCAh0k1zQcXZaP5eyrzzETultS4gPHr1P9/qYv5d?=
 =?us-ascii?Q?HQTS51aFH+YpIs8hCCnA9BcQqHng3jolaNHluSu8eZCSiVQ4pOVwU1J6Zt3h?=
 =?us-ascii?Q?EDJ+pNw7x2tXerR1PDFRNUyI2ss5SP4YfYOm3LFJ8tpFbJT+vSOO/kCReEj6?=
 =?us-ascii?Q?X89F+JJArUs/JPjqCI7SqmvsQfHiaaWDUG//eMwwVODoTPmWy3QIQFtuly+X?=
 =?us-ascii?Q?kF2V4mkyFU4F7QAHNS6L8/OsGx2XnOfqW4OXwyiRoVnDZVTSttHlr92HCR9L?=
 =?us-ascii?Q?ZlKO+x/y1sKtaZbUDjsTeBVvj3lMTN1ywEHM9FPB8EGc3wq72lXlZMLwrb3W?=
 =?us-ascii?Q?4Z789H94cxBZHeieVWWWrpA0STO+/9fTgAt3KBYsYMi34bf3qonYJrkd01/x?=
 =?us-ascii?Q?7H//l7aZK7S9beWS+n0T5uZOwTvcduP1dopvxP4ETWTajaY93jVhA5UNsnfE?=
 =?us-ascii?Q?7zJsih4840AJG52StbM2e/RuuwPDnHgWsGI0ITdsA108TFXDziuhczWs1iRW?=
 =?us-ascii?Q?67muxnESEv/U+itT9lk9LeFpOiHG/cEFr6YzwMZu8u26eZTgIQp6x/pikhpD?=
 =?us-ascii?Q?PJqzP+RvkMMuQ74ezQzxh0tB/bWs3ckW8ZhfnulJLBNpZnpkM1YSKRwe00XK?=
 =?us-ascii?Q?sDnKLWU5L/xfUpbKA8tEbuYpGsflpC7+JQq37RSndaS9lKZ0tcnocNJrHz+0?=
 =?us-ascii?Q?ft4zBc/WzNiFHs4WIwPdAvZ2alSWcXmNf3nNR7/paGs352jUFx2oIXM8UAyz?=
 =?us-ascii?Q?V7sMsdd0d3BjXcRsLO1NE81PqcbPpJuJzBwJKVmKANRXKJhFAsmDO+6knL/E?=
 =?us-ascii?Q?xkS/MR8N4kceR0BhHW3vD4HRM7gnkjX7ft1E8BLrUt3oU7C+JlljHaozmSCB?=
 =?us-ascii?Q?MCKjGs07MU8/PVJnLtLl+lULecUFm51Uv3vHx1yT7EsV8mgUUjZmXMTf4VsH?=
 =?us-ascii?Q?TCg/2PZDP5bar++ClUW/dLHq273FhJf2+PQZe8UDec2IaFTFEtcr6aIe439/?=
 =?us-ascii?Q?F2N1xbNYnZe5wygYqHKUiKxQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be44218d-064b-4fc9-58db-08d9076ed6a7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:08.1132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7/6H+Z0+LYRLA+eo4vwflt+s+jW/zaufhfrzVKnTpmQwu6P36xX5/y3SQnCsj2rQkWf2qjnSUt3aacUqh2GRX0YRqTMPtkj15crQr993RIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-GUID: -SV2iR1cCmtYIsyJ3xz3v-zUDWRW3Oyb
X-Proofpoint-ORIG-GUID: -SV2iR1cCmtYIsyJ3xz3v-zUDWRW3Oyb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240169
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Userspace (open-iscsi based tools at least) sets no linger on the socket
to prevent stale data from being sent. However, with the in kernel cleanup
if userspace is not up the sockfd_put will release the socket without
having set that sockopt.

iscsid sets that opt at socket close time, but it seems ok to set this at
setup time in the kernel for all tools. And, if we are only doing the in
kernel cleanup initially because iscsid is down that sockopt gets used.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dd33ce0e3737..553e95ad6197 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -689,6 +689,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sk->sk_sndtimeo = 15 * HZ; /* FIXME: make it configurable */
 	sk->sk_allocation = GFP_ATOMIC;
 	sk_set_memalloc(sk);
+	sock_no_linger(sk);
 
 	iscsi_sw_tcp_conn_set_callbacks(conn);
 	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
-- 
2.25.1

