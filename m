Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052C6C4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLNXwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLNXw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553DA2AE07
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:27 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwmJt007258;
        Wed, 14 Dec 2022 23:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=xldZibIvBP4vebk504Q+fxS7SW/++se5eYfY/9kh4+I=;
 b=m4WNeiz0/CxfZn+K0dtb7ElRf6L+jAO63Ci50QwxLoauuwYvSZmZcWCEpZWRY0q5dUhs
 oIHmc8e/1Cf8tTn6Rh8DnakFmImWvSAMwcAzX2JGoADuaAOk1PUWBazjVw4sMlZXzl4u
 ZsEcUK+ZgkaAqcwff4+wpfHnxpRDG9wAPzqYbhuNMZ2g1UNYnE2ciSmcF5HIB4yHShzJ
 UgDhtCUl5bSDBPMkQPoD6KZvnIj3qAwiBrGwlCF3Bi0XXMwmHLOV9Ws9JLsikaevXsBe
 FIsQvfpSyWciHROq7klGSRnM0MPgPBoHYKrIxUgGWocSr6Sy1cvBsX9/BP8LnKwbX13U EQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex3qtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEN3VNx039262;
        Wed, 14 Dec 2022 23:50:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeuumqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDoRfkGkKmAB0CUL35aZPdRij4bDcigNVcF6YEcNzLpdcfc5NUGzcA1uaH6gIwr3+dIaRTIzQ7et62BKMJPbOypozudjJYM/ScS63TERsOtHwx0DcDtwG6x609ws0iexxIhGvfGivRto8dxslPckzB03H+yeI0EwZDCCUKOLSVPKGgK8fDm+BUyZ7HCiJMM314WC1Q45J9Q5w+9kEih0NH4qAow62FOQXt5/c/Ajp2Wcp+AaCv9xKFvtq9mYgqL9jeze3y9iOQZW9vouPUB8WW+bJ4A4xSKhRghFhL7kl056WZX2/jiOQPP6sx7YiPdfD4TzQ7MRivr9AxWldiEMRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xldZibIvBP4vebk504Q+fxS7SW/++se5eYfY/9kh4+I=;
 b=h6HokjDVJel5ktfCZby7eGHzebDraSM+qrza6+GfqcxmKofmyeUxeNoWrcEPHLcgFm1vlIoyDJNhZ+/2W7wUO5WPj1gr/xuK+/yWQfsmO1pZK3TF3Ds+CkWaF3T67IE3CB3Iy/WkfekH+kF4YUfqvQXgKJCqiAdOF0fOEY4Xca0+ddjbHk9/VpKDFqFM/qDR3NmpV5hUxebJKjBnqX1bIlaE1RV/wvQHWpx6+2XC9ODH3WGUOMRgZbv9vV7I2wZu7ZfHz37H5G85ox4iNdejjGIRssjdE0NgdBe1T+lVoGyNbyfhTQNypUDIFgNmleqDX9wLOp7odTu6e3bxo7JPpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xldZibIvBP4vebk504Q+fxS7SW/++se5eYfY/9kh4+I=;
 b=CgP6iJU0h2mhRY2ly9DTbuadhrzjAN2yBiczshnJno7I4kXs94HTWsNu1tDXeOmVyf96v0NjS6Mfa4nEqFJ4gAmLH1GtVVFZK/tpq3Y2APSEouCoAIfusONQL5ITUDXUF3Tp6bexnLYJVzDE1hvJqTmc3O0G+2yA1klNdpGgVzo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 08/15] scsi: sd: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:54 -0600
