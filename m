Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7689EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjGNVhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjGNVhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3603585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:05 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL49cQ019565;
        Fri, 14 Jul 2023 21:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=SKEfSRjnLJZZXmGNlO6J+pl4qaOrbJ5N+u1ePPRXhBo=;
 b=zB9vJYIE7iThePMo/aSMYu56CUjykM56TvRSXOSVBIykTO5+EZe8Ypjyy1SbsicPV28p
 05hsO86GYTWqUJRUt/KTKRY9OUySkf0o2Utvr6OcF6ZSvQ0Un9XhUDTXUg+G0iAoQ1Qq
 B+J8Ce1FQPmgT0BYhz6dUTBc8NtQqhVB8AdISYOZtzlA45uvjYefo4JKsneKCaIJkPHB
 1qzC8Eos/iOKjxIZPjMW4W1zvMWB2UdsyOTIDvTBQ3166Q+Urwz2VtsUi+eNclWeyS7t
 s/bjL04lnuCI26hPMVMoO5nlSCD5skGQEhWN1kWDG3qa6LC/d4gFEsVO6Kyn3Ef9rXJ6 Jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqgr2aqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJxgd6013858;
        Fri, 14 Jul 2023 21:34:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91u3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9M3DZOp4TnEQ2BOiAooFuaRzjy/CElOj4dleBfFZD+DzoqqUHbdViy7t9Kom9XdgDpetK+jerXTBoZ9CzBLTMDj2nNDJxJ2rmipHp4qjGqQekbThdUxgzIpg48I39ueswDILa6+uXojW/Q04zbUbz4TdaWWJSUyX4IgyTT94Zt7GK+fpAboPiB7DlZuhHMX6MYkHM7VYX31LDj2+VB6L7WoOJjQNrVJpr/R996pClkpgAYr4OmGy6s3UqpZrDL2TGkcQDiCrmmNqaXP1mBfjhzduvGdQXSnEy2Snv2H+0KPFwYnSAulbz5NNIUBh56AaEZOAlgnhrKJTaSWIQ8n7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SKEfSRjnLJZZXmGNlO6J+pl4qaOrbJ5N+u1ePPRXhBo=;
 b=P31TKl3iuY7AD6bDdrf92Lr5D+mDbw2G0NsiqAt+cB3jWISeGpsl6KCoUzGdmQ8HVjZYHvTGBdq1AqlepI0otj5HNUZt3YGCNiDMiRKJ72kAxFpGUvvWFbdPM07XV0Ag5cLODiG3miXG40UXeTJfHpFDIRWnleEY+aIJD7zW872dSLFmysE/qiZAh/pB+oyjxBEnxa7bWS3WuHdrW8rNHCHqDHVlkt7lpkJxMhwRhosljW+AKgX5Nd9fwsV3MP968/IRNI5JSO1HnZa4ObRzzVelb6fCy67P4RH3cLaGSd+uJtkTWVq8e4x2vxlIxtY9TYAkkN9KpFRHXcYvp35qzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKEfSRjnLJZZXmGNlO6J+pl4qaOrbJ5N+u1ePPRXhBo=;
 b=GR+bnD2Tfj1t+LPkboT1aamEq+W2rmUCWXq3NFlpxTDRz/oHshR/qy5mijXlPZSsFANajl4ad/lunlKUMUH6b5GRzmXlczJXb3YsmekMINvl1YtTA+HQMtik6wv4dK3ser6KrNKraouzcDq8xDfHlZpXK05FvuIDT27Piwdgojs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:53 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 18/33] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Fri, 14 Jul 2023 16:34:04 -0500
