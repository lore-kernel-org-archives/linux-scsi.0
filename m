Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFB3C47081
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652AF61261
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhEWR7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:42 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46604 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhEWR7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHw3nv164864;
        Sun, 23 May 2021 17:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=xMpTmM3381qfdSX76N5uBYe1Aop/CTayGWiKG83zR0A=;
 b=dmXmbVSh9UOqI9k5rhQw1gcV1qatL2xSQQaDTrHpMLEJ/i3jYaJDo3Kyvrwjl+lZ/CnI
 y5Rdlwi6m+2YkeERAuxTR1Or+zY7fcjgAh54xHvB6BWwty9FR780X/XVffmjdt0puqJY
 wtFZEalMJufEK7/aDfn6Vn8xz5bK3M7cjoGwi7bHj2IJABWkG0sMJa3QRo46qmDfa/5U
 9VLRTRFsvu0akWlUb+b9chPuRmpBCq0HDhE5q64JI69MiC+4VSPSR4SOV4BPNk7Ng5oQ
 qssMH0UAkI4mFKYhmzPANu4DBuP8xMfLrb8esfvdbHZx3r924ngh3foA/v0g3HSFEf/v Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfc9jae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHucts161854;
        Sun, 23 May 2021 17:58:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 38pss3qbg1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ifIVbeZsWkUlNby85AVmLBZ7vultiBts98D1tt9MBYvFoqd5WHHyBL1YjNuuK3+KWO9RHnYm3igjpelwPDtaWrykeegXmYPEWBhS4QQ9asryT+bL62nH5h8mp0mF0nN5PBcgqapU02RIOQy8zADu0CfIRqavmo2rPuIuM/dH27OrkOv2B0A03Bw8QJCelW5HXydOTeR7B34djEG4YhyntclFTaTzXFkEJg63YHTxxabTkyOIdjZbEwjaQC8QyNHm5DIzbxE8zdMRyrXmxS7aKsUmVEsDdOYqcJLqgm0qB1rKuyod2M1o6SGrfdXEeUFaWFcQLEfCqSBlP3U2kgVo9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMpTmM3381qfdSX76N5uBYe1Aop/CTayGWiKG83zR0A=;
 b=YU6L7/iaNeszsRNg+lBS8RT5/qJuWvIQvRsbZF8dzdMXzlaJBhDYx3cx1BZGu7rNBDSA15sNBUqFjAzUvtAzDfGn8tEJwJMo/nrfNB9+dWtPx/F9M6R2cFOO9v6D7lC9MOtGEFeSFSnh8Hg1Mb7SIQcuEtUoDfobldUPPS+urT9bcKweQ3DtCF6Yro1VIlSyUUkgQ+1eSP8H+/sxbIGYHV1nCTsL5ErrhlcRMIggTuzsGYN1UZVr3Bt92Dc3785sbhq6XwoEofW1KG9lhxtbNExWvK4y073kD19Wp3oPCuBukbwlpHUUhhg4AZfPJCn28qIdwTsbB4HL209+KCs8vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMpTmM3381qfdSX76N5uBYe1Aop/CTayGWiKG83zR0A=;
 b=MoGNvQzb03LmvP27WRmH+CFFaRaFYvvlP9iG4r2C4VDGDJ3a/iy1AgqvYpyCYu7XxYlNmzA+1lYRlKxeaS/G1jVV1UFRHQq/UohyNkKgafrTuyveKZ5JfWz5lvQlylY+O9RatGoGcA2R1Jeh5JW/DZzx9jujEr+2m+sUrc6nDi4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:01 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/28] scsi: iscsi: Have abort handler get ref to conn
