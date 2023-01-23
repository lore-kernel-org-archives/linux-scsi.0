Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72823C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjAWWPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbjAWWOd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:14:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708F930195
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:14:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi4mN022499;
        Mon, 23 Jan 2023 22:11:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SG8UdETG8/T5tOOtF6sh4E4k6+6wcX55YJ6vLZ/YqnY=;
 b=m26kk7cmnddF8wbYpT7kxgrz/Tr+2f6kKYXX+Wl5c8Smoe8GMH8/3M0kjDHfIdmHIVQQ
 MSR5aP/lk0gsyHzte74ucnyj5O5ksi9JFDmYXy3juwUooZ+/66jIvjloDGjazFeduAwx
 EiGShBtindTlPRr8mTSzTOMyu8QcGUlRNeiduSd/4lfoTklLMEAa9XFFgEPWpCtRC/kw
 MOngt/ZSrGzFvWxfXRa3xrTUBnQhfSK9oAxTA36jnQPVTQLtqfwqb5WiZAk0+NpbvUAR
 ve/M6+bKYBcAO7xVvDWfZ7GviWCjoxsT/oo+rda58NLcbcfQ10dECIluxiLoTVY8dNz5 nQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa419y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLXtNp011704;
        Mon, 23 Jan 2023 22:11:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3ndqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RE8xa6ye3/7573IJgRlXu3j4m6D7VHr6tNllVs1r2lEQoaBiQOTtZrJJpj9w17rvBJVona1BfjJbxrIj8YLprtVXcWUEd1SKjzUdnJNSpO5JWbG4Ij2kXROiiqqHJyNefMpzhW0AYbDDbWn+oHWtHMQ6xD/0G/lISPYPpxQi7FU5/Pcro1kmMyT0lbFdkrnlyOyRxG8RsDnosRjX9wExyOcdCXUh98PLlcBqHSrYcFGTf//0kx0g5vK4PdrIntk6i6S4fAhJgN05QYt+W/HweyROxIQv20uplNEQue6eyCJYpvhwOlXRSrdHUUeuxP747z4WeYCLBU9kWjCQi78ozw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SG8UdETG8/T5tOOtF6sh4E4k6+6wcX55YJ6vLZ/YqnY=;
 b=FFbo3boRx38TNODvbK7bR6yYSbJ4cQDiqOm+b3+Gygxu7db5OQIi3me6/TLqL7z3Cv0Bhqmq8FIVmYOUYlGYwo/I3REaGcTNQ337oWVWe2MN4DwwzxAhdqPZ2UsafZlY/SX8KHj91Jzq8S9VnBb2sc3S8E60Y7xVjlS0SP3Tll37HcwSbdxR6s8stSz4xhhdNSrNoPt63ekaUPX4Ag+KXM7EPW0CvFbJFh4lymcHZ0mkQnkeEWXdLTc46sWXaFlP/H03cnX/3h97nMb1o1eZjjnJKtitmW9TH5vT9/Nr4lvF1lm+43fLcapzmRz8xCM5wgMP5beRRk62xiLQNCB6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SG8UdETG8/T5tOOtF6sh4E4k6+6wcX55YJ6vLZ/YqnY=;
 b=Z08TdQ1Lyk4p6INeLlEIK/d7ixDIcFOlc787LYO/bsTBNaqpNJfq6LhOqYItjxnC6hzbfeTMi/pgnr3x8WNnWSf0jm9OyQe2HYN9Gtx5il8LMo4Pc/veTuz17TfN2HSZWkygrd9RN6mymqAC/LEx4vABk/OSNjSO6kWlhXq7Y68=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 21/22] scsi: ufs: Have scsi-ml retry start stop errors
