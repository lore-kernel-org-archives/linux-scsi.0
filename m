Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21947EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243448AbjFNHWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243412AbjFNHVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE322974
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:42 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k3aR023008;
        Wed, 14 Jun 2023 07:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=R06SqSAgZhjpz3iV682hTJ2K0P66WyKn05n7M6BD4lw=;
 b=xJHq/3usc6ClUWfSUgi7IZoJupyRZ6gBzrEENE83rV6FYE0zmyiGL2TG6Rv5pLWagup6
 usELyzrmnR5WKlAWI/G/KwynjfHOkwbJVnquawdG2AO02Q+VHCBy1FGs86ScFm41KPq8
 gYkuCd0XVFSVhaiWoZpJyNM/2nAc1K5DlWXkSwR6yA+PhiglY3OQ5XCEyZJlYSq6rCqq
 gCldiS2MavAToKd5sWDuu1AW1yAixNbMgARqB2N2kpUxLfZqvuOyVIJGH0Cn+f4z1b16
 xjjIHnURS/BUgYguZKpNoXB637yAmEzNKPuT67iM3QVdWFAZknKF8CaEeLMFP1vwVgYV OQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hqupw86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5n4ve017775;
        Wed, 14 Jun 2023 07:18:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4wsgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYcO1y57QnQZ51yv+KGQ8tDrgPOcKVJKN3rKsRkKRc6A5ObDp3mB+RQUzUUB9Id5ELf504nm/L2s2aek8RA5wtuQKYKH6B2BHN1y/NiX2hsmPOGFryVB85hxfCpSB/k0aeQWDYAAaxrSmbbfgZY/SQGOzuwNMm2GcFvg0kI504aBTFD69s25qN4gFEzr+z4wxxIzjrYzFOvN/EbVvkpU4IL6qjwGHfAetlUL/9zkrNtkVlVrWwzk1avqTZx1woykungxdOR5nnqveKww5fMSKlTANAy8EWM6uZ3mmeUjh0z1HRo2r/2vDulxo8TrvMa3K6FClBOO5vGEvFUyfDte6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R06SqSAgZhjpz3iV682hTJ2K0P66WyKn05n7M6BD4lw=;
 b=Hs3hrml3R89PMG/qyqCTKvmFq6yHEgTsYoZgh3ULRQVE3N6KNVohVDYK4Rk3eeBnZFIJTzWtu5qOiI2P0xWBWoLeehUat9X+G0NAN7ypibmnbxv/DJevkWxQXCJau/ySteedTYyCUd94SKzlmWG/x/UEH6ZAJmAoZgO17FWBCmNuWwU7pYRXqxigy6TU/Ple8BYedTvozv6SIo59+/RubHVwetTc2SxuNHWkBJBmbztMirOHMzlOxvx+5rPJ6M4iVME2DzXGeQ8ruLVybtRFOy1o6BhTkUMxsIno9z+RsezkG4s0Dp5axWSspusx+KhpRWa+HZF2CFryLNnFB2/MGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R06SqSAgZhjpz3iV682hTJ2K0P66WyKn05n7M6BD4lw=;
 b=VmIKoYRsDFEvTg5FpWuoQEzwSZi0dUanAHkuYJ5GV4PLhaQPNL+TW+IZO3ods3UI7ZNN0tDFd0HMlrVOWY/eSEP9pFBPqea8aAT/r7AKiu4GdWn5621xT8GbPv1CwB+vqX9am1yzYHCLV32Fz/w32f0GHaYXxvhm5YuVrLnzjNk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:58 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 21/33] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date:   Wed, 14 Jun 2023 02:17:07 -0500
