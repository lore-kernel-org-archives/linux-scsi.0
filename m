Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C79EC4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjKNBic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjKNBiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B547CD51
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNshUq017317;
        Tue, 14 Nov 2023 01:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=XOA7xFZx1ya01Iz4GEFW/R6UqCxtQkcq1YDmkKdjcG4=;
 b=o4c1+A9MGA2L2j/2kAekLDeTpfU+67M+BEhBEVzUe1ddTYeUV44UbNDpVVXPYqZXDB02
 TPaRT1R9Ri9tmt6jEvOffxLPSPq4xV5Vmdmo1xuLjJy+4SU89NOUE32HdkdeWHS8UikO
 i6jJG5fPe1vGPFDN74RJOYizB53pc3eVuHe9Z6Gay/3vU+pAu/WxR72cbCtMpbEvuCVz
 6akayHv1sf59nJFP9IWQFu+QS0bDX8H+AZWDt2yX+WsEvpTXKPhMqCpjOPgIQLMalfqd
 9DY3/xf7DdK5zvXFkf0SIw+mftQZI1n3BmL2Wo3E+TWp2FhpTtnJ9zicfFKOOyrEOvKB jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2m2c4gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE13Y5N022706;
        Tue, 14 Nov 2023 01:38:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpxgwq8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NG3MoN1SbWbTsC1r0ie7yrUxjhu2Zp1OWzaknZROkU9d1MDKy5FXXIa/FvzSqGrIKLAvqA0Wj5YZudanJ9biYafRPW9O/T8OykIfSYKdI+2okaVjd4XkWGRR2mGcD1dM67zhqtHt308iV48P0+hVDwO8SQiDoGmKXwBL+xTklfEVzTS8PtacuBoSRX5ZX6mRAG2hlbMLGC4Vf3FE308HD9jQmE5JqMe6gdo+eTdE0h8CAQd+vFRyAz4vKzdfelnogZKKCkd3LDNFGk+RYtuD3G9WVD4zrwGqIjju9YcW0Jm7DomO8nHavotxazHZDZOQrAbW2sJEywEjDL4YI51KQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOA7xFZx1ya01Iz4GEFW/R6UqCxtQkcq1YDmkKdjcG4=;
 b=BiX9ux216/gBzE4KnBi39f2pyJZ3xH5lYGzMhLdf4hTPm8/OHPSimLnt6l6FPInEW9+BuN7u8wdv79aXWduMhyBU6ZGZespOQWVxwvbHjx/Yoly0fj29dBgWetf0s1RZaUQRIh/xT9u5KeJRd043pOCPujOXaX6vZFWFyGqV0mN3K3T4rnpHGjZtVblEA+102ZvcnMk9tWznhElYS/OkuyhAKAIMbsuazPDSS7Imomh4CA/TAnCSyOFcXubzNNrwPOzfhPtVVb7SegaqGsEhV4w7F156a5z23fAMVFd3FAzLh9hP9hOOjCMkd9FEgoHlKN4IN8b8EjF6Uh5+VbvZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOA7xFZx1ya01Iz4GEFW/R6UqCxtQkcq1YDmkKdjcG4=;
 b=eN8cU5iRsdtEJMkqPeYV1Oirckb5VS7wcG6uvV7CIMrArodDIgha/nF7cKETxt2njFEPLMpmWmMm9Nl0yCOl/M5WMZ9a+RPkIqICx1s1DJeefLP8EVEHFO5MKtrk67VYYsQhfRCN2NHd5h7svEDHCQy4jtpOa8SSdA+FyGtZAWs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 12/20] scsi: ch: Have scsi-ml retry ch_do_scsi UAs
