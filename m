Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28B5C61D97
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235187AbjA2Xp6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbjA2Xpu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72B71DB9F;
        Sun, 29 Jan 2023 15:45:49 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TKG6t8032425;
        Sun, 29 Jan 2023 23:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bpEwJYsNGPoWtcS6lq+xXJpSO/2cK2sbeVTQ0opfdWk=;
 b=yYafb6om2X1VH1h3FZEuSeJ1K6IFscfU6wY0KqKlkGxuqsOoPlS14Z2ofsNLlNBZrRrG
 v0pOgrzLbL+V2xl/oc5rLbrWGtGjrJxU7y3rV8Odlq1uGWa18SmuXlag/dEKV6UQjWWb
 /S2vaBuapgllL3nU8GjeQ5e0S4Dfr7TRNvIYZhgazTkGiGL6pwh7E24oPKawPeD87Eb6
 GZB7u3Jkt1ZFvYAUBvNCcpygiDpkGgZfmZ3A/sxnVcc3CGDop9gBT/Vdi9xXz6vCvvLM
 Jhrb6wUlGXQs/bMjkANx8L8abESIacnjY63an+UpwSA1wO5RXp5yUI4qE2NH6PeHlf8v yQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvp11s9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5qYT000798;
        Sun, 29 Jan 2023 23:45:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53drf2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h095xfsNlRtmXkypi+MISMVtWsFnmqAzK8HzPDKihP2iuV1UmxZy/7dkRGH54b41A5RUKb4t9TA6NiQVJjWLpFwyxSB5ZeIIcHs0Axkl4zDE7vkM2lOb8cih2vi4fmZU/3nGMe0XbsCJX0za/oXMedR8Jkpp5HxUnac5Bp/U7GRccK5oOp/ZNAlTMabTwk0yhFAUYPQ9cT3MnNs1lHCfMNFd6cLhzkXtFWmm007G2BMLMc9Kk2jr3QZyGf+zn0eFy9NEH8i2IDxvG9pb53GmRjxkJ2yQyfZlsGTvU0s+lg4VAH65Hz2SKSXC7tkAEivMoKkz2iECTH1ak0a60qkq0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpEwJYsNGPoWtcS6lq+xXJpSO/2cK2sbeVTQ0opfdWk=;
 b=AcV3nIlsFFY4qDEuwxHTeHxRT72kwnaCb4XTeu7MzPEFC0ICkshUQyqi5b8Xe6dwypSOcM555s1jNhTPYi30MF1MBgi0UUSwKfSmbQzCpwqd0mV0kAQ31i082sKz+YZBV1Jx80+arb7NvPT9Tjiz3HoUZEnioff+TESLeDDzgIEH4BH7K1KNk3TkfwucLRy/VWwXdHe1U/ausQUPc4Y3LkpT3QoQ1ezSqErQt3yVnAL8CkIdkLmJnC5VslRgt9Ewp8qgnxX8gL3+ANKURXQT+ygxMqfGNcy3IkSSbBKvUg/VQsHPCuGVWN5m1e4b//wwlr5RqXeUb4PSC8x+l289kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpEwJYsNGPoWtcS6lq+xXJpSO/2cK2sbeVTQ0opfdWk=;
 b=pzPlkDr6B0hKpIi6NfsRoOkV5YHpD6XSbJc38keqFpAo5yfPYNjL8CcFnVwOYntsGUiTcxEmZ2bUmrp/clooJDP65fGAc8vOgBWt6/982NtivWXs9aNO1POpdMpy9xGwf/Hq9XsPpsGByv8wh1Im7RNokXwh2aDt6pHlqvP9sN0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 13/14] IB/isert: Fix use after free during conn cleanup
