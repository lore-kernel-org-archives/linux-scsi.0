Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6C5C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjGKVsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjGKVsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:48:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9C110C7
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:48:17 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID4TU015542;
        Tue, 11 Jul 2023 21:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Li1zk6JkiIkpaa7zgxQZGl5c7wtKiXpkb7E1T8VyQuM=;
 b=ecsJZnB4BM/D6g8aZZ0NfMyj3Gxeep1aJu2nSmhVXIRSz52K854E6vyasQVvvDX3T2Kp
 eYabyv+/0izpft+sS8fWrM5xbZ8vQ5U3D3icPM2LiNdyed8sUvRRUpbULsgF3z61uHHs
 yIKWkC9iAleLiz+PFSk1L7iC3U6A6YwthYaCxfZtY5I6LpwDQppOYz0sCJuT6ltBOule
 KUAUPY6O/y4C9JCG/70vu1VFhFu09i+zwagxNn/lK6BN0TZD2vJD8Nma6oPXrts0JnhL
 0fF6dYdS5EnGHX5qY3EShCvRHE+qGxKQD8DlKtavJ1ky2SVFv6Gr//MOwmPm6fZQPX+I Wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xumf20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJv9Im000601;
        Tue, 11 Jul 2023 21:47:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29shh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1OByOUtFWARjoKGF2eyrWBIIw4+bdqBmiYJpLAw4DJkWkcfoMGPPPthCM4HMJPpUP3ndRTw+KEJ+pvPfuOFdPq/RbKJDZUesxwcDJhCIS8aQJVw2yym4hmmap2w7BdIQewtxp0qAxYmbxQgQw/rJCRWLphciAuot6+4dOHR2PrdJL5Snkk/56pQDd/0hYeU+tk8WFuu/5JZUxi1GBYnuwZHFoa/kG5Gga0Cmt6WKsgST/JOomTlqD6u6xszjymIUIHKR9QeeUqGFYE7JaVZgiC7zJEPJYzQ13Gb5SmOsi0fEFWDCDzh0glHCQEYEO1u9u3TCQjNUVK0ZCyLac15tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Li1zk6JkiIkpaa7zgxQZGl5c7wtKiXpkb7E1T8VyQuM=;
 b=gIKTs+7ktLRbxYRYwToupxh1J/pcZdZ5RZxH1MLe1Gib/emsyDznJTghr48FA/oFleEmOvNEPIi8/jIIvPb1EXXfZPGR8dNBcGbJ/HNz1UStsXWyoePXmxfDr0IDIsu3/Qph2VkO1HFSumfDG6N3E3UfEj6+NjI3IvVOVlX7wyHQPMyZDi1XquBErklzX7foWR+gFDZalObIxXjhF4aVF51tXIcHsYDlgtJy5PKP1IbZ1e7qv9S/osLi/m4yI9dmbfL0wTjRnkJJ30pI94I1wwNNqfG2HHxuuRnlsy2XUgFDpqUiyr4w6Ah7aP7SLxfPDHwmDD4r3cfqiLOJMzupNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Li1zk6JkiIkpaa7zgxQZGl5c7wtKiXpkb7E1T8VyQuM=;
 b=DpwhH6ukxyOz6vnaWGtZePDWBLSUK56WW7G6suJX9mR9dgmLVKym0M9l3gVOCF7YJt/+F/7Ya24+GUj2opg0QE4XhpxH+Xs4WKMSEZBYtY7aNaMMHtaVfXWI8uYhS5MHZsbHm1rk+9K1FOmR/tvAzYlYb6ao0xPhKQq0IoJssx4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7436.namprd10.prod.outlook.com (2603:10b6:610:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 21:47:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Tue, 11 Jul 2023 16:46:07 -0500
Message-Id: <20230711214620.87232-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:5:334::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 51fe3826-df51-4937-589b-08db82585e5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vo3qeWegKAQ2+f+rH9TrRzfuUNgeT0AN2sPLcNnrCaS0CAEg/9YKF6TzOW+CzXafTDPop0tHIyYIqS7/4nU4JfpMHLOO2EjrqLSZSJ6+d7dlBrRqkhDXnXt9pH0SwvFx4bDGMIp1A6gxSrto1N555GFnAw2TQHrWlsSSuShRGyzmrj3d1KvgJrpJsofchLmVj0DRLOAvk+HPbXEQ5b0Tn3K8EsL5Lh9gTSFjLNhSAaVwR4DXSPIHifH0Omn6d2zkOhxc545IaO/eEeoNtQNvSgnpj76C95t0zdwBnMHTQpfWir5E1zZFV/uP7EGBYx0n8YEm/yhpXIDcU/js/lMZ7u+Gw/tTXkIxY5rMpMFj29kWl348ZpgzhA51fdBG3Re41sOfx9SoqaP1JJC43zpCDIUPDo77UOi5pfTtp61Wo8HiPOWHMgT7wvBN8gNaltZMsbt08zyLs87AWRcU1AP4wzXqw+QqAJLRHI7dIJt31RMDyknP4LYrQnkjvGsPSRwHEXVeQLK37xIX3wfoZLhIOMskjGLy4R0jO66Ty7OgWg2c3GcjsK8XNo9Ztnkh9B5F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(83380400001)(41300700001)(2616005)(8936002)(107886003)(4326008)(5660300002)(66476007)(66556008)(8676002)(316002)(1076003)(6506007)(38100700002)(26005)(6512007)(478600001)(6486002)(66946007)(86362001)(186003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BLwM24Ty1k5qj16Erib49DJGRxSJa/n0fNskYgLzkrlqBeVkeABkaMGOEYkx?=
 =?us-ascii?Q?FtlbTgiuEUo8e8IPQzyD1ZrzBcfN50HCNXLIyoEqVBFSIm/M/b23ePHqTA74?=
 =?us-ascii?Q?Kj1eB9grTFjeB2IU/SRAzYf8FmGG/IpUFAHcfICyyT5rgn3dBjDIQW/QWcUd?=
 =?us-ascii?Q?+ghbWruppfmZS2g4PGpUBxcow3q73Zg+ubHvTRoRrr0Ds9Fr1fLw6HojX3dX?=
 =?us-ascii?Q?AjcIZS0v39sJOVjaD/XgoyU6cDn0nk6g3mjImi7ApbeUb7QbLKeFfNIFwfV8?=
 =?us-ascii?Q?5CKISc0j/KmVrrr+e8xsn9QHxwuB/CIqU1S7zVmJZvBseMh/ywLluuJRUPlo?=
 =?us-ascii?Q?EYjLVY1gH0f7p3Y2gb5gL9/iTb+u1CsAdxufTH2Hx2ZSsN2zyPLKMnUOgzC5?=
 =?us-ascii?Q?RSKTGqcBqSB3q+rv2PIlyp/3q3g9lMvQPpTTqEa68G03CcajEc1MnF0jWEnD?=
 =?us-ascii?Q?HG9dMe9QGwYKeBFMPIIYMn87xDlkybn5UG67z9omDO9z2ldEmuDqgUoMfNTU?=
 =?us-ascii?Q?FNV4+gML0HID9wvV+QO7A56lxxjhr+/D68oAQh2eKe7s36N0xI3llZqt9wVG?=
 =?us-ascii?Q?Ab0ttK1Tm2E7XUrRYm6IDbwqaNA6GQL2gF+BG1ukJ5XMzdAm4ybn57Rt6gAT?=
 =?us-ascii?Q?8DvOyLWo2UJhLhDx1bRgTZMkliKRd12KQDkF4wqoaBZiKe2L44CUglTEmFq7?=
 =?us-ascii?Q?v1Raj9qa7oXX1slhwFuHGSdEouohSWhAAlusDBV0TzCJbGkZya5Oc5DluRtF?=
 =?us-ascii?Q?xI03+7TO4Dqq0I302RV7yAWzxjWRMlx7Ww5Cgt58LiOPltwA1iPiOdqJ2qU/?=
 =?us-ascii?Q?j4nXStJ4ulsFszoUWxAQ/qMGUze8SkFl+7pP2FEAlQtjcJLdWzA8TicSa8iy?=
 =?us-ascii?Q?9u9k7g7a22HQ5eCKra7tdQP91nV111WijmMJBD2Bs/19vKAwCHY0HlJ/fv1T?=
 =?us-ascii?Q?DIWQ2SxpILqIoEPg2ur1osawRyFLDY9rtMS26VmKUuDMifLNHlX/ZFVPYMyr?=
 =?us-ascii?Q?BDbmUmVskUk1+jhiEmLuN2135THD+zSXrQf+dAuI12chDk4cgfOHezLS/HQn?=
 =?us-ascii?Q?3J2FEEBzgW4eo7Bv1dQ7qZlJCMsHdVmwrqMzOSjvfjc8Qtp73b8T7QfMBx2g?=
 =?us-ascii?Q?whLZ7xO3d2a4pV5DGfrybJ4TyXF3vyTONQLi4JsORYkDe/1ZI84s6008qotg?=
 =?us-ascii?Q?VwvTXS7ufX4bkM/FU2izZ+nSmxBzsGUU/QPkVvNEnDRKnNTV3nVsSXKgm2eV?=
 =?us-ascii?Q?0X9kb0lgL9kiKrIBWLZmhd5ptT1Agp8VzCOFJZNZZbFS2tGVNqXMiZhArRx3?=
 =?us-ascii?Q?PsKfXQe4FFQ413GSf09Hmlz6Hf6xKmhmE4MmSC4Rb7qlpdIMLK6yhGpiL7XZ?=
 =?us-ascii?Q?v7exWSoCXHXepPBvwRFmzedFfuvbUtvMLKYsNDfaFF/r3PCvDN8idGIIjBoo?=
 =?us-ascii?Q?VEkC2AGItZKEhcr0txLirC5FvVjEhH4bderb89e+qdJv+V3i63qmUr179uqU?=
 =?us-ascii?Q?eqOu0cRJBjRJ28E5dJcW0lSS8m0RRnmI/trxdQ3p07Wc+jeCwSaBwEDo0f4P?=
 =?us-ascii?Q?bkYgnvP4C/c2VaEIi6Wa2JQ3ei1lmyEGZnxYiI4JOnrRwwcK8scE/ITbcf45?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tWgD/pot5Fc6gIaSv0/Jg/WmMO91+cTkHl5VGjfpm64zgjgkddg2mKv1sklc4vdjys6SiyeRkKij51oUhgTqfOE74tyIWaZYSUWTDbqmyp6bViKsBy1g+nCfRjz03belw6L8lmgEsKYKeXD0obk84Ml0QjEF8geime5Nk7fwznqPz9PxsPiOY7SXUJEs3ZBKQMwWktx8RyqJd+y90uFojeXFBtB0K/9NG8oCrwcx6H4olpcL/EUlOqErNvn9ZKXOGOHmXyIW9dBkJudxcZEXkbYFaTVqcgz1asxHRG7YuQ62/AcrB4qn/cpguiG4f09Li6AYOrxRgkjcV9LuJsmc75b37Ew4kCtBxODPQKd8rNe/HcrGj+ctVIrVnERUbr8P/yO4ZufZNcyXM8zJodQQL0r4Uc3AVM6bcsbRlcnCB/djUstaujehZmk04TmaXHEndZZ6vaBJHgyFfjjRBBg8asS9muNX5dBIO0BjbBMA2jA65XDRM9o9tXUfMWFjVyyeH0JosxDg9ArZRfOl4tYXm7sQyDTsKwPzAnTUer71+oWGdc2AjAGEx1m9mzjGDyzMKul0wiZjuOSoD7gltv1FpBhfnc8V+XCLXFGi01OYPGCXZqvFXB1ODh6wj7jMHDoBmNnbKPP0Ml+YtnrEE/7paui+BZE1hZBkfttgUwyeTA5fEuFcLym6ZNgrBLNCJ1gIeZWetwVm59K2Homp3NHDk2YR9IvXH/Ttt/2OsOjNVgBls9rAI3d/KSpP02IQt67iApfSmCZmCCwT7FrXu/iCKSLwrJQf0vN5zNg3kotVxFxbUhLtAbmTH0Qmz9mNQAVYJlSEcZFB18nggRrNiblAZs5F56IJgH7euiA/JyLBzxFj1n4lbvApYUvK5tsV6HCW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fe3826-df51-4937-589b-08db82585e5c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:05.7792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aj0NdPD0KoKpZ6ACCtf7BhGIFuEjkV17xYHl7b3+zBzfXkFRHhdS5+PXsJu35AT2wub4+9a91j1P4eteiSJeSiT8rlhfmqX8q0DXDFp5tkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: 7dgG_McvSAYCcxYKemYS7jAp1ZuNzZpF
X-Proofpoint-ORIG-GUID: 7dgG_McvSAYCcxYKemYS7jAp1ZuNzZpF
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
index ff4a81a1b056..f2c0778afd50 100644
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
+		{},
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

