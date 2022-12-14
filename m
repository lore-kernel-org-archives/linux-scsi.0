Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC45CC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLNXwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLNXwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C547337
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:31 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwjwJ024233;
        Wed, 14 Dec 2022 23:50:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=YVdrphivGF9b4JOglVVv2SZxqug0ZMKHrbk7QbRmuXI=;
 b=NyRcwM+a1v2ggt1WLhGMscU9GkQNFnK2w07M5exElT1XZ/d7V2z/z4p/Z6KgiTIwJC3z
 JVmoWkCIFfNT6Ru8rG1R1exnu26MCsY0wkiUGI+IohEAEXNTUKsYPevAhWjwGr30dxvN
 V9tIZ6OaTvT1+mve0UP7+PfhFoNyRTcViEtOPxfycTmxbrPXLpdOV9NPjKgIhfEFsJBs
 lTCcNmiUHmpXgHUFljJ5pDa3XaAtifMHCPh5YujCWZO/B0Samb9TLNXqL9J13M7MRBN8
 +vNROCrFSG6jnN3XzTfItVQU+K1m6MyrTfin8O+5MAnV69gnDWwJJztg8wnwF4M1FyTm uA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeu3r1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BENCo6l031169;
        Wed, 14 Dec 2022 23:50:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeptep9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PhG1RDOcRRFlZ8CRn4PgQlbZD+mjguBT6KvdgSwJ9HqRNSzWCpcITSnpfX6a7hRBt1aXcXo6G2ZKXuKkXSOagy5Q1FS5qDt3cpFoPyMSr5tih6F9qHNcECCpQ7CE1C8aPDamZ986p2MLhQ5zc1uE7kIdQ64wun10plt6WVmJVD/nzEWl8nbE+LlYkqWafvqCbm8TEg9wXg5gwhowceW7LNHKZv4R4QHH0a5wy9LOwEnc7xd+2tPuJT2OhlfA96r0vRTbLnsrIIOjx1Nu382IfX1Ghh0Usr5wf5cVilJQn3jfm6jHqq5CYrl3iL4B8maTkeQi+UiHjPnNoxOF6T6M4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YVdrphivGF9b4JOglVVv2SZxqug0ZMKHrbk7QbRmuXI=;
 b=K4muhw+GcnXdkI8JgEPkSW9hgRLZZXVc/sieLKkn+O4f+V0B9/C3R2a34CYVOVv6PDJe9saRaYtow9qILrDChLhOYR42LXlkf7Z8tGiFqxPUvQZjM27GpdsTC7t6Fu3yDOt49XfnF61q1iyPDcRvjGWjc4JS/Dc2B7S3CNE7AT47QFIwQi9Q7PN6XGJRLM3vGZOkZZNdmY1I6qoYugFiB5vGE5GyvEgVvQVu9FcjgKrU1+W9LQhcfhCDkIKsTJGWkgf1MyfuTuBZSpYvOjicQWw7Y9Btx3LAyzFoyHvMgi56ujCKfYTcdICaYJvu4LBZW0Lpd3MTMARMav28McWYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YVdrphivGF9b4JOglVVv2SZxqug0ZMKHrbk7QbRmuXI=;
 b=wWTh1DFh4SIaXC1st1/mjURPoWjCsZGfsyUKDMnaFFS5yZmpVhGwm8M4fiO3OBMUaGwi/F4zz4AT68/BTCGGUosL3CuHSJPMlI2iwoC6ggygvcxtafvwEPefI1rTmK7NAfNSZGUP9mtv4sfdT148hRot4r2cQ9wyqN2HUs947nM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:21 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:21 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 11/15] scsi: sr: Convert to scsi_execute_cmd
