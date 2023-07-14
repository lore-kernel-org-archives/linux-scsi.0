Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585D0EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjGNVhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGNVhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01FA3585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4Y17029803;
        Fri, 14 Jul 2023 21:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=zVQuHo5PAgEorlZE0AKnomrHYuG3KT/osqtZmqcMGeY=;
 b=Ig49GwOJJMzdvs3U6OaKSwydzlUmWVpcRd71Ql3Q0jgFHzyulOwsOaci5doLn2I6OCsG
 WAKvaNLgSJaEx0u3V+fRWIOE6vib1di/u7hL3x4JL4exKIFEXo8mRLMT6LGVzOWn2aL5
 7/PefbZak4SOHt3BP6SHS+7V0SA4HWmxe4ERSqVTDtyROU911Zimhn5QcQvnKMXGup0F
 nJEXVZM42L5qanpeD5NcYSE8T6ACLK4ZebnD0DReOlkaAuDHev9ZwPl11ZwYQwkBq/RY
 Yx52a9YFv2VHJmbdiUUZiudzL6ZY+J+iPslWYnlSbMlNZQUxqkyDVitgE7MjBbrifVmA 0Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtq8atd4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1gsS014020;
        Fri, 14 Jul 2023 21:35:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFL7urm41/zhg32dlmAaYyCR50VOz+5GOWhgzKRJEzPKW+lzpzi2xtrc5TNCJq9x9uRwfJss28yDHWKQ7esfutBDk+05CCUhNHNVqK82XcwTuQ3Gr1m+4IpVUv1/bmwylHnbKN7pRJkadFVsXX11WkjXgTgyeA1BtbSoAR3yhT9yfTrciY2ND0vhVbVGs9xoINGLzLHwqqv65HaliNpGrnqTRPoXOaKDM93fvnlIBN7DQ/r8xDQuusum6vSyABhoyaT2/mM4aXVIXXVP74OB1yC8yR1EtKssF9FtpU5RbZTU5H5FaqJG2t+SHoHY3a8XDNz2Hm2iDvR4LeiMn57OIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zVQuHo5PAgEorlZE0AKnomrHYuG3KT/osqtZmqcMGeY=;
 b=O3GDA60CNL+w3cROxx0K+AM6oeNK1BX5Eo0Av2uwC81KJk7ZAr7FTr2wzOYjvBjdELPi8HPXpjuskSZk2kPbpjnrFeBjrSuOllWUvBT1WkTfJZEvfQ5xnoFcmxMunk88uWzYhMnqk+EUMjVcKEqYT+jP9OdcYr8iTNqtFUspZfnvIk2nMhSYOP2hv5qAyA3L/kjAdNvQYHcXUMTZCbGZzExoUyqxvlg+0SX+dBnVrZGWpsEO8BNzOgAxS8TBWhxwE/a2/0Y3IpKJVWmOnoNZ5bZPPILVNrHJFzpVO2nZm1vGMpcszoMu1dBR0cdDW6jQRsW+yBAqAQU15l0Ao/CVaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVQuHo5PAgEorlZE0AKnomrHYuG3KT/osqtZmqcMGeY=;
 b=EAVoAMc/2ypF5igPBTZN/3nAIHV4J+KvogRhHq+Dz/DZrjjVRP74Xkb6VLnyc4gdVcydVdkd42PVWYypYj0cKdshFcjZ6G7wMFl5tub6nQDeZM6PdGfDKtgXYi9/pyJbNV7FjdTd2xIxJ4SEsgPdQbcs+2WeX6OTr/6AjIXYKs0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:57 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 21/33] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date:   Fri, 14 Jul 2023 16:34:07 -0500
