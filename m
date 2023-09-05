Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8561CCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbjIEXTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238111AbjIEXS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:18:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96D71B7
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:18:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MthKg029165;
        Tue, 5 Sep 2023 23:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=cVeL282nvfOA3+yvDKdOMj0c+JdqSKOdqKk3lKBB+s0=;
 b=05vN3NGo8WX8TX37KFEhCeWFzjdwCnq+GG/R3yUmYZoec5RrK6+hCnGV0hL+sUL7TWsk
 n0E5RToG6i0XjUfngkP0wiHChDSWCNWiZeyF0ycQPRFAMNEtTmhhw6Io+gidoqgn6GFl
 q0lgfea71JOlvmMp/a+ovJxvBVFxmju6KgLfn7dkMkOZnAY8J3foq4wA6RmiDewWLM90
 ewbAw+5ccoB78qbB4aIqR+hJxz83SdZbrN3mHr/41f4F7xx1gR6zHvMUEpzgXy1sggVs
 VNzaRix7bADqj4VXyul1elK2sAg+WG+JOpswQMks1esfD4Ty2sbItMCnlJWErdB+mt// MA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdj500w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MD1JS029122;
        Tue, 5 Sep 2023 23:16:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dy64-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2EiVpukfM161MirMcXo+pEZBdpozo4qcX0jJ5cY4N8tS+ONFuw8Mns/bq1Rp3TzZ5Yblm8Lem2ot0y0zY7glA6DQDdlsr2IPAK4b8KHvalMMzCPDm/9JZifkN5iZo4rpm2jYS3iRB5CuedXgfnqApM3wykKlrPydMuouFxkuMBq6OP8Mclix3hQv4WmMb3WoMFaBGz/1fjzEH6TylUKn74Z1NCmy1b5yWQq8Zqa+IazyIHVrAKZ6oTDbCwEQ9gdNxBbysVfaOlQeblFIf2PEBgM3H4WwmrSN4EtbEjJ5XezKW0xXNOlxAX74FroM9HY9tHnJ9Od5KPWDwCg5jDmfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cVeL282nvfOA3+yvDKdOMj0c+JdqSKOdqKk3lKBB+s0=;
 b=oZXt3egzbIUjdJytErnoROAWkEP6M4bp2SFcnMpAytKlZqKuCY1IRXCMBDymXzvLKbA05wiGJmBOrA9qkMMg23eXhdx1vwOf0McL+73pIrgoBUAHJqpKfjtcwN2LaT97DIKZlkKxPQvNiYoV3kESaq6gc0evs5dCilqyT1ikkSLg1oN4NDt+AV3atIXsMQsMsp1aolK4uORDU3TXFqq/lkmKhaY73O5lGL9gGaeeIejcmu10+rElHRZVCpiSroik/wx3NUVBcSPtPiMNvml3Y023z4ClE2kGD25NnM9A740pqps0u4VDWXu68WFv6cZc3TThcqwYOo1Y6eFjxjXGlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVeL282nvfOA3+yvDKdOMj0c+JdqSKOdqKk3lKBB+s0=;
 b=F0wNvlqObiv0qrZxBndGXGhQHcm06OtuNRDriRarZt+WhpoWfF5ZXpbUdlHtz4hdxtfaPOWvMxMqY5DEtX9lNQpatbvS88cyOFZk+erPKfu1uxQbUOivzAml/2cos7l0UTckLNAX4HRL9JKx6f0rQ+ytomUcOsg6Bb9EVaWcDYY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BN0PR10MB5287.namprd10.prod.outlook.com (2603:10b6:408:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:43 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 28/34] scsi: sr: Have scsi-ml retry get_sectorsize errors
