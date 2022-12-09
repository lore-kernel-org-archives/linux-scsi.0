Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A09C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLIGOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiLIGON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:14:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD9E944D0
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:13:56 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIuuj001592;
        Fri, 9 Dec 2022 06:13:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0vQGfqBoY7yjR0VTOmxde1JWPq62yOmoyNOEWOLZqSs=;
 b=IpgSr5wK4y5BNPgrQiFuuBaNEyromjzZr1GYrlXUiNtOiuHKtqOP8XFP9LNn7m7fJx6f
 zqs8Trn+/v0YUA+YvQqtsCZ8t6NKHMoKmkJfuHRBlOzf1mJ0nsH13CAT59lkPY0vmsLA
 LF3aFODocwXbVOVyS0BAnOJJ98w2awAAybKmV9H2/Y+dMbqlTsHdB+EDSTmwlK/2/jtW
 r6JDFyyPtvpBp5wveg/WijF+qDH82CEor7CK8PSaIB6jLRgm0xE5sfbLiDNoV9NqOEHr
 vDTSlLKTJkQOp8N2x9WZxR29qSgSkqQvjWPASkSBMLyBGUD5toES+tQyAqxI3EzaJ+2+ Zg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6ujb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:48 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B944UWZ033852;
        Fri, 9 Dec 2022 06:13:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6c65qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RarUABi37DLQt6wmOskudTpwsNSMTTaEe8kVKr/RG8QvM405l0w5jXGPyVP3JmcDlEVmbi+IYLMb8UXp76i/h3EdddfMLpLK3YR5mB2pRW5j2ozk3jTs1M2LpN9AeriKbf2tQKALvzy2Vfb2kFuELKZ0vSNLSBOJxVy5ZwAD4Fn+3OccVxjEE9KN/ScB1+t77d6gDde3vSvjYMa6WL1QMa34lfQP+hCvEYjOjAdkkzsnqMAw4JawFqL0wPk29mkU7hlVhrADTCH1qWt0N8DK9igvxhSWQutid3V48T5JVwTXqczE0YkCrrX2CX+8uxKCQSPL6yKsmoHmDusheAt/cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vQGfqBoY7yjR0VTOmxde1JWPq62yOmoyNOEWOLZqSs=;
 b=cy1V2azHv7orCAjnCI1w1CMRND+mPwb3GO7dylVPBJmE0XOFjD/SUvRrxJWxwNkcEnjHOaYTIMBgG62qYIj+aK8imXbi2NE5F5+m6ZZumvybiQzUw1SAWkZgw+4AZLljj3oUfHQPhXgsSgQekhl8SYOMZGXQou2U9r1YGzXX1Rg0Cx1GHXzZaNGIvPZWuCt6RO48OMmXWyVLisTdiy5g0pGlxcV+U4EyzaOEv0MHQwBSA/AEk00OiQhkv5RUI9X/a6AtCcC2SMDkBbrrlY7YEqQ9YyasfzFSj7uwYN4Ynghfwq6fZQbkSKG/16sFlxE5JV8i+rCpN7sfWZoye6w3Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vQGfqBoY7yjR0VTOmxde1JWPq62yOmoyNOEWOLZqSs=;
 b=DA96TEyzEQ0+JT05Fy2O7ZVnnT3ZvjeYT1RqejYoKL1xh45PhNA9pF/cCyciY5CZrJgivnTt7bqG1azm67acAFf0q9aEn/wjWrHuLVIHJdcgz3q2kg+BjhEF3mxuRGMItBatv2b6aAoI+H92ZZh9uJez1Jc6wMNJZND6gJzAOHY=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:45 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 08/15] scsi: sd: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:18 -0600
