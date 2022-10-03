Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D83C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiJCRyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJCRyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1643C8DD
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GO9WH029401;
        Mon, 3 Oct 2022 17:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vSdNeyNoLlC1eSdgClcalmCV24FH2zgLAPhKvFETZ7k=;
 b=1kFs31QkP4bZqgWxZLiJQ9juvLFjw5Tir9yw55ekrybdjVYg6D9wIzla4pVJAYOPa1Kd
 pSWyX7tZk7AUHPV9XelTT070e7pPWIfeZtMRzRcobLFBizXT+ZE+GqndfQKUO4uQAZai
 bKnFYhrWl5lHsfa+MxaaxafIHJWQdslBHKPgEqedqJBz4OD70Y/ypPRbxiwOq6vUZvMR
 BMs1yIhRFxWcejUnbRA/sBGjItTP4bQKYpKNxytsStbn9lGMVzh/OHLSjv0mFx6qSZAQ
 AAjQePcQNO5iuHLyVdCkow86MetrlXnwaJgWy2fV10jwdlcDnwrG7+OuJNMSD2HYSOQG nQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tc91x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xr015519;
        Mon, 3 Oct 2022 17:53:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjSec3GAi1s67kpqGnjliO9lpSShFZ3di3HIfJ6HFbraNpTnztjYWfr6osyQmANF//CjR6QrYB6KOpBraAdTzY/P0ISMZSILWFVo5C97QqUwMja9fETMAzISbMgcgr364EeeT2V0KVHiV7tf4UNfz46CMJXFv68zujb+8rC63ayBxDmPC09PEH/bMd67f5O7VDefF7yzpltWtDBeekp05UcPhTVNCAVOJM/IcNIl8qs/cwjahU9ATU9voDvs8GPcc6rOHPncA3+0CmfMG/fuHcswLz0nUUWs5dg3avhqzUooeqWTEQ60BjBBECcPMPV6sxb69kFSRyr18/z3Ocpdqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSdNeyNoLlC1eSdgClcalmCV24FH2zgLAPhKvFETZ7k=;
 b=d6KqYHCBIxyW9EYkmO+wRF0RjnJV1V3178crHgBj14ncggNpFqBS5ZUjjXBOdnVfVyuExXhXHEJ81/OC8m1xMgPQkBEbxu2iLADA+gQ1/KOzrIXnYb0gDF7yHeoelVdrdnMNzngWHHhQPA4vE+4yq9AP3snCgL+LHoiLFzv62/iYXtc2+1hafARC+uOix0cJIeXzecKcFkdo+2xThkSMMq1gtTe3YUZ8C+Jy5TY8v2hG+rAeweObVWhoTlzUOgdu0aCF8oIsXFsbeTotNBba9e75TGjrjdJiih4XNZTPT1fxkVh6kV31UI4zx7+F6Qx17qK5janiUDYrZB0zTEQU7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSdNeyNoLlC1eSdgClcalmCV24FH2zgLAPhKvFETZ7k=;
 b=E0Leg8zcScSImZlMDrD6bnej+01J7A6Ao/5T2GI+z3s8t5mPyn7ATaVWY2NjMqraEUSG8M74GqlDYnYSbHi6MFTawuxn3NlCRcKqKsrVtTukDmM0uz2NC4Jr3zYepgrqjrP9j9uHchOGKonI9p/CLn36xOpQLV+gYlaJlWcGltc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 14/35] scsi: sr: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:53:00 -0500
