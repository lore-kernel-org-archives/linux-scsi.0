Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF69EC4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjKNBiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjKNBiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD758D43
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:13 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNs3WO030141;
        Tue, 14 Nov 2023 01:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=RCKG0uvaQzRhSuPQuc5BgmOb35G2HSzqbGYFgdbngk8=;
 b=vX6lsIrczCx+kjqo8wkruljPoBqOD3FXBXGxrP7Omf7m1XxU8eHDmZbSdPmxkaU5gqi5
 9mv495Z8RRrBfPYOhU3oEER2PLuluGML3DA4q0hzIAMSYWvik0SMkkFjxZmWliTq2mBE
 8Gs807LXsLcwu8BCH6+CtLlwLrwZ2dmFBvlnk0tHPgWLkXx9QgtVw+sXF0jIxAdllSx+
 5H8b74k6n6ErzOAI5Mg+YRv0mIFCe0xr1xJly/KXZoC/00JZAexWpRHoRtaYDIxOcHbb
 wIi+9rG4gqiFR9L6TTq35Jt8Ycz6P+ZOg9Sb5xDfr6k0mFRVggd8HliKVwjZxMII9GEp Mw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n9v56u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0FDJt004532;
        Tue, 14 Nov 2023 01:38:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ub5k2j1j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe4sMCAyYud+4VWjXNK6kZzZnkR3X717xeFjhQQvWowp/gQkf91ckikQzY7E8CQa1yqQNKpp6oKQXaWkMojLvLAa+zC34cKP0Anbj17g1HqbfyUTk41wmTyMFVPJPrwcAFGK8ZjgO4R1Y8OAf/nmtLTo48tfBUCGrETopSVG94tXddUUZjiYS88aV2n7po/L8p+xPCdx1BgmhBHJdEj+gx4/iEekUdfJytePXFep9js/NrcPndjlTgIp3SM2BLyDxEJWB0SV5Vv3kTKOHXV/OYAjlVyOe7Y2LDZ1Ww65NzGT3ZM3aUYuYMp0G48VPWWK3HvQPNlpCSpBRxBR6pZSMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCKG0uvaQzRhSuPQuc5BgmOb35G2HSzqbGYFgdbngk8=;
 b=m5U4HZJWU19hjyIDuMQ2SUVc5/hJ/ie+OBrb9339W8xTQr74IR850FL1YRMn2x4cxr7Glc4TVdY45x78S5ADj//wM5+Ng4WnS8OAuqeKGcKzXXMPSCd8eweWxFUTZBaOzc7mMcPxg7gDPOGT7SHQM+DrsU/VV9l21okKDYfYfXNcczFL66pLiPvIXgf2yP+uc0kJE8Wx/TkKi21FcHoVQFCHb7v0uB3F31va2T5sld2oz+XsaB5ouRWxEZhLe5DziALcHNIbRsGla+OKMS7dv4lxAMW2q2iXU3X+VuOrrgfqVo/QDe7uF7ZaNLVj8STNZcpKPBZS+OHrgpbw48jQFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCKG0uvaQzRhSuPQuc5BgmOb35G2HSzqbGYFgdbngk8=;
 b=cthaLAh4HY9V6Fw2Ve8CydZf+/ldh4HWu4huUjfw3Y5+4V+dRUJPXT57kbu7aiiMRys1iXKTbQIeV2La3CJ3nr79Uh828MPSuczz+mrtWraZ+LkXhEQLooC0BICiJ68IS1Ep4Ndmyw3NdF9mv/Igmcp1N6tK8whO2NEo8RPSRFo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 10/20] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Mon, 13 Nov 2023 19:37:40 -0600
