Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60416C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiI2DGE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiI2DF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:05:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FC880503
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:05:56 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiSHL020728;
        Thu, 29 Sep 2022 03:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XnZU5VcTWwg8nXRCGgjlKF6eSM1/5osmWkzJlUV8cL4=;
 b=qP82HQcnA+AB/BnnPb04RfSqtVoAPjvDGXqHkQsdLV5Cbdx7FEBUSQ9jxzgAOXKiM/8l
 a9CEsMA5cRq1Ss8oarDte94KVWiDdojxhuweiPOeAu0n/zHR9r1YE7Dr+8r60naQ1PTf
 eRqfc6wL5t5h5YWoxs5MTywGbBe3e9vTBfpD5TyShy7tiSDdcn0LYxTuJaJqMKZuF9xU
 otImB7WAxnDPH3RmDpWBOjUa9rddtBXG3GdEbeqRoM2mBoEK5Qamil6Jll1KFbKS/AdW
 b69pceagY/n3rhXLj5RxW6evmb6vh8ekZSkKdVbJP+qpdyIvKJFZm5A5u0h2+/niA2aE EA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:05:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T2e3x2033544;
        Thu, 29 Sep 2022 02:54:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22qsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsvARNslsKky52Dq5dZHZPNA6RaDfZTtgOC6BS+QtbtVostZuyFlyaxj/cLTSc2P+eLnIO+av4TsWPWPQIdQPdim+6Ehx/z8jO0p5c6Fvup5Q9mInl3EwKyn3zqWWVEBOrcyBFWro8BqaUOo2Pi4cMDp0JDhkctAe0II7u6+t86Di9mpcDCTYQUH6Ot9+mO3Os1mMkT+wNBucY3eVz8p5FPoQkx1r8fqmCB9Lh+neB6qXUlE/rRwoqceyeLM9+3fbBbzaVbavHaNrzHweR+YoWyc43e2H1QI5kt0SLdXyS84d3k+CKdgNQ9ZzUXPsj635ftKsCAbXX8YkTHBkVYu/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnZU5VcTWwg8nXRCGgjlKF6eSM1/5osmWkzJlUV8cL4=;
 b=Pd1Va0yIlmzeW74w4dMSSHdgDT/RdWVpyUNdB/+Pwlqtjf47stE3BImqo10mt2Uklv9G47YPdbtzhYLjoOaxSgERpStk5vfaELReuvXRb+7zou5hcTyk65fs+9vQAct5KwPFU80+PpYPKmzmrd4G1Who7zEKkH2TUTLU8ARO9hCVoGmFJRU+ESh1PKboO28PfAyDftD/asgHQ+4Q5hm7esS1SYRy4NzTrYnwMz9XnQPyDH9McLCQA6j3HNsd40HJGNh4RqqHkmnL7GN0iIM3whrUYwZtt/dJMSRw2AgROEh1Do6kd3GbXJ9EFYFe+wczspnPo1SUK/yxVRn/W1UXVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnZU5VcTWwg8nXRCGgjlKF6eSM1/5osmWkzJlUV8cL4=;
 b=fLNJ3tM1SEXPnpDqn7oBAGt/nUSIym9sPwXCf3DiEPrYNfR7CBiLRoLKMUufcCCdBR+DloqeuZvAM5U5NTAQfvbNS2UBTZ01usZZ2Lv0tGL2hXcVBDAME3drklCkt3kOwaDPjupDtDG0NRz0DlD9ShgltOTAryosDqkAaEXUFxo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 11/35] scsi: sd: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:43 -0500
