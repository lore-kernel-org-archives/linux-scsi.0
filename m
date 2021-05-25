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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2620EC47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0523B613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhEYSUV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:20:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbhEYSUN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:20:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIFUU6053134;
        Tue, 25 May 2021 18:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=gkm8aFgYcwofFRYfvEAYGtr9YTXEIVI8gwrAumMpexU=;
 b=vN6LLDE7DVach9eQXZRYkfveTyn+/WAUcZfGR7U2wrh+swU0VLp7T6pwhf7+idReEhOF
 usCGBLvJEMsT6ExPIzg3lZuvM1RDOZxTJ5cjarBUPPjpPFbCNct1dTtd8I/7E9tbg5nl
 n9r70WCzYkauRpThszTT/yvvuxtN4Kmdq46C+OXcn0hKnxjTEuwcQYslaP4yw6V7JYi7
 uQ1LQzcJNWmW3F78oha0XM+Lm5/XjjOkCzxjGGuwjyL0rKCsvnDOM56UWVf969lkI+iU
 aiMCSYlGt8e9AMXe2H4ETsmR04pGorIs395a2dtbeyt1GNcc1hjB41rhSOXQbbCB3QsE 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 38rne42gu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PIEtPv166079;
        Tue, 25 May 2021 18:18:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 38rehaq4xw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:18:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HytFLUAuOsvroGLHfL6p61FVPF0fFWAUtCsuUEATVMCkiWQ245GYHn6Y0h6pd730Y6PlHHXpENtJO8lErE8pD66ONtURzFZERORQ66Nb1jKhuRkV034UxUCAjlXp3UNjGaR0+wtAUo14cmCsFraurCwzLKwF3XoZYq1jJALZOZZlWqye78tLNI9pQNtIeb6Z5THBb6P/Ng4RaPi1BqTZFH28H8lDdPhqiyPTyQwkhdx6EUBs1Jv+JRCAJIbAqf0dEKmiVEpgdKu/+uYB3dGLtf718vG+a9LhtTFu8I50kfNtGbmLOjzGt3BSO7e8UGN8R5D4+2PBds2mRTOyRixILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkm8aFgYcwofFRYfvEAYGtr9YTXEIVI8gwrAumMpexU=;
 b=cTwkUj/LQARjNcGPuxxu714hmUYRsM6BzTvQUcAb7IREVGTBPvu6YyBMQ+OE/h93XQ04Wqmn+lLBs37z7rSOxDcUVdoJilQmF+8y6J4hr4wFk7bx3nxX/Hy/dmibe6Mne8Foeffd30Q6/pOpoC4m5fMrB3Sl3fStoJbM0tn1VeCNK2PrINMEYfANT3RLRl1ZvCnNvvR1wAHHHiXd2U1uwULD4Y8vN9IqAX6ILodxGMuQfgOUPdS/K/wRck463JJuyyQN0ulVD2G5j6oWdTrSLHx7J9yeSd0EESXicbKOcOUr/9+fsQYTGSky73xn+Lum8HDxj3qvYU9tzm+Gf/OIZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkm8aFgYcwofFRYfvEAYGtr9YTXEIVI8gwrAumMpexU=;
 b=s0wm8H7OjdItotdY61/MUlwoYVCmHXOplSQZTTDL8gQY8ujRZ9PL2dA3TJYTNp2CqLXKtH6gDEx/7kJN9JS53ciOWjApsIXSxD0Q4+wwuJNigZRm1BH3bPYE0KvKyDhnFJOEOdUrlZhhTbsz6oIcW2bVwjq5RRPRfgtiaWrlbyI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4767.namprd10.prod.outlook.com (2603:10b6:a03:2d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:18:34 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:18:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/28] scsi: iscsi: Use system_unbound_wq for destroy_work
