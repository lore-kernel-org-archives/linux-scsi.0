Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205A5C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244649AbiHIAGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244656AbiHIAGI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:06:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769621AF0A;
        Mon,  8 Aug 2022 17:06:03 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278NwIiD007165;
        Tue, 9 Aug 2022 00:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=i8QCaPlvLaiD8zSQOBMYWx8KA0SIlkoMs2FhV21By7U=;
 b=s1XPzihGHXrXdFoG8/EGWOI7pmxES5nnkJIHUTplDmT1r71VVCvU0+A/bMxfj2WwU6/Q
 zIxWKx1SoVcV69OEE1cVPl+LhCcN6JpqeM8F9uHfQwLbak4HKGGsAT+E/wYcsS3Lcvvz
 DTFoRHDKolE7vBE422NzX3B7Uo1W9fkrCkAlWkpzbOx03cCMXcWHG82CKxr4RTSRmS2f
 nBWDKPscNf8ROA1/GP8QsqQEdblvQG2u6n3lUvaT8aT8927egcwa5h/vqLFJcbA44hja
 pO9xuqBfjRCf/43HPHpO/Bz1JLnCJg/2GDImBo9aS+eAOkjZVtaKmFBhAzWy+P7YE+Xb LQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsg69n1e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0wO9034454;
        Tue, 9 Aug 2022 00:04:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser2da0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAa65JDV7gjMOYb5eoz2+R2XrZKHmUjBTdhV3HVohtY37AuXguZKMQwzNIb/D0PU/b0xF2Jm6QTvbMkzXqdVwQuW1JW1ui+iGhKDSySzLTkdOXpZoGFQo6tYUJniTTZ1y+QM/RqqrrMwVIuz9l5M4tgptx8AwifEt+CpWUUOZ80B0lYAl92g3UnQSdQnyqsPI51VDbnN6RyZlB1yRIHRrwO5rMMBDzfBnD2YLqNYVzXSUvkoEmrhCP10LEpxQ8ZAPzmew9cGxwyDHdWTZwqEqajwe1vXiW3Al71nU4rcmv6wlHqz5f6NCwk/f8ZPH6sSnPyrUmSaF0+1E46q4/zOkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8QCaPlvLaiD8zSQOBMYWx8KA0SIlkoMs2FhV21By7U=;
 b=WyN9oacfC1/QYzvZmSOBomrxe7m8uZ+qJJGJDfK/6IPNFmxWGBlLhBhPcPCI0dD5C/OhkImhlHPRw4f8EyADpS909hAPph67g7X+2Nbj9JBCqt10aiNjFXeZOxPahc4kf06pi5H4WtFEm/2viRL0kXQ2BLpBNX6OruoeYEuB5QKj6kbnKuDBhGZfnHnva/+Zc3EBemqlVPEqnxI+RRN7p++rBg8zCGnN/dHbDDvv5PJ1SyGTDKLVIxRHb2XCpScFpezYq6Tc/rlVRRJ3UPApSIatrWLqIMepAjsjuHOoASgXJ7WNbttHg/EAb16vbrDK7HwGb9nYrU7jlDorWp7oLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8QCaPlvLaiD8zSQOBMYWx8KA0SIlkoMs2FhV21By7U=;
 b=0CmeM0yINamdlYkdKsnChPhDFP9Gj4Cg9FS6KO4m7QYdJOBmXyU0tylaS4mKWpo9rzEXh96V7sghIMfmeSdbPGxCgVy7wrRSp7nVXaDp4CudwGWmQ3No+YAHfX0p/PodgIl2c8McjAqyLJbigjZ+5flPIeSi7JPBe7Rkv0PuC/c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:43 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 14/20] scsi: Retry pr_ops commands if a UA is returned.
