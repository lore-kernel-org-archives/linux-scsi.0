Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB7AC6FA91
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiIVKIs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiIVKIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99889D58AB
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3rUc018189;
        Thu, 22 Sep 2022 10:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7AvuctKnPhKcjN7XEZ88uFBqTFN721zRfXcQUICQ5w8=;
 b=i7exjhvbUMP0QMYvTnfDz2Pq30+CtaASPDlul+OlnBOTMb063wsSJaQjHX7xguThsZ/F
 Syes3Ddd3T+fYoWHlpevuMXwupww+WK3ZjV0LiC2p8R01+5K2W+NSipDUFi4bBOVAgKg
 bAfsnsPmT55QkKKvFsyaHL8n2hYVnh2DFI9y+ldOOoXdCOF6AODjqoFFPNZR1mQIsIKJ
 hctNRn7sPmwSD2+Hmj8uJ5yxcUR03P6rlTV/64VXt9ei6rjLNcRWpkqBo7NhkQ4sV6uZ
 kgLOnQo9uTC1PELGxMZyXalyH01DvqwilSi7FXF8rWvlUqXFDdxKrGbnisBB9YY7fI6Z Gg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69kw1sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3w1032017;
        Thu, 22 Sep 2022 10:07:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fura7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Of1yM7ETblJZSwEsQdnO1eOubGEi2Nl7WJdN7WYA8bxi5rGTdEtG9mP3FDl9Jz9hEq7qLJluIrmOgRaSP9kZh1rX2jU7V+DF8LVpGtMNvVEeT++8p1ZXScv10pluhrX+LnP/iTz1QMzO3Y+HoMNLQG9k5xLDW5VXL0Js1PmVtNN8DdS8WdluE/g+QI1avfiadrW886jWjLbVu5hl3soUyKmUIdU2mp8ZD1ta8QvhDtLYYchr4argI3bDVg275JuoXZxDRMJ2ni96eMddHPrH95qvUixfkaj3vPvxYWlhh932Y/Ws9ZarG9Kmq3qaYGjHO5ZVsQIAmz7m8+xtyo5pTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AvuctKnPhKcjN7XEZ88uFBqTFN721zRfXcQUICQ5w8=;
 b=gUer9DQknvNhm5R7wcQwc4lOUyjim3oWvWQFS4vTOQXapMmdOoqiCD16KmBJDbNrdCqy7pxxd0To0dIz8J3PpKqdEyDuYnBlaXZLw8PVGjxDY+kD4fKxfd2gRu8Q7D7YILq3NLuN+drMH5riXkVGUKavP4Csoexhl4EKqDTxVunPcbDMvGHtY0Fh28z7LQuSplXhdVvmpWeDj/sVunJAMsEaRD5obTFfGcqmeYnXCFYDujqaKWaFLMFSdlHnUJrS8lIColSz5qAC8LKGT2gmtOjaWaZz1vWEAtz6o6N/pfbXmaGQt18Dpa6oZn2iKLHWI3kD2XG8P4TjaRcXW0mI6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AvuctKnPhKcjN7XEZ88uFBqTFN721zRfXcQUICQ5w8=;
 b=pHEsyGkbXlFJMcY0wZ3ect/yGODjlTKjIyXM4yxq1pz/wL3AR7D2r5EAsaO13km3XkUqdj2rotuJ38/1NsI5/s2w9qVJkoCi6angnbui19MOfqE2Rxk/yBmsxmuMh/PYB2jaHN2rNajfWpn9fSVjlKC5VB/vp4bFqe0YUyqCw7s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 19/22] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Thu, 22 Sep 2022 05:07:01 -0500
