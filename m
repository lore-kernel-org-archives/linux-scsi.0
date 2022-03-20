Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42AFC43217
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244497AbiCTAqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244494AbiCTAps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:45:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8124241A16
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JKeVMu015172;
        Sun, 20 Mar 2022 00:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=BVgLLFskMtHVRg73umRR8/sjE2XSRhYNfpgchOYL/f4=;
 b=LXov0Nx5zzDnocRUvCYVJFDk99ZxOppmny0odfIBG3WIN0d7ORhh1eZJOZrasnlkAZEY
 JxX1K5BNkC1T8735pybv0lfoPq9DyOGI3LPFxnMIk9Al9S3UUCjX+uNHHyWZzdi7uPR5
 unyDPdgjUhEgZ94/mluP0efaymX2oveoWtCUyifq5QQWczA5TtF0DvQCMfAV+r/DSBh5
 KmJxI3HYLqjM3Z+QfPk54j2/m3ieLs7vOV6NJUIaSVOQdWqvzGYBE0X/X3CaO0/7/Nsk
 41uFjULRQqoHCLRsQBNAGt0Srb7BSUCzI1bHZwl5hgk/xFGTQ6kUVbGkUssglcFh5k9G 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1rw2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0gu5u077988;
        Sun, 20 Mar 2022 00:44:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 3ew6yysr8w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhsR58V9LzWxDpMiCQbtzdiPzOyEIeQAJR3Be3NE8klYIDiNhF6OnpA5vQ82jN3JKjjbenPsfmgQuqNcG6tE4TQKIzNhQOq6dlw9XjuW7gPdUNiiAFUrOgl2H33RINu9oL2HyoIg64qXqJURG4s9kUAgcSwxISPfI2q3pfJDZnWsKIIzSvwT+8Fx+DPVk1bXPUFvtMkfC/Z4EuuMONDNWTvQ8gAR8LEWvn71gO/JnLt2eLnY1y7Oyy5f0glGNC6u8jMap3XAVnbrdpTAXIoC+v5eftg5jWSXOYj7mECCqNqAfM5yXiIYHGHRjTjg7HtUgQrywTSpm0kPAmqQUs8c1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BVgLLFskMtHVRg73umRR8/sjE2XSRhYNfpgchOYL/f4=;
 b=h3yLUW36wuSRXcnGUxuRUyOs95PkfkEPDKXRow/F1gf4KP7nSdbLICXpjhibnjFoEjcL2ra5BB6GmFwzjeXdm/76F6f8eowp/j65ploqwhZ1OzTu68TpzoKnr5q+oeYOb2NirYVNXGQVehrG0VinRQRPazxEVrjbo6WWC9Q3Sr4S3Nh+M1umviR3YknFrgeNLYfeLpKooXYkzh58IaxRdXWNCbiJSjyv+Qe31SuCm9FsyuGY2seFg27gY08Nd6Uf2UmSM4ohx30cJkNt6Mf4Tqk3xvCcIlF1GCybzdr+Wc2uaR9mXGlaHfB3FM639KZmrK0U6pvHbXv2Hi6ivYcJYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BVgLLFskMtHVRg73umRR8/sjE2XSRhYNfpgchOYL/f4=;
 b=iSFlIjbvMZIL7KkLA3MV7baCW1+hCUV5tLC/7UFdiQ7qyR2LmK5Nb82AdNBDJJUUcuTbjcX0SCsvC92EAI7FLjoqpDwjTSp4FrkeNhyHLZm2JEg5eS999GCAi8F+QsSqqnRHuPxXqgw+P6787YjcrpQNtmMgNAY/OXrGGoLgX8w=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:19 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 12/12] scsi: iscsi: Fix race between recovery and task xmit.
