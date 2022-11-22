Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E55C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiKVDpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiKVDo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:44:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF82A942
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:44:47 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM3ibSJ003442;
        Tue, 22 Nov 2022 03:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mf/7M0eB1ApcjMXwUxy9b2os+x7h31oAnxUf0Gcb1lk=;
 b=NMfQouC0tujlKqe1gfD/4HbHyWplKUA2dsfdAHrqkKDEijPOcVOmc8YyhlM2+7sJytjx
 YjEqpJmJj6hT0XDotQD8lh65h6XyRxPsnx2cvNNkgikbwHYVzhbUeYMQ2AYG4Vg/WGaH
 78ErW5eW85V3Hrr2YSK8FYMJqqu0ZlEp1OqhvzpzDiVqWS/mK/R4urcg1MR7a2FYx4wI
 s93njwwVWnz282naTU+JiQSS0lv/mwJOlIch6cJeM0XYuYsuswyxRvFLKv5zLt6CiDRM
 pmy2Exh8VNI87PQwKkwwkzUg8CX6BoRCn1MwlBooWmYZGwYsQgOHdsm7mKdS0nSGSb1z Rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0pf2r1e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:44:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM3Hio6008283;
        Tue, 22 Nov 2022 03:40:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk4735t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alXzfXsnbLG5JNi1O+QuzqHuTOpSRbP3mbbhPJAFBL5hzFUxPKD5xTSur0DpVrjiaGl9KNVwj2lAjKagNyAqzRvmf3bZFSvbRa0z7RP52N1ZtKPWIIep88raBzVFsIvLcK1qkdehM5nGhC6kN239/FQVxHr4Vp91vuXGqDier6kn2gAE/VRfBwOGQGqZpkLBEMJR3gVvgfvOO3LuRi0kxdwe6O26C9bz8jv/4fUmsqIn2eq6X5VVTE8hLGBwWIG61Gh564nfLcYZP2uR5VcqZBXIDp9RzbcC8vKZgZXcgDHId291TkSqKlzG0ATisSLOJnyMHgNp5nsbziXDal7S3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mf/7M0eB1ApcjMXwUxy9b2os+x7h31oAnxUf0Gcb1lk=;
 b=E6ieFkcqVt7lejIGnifcVQCuVX1gTqnIdzW+VLLqTMfzdu4OWWovQIHN6k3OfBYC+lwN0eiPmmlqdco/SIF465q4Dx+pALIsrA19L9BfTw47NATU/71GCmLInv5M97S11HcroltJCe9KKZolss3znVbWXUMK+Nf/97R9hiK5Ix7ZcVWtKHhQxKDQpcHTK05iUXgBrZW6/saLVm9HwROhi4fk2btqgFCkyaxsEulx9FXXV4LbStxx64PjK632qfB4Foynz6L8hiQKt9iIIZ1PB1+fDZqMSjQGFD4ZcSiEjfYQPBBn2/l6Sa9VVjtQO7iGLvJ7ph6SHyat6P7DxzgB7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mf/7M0eB1ApcjMXwUxy9b2os+x7h31oAnxUf0Gcb1lk=;
 b=KJnNOd0m0NF3lmBl/z72BSwEESDoNqHDle6g0w1nhW0cVDanb1kvgApEPxvHCbdAJdIHLOPJCS0OwhcEBYf+KluDieimA6pSJvZh4U5fwfURJ/cRaPIrzwQzYt0E1g8FXnMdsJoKiwi9+7NEsR6gA1xj3NH+0XOr1/6/r2jlXNw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/15] scsi: Add struct for args to execution functions
