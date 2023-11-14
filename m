Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C7CC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjKNBj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjKNBj0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:39:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A6D43
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:39:22 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNuuJN012937;
        Tue, 14 Nov 2023 01:38:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=9hbkVdGyIWiw3VouZvA7pxSitmgstT9FqnuTSmlNZOI=;
 b=vXDDizKXzuQfFI8hLQxUyFNjgVD0wEzPxCRoLKrcAIWMJvilyknvHaKy0auwzZ6LEaFi
 dRXdvG+wPx4hmEMhfz8ZyR8Qn51N84qqztB+qVz6IT7hZWAdxB2VKJDXMojx5ho6PXsN
 2Szk9+0MI0Ckp8+k9VbmUGoKk26kyW8vOXuVwdP0Jy1gYcgydRk0GO7aeeGb4gB6YcVt
 N8BfK6uEBfXJj2cQphIdkk+NZZV1Wy5Gne3iMQUjJw3dg9GWiVi6gAm2M9PGjXJwVASm
 Rs6/1KV4gR8mr1s8+oUuXF6h91QjUA8GhlcXqY05yzb4PYNjRwxAO1EEsr7A0WYtZ1co fg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2mdm7ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0L4th004566;
        Tue, 14 Nov 2023 01:38:15 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ub5k2j1nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTFZ6zRbe/NE5B6h1C4SrRjWgX/sg+61UJMlLTSn1PoMa32xjaFGjiXjgstM7o/zgxiFmjctegKOCDl8OgrxrH+V8YmzGmZE4KG8GUZnhvcyHmsXiDs73L/2WY5HdZ8avG2iwkXWIVTXL5DUMcNj7axLwHYAH06/KC2lgMFvdAsptBPh/nyv9S7tPiR+dSwpVz0kbnSTK2TcImDq4F4uaCAUr8QigRkL7010fzZXPw2eTsewAyGcm7er2TSzCbo9dMwDuFo2nKi4jLiy3Y//8d0I0BeuYjwogEUibZysgUI6W6Kup0plZ0EVa7YsrhnCMc/K9bnosa2iFdiDp7qPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hbkVdGyIWiw3VouZvA7pxSitmgstT9FqnuTSmlNZOI=;
 b=GindxlFM4AbOx/Zk3UcP9S2gOvuthv3EOxeXCC4fdWeT+m6M11xnepY37gMqpOXDBjDMRN/boz4tIvseQmSQWHr+eup7yUbkAqhg0bGOgsQkhzI252jACTHPs/emOgM85ip9dXKNkbJSFlRB23wJihZrYmo4R0GWO4ezN6XqoS9KOyajvToSL4uOEhxq/3n4ilAjrLdWQK730xuNEWPgJguq87DODN2dfHxQKJsYbvuxeOey2vx33ZdyyyMPUgBozk0IIKE7+o3jm9fc58VQcDn49N2Ql8tyPSmYBC5Y2beRGJLXPSuMuqzEzgpicyzOwsksWOzzkHCftU8AaM5jRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hbkVdGyIWiw3VouZvA7pxSitmgstT9FqnuTSmlNZOI=;
 b=uTDJ8S26Y0piUat+DxJX+zQd0I0ZmBX0B27ABl/DkB10w7NWFxqw25bSY7ahBHhbCmYNeB6c5x46A/8wjxuSYfHNBPzX0qBSqOvn63zFfv2r9EyjcXnylit/rDw1vJXNm0xcglepRmSjS941C46mMmkQBEC9S9CluZ62p2cNZAU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:13 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 16/20] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Mon, 13 Nov 2023 19:37:46 -0600
