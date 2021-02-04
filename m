Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A325AC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 744BA64E50
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 11:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhBDLiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 06:38:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbhBDLgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 06:36:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BZ8e0072968;
        Thu, 4 Feb 2021 11:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=J7EsSQpFvTzHYGuBhsrKHKMLJzLhhWIXETntUpwDzDc=;
 b=PjApFA6elHkZX2JO5rxe0TY9CO7eltpPRk2/sxcD88MFUeW6e5OcU/r87FImg1KNhLB7
 3cCSAF0iUW+4tA9/RIAnLA4PAvvE1BAFkh0Rc2hUQ3UOcQOxGTIa+g/MpGuStV7spJYY
 cd3nCMg7yjs3uIqJ/55cGXD63OJBFyFKG9qTkdxWH9j3LxGHOgi2OezzH7ngAnwWO6g+
 Krmr42OTbpVkhaLQvr2iTUa37HvJCzeb27FQ+bd9FXksyox6Ai1UcoRgzDqikEtqOWGK
 66Ul/24njm/JMPr85zxclXqMozMZjz/PDu2ocE8+a5t3kH+n3Rml0y5+617DpyE/mjmR uA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvr7h02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 114BYfbP134905;
        Thu, 4 Feb 2021 11:35:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 36dhd187nn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Feb 2021 11:35:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOnMnWM0llpJGpLtavQFx40FOMpVBzjsGiPI80qDJyHBo5C+bKDhkATBFnrPv/1v77S/mQ+4u6TSDpZt2J69o8Q8nJrXD+OUAsEgiPvrPckK1gb/ygvRcGFkTU5XzYOZypA6Lg1D6auayuaCKFlO4Lxwgd34if12jgaFE9oat/GELqO4AIUvdOEws/YViJepslmjmOdbNwfbz+5mxf4zDSW1fVSiqhec+Y7kwrFZm50mGYBcEYspbm7BMBEEu3r5FwayEc19cEpqSaKoMJ3TNC5fbXNoz53yVJ62+gbuoCNnFqg6qL50BSVrchJrTcrzBjeifWBdSFZ1j6Y8S7lrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7EsSQpFvTzHYGuBhsrKHKMLJzLhhWIXETntUpwDzDc=;
 b=Z+Jvdn0PA/UG055GIjk0/CDmFd8n03FJ8QBBquxTaOnhikKtDakn/DvOeGGqbgUJN+i6h5dRM0uoin7blgz2BSwqp+4lqltU6kkKNTHu821Ow7+Ehwa/MjxXo+issDKBOvp6mGvIpW9MnyEcreD4O19Quzwzd/owGE+aZYfx/JD7ml1/FnefURYYuQx0zkUT41+vQZ4jBClfImbqGfM2r9ymL2ZT6TvE8GykP/3MI62o9P7dg22ZhPfTwHiyu6swpQ7aayNzRkLM6K6GiZPMed4qkcW2Nm9RlpKMLY4bxU2Ccka0YDWPqtfRJuwinYmbQ6yPMdypnwrg82G+8nW6BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7EsSQpFvTzHYGuBhsrKHKMLJzLhhWIXETntUpwDzDc=;
 b=lnapzayk5hhhIS3/od3of7FFHlrNfHxJtCb/tsVqZOg7aWGWnMD2h6JgrNFZDrZcDKrTUqZiuGY6ZduvGGZx89tl4iYqTcVZqEjc+0ipDWCqqzG6tTJ/my/aADZ9qhmSZWtlkHdSrrO0BL6WEZ7qcxQdG1la3uv9RTu8cYefS+E=
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 4 Feb
 2021 11:35:24 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 11:35:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/11] target: pass in fabric ops to session creation
