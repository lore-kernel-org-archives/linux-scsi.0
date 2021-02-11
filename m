Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2E2C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05FE764E9C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhBKMcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:32:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42108 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhBKM2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQDZL051084;
        Thu, 11 Feb 2021 12:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=Qph0xqbs6C/cp1mrm9ukKRA8oRiGuVIL99822tH8pBE=;
 b=n7X7/ulh8qNvMMYmKCbFoGrXBeUkbowZO5r4mnMX5mjJPp/wE3Xgca+6ztfCOls9Ndnt
 Roe2OeO2caK0SUVaKz2Q7OHtoU+A9DPz4ZZSndYA2Q9vLK4wVJ7sySy7qktWvSLapNo4
 x9IrXBPtbY1Zr74PaT1oYxlY/h1DJXYSX1vvBIVUNfT7hZeFtXI7OzY5xXlTifVI9fi6
 a98c2ombalR9vFhqSebQUiRdjAgxi/RmqmDrUcLhT1LBuo6Ozu0Tq2vB7iq0bKfxhO77
 7UYMAtd/F3eB6D4Vd9NpfRTWRyv6efa+i3HM3nhPtBIJsIYCfI4xeMQkf4Y1GDcZ4+VD gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36m4upws4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP7it052222;
        Thu, 11 Feb 2021 12:27:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3030.oracle.com with ESMTP id 36j51yxty7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4IKhYJKnnhKAdEPy4HY8i16ddHNVco/aoHkgiiRGNCPVjnlNavbdIIcYMHyJ/y2SgIiD3k2m4VdDDPg0Opsw2HBDweG7+zQH0a9qYN0MvYyeWgBBIDtOyfYoyvEY2DF6GR400qOPOpdmUoga7eMG/Og4c59oV9rpJhBK/3KnVJZbkrG7XmnHkmWL4OFBPGbnjGHTEjmEGaBOI3PLwSKywuGaD8DUHy7us8Pk3HH4tNCEkNhmLso0po6FVucQQJwyH+RDGgALyRnQIzkH/Sh5Uwf0UJQKCXaNz36KO5SnIqv41uePenrhrI6b63EgTaujdXlBG1arY2qwGorof3hXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qph0xqbs6C/cp1mrm9ukKRA8oRiGuVIL99822tH8pBE=;
 b=ERzkcIrD7LCkGRoBZ7889cI+RWcp4q6Pe7R2iYdtPy/ig8XyD1FsbIW8zulI2VKn76X8EE/8IaHezxkAgxtujVYQ7DyVRTS8o/wIDdhuDEr8stVuD7jZYr9b4LAc0Bj23dKYeWgJIFnU3SityS1PHBO0bW8pB4kfzWSrDQJ+t6QX4cjweXXUZK5YTacOYjtAkaBWBYNNJFsIoQwSNn7WCK8mF9YSx2BBZr668bD9k6NdMEKuc90GlBjPDMFHVKRbhEWzk2S9dkMz2awtGRryoEUHqxAVjhc1O/zVUhuUxJ3BL30TmWAVFyt2SmxUWFFQsBwp5qxuEZjRNZ2WCCJkAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qph0xqbs6C/cp1mrm9ukKRA8oRiGuVIL99822tH8pBE=;
 b=TYBUWUlwhPJewLB9N4BduAN0dw309RzPJfU8tRe+g+xOU5t/BQgu6UPsMf4MC4AKpvrQZbPnZhejL9pEGjIjqZ+c/mmmOttJ4LseJS0CFm8jFfrUr5pO3hkQnOqJn572KQaWZ24uaJfwZfZQ1EyBcYc1nJsphy+zY9d8IkrPogs=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:47 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:46 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 07/14] qla2xxx: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:21 -0600
