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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2F3C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E23F964F4C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 01:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhBCBfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 20:35:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48838 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhBCBfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 20:35:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131OwTt149843;
        Wed, 3 Feb 2021 01:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=23wu1yMWld9niuqGxoI6BMKHkdgBSWL5rhPPfv/xM+c=;
 b=Ov7YoL/crJ28FMr8htWKQqUAtm+F7RfMAIgxoefMEKSTesKvBQxKHi2OZssuhcA4Hqbg
 q6Kq9GVSF3zq3YRABTYWUPvkePS5EtaSQxHOPrjkFwMtUdK+UFmiLW3e1L5bX8/EJ6CA
 G1NykwpoC+2TU2DYzSfrWW+cfNmt0jDp46G9fKCnKI+BdUIg2i06YJ6t69RSSbMm37fF
 6oU3+hpOo168LpG2VPNl+dW7iZaKTpbAedgg9EeT4TveBbOWGI6rCjKL9Fw91jrV028J
 yOX+v8OYvaiuyeYg1z/vwgrA7vX9PyRmcuLHo9q17vps29nsB3fh0tgFJhLa1zKdJ6sk 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36cydkwm2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1131P0tC139770;
        Wed, 3 Feb 2021 01:34:15 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2054.outbound.protection.outlook.com [104.47.44.54])
        by aserp3020.oracle.com with ESMTP id 36dhc05qhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 01:34:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCV459bfm2m2BtTwi1vYbvNdvXFL/r344RI7Eq5yYOyqbe5luCBhcFlY2XOtIRAjrKCfNi5AQaj04WLOIinCDcl4GnPnT9m/NLSvipj1u0HrBFDxjXUzzwGJqHs92/dxfbxOR7BzuM7IXvILtiua0hyIdXuAJwGfiwx/amxycrIJw3gRl0b5jA5ouZL5m5+2daYmbE7mOFdgrle3BjpixGi0lHspiGzzG8nItvVEADnVDCPXJAwTJkln88PjwGCG2LrupNoMn2ahhBLwXL0Ou0tuOJanyY3ztkoqLPwOnISFqrvtCYVJ5B+XvbQYRWqjJibLyzvg4JXRh7eqFK1++g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23wu1yMWld9niuqGxoI6BMKHkdgBSWL5rhPPfv/xM+c=;
 b=H+sti1dPSiGjACZtEH5dyfZCcN0ZxodlRaz3gRrE9YIi10mu+UerNZYX0/R5weslg8Pa6B4bhrtKKxbxWX+7YSSbZcG6lE9E82/l371dwckbqIdzwSIyJ+mMwLUX81knsJ1t78rzl0k8GryA6FuEwLaEv9feYgr3bCkgWdeql/goNls6Xp/v8VKi5PLF1UfB4CoB7lQPHvqYapyDPlELVMasp6RFiVwXOwSUmpP0ftJDTa97SGnb1lVWPtiYhvY8UF+yPwNvflaTc73eFRymSsYtXmI41rM8XImVtCgWU1dlkikickghELhbBNlSh0J/VnNicecckF19XgPwUy2TuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23wu1yMWld9niuqGxoI6BMKHkdgBSWL5rhPPfv/xM+c=;
 b=jIygVhn9vcKgd16fBmeespoOdKp5zE1yh+IovUPrZ/LLDllnvR+RWyQCCcG0sChUobZriVs8NPAAB21VqSUvzstDIfavvcNc5ki6VkD7adYrOtivFLAp7jLlQUN4RtsXRyBugMkqT4/3gN5A7fwisBW5dq/sU9KW9DQSSNGXZRU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 01:34:13 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 01:34:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 8/9] qla4xxx: use iscsi_is_session_online
