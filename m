Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AC4C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJWDFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJWDEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:04:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B2E16593
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:04:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKxHA7030974;
        Sun, 23 Oct 2022 03:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=k7/URUk+AvTBcV8qO21QTBKER9GfUE07a0ZeNcL5jBBOAvNovZPQHlCr+wJzZaJ3NOxw
 Zv/fNe4+G9ifR3Ax87p4CvCkTlHq5bnrBN68psffNCeHJch3YK6W5sQU9LJE+Ry9dBnA
 /OQmW0lSGKccjlIMHIraCW9BuNksELs+kh7ywUC6F5/4azzblKLBeRMfJqVBmmlmSCAo
 e2JHzPywJPAlXT6JRw1mO3FUaO9MAN32G2McYEVhTbHMTqnZj79h+lgL3htv8b5LgPrM
 AJYQDD71MxQAIodejCxHmku/WXw9Q2FXnT8sYetqbXkuaZMkL719p7W+ooMYX9S3feFL zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741h86b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MI0iDc003678;
        Sun, 23 Oct 2022 03:04:24 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8rhjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsQo+R1KMIAFWqBc9Sf58ZkPtRF3gYjMPIdfs4Yz2LPyd0na3658GY0G/HttTBvxrG4fyfGTIJekZ94vR7z0q5Ry82FBVulYMCuzrg2QNFtoUVALxLLhxB/BkGhQpFWaCHTEuhQskN6PbgsVu2hYgBFW3RxY47KjuT62cHUX40yJ5rdAfbwlSZwZPjkG0MCvbj3ZymD3SnbKRNpjyWvqTQsRdrpvtBY3nkCiU+lzRPnIjxAR/TntEykEdZjXIQsRZjZN0pkXl9znc/2S8fxn2EnglfErLqTHdPgsGB42HJeNhZFoXClHJ0f/p/hARZ1I2pYfU1V3YJSqBs9ex2xvmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=GNCNFr4OuCY6YXxrIUUNEADMXXzkRzUyDaYqF+3ZxqS8CCTn9ZjvoOovxdonOfbavDxcnBGV40tiap8rjD7fWBgQWd4cRbNr5w7uwil2KFTb6k7HEiT0pHe3WRD7alzEGD6Rk89MT8BbYF7cc4Zdd0PAn2ek4QERPx8WFdZoCsXD2Le2agGFgt0RY0eCdcNPEHaVilqgVJRMSk6B+SEgI2qQwtqEQsBakM4CfE07jF2EnmurzVK3xx6wboKSo3nMedcJ0OIk7awHufW4kJl1V+U/Pdnwa6p4FFM3AB7/+Tsme0/1N6K20MqlxSADWTszk/P3BBEKUn95uXYMHdI7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=tQtiaxhVW3fqT/wm4sVcmZWygmuNaYzFVbyNNBDmamHc9hk+wpb/JmVyH2edybsVGPjxL6Up/3jzLfCaBtdDgj+ZgL21CRA6TtnnENUSL4k1B8Mnc4fERhRyOdsz9nE3Phy9qV7mqTpKQaNKKlJ8RkOQxt8InDF4uNaneqEAuiE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:22 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:22 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 10/35] scsi: spi: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:38 -0500
