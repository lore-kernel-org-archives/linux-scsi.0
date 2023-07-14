Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36F9C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjGNVi4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjGNViy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38F93589
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:53 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4E8Y003214;
        Fri, 14 Jul 2023 21:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=yYo8F9i4CSgMX+9SOo7HMBheVQ3QktMILoRdiajQEIA=;
 b=t/bqvPy1feV9SDiyEf9rIJ2HUX0Ta6LZX75xNimEkZVYN3psSEl4ET3r8RegwmtGVUlU
 8WEPE7ZnC7HYQtAqayWXffi2apwSqv01ahOYfkStqbZiPdBHq/DB08lAv0O6MoA4pvYe
 6ncZzCBQTqiju4dw5fZuBtBNeawyqXy/CVdNgmhcMJQLPQyp1n4Kr09CkmWohSDpfpts
 +mrFKyEs0oX8ed7RMzMqxEZf1KPlfQ+nLY6cMBb9yZXlr8WpQqWw0fTvcies+CWouosG
 0y5nNTCl96Q0MovlcetFSmvvexl5oYwzP9ur6dMrAnZVNE04QxuX2fVSKofI2A6z38XT 2A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK0JIm007621;
        Fri, 14 Jul 2023 21:35:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrwye-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOnKFb4q6mIHwKZmEJlBBt7EBgzXLMJpdHZaukegCPFrhofrnZMAhialJVP8QVASIHQNtBkr+8jtrKUuFkSRaqRRlXFatcZwJYA7W0dzb2YRZoiTlrF4XBpI3KF/07VMGV7Mg7szUkNuLI3v1F6qZx56d6HW7tBsZsbGgFeZ+h/vqEe2y4UsvQZ13jCuSkPIAh3bw0Sgi4qvDb3NPkFCaMCNPNdIRG8E3LQ9w3djSrA2l6Zu4Wg80GCKBP0jXQFXu5X/wyeHgsSCsyHKBIy+DGsKUqmJsbs6CgDiS8CPatxiZu7RHcih5HHwRSzubE3rQ8jcglZTOVNVKDNPWxS2hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYo8F9i4CSgMX+9SOo7HMBheVQ3QktMILoRdiajQEIA=;
 b=V3l5khzNPFsMoudspWZpEssndT+O08Tqqzal93Vz5bToZQuI8a0JEIXYXCWgpszzUKBDJ3QM5zESCQaS1V//0c6SAlZCSjxsEb9nRO0NnXLMHPx3AGezfll6DJqf908B80ZcFbOLfXZ4wKNZ5yqhBohIzeaYLi2+1OB0NIVqDY9C+Is08Gz73GXIGkhUd2M0cKSjuDnv8lo1eCVZyagxRyzx7Y4Ud4T6vCtctkPm4XeQ3s2nXzEko/Y8fEUd0z3RrZO8KBRKrkBQWgUSBrFkYI1zeS4JRN9Lbhlz8Zp0lFfEo3bMb1rKIOO9ksr7G21ooVAp6k3bcfUOYl9RhxXseA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYo8F9i4CSgMX+9SOo7HMBheVQ3QktMILoRdiajQEIA=;
 b=ljTgA+Qq654Fubsrj1shpcfeM/gzJHOT2DLW2xHLySwRzy6ltBodNvKiXgNtf+CoBLYu5JDi7Z/oY4e7M3ANL2vJ7lAnliR/uFxPjCImFq9bFmliH2fghgYd//nnJZE3A8q1TqLEOrMHGs38bE8YcUqqVt7MvDxNuuLil2GTTME=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:42 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 31/33] scsi: sd: Fix sshdr use in cache_type_store
