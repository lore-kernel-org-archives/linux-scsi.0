Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829E6C4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiLNXwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiLNXwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582F0167F3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwrO3000481;
        Wed, 14 Dec 2022 23:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=4odf1ftkPYdTztf8BKOtCtqg7LfyAZ7pMtAdPXHa1g8=;
 b=H8ELS+rCLjn65IvV9eDv1NrIULa1ISCMjSBGiEwZYAQEzIQvr5smX1SWGb8nkx/Z0kYo
 cwbIzhu+cHyOi9nUjhPuFUbZUQRbHz0fXgHlaHMja24t4oXqIO21ZMZK70ehudwczBv/
 GqThJeZRci/P9u4RUUkPX7Ur5ubT4Xq0CzO5k5YcYuoO+iiIYy98LAGe9fu8f0q2jGyB
 rzYFhxrSlucjTfH2G5Eprur4V9OkNnHqY9O5y/yxmLCi7SjJaYCvswRsm5ZgRv0MbJ01
 MhSkusKYn+2HSA341QQ6NLuUOLZrAi9yhLeWjSXDezJeCBFhvAdB8R/0R+/sEPTMaxRB 1A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewuqt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BENSaKf003943;
        Wed, 14 Dec 2022 23:50:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyewunx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSZeHmHAmUWI7qr479r0KmGcj0XV8joWS9Rs+AX5Ve5LJYeKCdbwgTHJ0xGPxdkxBy2O9oOXrutCmO4QUY3L0OQiwrZepZbl5bw8rmy0IsGfRP2pYj05K8ssYwVUQW+idWbrfDu8ktz+WGb3gmJIJzJ2DCZLDrCVu0+36IriREGQxugKkzq2fkrCZWoPzEhEoyCRwqK1VEOPB2n1JpDB4B79ihVX2c6jJf8QhyYAI1cGpHCbETuepu43AoiLyRpUyrTOJtosMAVXNxIW8X6eWu4ZkQ7RQ+I/IcSB+hlkCuKU+6svQ77LNK58LgQT9FCo4dEfD6cMfkcTyc0CcKr0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4odf1ftkPYdTztf8BKOtCtqg7LfyAZ7pMtAdPXHa1g8=;
 b=a//NmTTsCr1pJsfRCL6496AtRGQRQRRLL/4rYAHy/9L23ad3A0TTxHbMTvbmyiLm/Ry0wlzLZdjxOjM1oNEchfe1NKSaQgeQxZwCFbhTixMkk9+B2tWsTO8/hsY1FsBQjX7MORAXorLKshtqDw00Sg4j68E+V0XTNsmy4pS1Zxk/9EKq+Pqtx/6BwnqhaPm0+WfVFxMLExmHSd6eby8MloH7E0coiJcM/6ALhT7S+HGwmdjEK6yrcQKDhB+cVQQJP+l8SysPydy4NVuPFe18Un9Y40ex0rSnGI+FVVVHYChP1xX3J8mcuxGOMiHqPKBiolcCcP4l4JGzg2iOL4ClQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4odf1ftkPYdTztf8BKOtCtqg7LfyAZ7pMtAdPXHa1g8=;
 b=g8a0z514VvMH/PEa6xzuFapn+ZB1JpsD8mo+gCSj/H8zyUvRZU0wvzT02ui6YROsPdSAiZ6V2zqsokMJ3YjpjSELpulDd6+PIbG9a5xBMINdAqxaeP6/wPsGp88qFEpigm8/GFerKaDyMxD/UyoIBvAJmclGZXifys6H/xjeETA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 10/15] scsi: ses: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:56 -0600
