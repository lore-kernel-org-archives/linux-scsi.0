Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DA5C04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiI2DGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiI2DF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:05:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B137C7F258
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:05:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiRPg003466;
        Thu, 29 Sep 2022 03:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nzQ4DsWrbIepq9gHhkDIp/sm9Okg31VE91zu/E6WMeA=;
 b=s2xxYE2VV0YDk2uaOjm2aN3GdLs+Q/0bleGMYP0oWvdgWd/2M/zIbBZkbBw6hnVtQJXV
 fXfCYHd4595EGnpfPQ79ra+hRn4AL2IvLKOemFyoTe2WiSvE2vx6A35jgc8viABXxeoU
 +yfN/mOT3Sul3DPvZkEZrxw1wM4vqy37i/IbFGweBY7W/lSp3Y9OrivahbIjtGLFAXHn
 4BtiwuWWNNhNa8s17r0QdBTYUxjcqWxuZZZ3gmCoQUmUN7952xE8BhbjYzjKRquGglAR
 fTqo/N+u9GLi5KUtDnnaDsB2uRVZtFeWeRVVuVizCcEz7D9559Foc0cU2cHgP5gAglfu ew== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:05:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T2e3x4033544;
        Thu, 29 Sep 2022 02:54:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22qsr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcsBG6PoJWbw2lJ4SKI+CoVAU5bQID9WUxQjvj4v+fLaiVmcThOWz/LcDapSReWy2I1tY7tkpYcCoxp+dh9gh1ThWJvo8UQhUyVSBdRdQvFgVUR9YSEBO8sGQs6HQllem+kzHHZmR2m7dN0RVLJkMZM0J/1jIU/tTNF9Lb7trqCViW+nPH3v3ZAb63Goo6qZuPTLY3pX9V5QECy42lIDLnAyjsm/p5StvoUzV8YaXrw1JMWBoO18Mh7pkGperqTphEZTAJbDhq1YoRM4Nkv56w6XRpHJb4V77JYU9jq9k56P3ADPV/iHMnXFQyNLcQ5ETZpYa0YIEr6kp+EZL5qqzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzQ4DsWrbIepq9gHhkDIp/sm9Okg31VE91zu/E6WMeA=;
 b=PjfM+ePuFeF57NwM/0engl5hKMY787NQrssW4oh4SHrNWegN7Pu/6F/62zSNNYE/4Qqr1WJrVUvzECPQqxXhY41Ca+689V7oHAvm9QZtY+0N1LGLFp0sqVMLQ4xLER2aSmFlKJ8xks3kKBAKLCxISCEU6tba9yA/TzHshc4tCnqi28ROuq6jEyhzM5FFofmfJGuQx/GzBbrf7xEnh8wHuRD8OGYFrHkA9TBgSjyx40VZ4VXQWWFScn5y27TonamCWduuyNwYodq2TPfxaSpDMBp3kovlL2uRwjBOuhna/CtcCQtyfK9hfXkj2WccQezGgA7oiDh52GbVj/YlHYW4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzQ4DsWrbIepq9gHhkDIp/sm9Okg31VE91zu/E6WMeA=;
 b=JIyKnI7epBa3acPxRJN5xfTvqFJGCwtBWld/bNh95q2+3za8C+Y8X7KFQpIgRhd3VvFJrp2ujANyBSFnX4EmXL1RXnyw0OigZEmnLEM1fFjUoH9Y6OswLbI59k4C6dfCxBf7JBfDxc1iVLGyhzXVXGaAZWTPvcV+9mpEm2gzq3c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 12/35] scsi: zbc: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:44 -0500
