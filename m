Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD65DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKDXYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiKDXYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:24:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FEA6267
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7dT014044;
        Fri, 4 Nov 2022 23:21:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=Yb5frqM4FEYtQp1ANve/HHWeXssEyvhp12zvdwQ4ZjvMTV7tyGaBn8zhLjEho1NjJz4a
 vgo/OBxeA1R+vKmRfoTlpfkAL1ckxgiAWhf2WuGr6L8CEt3TupUgyD49G+SvzqocPPPE
 tGRub9kQ2cfDlmBaSCnr1J7D26iN8jjwRqoPfWDuUk10WzuARgBIKi8GbmGqyw3Y2HV3
 11k8E+fwMxd9IC5ph03gkk3c6eZriUvlXmVR88Zyz0GrxESMADkn74KHFmK98LBOe/E1
 Nzwki77pczuGLbfkdc6TvqOP9waolBxzbv25cd6fJdkPBf0sx5EEKeLSVYqHHaYQgV8D Ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts1hgy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4M1EUU011983;
        Fri, 4 Nov 2022 23:21:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpwn8ctq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9Pu4bUdFjqQIkABU9GJvuhbdY/p+dMXkka1qEHlFKihjVSqyCXQMFEzgQ6tDFjw/3Uv5kdHka6qw+4NtCQrfNjc5DZBDXgvpik9mjDNi0GpUY2SmlqOsgVnlna4hI4pYs59UzUvpS0mCX6lVxFDx2crW34dkD72g53TBojJXNz+MZehR33PGdkGI7OQqFIOxaZHr8dZ7v/92WD1EiOsxx+S3HlzEj6/Mhwue4R6Xs3bVcZg1aWXRQqhyFo++muHjZUwNXaRgaevg5AADPSelXXXBrtVa3OJanEkmqao0cQRlHCLALG1CoPDV2KAxXyB76fAniAb22udRkeAmw7nXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=IUkOk7hUEQ2IJcInAcaxeQ5A53qF+sJELCNQkb7Pl+xgUO74CMpOjkNvMpWRPL+UvXmzMU+g36oV2SRfPKnzcoDdvbP/9dirw0nONwb93SpRFzROMYOx6MlSz4zaMRyrTkcr3odGHmY9SP23IZh9e4NsMbaSB9xJwD7n2RiTMsPvQH1IFDUtXTR6No/Nuaa9KKsHnUFYu+cq8WHVRLtsVB2ptw7CPaQ8DuHtpg6HscQp8+CUSfSR0PdP02Zo3YxneHLFXXHCzWIOVCmdFklX7LnlRE3UrnIMvz7UYYw2nTSrnQBxPY952U/oLw1UP49xrnpyEq2HLBVovlx7HOpHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=CoEHEKG/jrbChjUXj1U79FnUY+4KeW7FrlB144J1CtArUWnU7BDFg+7R54YD1eM/jSWcwDuyJXAJYuzZYH7t8QY3tMec2a3TTsFPVNQuUzGx2Gp/JyB6xK6zZDEjy7STrLBAeXCtVNfG7Q5t6v18sgT+4gzCGnmUagldt71V4pc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 14/35] scsi: sr: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:19:06 -0500
