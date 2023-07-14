Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D065FC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjGNVhj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjGNVhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983753585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:36 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4VZ6019268;
        Fri, 14 Jul 2023 21:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fCb/dGujvfO9I70viXXsXnvOWK8as9iPXKsPbOA53ZE=;
 b=wVNsYaesn6IKUuFgEjmEcOBGi5AINqLk3mJl4YVB2o1CzEzRyhPiBTjGF6DbugjP9pHe
 g0xINyVsujtTXPeSTKYjgwGzPekGYddMStTjumr4o2v/3fd25Uo2guavgx1UPelVZ/h6
 w17oU3ug8uoSAJy3y2AuHTUMIAwFCPc/n5e0G++CxXt9Vg73LmWDVaPwV2asqhy+5NOB
 NnXWy7psWxNxS9OxXypAN30CxrIlvug/6KSefMflAZQeeOVdYVFG4S3BJMVqPLmE9Epp
 NeCoGRxwpOl4RXqUMlCbFKbwsftW4cwry1KgX6sJiGmjRpup7veqQiWM2srf2FVgrw+m fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpttjfga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJoV99033015;
        Fri, 14 Jul 2023 21:34:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvrs496-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf7UuJ/1wDB4TuJRVI7Yfckw9fLO7Idbbar5/IgTtsNha+HaQyxF2h2GtF9EsA491cJZ4w2bOtfwvRx/FHRuu2YFvMmtuHf1k2A9bVjWwwhBFY7CR3L9FwAKzp9wko/0wvyCHnHsUXGHCfsN45i0T7/pn9LQMM0RfrA5BdMU0f69R2o8irCMKbsaZ5dUTEdGzuB3o+ZoZVMPytRZHtO8NEtW9lH4i7tP2NaEjGnT6vdgaDY7Gf+35HoYKIBNQJ3DMQryf+cQwcbRh3cH0pYxqtUniM7ttMH8tWXO0kVi5BodepaGAn7lgZ+L7FoU1GGgjHrzQsP0bbfpYzXLpJgguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCb/dGujvfO9I70viXXsXnvOWK8as9iPXKsPbOA53ZE=;
 b=S2hlf55VReegUOJmDJzGiOHhHEWyLu10VPElbuDyRsi2blT/KMwyXM9SgEcR86WTH1hzVHF9fgTjwoE1Lh187Z4RbBK8+Horex82CwgGuHMf4HT6AMFaMEDCuqI5seVb2w0jy0NnkohxzW8zR4mjdNd3F1B+3zWHZy3LFRnVVNPbUuJbsEgKuLn+0wZj35023vmPKorTWROgVLI8DNI8wkbri0cvQlOjvO62nlZ1iX1RnnvK2qnW1ETrVtTFANDwQMsw/1atkCvMIMc+/DzscaKn4kLWeCyva+EteP1UzokpdFyGFQBl7xWs+32hQgckTiiuObMkBqoxt+6oZaWuqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCb/dGujvfO9I70viXXsXnvOWK8as9iPXKsPbOA53ZE=;
 b=jxY9GXg5LNkVz8ufQ5hTpbYBkIFpK6MuEK2j0Li9pRYKFngve+94KC/DYa/k+KlCt5ACK8fKUVS9+4fSaf5GzilRj/DEjFSuZlF9QvvfVWIQFpL0A6Qt2ThglK7YBh7miyj3yqZFRZsUEa8uKc/+yBCKEMVKV5Or6hxqhHYzYhc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 02/33] scsi: Allow passthrough to override what errors to retry