Message-Id: <20221214235001.57267-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:610:4e::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f7001cf-5b88-41bb-78c1-08dade2df38c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xnwWz96wkBkeGRaDakVE1MZgH4WPht2abT9WVkhsdeHGF+FeaIsFSv1wPwQwYb1vt3KLcomc/brSdXhQFJgDrgKgkfaRa0Bo7VAJfSNifEQYTQeKJTthobQ9O0ta4vL8LBCxGvMZnbhUQuZCMUlA0BfGBe1tXlQjR9y5V4Vkx1HEKtPpgrjgmr8LT0nCa27aG3Ev87+N4fDeHXelTRNyWZFMST9mUMT+K6VHTCOmlYkkYSPh6ylOXTOQ/bcmSBa85WZndhiPhpblZemEGuMnSqSatxZpmKFP4Y6ilmn+lPTnBuRltAqrv6iOHwitrtvURqMrB5OOFMzdsPK8u/BTGABj/jd3mAzNTC1VNxGzwCtebcPDmEvxh30ogLCDQWiE7yy71X/kOEd66Gweo103HamOAEI6aVYojp1fNlEXlasJrKu1GNQeEeQ+KUEx8bKzWTn2fc+vUSxtHjYHj6V1ubB/xnet/kbFBbTG5UV/fOuT/ylw0HxZ2BwGB5QkGH2x810Ilgbx0uxZ6sLtb2QyjV7XkTse69lfKMzN9QVG7zVCeYj6RFZDOkVy2rScBfBTIs9kx6SMKeBGcL/yVQRZi22m6mwwZeqvoDaRBXfk4DCK2IPtxQZZS6VzxRbe8saf6fq0j1FIri7n4cGDIWjeKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rNB0bp6A9KdpFc2x0xZN/eVkKf9WDeYXk2UzKT4JyROJPcnfDP7X8D8Hn8pQ?=
 =?us-ascii?Q?bYjxNi2wis42P2p7dH87wrChmfF0NgcvLFv5PLyy7KV++q1ctuatdX4qeEHE?=
 =?us-ascii?Q?AfpBb49t+ATs6OwWboRovCkdpysHOwPNyuUd56JnH1cF6a8I+aCcn7NVV3g3?=
 =?us-ascii?Q?XU2FWnJToo4+rgVBn0mVpZ6VWmOa9d68qkGdDHSJsbfwwhWINqO+wnZ85Jaq?=
 =?us-ascii?Q?ieF+dckyjJydatdjwlSVya4BYh13biKvpIxKaedKXo+2fn9PW+3ljUjFMq7T?=
 =?us-ascii?Q?N2ZxhEhuOWFtIg+az1yVSXAXzsd5wAZvhZSF4S7hLcCZRK6WQV1HKlAOFSSO?=
 =?us-ascii?Q?RQ8uM/wEbgLcZDO9J73Q76qUeBJfP5HH8NFUaExrmMQWKw0OFgfQb6oMjmKG?=
 =?us-ascii?Q?U7zKETlIsuciyVFF9xGd0iroeDhXZ1/qEsrj7gBtIq+l9cJEzHM0cf1aZw3a?=
 =?us-ascii?Q?C0ZeOp8POoulgMA7DTPHV3d5gRLAy8ZQb5sKfyoEcfQ2JjZWkanHeXW+8puv?=
 =?us-ascii?Q?vtF576It+ReqfDeSOjdW3uq9PPIIVsVOF3F2UNXrdl4feH1q+EKHdpINBNYO?=
 =?us-ascii?Q?n33EKgVyo84bQFap2PZyuLZoVtwAFCymw/NiCzXIJZrGFzCaBtpwSEzsKGvw?=
 =?us-ascii?Q?FWbaFCWrawr1dJS/G2zvBCPrxJajn/oNeLpD5yL47wMiNHEqaP5mLaqm9qiH?=
 =?us-ascii?Q?trdmoQfPLpe055gHN3xpkJGjWeJ15RFBISahjTEFI10ZKPCnROOHL8YV8xdZ?=
 =?us-ascii?Q?jfEN+4srKrr9UWnLs5vtBxyvgF7ZA8N8/e8FgPNeFUkjNjSpbkZQF1t/WHpQ?=
 =?us-ascii?Q?oUF7PKbin3+XaDphhbSt2plbeiQbbabQ+n5hiLv1St8HyV5cb1KyhZ97bCgY?=
 =?us-ascii?Q?bEXFjXePre4BCh1ENf9lW/x/Lf1w/mlyRxajg8cgPPg6H45sbZh7hPKVvj8D?=
 =?us-ascii?Q?4v2Tv/B9HkVmg4I79FqlnQaQ1/0an62DydOOc/DVjKCxq3G/eWJAzZ9NMzBl?=
 =?us-ascii?Q?9x+T62CjKsh11HD1L+UBCbwY2Ol0DyyXA5R7L+uioSpKBxDOP+qJMHtnic4G?=
 =?us-ascii?Q?yvKoIM5g5UzUWxBDkHS/EjsD0drIMmlOZ7MYS4E8r2foBiI4N9J7aAT/bKVr?=
 =?us-ascii?Q?f5Q1jt1JiyRl7S2fGjATnT1guCXwsW6FB4Aaf1ziorY9WHJrTA2VvI6Egff/?=
 =?us-ascii?Q?ugY9zBQcZdQUjXlqdvYLb/mLFDBqEOxJCbZU7Boyn40ULlviStdAee2cahrk?=
 =?us-ascii?Q?NhP7ufdgNlHzi+AjbExwKWiXs4SIHLlBTeX34D4kHzHgIl3AVve9umGdlpQc?=
 =?us-ascii?Q?P82hRmpv1UM9D47T1KwTouBDW0voOX3pNJ/0NauDokKk+AMOBJbx7Fwifg4+?=
 =?us-ascii?Q?WPfFPITFkgl5TfyfxS4szAn2EsVvYvPwqt1OAIuLA0lwazNa5wka5jMzMaEn?=
 =?us-ascii?Q?Lz2cJxpvSDy9N3RZbCTxfGc8Xa3nA015TUK95L19k935WjRTW84jwoQUa+6g?=
 =?us-ascii?Q?f7c8gu1Y7iwpOaT9n2weqXomVMo4+6J6dJ9ZP4lTikgfrivzHHMQhXUH+b+W?=
 =?us-ascii?Q?26eLajGSEd0AcgChUZaWFMrVuPeg9eT7K6gQ1KJ3Dtlcx4nBcc18Y8aw4bv2?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f7001cf-5b88-41bb-78c1-08dade2df38c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:16.8560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxpToJ8EHjE9SAI01vJoO/Q2cZzVQ97r9/56hNPknF8NW2Y5zm9GwY7r03ElMaGddnY3lvG7vWrJD/qvxDVxM19nh6g7omreYyHEhse4ofA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-GUID: UsaKmuQv7ild1kgFqsoLfV3wfQkSx17-
