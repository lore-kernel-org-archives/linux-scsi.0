Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95759EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbjFNHWj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243076AbjFNHVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526E0269D
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:43 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6kCOF026738;
        Wed, 14 Jun 2023 07:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1x5ZJ3aJQDL9NPjtm8d3z46zCcqnQfjROS/AeXBX9/w=;
 b=Ke8XJtD3Zc5qYrN3Q0sAmw08RthwR8bu+0VPCAFu/xVHJCpSYUNbVMHNfVmUbZhc19iX
 b6QvvxPO9FikCyiK34kgr3N5IEe+ipdOuV2ykimJrLO8s7D646ifvsLiPwXITjGNYaH7
 3T0x1lVyXvfX9z0gXXWs3W+J8PNcahm8gHvltP+nzmdF0vJBJerJWX1cY17G9oHscNss
 hcMIscLIcrx+0D19DWCFExpAe4sYvDwSCGp6hCE02Ol8zNHlnoS6mmV29Vcf03CgPQ7B
 KBgjLgP9835E+vNs0VQrcajmtulhXkKwuMeGMML1sIk5aXP2TYkpZSU+FTXTCsyMdxX4 Dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6UG34017744;
        Wed, 14 Jun 2023 07:18:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4wsk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtkUCAjcZg8dTidKgdJTqE3vVRnftmGP/qzR/8K5daUbu1/fwkqeC/ofXC5gvHB3COVTanG9D55hf2aCyvGOL1qJX0nIMYW4LObWQY46pCF+t6Ol2sp45hewNrMcQR380qzWTuurz6Ofe527tCC3Rt3JPPCjPC2g1RwUWPwVwVZAPSlQGY35EXnPaM/6yixhaklOlvKWIXlo5tFKhRKEC5TOOXu778Wcbl28qILQ2qp+Pg9nMlZkfntzHhUU+Q713Yt7tJZqRgQelK2ce3lo+Oh7eHjow3E0xuAyyWRw1Vot+o9I1dtBXwgjiAu25Ixu2tWLrjC0ua8ltY2IeWABIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x5ZJ3aJQDL9NPjtm8d3z46zCcqnQfjROS/AeXBX9/w=;
 b=encFfhwci/615tzTe1Hrnthjd8chXqbsP9QwEkxSUMwSHPQ4bGdF9jDo3l+Gi0cEtuqGc+oOOAUSL730zkp8cV6v7OP5kXcYMFYSdKVtYCPVBOWodC/M8NonvtNBJbOP8P6FaP78tpJfaaY6Q+D0FBbEeplCfWGZGgWacrZMy1RRahbZyQDiE1b9R9Nras4uijFG4HoOJS+tEH7cE0rK9pf15ALzllmlW/Nk2bUhkfQVVbThACDfX+RaEiYPBTev6peXbBDTKenkiGz04FmDkeR4QIy4vjRDtBqOMx6go4MggCW+u6MylH4B1mSlGgoyqX7yN/lF2ySu2PXi+vSTgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1x5ZJ3aJQDL9NPjtm8d3z46zCcqnQfjROS/AeXBX9/w=;
 b=nJcgLDW62YoqPzKdkNZAKsjMWPZyRkQd+WokXiqtKeEGZtFR2ANiFK0AyenjvLtakqFf4ktccxvqt6AQ4faaVZkIRCyrDJHAYrH3TRLoNA1Qop3zcmc4aGoxdVHmmssIJEq0p/sMaTT3eZc/lFFUpbcEuLBio2wehD7N2oJyzJ4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 23/33] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Wed, 14 Jun 2023 02:17:09 -0500
