Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBD6C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLNXxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiLNXwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9085218AB
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:37 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwgF5024209;
        Wed, 14 Dec 2022 23:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=S9IfsMYSeF3M4JrFom+b3k0PUjXzoQOIqi26pEpqvsU=;
 b=T/8o0WI2/A/LexpiHqjDI4J+OvSeSgX5z3w5hhkY9OP4QrAKbNaZxcxXDAgbgwgTnXJ+
 XEqg6KgfOZP5Cwmvjlz1tpboYxt2zj50gn8t/8nH5Kb4ITqye/GcgIOSXc6iNygsJrV5
 UPH0hvwrLw5vpawtT8w/wnmYpg5bOJi5wVm4P8MQ9HFD3T27KezZKVmTgHvTWe7WBctR
 odb6AHZ2P+M0a0ad1HhqUp33kKFGEqVI8hukR+Wk0yQQhMvINIs79T2ytZBpkeB1La98
 vYTpjattyRm+sszXherc797jpLO+NRJFH3/yc2o5ejmnEVqdCsYVoB435qiexlOYHTiH og== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu3r1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEM8a45025159;
        Wed, 14 Dec 2022 23:50:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyen35ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RphzpuGRPI14LAFFGbRoYglRMW+ztvFqQsO4v9UnF0JBpS7lMjXffF60Vx/vt3ufkD56FABiQJetUn7qxQHIwyR1gbJyrJ/oBnxt0C56ywMggmsAMFTGVTUZbccisVGbHf1eR25snCVkFfM8Mxiip1HO/IBI0tfS85IeBH6h2m3SgT4SeMRwjhSoI/Xie/MXunOMmDuD5kyQkc1zHKMqT4OmtOHVg8GLQ4Qtyd+OuRhJ0/KDEa1CjOV64Eih2BpMB84hljWLqae3rJoExgxDeOLLHR4zoamxHoY9BzwqqedyAovHh8pp64BHzLNWZYoFyylDdku9YWX7Z2bDTFjUbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9IfsMYSeF3M4JrFom+b3k0PUjXzoQOIqi26pEpqvsU=;
 b=Fah8n1Py3xQ+8of1oiaaZfw0ztxR8Se0va8Kmo/zIxStqnoJkaxOE0044KWxjmHjB3k4DKQnSzZ66qOAXL9UGQPlq8dJgto2WX7xawxyZlQA0UVKOWcqQ2kM9PumHG3p22e237XXF9LPDuUBK9m0JmbXhBsS2JUhVgw1jAm/i4uBgZZ7O0sEr5ADUHZ6kFWBDYngfhNzQ1Xasorty34uK2PoFFQHYAKgFurMK0GhRW71PmKYLtnWGu0GYQdmkrnPk3EEpy2HcpjFCjoAqNz030986Mpk7hiqfdrzoXmA5yY11jDqSRHswm+FjVReY64asOwkZoUZFbJ8QHl241GqXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9IfsMYSeF3M4JrFom+b3k0PUjXzoQOIqi26pEpqvsU=;
 b=qx/Ay3CG23fZM7cSZiEGncO/YMi6tfg1m+f6GZYnpo+I3Wcamwb+Vne2eidQ9Tg7tGF14bmKv8EM0wRVzFY3+xss5KNFWEUPZvM/g8IuAt6HWN+kx0lnapUbRYBbnlHZzwKIY0wucnaYh1Ra9fNzESnY/hHjzC4OkYjOCcbV6KI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6699.namprd10.prod.outlook.com (2603:10b6:208:441::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 14/15] scsi: cxlflash: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:50:00 -0600