Message-Id: <20231114013750.76609-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:5:190::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 79cec762-56a1-437c-b387-08dbe4b25dea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCYlUSQ29NWA78F+DniPpn8YjKdGx+O26VWHt3oM7jBH4/GRyMJznGtwk4acFmvyeNZw24EiAOB/vZJPqUJIaQGD4JT3E0YqGJIz5cehKTMas8487/7FwBoofAETE+huP/LGQrNeA/GLqQrkRHiTUhDwzFnFmrCk5tEGz6949yYA7sfCdW7TlxhrikrFCym9WObaRg8CN+QXi5nDqdmQmj7wJ1tyOFN4C0exwo3FwkiutZpGY1CPugQyCBfUcduVRVOM7GuyMCkqizBRrGeOjU7XQJjsKCUzHk5vHtbdAJAPXDCLoPNeKJws/fpTjXCLHNopwXjkFHZ8d7BkICcxRlhBrZP5e9C5382zgxSz6Z8wNkzHfrMXizSYObHNUGvJg6rh7ui+ISz0BJdtJGH1QPMutIBvtBCh9tLFRG9MkdZnP8uwvXZaLt7ysTF/s/mzp+TAdy3+P/oQWfPFdofua1hN2s/XKTmJMFKyotUibUYSbShkfN5xNT1DhA/IAyl+mWFCKrF0Ag+HCs9t555CMkPwEFri4nVLMM4YEusCQFDSxtHEk7KyPv7lbg4VWmiy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qIV89+/XD462DCfPhHLVHklgXjAu164b1uXmB82/0eSGgfcvko6bg9NxRJ+o?=
 =?us-ascii?Q?es2HzSwRLk590qV8NS+rLFUWTuzgr5OYKBmZmALpMP3xwWl6Dlo01U6rfD41?=
 =?us-ascii?Q?blnEaP9dEiMvg2R1Cx1KXpGc6TQMelmOqNmIhqN3BqYSqTDPl4+Xq0DoAaai?=
 =?us-ascii?Q?3Of/V5RzrQaXYgkJkLN7bOL4H4QCCtLPGZVZLcvqJP6kZptDZKXfhf8OP0qJ?=
 =?us-ascii?Q?eFDmiF3uxcgTA8jxOWD18S25PrzvNtOTf0jw1UmspjNPKSq8RSNmqoJMYXkZ?=
 =?us-ascii?Q?cIER1N4ecYszKvas7T4KXSHVTXy91y1hpvUs0IYRFDeZy2s+Ee9icXaqaYd+?=
 =?us-ascii?Q?3emQMppIDiCCDau1sar5MjcAsLmmeyJmL24B8EkyXXHDtt+LoHEzDerFcgpq?=
 =?us-ascii?Q?ORsZFtPxcTCfT0qdHrtX7X3fZGPTVTVptVGUU5YY990oULrOC6w28WnlLrLR?=
 =?us-ascii?Q?uc5wKPRveoERcEhEi0FMOlnFzJCIJPQdg1uiyJWAPfSj2kzSYcz66xpmW7pg?=
 =?us-ascii?Q?mnF3HXs7SO0wpv6jVKJbzBY2QoaaznUzQvpXo1TbTDyBpgKO3bDNo1+/URaf?=
 =?us-ascii?Q?o2LkPtPfNF9Te9OodIZlyxQAwPMfYeHEkkJTygPTgDl90UTX8bB4iRWftJ2R?=
 =?us-ascii?Q?CqceFB4/s8/zJvBRs1XdVIl8JBOTKNqY/AdL2ZSbR0UpfC4Q8HV+xeeSt100?=
 =?us-ascii?Q?qz0hYP+MOjazHN6gvPS2NCDnND6qpvgLedMASNNTBGrn4f+vs8KAWHUJBrKG?=
 =?us-ascii?Q?AWXoBTa43w/YtQQWC7T+nISJ+Mw0sTkRAoEfQmkzd2he89rVLtR69bxkzQHA?=
 =?us-ascii?Q?IZpkL42FEBOQjEVRSDFC4eocT73pxJZFgeIAfNKnhViZu06c6/FbGehiOX9Q?=
 =?us-ascii?Q?LV/VLkdkt+hICZYQ4IBUggu6pQbb0ckuiPMcKusO3ncxT+8WoJHzJWf5CrLr?=
 =?us-ascii?Q?nLpRdL/WTT4P6bOwzO7Va+0ynps+CJY5Flu2ZuQma/F5uPFI+P8UFA3kvZr9?=
 =?us-ascii?Q?peof8oRrR3BLg6e28f8b/Ap27M28eq65siR0xqIxcjTDn2cDMm5J0K+g4FX1?=
 =?us-ascii?Q?vjh/gRVyAKanFbLtRQOVPHq0ydd7nuylVRlEdAQ+AWmDhpXp1PocUQvza4Fp?=
 =?us-ascii?Q?gjH+Q0d0sqjXb23H/qSe02NKiFxg6t5EQfaY9Iq9bLTtdmInObpCIvCqjp0E?=
 =?us-ascii?Q?3k54+5FdKMQBG54zPPx5UTHrBsv10tZH+7DBjFo66ZWfAH25KyOcCiCOBf7M?=
 =?us-ascii?Q?L48NFCaPSXNe02G+XSPlaLjYiPlKFmOp76P7SvozMDDc5WmIEb6HWx8GE6UI?=
 =?us-ascii?Q?Jg8ekTyZOa9Zj4++b82iHNlxKbVXUmZDIpnc2zs2KfywWXNA7qWRJoH9Tggi?=
 =?us-ascii?Q?JY+zql7cbYUdzHVvVmNrPEjYsfrm5TfQbZQJNEQb+aurwWFcTKQ/U+7GSv6l?=
 =?us-ascii?Q?2tcfu516qai6yUfc1IkoaXKOgZ2Es61ALt47DAIcbNtdzCFlIuYVYJT4Tq74?=
 =?us-ascii?Q?jLq4fAPA3DNajsu0oOJ3l4T+J50kDRquN16F1W7Unyzh9XIjyP8dQNqkulkD?=
 =?us-ascii?Q?QmgKpz0RTJDQxWwicXFiU3dGkgA9quUhyWeOSJpjuI1Ha30clNYYLrOu2dXM?=
 =?us-ascii?Q?nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8ulWP5cG5lfXFLmHqfBHeHrHOnWnFKD64POPeqyLmhi6+pBRdGLuijOAvr1h4B7zPyG9Ba1BJ/gJnVchPDGy91i/R+viOfj+W6VdOC4PZH42m4kDL+etTr7gd41cbNZ2WjIIy3KuC4IRplBGLA50bhmd6FG2X/Mkh947PHoL/g469AwTtzq+/MxMvi4vqTSg2l9Yzvp/3qyYjmdZRiGcPU0n/p85iEuVIuPcdOWZRpEYISPnSm7l7PpRoEDyzXDUphmMx1aC28m206+mXHVpA1920aqZGOc12bip4H/RPLCG10dzOCk5cu5ZfxUSDHusUt7VBrDKyZwQ/4N6qUDjWEurV2fBKyHjOTdXbaYObM4meA9/cOJV/JBq/EZyVpDPLzTd1uPfrdtxJlJuuvSm8Pr7sc7t5eM0QbhFfgjxxXitHgSvsZGdBwU3e/g8Qi5+U4Fvc7ohmpZqySPpXTBgVGcE4WxtvLoDCUmqDuKb4NpmsAv+0ddbL/eHYgWJRqa8RjUAgdRBVIcIC6HmBApcNGeRCbyu3pwSJlHHOUVP8TY9gdGHNg2ExK8yT5EnAoeMa4bSah/l8Lj4PGN1EecqUim7guobZP/HCmb9OY48vEe1ebx2VaYB6R9W9qIgkR662SXJOC+9FoEci7Cw8cSJD9PsA5WJmwe+XHJ+m8pKASZ84zCd1BKU9liOxNfvE1oOwUW213bIciRuN+1U6m2AkLY/iyQhub+OwRXPKefr2wnhykMNsUcwIitJ7rVU5x17t9h9tra0xNtS0I7MFSE/maeE6oltMRTIsV6/+Vti8UK61IJkf+s3LUq4fo1ViFRIsn8AzygVfdGOBqgRQa9ygpYGtXRSF+ldCuB0uurMHcw5xD5qO1ZmPlCYxB9Yiqbp
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79cec762-56a1-437c-b387-08dbe4b25dea
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:13.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJi0T1jUI6Cj286UyylVPJB9q2GJ8LlZzJKXx/ACaseGMF17AkzvM6TzKN5RpJJ30tgPXuxxaU5+wV/wZnYQt68XD+F1pMh6fSpJyxjU8IA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: 7ryhl9RW9JeS_c1EcAgu1mfvjRTlsZmV
X-Proofpoint-ORIG-GUID: 7ryhl9RW9JeS_c1EcAgu1mfvjRTlsZmV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the main loop's retries. Each UA now gets
READ_CAPACITY_RETRIES_ON_RESET reties, and the other errors get up to 3
retries. This is most likely ok, because READ_CAPACITY_RETRIES_ON_RESET
is already 10 and is not based on anything specific like a spec or
device, so the extra 3 we got from the main loop was probably just an
accident and is not going to help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 62 +++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 87a8feabc2b4..cd6a6b31433c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2622,42 +2622,58 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		/* Do not retry Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		 /* Device reset might occur several times so retry a lot */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry 3 times */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+	memset(buffer, 0, 8);
+
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      8, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-					      8, SD_TIMEOUT, sdkp->max_retries,
-					      &exec_args);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
-
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
-
-	} while (the_result && retries);
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.34.1