Date:   Mon, 21 Nov 2022 21:39:20 -0600
Message-Id: <20221122033934.33797-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:610:e5::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d6dbac-ae14-4726-0518-08dacc3b4b97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvk+vu/jtkhS0jLNwFq9vwb3fsuXhtXmux+uTMhoK+85fiG+GCDL+5+FsVbTSaDv7wdf8219j/9CDEgoqyyyst4AhQ4EyOEtyAK8l5ZGByHkjROoSXUU78VZihMGftQJW/JxVS2gKg43FtgQdiTmtdce+JNAK7WLkVjNh7hobRAkmvhs+oRFV3yk3WBQtM2iUCHEjvYeiEjjDXNNsPpWs8tqldYBxGqBJazr0ov3WQAMWi59HupdY9HATdZSyroWUrIAQa4wF91FZ/s5+M7fFDQ8mO92NSI7osyo60fLdf/Uy+NiIJAq5Y2inEsGP4L5El+JI7tZX/doBWWueionLW6SgGUGIuHxCvoJSwTRXL40iz8ZApfHZL3bZUnzPPrVhaacv9AdbJRuZyfcd/Po1QprCcsuk2UyQkPy14TNf4BP5los4BIz58V47AaW5mNwQ5YuCuKWsfJIL4TOUdHj6qojweyihRwQVRlqz0iVZ6VVqFcNiwPQolhNVtAAGfYkBrAM5hFd3endvmb5O1ryeXEFSbHJOfBznJZVlGT0b6l8K2/a8Xzvv4oqO6AjWO9qyblVvRGm9Uj9osVWfuOqXU7ECNTHJNRMHhEs4e+IcTzecqpJCy+39IjNMHLZTckTyIk+bjJdMMKwjlbVLhVYwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PmdpfXfR/mi2SYU7M8IXg0J5vz/1DyqCNlHXIe+E896dCyuPUG4UdqgYnJat?=
 =?us-ascii?Q?fd+W80UgW+u11alYRf7DUjoxz1f9INt0jNJDiO+PbSHfQ08sNeEM9ZMwljBT?=
 =?us-ascii?Q?W9C8wB1wJmFzFMGMjwzJHIwQMzpsZjdFikiRPUJHrHfAZvHq269isgas+xV4?=
 =?us-ascii?Q?9luEgWQHjkyBhZE+bmVGGckAAX8fvHcqIQ2Sg9V1WPbNh/l6Wif/edLi6cNp?=
 =?us-ascii?Q?pk//tCdEfNSLbpfEvNQ+eYFiVMbB2RHMSuhp4gNL0HV3FpiS/lFeVDbLjX7p?=
 =?us-ascii?Q?JkdGDmGwFMPP/BvEDMRuqRLHFYz2e8nEdJ2IkgcHNOSo8YWFLy1wYLxJP+n4?=
 =?us-ascii?Q?8sgP/OsXeabUyIIB2rhA9auxYNkjCVCpbAOMmLuqo/EStzr+3Y9u8EQfhnR0?=
 =?us-ascii?Q?Q91OtrHp8460Gm8XNtBqQmanaZOSac9H4IC34+OhyUJGWjyfWP8XQsvQnEyF?=
 =?us-ascii?Q?epj2+vcrO+iu+UdNNn6cFbsj0UC7QTjAqBvDF8KEtYVpNQNqk1NQc1InNPwa?=
 =?us-ascii?Q?1RQsuX/Bg/pTddbo0zOkeu5TL5FWyY6A39wR/JjF8oGPS4YuQHfx0y2QWU6F?=
 =?us-ascii?Q?UGrJieY2QDj3zKv5fyEBlpdHdMvDcIzr9lc+wmz7he+cLeAYJGPJJlCe5YJP?=
 =?us-ascii?Q?b70GZ/RcMiyK7WhPrFfyoIDL7cRIw+lFjEc6BznmRQogCu8KYB937/EofBtt?=
 =?us-ascii?Q?iVWTKJN2AaJOCbZYvJ+sFq1KZpOb0WyjDeB46HYOqEjcJUIdw0kBc5jyjaS0?=
 =?us-ascii?Q?MPlOHJBy+GpFHcAlvySQs3v/KMB+uJ6EwrQGwqF2SYG44YTiTVQ9x9jh8VqX?=
 =?us-ascii?Q?Jr75Fn8B418b69Nk3DZz3uF0qPleqLsYHkFlUTLCXTjkvXT9BlbToul6AUYh?=
 =?us-ascii?Q?zNJlxWTWJNIjrRBsJ3YECuKtv1wJAhNxAj417GefKzgP4LI7JRDaFif/joK5?=
 =?us-ascii?Q?DTUKYKyNygghRoVy0bvyVqvVWbn5LLULzWxlTNalSNZ8l80XdqPMjtM69zHP?=
 =?us-ascii?Q?pvAz58NMfcXlu5JsR8/c3UlnDfAUNYUlF3D7AwmXdQIEtThZ57+a0U2nq1em?=
 =?us-ascii?Q?pfINLOLTxhYzwQFYuMwE4quWCFJd+enXlbjftiv75P/pvRlSBJQuzYLwiEdp?=
 =?us-ascii?Q?tXwC++IIX1U5M5v0HfTTVG4rXwF8R9gAF7aeKLRI9N6tr17xLICvnKPdYJep?=
 =?us-ascii?Q?7ZUbteV+tcfBkfF2nhlFMFi+5SIBZP7ZMs7JGex5NVNBzY//NawgBIMVyIwh?=
 =?us-ascii?Q?sC4hJDQaEQWoQds4fDDXIxkip94wGRdT1AZpHtX7DguYfskOy8kTLzFI+vOH?=
 =?us-ascii?Q?d4OQADh0RDbs+O7zhn8kkUCKSKCmcf1MohmxIR5TGMH972qBO+LN77OD/WQc?=
 =?us-ascii?Q?CyDGHa4vBVPfMjBHRcPR5K2Dx0APpyUp5MyY6gsrdx73nUGUK5P11YqeUL+h?=
 =?us-ascii?Q?OOQxLlo1yKW07JCH7URA842loDDHUH/O7y1Fk03+9AAfQVNL/CbLbh0JY7/C?=
 =?us-ascii?Q?8B+1426ivyR7rva14z7I1zTrlAEzIDVYSK/b6ds03Wp9h7z9f/MQiJP/Dqvr?=
 =?us-ascii?Q?2xzbRKL+v0QoEq7fn4jBC/RoTWdDB1Hfoife2JKa4+elogUM9s2AH7R83X61?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 5ydK9Ah+pK+QaEMxOTwwWGGH6agp6UknyGr0Vkn21iIuV7IVc3CdxYPpjLm7llHnWZQUb1OvUUApJF2ncJ5rzafJUuxVH7ikUvJ7nxPxBWFaPwuPBDeG9Qv4kWWEso9tZ36dnoFF+PqNitH5uLlJZbC0xcsW0W7xlMRsf7HAZZgBwOqrRLpEXgrpWwOgMG7o6r7kcsoLuGDimQAbDt08GOWWouJgQ6UOnyhKLwYRzZlUQpCgkhajw7IWUpMCVeeQjqwB1U/f4W7nKWUGYPZzxMNXlrzvHatrTmJDAN6E/N0Zjbcz3f7UiTSbNroms5VfTitS9seXPfhft6MaVvpX9fkMg10ZRxUV22bbo7L3Vo6HSoe6FHBsnLpi1K7niHS+P/xbHX4HKZw2wYrPXH4X7BiJkc/eIDw+D2wmvIEjs1HnwpkGgA/sc/vPevUj4uc1CMxRzFyydFakhIWhrTbRADQoVSuowefJlXbDxWlLmGTY9BCBLerPlI3kqBAWd1oMx+2yjBf/HCi4j9trW1RJhtBKneOqI84vgS5O0+KXMOxVibVa5IA8phwfU79DzRzZUZ3jBuGQtHl6HZImjyAD/sUEOas8yMlkDWXOrk5KBlsK59FNJ29aqJilu7/yriTJrEI3v/z9EWrpaI/0rXyEPR2fCa8UoVlcGWziCZ3cCt4zRAHwjYC7DINYOH3RBBdGsUaaix1At0wnby5Iwh8OJ2nNoC22+VAaRsLKSq/QMOEKzG9iDE/7nCo7GueTBVKh5v79Z206uJb+nA4dURlMMZ5yMACXGM9qEAo8ALDg325fpzSMuW1PYAQZ6cbx28vvuf9tOGA1CbswJ154I/bqQ1SjkwNO3grIjCcbpB2J9byBTBuDSnEIOvWkZ5Vis6In
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d6dbac-ae14-4726-0518-08dacc3b4b97
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:27.0452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BSfPmq1bT9rQrwDeo2TmT2ldZfHFPAzzrKyO+zQJKQdrK8SbOGMh8dnkEvFGSixxo8Z8EhKGGoOpnj61sfzlslVznTMePkohj4G9J3JtLz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-ORIG-GUID: J6xaP-rnLNeoI8LO_t1tCCN9CWSukyKI
X-Proofpoint-GUID: J6xaP-rnLNeoI8LO_t1tCCN9CWSukyKI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in optional args. This patch adds the new struct, temporarily
converts scsi_execute and scsi_execute_req and adds a new helper
scsi_execute_cmd.

