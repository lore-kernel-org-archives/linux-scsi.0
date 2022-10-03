Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2EEC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJCR4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJCRzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:55:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D286186FE
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOABR029405;
        Mon, 3 Oct 2022 17:53:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=wy/V15K6nvwrhqR0IOFe/2l4oLhkIb2knvEN6KuPVM8=;
 b=ltrsbxUztK10D2mj469fQ1QxQDIAeNC3i7X5+LO7A4uOrKXq/IjbTe8ThxLiCDjbFHKG
 FwN0N8znLshmGA5fDQpvkl85wjpGfqEZuZfkZUbK+GYvp/hE7j7uU6Gy4V6uxS8fEPCG
 /jPg1FkhawY0T+wiFCogigajhX0Cqo0uarYJZ2WDlhWEsg/vHLTE2XH5XB8BAIxCm7W8
 z9myPvy+EWL+3ri1IWhe2obUSbAkNDVsgBBMFLPSCX+Jd2n2rRft+r65fMPMvSlQMe6N
 WlKSCRTFeM6BmZVKZWZDmb5NJB9YiigQvJv9bnPnztn2hFe1fLRZKb71Zj5j3jnx4I6i hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tc91w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xq015519;
        Mon, 3 Oct 2022 17:53:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JylqwGlVDqvzah7bbbaQdUW5fXxhj2nh8yD9CyZINDQAmukZedymPff1zmxQN9YlUSgHHb9CCUa8rtjItTU4H49lXTJx4aBNhjlf915WktjvyYpiP6D2Fo28E+6HwoU+Cyx40BZNiAagxpH2XmWz4SX16kpwy/h/u5rzuRwlAGdRqeCXJ67RPKizxM49dARQ/udtQnxKcEv1tpFsgbI4GIK0oTzqrH70AzfG8cxrLi8+RFk5u1FYULWhPP7DRRL5q7jbuVLje3DWmO8vTMaS+AxP3v31wf6W/iJSKVZ/HY9xUZ1sd+mH/1u229Zr2U+cLO9mv0RbeT4msCFPMAvk2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wy/V15K6nvwrhqR0IOFe/2l4oLhkIb2knvEN6KuPVM8=;
 b=RTMXC8qOQLlU4E1H6dywxDV+UQ+1y4py/A1WHl4aEamyPwVbRBQQPGpX5kFfQ8/cTkoBdaTskhSrz+u9JMwxXsRA3dmuDL+MK0sY/5lJzsfMRbR6zzCw+xcgAlzQXEwKnwm+cy4oES/cHJIGb76VdcFJ7ktT2HBPZSJiSsVsrLeUtAtA9biDry6lM1rDwGaB7YbiCq0KrrhdC27nC9FyDZij8jn9ICVqjw6AJVukNMNkEMfjJNu6wl+gEXd/6ckdETaYPy4LZPsObDXN0JjeTJVPIup8e7a/Y4k9VtM4BU1TRthc7me4MvcqYKpVag7yAuISWJlTuMUEItctXpaNdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy/V15K6nvwrhqR0IOFe/2l4oLhkIb2knvEN6KuPVM8=;
 b=UsyJ23W7BDfTQi5be6m6DBvLieo6PTRvOVDzweBXEaFqGHmj3akrI/aaGKK/lV1AkSH4WS7ndsFEiW0fknT+/igF2jTwQQcZsPRGqJUjEjwRZFUvGD43pn/2j37y/rIepr14OL87nfnyp1Ahwo6ik9tm5GKnjzhmnmmm5ryrxvw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 13/35] scsi: ses: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:59 -0500
