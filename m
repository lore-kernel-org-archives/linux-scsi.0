Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAE3C04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbiI2DHc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiI2DH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:07:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D261122068
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:07:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiRoP003459;
        Thu, 29 Sep 2022 03:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7H0K2J3RBkHTQ9Wywq47pqi+uDpftumCY3x9sz85apU=;
 b=H8W4h+c4PqxoZ3rNGmuFOud0WQMuhSBeouNeAwkBh2Ul1RJx2jEMhujjBiGTX4rCM+mG
 5wKd4C4dMDYTM+cEmTh06Co2ii7D5vkLSk+q4RgrXA6h0y8IsgEof0jvWhhS+vg+u1/R
 g+ttQWtCEXfrY/TXpfT1z+E0KyaRYth4uvvEn0h9wjU1I4kYsuzDQ93wKaKFwd3NNAN1
 S1BNIpICEYufSWs2eHdVDJ+mK+dboz5rgHj/HxKd24rxZtm5khTX7/9dCP2MQMwXbrU3
 vVzviYJESA0Ftr+03Jt3NcdGmrmgAAaAJ4z8Y78QMDZI0i1o2w24LCCLey8/cLZp/cGk kQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjqu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:07:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM7Zpk033772;
        Thu, 29 Sep 2022 02:54:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22qw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm29cRiBJZaqrz7kh7vIr6QfNkPvdcBpcD1GtB4BoBLFit1wJpjCRQdIWN/B4mfKwLoABf3Ru6GCsYTfSqYJD2p9zwFgAlAap6o1yVGtGy9tecANOP6v7lbqGaERL4W8AIZ0NXrwkk95WH7pi14ZUd5BvURcY6QQlRtZurKKIdWrCerXvpUCiOknF7UW7WvN+tgbyS8nYYTUN8QtudXbWVnOvZtGb3yUwWTVng0Xy0NaQaF+assL3wVSMlxjeZsWS3+VnFntL6DIxIUqiwUCYoco1pmK8G9yAfDCBcMyeGXMo6/VqempPRAb+Oywn84L8lnl5tUd29i1i3jXWJbtHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7H0K2J3RBkHTQ9Wywq47pqi+uDpftumCY3x9sz85apU=;
 b=DifS6zlRnZxyxbe6I89mFXHI5xptecr8yT8inN+b5Gf/OvEBgHiHyAV/m9QkCdfLlzA5ksd3Lbg/hPB7vpvaTlA2P3HWglfKQ7mFqfHGq8OF/bkhmLuhWBFgByS5FgqVqWnKDMUhp+EECiMojOzvwc1DRbG1DFo7r4eyvPNoTqAgOe2alljZ+gNfj+4ee5JXLgm/zFd0OIvRyHKX0gQa17eoglcN6614D5XYDUV34Z41qPK5PsH4tPe4rDwa7/RlIJKRz0S1HXTRWtJNS4zPAjWrseqY01+E5MaJ1cgRvlR+74/GilzND3dEDrdny6w000msxgVkWTAJuxt9f9dDQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7H0K2J3RBkHTQ9Wywq47pqi+uDpftumCY3x9sz85apU=;
 b=lLgGft5lfoNvpAqwlBkoIp35eNMXa3DM01qxgcsw7E1PyEiUSYUw3nqGsu5PWNK/nJg6DGhn0uuu1JW5qg5Jlmyw6Zm8CPHyxzPDKKy06RhED5jVT/LmRkQQbCOq44wN8Ra8MoRnzTV2jaiDkXkjXuHKhCOgN17CqfzbM3PM3Hc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 25/35] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Wed, 28 Sep 2022 21:53:57 -0500
