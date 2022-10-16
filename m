Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F711C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiJPUA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJPUAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B627A248D4
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrO015579;
        Sun, 16 Oct 2022 20:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=LYrW1LP0TzS7jhC3Mo+UeEgQHBP4bCwh0Uf13dW9XQpS64myIEDyj1cS/5EG+lCg1hBR
 X/E/9UssDmrGQH8WwLrJ2Ew7XzYSyqgM3nA8ISFigVTXlkATuLSIDT9DYxPzvj2yEp7V
 1eqPxAfqOpm6IjUm+Bh0Ra9qbG0iUL8SldnN3hpTwtwq8MwIV/hLm7Zw4+BQv7yOQysC
 uHjUizbq27FfuyA5AC708vVWViDrJkzEdgSTfK0u6pLAY31Oe+NlEsR9fF+0RhE4JGlC
 gnvN8FunuO3n0c9hb0R/KHuEEMvZkbbTIHFl1QRVAonrDGGH7x9PS9RzprDlsWZz8YdT dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAneJ001181;
        Sun, 16 Oct 2022 20:00:08 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgmf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KE5VXqPaXX3p30Y1RSM8hwBA/AF7qJ0e/jr/UFRr/3XoRVeCJKdhjECX5skwnAHrP0z8UsoddkE2TJn3I6y0VDCCDdKF29nPYkFwb8dg4O/ekZq1cgbvPQpyb5PtJrcVJ6yiGqa9OO67TkJLQlBh2HhzJIwvph72aBPcC8UTEtPucQmd5ySEJ29ZM4uYiBjAfdcNfmL4cmoz5pZvGOGBu1MyvLf7qh3ofUu8x2a0XsZ8tammepI1mE+BTvL96QoVVqc5fC27FNseRxO5GpK+pqYWRIx24gpk9e0z7mzyIY5GOKeFQcSasMnZujnx5MjFndKHll3IrsfOtAgzKycFTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=NfKPeathFeWxIElsJeDs+ozcr9tR+M1t2pGwOMdZPUjvZRuD0Un6Da75Ftb9PR6VFsUpZyq/5K8zSk4Xm/zfRYpkIt8CsL/oFf3aRuqHRynC9pPAunVhBEUwRzsGRzVHwz7CAxGhgyt9WQcrDF49Q7XJECc5yK6czfEQnMZwjNr4tA89BwEOX/w69wz+BttC0+4HxLHjex7v8zpMxCIIvwclOheO6jsRhogbpiVPr0TzFPFjfAGWnkcKINnSxUrLB60M10Ae93hdtgbypgb7gezL4Fp1t9r6YXCefNL+t4OvOOoXFCdH3Q8h09e/YVkHWYnz29PW8YEKKzyjsCWlOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV79/Obc87tSSRQeEHmAoG7u6mtZnjlW29/zoqDv9y0=;
 b=pgaDt9IvV5ykVD1XYjM948VXifBjuJtrQgxMFXujA61k5uvuuZDzhs7EV2rrq95Mb5bLzhfAqS0QSOS1CN6YCJotSs9Kf6OPZToiXZo4Yuuy6pCGe0a7n6dWzPSIMlnRK8qevzY30rJqRkeY23JHo5tm3M+F0nNcj5DjhYMibiM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 10/36] scsi: spi: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:20 -0500