X-Proofpoint-ORIG-GUID: UsaKmuQv7ild1kgFqsoLfV3wfQkSx17-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sd_mod to use
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 83 +++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..2aa3b0393b96 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -664,6 +664,9 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	struct scsi_disk *sdkp = data;
 	struct scsi_device *sdev = sdkp->device;
 	u8 cdb[12] = { 0, };
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 	int ret;
 
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
@@ -671,9 +674,9 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	put_unaligned_be16(spsp, &cdb[2]);
 	put_unaligned_be32(len, &cdb[6]);
 
-	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
-		RQF_PM, NULL);
+	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			       buffer, len, SD_TIMEOUT, sdkp->max_retries,
+			       &exec_args);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1583,13 +1586,16 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	const struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+		/* caller might not be interested in sense, but we need it */
+		.sshdr = sshdr ? : &my_sshdr,
+	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	/* caller might not be interested in sense, but we need it */
-	if (!sshdr)
-		sshdr = &my_sshdr;
+	sshdr = exec_args.sshdr;
 
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
@@ -1602,8 +1608,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				       timeout, sdkp->max_retries, &exec_args);
 		if (res == 0)
 			break;
 	}
@@ -1745,6 +1751,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
@@ -1758,8 +1767,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, &data,
+				  sizeof(data), SD_TIMEOUT, sdkp->max_retries,
+				  &exec_args);
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2088,6 +2098,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	int retries, spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 
 	spintime = 0;
@@ -2103,10 +2116,11 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_execute_cmd(sdkp->device, cmd,
+						      REQ_OP_DRV_IN, NULL, 0,
+						      SD_TIMEOUT,
+						      sdkp->max_retries,
+						      &exec_args);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2163,10 +2177,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
+				scsi_execute_cmd(sdkp->device, cmd,
+						 REQ_OP_DRV_IN, NULL, 0,
 						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+						 &exec_args);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2296,6 +2310,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
@@ -2313,9 +2330,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
+					      buffer, RC16_LEN, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2387,6 +2404,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
@@ -2398,9 +2418,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+					      8, SD_TIMEOUT, sdkp->max_retries,
+					      &exec_args);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3637,6 +3657,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
@@ -3649,8 +3673,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3790,10 +3814,13 @@ static int sd_resume_runtime(struct device *dev)
 	if (sdp->ignore_media_change) {
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
+		const struct scsi_exec_args exec_args = {
+			.req_flags = BLK_MQ_REQ_PM,
+		};
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		if (scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				     sdp->request_queue->rq_timeout, 1,
+				     &exec_args))
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

