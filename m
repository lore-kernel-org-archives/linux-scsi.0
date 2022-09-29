Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF6AC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiI2Czu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbiI2CzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B174F191
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:55:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNif6f020801;
        Thu, 29 Sep 2022 02:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jaChMzsQ2AqofL5QV7lsV6jKWLsgLD3SnH1sOXW49vw=;
 b=HvomWAhzVT+ImSeSp63/91wJK7HcNayKi0eNqzniXy0ckIkF6Cf6ynF0wODJ0jKBmitI
 KE7sXHjgFcPEhLm52/+j4+lJmKusrs2C8HrDdVHNuvGgpeWDpOe3J8PRcqGsQcubl8aH
 8V3cJEiHfRjO2abNbWVEe6ahDOly809oinEwxoRahKsuNeImPBnZgIO0i4kl+a80qYs/
 sOu+a29TnDD/UoULW50Vb/Fc8I9EzA1qfYQURTaR5oUHzOp8U9JLGtHD4InAktDNtjFZ
 kAPJr7ii75Mh8u4FX48lXIMkbuCOg4IpYwRuMQmU+kXV9Sy9CH9A15hbFR8K+HM6IEw2 Sg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM9Skp039489;
        Thu, 29 Sep 2022 02:55:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcy6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKJz4qv2z9IRMOSqF7sGRxrZqUa1Vk9xvwiLC4IWxUQIMoUlNtmp2qdEEArCGXh6M40yNYQ/lWBipA5qXZhlsrjdue+a3/VlZLch/HNgBNLzPqrVoGR0xUQ6RIuemO0L+fWMoGUzNUcjm173GJZkTacnrXkMcAkUM+Iu90ggxitDegXqM9QaU4T/WPNQeMKNA06EWGmSUR2i89JTplye0RbAmqhc70emMUcnXgcwIC3wg9wW13J2h3kXUDfWCarXgKWyUAlsW9v1h6DkzWNm5ueg7yHdQHOlox5/gp00z8mBH5dchO85m3B4thIzwPmaACV83kIApqehjfNq351NEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaChMzsQ2AqofL5QV7lsV6jKWLsgLD3SnH1sOXW49vw=;
 b=XS8kKRLpZYD5zoL4nKBieAjQ7nRtFHMgf4nCmWyxPwL2R1fiCX81hIsblK/B4tYdDBk2ZxNvs5GiYp+CSDIblaKJFSUZ4ozlebhDFJvBgryy2udMslUyVB4AV+FRBIVXT51kQYajfx1KP1WLhzOUtHH1JZnDGNNtCl6XhaqxG7iGj34iIWecJT8iXqr4aBtvlkqhn8lyKcJo2AozbBN9EVnb105Imvb73hwGgcu6JTJDoCvT+tlN24XbjxP0HlKJtY6r5iz4wF1F6hJTd0fmO9hhpZKYm/Bh/g77ugwxk3FnUwEtt4S2tsfDJY3ocnwkLmtvSPgI0VmWCJi3FTHcgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaChMzsQ2AqofL5QV7lsV6jKWLsgLD3SnH1sOXW49vw=;
 b=DONdZ04fW4DJ+sw3cpDlCEg0J1LE3vJ2Bvn5sf0DXf7iNMckYgme+fbAe+i4M0iSiWP1VjL+yuRBERfALSZtLKhTgpEOIQvKNMD8Q+A3mN6dB/ErUeKhFpp/md2jNZQN5aG0JLcmfMGLWmVqXPUPUysWGLOBm9P0fOE/RyBGVUA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:55:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:55:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 32/35] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Wed, 28 Sep 2022 21:54:04 -0500
