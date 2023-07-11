Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F9DC001DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjGKVrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjGKVrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A611704
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:09 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDARE015910;
        Tue, 11 Jul 2023 21:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=VYnOIhUVj1V/50kIYvrfGmYDduLxEuZesuEoU++ELp4=;
 b=Lz6OcJoQnKKRP2Wjmex4urYqq0D2Nj3F7JVTwsMsIBt5OmnkoaNcvl0uBeYaAVILA1us
 62FJGmyOoyd5/ubS6O8kmSSeTC+XUXXzIX8otN7NcOGHu1x7ILTMyFZinbx988hMQ5T6
 vcbEy9+Rk9mccee7btwU5PuJXoWmZ3OH0comx2xK/dANqf9ae+f6KG3yAlIk3Dps3lQD
 Dt0KqQh3gyLmeVX6yqxN42Cbp7+5memb9LKAiO540uT1pL+nP48KqCLQj45coQ1yvsZV
 SxEu5+Aw2P+biAZvmA48YyZA9Pn9QtoQKcP/NxkASG02W0IruqZ/fgLZTq8imYh6M+JW YA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xumf1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BLaeG0004195;
        Tue, 11 Jul 2023 21:47:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bt2ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoNpeNSfTT3si0hfPZTJ29yKLZmlFhcdb36VbKMPbyF/Q8pMGrzPFz+Id+fvyJzEmtGTJwpHOACtrq7NYzFT5U1AceiiKz641/1m48s8+k5QThCGetgdslrqWNDgF6sew+6GJKE15oqJ1EbZ2mCCee28EQ05wVlh8gJQYlK6udOBQN7hYz57bThGCp1oY9IEJHL2f4ksKBZ7HKMvs3M5CGRW1+e1XCwbev0P3tDPBq8h6g660aOLDpTiisX9KPCSt7dA4moy33ALcVBP0UF7XFvJMRVTOJ2yrJIHafsns+gCgMd0MvfkirC5JBBH4ILy+549JBzdOjUjxWYPrrMmmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYnOIhUVj1V/50kIYvrfGmYDduLxEuZesuEoU++ELp4=;
 b=bpqTHkiMwLMiAv0/D3C5KtoK4FyYDehjUNU6/DaHYcFQsbe2PVJTVgKq3kibolMxbKYTWzJ95Ntvkh8hujCyeB5+C1RiZ9I8QfPus8AR/M6VoLgVnMgQimF5TdZw8i+FkViu7vjWRlugrAHPHLF0nrVHIoJ74VeRVYiejpSF9aAv9W+9voDtcCH2C1oGsAV5SHvKYpMD/cVvB67W6U6VG8kV67bQq096IKjtla67Y52gUx4AToeGBbXY3Lfi4J38nIl6CH9tGJ++CdDMOxcgkv4ZNusXiL+zwTmn8h/JwoVGn+LKv1YM59biDkgkgrSfeyMwrPDpJ0pnkrVJYSXRTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYnOIhUVj1V/50kIYvrfGmYDduLxEuZesuEoU++ELp4=;
 b=NGmk3oKMGU4O2/qtUlUQAx+kSnqoohA/YhaqPlWRqndFI2acnTNw5q/5paSkSk1jXgvr8GhkW+K+0mIrCtcgdO+nGp5CFDkdOp9neoLPLj0o77wsVuac0LbdW+C5zxmKa++Bdo/elfbxx0yhlC77yAtj00qE2DmOcGBRb5aYgl0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 21:47:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 17/33] scsi: sd: Fix sshdr use in sd_suspend_common