Date:   Sun, 29 Jan 2023 17:44:40 -0600
Message-Id: <20230129234441.116310-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:5:335::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 137af503-31df-44c7-06db-08db0252e814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lQKbkAr2cuBh2C3MJPKDtF0TxUQjmu1IXGxmozy+iQFPIqPSPsHTRsPzauXVOOkKvlsPk3G4qNFEKIl8yBU+CvpC1g0aMTyz22RDYalfcYL/kOAi4aaQln4XZUEByXyrI3zEVvuZjkrJiHZiyzvjjJLQlLI8YN+PACOkH5uBhVuABxnxhd6UdlLNIlWtER1/pljtpeEfevcl6gYRpE1yWSexe8zhIzsGnTRHnq2L2ITTwjnET2O9FaFPEOs8FEs76HEseXr1T5lyithXMEHTyfLDMcNbmkBi4MZIjHuPtDjLqg5JPZWQFR+CBy7mQkPrVI7hBtTz6R2cTEy3Xj/ChF6nr5AzEH71J8rZinUwF9yajrBkAv6wJWMQjfWfcMiFOnsqNhbwqJT/QXjyEl2PTaKTQdmzV09GhO8CTjZYuD/apn6CGxa7A4pVFhvUWZLvtt+Zhhf/VWiGL/30hEhoGjpO+YK5eur0JG0FX+0RvCul+lAwsMkjPCDeE6T2Fva95GSU4chRA7dMxynVY0SphaH+TBlCHG4Id2FKZtVkq8J+rqEbcn0JiqsGf/m5X4Az80RbJ8xEyqDRoNIWsN8IkVf+B2uHx0FdmtxlZMz6pDejlE5aRJIAzpXoqdy8nHcNBoqCmMhPd4Rdqfh5xk3MaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UsN68/p0Q8gRjOYNcLGGqmUI+mhfRZIoRGcCD7sNlm8eagzIPSrQ4ME/kM9+?=
 =?us-ascii?Q?0gGWlHjwBYst96ThvxGZcYmipLtOLU0tBgO/Ior/yiZ14SzJ1a1fiuczxPaa?=
 =?us-ascii?Q?N3DX/dTV7Dtve7fILX9paA5GnbDNvpc0rF5TGfSbaNwXcdYiDK5EGsknf0V1?=
 =?us-ascii?Q?ZntK8RDZHVQW4rZjRWyhC7voiqih1llSm4c/Wl74JxHOtREesl9MD7vGdwCZ?=
 =?us-ascii?Q?jif1ant5RdOclHIMrsOgArK6uCIQ7Wd9cNqJy1BlACRbIrNiPklGIpM3eWuZ?=
 =?us-ascii?Q?pSD6b5hM8wf4iR90Bnw1n/kmDEfSG5WkO85Xnzf3J+kdKk7uc84pfXb8Clre?=
 =?us-ascii?Q?DBEBo/uVU4t9CL/ktQYWs5jnGDlzewxPqoZN9W+tQj4e9mk8+bHMMflGSZKO?=
 =?us-ascii?Q?TCMEsuLg/lesC+zIgHIrTuuZUcvBxEAKfbQv4bW3tePWRj4hIIw97CkoJgzR?=
 =?us-ascii?Q?eRoP2HHCvDpYRcyzszhBqYnnMtiJ97Y5ro+D7C8/KA5maovUh827bLUonRmE?=
 =?us-ascii?Q?eXdO4prTBeg2WQ5IxYGR5rKPj5ROzsFrtRkfKMF1upcskdwXzeH+qrITY0Mn?=
 =?us-ascii?Q?leUv4ojsNsaiGLVETKzJof9iUn9TYAMa6dLgemGPxCouK+zVcNJ7OUwRKo6H?=
 =?us-ascii?Q?PX0Ge204U0GviCGxBJr18dR2/3pMN+VY8ckBOxBk8XAVwaZSRsfnyk0WdFkQ?=
 =?us-ascii?Q?uze/jeLLb9GYEbT07oSVtIsVLz8AcJWUz3rygBFVEsmtHWX4zdj55/KZF8x4?=
 =?us-ascii?Q?+keOKuiEgdxE7NB370XPyhslocqOzUfOIeBw1uzcwEDgslL9CbsAikErzpDP?=
 =?us-ascii?Q?NysDN2aeDRIvqHMM+ZG51Ht01z+b55guOcMIeJM8vaXOxf5mSVI3aYFeM3+Y?=
 =?us-ascii?Q?pZX9rBsz9J+NndFbM7BhkFS1tj0clquyBK4hWYI6JZ2FAQSmdYQ5vw+spy8i?=
 =?us-ascii?Q?TeaHdTo9alSI61nwOZdGv9SxNQgVukCTiuGwz4tGDkFaibX4nUlat6c5rkZQ?=
 =?us-ascii?Q?C3LMKv7wCEfL/L3HIzUjBdmBydQx0hosH2gtMQGKTCh6K5mFetTIOdd+ehVv?=
 =?us-ascii?Q?E3Wh7Nnv/aM6OSlioYApiqstpf1AQd4I0Gtt+UKKwaeSRHEt9DdHcfP/zsjb?=
 =?us-ascii?Q?UZl2/cCnYUs4rXZk3JtQZVWysCDT6lvbBXdJ2YwzlxC9qaa7i4/iJBfJxfv5?=
 =?us-ascii?Q?mGYK8GuaovZtQ9qk51eLqqjfn8e7pzIemeMffweZTDM2wtNztF80GjVIph+O?=
 =?us-ascii?Q?HxNMos6x22u/3DmH460YsGBfulQypTnGCKJlF8+saI/1XdrJgC7HMSYRz0pK?=
 =?us-ascii?Q?RIxZPZbKerSSxye5q2kEkQ9T0cluq75eeWjr9dka0Eaxwbh09OJUncQ1FJaz?=
 =?us-ascii?Q?R2pPbgsq77p8QnENXpxozobLkPhG7sD07A0zSzSvnDWrcEBChRY2K5/52VjR?=
 =?us-ascii?Q?dUnu9yfy8/hddEMSb9KS54z3zJAem0ROxsrwAbcf7cAq82Vz/LlJN1xTj+WK?=
 =?us-ascii?Q?JBdruJq7JwNrfkzb+D7fc5yIkzgP38HMKJTehMUQTpt7GPgVWvRg/VF1xaoy?=
 =?us-ascii?Q?A/x3npWRjCTqrOA581Mnsk7z15JA/c696jNd1pd67hV6lrYxSmuqIoHAxAZk?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 79Ig6IN6BJzqBJwijiDzv17VaFgBJDHzV1c/cgyQxPHf08xRk8VnvjGhgMnqNXiIfHCxUDk6+1Tm+1AqsRO5NMCT3zQL8grrVXdE7m6EHqTpgbWcnPi3KiyttojrgPeHay0QWuODOJaACNdgB8Nd5cRQO+9QYuAtqhxxXNY2HOCKPVq997UcTZMawrFvq683zSJfk5ulJBKNHDC/PPSfIUIqes+vA8klWOeBO3k0IKVe28Zd/P5peA+rMH84yMQYGiOvBfy0ppKFnT+pxaSmDmqrSTQB+RMLsk30v22h3Ze0qaxYKNEnu4KzXG1DA/KAQmjzdEmRduyxqEfNuQBx+Bq1IOT7jRO/L0x48Xbt6a7eeRGaoRq6I4qpRdawt2Xidpu83fhNIuq1REAjTp86xa3E9uf1z53C3dSpCUyQa4dIVe53BuhN2bf3PC0ZAsHqmYshltIwm2Kbhw5phq2tH5QybcWozwLgDKc0ldD5hTNg6QPaJrkHbqXkQM2LssK5ykDdtB2yR433xF9xc4jnM6uBsDoz/pIjvI4uH/Dn/GgQtKnKrJV/C8VOH/ajF8XdffbjrxwcEovvc/u+4A6rQQIsmq53baWg2L3yTD1GkbY/lHPXrMesP9ftzpqK0ndLodCYi2+jjBcGiCYjDAIHSumL0dyuuuj0qiox8ErI1kyXbNFRFBCL38NvXQXeXY7bN8wAA7x0gbzPahQYc1WdnG91SEtbyKHSKGv0LeN9e5UGuWmdNKmkyEdovXL/mvMWtEeB+HhNiPuK1iSouW7Np0UlA/J390wiV6y/4hlBunRKMaO7sXgjQ0Xmv3F4k4tiNNtwh/WRt0BLSJC+Zpt7E7FQh9c9XCqjBkuOA/NVBXkeHjxwK4fQBKG++RjdRGkE
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137af503-31df-44c7-06db-08db0252e814
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:30.8507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnGYATELxn31lpVuz5ZiitW1Wc0nt2icjHR2Y7sRKME3kY7l+Ra7TqOfFmjmnq7ihqz2uxQZVLaTJzx9rhY88hnilotVW6jv+AjbE47ZJ60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290235
X-Proofpoint-GUID: GO1Jar5VFm_cRYIAgb2-_MidY3lPKIwD
X-Proofpoint-ORIG-GUID: GO1Jar5VFm_cRYIAgb2-_MidY3lPKIwD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We can end up freeing a command too early during conn cleanup by doing:

