Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082A8C25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjAWWOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjAWWOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:14:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941EE126F0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:13:57 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiMrL022667;
        Mon, 23 Jan 2023 22:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gHmhyM9trD+AmfYLS3p9E/Y6iU9S9GdvQ+UOcQJz+0w=;
 b=YtSDviHohDdCLNBJNIEHWfgvERBKI2u7sQNe4jx/Zg/qOIZw7/FSbdKt+QIAAYEUza71
 x+oxIXb/BXIbin8reXMRxcelUTNwKwWXRg6ttqSstxh9AkxCHerbKCB1/WmFyMh0A22x
 PWVnX3T6iJoPDnMs7HmFvJewA1KsVFxYov/Bp4bUG65sPmyKjbxAL50t7tziY/pER3K9
 fEfjrw6PLpRfrA4DnRglLVTF1IG6bQyizFU9cA9cquj7CfAYayZZxEFt2u299osWgItS
 uf9lQO6qocEG97UtoNmo0Qef7mDgHHPXhNmpgoo0QvFf8RuTD23DG0bV1OqTlQe4lHZn KQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa4197-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLHUSE023144;
        Mon, 23 Jan 2023 22:11:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g45epg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0YEAZnU9Th6/HfyLYOB5h64LXXhWfgYHJAAd2joRvphEoUeHY9zdV46peOvdUoP/KrjcFwv10IJbx9szLLE/fYwrrQTLGC0wOSII/M3H2KagtFXFOniSrxDkjxeRSUpZbsXlcAHtKHNH3rIZBcMlEzjQprka2e7/aThVlQJlMI2pi1dUAIPn1n7HP/5oHpku7UGhp0b3ufAkbm3mRJbxKwMPBwFze9PzXekE+iLc721K+uNcQnOVHpBgD8yB+fKEL/yQK/WFsNLUoJLSMZfbt4srzn1xVEIZjCrg3eFEOwLRUgTFMfcJtPhBtAS1ecu0SuWiMS2C8gVHfFei8NaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHmhyM9trD+AmfYLS3p9E/Y6iU9S9GdvQ+UOcQJz+0w=;
 b=n6XLnrZ8TOWKN/UJlyKjIZM+21E5y1/hglwC0KVkK67CY6h3Cth8Okfjeoj35uFPuP6A1w9I+h2Kyp6Q4NEdpKTcBQ0ubJyJtdD8n5Jr7WkZ6F6puE2ltf0JGUU9ct8bFuMX8TdRpfMc4NR++80TN9IztnxIwI32/NilwP4trUz0xdn13cLLpQusUPnt37dg0+/F5NhiV711bRmiPl6iqt6IBca3zYVbeY9sXJVjKp+lEVdNiLn4B8/3jsy7Nlji24zTN/yDBxwK9Oyw3YLztl4qVqbB+16p0JCUqoCeMv4tKKX74Ny0DyAFQKBKkoMfuLB1NoxEHa16cdptzA9YFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHmhyM9trD+AmfYLS3p9E/Y6iU9S9GdvQ+UOcQJz+0w=;
 b=Nb0XjFhXiW8otfb8nz3PFZXMemOHGKg+jANnBbaS9hIbb+5VSIdsDD/lh3OPa899FC77bNbjOfn9Dyjz6oN2MfJpIIhpeE4/gCBz228rkz7lG9Lrm3glJ9HYTVyrTHxxXulGy50WOY4jvtqLP/0SBg5UmLXcpF+hAEh7+gUOUfk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 17/22] scsi: sd: Have sd_pr_command retry UAs