Message-Id: <20220929025407.119804-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:610:cd::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 07da97e4-d571-46f0-ee23-08daa1c5f9e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOJF/r+rgEKkfqEmbnn/joCWiwGtMKL2cHjBhp6cQ8u4htCeLylpF43cHhBPR2T4m/eSX6CLxc0af6jbzRn2nSet2b3T904KCTImx5FR7CzML+u3SoimEP5speuQQbGSoje0gSjcZYISyYSsFD9xQsBzxlCMcHhxG7cNkDbAzqWhOzoc+dwN79d8ldDOtAybZeUooVDIcYfX1QFBD4DP6RQCuyU/eVFtK8Ta9aoRemG86n/tSRXZnJBkb8OhpiL1HY1cJipS7p5celq+7G9uY2uQIIqtNFVpp8HWJYyRyWJnKj4giX8HldtN4p5T9RfrB8qcWTvVR451zK0GlSczx1xaIoTK7DjL3gsaORPiCNJoQ/eEaWeBcmV6SfB05lknWQwJ7HKxH4caRa7N9N3LBtRujh+QP1k6wBD2yH3iQnvJebAFyt5GK5HORDyRqhsLj7x/M+lfGg6fDpAO/aCkKTGygIVbEfmBWC0C2oBAw3c+KYPIcPUi1LANkpHlfGkwK47qJXGv/MN6CldZMulNEwIx1j9uaTvirIwXK/rnBFq7/cEpoFV9lemxCWqaaUIA/jr4dnUk5A0eiLGdLH5ovNHMwMwTKcBj0CQueCDecdnY9NO4msnTZRtWgA/8LUzVVLTRXF4nsYCNspSYYQf4TZ8LWDPNH3g1zzL4lTuOODziL+dUCYnAv0STzgTqntecrlD//IP2PG5J0GrJlML50w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?elTDgbcAuwzZ1S/Yu4MLiT/TCgOowK46PFNSBS4wIaG5Ez0PGI6h+T3X+d5/?=
 =?us-ascii?Q?M27/zJmnsIL+grdhDHbwBqPWu1eOK215VmqUDY5F3OrNCuYiDI+WaaHUk0fS?=
 =?us-ascii?Q?ShMWE4BK0HrGEe/5hWb/z836xr+oGP9ufMI5AyHNWoPzjSXUXQ0NjPgRDj5t?=
 =?us-ascii?Q?/FG95rOerukgLDxCjRPxemDQtogh1cu+zUUmzJjr7f101kJvsh1vBlxnnbJY?=
 =?us-ascii?Q?iZN0R2xtpTdq7xrcF82MXTxQwEYiBlVauVaHEpQJv5/MBTwzpu88xYihHl42?=
 =?us-ascii?Q?QSyqYFr1dMT8wZHnEOoRG94zD/EKKRfb4VhKHEhKFdceF01/5ouWEpFOiors?=
 =?us-ascii?Q?O35pSvuTniWvqUKkMf28Lea0lmOjSkLz0DcXarQDcSo2amiO/9qlExlmhd3u?=
 =?us-ascii?Q?CJNgcaB6D5ZuUuuEo4Zrl6vpXMkdvbsev8pisQMaKRCztS+wsWwNnXwsW5qe?=
 =?us-ascii?Q?6ZG3clUUB3CmytqihURn99IUQ7Y7YEZxJZg7/AGKWv4xtSLrnxk+JI1y3waO?=
 =?us-ascii?Q?zH59VMEtIURit71YF4IwFwcHj8ccW4PlaPufxG8x82Qyf5JvdvO7/LJ2Dq4X?=
 =?us-ascii?Q?AVRVdIU1QLeETb5wl3ApEmBGaie2T5F4c+mhfl/RZIqXR9jUF3T0xqrLEJbV?=
 =?us-ascii?Q?OCzihro+QZbhXgirfMpITsrO5jA34RBvc0MzXBq/PvSuBfM2QcCTFh2qOh4R?=
 =?us-ascii?Q?xOcdY8f3M9udNww66SIHi5VIfvAa5dA5yqdf5fUdqaT75sONU0AOKChbyKlD?=
 =?us-ascii?Q?RSKWDt7hgyl+Cd3TKUdqUDOgCNWxf48yQdBsPFFL2Husn+QW/2LaimCgyqYr?=
 =?us-ascii?Q?iY7r4FID7rkUyDiBVka3ByrsHM4ky4VCybECZ9H9fxSkPtwROEpjaQXLIXkU?=
 =?us-ascii?Q?leh66uYFNQ7nAJYVMxCjIPoqXvaK+aSiRj5nk0BNPwO478nplDk/RlU9oFNE?=
 =?us-ascii?Q?9GH3gekvy3/qdej6NYsmpjq9677UEcCrCU2ww/KP6MmLYK3DlO2m+yakbr6e?=
 =?us-ascii?Q?a9IxArpLsaGq9HkdQ+/CHTSffjuRkPxdZrEZmgM1w0SSdVv0wvJ9+Jhgz9aa?=
 =?us-ascii?Q?XwPrPNf1klJTAF1WsWm1Uvb1EHPkXQLydNhggjQhXRAqwnmy8ap2fNCbN0pW?=
 =?us-ascii?Q?eooeYkXNquV6Vbe5wbFvidX05T6S+VxZoiL7b7/p4ahETz/Y/4gF06k+7cdB?=
 =?us-ascii?Q?OJ2cgZ8W/s309uJ5/5ASRddQ0lYgvwNUubAemLuzwnX7dK8uQUtYZoZ9rgU6?=
 =?us-ascii?Q?fdsx3++D9k2tskBvmqa6IRuGgzcl8ndW7gWjxzYcPXMy0Jq98dzy6i7eYDv/?=
 =?us-ascii?Q?cWUrKkAnB2/54BqCZdNnbKn1D7770BN7YQWHD7fItSh9EqH0HrDa/Z5oqm1/?=
 =?us-ascii?Q?RdGm1IU/2lmjytC/OfEGG/+oD/NxMI9H1Gv00qfBD3/wcolJPRmL7Cq8A3mT?=
 =?us-ascii?Q?Q6VqbWjHdOH7FewrKmtwcWFIO3Mz4t/DbPjlWvZQJXmty+AuTACwi7lj8ceV?=
 =?us-ascii?Q?ucD6Jq6gB2MuZXhu0shQEdpVZD90FY59uF2lfcihUM7f/xrQ5ksOJbzaYUHc?=
 =?us-ascii?Q?XSr9vD78A5uOQOyhCTf5ILH9Mu7QTzdq2Lcmqp45o2UvZb9rrpUeRvKSkJDH?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07da97e4-d571-46f0-ee23-08daa1c5f9e5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:50.0508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJ3pZHhp3bIO/x7Ef60uoyBNyFia9PVzPN1btnpCo2uw0bUxOK2HIfD5NdZL+/xkB3UKa6Q09XAMMImtzfmyPjaKzbX8RXeBC5iGLPh6rHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: Zt-eI6eEP2uwzzn8gU7utJt2VzF9Gnhg
X-Proofpoint-GUID: Zt-eI6eEP2uwzzn8gU7utJt2VzF9Gnhg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 109 ++++++++++++---------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c4d1830512ca..480185d57071 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK, result;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,7 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
-	int result;
+	struct scsi_failure failures[] = {
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+			},
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -546,33 +562,28 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+		"MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index);
 
 	result = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cdb,
-					.data_dir = DMA_TO_DEVICE,
-					.buf = &h->ctlr->mode_select,
-					.buf_len = data_size,
-					.sshdr = &sshdr,
-					.timeout = RDAC_TIMEOUT * HZ,
-					.retries = RDAC_RETRIES,
-					.op_flags = req_flags }));
-	if (result) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = &h->ctlr->mode_select,
+				.buf_len = data_size,
+				.sshdr = &sshdr,
+				.timeout = RDAC_TIMEOUT * HZ,
+				.retries = RDAC_RETRIES,
+				.op_flags = req_flags,
+				.failures = failures }));
+	if (result)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