Date:   Tue, 11 Jul 2023 16:46:04 -0500
Message-Id: <20230711214620.87232-18-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:5:3b6::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: c962d6ad-eee7-4e52-7b46-08db82585a8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fGoqwWsHykCj71KAWYu+7asG/na3MosTD/pVaUtelOa7zOVh2e+9ki7tmk/MoJhgSk8xRxFbEzqx1oWIxAp9f8DiVsk9376y90IBZnQ8WASaGkzMW+3CZIhuolZEEfbwlPzJvfIEv0JXV3HJAchI+Um/J+PolJyi9BpoOaEw6M5cKe/9zHjx2Pe49F8nx9Ax0FOTc+2aGNO7Aoo/BO4Xa69R0kSpTOUQ8d9zXbi5knrsmo3dNkySq6iQz0KqrbvCDdwDBX4+pjhHCriWKUW+Nb2xEc1iYcWaSsCuITpZAkRnuscl1wMAuYENbdiMcqDSQCvFE4PTqOBo2TLO4zcydp6wEgZ9bj9LN9sUx9BUckjsFQGT1/CowHUa30h79agOQWostj6RkrTutrbBgs4YZpz2qKv5uNtDbb07xrEnmsKFgsy9rXTrn2e+o0hj5yyf7zWV6bS1/d++w2WY/Tj4JDdZj1yufFOWkPW8NFYpQK6icXSEhYjBY1Qc+wCHW9oNcvVQqdYyH363FRUiHR84EAj86kH4QM6cluzy9cB8wcGa3bpR+5+8Q0eq3Cl/Zcr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(186003)(6506007)(2616005)(6512007)(478600001)(26005)(1076003)(107886003)(83380400001)(41300700001)(4326008)(5660300002)(66556008)(2906002)(316002)(8676002)(8936002)(66946007)(66476007)(6486002)(6666004)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jWZMK+fEYbzSdQ5hB6G/r77734QZF6VsQl3bv55r1TwJyezHjL7ssJb2d1Xk?=
 =?us-ascii?Q?Hjdfu+XicdwXjtu2+5vx85fhWwJzGk33uiJtfEbiG6pUrajsKt6Y8/j2drf3?=
 =?us-ascii?Q?r9cKu0uTtBmZeZahgJrOwGbZSF25EhiAEcqqogEf3H8CxrhSFvjUI6mWl2JM?=
 =?us-ascii?Q?A1VYSMDpztCQy4yzkdV9NUIbYpy0njG5JbPtyssLQNvAQZ4BYCuyDDrUHbWZ?=
 =?us-ascii?Q?pqPNzVvAKM746dwhTd5cX3wA71NLPBtViBxIU/9ic9KczRKnXZxrJN19cuh2?=
 =?us-ascii?Q?j694dO1eBq4LTRzC2tuMU11jlSNTYwo4bgFEa/acMNC8StcBYnLhICgTI1fC?=
 =?us-ascii?Q?lZR+OwTaWykPWMm3jNgr7QiQrO/1JYwUSn9XuqidxVPtnUUsIVRt1FwYnT5/?=
 =?us-ascii?Q?OyZg6Qq8TOxgFNLNAWorl1IzeiQazV7O8xBuuqJy291HzflLbvKfVZ+qD0qz?=
 =?us-ascii?Q?bAoP36qxxrKLSCBW47G7Kopu4ZNVwoUJ8n0V6VocuY6kfhKrnoncZgXrt8zC?=
 =?us-ascii?Q?7PNKS6Lebb2kRY4LDVl4tqIs6ZprAbK9D+WjaMuYjgPnBraJrJnKuh5TlL1z?=
 =?us-ascii?Q?c9r4rbSQ3Xx5JL/O92M7jImvwlwSgxzc5EAbnIcpz/oKGz1BnKQn4uoGPhZI?=
 =?us-ascii?Q?LOOaFNAvIMdg4q9w+l/pStMP4Xzb56afzMoq0JsZzOBeo8ETMfW9w8zfwn0i?=
 =?us-ascii?Q?AHGWrnvKfEyc8G4woCopQWewNzKj9kNlrWNCLb0GS2sdxFG8Wk9fNk2WfGat?=
 =?us-ascii?Q?MVpRSm2HA4Q6lrQ/5xjAXzfI8672aIv6jF8IdgIta8g0etZ/KdLvx7CQN5Lv?=
 =?us-ascii?Q?P4J8A9KT4gjkxkFhy7lpJrBXigJaiuniip5Wm675SicHQsYmZfRUqAunnxmE?=
 =?us-ascii?Q?BwRR5QdJxLVLzYxc8gmCpW+sw8iU5HseqoYoMsL/0FOZvzUBKVjinOoxMvdI?=
 =?us-ascii?Q?bsA57c/M0kCv9xaol2ME1j9rHk5ZMXxzeXM5oFJAWfckYXOFM2cFiNvtsLqo?=
 =?us-ascii?Q?2M8KzGpLMy55U/a4pSEOj0dHQwGVYBy//k1P0hM+CmH/aNkH9md/RX4qb3PY?=
 =?us-ascii?Q?Hxq0WqlKhMCQUY3PD5bw9iNdIZQI1VF1PMHrvczxt8/3ptxGFg7468wxknQP?=
 =?us-ascii?Q?X81pUF0LllvJQHQ3PhyLbbK/I0TIKYOlSbd63HUVmd/F1GrOAho8PN6R/PrT?=
 =?us-ascii?Q?EJsOxeHXV6nXKGHeeoeAFXZPFXndmQlrqeZfBXzCiMLvReMk3/d91v+oCzNL?=
 =?us-ascii?Q?riuTYeqAXhVGL+7E4Bjld9wkrCdQfg1UsL3AOLa57esm45yLpfS7hFJPxXGC?=
 =?us-ascii?Q?EY4KAeWF+rpLRbALCSAYRrhkfN9Wo/+iU2ttQxCzZy1YXgWOElzAbVfx8T1A?=
 =?us-ascii?Q?mNNiNYfzpWpoUE2KJkxG/Y6IT9vNswItKW5UoJD+6vhpSYtyLrAiS8Y3f7n4?=
 =?us-ascii?Q?T68DJ8g5UKdtdpoQVX8t2uyfekL0x4JjFbApi+RrpG3JPLKBlOKqhk4FoPp1?=
 =?us-ascii?Q?cWDtbU8K37C6HLjNp9ZJgSQOUQAO5YJSm6cjiDhMYsOW4pZxnVrc8DySwDLJ?=
 =?us-ascii?Q?RnYKQgNPhyjLLK2epoH7sgY1CL72R1wPxfsOj/227l51bjwhAy24jTUPSSk4?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qssPLUaD48IktQTpj18oDWA4xEIFBkzTsznxsOBRauXa6md09jNzcsUO7T5tStsZ/g0KqndkLAuOT6zM/h6y6l3des7PEBvgCTrBOzwIV89U8RVUXOjl+2PKvQ/8TZ0QhFFfC0bTMutwp8v6QTPGowptuW/8TXciIvP9X7K0fOoEUSAh1u/AYqF+LAW5rZd17b/tvibmB5X4zU/77g5gOISD92y9ndClC/QLH03Bg3D87nLAC8ExIU/RSDsGvq5gm+xtJdGPae0ES7mBDboGDCJ7YkoCajFzlwon+ZMPYssJKy07KeEgWWV2mcORJqXMnAWO+1qYs3+S1aDy976qjeIqL/rak+ose+h+LqG36QH46oQ5AQc+yOozTErZLXqJyWLcz85Qk9kcoQcgO16eMf7TI/e0O38EpYcKASDvlIe2U1z6Q/7eJ7LYcmEwQSnVKitFg9QnzPyCqo+vmxsTKLKTkKNGdwSKh5JTPf0JPH5VwbW7X0UT5Mi0LmmCulGtcEFXX/nY+K4RiYen/VpEc5dny/6iDq9LIDOES33iFxyYbxfzyMrTCPkcJBH5zyLcHtHRaJQUjmp9hTMMGTwPid4+oC7jM71osOex+Wgy1EYinUwjH5x5k+1CvSBQXL1Z7wqwdUdM3g8g/h1szp5f6Cwk8ObjiShd+xfDf5wPyxZVPqgETzez1N7cuBv+yta9fHtuXAa4fe9H+iDjgYOeFT45i+/3V3g9VHQbgR15rGESY/cDjqsVzV/MQQX6tWc+uBrgqab1Dq3CIu2wYh2wRf6v8GFMM12VB+6l+X5iUQlXMNkn9KDOaUn6kvsFCpXErHP0VOoSrnhWDE3q7Ezx4Ce0ZYXI0TH8ybmrlxRt1WlM5t4rNebcWVZvcHcjDr5Z
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c962d6ad-eee7-4e52-7b46-08db82585a8f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:59.8653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krKyVmx7yGj4nfBTAppy6z7QJZfvp2sXRvcaVK8ue1Stx/piTg5c9XOt5uiHRdGupIIZxxAPKaqcctpWfRPrMnI6qdg8G67bbQuUWZ1WnJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-GUID: zgzKJnj8zFj49ExPIre1rgmpR-_0VDxs
X-Proofpoint-ORIG-GUID: zgzKJnj8zFj49ExPIre1rgmpR-_0VDxs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. To avoid where
sd_suspend_common will access the sshdr but scsi_execute_cmd has
not initialized it and to allow sd_sync_cache to convert
device/host/status errors to -EXYZ values, this has sd_sync_cache
convert ILLEGAL_REQUEST to -EOPNOTSUPP. sd_suspend_common can then
check for that error instead of using a sshdr.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e67a3d163b24..bb2e5885e41b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1604,24 +1604,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
+static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr my_sshdr;
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		/* caller might not be interested in sense, but we need it */
-		.sshdr = sshdr ? : &my_sshdr,
+		.sshdr = &sshdr,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sshdr = exec_args.sshdr;
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
 
@@ -1646,15 +1643,19 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			return res;
 
 		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
-			sd_print_sense_hdr(sdkp, sshdr);
+		    scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr->asc == 0x3a ||	/* medium not present */
-			    sshdr->asc == 0x20 ||	/* invalid command */
-			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
+			if (sshdr.asc == 0x3a ||	/* medium not present */
+			    sshdr.asc == 0x20 ||	/* invalid command */
+			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
+			/* This drive doesn't support sync. */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return -EOPNOTSUPP;
 		}
 
 		switch (host_byte(res)) {
@@ -3849,7 +3850,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
@@ -3861,7 +3862,6 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3870,21 +3870,18 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
+		ret = sd_sync_cache(sdkp);
 
 		if (ret) {
 			/* ignore OFFLINE device */
 			if (ret == -ENODEV)
 				return 0;
 
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
+			if (ret != -EOPNOTSUPP)
 				return ret;
-
 			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
+			 * The drive doesn't support sync. There's not much to
+			 * do and suspend shouldn't fail.
 			 */
 			ret = 0;
 		}
-- 
2.34.1