Message-Id: <20220929025407.119804-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:610:4f::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: d05b9ae0-f198-4a44-dd3f-08daa1c5eeaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxC632Dj2e9UKteXFpkf5DGk6znzcctSwYpcatA+exeEYA2e6WpDoZ1ZQ5UTIwl4ZW8P7vyXzQnIBHA+kdUfb1LzkbPl9vpZOOiuPBPauNmZ5qptXuS7ro4oSScT9GhyvRJge+lA5xWotj7cCWr9wGTKmuZHVnC0UAVbEkWZhEHSIniG3VpCvkYzgjIYI1VZFgTxwB5ucL/s3c8v/nzScVO7yaSY8wNAhg7Vj0jutr+0qmBRpWin20fxfNOJJuD+1dYO2Agn0lzxcEY7sb/I8jDTUHHWwu4tWlarF1kI+siOgKJvb5NIAEL14Vc8MgvSL77DEoAE09OED/YZF54I0Eg8U+6Q2qGTCQ8oestO5l9v5Rt8XMf2vL1/Imx+TwnCd9x6oWwHdZT3IVeDLB/Ou0HiNqss5GkvW4cT+UCyOGlPB0GSUoMfp9e2BH7uk5jMZ4n23iiuUYtTpqw3xHym0VoFiBWDQnRQCab8m2JOt9ShltEqZtiH58UDNXx7+h34HlYcoptZjEi4GtoiAUvJrUzz7iQytI8vndmaEQSUWefCuu/rEM2fUdMxjywvuT48RKK99tv0/APH7C+N8gHlP+klMF86hILaLoXhJa8fT3lbN+cZxj5l/9kYu8Yyh+o16y2t+3+4Mlyf0+tEbptHMcJltOaga/1zH5CRVgg2s9b79ritdJ3q06xv0XegR/g8DtzQi81uZE2URc3odqxSyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(4744005)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s1wzQDj+LCp0l0fBoYwHR+XhPf9QKmT2ff2/8CY2xeIJLmyt/TQlIHf9zRXe?=
 =?us-ascii?Q?x5b5DCbTzQ5L2ZtOzeebUZVOpuLcGODqnXYN+ifBVzbl/G8gDG3KgXQWzJHq?=
 =?us-ascii?Q?IbQyY/7GwwDA51ZLtuL6XmfdgY8aRpt4eq3L6wETAXULofYd8pTJndR8Cknx?=
 =?us-ascii?Q?c+xX9zgBW1EDEJPUl9wwjdRht/LH29MUS2knF9MijS3Mq12QsgjAGH/EoHPZ?=
 =?us-ascii?Q?6Eo0FP/SsGWPcQjXIKH+HuqU4ANvXkC+kFAIhBUQbH5uOwgAuIYzgpJ1F2Rt?=
 =?us-ascii?Q?q4fuzbDLO9A818hFtDn9e5hsU66ejNrsayHRKBQsG5pcVUPdYPLrCiA3hd0v?=
 =?us-ascii?Q?v03DdQ1dt9l7cyhPfxUfw9tnQzl8z69QONmiYGz/TpWuX9Zmxg/m43d2nBeZ?=
 =?us-ascii?Q?/0QEUJxdEg6YXVyH4AxX2PN/8FV/Sn7bI6D0viwoEhCJC3bpON9XxXRbwG9r?=
 =?us-ascii?Q?ZMFT5H4S4qfqVWaiP/cj06sy7QIG/T4XIQi8DfP26ZzE8kBfeS3Q3GrsmOnk?=
 =?us-ascii?Q?RZ2wxaoqbo+5Nzuf7s2oU4tffc4Z3OEGt8fKm7ZZUTP1xNfrccw/IivUoUDB?=
 =?us-ascii?Q?qD+/9QCROVuBIfBvEQouAgRGlOv9U1jeu/Xv1n9TEuGoAoqJzACEatYTX5a+?=
 =?us-ascii?Q?nwCUaaPatjQbxFq7dGl1E/VG8MH9PI0LxAwGxC8rgz7WBTqs0ORyBEuHE8Ci?=
 =?us-ascii?Q?JBpaxKpObJ4N+mKv1A1enIEI3luAs4ZV69jaol78wbs0KPdbITiBXy49pS4d?=
 =?us-ascii?Q?daV0RhIOqFBAj5WC/JTTdyw8JLtmCr58W1sQ2YvMlXDujGJ5NQXXlWlF65O2?=
 =?us-ascii?Q?HgQHir1K1sL2dpKbeujjvqF1T4bMoMRE7n9iuL6HYdmjxSnaKMhuyfrAsV0K?=
 =?us-ascii?Q?cXS/y0vF+zLtLRf0W4lk0wKlDLVMGeamSOf4UcZobRFc40AzYh1Gr5l9DGeu?=
 =?us-ascii?Q?Q4TAiomTJtF5c64aP1wXQW50frF66P8WCb7qRWvJDiWwqeHVoGUVaZVUU6Kg?=
 =?us-ascii?Q?I21stx99rxeK5cqfsPsZhYMQKNuBqEBRg4mIk9bDRYKGakqxPQhLcBEKSgst?=
 =?us-ascii?Q?IDLJiA98eX3pKYQWNhdgV0PuerrvU1D/utXMl0r9HE990Rvgmh+qPhCp6GIe?=
 =?us-ascii?Q?a+Chvok8FDM863WYgOFR8Y9fDZagvrvHQ2O6wMpEDmzfBqXrz+FvFUJcoMfz?=
 =?us-ascii?Q?2+TJwQLF2akrD0qZPWPmf43q8s2Ad5+p8sWee9fToUxM4t65BwEIS9UGbNzr?=
 =?us-ascii?Q?v2yVzR1jWJHDx3EADnkTeTECfjVt7Hx76Q+0J4mpYLaxvjAbt0s5e/Rzumob?=
 =?us-ascii?Q?oddRHtTqM6oQXFQBxEIYO032A1KEg4w9yP9q7QN2fvIv2GQVRMfei8KgWxW+?=
 =?us-ascii?Q?y0T+ItMkHO8Fa9aiYcTO6pqUWZt/roKjRhoiag0WFdZSvn1WITBjGYku8nfr?=
 =?us-ascii?Q?tbFjDEcJUdskU9l9fRDXOHUhS4ikoMWuloxke+kKmzquMmJ0fq3WxSc4cNLV?=
 =?us-ascii?Q?MK+C9bXZne1mgbZH0sOksFSP5yU40rAcT3eTic5y3e1zIlEvNQ6Jk2ube5AQ?=
 =?us-ascii?Q?Eu1yFH5j/FWttPfvFRHFO9CFtcb35heEQ0r/em2HE4ESWXPu7NLER/lwnHiq?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05b9ae0-f198-4a44-dd3f-08daa1c5eeaa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:31.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tuUZE/WjdVAGtDOC0G+2TManEOwcCFYVVNNGmZy7pIrUGI41F1LTj7ycR98iJNGRn/tf7rReVzsSPYUryEvW46Wx1GRZCldzVcGFgfDmSQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: Ji4wEGNKBbxcI-e5fJROZJCbNKUjy5A1
X-Proofpoint-GUID: Ji4wEGNKBbxcI-e5fJROZJCbNKUjy5A1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd_zbc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..d87884a19a51 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -157,9 +157,15 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = buflen,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = SD_MAX_RETRIES }));
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

