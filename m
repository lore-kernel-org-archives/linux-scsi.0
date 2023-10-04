Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117DAE936E6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243992AbjJDVCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243898AbjJDVCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AEB9E
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:40 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ1PR016039;
        Wed, 4 Oct 2023 21:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=hpp3dor4hFf3OVHRK914BNwKq2IFLAkhr3N+zRMQRoM=;
 b=LWUYphiLIsqkLHT4oNOidBJ+lN49OMJPV6lJJ+vnjwxXC7up6ypaXd5KwzxuLB7DvISX
 XFGlUYeKE2/eLJNmV8BeKS6t1Cm5a5+vmlS6u9gieRmlVr05Yrs3F3nBU3Ctsme2Sk+y
 a2BsdCvli0HxDkOTrhn9NYc7iMnSGGi+uNuyOqeUrGc6ZyVGY+2djqvxcWvH8Esxl3Rw
 fVUYoCHiL2rhwCQV5Va2m7QwwLXsKQ3Bo62uXkB5jh5nqp29xUJd+TKixQ3/g0sfikW9
 ibGb+mFQRJ1H2fwmG9oiV27fQNnZFoiZ0Mpu8Zcn+a0qO9QR+rNLQ+2wBh8BHXS8noAy YA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcg4r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394K2gw5005824;
        Wed, 4 Oct 2023 21:00:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4869j4-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clVc5rc/K90sSb/p5d9Tv9/kVIvi7HFxMyfYslet7W48mSPhV10BVHD0iQPn7SrXiXwitKx4p6JeqQZajES5w//QeGUkyciLSNgr4fJ0f2JjgSYICvXb3ArIel1584gd58v6rVSlGzpFCVB8YlgHIUOWxJY49OPdmxYjFIBFXBZ241vTxppVSih2rh6CtwvcqPH+0hHfo3fYRHNjBq2igookm1my9h4oic9XdhaDNJXK37cLjvsE/hyCx5aJ40xyqppW9C9qiSyAdSJ9FWm9aQ0hB3j50oNgVIuVmJJWwRDkS7qlmZdxpDKpcHj4tQ1WmChLfk/sggXMN17BElG4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpp3dor4hFf3OVHRK914BNwKq2IFLAkhr3N+zRMQRoM=;
 b=JyTwV0CX1qW+ZWhJUqgbIzXN7zDiXqujZaOQDSNS7rBEV6233ExXrvjx3RGiI0r2vj0f93FfFNaoNWp5ADLYfipnJ0LkmUorTIi5qBgTYgFebCDyqpSC+WpWMPkohlJWolxra73Thmin/6rimRT4UhIl6WsHeqQTp0yd6XlSCROyRrt9r2IYfBW2bvlZuOktiNPWR+/BvzfVJV9cP3ld5rAsIpbbt7O14PfXH+iZVTys/7XlKKmO3haKhNAbKKsFV5a43Q9UqhsyMeYnj0B7LK+SGjRfQmnShyoCAEcj6PSUJcSBk9E7MfTFZGFZBax36xN7awof+Dl6ZMRuC3g7kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpp3dor4hFf3OVHRK914BNwKq2IFLAkhr3N+zRMQRoM=;
 b=VeYnbfwoO4M08KBNDnQOky0/5mC7Yl77LIjQm0f+jbHdGgqFbZiRmCV6kRvZMYLPi31ZniJXNZHWAcM1RmrSijWoKX6lvQ6s72mCznd/V7lcvVWbRm60iZEgcZ3Mw19XuG+3FH0NE2N+tHsqOs3zPS9yp9Glfh0GejRcqa7edFU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/12] scsi: spi: Fix sshdr use
