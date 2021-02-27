Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735E8C4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A24E64E99
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Feb 2021 17:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhB0RHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Feb 2021 12:07:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46664 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhB0RCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Feb 2021 12:02:08 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGx2pm030979;
        Sat, 27 Feb 2021 17:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=kl/EjnB9ZwBzqtChF9uf2wvKcrv+VSurCwCXDzlG5UY=;
 b=x+TqU33WLOe0QpsT49RZpUqGC09KgbO9BKeJtamcT9qpwRiUi/gP2kRB8d9I4CyvjZ3U
 tcm9frkkf/oIvTLJslH8TOyOwXXvJLyy6W/WhdAo/JmgTohrBY8Uztxie3kYe2k2zT+c
 1j6RpQ5HQYWXweKX2WZRYBtvxK33ibYkEQGywrvKEM7EbkW5yQfdJbeuYQntcCGmFMzw
 jRZ2qBBw0vq4wnByodFE7xcrZUaA0yBnTT1pWcGECqlMAkN4HoYtgOODvGKpirzMkasN
 GkaWYqiOk+CqZq2M17Wrh2Nj6lqUvj8/LNU3ajqokSHPpPop72DkX7ykKW0r8jsbnRCu uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36ybkb0v3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11RGslmd115709;
        Sat, 27 Feb 2021 17:00:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 36yc4a7jaw-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 17:00:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRB6mmr0x2W3S7wKd01KAzXVNbnZdo+M7qzzomieBOcfIS9VNGcJxsWPdEwUBrzh6bGMkXLdvBHSzCW6lsV8xxCbnH5iwphUTa3a2ZSb2wITFKUQvFVcSwdzHQ29sTaO048sBO5/ikEjHVbInghF4UK0pCYElZJAirbv8AxNs2dG38CEB/Hhf3iKAV4nrUnl3rfujPsgwrdbQoOOCEA0h8IjfVUkwdENZQxW/+X16Z+1bwPYv4LJfx9xAkRz1iI32g8VewQMVE8dmvAFyqUwuy3S4ihvAwgbHqhvuFnnS9zrXa05GnU8yTrRc4qXaoDX+pm76VohmN3bZEL0gy6Lrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl/EjnB9ZwBzqtChF9uf2wvKcrv+VSurCwCXDzlG5UY=;
 b=j2+St+vVIE45+2M7DGA4N9vyOatXGKrS5CVDo9yoZEUV69Uf8Hvs3s+ddx2lcu8h+VN/PGnHG6X3pwgRVZukkeLHIDKa7a4jLM8ee318OPqNqCz0Chkf5FJRUr/SvslQGeFgEM7Q7TPg56S5Kw0+EEoZ7dYominjl6uzoqR/5iKBAzvGc744lkBhNNPUMszJqSEefJCLbS5Tq0bsCeNVVHgB57ecMp70esj8bveptlvBGzMYzwsHdbijCjaqOUMP0bLE6SYu/xpm14WH1xhtnJW+irHo1T7Eo0HB71a18hTe5QNzBjj8CZKSr3XDRXaU+bWXZ0/upaHg2sBrPNEeVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl/EjnB9ZwBzqtChF9uf2wvKcrv+VSurCwCXDzlG5UY=;
 b=jOna4fW/RDEoDoIqvFjyBVDvbPG0Tk4du4NEDpTv7ZM0rboXGP8mKKCQxzwjJ44M6G7kU7VgCHYRK8dxgmSK2iAmCo+ITr7denro2A8e7yrlhgAcnHT7KjHeLGDh8aFusnBNqPPeAhPv7DV4SrFYyCJkhpwXo76X4C9xIwStuRs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3499.namprd10.prod.outlook.com (2603:10b6:5:178::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.22; Sat, 27 Feb
 2021 17:00:22 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Sat, 27 Feb 2021
 17:00:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 07/25] qla2xxx: Convert to new submission API