Message-Id: <20221209061325.705999-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:610:58::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: cc302056-b07c-4f0c-f481-08dad9ac86f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJEShQUr1R2At9iSAzNHbEQdwJesquPcbEevvpA2ZiAri1wA7JCdnbT890eIlXDRzBoyCHKz9+MM8X4kw0N/Dl8h3IoEd4/LTUnX/NLAwTuxI+FtDUDOM2StcHu89/hhrSugXScuHwg9wrhX5OWxsC60jXUFZaygT4jxLqIqrNBQ04rdIlGUbkQWcveaE9NPMsHhqGOh/grwdmnliM72PPpOuSXbZS1yh4+TTMAzlGkmK3Eqbt/6vEUZ4Ra1sBwRUXv6ErP5cmAsnQcMSkp6LEGjzVj8g5vr7ObIerCz7B5COppgk5WtvY+j5vcJaCyBUNFt4x/coMc84Te7KJxd5bce7gLBFzEN6jT2my/2M8xTpMRMDW0u94L0cqLofmmGluVIaoJfl7SuCF30vk48atFWBO+dy7eHXmMVmiwY+WJEMz/n0byf/TEZ8q8lcqm5Ou7A7IijkkSpTYjAY6M8ahT19OEsx+i1LZh+ywuOwYixdVddvyPIURh80PZKtuOmQx+KDOOcmAm1ghLhgPy6efTJZCE+YOJZfxY2iTDNNSnEnYgnXi7w0xNgbWWPzrIAlzqgFmnnMo3PesNxX0ufxJoCl7SPU0ldAoLsw5+liNJ5RlOafNFkz4wq9fC5LLbGUaRZcWEprpZEPjHptZBVfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2HvJ7/KUICvjCL0vGsKq93O+jxIAx4Q5SvxeilQkNDru+Ogd7uYuyjrAiAS6?=
 =?us-ascii?Q?TqnS6dbMkZUo+tmn/57jzawr0e+0P11OEs0EBJ8d38IB5riqNR+hirVDSW6r?=
 =?us-ascii?Q?E6NAkDedg/iOmDwonpsePf/5PPHAsmBDe5RkPGTLjk1UwFQ5n88nQon6XS2O?=
 =?us-ascii?Q?YxG65lu/5B32Dlzmw+hXsRW5yqk5KWF06hwchCH2xThTIsIiOl+L7HMvftSJ?=
 =?us-ascii?Q?s76KVF7tCtUFWTzRn/gCCpIh8c3JYelfEpEEuFxqARVmf6wTJUCsQ/z9ny1S?=
 =?us-ascii?Q?IGS9kKBiZ/+TQVKmJ+o13EIN3M0pro819gdUkCKkTpbAWXn8l/pgw21u9yrl?=
 =?us-ascii?Q?+POtkEnU1+fAE3XrJ1I5um2uH1WwiEh6rAGutEZGI6nhO+3EZWcheVJBAlJ1?=
 =?us-ascii?Q?rZByqL8An/zO7lxkTSrC2wEoUt++HNMtT5MR6BZ/CYyw+xV3Yx/vnmTXqDFr?=
 =?us-ascii?Q?at9j/N8A9tECohDhi6PfNSPKB4QUFHadVm1fkOgQnXt8tEZ1NpYaQnVWjl6w?=
 =?us-ascii?Q?PIZBRs5x/mqasGnTiNZ6SgG4LF0ZDfNMvBto/OOpIpc/5SQh88umvagt1Q6U?=
 =?us-ascii?Q?7jy4o/vPOt0OrAPTBxuaQBI8yBaW2e7NjEBjUW7Byi7g8YQ3jzAe7QYOK9wj?=
 =?us-ascii?Q?OhO5SQBqnNPZwWv1rBi2Bb+07BEumIBspIIx/T2JcpXI8uofHDndT6jNNiQF?=
 =?us-ascii?Q?69TI/VYJY1l7DCJymsYc19KibUCeDvRvclyRHmJ6zrWOLdXkYyDbIVv+C6vk?=
 =?us-ascii?Q?9LOVOHNbw6ilsdgcJSdFNGMvbK6jiITEo6qrxWOJxJYu4jBxC/05znx4LdJ6?=
 =?us-ascii?Q?dTK75qAm0EIqtFjOVaMzhoV5mIfXo8RgQpaKW97eei1z9A5w9PvCunOb+0ar?=
 =?us-ascii?Q?5mDc/BAdOGd9SIzTEBOzSCN/dS7kdb2B+73nOwAonfWi5ErmsWUxOUqH3gzX?=
 =?us-ascii?Q?DPpksnsflYxO7l0a/H+PZfcfQKkj4OEyDDX60vW1HO80C13ylX50ao/4IXz4?=
 =?us-ascii?Q?FRZDM1zba+v1TtYmWRZ227ELWYJgwg1prsBGGsWWYyvrkYQUuG0BSGBaGMSH?=
 =?us-ascii?Q?JA0XSj2/nlBjnIbGWGyW00HC3iMcMuD1g8quTM6owJdRGhtc1NUlThx7aDxY?=
 =?us-ascii?Q?c09G3FLg8CNY2+mx03BMbDklww8B9/AjKZtSjAlKCaSGwgAmETKmRVdi3LNp?=
 =?us-ascii?Q?VcY2VSa/j5Hm8VJbp6CbBjT4Z8ZmUw5H1RwCRkryr77m/21nb0en26efD4tg?=
 =?us-ascii?Q?7s0i+qNSZdE+Q7oSxMu1pgixDtAse36LiP0jgZLBoDmm5GP0dISPdGW0azHe?=
 =?us-ascii?Q?w5AF+uB3XCvKDpYG/Us1e7SqzR8s7FU9L4dlNqBe5yW5p/FURVYEtyQeRfZh?=
 =?us-ascii?Q?vcPnXpkRrvUyMddBNEaeEjJiz2l0Gp4vE8gDswPsj20WzlNQIDAApDHtUT/A?=
 =?us-ascii?Q?WYxV72RYehtkW+f9J66Gh89YQRyZI07+Wy7HtOumMUPMlEj8Qldh2H+E+aSd?=
 =?us-ascii?Q?63Dg9PXcqhpWOHfBh7Un4B41HCURKIgtt/FvShEeV7F8dS9PiTtIz0gndSeS?=
 =?us-ascii?Q?Xv2LXP9WDKydp0FVi64yVHZpfAfvjuV3YOJrPwWlXVEscYUH2rae6BICCsWd?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc302056-b07c-4f0c-f481-08dad9ac86f2
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:44.9736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0hvf2YjTx8YXJiJTwLnottc9fEXji86w0ZlsA66RNwI3z+qFRu8VCpAayfFJl0nILGxA1SpdtA42/FzKjVq1/L7dxS3jjnmbyb45R+egf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: zlPn6TmY282ZMM8t3I6JoK7gEUzMLOVj
X-Proofpoint-ORIG-GUID: zlPn6TmY282ZMM8t3I6JoK7gEUzMLOVj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sd_mod to use
scsi_execute_args.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 80 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 54 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..4032db01cb63 100644
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
+	ret = scsi_execute_args(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+				buffer, len, SD_TIMEOUT, sdkp->max_retries,
+				exec_args);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -1583,6 +1586,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_exec_args exec_args = {
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
@@ -1590,6 +1596,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 	/* caller might not be interested in sense, but we need it */
 	if (!sshdr)
 		sshdr = &my_sshdr;
+	exec_args.sshdr = sshdr;
 
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
@@ -1602,8 +1609,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
+		res = scsi_execute_args(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+					timeout, sdkp->max_retries, exec_args);
 		if (res == 0)
 			break;
 	}