Message-Id: <20220929025407.119804-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:610:54::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: de18095f-9265-4cf0-1330-08daa1c5edd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qvri4mYn7Q3p6LFsNOsN5TbU5jgJMWNhiaqbSXJjU1rIXb3SFnfbrcHTBSp3B1EbCwaHTfhyMM5wPvXbZDccW1Yb0RDK8Qd8DwfZPyy+V+Tw7mwHkbrXs5OKe/qEjy3ZRar8dfRdp2nOIh2CC2HAZKi6HpQeCWdgVTP7niV25PlqXAUPG7fUpA4vYQvmgpU6fKBBV4Euac+3BbbrRuG2MXgVbsOcHxWJmvHgbHmuCT9ZZOzjaIfzK33od02EpsKI4eTIE2N9vT6llfeDPorJJqjvki1oXEdAN61SAsrhzxb+LgSRZ5qjGOv3beKT8cX7KluCjmhljSsxYYzz8cpe73gO18fL7D9MY6sLPiISv5cze0uzF7yRve6OgEWEAhuy80hrXe0P3ih0Ay+V1l6PAFPaAK5Hd4bDDQ6yjj+1SZ/CVURoy9fHLew4s3vJVj6xShbydXPa6aQytNtQCe1GJkirqjUnHXKV4J879ELbh+WxOLBhmU4+sQ8pzjRfsDbA8SE+x6OLQr8MGGZewE5VueRKkTmlZK5kEn9aaqLfuIEvI2uVatfPJks3OHiijl6CBELboeGB+9NLYG4qdtEz8CkW4DgKq52ongRSdhjC8bV+EHQswPb+FqkJq0S0zkqZk9hxpXiZaU9VoZT4brTzuyi3UoCiVbqK8oKNTdoyi2w+z9rvQbfUkKLZCp6H0n+wnl05kglpXAhJKq9IY518jA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s5wyM5E0QLVQGk74IqZy9RLmjWkN794mpfjA+NZpppR3XYIL6C+enYecCu9X?=
 =?us-ascii?Q?UV/91Axj34nWWzFlxeG2zHZBNQy3UJWjYPVhc534+Y357AUdqfjdCgqL6sRF?=
 =?us-ascii?Q?pRt9kh5ImBn4vDxGJG/EOWjvx2gpLS2cSC6U4NkB+B40laMGjXb+SK7W3MUT?=
 =?us-ascii?Q?I1K0GL2JoWLMNInJSw1GnmhFWSR96nTPtg2JxwNcIbFeNMMll47EL7lBeq2+?=
 =?us-ascii?Q?8Jr+GM+YBZDpt29xO2vIZnued18BhtsWaLzG4Bdft7YXC9ujPhzrGrmWPEt1?=
 =?us-ascii?Q?TdJJ/xk5ENBNiJ6sPVR3ouNJaXDrrUV7QZR04Fw8damx7wQ3Bb7UuKlWAd9J?=
 =?us-ascii?Q?9o2LqfMNERi+86FwGCm/xqmwso+X51jv+1Rsvor9TD7R7hThuqAuxqRpDvR4?=
 =?us-ascii?Q?w7gscG41jdDo5XFVnW3g6j7X+9UFOMhd72YAEcbXsS91D2AbH/dQQ3o6Mi0j?=
 =?us-ascii?Q?BcbMps7c06c1q46RW/Nm6RgD2911lkOE/5n84QjuSdFlBEgY4wENw160ihVl?=
 =?us-ascii?Q?E0x4UhsLMszmA+AqNverB7zQoVqcey8xUhKCi+VDfYO6Bcq/JJMt5XNnJWxj?=
 =?us-ascii?Q?GOkl2Usl1Hxo4p1itgBa1ge0zfRwZoMzAinbRDV+Q6ihLB/ElUJ8Xq5cJftO?=
 =?us-ascii?Q?e7mT9ZvMOSHRj7Vl7Bpn/Uqtd6E9xfS78S+fswZHasJuY8QEwukQPS1eP8B6?=
 =?us-ascii?Q?pX4APOmFgfrnv+V0C0jFmsIGQsiHUzpuSxQGsuoXSyyP/zH7EW2Shkwwd5BB?=
 =?us-ascii?Q?oOzYCDGRitQMDrJ06UbD05k4ZFUXSApS0y07R/E61mv6qiwpcK2MYtgEOd3s?=
 =?us-ascii?Q?hwaV+8Zaw1gq76hDcCNXyXec9iaTeNPWCHKniRdilmUGcgU5YAzCFVkeRJoU?=
 =?us-ascii?Q?AjfZM6AR1LuPOreOzqLKwjAZmzj4AjlBY2kLqpYtLDncUpO2PXhxLFIsR+6d?=
 =?us-ascii?Q?wf/mmyGK6n5LMfeJrBfoH4BgoDSB99wsrDz6mqtG/IPeQB+bJdFIVmz3h/yk?=
 =?us-ascii?Q?7UCarLwTBuRhz++zFQdL28ocBYkGvkya+PmWSj1fFAEiPlaP80RPOMqmy2ia?=
 =?us-ascii?Q?49K2iXcCUHPbRmLMXxHKRUZWpptTQawOcXNHojIGhY6vL8Z2F1g8t4RFK1Ln?=
 =?us-ascii?Q?D0K/uXX69I6Lcb2YRcdxiXJz0m6PDp6lbXBXLjUm2GtcXm49BBPH5CdADPFh?=
 =?us-ascii?Q?C7CvxoX+yi3wzcHWS+VatH26P3Qfwk8SRhW1xOxidbF+fSx2lIzzBe0b0I/O?=
 =?us-ascii?Q?Lvk4WQhJ6TyOu/NOlh5kCpa1biNYtj/+Wc2O/1X1UnGMOk9hvVGq+sKBnIUq?=
 =?us-ascii?Q?2iiBcUu2nEdvh/72Xjgcl68S2ktjZdQ2bDl2YPaQzBgGhNuYYyAYAMjolhO3?=
 =?us-ascii?Q?jrtCv/Zzbcpj5k5672SPdGp2My8vTZIETwe8UV8OLsBHSF6NdMsntNHUH7Tv?=
 =?us-ascii?Q?MSvkE/CSN4fXxANLXt+AN8kjdf0S8+Fe9L8hx10OWxJsVCh3+CDtotfac8t8?=
 =?us-ascii?Q?WcklYocA/VGrqE12HwCIE/yGikeEzWeEjpEW13A7a2uvGzrqQsB+t6Td3/hU?=
 =?us-ascii?Q?Vi3PDsn+y6eEyuazIg0kgw9LrVT02bRm943K81XOlHbAOUD2RdqAYlKnHpwy?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de18095f-9265-4cf0-1330-08daa1c5edd9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:29.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXYqIuw11WEnFiFlNhmlvSD5w0WlaCgEP0cETUaMFggrgyfREJEmK7UVJkudE546/T1QMGJ1E9jtvDFDbtfwgMlf+bvuG0I1bos1q0GScaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: V_1SjjXHs6s9RW6BtnjEh8fc5W9gBokd
