Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0027C4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbjKNBje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjKNBjc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:39:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6821A115
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:39:28 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNs4B9030165;
        Tue, 14 Nov 2023 01:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=/qx7ax6f+kv89eOoXm80os6ygj+SY5O8m3IccZxZfLY=;
 b=HIGDylw1STv1mrY8bmuW8SqtnRTUW7TPC0LklEykYORg0TPKiK5ox+jh4jIlWZ/ggDid
 OvdoPOwnNPdrxuxZ7C6N24bbYiRJ46Kuv2WvMpasCY961bf9n8ciP/SuKrdcgtcZro/u
 AOlGUiP8qq7rzjUA0bDaJGI91TRhHV5X9kbPEaW3taCa2p9J2ZYxQrEid48OaUhppEIw
 k2ntoXNgT1l1+o6KVOchm0DKAQ+eZIjgaVv7Vi8+/+FCBFrBuZyhg3HQxnHzdQugfzBc
 g2f3FFBZuBF3VqRRJJfBhP2QSYugoVGS4iTUQbBtdv62Hf5aB+dHlcLoHewtS39GTzo1 2A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n9v56x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1EXbt013562;
        Tue, 14 Nov 2023 01:38:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxj193wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7zxDjWGEryS80Ab3EI85BRgRJu7BwdU7yNqzJLhRcd8CdiYpqtNCa74xmPg3nRfQBY0SUd0TiUM5PG+VvjaT6Fy9fJRRodqfs7VreBoMVd98KE9Y/uKAGQrXIxxKa0UDu8/NcHu+C8TxSOh1iZ28sAAJ99+R5+LGGie7bVPm7Y1F8bVb/tyioyrZPnBpbUD40wUfioeQCDMlaeBtBW5Vhh4T4JQ03Z00v/F05Ehg7xhl1QsBCLZS2+wKNuFJ89B3xLjlEeXYLdHCYP5lmncPhFlamZkZCdFgUS+nROPDvMERkF6UetlfCAda7R/wjv1w6z1Hkyq2gcRVP6DVkBC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qx7ax6f+kv89eOoXm80os6ygj+SY5O8m3IccZxZfLY=;
 b=cUDpoecjyUha37hYTCcDQm8nwPNwW10wBLux1+Xjc7qoPb0rqqfaeAPYlngfBrBBkQAF9isZmiNWRuMVN4OWhcXIMDzqzkk9fk2x2lhUKjUt5R8RSL040Bbllh6eB5Z3mZu46+hw2u/ErCW+nWzu3dRgYDcZM09ux3pc4ePUf9DJs9OMi+f14dvkxCK/QD15ZOXdQUfR2JHRPIm/o0qxVo+AB44Vl1qMp6OvRcSgyExXNmsUAjUyIbC/DUYEGQk0JPqnHvK4PGHoFKS9lUHNeCfbv4AJ13pkzd5ewgTaz05gfL4JxlQGsBCBAY4rny/ab4nk+8MSrUOF8wpjusr9uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qx7ax6f+kv89eOoXm80os6ygj+SY5O8m3IccZxZfLY=;
 b=qOkF1+REZJ873ACg8WVygcjzlhwEoPVxjtDLxkSUgTrlWCYv3gmxJo878Hy6wDeyeaY++b3L4O/ujfr7YZGkmD5yAsUQnoeoQ1rmp3hyWyB+y5MbHllztq7DWH2CLWRyWXJSHe0qyFD1idc5Tt554ztWLP6miPJdhDV/viNJl5k=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:17 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 19/20] scsi: ufs: Have scsi-ml retry start stop errors
