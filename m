Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E68C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJPUBn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiJPUBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9AF43310
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJluMw004999;
        Sun, 16 Oct 2022 20:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=KI0EKuLOiV6yDuwv0zbU8n/4l6EXJOqEFdqcGcr38NXAb2iV1VRnA6QmlBmz6oBvLLeZ
 K3dKV0BCQToBwH3rNAUjMfsu1QhVVxR/P2fYgSbOXOAcDWZFg8hG//3sZM8IUsknHuEz
 0H5gAnziTR4uaMOXEtMdM+rceuNaw39KtmUqnRIdiGlTVwjEvIL7PkzMlrwyMbqKl5xw
 IlsMyE1yTZPwfi7Tt4PFV14guujlL57qfxC/o/himqf9ta7BVQPlw0q7bhK8wSu+IdXl
 AeJ3oU3or18ANwe+QPlws2//otptuzakbfKUTWhMuWbGUHOX6/ki6eW9bIqTlZmXwcP7 fw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAk2e001153;
        Sun, 16 Oct 2022 20:00:11 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmh02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be1toX1YaVuaIDK4Gnz7iduiyM+XwHcNr0AzqbnrTPc/vCgOtFRXe4o+C29/ScqKZ05WUypz+rgOPPiwGd0AYuC4r+djCwCkyhJJ00HFQl/GQZUVrQ1ddk6YPFIsNw2ZArxNZbOIcwGrtGMxjtg2PkKpC5ZSVByN6qZo7ZKA84kCdzHrlOpOP1UyNPhsFFQn6m8+FCBzkweTpJVMtKPTypMrj3y6qIFbTCZVWgsqpT76puX7UTPoK3Rv8Qnzvr4PnFrZ3Nk2tRgjs5omEOrLr3XtAK75Tu+2CiCE99wE1Y53+MOCC73W6v05Epwk2F6uSzE7qLZ3xEDIW2lRj3B1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=gtZo0+GGshf+ZFMElQIAU3EwUtPdGvATdrZRCRV7NzdDeSgr/dgXKO1VlD7QfkgSTvwP1GR30CCmL5CwDSxEjx68ajkH9le8c9Lep4tV27CMxI9/RxDGqyuNZ/O7YbB9cvGTBUfBX/v6pD3hSIILTDC26VIETd14ZH//400h8r6bokgb1691eaXW7y/doymlfgsm4n+tPlaI2zRGj9HuA5A5jcsqVC2hkv+biQNDbgzW2SN0Pq0fI7roMdt0eW2pZIPSs+LSYQHB0/TbW1W6ililMlvBdyjb4HrkP0jqZdwuP8BAVPjRHcTn8wsoKv0dj7f86YpeJIoQxfqZD3pypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8P7VsBo6ia2NGN2xi+jJ4Yb+k/2sWqCIymwCu5ZnsY=;
 b=KrhbYK/UAUsVZhJYC1JX0DIZAjB2W8iU+pmJysPyfwJ9J+eLrkr7e/IzSfp2sG11WTquZBW8CcmMum/l49cSKSlDr0H6m1Xquk2JkOW4OcvUVsNbL6oy5lHcgkNPgLs6cM098ZA7RKoI0nEfYqNTxZy4wTJGk6GaOGsBZHvtbbY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 13/36] scsi: ses: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:23 -0500