Date:   Thu,  4 Feb 2021 05:35:03 -0600
Message-Id: <20210204113513.93204-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR03CA0084.namprd03.prod.outlook.com
 (2603:10b6:610:cc::29) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:35:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4978084f-07b0-4ae2-d2d9-08d8c900f643
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB448033B0880C17AD768981C9F1B39@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3HtciQc+k7nhcUjvQNnxWMVcFX7GaAUjkMGeWvzSI/cQ9N7NWNUA10JA+QH3BXVy2D0626fMnBfL7ggp/2BKHceAx4MjLYhsj8lkVuKzExvX0KZCogJUBwQyGEUO0CzypHflvhX6coq+/BNGCuEbNjRrcL45H7oRj9YxWzZ7gbTI6n/zmEFmGsP9m2ATGlhcjG7XaKk3VGq/HKctWnomJrxg29QnrzKtZtepnA6D9TXDw/fmH4sxj2iB44koYTZ3jZmP8edHihkPfEgxh9KXaCZD0xupugqu0mXHslVtul/bHr+JxDHMKCW3vrM1fXM0dZWcfXa9lg0YWdpxyr3ftELrlbrEgUzwpMAyvW1gOTeKHgjpdj8zaxgq5W8FTlMxXDw7aNhoojNjuTId3ijd6VsRLEk0FqN+E2SpSeZsQMD0yXPA4l8IIgE/X5Rr2W1CkVkg/pVpCVMn1eiqFY9YUaRmRmURbmAPQpCkNstkdsKVuihNzC9uZyJpop+e4G9GlXmROvWRoNbs6ucNSnnVwCUo4PDIFYgeAvFYJS+DJT6OgOLQcW+MpZcTqHzSA9a5ybd8/pr7foP5iBs618nFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(52116002)(66946007)(66476007)(66556008)(26005)(6512007)(478600001)(16526019)(6486002)(8676002)(107886003)(8936002)(4326008)(186003)(2906002)(6506007)(5660300002)(6666004)(2616005)(1076003)(956004)(316002)(36756003)(86362001)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r1IbtGSXMzYbMwpW01/yJpN6vHqQXv6uBcyroXMFATs4lGJ6TUPWfagbMbgn?=
 =?us-ascii?Q?auLzbsFGuhwJuy1hKB8rhJzQ9ugmHxkOOSDYE85Eey5VCcFMbRhMoz3SqzaF?=
 =?us-ascii?Q?m/U5nYJqvHm+7QdF7j5UGgp7dky8yQ2yFdltEew6tqz5jxxl2FqOvDQ1C1va?=
 =?us-ascii?Q?KU0CYT68FfFqSN0OYXwbHlU9WQTZvoN78mve2M10JR80XiEVdFqFXh7cXSpw?=
 =?us-ascii?Q?yGEEceGcc30ufENOpCew5NQEzAozCB0XQKycH79AIvw05jaOAML6r1Zq9wKG?=
 =?us-ascii?Q?O/Lp7jf+mEhaRTkPe8N+vTUtk9ghrIjNZgNYb9v5HcixGDq7yR6jVhasDe1i?=
 =?us-ascii?Q?sk5IbLwIqpj3zIzFGWPp7Bf3udba6yLQeZRit7FnbQR1PNKACPtygsr+Zua2?=
 =?us-ascii?Q?gYOeyCOd1ihrtrpd7dKisWPpVQC+M7WgUBuFZzXeV/bp5MEguWfmOWqsF5V/?=
 =?us-ascii?Q?teBNESIXE6gLhVrA8Up76YHZvdwkfvQPzJ3uWrA+g6N+WL885MbIxOHYWcQE?=
 =?us-ascii?Q?1BUe/7R5L82s5L0yEr+rIthzalaa1eQajy+Yv/drt7FNigA09G21jXEntFJx?=
 =?us-ascii?Q?YtNrcGDwNtdVmyiCaHSBKcbUDEm6TZZjfiGgdN1dCsHVHvtOMXmtI6ggwvQL?=
 =?us-ascii?Q?U6l8b4FAwIygNMBUTgBG6g6tkv3RhulzNt1ZVvLPE7ygxbyqoFEAWIVpv+dF?=
 =?us-ascii?Q?C5GTy8Mp5ynkK4mFd7CXTrdXIFE1InsQAZMFzsQUIhWApDeNCkgtTu5i22yD?=
 =?us-ascii?Q?5CYgmfgZ8sSuPCDBp92VlcqhJ7j8WZn3Q4DJ+dL3YaoAZGKwNHHtcytdk/2R?=
 =?us-ascii?Q?ne954L4seZVArRA7/Y4kDAodEhxFqmpY442Un+CvI4Nas1rS4uwzt9tAT56p?=
 =?us-ascii?Q?bgdr6q3FpGNsRp/eOxjFejEY9Wg/k6VGBH2hYX0G9U9RrQbH8jmj/MiLpbZf?=
 =?us-ascii?Q?fIljHtFKPJ2EcUNtjdX3x1hj0Xbw1/ngRGkdR0DdPrN8VRdVhfQg+XnS6CGD?=
 =?us-ascii?Q?SrAchkPmi+dqzQ6Hqsv6oyiiHTt/L5Kcr2gr4NU+G14DgIE1GvphbyY5yss/?=
 =?us-ascii?Q?ANP8AWU+ZDnDx5UMT8LEnE2S+ThPG0TjLfSwA/H9Xul2dkPRB+Pf5pvJB3EU?=
 =?us-ascii?Q?4R1EK9BhfaqSA10nP0oz5JghCdVbrCEEen/upphp7Zrh28Twy9ugJdq6nt3c?=
 =?us-ascii?Q?6l9A8Yx41WEM6GYnroz0XRmrZkINpk0knJu1rLPIZoqqlOm8ceKs2OM7Hhdu?=
 =?us-ascii?Q?ZUjQ3Qcr4PbyBO4JMAK73QeEOfSZJarS6Mt+EQabzqhipyjt61d2O7LZ8Nwv?=
 =?us-ascii?Q?aQsblEDPePrgyDweHmEIh60V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4978084f-07b0-4ae2-d2d9-08d8c900f643
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:35:24.4616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hi59y60ORK06jnkDOO8xcncjYPWOHjUQbVlSahgenbMu8mFcvGqmDWTSFnv9kl807GqxHJ8LUT7psnSXPStHjjLbG/0LKte9AOjKhzrKAP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch will create a session level submission work queue if
the drivers fabric ops implements a new callout. This patch just
converts the target code to take the new fabric ops arg so we can
check if the callout is implemented and then call it in other functions
when we have only the se_session available to us.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_login.c |  2 +-
 drivers/target/target_core_transport.c    | 24 ++++++++++++++++-------
 drivers/target/target_core_xcopy.c        |  2 +-
 include/target/target_core_base.h         |  1 +
 include/target/target_core_fabric.h       |  6 ++++--
 5 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 1a9c50401bdb..ddf0c3b13671 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -317,7 +317,7 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_id;
 	}
 