Date:   Mon, 13 Nov 2023 19:37:49 -0600
Message-Id: <20231114013750.76609-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0039.namprd02.prod.outlook.com
 (2603:10b6:5:177::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 02b1df69-32c3-428a-46f7-08dbe4b26054
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xEXainli6TYB4gt6cKDX7i+iCO/lHHic4n7ekIHBe7t3SonDdmgdfHc/X7j0UPu7Uift90HvwFfAAoopOM4cDnD385zMhpTqDsWsk3QuhKg2luWNYkP2QAHynEEIp+41Wr/qf58Tj/1w+z6N+XcYT1Btly1HMiTiB1E+bOooTDjHRjwG5oWYprn0g7GKuVDfuqjwUyA6rMtIE5GQEcDlrBKjhA1F+UThMgXEfla2wBHFraquFT8AWhbuD6QS0NSResNwqT1wJbTgTHItaCk46zfieAATh9enb1pEYua4HcOIyTGXIcuGIFpoAXJ63OeS4hf99JOUO7A7V4NjO+ytbQG/iA8qq3jSlFgYoHMZaeHf9izQQb0tvbLaWG8wdsk/+UStza+DynXoLRheqTTIxrwZOiThKuUAgG9XeFgSN6ue2JWt9gUY3Pm0qCXFyQeLVZGQI7SvWTwK7sofbmoLFKJlygeHAIcgOo5QQG1WRPoQEuCYPz1mudwSRJ8ckk2YH0Bbh0zhXmueVpdp08815nHV0Fjy/Zfoha3XctYnYopEEjanUZbDcS+dsPo6yMCZrpYdLoubZWTzhi/uaTcQvyCZyJ7HX+AoaZ+WPqC0i5XZ8DTfEvRR0brhPtxfD1k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6SIJr7jwAwt7dJVwnWpuMYMSbh8U/VYlhtiOboM6s86MY7P3rswexXtgwCWu?=
 =?us-ascii?Q?MAFF0ZrZxsUB4hxRYQmz4LwzFIthU9eUaNPReuhzlmpRQc+jPSZwJnbYinIs?=
 =?us-ascii?Q?84/+fR3eDFBc9ow9ZYTb0/U9eOYhVREqzVqy/fhr+Z7O/Ueqq43j0kP79Ka+?=
 =?us-ascii?Q?lLGuyaDwfOWFlqsEy6WAG/dRVUX6vS+StYCdGfH6OYYJyLp1p91zRTsCNB1P?=
 =?us-ascii?Q?Vm++4kF4BIUKPAEoaOm4M5GqIoVH5BKP2lzmoUoc77b+Dwmiu48QzJCT223j?=
 =?us-ascii?Q?3xzhZOncS2rx+dRILMwXAIBsbh8s2apubczVfGzj0JR+dXuR68SA+SbeJDSl?=
 =?us-ascii?Q?kqtmkPLnuGkl/JxD2cF52ofn/uX5oHqVL1v2nRgiT64A09mT5jt7TU3nPZ77?=
 =?us-ascii?Q?O1M36NnwUpjZ9bw7aFapWxN3SAkfIS73oeQavYupWzkU0G1CmsZQmVcvVJzh?=
 =?us-ascii?Q?5haaIVLht4YRWUdPWq6U6QypH33px5Sv/oAgLSBYYtAA8vZXnEhphym2WYMD?=
 =?us-ascii?Q?7bvsdJoDpbG7a6foPZzB+fHg4O6qBq/2oR02zKNzWPhd5J5D6XMIK7PDBpPq?=
 =?us-ascii?Q?twc65z01hKl1u77GiEg8hUrNIW1Ndlxo+64KzBN54NqtLRsf7x45dwF+632O?=
 =?us-ascii?Q?MYAsBNi+J1y36Goo/77vvmUidLAFpLf7KUCQ82gF5UJIyDova4F3gmuQ52yu?=
 =?us-ascii?Q?1WRqLXPGmeGEV+stFJN2aTQFwkUnSvv2LLm2wvzAT6C+TSYtfJRZnt2WZc6w?=
 =?us-ascii?Q?7AD83W34+IafZTi+Uwv4SYXyGTem9/ypxklYTGjlhnBL/YPiHekOPF+6qDCa?=
 =?us-ascii?Q?mCXD8d5+ejNOkSSFYhf0/OdhetpMbaueyRIem1NgCGeRhbKfv/DNnVBWx+dh?=
 =?us-ascii?Q?eMckEnoInqE9acW6Ao8+mCzY8XHYN6Zacdy+uNsVwhzhc/shLyhWDMX8PO7C?=
 =?us-ascii?Q?7Lz1xlyyi2/DL+plUW8DVry9SSNyKYKil+FG2EFgtiUqemsor7hBJ996wMPV?=
 =?us-ascii?Q?WAAV4tliI7TFeQZ0y4DPchhjx3Doo8Qwc9Onkgp6JWV+Nv3esxfRtNPnHaMT?=
 =?us-ascii?Q?RQKXoVmKTuCvTFOEA0g0RSHiu4U8V5VYV6g0y3+EB1ady9CYE6c6m15Bcc2D?=
 =?us-ascii?Q?BDbfnaUqwZiaYkWmsOoYfLaFSITrWXyAin7n+KpK338t90zBQWsgJJFxagk4?=
 =?us-ascii?Q?pU3WGrjZVunbNanJXNDhoHrHF6BpVRNFXb3/o7fWxxv9rNk0rDxQKbo6Q0V9?=
 =?us-ascii?Q?rjcAeMpEfztf46Rq2O1QEnyVA6l4gXPvb6pIFP3TdsCTU6rml8CLa+jv7X8c?=
 =?us-ascii?Q?JZPe2b5WSu67lhh6KdQpYvqIZHEtfB9jB0Ub3Fjx9iNmJ8MReQy3g9rBQdAP?=
 =?us-ascii?Q?XRYFbt3zAZDe5xYNdrmCipdlpM3Ax4be0EedOeUFZaN8jcMKD2u2FfMUA5AP?=
 =?us-ascii?Q?tB9B+ra51HRHSgx0hpVsDyrfpSau/DzgBZbYuP1Nq0hjhOB39CN0nbi0bXDt?=
 =?us-ascii?Q?VqL12qtWjl9nVDEp91phmm2Tae/CUAL5Y9QchXbYb2AGA2RqAIAs0rXziUVO?=
 =?us-ascii?Q?xzq+wunIjVfc2yHy/uys6mLs0zPlPQ3eWTydcX1rKEJ+vk8lHXea+IaUQWfp?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: KZMysBDjnU9VR8StZOOnqzeSZhncG2aFTw2flV+Q8GFSn/nbPUMgNrqZtVej5oVzws4vj/qI4OwNiTRqDsXInDSdGJ6vH2HleWALWcgKZS2KzhUe4ahZ5vMa507V0/MY/sKmhjRTYk8iSZ2b5rbSBc/Rraju6LNNmwLqQGJAj07YVTN64sH5fRyxo0d+YNVFvaYH8aMJqz4+PPGH+0zhykLj56O4x75PkKYsIQoBNtsG9LRGj+h7G5zU5BeyeOxzYsGKhEoJZWsvyZcJ8kU5VXVI9Jw/ew4qqXQqc1WRyn8lMYAFQRAD84GoCCuaoh6pBEivkdbcVRcbpI9FYuCykh243Sb8gdZpLpxoAyyiXcPKijbgQQJ4xsdYpIu+A4ouRv7+3Y/UOn2SS5ljAWR3IAXTQUPBpFeLJRYVe21l/QNHYBnrBrwO6A1S+9KLIA9UJv8P639+6HsUGuMQ/JGZNKFfe/VceWVdy5TJBo1PmxR3R3sWCIchoDSRkISUj3ufgNG+tfDB1gnIwdh4DqAF6M+zsIXbiy5nHB4FzD1NvRGverg9ia/p5/hkEPjjzWwbP0bMJbLVUrD3rjC0E6T/CptPEE1rTQmCxj7cogzNNRPRjDEaulMFE6nCunf0TLr4vZBLp4xgXaA49r+Rk7iRd9BEOkypqtaJf3G5AGItU6DvoPhxla5eJSdTPgCo0UFfMYqzZyrhjYiK8Hh7NlVHxWEhA7SUEpiR6H1N1AccIc2CbLh+EtfrGrRkkQhPYVVQBSqwJ16XDK9SrYH4bZucSqgPAu3kOwHBGa+8Bf1HHVIeZ/FvT9Btc67SMMOZR28o5emcMyjkLcWtrvZZGGz0Hq7tdv4dPTQdecJuPQfmgq5G+tIF8Wb302jMmJAyeUeZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b1df69-32c3-428a-46f7-08dbe4b26054
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:17.5484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2YgiG09B5P1oXgpHdV3kvUWHNroeOwhIS+2jCQ5cpdijfMqN5u9DcHoF6mrd8m0vCqJoSAsNi9lqLQVt+tLPfd3Qi537fy5GuRi+Sp+TOPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: -dbH5dAzjUbmmfElRU2LYz0N7A2GOpUs
X-Proofpoint-ORIG-GUID: -dbH5dAzjUbmmfElRU2LYz0N7A2GOpUs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8b1031fb0a44..001b27ef2bdb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9384,7 +9384,17 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 				     struct scsi_sense_hdr *sshdr)
 {
 	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	struct scsi_failure failure_defs[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args args = {
+		.failures = &failures,
 		.sshdr = sshdr,
 		.req_flags = BLK_MQ_REQ_PM,
 		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
@@ -9410,7 +9420,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -9436,15 +9446,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
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