Message-Id: <20231114013750.76609-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 570d1fed-36a3-42ea-ef35-08dbe4b25919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOSGsdia72mEQWqEoqCjuk4phyCsPWMF7YU4WPGGzhdCzcJudUH3S+rW6e4eJOMZimTG25ZNN+dgNvFxwnWBvYWdZsCwdB6562vW7zstzfxA4aupvkYSKgROAMRg01hRDQREKIqTbV5N9dhvV8X6Ise8I7YuNB42YoD12ZScCymqPGkv8N6VEGv1bavz8mUWbquIJDxO9a5bx1nF1KQ7GzTz0ecS9SyzjEYHMmy1Xt1VSnr6mhahCJNMp9NtXbqTgpfSfgs5WrBtwRUSOYe5ddtn+Myw+YM42qBrx4YZ1BH3/giQIF8BFyMEx1SmsAkiP9pb42yPMyhyiERjTh5EGBPpW7ZT9P/RI6rfyBVx0lWVf1Jr37E/7OLuoagpSOHX8ecavZN2O5oWL88wEWSt2XsfbhYVyhAZNfbsxjKZKuPn+CykPbUufEMULDcyRX6zvtcm02Zhbua4aJcMchRFcPLQe7+feOScJPh0HKZTj2woqlGRboJg9gQs3k29buIpTrk7Si7gopXCNYhC7uGdIMOvRaKOxUt4JIiTDRdU5wap1mILGbp6vj33MCKsipBd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+d3W6vWgftmLCZr2f++Uo7LMoBRzYdkT3TFKzrjKT2Qn1+WptRbhwhSvwDbt?=
 =?us-ascii?Q?xTw3ly1ADQxgHdfq618YkTiVfjq+IAbDp6t0RskuF3jQiW2OpTPpD0vxb0ER?=
 =?us-ascii?Q?CWznGDAZSMexGp5cMCqlrvng/q62pW3CYFtE0jcZlPhC8iMpq3EuCRN9jYjs?=
 =?us-ascii?Q?QIhBjfzfg5bwbZMhxB2qwWX3iGsk90iV4PXaOnYuVPj+TtcKBLoVymKjcS4d?=
 =?us-ascii?Q?SqsofkMSoTVRDbhmi06SVmB0w7tii/6NqYjLhd8RYU7Li4Qb0NBiRsRCKMqD?=
 =?us-ascii?Q?P3bwUMI/44zrmgv+fui+6C26vXGnJ/RezTxNG1O6UI8skGP83WCvYirNJ8yE?=
 =?us-ascii?Q?BrWRShVW4E2DXhVJvEBOJbNQg4gd5O7YOcWOJOSVtByG7j3RYRpFNfVG2ss2?=
 =?us-ascii?Q?od+PbBXY4p2sPjNHBRyn5gCeYewsoLI9kPFOloX7eqxnGBnUhEh+9z82Ib5g?=
 =?us-ascii?Q?7G0LINTcNnNf/RpRoLp7iB5bZBl4hhhKvqwVMX6Zw4kJL0hlTCYQdCRx3MAT?=
 =?us-ascii?Q?nXsWGzNc/u8GnM04B8JGDQFhcCojnW4SNvWVEseW17oReoHzw9ArExQMOwKV?=
 =?us-ascii?Q?k71MhdIXYi/s2g3//arka9i6O/3aHO+r1yhxOQMm3iQqD1bWMxUn2M3SNA1W?=
 =?us-ascii?Q?f75Il0kX4rHWLkoQ+KIvNCe+Yi7sq1fU/h8iYzBRFVHTN/E6gfbP5Pl21DXB?=
 =?us-ascii?Q?genKXKI1tMunnubQ6Ne/2xTRwYf6N1FhZ32HcE1WOsXy4zE+2n9gwrgEtQxs?=
 =?us-ascii?Q?960gcjYCOURjfL/yDScDmmvSlBwxdXli20DXivaL/2Nui/pg58HzqqaI9Flf?=
 =?us-ascii?Q?Z7fnPOnW1GHUEYe8SnLgeSX86YvBAfvQK5ooLCBFF31kT9ho2vUEPh/rQgvg?=
 =?us-ascii?Q?Rfd9vFhKeNHVCH28UWKCYqAvzrVvw2n0LeAP3L6kh2sYkXgpDP3CPtyQndJS?=
 =?us-ascii?Q?tvgfNG+cN2TPHsHsTR3xAz4IW2mCngoNSQjeKOzJ4uaYeVTsHcM1g6lPYjqU?=
 =?us-ascii?Q?0yvxx5ut2ECBXLq8byWIERN+P1GJMtbYSpcHW9/VPMYdk0p0C1+4tn10s0JN?=
 =?us-ascii?Q?BUgxjN+vo8DUfsBkoVIxBECoF/4Sy/n6U4VWNrvLjVaOgKqKt5wlaIUIyVcx?=
 =?us-ascii?Q?EDjlPOKOtFq2Va/o0MVRjVG3PouK3mc3DHyMGn4vZKacDXnV4YuKs7cMN8Lx?=
 =?us-ascii?Q?tQ4TvEuxBBTG0bhe6n2Ov/B1EmbPza1hAZ1VYmKx/gAq2gOJfgWXRj25QZPH?=
 =?us-ascii?Q?eZIi86E5Fz/E3qsw1LWJAqRmvOK+rCUIX/w+v8cbNJt+d+w3NLOI7MafSUlW?=
 =?us-ascii?Q?8MUAhWqGW4bE15ZfGVnr4xuxy5jy7JyTB74SYIRpg6nBjizgzpMO2L/f/HsW?=
 =?us-ascii?Q?S6wo2pjXn46L6X7/PB18VTekx6KlxgoDmUODxpgq9jfuyVfYy9FXVpy8v//O?=
 =?us-ascii?Q?o9FXEmywJZ2qvZeuZXNOQbfNOk8HIFMQ9y7lBq0vR6mnIQPU0EJ4wDCpSTfn?=
 =?us-ascii?Q?y7pGS7vnyi2BK6N0RlkRsNl7A2EBa23LZe040CiuQ8HHzKa+hfGStHKRbpL4?=
 =?us-ascii?Q?eHUfZgNBjsGZgg8MxV2ccF0ssow/uaI6ByaddbwhZRXOG6gX7qT4ZPTaUIZW?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: bp9h+bsOqNXue49OJQtMcOgzSTVp003e/MGvtTUs2khIIgvtJNVf1ofVpS0tkDkD+O+iMHPoAAWFKiNpxlrV67OFYbGdrpYr0HYFfvLFsVHAt+q1dOqgrIF02isV1WaI+i/9Gv/Jj79NpCeJjN21ev0f2LhksFK3BJwS4JuRKQpPRCp1u+k9g9lmArcua+LUABwopfreQBjihTRBz0nnbkDFddWGt20DRdOUf06n8Msdrxun+RBF5EvbYR5VUXiiR/t4HNSykJIj+Gx4sSdaSlUBLRk/F1mgJve2jWZFgmKDdQxowBrdTgIw1H3wyo/w9jmsg3VZQtH9djSRXKB4LjbvV6373DhUbhl2hX9HPOjRBYVk8U6doq9rpS0nIHREQXAFGzBWrSD2gLH4WzaS1L5CZuXO2uVDzfbd6dvuPYlv9rxs7HkYLyi8opsdaqnEqVOJtYLaLAyN7MmKdECZ9N/s5H9OZN6pdLCA4poY+YhEOb/qgvYAv+cb6R9OoBDBshpdPvLkZDtsKhywKdxfxRhxaylB/5LalLgnJmJv6xUHYf4005huQPAsxSdXwdnN4bMa2xHOrz2SVUM4tKdhG7ZSE5TOePutyYFd2Ue1BHTVAwFK8a2A5ckXqIjDD9PaB20VPa0t+QBDfnfyr1NQ6z8ZI4iYNuJ5El0mQe5Vn1kw5LbY9SJJoBvWniuDyG9SR81hV+EL7gyK2ZGCzQXCOG7Gh5f+B4VbCmGCol/zjf7U9VMUupiOUEy4DVbT6B3ATa48/fkzGLRKB8VnN7q17LO80vlZCTB+kCmJweFR4TzBkgub6ZKK/cEml7dMYcWeLOBvmi364ZXARv9L27spdp3sfcuQEH5qess3rVNGXDag+iY++sYTCeD6WsMMVqqF
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570d1fed-36a3-42ea-ef35-08dbe4b25919
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:05.4088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlCN7F4HNiC29jyYYjUal0qZryE4NOuVRT9pPvf7MViQPE2gRH7XdT4IGlytgSQojndVgyFFeiHuxobFneYHVOfWOgFD0HE/nhxf3ScJ3gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: KEZHCkbeFh-IN4UlKaxwTzR7ugXRKMTu
X-Proofpoint-ORIG-GUID: KEZHCkbeFh-IN4UlKaxwTzR7ugXRKMTu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cda0d029ab7f..0d73145430a4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1645,36 +1645,35 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
-	int retries, res;
+	int res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	/* Leave the rest of the command zero to indicate flush everything. */
+	const unsigned char cmd[16] = { sdp->use_16_for_sync ?
+				SYNCHRONIZE_CACHE_16 : SYNCHRONIZE_CACHE };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[16] = { 0 };
-
-		if (sdp->use_16_for_sync)
-			cmd[0] = SYNCHRONIZE_CACHE_16;
-		else
-			cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-				       timeout, sdkp->max_retries, &exec_args);
-		if (res == 0)
-			break;
-	}
-
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.34.1