Message-Id: <20221104231927.9613-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:610:74::23) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c92633-1384-4816-fdc5-08dabebb568d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qUn6m0fLsj/maBhlRO5wcrYEjYaHtjalO0e7rSV6SF/zhv7DAX9D3mvbdTlQfiOzNQa+eHNvaaphJt3DByTl8zHB8dZCZmT7VuxguPi6uSQiiw6fYyEyHbQLNdY/zOEFM13C2S3nT95jxogFGyDKbrxGax3iaTamXS0Z2sXy+7lbemVKi7RWGnexj8ntowtHyorotwtKMBUwoWD0LYSffYDBlDQJPmzfP7X1LOSSJSr8cL6HF1hyfa37ALUTeuOq9hIDT4S7lKWwTus6KWFCxnfhs49UwanmKFp1fy+w+EHUNlbwmrlbJuXKSbj5P7KCJPKffH9QjsSeory/a9tmyFDoZyVBCOzzX4xFeZBZit+pMi6nMDTd0/Logr3BUYMsZfDiIr/oHFvoqG0bMjwwUptFmGlDmCTEA76CaR0lLtRKm+UYcqm85g/dlT12hU1MQMK4biHWqtENSQIS0io/2QM7d9fgiEuWnydd150V9c5FCYikW79R8HKFfcUfcW073PNP3h7MOdMbXAjxtuy5Zn9Tomc5kuTJzzXkBeMSQG4LQTcnodR9XPXl2kSbhURhlpI1f3DB2OBA3ZYiqdtFyHkJsVoi8sN2HBp87WdTfpRmmIvlkWr4zEFdYRUZtI/wAssgZvQBIaO7OgdfXH8BOLbzALwmjcMkrcA7+i0BudeQNDj3YnDCoOZ7aL3scSmmlqVGFEK1GxF0VV5PHHmvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5f5+fEb8Wk058Bwx9TGEMvuwSGVS1YvVxUpZVu2V81XRcWftY8mzPA0IbRZb?=
 =?us-ascii?Q?8CfUNfAPpTTUDR8I2GkRdyidmbReyKoVbB0LBoa7ZGkNMd5RKdvgLQ24S9Iv?=
 =?us-ascii?Q?kngeSrbguBLjeaUKLchKORExBhpK3p9qgp3VuhRKIlN6nW9ZxpAn9fAD3wCT?=
 =?us-ascii?Q?ghGA3Kdp+a/aGLQ7rOQMf5mpmnQtrYFxc3PxXh38aUGQ5hn07Jggbm+RIfQs?=
 =?us-ascii?Q?G5UWkvjdBVDIuqCngEZUjHgABrBRmOOoVdzK7SJg7Fu4UTWHlnLbQu0e4W0f?=
 =?us-ascii?Q?dS6Kh9al0BvJyVpGNgQL3mJn4VYGLE83mw2loQBu1hlS7Zo9rklm2xF+p1ti?=
 =?us-ascii?Q?yagB5pmViaVdV2D3XkL+iZbjdOfhijS/luFLl9nyse/ZTdVOpGWjCzXTvwto?=
 =?us-ascii?Q?8sqMNHmgE1Tj0RKvmxmI458FoLpYpslzbLEGJFgbeVVVo6XqLkRZO64FWLt8?=
 =?us-ascii?Q?nGraC9dA+VSfhUHugS8MU6falEAPrrKvLGlN2zcbAYg/g9J7Swgoz6oQtG2V?=
 =?us-ascii?Q?PFYO6wQUjtEn3ZXAOGmCyknP/0eg8ISmCFxGIJGpoWXE0z3pO7Dyak8doee1?=
 =?us-ascii?Q?ZWAoA46M1JgoxOBZQTmwTx6U3i+JcDj+4i+5nWl7ITss4+fZyIg7A2uS8m7I?=
 =?us-ascii?Q?QkOW2co5IJFSzPFaGW2Qx5MBmDqUXofRqi2WO3SEZQufJYh9XGFy5Zr/Ydxn?=
 =?us-ascii?Q?e5T8BWLgs38MpgtKMoziqKZF6HVx1ipGnxus4BuFlM6W9GLIw74Cb/0tZm2S?=
 =?us-ascii?Q?3k8QXMbm28iaV0LWnfEYr1cbktdn03RK8bI4K/TuaQm52BL3SHN7YDpo5B98?=
 =?us-ascii?Q?rGJb/Q3yGBHqFfCfo1nSuDwGh/GvGvvcOoh4U+ThRnrdcNu7MC4Lgy30CT3g?=
 =?us-ascii?Q?Tv0iQfyXJz1j82qDddPHa5JW85pkc6K/yiGUgUo+9d5ykhcEcrYw6tfVP1qQ?=
 =?us-ascii?Q?+Nvc+32NYMHKrQ+LJgPMsWVP/OkEmyvOHlJ5AE67Zpwt0hp7Om0g+DMMLv5T?=
 =?us-ascii?Q?U+47R/alR9vqKuY1eVHnveLpO45vQZl3BSl6VzFjhhvSepQzJF0cyis0d1vc?=
 =?us-ascii?Q?S/t6DVKrMIz4vGeeRs9O64xApPF22YQL8tC1/f9jYxwEiojACbDqsOLG/Jj8?=
 =?us-ascii?Q?hJxBxbjxRk7BWyq9lpf3iOdJPQy13qlLVGMCuxuGfreUgknifCOEJTlNF1xn?=
 =?us-ascii?Q?Q3BD56sXFPHt1rwD+DXVqfmmyIDzADHZWLnSgNeURldgHrskIe0RxgOr39eb?=
 =?us-ascii?Q?GD6aDVLyflxJvnTTC/+kvx5Bel8r3fvaWQ+BHS3qD++tf4IK9xaveARG1eQD?=
 =?us-ascii?Q?TkubxO3qGywMcxsEh2uIEfUucOoz79HInEhCyWYnpP7S9NZty/n3sL30xGd6?=
 =?us-ascii?Q?Ff7W4/pe0tKwzUHpT50ZAZ71VKdf3TYushO4GCx/hAwxWzv6ap6xEV7OBEaG?=
 =?us-ascii?Q?f5Ai3vRU+UZ+dKIXl18p/EolOjbwdd18vMGTlXf05EfyH96TLdWjtuZ//L0s?=
 =?us-ascii?Q?4vn75kycETPfBlsJVSW7pdh0bCfJeFwjSvvjAz2HbuNTyVsFghcWdZkQHG+x?=
 =?us-ascii?Q?3GCHNmg8HmJ0R+tM/t1nyVxDq8ZUMoNuEVt5h6mguE8TGex7X3SHfXtFB7xe?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c92633-1384-4816-fdc5-08dabebb568d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:44.7748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IHw8WOOFD9W64pRQ3Ok8acs1IX4J+3ARlj/jkKGtMPAjiGNDpd6IGavhu9wDN7tL/QNutmLdUV/ieFfeq0ET4c4zULdj4NTFpD8eH0qk7wc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-GUID: wAz_arrwn4Mgpbjpl4SX2_BefaGT5PGX
X-Proofpoint-ORIG-GUID: wAz_arrwn4Mgpbjpl4SX2_BefaGT5PGX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c       | 22 +++++++++++++++++-----
 drivers/scsi/sr_ioctl.c | 13 +++++++++----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..e3171f040fe1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -172,8 +172,15 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct scsi_sense_hdr sshdr;
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = sizeof(buf),
+					.sshdr = &sshdr,
+					.timeout = SR_TIMEOUT,
+					.retries = MAX_RETRIES }));
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,9 +737,14 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = cd->device,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = sizeof(buffer),
+						.timeout = SR_TIMEOUT,
+						.retries = MAX_RETRIES }));
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..3d852117d16b 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -202,10 +202,15 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = SDev,
+					.cmd = cgc->cmd,
+					.data_dir = cgc->data_direction,
+					.buf = cgc->buffer,
+					.buf_len = cgc->buflen,
+					.sshdr = sshdr,
+					.timeout = cgc->timeout,
+					.retries = IOCTL_RETRIES }));
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

