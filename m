Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164F2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiC2SKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240427AbiC2SKk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:10:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC641ADAA
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:08:56 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsK5B022185;
        Tue, 29 Mar 2022 18:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=kvd3bTvnQHtjazNjw39p1ZUPgxJrfugP5PHexVx/GvY=;
 b=qHssOGnNqzKOoCX6wIvA+e/v9g40Gov7k7+j4x/daHwTFDqfj8Xq9yS0BW59Gqb9g513
 80Z04AuWT/jhNoHL7KVwK+Tbt33edpBG0mR/rGxdNglD0lBbRlIrV2LivjEBNpW2xUrX
 uz3RBEWql68WAn3d0TIthuHNi0DyH1aZb7tPvKcWdInWwgFeZ3u/k1q2lS7iM6D9ip6j
 d3a2DDEu7keDerH+rm4efsoIeZ0+hE5kLI+j5u7Cqzdz/vkLD3Z+6HxeT0wf1t2VNBuL
 64S6mq1XAqVgefkXZEGOn0T7g9oo6BZIYzXM/85kQQ6OXMeqaKPtIqeMyySLrreVZDR0 Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb78tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJO048570;
        Tue, 29 Mar 2022 18:03:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fky7sAl5PiTfmpW5iGBM/Qz82C2Z4XctfR33T59qu3+0mpSHp3vWPAzsYXWo1UqVCvbJ2ntD0dsT2S0DxyTw5xZHe5cDiqEzzcsry4cIuFSUXFd6I9BfXrb730BsLAsKnq4TtGWrgUJndl13i+1tROdFatcMIIqv97u60vO9kZMWjITlhLlgpldSrMJTeCLsY6UMN6R0FbY0O5L5kZCW9gRLJDudOdSqFV3qgevlm05MnFEFec2/JOdpFAyn7LV621WjGbGbJiNsZBF5FNr1Zqq83URiYsjGecBpyyTOE+5Eci5w/W4dzJjFyZGZGJlS31NwYxBIz5ChkEmrbJYAtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvd3bTvnQHtjazNjw39p1ZUPgxJrfugP5PHexVx/GvY=;
 b=F1IDdjd8mb12wLb2vFR6RZnb8qrEtcJSuLCKNwxn3In1a67KcZbNCUY6l0xSnoYsbvQuN0zIVu5lWK+HHsE/l6b1V6+cWzVJqvOS9qA9vNOPEK8QlK9YgNrm5NgUZfn7r863soL7jPSvsQIaEjihY/2FrEJ/zEoif4MGz+CL5PNA5ZZB+pu8A+VbGTXaW6y7xnMfpUv898f/YCDqnz2M92nlY4zPFPjLhuuosfZzVV8XuG3algNWUIT5VntPLKXURKOKqY+lUvNUhER8lPZ9+gyqbnrtjB7bllUfW5YJxr+ns7uTezcOEQZ3EeKrc9/N2RmK+1+jsJvJKYeCDMlm8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvd3bTvnQHtjazNjw39p1ZUPgxJrfugP5PHexVx/GvY=;
 b=SKgvMGbLar2gCPTRCLp3RTFcLObw2uRZBNsmhMbd3Hq9oLSPlp0WsY1H6VQl0Y20gWhfHOd810vy33cTCqwx9v5kBx7DX01CTPD2k5+nLf7of3rlj2MHPCNc40jZprVniw72XfkWPfpmUNg83fWG4yAF69s0SJ+JUEOFv5CFCiY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:40 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V3 10/15] scsi: iscsi_tcp: Drop target_alloc use
