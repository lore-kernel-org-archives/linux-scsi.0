Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C977FEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbjFNHWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243403AbjFNHVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FC6296C
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:34 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jtqP025337;
        Wed, 14 Jun 2023 07:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=HjHtE3y4vchkhka5T8ZdL7UBs6JBayCce+w7/TDIYS4=;
 b=cnLXWZbT17eS4mrssi50Xrp275xJmnHRim604ChhivrfCABZyGZkcgiHxAva3JKAl371
 a1rh7oTB2GUWlyDZXLQfQOeLLQx5fm+cxxDXCd7+IhwPhy93BDVB7DgRVDMCdcU17EyK
 3YGkBCmneZQHxSmtM+D+gLjaGFnL9+bSITx6aIvmYR2pFqBTKFUqYvZFzBj81lhKH2dv
 zGt9kHNRGYKBKARQabEIFaDNDBvOlETsnKIRUKqg6lm5WT1uNFCbFDasTSjJBdwljc9e
 oZRdmqtSR5quYH5JvfgcpYLPIrVsYmlJCAJwRWU0jlBYZmpPUtFit0sbeBNApuoRrndp 9Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7d6vpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6QHLu016326;
        Wed, 14 Jun 2023 07:17:52 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56pmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CE/wlPe3VmfRrZMMJMdZgnI9gKw5H9YtzCk0fGkwxV3DHz4KHvT/091soui8EvAD5EJSF2WwNcSJhwoTdy08GdFc/Ugw6etKcfzKHw0VaurLYLxDAn7688gPBPFnvhaZ6GnCNALMQ1qhhdR0Y7aM8D1dWzEvr4OWISVWhZry2gjYftEa1li61Tc+oVr2YB+Q82gwMkI1sE/hWqGC1uAiXBCiLt1WxdPABLyoqdvCfrJy5pUuCD9BcBmdtNpovguqFZR+tj48y070eJEMz+b8LOwYPMPq6RXwm4W31UOXISWI6lyEWG4TinG55n+/prG2w9ZEA6N67XP/h+ZRp3ohjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjHtE3y4vchkhka5T8ZdL7UBs6JBayCce+w7/TDIYS4=;
 b=Dq/xamZRh1JBMY/Ere3u6rA2nURr7N9Dy0rXahYMwyUrV8O/oVUtga/YYMR4IBL2AxJ5eXgt3os0mgubP21U0zO4Z8bEvc1CoUy9WVG3eMcoU8ra+yKFdbFx3SJmAN836qOLmcKxB4yF3x49sqrNMH+PG/4xKksUodbnGPguu1l4fYROBxYvcbOgZNkwj1P/OTyDm0IJ9eQ3hTLFZhlB0C8fGO4jfcTzYR7DFLqFCNmxqRYktbx5M6I/uUqe/pCE3KbEu8Ih+rS3scUb56kyXti7fIl+WHqrmXpCnLsn4szdkfupjS4s+2HuGzd1EiRBto4b1+JaFmsFsTWk8uSVRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjHtE3y4vchkhka5T8ZdL7UBs6JBayCce+w7/TDIYS4=;
 b=fvW+bKf83GRwTDTjV54q71lu/xUDXmJVY6LoZYiT8I1gkPV0Uat+9nSBnWF3c493uFxuzxxtnMmNsmh5rm1TraeTEUh/pInSs2PYYpCtURYUxanm6CJWdjQ6W5cDVGjfVWu0BpXwH/vvw6jPJ0cqxLlTKaDDw6fuV0lM+9yKGcM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:50 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 16/33] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Wed, 14 Jun 2023 02:17:02 -0500