Date:   Mon, 13 Nov 2023 19:37:42 -0600
Message-Id: <20231114013750.76609-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0138.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 564cf181-a55a-4709-86ad-08dbe4b25a8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qCbfUyuqI/9RnCxA/WnIImzAgJ7qcS49/DJ7Exnmg0aiNHSySf+LdOiRv1XOUCrrGY1DPLeVixsStbwmNI6GJaIBd+bIOyCJ1Srg+W7TyfACQsAw/VSzm9L2W5ZWdGBZf0CHwZGdB1HEV86CXYyey83ZX5cQ337c5iFZJX/X9vla9IRB8jLPJYH1WHHaZGOYjjihunNvwfrTj+O0gNztnNKE+RUvx2IORkosG5U917/FFsmwnAitMK5iDy5yQSN3fhIGPpviPXOmNJ9SwbfmmpYCqhFv/CgxO1yvjJpQAEX3dGLG0j87ajTFtHOynlWtSE0QVwlDUTuf7IiLmk0JBZhLrHiZgsdyjy9NV7eYw9lJf++GUhub5SMFzCD2t5/W7Zuy6uzSQ7CQQVpWKstlQBxVqLuvXY9ltmQ1yaEOdB1MHR3FByV/R6ZfxVP06hQJVdhLw+GYQD2k9sj46p2pOwy5mEbHw2gy7+dntZY6UlkKS9hGjDxbHmdcRYbYzJm5qOXJSnmTHsAp2T6hRWWo0p+GT/03VWA0DIfMS9Wk576HH5ix/u3qGC9NuoaHudw+PM+/FvlsCcvk/AyEtOYGTQy+xyxP7qDTThTFECr7bwdmjWPQA7lG+lS5jLnGiaDO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oDxlGRwrVfQYlapSojr7mWBSMUvA0OUTKcu/pfdND6+vCo3/3vWfKXOBeDHm?=
 =?us-ascii?Q?hYrLPKg2Kda6ZyuHjl/8URRezqHVpVvpCJj3h1ttNjK7YCTB65FrB5RONzZx?=
 =?us-ascii?Q?QEAzfbXcC7tYu2iX1FUKle6gpFXlfEXZUpEH9Hwb+qldO8du7viYAH0Cx5RE?=
 =?us-ascii?Q?dtEp/r1q6aLc2QYX6QiYUSTsUWSULzZkGb4OKNXd/HK4f8UgJI2OGsM+iEt8?=
 =?us-ascii?Q?cmpBFCkOxAbef6ynGeQeOrXlpXc80kQi1SLrzfjzQ+0gj5XsI8BxsSTk4FQM?=
 =?us-ascii?Q?M2uWOwk/nvokZxxXHbDhplH3zmcsu3tZWuYrqHhLueXKYR2CvLAqlAkJ75SU?=
 =?us-ascii?Q?BGedSdHaqpeUz5xFAbk9iBNP91piUzK1RKPS+eDJ8a/RKKNS/He7rIox7ezW?=
 =?us-ascii?Q?M2W9xpuM6f1BO4tfzeQNmIKltjnLQgw7zzFjSKj8/n22Cj67WdhUv6wPzcVi?=
 =?us-ascii?Q?z6tO0Ssbn1GlfCtS4+mkwx5iUkmqznc07btcPUIlK88q6KZcWQQH36BCgPvb?=
 =?us-ascii?Q?wCWIGzYiK78H5COFKEvnIjtQ5rg37iDoPpH1B/VPAviWVB4jyRiSA/808vNT?=
 =?us-ascii?Q?3i8koUn4QH3Y/n+cGKBRoWR1q89LS0PhH/Sn3I+xOAKmoDVfhhpnWE+Krspu?=
 =?us-ascii?Q?XT4xzYcxKv8tVwFADSMXs4kueqfNdao7eKSNYP/Nsah7vtpgwqvqeN+pFgKD?=
 =?us-ascii?Q?ee6BsOVH67Bj9eLWvoO8BOhr9QbUHNu0lU9xRwbQt3eExVN5I68Ru2iQITLo?=
 =?us-ascii?Q?LoboJX7sGvmIGJWMNeFpINgPHw9aHIvH0s7wuLHEd7MIHUF5tKuIoMOPwbNA?=
 =?us-ascii?Q?VdFd8EwGuo8ERXAOHax9qI/c4El3+IPaeajTgzYr1qJBUmA6vbaZD37/kJPw?=
 =?us-ascii?Q?ZYbX9+wFRKDA80P6jBzX5fFzzf6pPf4XEyDZZIzQLr3yfHdUFlc2J8llnz+5?=
 =?us-ascii?Q?P+0siCNv0WzAjEvWrmW4ogdmQc1tphamDj7/jaGNj69tSAEjBjJsF1h/HXrv?=
 =?us-ascii?Q?Cf+Z6eflOGdLPzvJzKqtP9od12pqbp8XjhEOFBwqBnTm8ZxnpuscJGgMuOai?=
 =?us-ascii?Q?PPtMts0h6iCegCcg5Llb7JT82jzqs3xa46qSPvgEdwQX0TGs+pMihXC7UphW?=
 =?us-ascii?Q?G7lTijVWfq9jhfjGzS4vVNYdNhCo48EyvjMP9CJKgTx+nvtomccWXeTscoVR?=
 =?us-ascii?Q?BynIuGkMIEl64Ni1+rLCqu4tC4v3zmUr4ypzGCS9GOvDBRMfqwzLbtJosEpr?=
 =?us-ascii?Q?13O8FyG7LZKS0PYS748Ml93JPXpDTkyDW8ZQIPvDP9yD+8kRZ99fyojfY66v?=
 =?us-ascii?Q?hgtFnEKVVsQgbO1gph72VYmdFN7TZdAkcL+ix8DOErlY/QxP7RJLo8G8UNLu?=
 =?us-ascii?Q?J4gwU2TfgOmdTHu8nlHvcbJpGK3Yr6GHSXkp8YTFGv5Dg2uMnhtH1OxQENIR?=
 =?us-ascii?Q?8Jm9faUbJoykJN4IRNnSaVKHJosdRGNGzxkpmQ8Yesn8zghY/jdoMKmR2F3g?=
 =?us-ascii?Q?qlH69g81NaxTfS/AVw1gfK+kUnyPk+l4oD6GtdTc9TsfLpT4NMTVRrB704sZ?=
 =?us-ascii?Q?zZ5rU1w1qHs945RWmVJn4bzwQQiLdL0lQ+UB0obZUlO6hbcPbKTvCBcEzdk2?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: c35pwenOaR8spLgYXAWT2WRVUaIOM5tUNdMUPYshY+cPBGMoztWYS5sJ6dxCm0K4bl3B9sQffzKa8j70uGQ3dtWkurYo1cyg0fpwLZCtlMxjpX5IeAsx2eeTIS9fgjCKi2Pk7swH70An83jcGboZpEIJfu3pGuhGHWZkXfGgdmRkvpRXNrAg0zqifXdJOKnRTLNEE1XH0p6uEg8chYo46ztyc+utqehhqrM+TGzEMTyvuc8PrgQ80AUz1BfbPeDAvzW4ZiTahTo5WD8qP17ivPUWps+g6Ump7MtT4axw8Ac6O9eldq8fwtGvyZCzltAwTF4yTMtu4aPWDdoLPNMV03jaCsmbeR25/3A58k7vI4uN8HMKLUE81JvkRyJo9XdZIlSoXAJYfNVmHkY3WFJO/V25rBdTCSrzCQoUMZpd1H7POC7Jf0VLNxDUU7jJ/X63STM9GWhO5F9zz6H1qsb0t7s1KDJH1XqwkGuS4KIKcweM1CxJVVw4SNfrXdCi/ChiRUEpNaqEusVR8hkmIkl5BDySwp5Uzs/ZO2UimTR4qUhEMBM7z7VnembZVF9eBg5fHeqk1PRwudxy0xJHDyzoMPS17VxWMWZYEo8MMKwiN07BqKjBslkvgParGPKH7L+rcdqXfGfUkIK8zxa2zfBJMs0YxS8Ls6K8m6M/DpZCGrPyyVmTNTR5eHmKUH1VBeivLQm9LdPELAPXwvUJxfGi5sfJ9WkVLA+/SiOphvwv2VDjaCHzZ886P438zmnrMkwXVBVgTH78QujOvBs81N2TGbNeEqOweljY1w4UUTMXl215r5mJO7mv4FmeTq7Eb6HEKOKGWiPE/zkDPNCZ9WG+rYltfrqO2vuMT3CmGJoG4khYo4MljnAurbzJit7EicVQ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564cf181-a55a-4709-86ad-08dbe4b25a8b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:07.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1kbVJcX/+MGbHMZcLar6Y9gAnvswxvC2UJ6267qLVbWuGzOU4go3s5tFltN4O78Mh8D9Ji9xMn+8DGIxACgGUTlALUzmo1vp9y1YwrvQT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-GUID: xhGlLF0ISdwqWSC1ci5N6AkRN-EZruRJ
X-Proofpoint-ORIG-GUID: xhGlLF0ISdwqWSC1ci5N6AkRN-EZruRJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 1a998e45978e..4811d15b8fc3 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -185,17 +185,29 @@ static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned int buflength, enum req_op op)
 {
-	int errno, retries = 0, timeout, result;
+	int errno = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
-	errno = 0;
 	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
 				  timeout * HZ, MAX_RETRIES, &exec_args);
 	if (result < 0)
@@ -204,13 +216,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.34.1