Date:   Sun, 23 May 2021 12:57:22 -0500
Message-Id: <20210523175739.360324-12-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:58:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e2474b8-8599-4825-62ed-08d91e144e16
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40042194A98A15CD4C43F32EF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4y12b7LMKGzSjK8G4/3ykwd1E+fjMiibXJwHcSgbtrJfQ8XOoVOoGRrbhHm+rnHiAXR1CFsCQk686452oU7na1Vkfts24X4NiK57hCXtK1K8lklbsDhincOgOaUh9pmS+Mcyeb2lvFldiqltq3AUpHl5gnJ+35sqDX5KTHDFVq7SjQhaVZxYHkSQ0SmXsVv2o/+ol7Ca8lgn+AFpxfHCRKMAsFHCSg2I6jULBFdKNnEeaC1nSUZClyA1w6WXKD+7e3cSBfrXphhEb6P6LVI2lora2gZPQfhg2a/yXn8pa2veRXDqwuU9+nBj3QdzbD8o5ij+4Lg4o2PS0cL5iskMb48AAAfY8K72hlmv//gvyigVkxLlR+/r6fNFBSo4K4GjHtMv13XNwucgwObc5tWONTw0vTxUkLPhwHDkTdJxOjCctU0Z5sUCoVb8yAf/SPFanoMvu0cgxzoWcPufxk9zeP1EUK0jcTVTr0P/YUviAQh6HkW2I0UEYoKvoOoKjEJ8+8w+ZEKX7pm3fDo884wnj7V49YvmHUYnaw0kqTilPMLtV9lkNHQleS9P2WFUXsYkIZpHd3aNY2oJj+oFvItSpbuoksvmKDYaf+H5vtQaZDvuo+0lM+ur8E9zS7urAAu2mBk9s+0zIMB259niWMEzd3UnXitEa3gFKuEuwPA71M8AKKjCq9njuEjTodWxYSYq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1ml+ohsvpUiGWZ8dNkGgmqQVS2HMcSWC5udwO389dSVJ1VusMTbyoplQywFy?=
 =?us-ascii?Q?gLKHpYZtMj1V8K/ipuCTjOYyS60vJnI/R1M9JAF5fcx+XpccrftMzg/TCk+U?=
 =?us-ascii?Q?qBaShVo7QAPf+PuDFhSiKpwn+ikhUm4Luh+cBtNUYZZJV+qqxK/RI54dGja8?=
 =?us-ascii?Q?NGSfJ4Ib1REy0qftAy3rvJkC8XcthBRw7lmTrBACbL61lVlvR19/j7gMtXyE?=
 =?us-ascii?Q?K98sWO4oKaag7ipXqv3KxbgmqSbAcIL6BCarXJ2Hw8W0Kbr1IQKfjheQK3RM?=
 =?us-ascii?Q?W5Twwu9GUMhoBImqp66kq65iNqoulbFgQ+vVEWwP/VIZhEN1DXVAPWp7SEiD?=
 =?us-ascii?Q?rT220G8OWgMQ4k/AXCb8o91jp7KbGAoVScClL3V4X4GcUGjI5LOsIqD9LpDw?=
 =?us-ascii?Q?s/GP/+wJnjaYGvjp9Q2ncTxN8tAnYQX3VZ2w4FLoUlJv8aPNzWmTbxdTYEsT?=
 =?us-ascii?Q?OWHBjwvHYj7jiEfCMkXxaPB+TNzsy/kVzO4+32TLEmzpRJ1DqTEvrfOGsW99?=
 =?us-ascii?Q?imyh+TiA2WFkEbpmR+ivbP6TA7bB6+JXgafgRy/XgVyUBf4Gviu7dzLsvsN9?=
 =?us-ascii?Q?hHCzz6oICQ3OldqktpQn3xcGoSosLTD9Rc0D+I0OHnuQ5d21iJo8M09eo4FS?=
 =?us-ascii?Q?MOLDnONHsQYDxlEvrFfjGmJQJ0wg2F0KFPSVf5eWjgA363zCBBwUf9NKX2U+?=
 =?us-ascii?Q?queC2dQfZalkW41/4kkN1P7kAiJRONbA9VK5cgdaq+LXdQd2DVKPC0OKxVma?=
 =?us-ascii?Q?chwvvLUuuDX1wmP7+u5sf2q8zWP8S32n+B1MQ0kvS/qpW9UGd6bDhpDQ4uDq?=
 =?us-ascii?Q?7ZOtHpFphZ9PiLAiQYPEgLZUeqL9XaNpPDJ7zfsLAPQGf0bZH3s8+ftt7kqt?=
 =?us-ascii?Q?/4DuyFwK3t+NiVhR6KqtNKTPCTOmYInoGXL40VEucwaILAfLuhn+mz2nvSqL?=
 =?us-ascii?Q?HNQxvYoE7NYf6uJtUf4H6UqhNz8XkRUBMqv1BelgSDAxyrurtYd9N/mY6T/i?=
 =?us-ascii?Q?Utdi34cRajIUrdpJxa/Trby8TLeEjuczc5kmTPAqd9tZ0tE57kq3ZFTfKZuL?=
 =?us-ascii?Q?T17bc8PkaeAn5SDPiYkLI93or/nSAWk5GaU18d63bDDbg9EmkCdyPPyNLADd?=
 =?us-ascii?Q?XcY6rBaA1ZsiHkRJsPLSBGy4zEXg8mSIlzgXt/i4Hj4yrZek9pR9Woexx0/Q?=
 =?us-ascii?Q?vNVZmy5kiRJjnFy8Y6D03qYiZNxfpFS53DWU2wzy3k8XouzS3KrEDNYgndUw?=
 =?us-ascii?Q?bmBEUuYKkydgRdtT8WbyE7nAZiCMG+8GY9d7Nacqh12dqs6Gm5eZkit7Wxo8?=
 =?us-ascii?Q?VN7+rI0I07otHKFcPVT5Z3xz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2474b8-8599-4825-62ed-08d91e144e16
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:58:00.9354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7E8NbqBGeyHwMb8hG9qz1QJPbYAXUHGak0amjwfOzjDKdCHE9njRgfePBlh9hs6y/JmZlWJHAYGwH7HpEE/BvrgowdWZXGxSN9jCLcePp0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: pld3njbnuEUFE0Pz4BbPLPd0a1WE1vi-
X-Proofpoint-GUID: pld3njbnuEUFE0Pz4BbPLPd0a1WE1vi-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi-ml is aborting a task when we are tearing down the conn we could
free the conn while the abort thread is accessing the conn. This has the
abort handler get a ref to the conn so it won't be freed from under it.

