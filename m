Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFE5C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjGKVrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjGKVq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:46:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D6E1733
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:46:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID3wU015528;
        Tue, 11 Jul 2023 21:46:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=kiDbFCBfMyn5lvqMtdeTI/9rdbsKcHLUw80X2oOpnBw=;
 b=BrCNXhr2HQPQuhv8GexN9CyJ5LwaAHVN4AiO+RHRLX4xB4LnSsrdZAOVqHq3UOnmZ3tl
 gv/OqyH1JsFg96p0J1R+7oSYVPOQnA8DWT+EIoiQ8aDib2kwefB6vaF5b3QsJx36Hq1r
 D5b2Hsrbg5ZexGoDtyReMzSINASg6Pdylm6iMC9unsW9L8xdPK5+a3YS+EWBCLfstn8/
 IwBSNexwLzqdg+bMATAAtYXmpE+9+4YrHgQUkDgYy8ydLeBEX0vMe459Iz3310C9Jxzh
 aSK4d+vyjFVWLaVATwKDP1iQ+JTtV0aSp7/mmhu9Lk1ZPCIRjelizdFyC+uHnTHfOJTI vA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xumf12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJuKA1033178;
        Tue, 11 Jul 2023 21:46:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx860yuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWgeRnCu/KE/wu7w5+CDBR0lA/gNxHwNV65vitBIWR89msXJkTkuls3WEdkH3Cq3w0tHhbmtaSUkxtqDNjkW/1cFrXnHS6sPNjIxcqEt/NPB6awX8/hL5PKXPZMoIv8+oZXObDIIvtWqZ7PtXnL9zpwHUNG72FjnqSgLUl/iEpnXKOapFx0Hk6P0QyL+XoWDUwPrn2PZmiItcSuiECDpDdsxPUYLRvokKd5GZPkyaIviKiDskMfdBznnPy5UVmkYyAUyoiv3+EMeZK1mm0de9mNuAauMUwlpEopsWYX937kQHsTHEpiNcPP9ahbsY++pF0cOVAmGf6nwAc+j8MiCiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiDbFCBfMyn5lvqMtdeTI/9rdbsKcHLUw80X2oOpnBw=;
 b=ntnOBXDDRFJV8+PYgFyi4jcpuCzJXAL+mgodckEMnaqxwCHKe4FPrDkZdv6BTBa+ENYOv0PLAOWSTKZxXog27ubq0r3nYojkHgXTqMFQnv7ordpRA0xDm32W02XSm6qD1ZlcQRcrwrc/Yd4TnWTxt4qBxa6E4yGM7la+N4OPNHh9lQ6hi85Vb/maUvfnhsFcCJqNy7pIUCZ6qcWLUF4Nmq1JDTf7SH1pm7mN1nExwnHV6U8EjWAa7FvA8D2Q5HMdAXydyvRFY4FxQK6wxixM13h7j2Ovh52Jdk8qgVXMzePJumNc/KRW3fbECNfgW650Ie2st9n4IsGj3V7PDZzM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiDbFCBfMyn5lvqMtdeTI/9rdbsKcHLUw80X2oOpnBw=;
 b=k8T2RQAoki/cXhn0lleNOCDjhHEcrbwsfnuLKDCFhLNgVqs47hZsy/2DuuWdHqD2tAakolrP3ZdKhGniaWWpoGJo0uL4uy/PtTq9NXHihGsJySpWqV8XMfzD2D7sEQpkUeTy002h9d7WNrxrIv5nZKp+0b4RqBhWO3RExz+T7TQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 08/33] scsi: Use separate buf for START_STOP in sd_spinup_disk
