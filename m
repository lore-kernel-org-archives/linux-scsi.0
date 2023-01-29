Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1472C05027
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbjA2Xp5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbjA2Xps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:48 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F31DB85;
        Sun, 29 Jan 2023 15:45:47 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TKxIXU010697;
        Sun, 29 Jan 2023 23:45:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lQ6wET7ea73HkdHDAZsyjQ9jVSUL7gC8ZFcL8LEEQR0=;
 b=AVQa1nWPC/97zctzx6XRpSIj8CtXhAwY/V0Cz1G/s8xOLBSq8r/velE/b0e03s5ks++i
 xeFt/MQbuVOkh7VQ1pW1CkFG0xVxKNBetXdaM77xnptQPN43MyEpsDpWeGpYJPze6bVL
 qFBrCbAMifZaHk5SouV+PyJkE4GHxiVl+lvAU70pgsF6mELdXn+ts+0eKnbIvjoDPsTd
 4Rmv5/v38n/FigP5Om6AJ+TBB6/CyYNixPL9Hq/fYJ6GGJALVKKjimgmSFQ9tGkpiUyO
 kvRdJKgzz6fSQR8q8molZrlBgy6uFYRcGC0hJZSxYqo0t3P4pEeD9OP7l+Y2QqR/7RBJ Zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvn9srpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5qYS000798;
        Sun, 29 Jan 2023 23:45:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53drf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:45:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJq5rOKQR6/OvcxLYqyVbG97Fxk8ccq5f9H6OC7y9c4QmWlPxwiaiMpAbo4MwEHpzqde4Q8Kv/NgDsy7xNgkPCZ6XfQrB/bjFUmyNCf6m/i6jNLHcI24pXk5mS39NWe4qNjv1eDrPrEO2nGP+MZUVk8HR2qrZAq3/9Th/rC3MbR2dnDKydW1Yax/xuvVrLY4NEbuAO1NHL17kcJriMnhN3zFfeUot4+m/nZpLhYgSL+39dJUnWlq5e2V3qQ4pRvxsonhuf3fJpL2gRKFHaQCV3kZ3vKO6SOlibk7iOyFBM1iNNxVZieuke4ekhtd8if7BP0W2K6D4j1Trdoq6Hdkqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQ6wET7ea73HkdHDAZsyjQ9jVSUL7gC8ZFcL8LEEQR0=;
 b=BGILg4HlozD9qaMPIb+NrOm7qxEUX9jN6sUp0z33S+VGJkysPJ8KWFpCqm2IoX0J4TumWR1rLrKV5GeLPf1T5UxKRwd/lRSCjCGGaHSpelinwRCZ6bLKcFsBIk9DwFM0joNL1jCF3/JaqSERV1P2zwATRHD3J5qP2umexXzaV8/qbFOAD4OvJWhrPIPy+ariY7F4WmF17JVcrMNBzGsPeUyOss87Nvoc7M1UnHjKbCMQSJebAAS5o7zjc7By4Wi+xIct7ksSYq6XvY2pUApPpxVBkLHIb1lK9snRSvV9dT+CGREhgaNRtELL+z2AeWS91q4CpqSVxVXrNe01oYBQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQ6wET7ea73HkdHDAZsyjQ9jVSUL7gC8ZFcL8LEEQR0=;
 b=QyuEde7xD4H1uWHs8YyuY2mpvhVJEBuF3SHqZAnt4g7IxG2lsELTXN0BtU326336T9Vv6/XfD0//WGqvHVBaG5tZxDunl9rQ374SJhK0exuV0YIYayw8C9ZTHvevI+lEDKE2miQ561fuaz390NHQHcf1tx+XO2T8dJqoGIliMz4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:45:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:45:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 12/14] IB/isert: Fix hang in target_wait_for_cmds