Message-Id: <20221214235001.57267-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:610:5a::37) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: c8a87a93-2a50-4654-f97e-08dade2df53b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a6MMkwzevjgkLoppg4/uyIMyxCk1xVrBFhGVmxt+Wdm8reBm/b4/Y1XhEPV8EQlqSeuav3XiSynlPS3m3wpn3HuBpd7bnuefWH6kD6hjbmKUUukupjNbo0hm0tCnI0RKgLPuoelS38VUUzhi1HLg2/gevGFoi2eK4uUrPgZgErBBeeRjVkKxsQJZXAc8zfAVRFFhkDDm4uB33bZSM4Nt6spQcpJAHzXqVJBgjyZp9kJscvLddlK4e0l85I/rUn7fykjq0eMLjFJ6QFSxMsFl7D39WFC0LUeAzRaXyLm4XnxegN9vtz3N8Lre5XlHnph7hQmJixHBArGBqU0Vv1hzuFQLOQRgJ1LyMQpv8GXDPCYGfxAUiUa+u32MhLnHvVd2OmkIavin8qlo3rLw0bOG0cbpJiC2YeQNVXKZE6+aJ8sHJA5y2ptw4CMSaUvk8TUH5jt02iNbUtEEfsvDJEtcnWzaPv61j/1BByXod1PTiibWB/w0pnv2ELkxKGYPR65+wT30kFa2TKzhG8MeSP6Q9/7kAjaDXIjQwEnV/vQEKcNVa8wHPGam6EuiQMa06rFHmp9tPQ/uDKJt7qR5kgZJRKSGUmhT6u1iJF4CKZfCqWlUJ8i3TeOY5I/rt6ZxOvi67fwdiUoRHCt8vd2+wTgxrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sB/YcgpqDqZKfsmk1HtVTjPyFL9ZgjZDS6iv+iA3neNdVNRjuklBIRVDJtf8?=
 =?us-ascii?Q?/p+IwiS0d7PoVC67dsBJTjHJvpiVTAFDnkO4BnvdZ+y6OlsH1nHKyvWPlQtf?=
 =?us-ascii?Q?eE5bYcKJmm6wNZRTKFyLHX5mOksvZ0qSU6Q3DTiXDE3cphAfCEblAcOQBHQY?=
 =?us-ascii?Q?ZZJmD6X0os2LTWmiCBMBqv9NS2AtLsjEdTwHikqhIdQzPx1FRYC5tpvd+HqM?=
 =?us-ascii?Q?0GkMYa1eEfVFv4UaDjr0EEiaJbfKCrU0vnv89jrJa95V+wdSWWgw5MhIcGLW?=
 =?us-ascii?Q?chlMAFcDAnpr6LGYQ4qWq8quVtFa98IbMAtMbrFy/TyJO0HQH1amIifapmP1?=
 =?us-ascii?Q?FdJ7LTjj6TJ52Vb/L8qw+vUXPaiOBTBOxFu5y/QZT8wH4WFsFoM1ZuWjzQzg?=
 =?us-ascii?Q?DFBD0o6vSxoi0GebvK3oNDWK64y4cTwGeH7HfpudUW65ak4ShkBNNlpQ2jPv?=
 =?us-ascii?Q?+UL073wmDADP75F5ysUbRiCfZqfA7O7nhFwZiulxRHrguIj6S5HfPeeMBYFD?=
 =?us-ascii?Q?1mHVnzjvNa2JU8pKvZ0PrcjAzVHegB1Suoy1KfRAzWp+CxUQi7JdUeiaTP0/?=
 =?us-ascii?Q?YRLh+fKeC0mf4ojCu7hUpbQLAc75diYy2xKJCzO6a8GVzLvwSLO7dDPWq7Fx?=
 =?us-ascii?Q?MlfyJAZub70ArCIqyue1yxfjnMFpOsUs4nhtRSafIDGOYa97QveXrZY2jj7T?=
 =?us-ascii?Q?emxJjKdF8v3f4Ydr9FhVJDlgva4yQbQBhmWsbFuxYF9jQWSdcJSlZQ8ZEn5b?=
 =?us-ascii?Q?r2G8uN6+bg7EIUFgTahXpqRMGgubKePCsxBDTcfuM9T8obqcmZJeC9UoZbVx?=
 =?us-ascii?Q?zaDEVwjdMqANbAHtJzAprVK2UtNEfG6y0lwKEDLxzIizbwyglVHNqY69Jhwf?=
 =?us-ascii?Q?DXt9eM7ReC7XM9ZSB/JPovxqxESLeL7OJPajyEYdfU3C1/M5VHmVb0uVEZvn?=
 =?us-ascii?Q?8o6atCX4OTRzdeJEYDQSACkVqm9tgDxB04NVVM1bnmYVS+PRKj60DMwFWnDy?=
 =?us-ascii?Q?MWaWj0rGeWsAr213r/morWWcPg0h9SFfcEvCdoIMBdYDB906THBdUSBAupuO?=
 =?us-ascii?Q?/Qi0doyr9Me1MIBTEVE3n75XsieH7mMaMDQelnqr0DQO/LU2aMZEfhy3MAkc?=
 =?us-ascii?Q?xltPTQdLsGO5moSEkb8ONrXC9bG05KaT4GVJoMUiO2aYH9vr6Ucn5WlWCMTu?=
 =?us-ascii?Q?+3gIm1hEzxQ6d/qjePO3qDnh+qRJPHZjlUfIvLLED86dgslFWNPbZStHuPWy?=
 =?us-ascii?Q?xeT4Ol777zV6qVVSfOF6f1NvGVXHUqn7J8W7DdHV3ki3/ColmONy7QC9Pj2t?=
 =?us-ascii?Q?bopPnrSHv9AVnZ0ID9zcgoZ38RhdJDhTdEi1qIVF4NFwfHgBFctWF1K3YP8H?=
 =?us-ascii?Q?8GY7PWj+XL+z7IIwoPuD7qKu3UBJnLBX+38XkUDuSSygazagxI10lDmmdXhG?=
 =?us-ascii?Q?BoT3kQopRL/hGvNjIZRzSPiurMdLCZEojCINJAOsT2DEaQaktejcsNyjudh5?=
 =?us-ascii?Q?wEu0/3l0aMfBMGR+gaPY7osK5Jn4j5NEKa+S1PqwtLYHrwkydzRv/7iTCVHE?=
 =?us-ascii?Q?Nsoh7+EAJVr5upwV1fasNpnR55B9nk36xiIHdyT0LsDki2XQFzq6g415U2x7?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a87a93-2a50-4654-f97e-08dade2df53b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:19.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCSzcnNf6eVnzM23uC21lHZLEV3sUQURFzGX1ZiT5FlgzjhZVj8+GbH0Zk8TCWEfBSTYbeBRUXcklvfjXCaXbx6kuDpTf1PSxy0SdAhhBBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-GUID: AJO3ZW9QfaRgs7pvJOfCYzfs2Cb1-J-c
X-Proofpoint-ORIG-GUID: AJO3ZW9QfaRgs7pvJOfCYzfs2Cb1-J-c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ses to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ses.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..869ca9c7f23f 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -89,10 +89,13 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	unsigned char recv_page_code;
 	unsigned int retries = SES_RETRIES;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+				       SES_TIMEOUT, 1, &exec_args);
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -130,10 +133,13 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	};
 	struct scsi_sense_hdr sshdr;
 	unsigned int retries = SES_RETRIES;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
+					  bufflen, SES_TIMEOUT, 1, &exec_args);
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