Date:   Mon, 23 Jan 2023 16:10:45 -0600
Message-Id: <20230123221046.125483-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:5:333::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 584cd1f3-4f34-4652-f94e-08dafd8ec2a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZBigT1c2pTNYxUj7bpzmri+osfBwEFbqcvqvR4d0stxkC3Vg+/3Tnxir94PPlzWpM2mSQIGhWpcWXrQBbak0kUN6i+4UHMtZzQon27z0p8CVvfLnEPdPIEAL+HhTKab9VGHmslklAIr4mePx5fu0qTU6xppxo+ne+TybL3+40SEcwH7h+YE8iIlcqSTTze0sG5fqBzHK2/biRgW58rBX4SSNIdv62JxUi1b3m79hCPk7ZlgjXvTtQQJg6EHPDwzS1rOABMcXlgp8pqeWEzcc3VvOJCYOzSYGy6w7XKLf/NcAZC6x+zDcUVwx0LO6HimRKkJuo1DdW9razeH5wOrFiAaGeCitK8V9yW5aeNrUrsXtho687FkjMUUXIPzcpWE3hBrljm8WeKQ3PnTUAHk5X7pOWyn+K2hp3eUQidM4JrWhD7w8vPe8yydiLtGB9MxgcqDiis5kEAgpI6IWDX6/++6ab0ZPb7nVfbQdB73dSP58ag8VxQXOnX9s6r7FACsYhyZRB5ZDcxdguHKU4FazI+Gu9+FJEQTSskXbkJFgWlHdLYlIZsz57JiQzRc+1QLR0kBOkyxbbqEsEpprBqeHpeDG+3VibsrWQ8kwfltzhCiipd5+FOn1Ch0AbSz2vJigCgOVLwfo1emuRmYZ2A8eQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZC/Pjskyhjae7dss4LmTXfegX6oawSapLaCN2XgF5ZUnW93+9aPEkz5DgJ+0?=
 =?us-ascii?Q?4eUzPL3PCf7CYdrpCdSjc68y2jDggYPLPlUh+5NZlN13xwbYNol6GKif5Br5?=
 =?us-ascii?Q?RS4RBlrAi6gM90aFeYWvAQbmheMqSfJAVTLGkPxoYYnnukQlC2Vxr1rEVPiv?=
 =?us-ascii?Q?/CpEQS/a9RKq9P8C5otNTDmxp/SZ4t1UVV3WFwK4s5RRjeWx5VbV8JgB97V1?=
 =?us-ascii?Q?bJGMNiLVDYsvP7sAxqovLd9XgdvQy+gLMPb9hV1pI8+yMY+JYz+pUeeSUm2Z?=
 =?us-ascii?Q?1/lmwTPfVBnq4C4uREw8JkqQ18juKiewgw6DUXDp/JPEpdDjExZEIECAT/cR?=
 =?us-ascii?Q?LjlWoHguj22HNTa0Z8dia91qh9G8icuxS7Y6EBCQiBTBph7Q2ssqF8vM2ySr?=
 =?us-ascii?Q?TI0rl6abWxFfAsKYa7rKlUdzgbGBdFn8rxpbGPJmeiPBY9+7dImF+TmpJAAE?=
 =?us-ascii?Q?PaZCnFDvESmrOx1RLL3Dd4VAwYyqKW+lCvSyMyYmUyR/QI2N6ZuPTg49wViX?=
 =?us-ascii?Q?G2tq2KqkR4BwruBktW3CtFR1eXg4c3FXrVeyvhgVJ176vdjhaXiMJ/xxhAGa?=
 =?us-ascii?Q?2qLJctfqu/OOP8ENLPZFUwk2kKXxSXHY1Ym9arOHMAu2dV/keFcyucVLEUlN?=
 =?us-ascii?Q?7xhXMXcyEIH4k7DBB7qETWEi64A5OIsGyFsTlqrH1KzO1ynENbeUL12mvZdU?=
 =?us-ascii?Q?TslfAmxs5wgTxhYQk4eTJ+fkW7FQxqBjQ89pRojbpwNnVDvHdSVPsn7SXjKA?=
 =?us-ascii?Q?48boRWci6G99Z7yYZw0ZHVUqB1QXi2m3eCGq/AGTJ70QgB3/X5saDOsZJmVH?=
 =?us-ascii?Q?cMTWGt631WyE0E5QoOSd55tJwjFct9/NM7QCZ/u1WuR8dpnW6CDsN6HGccNF?=
 =?us-ascii?Q?rDxGBDssSHOtTG5BcMbNiQPMVWWRM8sUWQuO3wFjT0CdG7M9ZHDvmUK4eGsK?=
 =?us-ascii?Q?LZWvs55jXYrPrT6UUNgZChpsCQ2AZzgw5a++ash998yFOlb4HgAl/f2F1poR?=
 =?us-ascii?Q?dkrsyi5QGS8TreF1FsPHMICVRU9u3wVFX8maYflokzjbaN6tBE6kFxhmWoTM?=
 =?us-ascii?Q?qO3rpav+neZHzjDnmI5qeFnQu5FzI/NP1cDYWQFa3qghFf37cRuzLh1g37FK?=
 =?us-ascii?Q?U6EN1+AaJl7a6ADCj50+2mKJaXjY4Dnl9HEWhpAsAKxLih8/BNHXTkmvZtx1?=
 =?us-ascii?Q?og0FEhkYPSrfG5G2OHV1WEZGQCQ8dCgkP9QqUoDk6bLLz0MMIjUVSr3DigCK?=
 =?us-ascii?Q?bQh/iVmoGA+06ECOXNb/mf8UruJYe3Gthvqu8uDAZKKvabnugN/urRMH8jnw?=
 =?us-ascii?Q?gc23FIpXstqIaIAiO1WcFHsd+cc+b4UtaezZ+kNdFVIgxgoJ96c8/RieMvHW?=
 =?us-ascii?Q?G4CFy6bl5fUfGBzFbXFCWsK9ylcfZf3oQzW/F+34eCyfdlp6I+SJl8FLKUFY?=
 =?us-ascii?Q?F5vmpYPdNgBCTzRSbh+G9NLLLmdK8euG37v1CWHpOWiAJ97YfS16d3+Y1uN8?=
 =?us-ascii?Q?xA6lBNmeecS/RaGnyxeTIniqL5h/4ssBoSChqpTJjUAVDVKux6lgzdBYWODy?=
 =?us-ascii?Q?lQ1zzV0WpSH3ip/NhptrrNFTi8XErZ2j5FYka8HvjUeYfTuDYtx61QxiA3Gq?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xau6U6Dx9fGfxXlHOqcC0afZGmf4Q7SuzCU+c/a+IvUZhTKapDAnq4VEIDPxA2v9ck9kY9+yVtJatYKtFPkmpL8m8kp1+ayQDi2PwHV9gDQpvbLFLTnpCfMj6EXdrYTdF5zgNS3+kPH0tLwhjYeF6laBySolL8Z2ZeD2WgkMb2pN4GLDjWnYeGF9qwoW1ckdn8sYRsQPQ1mHB6XQ5g9+9sUzR/zcHv7lR8CLH+SgvI4HmzIfE8DCrU+3ZT8iz8ulDb1pl4OpgsIlcZai0XtbA6tHKs0fZ+Drc/epjuSnQByBKF3Nwoxq8GxBy/3isUoCCPu43D2RrHlLyrjnW5v6tmx/N6wbtKtvsU5rbeC3Q+PgsVZhRKX2pu3RTFMgIG+4U1NusiR8mQaaC1u016vs9kAb77lgBK0C4QXrQE3c4Stsbsat24bW5hAbgJLRRN6qc1vGNf2vCJIg41IBxLG75aBAeKFqIGp3OxFQ02jmk9hba6IugK7SUMm3UG6Qw+eDNL3cPy1QXuViAtvr+R0y5Xm2H5410jQcUvbxEu2WLXINRnJNppCDZUa/oNsGEzQXTQ88K/Kusa+DxmBSGNuCH4114KEPt4WYeJ5V4kGpbAnt3RwBAfTL2jzLYuo9TAvS3WLWBf3ax2IlKDYG6ZF5PlMk+po31Ex1MFXgcvKtGRw2TAa8s50yaA3N9gePXkbuV+cZX1OvX7yjQeoHsjbarGzBqOCJnPTzdPDWWwKZWgQvunDKpNT0LNllTnL0hUi3Qq22bhE/32r/Y3mkX4OxIaXH+nPUwQytM/yzNLq0dpXmxJv5jJ+nt4YDjoQUaTPpmLcHctliCo1qhzsVzAvrsSNVsuEKP+C/YQDnQ+Awv9AlvFMgRgIoTEFN/aqUuXIN
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584cd1f3-4f34-4652-f94e-08dafd8ec2a2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:22.0396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p7kisjCSt1K1TEfCevbKOsNj+a88qJIGeTC03XjwqmYJBSBIkTp2F3MLkgcks0s7+ccRZhvtTDy+gUmo0QER7VyTXT7xEMxHctZNAUtMFtE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: s9ZWvXoWwyY_cesaEkeo7pBBvD2KQglK
X-Proofpoint-ORIG-GUID: s9ZWvXoWwyY_cesaEkeo7pBBvD2KQglK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 064a6d8605c1..9f37c3993d1c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9126,6 +9126,12 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
 
 	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
 				 BLK_MQ_REQ_PM);
@@ -9137,6 +9143,7 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
 	scmd->allowed = 0/*retries*/;
 	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
+	scmd->failures = failures;
 	req->timeout = 1 * HZ;
 	req->rq_flags |= RQF_PM | RQF_QUIET;
 
@@ -9167,7 +9174,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -9193,15 +9200,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	for (retries = 3; retries > 0; --retries) {
-		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
-		/*
-		 * scsi_execute() only returns a negative value if the request
-		 * queue is dying.
-		 */
-		if (ret <= 0)
-			break;
-	}
+	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.25.1