Message-Id: <20230614071719.6372-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: b4abb300-aebf-49f3-0503-08db6ca77b22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5RY37rd1PP18TvU1jbMNgZTR9hAjLSsAmlohpqenrR5K+bF/9TSLPlry6j2QvMN9RrapHR/0m+cLvCANTeg/TyCfKDPt09/RSkbiZs39XvmjkSGVq49xAAIE4sTAbTLwu7HxrPkOms6JBA7hMa+JMxwgNGmEYk6FIHBkDZ26x+vH91V3OUDmpghQLPmz/Br/W7ayWRu51Ppcyfx0y6VtxOwoZ5WZqsPXnMpJJUnzUvzX8aCRu39nCmnS2Y3AEzP/YSY7yZd3xInPnKJQk8pn3iqKndjMo0r+cZquHGdHXb65mH5Iy7YIewcGMj9jZcpOJyoM1Ut7kbmc0DsUd1soWsgtrakqbO9U4I/hbqj0TQ1EVYYHH4sST+Twv+eEwAKM940GWUDNL36oZVcre0Ydq5r7lSMwsxwfs2zCdUHa1/0T6Mn0b5zMX13sm/BjYzCXSW9UbrRvrUnZPT6BPdea1p0U4t2Iz5HCx0m3U1b8A2XVhPgGNFprGUxS1LLwxjOOUOBFTvEwfaic52dJs19RozLviCIsNVYcJYjPGBMVOhf2O+yY03OpCKeWCYGxiPT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?klckiu1eLACjTSqaUP4xMyETh4IRsmtdmNG+bKxqMWuLW8Lcw/4a6s7bjhrB?=
 =?us-ascii?Q?gVkpYjze1fh41i30fJQdnuyb031hQ24pS/1v4/MCvCTk8xRekVrdq73I4Y65?=
 =?us-ascii?Q?LH+VOsCZXSeJUyAI2fD9L4tEhiPVS+o12A/qDsp8LKvfy9/2oECjZLq9GLmo?=
 =?us-ascii?Q?n2iN0gonrqfv217QG3lQr9LRIsjyfw/j0iN8fdpptcLKPElWtVRXftwDOEk2?=
 =?us-ascii?Q?lcRcPHG5AGhobOR+mtLlviFjqo4lbBNOPRKWLuUZcEKH7pLr0u0BxWgcEjck?=
 =?us-ascii?Q?sh2aQkfTRNqPfBWRW9CaVCjwUUMvcXyzRk29NkbFsQ6ZkUKPAW8XSYY7YTjE?=
 =?us-ascii?Q?efFPAKJWrAKyrTu6hhRPI+UlKe9XzBGdqtk6hO3XfFrOnXBtlavTT5lj9JPj?=
 =?us-ascii?Q?GiK0ae4OylNPCZQZ5wscQxOAe0Qf8VouGJ2ZR17QzVItkCDxmSwQV3+n8Nyz?=
 =?us-ascii?Q?Q/iVzpuMSPBD/naS5gVygTKBeCPbAcAxU/3WY4dwzqpZx86dhA8NKs5Spqli?=
 =?us-ascii?Q?ct+lNhHPjjl4nvRwcg2XbNMz+KpUls/YVyL48IlwWulfbHWHVfZY2mugihAT?=
 =?us-ascii?Q?YPH9qy0hmIQcItIK6oBb1zAT/NoJPY37MPiIQ6PiTJDThHIhXfvWs7sggu+W?=
 =?us-ascii?Q?uMq+1gpWhUg4QONCPPcRUILXADNjKVVn6EOK9OYJDYSRi/V5rnzlejo/szzj?=
 =?us-ascii?Q?1qlHnOABsT9TIRe0pZMh4ENU21tOaBshBO/gw3JQSYvPQ4B/C3CCfSDOZ4p2?=
 =?us-ascii?Q?uVvtOtWLLG0rK3/6eZ+09f0t7e2Ex+5xEh5vJrrxIj0YbwAV9uZcreV5j4+t?=
 =?us-ascii?Q?H7kCynLDhq0OP2ifiUvDmekP/K1mZG09fieJz4e8RBOcr7vFJnQvsYXjJbtT?=
 =?us-ascii?Q?70N6N6G14ZLRmkBvgQxFFH1Ju6aHFgHWGdDbk/t4UUvL7MJ6yOqoqH4LW7SN?=
 =?us-ascii?Q?fUYuJSJqErjAWHeFZ3fRreZWBDDsQJYEs0LBjt3b1lCT2nWuFj/7N9jK0dxg?=
 =?us-ascii?Q?PzPSWCfRNayzxLt5jlXeod2KjtSb0MQatTj9J915vrR52j9gQ9XsH2dmR6bI?=
 =?us-ascii?Q?TC03A0F7ClQn6sEg1HMXa+KyCip130B8cq6dRahQ7o6EIAmBRVvY8MphWcax?=
 =?us-ascii?Q?HGjR9ovYfQfVAna4Ov6Grum11ryklLH792cbcZd7w4YdtzYBJPbbWd4wy1tK?=
 =?us-ascii?Q?GLK97Pw0hh+ri0uJi2uSFW8PTUjZ9rWpXXsLzJjli6WgSsJZ38FnjbMfcXSz?=
 =?us-ascii?Q?O67ilzX7JcICqgSOE2VN6fZbNEghkwy2EnJ0IFnccIqEC3n0FJ9n7bMCKVeS?=
 =?us-ascii?Q?493GtEKXVaWEWxB6ygG9GX1BEaw6iZHCJ/6PLMJimyd7olcb8EQ0UFz2MqUP?=
 =?us-ascii?Q?7SdMlmIBkBnZ1cjpPq9pZ0QiXOxGMHZS9T3UOo1d8S4bjZcsdfm923a4LwBE?=
 =?us-ascii?Q?HjatnZw2YGh0HCCDT6TMizpT2/eOU6s21dQ7HH1MSeiZL9PXCV76WPBBM9lI?=
 =?us-ascii?Q?+RBXHCsWPjDcMau2nHniDZYo95seo8+usXvQjXwfBRFAqPdSpZ8MGLhUDPOd?=
 =?us-ascii?Q?QdviKS2lBgxMa8CEmM1X4hsleDcSsWFg4gVFsT1Nh9HaPZ6QXdPz0YLW0TSa?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pzABAzqh5RJcOkcmTkSkyE66xVhzXARFGAW7+Yh5STmaY81lLVI8sU1b/uDvx9lrZgy7gkEJY8lFqDVjh12UOkaM4sg8UMykMEuPg/RLSy7EXPamQDtNHt+WQDIALoMMqzpfd6a3EQN6X6a/PkUXqg1iIeTZlzkJh7HDZgPL+jO4DTKjOJiULF9Fh2nd6LSNwR8fDW3wk2Uhcjzk/APd4v84NK33n8j1TWJdKKTt+SMfxoeb8enUacl2CZEoUGSg9xj7CHMQN5910H7E1+TZYEWbXAmIRLqzhwjmpC9exlKmClcpfm+JMjzcyDxalEcNOf2tQlZxqG9Rb/ZcUXNSmgw/5Sdc96VJXb+rjUAFHTQcX+3IVYHNfrzuSMGYogDROK3D5BohsjGGwSXVJW8H2snI0I9ASUKIfz0wntdDS720hjveu1qcX3QqwD4lJrGUGM7DaSACnfilWWib0jvC3NAyFvy0cU82qK1RJbJciStNQgmyaAsNXlGzQFHzYi5dnBOasiV09R/HLM8DJG9/qVmozCgo5ySDFnkigR9a6Sv4iHnSNmSCk1sJ4RA8k99vVR8dFVScXpU7s+9NYeLSD02Fqy19GdoN4ygmN/OnbLglgTqoXB/uFxjc0WKwXjZnjqNE9l3S03g3ARgMBkZfq/vUiaQHy8WHY4zalICo6redN5W6E960aMJvfVh8KHjnH3xBdFhvpWkdT+oRkZ1b5PzTpzIKaIkjdwzzJHsc7TigDCRhGTCaAXsf2fCcE6PPAGtQaHOOAvfwY+KlKliExXNUa9LopZZEoudtajnEyUbfAJ9Bk+6MIz/cHAN2EY4KdmMrl4RlsHLLMYg3ImXrmpcXPEp7i9ymMGOfBD57PFJT8feIn5zy98XUskwVuzgm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4abb300-aebf-49f3-0503-08db6ca77b22
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:58.5334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXK4pxIWY8gHG8jMd92qrkV8sTRYra3j162o7kN/cOWx+8ypytAWkWcJJict3cD/tCTBqtxT7fe198Y+kYp4mfxTcb1k9f0ca1UdxXqNrBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: tdBHvF8GDAx5FSR2NCu4bSWBK5ZxOLnF
X-Proofpoint-GUID: tdBHvF8GDAx5FSR2NCu4bSWBK5ZxOLnF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f539fc4b7148..0d28920d088c 100644
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
+		{},
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
2.25.1

