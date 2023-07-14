Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B89CC001DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjGNViS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjGNViL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D930358D
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4Vik019246;
        Fri, 14 Jul 2023 21:34:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=QnApxjFn2MRiD0R2l3EAMEwbfo+TS9PHUPPqpFCR5+o=;
 b=uy7llSc3XxVIgDQcSGdm7iijjB0SPqRT+wACKHCm2m9/9kU/Ujx14gpfdNyP8L/Wdy0K
 KHRKe5nJtjCRzmpp4zQCRIEB/NVnrskg97h3nuFeU1ZkozVgeENv9PQMF6pVt0rJsNd3
 y89Aj6rXqRm9vgl8t/tFnkqGPEabgtjBd6mZazR6fcDXkecEc8WWfkQXdFAgs8FmEiIk
 rpQZu9/tPyPcWPyFYPh8oRqhEO7MZnd9bMFuKVl1U5ZpJazo5JzdvI8zLJVxvQEFbHpt
 rGhz03uidfmQ7BPkfuTWGpMJ9X/O397cEit3UAQ2LuypzqwRQFV/HCOyXPE2nUxVrkE5 0g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpttjfgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK6nO5013815;
        Fri, 14 Jul 2023 21:34:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91v0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeBvyEMgjx5vXSAFnDXdNmxeuCGMX4Obp3gl9oMhBL1RyffmNXlEdf0ZO4GP15ql9x7bVCKq+IGTFgAKJTj5hdVU5wvqZkiPWVNI7EN3MPuwlAyO8ohIYZDl3ZviJDGT8rHrx4728f3UXS2UJckcRAsxJ98xGTkoPCCsH5rDz7t1EzDMfb/x0hgtJF+aMMMEFjnv99YYkhz0ChRoJUP+kCmxR7AVEhu/4ofQubx83zYpoy7FudvuCLhWWcJU2MwHN7npC4vU+z3eHOoAlpuRwvJT1kN96siYy5DabRycLIwnZLSbvdz55qmwaahKYLqvUEePw4nj+Lf+x4l/KSUjQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnApxjFn2MRiD0R2l3EAMEwbfo+TS9PHUPPqpFCR5+o=;
 b=j0/5EHYWbHCnzO/mwo+RYfjU74HaLRcvixSIYtz/D3BVFEcEQrsQsl+iEYBMCuMh+og4D2r+nIFDxvJUZDURNKAJoWSIfjWK48UIlE0wSHvioZRbhTmBWZF2+kr2svEBu2TTyJxxEy/fb/kHjN+sT1i74NFsPr2z9a899Xk34ZmPVWxXa47CyRrpFwowwjbRczMB/8t2mUIOdC5ldWZc3CRxtSuGPun4BqvxCVf1jX1GNNi67UUFUPy6TYJboA6NF7aaMO4LYMvEdYHy/5SER6ekdyT2r/w7XIy9C+AAGdUPE8ICz7MqmT29TlSp6J1s9rEjyPG6nxHWiccN1paWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnApxjFn2MRiD0R2l3EAMEwbfo+TS9PHUPPqpFCR5+o=;
 b=JySy/dAoCJR8FB3pR8aX/mueuVrBnWQbn7OedQoIsFV0bo8ehN9MoEAMvpQxbv8CDughQM7n2G1wbrnTZKFe1YDHf1FTVHyMNRlJBnShBTLsrJov761MtC2rvobMPRO0c8BZGgGg5tdpwbi2wQJbFBx5aVXr6jMQnc+zEFMMPgc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Fri, 14 Jul 2023 16:34:06 -0500
