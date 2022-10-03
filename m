Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9236C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJCRx7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiJCRxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:53:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D9436DF9
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODGP015434;
        Mon, 3 Oct 2022 17:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IW0dMrPTpp6b6jKffX1ZsG6XTvsN4xd7DFp4ZVSxR7w=;
 b=AEFhdgNoOWIRqD/YAPrRpg8cNJLaiRh+OJ5pSS3AVGCNbUNdN5/LEpgKWeaaMZ+7LDCq
 c0oVrVLUw9gILmm1LFvTe6q1rymnBORTv1Sbnnoz4a1D14W1G+nZxiqBUMZ0C+0oIMbb
 Yu5gw5zyeLyuwRd6TPNDRelEQQ1dhcCumOCvm/bwIStt3OpwJVT7UhgKKsc0ejAEgcqL
 zmpo7jvh/tQ6KiLCgI+BWMkkVGwfAVXuXET6UEbhaQ+w5qeqypKyvlg4cKBM/XN0t7oG
 CF3J7eD7LlB4HPh80Bj79aPfNpgSzCnBqqo6nPQsSlFE3DQ9tRvfQPYeA0viOeO0mnlw Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xk015519;
        Mon, 3 Oct 2022 17:53:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0xDdA4nAGJ9mOZvLLo3NltWchO6Q8i1YyOYlDg9q9IBMVmEGlIoOPfg1z8fhbcChrd6hy0Qw0QG1l2ZYXqmXawkls4T2cfG4YejYeaDOwN0FFHdLDqOS7qzndV73TbtwK++kQnMMf451n4wnD7C712YII0Q3Kp1YY2D+uq3xhXOcxXV8vntH8OZLdvuQkzJL1srZT+ySCPg+wge0YYNI0vMR1xjaGakiHbQ4EomMgBw93bX7ZRtL9YvDW39/ejVsGVlEN5B0t+M09yVlsVzyQicgyxyCMso3AMzleoAh2lSVzM6q5oLObkleXZAgKwYE8LbndlgZC69bDBftOonjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW0dMrPTpp6b6jKffX1ZsG6XTvsN4xd7DFp4ZVSxR7w=;
 b=fkJ4vKJBVtTyxVmhW+c2aAlXBwrrraWj4znLWxlbRDzE/MPOxjM7dWrZ2mfjTawxtES4WHozrf6o9IMfWoyIZ9wueY7hSibh/K/fmiQXofYNYisq3lrhbeu7skdXxa1ttPMVQPj8phsOuk9NFGMqZC+1tJ4EvvH4P25dfVaRkb+R4NWhzwb40azr8tfxhELQwfH77uEQru7kb8Upjmti0OJYg4q/YExBvxZltpwsXH45wI6c+/2USZsL5SRW+CQj1/G0Ice6mU216WsnfCoE3s4iR7mOFKlfOsTcHUuKXQ5CeX7Dl18aKhei6oAZOugMmULaBQr08MrcYYclCZ+5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW0dMrPTpp6b6jKffX1ZsG6XTvsN4xd7DFp4ZVSxR7w=;
 b=MAkU1ZnstK0BstGbo1GpZY37F86Y3i5eP3advP7kBO03P/Z4Y2xcR6c/2bRzO9oReVGwk1x5HErnAqR6Ci8hR6cOtgSx82hJf7oVXPRR2vZxxpwUQisEGwpPic72x52mH2tUfd0biGxOP+YLSMfQx6bqEdOP7g4sy0CQkdfQZJw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 08/35] scsi: scsi_dh: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:54 -0500
