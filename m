Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E559C04A95
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJWDHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJWDG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CC9719AA
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKvuj8001390;
        Sun, 23 Oct 2022 03:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5qGq1GjkGe6KPqYs8n0AlyWjCvPVGaFvDm7qWcYrW/4=;
 b=LKgaB/b4Hz5EWoswRBKXyszv7OMUT2083Vlh2pdG+ejDfj7Gt3A/mbNlIzs+S+fEpVKD
 iTKuyZMUB5z9CIWzKWAJmrfalNyRfa6aH6/sh+j0ZdZMCW3wGu23w3IK4y/w0Hwm423A
 t9ZnizNwO+uwEGdR+gOb/GbBvmcqIliPCcuo4/bya37poZNp7Ow+LXWj35s8zxvUqzhY
 oH8fMIFNx8uL9nZ6tD51QIiWHgfDuYwkZ/vdWMqOvHkzR4aI/o0LkEZz/QNBUt3KiC3B
 jSfn1bS1lxgzXRo+H+r08rewTVND9u2EkFnyvwW0nURJzFQHQfpJ3cxZqNi5iR9q6l92 fg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8db95n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29N30Vmu032218;
        Sun, 23 Oct 2022 03:04:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30ajx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYIcOjffkXZQ3oCVHLBt+aA1fvu3b9DH3iO24NfOnrwmfIQ3R094MBtQYtLrnRT2k6/zhvgdEABzh7iIB6t7ajGfXAdMV5pOHohcks2M07gGhrjHvqu48e3//dfcghHuvht37CeqQfPf+5N5vQLH9NZEQwKqpm4pjFM6KS5xwEU7GynvuptLqUCyRJ6nlkUUL6bmbjJMr+pxqSxvj42OGxrKWB2bHt1fvnzhG5HlkCC0S66TkOdpt3lHnQUS0UQmIGZel6iZJFLmZFynr3d6FUCCM5wPEZw9vR3TEi+SjgMpdY0qZM9aY7V86zZ+kd+SYYySXETf/43tPCB84TTPqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qGq1GjkGe6KPqYs8n0AlyWjCvPVGaFvDm7qWcYrW/4=;
 b=XBRjpETK5LCPrNAFKWWSMq/QGlttAdf3uuObpjAamVS4YySFAsKDHWyJ5i0RBNt3NuzNkEaXMZBk9gW0H8r7RPwExjLqDiAvpXeB2IvYqQ4/HdytUAh18snsf7fRPVmfebQheu4LISBQqJJe7bQVBDB/25vsHjLga2JbCltZu6thLguiWqnuW+x3pogfXmuEPHevrV+bvfGqs/0+JCfNGumJCqe7r7uubBoy0yvfe39gRmdmiFYuks+mXtQaZxsplvo9OzludGY0MPmBiaqsyyukN8/EhVJWPkVNQhUlxntW3Gt0uBtPyqMwMY09wPvm+QFPAAuwokOYna9+BQMndQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qGq1GjkGe6KPqYs8n0AlyWjCvPVGaFvDm7qWcYrW/4=;
 b=ljrxvIZBfILl1H85AFTDi3HqlxVAwd/QSg1EYBefdiNJzyQJqwBZcmAqCWWBW/dapsLTnUHIL6JhnDJEeRDgxnIHtCOpYxzvgbvByBZ89/ZW4Ie52PjV+2U2Zc+85/+hTsZLBvNblMiYLvfmGAt0R9ObHDuqSp8xNJL8+IE7RgY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 15/35] scsi: virtio_scsi: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:43 -0500
