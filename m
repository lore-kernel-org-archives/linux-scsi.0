Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9ECEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243254AbjFNHXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243325AbjFNHWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:22:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E852707
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:21:04 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jlbm025270;
        Wed, 14 Jun 2023 07:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=4/Ia5W0WVQq4f4aV5B5uZgO45zDkb5N17gJb7mkbDlE=;
 b=0IyQIXGOCREAd11qtGMx+lXW7bRUECOu1gz/LFVBBrHy8BTAEjy55rUdxK8otn2R1UTu
 UEr0h1b+6zdLhOlimKSFxoFKa3AgnleN25tGP9iZ+GljLv7YWgNWkoWuwo9LnFdpHw/m
 0YvvLVnV6B8/89lERlWTXQTqU1cgYtHYGNk3dgwr4rlKUehpspj1HQ4cvmjg+3SSP8KU
 8vFx95pn5JYlNlbgIlgN20c8zRznQErj51llyoKQWVWiuHnC8tT3EAhk5LSjHHRXJSe2
 6zZ/nAX3blbJTA2AzfDLWYoYCscQ32mN5MufUJcbGP6zQxUfn/UnYaNJFgyfBjfk3gAa Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5bIXX021593;
        Wed, 14 Jun 2023 07:18:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56cnn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:18:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOiuz23TDr/bxp22hw1FlYbpM6efFSA3E+GXo6O/15nI+eNbS9xk5NuroHLnSvkC6YV3agwZza1eJAvbmdUsNilnQYFi7BvOxrNNwaxewnHpmCAYKOsZuj3Uh6YGfyEu/iIwBV/xRoQTlKkGC809b9Av88Wja3Fhnmz6bBE6blExxnrOLo/ruoiD+H7df+JxqFjAyzY7fLuaZqIZBDyukdtrCDCJYPZUd/Ov6TK76wWhXpDPFq24v7wH3UScZtWeTF5c65Zu0v+9FSSR+6VrF49gNrSyfJiCk0kBzLLDyNMI8Ls5+g3hsVu7S5Ur3anpJEwhGButcrt4jEJ7fu+WSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/Ia5W0WVQq4f4aV5B5uZgO45zDkb5N17gJb7mkbDlE=;
 b=WieqloxqK3kCJHZ0Mt7UW9aR12nEhbKxvGgSwhjnwXgfe15Oll8BoNR1gnCI4AIcZ4AoFftQUqbe7ESc1LpNYK09UKCGKe6b1TPTl5+oEM/FhBCKBXcat1WAgd+aopYe3QH3puf6moxUX6H/SjT0GXN1QpvmSGtXoLFCIP+RJeVWI5RVOAjLq1s/Egj8S95qJ2XVwVbQe2nhRLpBEZ88rkXqym2HBdLgOqunnVjYJmgdQd5JlsaaI2lFTV4XHuX2m4TjJVF56D7kJb12CCZKLwDQMRuzBCxMWuZ2cbFX0IehfRDwCKs93YDYTsZxR7sTZ+NZ3JK+7l0cZenv+/7eXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/Ia5W0WVQq4f4aV5B5uZgO45zDkb5N17gJb7mkbDlE=;
 b=z7mpSQy4ZY1kpw3Xiwgh252+7FkiuY8gdjbmIDHO0CBU4PmoIZaUqC7mFjpByY+eKUfI7+pLHukS1nSYWzXO7W1pX7mzC42N0q4zNFhzo9BPo90yVPMYVhyCKdEvJcYTuUWPWaI9sciTGExVU9wiWKOy8EO3fzhoDiiu4OJ6Zy8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:18:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:18:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 28/33] scsi: ufs: Have scsi-ml retry start stop errors