Message-Id: <20221214235001.57267-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:610:5a::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: 386d94e3-e00b-45e6-cde0-08dade2df8f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+79VlyHOQ670ESRapEVDCGdIUll+B+lkisN3ytNJA32qeUflSe/bkweLawgYe/4zO/DFNyiPmmI2j+fbTvW/D5GEhlqGiGlZOQP2uSiHl6bQ5KbpTnLxRVN6DsnWsyUr/83JZyqVh7kQaVYjvq3xj+91xf8D0lmVi6BYH0i50ShcJvd/ajiPPEda6ublSefS34prVaADhoLBY5D91LKebdAzf9mi+VwTi91KQj6klondepa7fCasp+lxAjz7uSb/SiYYeOsU6JF14JKUIlbDBK7zA1/+uOWIndY+WGCXzA0YsUWzKEvAsdNeOc2vWVLjxHeU7J54ntaY77WpAdkva2iX2Nmqbz1BdQ0yP8VYZAyf+17mX6rhZntklCGvFodAXTR87LBN3mDBXIx55tMYC5EqOoAV1ThcEtbBGMLNleBOLi4Rgek3YzW9wGRNyIjbI7NK5DHDEhyNMTf1B4jPTvei4M0yCNnu4GFHGPiiGVa7ZpnbZpCLkcb3+YaOWD40NLwGvOZlz4xhoy67ohdr/xkJKlEp7K2y6E4vFrMSZguY85j3Q0+eX+39VTUDgIbonSYk85q7ypOYyiuhurA8EfJ14zzDFXVu9O+h/HNBHorPLe920y6GvHGAAOmkvEx0fL6cIRTodS6J6ne0ynuvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199015)(36756003)(6486002)(86362001)(478600001)(316002)(38100700002)(6512007)(107886003)(1076003)(186003)(6666004)(6506007)(2616005)(26005)(66556008)(66946007)(41300700001)(8936002)(66476007)(2906002)(83380400001)(5660300002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WCDczPLMbzkQSUHMIIoUSmMDY+Ok83gx3DRPgSmdrXe4tpITaROzZ6qYNaze?=
 =?us-ascii?Q?swj0A8TDdeoVfhb2kt8pQEjsezjgEccgUkvWe0FQjwZw5OHh9iqf1WB5lKB6?=
 =?us-ascii?Q?F+b8m2unfz9+zPYhUqSY/CfbpzokdjqH+rfhLPzYguUGxZN94RlRHwLt2IE9?=
 =?us-ascii?Q?EB7P3KrFGK4+ZSxHgO97ryfvxeSSdXtg8P2PN7+sVzWZVHaaFsTpetbiMLI9?=
 =?us-ascii?Q?+sxGfgzaQ5O03Y0oB8XWgI1P2aW20jO6S/SsV+Qeh/SWEHPi//4/xtjRgguu?=
 =?us-ascii?Q?ny5/XfXepgWL8HilAdRNNww9NfcYj8DdPb8itAr8R3l/PQqIvTg9QrzI1224?=
 =?us-ascii?Q?xQyqaajrxK870GBQRuqmf38X2hiv94pSeCRl+Q/uzbf7N4+ZDJNCx6gdNCu2?=
 =?us-ascii?Q?nPf8bHLUKoPkrrm6g7vGtLo4zUrBb31KdR10ufUX0hmqaOrJIVBFn6HUWKkN?=
 =?us-ascii?Q?MCY2AOJxEH64DhvvbADrc8GfOVWJz68TS4bCbr+/A6UQkqhhhYaC5zkXc13E?=
 =?us-ascii?Q?BxmkfrPj7O4KV7psG3wdvjvxBjXL0GGswXCL4j851NpEAEzzfMxsEbFMWqE8?=
 =?us-ascii?Q?zhFtzfGgPrDd91bQ/PcnzaE8ksW4q0oGDxIrW01FS3SNBsbgbwJGzhbxrQlv?=
 =?us-ascii?Q?RGS1w3QCQFkD1qoYLTq73ayO1KVVwpDdlkIxlvDKgNDSorB/rldlARD3/nwy?=
 =?us-ascii?Q?S4zfWphlhsMCSEbBII378g7hwGd8apu+ZdpKBsj9h3XNAMZT4eMaM2Txz1Pq?=
 =?us-ascii?Q?BDDArx7erxG0x1InfDsjur22dmuhHJ9q55oADdJChRdmhBoEjjnoumhgCngx?=
 =?us-ascii?Q?KpPhL1E7gtHo/RTATrZOQiHGOKWl6lF3MgbjY+1mPyhWIx6algjW04n6rxTP?=
 =?us-ascii?Q?jeBTbremTkSPnV9RA4rB0/KQ5MVSSRoTRhwkxV2/ujQVyZuFST6aNEkiH509?=
 =?us-ascii?Q?mIAiwijtL3IdzeWIQh2BTt/SqUeBWekDu7xxhpuD0wWVl9CQvd6EIp7SzFLw?=
 =?us-ascii?Q?P0d8axTQw/Q5oYzbsrNM43Eci78frcJH2p5BE0RZqjrNTl/9sVkMs1M9fICB?=
 =?us-ascii?Q?obEFsvEZpRYn+PddIpJUcR1LQKS5HerpinfvA/86Jtz8zG6/APbnx+W/SdBd?=
 =?us-ascii?Q?OXfDONyQyoATvjphiW5PR0zZB/EgWmKrnJ/1cotz11YkyP1n2AffLr+KkNqh?=
 =?us-ascii?Q?D5x/9aMxn5jgqpMdxktPznmpvL62j3tiUdAN5jum9rLLjNURtl7nH1oTenaV?=
 =?us-ascii?Q?q4VU713rcm6YgjbFwbOEupsNT04MEVd2SIaIT1V6DelaEUf0w/JegTQvQTsb?=
 =?us-ascii?Q?sLwOb8vcrKT5LkpuzL4l+5tLzcrU2gwARQnq5BDpfGtV3szMdQ2t+zumHmtE?=
 =?us-ascii?Q?2QAZ3NP8ffNHBi1B4k25kFGtYQq0YpT2D9TuNYZxc4GZOwhNfbc4AEZD+qmP?=
 =?us-ascii?Q?zT2dC3YxcJs4ktekF5aZWHVF/AKxNK3onu4MYTb00tooEWRvhoUcKwjPJAtA?=
 =?us-ascii?Q?p88M4VgsssaP4liPaKIQwtpLTF2xFmG9YwT+orqx5k+00/mDDPmlCFJUDtFp?=
 =?us-ascii?Q?SzQ8HCzPZwC66zvk9VHfjYDqRv7lDdJM3CZOc6dO3jSmu5XdgjDTA018fyTW?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386d94e3-e00b-45e6-cde0-08dade2df8f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:25.9490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAueykV1Fsp3hjQ0YPB6Gn1FadOitux6OZArTKkplepzW4GufcVB/AhSvNMcWPa9jfhDm5axNiQQY+HG4jurXO7ohNeKwDC6w7ln0qa0+5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6699
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: exVDFGGovHLI6YiD5tY6PwojbrbGbz8F
X-Proofpoint-GUID: exVDFGGovHLI6YiD5tY6PwojbrbGbz8F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute is going to be removed. Convert cxlflash to
use scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/cxlflash/superpipe.c | 34 ++++++++++++++++---------------
 drivers/scsi/cxlflash/vlun.c      | 32 ++++++++++++++---------------
 2 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index df0ebabbf387..9935c47712dc 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -308,19 +308,19 @@ static int afu_attach(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
  * @lli:	LUN destined for capacity request.
  *
  * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
- * in scsi_execute(), the EEH handler will attempt to recover. As part of the
- * recovery, the handler drains all currently running ioctls, waiting until they
- * have completed before proceeding with a reset. As this routine is used on the
- * ioctl path, this can create a condition where the EEH handler becomes stuck,
- * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
- * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
- * This will allow the EEH handler to proceed with a recovery while this thread
- * is still running. Once the scsi_execute() returns, reacquire the ioctl read
- * semaphore and check the adapter state in case it changed while inside of
- * scsi_execute(). The state check will wait if the adapter is still being
- * recovered or return a failure if the recovery failed. In the event that the
- * adapter reset failed, simply return the failure as the ioctl would be unable
- * to continue.
+ * in scsi_execute_cmd(), the EEH handler will attempt to recover. As part of
+ * the recovery, the handler drains all currently running ioctls, waiting until
+ * they have completed before proceeding with a reset. As this routine is used
+ * on the ioctl path, this can create a condition where the EEH handler becomes
+ * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
+ * temporarily unmark this thread as an ioctl thread by releasing the ioctl
+ * read semaphore. This will allow the EEH handler to proceed with a recovery
+ * while this thread is still running. Once the scsi_execute_cmd() returns,
+ * reacquire the ioctl read semaphore and check the adapter state in case it
+ * changed while inside of scsi_execute_cmd(). The state check will wait if the
+ * adapter is still being recovered or return a failure if the recovery failed.
+ * In the event that the adapter reset failed, simply return the failure as the
+ * ioctl would be unable to continue.
  *
  * Note that the above puts a requirement on this routine to only be called on
  * an ioctl thread.
@@ -333,6 +333,9 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	struct device *dev = &cfg->dev->dev;
 	struct glun_info *gli = lli->parent;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
@@ -357,9 +360,8 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
-			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
-			      0, 0, NULL);
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, cmd_buf,
+				  CMD_BUFSIZE, to, CMD_RETRIES, exec_args);
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 5c74dc7c2288..9caabf550436 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -397,19 +397,19 @@ static int init_vlun(struct llun_info *lli)
  * @nblks:	Number of logical blocks to write same.
  *
  * The SCSI WRITE_SAME16 can take quite a while to complete. Should an EEH occur
