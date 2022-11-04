Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D7AC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiKDXYe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiKDXYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507EBB7E8
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:07 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7C6013354;
        Fri, 4 Nov 2022 23:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=Pxg6F86JKt1+UnXmaAU7UDDRu+v8sQI8iwlAtk3fA+OFg0y9WReQCmpH+xUljIm65nG7
 wij+TO0H4tlWGJF6Av8fc7Z+UW5IL+MD4RjkWljdIO/hy9fYwgr+F+S8IOX6cYqeHKpQ
 q6ZgFfk+KmuW13XZa9MdsBKQg/E7lAwtYJAgO/4qGsmZ+4Sawol9hr7SZ2ZYh1waWsj+
 WSO5zSPeEBb2UyKyyOVEgnibQKFI/2ZKUhcFxpRY8wmsjjgVVpF2zDjXSNVeilVSJ8y/
 5cxZcBB8yaeA8UkKeM9d4z8mHXNh7wBJub5wE8mmB2QU2jwSmzU5U5ynADybheD15Dj5 Dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4NC4P2023061;
        Fri, 4 Nov 2022 23:21:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwp09qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+FBF9xXnGuwto+McrlQp5MVo90FB1MMvYfazIS+kBRvzJNiaaTgNcIK5lUd+2OhcKkAZs/6i7UH1Q4Wkl0bsRA98+/8knfFLkLgfkraLXR8q3bSR7eLrStl3XSl36Ksy40QOUiZpktqb5MzIHLuPQ2FRaTr+VpVWfrYv3t0w2/vXDqL6HBVrJRiyQF8YUud/9BZr0RE5eUxmqesA/vh4rWNWLR3FDcsurPar+hPS1UjN9udmFBiX1Ipszw42PClPXHvbr9hS0jurLygSXY6Z4aN7gbvRSli49eK1jZ7xvn5d7JV1iUM7Sr4wVzzHNeVGtZT/3vhx7mDJ/5T8BBFxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=Xo4k7pqX57X3dfQ4sP28u+h9+kQbDf6JlFWB7KV+1/9rf4FQc8la/a0LK5fVXkQWpmQcSNDmtl+mXKEBNf8kFw3Qq31Ff+VcfDPLlpyvHYJQzfVMpkL7lha8sh3/p6sRbuQewGXlXZY7WA0NTqTJjZnGnL3PYLyvst3DTjNT+EyDfEYkxba1EtzCroQcAg3vbo8vgvfNTnZ6p9ro/KZOAwGarTDQ5PbUx9dXRqkiANA5UUCPEkkqp7+2Aqz/bWKrwi3QN1eLQAQiPG7Nob9VD2h+eE9VPPzDMmMSsEXKb+nJIHGsEBachpz2vM6k6PzCIyOw8QksLZhX1UVSWe36LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbK6EOCeB16Hxeh5BeQ0zE668MA1KGgbX1F5LCZEsSM=;
 b=Bz9QV0M823X3wpI0s88TsGxuTuLmEcaOJsUggKtRAAhiuihIqxwryDb2OWLnnjAYWFQrRG5KMVa9iZy4oilaEs1deMtjFIfOQQwAjCeBjVvTRu3L6Mbtb1UwmDv9gD+5x4TBVWillwvAGHEo8+WJJ/XaMYNtz21UkWXB9tvxSJ0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 17/35] scsi: cxlflash: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:09 -0500
