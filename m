Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABE3C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiI2C5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiI2C4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:56:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C0411E0E6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1T88W018191;
        Thu, 29 Sep 2022 02:54:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=u161WvevX+5j7BKfsOo/pm7ZEhl+MUf9Ydb5jNnekK0=;
 b=nZW5Qz9NYwONBrnd52XaNwlDQy/mwnagduochdLrDBnFXz7ZqkbtGcZxdOUbb53zO3wk
 s8gZv0+kWN2qiHMOSRp0zLJaoZsxshIFL/d4I9KJ/HwuUF86U+TOC4umEdPE54DEpKuM
 nbaDfm1rEerctFRehB5GIfM9nic+ZIkY63mNuw+vZo2/78dxfjY1JsMihG7faWpRh7P5
 6ft9X9rcZKaD9xeWohc83o+6RgCfgZHmhNj5VXiNgBQm18PR+dzYf3DwOOVErGCC0RdY
 f7oH03lv3Ryakw6S5pA9or9w5rcQn4IoYxELv8jl4bIED6QtCfZjNvR63cDg1uEGlJNN sw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet3uee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1aFGN036988;
        Thu, 29 Sep 2022 02:54:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvfv4tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajnW2bohi4jSaIkd7ZSdYAqtzr+E+h6fM1CHSipUVCBfepHJPwS7tGEYokzm5jhqee5i+yA6Yp7hvo7PcVLzf2wQqa6A2h6uUmT5ep9WzmKr1h9ZUJ+8dyMv39VYafzo7lq+nMj+bewHpuTyNVPc50ZH72bhDFfrm9l0DKvh/JGtO5uvMZWBRkpC9jTw1H8mmT+wfF98LdwYCw/u2dH3QY1kX1nP4YqkathRcj0inVOdKzh49tnRZ/VxXgM1/LuLdus5ev2SaqnuqDTRDBSGaHjiO6zHCOWdloSKWs6mOfbDeEFJ1NxcCMR5FLcj2ZZIPm6tHoUEZSmzUCHDQnB15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u161WvevX+5j7BKfsOo/pm7ZEhl+MUf9Ydb5jNnekK0=;
 b=WnjhQ4wUB/MO2FFG1Qay1m6Pdy6FyS26/GDcblYhRh1BbXEoGpnDg2Q3wNuW+J/9QesZLwp3D2oZjEaRVHR2kefTYqRzpKLI3Wy7mpmBGiNrPEhDfnGc+5LRM1AdlTX+awHJUl/SU95F7SKUq6lWg5dvKIhin4sxtZSiIk0vuq2BHCk1erS14kwBfnU3mpqI85dwz0hv4oxgAPa0cw740L6pQhXGcNDM1JOlVtEVvHWJk2K1YVWBFptWQMu1Q8x5aHO5YyPsd5UGKPBqW9TSeBmeZTmpkj3rgrmABXrtOKVNJilG2a+yfLjTM9CJi06ho51Da0k1kgaGAHQTrQODJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u161WvevX+5j7BKfsOo/pm7ZEhl+MUf9Ydb5jNnekK0=;
 b=wYX9E/MyOwY4P/YHPQhn8h/V/fiW0MdZbTyBgHIaiDAeamr3c8o4hc9jT81vlKa7+u+4ebGz2l+LozC5Lc2SFW74yGJmMMXakExak2vsTUOmfrJKBapbWQSj/PdAeIlHJJcnbUs2NkbMpPLAc2SJEGnWS2jtpAk2Fy1ZLrNqEdE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 15/35] scsi: virtio_scsi: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:47 -0500