@@ -1745,6 +1752,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
@@ -1758,8 +1768,9 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	put_unaligned_be64(sa_key, &data[8]);
 	data[20] = flags;
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_OUT, &data,
+				   sizeof(data), SD_TIMEOUT, sdkp->max_retries,
+				   exec_args);
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2088,6 +2099,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	int retries, spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 
 	spintime = 0;
@@ -2103,10 +2117,11 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
-			the_result = scsi_execute_req(sdkp->device, cmd,
-						      DMA_NONE, NULL, 0,
-						      &sshdr, SD_TIMEOUT,
-						      sdkp->max_retries, NULL);
+			the_result = scsi_execute_args(sdkp->device, cmd,
+						       REQ_OP_DRV_IN, NULL, 0,
+						       SD_TIMEOUT,
+						       sdkp->max_retries,
+						       exec_args);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2163,10 +2178,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				cmd[4] = 1;	/* Start spin cycle */
 				if (sdkp->device->start_stop_pwr_cond)
 					cmd[4] |= 1 << 4;
-				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
-						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, sdkp->max_retries,
-						 NULL);
+				scsi_execute_args(sdkp->device, cmd,
+						  REQ_OP_DRV_IN, NULL, 0,
+						  SD_TIMEOUT, sdkp->max_retries,
+						  exec_args);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
 			}
@@ -2296,6 +2311,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
@@ -2313,9 +2331,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		cmd[13] = RC16_LEN;
 		memset(buffer, 0, RC16_LEN);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_args(sdp, cmd, REQ_OP_DRV_IN,
+					       buffer, RC16_LEN, SD_TIMEOUT,
+					       sdkp->max_retries, exec_args);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2387,6 +2405,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
@@ -2398,9 +2419,9 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		memset(&cmd[1], 0, 9);
 		memset(buffer, 0, 8);
 
-		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					buffer, 8, &sshdr,
-					SD_TIMEOUT, sdkp->max_retries, NULL);
+		the_result = scsi_execute_args(sdp, cmd, REQ_OP_DRV_IN, buffer,
+					       8, SD_TIMEOUT, sdkp->max_retries,
+					       exec_args);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -3637,6 +3658,10 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.req_flags = BLK_MQ_REQ_PM,
+	};
 	struct scsi_device *sdp = sdkp->device;
 	int res;
 
@@ -3649,8 +3674,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
+	res = scsi_execute_args(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
+				sdkp->max_retries, exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (res > 0 && scsi_sense_valid(&sshdr)) {
@@ -3790,10 +3815,13 @@ static int sd_resume_runtime(struct device *dev)
 	if (sdp->ignore_media_change) {
 		/* clear the device's sense data */
 		static const u8 cmd[10] = { REQUEST_SENSE };
+		const struct scsi_exec_args exec_args = {
+			.req_flags = BLK_MQ_REQ_PM,
+		};
 
-		if (scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL,
-				 NULL, sdp->request_queue->rq_timeout, 1, 0,
-				 RQF_PM, NULL))
+		if (scsi_execute_args(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
+				      sdp->request_queue->rq_timeout, 1,
+				      exec_args))
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Failed to clear sense data\n");
 	}
-- 
2.25.1