Date:   Tue, 25 May 2021 13:17:58 -0500
Message-Id: <20210525181821.7617-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525181821.7617-1-michael.christie@oracle.com>
References: <20210525181821.7617-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Tue, 25 May 2021 18:18:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce7a8428-7377-4b1c-db5b-08d91fa9821e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4767EABCDF188C1DDD9CA5A6F1259@SJ0PR10MB4767.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5tXipFB+WDJEEjq2MEDsaSujc2IPvICXsjDPxEzeMaeTreIcF+xaw0CKQsdUShjIu0Jv0lUu77W3qrEA5CVn6NwSVBIRfjceTgeS5awb9DiRrYLjC/wZXDbKdedGAQreESdHUgiVPY6d9TcZADeXhsV4pwCBL1sZk72XM+MT10FUd2N5g3o6D9QmdoZlaaI29eOcVGyvf2crp10gXLotn5PW7aKk2Mg1Agw1Nhsgxrc496PDkY5Bw0t6pZ92hbviL9/R6U5iVkQTtULGY9sZJGnNm1S7kBY6+nAWocC29nuybREvemEJ8KkUogW5JlLg2ImZqD7hce6GuP9KTUg+o8t42Tp8Ie50lgF02E49BZHvUWWRxC0k5qNK59V9YAKc9kl5rxts8Fm25t0uF36/20g3nc4Eyt26Xp2Dp3NHQZz/eVuvGU0vXDP0vS1+Hekz5IIKcLFYBP2WDmrfXbe2XcxwbFQR+uIMgbdV0MGKxeWRoiznnVDv1LlDIK9MMRLaFfJD3kgB56DSHKsEkcWCcUJya81j2LIiyTSbvAPvwuGVYlgbgmJJIuh7Llp21+VE1eqmNawGH9r4TZmXxxeS+P+VCHnGpZY1nT6gAR7u5LkoEaiysc13kgpnQhpQpa+XPTgWMIHvagdDTfE3HwNJIn03ihGua2J4s6kKxCx1eDn9dQ6fGWbjLx+KyYNwOpy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(38100700002)(83380400001)(6512007)(26005)(1076003)(4326008)(5660300002)(956004)(6486002)(6666004)(2616005)(38350700002)(86362001)(107886003)(36756003)(8676002)(16526019)(8936002)(66476007)(2906002)(66946007)(52116002)(6506007)(316002)(66556008)(478600001)(186003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S2g+P4LCFEXIYEAuPPvvHc1t9je7CURK8YnFa7Mpie/XG60zA9zhOhEbFkdz?=
 =?us-ascii?Q?QFFicLbU4cAzgPcCN52bQ373wtLsoLbrKe+Wp6rdgZK9qO+J8RkK2v3kTwFa?=
 =?us-ascii?Q?XwdidW/Z+U1o3W3/UhYj7a0t7MpEvYRXQgzmPKtezcMQsTZhsF7rVj9m0GAF?=
 =?us-ascii?Q?0qQT2qZIhAH3/VAW1CkvUOP2amQkYLo+FnduS1fxlsf74UHwoLLNyUVaChN1?=
 =?us-ascii?Q?gbPtnCoaRPbepo8ao2K65QTBKwS+jgvY//3l0qPlzPwBK1g9DQBmTa7mEco5?=
 =?us-ascii?Q?A7LyIwV9NnLIJ7iYhsaNkZyNbES3QUJl8pJ2w1jHAbt/jPGNoNyom1HsxcNy?=
 =?us-ascii?Q?/YKDjjVgv3Iefk3JpWkWbUWh23hiF6gzbnWQHQezHMTfdVjzIxSGPINi7jLr?=
 =?us-ascii?Q?y10gDL6cid8R675VXgVxNVLSgQsLx9jWHNY0x5ZQU+2AslmV1bnkluwZ/sl0?=
 =?us-ascii?Q?+9lQSkrcnNVFHnmuIW1tj256WQ0nGtHAXwPZ5kMi931DsNiNeK9nuMdrLbNq?=
 =?us-ascii?Q?HmgGNQlatmMgjWj2NG/MXD2XyvnHiYdO4lMhLScDPYt56Ts6sEthWP6JcGmT?=
 =?us-ascii?Q?bQ4X/eyZATHfFNqxhURh/biIdRiq5SjSlbdEhYNCmdogJ8QXWwQO+skcpnQb?=
 =?us-ascii?Q?/EbUbbv3Wh11rtEwh/A9bera9GMSlpotwB/eTV7ZvYLPQ7moYRD0pbUmTnwH?=
 =?us-ascii?Q?qGu7NIOJ8ycgVfteRlClE9r5LMVIeZA3Rgo3Imax86qolAXE/P46DOYygqM9?=
 =?us-ascii?Q?B72025iLGYklHtuJvpMrQrckcB2lE1ni9p/acfpApwiZ804/GIAe/r+pprmA?=
 =?us-ascii?Q?3uzVFVixe/uT0YL0lSn4boPwjjvJ6HcBszSF9Pp3p/PZJanqYTxIEgUgGsqE?=
 =?us-ascii?Q?Mz5n8aFzismrAOJzEoGVBFzGf/s1hXfPfNzH0ICYYQ6y5P2HsE/uhP7LjapT?=
 =?us-ascii?Q?3tMtM22WdomwCPOjKbW9sbgrZ79H9BRG62i+tiYRhXkh10BBR+T5CX6DOJp+?=
 =?us-ascii?Q?sbtaQ5CUuTHGpCdCb9ruNoaqSIjAn145fmmtV01nLv6+1bu/bHFq6BWmSCQo?=
 =?us-ascii?Q?xHyD4wj+Wkymeb6WPDwsnO+mfTdZhlnCapRbU1fkDrs5TUnLlzAbhli3sBZ0?=
 =?us-ascii?Q?wG9WIOKWvwmtVZpy2Tw5DuAA0TCh1DoAvMnVj1XagIp9R9Zgej0rORImACr7?=
 =?us-ascii?Q?gtfmKnnQ4/SsWOUxNhtxqU7QljRD2CVQhahgimuyYasCcjc05aUONiYDkniR?=
 =?us-ascii?Q?Eg/4nkXj19A5gt7p1FNrRv8SOrjSw4ufSjsrde4lTpsRZVsczMMPIPzaAQff?=
 =?us-ascii?Q?2DpsSC0TVmosAJIejHsXYRhx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce7a8428-7377-4b1c-db5b-08d91fa9821e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:18:34.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mN690kg2qe0EI4GnMq87cnwFam5fKNLFYtU6Jg8qmaL/chsH/WCdZaoFVKuudXtfhmBlJ79GDR1aWzGpTSdM+yhEbf9BTH/OlPCPR/GShf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4767
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250112
X-Proofpoint-ORIG-GUID: 3AfC0rOXKTnq4nPHZSn7r1_Mqhj30cI3
X-Proofpoint-GUID: 3AfC0rOXKTnq4nPHZSn7r1_Mqhj30cI3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105250112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the system_unbound_wq for async session destruction. We don't need a
dedicated workqueue for async session destruction because:

1. perf does not seem to be an issue since we only allow 1 active work.
2. it does not have deps with other system works and we can run them
in parallel with each other.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d134156d67f0..2eb77f69fe0c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -95,8 +95,6 @@ static DECLARE_WORK(stop_conn_work, stop_conn_work_fn);
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
-static struct workqueue_struct *iscsi_destroy_workq;
-
 static DEFINE_IDA(iscsi_sess_ida);
 /*
  * list of registered transports and lock that must
@@ -3724,7 +3722,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
-			queue_work(iscsi_destroy_workq, &session->destroy_work);
+			queue_work(system_unbound_wq, &session->destroy_work);
 		}
 		break;
 	case ISCSI_UEVENT_UNBIND_SESSION:
@@ -4820,18 +4818,8 @@ static __init int iscsi_transport_init(void)
 		goto release_nls;
 	}
 
-	iscsi_destroy_workq = alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, "iscsi_destroy");
-	if (!iscsi_destroy_workq) {
-		err = -ENOMEM;
-		goto destroy_wq;
-	}
-
 	return 0;
 
-destroy_wq:
-	destroy_workqueue(iscsi_eh_timer_workq);
 release_nls:
 	netlink_kernel_release(nls);
 unregister_flashnode_bus:
@@ -4853,7 +4841,6 @@ static __init int iscsi_transport_init(void)
 
 static void __exit iscsi_transport_exit(void)
 {
-	destroy_workqueue(iscsi_destroy_workq);
 	destroy_workqueue(iscsi_eh_timer_workq);
 	netlink_kernel_release(nls);
 	bus_unregister(&iscsi_flashnode_bus);
-- 
2.25.1