Message-Id: <20220929025407.119804-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0063.namprd07.prod.outlook.com
 (2603:10b6:610:5b::37) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1a332d-8337-4ede-6231-08daa1c5f127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWtOLm9rFyOruWQ2R4lVCD1sOW4CNHScB2TP3IX+0a2E0mRjXIhUkELab1RboLdFlo5bP/rpRHDtVEuQZU4x9nixvyUES5+tNR24Ww9lh0id8f0yd3bZAKL3sICbBPc31jBTt1fhWZVMuk/8jt/yPZ9tK0Xg6MLanak6jZDaxFN2Zad+yX2wTOilGIWIupdqr6zngQ6ceKt8l+oDKDQdd7E1ioMLwWUyERV8wZpr0tcrEDIEBp695FVHNEVKLZmPz5S+f5XJuA3qmd7JXad4oZrlVcV4DEqVXsA5l1TjvNAWedVf9y2Hce78tvxSbG9jT1hx8oJScwNx5GrPwOYzMTmvtnNHY200gfTsn4g6Eph3ey3OUaOIY32rRi+E/18rpkNrlnVhtOUvRrKo4CeydfZoHtrF4+4KDM/EbDQ38it3FB+VdHtKjhYdRwj7fbLtXY+HHQbIm7PYBdgXG5ZernvOy1i8pT7d84PulTymx5kL+fzqNCl6KTbc3XpWoLIJY2Q842CjoxSNd01C0tvCTuJa2hao77Zwk1u9IPrASjkWGF7cFbczwPYSXXshMgUPEbrxeHewG2VKGHd7HeZdnsPLUcysXNX00IJHQL/CvQ6SxWr38KsaXYCo2Jp2AVXQh6uzpAtzHRoXgnZty9VhmbizyBjrZ5CLS+HxJfTvqW17Yfp5AQaA2/sX1MshzAVV9DicOy4yqMEWS7uzu9+NJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqjFCmShGr2PCUwwu4HJaHW08YgDKbGDizFVDPtHZjEYIL2RfkVvX2WScR1v?=
 =?us-ascii?Q?UEu0+5BK6tiIgzUwYuVmwzVk1VsiJr8YE1wRf9r2b4FM3Pwgk0T3g3HNR2So?=
 =?us-ascii?Q?CABZGfC/1UK38QlURsP5fxJkeXJVQj4TEczodfdIJCDmtH4uzlOFjBZeE49P?=
 =?us-ascii?Q?EO/uYgaXSSBjeXTcAyjONoa758P5JY1nfdaVZy4lWJuz9tgmeObvHS6+i612?=
 =?us-ascii?Q?GPTSvSnzjRT+VpF8Zxg+nqhTaIIiuy+TdHoXJQyNP13fbRFHh7YpwhLcZAK/?=
 =?us-ascii?Q?H7zv+xJQgo6a92Yg9oDKMrCuDYKmgFzv0uczQ5Umr4chQjtFeCbZDn4tFLHp?=
 =?us-ascii?Q?RqoatNbVNLkBKwQuuYKtLc6I4DLIpvqIknoPQgv4i3v41LVkPMzqndTUC7Xm?=
 =?us-ascii?Q?HLZ5AOdt38og2f1FMDyJXV6pY4sjriqw4cCRJKM2pIbGTq4OgWXnuqweJRzJ?=
 =?us-ascii?Q?9n9zAUDwf7FujCIa6VKtX7QgjcYUcNFUlPwSlquHiSeAWlOaVEC5ck5WkfVC?=
 =?us-ascii?Q?jeYYRs9A9cudlP1kOcsqNL4urwYOoXkarRICwR59NPX5lsnbPTIEkNI/mj0N?=
 =?us-ascii?Q?CMydY2rJ6+VtE32ZxIG6VPcpUOv72/EUSaKStRZenelusf70miPof5yWIJey?=
 =?us-ascii?Q?idCDjAogDwwkm/OteADPoDyjrS5D5avwXQ9+LOWbucvRaW20AdGmJjEpEm+k?=
 =?us-ascii?Q?KKLcqzBZtHIPpXkLGcKPLQ94/vipcgi6YVCMIkCKbhpBibIqlmlj4pNX2ydK?=
 =?us-ascii?Q?smxU8V7DKtWdpEOpSY879By05jjQCSoMt+3oNjnrU20bY8KiHTKt9WjKRrui?=
 =?us-ascii?Q?e+waCCUNTErCAcZP1kl99LlKxh6AvJyMxvKb1yGcXUK2RygaZy0js8+Pi9bI?=
 =?us-ascii?Q?iWGD2c1jwHKgxYrk+PwcX7qnT35DTkcDUZc/3nag3tNNXPSxrEfReVAk6iPu?=
 =?us-ascii?Q?vLRyslnmh4YNJpI2ele1W+7o6iTYEsH2s0j9ywh0b1Ay0t+J6ptailooSwm7?=
 =?us-ascii?Q?IqSsTD+6ef4rVaxOKd71Xli2odMaLpKJb7n42mphj+EbXsZoQCS/yAEy+cs2?=
 =?us-ascii?Q?zTvpXTzymekSnzwJZRrNiaIV8r5RR9XzKfczRUFJkIinq1bbRuJJCcKWJJWR?=
 =?us-ascii?Q?Xl1CYyeDJ1jn8NrOTytpJ2v53YTFajPGkvTEnhnlsION/S60L/qvl2XGNkU9?=
 =?us-ascii?Q?6q19M3x/nuqJBo0HL2dr/IvY9kzBYSO8kD5+vT+qQXwZlznDopxw6Qt73xZj?=
 =?us-ascii?Q?JJFnIstJsXHzuGuzsnq/bq06nwIGuw898FKXprBG6r9y3NcYT7uqeIm03FNn?=
 =?us-ascii?Q?gwaTfo6MeozrmeVgDoYMyc49CyZeTgDVUObdYD2ZW+wrl9yeljmThhZ/qWwy?=
 =?us-ascii?Q?AQgynxxm9z/Fpr/aQKJ5f3lYIam5DuzCvCkq1Ews0LoJRjzTO4EwbEMFAiL4?=
 =?us-ascii?Q?2gjuXGXT68rdAXJb3ZMlidwn8TTE6co+hUEVBrZ4DhvQ9TWQR/OLeYiQ0jpm?=
 =?us-ascii?Q?a6pDNrxFGPBzPF4Q7xFBYQaC/3VQWWZ0hKAaejUVmbZz+XwVQnHJ3bgCuCtF?=
 =?us-ascii?Q?NLroiuic90QpZL1HJUwjkiwGSqiz1L2gvH6gIiU1X/gEQ9m+NDmPlPGgLjTU?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1a332d-8337-4ede-6231-08daa1c5f127
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:35.4115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: so1kR3p8fTXRxCFT6KSTU2dbwecTILtCSC7BBi04wE2NDTryE2JVSbMuOrZdlpepY/fPA+SrtNZ/29sX+XIAm8HrsvKad+O4kvqNRDyFCNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-GUID: ccFoWWLgLldgWtHWzNy_O9vt4TLCrxb9
X-Proofpoint-ORIG-GUID: ccFoWWLgLldgWtHWzNy_O9vt4TLCrxb9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/virtio_scsi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 00cf6743db8c..c86a3c035374 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -347,9 +347,14 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
 
 		memset(inq_result, 0, inq_result_len);
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, inquiry_len, NULL,
-					  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = inquiry_len,
+						.timeout = SD_TIMEOUT,
+						.retries = SD_MAX_RETRIES }));
 
 		if (result == 0 && inq_result[0] >> 5) {
 			/* PQ indicates the LUN is not attached */
-- 
2.25.1