Date:   Tue, 29 Mar 2022 13:03:21 -0500
Message-Id: <20220329180326.5586-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9c7617c-fcfc-43bb-f996-08da11ae7422
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584A8306FAD98E5A6F63CB7F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bAhjypnIKCpsxNKVvXhUBO/bloG/Nc39T0ej0/pWnSLOiVwmDe1XQSCWrJ4SBlMnmHolaALk/AYe0JA7P6uJwtkXPvDCtMaZUEHMI94peZj2Wr2Delo7pQEfXRKB5vw4sGGhV0Kz53eX5YLbxHNMscJdCYO47XewW5w4XShFN5xzhxsPx2PLml977K289VfdjG+oUgnP+i3NLh+eFYTD3YBODHU0sfJgUHQfcjlgSo8BgNBxbf/XVXIsSIfhSL0EFctLLaAyqK5TZNAlY5MlK6CmQeyJmHJeX4GQvtEYQBNX4po022PVLUduEGdFmuwdRZuKBcbd8XyEGEwcqrcMf6iU0qZBOLWn4QMLwcReisKu1HozqTorVYesA3GFnyDofOPR3Px5tplqBVyHIjKq8uum+Q3pli5HNyeEuYPhN0mH9Z+yh/SDtvguw8NkT3x6EM3Nli+I90GNZszAsUF5XHnWr6RXz2YMZ3i4bb1Fc1oyYUj02LmNx5PChPqJkWZCsOnNMYxV9f0oezX5BDMY4TY9EjsxB3d0suEkFFL+CwCTMQtzcGouSXGGHhon7NsMOgjGHxVJiHZXGXGH+gCwKnFOscljGEPiZRp7egD5hsLsw5bYlu6C98YXsLDIYkHcczDqKRipV9wfIYfuaGOvoAgvj21EgRBjnEkMvtEU5hIBDl6cOjduWVOmECv/FUCGNqkk5/uwwx22/dCCnoihMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(54906003)(316002)(8936002)(8676002)(6512007)(66556008)(4744005)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CHqqsUAhrz5tb8q8+MMWO0KqE/bRpWvoaix20YxPCeL1csExzIpuPGhlXXMb?=
 =?us-ascii?Q?t0HwMZSLI/54IK+5RUB2zwzz83b84RVLUWicIKAM5QJnh/LI4QieokPaBuA7?=
 =?us-ascii?Q?mdku99iy8oCfnb2lKrQm4l4mIDhWpWW+dZ0lMR/qOiwP0Q5wPvts/cBb2mcD?=
 =?us-ascii?Q?tWV+75vigDNxVEfcr6gTUwTzPSQMg8+mJgL9UK+2brMNtWbDxkEUc+OTF5Ub?=
 =?us-ascii?Q?bIJv3ypNG9zNeVckl8BAVlXNx+RPe4tBUmX1S0Jn+YO9eMAWhNNB6Mh1F8FR?=
 =?us-ascii?Q?uid3DL3SIOhvmscmPzHbnlaOQlANBoC7bO09NuuObumZ9Itn8Yrw4pP72LJK?=
 =?us-ascii?Q?i1VES2YzgQO47jcD4rhYHViKeDu8vb75SWqDsQ/jfyI747bLE3mnNyRhIfBv?=
 =?us-ascii?Q?MC3IrBDDEVrpE0VSOCBi4TZUBz+IuDWvdGVFwah40VDArFmBdITw9JUtPyHd?=
 =?us-ascii?Q?kPr2TDxTPkNP3hh6O0uwaqDXU1Mw5Kl7ySpEENZSEv3apVKtz/+d6u1ljsPy?=
 =?us-ascii?Q?r12nEtOLQpmyftxSR5isCApvcYdPDZKagHiEscO0IrSj8/SHZlUZYfgDBBRe?=
 =?us-ascii?Q?ZyGuvQVhNO6Gn+lOqW0hq/PoNOqTfjnEl82XjpDdkqtlwygLSyS5UoArp8a5?=
 =?us-ascii?Q?XsO5ObZ4Up9qqjU8KYM6QK57EQLhAWpS3/XmpvBuYWm1+WfQ5hFLip041bG4?=
 =?us-ascii?Q?dHUQqUOxFYwHyZn44YQSBpJRTvPimPdFwgq5WGSMV+aXlx5uTAkzrBOXzfev?=
 =?us-ascii?Q?a8Vd8IcU5uC5Q+oITy1c8CGPGiaONeOpGP91XesRJvQbxkuvbWZG3bbxQ0Zk?=
 =?us-ascii?Q?eUGR8kGhW8TS9MLiFFc4f5p7Mxa8F0YhrOttVTakeyfNTPBWjBynUSetKm+/?=
 =?us-ascii?Q?juIshJe5EvHhTaThs9vXv7VZVMN9PZzeyfxhM7P40plyU94WZBpH8q2hqXSX?=
 =?us-ascii?Q?XQO16dJrJPnZRA8l0Sze97XQvi9pHqCw3DIHwTqosE4cdT057m5Jq1ZAYjog?=
 =?us-ascii?Q?zcAd2RRBqlpkk2jrVsAr9UYTBdOPIFy4CXbALpMD8ONGjFECG4Sg3YAaKEzh?=
 =?us-ascii?Q?GG8//150hI+8ZnWVyjgJXW2OQHxfB1vgKcHhCHFjVD6FTBd01HBFkKNftxEL?=
 =?us-ascii?Q?r5DX1kk1sRsi8pYpW/XEKmXGzQKOihwQmriVCMav7zDlOeQRZqix88bT60WV?=
 =?us-ascii?Q?Gyf8G2AYO9/8JmWdMz2nJ19CPT5a7poF0O4YyHwlsajeFWOgxjZRIeMwQkTp?=
 =?us-ascii?Q?zqCFCtriibph3Q8Ac1dycfVKNEa2cNYfKS5nnfmgiyleJSW6Dgz+AqvGg9Pw?=
 =?us-ascii?Q?DKP5MBtT++1XLRkkyFqfe6QyIwlLTLQE2aQ+vdql1MWzf0ocvk5cR7+m6lqN?=
 =?us-ascii?Q?jpQgqueCfiUomPBBeDbSd2Z+dlewQqn7Z2DE7lOUpomyRK1yvTuq3UArK0Mu?=
 =?us-ascii?Q?K/hujtSqSt59s0oXotrFqiBIIynOeoGKSGCYeAmoLEPeU+INVAaoYQPiEwal?=
 =?us-ascii?Q?fJMrHvN6i/M6INs3p3UCyYpq6BGePFSIhHNYM4BTXfOdEvzsrFOSycbq7SuF?=
 =?us-ascii?Q?WIdAWw53C2Ap4R7sVlnaLAQNxBuOpNcEOksvxeCPrkb71XtdsnlbjMrQQG5p?=
 =?us-ascii?Q?v34/BCZBkQn9LXxQ7QbR7+BTOR8DeG4EoXS57KbQvPSaYrGQ4M0ey+5Zpbzw?=
 =?us-ascii?Q?UsaRs7uHhch3ccP6A2HBPQo1aTQczDIIzcFRKRqq1GJXx5yx7QPFyf2f2wDQ?=
 =?us-ascii?Q?5Cfiu8vPcs5FfwZTlFDbIucQ9j9geg4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c7617c-fcfc-43bb-f996-08da11ae7422
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:39.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: da+ogg3WIw3UN94TSf+CQwxP6gOhLQLghveK5diFBPAd5YW9NzdaMjEQjMdzhVQzTgifkqcrHPoakcrNniki4/TjVyZIxjAJJFvYqyOUgdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-GUID: txviblKk8WYhN5PkjGH82XyovIQ0Zw8w
X-Proofpoint-ORIG-GUID: txviblKk8WYhN5PkjGH82XyovIQ0Zw8w
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For software iscsi, we do a session per host so there is no need to set
the target's can_queue since its the same as the host one. It just results
in extra atomic checks in the main IO path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f50c00f2ef9b..69218c8830f6 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1039,7 +1039,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
-	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.25.1

