Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3ADC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACAFD61152
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhDXWHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbhDXWHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6VBT124468;
        Sat, 24 Apr 2021 22:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=7ET05EV6JQSKO/pVD84JdRXW/MzV5wyzCxG8rjKN84o=;
 b=paubUKhXKIc0UyeSKT04yGOyAWqo05d46vCi8Ezj567wLgzy5rchy7qooHeojoMb6QGX
 eadL43EI3DD1DJUV/HOUdgotiOF1gpjvFVpMQiwxpchqkG4kjr/zitXzbI4biK2347Qw
 UJXAo0fZHYuTUUEk9kWOzu6SoaCg3kqchwpHDbx9v+Nqu8F094JR2UN/9qOSCG0sUgHc
 19I+XZsMhUx91sMMlu+xCV024IFzCmDmqyDZp1Gmiiyvm2npLMGMBhWERvunDc5Qpf2y
 siIQOuLaYb0v4YWLOaer5iwwXKreQqoxSef+n+l0kUfYXAo9HNz4vqBWzLDXaKEI6naI wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 384b9n0shs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6B7x045523;
        Sat, 24 Apr 2021 22:06:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 384anj7uv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ec1LoDL/CuuADrqgBxDREHD3s2B6+gtDiZr9F13byxbuCwsu7vewLddMOUQTx8VdGhFqQKbgGB30dva5h6sjyf7+h2rM1hvskPeiqq12nzYYqWwF3BkCaZDfBgXjcHcimiC0EPypi4ETxMI6I7y+zg0D3iP72O18MiXEd2w30+Raf/usHV2h2COeyG6Sxcp7juuKC6JCHMbae//I0/NqHFIZb1gCmzhHTsvPweRLel8RWXCjktkDzMGVOttbI2UsUOEqyP7MBn1d5VQWswGA0kalwKqNGHR/3DOPzfCY4QSI8N4+0r2fn1FltHhYERfqMswjqmE+fx5V3zsiFrSAyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ET05EV6JQSKO/pVD84JdRXW/MzV5wyzCxG8rjKN84o=;
 b=C59W+x5vYaBAoW9oG+cBz+/HWhjCpnHcgxiPQdM5AdMwpXHyiLYhZeNoetISo4a0ERw9+izYlsTbacFwI86My3xxV28m0MPvPTOMG6NPIIEpj2Z6zh8CN3CfTTyvb5wHQJjr46uhVGz7idvuStoGzSToNM6Zkumu3Nha8oN5vPW8VeIOEDU2SYSVN+Pg3tiqRkq4QGdJhjpboXr4CThE5HDrmbF9nWn2chsMScvLd8BAuIFEK5KIAOTbRYQeLBt3nXXAYoub5CtW8rIf4QM/cpjct4OnZPZOUQf2aoPIiVey0/Vzi9ZUUqgGJSUEc0WefqaBxq/RUpBA4PBXgAxqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ET05EV6JQSKO/pVD84JdRXW/MzV5wyzCxG8rjKN84o=;
 b=mSN8XFzomY2ZB7/45EN0dztI7OjoOt7Zq0VRT0kTAmz+gxCX5XIU4V110dboe+JgIiaK5r8UZhWoDlN5PVJ7pNlMvbV9bgmctCte3e724Z4I5mpCxzUeWWRNr836R+TjRCsHePniTPVlnsw7O6DLyvx3TLzC6JfLqsT+FkDpgWg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:28 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 14/17] scsi: qedi: fix cleanup session block/unblock use