Message-Id: <20230614071719.6372-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0192.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 55447752-2aa9-43f7-d6d1-08db6ca77d86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P94MrlE1vxmC6sU8kSRzWg5X//WO4wG/XiYp5Hp7Bv4dqBkg1RuKZ1aqZAV39NZ3qA96EGajpIbQOyMqxntcQf02skm/OXgjYj8/E2aING+7U0qPXhmqXul5lUYTkqfCKGTgorIXNOiWcYatH72I6QuFde4d4ervde7DOMFP4aC+hYwrnj2QUSWY/ymPAgLGjQzKfhxSW1qvdlUQHzSeaFpqnj8D+zmYHiYagBwWwuzMlxZ8qfVXdlJRUB7Ssl10J1q5GPBI7BLl7ZOqu4Yno9ayorOJqYwklTIobrjqrrke4FQjdSLS0y5nC2sHeH4d5jD0e+2mCYMPAaxx0ll2eMD7oa9mBapinHkBT+yrbO+IwFj2MPeRFenuCtS1g9glKODKTFj0vQt/+n7+3p50Cj7dmkwXTU1ufYlk1ET82pwts7vbPnjTiTovqHaHddiQ8UBLGXz1ZyTKRxHr3cLULTgRnPcB/hghA146q/+tJI8uqu7egOaBNSNbuqKX7UvREbcuEDNp+0xZ6Q1n08g4XHZVvqg35EIbtF7ZVWVtuQ4UayCeSTmt/calyab+t95k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Q81aKVIGsGpYi1h5JM9gkgXi4UYAxmq0aUrUp76MVpho6xYZhzaA+joJ+8S?=
 =?us-ascii?Q?bmu0SI4Jt3P2hWWliIVU6NqCGxyDv0Aizm1b7aWwO1V260iYKDakkiBJY9Xz?=
 =?us-ascii?Q?nWkhyg3VI6zicyudswK55HqLDaqXEfehXmLqSg0ePizzO27AWckZPZST2i/O?=
 =?us-ascii?Q?RSwlOnQx5zxuBozCS3jqKDJylANK0aGipACWfbFforx5zR/8XuUx1NzPnP+I?=
 =?us-ascii?Q?bmwFW99tFNNHPZpVXw/E7ih5ccKuDq8ihz93snKkRNvYwAsV5m1YXK9PL6IL?=
 =?us-ascii?Q?B/P9tVQ3pfbgPZETKVARFYH425posEAwWKuKLgeAEsghjtLudsLQhpYihq3o?=
 =?us-ascii?Q?EcMIVeVu5T/GIX69J2dkmkrjnwvCKW4mFf7j0l6OE05dbN32Dw8KLzve1tH9?=
 =?us-ascii?Q?ipCkLaH3uKswBsnrymuD5t4y/9oiKMCUF46ToR8Y6FtzEsajxISQvCIlVMvN?=
 =?us-ascii?Q?FCj0qSq3nBwNpL5nkU41ZdG/HkcEeQZF1RZVllnv7pe7oy9kxSGlekc0hAXu?=
 =?us-ascii?Q?wgrCL3dpuGsLQQKPV0gAz6NxsjGKUK5XbS5aiuVGiV9cjv9UomWOaOQsf+lQ?=
 =?us-ascii?Q?rpplSLwJKrTS0KwrL/eWpv+7xs2pyzo4FiKaVt3cZhgYCxdTfPEGLb2XB+zT?=
 =?us-ascii?Q?eOYolyfSvrgzWHbfQUGZVfOEBFmKizZGVD9fbmIbmJ6HUfd2Asl+d+Y9GwlX?=
 =?us-ascii?Q?osXW6SlLTwMJwRJPNbygUcd/TJNC1GS6H5XxskduSuw8udD2kbUs7cSDmzbi?=
 =?us-ascii?Q?l3+9fjVuGX59i39NvBL2lOogGfC+YxfyHKPWqdZ15cs7wx6FPoCO2noeE2Ct?=
 =?us-ascii?Q?5GfHXD+mgJUelXy6xRDWD5ag+DlIqmcK3EpHQ7ZXvD5F02Njzo8aj/IG94U8?=
 =?us-ascii?Q?9fTcFsB/x7zgPMGZvMKChWwPtF1dwk2YhgBQtaKiq6m7F8V+z2Hhs4wDVo1y?=
 =?us-ascii?Q?EZ2Umam4mjMx9XksyWVMYYsj6SSYkGQGFvrANMvQHfEYqPJeFXMEkdUV1K0O?=
 =?us-ascii?Q?9slyAIuCogzQWdLFL6wdJ9wmslY95mm+WeLk5RV/BALAJ3p/IvpVYgg8Kuqk?=
 =?us-ascii?Q?GsMzMfotTINaGXM/UScKoW0jkwa7nmB7VJgHtv3qB9LbRjv45W9S+WPKILrR?=
 =?us-ascii?Q?qhOrquXWWGhXLQ3iXItMZerbE8Sxy6MGw8ugqNWr+ujhy/u3pKzh4KOW5lZy?=
 =?us-ascii?Q?mm4PyM4cMOSw6hN49jtmJ3jdDQ5X6Alw9ckuJtevFRG2M4lzc/VChTFdmzhZ?=
 =?us-ascii?Q?deblC/jh9Nm42fAtlxBVWXuBLihBAujqkhnOj+Y4gonimaNIER7iCnXEG4EG?=
 =?us-ascii?Q?y8PJ8ydZBBtjYjTSQH5xdW2ReBpadEYFjI5ts4A8kKr4uBNxbNXCEoBOTlar?=
 =?us-ascii?Q?TYvPZ1sQpch4QqJKSwEkNOLW8VY/X+S+I1m9tiET0j9CkuErZ29s/axosDNA?=
 =?us-ascii?Q?9kALfbhFfyRNlvMnHrQYiMd78hFwMTyc20pxHQoz4yQl/9k7fmuItoMV1ty0?=
 =?us-ascii?Q?XpeUIW6Ad8fnFo2zad3U/IWk1VpmP8IBtdDiGYsIHL9198f5Nvr/INTqgw/N?=
 =?us-ascii?Q?qPvdQ7ehU/UzeEDkfWj/feGd4CjUXvyZHkxEPeTXUiGIrDOOhSOjlUyy+YAA?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3OUmT7F4uRG9TCULCFh/0QTxJqgCAHPyW09WzqB0Zl3RMeFplG+zPtlJtunXfLzMEPPynAIffUYPAw068ILjgv+ZTOfDEeOvyR60gVJ84QbG66YPr8c/8znUQNyHnJ7ZOfF6pZQFr1cqzLWVgAh7ZyVDU6HAGUAQGS0l6cJcXNf5QWefJ0hF3UO8S/RPtB3r9DJ6ZAN6UMODHl6BK4H55w9vaz4REvdmo6IdsylNHTN39d4GOEejrNrvfbZW1hPLQYliLIJrsuMX9joS1F1fvCH/Nsb5DZY+0ELeYEkZtPh8M83H91rSG+brJjlR5dh/+W1tI3rTIybRo+sbp/GnhoSC1Ot1yYK/snB8JjnbTcyvVPyvkio7JnfTwKu6d96SeE6Pr+xSq2Ny6W1VI4CUa63ZE/k1Zhyz5lKJuleRcVfUkHkNZS/31r3fF8ppAWSjUo0I6uz0LrTLzX4WBKs6EkmNizuvYEqgPvG5HLfEnZE5oED5wvt2CP14OMh3Tw/qXNEq1ek+DzsXlp7i67vWR4TAQryhvUYklAsTnQYYOYO41OjEeVZl0WLYNm+yw33gLgu9oioqx8sZacsJTgjADnBuGmre5SWJu7gqWHbmfGU8knflS5cf1mUBparz8auK5VGopSK2ua2LbARIL9DGwExWY58wlvTqOEQTH1U+WJmj2cR50OACoz1fueBPxnfUrdwB27SqLp8KI9Vd5NFIg5NuLAIP4fZDLU8nozSDEk0V1DQXRXFEtU45L9Zu/UoH4eSwWv0a2hPh/E+xHsR9OZNPcabmVSEXAoYRDDshaVzjTKD69sdXBdHhjKitGRmq7Jy68lDcJ1G0u9AG5ldw984Aqe8WdWukjHvnlqyvi4+TmDNkX6wAd0m/sPomnkGM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55447752-2aa9-43f7-d6d1-08db6ca77d86
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:02.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZEnRGXcnEyvRkSYtJYLw5dlRT5owCquMSOC4O5ezwLH0DPw3+yeG5S54KGwhONIhEtEIfQ8LgnPQqPZf9VpHCrvlnvoJe36EGS0hZ1OoP5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: WyLXvnep5c9oyKsUsii8wUm32JsPtpav
X-Proofpoint-GUID: WyLXvnep5c9oyKsUsii8wUm32JsPtpav
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 56 +++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index eeaefba6c9a9..9646f90878f0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1412,14 +1412,33 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any oher errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int ret = 0;
 
@@ -1490,29 +1509,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
-					  lun_data, length,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3,
-					  &exec_args);
+	scsi_reset_failures(failures);
 
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, lun_data,
+				  length, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  &exec_args);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS  %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.25.1