Note: this is not needed for device/target reset because we are holding
the eh_mutex when accessing the conn.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ab39d7f65bbb..6ca3d35a3d11 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2285,6 +2285,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	}
 
 	conn = session->leadconn;
+	iscsi_get_conn(conn->cls_conn);
 	conn->eh_abort_cnt++;
 	age = session->age;
 
@@ -2295,9 +2296,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
 
 		spin_unlock(&session->back_lock);
-		spin_unlock_bh(&session->frwd_lock);
-		mutex_unlock(&session->eh_mutex);
-		return SUCCESS;
+		goto success;
 	}
 	ISCSI_DBG_EH(session, "aborting [sc %p itt 0x%x]\n", sc, task->itt);
 	__iscsi_get_task(task);
@@ -2364,6 +2363,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "abort success [sc %p itt 0x%x]\n",
 		     sc, task->itt);
 	iscsi_put_task(task);
+	iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return SUCCESS;
 
@@ -2373,6 +2373,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 	ISCSI_DBG_EH(session, "abort failed [sc %p itt 0x%x]\n", sc,
 		     task ? task->itt : 0);
 	iscsi_put_task(task);
+	iscsi_put_conn(conn->cls_conn);
 	mutex_unlock(&session->eh_mutex);
 	return FAILED;
 }
-- 
2.25.1