Date:   Tue,  2 Feb 2021 19:33:55 -0600
Message-Id: <20210203013356.11177-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203013356.11177-1-michael.christie@oracle.com>
References: <20210203013356.11177-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:610:4e::22) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 01:34:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 925f4bd5-e6f0-4f35-d82d-08d8c7e3cfcc
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5320FDB77E8C55C4BB8700A0F1B49@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rdyVn2pqqw5MTJ3oEjYXBIEdLUldwtC8K92X7VAUi6ew1SW9K91ySzWp3Pylhe4UnofnWj8sDbvK22TT/Feu4ccxfkQS02T0sNj9Y6goTOIO3Xl2QOvPd7RAjtlhj+t1lGZUiN228tU93eFF7bPTdZzTgTc7md0YeQ0uLDhMWU+IWT87Faf15J5HiXUyI2/W1lzVsZawNm58cNQMTAU1GYTqyFPiEVnuNEtfadtVnVYr60YYiNcZY7Y9981JeYJiNuXi2TdOQmJiWIZrGl1CyDNSi9PIgbmP7/G6qyHc0wEgKT5V0kM3/840KCkide8M+UHkaqRTd/zErFiA+x4/bEVeZVjbqAIXc6s4Gfp5kPrpEvjsYcJ7f9o5O4hsvmwTs6DCtiIYpsGKcVdkvxf4JLfuJcH8y2juZLTveJOcplKHe9tSRXbJaWcNykyrokCbpCQxYogGI3pz+TbVZU8QLkXRy62fOb/PVbDbpHCfYaTTI5PO0wkzwEXdPbbcpdHaj94nGLniCtKueCBHqb59WwnesG4xQvn8oWRndBb6SAFTkMDntBiJ9Mq3TxPcPjllCSgN52R6S2tgNMk87SqCdeIbWRlBfzfkgcg/OmEItQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(136003)(376002)(346002)(52116002)(316002)(6666004)(69590400007)(956004)(2616005)(2906002)(478600001)(86362001)(107886003)(4326008)(66476007)(66556008)(66946007)(36756003)(6486002)(6506007)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(1076003)(5660300002)(4744005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?54TaMRadhUAAnt+XMlvFYNfDmoIEf2Z3l549cUv7MfKtFxxFw8ZkKRUemVyB?=
 =?us-ascii?Q?GPTW4QiHlkiHIGvi3Kcw6ViP7XjUfJJp+IfJrO/eOTFdbENsrPt+/laWD56I?=
 =?us-ascii?Q?zcmZ3xQkjMPDqWfw1wd+mYHA+xWD54Z1cfUIYfPZ5x8pBLjVe6UAvi7AXIIE?=
 =?us-ascii?Q?2LayeMNic/XH6UsmeLZ7yEHC1A7BrJGbsmmNT4SueUsWiibYgFAgVatj9t54?=
 =?us-ascii?Q?YVNI6GHPs61LTCR5k3dY67X0XlNGaNOQZDrOp/JZuO3hEdfkIr3cupum7I5B?=
 =?us-ascii?Q?zFhbRA3ZJa/soTJlEVCFJFrZXpeaqHxFLBuWP3fCkA0UrUzvv0pTcdzTT80F?=
 =?us-ascii?Q?uaGKYGCbyEk43udQ5tFjMaBR0ii8lc4NJmXYRnR7kvoAvuyCIN71EkXKf2t3?=
 =?us-ascii?Q?1cY3/rn69CHUEgVNUL+i8t8tszRsuECVHvwBan2YbNcCv1exFyiILLj87tDI?=
 =?us-ascii?Q?Bxegp7F0icUmo7LwDEqPfwCbypLgLO5OzomU7CYa75QugXJFSWwiWCpJtkrt?=
 =?us-ascii?Q?emlwDYmtIceDxoeKjy55MeLZlO+YkZqkbX2G4G03SgsYPppKG4fWvmx/o4NX?=
 =?us-ascii?Q?MZ8uSs1aXKyAdZfWELSxz2ZOOnzDc0eGQc1ElTb9N+e2EDxqoCfWA+MJzOdm?=
 =?us-ascii?Q?WWWucXCeftbp9OMflDLPEs+cyH7EEvC3S7kGKjRgOOP+O6FAU9LjqUFWBoiZ?=
 =?us-ascii?Q?IJQdPAIjwRxZJc2j8nvc+J6qXeWOyS1NK5I8boAvJ/hPszS7/8YOMchgKoeq?=
 =?us-ascii?Q?jhPtE/XIaDfQM9F6cHN4yY64u2BKVtr8Kyu6GMJcFkxtbQZImdbnt7GrU15X?=
 =?us-ascii?Q?neGqQlCGdSdAYjlQD3XretaRlZYbPbMSi1lWhEQf0fb+BDJGbKbq5GqJ/HrD?=
 =?us-ascii?Q?93KKO/MmS9GGUuHbx1K0dcTEwp7us1uA5wRtt8Ly1Y0X/hOv4o5nsjHGJyF8?=
 =?us-ascii?Q?Flz2k+4mu2UewYljGy6IwCz77g4rv/RMOdlwjcFZCXqHSWWYNtd4ziqIwU2G?=
 =?us-ascii?Q?rQIioSAG17BrMgYNKOg0tGWA5V5uESqhUnw8oDtsWqGpSDNn7tmpswURcviv?=
 =?us-ascii?Q?KqirBOq8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925f4bd5-e6f0-4f35-d82d-08d8c7e3cfcc
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 01:34:13.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o24exVen8OyfhbdmGfj5a9aHLs7kTuttqxgvsapBsapBNLuHMJ4jQv4ylWMzjRNdYxjmPWAAj9ednt9rZFbR5n8BXF+7qM8TMJZbwsZad9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9883 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__qla4xxx_is_chap_active just wants to know if a session is online and
does not care about why it's not, so this has it use
iscsi_is_session_online.

This is not a bug now, but the next patch changes the behavior of
iscsi_session_chkready so this patch just prepares the driver for that
change.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a4b014e1cd8c..7bd9a4a04ad5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -841,7 +841,7 @@ static int __qla4xxx_is_chap_active(struct device *dev, void *data)
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
 
-	if (iscsi_session_chkready(cls_session))
+	if (iscsi_is_session_online(cls_session))
 		goto exit_is_chap_active;
 
 	if (ddb_entry->chap_tbl_idx == *chap_tbl_idx)
-- 
2.25.1