Date:   Wed, 14 Dec 2022 17:49:57 -0600
Message-Id: <20221214235001.57267-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:610:5a::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6800:EE_
X-MS-Office365-Filtering-Correlation-Id: 553a0b61-67f4-4875-7443-08dade2df61e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2LxSXQjO6Y4yJymiS91j6Z1h1v3ErBqOgeox3rEsdPHeimAgOj19YWCf+xP3UhWQpUHOegZrUvR5Ab8jJHaVLBsZObxBFAUP8jEqBdwojJWAA7HN7JE77lPkVixMYqE3wUt1tcwDi+JvF4GbwrDqxD8w5M0sE7TPYlTo+L/YyMQafk7TuAptoPwt0fBFNO5hztP6pA7SkMtK3t7vSWLf7jqssbo9KLp/aqnXpnSi81ODYDaLbbznxFzWUl6j1GT2ytLlyeO9RxGev1PwIeR1VJBEZx856mB6taw6j8jnyUa8pN7ax2EJSD7ctqE3ikEtsM107mzpz+fw63YqW0h9m+sDpBtpb/BoJTKCbAU2cF5BBhMUNw44CHB/m55gJ1EKgWCi7oXZ7Q79FLkQyxEY8z+dPwA3ZdwAsxeNux7L3MUF+ko21HuacpwO96/nyGezYxk2wt6qws8Pb+uQYC+kft3TBZfcp6I2NERm66kiEouF983YqrTBy+NKFJnEC9CtQpuFTQsP6XkOH6cyKpQ/u3CCC4YKWAHCEvD1bGPMTWsAxixs4W/B5nHpZUXAaG7ovZP2gnvFLOwL5dIyMkTsT0EhebtiQIcRqWNT+cikUO9wNvGIpKCa1mmwDl71+IsdWcYPP3VkpG4+NnEQFLYeNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(5660300002)(36756003)(2906002)(66476007)(66556008)(86362001)(316002)(2616005)(478600001)(83380400001)(4326008)(6486002)(38100700002)(1076003)(26005)(41300700001)(8936002)(8676002)(6512007)(6666004)(6506007)(107886003)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kqqzXiOcrzrpgdGqK7hvet9M3XaKZI0GOkRVpa8qaHTEc76MhGz/AGmMdkhi?=
 =?us-ascii?Q?YE+/Yx9oCsj2w3DzyHDMspWU5r88CwYqDltqydPstdvi5oQqEJWLmpa1AY5A?=
 =?us-ascii?Q?hpjNTMCdhLgRE/TOxaBFsYFwK2IB8IkN6EWqRmNlwQpvaNG9z6rWXJM8kYjj?=
 =?us-ascii?Q?5/zByAnZ59YoCJFnHaWoBOm0rMwjgfBhFT5cTkBC/U11Oeagzs5hWfX8abQh?=
 =?us-ascii?Q?1Olc46qBSGQFNZ3Z/djiNKAgBrZIvIF18W/yLwKGpM3TOLJXpGoLRnSDK6VL?=
 =?us-ascii?Q?mvwNcW9T8GJ8p8+vGDcSP9WCUqVB4keLaDOcUmBR8GHkeQ+UHn6GO66sbDNr?=
 =?us-ascii?Q?6KaN8eS+N+fjuzB9imD7zuAuA4HhZkZldkrPWCVFk1gteAufYtI9m8/nIk7D?=
 =?us-ascii?Q?8lxHkngQHDcaYmKVeyFU5zyDnwa5XXe0t7P3kOohqF6O1J9ibw1yFxG9V8Cr?=
 =?us-ascii?Q?Uo7eWsNskRRozQ3lVehns6oIPWnOHDzWunyOM+WW6yCxc1Q/+wMlJr+uqGbh?=
 =?us-ascii?Q?0IyZNL1FDfM81in6dmbck7Yzhj8peEC5NgNogMhzX3BiNZ4JsG3LpifIqwhT?=
 =?us-ascii?Q?180xJwKgYBlzxC3NZISqKonZ7hLB2JaP1xXf9WI5Un7PihLpFuiXo2zeZW6Z?=
 =?us-ascii?Q?rgF0XMsc0U1jd/P5EwWESdrkQjbjHejEYfpnh0E9EwyG50P5XWtq1G2FZkWD?=
 =?us-ascii?Q?WaulO05nTtOSD922z+tzB67aK8ODkz9Mu84S4SxTzjq3/yw9qCjUfUJaD0LG?=
 =?us-ascii?Q?4QncCR7YCvLXPKMOdNd0czFrgEfG/56PDOdan0yabJ4dDin4ljs6lvczWUAD?=
 =?us-ascii?Q?vWpXdyF0y/P3kDt6fJvEJphYm3itR0hxf3rSMhrQUVuYiIoXvU8hIUMIIXOF?=
 =?us-ascii?Q?aW/zdt0NK7i2XS8YysCEy3b+5rQ8i4r+bG9eJ0XO3+3tuYcHQy/K+XKw+zh6?=
 =?us-ascii?Q?21MWclDoXHOp+ABD5n7PkEL+zLi34u4wbxR4Cg2DnsxoXOGmSVne6to0Tz8F?=
 =?us-ascii?Q?nPzaC6yLvKvCt2xQKw1A/vEkBrQXdokX4+KItVepohvqnqGzFqxb5i8A+dZC?=
 =?us-ascii?Q?NztWPWDlWJsIxUhjp+TSx32IXdLcsps1FmZKSaDvQybR5yJP+NQYXWNJUR/h?=
 =?us-ascii?Q?9KalSBhEdnS91dx3HnCLqV8QQUQgo5Nq3dedYLtOfiVkY20kR296sF2UC+JW?=
 =?us-ascii?Q?pBpkl8HdHEEuS3c/1nTOE3qh+nGicIFKd58LY+4gP+SmwBVuHv66zvOHGm5N?=
 =?us-ascii?Q?CZoXDz7BpqnCoVvTaOBBQfto3vZBsiEpZq6p0sgyJCii4sjk/5zVxNa6sFML?=
 =?us-ascii?Q?a0BALv4E2ap3KZipIYNHQZVA8OZKGfJklDFf6AWKPBTv7h0nzPo4uz5qWfZ9?=
 =?us-ascii?Q?I60nGQmoSefuwcf2dGwcdjXafa+KI/LB14nLUq6+5q6QaJ6w9A06Fs/z0X1m?=
 =?us-ascii?Q?/NNlm9m1yVYpLG9jfgAtGHt0FI2NWQuKHxlp8GXjVnMJ+K87krqzZ55cBh0y?=
 =?us-ascii?Q?11/PqLj0PUKtg7QI17y5XZZ8cE+r8KVVhsSjtLLn/WwwLZ578HwheonS3U+Y?=
 =?us-ascii?Q?KXZYLm4VSoNoxVr8K7tGwCg3yP3v2bHrHmtOG+hJUuxNKVQfR68H/awKTKIT?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553a0b61-67f4-4875-7443-08dade2df61e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:21.1838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZO8SvrzdgLO315BaY3aE6tw9Sg1yWm6DPHhAa/DRXDdqvfF7tAkA3oTptSf4N9oq+xoY65YLj1tCaqjzcnPoyzsq7CSo161nQ1qTnd0EPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: cvGuo6y-eiuCAII5Sf3kZVQAyCfAZJy3
