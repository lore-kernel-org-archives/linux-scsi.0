Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F683C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKDXZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKDXYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6D419C34
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:24:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj6h5013351;
        Fri, 4 Nov 2022 23:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=h+4cg5VtFjy6LUC5EuUa5b3Vyu9XDBXBZUbYis00cLk=;
 b=mQPll6Jb3mxrsi2Ibb58x2+QiT8Ef444duigA6yvHfQsB5TkUzpCaIpXvakG6gE1YRqE
 Uh20iFrc3AhEEI+xYPwDMCJnjts87QJs1XwG5NyHIMQ/yUXRyMIdymSPfoIvvPN//nhV
 VBMNIqsJH+eXcfBpHz61eEXmqwWDQn4/7eiNPCBGuvr75E9ttaf2FT0o+IGA6GY38YF0
 BmlGHMQE0LCuoIeHo00C16z93FcXJn18Fq7R75dKdQLBV3HatqzUd1SzMWOY4IGWy0oT
 iIZvWmlE7JL5X9/NNE0TI28XvcgAgtN6k1yNYLazaMrV9sJ82Bu8MvbUE+/iJi+YvpkW 5w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4MUQ5C029964;
        Fri, 4 Nov 2022 23:22:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a9dq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYKnLn+MAvAQDi1nGPPDXubXIzFuRDI0NQI9MpnHKY5W6QDg8wHCRQx0+LIyRot2CpFeVwqBN14YJUSZWz9c2lyv72/7KQXKj4RSLSqv8egPqwykuJwJNffpRtYkbXhmZZKj+3oa2Pm+AJOHNlISM79+A0XjPZhevjuLOVWqcg5UpkU5yrQwDRe2MzrGi/J09gIsAhxfcCmm2lZlQZXIsgQTOflnRwjoBXvRIpAmhzd494EYF2PiOb/DmZXWvKw7ELtym4MH/6Q71UK+LZTs6ZjIbszG9j9GLu6WnduRcqz/Mqx1iaWkjAzUUr3KHN8ll2+kaF3I2BceTB9nTQ1nFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+4cg5VtFjy6LUC5EuUa5b3Vyu9XDBXBZUbYis00cLk=;
 b=WtrvicG1+ZA8wy7VmPcvNEDkX0fUBsPaqMvJJSXudDT8LbrxywOwe481LEpeXvBZRDt2VoqBXeAAJMhHflytBRlDvOsYoAdjevuZAJCGqipk6xmkr75TGu3ZwSwTFJU/Sm32pcyCq5OZq5zR2AWXcoaufoz7BJ9Wxe+DeORXbTA+e5t+TfIf/Zq0Sv9Bd74nJbLZY0iPLaFclKTuEGZVPRgsPUegcD76pK09nVcz2HMu3U41UIDtKwJlcYCoX6mLWtLsNsDsfPJiUlLwrFUYvKgNGbWminAXgpaMyKQxifyevYLh6hv/kOtkbmChoJVslSckQBqcoQ4yJ8YFf9XyrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+4cg5VtFjy6LUC5EuUa5b3Vyu9XDBXBZUbYis00cLk=;
 b=uP/98zEl2gVyT2VdvL0mK9mNkLraQcYbmyqMp+Hmgu7jp23yOeFu7OS1ZfEU21d9l1Pb1QkJuwOOwln1TkKfKNG7cedDcbrrCP0Mgqc2iL+KZNe1KRgtI657mTeCgHyvlasdWu/7cDsrEsagWkD7Mq1lMfHK07rLqdxy2fm7lRg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Fri, 4 Nov 2022 23:22:25 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 28/35] scsi: Have scsi-ml retry scsi_mode_sense errors