Message-Id: <20230614071719.6372-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::25)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 231a909c-dd22-4230-b0da-08db6ca77609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGjF3hNYN/P1yf1t/ri30xKfE4XhrIx3PoDBwy0a9PstdwAdZPXK/NrfVGfmJ9V/8682hBB6sCjMHJvyucUfkwKxLqnRCxxNVH/FZ2itP6qAsMxIE0lgQOjLxpcTGBjXjwKu06B+5dGaSHwxnqWi9KZvHkVwb6QEJfELTsk4eR4bkFBSUpBeWPZobnNFP0FCA+JORHDOb11UclUj8vbc5pWW8lHJRQ+g1Fj1o7TCjG0HpD1MtJkHZ1lpOlFRjDdyhh5df8lEhkoDSSz7az6vLdWBetrMS6xyxR2hJmQeJHMlChFC0mLhoAQEwg/BOGhUlTeMa7SWQAHtKh60IdBHHWB6BBzX9se7sh6s/heqaB/FG7TS+5UCqQ50IToXULOO5UZn9EDTorpw4R9ntGEGrXtZr3P61X3+KyYIp/iTWKbAusp1FkIvJ5lWPv80o1AmAHgwHu/9r2F+MEsIFF6UMnrs4LErxWNiNCMwGvmBvYvw0lzFh4l2Xco6RZc4UdqAHEZjVT8YEnbKqhU7QvnSL/o29R0JIMkPsTYZvmQNkU+rmV8y07LaZ3N5+ynq3fWI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uVeD8kN3CHcoISFng6ATLfj0RPF2v8xWlhWSndCxG1CtLntO8FOA6jYOLJ8V?=
 =?us-ascii?Q?KAvQYWiaocsr8A+sHZ7Lb+YPJ/LQw9wANGIy6la9yNWk5drrDl/ayA2j0uwQ?=
 =?us-ascii?Q?o60yA8cywILzxPhdBtz5vvFSh79UBWDdIX5q224M1EgF11EdciwpyA9pxVxd?=
 =?us-ascii?Q?+QQTq4/itUCeH8TM33SbrX65ilP/29Hhc61P7NoI+TdhiIaaQAEiq+dDr/xL?=
 =?us-ascii?Q?IV2e8q88jTUVbiD/i+ojmrxnKsdjLV6jyoo7NTB/lZAJDIyUAQolUBS7cJwU?=
 =?us-ascii?Q?HDh7iw2ekbB41KB0xfhIZY/PcdnC1cunQUgiXlF+mcq9+mdZUpHdS7O7qq4a?=
 =?us-ascii?Q?BXVbOuAUjakC4IxMjv3Cnu664vy0Wmg67ON66erGIco08E0ckx1QVjM6NLRD?=
 =?us-ascii?Q?8nUzxKvaE7OC7hgjCrOl/TlYQWSu+Irvkwnwqn5LkEJYeNkte6+J2t07lkYA?=
 =?us-ascii?Q?VuFG1ZWpTXmaZh/HQOxcwfHDzllm2jKRZz+rFfpJuvI+HzqXjRlQNjcyUWQA?=
 =?us-ascii?Q?dqyhw6sMldg6CnX6xwcfGjWG9AjehHw8k6lqlKOOk0rqiivYMKK2DzXkOYfR?=
 =?us-ascii?Q?txylJ5vo7MdcyO5U+32nIXn4UlbU+eNZLmk6XjNGFCgzHvziKriwyRjOysRv?=
 =?us-ascii?Q?2ZZopstKn0tU3TO9i6SxJN+276sK5MW8fEaypV+3pvUAnKk07uqHh0hEJDku?=
 =?us-ascii?Q?JS4lL3kangcUfsfcysHvpNxzju/Qg8R4Xsq4JnUlmEWIh9A+gabcPrCHMFho?=
 =?us-ascii?Q?cgiGgKJgFPLq3ZJjmzeWzOrRzu62w2N49NIMY222hcujVKb4GHty7/hAEsrl?=
 =?us-ascii?Q?0BNTayQ54qVyDJyF1A2fgU0hznm8ZL+bUnYoFc4i6AMXkxZFN0ziXen3gQIj?=
 =?us-ascii?Q?d5WltE1nMIN4lMomYPV2WY3+vBNN0AbK3VN9odbQrmgo4WzV3p0JnQOUoSgF?=
 =?us-ascii?Q?tPLu9oKNDlJJtFFVHUNM50S0E1OXGepW+7mpRdnxB1k/rbWZU88FOQrcqDV9?=
 =?us-ascii?Q?oL+0jmvCRJuvGt2dyV3SoVtQi19dPp20D33o34LzbWMRovzWjHYYIXgRGT+4?=
 =?us-ascii?Q?gI9n1gc8vDevUkNkWgml04qtOPzD35KnBPq4bRs2Y7HvhE4dNTkTmqr2DpUw?=
 =?us-ascii?Q?904svYxOT4c8rFDQkfJ4KFvhZ5R6CIEIBnr0a6n5XJcTVh6H4ck5QILit3D3?=
 =?us-ascii?Q?kPd+LmqVwLd7MzPqg2qjQ43YEyPHjkH5hMEs8bBKs74gMFnAv5p2udzm79iq?=
 =?us-ascii?Q?BpRP3NNW3TP7mcJ0sEvvPA3jMGyv5OJFP7JZxtOYafziJ3GaMOeMj9M33E95?=
 =?us-ascii?Q?mi6/x9kHKLa0ElNKloGmubZZNmJNTcWHK4hyT6eWqTWgBgLts7JEXm/9XefK?=
 =?us-ascii?Q?7E+XSJi3e6rQhpLOkklCfh99kqWsGadG408XhVNdphApP2giZRgICv35BBoZ?=
 =?us-ascii?Q?K06+L6mf2LmKecSAj/SfZuWhVup0Yt4J8Bl6DhO914o382LHUttIQ9RCLwXd?=
 =?us-ascii?Q?bcGeXapp0UYZQvNlSsQcA6NqxQYMRb1EzPEomm/Nj/ZACuYreH/XE+OBRu9e?=
 =?us-ascii?Q?8t87mUqirELJbjiOZ8QBnkjcOyub9AmZ+6iyypiCwTn64cvzIY7vC7SLOURH?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tMKeEUYwDiYbjw+M6BzFdTFIJE26gWgMe1XBVcpYrNJDvY75ZghDyCVk6WjIsFDQvQbSSBXaWinUhIpMWWrgtegBZKGlY8N5BrSZGNCAaVbSzPdojzbZLf+P+8xf94TQTsdS1SOH0ggEWYceF4tc+NubHiwc38oRW/vpcjkdcAjl6OolAEJnt7hUey+boAp3gfKtKuQo0OhofV3N5MRMDe5C9JLSgBpzn7bHrHwupRV4/pxKpDsU6+hh5K4/b7Rdjo6ZL8cYr7XQqFf/LjcFqxVgD2Hy9t5yECo68wjY3rO1HiRTozqAguvrTqCliWC2SBcR7sN+01eJcNXv/+XX7IPwS+TzJApCgiGgAKI995i6dvBQva2qdwR9HtpCkVVLZOU+cAfrgxDakBTdJYOih0I4ldP/jd/sgLxp/fLwL+WzgTQ7seFTYypdyINq1ozuWXY0vigpYt9QB72HZPoHXmuBcMWBQRi4zjB96bkG0rF4TpBD9YtuaAe4AI+RUUNFEnBYk8sJ/PDsh7aLtf/m0S7m/llZjh+rR6uCQcSdOWuykTRIytvBC5zhxPwdgtCr/V7pD+ClwnSOYEOM5Yid2dEx3XvnfEX3HIxJGo8S95C3vgULHLauGgAA6cTwkv5gch9eRYdPYTSyz2o5qrNvcaC5lSTEzC8sVknA31nerlw8wbsx09b5nV/I7NHGNGG4eDjJJJ7QPwLJYO/qgckOVONc6JR8wyrMcxA6kbedpz403XLvxLYOFhsQ0Zy0INkr3tsSsgmVclWzY3PeZht2af8HCbnN8V6cEmb9npP2wL/0uQo6plsnfhtuVYgUqostKc+TQ57WTgSwpTwCElkFrldO1qP/rI3WlE9zWXvlPiZx1Ga/jfSMy3Cj0QEv1aFO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231a909c-dd22-4230-b0da-08db6ca77609
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:49.9956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkgpQQmBWNammvUaTCoYReGuycv4LV9pBHN7ok/UQ5jijUrOsWvidvo85YyLtl+PvJiu5A8AtlJrGfEwxUsaRTJh/tdsOW9Iuqd8lFV4ixY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: 8ujJYqOSn35NOk_gmt9XeDHe7DBzFl9Q
X-Proofpoint-GUID: 8ujJYqOSn35NOk_gmt9XeDHe7DBzFl9Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2100c3adb456..3a7a61d47910 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result <= 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.25.1