Message-Id: <20221023030403.33845-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P221CA0040.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 3475ff26-33f1-4fc2-dcf6-08dab4a348e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zh6YFjIrXZxwBBpMA3eZ0UKz6t8W03jZ61mKFm/BaZ20w1uUUO+KrOv+REW+UvHbSaAoP3106hl0Fq2AqHqkCmnniRqDaHwFF//CFJA3ekFZtYBKCSF7v0zLoqXjONNdsb8p4u5c7VM82ddOZ06Sj55TMiCAKmKdmAOBMXy7DNRyzB945/MwzNlFhs14rzN6As/FzQKi0WvTwuhM2UCCeE78kwx478EzZA6wePtUoLSE4KO5Ju4f+vI3bkQwP3yoLca7bB0ic3jat8yjwWMh578JFoKCY1cYZUXI3iBcYReIxEUc0KiPr02jMWlK7SOPYg34KRbMvbuczPd1wQ+YEmdtgJdv7rJ/wL4sdP/G9w62b5nryPgkYnODGfrLivFG4h9B05iYItZ7jCCPenM6590Ai0fIoUtkJJUThHN9uzC1eOTY/ZMiiFV9FKnSbY/iYi7fI/ctqOqz39U+If7zqIRTHmWwqu1QazW6Y/c1NohVVUe4NFfQS9yBVrxc8Bb2Z7MXb/EQXepM+gBVRLsqTjLcCF8e+uu48qHOkkj8jF9sA43rsVAAWPghqGF6zvpR04128GXNd8a9CO4GsJMa1UcTPMcF++ynoSL0VZa/bTg5EN13LV8rp9nGSGMqBu0FVWht4Ev8yjP2SrSE2TLXsqUPjcFJfxOVvu3b4QfQhWSqjzgR64rbG9uA9RMbl/Omq+l+nzfM4WjONl4wzZixg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VMDzzolt/w+ujkp+NiYYRmODA+negls4zBqMUQyI1KigZDuBpJJXj1uxVcvm?=
 =?us-ascii?Q?qXd1wr0/UffD+etxlzW9UNy7g8AxS77P7LvfrEazvyXrvEzwmzZ/l1JQQNij?=
 =?us-ascii?Q?uSCJm/geeyAG4rY81qYAKhB+iDIbt+MKhcOxHICiGsI7nnT+kjCZnGhFt0zS?=
 =?us-ascii?Q?LcpWzHw4Kt5C5o6gDGz9bGoDRYL0ZXj9HZWtRMRO8tmXqf1Fxs8F2D+zIimZ?=
 =?us-ascii?Q?+0Ud+G8rPAPNePwBzVvPXIQ9XkUVpM/9m9LCXmT4PqamzqgBVqpxMkjOajZF?=
 =?us-ascii?Q?JYpkKnUpwrnqJergNQF3jlZCKhvJ3F+fzb+SBnMAn8YZA3tws6aSoyToG3Qu?=
 =?us-ascii?Q?TTD9r5JJ1U/+R7HZzgz8z1eiMiRu/8IFlUhEIJh2ITCn0dg98ZxSAsbpeeX4?=
 =?us-ascii?Q?/zb4ViDH5/oyId+ckOBTY4GnuNSMwZDuHrVfF202J2BNQsZl7OJzkvBZDkzH?=
 =?us-ascii?Q?j9QuN/PtxaVG7CkwOh1Ns7qQYIkXffZyQlmu7ypJzXreWS7febYN7oPEyjwr?=
 =?us-ascii?Q?GkaJZxIkiHoSJGst/eBI3vTskN3PmSPgoUlJhhKYeMvMy8jMAm3DCY/drkph?=
 =?us-ascii?Q?Wo/hGw8imTTwLlwuwwWSMdLZg60Jbtysh8ZwSQiyAneMtYf+E6YSDX+WjPhA?=
 =?us-ascii?Q?0CThbZbvpvfZuXLDovxYLFiZwAVeW2tMQ0rYb/S1NhWZa1+2YY8hDMKae+r8?=
 =?us-ascii?Q?wlJsgPlEFoVkE55oqn+aiRnn9SoX+oz3g/BeIdWCZx4GixrFzMzQ+2CMOK/E?=
 =?us-ascii?Q?7b01lW/UEA4I4+R9t9aqlQQFc1IxKdCsJuQX+AeP/eWHnW6bxX/QVTE0Zaju?=
 =?us-ascii?Q?iNtzscPJWbGi2qHHlYBDI1B5OkEgpR//+SBJAvzKiX4qFtLu3KponXLEKoFv?=
 =?us-ascii?Q?5VLGH+bSbbUHGD/YlhTUSrnNPteg3Rgd9qGcw0Ecp+dVDHFwynrCnE/lq9Eg?=
 =?us-ascii?Q?enQU4UKlGV6O1WWxJsjZITuUr2RnNkybz+PQIO/cfWek/pxTRQaF/nKe/pDB?=
 =?us-ascii?Q?1xXPc7SG8Ffs+NdD+c5oqNXcAwnGOyNNuQ8FVDugGPtHR8hECtKFt1poZnjp?=
 =?us-ascii?Q?TyfFIl0pyiG8i/a8rzSMjh7y6FrKgx7mAvIYnPfg8VO9BJ0bsjPwFT+IJFSR?=
 =?us-ascii?Q?Fk1NSvxUut8PDbTY43rYwUGnnsXXTg5FHVGTcSpqX6T+mx3EFKwSvDxIKg8a?=
 =?us-ascii?Q?Jt6YFgxdThyKEyxu6v9T/ohwRGjHi3ATzx5XTqSFZOHpAoeuVPe18Wk9nmaG?=
 =?us-ascii?Q?bwmXu+Hle91APQi1bE41NH4GXnE6oml2aTXaoMG1ie04uCL47GMe6LE2DwwR?=
 =?us-ascii?Q?ylHV455lKMuEZTXPrf6aiZtJJATLGGTMf5m+CbTrbJkdNaHE1vM87L8sC7SK?=
 =?us-ascii?Q?H0GOwXgy2j3QR7MIhVN4zDb2x+QAlvHHLe2b0ymhfQ4m9F67VVAi8psSr/to?=
 =?us-ascii?Q?uLtm+Tn83c36qszTqX9nhNvaMauiuE+4jjdHbv83/ItId0z4eD1FDuzLQghc?=
 =?us-ascii?Q?VAeBaO5oZANw1waUOXctmCQY6Zlj17FdWaAFb+mBAA5a3jAw3hkZchholb+e?=
 =?us-ascii?Q?SW7UhF8QIKys/w1a4SD+W7qvnz9vx6vg6jOqvxlYEk2qC1yf8XLkkHOgaLVv?=
 =?us-ascii?Q?Tg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3475ff26-33f1-4fc2-dcf6-08dab4a348e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:22.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FstcPeQ9PQNeN3FzEz0RYqVDFW9FwPnYNZJaB751u6DqnxhTqH1FHyaR+G76X1wa1Cqssgqi+VAWpKhtFfM5D6fOGwCiMEqK2TCHN2KLZ0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: u5JWtKBIQ31KZ-Iy2fXKX9ojTJiK0P7S
X-Proofpoint-ORIG-GUID: u5JWtKBIQ31KZ-Iy2fXKX9ojTJiK0P7S
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..18a365c577ed 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -121,12 +121,21 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = dir,
+						.buf = buffer,
+						.buf_len = bufflen,
+						.sense = sense,
+						.sense_len = sizeof(sense),
+						.sshdr = sshdr,
+						.timeout = DV_TIMEOUT,
+						.retries = 1,
+						.op_flags = REQ_FAILFAST_DEV |
+							REQ_FAILFAST_TRANSPORT |
+							REQ_FAILFAST_DRIVER,
+						.req_flags = RQF_PM }));
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
-- 
2.25.1