Date:   Fri,  4 Nov 2022 18:19:20 -0500
Message-Id: <20221104231927.9613-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: ea9aa786-cecb-4902-bc42-08dabebb6827
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ljwFXwn9/+KVX5LxkBCDHl999anKxj+A41uzUYXMgX7dzQMGG22XLy+Ps0/ntI5fairj/cuZQ676btZDuNMosXHpUfqPUEiBTOxUkpCyrs/PJjHu1IKu6jGKPvf2n4okS48lmuSBkxjy1sicJPFLqm1hWSSMSXEPU0Xu/wlhjFZ+I4rKicMfLSGVmKcfJU5z49bCwJohF1OJQDGtQwxI9Fx3Mn6o9fCbF11F6en5IbD/TtLXlg80VMVJq4MBXIkLzQ9y5934bWJiAt2j1jnpHZ9CiGmP4DGjWAGnGmAnG7GPFt6mBrdfhpJj/NUkJSO7XqkmZaAKojcc7eKbpQF8AcNg2sHO/cloX7tKsuS1KO+/JZwexSSK+wBVopL1PiZ6Lp9zA8EfHFhMwU97/vHWrBEEtkAk93TXDtTok22doiCRbQ6nisYMcClPKze+OiqMH2v5BM51ETbfhw1gG9886lxZfa0D5G9JOSGTeC9VsLn3beJxholj09UdBe94nFrgRIB4uDOggI1DFZojrZcqXKVVkDc+OxI4v96eSNb76cXMtyBGSR38Jdq0V4wbNv2A5Sn13+Zlegi5NzZmrHjgopHmYuWGodrMn5liEIQrBtU9U86ng6UkUrF5fyAKrcHknjdYHBUKzeVIs42tW9uGLCG4t4/eDAyjdHDQNo3DsvD5Xg78foieMAlDOFDvM7qLwbrs35HYFlIDVWFLQLuFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(83380400001)(8936002)(41300700001)(5660300002)(6486002)(6666004)(86362001)(478600001)(107886003)(8676002)(36756003)(186003)(1076003)(2616005)(4326008)(6512007)(26005)(6506007)(316002)(2906002)(66946007)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sXG/846wdnfyeta9Bjw7z1afiNC2nNqiyui+hdF6Iy2liZqMpSMviRb8IVSf?=
 =?us-ascii?Q?VhYiY5lk5b+5UMzrePdYB1h0qPatxMw6yXOBiDR6ixnRyb8EcUSsDvPrHX8x?=
 =?us-ascii?Q?s6EE5PsnHlRp48uR456R3M/zMvR0KeYM4iyBWSSRfQRrIoRHxOxq9cF9wWJw?=
 =?us-ascii?Q?pBMpH7k+SVe1nGBS6dTXVf2QcYtuxvnk0TsNzqj30fKaBL0hWXjAE9CfUl1W?=
 =?us-ascii?Q?eRcVHCw7StmL1Aj+Xy/BXNXFRbOeCb+RpfoJRchtmWqLl9VUHZt9yeIcZ+96?=
 =?us-ascii?Q?ey8GMoin0es2xJmv/gGJzI0zMK46FJxWeaTZ3jlRQui2/H5ALYBdcgVf4QAQ?=
 =?us-ascii?Q?VK8EmIsRrcsC97xyHIYuRY8MHpyb+DnJtBROASgI7FJcoDXJ0KAlqAOMSm2G?=
 =?us-ascii?Q?fpNrp2b7OtlG2C63JJYZ1vXIpoMzWSNrt6sv78G51vYTBi0PoKdKnn1Uz2bk?=
 =?us-ascii?Q?gEiNVErTALy5J8QCoZIE3Pl41OVF2tvQWXuIlruTEjBg+YxLpW7DQui2hlO6?=
 =?us-ascii?Q?fS+RbVFryvqZeOPuSwtR1xupFOjbt9CANJGlLRwok/UEdKGV8lruqeP/dV1n?=
 =?us-ascii?Q?sjUDv1UAkjN5NTLeyYJFrBUDjBc7GD5UMPQXQFPu3vDuk9AMNdQ/JpiczMZs?=
 =?us-ascii?Q?inU/+oW3RHrxJZ5xWvbK+l2a3ufW6HdTDWe8J6GeXs7x7yEa3kNPrH3jpovk?=
 =?us-ascii?Q?OjuyHxa6rfQTONOadTse5ysvrUdGmYbIggysmcJON/ZbEO2Z+MCRVnb5Zsl3?=
 =?us-ascii?Q?p4UdzjS5Pt1iMoM/hY8ZvD0eANc1iA5Fi74RBwUL2q+frRS6NjM6/ab7nhIV?=
 =?us-ascii?Q?dlaSUrzIZ02sKC5eXnQzi5838+DW/NqlcY3hH5OTThd+SzP6NGr6XZzoEiMO?=
 =?us-ascii?Q?0KGVRcS1uskB8Zh+PJeKmWajme0Evimx26IYAIWUftKOGdRdqiU6CQQkJciY?=
 =?us-ascii?Q?KfKMCBRQw/VP5fRvPHJidbnYZSs7LsEqoxiJv7CwFW5BfdKcuD6B4e0/DBcS?=
 =?us-ascii?Q?n6DTuuT/YahwvZp6JcHyUfzHP4Ch4ejNwzjGGWTvXaI3BRcEf51hh7j3I8Y9?=
 =?us-ascii?Q?qn7xJRViJ79V5GyKq3PWHRzlrku2VmoeyBzZeLQU6O32dSCTygAFJvJCZqbS?=
 =?us-ascii?Q?84yEu+GyERdeP5HzfSBXlZGjHoag9sqN4Ha1D/5o3zOCV8MEt0l/MBGWYYOx?=
 =?us-ascii?Q?t7syMSDf60KUBVEJVZA8qAS7t2TRlAUsGz3keOG4Kr7wnnDBekVKtl/Qj6ro?=
 =?us-ascii?Q?QV/QhgZ7pDRnX9F3k4/L8JRhrGdPzwRDDteXIcjY4YuXRUwZ3mmiFA9vaqzY?=
 =?us-ascii?Q?M68lr0ziCRIduvK1YaJmLOKak8OwSqUhqE/EZhyhpQ9/pbNKSHWFiQK4qzaB?=
 =?us-ascii?Q?HSHQ2w6Qy05wqFDoZOMcg4Vaz4NEn6oOtwUmqIeThZDyrGKJsiNTAESESJB0?=
 =?us-ascii?Q?K9nglDAxMPUvaGtVGk926XeB3caf49K6LT6hm8JkiEwQxThAuoMe8N1E8fGo?=
 =?us-ascii?Q?4o0nCaGkA9bSrjG+mpM1DX3Guq7FIcxtWjkngdiz7u0cTh9Qm7tZTQSdVF5d?=
 =?us-ascii?Q?V+92Fy61HvGh30Wak3TKthN7k/WaETElKd4VzOUe9c6Luok4wcryk6pBq74d?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9aa786-cecb-4902-bc42-08dabebb6827
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:22:14.3192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXo39E+Ec4T3M8tqMWAcuCl3merOhLUCr5WbkFq1QPopPLBH+IzB0uGUejIiTE13rq1WX94PzRogF6DIIPhmFyRilHDa4PILyrXgYjomJFU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: oXBUn0P0gVaLtFNeCuz20uBkyXxpBb-S
X-Proofpoint-GUID: oXBUn0P0gVaLtFNeCuz20uBkyXxpBb-S
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8b2a9388420c..623e53fe9a84 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2160,8 +2160,18 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
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
+		{},
+	};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2203,7 +2213,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 					.buf_len = len,
 					.sshdr = sshdr,
 					.timeout = timeout,
-					.retries = retries }));
+					.retries = retries,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 
@@ -2230,12 +2241,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
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
2.25.1