Date:   Sat, 24 Apr 2021 17:06:00 -0500
Message-Id: <20210424220603.123703-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faec8b64-c257-4f9a-5eb0-08d9076d355a
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB331722BF988B5EFBDCF1B90CF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNg50RUHwSYFJQ3kCke87G5NRfaXxGWPjlXFWldl6hZhjGEPMXEMbUJ+ZGwRu1j1/a3Q/6+BBmc89Z0sl0Cx9hDWgbeZHjvJOdjpXQUch22tffkNigGlfnKiBrvwAjvuRgTvTNUtd5eNg4qPaZVBPJBQPWRrQXvp7+3h1Bbmw0ttKfIQolI1lBpFNeXxQbPZb7aBDZ/IdkwdJmuFB2TV2LhKH4Uhm+pOynUXXr6XKSFhCeewaxJli86Xtx+gMyEbNIAFoGXnlPVjwTdrcAUViQKBfLZAY7aojb9mroLJPhE896iJSTdBTJ15pW62Y4m9qMRfF04eToBQPbdh/+kz0Pi4F9qju6ZGLGiUTbhAQm2j2zeX2sS2WlIrZZ564/3CMn7+xi03guHbZ+YE/BllWVJzB1WG++SrMNN1W7qD35LPEXYFwXKlaK95hNcMn1wkp+MhefaJs4exJ7Sy41nIWyLRNJ7KPK7qckkwwUd2WtdBis1SOJ5nGRdWUFbuJKvd6eA/liNLW9owabLb+oArq9QmeMoBmztcQwTbneIh4ob17jW2Pdkx7WmDlE3IMO+qjQC+l7Mltz3nxi5x0HVWlvkemgv7Vjzp8JnXXOg3FyMlfDW6P6fIY3k/Wr0Mus4C3i4VdLOWfsf75QR9oH505QXZV/tC4owELiBJLXVgchBaRN2vbLaiObitJNb1D4PR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rn5PfZd3Z0Wz4C8ktcLx2tOMuMVivqxXC2pzNo8qwxBIV3i7MuPh9UimLXve?=
 =?us-ascii?Q?5ggQnmb7Z2+cdArJL45ibgvCJuDNfdb0XjQjEPPujl/BAOrnaC5ZrTlzIB2h?=
 =?us-ascii?Q?tck8195Vtuvj3PVrw8bxrhorfANxhiTDaSUXzQQ1ueLW8qV6K8U9ad+jAano?=
 =?us-ascii?Q?96LM9px6i1VHfBWCnArKYZs7rWQEkvH5l2YFbq0hpwBiYo8IAa5jfoIvnQ3j?=
 =?us-ascii?Q?W0oihCq56K3i0YzlhAPPrusaw4aEIQ4lI4hkLSpAVMJfK22yBKNaj6NV808L?=
 =?us-ascii?Q?ykIZ1Voi1SeLvl+IOYQyPe35rgl1vv7ptAbbcVzdf62/61vVZ72QHxuxBO7t?=
 =?us-ascii?Q?ihyrVMSMvB6G8aF3WymrTFe6Snfr++N1hZ54AR01nDPYfZM29AgYvOiz+Odl?=
 =?us-ascii?Q?N5UgXwPpUJl1Dk2jTVtbudsOBraFgrYKDtjOlzUyIECXMewQW2Q6HnzmSPiE?=
 =?us-ascii?Q?oq8+jtT6/kkFINtGRruXVkdiCv8QxgDhXCHYoZOP4p4WY0tDo3K3xM6Q/DaC?=
 =?us-ascii?Q?jt2Hu9nkgpG0fkihwzTwUXht1hzEcNVB80bIqaa5loEyfUH4XftVF99zIrtw?=
 =?us-ascii?Q?vw02+CIFwvh3vIZZUimv89SL4BwgN8sKTIOANMfxKitC7OoOBKWc/diHLBN4?=
 =?us-ascii?Q?ulaT1WNhgXhb6AkdBmn05mOIuV9oY7LbomxgjPZqHKfcpcVA3mAIfV4sNHb6?=
 =?us-ascii?Q?El/k9GlHQOmxhwsGix0bg97m4AsFjw2tUdcTSL3Nk6CaOf2P0TOnQiDuiLGh?=
 =?us-ascii?Q?Pr/u0wI21aXjFNzzL3o2L2JPQ0cKSoIlvt8COG0EMVl6IEcHWmahqjXCT7Gp?=
 =?us-ascii?Q?72IvLyZLfdSgINc1tmINXXEzBtf3f/OmrYn3xRDpusZGXvWZJCxjC8i/37eM?=
 =?us-ascii?Q?ldHQoE1k17kOPEkODNcfzqms2pjG6p/TVywRCdG38ex9l0W1MVSsBscRy3qo?=
 =?us-ascii?Q?Hwb7pHhuq5ZtE8o9fV4BuwowSNXi2zK/s3Ps/u1dLqrGrfknO5XQOmFS3zwD?=
 =?us-ascii?Q?7tKI+cZtDC7g5XLEYA3HEu4opDS3C2bOn9+I79CZGCBt+gEWxQRk+3yirqg+?=
 =?us-ascii?Q?t2OqV0agfJLHoqWaIfwFHOZuEh5RDyHWPsgkGQx4aQpjSOAZmNbAQOXSct6G?=
 =?us-ascii?Q?4iIkfVkUbbD7QSIsZ5i6K3owto/OCW6axl9Zte7S4VPzXusYxOXMKQc81z/7?=
 =?us-ascii?Q?9s8yNhe99SOOiNOqR5/7+Qqz2HHEq7RmDPyGsUVRwThl6RDNTaPhkvqXxQ+Y?=
 =?us-ascii?Q?X76IQ5+BZuodqDHZq891BBUXdQk/KXBeNBCJ0Xxq/kIBgIE6sJc+6kNDQr1R?=
 =?us-ascii?Q?A/AnddSeYJpq53TGUgoSiw6l?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faec8b64-c257-4f9a-5eb0-08d9076d355a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:27.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLCwFLJ4TLADxXIFUfjidVXNkcQ/NcuBQhszJHzPB8Y/zu3n8c8mGDugF5UeTyIc3so/86AVqyU1TiWCAp/zR324vPYHnMwBhsv3h+NLoI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: dZbhIG1IKeyQBg-LOxVYbH4dnY3VuuA2
