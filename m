Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F436C54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbiI2Czl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiI2CzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E6F40BF8
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:59 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiQTV003456;
        Thu, 29 Sep 2022 02:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XhJrt8QRW53klPP4AIl3L6Kajxn/224DHoLajLXtdtI=;
 b=lzkswePE5PiP39gsCPtrIYOu5LjDR1jBwWQJ2/GGnDL467pnrnN1/5QwI2TzHso84S3z
 R+5g/LwwCv9OngTTTRYPpJ6H9HHMO3joKdrS4M8c4G1eBYdtgbbRC/aXnfwQHH5V7jGR
 BU46Iq0qK7HrIZhN5ummZTdHvVS1WqwMJkHvmgZzSM6j6exGicZhgIojWA+BVy35cZcT
 rw5JGmoW4RUD0LYSS8g3iKPmZR3jZHsIc3dJ6WxbtEBvjrMmbqLK+a5f8/pmExIhDZiF
 9tFNU4KeZ4oEqUqmatU2tPQEzH+Mt1x70Q4hwpua2CKHpeRd5blhbmh9RRHCDKPPlcmU Dg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssrwkjck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SN2DnT039536;
        Thu, 29 Sep 2022 02:54:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcv0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfQemYGThyMMm8qX44IZyirsJWWzFJdfWSSk7HhcluvH7hn4voYD5GnLq+OkRrkdIOP7OSKujNrMqmiKw6WZ7Ov8OhlSJNFDWxIlfj4KaCb+2GhTZDrW4zyEPazhVnT2IwsK27nkZzugdozOGKQD6pcuE2vmaL/If5TAKxakD8NVHeTYmaDJ5s3S2AE0s/J2yBryDpAWEnfYVqYAM0aO6HjXI9InmfIXZo/DP7n4S709yFlMtUWwEq3tgd5IroA+kTxhXpuLxuwCRpiLp1drbqpNNJw2+Wl/PxzYStStdzoIfQ90RPRcto5SvqsKzuCE5jMIPUwT6ikWvtns4DoNuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XhJrt8QRW53klPP4AIl3L6Kajxn/224DHoLajLXtdtI=;
 b=UYuv83v3Vz3GNOSXB342VmTSOyM3MgeHsF/aXZhoDDRA6dBogli0aXOYaTrFRbCu1wLUIgVLosQyf4p+L/QeKjUdQdGo+xrS3SyjBI+Q90JPegL1hnS0EXolO60x5EGVmwfq9SqrTBMpy4xeqEqvJpUfOm33YIWR3hQX1e0OOEPJzPPoSOstLorcfj9fheFrUWOvgGH9LFHiCc1dU9DOGTxWhPskrmAsXtOqiIvXlmixcV8qSOOpHpkj/gbMimMAqL57Nxb9dHrLsfHO5O75CGOBwDDlo+wLlweShZkpSC13QEtuuyLy6ZKEPuSDcSjqjjXqrxeOqvJCVhLu7IH8rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XhJrt8QRW53klPP4AIl3L6Kajxn/224DHoLajLXtdtI=;
 b=Ef5JpYu60k9/sFQOaM7+Lm7fW8CQDZ0BLU2XKsj6XLfJSIruyFedNewKCybpCVsUQkjXP9s55vaS7neRG36Vt+onyp1dmN/su/MkWKVqKJHcRw6I9LJYoTQOeHA2zVej7nYhnkSJ3aGuePPnAnRl/ww0oxK/pgJdt0dXeyK4ddo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:44 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:44 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 21/35] scsi: retry INQUIRY after timeout