Date:   Fri, 14 Jul 2023 16:34:17 -0500
Message-Id: <20230714213419.95492-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0139.namprd02.prod.outlook.com
 (2603:10b6:5:332::6) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: 826fcb30-5a43-4644-89af-08db84b23546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XING3cZB6sCDLUG2VRkmQ2AKqnPqaMyLkqeURq0Hak+Qh30aVTHFW8sbhyXDLTo2ejvyrUaT0Vg+mt5LEMBaeNMcSAlf/PbuQ8o0cqeZx7Baq4u5OaIEZGynDawxWA/8OHkxbylDx1WQ+57vVduASHafU72p4BTjF36eS+5nu+OSS2okrc2TKvL21FrY8yd8rCASgUDjAjCmL7OR/biFZ3jvY4YlumrZ/E4KVgk41tvg2hmft7bY/Uuu92HOkYOcDZpkISrBvkSA8QfBSDUhYSEEsrPKPH/Kn6ZN53433eqJZFDB87mFBGBWJbEW9X9MQF+VVtPuWvuYI5jzq4hl5GZYv+0LgAjnp+HR4A7aZrvQ/67j+5mdVZOClW9iaIq5pQPYFnDZLnB6VogQ3xIHvuopeXhCkET0x0TF151g0YYn9YFivfMp7ZaTCCM0D7PI3EimPGhFRgcUxSaHSpQY5aA8i5RVe51a/3CVTeqajShqxcsuvs8Gl1UdXohOUelRSAQrK9ALKki+vrborIGAqIw+uS5Qd0GFuY6d4bzZOnHbfOMxIqzOdmGExq1J4jPh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OAgd1rhEYtyBsp/r2/d8m2ZU0eqXOR4MYD6aj3Wb0pAUAqk3fNRM/h5CTt9w?=
 =?us-ascii?Q?NM7wPNBmY6UKXC8OFq/0UMf8OoO/3noEXJYH0MgkFB6L5lFeuJ/bq+diNJ00?=
 =?us-ascii?Q?mlAXyYLD660nEEocn04QUIjdAtXBCAaqiWU3CjIVA9giBrC6TREqG5tb5yDC?=
 =?us-ascii?Q?kgib8PFREVXx4hFLx8g4PH4AgkAGsGn4xNpiOJVrty5hUm+7ucrccyJBwLBs?=
 =?us-ascii?Q?x/y54mZofWz4LqWBkV0i+AntRABxNd7ZKGLqRTOIAHV86krM7DiaYssujXvj?=
 =?us-ascii?Q?m9XI0kBfg+5L+7rlJGBad5KBOm5FvzDg+pjBOdTK9sC1RAXbKkiOCAajLuJO?=
 =?us-ascii?Q?gK68CkUyjD9otjNyMrSmi+IZXkrtOsyUffCySWkXmwSS7e4GTiviyqCVmr0d?=
 =?us-ascii?Q?QLSP/T6wRggfotMHSns75fj+G/OW/GLHksghS/YLmO1d7iiQa2xLyw36J3TR?=
 =?us-ascii?Q?4W+Yy1VK34E49cUWmBG6rElgnH7uDxVta9TGUoUFk77zpISEKX4lZmzLoAE2?=
 =?us-ascii?Q?B+bIgpmGZNgaXGDZBh6FLW4YY0bU0Enp7CXzMd/J9eLyHHEzX/QFwJ4yfmJC?=
 =?us-ascii?Q?GifqnI6vyRusC4BoxveH2tHvWheUPvnlT0HkSggVMq6HSiDKOmmD8OMFltCb?=
 =?us-ascii?Q?gcQ8KYchwo6BSHgV0q5s5I0CLt5FdaKKI0yL1iF9ErISGDvB3v6wq8abi1Rl?=
 =?us-ascii?Q?+JeaibG374z3iEmCV9R4L6ERJwaph2TNvJI2LpGSn1sxDQj8WAYMpYL966v5?=
 =?us-ascii?Q?hxKwWIhD0NuKpoV7skzee9eCmK6ou5v+58gQ+CMClPRKeDRL0DkTxlqoTJWv?=
 =?us-ascii?Q?rbK+Y9cEqFymzEl2oYaCdU3kTjYIgsrlfVR6ROeTBU+ce+naAxdTY+BB/lPY?=
 =?us-ascii?Q?w+krVW27UwGGoCJcDOtnTJJXkrCOjTZHjejG29vRl/oOzSTPauD0RUUYxzFT?=
 =?us-ascii?Q?9BGBzcS9KWnoIyBeg4Yu3TKW2PydpWbsicLYytC7Bb483wlvd/05o86O7FVT?=
 =?us-ascii?Q?gTtynKeSC216tz65p5UqGXwnovxRhfBBdpmxAdb4kYF2RHcXjrtu9//chhT6?=
 =?us-ascii?Q?J/6g6KaNrPEW/XPYqUklnxwUVernUsP6GQua93LTI2iEfZW3meEg3m2qyQh0?=
 =?us-ascii?Q?bVWdNF9Qg28BzvN+mrynV/zvALxlFJROqhDJZSnkuBaKaArWXnsnzxG8mIjG?=
 =?us-ascii?Q?oJ2OK4z63gX5VHGUCI6mO9H35M6fqONhenwKhiv7/ucMZdGka3no8ZXpi4XZ?=
 =?us-ascii?Q?9UL4QcKWYKXMaQOjrlY6akuinFQJEUzl13vkJ+xsb55VM0hva1itMbbZ/MLS?=
 =?us-ascii?Q?0OCNGDEzHbT4Ylt+R3ETYqjeS/EDaC7uLVbs3V66dpuZb2ha0exyz1ZhNWaC?=
 =?us-ascii?Q?wJIES64hrtZc43hElwdNYBRG+qO3MBIzzGX3K6iDT2G63Vb9uFewD1gAqpSU?=
 =?us-ascii?Q?lUEYDw9PivVKg1VbCAW/Tm7JKtzjXhf5gAUeoxRYGQZidiarmhXubkN34e2F?=
 =?us-ascii?Q?ey33IJpewCxqMfteZpNBVxvVHFuARu0934HzdY3VGpJl296qjCYMiUJSu15M?=
 =?us-ascii?Q?CeuvRu/cHl7fK+v8gCce2eK22tiH1DJjxQY474vE2WsYD+hlHr0elEFz9Y7p?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ho7kSuopalgi+rtP2OR7lq5XIvwx4x6uUkTxuuPuivxwlFOeJzOgvShrsCzXqWarl7FAQZYYD0i7VHzUz1cCtOflQc6nR5BGGrK5bmp+czXnKSgFBZ2GYzdal6gPIgMfbHLl882KJ8DefJFq/FZPtmt2QhOPMxtsyCoI0SfTIiOl+SHAEcCcxFZmLdMpdju6nJnrlyFNt4BaeXMK67J9RKcrDih4mZB6Kmr92qBXF2Mim8R5LuN+NhF5betiaHbC1xLHrj1E4BfUrqmS29Dh4VTi1V5c9iOlZqUx6RZS+DwNlLohILcevY87SX9BjbhsAi3KeyT2gjyIZAiK/Tr5Ot+SRwf5hLqw7k3shErD5IWVMa2DHbETPVCx+CQs3cdU44tIEogNfGos/6kWycY7mhykL6Ty+WqZlambY0fvR4mHA5fulfsPMi6c9HqwgHdHCN3/s0VGfktIL0TXaaxzgcmKlpApfMbs88Rlm8xMMaIatNSUaI5IqgAgEYdRR4sjk9h+dKDeui3qvhydy5WBw3JQgNBmjBauOI1xgIWThpEewz3iX5KpgaAKa5VBvNAB2+K2EHkepYzyDamJKoXhdeKLwhUff29+5u1bShH/ATxBJygR/gNbCQ3GQ/CyLeWGSXXZ32r5AL5UNHgMlB+mi4tXNQYsUXJhCXI6caCOlkF48o0WuGBM9exAvcQIuzbw8eeukSsGHRWgToP+jONg61vkq/rWW3SGtfbqdQej0Y1vOaFLIxdPCaLsEGH+2Cgda34Z4cUpDmmVvqzwr+Kib6ljMLMLABfwfPk2Wc9Q+rL7NmaIKyIdpZ59HmBnzqW3gyMrN140Tx+LVgSf51GGoSN05gf1RTMv6b7T1Ov0N9tYg+lQitfRRySRrdVZRZqy
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 826fcb30-5a43-4644-89af-08db84b23546
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:13.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: li0bMN3BGai8eFiykiH3GS2ZJ6y97j31QZGKnv6ML2gTeC2KgCnyULqUoGTPwGvB17I/lBJkGWexd4ojkwBI7BzqW5crXzq/hXzmriXRiS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-GUID: 475uceyaqg1Gx6Wbm87kO_svQB9xun_p
X-Proofpoint-ORIG-GUID: 475uceyaqg1Gx6Wbm87kO_svQB9xun_p
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 34fb0f8d189e..da7afeecbf17 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -155,7 +155,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
-	int len;
+	int len, ret;
 
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
@@ -202,9 +202,10 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	 */
 	data.device_specific = 0;
 
-	if (scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
-			     sdkp->max_retries, &data, &sshdr)) {
-		if (scsi_sense_valid(&sshdr))
+	ret = scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
+			       sdkp->max_retries, &data, &sshdr);
+	if (ret) {
+		if (ret > 0 && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-- 
2.34.1

