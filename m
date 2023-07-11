Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915D6EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjGKVsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjGKVsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:48:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC93170A
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:48:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDHDv018444;
        Tue, 11 Jul 2023 21:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=gu1OqkvXhVtYJ7EGUuBrIhv+sMJBqzM7P9ziMt3eC9s=;
 b=nZArM3D3/wZPbr0YGrbRRhHyJIPJxb+jwSmB42eEDVmrhX+diGCSgsp7rGgIUfWG9H0z
 1btAkBLGLnpUHEPEg3YEH+xy2vLryTo10NI5JkF9QsqDggCEPHbjWWMMb6k0dsvA+MHZ
 mWr0NzTXsotuibhKMEUoLmxRUIKXSWfCBBxhDoSkDUUryS3n9MlxIiTbmYqVGCDhP3ui
 JfRBnMdPby0x5/k+yFry2fl7W6RQxllPOBujZI47xMRWObUfaZNT+paU7GaoLrRfqB2/
 /1ZwlPu9daF7vtHYdtONt5pp/NMfQ67KH6oKw66hD7qP869YuoHPYAZs58UVHriIjKge Wg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydtwy0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJt6AC004286;
        Tue, 11 Jul 2023 21:47:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bt2rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQRxzQuT2FmBLkYI/thTTf06ihqP5mnPXfr6Zyjiq7/5uvrbM2aLXLQKJCWZoQ3O0RDdlZC1LaLUh74gBGdT7Uah5HEV2AwSJgk33rOhUlPpsqzBlx7tHO3rPYsZruSAFF4q3Xh06edYHAr3cG65lmOhdUGTFNNUPHfxbMwaLeo0zOwpfzYg8vRzeTEv8smkC6kaN/5uSXs1YPgXuIScWdLc3flLU8pX5URq91sFnm5fXdj7ExT6znm97qqSWw2E04KipMOeDamUJo/FN5794bpzVML6b5kdpoMWnRCyv3wjM8qZ5mt0+zuMces2O3FPGQSduymJBwrdry3y8GY+fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gu1OqkvXhVtYJ7EGUuBrIhv+sMJBqzM7P9ziMt3eC9s=;
 b=cLZ1DfNBqwyN7E4xqhz7dxlAwTXeqnXVbKymO9dIjKJuZ2i3Z4iksqgfoWHTwLm/8BqRmuE21dx6KUFlUvXGFB4F1ihVrQpmRNBgDHJ9YYyioJwlzccvXxfVcRiN3YaPbNbtQ0t3qqa+e8TrODi7qExqGPHHbL2sRJMgMf3otY35waTkm6hG4HZUxb+YOzJMM/fjIzedZibiFlCZ398uffCazqd1yToWg1o+dtzqv6baQjjF8lsIJQWRwzNJGv6MApCuV9ImgrAxVWLjCkzGEF7+XpZuxH9sqelVHkupT0bFpYjbxaIxhxQ3BXo5GKhb/7RVpWEE8ohWcp3zf6CadA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gu1OqkvXhVtYJ7EGUuBrIhv+sMJBqzM7P9ziMt3eC9s=;
 b=r+6TpJAgTQpdvpp54/VTLM9xcCBg256EEtD3IlMpc9cIaaZvZwJ4v1vf57VycdfoRSgwYSEl8KOLk/GGwF+r4FCb9HD7xdyL7lB64mb3fi4MMgDE01J9nUYpGnLIscM3vLFuUG3Cv38eSHZiEC61SBatmRmbJTDXyUua+Ir4wUk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7436.namprd10.prod.outlook.com (2603:10b6:610:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 21:47:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 23/33] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Tue, 11 Jul 2023 16:46:10 -0500