Date:   Sat, 27 Feb 2021 10:59:48 -0600
Message-Id: <20210227170006.5077-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210227170006.5077-1-michael.christie@oracle.com>
References: <20210227170006.5077-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.13 via Frontend Transport; Sat, 27 Feb 2021 17:00:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73076f53-e98c-4e9e-ec24-08d8db412b20
X-MS-TrafficTypeDiagnostic: DM6PR10MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3499718E4C30AF61B391B013F19C9@DM6PR10MB3499.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMhJ6l4n4jsrI2YVu7qBR9yM1GUgWUsPlHgb54grFyussNzHZv2nzZpzSm5mWsHCwCK9D8/F8BTUJw/2M8OTVy/qV7SQ8bau6aSAIle23NHWSs0S4JCkhWXxWCg6L1D+hKkMmT5iLF8Hp07ajIWQaPYhN4xaFvJoil9bv0AqGWQToR5bBvNferiEkpnpZZqV5YYDD39kn/QxOaqzSORq4xy+oCSG5yNnXdZALVCDwIhfXeGrZjZ3XpY/K5mKS+k9x1DXGRvR2lkc0vrY4uZjvtN5ljPKT5gxaPuxbnNhmfCeICwycWwXs4GpLqA83hrNojpS5rSmd9Mqq7NCK90PDajbCDkXUMirnpytm4NWFvVbqVbdvQ9XLB342Ellz4nx7dJvx6hcWOdo5HpjYLMJWEChNFRoBxVt3yfblEG2SyEGlE4pqrzAqvm6AiJZxWBMcO6bKsHL29CjER5lmNuvKdH8phmweec3YzA/5MZjMGystZT+dxoJEPoBv6jQUu2xoUrQ35ajIr/blnPa4++vWpRwHalpTs1N/NWyt/1aRTZEI+JTrNdSUyV1su+uKXIUku8F2HZkGNm3hCU6zQQuIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(6666004)(956004)(36756003)(316002)(6512007)(86362001)(69590400012)(6506007)(1076003)(8936002)(83380400001)(2616005)(478600001)(2906002)(4326008)(186003)(16526019)(66556008)(5660300002)(66946007)(6486002)(66476007)(54906003)(8676002)(107886003)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fev2Lw/9pfwS0aQ2yoRl8LP7ovY5GbQUKo1PoGzYQxc+0s8UysuRULqOQ219?=
 =?us-ascii?Q?mPs9XlazeI6Pm/MV5fen1i51ScbVmcsn+0WujRSAIABACX7Zh3riycb0PsyF?=
 =?us-ascii?Q?7aoTUq2rAayIV061FfFQSmvt5ZJ40sh0gqzf5AKk8TPIjS11Js5d6Hhqv4eL?=
 =?us-ascii?Q?Xh6w2vRPQrTOdPU+0m940hewYRNqsXUIG0uyLc1OSrKmXYCvmpBshvS1biA9?=
 =?us-ascii?Q?cC68hMLVCfQy7StEuIDPk0JH0evT+NxuNkn8z5gsYcqybAmH5ErMfMytB326?=
 =?us-ascii?Q?hJKjLpXq7Ph1ohJmsDUddsqkBnm33TMf47spYdguUWBwwGRbL1aww5tlMseu?=
 =?us-ascii?Q?aUUBM1qCgkUa6360m082cFLgYuMrNfUEhjlWTaiVlgsFIrJYSTb3tMJNSrmA?=
 =?us-ascii?Q?ag8YyzmURLa1pEe+ZvC183OCJMCABaZhjVJTa1aP4kaOo8XBheB+sh94Qs+D?=
 =?us-ascii?Q?ghoX8/YSOq3uE2DagjxdQjt5H9023KN0nSfDnr7j2dHaX6AQMNaRjQ/zPktZ?=
 =?us-ascii?Q?ydGYK3XfRvNMHuDNl0nSelc1pVJw29QV+3/IE7G/7Uj2B67eBG/C8hS+Wd57?=
 =?us-ascii?Q?nrla4aZjlY3WAGesgxlNo07G6uLbRCmHs/7TAYTPuay4DbFCv5t3OpBF7zXs?=
 =?us-ascii?Q?049IybsCaG8z52dYZx7E4fT1SZMmdBjoG6s6ZBsLgpb2nARoYfrVlw/8rVz+?=
 =?us-ascii?Q?Qx0FSh1TzfGHRM6t6nW8x9tztjXAC5jsrJTXIp5Wh4wjAef1mVW+MEPw2e5A?=
 =?us-ascii?Q?rNYUZbCnIKBPdisRwQUFq3YpN17EC3TDGdViPeDCnV+/hQ2BAu6IYHEsSLCa?=
 =?us-ascii?Q?fSNhzLm+rs7LKSxgq4vHLbdIdiFbAvbfH2QQHoI6p5Xi5YDG4bCBoDlHhqWK?=
 =?us-ascii?Q?UMxHhSyc835y//WMZ9WE7LTNDDPxaqTSwHDb+0D8BG7CMd7qt6s13k4Fwn/l?=
 =?us-ascii?Q?PzYgwnLlk4VUtCbKV6EllBT35I4PiZfMkX5dFKrKLh+YCRvwgDbc3ZfkClTI?=
 =?us-ascii?Q?g8YM2wYNmVpWzz6wrBZXeNj6NHZNXgAMgflgf1V0ybqdqZ15ql+e2jT7o+JV?=
 =?us-ascii?Q?9OL+3paqFEKXwS2kqqdfNrchsw2zefNaSDJSHFa0X04IxOLz38IBB9cZovJH?=
 =?us-ascii?Q?I5YD4BkL3U3Cdg1okd5mcB1yTiacOstW9NCCYCLGhRnm4PShDIX0wCms6v0x?=
 =?us-ascii?Q?rPvP5uRuPAw52/ueePnf3z20GJdIIUW8X4hTlwK6ym9dY1A8n08W+LX7HD0T?=
 =?us-ascii?Q?6CTAx76rIVJT3wW+ht1mJSk6SCfJQqOiD/27YDRqxflSf/gnrKJhhqWEGqwy?=
 =?us-ascii?Q?MO55CLAOve3crTPtvg8pW7sf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73076f53-e98c-4e9e-ec24-08d8db412b20
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 17:00:21.7949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBmaYzsfbqx0CetZTRaVM5B8QLJAIFgZbtbV/MlRc2DjMNJswz7weCLZcZKKmCECfExa2iuR4NThvLDiPYwjaxf8dbTByrnFbt2AWN7tOGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3499
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9908 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270146
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session.

tcm_qla2xxx uses target_stop_session to sync session shutdown with lio
core, so we use target_init_cmd/target_submit_prep/target_submit, because
target_init_cmd will detect the target_stop_session call and return
an error.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b55fc768a2a7..56394d901791 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -451,7 +451,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
-	int target_flags = TARGET_SCF_ACK_KREF;
+	int rc, target_flags = TARGET_SCF_ACK_KREF;
 	unsigned long flags;
 
 	if (bidi)
@@ -486,9 +486,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
 	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
 
-	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
-				 cmd->unpacked_lun, data_length, fcp_task_attr,
-				 data_dir, target_flags);
+	rc = target_init_cmd(se_cmd, se_sess, &cmd->sense_buffer[0],
+			     cmd->unpacked_lun, data_length, fcp_task_attr,
+			     data_dir, target_flags);
+	if (rc)
+		return rc;
+
+	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
+		return 0;
+
+	target_submit(se_cmd);
+	return 0;
 }
 
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
-- 
2.25.1