Message-Id: <20230714213419.95492-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:5:14c::37) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df6dc94-b66f-45a2-ec33-08db84b22bb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTL6KISvOJnbNZ2bJouWiPCZFtmj+HPMmyfl34jat6PcBnZ0v0shOMlIIisTYKVl/0cOt5Sy/bvua3d8V8e9gIBJpkzCpAJbCr47DqfwhwBdlYzM2urQjKNDrgrYOQ3+08X6ZcGY76VvszJw825U/vAlvxxmzwDy8TJ+Nkq7u89VU8OZtGLoDLZ3MHNAYKSN0KpVsRVyccmGdDD8Gh+9eVq0nXp+aDKgnPU6HBgY/jZ2fWTa3zujMGRxObsaPdlLAlnvKmh0a/mzo0Z+GNZzpmi0FyCt+wlO6li5TvAPHHyF3addpLOyejmP40mp1P3iYgaRUlousPtOHkpKDTmjyedz29VzzUI7EM1hOcHUOUJilOxF0P4lzqtNcMdZVYeLaBW/dIzfw7DIwuh3X6o3/pnYDHgvbIttxKPznt2jrqYbBufPbTR4Az116uQdUPrT6GORzCRAdmI3/dN3RAonFSN8NLpv486gtQq5BCRRiYDR96BHbsLOK72P/d7uXPS2B3G9oSvCzZroU0vDibcvkSITaZM3MTijjJ2j256DVhvmEtGjO+/s/oWi8674eRFi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LXZErJoMkQpsy8960kMYRbCy7O7wrlSHnVsK3hNIg0C58y1J+88wAf0bh7Xw?=
 =?us-ascii?Q?kNJDoQTAfKffzQbSeR7gkY0BpD4Z0ANM3EgnCdwTh8Q6nueVyh+HT5rG34kv?=
 =?us-ascii?Q?9TRD5BHwbC1nLtgNSTnBx9XBRnKlYnc2FiVhLmUnBM1mZSSW6TwzAc+nSzFi?=
 =?us-ascii?Q?v/GUeW+NT/0HDtx491yND6CO0R7DWJ6fD/dAMI+RdBvZMIJLRReODE0GZTSj?=
 =?us-ascii?Q?9p1vcrYqd/OQGBv2hZ7N9jW5WXvRFfagZdSfq1BoMAbc6Y37HKju77zThmrx?=
 =?us-ascii?Q?/xIaB9Ivfk1g/fd+5BCS+drrAqE/hoGo5ytQGScBpkVW1A/r8n2kz6RG6ar0?=
 =?us-ascii?Q?59/mlRFFb9zVOvjim80kcNUI4mpkU51Of7T2L9w5TZrUoWiQLzo328y+7l9y?=
 =?us-ascii?Q?YLFM7HvG1+Y5DGHsY7iouMk5cy+rtiNt8AYcXXH6pEeKz505mK72YpbiiFew?=
 =?us-ascii?Q?otkPm3QYQGRmYy963EjpumbGHkO9BHhNrdOB57jRzvrOLOx5TPpVyIe1bbAT?=
 =?us-ascii?Q?SB9QBaZzUoGB09z+COLroA3+BCHD9cvSX04tXP4JV+c1A5hxdLFE/LlJXkba?=
 =?us-ascii?Q?lg1xT8qYBJTJfHguiXcYUYE36fCa45EdwxaI/LVxZWk8h8QvJ2yw+zQvLFKd?=
 =?us-ascii?Q?mvunpLI5PMdczwna9ymo9fhfCdd6J1fmNBv63pAtZdlq/wCpSVO7Fcxphntf?=
 =?us-ascii?Q?nm5UcqpVsqu3HxZXjLh4lRSA8XgsLt/6S2vOtOgRdLkXt5m+sYprokGPCU/u?=
 =?us-ascii?Q?voTe96vybYJeXScI17l3OPKtPvGciFKzB+1Q8DbD9+PeNJwfcVufbd5/FFdW?=
 =?us-ascii?Q?/mAMPNfO9EIp5KvneTwIR7vrueilx8CmVbJl/XC2O71EWiKIim2poVAQLDnF?=
 =?us-ascii?Q?wKsHEaFkR4w3BCwNwUJ1GrBX41GNyIXRvpSSDO+DLJ2YQkWzl8YWJiAUhxet?=
 =?us-ascii?Q?gD4uvDKYKEBYMvxYv0EVAjsUp6uVJcPDb7NpQvXtS/BniRH/WY5TbQBZqQ/v?=
 =?us-ascii?Q?URtrBTrHQaNLAUlumOBG6xB9Zv+hHrl3ZGkLgh0GIgkONhq9tRR83c0+Hl+a?=
 =?us-ascii?Q?wMkNSAGp/7TRtyz58bb6DnIu2OP778ihqVdwwI24qGbKA6KFEZMPUUXEgTQi?=
 =?us-ascii?Q?OMPu2PKcctsRCiL8IK+7sVvndm2++w1bRVdQbA7z6HvChFA1PJ618lRZzD5U?=
 =?us-ascii?Q?oMLfiJFVgYovbh6ykFwOTLa+9lX5u18Ys4mv6GKIrX+QFt/VK6qEZMrF1B8h?=
 =?us-ascii?Q?qiF1yjxKzA1FUFvA9Rhkq9sFxtsblaA/oRTSbwuJiscC7G07BLBP0pD3zduL?=
 =?us-ascii?Q?6IPDBEzSseLNkVLbg+BCsvKgBvX1cLem2lZwgp0GFvSyWHZ8FTWYtTzIF0QA?=
 =?us-ascii?Q?KVDVcxi4R5vs01NJm3r1OWIrH09g6SMJvm/QWbwZnO0zPYukOqjEGlPoFlNS?=
 =?us-ascii?Q?vSdgygLNmK41C6Fcn679PDir5bkIXI8yEaZhS4a9jbc+NYChigBKg+DleF4/?=
 =?us-ascii?Q?ooFemYhwT6SzuYJotmNo3gxctzQzxJAZXrOS+CdmkydmO7wXw8yJ4dUcDO5y?=
 =?us-ascii?Q?Ta5lQ0RQxo2I97qFkrJUtu5Hw89WYuof0B97dTtCKxlqdHK3BSG+4KscogBf?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2aQSp59LlAaDQM4CgdXB1uERGJNODDUu/7EDrShUDQ2G4FvwyVar3s2Xzq806D+Kp8gPL/mt+r+nflolTi39bO20h2yUVRPAg4u/Qj44tjetroYsjLUuvGedFyXbAV9Kd020Tr5OBRi7csKew3b60gJqJr2CO/o752kMy++M8ByPIEhkOoiUJG6qnwJPn2OHtZioBkf3xqZzHmlKoUtaTXf8OGPJgIwJKFjG1Aoha76pNoJs0J4nDNr0ZVXKduzIByWudmFC37jvlRNHCgD8Mrkejofeac03ElXKfRfEWQRbr3hG+nORKV/HuHgZ3vQY2JMM5dumaWjKc+xvvsNTBqOtsmooja39NcrxrrjIAwC4G3SBFFN+QzB6z/cImL7VRPUd4dxtAoXE7R46taig7ziOW5QGVg4tbA1eOW5+SlpSoPquiOqtKfeed2NlhO+u47/x9purFcU9zd3javnEtoQ7MwzUoq6H8Y0uLi5JHnk1OV7FzDMar2ghHkD4hWu/YEz8ILF25Vjwwu36MJ3cjcwAcHQyLrJI1irX2epidBYDtmUBaQrBSQtG+vrHieYUmhCmA88DmDV8tS0uUFcRS6U4UeJfY/PoCjcHjzi/HxQaOJXXBHa0ukole4tqqwuglCL4oNS9RTcC6Xw4o7YHVhpxc4TMlWVk8TkwlMfK7M4ZBOBzEcw+KMS43aWRY7JPOExrJgrN+skONt2dc38td5pPy7RRyBT3gbzxEKND7/pjyN90EOThB1JvBKNFvBBEEkv1P/an9N61cDLEfsh+cuuHm5IfKvdQkIBaAGjFkN7FxIKPlipR3lsdnX6yRIqKx9+F0DQgH+dhVlTuSByNYyHeaWESe2NQn2g6xUce2VtcU0uHmZO4gjnX0yeNYjQa
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df6dc94-b66f-45a2-ec33-08db84b22bb0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:57.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7AC9lAPht3AubC4gkDBRVxXKOyhqTmYdu7Kc35Ylcq3ZIGHZCOH3VwWo6fQk8BKZr/Dabkl2pCsNh/dzH1pOvzbdxZk7ENl/sBs8+AUCD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: 6BZVk0ddGVRG8bcN_F4Q4buhi6i51Jjr
X-Proofpoint-ORIG-GUID: 6BZVk0ddGVRG8bcN_F4Q4buhi6i51Jjr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0097166814a0..26b21e20ef0c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2186,11 +2186,22 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = failures,
 	};
 
 	memset(data, 0, sizeof(*data));
@@ -2252,12 +2263,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.34.1