Message-Id: <20221016195946.7613-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0194.namprd03.prod.outlook.com
 (2603:10b6:610:e4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 85c21da7-3e5a-4790-f042-08daafb104e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwweB7c0aQrel2OYlf0F8Da+MBbrKtqo+gtbqYCdaOfLprTP1oQT3dUyXoRb/WyTXPthzsoSeLYIqmMW2zrl4itflLzCSYckdyt/BaqADD/+cJSpcmeQNPqXfFdZfV4RHyF//AeJZE+N4wdnf/BjHvtNR7mkbreIYT1xZbtGyirrE/hf2Gc6iPwnoOqzX0rOUH2noiCGpSa1WPj5qXINeQqV3fwq1b8GqxGoPedmaxFThaFHBTM5IVcwL0H4BguFHlrNtrzsam3pW4elDrB7lbTznW7lsIF1/Fb0+Zzu4j2ggoZrMsUHP1twbp1PoQCsBnjLCj8MhzmrXQc0bGbXTUqJJe3jkE5J5nvJEk0mJa4CnlilAdDi4y1wu5CP+Ugh7a94qHo4oeaicZVRAvVsGrl7SaOihbM93qgdeSCYFvLDJ4kUzPwXtU6GIZY4YendoXoI3xhLU0ZSI8UBgpD8EgcFDjMgB9wD9leGkBFEdAMq0molbM60C0oMijiIS0r7hRNLFTy4oopULT6ErnvrAHCYpWWnQxwVcIYVqeL5xr2Z97H4c1BXjon8NK0wyaua8YO7KtDp5eZOpN5RZyni2I2NYNHVSJ79c6Iy4l6fg/LjCnrpUCSMcgd/ifHGsZo+awKPWI7J4rd78/9+mzmY8b2BwzHBwMktXCR0BbepCJ2kTT9BiJdHfYJu2Xl9T3iuEjPICyuv6Q3zeO4VN5V29w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5GM+nHR31bCj2IU0Y5eT23LvILuvWRH26OLmcxGyvMB3dyP79V8PeyfCje3s?=
 =?us-ascii?Q?GZ9P2C50RC9jfSoBgXZtJE+S94khttw8aaY5vzMXCWzasLomQ4TFZkYx1xzZ?=
 =?us-ascii?Q?F3SaQlam7mw6yRpLX2iGSqFR0BC7euN7yt+k1axggwKNq5FNvqZvkQB65f3Y?=
 =?us-ascii?Q?fi8an5JDrB5ImWyW4hZAFfVoM2tVvv+Jf6ss7dKC/LXGi8DOc2DtU6KHP00N?=
 =?us-ascii?Q?gzVVYKUEs5q7qJ4tLW7Hr1B07EmcLNGysnMR3mjPcYUgeaUwY6wXifKHzZML?=
 =?us-ascii?Q?WrYR/I3XUIQDNVGLFeQ8Y6mKjOXW1Cv7KjrzXgaUWHqXvr7fbOTMhJUdav2q?=
 =?us-ascii?Q?FVHtKutJpDA1eepO/kVRahoRINU5CgQHTx1BgQQTwrhc5nExIqIEu9R6oVFh?=
 =?us-ascii?Q?TSaFj/r8xiWfDU14TwAPuXn6foKTFhMzE5IdfsZCmhOAfRtlVC4pOlYjV0SX?=
 =?us-ascii?Q?Zvhqq3Y/rN6eY9IQ3CO1EGS5bH4x4UeZf/EBGfEp7FAji8Kx8tGHoSrsQnrC?=
 =?us-ascii?Q?cJLCXYcf7UoddIasUGOcLycoVeIrLkqo47jSVccRrWN6yBDhVHWDAgITFarx?=
 =?us-ascii?Q?SA0R9rjx5J6/BnwnZXCS4u0m67bcLT2WFL3EB29mGCF/kfoaFDrj9YmEtuNp?=
 =?us-ascii?Q?sq/ZdPJGaMXQ3YYi0p/qoHnC0EyKRXUD419kgccqFK83GS+kxR7TBoNs+fSQ?=
 =?us-ascii?Q?l/QTTRj6izYKEIjUuHSAGPXUu8nLSyPefLFhnc1lNI4nTKP3Sv4QENq8oZxu?=
 =?us-ascii?Q?jDxCPX3FgZ8dX2C7Q/fAUeDpyRX5E5ZWiPmzkyhC3E3D8KGkom2p95EipbOK?=
 =?us-ascii?Q?EYyjcvRzv5vbdCI8DINwOhJVT3jdq6rPjIKUTHjUOxVNKvvn9NbTeFBahyku?=
 =?us-ascii?Q?yvmRTlzguXBjQj8UkU2gWRs+NpOxGhu4PDhiHS+WXtCzPF3oYkqmPQ4QaZlF?=
 =?us-ascii?Q?ZeGgkTUAcbtWzNiRdV2FppV6fho1jQtmUK3V+0eK3OIzkquoMZOMbxM2BvT7?=
 =?us-ascii?Q?+hyI6UK+ylYADhIxPND1cknPosqoF0uold5r0Out5XYAglmo3aoVRYml2Gkb?=
 =?us-ascii?Q?YLyqzNaNNUkL6ur2RaamkR/yIdEESrMoTou+mafYA9YTXqsv62yEtg5IH1hU?=
 =?us-ascii?Q?LrRTNS7jDu1HKdXQzdhG6Yry//VAf/zndkU2SLdm79oRVOiyJyC4w+jorE4d?=
 =?us-ascii?Q?IviYqnDnOG4qP3PMBApyqFsWp32iz5NJSG6fjtBXKV4GWGB1AUJD4zEg7sQO?=
 =?us-ascii?Q?bLtdlS6T1npH1dIX4TGB16AxN1rg06G+Tqc6vHtqZHChwEZc8YoeWgK6kRyW?=
 =?us-ascii?Q?H+FvlpUq74wML8LN3gSSz1Rlhf32fhIfEBoABdqi3qFTqsWYWJEHqBeuW+VX?=
 =?us-ascii?Q?qPSEV5J2NqlaPazsJ5sfaCYQWDBZBZGSVtwN5yPQQC6fAaHH/15TaamrFT3l?=
 =?us-ascii?Q?CoFc+CggP8no2Zw2qtfVLCIzn2WjN020dzKRSNHZaH8HTG9fn/T5lcBD8GLV?=
 =?us-ascii?Q?dWUO40kMEFdZv3ogmkdWjvkY8qhye2TfEaTrXkbKLzqflvF5Yz/JcqlSsnj5?=
 =?us-ascii?Q?gezX7cP+ashTkf+Uw7oQqVVF8MSSf1wTaHu+f8d4f+dCY6rGGgWujWF4hGep?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c21da7-3e5a-4790-f042-08daafb104e4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:05.3624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKbeTQaHc+skPSIxgcFSs75N4PrEMg3PmJl1u2MsYROdv30fDU5g8QYvQupSMzS5RcUTyBzWkvvbULK2s2VYLF8ggwiFv/1KzPd3FyYzCK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: O9tsF10Cdv-ZDcPhKEDMJiYiFJ2QgXhn
X-Proofpoint-GUID: O9tsF10Cdv-ZDcPhKEDMJiYiFJ2QgXhn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f569cf0095c2..18a365c577ed 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -121,12 +121,21 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
-				      sshdr, DV_TIMEOUT, /* retries */ 1,
-				      REQ_FAILFAST_DEV |
-				      REQ_FAILFAST_TRANSPORT |
-				      REQ_FAILFAST_DRIVER,
-				      RQF_PM, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = dir,
+						.buf = buffer,
+						.buf_len = bufflen,
+						.sense = sense,
+						.sense_len = sizeof(sense),
+						.sshdr = sshdr,
+						.timeout = DV_TIMEOUT,
+						.retries = 1,
+						.op_flags = REQ_FAILFAST_DEV |
+							REQ_FAILFAST_TRANSPORT |
+							REQ_FAILFAST_DRIVER,
+						.req_flags = RQF_PM }));
 		if (result < 0 || !scsi_sense_valid(sshdr) ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
-- 
2.25.1