Date:   Tue,  5 Sep 2023 18:15:41 -0500
Message-Id: <20230905231547.83945-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0006.prod.exchangelabs.com (2603:10b6:5:296::11)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: a10d4e7a-8541-454a-ad04-08dbae6629a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mARXFiJzt6WCvyiPb3khdfyqbGoYJlHEPJE4vaL18eNwWI3/1Yyd5uL98lRet3F6b8titRnAMBdlI1Drxf1I8Y6qnxs4KYuOVTweiZozvrc+N9azBBsYjnPt5lTlhMdYIMWXe2fSusIkn/ykqP42qdry3WpVRRmv6bvoVEhbPM6UcCxXksGEUaaYba4G/GuU4iUu1ZRr8CZINjFI1LfgwTCfRQpMrEGNVrHTb4NMd4u7wp/5qxW0BbOWb944rIqp32RfhJRteSIwiYzSaJbWAPaBDlX9Kld2StWbvVr6WODlygruXUEIA4RQkSz3qw7TvuW6UnBq10b1PAoHLyKfXj732nxV/Onie7CSRNIq/myJ1k4/Ble6a2S36VEq3+vUc0cdBRL5J8bxNacIkG2j31tGvoRpfKepM2Uq6y8arq7cbdtp0viuLwAGxNzSsqSXj+NG47JbwCxD0ChxeaQ90hD3ENqbtCp4tl5DaCrB8QEQVbdy4tuKE13cfc/8TjKTE0O3SmCSW0RhBT2h6+DmGp7qflBHcYnB8CW4z5ELZQCtzUfE0d1ngLQAZHKxwTgR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(39860400002)(376002)(1800799009)(451199024)(186009)(5660300002)(8936002)(41300700001)(66556008)(66476007)(316002)(2906002)(66946007)(478600001)(6512007)(6486002)(6506007)(1076003)(107886003)(2616005)(4326008)(8676002)(26005)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ns2Rf1jZL0BQML9AeysUYjp5D9y+6ecHRoET/NJ+q/MxzbaSBxp5Hm6pDoB?=
 =?us-ascii?Q?vvQbyzM23WJiq8WDMjkRug1sRiJijFEwQkEcNscFKA0i2/uEuQtUkG41S6WB?=
 =?us-ascii?Q?7yblswn9bsYQhCJi6/W9ThhczE7ZMd6yp1hjTjvVa6AzrABp9sOs89b6qXeL?=
 =?us-ascii?Q?tmib8pUtdNbZqugeexLNZJhva+/oT2ZcTpjW5nSSLAJCIWEdFxvmlb45mZcQ?=
 =?us-ascii?Q?zeeI2NiLEtMyY+7iVzJ7pTetL4/9aYX3tuNx4TNOTO26SFjB5KDDgX8ApQBH?=
 =?us-ascii?Q?rGkR/ciivLX+3V/e2vKGxXSRPCOOxEh1BLAnU4P66qi1LbauYBqcqO3nNrIS?=
 =?us-ascii?Q?zGK4/OGg/wyEERniVxSRr1yoU1o8fb9Ef5Xz6QvUGAe+zgIuGK0qgkAbdn7z?=
 =?us-ascii?Q?D/hhmhTp8Mklxm534X45EEZdWMoi4OKMjXaKlmm9A3g94v9wHCO5EjmpeASQ?=
 =?us-ascii?Q?RLtIUnetyCyJBHIbcsegMQO5GqZ1TIBtGo0oS91Oeske9QkuING4y3PotehT?=
 =?us-ascii?Q?bL452ju6d2d/K8e1TFoO5OcMjQ2gbCQ2TjfXTx8NVjyEi17+73bMzpcyXxAu?=
 =?us-ascii?Q?LQl25vzqTOyPO869ICwnSpaiGFXxnVi7bgHXuG/tW1wnc1ANBFozmhELYnqT?=
 =?us-ascii?Q?W0/2YPOlO6n5No+MZDvQt8cxhb6/LiqZ8phtyue406ZVXg6En19OwuGcBjjP?=
 =?us-ascii?Q?egHPk4OcDUATkWXVXuk2jn6FpVgarU6sF71AjWLf6Emyfbb7i2RyZ79nCSEv?=
 =?us-ascii?Q?raCokMdHyX0E2aDNS0Hwf2kj7ZyKI1up20EwJrM6+JehechybtGf6SNmRd7b?=
 =?us-ascii?Q?nTqk7f7jMDdIdMDAwTTIfnI4U+C3rQENQxEqNjlq+cUn0Oqo7P2acIaVRaQR?=
 =?us-ascii?Q?eGN+IuHQK3s7glsf2MrlK14093kozsF92olmLg5pj22InN3XZfIxIXC4pVJL?=
 =?us-ascii?Q?uv/QyanEmIgiVVvd2ycIAZ6xWM7bPw6UkAZ8m1prK6kyMVUkBqc+1ex35S/o?=
 =?us-ascii?Q?QSfShJxqUOr77mJylC4afYO/MsRISMtc6MBecTG7dsOPdic8rCaRlcLE9UMt?=
 =?us-ascii?Q?UjwJkkTTIuhibvtQW8MoqJNgjQLKW9jMLI1yg0qQXkOjslLRst/DDkd1vJXV?=
 =?us-ascii?Q?UYYZcihcnJXw6NqRWxT4/YT7ibIFgyhimT+5PWQM9FOkqLYM1bvhyBOMF2b8?=
 =?us-ascii?Q?abNwM2GTjO6nhcwod0s9rkodEjsgKteyza2fRxEE3IN+ZmdnL8qWFB/bCQDa?=
 =?us-ascii?Q?Ju+AZE73W19n/SKywoW3kqheviQZMYSmXwXLGsZU5dDl0S1YmWigQzvaQlK4?=
 =?us-ascii?Q?STPYfJxzbag8VNsMrogU7EOfvv4ujhdknjPR7zDsL193j7B5jZ2K6hsKZJSO?=
 =?us-ascii?Q?J2+rqGBrsXu89GEkLEMUN+6+yxL6F8UogcWjTOnw4mdNg/OlPLMR+jbsYigy?=
 =?us-ascii?Q?eteWGwAOS9GjKVORSGLs5XSjZt+tHskj3NF6v2x1YikGtTGX77sfUIKe/g0L?=
 =?us-ascii?Q?z9CH9SqPRIsboL1RfgX6rJ/RUuhYIV8l4Bsex1uMIcUH3VzziHcr7E/dWDyi?=
 =?us-ascii?Q?ngZaGY5fwYwh+1I/bLcoz+cNK/4op9COOdpVUhXwJZMKQD7UITOrZn386Teb?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F/czDAMbbJAGM74ksOkvZc4zUB2FkDKvUUie+9tYdCh8ZMUhFdRE/QIoP7RdvGMuXa+xF2VDqrBayLDS5MZpGJFE9LPeMOf2DxpBSFuSvN/SeQfRcjwop57gvmUx1rktUT/odAvQrTpLhTSKynjueabuiYdan4gnXPHm3qIn9TKrgYpEcXqrHWfxtZ7w/L3+4vIDCD2gy2eUmfqcUkuJAUQSfzGjNDwHzd+7o+aHk0GJ8/nJsjB40OY/H2rSxhIuJRQk+H1Z+rlIiuShF2v39mWKzLW+XNkpOo8QOa3BlZkoMO6yN+3oOSO8olt9RRwyFgK+FuQKYNJ+2IC5KOuoqQhFAHoGH1JeCV9q9MUoDBTRm/QFjT8m2yej6gDdRJAvMDkH+azgelwOL/1bi6GOGsWd8Ts/EOBpwj4FfmmMjctTUyg3wYWZrj/oWFEv0Nnn0HkpqNjZur/8SDF0NedmVIRgeW7Bjm9f9hZW+bknjlJMTaKMXMLr/E/Hj+zcThuaz0FH7d3EP0GJgMcs+FV/Wg4AhAOXbR/rbwmrGDZX9FmH+X03B3Hm6h9LKzuQVV7aPakGdCQUal2P2i4/onEwUBc928YYX+ZR6P6j3Fq6t1F+seNzteeUGlcy22aHU6yLOOXmmJr5x0dMbDH09ZG8uObWKMcvmGPpSnYPEuWicgMi66fFTnXVOQUcW5CYVPTMBgBGIqsVTpReflmhFJWN2KWnuK9ERroeZLxPo6/QRapU/EHSwYZxXDFTqTnowSeoLlqqFNWN5cKkwhd/g3GU8uMDxmBkrHoMpuiXVykyhNwerp9QG4s26yRwcPA/NOOTuEaOFd4jDlcFOumhyTmzNH3HCjeF8hciQuvN3BO+PZUVQhEv2M0bFHMWOF6trajV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a10d4e7a-8541-454a-ad04-08dbae6629a4
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:41.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eocso+uApSZTgGp3pVkX19s+NpGj6kJVXVxGF7+RaVEPUBu1QXVnyTkMgB4CRcE3SYlcEvbfQMo+j3SHIk7uC/fIs5j633hWJtkVtyAnmug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: A2MOWDJONMUB4BQkp7cuwttAZI7xbJ9W
X-Proofpoint-ORIG-GUID: A2MOWDJONMUB4BQkp7cuwttAZI7xbJ9W
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 07ef3db3d1a1..100480f5bc2c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -716,27 +716,26 @@ static int sr_probe(struct device *dev)
 
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
+	struct scsi_failure failures[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = failures,
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

