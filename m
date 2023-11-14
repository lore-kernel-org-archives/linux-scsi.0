Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72294C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjKNBkj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjKNBk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:40:29 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16231AB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:40:25 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNseAc016967;
        Tue, 14 Nov 2023 01:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=i5vXS1djHmBsng2QRrTpw3owfNQ1wdfmYnh5ZA9b1yk=;
 b=sw4/I42hyP8GuKCNhgDMZViUIXsEIHVquaKeolBuX9zeGbr52UbBlGeylTmlLnoO0cow
 5gyxRwrtmu8dx+9vJq+h4+1+Nazvmn21vXN/meNZ7ODcarFKhjTuUvUtvyDtrZMwHnWu
 F+VvmRVn/F5cT8owU7jlOHRxhfgnZCBt5PYw+f0u2i4dCjZXZqTyt8Ox24M3JthPfqmb
 FfxUv5gdAj4X8H+THmlSjtb+g6HZBTyTwSxaSgf3qGBsEZo7B+O1laaSBY/UFWVqYuCf
 gDMniLZKuE3UNsvK/w11xFJn9vtbtQq7gUwVm0fMN0nOSbDUTktfDM4rtGkjvlNRBl02 tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2c4gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0MswD004499;
        Tue, 14 Nov 2023 01:38:18 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ub5k2j1pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6Q2RKYbf3L9K6/d3ptfaSSNeFG8Jpu2VgkdJZfIDM2L9ZLgNr1e2JAvDta6mzgUsGXfwbLSTc0ePDZZmJantOwg5OZZMZbZSfB5t8JiZdp/VMKyWcn5UKskYYnS26qI7TmkvLNcRCZK6LHGMq7cBoIWRCG+H2hh6uru5nQVlQMWWdmKFAoWmp/16B9bgs/ZUd5Xua5irO+bl8NbFWPQxFIM79cOtSvzAVpbN04hjJFClNm8+lRcH+tR0fCRe/lWQXnWrhX3bnF94tmoJBD8lzM4cztFNufPcGzGIBD5bgTOhbiv+yaDHj+thI6xsmRqQNC+X2mS1ChGhb6qScle0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5vXS1djHmBsng2QRrTpw3owfNQ1wdfmYnh5ZA9b1yk=;
 b=UbO0NZE6a2t4PnuzUB13n2usITG58Q5f8Jdf6zOdaZaDwfHUfv9YBYwhgUADGXo/TgSGOUAGhp/O4Aa02wYX5aRN6IxEAkzFlRFFV897ziDQAGg5NTBxw/Cfs10L4qKuQpegh0HoJFXbiaV8wrgAkJCiSu+WUjwDQZ69Y1jAfVOUvGhgHCNv+rXVyFx0+4CH3nV2/IIzgCVKC7ryc8FWMvIRRn3DD0263bX5mdjlSz4WlPq8Z0hMFEy/X5fVU9yGvZtEDthInycKgqBqtSBE14JosusB+a2VQfseetEhnqGpfKxs5g+WkhjwPpohqxc+sAJcmvzTcMCGigk609b5og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5vXS1djHmBsng2QRrTpw3owfNQ1wdfmYnh5ZA9b1yk=;
 b=Qtdm5h5IxnicCPB0RNMCHiaaSm++ZvQW2yY+D3FM+LZscFBYKFcYbyLjinAJjWtrreHtugIOPIAhoDC7QdMOdF/jpdNa9dtWCmO3ho2qg1QcUvrzM240jUNRl2M/BIkTh1e+rIrPpg0rsCrpdDn1bK4O0c1IkdBKmDgT3Jika1Q=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:16 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 18/20] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Mon, 13 Nov 2023 19:37:48 -0600