Message-Id: <20230711214620.87232-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:5:80::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c3ce755-4f56-4d2d-8382-08db82586256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71zDvA3IscsaPfu4IVfEwjzsinbhOqUbkD0IFrozabxOaf8YcPvLdQvmZZT8AFA8QhCnxJyo4eMlILKby5VvEXdcFsBMgTOmcWwKQP9M8fex7XqlH5cYij6Xdkm/TN0Ej2wuBY+ErrUEt+yEdm+OwZ3nIJZQFkubOMVFbCgvth9+MvhNZyXu0anzQjaGRArKLLBSXhM9fEPgl1w/hcfJ6Zvu4a0F013PPT8tyhPYF2xsoOww8r/xEN4FsnfyR5jOtUU175Dmo5ERWyoohVv7x4hqs++nW16ENa1xkSbBjr+gmgrj0tvTiILy2zusgnjGT503+MPexeqxJJsUGGtVozJga9TpXm2A1o5lImAPSWzqXWGql2i0FtNA+XY3SfNesm1m+ac3LKWDd0f+fa89pSLq6wbSrJRk6R28Jc775N7Z3X9tpyqd+91MTWzbYS+PVTP38TiFOWmccQjEYMWx76iFAQ/uES04wYZIHhLs+rxpSJRd47nNJ2Qt5yQIy6F6p8UPKYKEZdoGs4lVF7FbpAAqAkdJ7tRuLr+F7EL5rkeYk8obVqtdvQXLV+QUqV7E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(83380400001)(41300700001)(2616005)(8936002)(107886003)(4326008)(5660300002)(66476007)(66556008)(8676002)(316002)(1076003)(6506007)(38100700002)(26005)(6512007)(478600001)(6486002)(66946007)(86362001)(186003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kLGmk5QyVjST+p3kM96rmnCG0eygBCLwJtFD+Ok2dl3EVktXNPmTqHU03ee8?=
 =?us-ascii?Q?PcQpPg4j/JADxj3L9LvZqvdPTJ8SJmvmeZ2xkATn5Ef3n+uM3Hd2NH3a34yW?=
 =?us-ascii?Q?0CjW4dnFXwkPqtZ/lWn2ImSbeoZeua7QE5YzOJjA9uu2M6yfUuxB3WtOE/u0?=
 =?us-ascii?Q?1dlAplHVrEq+bCGyhsJ+mGA/YQMSH2ZhjpqpMWIef60owh9XuDBMLkzImol8?=
 =?us-ascii?Q?2mRyTvPx+2xGRdH6XjbVGysXpF7DCQAIhL4lG0v0mzbCzvTLSwDbo0FkNWnQ?=
 =?us-ascii?Q?FnbX2CY5adI96qfM7TUjjPi36JVLu11BlnjMldlZvO8RgN61pan4+x3G4nfG?=
 =?us-ascii?Q?i1r1QUHioJEybPxQaIfhIV1JqftbZUCCzf82o5/v6kEG+27RoVG8+JUarq69?=
 =?us-ascii?Q?JQq8oVG5krIrKXx+9wAJD7tFXXGwcdTVCaURXUimYylFZz1yNA5bjVRr3iF/?=
 =?us-ascii?Q?3D/zCeAtCE/Whu7vMctx60nl7FYmCKFjkw5QITyqYCMIga8NgGklJerWYDkA?=
 =?us-ascii?Q?CnOqDzhZY4MBBRN/whEerZwWdp8dHyFi8xrXNCTlM4KkpHPDr1tVD2dmt/wY?=
 =?us-ascii?Q?0PdhpCUZRXFlQJ2w7dexU9uMFRlaYZnCwerPaSXlx1KkyuMro7jOdD2FbeAD?=
 =?us-ascii?Q?81XhRH8j76WYceCbUCzBBtAvfiex2c+8BMnnH+qJFjxscrT95JRez0DRkV3B?=
 =?us-ascii?Q?lyaOO+5/zBFCmDCGwOKmJRFvv2A5m+R9oeJS3hnP2f0aaDaGIM3DNZx9uyKd?=
 =?us-ascii?Q?HDzF+ph/TvBTn3uYYpUQs9ihIn4feOXNFBYTPStAyd+SbQjqNFAiN3s8w3Ej?=
 =?us-ascii?Q?kI/7HHC3zZmTWjWzK4oRQvSSzqnVao62sZy0pBezpmDpvpYO56ykOwO3DkFo?=
 =?us-ascii?Q?9XGhFKjsYCpWlPycnMkMJv6qpaDExnHmDtXg6Rn3WCueFPtBYDmbCvfAo/z2?=
 =?us-ascii?Q?4acehTt19TU5VgCcPXQ/hblrPbrwng5h+xNof3v4wJOqgr5tCbJYV0Siagtl?=
 =?us-ascii?Q?PsyslJCf/JO3r32KHwJkKDwkXKaIcVrpEIhj+l36g05ojuY1gtU39K+l81Po?=
 =?us-ascii?Q?6q8tJcv7GfHpp2Jw6BlPuIZAXQs7imbBpGT2JUNewmJlPAWjzKs9xYvS01EZ?=
 =?us-ascii?Q?qgaCdBHs2pR5daN+IanmBDJMYjREdb2CT9Z1tX2JXQtQUmiPRY++04orPMs7?=
 =?us-ascii?Q?RyqfJe4lwthp4tbOYWAI7w1rDdRWXgExNlL5L5SohM13AZCqQ0vKwxtir0us?=
 =?us-ascii?Q?V+QMUj5NFrsS7UL2jH4N5IgTqtrrOHck5iItplsxlrbz23N4sRvVqxPN/CkL?=
 =?us-ascii?Q?yvhy4WfACnRxDJmlaDxEl8nvq1H1rjl0LhqSeT4xh+DYK3tnnyfl4n+rMqTe?=
 =?us-ascii?Q?Ejv7T5mH5xfiUexDs0alMF4BrSzYXBfaTK7SSDumUcW56Ya97KtiuJxz79AB?=
 =?us-ascii?Q?+yqs6JhP5uYrqrrHMCmtEprjvkAygmUIZWPQ18LLcpnWlywuruF20wztrzRS?=
 =?us-ascii?Q?JI2WW7nS+Xrj1zSYQsoxtvZOPFIFpWeFaD3cfim7PvyHGcx+knLQ4Ak4aYoh?=
 =?us-ascii?Q?GW+g0QTo79th1N+HAhIYjZty4otE49oon4QiwMK9dPcMyQehCAwPVhsa5NQ9?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mxgyVlzY3OjkHxBnvvB57F1M9ohR5h5acf05Xr2kWjG3W78+b7NulFa0kPkteo1JLwXngBNXtmFVB2v4v5qPBue54T3v3//nBJUfGyivqD7Mctu5sWS3U3un009qnkmKRyrGmA5Ljn+uBEdQacSP2dOsZpjpmiUi6DE9ATiXBu4E1FIH9sSIt8BJK6F3tPVsV1VwPuG3vePNyuYNPurKzhCX/KqBYO5XJyJTrzKdTrSOpVT5djd1Yt2Opf3/lgWAl7+9VWMmytPILsvlkGJg8Qrd1BDKMpEZzk8nA0npth0niuWMYSF1f9TP2YY4h2ZRKDGBv5axoPJ32/L+UDW+UxDaThk06/cAGEGvv29f5/k/nZTv2QH9N9CgQATJK4zXQ6/RTb0GMT3XBCnPFNtw5bmT8bk1glAggkjLmClLrI4J57L7TZxGobn/fjNLyqcLNtcmZio/Rg6z4NRqUecinbyKu2KoKtBoxsiKI6aocd2nO+h/iltNRAtK4gEsrqpLi/pyS0kNkNyllwC8e125aPi/IZ8Vx611CSLAs3ZqqlCIbmQAtNjyAYn0JBJ3XCMljUNcUOtHLdq9Sl/0lOTSBBBRM80/h2/lAGgj55+tcVEgYQc6b71i3Ul8BhlI5GZ/g/W+PS8sadbD/u6Mv2pt7s6Z+yUbDQNeU3Q2hDNpypCe3EAZbvHdVxdMiQAuv/CEprPNIPoeDtWA1MuVDQxL05o1ThAUb1QyutmA12t22vxIwGbhW8M/NGBaAdkwhh/vZBPb/9iUArUUPxcicmwsckZgckDzWr236nyWCcFP0HbJmnoC+eHhvafDj0ZEhh5Iw7ChEPKcXY+9Z7rpvNh5sBa6RyJCflXrqZ/qAldJHrjdp6gnOAKFjQWBdSD4nGym
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3ce755-4f56-4d2d-8382-08db82586256
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:12.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUnH7udeetLmqxkts5oaTSnCI0ZS3TR7yQEVJhWe9kmymCT1I79588DpQv0OXZu8DFEC+6a7XxzZOh0zMfDnmHQ+wHc45EHWgF0FcNp0omE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-GUID: HRdJAuEJ9pxZzCQZ76m4QuoWuD_l9Vt6
X-Proofpoint-ORIG-GUID: HRdJAuEJ9pxZzCQZ76m4QuoWuD_l9Vt6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 56 +++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index eeaefba6c9a9..9646f90878f0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1412,14 +1412,33 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any oher errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int ret = 0;
 
@@ -1490,29 +1509,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
-					  lun_data, length,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3,
-					  &exec_args);
+	scsi_reset_failures(failures);
 
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, lun_data,
+				  length, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  &exec_args);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS  %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.34.1