Message-Id: <20221003175321.8040-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:610:20::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 871e2e32-7a2e-4504-eaba-08daa568361c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYU5FeS2rHeaXBqyRIl5ONUVineevOd+vA+kcg5tdQOgBZ/p+v8S13C457UlDewWj3lWjA3WWj0GozXXnaLUz2S7W3zGGGgQ/Mfee4lKf0S4cl55eZqJW1aIkmsoBrcSg5MAhiEnBjJF9XUwKPzyx6/BtoeeKrf6ZrEI7Vru1A2NJYjoaoCUmpatv4T6ZfoI0sS2MZJjhv3qAe6bDzJUMff0Z93VZ6hm8FqeMUdXkI/xEcW7K1fAeyNteFF9oi4/gjoBwisqqtATVGZJ8iBsEBlFhWHaftLyHz3W5xHeb+CsbMaaAPwqvKZBOl1WDBPwtFLO75DxrA8NC0CJbkr3dV6/Adtyv9WmSF7oixkULFepTb3HH6XwJfPvLfAz+z3FehlPwrm/np8+9UcUU9+U/RskODXwWmZcj0udLFgd/csLIBTuvIQ9OMgGixnfChhAsF4KRK4lSWeq7PPqvrpiwE0FS7bUBRktonuq5u7pX+4Xez/CqUn2fF1+oByeJFhqQLOVapJqeun2C/HOsoT/JNsmNZ3mpkV2jr/cvjDygLCmbgEEbyxuhMeL2neml5Y9UAB3jEZFPBT/Ly/l0SB7AxFsdq97STotjw1pI3virk0lHrdjYsN593YuysqfJktV1OBbO51Ld2M8xGW5lj8rHh8qvxzi99Un4sVx+VhwzUIZ9YJx89ytuHZmsN2B+P84+qijWkAmGrXR7Jp66kW0IA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ym2JSfQ0ltGa0vy6dfOnsYM8RpDvqJe7qn50Gqwaxu8Z5SMA/N4zHYF6X72U?=
 =?us-ascii?Q?c+ip4Bvy/lO4fA5ei4WVnTLgVltyGsGOY8L1jduudq9d+dqbfsAGJ8ZCZgwP?=
 =?us-ascii?Q?JJm1nA3ufWVwU/7vp2R2/fafoqynCZkTpKp3J+P0CGzl+mfE1s2OCygLroTU?=
 =?us-ascii?Q?SsijfBt2ActPmCBD7LsJFzkr2gJnVnpNm0Y7iMUzKFXRP7O4Lyzv4schS+Nr?=
 =?us-ascii?Q?F4XHAh3zFaYN6ze003OiC42iVqN/sLfbuK9/yyCmVMBOSrOUyhB/n9ivtRdK?=
 =?us-ascii?Q?E3h4TSL96X+LrZH2kBf9ZQlO5Y/nkIEhAz98j24goEHCnHU52IT4Uy3ossY6?=
 =?us-ascii?Q?Z/51Vy6eD5qS6rawAznvHPosGu2AYIW8FD5ZXM0Ef+G3v2t5bGmaePjWkbEu?=
 =?us-ascii?Q?7HlSdAkESsu1wyrP3lF9/8HhosliahJjQWJpTL83jSvAmdOdxK40U5erXSEe?=
 =?us-ascii?Q?xaMs6hMMnLu0IWH/RS5lBx2XUuWgtH+1rhDbEHPw6KvHxbt3y2bpfBt4gA7e?=
 =?us-ascii?Q?2Xu8oKoQFAe112XS9fVWNNcwXT1PKIB+IYN3dgGo2Ef8+5D5MlYoyZnRqwS/?=
 =?us-ascii?Q?gJtqOjX+rFi3Nh76a1Bu3DhwUNdGUeMfv8ARyBa+7CUF8+B+R6x5/MPVLPIR?=
 =?us-ascii?Q?qlgzzLetdTBn2zjirfGH0pWP/U/fldeMOUc+ovdXqIRbL7pQiEOpIO0qfruT?=
 =?us-ascii?Q?ngiGo57VA7IPQ/rHYIhX7DE16nzqEZW1RTJVL+8+DmGZKVgdfALe6KKgZP0B?=
 =?us-ascii?Q?xLh4A1G0J9LwZR4BAg+BS7QlhgpudkwIjBBVS9RHsTXH9LgNtlKSFeoMhmFn?=
 =?us-ascii?Q?cLbS+28cCfoyZbatb1LPD194IeylaIT/1wCfL5lb01MD76hPr38/oTVP8Ir4?=
 =?us-ascii?Q?IrtkzjSirhvyYzZJmqxdRySv+rWZ5EURogJiVREq9TebBZXGtzxiqvbzgGu1?=
 =?us-ascii?Q?kkN/uVxcWInWPkbqdhsG4C2tZrNf8aVFP8k2KfmKNXIPb1BDudOyWshvvY4o?=
 =?us-ascii?Q?K4SYpbapUWgoWDYOfyxg1US68FpWyrD6+pIn752Tea5GY94zvxoFapWhTqWx?=
 =?us-ascii?Q?Ew33CfEcW9P1n7oV0ovAjS02noOzsaKQJvEGseisj5OzLJvcRMB13rIPQt3M?=
 =?us-ascii?Q?Mr/Bh4iY1n0RD8qSIiqEOlARIHEFt3Uh3Xp2lLt1ULfo9IceQ/BfllmAncFU?=
 =?us-ascii?Q?VLXc25pvDYZoglRJpqcaMlE3oh8dsfmxTXtL+s1PAFDK0FW2AP+vIbVm7kvb?=
 =?us-ascii?Q?0YWcfmOyFrWflSUvJXfM/gvPVCV4YypahOkVMTbC3Uw7JM/1zBW9SqtmeB7d?=
 =?us-ascii?Q?C+ObyirflAaRC0oTPYTrSuGuMXKNxFs0NuBmlZmwLsw5RbNJhYd2AO3/m4at?=
 =?us-ascii?Q?r9ygqj3QLSGsWIqiEpQ8KkEKAvldW+GRguyxgt5psVAM3xFdOQUOV30miE9M?=
 =?us-ascii?Q?Vy8587FnRGePjX9jgFDeoNve1guyNho8BREBKs/VYw7g/jGXAi0yWCPjLGZ/?=
 =?us-ascii?Q?oIdhu6FQRPBcm2PEhCnyU57t5/hCvUDsycsLuAN6Ai/mlN9dfy8M11hU+C4k?=
 =?us-ascii?Q?dXfVSq3f6Hjk1ryzHdVR3FSKPYo4hRtBvs25dEaKQr0ERvfft/nOeSjqgnrY?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871e2e32-7a2e-4504-eaba-08daa568361c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:43.0486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hi6Bp4AzNN9wJYK9WK+o+DptVKYg9nYquN3BOphAK0mdwe/sI0vQiXCaEYITQ4LToy5aK2tLd8ktUHlTpR7jXj2JWMUyAHlnba4FB7Z2k2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-ORIG-GUID: y-xLdlIYBM_-0OOgj6QmmwlbUPAu7azF
X-Proofpoint-GUID: y-xLdlIYBM_-0OOgj6QmmwlbUPAu7azF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/ses.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..c90722aa552c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -91,8 +91,15 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_sense_hdr sshdr;
 
 	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL);
+		ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = bufflen,
+					.sshdr = &sshdr,
+					.timeout = SES_TIMEOUT,
+					.retries = 1 }));
 	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
@@ -132,8 +139,15 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	unsigned int retries = SES_RETRIES;
 
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-					  &sshdr, SES_TIMEOUT, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = buf,
+						.buf_len = bufflen,
+						.sshdr = &sshdr,
+						.timeout = SES_TIMEOUT,
+						.retries = 1 }));
 	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
 		 (sshdr.sense_key == NOT_READY ||
 		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-- 
2.25.1