Date:   Sun, 29 Jan 2023 17:44:39 -0600
Message-Id: <20230129234441.116310-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:610:77::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: c408bced-fcf1-4e8b-c7ab-08db0252e72c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lN5vBjuJ/azC52bBR2aPobMviFzIxEFQH7u4Bugbyf/bQUvn2MIN1IapkQ3PXqd9ufoeqooMS8rNjgWqWw9X4bvGnYorXsamAHqmOA/ohDEEzOq9rRuwjij5Ck8GQ27pGcZMYfp200IbYZBKMlUwuHjDr+tuC4s5H8QTwFV7YvXxtUlJ9wUdEGWov1kQEvY5v2DkLJ1V9UlYqs4E5mkh5UeFsgyW0IiNVO48DAa2sy3d42qD1nqktB27wiJfy8zHe+XMAvga5DAqNj8B+0siVQQ9Ya9kC9cY8gyreMzt53bb2lBnrFeJ2Vjb5OZcOacsGJ6qnjF3sMXt0bstmCJbb31EwumaQiWRmD6mAEB+MyKBLHKWRTtTAoBMv3POjm2flnrdHWuwWJSLr4/cQscvPb4KHPvLeAzhPJc+4HnsyGNu8A0PTYBhsXJdnsRKK+79X+Pqa66yO+ddhxEsfzYdWzlhNgyOnDoA/5rBTNq7LrPjT/lt+KkhXNP/uEUk3G3fNSi9BaO9KFrWTAnTypm3tS8Ax8CA8C2g7OIUdhsP+MSDOhRYMReXHDdOIsgWnGaPfajoFH3LMzuPamdMoA+A/XDSuVXgtK+IAG3lHcmGdBQ+pHtU8BU/xL60sSVab/1+1mRu8/JAi51D5mxYXmeY4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lAR5dro2idcN6z1cXj7Mz6xfzr44rrEASfDHhKJbY/HuT9ZajzWUKkUGAOmo?=
 =?us-ascii?Q?mKaoXW7M+PHmjV6pORwBbetyl84IB3aUA+6kLj4pUFRw6Ts31KRkgOo0YAJq?=
 =?us-ascii?Q?EW9zJ6+NPZurlAC9NnmztTUKr167JNX1Ap0/Pz2nWti7rbdscemLFqb4kJHk?=
 =?us-ascii?Q?IIUtCWi6oqxBjnV1jcyxoAnvtBvRBT23wGq+Pi7+gR+w1B7lJTdYAbkgvWLY?=
 =?us-ascii?Q?EId3OGW3umS/8lyYrysLxbV0tP4UbNwES1ZnqrshCZYa8yCVA2IHY3Df3YH9?=
 =?us-ascii?Q?HVQhZHMVgaQLiBpPLah7AGu/sa8+wESdpwLxvWcSV1OcRqcenR6smt1P86Mu?=
 =?us-ascii?Q?RCOrKKvb1EsgPICE9LghNPB83Ke8Tgv8hDT8nB5xh/Iq7hGRHMV+tqRoS50H?=
 =?us-ascii?Q?FwIraljGeSI/DxNlN8hcvbrIo3d0+EvqqhiEz1aPaU3/31gkB821lWBwUz0H?=
 =?us-ascii?Q?/CVRpPAceR4G/2M76ccOCY1myifCct2fKHh41PtPUwZW7z9/juTaIWr4YtQ3?=
 =?us-ascii?Q?oIje92f/F/wEekMdS4rZfvpmTBL2ONskIytlZQjTOtEbEtivP8I+Hko+xqX1?=
 =?us-ascii?Q?4vO4Zmo1CcwkJzf+mmIh0nar0f3hfUHl2tl4Gg/qLb8P+UBeXHUsfF0vSUjI?=
 =?us-ascii?Q?qJj7xPHC1VFkku1lAiH4r6SwnLRU+ixaBwCxFYfQ601VeaNnvmKpDoEMRgTQ?=
 =?us-ascii?Q?wsdTXC004P5zhzhUuJ2jiAv5rqYt49s1dPVgnqkeABKDdX7JyW+OFLPuu+92?=
 =?us-ascii?Q?CbEubEUJ7HEZIspEKwFBy+V0yBaw2PvI6gq6FltVqrOFx90W2YFftnNanZLC?=
 =?us-ascii?Q?K868AVKdCLqJ7a1N9BO0PWYOU4pk5+mxSh+N2O3S3flxWbks00+K+rFnuM2E?=
 =?us-ascii?Q?ObOugiez+3BmC0e6VtUypM1fVv4xKbRL64QzaJIAkfXw4rCuzRFlfLw7AaBD?=
 =?us-ascii?Q?AGXHGUvnO4KT3pYJK1ho+R+zP7rVTwa5OjBTZqM97uu0PmejG0V5XRdWF0cT?=
 =?us-ascii?Q?SoLz/X4Wg+P5QK36Px8FCMLVR/QervGZ5ZXxMNhvCoq9ZRUr5kkFJFpC+v7b?=
 =?us-ascii?Q?HKzsxr9So5cPQgaAMNo+iWOpZw2NgdPH9tKsZcyJRBxDnIiUfmy+jp7jjQ/d?=
 =?us-ascii?Q?mqdgy6S2vzNd8FOJ7R7p+bn7XWfSd9zjfPrFW7Yv5k035KOpf7/QwzoJcH7R?=
 =?us-ascii?Q?cRovK2GbumjWlHq+Ql8aeVz7fYSd7dsSLQ4U1gmKTpdNby8QYFarUbpYBFH/?=
 =?us-ascii?Q?2EZ3XTT7Mg3b0gUFXca/9gM6MNqgzbUVrXdgBZn3DskBPnyPiI6FYyN1Yq+p?=
 =?us-ascii?Q?cFv/iTrftUzJI+yLbWUZLvxvnRLy8ZulteSYTbjZX7SVxxU0DkAyy8Zp9Pj1?=
 =?us-ascii?Q?2weMZgtxegcblOZDkdZwkocNosR9eC4XCpB5od3IDZ8LkNUID3Nw/9nhcjgj?=
 =?us-ascii?Q?9ujoVgH3bRXgGroXxrlzURx0e6MUYKXvRQnnDKMNxLgpdfoxAEGf4Itsf6qW?=
 =?us-ascii?Q?bypu3yMl4znpJ6YmXYXFcfbCWuESN4E8VfGJGN6oCEP4zKAaxHeO07XNv0/K?=
 =?us-ascii?Q?an62HLsCHKwP4DkC/pBs85dTmTz/AMapO1i+8ffkPfU7J/vOli5xTBIvyfEp?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: o2jpjnZ3R1jLKIDSuQyQ3op0j1EMHCEG9La0EA9I9yFSWWayI+cYzo6ZQGhkBGlT72gjeabN6EjgeV2RHS/iluQZKAtAMOCRbsZeFEQmnFcseUHPU+O0/T5rNqVomZfTuyOjQe8NogMvZecLn4CPp/UuQnQ0qQuoE7W9OihbWLmfwLFqBT2ezp5wOT8Rvmnne82aQDwkL+2S3atDEiMaos6HLDFAt9nC/Z9YAbvmMWSlXBhxia1mgAX0Ivum8WhzF0UG0K+i2c7p4IiHNmlM4gIdUtphagggiO2IiFYgPT5cOHnxOJUC8eyZV0l+6uBmSBs8WA5yvaPYUleE0Mj4awzez03mX2Hs5aDyLlKeEqIPqHS7Xu4H+tuYCfyZOZPWw5aI+rc0S7EuhHVvNU4OKzKvudQa7/HXdahFSBdKzVKkKkkzcf9ioDSLKMvfMR5OTv11vBee/vYhGAmd6RBjoR3OCnQzrIihGevk1b6JiiiARPfzdXIPWgzqe+F4405vd6l7IYZdGWHjNBp9bUTCi3t6iHl5iLlHuiAK6Q85i3dNmBA0KzmnXAARjJy9fbij9cIHremhRmRcEQzlI/ibfxP9vL7SnLWoBTegQ58ZXdOu/JF0q3DZPPPcFVY0Q7zfJ9Ys9Ut4KOIAsv/OAlMNFdeazPTLZIRahzzMKrSRrak0iVQSIGE9PN2JMvjGZUVyR2KPwWnDdk7oNCMoOubNGCB0xreJ51BDVemBCJOdKYdE5avsKvUU0HzwEpWRvB1rjQZ1qmqC4zMWqrJN2JJPA43Tl0LgOJltpbONXJ6JGhO+VRfj1O++fqnMccATgHufdDtvWUCd37bBli55i5ZI7M/x6ouP9ykB1qrPpZrsOT+RAceX8l8YbFjTUcNpIU+Z
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c408bced-fcf1-4e8b-c7ab-08db0252e72c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:45:29.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jARrBaAepPwTe07ARu1MRCPivC/V0gN9hb72JW/CxSPNoVnT8y7HZ0qYXH10VsAX12t5PloT7jLC+VmkoTsoeYRo0GUEws+FlsicJNHHFKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290235
X-Proofpoint-GUID: 4HDtzs-no2rS3Av_vVnaKf2YO5AKxjJn
X-Proofpoint-ORIG-GUID: 4HDtzs-no2rS3Av_vVnaKf2YO5AKxjJn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This removes the target_wait_for_cmds call from isert, to fix a hang that
occurs when isert's calls target_wait_for_cmds to wait on running
commands, but also ends up waiting on failed SCSI commands or TMR
responses that are on the iscsit response queue. When isert_wait_conn is
called the tx thread is down, so the response queue will not be
processed and the target_wait_for_cmds call will never wake up.

This is safe because iscsit can now handle cleaning up both iscsit and
isert commands that are running/completing and stuck on the response
queue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f290cd49698e..516fa37494e1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2500,17 +2500,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
-static void
-isert_wait4cmds(struct iscsit_conn *conn)
-{
-	isert_info("iscsit_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_stop_cmd_counter(conn->cmd_cnt);
-		target_wait_for_cmds(conn->cmd_cnt);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2558,7 +2547,6 @@ static void isert_wait_conn(struct iscsit_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
-- 
2.25.1