Message-Id: <20221104231927.9613-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:610:74::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: d79d4682-b337-4d3c-f909-08dabebb591f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sDSKJNmVD+FZ4LyO5x/0lP+DxImO25Woz5Z+dS4kLXt9B/fBysyE4Vb3WVT3gY12ogQhB3XbI0JV4c/UsYkUA2KLZiOCO0E9G8OGX9Cpzgc7X59SSp+/aaPodmXgNXqqUI8NqfalkkRt+1S2PCfDKMb+6+8J5aMkDT7xAbi7mfKGN8Ft9RhmUvoR4P+InsSKgYGkoma4FrhYkcbT9PR4rU1/OyOoVBMIBGiPQoTXLCUlUmBqmxmghvJScMJcl6MHbPWS2T5K5jalJmbVWtK815MVaW7ybOiWVdoQHW6yraOZYq9jfub+SA/yOa4Tp7/U9clQGkwGNLjTyWOjWUpVUVT/eRTbc/sNzGOKPftE1ao07G9Yx7dry10wGny9CRcZZmXeQrmwWLqVgmhSkjPVOCljmaW8Y2Ulof0Z+iHZFW+dNi+ZFC2VtOwyQWRHLFRrf0xgZ0wlubI03wykRL2jwtvs8cBJU8ughp4Cxm5CZo+pxDqhMYoZWVa5yOti/5d+oxYXeIlTu11eaG1nyqTIWJS+ZriXAcGJ6Jp+DNIQjO4VO51tSz8wI9+oobROH09IKvGwVPPJSS692+vTorCjVHrxm6NhCLOvXgkuUP3iowsdGLX9KJUetNXLV1QZOEFiH0D41VLbPzqBuCZT6oDKImIw30t65gd37C22LuEyZOqC0e9hlyq+/OhTW/7vss4uvPN/Eaj3nK3D9qzfdtIydg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k6AoCctGYzXSV5Q2EnFeaNb0I+3s5E6xO7YvDQ1LXCadwPyTayL+13SXxvk9?=
 =?us-ascii?Q?d6b1fwKaL5brIiKp70ECPhSK7qWsuN0j2KNJl3wjX6R8gFwFl4YaDtA7Ha5h?=
 =?us-ascii?Q?AbFOM2dCfsyM7u+1it95H2qnxRW9b6DzYrJ4XIbnINcOrkLHoqSCvFz3QmuB?=
 =?us-ascii?Q?YuYdZ7eBxMr2XbwT2Bl4pvPA8ibIEfSPt8/g2R3LrZ+oGDVpTElYXT/38Sj3?=
 =?us-ascii?Q?GzNp1cS7O3DjxdUHm6DrLw/Ja5owLBqcPVvx/6qCcKl6Eg8GvX+Rl0kY+Aqo?=
 =?us-ascii?Q?HnllnnDG7ucBE/4qnUNHqEAZB3ah/LYBOg7U6kgBixtQGA86weiKSYZb3P+6?=
 =?us-ascii?Q?HKz1r6j0we+co2POQfN4ootP0q5s8zakYox5F+e5ikMiyQH4U13BrOGEMPaN?=
 =?us-ascii?Q?EM+OlRfHFPNDEmoaiSgUJgjUW37MjQC0mlz2I2BWiepNrZZHq2ZTvD5k853N?=
 =?us-ascii?Q?f2ZpmiBQyq16EL+0Wm9GzIstXQk2WfwjDaI/ES7qRzf7F9/m8FjO4QqomAWa?=
 =?us-ascii?Q?7AiJxkRrG17dA5uBVrWRHk1nctl9XInaGSn9hQFY2zHqhcbsgGvEORmDOkgQ?=
 =?us-ascii?Q?3hN8/fP1aY5BCg+R6/SRuI8A8kaENE5jaPfOm0jOTS7UTzXe+Q7YsyTydpVs?=
 =?us-ascii?Q?yKnHZ0p62iCwrvUxYWufd1umHad5fJcMM9dYMf+CzsMwvF2fLUFgIXxwq9nM?=
 =?us-ascii?Q?vJhtGSlT2QyLgFLpXbtW7z7jsjN80jczphLUo48h9l+IaCNOWlG2f2Iul0gP?=
 =?us-ascii?Q?MQ2MCtcc6Y+R2aDkQjAs9rSynHE9HM4Ct6EvIpy+QLpIiAwno5yoIIWyf02w?=
 =?us-ascii?Q?48Cxz9TEdpXU8qrBlJqUO3ZqpshrGuChBY63P00n/KIk2Ry7BJirMlXU8qVj?=
 =?us-ascii?Q?E49nJYbNwIQPQXHc75CWsdU2OXn+PkL14QrceOnfggkaG1gO/k5vFfAgCoCs?=
 =?us-ascii?Q?y6oVV9XkTtioeTZNJ8YFow26MlAD3MndydPedV3oLWHDQA3v9qYxy8u1LV8M?=
 =?us-ascii?Q?oXdQqQKZ9xVd5E54lso6gjH6vdMydq1jKfXV0q+uZ8TGRRByqE0E1O+UW1Rx?=
 =?us-ascii?Q?UC97xJlmITqt3QlT5vDsNI0cmlNcxcFpQmaof4Itez8zAhC4p7sDbSMQXhEH?=
 =?us-ascii?Q?+ZNP4hun+InwHe701MVg6YTVnac7WUFKwgkjOLJEVHzaHsSDccJx8a06kIu5?=
 =?us-ascii?Q?1Xxl9EBHdZZ4xP5Dfj4jnyyCNCAoq2pLqEsMb+cm+pJuO2THpGRId29cRv/U?=
 =?us-ascii?Q?JIJlfH4FvAH2vCyCGck49e/Ya9j8gf015iMO3KklH9LVMqefxDxbJLXYHp6H?=
 =?us-ascii?Q?rUOLFwocUBuNXyXdh/MLh80RgnSqxJjupgJhqnLGU1A/BFKp2Po/+3EIun8c?=
 =?us-ascii?Q?T7Eh+KBGwkxmnqIz/NeQlstJrOwzjrnsFEeZM3EuzNxCz2wEREQ9ENDajn8f?=
 =?us-ascii?Q?TRruOLqHQdhAAO1lhil15jUyDjIly1NNXHBobm/xTb2l294PpNdm55m5DmbZ?=
 =?us-ascii?Q?ogUH57Cd9esHFNOPc/h4OEkH1GAYW4hFMpeMOpTRzeDColyQDZO+Q3YPuI27?=
 =?us-ascii?Q?y5JFjBxI82pDdxSySfFr5+V3nAUw8QaZVWsDz6gBmtGQPgplVsef4rozHhuW?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79d4682-b337-4d3c-f909-08dabebb591f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:49.0713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z+cMIwF5iDI4yhsZyfV3ENtnD8oB2NSnMJsPxFs5kNIFphR7ul+wkfD6z7YaBru15Z45pPbqMv3m/qDFfwdHMsR73w6SIoLva9nIoruYaYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: VA-6tbvy10ITPHtzAeOBdSlHcUcLylSi