Message-Id: <20221016195946.7613-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0197.namprd03.prod.outlook.com
 (2603:10b6:610:e4::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: f54990ec-f09b-4125-affa-08daafb1077b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5fPTdQyvboQrvTo50b8fIbYARS4YSh1EgGN9iFGC0ERYYt/yG9yuR98HQEybG582BWxhdAJd7SCblLIq2Ic/nukjm+PUBomZnYbScKVthBMAExZoQ2J6l73P76R2WHFlJ74DWmtACQ0LmRsXum6aS35Lfe/QvgQZ1pxCbtuQeNqG+ZCigqGF0dcjVC1PMFna3CIRYG4RGq6/5Px+reDGlO+2yK4rUqZJbYT0eSZngukH/SdABbpplFRm6a6pwQo2PDj5UNhwZQXK3kyAjZhct9Uy4P+mEQKCRfj95mAC2QnNQ5x/Z2WWKJ1i/mWvZfm5K9Egqo8hnqPNw1z6qM8HeWkB8MxI077+5sIPEbPYepQTdLVfwTgI5aUj4MHwqBXBh34z4ZlfL92dxw/Jvw04lk8CMDB9Pxb8TecmlH9LnfQY+YqrKXIALnqWZw/LF3i2iHgPZPMq9X5/9bxYK4uA6f6hTsdsTf18xoCpaQPezGUgk50JcEbWHMbLr3iumWJCKUz1NHytAbMMtiqpVci0blkNha5PIg45zvfXWG9mWyLorNW4aPiVp9l1S741ifopVNjNqZSTVUll9fOUfGJX0uTZeHBmIPqO9HAlu/FM2ur9GnsqRqLK7c90GL3/zn3HyuSy2R5C5qn672NkKsGuKyEsJNE3hEIJEhJ8EbvIBRHDEFaqJcnzxExu214jtJ7qW86CLzIRwZEf5DikS5XqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6T8aKcFZyGUOO1NsnKipgQPx+ihP6bxv9Yp3fsbSQxzhxXRz1TC3pOgDv17I?=
 =?us-ascii?Q?gQ2bulN8rSqX8reZ66zWYi+OF0PUSvsKJ7NMvC1tG0Mcdop1YPVCoQg9VO59?=
 =?us-ascii?Q?G+mH/28NwCm3WTVn7EV2nnjz6dy61EP4NYA9XGMo4RqzUXUhQcwcvwC7eZjB?=
 =?us-ascii?Q?cbZf+EFiMgCYhBSeBhbw/Lp4JVcRn0oEnrF3+LLabsToLMNEp/RDwXvyWuIf?=
 =?us-ascii?Q?t3jXOi32P4Xc4/5eL92YBbIrFiodxRp5LSnhhj1ilU+Q+a6jbIwxaQHH8IB2?=
 =?us-ascii?Q?YNEFjkJ+tnBsZLghuHRfa4aDmNMQmZKbFUZEWsj4O19Wea9NtwEiatM4Ydjn?=
 =?us-ascii?Q?cdF9BZbMVWYWRdGRB1/2YagDin2B54sEDUsH/FnflZnbPqQQq1t9Wq9cJ964?=
 =?us-ascii?Q?h51HaIEYfaJh4tfGry14crRzxzrLE2fYJa4DefS00BbK4p6KP/MtVXQm5BPO?=
 =?us-ascii?Q?rfmEQ6ggZMAczoO7V8Na7JYyY9KA4+sAizd4THXOXW7yx4/MeVaK9M3UPjqm?=
 =?us-ascii?Q?GAaJJRP9YdovHU3zuVgXot+ZKwPEo8zXuUw9utj8VrmBnMTyE5XNGa1qgOvb?=
 =?us-ascii?Q?9eS3ojlBxqG4h6Bu1NY5mnjWUaHEI41/WtLj/1nEUk1T+NBaEKjhymDpdeR7?=
 =?us-ascii?Q?GF2jHsbEF+SILwSPjGZaV/HwhVO4K3ityw+2Hr0jnmrJH89kdxAUPwkymdVm?=
 =?us-ascii?Q?Il8COb+Zqe5hdYo6C0/8ilUvAJO1vbsPqsMy4ZvDcoqdPbz2FNQFhJ9sof7G?=
 =?us-ascii?Q?HKWlTQLAMQNkLMhlxVanfnzCX8ipwZd2PECvqvNZFA4/u9TydOctVqfvstQr?=
 =?us-ascii?Q?G4F7d6BkkDIJPlBmG/cos6f2k6ioS6XHZtuqgYaNgD3o8OmiF6/+S/lDldSd?=
 =?us-ascii?Q?BxAxOLjACr1ERlrFSEyKQBvit5cJ5i1od+FLXoT4s6o6s/Ezh6KvD4KI4zB0?=
 =?us-ascii?Q?7Xv3NCnpuF1KT6uPA4k/S2bnFRHwKI4S1XqqueAZmVuvEqUjSS2my/yZJtV4?=
 =?us-ascii?Q?hdVK38v5fbVs86LDudSMJ2bit5gJbOTHdJEJpLdge2WKnN0w+5RJjZ41aJhz?=
 =?us-ascii?Q?cnQDIwqIrgYyBtRMWLVxYCZzrBRcBEviYoh6R6BWOYCVPcmYkaFzpv7NN0O1?=
 =?us-ascii?Q?WuVlhYunKs4ibh1iXoIK9fX3+E0rP3t8NE7EnqH6iwPQNYiCuT4ghPbgvhHj?=
 =?us-ascii?Q?ZTWMkF2c/Varu9YJYsa0wuqYNrsVMz4uOpxOfrBwe+S/e1fMp/9U6wdoLxIG?=
 =?us-ascii?Q?3CW8KNCgNyhhLzs7TpwCgnFZLFAPL91Uu6EafFLWGTUd/W5wbUBcvYGhrsan?=
 =?us-ascii?Q?GxMtARi9xAOdB/22e/8vOG6UI4dBcpZqXq1ffWiUM5Pj1ZSBbigtC+OLczdy?=
 =?us-ascii?Q?NTs/v6rMKihvgFwHg7z+xGedVNHsE3eyyIZCYddZB9L/5uCM8Vwyi/sbsS79?=
 =?us-ascii?Q?0FMawDH8sVrdDKYavDHJuZfkN5AHPiguXda6pzPffYvSviOtbhtO3Eak0lz8?=
 =?us-ascii?Q?scpPw6f2NxclLvn9zqLvP3aUYw1VZRVKu/MQx20CPLx0RxW32ew3i9OJ9N74?=
 =?us-ascii?Q?eBCqkRLB+21Wl28zGoEYcj1lJjlz8HQtuWIbIxtUfccdKi+8h6W7jo1muFag?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f54990ec-f09b-4125-affa-08daafb1077b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:09.7215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 33sktvKVmxowY4WRPME1iFI8HxRRCk7tO6PEpNwOUIGzz5CzvTZSkj+TkcbBoi09gTTIpT+ySXxPsKYzGhFf5mmkLtUpo3gQulDCTcdd/0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: QCMAD-yaUp29rDPr8MxxNijQ6oqNELoc
X-Proofpoint-GUID: QCMAD-yaUp29rDPr8MxxNijQ6oqNELoc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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