Date:   Wed,  4 Oct 2023 16:00:07 -0500
Message-Id: <20231004210013.5601-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:4:60::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bd298cb-9360-46a6-d494-08dbc51cefc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gt1BkDVULZJXYpE/k6bEj/vSQE+HdYVEblbQNjLJovGLM10w+pWu1J3AMEWDdShJX3ehslH2fqNSMT2L8r5/tEi6NzpRC9dlxN9Js277CO/MSV+hcdHngwCQfrFPB+z+Gm4TAJSS4ZXKqJgeKr8RK56jlNhWlxTr7Jf+vkEbcnCav+83s5PQyU/xxEYFxQJUtJBbHhn7hUkd437IFghRTXORObD4tPm/ndSuuycPfqHfSy7Z8T7uaGX1nFSGAXBzVGkUBOcvbZQ5guS3A6n/KFfpIe/P+Vjii6KAiYkC8R+QVvWMqcWUFEZDJPfEA6ExLAMo6Tevb/Z2Bu1s01lDK0ifqKJLKEEAf0JKUWGSC+vF5/0e/gATffsShgHalP8RfTb/lX6OJKmpnGF5sI5uC3wumsQJfMiObSuARWsCYOd9xQLHBzbm4FQSHYuiNTwh8ZA8AB9k4pnpN43VLaHqyg0OJL0ayHgJ5CJ/+W95+Aiu2w094hGNDuWVF/osjhKt7cQ51RZCCo05Rtm1/ybb37FggZkbNGxfMbNQpvGNr0/WvxU1HFBHtoeQLc/2L7AK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8N/yxFHfiDMJm75lMWFPlvN7aK7iKMM/nOYJg7tM2YY+/9MQd6R2wEOTs7wV?=
 =?us-ascii?Q?AHL/5IldrEmVqiLGSODYUD7aws+C2Zi5cYhKiqtG27KxfYfcaj9eykkzynCD?=
 =?us-ascii?Q?xJDzZRGEQXRe7rdEnXWYn0TTqrO6l2Gi03FH48kiTj7mIcKcJlSXSsDxgRQv?=
 =?us-ascii?Q?i2d+ramJQdW2Mgy8Bpndhodkhp0v8wUHLKodLDTzDmyeoF7KLnfvdz+2jpzy?=
 =?us-ascii?Q?KbqsYhUlFlkZCnHJPhlsAXDUkaNMoNQA6Dlyjo5pD0Yt2Q31o50HXbE/cXoJ?=
 =?us-ascii?Q?xEAQVarSZ6PlwJFypEwEwtEspAdfEC8Uk+wz8mYEGe8HrhLNnQi3uVvoqEAu?=
 =?us-ascii?Q?m+IGjFwaz/L27HJYRAdSzhdnBylUUi5LMuEqkKjiKTICa367KUJDbYGkcf1u?=
 =?us-ascii?Q?yckqYrrm4IsFHzLDGK/SLRDxoaCt/9nkOnWXX/vfwusdQikeSylY2x1jO7nP?=
 =?us-ascii?Q?bRUgpfGq+r4tfZsrLdWV2nAibNyPuis9lhcsMjvg3NZufNAuxy0LD/HL3ldk?=
 =?us-ascii?Q?YjrVO8VY4jYYYPdB8yP6BTfa0WRlIAaNZ8R8toMx3x+lZ3GQ0eNzez4ssZ/t?=
 =?us-ascii?Q?D/LXAuLjvBA1zTLcc1p7Q2aQhv9sLmT4zZW99aLP6gugHSyubNPNu5W4rdj4?=
 =?us-ascii?Q?uSf5xNcgF8XoW8om3shR6C787hdUtettx9Mbpnb0hnVKhbOk6jzYtT9jDdzr?=
 =?us-ascii?Q?IEia4Y8wudEX2AaTtzTf1BpQ7KKdKk/5GKSmukmPEPE6KUlFGiaT9IYUXZ92?=
 =?us-ascii?Q?bqDl7ONAVGyuKfYMVN95KTAaukpSf+xuzEyjCEq8zZrql9Z4j5B4preOy3wO?=
 =?us-ascii?Q?cuOGOm/wt7TDC4kte5rj8q92RIPvk41TtVbilkQHT4RYG4A7hOwKcj6RTMDp?=
 =?us-ascii?Q?jUpf4IIicWLxmVnjXlJHyOfkJ3VBvQRRDLoPV/V2OTqx1xBqZnkH7k1/8wko?=
 =?us-ascii?Q?tAsaz1axYSjdoUbgqcWKyAOtf0QvD8t94DtJsdulJyh1dBHI/cbBtxkl7Z7K?=
 =?us-ascii?Q?42kaXNptSl813fgZnQzbUT/XbKOqFtdqU4k8PfOgaDmqZBKJRmATGSKggItF?=
 =?us-ascii?Q?ewzTAeCcw0IdoIzwgW8ztFzIo900iab3GPrmv5zrBvOb5gtaVuxDWE7IfQ2X?=
 =?us-ascii?Q?3caZ3Kv6+848Cuva8bNp7XSauX/I0fgJDzLqlSrC6CJDBC5DKL7uL5BsUQC/?=
 =?us-ascii?Q?tgoRkzlgnRkCH66pOU/lmP5DhyK909ET0FFzqA6XpVALIkTliQ+qqu7/304O?=
 =?us-ascii?Q?hkShZxY83GgeaFj/u8a5u9nsdIbZP9ruyK89/BB1J0gmVUzwvhXBUh+/thwH?=
 =?us-ascii?Q?xILicAut3t1/n/GlkpkU07SGQ1aZk13xXWQul3dILIEVwKGqNEHlze4h+K4A?=
 =?us-ascii?Q?p2DfneXXMjfB8qfcmlsHrjCSWz8qkJ67M6sipe07OZ5mI8zjPlX517FbYhNZ?=
 =?us-ascii?Q?IsOHXL5i98nhdZDWZ+1Fpf0gApYxWrPgPqIxRCzJHNoeVRYJm8C7+P/zlssS?=
 =?us-ascii?Q?vYn85CcQzY8qozprLWM6uiXCr/2zZQ13FZ5CR0SEHTsLYPHHI4DBKEpfNwLS?=
 =?us-ascii?Q?S2V7M8VRrDeCULGxpp0dWfJL7JTDrBfqyFYijtzYpPD29LZ5N4O6izYqMA74?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vASPXsOHhwN9WJHZpPaLI/T/RZMCvmvSZLyIsrBhxqlxv6EyWaCHqmgFA7nnS4mRBUmdU0HWVCioPhi+oD6WlMybPl1DefMLJOsZpU90WlucRwYvUV5q5qh4/6qCi2yoAlTrqL98J+TBhZRrTGIxWqWBIRafXNFAOclZdVXYEP047Su7iFb71tf3e/yU+pTbQtkXFy80CjF4AV065/3rZbP7Hw3e2DO3d2eZWnlgHT4BIoJOK/Wj+O/USI/7+XQEXCFfxZDvgKA0HV4+yeJbvdkzv8lWr1+gaxiuYqSHpnoelHHWquBkwvMNRI4h56vIYjllapHEfb202kgyfV2uBRLpHAw9ENqq63qsOnC2VGiVVZLtgxIdhsSrm6VyuYUq58gB5jTNpsA3pSABLPtY+dauVHvMwuMsWCQmOOyCK5QSnooi7SELm8y9V1nBBqW2VXy4vBLYstQkdMdbTQN21RvwWaENIH0Fjwly7YuJkurEQYqImEzTNiFiiPwt3sFOb7G5R9dCodn8NW9Pc4ouPZrDWhnFD16yGR88w3K0bN6K64v8HiheVne0Gz2thkMAtNRrv+0RyB1IiQvla2EiesvEkYAC3CuFpS/hx0ouRABMkwVzxEHpCrogCiY7pC5xHE8LdR2H3auD0AXTYAf445YfBTxRI8lhm24GzK/VxxxzFg5LoYOwxZ0I8DfIYrJiIVyHNUDnZQiB8rXy7ou0oLzOa6AV8JdY8f+5ja+HcNFfQHnwklw1uMPQd/UnV39IeMWLvWf5hPjtq5ibW96UL9uzBAgI5c/tSUo4rnH7fom6KYih6tf75k3BLlNP7+MFjgiHU4kVImcPw6IFnf1kHA6zyfAgG5brgwq/uex0oPZrlfG52RHp1SIMaO11zYxO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd298cb-9360-46a6-d494-08dbc51cefc6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:27.6591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gv1CP05lhwtn0tqmmFQpAMKk5zqZZt3gkDQLEpTqTjyhIyeVRwHK0KThErkXLk7T0LRkpeho+HggGOMsU0bD5oaed6j0brE9oCAo4023UR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: 8CWVx5z1rGOa-0K1JBbexARvjJcib5hv
X-Proofpoint-ORIG-GUID: 8CWVx5z1rGOa-0K1JBbexARvjJcib5hv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..f668c1c0a98f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -676,10 +676,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.34.1