X-Proofpoint-GUID: dZbhIG1IKeyQBg-LOxVYbH4dnY3VuuA2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for cmd cleanup
because the functions can change the session state from under libiscsi.
This adds a new a driver level bit so it can block all IO the host while
it drains the card.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi.h       |  1 +
 drivers/scsi/qedi/qedi_iscsi.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index c342defc3f52..ce199a7a16b8 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -284,6 +284,7 @@ struct qedi_ctx {
 #define QEDI_IN_RECOVERY	5
 #define QEDI_IN_OFFLINE		6
 #define QEDI_IN_SHUTDOWN	7
+#define QEDI_BLOCK_IO		8
 
 	u8 mac[ETH_ALEN];
 	u32 src_ip[4];
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 0061866614b4..6e4f7c427af1 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -330,12 +330,22 @@ qedi_conn_create(struct iscsi_cls_session *cls_session, uint32_t cid)
 
 void qedi_mark_device_missing(struct iscsi_cls_session *cls_session)
 {
-	iscsi_block_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	set_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 void qedi_mark_device_available(struct iscsi_cls_session *cls_session)
 {
-	iscsi_unblock_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
+	struct qedi_conn *qedi_conn = session->leadconn->dd_data;
+
+	spin_lock_bh(&session->frwd_lock);
+	clear_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
+	spin_unlock_bh(&session->frwd_lock);
 }
 
 static int qedi_bind_conn_to_iscsi_cid(struct qedi_ctx *qedi,
@@ -789,6 +799,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
 		return -ENODEV;
 
+	if (test_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags))
+		return -EACCES;
+
 	cmd->state = 0;
 	cmd->task = NULL;
 	cmd->use_slowpath = false;
-- 
2.25.1