Message-Id: <20210211122728.31721-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c0bc79d-490c-481c-d62b-08d8ce88701d
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339A53E1C11474FB4C5DB65F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XS6QbrwR3cSwRGM2lnvkhUErWeXzvUv9nipadWNSelSIOmi448Da4MrSXash9kW0PFyNoRdcStFK6Bji9gKPuwt4JLcCaeBiVlNtmUSqhh3Omas5VeZ+UN1ImtsjRQCzQnRCgF6yAGksn4/LY+n7MbFnNc/QnmmTwltJF8nuXD0ZXpPXq3mCtDtPnD//QQUwo28mOxF5ytR8IUGGxSUofWay8y+zFUAteMwL+d7gNi/6Dng7b7VnoRaVIiafByZB9rK6Tu+5PQbaoNfFidFqM+tskuICCnPbNpeNMQGrN7WkLb1G0MTa65huupjtHDXlycTDm41ndGIvg7CBLWdrA4VZhmplTFVA7intk9uZ07TaQawC4+HmR+atUyJumYhB2hrA33kRzn0Ppop8myusfGaoO+CBzvXnLp605TAcO+VXghauQqQgGIzsHSbvZiIELqHLxDNWMDOpT2sQJnCCI37pCRbM/0zFjINJO4nVI5oF1y+zf/mxO6ZwS4DeQCarfKJkaZgRYCAmfNMz0AxP5YHTRhW0RcT2Nuy+HQ4+UtPpO7Fdyg17tWrnJCvUn63AyU6YKkuspxUbk8kU8g8E2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(54906003)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o50FEnViF0QWTdmryzfTHzD7LOw83W7Pyypek3bbY5Bv+0M1WjwBBekERXxt?=
 =?us-ascii?Q?317N3FrXhyRE1Uabamkz6GBmSH6XaSuStWcTiNbjrPjX1UOnV8ClYA6HevZO?=
 =?us-ascii?Q?sqZSLgzxSOVyAIAaGmh73q6S9i9MOb4EEt+j8yM4tiSJu9A9U8Pc7Hfzibo5?=
 =?us-ascii?Q?5qr91DCnLkIUW4CYCcPONYBMXHd4rVq1IgZVAokxOgqu82tp4K0NmtDqNu5V?=
 =?us-ascii?Q?cIRbsLLOB8R+5Q1fHzt8NVN84SeRiThv8v4UQ54dOnQwh29fhghOeaeJoTv/?=
 =?us-ascii?Q?C3otMmxg283rhoQdNNhO4V0Jk1AoOnjDfOwUhtPjy8KdOYNC887x8mtNKHy6?=
 =?us-ascii?Q?yYeICcBWn+nTEQJ18RFAffbkt32NC689AZDhsQtDjvh/Ie/HrQtEvfwzL+y+?=
 =?us-ascii?Q?YqR895sRvZNKIb+e7wNjcX9j5PybMZIXECINqFJav/jfIZSfwH9QsuA2I68H?=
 =?us-ascii?Q?R4d3Pn0pT5GwkRfTO9wtSg2JMLeF7avfXwIyHZkCyvzflVyUOQw7ADb76NeJ?=
 =?us-ascii?Q?kkom5yiGY3i6eIMPQgSnZoGRm6iRNhRQixMVrawBVdWSv3riyYS7aT1IruUS?=
 =?us-ascii?Q?AEomf4M2HIIDb4bexq4oHeVdp0dwJ/IJPhdMWrmMFh9daPAXrIq2+dxwWnRr?=
 =?us-ascii?Q?GoyuWHZS+5s8EryIilOwdVoD0S220msS6GZcSz4I6MjvElcG03zWfUgcfKYK?=
 =?us-ascii?Q?FzPCvQjOxzfJRtq6Jltx8rnKixln8tkuK1C6GN6nqnNc+XTr0E+hYiLGN8Qk?=
 =?us-ascii?Q?wfAejvZMKNSfoieMrSFCkX+Ypg9tlrtLoOCMfMaNTMvxYiAKn3xo714eZN9X?=
 =?us-ascii?Q?YIyeGxjyWHmWVgrmGDPYpdIQJ+GThkF55y4cPM5fxhXyV68VURqaYX3VuD8u?=
 =?us-ascii?Q?yWnd8LLf4XvpF8P61Qwx+8mP+n8re5UVHzSXXZe07/bYpPmtX++axku23xvX?=
 =?us-ascii?Q?8if+zUidnbizO+jOHYxh9/JhW66G+bSK9/PSj8leR3aPXwkHh5F540nrkKFM?=
 =?us-ascii?Q?T9s0X09rtXt+SMd+xvEhtY/U42h14SqJPYVGinNqaYhErJMtVe9gYc+46p6d?=
 =?us-ascii?Q?qibtck1GYFobhJ3ymyBHPgHeMr0Agxkmoj9kwFWny07ty2mvj2jZd5JoR7OH?=
 =?us-ascii?Q?YVmIaFJMBVBNeLZgtgLRVZJg8hfX0RWZeY9cRgWCVG6nfprxgMyS5RMGohpf?=
 =?us-ascii?Q?1VjvPzhdvYvpUEMXoP+smoJMqkqR9xonqlCUlbiLUhl7VZQVckMsQhN8h636?=
 =?us-ascii?Q?/CY4QOhyfk8HFwytO1DUkrEzjXGzd3hN4b6ragGN3HwH8J0exztQyC9pJ0vl?=
 =?us-ascii?Q?mxz8hYOku7bCBbk2ZxB9AE50?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0bc79d-490c-481c-d62b-08d8ce88701d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:46.7661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GqNX6oRad9akKFSWUzeBjp4WLOEVstVbgaQ4O2LK0VhHDvtvjUk9hORjj/ZSVb1zEJ1korZ8FtzY/C2OQVoUDu8wIwNuhPA4movtCaXSRp0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
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

