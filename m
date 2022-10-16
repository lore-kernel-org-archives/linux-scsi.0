Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CCAC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJPUAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJPUAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6729829827
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrQ015579;
        Sun, 16 Oct 2022 20:00:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=acayU1GAglB2fQHOiQLdYArjnwrDye2FGjGypX1/B9MDr9aytO+NVjRgqT1okXtbhzPA
 G1kux3WjKYI7ryvm4olpTQ4Qq5LzF4bIyuSkmeFNDWsmDMnD88Rx03n5vntucvPLMfzA
 9piimFwyJ90B4+X3FqU8TO0Icx/QkjVIrO5Qnshx7kxRD6+2EQLUp1XM20TsYxm3kpYT
 jIIxVlAFgXKj7Vv2bHVry/z5EJlnh/IkGdt/1mRo7QEbwmD/tzvd+cANu1wk98UscKnX
 UzIf+t8HAJPpHsedJyAXy8sT6oE+FxYsVt39a58Ix1SBmzH5VxdZpJNpOb2vVZbxr+JT qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAugj001237;
        Sun, 16 Oct 2022 20:00:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmh1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOh10g/AhC93xO6h/FPX1jQVv/i74xCWpmpr/KJ9es7gf8gT+YxfcPhMh9sEqd3wIJkOtEG4RxTzsnGIfK329UzMhd2xnouEWqnd6JbIKOBIHzvwy2MoHtmzTejBew/oLezg9gD+HTP1ojs3YJNTqQY9K7Y5JDDX8TJBnIfv7I7BONST2GJO9lvfGVh05AFMbaQYaK5cYJ7bhqH560a0pp/9pxUP1JFcU2NKgOw/U6UxA0pi0DwB7Agoq7PPj/CC2XzbSpjWY6dRUzKQjFC0HvdvUEYbOaMbm9aDwAM58Tk0GGZwSwKRlaIQL+a7d6RHwo1b9EvuN2s8EY0Iziwkig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=BE2hF2ZB3NA/tS40Z63Ey2dMmg293vBsEsmGAWeBTpYjRbvlUbhKuVFurPBiWm0JN3SCV+CwC8bpF6e86+NMylnjeYOCIlT8oQpDmHMCURAX+D+VzE8zHY/4Pxxm0avRLw0okmnPzgqZYAoI7Bn2TXO2plcmKckgC8/4bnWLOKBRFa5PHkg1d8ppRXQT0SLG+uXb6mny+l1nWK/kHDq3LoHBMUaM2UUNF9+pZKnKWOKNFLrlmQIn7dLnj26cdjKy0ZwdhEFL9hLleVym+9VPlV1PuAxuA7NuA+3XF0F7om3FiCklM7lThBELbDHrdK+eqM8hY2lhC4VMckAv7NWsbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osYKhSqc/sok6A/EqLBKLvCkwqI58nQvBOEjYLABYs4=;
 b=Tv1uEaCO8JEMDmi/Xm4D5QJ90LJKDjJvcDi3jUbwiTZgsnAREBjqSx2NS/tbSbSPSZvfAq5dgNqW1mGmN3krDGa8ZemVeXwu9StpaRcoSPXxsnVG8zhitLJvkBTvHr0XvYVl6f/WGmy9rXsEbQbAOsIG9PuzrjyCTo5VpyBcAE0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 14/36] scsi: sr: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:24 -0500