Message-Id: <20230714213419.95492-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:4:60::49) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 50a53656-d4d5-4f24-f060-08db84b22ab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zr1NC/TsVN3Mpg+s5X3IX9H4qBo+ddj8ZphZwFH4p2it5+h2c+btGxnK6m20YGcIyH9igPS9rzbDtDNGybVfTjLoD/lsq4i+ros50RyaOZiI/qYr5YtRcYRGIysKWIsVrawUzj/SoJtDYuwp5vwVABTHaaCkK+PYgEbJNOr7qbaiBWX0sz2KLZMhXFH/sy/N3UT8H1Xj3RnWMXiOkyT1VY6ls0XzjNjpbqAy/pqueiTd1AGGJZccyU0EWzlNMASTYANVXt+YcggikTC8WpPuVmlv+4uPvvEs035awlVYv7nNbRdBe0CLJZY7NBfH8ZMb5ah0o0yIMef7voFOiR4Ed+0Tsk9+4M/qVqiHTBW7OZIr1Wetaq39f7MRwx6444w5Os1+PtNbB3kehOlLhYVWFcs+IaByMUb7q6BnYl6qvOb8OUgh0xpVb6x/K0HronbNTYczSD/9P8TebhvWFH7no+1vqk2U/MOziTD9ePbf5IdhftmmAy1cHfNA+gNWurIep12nUwwjDHX4RxLg1Z5vTpkeb+8vm9ECSMTFwYooqizpuDGbhjxI5rrrYUn2uMT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fg6LOYaNFA2N0tfRyFY1gn9Qq/U56QArfv82ju1YUhQPeXHtvp+ub2SlAPAN?=
 =?us-ascii?Q?1bYevnpXNdspEDS3zG8T+RqnrXIhSBnCPxBtbVTWer6NChRHEtWnZkItNl2i?=
 =?us-ascii?Q?B9lnqd3GLhtQQh6z58nMQmP9ZK+f7t3ubCD4JE4NKkV0b2iPJYo26FhYCdxa?=
 =?us-ascii?Q?d/Pp3qcrQuoe4pQW+1yVrN9M7UqiIC6WBaN11N2dKfAyWUFvYZKq92ZwtJi3?=
 =?us-ascii?Q?OXT+IQj2DjOGuo9CUzWSau92oClFNRZ2AwiW0dRJfGNaTXYHQidDjz1Mvt6H?=
 =?us-ascii?Q?vJ3dh3ZyosKt+6OQv7k3Nr2Nhc2LMUf6lcp/33/wauAIxLHaUZcBZpSpyWHR?=
 =?us-ascii?Q?oFJHfHkkz8PLv6Ysa7KEnVSHeLiKF9CrVf7KW3bY/S4BcNJzSgmTsdTc1J1j?=
 =?us-ascii?Q?Rx4BGDnSGGvqpdfaRESLm8C3VSbtL02kEmHp3IkdIFS/iaxxadyiORLnUaZo?=
 =?us-ascii?Q?9Pvd+aGBe1HI9v6KEsuZ4jX3X0uTOdHWYfA++I1lDA8FsJ77Z/fu8X7PkZwm?=
 =?us-ascii?Q?V8lvsdxLH8WhR8r9aDiQFVgEUNTairbk4pYS4fO/Atr2Dd0wDbUGj4prj3i9?=
 =?us-ascii?Q?OAQBU9MhLnKmpkA13fkkgm7E8NBXC5GsrWfl+rWY2EeCTXB3xmQyKDZlhRtY?=
 =?us-ascii?Q?czHqGnNk6dD+wTQn7x6LIVy7n84xkCNzhrTtNlYVRZbnPlN4pVupBNAfROJ1?=
 =?us-ascii?Q?oPbHNCfT/kJL5ffcaYHUvDb3OxLirqpqK/978G6XZDsVb+vYmW/jcsByubyM?=
 =?us-ascii?Q?V4qhyCQrdn7O5dR4nS0VtEO/AO5u1T15BXCXPpEwudbKGEkOccauGUt6QxBY?=
 =?us-ascii?Q?+zyLRojhAr8jlLcLIEL93JdCpRri26BnOBg5CNO80NLwHekJ63oqAKOX5/Px?=
 =?us-ascii?Q?RJA2D1t82BqfDBvwGRsYxC3gj7C60pAFZ8xU/hwCPeb0iDuLycALrchY9zP2?=
 =?us-ascii?Q?inlaCYjSg8rRo0OQHqGJ3EzQFuI3eAboTvitf3ip5g5eI/MDN5I9uVOt0Thk?=
 =?us-ascii?Q?U1ikJwD/w5K76MZN+lHaN1OzVZaPk8KsDMFNJSpCFRJJSRXvcvSh8dHEIeRp?=
 =?us-ascii?Q?CtbHgI9EGc7QBgpMo7nqdqiqj/8rMOjqc9MVinr6lxjhsuN4fsciDX69vEA+?=
 =?us-ascii?Q?jA0yX4r2RrttGCXcNbxaA6WxD3qo2N8PIqwIVwmtqaJ4jckJjOEY+olqkBjv?=
 =?us-ascii?Q?pkwBAXxTrRHu4J+CaZfKdiQ1e41CR4qZIo9EtnAc/rwhsVFVEFcw4iAMx6v3?=
 =?us-ascii?Q?UoCy1usMhz6Ml1mK8ScKrphlb+0is9JucJTln1f97hBQ86YsvsXPGwoi9/tP?=
 =?us-ascii?Q?JV3ERmoMOjUVPiAjsi/efNJv8Pcl7Cfo8DrKUPq2AZVuYNhik5MEfxfdvi7F?=
 =?us-ascii?Q?F5Gh/Nx61Ez9addo0W5rVsB+46H1WR2dhSDRyBPK0oDYZr1EgEhwFYt3Bsyf?=
 =?us-ascii?Q?ZInxz+XLJc7Ro/tm8S9P9TKSZmOfwzdahpZ4SR9vN7oB7YVfoUhbzzAQq0E2?=
 =?us-ascii?Q?QQ9QNIhLXIqrJ51TeFmnwfgA3jIVCuhCSn5llVOHI8LhvSlKm/3WWJybtWOH?=
 =?us-ascii?Q?YjpoZrZiJvUQVyrehX5ykR4RiosEIcfaFBXhRtUh3ubIKRaFs3vZGzyKCjTa?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5faiXmcsMJOeeUqpQeJq/WIBqfmZyGKbtoSyl51p1tTpUHnoUanymwjnryGtBB4x+AU+Dnmwk+ru+sQqvse8JpeB2Zc4PjrwbgmT3sVQnwFfGOlBlavteBlQSVLO2k6SrslcDvkbg0zL4CPL+vxSeUaHwNinyDy09/0SOWsjOaRjseyiyQjLqX39x7fLhSlmEQe2FC4/CfISmdb6CGhKRYeLr96g6QVzUO3wY7zyM83X0rNAbhyMmvemF+mGNYtVlCuNFtHPbY0LIPfgawvT8LTTvU7IA9lFsZb7AeW7qwr1ZGVCE978x+JDtj06FKKhCMA7Mu9yBv1lu/cq2RhEmyK/T9EbwwiVd16rcV8FbS65nwCLzAnwhBsOHpbFBswKKJIDP2O7wqEhLwNTCLnO5os0YbH/eGhOgsqElWGZUoWehtvZ4pogvygbn9gG3TLEYjI4E3c5s33XvhM/TC43n15GGJNWnrtloqo0oOQYw5U4G7f96X8CZiqFRMGcyRGkTkE27Rvhv0aFcntjjfwLqlywx5nolpNV+BCXkJjUhD8hclVIVJQJ2BXOHF4JVGlYG1DCuqa/tJHMciDMxDUrys+QbEy0o2WTsItPX3vz8JVGOnL5LXv6dAjTkaX+84oGCPWJHgPQhxyAhHL7V41frUkyp763B4M7DURaClgRJOSUWaBy9NqTeWu78N0GAUe7lZM2slIo8CITd+jigfVs9qxmoW3ywgIEIa6QQyFMGZXlD6SxSvBqdeOaLFCIJu3Qnz1FkmuKrfLuoRUBg3R3JOpfzutQarDhdoCxFFuWIl3rQ4gH1TlHKyKOZ+POyCKTm/mEO5VAhK2Mdm4pOwleSV4t7IQRIVyJHe6UeggBjo23ZwTjUNqwBGBCXrrwiZ4m
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a53656-d4d5-4f24-f060-08db84b22ab8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:56.0322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwRQvxF4dJSJ/apCqCj/4bonoUV0YZoNLmn5vv8iFt2WrzkH9zFWt6tAf0+PQSrWrvvRHzbBDTWrzI9Nuy+zMGzvnnz7sT8BjFaS8WLCCks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 9ZuIdyQNNjx93CdSFPTEC8elA0OXOlZQ
X-Proofpoint-GUID: 9ZuIdyQNNjx93CdSFPTEC8elA0OXOlZQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 1a998e45978e..8ea498e6eec2 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -185,16 +185,26 @@ static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned int buflength, enum req_op op)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
 				  timeout * HZ, MAX_RETRIES, &exec_args);
@@ -204,13 +214,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.34.1