Message-Id: <20230714213419.95492-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0105.namprd07.prod.outlook.com
 (2603:10b6:4:ae::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e13e4b-4e09-4657-0b22-08db84b228fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knMn/DTgRE5bSv8vAvfJM5j7DHLdqyPWuOFI8vegEtJhE+sCxpk9a/e0B8STOG0HwaVFvacG/CAQ1xH/1dq8uR7UQ9HeDPphSeKPPFS4regcrUXfK4L8okuqpemnUT6Gc5dIjNem8ssdlrP9jH3JrYnh9z0kuTB09zTMiWVDrUFBVDfYPxDJavYB7BKbsobM6VuR4/GPPKjj+T+JOMgOV7GccuFh+PtUVQhqXOoCWfgzmCkmdrS4IbvS+fx1MA9uffHsnbwjIjc6qjGWb2nTGKWyuy3ZUwnxKjw7l86BbTPqpA8+k+yvk2aBXI2R/ZvJSQQqhFXamE2bV9WA1496hn4vsXxj6mssVeWBS1BW4H108si8zfTSApEzH+1Hjk0Mku7QbIyZVN7LnaCOWlzN0tvZjp4k7tORp24EMt5bCPlzwhGF9r/xkL2fDXLNhYZ+kEBB0jwpaZPflkcAcDhUzH/cTxK7AzsZiSXDAbtIXDl0Ih290hmxabgGsihcJFwA9Z3v8oouyprlcK5LRaTGrZ4VkKeCSPXtl84e72XT8nG2bQcDbVzGs1kTmvYWGxrU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nJpun9i5WD0k7UY9wQTvhkjjj+jB7/hBS2I2GJLH7AIjvSl8HRenLxJCjDY7?=
 =?us-ascii?Q?ArR9kJNNcmo6pqQT0DBLUqrFj2Q+zRb4+gAy0flOYTd/unnThl2D6RI8LUhM?=
 =?us-ascii?Q?FWHAWpiAAmwdzECfOwGpk6N6bprM3N1nh7gUUle+6CngiWceQjwvN40Tauvr?=
 =?us-ascii?Q?Ob9npMrjTm2c5wCIg/YO4RPuUKbfPfoyrIZSrHQuZbNbBuQw1nKJ3shJdLWk?=
 =?us-ascii?Q?UM8GrA5QiX1auGpYHiRdKFFhrOiixlcLulR/EB+aUv1Ggz26IFk6NfJP0x8t?=
 =?us-ascii?Q?Ub6aOObZZEuBsQKEFyWlEcjyD069itHqx5XYxzKe8fwWmmfOThoZoGYbbO8P?=
 =?us-ascii?Q?ucw1Z+g9sssKa2w1t5thgomT0jJp6MAXr4YLwqDf3Hbwomg7R48+wF/caS61?=
 =?us-ascii?Q?k5yg6sLzFdZyuTl38yajba7QdRdWucRv4+Rz42hPkIQu9Avrv/pjpK+7fv5Y?=
 =?us-ascii?Q?ITp/KLt6F/gepMBTJ/YpbT1QDPiaJX04nqJ2zbSHEvV5S/fWD2g0fyhY0uq/?=
 =?us-ascii?Q?j2m4xkNDCZUOwMLkdWrNllbyYmzwdo6Sn85aKOkomah37oZ3MF7kqjMLE2Hl?=
 =?us-ascii?Q?3auDTMgNggA5WWLIZVLAhWJ4OQOv7dPA5qYXm0wgopCLeiOhiRnQsalhRDnh?=
 =?us-ascii?Q?wYtMj27/ztIsD/yxd87gMTjnPJx03velIAjOeUeygpul2FV+NeXkDUSdxHkz?=
 =?us-ascii?Q?78VWC0XNBhXJDr3ZcMIM36fU0Oiu1CdOr+1OAV9OpIEhx3tShhc6i353aPJj?=
 =?us-ascii?Q?7Erf1IjFM1rDxeSbNUEF+tbDRMvWT+5DBGU/dfwUZVINFXSYtLwhXusODtZ2?=
 =?us-ascii?Q?NvUtmA4CdtFOfvLKhl19uUNx3+XRwQdcR57YHYhWNMRFXcSC7Bp3RAkie98k?=
 =?us-ascii?Q?ZRH3Xm7+TSYLjWyQw25PR3x8fImjfOuF2xMFUklQeLNUxhs1ZEJxQlS4iTxz?=
 =?us-ascii?Q?zpSCPnhs9cLkGiZ2A7sa+azLZ+5pWm/Y8x401cSyfC/CwpTHamkQjJCfk9Ji?=
 =?us-ascii?Q?WOcmXa8uAYdlRCJlLZsgIz3H4dmrzHVvuwM6L/D7XK8/Rgh25edWabHXPhB7?=
 =?us-ascii?Q?vh0N0Joz69qwBNKLolyWPZlwREOOmwnL3jooZHe4UxmfkrsrPGMu5F3NSI13?=
 =?us-ascii?Q?8rlmGAKWmAdpGC4xG67Pqj0PW8Zi7fDQ5IF+awvGxHTh9DfxX2tewMxGccbm?=
 =?us-ascii?Q?2pXTfB8go3VUTgEwM6ggDn7HoZ++sDcUhu0r0UjEPGD/pPqwIA4qyhZ6tDU2?=
 =?us-ascii?Q?MECKKOEkFjLiH4Rv3TFVqQ8qS3Un22fyx7boIvUPuPMQ5A06MxdHxGLtQyKC?=
 =?us-ascii?Q?gNw+yOCeLvUNsXjBHMzGzsKpmWdrzIqUdSXiml0g7m4Y/36lNa5bCJs4Hbus?=
 =?us-ascii?Q?GS+LVpohZ5OtBh8U1+jOkEQZDkZFHx/Z9zyyGVyROaoPO0mAFGyrL6MOBo6E?=
 =?us-ascii?Q?aR+BToycvj471xIpJrKVP+2H9B+jRlYz/DgaoRBrw5bGeDAr6rw9WFMYZnM5?=
 =?us-ascii?Q?aRzI/wqES8qugKiItqu0jUfYvrIeA97XZBdw7dkD/g7lAzMTkwx4gwZ1fKW7?=
 =?us-ascii?Q?+aKnRbdWdpS2XYoTAoXwju74LJxyzepik5G/KuN2hCe25UTkOe4EOvOU3003?=
 =?us-ascii?Q?JQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eLcMR/Dw8udMM9nopFfTVkV6Rgp+4xGlS1JjNOPQBN5u0HF9lZuJ3JVT4JiLdAu3fm/7KkloRUrKPGOlkaTaornytolCjCUJyIMvngu1MdfNoPp4ys8/rJc13kbKVDjLdQNbUn3btJq62qqnfNRVcHL6nTrvYPY2NaWP7W5ndY7ztJltW1l6xweHNA1HNn85IM/DOCpFcbsCYxmscz1BoFRuhcKfpnQ7sfhaiSHLqgFU2qMfZkldBfcIbqUjTtKLibPbw3pqu4bBt16s1dMsE1ao0hSzjdBPtrCj4XrfD40oh67B5v+wHlPanOEDHe2yEeBmV15ibW3HxmhXkAS2IlR0RIJb1iQQzKfub3YiiZJvAfp42jwqWCGI+/jzPvC8h1/M8UQXLX5ctyzVyYU64Fo11JdiO43Y2SwqH8/OO7VfIyyAw0OPdD94BSegeZfVqfDBHFppAJbtvdBhdazmSYYP5qbwp3shGFnWOr0ohAVjL/rQlfnaiJEqC0moXxiEK1ozCED2vHV+cNRIATV8wjXGNRgcRe1luS4/1C7xHK1UfZtet5webZX9it7bGMXyo6YFBAaPjWzTB/UwtktJcY6J8zMix5mBdiSOdeeDRM6PoucHtEgeX2PVAMQmUMv4NxPHkZpCGSW59yUvWKa8NHZD9apmqyl/VoDyrSo02erDakXB7VrYujFQaZTCuZ/18h2rxaKDXDfB5SsjqEstUBvZ9WloDw4vTauvgT1ZSpHhGGuewf7P1Cp2SRH+XIZX620MRM4ZtVAy4ylIU6v8YNUkbvOGhQAa1vO5cvyBk1uwMBbvZ9/2lWAL7+0AyKwgToIlKA++zHlR03UrIkSxXq88BwPrninIlNkDVzUCY6zG+okLM5da+4/+FVvE7Hef
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e13e4b-4e09-4657-0b22-08db84b228fb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:53.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwibzrVK/ByH9pUA/rukO77+6/fNx60yeTm02O9g6JHeDQSOt+n/d3P/s0Mb0CKsnl+mRlSko9TJWotgIOGii6jxtkBdQHNxLvpREKK7Wxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: GBW7TgPeD7EI4XRcJZpzxUhvUdTto6OS
X-Proofpoint-GUID: GBW7TgPeD7EI4XRcJZpzxUhvUdTto6OS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1f110d646896..deac35fb520b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1605,36 +1605,32 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
-	int retries, res;
+	int res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	/* Leave the rest of the command zero to indicate flush everything. */
+	const unsigned char cmd[16] = { sdp->use_16_for_sync ?
+				SYNCHRONIZE_CACHE_16 : SYNCHRONIZE_CACHE };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[16] = { 0 };
-
-		if (sdp->use_16_for_sync)
-			cmd[0] = SYNCHRONIZE_CACHE_16;
-		else
-			cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-				       timeout, sdkp->max_retries, &exec_args);
-		if (res == 0)
-			break;
-	}
-
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.34.1