Message-Id: <20221023030403.33845-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:610:50::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b7586c-d169-4645-1b76-08dab4a34d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N7NV4gYg8tNTUeeZo6GUXLyRdSalPmZ1+V59zNcDgcEa060gQ546u+LAPTZOqIeSxurZH1eKeYWY4MrprWEOtnjQlbq5LxYvI1wMrgh019gB6RI3hxrm2iTN10GlAHaB43txdg2WX86wLq5u97n2fSMe/OupkGxP91Ad6/F/jqQwLwrKJXVgTa7QEUJQK+bIiBvp5Ei1qxKq0qAJPb59wfKO5vy4UwzOOtXnZOGfzI1zZsa4rxNPjpdk69I3f6hn1z1tF5DdklZ3A6lqf94ATOy0Na4MEWsXjNs1uyE++DhkyecOdlrcbiVaWPlcPHCmwpa1eZssOpfjzgpMEdYyYnXgGbNApPb225cFw5zwC5ZMOWrdbtyeFOe4rxt7jL/LKafHjQlxs2JZh/YTdYkqIclOkjoPwhKYke3O95O+aSCi2syVg/hAHkiDH/BHHMZFN3pG6rMuH+7xfrZdztIK13SrNQwl4Z75kzpAyVX7/slXIOkRXZ9stRKrWgKG4duv9qk0aRsO1gkbp97izhwj4o2zhFCtLWyfeB3DP6kisXVM3XEM3MCZ6vXlDQi7y0vBHDKbUqCLgSSfMyVkDo3iimGRlc66L87KEbZNvZ3HAVU+tBf3yDBidc8z2QJc8TrE+PQfRL4fOIPl4QLoT6o8/1BtHeQDPGr+zn/6wulOoqAdAzFfPk+utKhD3KVg7aVJ3ucua5LcJ1flKCRQKzlU0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o5sJOOEatpxIzkdVDWicqpEs2NerxITts41hjQO7/wkl84JeCQwl2nMne3+S?=
 =?us-ascii?Q?m4AyIK5th6f0hYLI3sILWDUGnZmdysq8tb2xrsV1obvlvhkpybVCDSJhqOP0?=
 =?us-ascii?Q?PD3LOyUAH8u50pqsb1XceXnEXWi6ZE+PFmUXT1HP56xNv848yH2ME/to9Lxg?=
 =?us-ascii?Q?GA5UkLsPKtGAzBwlkSFjM5QTbG56TZL7G3MdblCxM72wUcXEHYF6cWvfqK6t?=
 =?us-ascii?Q?wVv3vG8/Fq32J6VedzreV6NhQtF1jdrlI9xnRGmFNgecuutecp8Bi2QeEGvd?=
 =?us-ascii?Q?7NsITPFlIruvIVqu7BiAprdJz85HXol4cItAKIxv1AshVn2sdquzP3VDDvus?=
 =?us-ascii?Q?nVvup/64JVPbg2jO6KM59w/5Ib81If2apYL4UyqG7SqAJY8xvjJ7rgSmAKJl?=
 =?us-ascii?Q?e3XRl22pALYkO6RehA49cf5Zk8zIWrmCLsyF6Qp3Dr/6JCEFSMDejJ5Q462f?=
 =?us-ascii?Q?9ZKaJaIG+8Z7UDF+t2brq6nrasJZjZKu95Q+rAi+EuSbsgBkAVCywKTHC7H8?=
 =?us-ascii?Q?/Qwj6wKHdkM0hy9wNl9Pi3WA4U6fI0wZU8oGhMBFNy8QMcZQhaUQ3+xpAnqp?=
 =?us-ascii?Q?8GGpuyDvU0Mto5VIOdCPM1qirRBAyg3rmJN7/1U0RLO2JBXsOrMrAdaMq+Zg?=
 =?us-ascii?Q?76Cy6xTZAM85ixCLkTGAPahzDMTMu3rBil9bYADs1iKn4rfZPZb1kvhI5wO3?=
 =?us-ascii?Q?049rDDJznRI/DXlzlghepCCI5UMgb+fcRzfT9PlDMF24RJtLEEKOtzpdBCwp?=
 =?us-ascii?Q?WZ/OQ47JxBDsoV8ZYySIOZOv12lUwX2jmEpf8uehCndVFxcqFawZJeCtkI2m?=
 =?us-ascii?Q?wEWTTxKU4erGF3WbxnDN4Ag4PleiJ2Wffr4nniGkMBoW0BXZkv8wzhdkKAEc?=
 =?us-ascii?Q?4S11iD/0s4Tfk/QClaYfUAUAXUTTx4n0zNxDD/nxeB14WJD9plv/oUMFvvu5?=
 =?us-ascii?Q?pQEt7YUls8wgup0k+KN2fhaa76S9PepEjDuAhlXP/gjhQdL8itmKTKXlvpgI?=
 =?us-ascii?Q?QvaGIrZzI8ChqH/p0TbKDCHeabx4lO/ZSe6TLLO9KBqEeB5O09wRUs2pTJGx?=
 =?us-ascii?Q?BIPl9Nk9EerXaSLNFabPa52t3bHEzYKIIQA/qVQrQC4lEMP94d56nLjie3f1?=
 =?us-ascii?Q?uvrHY0RHMe8wVKSSg9Ep0f7xR9HVIy2lRi1mtBMc+pci13EalBPYcqplmm8F?=
 =?us-ascii?Q?684RAS8oDuGoVPHxYINZBl5edE4KWPCFUEjGgLoNUHtL4EbnqmLMZ8l5VBRt?=
 =?us-ascii?Q?g/9pcTQ64tNOF3Roe/Jro4ZBgxpr/8+DjXqkNa6qDyH2Es4rvNWHwS64Lmua?=
 =?us-ascii?Q?Kx1KN6G4PHkZxcmias1UeJng/bxxtaeef0vUuS1jfUWoTCXIRmXS+lA9uADD?=
 =?us-ascii?Q?kf/emjrCE/kKZebeyS2VHMqq7E3xge3k5VNNNnOoIRjOkSSr1R5t54cTaNnh?=
 =?us-ascii?Q?DAKwxdsyaSZmyD9IM6zMcbXolsMsCzY/+G9y9CeF2texVaCJSSE+iXYG4PAF?=
 =?us-ascii?Q?aoGdflKObqOF3X3XQYBDWPd/GEucnE98ztxcweNQ/E/D3GJvNvUsOJio+qKz?=
 =?us-ascii?Q?WO3N+phLTL1RR7/ejQx+sn5lktTYULlTUpNFLXYTyLKeqW0e8HTDGYNdwG3g?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b7586c-d169-4645-1b76-08dab4a34d46
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:29.6393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXVW7rT5Ynn4ns7nZZ1r9QwRj2aIob6EhoEyUm6TN2YahzAO75DSpI5EC1RtHmIMZBTzWG0lK/R1rrpX8nOdPn/wnIqZtkIBKs8WcdUb59g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-ORIG-GUID: z_6dbUf_NLHXyj10Q_a6Vl9Q9FEZjK0F
X-Proofpoint-GUID: z_6dbUf_NLHXyj10Q_a6Vl9Q9FEZjK0F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/virtio_scsi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 2a79ab16134b..9dbec7188995 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,14 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = inquiry_len,
+						.timeout = SD_TIMEOUT,
+						.retries = SD_MAX_RETRIES }));
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