-	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
+	sess->se_sess = transport_alloc_session(&iscsi_ops, TARGET_PROT_NORMAL);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 93ea17cbad79..7c5d37bac561 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -220,11 +220,13 @@ static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
 
 /**
  * transport_init_session - initialize a session object
+ * @tfo: target core fabric ops
  * @se_sess: Session object pointer.
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-int transport_init_session(struct se_session *se_sess)
+int transport_init_session(const struct target_core_fabric_ops *tfo,
+			   struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
@@ -232,6 +234,7 @@ int transport_init_session(struct se_session *se_sess)
 	init_waitqueue_head(&se_sess->cmd_count_wq);
 	init_completion(&se_sess->stop_done);
 	atomic_set(&se_sess->stopped, 0);
+	se_sess->tfo = tfo;
 	return percpu_ref_init(&se_sess->cmd_count,
 			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
 }
@@ -252,9 +255,12 @@ void transport_uninit_session(struct se_session *se_sess)
 
 /**
  * transport_alloc_session - allocate a session object and initialize it
+ * @tfo: target core fabric ops
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
  */
-struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
+struct se_session *
+transport_alloc_session(const struct target_core_fabric_ops *tfo,
+			enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
 	int ret;
@@ -265,7 +271,8 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
+
+	ret = transport_init_session(tfo, se_sess);
 	if (ret < 0) {
 		kmem_cache_free(se_sess_cache, se_sess);
 		return ERR_PTR(ret);
@@ -311,13 +318,15 @@ EXPORT_SYMBOL(transport_alloc_session_tags);
 
 /**
  * transport_init_session_tags - allocate a session and target driver private data
+ * @tfo: target core fabric ops
  * @tag_num:  Maximum number of in-flight commands between initiator and target.
  * @tag_size: Size in bytes of the private data a target driver associates with
  *	      each command.
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
  */
 static struct se_session *
-transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
+transport_init_session_tags(const struct target_core_fabric_ops *tfo,
+			    unsigned int tag_num, unsigned int tag_size,
 			    enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
@@ -334,7 +343,7 @@ transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
 		return ERR_PTR(-EINVAL);
 	}
 
-	se_sess = transport_alloc_session(sup_prot_ops);
+	se_sess = transport_alloc_session(tfo, sup_prot_ops);
 	if (IS_ERR(se_sess))
 		return se_sess;
 
@@ -442,9 +451,10 @@ target_setup_session(struct se_portal_group *tpg,
 	 * of I/O descriptor tags, go ahead and perform that setup now..
 	 */
 	if (tag_num != 0)
-		sess = transport_init_session_tags(tag_num, tag_size, prot_op);
+		sess = transport_init_session_tags(tpg->se_tpg_tfo, tag_num,
+						   tag_size, prot_op);
 	else
-		sess = transport_alloc_session(prot_op);
+		sess = transport_alloc_session(tpg->se_tpg_tfo, prot_op);
 
 	if (IS_ERR(sess))
 		return sess;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 44e15d7fb2f0..a7553712da25 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -472,7 +472,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	ret = transport_init_session(&xcopy_pt_sess);
+	ret = transport_init_session(&xcopy_pt_tfo, &xcopy_pt_sess);
 	if (ret < 0)
 		goto destroy_wq;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 54dcc0eb25fa..50103a22b0e2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -628,6 +628,7 @@ struct se_session {
 	struct completion	stop_done;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	const struct target_core_fabric_ops *tfo;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d60a3eb7517a..cdf610838ba5 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -132,8 +132,10 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-int transport_init_session(struct se_session *se_sess);
-struct se_session *transport_alloc_session(enum target_prot_op);
+int transport_init_session(const struct target_core_fabric_ops *tfo,
+			   struct se_session *se_sess);
+struct se_session *transport_alloc_session(const struct target_core_fabric_ops *tfo,
+					   enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
 void	__transport_register_session(struct se_portal_group *,
-- 
2.25.1