Message-Id: <20221003175321.8040-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:610:50::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: a84ab6ab-5bab-4015-e59b-08daa56831d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtkzwZd3ue+BYE6qBaUPN/vpl77Q/AUyA68liqK7FKz4L0WpnBIVFDE2fDvtQKJbBgEwTw0PaABRTFc1759Oymk3Q32oCwBzYhD3Yy/POuttzYwVL3/wamRDqH/dCXaE9rhquGKfLRTTjOjKoHM3RajDtgKboCRFLzE/1rXV8XBt+AMPPGXNDP81c07L1FplElLX+25DqJLeSDsZ7qYSeqWfObgXq8gNGRj6jlqZnik3IMPQ32o8C9lrj2gt062Ia+UWD+yrkQSchF7TiezwnHCyoSQ1ayFUW/b5dYGRfmv2TfDqe9hJOq3IO9cfbNCsFfa7jMt0B+WU/TkGrJco2bHR3Ker4KyzSOXj7VPKDmThyeep3zjAEG5d8i47c59TDX9jMCD1P2voFX1ciw+KvjfmyTOJnKhGMQ3GxnFK5k94FM8B2wLKdkHLDd0/z3sFP6FpZqbeFsflYN4SMkIe471mvUsDeGfnmr37OjWodvTkpOTYj28T2+MQo+cpmVqwDJ9VxbnhwZPRTn3XFHFruOv/cs+XQ1frW+WZDJQdmuB5Inwz30pit3C8dRGI2baTH3rqh2cZwu+fpOSObjwziEH1U1d98cPMQ8sK/hALeT8euPSUNEBO45WxGrIZzKeVV1flPfFhvBxLg7GC0LDVASd1a2/mk54DjTFnUm3ndZ8WCi59Uqzuvi0+HPs6txSQnFENh6Bk8gYEbQQHcqel9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jt68+QTeUqHpUdt1WTuAkdCZEyxe0LOjC0MG5+rO+ep49/tmP+gZw/GHwTT?=
 =?us-ascii?Q?1lq4EL8d4iZDM14QirrcmsWBkUaAjeBFSEwcK3uxbIAgvkZGQnOSapH35uC6?=
 =?us-ascii?Q?o1ZwL4swE51rXrPKZECicQ07Z7cCZJO3TFeQJhh5YDcwzYcho+wzVwMu/TSL?=
 =?us-ascii?Q?X/KE5WxaOzeZZVYGur0IhQUmM+c+bs0USelnbmiHDIVuvf480/KR5qdGYbKd?=
 =?us-ascii?Q?5q15rKJCSQTUeIjUIL5pB92tASndB0rEHMggcxGbT4wi5cL5x2CjJoGXsV9w?=
 =?us-ascii?Q?Kj4uVlh89FevRbqKXWN3CA8pO9LVWUsxFvQwL6I6YrUsOGMCGIxTxgCRDkzo?=
 =?us-ascii?Q?/wijgN6h66IlQQZBCiHkgRjAseZxKW9/CgNgqIkto8zgt8Bt7gaqkiwDf+HH?=
 =?us-ascii?Q?LFLZ3TaXHIIym5tJI3jr2bqHWjQq/UOfhfgWx9AqtcB+l42dtxHZJZfmIMJa?=
 =?us-ascii?Q?tGmIjhWoj3/fL1z4+tffXX4zsbVvZqE6uYod4kCCzbPaYdekVUiatwoqjG/q?=
 =?us-ascii?Q?Hc/WIFO4gHTWBtqx78vZLLFtxXb3V41fGQ6D1Gvoi73uERpw64OLdMxiZ4A/?=
 =?us-ascii?Q?XBi1iRzWOhWG9FIrOyxcOKwzNdoUsTfHxhyDddSQWUts5VRFrd1PFCWXLrjl?=
 =?us-ascii?Q?RI6c/CDhcvfyq72gCb3oZR4PV2yIq3x4WtCMNP5ZHALMXZi/wsAEfc8NIx3K?=
 =?us-ascii?Q?mCb6ohWM5ambAoeqmuKGntpS8sw8DLoLMjzK9asgRkObtGa8oa8ecEKCZQ5X?=
 =?us-ascii?Q?z6kGMAkvEqtCgFvOLeeDjzNIT3i9RfCj9qCQtBuVlJf2KK7kSWCwuN+xMoWy?=
 =?us-ascii?Q?Oey0AZpbGwjXgrx98/dVrX4anA7TB3hLhcI78bguVllKJkbV5PI9bHNnlRWY?=
 =?us-ascii?Q?5d7b9SUz+uCtdISOhfhYemwtOkx2jSy6sh3lseaR9QhUOaeVOuah7x+PrvZk?=
 =?us-ascii?Q?hswsNMndnK+YfjWyBpQ+SQUY+mfU9x4GqVDBAGWrur11mmX4EKwfEh0dWFgP?=
 =?us-ascii?Q?0aqv+IAMaHoEspxt/XqAd/FMaalmlBpMfYIM/ulWgBmo5s8VvQ+1teXRXfaP?=
 =?us-ascii?Q?9ctrIru2WIc1jbYiZmErD95ehVM77J72BaTgPVA4af5LWuXlMFsMRP7PxVqM?=
 =?us-ascii?Q?z3WPt29OtXbwI+/xoSte2JzfxapfZev36SgusbesnYzX3zejZQKsjz/PPcZC?=
 =?us-ascii?Q?N++5QaxpKo7BQ/kObgS9EHf0hDf9F/5kLrONNsfaqW+59lx5SrVbAU14hNqi?=
 =?us-ascii?Q?fko3IbmIbied/H22dsc+8BG01uWYxp7Sg2+HP9rsOeNCP1gEuDo7BSHVMcLx?=
 =?us-ascii?Q?2rjtg7AEqeHso0+BntsOPaeMADk/AMq6gVeNuxcOc1/t9SWatDyLrBoKo4AX?=
 =?us-ascii?Q?cmM+chdsJcesQWhsigcJqMrLZl76eS6/TOFz6KjeQn9VJzizOVtW0jQUbAve?=
 =?us-ascii?Q?nJswHMQs+x83kLAQCzH738BfTP0aRYpn6Yv3U4lGFVXfk5g1+SchDXPmMOlV?=
 =?us-ascii?Q?wsxm2bMpwspL3CFbvwEmilbIyAL2+0RhJiN3I0yplMBazGr8dDeOXT+lgYvy?=
 =?us-ascii?Q?H3pe+87L8SQVZ9Wc3GCcHDlvpchukBebaGnw/3HyljHCgpNKqkOE7UgzAYmv?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a84ab6ab-5bab-4015-e59b-08daa56831d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:35.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSR6KxHYBPnXG/EqAmzb+o+XdJ/y2aIc9TMLlnE8XR5fCnbvJ/x49yJP8wAuF4dIssvk/+0GnYXYHfVSdbn/eqzSpojT3mK5RQLtdk7+2eM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: QfCkBhfp4yhV-LLbwLxNJCzuwqnMDyJT
