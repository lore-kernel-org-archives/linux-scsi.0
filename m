Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D51CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbjIEXRa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbjIEXR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:17:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE325199
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:17:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtjMH029203;
        Tue, 5 Sep 2023 23:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=H3bN2J++3dXRI+yKekNXfuDFv72H2spSYtIxlSeSkJ8=;
 b=lVnab2od85uwKE/5L+72t6AwEUGsF8KUoWcSoZLGrj8aXgMNkD/RQExrhuttszSGPFUC
 y5hHojRVtQziIqvZ+rxPcvebxDK+HPGr6oxHfjPgf3tcJ28BuPnS45qFHu4y84AMbacr
 PL1iEeIw0YkKZ0e7OV3B/cPKRhcD++AG6URZTkR+C9JwO567WdJOYVtHosI0buvcZhzN
 uqfjglXVtUEPequ/i0uJkIizkFdrSG6kmIuRpVWem6Lz2EVsF+2MD3YXFSbJshroxHD/
 tCU4cALHOZ5PZTeoM1vf55BNyoXZLKXe3uEm7O9pw5R8O1wOwSXZwZrN2+muInXFqHi6 qQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdj500v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M1gNF007729;
        Tue, 5 Sep 2023 23:16:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5exey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYqbfO2sVqTdOscCLb6Kr5K/Vjl1/ieywMpfpik0EIVxzSfddlHBRAws2seXQLkPcpUL4LEJ3YjwZ3c6p1OJrEXukIhY4tYNw0DDRp4WbYAxHIaBZS8/QLDGjin5vzKrKWGzRjAi+8RMCeWU7Vfhq13JuKehYs8JqE9TD5ELTfnG400pXsEINZPg6pv+9Yy3K7IU4g5BCB0wmO/yPzGFQQd+HKGoscDdJCf+GMq81uaV5JggKofa3y1DKlcamrkcxLR3icHtm7Y/FFgwAoyN0AjyVjBl+vYNSWi2Z7HUmzvXSgTNyF3/gWJkkVF2zfCqe7PfaP9bsQGTH2Kg7P1NXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3bN2J++3dXRI+yKekNXfuDFv72H2spSYtIxlSeSkJ8=;
 b=KHnq6v0HCSdBDyeieWUuj1aNStJi7Tw/YgfFgv6i0ctot7qfZ2M49mYxQiZqDVQg4SujSL29Nm1PJQOpQx0ZAgCrMZs1E9o/fdpXiQfqeZXGhD7Yk4CiiV9O9MZ3V4DvN2ujfFggopfH0zvuQgjW2IgG4hXoxcGRzA/mKDuKWyOUejRFT+bKDMCVO/1yp0FZ9SREQU3um05WcZ+Z3RzmE391Y27GNOK6JsQBcWrqj1QPNaliiME3dKOMSksw/npOE8Kn88ZpTDDZlOp1pF5fKrB0U18jJjRcL5BeS/5YtjePFLQyoTHq0yQwpAt5gSS+T39bFRHU+dafCJ+vP99jDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3bN2J++3dXRI+yKekNXfuDFv72H2spSYtIxlSeSkJ8=;
 b=xovUCkNe77RUpxpu6npuHAZmGD1IYYlG11O6gwGvqwaJzPd/hMs1+1l9XVte/SylWaOCrnCPTbEvx8d9zuCMa+wUQA+M5a/bfOXPmKwbydDRWS9BeZT2gmUq/7Qr/t7KpVzgsNQZpG5qCuLX781CZ1eTCNk0MMVBpkB0HEzAc54=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 10/34] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Tue,  5 Sep 2023 18:15:23 -0500
