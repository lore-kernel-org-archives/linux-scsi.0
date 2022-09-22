Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33B3C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiIVKIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiIVKHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E755D577C
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3sar006440;
        Thu, 22 Sep 2022 10:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/GU72gtYBEo2FSgdDLRyX1n/d91Ye2t+It+ytmhpQ78=;
 b=h5j8W62YrdswmNtjVHq397uUsUjxiq7KfIJ9TDdBK/oXApIUcALJaRB0t7eGZ8zA73Xg
 mrj8S/r/rHc+ViC8Z1tV8biGlcFZjIdzxQbedzQQRS2Z1Dte+bWlQCGeylyWfwepIa/b
 xvBKUxy/T4o6lX2N78Y0UH7ry+vMPDpapJUel7KxwJ23yIoEtIsFGEnKHQfEIfzIaYeP
 B4wqz9B9nUG+Qay8WCC8qmN8r3LepHZVQ7FEN2AzPpeOm3vVrTcxJ2nXqeHx9t8rKsFj
 gR6gRi2tt+Dn7Or5wcI6byIsk8HshUWCN4b49Q/IDpIZ/iDRese6p8LCu384ErL0ql8G 2A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md27r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l36Y001239;
        Thu, 22 Sep 2022 10:07:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cb3frc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUOx5Mjdunqq+7Vpae2zZavY6ejkUsHPkRkMHsNeWcXp8G2NEqoJkGjsC2f/Pm/dlMmhEIyq0pk3+4MR89AQb8jDbJU56dT6j38RwwYfk4PIaHR6s81/sIGj1WGWmq4ncqKWnWUq3kphXTOVBFtPOs2Te/Y+rW7d108b4ifPoKU3Q3CpyWVbnlRXtdIXAe6JYeKT2o+XQYCIU92jyJ9mko/f3SeWJFaw6KksH2AOyi+IV0LWLAzzTvzLBQmgONIsrPN0DSVQ5GJkcMg5DtN2+Eu/K+ZOMkKPa9pMA0RBQLeeIH8DX9ymFv2Xi7zATfZnbcbh/wVfpwUGMyU4Gebe+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GU72gtYBEo2FSgdDLRyX1n/d91Ye2t+It+ytmhpQ78=;
 b=TDjMWR9+Kfdk4QlL5iL6vInvMLsb6it4gCtwlCn35mAoeTFIyfd94bVPqE8ihAKQKtwrR+hGQMc0YGU6JIt3El0qV1DUqCyMxn+oSHwV9hhBGlvLYw31bdSEYDSYs+6TUeGQOZ14IbB1TtBzx185N+JigvwNd81aCUwKUqIiywfKI4FaOJflHgnmw2d/2u/nexLPt6Y6dc6B9nPa2UNZo7Irlye6lvdEycp8AiwRsAwEYsHqfr8SykVfVcjvaiZi8U4e557ySSCArs3VapCkJY6VUpPMsOwhDMF/QteawAK+53nSJrYjkUFvLqxUoOi4xVTQ4OQZvjbjNhYX7xpRtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GU72gtYBEo2FSgdDLRyX1n/d91Ye2t+It+ytmhpQ78=;
 b=CyD4TfoEIIaPi4GpUaCXD+nz/dSr2dawM9tCjsJqe+hdo+tVl/fmLHA/B0IHZzzbwxOTCdsoR0ZzwPzeT9gvQ2yBvrIiCrpSlyGTfwTt+fUX6rdyxt7gkh2T/IlztluUeDW0yyQMdWG8ISpETDZFBFLxEDPS/xmYa8Te9brXXUw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 10/22] scsi: Allow passthrough to request infinite retries
