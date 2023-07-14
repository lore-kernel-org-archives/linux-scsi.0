Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C796EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjGNViN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjGNViK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93BC3AA7
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4Exb003082;
        Fri, 14 Jul 2023 21:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=2CLbWCOE6iwWCbt5W7HlXokz+ovF05gLH2P7Z0Ly8ro=;
 b=JwatEcWu5MlhuZorPGJLZhtMzpzMUlmt6JUjzSlhwx1SHv7erWBHRi6insLK2vZmeY2i
 aklFH5b5k1oCVznmwNGT2Ftne3V6E/CDWnlYpeb2Kakcaj68EDkB01TK0GAPPTP3so8m
 CQ8xlHmtXwmZ1o2xRLoiY8w7qPzI2T+kbXePbzX4GYUMzVa3YCnlRaQMWzJszv/INito
 sBzVD37ixdTa8qDpmC9i2SpEZ2FOyENux7i2e8LFshC2glzMp2uDadSu/S/ETBDoflly
 KByoNbbZQ/blhHrBC5IXlwDjywoRFCcqNT+jvEOpvb3PplgNikErvhMCzZAFoijK1baE +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK6HF2027202;
        Fri, 14 Jul 2023 21:34:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvyh6t4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V68VVeqSok+nsFy8mMANHLl/+EURNZekSxQNJprzv+yhwdevnVM7Xv3xfjn9HYXEty49D8qms/fQDMRDDUKW8EsLIdLOwtUJ2sMguTdvxd8WssOnY6ewbk6AXu7V7txKtZ9m8u3pmrKdDxLBuruH4fDWbMN09qx6aZtz1yxNPBkv0KaUoyi9t81Q8iRgYCHHlDdVsXL1KJak7yKUXc8N/aLq2c+VLVvmMSgNMWg+TBtfVrgr6R1otamUIgzVLvQQ5R6PjqE/K2BeRh3ZHjWiluVbSLDnYi6v8Kxz3EVn1Y+3pTvbecK3AVrkwU4IYNSeL/xTYDo8BY3M6j3IjXDaVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CLbWCOE6iwWCbt5W7HlXokz+ovF05gLH2P7Z0Ly8ro=;
 b=nV2rtYPvvQYuXeebb/UBQl2ZTAWLbxfDE0K5SAXlriRktwzZvTfMqeWMfLeDhmjHj3FD+Rvh47L21VffzyRecyIPWNBsvmTXOvsvKCIa/PAXU6jg66OUYMXwOUQbzjSmQE11dipBGD2LoM0Dq/IM8Q6LNmu9S63gXUMLLpIaJEmBXTJIQ19BCNK1vNAmM75dXhPM43C2xFcKpq93kNY+2RUh7n05RA3EJ0fZBkg/xz+26+gZTxgcSpcwbrqu/xiLXMSxW038TB1A2wV/aqmqEkwlOPai5YOCyq2d3NIECCZKgXS9AUJmiYTHu+mU1cKYn/zoV5ARNwYgJYSRgqOf5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CLbWCOE6iwWCbt5W7HlXokz+ovF05gLH2P7Z0Ly8ro=;
 b=l1GZEzGfFDPfmz1bneJPwTyKilfHApD4C9YypIYZK2qcA66hdKs+x3V+sz5ifoD8Xdk2OALnvYKpU3K8o+TxuuQEIYIvdP92+sRVRFXaxOAHqwBORR/v01YHm4UvDxaVJr4Me6rsIvTgQntlNGtDgBLqlptKwSeFQK4m1SSImjU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 14/33] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Fri, 14 Jul 2023 16:34:00 -0500