Date:   Mon,  8 Aug 2022 19:04:13 -0500
Message-Id: <20220809000419.10674-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:610:59::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8874b115-c290-46f3-d0d6-08da799ac2f6
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/JJ6lpmlZEhiBohok6kFkbGBwAoEdjdTxzXSer1fqLkiXvSrrw8IrMAN1lNxz5qFr2oWJFbT/XUpmOAf3YpHSNHAcubXEbRL+9W7uPJEpXqVHJqIe9P7GhUWpKb82qT4vNQn2SIr/W/svH7J4eEBPEtm0H2uaZedo7IG9j96V8QVJEG4yyB3tAP0tv4heaTu3Lo4/hH6yJ9Mc8oQY6yJfXb+16wFZajzwzhqkO5GS+cu/HHVueIUI+vRl1KiBTowN9MlvOZCoLhOt+t3jk4+UEkH5BH6BIPXzWzFR7Ga8pzcF6kACJvMzE7isjQvpZnO3NpyG9CRiw1d7PNF+DdEy+wKT+66pIOlNRUMdrzU/5jE8gHRIbUvC3mFPdcDNQb+wNEeX+tn+E9DQHrGNOWDhFfkGY4/626eVDkGjeYP7SUjHmPoezaI0WTbTZtAUCmkEzUxQUJCJ7AaQEng/kAn4lOGt45Ko5pki8W+Sz5DPYLaGWbWmE1jvQHA+A8SxhANaKmbAukH82+kuYHg8nWE0owKeISaeLAbLRMmNe9ZTm+BA9Q62aisrm8P19tCR7fQEkIEfxxMQ+AkOXTw2RBGJ64woiBkpS9v2LTBsNDsw1dX4MPDuraH9d7maMZxEZmB2IQEM9GwC8YRc4Ths8d50AQXygrcc7Hxo/VII7HCoW4BOBfLQm9lchddFUNdkTMV82CWWEfpe24NcWYO18jtltnu3bCNF2d3d5rKzHkKycGRd0q1aI9p21ghVQ4AWRIdt01b7PhlhQLHy4/DI9PRFw4SaKjSBz/WTj4MMaGXxw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/eOoq/2LRGtDIPc89ZXWSsy9muV82DbcC6hpbHiuorLtUIpnjQeSf10upXxw?=
 =?us-ascii?Q?YFQTI1Rhq2ld5X4j5rFsaD5X1E0sqVBBw3nIMDlS08pBFcHI7258yoLOqQqx?=
 =?us-ascii?Q?s1PsoxfYchu0wtYNZnPWQcK6+NxcEKzTIogGuCsPrg8Tbx/TZzFwq84s8QzB?=
 =?us-ascii?Q?gZLdBORZXxGpVj5g202ZvRq7ypAUt0DsAntDjos8EE3tVsZdl5QDED6X903p?=
 =?us-ascii?Q?3VZfmvMbZhvIQJH+5a8j+8vncr9Oz00kID6AieiQYBfFhZKYd66fFF0AZ0dP?=
 =?us-ascii?Q?GSvmUrsWC8KlRW4mKv5E+qJPOZEMhCiMR/3Xr5MEtpw9ki0RZZOPOxMKHf6A?=
 =?us-ascii?Q?2qHeVPA7XEUJxfzgUxqKqwTuLGMBFImumxN/j66ZgQX4UaKTTHzNHq3OXwe9?=
 =?us-ascii?Q?mkG6p+u7+CK6YZ7a1ukpDeEprIVs8Pbtht8Gk3nlBIFnR51cFxmFBlTQgsqv?=
 =?us-ascii?Q?k2EP94Z7VNdXX8iv9Nuk9iMkMtmZePyTgMG4zCbzk1mo7CkQGeSut7r4wmK9?=
 =?us-ascii?Q?yWLs/BzIn3zDW4NkKFAHzbxpvCgYdk9rGybH9xpbGcXnHYbG61MzSWCm66Zs?=
 =?us-ascii?Q?gwsniV0H/mqWRzCwI6hbTDeOpM0cLMmRzuDtapOf8F+wefcJbcg5/u1EzJJE?=
 =?us-ascii?Q?FVV+DXJhfiBRQqG7d9nWbH95JNrkAQYGu4yiT5FDDtb1x2BxpIBuea2CnJ3j?=
 =?us-ascii?Q?dTxnqoKqqu0wbbysJ7jh0nfRgSZ9UG4Tl2wxJvpNxFbjvaIcHcKP1KA9yYHa?=
 =?us-ascii?Q?so2ni1fOi++ksai5/xghIdmTomvWOGZI+bvQjMwQmAU9i2dmuA6d72MUqUiK?=
 =?us-ascii?Q?zpPzXFmeLpB0PfRoHDAZjgicnnfEWHSDG9Uv8GXwo/dL9JnGFSEN9jdS6RvY?=
 =?us-ascii?Q?IpkMaWtL/StnPoY3jbtb8Hr2Z6M5+NrRAoJ/mmc5NnxsWXiTHQ2/9q0VCR88?=
 =?us-ascii?Q?8hu1/eLdD7yuVYoS+WM2e+PvL5FDkNwN1V/+OahQltpFK0ctJPDcKWXFbbPQ?=
 =?us-ascii?Q?E1kcf2uxO/i88pzSJvO8xhEWj5ity1XfFiz4JacojBAtO3y5G1ZE9PQ0DwGL?=
 =?us-ascii?Q?3TiL+7i8rmRB0VDJZ1k9OMq4szTmH/3551zm5iOIO4Aysa/8n2+hCDg6vIj5?=
 =?us-ascii?Q?s7jkpwh1PHL8TialePdMTbCRfPmoYtwApOZEK+pU/6uYujLsFxXCWIdImc6X?=
 =?us-ascii?Q?tJ27pkTQSBy1l+b2pLlSE8pX9GblsITy78LjpVtMrI2O6pGvSIUFnSsE84dm?=
 =?us-ascii?Q?SD673tHrAWYsFFvRlVUJUkQkFMeooyBQXMyVQhOecDSmwkf444xtZK/xNrgp?=
 =?us-ascii?Q?40XNICr3gIJM7Tj/ML5gIpUUvQG6gGPE0xLTnJSkCaGhyDCuMkQriHRuAxig?=
 =?us-ascii?Q?qAX4hhtniAc8TzHlCqDPnNqecwSvw8/npz6PauA25eE2MPdZaohuOgBHgaYf?=
 =?us-ascii?Q?Ol9ev7er+Prnmq+2j1rD+j8pVf3ytGirfMIxIxKdVBz0VfJeWByG5p+eibiI?=
 =?us-ascii?Q?L7An2PiIKK+6LRBl+SGcXpeINOjTSVgAkQxkBYupsixULQedARCsKKCM9bY/?=
 =?us-ascii?Q?cDMVjfVSAqI6MzMUIN5LiXWj+JPgJcnnM4n73ZaFa3YFiPIDi7/xIo/k3CiC?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8874b115-c290-46f3-d0d6-08da799ac2f6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:43.0788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: au53tZraDiAjdOSK1D9NnCqVOCpxmhdS+6pEfIzoMLsolqeJ67XVOX/53OrRUMr4ZhS1UHpQNqigIIcStEKX3Mv0f8zvF0lSLqVuxTBhVOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: Y0VAjduY87uUNDlhDcuZtj02BaigFyBp
