Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F53514DB77
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969363; cv=fail; b=PLJE0HtcX23v4g6h5hVlARXcD8kgk1eyH+vmB53UO3Q3tdfqv79RHEAgs2auIAxIBmG37fFUPrsSH/SRiIT2/gts+G0DizqVvnJ2M7QQpoe7QINZvre5h3g54Uta6rxR07MG1xz6tjGv+6MSOYqM3iXalheuSnwiosubRchh9CQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969363; c=relaxed/simple;
	bh=6Fok6q8EFJzUKDnhJU/p70GxQ+adu6pdeNod/uJkGmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s5ZnVAw5LTu7GzWSDL3i31B2BlUs5VhzL3RhCrTFHCrsGkXBuav1HLObRK+iXCMSl1SIuVbwBnEU6Cd3dnOEw02hRi3ikvr2s3q0tx4clt6IhoSEQp/1IRAyYrDo/So7SMOxvu+UtsasNrhieUyPmcxna+ClfLWgSJvW9Gymkls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FkOmcNYF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BO1Dg9rI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FkOmcNYF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BO1Dg9rI"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMogLr022182;
	Tue, 23 Jan 2024 00:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Jxsb0thGeaakGaSIIjW0c1lUqI3rg/gUtemvguE1cQk=;
 b=FkOmcNYFOGM9PpxWbYahrwDabOzMNQOouXoNB/ZVjupMgD366vTfENgcZlQpfRwypWTD
 RrJMUGQ77qQVkkx2+cnnp+v/uv5BMiATyhzfkrPWdEaHcDELk8K2d5AT425ELvdPy7ke
 VQsuUWa/7DIlKmieHUJv0yl6/rXF+N/Ul4/DPLn28SxjT1Kk+BICdY2T187LtUhMhQpP
 IDEDW4WMdrletJreZq4OeR1rxJsHbUN1kI/L9FNJvfwCCZZFrzdMW7529ibfEj5SXFhE
 JKAkhMsNt6mfJw7gKGdDtSF6PUQBEmPOcUxYQ6gpq6E6veqPeis8CBp+vguLBLeO6plQ Fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7n7vysr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMqMgb013112;
	Tue, 23 Jan 2024 00:22:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vs3700jkc-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:22:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRY21LYbJR0Z3EEnGs7YahGI2e6a68BWkFe7qh5vScWA8ld4X0VEstGQkxbBtKPMKlmXq+EiT5AjaJ+yjyLLwhTYJU3WSNEKBnApgY4gckm5edVd1ZAi2GswlfLlXDmZfoih/eTn1qsKhsABTo+iS5R94VjwGDBDM4QsSB4J9KDnIRsj6YO40c9ASwCAnExNbk5VIUV8RRS34dxFzoTcb424WIfCz3i9UpuKyDe5F7yV0PzisJlSEBlUn8OhQNWCaMonI9fsZICzB9UwJVp+1jF5VY/pHEafM9vzfEYxJFquGUreCtDUc+iq1S9LGL+LDELr7Y5ehB2+5NrJ9p4xhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxsb0thGeaakGaSIIjW0c1lUqI3rg/gUtemvguE1cQk=;
 b=DFCN4YFbNKyDgojPsGkEJD++iJOxUh9lOY5bxl23hwuviPN/rxivq63VqvI8dIt5gmT5w/JQa59nClTVlOmKDaVBQ0HnfsgyLQdbGVMZohCzuyk/3mjLwulLXwVhBp7rLV+lfGX3+atmbUcj79GSIdNNN4HLHeTqi70L1iW7ZeQr4+5qwwAUDURNN5P23Qz55g3lozlm2VV9Tajb+GINyQdGQEeZx68JOBzSVl7smmTCtYdgIrNPEZqA3dLtz4J02rJOrV8XEE9PO1j2JwIvju/LPwVCYky4IB5TKvE6IwG/Jbz2BI26kCIMqxH+R2/8YrRm4iryj3V/xuwuqq8yjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxsb0thGeaakGaSIIjW0c1lUqI3rg/gUtemvguE1cQk=;
 b=BO1Dg9rIpytaOPHHokxAVvVFHa8XBnQHdj0U9PO2WqgUjolni+iXo6XRLoDCo+Mg6INRj2CoPPvSox7LERC1OyStvqaEYftTVcfppZLY4zDoQpKzseOnlncAQk53UC+3uXSUn+htDrTGl3SPEctLbmZPXkVMoaC3hcQAHi6s5IY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:33 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 07/19] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date: Mon, 22 Jan 2024 18:22:08 -0600