X-Proofpoint-GUID: VA-6tbvy10ITPHtzAeOBdSlHcUcLylSi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/superpipe.c | 18 ++++++++++++------
 drivers/scsi/cxlflash/vlun.c      | 11 ++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..724e52f0b58c 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -308,16 +308,16 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
  * @lli:	LUN destined for capacity request.
  *
  * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
- * in scsi_execute(), the EEH handler will attempt to recover. As part of the
+ * in scsi_exec_req(), the EEH handler will attempt to recover. As part of the
  * recovery, the handler drains all currently running ioctls, waiting until they
  * have completed before proceeding with a reset. As this routine is used on the
  * ioctl path, this can create a condition where the EEH handler becomes stuck,
  * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
  * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
  * This will allow the EEH handler to proceed with a recovery while this thread
- * is still running. Once the scsi_execute() returns, reacquire the ioctl read
+ * is still running. Once the scsi_exec_req() returns, reacquire the ioctl read
  * semaphore and check the adapter state in case it changed while inside of
- * scsi_execute(). The state check will wait if the adapter is still being
+ * scsi_exec_req(). The state check will wait if the adapter is still being
  * recovered or return a failure if the recovery failed. In the event that the
  * adapter reset failed, simply return the failure as the ioctl would be unable
  * to continue.
@@ -357,9 +357,15 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = cmd_buf,
+					.buf_len = CMD_BUFSIZE,
+					.sshdr = &sshdr,
+					.timeout = to,
+					.retries = CMD_RETRIES }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..4fb5d91c08ba 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -450,9 +450,14 @@ static int write_same16(struct scsi_device *sdev,
 
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
-		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_TO_DEVICE,
+						.buf = cmd_buf,
+						.buf_len = CMD_BUFSIZE,
+						.timeout = to,
+						.retries = CMD_RETRIES }));
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