Message-Id: <20220929025407.119804-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:610:58::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: a1335a67-13ee-4a69-e59a-08daa1c60014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Telqv7jyO7ybeLISmreDjEIbWIspEtYvTMVDFYjlhpSV1zVe/XZLwbsiZ9VZj7lOpzn6DD8gR7vrzr7zvIQehy1e1oM2PmL4k3WU6+b/asdgl2qfN8u9QrYbZzAKSB8Vq6F8qq+JT2jgAgLLDCpKiXIG79Vleb5XSTLYS4JE38jxRwNndvpDumZbG7LBAaVcdd1yWPu1rcwU0WPzDbqAPRzxngZX97sWTIb+eTUT69M7AU+KvPaycGRsuZSw/VB6X/0HDtFBncPrMab9q5QURc/jKA/PG5nr8Q344P5u2NeDlqqQdv/cAL4SMoVMRF9e4QbazL5tgq4k8dghG873y1PaA/oGz3yVKXRvYNCe7aWwG8qJIYAl6/+WNNfuylrxxbaDyWb37EVPjyplovSqifaUY83oeo5nrszy7ErRb9fPVU+g4DMecS4uXdgYsjw9B63sBsqLy0kE9O2T6Y+eqPZuwCN9tGvq5Jc3+uUcWgSgzIQzpDSM2x5/2eX1yMO1Um9xxF1Eed9jJoFUJax/psVYoEZe8r19fvxOAvqRkULFzcqIhibXaxLqmEsxl5T1pSUk+yuNyGaDrkkBIMjGyRqovmOIwJRPuEVXEShtw0cYIqNBTdUnJ2E5ciMMqht2xOaUWsCpK+ufh66QntTuau0U8YQ02IoWGnTy3oXB7zyVeLVFiQue+be/UDoEA9L7+oTPWkdrPZt5LUvGvpVYjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzXvE3WbywBssZ/8z8tyiT47W8vStR8H8g4XAFpHLt/ZpzmZaUc1VVqF7r5y?=
 =?us-ascii?Q?VAXBZb9Ch2y6JZ0SOoTu8xpUevEVkSRO0upQhR4hIcHVXisWO6//tPGYBLNd?=
 =?us-ascii?Q?9jWyWLP6mMT6j9ZxMPfK2MRcRo45TkHPhYvB5EOnTDPEZICXHWeRLOmSnx5i?=
 =?us-ascii?Q?zP6Y2aj3R7MoZ+p93/NeZDMbYxYr0vTxtGuRU/Cp7vvn9KqrR7TS6z4K3jej?=
 =?us-ascii?Q?BGElMuq5G5RY6XyCbq/49KD/TZBK8dOWBfQCIy5vWIwtxD4pA/RiHYZP9Kp2?=
 =?us-ascii?Q?U7NraroYArxj2X7GzmDXT/+hl41/1E4iao/N8yvbxJKHlCTDgadkDIgplK5b?=
 =?us-ascii?Q?AvyNopujAY6M/D3aUBBozmj3spGgXErsQgaYWTwjeG8IG6KGiL+ihKYTfHOp?=
 =?us-ascii?Q?d+5yYCnzuvmmpFMXAm8n5O/bBgyiC8nfQ7fSV8h35qYRBTC2UJiQuiBgqqjv?=
 =?us-ascii?Q?3OYWwipO3FzgjSQjH/FE1Ee76x1lp/wOhmEc3TMXJUs9m28rQFHj/b04o0jz?=
 =?us-ascii?Q?2uyAezn6nJ8x27hlYUVW5W2buMWoZH718WB3g7c1mmNsG9M0ngt0RMD9cgsO?=
 =?us-ascii?Q?i5iXxLNg6RiLa7ma0w+DUaxHFx/5s19PF+A9nrhAXGEfiS5D2ns1cr6PGHlG?=
 =?us-ascii?Q?wEyPDBqM+kB/fynNperHBfUeiDZwnLiwJwdjVS5FpnqPqmDD3wzJnlauYPD/?=
 =?us-ascii?Q?seO1T4bL4tzg24WeXBaEjvLEoPndZ9SiLovAM5Cfncqx26ozXbok/v39geZF?=
 =?us-ascii?Q?LgpLXqhxgE2BtLdFXXPvUczWUWHGLK7eiSvF9bT0zbbeTLro2X/5OVbzRQ2w?=
 =?us-ascii?Q?AIM95ofRE0Lp+IxnK91oNDdxDRWq1vzlHoqKX4Z38UIBhgiWZ7npDOwGiExi?=
 =?us-ascii?Q?IDNxyLuhHRiqNbCDl1sp+YActkVg9vIpp15bDksJ78coxyGoBM2tsEMBMc+m?=
 =?us-ascii?Q?Hjc03rm7vq24gzBU+WjKFyRFQULZNYFKZzN9JtF9syptTso4n3fnCG+EJSlF?=
 =?us-ascii?Q?wm5WV6OrIMxMkTZGOOGVmp6bt+2ju2HPRo6xnxguaugSo9hX1he6zdeY5SLq?=
 =?us-ascii?Q?e+q1yrrrlmYDvPoauY7sG/R6uXHeQRZ9mooI55e0cykBhQpykGTg+3io6Iy5?=
 =?us-ascii?Q?kgNQYgAnaIymw8wT4oQ/VR/rdBDG2PkGsKoBn9jx7aZZWOrABqYDGuslYwQV?=
 =?us-ascii?Q?ZdAUAGfBUtRxI5LYU0dzNsGNX7F0X8z6Daw9V/MMCQObjI6wmhX2A839CYD4?=
 =?us-ascii?Q?XV99dk80Yb1vI73KAVEMVXtp8zZs+wWWw1PJ7Jz8WF90Gq2PSikjLeE3m49h?=
 =?us-ascii?Q?nRfvH21WNBUPd32stHOSy4mD0JkywqGorh9WVGQK3omHzYwFM11slsEn7zbL?=
 =?us-ascii?Q?Wwlwrylu2MahWic3IO7GyYllPgnx/GFOJddSBRtwacCAQCagCl6I9oy8kqMA?=
 =?us-ascii?Q?bh7YMbQ4pCXoScTvTmJh3fAUbN9jX07JaB8T1n/9/ffDmuKPVVM+2gq+fLLT?=
 =?us-ascii?Q?duMzV5EqlOyxf5w/sIM+WaZKpqKsFBdaFOjEocD2xplBMYR4kCNG/go3zP+i?=
 =?us-ascii?Q?zUJVFuk/m0v+/I1yIO8wcXaGTuFSZifmAr76XjjS2PYhvPwKwCrcJl4IA4zz?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1335a67-13ee-4a69-e59a-08daa1c60014
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:55:00.4717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qh7uPde3iKFIJPHTkY4hn1eVjzoYpQcmS59ooxbNn6ZfNn6/OalC3c8KgWxwbfVj+JUD893BzZ2/qBVqM6vrtDkD6Ul69DLeUcRbIA2mCU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: IMsrQpLqNJmqaAuir76s25r1BcBZt0P8
X-Proofpoint-GUID: IMsrQpLqNJmqaAuir76s25r1BcBZt0P8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 60 +++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e7c7992b7bf3..0b6beda2a039 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2409,41 +2409,41 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = 8,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	cmd[0] = READ_CAPACITY;
+	memset(&cmd[1], 0, 9);
+	memset(buffer, 0, 8);
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = 8,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-	} while (the_result && retries);
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