1. Send iserts N 1MB writes.
2. Pull cable or down the port isert is using.
3. isert_wait_conn's call to isert_put_unsol_pending_cmds races
with a running isert_send_done -> isert_completion_put -> isert_put_cmd
where isert_put_unsol_pending_cmds sees the cmd on the conn_cmd_list
and it does a isert_put_cmd which will free the cmd. Then isert_send_done
is run and will access the freed command while doing it's normal command
completion:
isert_completion_put -> isert_put_cmd -> transport_generic_free_cmd

This patch has us increment write_data_done, so
isert_put_unsol_pending_cmds can correctly detect commands which will we
will not be calling isert_send_done for.

Fixes: 38a2d0d429f1 ("IB/isert: convert to the generic RDMA READ/WRITE
API")
[code written and suggested by]
Suggested-by: Sagi Grimberg <sagi@grimberg.me>

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 516fa37494e1..a44da60352f6 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1636,7 +1636,7 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	if (isert_prot_cmd(isert_conn, se_cmd))
 		ret = isert_check_pi_status(se_cmd, isert_cmd->rw.reg->mr);
 	isert_rdma_rw_ctx_destroy(isert_cmd, isert_conn);
-	cmd->write_data_done = 0;
+	cmd->write_data_done = se_cmd->data_length; /* done fetching data */
 
 	isert_dbg("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
-- 
2.25.1