Message-Id: <20230714213419.95492-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0005.prod.exchangelabs.com (2603:10b6:5:296::10)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 7664affd-446c-477d-1a78-08db84b2253a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YmhbVSosY2fvCkcrIKOhrh+DZSncgT5dLByRj+L/zubTCgkxldBckZKTkqr5XGj4QWRoMSsrnRVrQGWrgGJcN4omF8AHyMuM1cDib27yU6Z8el9FNEuxa5bwoBBwvIu1tAgaJV7F7OWjalvLxQj18oqowwtXnbR0hase3YpkU1a4ixUVqrlVfqSZ0S5GFirgUw+ihs2I3bUBHHrFYivik4aRAQInZ96nDVM1KbpCfB2l2qTgGOedCxYA1DgrYVvqX4Mk6tVsBD7246Y8D7AZUJR0rv37HWwP9O30oYq8iYUGzHzrN4hzObBnh+kjn1TzRzM8AdGOAULEaDyDXDLY2ODzfVizGflMiRTZlqme9t1NxLOambK9uvumqLdJWiH/xxHcNf867yeuBsm5SBoeP4smiip+NA/IARB3RNP1QpVDosA8BRxFZS9m0o8gJ+3J1UMGi2WS4JXUhL3h9sgTG3nEN/hDYj9kvsw4RVWuZ/6yEJ8QjVcj3P6pSyS+7XK+ubzOB4aG5Y88w8We5s7b1bV5rNsMJYKxbBrbQYwTnp7z7Zjkw580sh4XdS9WykY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1/6fZ/bbZ5NTb8eO957KWR7u4sEl5+QymPG75YWWbQn4UOd9oHOGzRb9lgp7?=
 =?us-ascii?Q?V8YjSW00299T2d2qJATO3M1/nQySIYg1JCJKxOwIcc4NTXe+/0GL4CoggaB9?=
 =?us-ascii?Q?JYH5Gyx/PhXX1ODmbo/zqIBZeOEYfOGzexhYOjzVT73MWpkruxfcltohmmxM?=
 =?us-ascii?Q?XkoGox79OBjIf0flqWnyQh+REaHgA5KgfrMpc0Z29yv/DnxADj3eFMv2//KA?=
 =?us-ascii?Q?h6tlhuY6eMyCG0GLXFxzn0YTKd0gwLPqhscEa+P3MOrlfElZ76JCDqU+YONC?=
 =?us-ascii?Q?/70aw1opn6FAd54F2y54U3p7fb3b1h11FB2CFROKFO5Aac8XmapQBbISiqgf?=
 =?us-ascii?Q?1q04hKichHzqwxmHVR3SJeblrq/tg7e0DPMxexve+ajJ8x1J/GLkdGX+INE2?=
 =?us-ascii?Q?qlLVHNET2d9WbysXdEcyzAdNZ0WMb2oTSgW/v87y8gl34PxAXpDrnYgPWDQD?=
 =?us-ascii?Q?AAh9JGGU4DDRH/gdEHqqguueYbXjj6NX3bExAURfnwI/7Tg1hiYP2PV81lTO?=
 =?us-ascii?Q?vpFspVtZsq72bB5pg3t1iQeBU0ei7PWsVXrRa7YyVQYL9CTCMXAlwV9TjVnW?=
 =?us-ascii?Q?RsloYcHOsZLutiywCAM2vOWlJtyEsleYAH4OQ1jwPZrlTvXHwIRqf5OprVR0?=
 =?us-ascii?Q?ot7qNZmPp2bZMAE7K4bYY+JY/I8p9kL/BCAK1VeS93O6417E9xT/DtJG4+0b?=
 =?us-ascii?Q?HX/h4ouoieHGeJFa0/G17RkKi1nn1L3En+k1uxhoMrpW+Bxn6SNuwBIAZIMr?=
 =?us-ascii?Q?ylsmqxjS1STvLRHhBUPb5GTylVaFtVpqO13P9h+JnYipBRDTfUHQCXKtSBP3?=
 =?us-ascii?Q?onQqpRpORwnNiuONpGtDISSKKQnLn/HfkjFRd82awD4OvlSHOMLeSarbVtt8?=
 =?us-ascii?Q?QaEhZfwhujGnbexqxinVvNXQyABBxelOnEtfz0qd2d+whYdkDrBuGwP9yUgq?=
 =?us-ascii?Q?Zr5Gqs+tnzPWrTjpOI2JKdb+325aiNNf6WFeZBAACwQXydf7NBcAWVr1/CMx?=
 =?us-ascii?Q?VV2ZJgxyHYARuhZK1mqC6OlOFaN3HiYYS9tSr80rmXa36md8AwGjFs9iwVU/?=
 =?us-ascii?Q?Iy+fLI3qI7yLZnRL1IaMpJ0JFWA1cDeCbLjZw0mzBmlfWvydj7rcF0xUPdWz?=
 =?us-ascii?Q?ufefI9e0cXqCo5EWE0+4vcPXZkoyMzqkWjQIdAEW7un+ALxbwJBNnZuTHvON?=
 =?us-ascii?Q?2N7y1z0jHA0J3MU4FQrHhz43TI7hJOhsgq8eK/ScxxIerBUPNIt3bxMAVyWh?=
 =?us-ascii?Q?qUuFdCShBnG2vSX7UOmZgNXVEahK/3TFboLPG0LYYEJlN+K9FthTQBy9gzab?=
 =?us-ascii?Q?EKfW3WR5yVVafAwf5AuoUe/3ijv7sQtv/AxaBh05kyoRuTmERT4sBPtv20xb?=
 =?us-ascii?Q?ULH8Or4S4g8KbTW63Zkl0/2vrqZUbUDLPcsu+6jXkzsmMXWSxH1enMkDEJKi?=
 =?us-ascii?Q?08YFxkzSt7HWPxWXSRyhQHTRakq0j7DNY89QOn6K7BRoQtB82JQz0FWs/gs2?=
 =?us-ascii?Q?RgfDtX6bu2DNRuSnIiHI2BKZgGX/UwMWXc83b8DB6tw2gJoUjR8m6AppFGu1?=
 =?us-ascii?Q?ohQNWqREtjOHgkhZtwNQcoV5kMuMxdPjHi8Rf9WxSpQO4uZf7wsC1VmuMg0s?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: f6aSz12kiuYSfFtg/ljq/zoFkTS8DE7cGWK5k8RItN0xtMZkOuO+v+SqS66rHy3wJLk4p6RdeonbaU0otJu9b9B2btWJ6vaaZneW05HPFHPuswAR4Aw7uxtRqDmjCgYkBNJU/6/74ej1N7kzsna5upFuzPWRmZ8obAR/5Kxj31yes4Kz82pXNy2T2RiA9aloW6OCx70oap1tavWasRtAl/5amM91o75kQLEimkyWW1G9fnPdoVPRnMXWfQhJcnzQyLGzRqq3Iplrde1rBmGQEqc9kjA74xmJMuvvwLL40IL/fGeBPF0tdemiNiEdj7NnCu15FuQ4E8+09X9AtkhqX6JtsXLtUWVG8VEVNfP6Z25ZtM9ORuXwpRPiA1mM2uR5vEOJHRbzv2DswkuHAv1spHdWLIqKTZ5LZtzqc+ymWWODUUPj+qZhKzOWWcDjdLTTn7GdXUqeJ8sWTJdkqdhRCJPMg4R1NN7VR7RoWvgdUe+txulPK1lWgtSXZpWgMH1LWS4P97kDR2sbyZlHZ1F6DITM+VzN9guV5zDrkurxytAdkyFe8wCdbivc52P09qHrFV04+xjwFF/t5L4LZBmUUznW+3cjvlf56CNacF1XIw5P1mAfcueqRdOf/H49ptJRZYYH/AUOyEEKHc+UGjTu3jz5lah9u8p3FF1GAT9cDWtGlV582nLm4LpTG7Y0BZWta2zBXzoHel2qseNdKBJ9TEABtuWG3bhHWF7PNcKQf9r0uOr6HgTKcBKOPeROX69JgCJQhNAAPa5htGbjLBecHiRzJbTDmLLKHAee1uxjn3/2gVrHeBYE9Mt2qr9jVGJDbsVju5d7hX8hAD/MLtaGBQvShJp6Sm2qFASqU4j+p6L61dFLbymTZT/MEc7JTE5l
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7664affd-446c-477d-1a78-08db84b2253a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:46.8433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzT3oW4YK7dfdLefyrxufAlSY+0Xie1lsWWr7qXJP5UnnsvZ+Jv0CfT9GtgAAuFyqQilOeTpl3706XuJLkWotkaslFNymnWel8azVV+7Hcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: tzXmrp3MShIInK_JtSIH-iTeD56bBz9L
X-Proofpoint-ORIG-GUID: tzXmrp3MShIInK_JtSIH-iTeD56bBz9L
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

There is one behavior change with this patch. We used to get a total of
5 retries for errors mode_select_handle_sense returned SCSI_DH_RETRY. We
now get 5 retries for each failure.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 92 ++++++++++++----------
 1 file changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index cdefaa9f614e..1db217be4db4 100644
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
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,52 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int rc;
 
@@ -549,27 +567,19 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, MODE_SELECT command",
+		 (char *)h->ctlr->array_name, h->ctlr->index);
 
 	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
 			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
-	if (rc < 0) {
+	if (rc < 0)
 		err = SCSI_DH_IO;
-	} else if (rc > 0) {
+	else if (rc > 0)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
 
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
-- 
2.34.1