X-Proofpoint-GUID: Y0VAjduY87uUNDlhDcuZtj02BaigFyBp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bf080de9866d..61e88c7ffa44 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1683,6 +1683,8 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+#define SCSI_PR_UA_RETRIES 5
+
 static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 			    unsigned char *data, int data_len)
 {
@@ -1690,8 +1692,9 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	u8 cmd[10] = { 0, };
-	int result;
+	int result, ua_retries = SCSI_PR_UA_RETRIES;
 
+retry:
 	cmd[0] = PERSISTENT_RESERVE_IN;
 	cmd[1] = sa;
 	put_unaligned_be16(data_len, &cmd[7]);
@@ -1700,6 +1703,9 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 				  &sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
+		if (sshdr.sense_key == UNIT_ATTENTION && ua_retries-- > 0)
+			goto retry;
+
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
@@ -1776,10 +1782,11 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
-	int result;
+	int result, ua_retries = SCSI_PR_UA_RETRIES;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
 
+retry:
 	cmd[0] = PERSISTENT_RESERVE_OUT;
 	cmd[1] = sa;
 	cmd[2] = type;
@@ -1794,6 +1801,9 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
+		if (sshdr.sense_key == UNIT_ATTENTION && ua_retries-- > 0)
+			goto retry;
+
 		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
 		scsi_print_sense_hdr(sdev, NULL, &sshdr);
 	}
-- 
2.18.2