Date:   Sat, 19 Mar 2022 19:44:02 -0500
Message-Id: <20220320004402.6707-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78daae3c-0c00-4707-5de0-08da0a0ac466
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992EEB6C57A835BAD3A4022F1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y3q0hcaxQoYTxlitbEFgfBMWZFAU75EDB+qOlTEFv3iTwNjpEhBEtRGDJjCgp2dHxcCbm72t6JnVAkkr4EeP4zGJ6Si7sAbcey4/hwV4jKKl8ZUZhCET4Qw8xaFiDmfm+TfSune5kpT2Jx/DZiQuJgKzxZyGSd7q3xk9HSh61XWi7RLxWxZQXUSzvDBUEqO1tUUCV9Xrlt2oA2jIGgUScN77hBjWWrevMVsL/6oKgLAs/eBCIZnoE3x90PzNxlTgU8rbFpI/HwN9uqfr55NSXenq5MFEAmFIQCNTFriwTdKdCWtuP/A4VjZZW+MeMeq3GIA1S03h1rigf/i1AOvqll+OXUyHcmnuB9dTSYOlKVNT7ghhadsdjSbms2HTa9ezBKd6+5SGz1zWiFHIVd1pP6E4O3/spp0GoFOMnvartDgM0lJmhH1L+JAvXJi3fm8xJV7KynOI6KF6/zuCzyLRat0xt1mOpVymwiKs1Elc90wKMKgDHl5sn0FGub76SDbiN/3wP8nUaW6BTZvf55DNA4Qhk3EgKaM/w3frxIV8weyNeBlK+aASl28Qdi1zMAMO9qJZ776ZyNuNj7EUK25KEj4JscF71jKWwonfMV+Cqq5TNiR45NYw+FTzbURqZEIcP6FlkQB6g856Y8fupe0ApK3wIW9vzlsxDF4KOLoG/4UrK9KlWC3kTBwnYv4HaH1Dvy9+kGYc/azfDLJO96ZYOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(107886003)(36756003)(26005)(186003)(1076003)(2616005)(8936002)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wxizloiNKj6JpdmNo0p3lG6aIGWz33m3ZkYqbOFaNfJ/t2h23wugpNKwKAP5?=
 =?us-ascii?Q?skwPo2HiUUFWuP976N7Sf01UffNGvYWbI8remndZ8NQcFcuo8eJVZOROWe8c?=
 =?us-ascii?Q?GNX1IfdkBU1PdaNMm3uz3bnFdl3wtCIaB9+LSpW9/kLv8ME5hkpsJZbhanN5?=
 =?us-ascii?Q?8d71tGOunXPlp/N1bJGcw0o5k408xQqqtqEUkC0Hr7+5e4ulQNvKzpaBiRYA?=
 =?us-ascii?Q?aGwYbqi/CgGOFXq0Gt3JVO1FV/ckgreETAZ7DyFuDxv3ZJutg5deEILn3tvz?=
 =?us-ascii?Q?tks7rNzAjFTPEPErccs4xyYeLcwr+Nn6sFG7tIblprWZhLpe+Ut9keSwA4DB?=
 =?us-ascii?Q?a78o3ZqLoT46UIZoPPM7qYliDNMcAtZtHTjWeUzXm5HB1eDxPkxsnD01DHzW?=
 =?us-ascii?Q?s33ZupcCqOwH6N3rYKIeCK5EfXDIbyf3FZwJMAh69l/IRGiKTDRNM/pYly/U?=
 =?us-ascii?Q?AM4ddBydUzyCy21gK2BUalezq8BvVKxGKu95mktXwp2TpAIZpgA0TGCgIkU8?=
 =?us-ascii?Q?Miwvxv6M0Fm1hiEvFEZ8ZMU+y2Mp62Y7vHjJmGFUTb9e5VnZ76Plv4j7og0k?=
 =?us-ascii?Q?JNDZAB5Rk1u5MKVuEHeotHWIkRD/NpjEVRtihV7B7rfIEZFYt68fBs7caQ5z?=
 =?us-ascii?Q?4ulgrzlO+Rpv52pkSNYY4tdjHAjn+m6SjgQkhNvQjGpe33hDIXyw9Fa4L7+P?=
 =?us-ascii?Q?Ttgqo6mnMOGQXAH0jQ7BOvr2q8V2juXrNhohpOdytMYpQ8KG7fwZWp1x/HFl?=
 =?us-ascii?Q?ZwLjOpj62KN1gzctc9EX6q0ZzU/RNNMAYQd1y0AjU+GoZ6ByNiOzqbWE5Gy7?=
 =?us-ascii?Q?MYyXo5SXiu7X5ALPd9dsyolBVyemD7ialH31OpkFfGMIQ+q2qIz+Xe3wpQAP?=
 =?us-ascii?Q?nsT+aasclrWkHDTDRmAgtie/zMXBBEpZj9i5x7h4IfQBEpuOEf3okfuJSNKs?=
 =?us-ascii?Q?t0ZCb+AQPH+ddaH8iBQZVU6ZtntEjDvMmpsHgIeB6mSNtd4Jmvucu/lGXOX7?=
 =?us-ascii?Q?Sdhd6UaK49AusfnvWza1d5WG6O20vJ/JkOjStHAh8xMBEwuJy3U8Fw7TZX47?=
 =?us-ascii?Q?MvFf/b6jHxX+63oN8FroOUZuuTkvbxWjR7NWZiUvcyVS2dJgoC8Z1tXG59vG?=
 =?us-ascii?Q?JO1lKODt79NAzEw9LGwcaXng75Ql6+M45lYAyP3pQI4uyFXoFuhBf9tikdQu?=
 =?us-ascii?Q?Z4tscXAHscg8QEl15J29dKBhUfKFibZH/8nnrPbg0vrL8tqkd8KMFO0RKeQr?=
 =?us-ascii?Q?SpWsc8T0Uo5GAB1zrNCAX4mHPj5bPemei4hPEudyBI3GcOh6+27y2yNItzQh?=
 =?us-ascii?Q?weveiot5M6jKZHP4tiMzHsSrrtLW3z1bqnFH4+x8/dWPFroafxihgP8a7drW?=
 =?us-ascii?Q?9p26NVNh0BdAObuZhLLkoHUsQD4I22Rc2txhaI7KyDWsaGS0ha0Tn5gb2HKG?=
 =?us-ascii?Q?eFtN+LZQUh225rIHsKs7s8saTBrVlzpnUw7diNwAxcAziLiAe9HDlg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78daae3c-0c00-4707-5de0-08da0a0ac466
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:18.9215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hq3oJyEgTnWCkX2Fz9Goo85sICPTIKmPF0j3ZAbyCfq2hbdBytQO5eSkUZEcyWuFZEIYO6XgZT6/cdfCadCfYXRfh/AkXPXm+6T7ahcWnvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: RGuosMKDL_n6K0dyp1q2Bzzd9p4Jr8-F
X-Proofpoint-ORIG-GUID: RGuosMKDL_n6K0dyp1q2Bzzd9p4Jr8-F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

set_bit doesn't provide a barrier, so we can hit race where we've called
iscsi_suspend_tx and didn't see a work queued, and then a work is queued
and run and doesn't see the suspend bit is set. We will then call into the
driver when they might have already cleaned up their xmit related code.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a165d4d10cea..b79739b41b10 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2020,10 +2020,14 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
  */
 void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
-	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_session *session = conn->session;
+	struct Scsi_Host *shost = session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
+	spin_lock_bh(&session->frwd_lock);
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
+	spin_unlock_bh(&session->frwd_lock);
+
 	if (ihost->workq)
 		flush_work(&conn->xmitwork);
 }
-- 
2.25.1