Date:   Wed, 14 Jun 2023 02:17:14 -0500
Message-Id: <20230614071719.6372-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0033.namprd08.prod.outlook.com
 (2603:10b6:4:60::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: b48e7c7f-5b6a-45c5-dca4-08db6ca78252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjv10ULQ5D3xQ8Tgy3f+tRsMClUhqa5GwN/nNLWTEwKi08VjCuaZujexFRBcxzxbg25AS2ocMCOB5amIpqyLY+YciaNv5XtBSOMWvBKzk1mLh6gyr8HeNzW4o3Cy2aWixeYsEv6IIW1Co5ub2jKu2McSfhzZMMH7uD7QHKqna7kPNvYG3o4pa2iQG5ihAJIB6B26hRQoIKixBgMSiDAgvV0t4jsU73vihDng4JzwtwDD69oj2LfIofbBOwbLqSByw4T6PlEeS9bkMv8H4JH36v6Nv/k02rglUZ4oHJQotMVxGNAAIt6KvS1h3MepOzOfg5vjvddfqPfTYBCR+Gf1ejvmaDt99qWK72bON6Lk7YrehKXWv86qDxjQ7YmuOfca2Pdzk0snVc2RvejHUJrvpqPlRHBNH0vDaUYl+mqS1BSUJL59pA+moQECr7RHHdDGAkOG3Lpg8DlrRwXALv+5b3yBmb7aDli6UoEVkn6bm9OxHCdP6zFkwp6s+XA88Vx+RI04dAMFmCXcLzhg4mMi/7oJj5uYvY4S2b4jI0xlbpJda21C4yl4fs9zrAavE1F5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qgaIeiR4GTr8JQWPiNlMujkE8bt7OufMG574O3luADV1jx8PNJHyPQu38bMt?=
 =?us-ascii?Q?aV0dgY7A4Vp9EaZA6JJcIiaTKjoPhFSeTIE6njR7PcWZgtZmELbhrjIhnfPQ?=
 =?us-ascii?Q?xWAwu5rUWfF4+xV7tUQUdF6fO2Hg64HfVYECdQYeYqxUapw1egwdhqOawsBm?=
 =?us-ascii?Q?0v7nzPAsHNGNv39ICpzOVrt43XSAkezdTWqrKcKgIVe+R2jYFG0PqGYfhOfv?=
 =?us-ascii?Q?oS9AmtMkHaiNyVioEToF0L5NqguvE8sn1AHvVkWQ7tUg4CEN24AlzwLQtB4s?=
 =?us-ascii?Q?PlZoLcEk3i6CZ3VP+QDfleLMZUfqg9Gymdr/ImxJcbTULCT8GV6urP3ehX84?=
 =?us-ascii?Q?B0LTczuRkE2UXvP8jK1L5X1fqFhbx9Dho5pnHFPx9a91hkQgyWu51x1O5jUv?=
 =?us-ascii?Q?MZaYUx+Y4lMlHXU1lfSkHmf2hKN1ND+Y6eEbs6j7JaQSVOrmh+j7A5K+RiBw?=
 =?us-ascii?Q?dErRH/epcIW+Ltc/DepdVdv36fke3u/Umc2atb1/FR3oV29x5WKLcPFB2bRU?=
 =?us-ascii?Q?s54b5pb2gLgxSCbDbhZyJ9KywVvR+aE5OhEFtrrxyOWsRbYeY3w0fpU07QzE?=
 =?us-ascii?Q?MhsjGisZQ9IJFRbWJMHKB1PpmcvCoTQ6Hr/D2sdPxwJHAsx9YgwlVs9EriHJ?=
 =?us-ascii?Q?4kmMZgyGhMYMI86a/opXgx6BB5zcnYFjvxHeIYGuYuOHjcPBL/JgmHTtfEJG?=
 =?us-ascii?Q?lieLeuuqnVYS12bW33l/9nKWuvurhDrf5/Rl3L5/PiycM4oj78DALzy6tLKF?=
 =?us-ascii?Q?NSNbH7AL4qATK8ByMkaCzOFvO9/gxKBYPDzsTFgqoq5JH/6GJhG7WWTiO2Kd?=
 =?us-ascii?Q?n1BvNlvzgJUzDQ47nj2acjQDtnVhi/kVn5C87zEYdl+hu3lmMw7RZICELp7u?=
 =?us-ascii?Q?QGC17HlmoMCKJi95RyRTWesDGv0hgRrEE5iIQqUeMeKuU8Wvi8P2JKPAsXXV?=
 =?us-ascii?Q?kof8FXU0kEhWOw2qESfhLfqRK+LvyKKwrZ2f1HSQD/s0lm71KD7jv8tbOk4W?=
 =?us-ascii?Q?vrOx/RPBX4YAH8XIlAZgZpJufkAGyv4sQ/feJZDj0WwaGohvmRfwsnH8uML/?=
 =?us-ascii?Q?aDlIM7X9xKq5kewvPGRlw1wZwZqgjKFkO4N/T35tr0WCKhDfk+OsWfkfPjTX?=
 =?us-ascii?Q?unZP9b1EQL8HDW3ghSRlI0PqoumIBE8IIUVhBRacVLlVf31n5N3Yzxvzqnha?=
 =?us-ascii?Q?1pf33TWq85YDHeTuDlw3c5mmKkr9Htu6ScQ3jO7irrShHKB36gASQeCVqL9b?=
 =?us-ascii?Q?hWDPg4APbCFCyYCDE3G+tJu++tyRuAqBxJO+5UHFK+loz4z0GTqL8vrEfhD4?=
 =?us-ascii?Q?waasWMJiPFzxT6WWes75cMOOM3MOK9oBSfvSLZA+Pw710TRZFGmAbXzxfRoj?=
 =?us-ascii?Q?zTMPRTOqJWuB5oSxaTlN3pdLooglvb+WACJt3omPvZ6GRatSDNV5FtSyuITE?=
 =?us-ascii?Q?8064K27LfmqbhGqd/BW2ms5KWK/swTwcK60VPiazQ9fFmv+oSqyEgCjK1TJJ?=
 =?us-ascii?Q?OBiReLbi9JdTxh9DRDX4mucpusgM4o7WyIVmNuOG9gacsteIWWqLnPIVZnjr?=
 =?us-ascii?Q?9c3yclFJBh9yPnSMuaKZyxyZma7jNcAaUJVQ9Hpt8Rtf9fQ0W7/2ro6BekJk?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WNREgn/FuyXMRptmvqxJCbuLFVyNSgjK9AzeVGM3shpq+ed7IluPyasYEbkSriWBmBxioN+QF7z4L93gutmvqWrGsv7dhwoIWa7yUhD7IS6UMvfdT2vMFjnXeSfwOhOS0ApO39TfVmPzcHi2UrfphVZV6XwTc4tgotNwSOnvuSNRPOuOb455oIcXAOM5XIBiOvOs0G4vrvh4hIxlOUwfeRcfd1PALRbD+jNmgLkUununMkVjnVOQyasKmqj4yd3fzpq3KXMcWZHyCiDU9L0sUpF1OYftVoUGX+Lz0WB7ex+4nQXTT90ZLGOSXyp+BdyqmtFQ7ArSG72wtLgL3PdXs/4jkx2jkqOtzkLr1aehSltnF4hTLZzBVNyiwBoZojNCEtE8397H1FrBPaOJpoTaJKrU9l9qlG6hjZrD6QCqkQzv5Yvjr1U7+TqGX8DeK+PTeHa6SUYLvQG50kxDg06JEwqSh0tU8x9g+louMs62UZSzvwFc1opOfPMre8s1/bwa2wykfPOy7StapT7AggAsFTbQuSCm2kf3rMuijkTGLxbQ637ZtbEvgk24Q8gG8Oc499MAy6Q4niWbynJVulfH9IHFz0hr02zYh35dVuxFjGm3BhdwtIqRyMsjPGJGWGEWmROYwoE90Ljj9RYtnFF3+4oRkMDWypmnZr5WXvapF0BmONtH7Gmcv4ab5nNmi0TzItvui3T1f/Fb0Mj/jnP9FKk9ib4wY+J92mu7kiO2cYtMhMMV45jmCNrz+wPjsNs/IBkr/J6EpmHT/tcU29gHEee41xkvZZtnXZncmtrkpyQ7kuvtKkkys/owTnC9QZh0aCjHDBZcTkCzWQqutHOmGHGyk2b642HVcjVIFJ+VGo5rus7HI3vMm81rJEpzDaqY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48e7c7f-5b6a-45c5-dca4-08db6ca78252
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:18:10.5974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eGC+cx+avaAQJ+QHTpx+XsqG87FHHLE32pnlDmwuDxa+CRNrpyUBhrxTU1s1sMBGn+/FpAWdcOZTItLwiT/5KaAwd4EcYGIxn4T7EFozCJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140063
X-Proofpoint-ORIG-GUID: b0JrBQ9igFRo4cBxonAbn5qeNBkeD-hX
X-Proofpoint-GUID: b0JrBQ9igFRo4cBxonAbn5qeNBkeD-hX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ufs/core/ufshcd.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f2b3abafcffe..66ea125f5e7c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9284,7 +9284,14 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 				     struct scsi_sense_hdr *sshdr)
 {
 	const unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 2,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+	};
 	const struct scsi_exec_args args = {
+		.failures = failures,
 		.sshdr = sshdr,
 		.req_flags = BLK_MQ_REQ_PM,
 		.scmd_flags = SCMD_FAIL_IF_RECOVERING,
@@ -9310,7 +9317,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
-	int ret, retries;
+	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
@@ -9336,15 +9343,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	for (retries = 3; retries > 0; --retries) {
-		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
-		/*
-		 * scsi_execute() only returns a negative value if the request
-		 * queue is dying.
-		 */
-		if (ret <= 0)
-			break;
-	}
+	ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
-- 
2.25.1