- * while in scsi_execute(), the EEH handler will attempt to recover. As part of
- * the recovery, the handler drains all currently running ioctls, waiting until
- * they have completed before proceeding with a reset. As this routine is used
- * on the ioctl path, this can create a condition where the EEH handler becomes
- * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
- * temporarily unmark this thread as an ioctl thread by releasing the ioctl read
- * semaphore. This will allow the EEH handler to proceed with a recovery while
- * this thread is still running. Once the scsi_execute() returns, reacquire the
- * ioctl read semaphore and check the adapter state in case it changed while
- * inside of scsi_execute(). The state check will wait if the adapter is still
- * being recovered or return a failure if the recovery failed. In the event that
- * the adapter reset failed, simply return the failure as the ioctl would be
- * unable to continue.
+ * while in scsi_execute_cmd(), the EEH handler will attempt to recover. As
+ * part of the recovery, the handler drains all currently running ioctls,
+ * waiting until they have completed before proceeding with a reset. As this
+ * routine is used on the ioctl path, this can create a condition where the
+ * EEH handler becomes stuck, infinitely waiting for this ioctl thread. To
+ * avoid this behavior, temporarily unmark this thread as an ioctl thread by
+ * releasing the ioctl read semaphore. This will allow the EEH handler to
+ * proceed with a recovery while this thread is still running. Once the
+ * scsi_execute_cmd() returns, reacquire the ioctl read semaphore and check the
+ * adapter state in case it changed while inside of scsi_execute_cmd(). The
+ * state check will wait if the adapter is still being recovered or return a
+ * failure if the recovery failed. In the event that the adapter reset failed,
+ * simply return the failure as the ioctl would be unable to continue.
  *
  * Note that the above puts a requirement on this routine to only be called on
  * an ioctl thread.
@@ -450,9 +450,9 @@ static int write_same16(struct scsi_device *sdev,
 
 		/* Drop the ioctl read semahpore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
-		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
-				      CMD_BUFSIZE, NULL, NULL, to,
-				      CMD_RETRIES, 0, 0, NULL);
+		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_OUT,
+					  cmd_buf, CMD_BUFSIZE, to,
+					  CMD_RETRIES, NULL);
 		down_read(&cfg->ioctl_rwsem);
 		rc = check_state(cfg);
 		if (rc) {
-- 
2.25.1