Message-Id: <20220922100704.753666-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0011.namprd05.prod.outlook.com (2603:10b6:610::24)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: b349735d-ca91-44a2-92f5-08da9c8246c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHtta272E/pAPAEHoC24fFuwRbm3eTh7YRzDmkmf8zk7H9sIDMoLMiZpP5dd0liwDU2iYtDb0Sv7Di8OmKNyPYmVqmmbFeLeS6QFsl+HH5x/gYwKwu7LlVAGXwjePYTCswydTN06wGTlyajizWC9BHeBP4hlVZwraBhXi0WKl+gsxVHD3hXj11qjwMoFpPvX4XTquvysr2u30gpQXviWiiamPPGrAS3fYW722MSqN9mHTzrIsaAJrs2JN9ND5UUIdd2BrV6+wnQZbyit5axTTOKGHKmRAuW2xuQ0DwusuO4LDPkIYUJxyHGG3y0LvTYlZRh/7WV9RX57j3Kqujv8rSREgsyjLg4USW0+8+UT+aGk+1M9q3Dk3VkqLVahXktFmWkgiMLK9Ik32I51p1MoO9JVH0o9QDZQrV0MnnfaYfRMhxM6gXxhwlhKTUjLZImCWwlJEWrWH6O+9WYAjJtSCKpDjJsmBuP8haLXBZNPyhorEwYOxCAVYLiTSIP0rlGNTimwvtJPe07KxGol+fQChZn+B9mhYYd5DF1N/ECncyk2UEZTMU+oblHPAnl38qIu2vWwoEYLKu83LqpzB3fSrdpJ/9DHmzGzce+aiP7bk/oLNwnziJXXOaJuiApX1H4SVUco6+0PSx+XliHyb+6PRsGCak7S7tEvBktAezvlM0THnqoTmvu/4AxY2BpIHP5iB5glZjKdIu8QCyp9AAfWaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t2AdJXB7yqT/Xo3KcSRYBKclucXtp7vtFaqW8GAK3rCLdcsubWa6HatGA5lG?=
 =?us-ascii?Q?FDmt3cTkP+exkkoLbx29SLV4EyC43EiLUZmwdUYxs80eEBjU8F38SVO1df2i?=
 =?us-ascii?Q?9LowrW6Gt5xkuazc53kAGLdVhrDIbsN8Y99/Kd7Ly8e0SntoFs7RzjRQg3hK?=
 =?us-ascii?Q?04Gf3I4jjrCHp+LLqzwHVAh2TNquMh7KUlkrb7M2G9RZke5zCEcBc6JrTQ88?=
 =?us-ascii?Q?TArOmWvpvGRaxIvAvqGsq0dM73m4ncfDsuVbeiSI9JRuSJnFTpbY8DriZWP9?=
 =?us-ascii?Q?6hJAl6cRt/Wrh2cCcP6Kux5nG7h+jwnG/CQFY5xjsiyUOocloq4pyIJ8QMJM?=
 =?us-ascii?Q?srXiiCCWQXETh9Is49Z7j1FKXkTwXx9u1+Ug3jgC52kvyix7ej+VAwqHblUO?=
 =?us-ascii?Q?JWVSP9YwbL1iN5+twKkK/MLXmqca1kb6JNXHlySvoBQVeldD5kbTa9XWrRAw?=
 =?us-ascii?Q?RYViDt/qIGzRHE2VYARjvcxd8wr6cw9TtmyoC+Rc4JVc4l1bqDMZPa0AThRY?=
 =?us-ascii?Q?IZ7oLxGI0heCSq2yI4mICrP5S4IMcBIhYLslrR0bN9/5ysFhPeIc+DE9071s?=
 =?us-ascii?Q?G0RROkvgL3EuK1cWuXd3sYkITILJX8hPTNVmEgkF5GNobUAJBT/OhzKq8Ts/?=
 =?us-ascii?Q?f1cDILT8It97JZ/vzYS+On8x9e+ehDFU/sw3fGcYDWJkdKxnwb0Qi16G//Jn?=
 =?us-ascii?Q?5zRTqGKsoielQVjdjtfp7zCXyysoY2Zs4OMgsq/CjN4KOb39i5gSsNKuzqW+?=
 =?us-ascii?Q?HzNParleO1bcZphMw0GVmikuZXU4w7RguXmCMDGBLOhkbbYIM9CGbBQOmjM8?=
 =?us-ascii?Q?5ddXEtqsPi0IRm/LhMRvMCdWhbos8SobcTmOrLaQuz7TwQ4V8wvgfqbNhEwx?=
 =?us-ascii?Q?tx4VKHk+s4uGCpgjOeF0j2cOg4c54ctOhy2F/aoQvR6cOHBu70B4l/F5G1Ra?=
 =?us-ascii?Q?TKJ88Tpe2iJfkThSw4Sz9fGQt62/SCpbKxuYTCC+GuWGPUlytpbu1irbkeL7?=
 =?us-ascii?Q?FVlCwv0gaSPRovEMkED1cRQLyDxwclg6jUpJkVoPSKDkxuIHC4/WZSqQ4kFC?=
 =?us-ascii?Q?qfZDFHIFHZpLDDWQXttgx0R14qFIMkCkKx4JLsnaNhQ1Q4muUPut3LKwlUu6?=
 =?us-ascii?Q?O2N187VYTcMBSf5XE1gIZTAd0oJkKEAf5ONK3FBSFedbidV34Tlgb47DO52o?=
 =?us-ascii?Q?V3SnYOJAxRQNSkQh58aqOzM0nNM6nJ3qR+7PyggkU0xUjkQySWxWvLyZG/85?=
 =?us-ascii?Q?oWn2CV7Qsr/CrMs5+veuvZoj6xUFGPgQE+fMdmFty+5xW4mn7v40LDtoq2vI?=
 =?us-ascii?Q?1LCpBiothZE/90opTrj32sH2e+mM3qIS7fWxownZaWSVL0kUjPIs5/mIqK6f?=
 =?us-ascii?Q?1mZfPF+BW1sweHOUr8CZvgWX+qyYEueeOBRZ8dilYVRIXbcZFdrbc0itjcoP?=
 =?us-ascii?Q?/xyn8dtm7ZmITThoyboNENmT5ia/jkveOUFggFzF8zemwUIYqZfCFQoDITvF?=
 =?us-ascii?Q?Er614VD1zASzNFsE2mv+28kz0De1gUXiYje1+MJE3/tvU1jU2GTb+uJmZ3CX?=
 =?us-ascii?Q?ylpC3KPhF2AMkI8J8d3ASRHXCIW2XwcY9j/TvZAPjBXZ3RnmEASYZuPcwsue?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b349735d-ca91-44a2-92f5-08da9c8246c9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:37.5049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0LZkOlboW9dzlINb7NM5F1O7ftn1JT5QBJhhAwY5Qa+iHHr82xHJWv/zyHDknMDdOjESWwm0RgG58Z9CVYy65Esv97cdF7k33iCUs2a79c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: n7ne0hUX0IGoJyrqZDbDkpOPFdep9RZM
X-Proofpoint-GUID: n7ne0hUX0IGoJyrqZDbDkpOPFdep9RZM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 48 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d655549dee94..f6f7e16d2a71 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2362,36 +2362,34 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
-
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL,
-					NULL);
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	cmd[0] = READ_CAPACITY;
+	memset(&cmd[1], 0, 9);
+	memset(buffer, 0, 8);
 
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
+	the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE, buffer, 8,
+				      &sshdr, SD_TIMEOUT, sdkp->max_retries,
+				      NULL, failures);
 
-	} while (the_result && retries);
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