Message-Id: <20240123002220.129141-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0323.namprd03.prod.outlook.com
 (2603:10b6:8:2b::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: ae33878d-bdac-4583-d6f2-08dc1ba964d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7e7YxYknPGPClmAi9gxZXeX3hqwDTf9bA5DsmPLbgQ6Mzm/yESXLPg5pn1fyn5yQunb8BIhJyIGEDABKOo+G7efhpOh0w59HAPjpH9w+MULhDBv4/xOjuF3kyms42fbHlhUEMfYg0Nir+4UV2CTHT/+2lAhcYlRS4Lc39T/s9jVg9304jm7NDvQJokHx3SQk0Ozm9m5LacqwgcZU0rqlkdeWVgqtt/mf+/gs0bq/ttBTMRyQdE6lWurHVipibMyqT7gK7SlxhmFTKXOe9iyHLXCZSYPB0uGCls9RvallLf4lAy5R3PV7iKlXGMkLyCWm+B3Rzs76Z/zNhpGh9dVZWKfrETVBZYwoofW5sM3SypixRPBFc7SfDMCBpCBqcbVAPHDg7QQiNfiZrbBAZ6oRmIh5PAvs4Pk59mY2tI+w/Xfi5IEtwLjaXjkl4YiDfJHVfmgqNEoN2mJcoTMeuufUAnQtl9iFYQOCESNHAe1s0mnhKHXa/sEjGlnM6ME/wXIEDADlus7wbSaukRbb7289lm4WODOL3qzOkU281joOLxY4Eur0+j4EdiavHSpR+ViNt7tV2+fzqbjnGH5wChthzck5xkWKL/+9XC/IYK6Q1Fi0CF1EwHJc8meG7dql/iSd
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230173577357003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?bC5F6RfaljEImb21tM97XKKaOTqRST03SGmWVZ0YlnsObdEV7oYwiuf7rc8E?=
 =?us-ascii?Q?SL1ZxrFOiLx0E019RYmnwikrMzYNB2hf2szbBnjwk3zvrZRQnn5yBT0SvMJd?=
 =?us-ascii?Q?M15ASkdI5vs/BGnuX8A6HjXjwZ4NEpjiKa7kTZJTaiyoT5I4AYbjeUZNc4QT?=
 =?us-ascii?Q?lmUKCSBjlGsjiB93C0fyy7PdE32ZiKG956WNpnt74d3HjxLv2ryBsysisxlv?=
 =?us-ascii?Q?YRFMhalIyJJIv2UxK4cZ43lP0G4+dHNriXpPE10/sY6VY3FZiFPY9Wuh1CoC?=
 =?us-ascii?Q?dv8dFuWFMazqvg/WRFY3b1lrfgCP54ugx0S0ftOO2FnOrD6dc4/G4Ch2e9IN?=
 =?us-ascii?Q?vjY0mY0+75s48oyvzTbYGB0VNsPUkLEvYaNUlhkLlMEjQ+8fyaGiq6fPYamM?=
 =?us-ascii?Q?+JyF7QtyD9GkmM44WQmgduTbo04nOWSPKyoy89zp5Vo96M3sx7CP7p4Ik4lf?=
 =?us-ascii?Q?68I8lbEiAbLaYDwrQPYUk6uMwB+NIs0mWQqsRvdigJKlJhODsV35owhFGUa2?=
 =?us-ascii?Q?zd58aF0vHOzQxfF6lrOcSZu864Q48ANKPyQd29oESn2VGgo5mMalX+XX/fym?=
 =?us-ascii?Q?bnXjeU6sNyYmf8i5BsWUIPT78N8S/9kOYWuQVTh7jbAthPWLdHlIxxtoSkrc?=
 =?us-ascii?Q?Gg3XoUzkNVnI0mzDUY+AWHy5ALpuDLpG01oNJ41dUcopC+euKO/BVOV0mo4+?=
 =?us-ascii?Q?xQP5LjhPmDx5P+z/Sj+z8I7HKI1TesVae76ygoSLbOYR40TP6Hd6EatdZJOS?=
 =?us-ascii?Q?ajKFdNUGBKAuIbIYi5S6woxNyr+k8Y7iHhO6/yX1Uo7KZYa30V0QRHNBTzLk?=
 =?us-ascii?Q?gcCidSR1Ke9gPD95YkkVrLlmmDb6iSq8RRDL2Q1/LIMRlCcKLPiaDKgG68tO?=
 =?us-ascii?Q?SU1ejq8+a51bkQvZpVdCvW+C4shkTQYYSuacdMqE3URZl8RGUhkx94sW8gei?=
 =?us-ascii?Q?r3l9c4oRclqqJshEMUToeLFf1Kvb5HqbY4pAnCylqKJZim/UIuxjpKhmF3Jo?=
 =?us-ascii?Q?rO0e42Drzfo0zFzcr6aqPqBocIuEh/WWVc03BbP3o+LutGG1HI2MDRX0cFUD?=
 =?us-ascii?Q?wb/KI6r1uyfdtYlcVF8Ljcz35xvfemK2srEgpNhSZ60J9y8ig8a2VwjNu+bA?=
 =?us-ascii?Q?iBQPR1RlO9i5goSjIo/0ueuxxJOQA3U1En0e79H8knJiCsRjysrfw1EIs5Ve?=
 =?us-ascii?Q?CYB62n35LHIc6BqjN4Am94Dw0uWuwjVDJKDW+GEpfTXfHdcm6gG1iyhKVFOr?=
 =?us-ascii?Q?LAEqIzUpFdic63NsdG71NXu4hrQ/Fm9rkIiiWo2dQwgJCJ+YBnNHUvSC1tHB?=
 =?us-ascii?Q?x/A1l/HmJ5+lzRBQvPxQVmPhPwoNmQN2HUZGDFUBRAyVRKPl8vPkYvz1Zkyn?=
 =?us-ascii?Q?+qTq/uEdGFhc7Ezmdibo0ndmUKZZhc3z4GZRSr3BI0J643EwgjN9A4IcK9PW?=
 =?us-ascii?Q?3x/YMyI5QOAe+U7+fBfjNRRMfowTwZ5Qp9FnxUNpaqRJyKweHP8xEji3geg3?=
 =?us-ascii?Q?WWR6G1BFj4ZfS0YHDonnNNjn4vBcaT+BHVbMilyoZPiB8MYTAikmSMf24LIi?=
 =?us-ascii?Q?0mZPcUYe0fftO3q3sbhSaMibcXvNDoDeCGsIdTbD8LOC7IfepGCGqf5wwnRn?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WxqmUylrR/1BTN63wS5vVtG7AuaiohT+kY8W8c46lIc9vMBloPAE0+Yn9a4VjGyKAiE6t3/Bv40AoHFe9LcpVCkJopeqnRmWrNxOwsEnm9vyctD77KzwiqSvDD27fohL53RTaROo2IB4mGT7URutEADnlrckFjtqd0MVPetM3ih2rMJdlMw6Bs13NtTRKRDm1j397THH6tBC60pCD7EZUTjp6ylpUZZ2PuI5NHvoAoKs1EonFLdf4rVPWVwxQ8f3fTnm5ijaRHATqK2JZCEJ8EyKL1LUrZpbri2fH2Gn/HPfTvq5NtZnIr1k7vWWo3gV3/k7CdTxdGywtEKviCp2uP2dDW5tOgbrv++aYkdyYaPXTEdgt0aPBf3ygD2UNkBM7E6iGCHx8l4n3aiZv/N/ZC8/miUAQ3xd+vA4U6ZsgRQy5QJ1z2ry3SJigQBR1YS7bu5UMXwuIXTXRiI/mhsIuMJCovEj9nYPBe03TBrKcND+LnpeZsz9ipJxNpJo8f+Ej5iJFooCYTZKJGrkbDn+s0Xjtx8j1pRqkcNx1vBtrwqo5eVlka3nVQXTJQqMTYSdrXtrHbMWwvQqhwAj39B4v7ZUwi+KqrMW4PHiY8R77X8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae33878d-bdac-4583-d6f2-08dc1ba964d9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:33.6379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtH+Jkd8cHGl0CRdI9rzwrbw/AQGXrXmJ38934jUw2pJ2tnvbOyC6Cx5w25WdqDAATIcJmCrYJbWnZmNg2I5xC69OWJOMbmBCKY3gMAkk0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401230001
X-Proofpoint-GUID: JeL78OmWIaupN2tksW0Mx8h8iB9y6Acc
X-Proofpoint-ORIG-GUID: JeL78OmWIaupN2tksW0Mx8h8iB9y6Acc

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 84 ++++++++++++----------
 1 file changed, 46 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1ac2ae17e8be..f8a09e3eba58 100644
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
-	int rc, err, retry_cnt = RDAC_RETRY_COUNT;
+	int rc, err;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* LUN Not Ready and is in the Process of Becoming Ready */
+		{
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Command Lock contention */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.total_allowed = RDAC_RETRY_COUNT,
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
 	spin_lock(&ctlr->ms_lock);
@@ -548,15 +563,12 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, queueing MODE_SELECT command",
+		(char *)h->ctlr->array_name, h->ctlr->index);
 
 	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
 			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
@@ -570,10 +582,6 @@ static void send_mode_select(struct work_struct *work)
 		err = SCSI_DH_IO;
 	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
 	}
 
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
-- 
2.34.1