Date:   Thu, 22 Sep 2022 05:06:52 -0500
Message-Id: <20220922100704.753666-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:610:e7::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cbb46aa-4666-4e7c-6239-08da9c823e2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yvHAqHDeLh2annE5kiAAc5AqhH3IPz76vrjmWn58VMJ/RKMCLhW9Vy8flu3uJgt3gtpQLrUiZJyo80XhJB944VnOhRsJUWzH5fX4dicJpeVKzT/mwXLaadBcZcke5CZbmeeiVzyJR8+WPKT8XKHn5BXoT40YlijGGpH9p7MDyJ8qNizbHIo//6cSYsxgwjbhdqtyDXE9GkyJWacKmxYQkMfisLTFdC68weEmMdaFiFq7xOAm5iS6yya8M7BpKViSHnvkFnc8X7n5wJiSMDB50i2ZIqh0bHnO8YbdJ8o2kvKHYi5NoWY2l4vZAzr2WyJdZfAW+F7wxO0DnzYqa0kaMhQwFD/zXcDh2O6zMg0Sm1VS4VGB2L3EID38IEBPIlBT0h/LyUC2MwzbXJlFZrTM6uJT2h8JrtrtK5UpaSRmoL5wyHPuJq8vkUDBKa02lV3v1OXUlGiLb+z7GfhJnwVHdf9tuUu9rW5EMX6FhWn9nkN0l7uFTeWofVPGZwTMzsmYlYx8JCmmMvMHk5lkhYDfme8z1G8/UQf5IhOFeKMR/s43L7gi3RTNUz4t47UAeLfQw6EZIK5Gk8C9ZksW7f8Sr2lIN9l9rN1nIFfjsygZIslqtvDgqxV7LwwwsbD2gJsbUUFXm4cGK3YYSnovn1TDVSR/A2HxpNDNLyuGIULDvQoPn9qQWui3RsroXj/0pURyeo0MfZkLtPx1S+c6Moxc/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(107886003)(66476007)(38100700002)(66946007)(4326008)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dZWlyXgw5Bk7t0wQE3pls3LMACdwP5DMDxuYTkA92wX7SIywXYTJlotkPTmB?=
 =?us-ascii?Q?l5T061jAGyo8WmC6WBxBCxa4YtP+yGuKVuQWQxQYpZd2vN4S8PNPG9L5QmsZ?=
 =?us-ascii?Q?vCz7f3jF11iTPD4AB95THE6yd7aGZZeKKgzcvGVp5iuXxtH5wQa/axK+pxqD?=
 =?us-ascii?Q?4314xKWhn0wJJED3sbgrqFlB0CULYv8OE0+PD+Na3smM0UftCmED2paqzgF/?=
 =?us-ascii?Q?FVq8YsT0EaEmuej9/ZjqLbeZlIdz6995KYpTusVDMth8enys7yKlL15iaK/1?=
 =?us-ascii?Q?8YjcrLvDnEGozhlaDWk1tgEce1uqh2afcgBvhpQj249BNRLNFYicRhwaOYho?=
 =?us-ascii?Q?b3GQ9GrZJPzuusbXC6m30UFWUdFOHUvU9jUiqI1W/ADhuUAqjlVGX1xI2TY2?=
 =?us-ascii?Q?JkBKTTl1Qaa4OoHxYUT1RVem6N2urE7htFzPdVPSqpuVqx3cNOodR9UOGsG2?=
 =?us-ascii?Q?UOX2iqBJkELFwKrxKyeGZJrZVD5kfuEkYuWhqWXuHRKn4f/ESXFjWggdfK4f?=
 =?us-ascii?Q?W0U2rUetVlyaZgJTLlMSs/DZFS6NJpqSv3wHjCs8MF40aDHXMJG770Vjbf8B?=
 =?us-ascii?Q?DE+ybZ4rLz8KgPwZtcc2Y/Hkc+rNvOHc6w3WyZ3fPduLJSoMAfb00Tk6H1nN?=
 =?us-ascii?Q?CswX/NuQbe2kIN2nH9ERU6LUVVf43TuXyktvkaO5Am8lk4l0FmVI1psPNGuj?=
 =?us-ascii?Q?2pXwjO9UA3CZoj6Yi8wIVExc7EdXGbzO8GK2ShkAKhJ97xxeNq/GVXlXNhYM?=
 =?us-ascii?Q?wAfn2WgOXS1NeipPV2Vscptatz8TMbZkz6pkrum6A4s/NoR7vU58AOV0bJQh?=
 =?us-ascii?Q?/MeHfMqNMW4SlprOy7zLZuiQx8gcfLyhbQ7gaBHdKsXzlkEB8btsu9MoNygW?=
 =?us-ascii?Q?CaGboxPluJHppk85haJFyXnT58uH+aCXk2PfhkZT6RH5tW5Rs2w/6tWo1cHS?=
 =?us-ascii?Q?or1V+SnRW9kgpcA3pT5BoC5VKcJ8xJqNoOzBhRvQ2IX8x56va4EMuHN102NE?=
 =?us-ascii?Q?FyiZ2RVm6+2uGXRYIpSAiw48bSeaXdYhCyEj95FFKy395fp4He5cqRPl67lr?=
 =?us-ascii?Q?vBF8M6AJ/Qiq0QgkUwLGhY/oRYQMyqUCEd8qr/02bFRyffmVYzfsbYNUxd0S?=
 =?us-ascii?Q?PIb/ffzF1cn56cAOuF8jGUoAZsrOKcllNYezFaDB20Kc/Od6+hRaDah9MSqu?=
 =?us-ascii?Q?Y4fT6Jt5wVFjjNx9lnJNplttuN9JeLiADqkEptcEw16HgGOdi7ok5PqEFdfw?=
 =?us-ascii?Q?AbuFFZydYg5vu8Q4I3j/ibYdYEeIZ3QTw7pdgui8zzxEqjbH0kZa7IfDDadE?=
 =?us-ascii?Q?6NT95RmmQiCYmtY9kk8IKPHhq6ZxT6D9SuuktcVNmmYx4XwwHtjwkwGZYlcP?=
 =?us-ascii?Q?L7+qFLm51UmiSGiQeQtiyZLmCKnMJbkEQgR40vZ0/Y43T6C/HAJOoTR1QvZl?=
 =?us-ascii?Q?aTnR4H5dqiozrthWgOMKCG74q09Rsru4arasGwS1c7rgRhnoCjeL8XLs4yxe?=
 =?us-ascii?Q?6pd0qY33+fF/n/SzDYqFE9gVEelfxE1gZkKDwdAEt6GCCIb6A7JqlQszBqXz?=
 =?us-ascii?Q?8OsIriKp9rR3F+f+qiwg0uqia62VspVhG3P+HG1ThbKch3NMgEUoUtDcVpL7?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbb46aa-4666-4e7c-6239-08da9c823e2c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:23.0686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvIlNT28lJRReKYF9gQ79MdbYgnpdcYlS4b/WGTkprGVNiDKTAxLr4Wnaw6hl9jF2NvL3M1TpxTjTo7xLEVdobGZRcYCuFa/r+gMgChZRjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: l_fz_PYp0g3g0wMJTD0HjbSFp-C6vLQh
X-Proofpoint-GUID: l_fz_PYp0g3g0wMJTD0HjbSFp-C6vLQh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hp_sw and rdac request unimited retries for their failover commands. This
allows them to request this by using a special value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_error.c | 3 ++-
 include/scsi/scsi_cmnd.h  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 059c5f40d236..ea79bad4b865 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1881,7 +1881,8 @@ static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
 	return SCSI_RETURN_NOT_HANDLED;
 
 maybe_retry:
-	if (++failure->retries <= failure->allowed)
+	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+	    ++failure->retries <= failure->allowed)
 		return NEEDS_RETRY;
 
 	return SUCCESS;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ee3986401f52..cb1191ff698c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -69,6 +69,7 @@ enum scsi_cmnd_submitter {
 #define SCMD_FAILURE_ANY	0xffffffff
 #define SCMD_FAILURE_ASC_ANY	0xff
 #define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_NO_LIMIT	255
 
 struct scsi_failure {
 	u8 sense;
-- 
2.25.1