X-Proofpoint-GUID: cvGuo6y-eiuCAII5Sf3kZVQAyCfAZJy3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sr to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c       | 11 +++++++----
 drivers/scsi/sr_ioctl.c | 17 ++++++++++-------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..9e51dcd30bfd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -170,10 +170,13 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct event_header *eh = (void *)buf;
 	struct media_event_desc *med = (void *)(buf + 4);
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
+				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,8 +733,8 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
+		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
+					      buffer, sizeof(buffer),
 					      SR_TIMEOUT, MAX_RETRIES, NULL);
 
 		retries--;
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..5b0b35e60e61 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -188,13 +188,15 @@ static int sr_play_trkind(struct cdrom_device_info *cdi,
 int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 {
 	struct scsi_device *SDev;
-	struct scsi_sense_hdr local_sshdr, *sshdr = &local_sshdr;
+	struct scsi_sense_hdr local_sshdr, *sshdr;
 	int result, err = 0, retries = 0;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = cgc->sshdr ? : &local_sshdr,
+	};
 
 	SDev = cd->device;
 
-	if (cgc->sshdr)
-		sshdr = cgc->sshdr;
+	sshdr = exec_args.sshdr;
 
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
@@ -202,10 +204,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_execute_cmd(SDev, cgc->cmd,
+				  cgc->data_direction == DMA_TO_DEVICE ?
+				  REQ_OP_DRV_OUT : REQ_OP_DRV_IN, cgc->buffer,
+				  cgc->buflen, cgc->timeout, IOCTL_RETRIES,
+				  &exec_args);
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