Date:   Tue, 11 Jul 2023 16:45:55 -0500
Message-Id: <20230711214620.87232-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0143.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a0988f3-f663-4af3-dddc-08db8258505e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6TUI9NkDTfY2daK0kkU+njNwhGPijyb6zDpCofF9GDqBlaK/O+Oa/kHhJISDgXHc8r6WEVoT8CFUGhGpFMyf2Hj9jTLsVcRgue1yWU94vgA8z89XcYwZXh829Y3e4f0uPL0H067RYkpeoOoc9aYuO/C6WCs6XXVZt/+rcfna4y+ysXJ1XyY0t0/J0TND1bxUKjGXZscKlooC/i6kaOipAEsxbHwRHTAECtBvRhnrMIBVqxkC3/g+UufK6dpRn1EEoEu3gLdijzP/VpuPwpE4hxjs9NrfSC9xL8iOhyhDXebFfKkPFLzjwO+EfS3LcGWBT2u7ZxNdl3QWXK8EMuABqwdysj9SiR3flutRjO66tfrc55B915JxJ0kDGrxb0UIiul9pIkQX33kFFGVkHSKG/KYrHkG3QIPVozWpknuBUADQIn2aUBMT063swxUKB308THSRQSHyjBslvRwqoxHr50TK3a/Mjx3RnBK0NKQnA3glmkmXT44Aa3v0MQ1T0w0fkdDRLIpT8Sg4jJYoIylHDm6MdBkLCeUIg9oVadf++Gv2eZRodA9Q3b2Pk8YYL5+Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8v/j4WwAnN+mTaQzm6ywxNomXN2met3jl2MDy6H8tjVBAq/OIm5Lsxw1dwus?=
 =?us-ascii?Q?dfLBJDEh3y74ULLO94UWvTLYDSLAyfYT80bqbQcO1QS7gENcBVA1uxxHvEkI?=
 =?us-ascii?Q?KeBTvIDa+WINTug8a84lObxBO3WGjul1Q+KdTs1BXbmC0kcAHpP5HxXCCaMI?=
 =?us-ascii?Q?0HTqFOxK8Ys907eKOhmRHoXzXP8vthTyXZfepRIMqrKm9BqUAABw8bTCWlg/?=
 =?us-ascii?Q?XsboC3x1oUYoZW9jeCCj084CouteCwOre7Dsr1VcBSBcsKZpQsFygozTIEil?=
 =?us-ascii?Q?3BmzqxH3d6Kx5lVgitwfR+UjSxgyn6nNfL2nqNlsY8ybeYr2Y+j7U7Xa9shu?=
 =?us-ascii?Q?KMZAYKgFvPR6AU0cbsGqfNHQyDB1fNU5LuPIhlYMqEruiCBckSu/yyKW1NoH?=
 =?us-ascii?Q?0zMRo0LjGe3LQDRm6e5+tk/X/JOhZeQamIFKKJvxh+g4AajhEV7jwMkQvWJ6?=
 =?us-ascii?Q?DvkbgiIDdosDO18I4OlMi5QawOpXB4tIh3XddT1NJj6JQUeIPC8RlWfd0zqh?=
 =?us-ascii?Q?rK4CBt0MeibTtUuIJGsLFXKLbBiYJ2PJbmrLXQPtaF61wWvgnvKqnlqn64fT?=
 =?us-ascii?Q?OBm4FDnNuuyefQg4p7iA3/BMUgoOMR97rSKW3NAZvR3c7KVwupK9M89dN2Q9?=
 =?us-ascii?Q?Y2ItIfB/i3le9gihrfqA53V23Bt9wr2ST4nve2IAsZ36BBefxQtBbOHHhTbz?=
 =?us-ascii?Q?EdYXJ/YxYStdSFGN+6LMZro3iC5qEjeQLJ+2eT4qfiV9A8jVLtYuHUnbBoSy?=
 =?us-ascii?Q?FOR/kO8cPOwJXceVhzcDMVuivIEpX6M65TcNokvIiir2K6T8t3CtGmfD8u/w?=
 =?us-ascii?Q?satKnVEX/Zq+9FyeqN4DSodlEOteFxa+lOdon/txtXdt6G17Jtl/VJFCbjop?=
 =?us-ascii?Q?8l9LszJCL81eP3iOFcUkOZ2SU2Ri6HMufFt+8vboWnuYDJGaPDw+vbYYPNQG?=
 =?us-ascii?Q?64TTQ+VuCM+hd4OTwjM5rEU80LggNzWMA0K1ZEhNqshxpyQ3dwLWQGAiAp01?=
 =?us-ascii?Q?TO3L4Hcg7xCeKbAXt7BvSuNOLev9NYdoXEMQBUQR3hV4g3hsaVwaE6IYhuub?=
 =?us-ascii?Q?Z7zXCdyFGVUI12qiC8W3GSphW5wmPJN8+N1AUNLjmwye39p1L+ZU9zovzr+k?=
 =?us-ascii?Q?ofFeXJttJGjfDDbt2E+CYFCA9cX++NUNRcqKubnBC2bwrHIlH4ROxz7Tl70j?=
 =?us-ascii?Q?wgH8eR1sPqShkKm0Fuj2NUKD5Jwqx3P6fBH5/a2sEGo6jM7CTTfcWYqXosZH?=
 =?us-ascii?Q?R2sUKCXb2+wJeD0cD6jk7PwKNdcmJX6JKzQTGOsEhPlitye7G7GYE18pB+X1?=
 =?us-ascii?Q?Zrl4zprIUOvP7DWF/qDQiXgIIOwTEbQCoUK5hz08dn205nnwg7C6M5Oy+3n9?=
 =?us-ascii?Q?8fymhN0G2zDG33Ap9vbW31PWUsYxDPHNuOENxqAdXoibWyHAo/X6k8Pt1+o9?=
 =?us-ascii?Q?9YY4AdWxfFa2mUrSmgkPbMLMbBjJYJJE/RJIDb4CFpX7FvTqgFPenPLs228s?=
 =?us-ascii?Q?1MkCiqh3Ts0372AooNNjOBczl7WSBrL5fxNIta5NSdKoa/PeGqtn9o/SGQdW?=
 =?us-ascii?Q?MwwVdcTSLQaOJUw/SCYEtlGva/bFU8Xh3EEOH2AsNrRlBLtSnQk3Zk1rRnnT?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Oolw6unwFdHVW/W9rfAktsXqAqyuasV7cVS6EXou+LHxitur9fPdHyVcknK5e8tmAkPJWRSYr8jeo/1J42+ZVwSCbICZAtDEhefqEgxBZTtenK8MNyjTDVva/G1KjJOA4ubJPd89rjs3JUxyLRvWUTZmNTTMcro4wWKyLS+JOQNAlqx0ehpPzekvDOwjhi2uTe1jzdwGjbHx/ablQLje3AtGAh5akEoZlgFIaZrOazGJZDVbaR9UIAOxrzGXaHu4hbcp0mb/xil6Gf/t6pZQYMpYV9CpE8KPfK+qIsw/JfBQcAAmtNbPzDmFqZrl7UTCaQ8pVq2fUZiWtPb1N0qa6lloqlNmIoy2tPjJO1Zz/KNk/f+LD44j8zjkT4PXruVlPZu/dHC6JVmnhOl5y9sHVYE12TUidzjKr5wnnCRrvtNoubPSjwLVqlWYNocq+VFUH/zVQ7KGT/CZC2Q5AIQqgxWDTi0xiRTuIojR7e5sw4o4d/S9W4p91XkVF1NayQCWzYTtTY2HW8HqXkmyTYvMdFp2uN/xBisbqjFNMg1XHfVwcYesLWEzUY37WOqyV0BsQhVtNyvBs+WMDaq1+qRW7KoDX96/chXL9VgN9bL+hnnjxhOXtHJS2XUE0anBZasaoK+1SHlmwQK1BLllqckhLWke+fHTux8vUPnFWro/9XWatHLHFGmLiApujEUEmMkPHzCavHP7Bw6c4/iztpDJ/fgINZAbeFuiF9TRBurjvX4NA+risXK122zQnxZ0pbh4fx99TFCh6VniLOUV5Dw9LzCt+N8HeszQoB8WyS0sbB8smC6IE6TdVmm3A5HMLfjXopvBDNzy8fPk9j+3gO+tmN2eAYkx/IeAXoIsjHXUx1Vb6qIeEfxdjHhNx1vTJJd4
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0988f3-f663-4af3-dddc-08db8258505e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:42.7503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2Wtf/hJ11TX34khXZxceW0PtFk4cKV/+3boyHesIQZZSegY4Jrn41r/PdRb6UHx9K8NmOAT8I6E8O0Pm/JoGpYKKay6BRVg0JAmv9IP3CA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: BsC7JffHACI956JypsnX6qHzzNlhrjpx
X-Proofpoint-ORIG-GUID: BsC7JffHACI956JypsnX6qHzzNlhrjpx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We currently re-use the cmd buffer for the TUR and START_STOP commands
which requires us to reset the buffer when retrying. This has us use
separate buffers for the 2 commands so we can make them const and I think
it makes it easier to handle for retries but does not add too much extra
to the stack use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f2edf1d79cc2..1a1011a8ae53 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2268,14 +2268,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * Issue command to spin up drive when not ready
 			 */
 			if (!spintime) {
+				/* Return immediately and start spin cycle */
+				const u8 start_cmd[10] = { START_STOP, 1, 0, 0,
+					sdkp->device->start_stop_pwr_cond ?
+					0x11 : 1 };
+
 				sd_printk(KERN_NOTICE, sdkp, "Spinning up disk...");
-				cmd[0] = START_STOP;
-				cmd[1] = 1;	/* Return immediately */
-				memset((void *) &cmd[2], 0, 8);
-				cmd[4] = 1;	/* Start spin cycle */
-				if (sdkp->device->start_stop_pwr_cond)
-					cmd[4] |= 1 << 4;
-				scsi_execute_cmd(sdkp->device, cmd,
+				scsi_execute_cmd(sdkp->device, start_cmd,
 						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
 						 &exec_args);
-- 
2.34.1