The next patches will convert scsi_execute and scsi_execute_req users to
scsi_execute_cmd then remove scsi_execute and scsi_execute_req.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 50 ++++++++++++++-----------------
 include/scsi/scsi_device.h | 61 +++++++++++++++++++++++++++++---------
 2 files changed, 69 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec890865abae..327eb2df5583 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,39 +185,31 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
- * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
+ * __scsi_execute_cmd - insert request and wait for the result
+ * @sdev:	scsi_device
  * @cmd:	scsi command
- * @data_direction: data direction
+ * @opf:	block layer request cmd_flags
  * @buffer:	data buffer
  * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
  * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * @args:	Optional args. See struct definition for field descriptions
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+int __scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		       blk_opf_t opf, void *buffer, unsigned int bufflen,
+		       int timeout, int retries,
+		       const struct scsi_exec_args *args)
 {
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	req = scsi_alloc_request(sdev->request_queue, opf,
+				 args ? args->req_flags : 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -232,8 +224,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
 	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -249,20 +239,24 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
 		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
 
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
-		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+	if (args) {
+		if (args->resid)
+			*args->resid = scmd->resid_len;
+		if (args->sense && scmd->sense_len)
+			memcpy(args->sense, scmd->sense_buffer,
+			       SCSI_SENSE_BUFFERSIZE);
+		if (args->sshdr)
+			scsi_normalize_sense(scmd->sense_buffer,
+					     scmd->sense_len, args->sshdr);
+	}
+
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(__scsi_execute);
+EXPORT_SYMBOL(__scsi_execute_cmd);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 24bdbf7999ab..578f344e330d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -454,28 +454,61 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+/* Optional arguments to __scsi_execute_cmd */
+struct scsi_exec_args {
+	unsigned char *sense;		/* sense buffer */
+	unsigned int sense_len;		/* sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
+	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	int *resid;			/* residual length */
+};
+
+int __scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		       blk_opf_t opf, void *buffer, unsigned int bufflen,
+		       int timeout, int retries,
+		       const struct scsi_exec_args *args);
+
 /* Make sure any sense buffer is the correct size. */
-#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
-		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+#define scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, timeout,	\
+			 retries, args)					\
 ({									\
-	BUILD_BUG_ON((sense) != NULL &&					\
-		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
-		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+	BUILD_BUG_ON(args.sense &&					\
+		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, timeout,	\
+			   retries, &args);				\
 })
+
+/* Make sure any sense buffer is the correct size. */
+#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
+		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
+		     _resid)						\
+({									\
+	BUILD_BUG_ON((_sense) != NULL &&				\
+		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
+			   REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
+			   _buffer, _bufflen, _timeout, _retries,	\
+			   &((struct scsi_exec_args) {			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.req_flags = _rq_flags & RQF_PM  ?	\
+						BLK_MQ_REQ_PM : 0,	\
+				.resid = _resid, }));			\
+})
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return __scsi_execute_cmd(sdev, cmd,
+				  data_direction == DMA_TO_DEVICE ?
+				  REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
+				  bufflen, timeout, retries,
+				  &(struct scsi_exec_args) {
+					.sshdr = sshdr,
+					.resid = resid });
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