Message-Id: <20221003175321.8040-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:610:e7::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf9d191-b1e9-4f93-ec86-08daa5683727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3qyKYq9v/dITjY6wEjvafiVJNeu3Hu9sxUGSupKztFmEFCaQetR1VdL250oc+e5bZqne/r8/jwnm5UywfFzQlr/ypAKowDgPhaFUgBT2p7mP3XF8ymemgUqbksQtYbDLnAAS3NeV71D347s1MpRWdtLcmBhAylchyIOlgmPzbphOeW9TsJDthnXjg1ntObpl6gEXYh6H8XyjazEVyawPHFHUjZcYROWx4uGSxDB86YZCLZ3TvRNvcBs3H0cFxH0fsWXag/yvUmy8EmLSMLX5z9ClbQ+IE6XwJiUH2Zdw7MSWgCvDc3T4l+2YGUo+9bzwxhcYV2iEjocm+OnRqfb/sX+GnbnpsTqpo9noyONcocTc7ORhZ0o7VOZn7IV7ob1LEXl9Jz4utDdYoFgdOyPR4IwrvLn2xFEsTZEV+zC6wjojBl3Qs2Gb0WhDCeFFHDB9FXMaUNLIJUcS89kO5US9GaurlMEQPzD/t414QF4fza0FnuwD5GQWRhb/ANN2/mUI+OjlEoOjbDFP+4BjTNyprGXFaFxRXkzPd/1Hb2qrIMVRbo/QjU/3SqwQYf4uBUwf6zA8xTULPNQpV41tenp7t/LXNXgfhhIyExQmQEkQPcNKPi6spNEHqY0qyy7X3inHEd2tSMm0zJLKWM7U+goEAWjzuZF43F7ls75qwjkQ9b47JgiuTpSUJK0fCqePaNNZUVXIJBXrhdvzT+Y/Yhdvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DGR0K7Jm2YoQ1AJDJs9Od2+j1z2je5H3pKvXKYqvELAXJwVq/R7lc4tl9uWb?=
 =?us-ascii?Q?mwTnPfVV2AKuigfj1f3cSduGEiFCcaXTQUQ0uWu8ZuPujB3LvpUhYrCFJsk5?=
 =?us-ascii?Q?E1f007G8WVe/H0JsuVMP2xpJsezrACFi7JEhByXjzpPkzghbDWQq2/fJ5ixt?=
 =?us-ascii?Q?TwtE7XH0Ruir0Z0RZcZ6YCoWlgdv0p/vkhKWjNqvRSYSrax69FZ//Xk5JWce?=
 =?us-ascii?Q?pT8E3/5uZmdu0D9uhGEDIt9XVaKChYe4SX1+Z3yHjHkiEodG/yVNkASinHb7?=
 =?us-ascii?Q?P6wsUCBskyCsLsVzeSh3/e63SYc0bXcD802AwffT0KE7+pHYGJ1wwXpCWlIq?=
 =?us-ascii?Q?UY49f5yCxlkf/8zyKjJRJ1TY59RJrZ/ZsCdqmrqxPuK30EUT1bSxpaz3PaVZ?=
 =?us-ascii?Q?2GyZcwX3hjNl63c2LDDndRL6nCCXawjuaZM4aDaEybeNHhSBjppRpxeHDgmG?=
 =?us-ascii?Q?LiFfgIhxIRvdbOTnlwHdHLC/CIQSf8mQfH4wIOSRhhf+9apJCU3tELzkld1e?=
 =?us-ascii?Q?BWcJTUqRJqyze1I1Q9atI0pzzv4RuR09JTf5lcWcKL6+BCYjri/yVBQY9Cz3?=
 =?us-ascii?Q?FMm2zWmdUJlUOYi9xaeQi+Qff1fAZljsnE2E+wibUy5518hFK+RLGIvFprlO?=
 =?us-ascii?Q?K/hHsAMBU0M4yav0RCZHUW0HpMl0FKN25bOB6v9dsHAqCixoLr386uPnAkHx?=
 =?us-ascii?Q?2SUBnQFAZ2F4L5GRuQZEJWcS3cDJJZ5+y9bN04Ph6q1CRdiNpp2pGBqHDjx+?=
 =?us-ascii?Q?H1+xrxGKZEN2MIsapVuEpKcCv+SVINWKwG9p5UTupJz/Bjb3HjQycXZp+Urc?=
 =?us-ascii?Q?dd6t0mYc4cntYF28HLOLQjzLZfQMnDYUSsWznZxGYwIGWtvJgK/Kqz8Jqy6o?=
 =?us-ascii?Q?Zueownxybhd9fetwY+DNBAeOsKnrj9IE9o6dxhOtdZ1I2E/zjdCCrGQujIh/?=
 =?us-ascii?Q?aCCEwDeXjlobiEa5gu0+4q4gWIbF+GtdfBpMWl9gYrLotQfUv4uGHVUEjr6N?=
 =?us-ascii?Q?WgDLblr9XwCjEOSQl19Me5Ln3qgY/MNf75kNte08rAKVTn04a6nGthyGKd/Y?=
 =?us-ascii?Q?9BKrKmBIuY2XBLwKInUjddu7GM+Xvm/Ay+WW/ooDY0QKXXALtnEggyU2Gb/f?=
 =?us-ascii?Q?uKHq1SpdkjgXNnb7BvGsV4F9IExkl1NB5H6izdYbw77vAGcEdO7SGuLMbNmr?=
 =?us-ascii?Q?xJo6AxwPu8xTbcHm1xaqF/Q5mh+v4ocYCyZfO6ks8UBgg9D5SuK+Pi5NV/Xj?=
 =?us-ascii?Q?qQWkFBPg5O47xxC1FmIBvTfINGII62ZardLS3bijPsWYO/VaHVn/yo71J7+u?=
 =?us-ascii?Q?HIkAiGIYgF8ErPXLw+Cm0W5+cJt7HHqWhAhZtDrmH25wLEjy6afeiVdPZfRB?=
 =?us-ascii?Q?PZNC1njAVusXPkaRGKGFQU0rwimpucZdirqtqgg1T7LgCqaaOWmBSdX4/7Mu?=
 =?us-ascii?Q?/jyli7Lhgp5Zmqy4qhW745CU+ZnngPk7J+CGzO2wMv577IQkJX+9HaNiHlCp?=
 =?us-ascii?Q?KwNY4IBpSbz00uy9JYWr2H+GbnRYpEdWbMdeRlREclZA2ZyV+svrif6c8aZ7?=
 =?us-ascii?Q?0y+1KyM9pWpOmd/ZGLgDuTuGHVM7y4fddlWuh/ZJy75o+pOusYz/Gc4YpAIF?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf9d191-b1e9-4f93-ec86-08daa5683727
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:44.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lhg/bGCNp6YP7XOgoooBhulUi0KLp/Tp+/jazwRiifRcXIJ3ZsXAIpRVaDi6k6yMs6FabWp+sEszxHqI9jUSnOlNg9cAi1aOHgh9tNCRKO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: Gl7usXkmt4a6jk7o-NyhnDi4WQSLdalT
X-Proofpoint-GUID: Gl7usXkmt4a6jk7o-NyhnDi4WQSLdalT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c       | 22 +++++++++++++++++-----
 drivers/scsi/sr_ioctl.c | 13 +++++++++----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..e3171f040fe1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -172,8 +172,15 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct scsi_sense_hdr sshdr;
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = sizeof(buf),
+					.sshdr = &sshdr,
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES }));
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,9 +737,14 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = cd->device,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = sizeof(buffer),
+						.timeout = SR_TIMEOUT,
+						.retries = MAX_RETRIES }));
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..3d852117d16b 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -202,10 +202,15 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = SDev,
+					.cmd = cgc->cmd,
+					.data_dir = cgc->data_direction,
+					.buf = cgc->buffer,
+					.buf_len = cgc->buflen,
+					.sshdr = sshdr,
+					.timeout = cgc->timeout,
+					.retries = IOCTL_RETRIES }));
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