Message-Id: <20230905231547.83945-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:5:80::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a251a2-8ed5-4df8-5477-08dbae6613c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YmDCu0xVm+Vr1+NvIsA6UnJ+j1+jpKIp8ClzQPJTV3FnFiBz/BA6ourGAZHrsQXUwDu0ggsgSuomRzdoUpV8rYfjaGdJzAZo8Lm/x2utV3ET601EyvpJs9iNeZ1zri+9YgxMerip0Ijt6QrEOac5MJMocpAVRVUAbeKlkHDbCba0/1TUJb9Hkx1V7zOgoXTVIPNfbM0dva/wuVaiww4G1jqlK7MvyvS8H/ipoKklFzuA75iZ3a1GG0Z0iU433YlUYMIC3lcBeGR6WPJqwTMKeimQ2R7V7fxgzztw0FfKSh7TIEzRX2JMTOT9UKIgbgyxCsEat6vP8Fm8U8wfJ+M3LGS+IfcswQEIbrYtJ7QQOSL1Ld+/vldJkc1aEu/d5GIjSCLDgPHbcBpLcicA4HOz21fH3o/gvJPfo0hPag5Fog7qd7ijbV4Wfyq6fgfbHJJxUzeJZw6sLA98SXamRpr4rsmBkBjpocRmhdnsPCMfj+fNJ7dcUeqmLm7cZt/D0PYKaQPfkE1y2/ueYm9qq0zO71utmjXzDAFutCV8j2DxanYt1FQejs2Y2hQ1OmVlzS3T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6tTWimjcrO1LlCWQYU+fNkTDJ/ywqpWDRvf9YIa7egtFOHK55WfmZUTd2Wis?=
 =?us-ascii?Q?lh/WvUJv4w24JlgwnEF4gWvmPvv71IIWgPc9F5T5E4RJUbCbAUxCVD1b8Dim?=
 =?us-ascii?Q?aM9sIwyPYHxKYNfZrkpg7bmPwGqZeb1jr2WJmqMGfmhIrNZIKGIq50GB/kY3?=
 =?us-ascii?Q?Mqzwvu95GfrDQrHvy7a2wMzhnDLmp1I5a2fDbLUM00scMqMCtGtYgeP84f8J?=
 =?us-ascii?Q?WbiusE7gjpGs1YNCTx0/5UvGlB3lZO4g+Dhrt1sdpHEHuZmRDQum6RhxM8zg?=
 =?us-ascii?Q?WchqESUq1EjzNePG1r8ASUZPYcggXg7fcxbZkefD4XbQKo63p5NO2ntMyIz0?=
 =?us-ascii?Q?uIpUrQQkIG1NDa7QhgQiwaF2sX3LHd/q4tJ0VU2ivPDiYe3hM3vPBj5qDq24?=
 =?us-ascii?Q?x+QQoW2cFn1+mTkBpNXhJ8SypV/3xzsnnQupTPb3M3vplPvmBlht0Wkb5ZVM?=
 =?us-ascii?Q?UvmoSCRrEVng51dB6WUBLmaWaacwcfqXUlAeDSJLystDfk3Idk87jowL2yBu?=
 =?us-ascii?Q?+0cjZ9XagxXXrzZnjyQiBHglEZix/X9h9FqSgxhoYaqF4qMzSx/rqHHk5OGD?=
 =?us-ascii?Q?m2cn1/UtWnXsG9/nqb7bQyzVfCO5B5fZiqzqG+s4WQ1UU61KGUH/jlR4CNPh?=
 =?us-ascii?Q?wsNKtimI7A50t5o9vtbE8JU7XYlfTYMZc4NHJm4DLmyBubU5q/ph5nARmnVh?=
 =?us-ascii?Q?zvKd4lHgOcCLa3i4DEaj+xbChEP1yyqGSe4twNz+bF87lil3p+4C3c09X1te?=
 =?us-ascii?Q?v9PI/lKy22yoi1zjQEl+3ssIygorKI/Ah4YyTuAYCneoPXiBi8WBjStIY6fm?=
 =?us-ascii?Q?RKfIZ7Uw35tq++sReixyXheYigpr9N7qZW07/b+pgUETFrkFzjJ8Sg8LfPjy?=
 =?us-ascii?Q?izmrtsYtY9N+jDbEaGXJHpw6yyLK1Vmye8KqOhCCyidGg3kBFBHzfUqBkJOm?=
 =?us-ascii?Q?ZNwKu3zNw8M3sxfkU7d6pY1ijVu+hG6HA4st5H1VAeSbNPhbAvAfPot4nuSE?=
 =?us-ascii?Q?LC4wUwpm0vZHcp8YXt8Enj3/5+jLfMVMuzXyYdZ8zf2xotD4C3sNpLDcyHvg?=
 =?us-ascii?Q?qIW8iqz9uHjpiM/sDsd472w4lacMfPTc4QEVxVifuHPDTd7dxgpeLXlRxr+A?=
 =?us-ascii?Q?vqENu2b1Hh5WGp9aJ5zVGToVNX6wEFFRjZLRLq/48moVCmZ02TMIlA/hLIei?=
 =?us-ascii?Q?QWgXlOb/7JSV66piaRbsxk/bvO7rg9O+k2yaWCPFJgxRkFy36cJbIaXxCEC2?=
 =?us-ascii?Q?wMsjglRpEy+9DeeB3RQ606BbTtTbiSHr1dcrRXEidUInRB+nVDPBepgmscuh?=
 =?us-ascii?Q?h+aCXWP1OuC1Q4aSW1n5fM3W0Y88oJeAqDfFXwB4OFmxlL3uNZ1b29NeNsb5?=
 =?us-ascii?Q?So7vCL5SpxOXAF3fiI5dDOJ/2dKIdrUgNRvlp5iXvfJgW8Chjh7wDJepSuyv?=
 =?us-ascii?Q?IP5W0wUOXaoDRyXsM1Glzb7IRRjqZ590epJo8yatVs9BWgK4Sb6qPI/OZxrv?=
 =?us-ascii?Q?+setH+z/cOShvgPHRUYvjUBS29wKh1RBR0zNIDRJv7S2WdC7qUrk2zl6HDC4?=
 =?us-ascii?Q?dA53tiFzBjcO0TilChWGQQT74dzIJ0KBZFzRzqY68QkEtZ088qHipC4eelng?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HwvLdW8iFfsOahnmN9gjNpAC2or+zaPI8hfmhnJUCxbGzArZuyzWSV0LrRnCzkl+knLS8N0AExFiIws1HULb2ZBviQRkXhxQKUYqFTst4sJyO1LcT1iKhdAcV8l49dvN+Vut6lm8GUb/etFrFAq1DyOKRE8GdF53e5dAm9WnYnxGduX3e8CH95Xqh6WG2v7WtcZopk8zfMSMp/zUGfs0WeXC72/JUnglenY65xkfyqrC9ilNBYAtd26Ioz+q45WSSxVTI7rSysMvsf9W/kDCLHms7ssk34/rUwFJ9/QsbCJiPvllgktZzp1L2t2rgi2sb0cheIdAMNQPZQKt6fzUggOnK4cK7K080b1hMsAs8Qtb7fOUgOwOCHaocyVBKIXp5otaHm/yye3GgR5s4Pj0raxUXbR+qi/qcmC96mOa3NF2jDwrqmbrj/RMLhUJX+jqF0LwscZLUQAy4A2aa2fmEsLg9odWFWYJFE8Y/LvGTxMva5DBwWktqU8jHf2WpT9JsOFaaVfaua8IA15GDi7/nruFxdfJ6vNT+AgabML1e4J0yBkIk+0JMeLN2du276I/D7kRtryaFTWkNLebFDaP3yfAFlhV/k5a9TBSbRMpGaLJt+dW3eZ6DDzrwAOCbyfTksqX4uFbPW8t23D+t6zSbbJmwJf5/0BhFyS5nfOPAKFhE2Q48mjRkLQ/F29+saLuPzQupA+SALU236XSqXIECSG5VEC0c+QflpmqiZhn93NwbaMA62pF2LiMZDEc2xWlmauCI0cACh3loog9uuZWzd4nAxjwV0w3iABIW+21Zikd0O698oZ0274GPui7i5BKZWRgVIe/AzuUar6v/YH1F2dmNDi84g6LV6qlpnifPJX5rCc+xJtEKV4joQM4uMpV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a251a2-8ed5-4df8-5477-08dbae6613c8
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:04.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0l5vjiMzBUfOm8kgjcOW7qnOvIC4UlJ0bOGtAnJkpWoYPx4iZfMz4w7IaW/GgnOx+FOA7H14h0FWuzIsxoTMljnhR0kTJTWROJighC45OMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: lTapEZbjxF_BgGKNAiumNyt8M__zHeQX
X-Proofpoint-ORIG-GUID: lTapEZbjxF_BgGKNAiumNyt8M__zHeQX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 73 ++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 74967e1b19da..f5e6b5cc762f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2151,55 +2151,64 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
-
-		do {
-			bool media_was_present = sdkp->media_present;
+		bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		scsi_reset_failures(failures);
 
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}
 
-				sense_valid = scsi_sense_valid(&sshdr);
+		if (the_result > 0) {
+			/*
+			 * If the drive has indicated to us that it doesn't
+			 * have any media in it, don't bother with any more
+			 * polling.
+			 */
+			if (media_not_present(sdkp, &sshdr)) {
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp,
+						  "Media removed, stopped polling\n");
+				return;
 			}
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			sense_valid = scsi_sense_valid(&sshdr);
+		}
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.34.1

