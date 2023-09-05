Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38EECCF9E1
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbjIEXTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbjIEXS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:18:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC03E199
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:18:54 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MZ2nx003202;
        Tue, 5 Sep 2023 23:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=ey8Lqc0DNwnKq3aR9o5Fio9/3nA2sbmc3NWbV0tsOtc=;
 b=xa2VKwOpZt1F0wwJm0RFrvHwBUv4X2tFWUX+f9zbyj1oZJy4QVoD/YHL2P8A9wiOAOPB
 V0iDtdpo4ESJDORCkLqn6lbVK6yMKenFCvitbbE4KAWlj//82YhiMjtT3v53wESDHpHg
 9EsTDMAhRPEUoyS33+wq3Iz1972aSmXyBtSrQdpsjD1Z2UhwOgSQbNn+dGEPTmQx1iFO
 zSBI1aykm5qoU2gRvfAEwPtJyHzSS5fpMN2+agMyuzhCG5GVPXbKkpRHpvtJGdA+XgUF
 eiGcj0HSEcnF4nvKxl6WBoTOrotNBeh1DesBFNZ3FseqzDbpe+bO5mj0Xj86RwXmxc+3 OQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxd8d8209-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MD1JT029122;
        Tue, 5 Sep 2023 23:16:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5dy64-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJFZAGOxjeihz02lZKsmZ+h26Rh/H+D0pnbPWmrhnz2lJwg0aUNEACBHM/xlUvSngBu/4N65478095TcgU8acWSEJx4WCjebPl//mMMXjHdJDh0RWVz6WYgrKw5pA2hj6Goq4/SM1+WB5raaBFIpgm8VyIggCSBT1RcS2Mnm+DQbWePdjVBFEuSjF99b4vpCY4fUj5jC/rAwovL6IpBiSZmHEGzncXK09BSHCZQiVeXOHXJ40HdGwVW7j+MEiEa/gzV0xpqZM2ZfadvcOtUuq4+HiM7ACfte6fi/756pUI6CB8VLJhjw4XKQv83rPDg+whpzeWQANp+5rYi2NzojQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ey8Lqc0DNwnKq3aR9o5Fio9/3nA2sbmc3NWbV0tsOtc=;
 b=Nrue7I5rmaMxhmTtsadlZLlGyezb9yT+MS5ENdjMkmCCnRaa2pv+qnVoJ4L5NSPbjyu1/vRvzsw9kE3MAJrA4qAk1cwWBzTX3R4eIek49A1gzsRRq4lCd5qsSrtmCSkXRX1n/VWdlgXEwKYQYAvJSSg4F3M7hhao2UVMstdeMfTvoK3E4Hej9sg2hl9BVIXTisuI3HTFDmZF0mof5MNY1XmucWhUclClmXiAgmF1LCFJye2JV/TN4FGY+6WIdCUWYNm9BqtuIqYuEDN5iWKTehpgDidJbf/VzUa7F22Tzb7fMbkNs7jrIMWS26CdI39mgyqk/sh0i+dIJSuhSfS7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ey8Lqc0DNwnKq3aR9o5Fio9/3nA2sbmc3NWbV0tsOtc=;
 b=Q54/ml2qINba+lz7XGaBMdx9lNs88SOFtcBHHOPGHoEynbLF567xxMWi95Acc2/Rmc8g3q9DK9+wb0/REnRcYHQPWfVfOBuZ3AivDnicasURQtsh2dGucF4ZnVflylgYqcvWVp8GVd2cjIFYpL1qpV1N5erM0AQSUs2pizOxwWo=
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
Subject: [PATCH v11 29/34] scsi: ufs: Have scsi-ml retry start stop errors
Date:   Tue,  5 Sep 2023 18:15:42 -0500
Message-Id: <20230905231547.83945-30-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:8:2f::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BN0PR10MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: 65d07cc3-27a3-46ac-bc83-08dbae662aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6c5WTOyPth4tNHe8oDL8LGAYFfwB2nNv//SpKFnueprWz2gtr003zJ4dc79C4DsVaBpeEIWMADydjPt/LECPLrCx0i1zSBRQMHdw2CpXxFmN1AiHlHAZOG+sGjbgNlhnqVbuyNgbIaeLJA1HNQmszQoFPitBb2sluKu/JMjuyPUv/agexl4JR5YMbScrNlXMXMxSuwWWRIHpStlE0AC86k+B0xayteXZityRztDkXJZGv0pn3kRA+lQjIaRlZ2ZaeK12BU63OpGZ79RkoHShq9SnWQQq7oq2VwUvKnhCLQi/DP0ynaVRWBtqU7yoZaks/2bh/9pcHNeIm4oC4ABTfdbUYNUFmhHRnlkJnO4hJsQ4WpgJevK8TAHDygsYTUm3f3ZPems8ktSW+eJPQn8ciuHxSrtLiGd4FCMG925E/wxhCD1E8XMbTYuivExuScpL5rl4BjA7GS+9yGh7IdgiANOvJboklwvykl8UKna5bbafxHv7Ik9n9XF72vzSouNlH35TBNn8ZBAPOT8rtiWftAPiqdxgnhHrZOeAXU5W7ry0G1KoWTTmp2ijUp3X5AD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(136003)(39860400002)(376002)(1800799009)(451199024)(186009)(5660300002)(8936002)(41300700001)(66556008)(66476007)(316002)(2906002)(66946007)(478600001)(6512007)(6486002)(6506007)(1076003)(107886003)(2616005)(4326008)(8676002)(26005)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CiBUPvftHaUFqNYA0nQLT+8H9Zk88/ftz1NjFLqRyU9dgulwytkgfNTCkVDn?=
 =?us-ascii?Q?XcAM5TeyZhbkru4z1fvV6Xjdx69eP4z/XGYUqtu6PM6a5e4SANHVNg0xQ4vs?=
 =?us-ascii?Q?k7QjmmxI08S8PhebDwSrDXMEomXmlNhXu+7BqYZamp7lX0taFPVil4uJPEzN?=
 =?us-ascii?Q?hFUk9mzqK9B0eUNHunbH+1frFsBtNm01ImUDy5k+Am2cAdmUzWn+SFsnlkEY?=
 =?us-ascii?Q?MpwkUPeCCA+5dy7Z4YBZ7oJrKnEzlHTi2QzeZYfCsvPDlC6YbSnWiBCtuqbq?=
 =?us-ascii?Q?krakGYSAFRZj5dKuHuitJigsFCNSfsAzv3lYKrjA3fVX+No/jEf+b+WeAGFp?=
 =?us-ascii?Q?y/a7qJwrw1pDw+mGzKIp3PHIxihX4XnFbCMkrdgg4+mz/K3fiyBG2xz6h9rt?=
 =?us-ascii?Q?AYw/J/GmnHBMgMq638jlEet/7tHIWFYxt72jgK3uxP4MVHRbxT6aihtkUpm+?=
 =?us-ascii?Q?hbOA9ggPkncg5l2g36DgSp6V6C65HVoSiMZgSHh8uhDiuWa9QHrbG+3Pj0Km?=
 =?us-ascii?Q?jQVHc4MYL5OoUrfelnAiD557H1bujLTBJvHnLCArN69KguzKAyvlmWWWy4n6?=
 =?us-ascii?Q?R43QJDTqj5yUdxBCVHUlqZyfnINrbslZPMnucYKsR8poQiC6V7+O9S84wXjy?=
 =?us-ascii?Q?QQxeFpEaJZHGd735/m7AkV2h2bywidPYFN4aauq5PX76uBJJv7a4dJ7pgqwx?=
 =?us-ascii?Q?8qIbYa+H8WI+2vUuV3Co4Vd3000auE8Kamjz+gqBTeb5htdJKnoU8KSZ725H?=
 =?us-ascii?Q?k6PMHbJmGH1bvyxhhlEPglWAMqqQ7qMmLGM6/uLdC4ILdTtbynGeFJsXTBYM?=
 =?us-ascii?Q?aEvuX4GmnRqGrcFtWiaiMex2rODZxRbEXxrDzT4yda6QAT2mH9hbphonwprL?=
 =?us-ascii?Q?ijq0JdOwQ7ubC9MLIhB/1XY7zkqne+vW0ZetXWYov8/3BLB+rmepzghrdElz?=
 =?us-ascii?Q?x/Nl3p8jehPDE7AEvQmo1QrJV0QY2YBIiGZJ88oWjuvoymuQECgfq/pPEyB9?=
 =?us-ascii?Q?HE+W8u0QDh49HUTraItlB122Zk1sIkLHdLGdFNuvkmU2s2Pzd9waDC94kDAv?=
 =?us-ascii?Q?AiN18iiZxiYzojzOoQpib1xsqYus97X0nR2ZnYx7RQBFMBtirL3mjO5f3E+I?=
 =?us-ascii?Q?sDo/zieeFcraS/CUumoXBHP63kdkppYy0Ri1+fleWnIQMCBMixBLomU765mf?=
 =?us-ascii?Q?cQyg1MrDAAGfNWQimbcLixy6ckwEZebwAHIDrJXKK/Vj0NUjX3s3pEFCaxac?=
 =?us-ascii?Q?K46pYML/yxqiPQWfEUYIMj2ZG1E+63E7xwMPoF4ejzvD7oDzmuLwA9tiowU2?=
 =?us-ascii?Q?+TtdSRmj82BW7D3j9J/8Qbs2lfvXkk6S4Hm2WYobk3ml4ofw9ICtWp1tH/3Z?=
 =?us-ascii?Q?dtJZ2D+Dyvct93Rmm3JC5uEazIVJiXTNMsKyB5d0gdHE1Z7jA0f7L7XjiBRu?=
 =?us-ascii?Q?Y42ft4o11086c4niGudRMpBYvRskqwtnrWh17PUDIsl6XFicLGoypez3mT35?=
 =?us-ascii?Q?pfP/kbWfCySKpWVUN0vDTmHb8ekiKnBUHzYNtpwQsKC4GV2hboSdcDa9d+EE?=
 =?us-ascii?Q?B/eVfmvVZXpauG2OBt7PJC1qw+MKl915nBi/4OzQFLf1rDqdwiwncix+qDVI?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /zf4Yb6UCknwofKIEcang6vK3deQvxCdT5VY2e5Dp+guAjqGkIM16cHCSM9HISZ8+xmwEiW9FsxgP3yH+fEJTYg4rbv8RlWt9ibXCFNVYJfiUL9env3k529JXzM0iXolBt2zy6NYwzxLsKvo9IH07iyUpAVBJCYnBmtHCq5HqVHXXBv2I9LnLTDMdiBbvJSHX/lVGuVieuCUpn82RqqRFRkFLBCNuod/gVeTlL5W52l62YePEXTLxu2ZhXp6/OXWtjTBkBI2lOGvmCzIH97n0+8iejXExnYqXlKYQfcB9v/JYUplpHoqQudbpmPlDHXKkmL8EhrbDbLMtDbfSoJIakbH54aFnGViUhR0A0viLJI6XQIBTLIUpHZbT3GdajusOSvjEwqxMdFi03c+rnnJdopuw8f56g0oWlIivEdEPyCYbrn9EK3BWZ1M/KIbTNsl0oXKDJ1rad52DQRKd2YPB01fJJbBXZCwMqyLh0Sv9wXSxGXQpDnMCp92vykGQCVgQ91RvbtQ+Zmbr5kA1PBFlhZbD8OYwrq2SN/cxlMVQxTeDKVFd5cmuxfkmnzYb3tavXzGZuk66DQoRjefrq8wtc6iDd91So3ftrs1Q7Zx5GywFpLC5U+nIWHjV+s1dFGxPUtqKIVQeDvn/xtgB2nx+3dsa03xiMAe73B1WH+RCwT5B5AtLF3mqSa/hP7oX5LXYz1+YaVPK0QmaCw83e5TBLBtVppcw0byLYmPJXBR+u4yjahubWjJXM0Psb68T3jcDcgQzQZERN2sw4suiZteF3i5t9IQQ9v0up19B01aKJccLc9fQjAfLzMwVJECBnnE09CK312sEzIhbwsQriEzvU+sxyXvqLD8aSPF/ALvd4xtE1g0U6qgguLNtrzx92O+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d07cc3-27a3-46ac-bc83-08dbae662aaf
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:43.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfTq8oDeZuDwCst435ahp78PUBy761nD+mBhshxR6/Id4OaPINr4WmqQkycuwuGh/GXzhap4WL6ecZQOLPFwmWNGal94H+YnCsuKUry0BZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: fkRX_J8yLoHnw-T0mqhm-uCvEpoiIMMY
X-Proofpoint-ORIG-GUID: fkRX_J8yLoHnw-T0mqhm-uCvEpoiIMMY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..a65b62d11739 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9266,7 +9266,14 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 				     struct scsi_sense_hdr *sshdr)
 {
 	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
 	const struct scsi_exec_args args = {
+		.failures = failures,
 		.sshdr = sshdr,
 		.req_flags = BLK_MQ_REQ_PM,
 		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
@@ -9292,7 +9299,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -9318,15 +9325,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	for (retries = 3; retries > 0; --retries) {
-		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
-		/*
-		 * scsi_execute() only returns a negative value if the request
-		 * queue is dying.
-		 */
-		if (ret <= 0)
-			break;
-	}
+	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.34.1