Date:   Fri, 14 Jul 2023 16:33:48 -0500
Message-Id: <20230714213419.95492-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::9) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d13b14a-4815-4758-1319-08db84b218a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcWTgfaCY6V1W9XGJgAdf+HY6AE5SlZtrzxFV6PaSzUMHwDAM3T0KpaeT64L/WQhwWoU1KHdhIJqO0Ve04XEevidVDG1CnwpAngAv+LXlb004LZVhFyrP9FZ0QryLKl9OlOqnasvw6BxoUndLG6r6SFEfP/VRGT5APRjo9smkBGScUFHb3buA+irG2yfejC7Lune7FEzHxaUN6gNyNxLaIFsdY40UM7z7JQ1Jq97Y3/W8CmTrY/ldDBdu1+gduIgzzrKeA5kzrK0X7v0pzm+OJ2PwHN5ZadjQICb9jO+OlvwJGxwFk/8iv+WJUU3rOFqnmK/zGja5fzShJhnEjM+qCanf1BWqAKnr8WQ7jT49lvm5nr75Yz6jo1mZxavzp79svPiwf8Z5dOIK8bUrQaAYqta9b8Gpgh1sDkyrAdm2VoLGSMCCiTanNyqGMbFHYhy5BqYuyRzJ8ZiKIMM9rlq2oH7F0hq2rldZhqbRRttAVvS7nGS5sf7XfwjcEBXI1K6x29Xq3LOfJqs8I31Y84/9cn5tPGYxszY3BlRQJ6UkWsrSazAKckcvnTIJq5cpMI9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZB3k+2YxEeJovjwMPJrwjb8WNuvScPxDlaT6XUzuzbUhy6nO04YuBSQ3obLv?=
 =?us-ascii?Q?7R8O749J2Ug60L1ah1vey9ivNLtkVoabufPKLbdcm3qW5fa1tFyCEsWhPeZs?=
 =?us-ascii?Q?cPKQoPy4wIApBPvHhIAH24OY9z4eU2cyuR44V2KZF0CXrtKtY4eHufOiyLzd?=
 =?us-ascii?Q?VRRo0XOMPVYZdr3q4U38e3WOPnSyLZJoRs7LojsZ8SFksdvF5+5wJ+W1Z3IP?=
 =?us-ascii?Q?8gTCAR4gb83haj3V5va2ptVgsRbitffc98NWAimvNa+VEoQlLSRre9cFkZPm?=
 =?us-ascii?Q?xiIyjVJRU/ri9BOJVnG0pj5055rTllSnP+VXksJsm4jQKwsmv9eICTvpuO55?=
 =?us-ascii?Q?yx98wEkWdGImDslDSZog0UB+CnUWw9MxyNk57r9iDFP872gH7LDxHRp+XmKO?=
 =?us-ascii?Q?HaHR0zk3CA+NgFjRIIyEWOI9gKmgQX7yOa2ur/pDjn1QGv9NMZqMsZQx0Qy6?=
 =?us-ascii?Q?N7ltMO7zHwI8DJyyYJo1DMuFbFBUzov63DE1tpzcMQ/ZyTrTvHlkcQeU0M5D?=
 =?us-ascii?Q?H3Bzmlghf5QX+Bonp02mjWeACaF1NqeQzHv4BKBSaxdNjB/NreeFGI8VKjrl?=
 =?us-ascii?Q?lPynqgtW8DiF/IkCw5gkS59DW1Usi+X//JhKSWpcA6tE/Ktainu6wC35JQE9?=
 =?us-ascii?Q?ilh8vVcwXQGSh90wuOKbUoxUfC9J2nvsnvP6ZPlkf43KowiMXYH3yUrwBfKm?=
 =?us-ascii?Q?soy1WokZ9rBDmr7Z/8UnTNI3pHxj1mNyJ2+Ne3k7iKKQp5ji6tTn09iJey6X?=
 =?us-ascii?Q?uw+O4KKJ3lz+tmGGy2TUm95gjoVihoWqbGmfLaFWZUa/x4kBkYuJH0TZZrhf?=
 =?us-ascii?Q?uZrIZ4wukV4hKF0Vp6Pkk6KaSsvvgJU1Heiw9irAP7qheFj8RgmTrmYlL9K1?=
 =?us-ascii?Q?MIVt48YYPSw4zDbGoEZyP94y/P2bIBmkG7C7KcObc8bzmZR7hHIutfKpKn0Q?=
 =?us-ascii?Q?OJdYJODkiqVx/QWBMLUyh6Uqxd4Vbk8+Cl3B6TgsyBO2KslrGruTVriz+tBI?=
 =?us-ascii?Q?zRjXk1E8v9av7tNb6k/tHfZ4j6QFeVcq/9ESu/9rIB89voXOexAkq4oL1y7U?=
 =?us-ascii?Q?DmoqouFAvq8xwhbNDsHYLLXinb1Xoix4mOG4L5QzAXhKn+ihNWmK6ONOp4/j?=
 =?us-ascii?Q?uc0AwIhhKPWIxmVWW+QBCs+4f7/l2k4Po+IPxg4dUsjuB+36C3LSFyiCYJxC?=
 =?us-ascii?Q?lqKdywXf8cYsmlrbnCaog/gFnwhWTo7wNYYwvu06+DnZB7PjAJKYZFtS2b/V?=
 =?us-ascii?Q?CER54dyjOIdA2GdSlNWMZ1M68/Nm4ryzyz8bWO4hWejfxO5wPalQmnaLgzva?=
 =?us-ascii?Q?fWDzZ5J65nAMH6NXlR+9c4n61dbMtbEIXoyemkL45zwASqYOxFvVB4r5ao8Y?=
 =?us-ascii?Q?juvF8OykIoUIMIHBgTazZIAQ+BM2YY1LAK+xQ7GK874mIu546L+iORXkqYIp?=
 =?us-ascii?Q?X546/4vZm3Zp/QrqBID8XbS29OZdW+T6hugKzqcZNW03DK0NHqRKAZnqCMP6?=
 =?us-ascii?Q?QEEz9yf62v7/udSqpFh913Ry2cagMtYdy0NLRcwsEdIa8EaX6WuqPyvBWtjb?=
 =?us-ascii?Q?Js09aDdIoSXaaPSic5N0rEJri0iT9FP8jzQPX4OMHSzg6JFgTqG0vFoQ7J9D?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 89+8fmvdlxb4lkZwZ58ej3kfYbaaWHTd/dpwBgXBFwzk/g9q1GThvH5u+C+Cf/uBGAjyxJIsnFx8ouyeMnwv23DBLDXP0iQCniG87J1zPDMnK3LwxV7WLDgf/NNlEhf6cnhfdnzJyS3/+CnEJc2yuFb/JyH6JQJhejX9q7nGggjuaJ1enebv7snWn6e08oYt/7JWTxhNLFIE81xQW3hrNE09LGkNm14/0vpCFD9d2psGxfqhiUUcQHi3ZIZ+20n8quuYCgY2qCOMaeKTcg027VS0mM8J9Ydl7h6xL9hp1EkXh6SeN+FMzbnKZ8+0hSC4iWe9QTYqB4OgXn9nEV+9OrN9+3qQffv1z1UJs6xlnKgxRQMYTvst1fhhT88fmtMj1G7ttxlEFoj11ozmx3H4LrWu7E1Qm951NvcYlU6vprCgjp7kACsGeCHobpzDoU6S8cNrulhIzMd1auho3FAkxfgtrfGwdsYwmZnzWL6ql1XOXeP9oYEmBoFP4ElL7AITY6+UP7ZMGdYZ3Mk6gG0aXisAfF39uZ9//LYk1NdplM/cF6DhkHnW7g7NYOkpHZNI/zzmUru9dDcj3l6yVzEw755Q01xSjwOmeHrFBXfYpmkfkK8WHVwC42g44oEqQZNydHcTpGVK6AILz7WyAs84gBXuZjUU6yRdblSjweuI0TmGDbu7ws+w/sXhNLqCpJcGndEBAek07qWnyGkdAIK+T00ZaTdYGsAHVZsCoeEaYkI5POSIB4Wu6ssB8B9WQw15xKfYKxE0iHbrg6gFwEBqT28GGgsLV/NHOabqkh9n+pco+HZsyOILQzT5qma29egKzFcuMOKm84rGUCaoq5zfEPxLvWIaCcBqcdfvRgeM1GfH4MNmaQuFBGdN36tSlMQO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d13b14a-4815-4758-1319-08db84b218a7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:25.7013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcUHLRUHUr/bSzKvxDsJ2P0CcGq6dypzHNyMd//sLrk/i2fhPgRWAWStPhHqKi4GBJEvHEXTCG/xAX82EjJfJublYsIeWocR1H/iTUcckso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: FEIDX2-Ka3zRCcBR0XwHEhF3woa8Ml1q