Message-Id: <20231114013750.76609-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:5:177::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 52693522-e4af-4a39-5e00-08dbe4b25f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKBu2pbyd9GWv94C6/9Ih8VK6biNVjI55KPwtkEByvZtwiZ2Qa5jlIMtN1aeqbCkjWx+1AtiCp3MjwCir+W5VMTzF5yqSdKH1Zp7a3x/NrrmU1A3mwSZQspNtqyTbibcQx+a8CTuOMzRp++1mkNXL8BpvfMpeSmRWxJahSg36hgFPNGEfe6xg7xMOmsFhsJ9/uE1qppku+jQGL8WMZi7DlV18PMujLatetsyJangMsmwCukFStUixTekBBafaglstUGOZqHZk17o/soNWlMaABiH5BgZApRvd4Vuf/Y5DcTOsH+p22APY2HuU54qD2iwvNHbM7GZ+wd6eSRScFUoCVxCrICT8/pi2rpsC83p6Fd6OXqS+48Sh/2hbCMukoXJeg1kNzJPt3+itczAJBL8tPrh4uklE9AJd7mS4fvaKSQkE2EK3IvqJmEaVZV1ZRa73em0/YWt0O7il6DXnD7fJQd7UPakMJI42dM6X6CgHS81F7/Y5+i+8NRvB/DiLuvvpIvIQOBj8kcPpNw2LNauTXYSlPI/JHqGeD671idr8bcJ2c+nRDbdk/yCg2quzyvf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q8axpojM+HjFFNrgjv1s3BCgFJcmPFjQaoIpsRkQ6VZq3mh8tcyMGK60ObHd?=
 =?us-ascii?Q?UQ+q9Q/w/tC0JVhwbiXtCXEvXn1/60p0fWKDHXvuRUvtqGIEc19hP+Hf1/Lq?=
 =?us-ascii?Q?zf/DbNDFb2pkXSIXcxY11TNsU0ou6paKxJZqkYF9q5TI/CJaYaHFH+YDgMUJ?=
 =?us-ascii?Q?HjRMiisilh52LvRJCBPQ6czGGqY+ZSzI6TbJMiJY8F7EUhDoz6jTudEIKLi8?=
 =?us-ascii?Q?zQfs/xE4ToaIp6x/THnYAbW85vGa9Q0Y/KEGohow1n7zu5vaRkMFVQ9b0EVK?=
 =?us-ascii?Q?KvURDsc6SA4NnHZfFsO05tf2J6d8VE8jIJzLSE0NwsT98l0lSLBSrLU9Y8Ca?=
 =?us-ascii?Q?5iLTcKRXpvbcOoNJb7jtqkbzmavRkSxI8SadxgnbGw94/hM+BqgPE3JDvp5y?=
 =?us-ascii?Q?F3OBKEyYb4wPUiHArNXHnkYyiTUzAEtA+UKjujqu7K4w/JDF41bF0G3jbtFg?=
 =?us-ascii?Q?GjcF1r9+jZ2l9xBQRs9YlvzsRO5vZGETQLdv2s38K+X1HYThPbmOTIvZCBxy?=
 =?us-ascii?Q?UJBHZMkjEk5ZdRuWjzqT13WQ2tBA7qOJx6qoI3ifeVRf6LN97tlCQIGGG5WS?=
 =?us-ascii?Q?0YXtlHcRhnb+Rk2haI9Hsfw2yJqOfV6W3Ue8bYqRREs1pFLl++jatVa8ewJX?=
 =?us-ascii?Q?kVNpd0l0f+2nhJNK3MQgx/RJbxX2xnO+KwGrkh9UFZQEURNOtqs2qI3yMbuJ?=
 =?us-ascii?Q?RQdxiVOZQXkjdHGmOt5WMHyEgNwzzrfCh/nq6uzZbxR/Sv9CNs0pyf+5E+Tq?=
 =?us-ascii?Q?C/5pNRJMYst3MomFN5S2eaWlw60sSr1co4cXAH2/+p2KjT1QKaOZvMPDWqSD?=
 =?us-ascii?Q?Uqv53tcAJEo5uZj0pFVwLfFdPFLTVXVlfKflHvF5rGCebWNMKpXxwsHtaFKG?=
 =?us-ascii?Q?viw9uc6XdEWUlB/XCnyKgQSEGoVUmqEjprfjOQdzXeIfRjO7pWWP8yW/XAbS?=
 =?us-ascii?Q?ZJA8trnYPFSc4exy3BdJPLzWbbwoOIvj9G6OJe4mUV+RFeobblYCygNRsOtR?=
 =?us-ascii?Q?LRGkGQ/6pwK+MTpN55j1tH01vZxUr6tpBRyhrK2hwzrUM+Je2lHf0CqdfxWl?=
 =?us-ascii?Q?ESO9Bq1V4np8FBDRtA9OnIwb+NwwFnuAsE36kSqjKlS1lTftkK7f+yD/lTyT?=
 =?us-ascii?Q?Eze+WvCzRw2z5OEOmfJzU81Q/7mC/7oqPL9w5aXV/i2yrqQJOXXcxgKg+y6N?=
 =?us-ascii?Q?KwP/TO3Q+he+HuObB95UVgGzQlnI5GubltBjzfNNVazjkEaqYH0NkAKBWNi5?=
 =?us-ascii?Q?4P1d4IhfRH1mx76XK1Fgnw8+EI3vfujmDCoXu5WbKfEgBzTdb3Uv575bVJGO?=
 =?us-ascii?Q?awqCUb370unonediMKTnKpicO6t30ib00RtMbedEOZ/sAUpaJiTHYtl8HPah?=
 =?us-ascii?Q?jCP5Brx0ZGAK13ySdf2AyXxVa5ZFKyHnIK35H+bzSsWCVFnSbVjBg7g1Dcy+?=
 =?us-ascii?Q?E7XwfZ+xVcd+kcCFq5JBk/ykANlCtuiSK5N2MDfNQ3C9mutG8Z8Nm4rHKh46?=
 =?us-ascii?Q?5EYlavEClJ6nS+tBWapY6f6AET22LM3KMg42XKBtbcQSQqtkORn93nsA7855?=
 =?us-ascii?Q?QrQSy64+gz5ghZ/pjiLVlEFqzkSFqvImxkHVjTPYCcIb1E9cHMs5GE9Jnwpb?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RssZywo7oC2RUBXoocvU+75zyiynP1WQ4VDykbxLiVvXTyqzO6Uva813XBhKLqMeSNCFbPLvovwODYvFLqRaOCVMqCP4JCJopz/3q4dqYVxMlzUmbtzWYjZF+yDWbwXzeCn8nyoh1MuJMxDX6tfD5E1BvOwSdfoMx/xWEv5iWS3LbgDzTeg+6K8fXyj9PQVNqU9PUUHnEgYf6fdx9cBwqn+lTxADXqiyvNpEZDERE6WIr3XT5EkGOOnDVdREnoYWQgFQzl1X327u83qQ1GlreBwoWoozApud1Asma/T8MR+kyJ8jMo1a946FHT+V7poQ3gNsjkx5eUHEblHHK7w0IyKiqjEC4qAZZC47U+/pgYGEMW5XNL21l9vH34URd9Pv6jW7W2TdmejajHfp4ZZn0iXk/E1vNq4kK68y33EP2pPZ+RbOqV7T962/4ShAPahgBZg4dPdXwZg20NmdXxYX6N0p5S2dPzYQJNB0leBFeA/6B/8mMzrgU58yNKmIsHV++OrWcO9ZuMpgt9215VK0cI1xT9KCjEv1Bgnra2ITpL6Bu4VDqG9097LEcEwAXX/97uTBS5V4L920Z6E1VX3mOkidrjsk7Da+ax682B8qCU/NqTzbrYl7gBChDnGPZI9qBxIY8W9FF3Ua5Z2onX/JA8NJS+9eTb4006yIlxkNc4LUruJNyvVbfJ9dcCLc1fPsuIAZ0Wd9Z2EZ/roHmIMy+se7B+wHIb+Jb5A568dZUNCUl/zp0lr1cxFHc5OGRYDe2+DqK7evYskymDX77NNsQjSYfnbdnYyn8bC2DXe7lAzPzlBoItvtBqY83+jpvwQCxYckUIHGD1ZvoZCGX62CVRwbU15x7Hh7uin/TDMQ/WFqKvg1WieIXsjYHVJl7Dt+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52693522-e4af-4a39-5e00-08dbe4b25f8e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:16.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2brNQsjyA0BZ6R5QqnkjbfpsyFey4nkM8ejGzgJORcZlrHJxy55KQO3rDb8AFyfu0OfFJ6Lx1vJ8s5fHaCiZFdpqbV+M8iDRy9d4yeUb2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: a-2ZJOv6KkjV7MHucatHkFMIx2FVVlhl
X-Proofpoint-ORIG-GUID: a-2ZJOv6KkjV7MHucatHkFMIx2FVVlhl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has get_sectorsize have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d093dd187b2f..268b3a40891e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -717,27 +717,29 @@ static int sr_probe(struct device *dev)
 
 static void get_sectorsize(struct scsi_cd *cd)
 {
-	unsigned char cmd[10];
-	unsigned char buffer[8];
-	int the_result, retries = 3;
+	static const u8 cmd[10] = { READ_CAPACITY };
+	unsigned char buffer[8] = { };
+	int the_result;
 	int sector_size;
 	struct request_queue *queue;
+	struct scsi_failure failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = &failures,
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset((void *) &cmd[1], 0, 9);
-		memset(buffer, 0, sizeof(buffer));
-
-		/* Do the command and wait.. */
-		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
-					      buffer, sizeof(buffer),
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
-
-		retries--;
-
-	} while (the_result && retries);
-
-
+	/* Do the command and wait.. */
+	the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN, buffer,
+				      sizeof(buffer), SR_TIMEOUT, MAX_RETRIES,
+				      &exec_args);
 	if (the_result) {
 		cd->capacity = 0x1fffff;
 		sector_size = 2048;	/* A guess, just in case */
-- 
2.34.1