X-Proofpoint-GUID: V_1SjjXHs6s9RW6BtnjEh8fc5W9gBokd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 102 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..37eafa968116 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -671,9 +671,16 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = send ?
+					DMA_TO_DEVICE : DMA_FROM_DEVICE,
+				.buf = buffer,
+				.buf_len = len,
+				.timeout = SD_TIMEOUT,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM }));
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1594,8 +1601,14 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = sdkp->max_retries,
+					.req_flags = RQF_PM }));
 		if (res == 0)
 			break;
 	}
@@ -1720,8 +1733,15 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &data,
+					.buf_len = sizeof(data),
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2062,10 +2082,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_exec_req(((struct scsi_exec_args) {
+							.sdev = sdkp->device,
+							.cmd = cmd,
+							.data_dir = DMA_NONE,
+							.sshdr = &sshdr,
+							.timeout = SD_TIMEOUT,
+							.retries = sdkp->max_retries }));
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2122,10 +2145,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+				scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdkp->device,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2272,9 +2298,15 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdp,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = RC16_LEN,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2357,9 +2389,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdp,
+						.cmd = cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = buffer,
+						.buf_len = 8,
+						.sshdr = &sshdr,
+						.timeout = SD_TIMEOUT,
+						.retries = sdkp->max_retries }));
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3608,8 +3646,14 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdp,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = SD_TIMEOUT,
+				.retries = sdkp->max_retries,
+				.req_flags = RQF_PM }));
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3740,6 +3784,7 @@ static int sd_resume_runtime(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	struct scsi_device *sdp;
+	int result;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
@@ -3750,9 +3795,14 @@ static int sd_resume_runtime(struct device *dev)
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.timeout = sdp->request_queue->rq_timeout,
+					.retries = 1,
+					.req_flags = RQF_PM }));
+		if (result)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