X-Proofpoint-GUID: FEIDX2-Ka3zRCcBR0XwHEhF3woa8Ml1q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For passthrough, we don't retry any error we get a check condition for.
This results in a lot of callers driving their own retries for those types
of errors and retrying all errors, and there has been a request to retry
specific host byte errors.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 80 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   | 10 +++++
 include/scsi/scsi_cmnd.h  | 20 ++++++++++
 3 files changed, 110 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7c3eccbdd39f..d2fb28212880 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1872,6 +1872,80 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should examine the command
+ *	status because the passthrough user wanted the default error processing.
+ *	SUCCESS, FAILED or NEEDS_RETRY - if this function has determined the
+ *	command should be completed, go through the error handler due to
+ *	missing sense or should be retried.
+ */
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	enum sam_status status;
+
+	if (!scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	for (failure = scmd->failures; failure->result; failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		ret = scsi_start_sense_processing(scmd, &sshdr);
+		if (ret == NEEDS_RETRY)
+			goto maybe_retry;
+		else if (ret != SUCCESS)
+			return ret;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+
+maybe_retry:
+	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+	    ++failure->retries <= failure->allowed)
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -1900,6 +1974,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (scmd->result && blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ad9afae49544..68f4bee73ff2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,6 +184,15 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_reset_failures(struct scsi_failure *failures)
+{
+	struct scsi_failure *failure;
+
+	for (failure = failures; failure->result; failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reset_failures);
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -1129,6 +1138,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 526def14e7fb..9a3908614dc9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -71,6 +71,23 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+#define SCMD_FAILURE_STAT_ANY	0xff
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+
+	s8 allowed;
+	s8 retries;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -91,6 +108,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -394,5 +413,6 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
+void scsi_reset_failures(struct scsi_failure *failures);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.34.1