Message-Id: <20221016195946.7613-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0182.namprd03.prod.outlook.com
 (2603:10b6:610:e4::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 37b59468-c46e-4acd-63e6-08daafb10878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /choySbClJMK/CqnP3Jo2AifKBWxta/m4N9LymaVfPq+tdyRvNdsXt7DgTUAr5G5DQQH1qg56vEvuU5F4n8msuT3YR5qjK5jGlmzt1MKAMVkI4gi/ni7/Ublg6y9Ce3vKBYZqPHVCfCBrNPo57lq412NbPcnwV3eGoi5AbXRMRrixuYYIk4VbAtJPJrEf61NYxhMH+PiTPs4kqNUD9aTAgcb0OGCm6VHckbHm0LcepOgJOnzrP/9BNlBJMfGlfmDYOd/sywbm5BRjGFptlN33KZ1Nkwb3oxBGEEg+T33rpHSblfndw3LXBDJptVBuLtFATQfodFAnEREW3MGz+K1xjYpAJw9B4y6DsQy9RIcMnTR9uXL22D8q/IJPYkXpfHDpH7F5dFlJ+rMJQBBRQNMx6c1vokdx+omyoGK2Q1F8F26TiJLo3DsryIT7vzeYd/Jli+8dh2JGvVZs/HgSQc577uwZa7tCZapgXBp37doaiBOR24jBK7qhWmFutVLRdEHMbuLDSYImU9eXF1yhqivKdKUK70e9JPk9mjol9BhAC0thfiJTBiH0wWRW4saBMLsKL3JnTjYmo4beh55MYzCOT8OoWgjLc9ZU4bsGQciL7wPGK+cA0wcK0TnYe9/ABYDSppzLkxsdmCB1ovh9tquO3SseoTLB1p54VOpE8eJhFGKsl7c5P1gF2n/JmNLiBXCykb0Zus//n+GchdhNBLYng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dnL66Ty+rWEHkTKMwF7NRZdvG3vjiTEk5CFXSChp8XCfmsqsnNSNetQKnqzU?=
 =?us-ascii?Q?xTIGKxzurgPkGdRC27YFAIW0EPnlgVk4fWplWsUWxK1w3pfEARKlOO030MP3?=
 =?us-ascii?Q?Kq1qjbPIKelNi/L0TRbAtGJG7AAM7huUF9jBrlmjE8f7cdsZeGZUzNTKGmNZ?=
 =?us-ascii?Q?sQ2nLhzawyZwNTRbPJ4WEDCM4Gnd42Ce0X+QURdzwLQNx+yJdEu7sW6JMGJN?=
 =?us-ascii?Q?m7Ijx04r23BCkrSjaq6iyjU0TTTuu/VWXcTddK/0UzNzrm4nqCiqO3jFBCe6?=
 =?us-ascii?Q?NjTxdruQJycmnoMtdSqHEGO8AVAQcpmhPy3OvBJaR2HynncjlxaO6L2qBium?=
 =?us-ascii?Q?ndh7fFt5CQormapoQFbeBgQd1cddmEI4PRchMMgpf7WfbmNaNSG6/MQYSvRl?=
 =?us-ascii?Q?kmUfJ7aby5j6r2d3/29/dLlHx735PXMDkXKH6t+q7EFP5bHGHHtdgOm+A9Zd?=
 =?us-ascii?Q?BxCADGD76xZBUsh645xvN2ZujXvGwWA9zQJ4h+uE/klrAtVRLssugMZeZUon?=
 =?us-ascii?Q?5A2xqhCm94jDFdn97csN975Xp5wXczFiRuQccHdr8hOT8+X506+FKEYxH9QQ?=
 =?us-ascii?Q?jAMC71eaf8JjJ+f4Tj6kb0V4GNzxZaNOeOt2r37o1Gucv2N/tNBdz+/uFzrz?=
 =?us-ascii?Q?RKLbeOobZGYu32qwbViEGTz9JOiIJrEECiieDRu9XLckT35ixKLL9QAoOfN0?=
 =?us-ascii?Q?q2+ZBE0tMFc4MX1+bfUuhEQnXt6tmBLHPP/wtD6cQdPAsMbbVd9nf9tqURrb?=
 =?us-ascii?Q?cV9Uc0HcKbt8EIkgFeeHQUYhO4BBOzxsIqDPcl2aLQeavgY8Gg8fc4C52EGl?=
 =?us-ascii?Q?waE4AgDVGx5nskK/TgmSmzH6DKznYQ/+gj8pLa7L/+AdjF8S3khrB39g8TE9?=
 =?us-ascii?Q?mibVnU63o3cMg7ZowVU0uGj77roUzNj7+kkGd11+uZpMHvoFBlEiZIWT4u+3?=
 =?us-ascii?Q?8W8Oklv3mBne5VrhTHahNKmUi14D7weTqbadjuS4U+eGYC1rrhcZgVbsuBgG?=
 =?us-ascii?Q?jezIKpuq59yT4ynP8b8af8t+Dn/4CDWD+dkpQAftPiW/wXB7ANGTOizq21+y?=
 =?us-ascii?Q?IfnYo68WEsw+HIL2l5TMewd/ou7b+QQY63A6AL4QjzUiBOL4t32MI5K+Rqmt?=
 =?us-ascii?Q?75wyxz60fRSADYhnfYWFd6ai0pUs1MkBrtI0X5IGNckyLuRY+XJ9GlwpQMwY?=
 =?us-ascii?Q?CFdHRdRRe025WEd8ryYYNsDhHxUTJT2Saug5WK1Ye9ECginsrQCcYXj9pcbl?=
 =?us-ascii?Q?jfxQT6qU0DWaASPmTpQdoFfJdPDxrIvZzvPzTDLibpsfHVDtkE5ra52DnGcM?=
 =?us-ascii?Q?NJUX2AzEavfaimrxm2kKfPC7n6Cif5+4jOytXHfvlo70Jmf3LWtViQXf3W+Y?=
 =?us-ascii?Q?Hb1+EO1wLcVvQAK+ygeRmPzkKnRNZ+zaiEsWKu01zjfYKgVsX+dYLGngw1qt?=
 =?us-ascii?Q?vMTi8CYJZd5FefajUcp3s6hvzoCOE2jqRSWAKS1IWQbDQ8yPqDEWorNfXjL9?=
 =?us-ascii?Q?5ULwJSrmqEj6ToB1Iab7hj4RIrWSRegW86zbjhOGpamr2KlbSLVjRydGioPL?=
 =?us-ascii?Q?inKxvCvY+5r8mwKfMHwChv0yDarFi/7fXRkrPnReF//0QNcGj7PFXHkwV9nd?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b59468-c46e-4acd-63e6-08daafb10878
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:11.4557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaf/fg8gZVt/WmtZxbFw+VC9e4Cfx96QpqWWUNc1FZhLEsUNdOXpGh4lgGRZYcck0Ftqz69FvY9xq7qLIicsT2AVuxk6qgM72kckrhVjAbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: SWzN7yM61f2_zxcq0X6PTJXYmc4LWEN7
X-Proofpoint-GUID: SWzN7yM61f2_zxcq0X6PTJXYmc4LWEN7
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