Date:   Wed, 28 Sep 2022 21:53:53 -0500
Message-Id: <20220929025407.119804-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:610:5b::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9fba98-0624-4136-2c7c-08daa1c5f663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LvSsY/c8ANkvNnOROKxVqvVFZ8pK1KGWqQIEXofV2Xh5+fmMN6zFo4aSVVcml6n/MHUI/4IUDell5bbcPmR3nRNtMu6twZicEs7+4Lj/sKrLTvWK5irMX9AH3sUA7WL5fxZ7APUtNiWHqAM1+5hDPiBB0oWOWIvd7gYleGIExwmSgb4Hc037laHkYc64slthBxceYDTteN0zA9eir1LRct+ipPgdGhReIrf37nOewA1e+PltRWK/2M4cUDTHKtg4BnJ739BkssK8pfcF6aSgljrRgktYxOqvWMRSHbkCFs4KIMblhtCTXWbLu+eORdNkb615uKbfPNLFUbT6F+ONlki6blaBP10VrYuaNYOCB7LF2ZaFJSp3zi0s0+T6myuYKfbDV2EeGq5jePSGpbLhhaX78ME+glkG52KR4rrbMHx1crmpexECbFDlnKavJaiqkBykEQ//lGSkhswNcAvr/fYv4tJD35DIIFzhJpD2cfmHu2wFiofd8to7bIaRL9zqWr9U7waMfh2jqHyXrvUEhqsk4++G0YA5q4biz6gdpGRENKKUPIb/N5RX1TLEqQX9on/1umBnsgxyaJPp8PnQ7XPnokFc+X9YblTxIDUmZFcU7cw+tYd65VvUeDdpI8B1pzQPuKb+23TFkPzUA+4JS1qWRo6qij0I92czWdW8SMbwKeEQ+VUyvLn599ZjRHyk92G19nIR+5USZHqIMbegJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(4744005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?82LSPY5mEy7t/b67ytIrfgI/obVpADBorSNn1MSbDrgjwvKaz/4n9YabF6HO?=
 =?us-ascii?Q?bXMIzzwrCJVw5dOuR48MdWSzjYC5fMSaMQJKc5LHTDJlSSQT+9gWiObBSL6L?=
 =?us-ascii?Q?WlE4UyUvmvomKU5eCsbQlw5Jcbl2m47wJIh/IHQ8dLAKPntip4F9/87LaudA?=
 =?us-ascii?Q?Vg/0StToCAYNlEZbW9YZwT1JUd01rm7avLU4IUgvhTrYLSOSRQJGF28gvy0N?=
 =?us-ascii?Q?DmUgqtrFMMWpbpVo7EU4FIAgpFjLGwVwPaWls17LaeEo+3EM1FwMaU+s/HXy?=
 =?us-ascii?Q?9N5hWwLQAh1oYR/Vlg1uTCBGPHM6l01JkdAOmTMEcsxCsJGRMav/XOMhi2QK?=
 =?us-ascii?Q?UWx5CME5wM1aSKTJjc6jdl9ADvdVXLvOo09EnPqoMyieAY3gA5dqvlbyWBHE?=
 =?us-ascii?Q?hUleJVKZNVyp4VaHVz6+8aobFdI7bxksoIsQrdebCgCANNrFBrMXvrkj3NOs?=
 =?us-ascii?Q?JP6teIJvz5tBCgng/F8hHqHJuRd/0AXmdnwTh0B5ScWXHjoefBYNYnYRuIAZ?=
 =?us-ascii?Q?FTEuY4gFwDbUWP7NK02PsHdSTO3LQkPwUnD9whq3HKcV8YmoQG2Mo0G/Ag8O?=
 =?us-ascii?Q?rKLW8aBVffYJGG/a7JuUYE1m0FxX7OCTKL/XlzEpg1HmpApWa+PgdqBGgcln?=
 =?us-ascii?Q?V9Agn7bJr5ZStAdFLJaBArj5fhwYpRZZ7EBRrdlxSOpPHgo8DixpMvUouqAC?=
 =?us-ascii?Q?D5sXR5iWRRxfzDTLfwyJRPKNJI5TVMYqwAnKClBW/52p7sSB+ajq1upjhdDP?=
 =?us-ascii?Q?gd3X/+UjQiXiomAhYKIrlcyd2Jrtr18OM/GCqZ89nyl51ZFZbBf6zMdt/wDN?=
 =?us-ascii?Q?Lux5DzSMBP2Bg9Wi7nS23cijO9mkIKHxO28aGvPwxgnKq/M9dNc/PUWybj0s?=
 =?us-ascii?Q?ealzkkIlgf1auFQb4ESspWcj8tu5QkpEMRfWgEXUGQ3Z+cAsIYPq7KeKw3V6?=
 =?us-ascii?Q?CMIsXtOgMm6Re8870o7KRFInZR7hjuuwAIvlDYhCKJboxcVjGCvnFTsHtCxJ?=
 =?us-ascii?Q?w0n4DE5IcUoqqdQ4c05pTygw9ERHn+6aT8g8AE9ve877s/YrZ5RQUbO/CAjV?=
 =?us-ascii?Q?KnXUMV8wMfsYzhWB8jhxQf3g8KNAMlSAcsbE5zFwtLWP28cU411uJhJJEqpc?=
 =?us-ascii?Q?Af4FEM+MqCFfMpKKzgjkdvm5K7p+lkRGaK06OzlHM+QHOspqzmxjlNRA3HYA?=
 =?us-ascii?Q?HnbY3/reuyU9vVNsMLAj2CasfU0/Pkq8Z+W//1dNtdl0+JFjSFG3b8oUjAw0?=
 =?us-ascii?Q?fzxdJG5NiJr258zu3GE07DDgNsPcsrdxLVEHevnSBCuonTSy820IeqmW1HhM?=
 =?us-ascii?Q?Shpsj7zBPbBCpYhCKPF9+VL/uJyeFAKV8BUeGNKbI0TTlAtfYrxwZLRm14md?=
 =?us-ascii?Q?mkKUK8ZWKeHIvtdWPzk1A+TU6zaBi6AygIFzgg7nKE4RyV7rs1yqe9DOscgO?=
 =?us-ascii?Q?CzSewNbeQvfg1OfZ5nyWQTVQxU7ACbGTnht5rdw5UIn6R+aYGlvoJxp8Xs/A?=
 =?us-ascii?Q?KHartJVEIRp9FOSQL4Yk9Ffh5RyUd7WpR54ttdn+K+hf6nHhvLRE1h4FyEni?=
 =?us-ascii?Q?AkLtj2bohbuOyFfgGmxAKXxlCjpVORfyYHZfTjKDGyQd9H0zeha/0Sl4rh6m?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9fba98-0624-4136-2c7c-08daa1c5f663
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:44.2076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfkHAZ0BkKsKSzHnIkqLba8XpWvffm0Gzl9RXKXPKEGdz10fVzvQ8EJifdtXz3sxRBrnpeNzuEHDuo3xW19fT85P4UmF6PHXnMEqxPVy5yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: 8p331qw957gvV4NYnAZVzbR90L3o_w4k
X-Proofpoint-GUID: 8p331qw957gvV4NYnAZVzbR90L3o_w4k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY up to 3 times (in
practice, we never observed more than a single retry),

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 83f33b215e4c..4c2e8d1baf43 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -674,6 +674,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 3,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 
-- 
2.25.1