Date:   Mon, 23 Jan 2023 16:10:41 -0600
Message-Id: <20230123221046.125483-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:610:5a::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 848dec88-b476-4dc5-6adb-08dafd8ebf78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/Ishs6vtLwHJytuiEDqd8ADGuQ9FHNxJuj3He/zjdzGFWUs9sCdjRDFoMUAhkzC9mYaFkSbjeddCW3pQdckpOE3QYdvOt6K2H550X8GhLF3vF0QgRQsDHIoHE2FwuzattlWHpM4tgKNopogvnb35cXNaSQy0lf80zvJ9MYjCYfGsKNSCDx4au5yRBrNAki+EaW9fpxb48eTxjYx+H8YDCQ6zzJfK71yk4F3HA69CTqTrCNvV8GNzLs/KgtNNxQe1hGAmQRZ9UYfELGhC1aXPNqWPfVgx+qSbdl4bEIC9bjB3R2MZNX96mwnrw0I87sHU1/e4NtTZWrgU36tG0iJffpto9LwgcyMigzD1sqpJ8C8TKS7M4XVTNA7cvT5PKqhbZHxI9FKWuoMt0wwcgwYZBSvXgKORyd3ZVjw42udITkpSrWEkZMofXdxxFqJh7WqEHlzpqooIBx01XJO4w960ALZOoMujIjZ30Ng5Nep8JWu15FDtGZeckdPfE4mY+H5GdhdBag1jpWcaiTBJhgl5dWV1dlk4rS8OjBcXMeXzFrTleT4EvPAV+pOLDSSc/wBfgivvblPOk+K8pZHNHalV6wmP0g2i4p3s7QrypC+qLeT48Gb4tafBgjg/d2Am5TAnkEz8RK9+RC526mDt0GYBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+p2Z8r/463EztPIs5siAt/5aVeSUHEOsPRtlB4Hw1R8XBTulBcsj1Rsnj4NY?=
 =?us-ascii?Q?tPir01WvnkaDdzusQh/itLu6qVf1CVAkPqyjJ9yLnvywLMbNX+QNOxZV9xUd?=
 =?us-ascii?Q?B/96kUNAloa0zpRYp7bekENVeI3Yw+3j1c2yOGIgt+NcLrptSj1ahHidW7MQ?=
 =?us-ascii?Q?jR7GdGR07XYzcYmFYgjEq92wgEaJkbCogBoS17zj9ZKj8YxqI9Xx3F+Zua26?=
 =?us-ascii?Q?bXPOGaqFZsz3CRZw4OooGOJqdfIfcoYixCvGWVca0HOS7WhubpT9zQ195xvx?=
 =?us-ascii?Q?JpOZpJ5rXlHNE/27W/OF14hGTO+Wxwzmkz/efIeDR45afKB1iNrw4X07e2oT?=
 =?us-ascii?Q?fOrjRr34kgkuPWwHVppFfZ3JdYaCH/DQuNWKKRBOvjEWGFXeLHaLSna3Ytav?=
 =?us-ascii?Q?AKlnjJg/kxLrGSqY/6041MCW12VediyjZKh3ndtZzBPIQSG8aijKfWhMVGOM?=
 =?us-ascii?Q?rEux0AG/5F2biv6TEyfc+jax4wvtRZm1mSkUweQqx7nvea0Tw5EpX6oGZwro?=
 =?us-ascii?Q?5+Bfty1zRF0PKHkzAhhh4y8yP4xR595Z82GH6YaQvw9ZYNj7Gvmk2E1pXI6/?=
 =?us-ascii?Q?XYQL82dYoaVEpIQB02RjF35WnJz3LDSfQZXtDomxCS7FybYfe0aGmjSi58Xo?=
 =?us-ascii?Q?Ja+3xll44wy8+uz2x1TnhXjU4Uyv1YFle/ALcTAO8MXcEYgb1T+qCefx6+vH?=
 =?us-ascii?Q?JjnYof1b0rrJDqCb1iOWBDFA6KDjvD93Z3Amge0Hc6VfpCDB0tN/NOqEvcxw?=
 =?us-ascii?Q?+NTa+wZkJJ3GyulWWHDRg/75tveU/fNi5blVCkGqIm/f29f1RBYYW4YVOj7A?=
 =?us-ascii?Q?KbCyl8zQtw09VArCNFnokrPwP8285XQ1WV5NKZKiPb3DRPNEB5LwQgDehkFe?=
 =?us-ascii?Q?FWryppK7qmyFt6+xcT78bCfME+8wGcKoTM4W/+h1+RaTQiJ+QkCBYQIwFw2n?=
 =?us-ascii?Q?Y02J+eoOLf09UAGrsL2xg/B1JlxfnxRxaqr1Ax8FvyisyrXXYvIOwdZmVHFS?=
 =?us-ascii?Q?v1ptqs4eZnr8s3zO3AhDCmn00vQKMUb47dLtQgWwuASBjZWFJ3kK8IhtgjyH?=
 =?us-ascii?Q?iuk13Q+/FVt1cuiFiPp8V9W+m5H06pJ8T1Tn6y3eFPI5C6GsMQIhXsI9QldY?=
 =?us-ascii?Q?jhaEfZ/9Xfj/csmOupYpi9uW8V+g5RKhJ2D+1TqtF6Z17X3jTpk/MfWQgRfc?=
 =?us-ascii?Q?KQlCeobOS4dLvlJPSpNFWhGCJDb2VkU+i58bY5DyB+UtfHzFkzl9HG9COXLU?=
 =?us-ascii?Q?JY1n/ZJg4iAZQbXOUBUT+p2y6QrE3gmCPw5r973wkc9K/E2hELc4jjwoA9ww?=
 =?us-ascii?Q?mErF6RS/w4U4cVATOPu9tUnkyxWmVLgaygEFd9ZXse+jqlHJl5xCWFzhXD/3?=
 =?us-ascii?Q?mWQMzigMWpiK4cn3cTUhTh8/RtKvKIiO/KrWuZMFw9T1Jn3m3Wl0sgCabiCE?=
 =?us-ascii?Q?urhFQn6Df5HQCVrJYeqKQgs5ylJOM5rm5rBe+fsJ7jBvSBsxEroa07wwPBQv?=
 =?us-ascii?Q?GdgCDCI9S/9oeuaF64c8SXIL8uWI97NEJUgykssEZKnYz0NEI2hkKORGkPF0?=
 =?us-ascii?Q?C0+KW56vjPfkt7xVS1WpWgIJOf9tzZXWUCsQV1vO7lxd5TqXqkhRLChvV5Y1?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vnIul0MMViTSUDH01kEKRIub0VLuVaooSKLC1aEWI5xaDmyOdRQakYWcq4beKoy7SzXBvN++6KPqLMm3POAARPwm1d+fQKDApeTCqMTL/OqtzuxXx+uYoeZ4E8tB2XCadZyonSe6xEAxF8PIG1cX84kLokc4dFwxfGfsan+GW3Y2hTHkzUxYg59WO+o4NhR46HUPk50TnK/LefbA3ZAzLeQMj6/tD6rPHS4dZleKOdvoHNlSGy0mVLuJcukwsrG9GEjCg1qOlQLglsA8csnjQOs56sZUaApJCSlPyX6uxjk05InokstjMrE0sSPb70aUZjLDO5BQcayACox7Z+Fsn+a0AeIp+sUVYem9teCJE1ejJeBi/H6oNqSbeQwS74NxVNjvzseCuy4QK2NI9p+/IcNinGHf7IwiQG4kUt/An8gNFLJ4IQWBt0yt2xonsbnmjoNcuc+Sihf/7mQu6DTgG6220yY8CZKSlFHaZN3DaCa2YOnKl+T6aWmy/hH3a8dcvdZFpDRgJtUljStDKaNOkwpCm5g6J/hEc9djXuhTVOmn6hqJxRo9OvlO7qrssH82Ef5MM9FmCswFTY8ENYyyREr+mizlt6CF4+dgeFwN0cYqag3ohMVqiuZmxfikxCDfSYPZbgiJD+bPBvuPXmiMmOg7Oy4wcjhcvnUAQVwivGYE/eAEy1kZA9oJIkq9gGKPI/Zy+tqmG+cuhlFs7gyDCGkAiJ7Pu7xbsi+OyLmmSP6P/VefqC2px3UTvHUCsyRIpVemHK9rFF5/lR/UCT2WyNeVyFUiKooiJ4CmWOKs4IWnD29COxUfzEWtB+mm322qry3pkAW1LKL6GGfRp+mjgPOV5El8pdPf/4TSEKsek1b3tQhxS79LfCauj13S4B1J
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 848dec88-b476-4dc5-6adb-08dafd8ebf78
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:16.7744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5eUD2QRJCfth5o8cGgvcgVo1pVqZHURy3MKWAkaN7r9GfG8kpzRy/eh1NguJ+M+GexMls4d5jxmR4KMm+GSYfkbV/Mr+PTQ+Zisb3YyFAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: ss-wF8ao-7sik4Rix5mLQ-_6bAILew_0
X-Proofpoint-ORIG-GUID: ss-wF8ao-7sik4Rix5mLQ-_6bAILew_0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 63d2c6ebf948..ba1970283966 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1747,8 +1747,19 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 	u8 cmd[16] = { 0, };
-- 
2.25.1