X-Proofpoint-ORIG-GUID: QfCkBhfp4yhV-LLbwLxNJCzuwqnMDyJT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 26 ++++++++++++++++-----
 drivers/scsi/device_handler/scsi_dh_emc.c   | 13 ++++++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 20 ++++++++++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 15 +++++++++---
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..e4825da21d05 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -139,9 +139,16 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buff,
+				.buf_len = bufflen,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 /*
@@ -171,9 +178,16 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = stpg_data,
+				.buf_len = stpg_len,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..0ad6163dc426 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -263,9 +263,16 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
-			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+	err = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = csdev->buffer,
+				.buf_len = len,
+				.sshdr = &sshdr,
+				.timeout = CLARIION_TIMEOUT * HZ,
+				.retries = CLARIION_RETRIES,
+				.op_flags = req_flags }));
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..adcbe3b883b7 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -87,8 +87,14 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -125,8 +131,14 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..c4d1830512ca 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -538,6 +538,7 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	int result;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -555,9 +556,17 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cdb,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &h->ctlr->mode_select,
+					.buf_len = data_size,
+					.sshdr = &sshdr,
+					.timeout = RDAC_TIMEOUT * HZ,
+					.retries = RDAC_RETRIES,
+					.op_flags = req_flags }));
+	if (result) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

