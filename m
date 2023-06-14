Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F046EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243403AbjFNHWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242938AbjFNHVc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E8F2106
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jvRo021369;
        Wed, 14 Jun 2023 07:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=N4iNcKsJQ4wXczqmN7bmTl8ctNuRtMBaznVs/liy3b4=;
 b=aHW4wuIbIlJcj4ooGOSHnDCFgBxovqQUnG70TdYns3gBhtdKLgGiD/ObeUoC2qP/5g+D
 9WNc3/y6tblfDlqU0EgQkDg4reaD9hYAu36sE7wXKzJ8NNa1gp3Q4DdNTvUW9fRaQ7VJ
 h8UrFpo+vpls7Ayr3Tklg54DtRDjUQVenDs7vDaUuaXX0TGbjXtCXB1sY7+0x/PkLPZJ
 wyvFE/2tnmWkpnleVsNjpD8DKaAdeiuwhLQM8VQmytXbmJ4HeBlaPNWhDHPg0pi5nGOO
 9dMC9nFKOtEmLZ2mf0pZvqz2Ei4A6Sj81QBS8KbDQ1bj8wtJd1Ass8jClkboh6XsbRRh OQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3evqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5pJOm009118;
        Wed, 14 Jun 2023 07:17:55 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5esjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ccjg1ozGMYYwUqp/j7CxmkvK+KxtfbUg9jtzJm/m16/v/ahNyyVAK4+9RRnHjypfgPXB9w7C9wEE3EAHRGtHlJn41WzUn6MJuZN28oSjoGc5nAw9eUzOD5RS4MUcWQKqt3y8I2y7rpgWb/3IIYseA9EkmcmLNkMVExjt74pRhY8TtSrS3euds6SEYyP5HB3+ENJmc9/Iu3dJvh9av1bWe9py0j68x3Ju8Oz10dh6NEY3fZ5cxhVKgnKVN+yjSPeHQvotrGyCIeq1iksuPciZqP1oiT/gKlXt2zmI5IdsKFKP0Nld/0Kq7onm4xeD4lTALKQ7iwySDk78FrHj/tCNIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4iNcKsJQ4wXczqmN7bmTl8ctNuRtMBaznVs/liy3b4=;
 b=e60sy8y/It6lFj2H61bOZ6Ke74U7b3bZRFIPbcNUohlhV7pN1TqMw445q/yg7DnwP1PW2jxufcSaQ4N+pWb4CF7x8cMaPdEnMI/F3y2Q7aWNjEyDM0X2BBpgS71UlcQVu+xaSSXatOAb01+YOn0pE5xuPw5Z+mJTGaj6LQVk66k2SNmkf4JbrJyJDOBgVo6EcoUBhXzkg0WPsZnLNwI5XivsoCkwCOBVa7ETw5m4nT/f6AIE2UjpqdUnJt7ZDPGnpKh7fdh0482ifnLp+q8sealrMLuAkHjmheG+K/Q2a2LMRvFSfJD//wBvXeb1tP9130CYxQNJobIVX5ju0LBokQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4iNcKsJQ4wXczqmN7bmTl8ctNuRtMBaznVs/liy3b4=;
 b=kHJ0FNf4rtXsGOQyja8dEgiGcsaeG6A0dne6mJvTfDFeINuh2ja5n2wbSo2kJW3clnxd6EMphr/kKR/F6QAL6wQoeGh7dvF5TFvBVZ6kaCSbfZX/fXgsdeL6tn3L7JtnXI9EEGxBMozgzt7TkrnaAGd0d8BzWGWnsxjL3F6LqSg=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:53 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 18/33] scsi: sd: Have scsi-ml retry sd_sync_cache errors
Date:   Wed, 14 Jun 2023 02:17:04 -0500
Message-Id: <20230614071719.6372-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0007.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::24)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 112c157b-1257-45ef-3523-08db6ca77803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcqfgORV53newbc/c4z4190BP+tE/J5/Jg1Ba1L5icFHhFM36D7uZBIDfqXSWtH+/M3N8ZvetZzAvS9lwCReR+CRyaqoZsGnYPdQlrogtmPDb+7bLc7zbt7J4KqinpdnV8G4cco5JC2jTPT7EkD+pCoRjxoA1hka+Uhk9Cmn+5HDZapHd53zdW20MqBkHIlMhJcVxE8IFTpy/HiJgRwXcN9hCqs8Sq9CS5xetHLOm9NMlXuHQlAln7PxBCXA6CGbXSQRz6LTGAgiWRnttjg24y/17LFXu3bCyGAs7dSojZ0NX0LNkUzwBinR9Es/Ypy5+pAecM8XNRYGkTiKwBIs24PJ1zq4hromE7NBKGIMeB3fTUXxly1ndrLNjWdlSQvmHdwXcaXGs4a7CmIGAKv0lqt76iyqoH+tD9rSHROl/NTBdD/fCp5THRv8JuUK25gxhdoTnryQF+HeB2IdI7iqiyhzy1NdTDOkg9n/901IchOsrn6MndQkydq4/8Fl+4i8/4RpAN02bkqfQpzpXA4T4sgpoc7UT+uaBN4/DfoBBxczK8Z4G6Z5aB7b0SXJyfC/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aFWHSImn/Is0Kdmf0dhxuFpw3N/W400hUPjeH/1ouYbA0jxvVYO+Sp4XnK+9?=
 =?us-ascii?Q?0C6QedH+8ne/RQewd2MNgd03kPzr4ImG7BalLkB9y//1kpTPfXpQVqR555sn?=
 =?us-ascii?Q?qBHlT7cEwht6ZgYFXvXZayjS+oNLB/ITvoP6lYKQSMbD7jTeDz6uXLzMzg6i?=
 =?us-ascii?Q?DbOahcBAehTg6aEyzDF7FUg2dZHd/zTZwZLJNmRZg8LujT7nxeBbKAUBqRK6?=
 =?us-ascii?Q?3n5kIoygKGfkKb+D2FkoPNy0kMJSPzATBtgpe2NRyeyONCfGRe2jVzEOzF8Z?=
 =?us-ascii?Q?iWdsDYPpwRiMX7wKhFZshxOkzuKYMXbnKWxfpoXGMYgZXnx+my2aHGc1BYeB?=
 =?us-ascii?Q?C5H3ONc4gaZpaFbz++fqXEMqOuFTrV46JWg4K33aexcwGujFEKbAsF70As45?=
 =?us-ascii?Q?9fNM5+AX7Hs4z1vKgkICRGDavzGC5xbcB2qtaFjXx4Qx4gGFhLRgjzvsCQ/l?=
 =?us-ascii?Q?A/42U0epkePNFaUDBLa87ZQiAP6C9Gpk9n56DmNOXj7BffrKej5Pu29aBHr2?=
 =?us-ascii?Q?yhhJk0ZZk7Y4b18C1WgNPTWjfJZ5EiwWg8L37IKtKvyvEXkTtg/bfDqDeW2x?=
 =?us-ascii?Q?hIxjLEZZ5kE2Iw7EoHnm+8AJuGc/dnxEdX9A8ucNzDHSuvOyEgGzx1XO4DSA?=
 =?us-ascii?Q?5ZTDRESogxd6TT2odWe9lTs4y+CNSUH3+gGqNG7PQX64UiNOdV6/hSpApvTv?=
 =?us-ascii?Q?GxOZF2JAJxs1w8vaJUdKpJ8QqigyNabVKzMSHnKbcNrzHu81rRofnES4DrTt?=
 =?us-ascii?Q?+Mc7wn2Bxt6FgC0+CuY5ptG69TmwgFxefnpr4RkkFk4Kt4okbsgpJIMuir40?=
 =?us-ascii?Q?I5yLqB8keifQ7R92XwjoTjzVefjcSx987ol25Bxeq+ccA6bVkdpH1uIved/x?=
 =?us-ascii?Q?cAkSOkaauyTyKdwFVqVFbSuCnFHEZsf7+h61yazV1g9MIs8+G/nhk/VFeSgS?=
 =?us-ascii?Q?grLOLZyc4Hs3rYxD7AVrVropqo95a91Wuo45L1lKFqV41SYSX8bTCdlsW7uN?=
 =?us-ascii?Q?OIh5N86wiKquUikRaNl3R8G/+LjkloJdTaiNQ5SvGSw19enu7px+/3cvMbTl?=
 =?us-ascii?Q?gYWscTl5BjBfRTN3MpH1ZkU8oVrwgMO30OEz/FLLktf2TDh7mgFXrseWRnRz?=
 =?us-ascii?Q?l22HGLEWOtGEHEc90QpWQoCrnyMwWAMdUXIzUth7hlXNE1sxhY/lXQFiOO9c?=
 =?us-ascii?Q?YC9bM1P0v9bMoOU/Wu7GBHtQTHAD5g7/Uw/asZuTFF6YkTnPGMsMTOXWn4G9?=
 =?us-ascii?Q?tU2IhgTRIjNdv8JxkJ93ccI7/cr7vhjk2V1znat1cvfJkby5AJslX0vXOT4I?=
 =?us-ascii?Q?Blm5lNsc1vzdbfO1yQvSVwDFqqCx9J6FNaDy+Q0jCRuYoJ/ON2K+7KzTQE84?=
 =?us-ascii?Q?1sqJwsKmQpzALnD5AwaYR4k33ZS2UfSevHDpFxm9H4q/6F6cAct53ca9a4CI?=
 =?us-ascii?Q?nOMPGOTsE1stHsn/JMcyq8B5B7OEKl+VHa70+XhRrl7AUazA6lkr33TfFZLr?=
 =?us-ascii?Q?rqgcYEVktwgYYfmO1UJcPiLS0HPnU4/vCyzX7tSr1MaGpuTgz543cGu8namU?=
 =?us-ascii?Q?6jvAvsrYZDVN3qvoNSHETsYOIcOCGF2+c2dBpSS+JywG7ZEoMAY00HNEtJZE?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: d+c0fNxV5A+aSLy/YD0pz1cCwGnB9y7vrnhcXIOc6xOl2VhVwApa1ZqgFSHeWq2h288GU8+dS2VfAcDkKdeRdqmvgoKQNLP6xyVyJlep5EHvJXQ2ourxnud5DiYB8yToS1lOx3KiuY6g6ywR0FCDqhC82FjcfpFaKf+foKJZIcJ8IGwvCyPUvplG+zbEd7p+Wx2vd06x+1xM5vUAP1QhCjTxsEVQQa09YlHKwKjauANZ02SUFJQ08sxPm37slwSsgix5KevaFi+89W72MmGJWHpICkxt2IkYaIZdXr7UkBvGrxBxgpXOeSG47/1k2g8KgKpqiJ6+yNxAYF+/Yn9a9dZ/FaXvZS9J9CX79vNXu5J2iQitZMyVvPOsod569ffp8AqRPjeKs9IDg7Pmwv3Sqn1udulY70kSulySZogNN6WN4fJmW1ZLmPpyr/JYXowFinsH05I/GQ2AM64Hyq6Tf7MgPLdvHBc4m8eEhV7rmZ6AMI3spfblYLo+timNDEwyzg5BfnNKDWw2Soh6HbUvKba+s6dPnm665wkYYRY03l/L4LzIrrT5BpkbpsUYXTg5s/hRSdYayF+hirZvMxK3ktpOEDQDNdGS4Ub06bUPD/srG3ySpN+ahC2kj/VCmCsk42Ibj/I4BqTPXPcyW5jIVElhYOg8tBgSHOv2aXm+e1OAW8VBRM70zAt8SrbTy9KKfg8YdGlZWjJttHvff6AE0KHdAyfsWDb+ECgbIqXSMI+rZrouCfbOqHxgCv2oUxVWwG7PzeKqgSv1aBsylJRW1bVPdRWgoEu5Z2C4PMSDwEB+Y7OxJ8FmGY7NKbkNdZ/oMqfiPc5iS43B3gMpSb/sQs57Z0zT9ZVQwVdhLV4q95zLZnl9Qh/hTXKczMdXe+LO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112c157b-1257-45ef-3523-08db6ca77803
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:53.2873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wLhihmFNr9Ly1eBybE9cTmsNu6eQF06p0t7AhQ9rvGBot8t4A1zyM53FZcqawfI2Kr08gHU6jmH2sMALXzS4ObYvfII1L3gTkbCGBxF7MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-GUID: fFm_THzcTEOxL9vGmg26FvSVgeEckYAi
X-Proofpoint-ORIG-GUID: fFm_THzcTEOxL9vGmg26FvSVgeEckYAi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has sd_sync_cache have scsi-ml retry errors instead of driving them
itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bb2e5885e41b..ab0d6b1835be 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1606,36 +1606,32 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
-	int retries, res;
+	int res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
+	/* Leave the rest of the command zero to indicate flush everything. */
+	const unsigned char cmd[16] = { sdp->use_16_for_sync ?
+				SYNCHRONIZE_CACHE_16 : SYNCHRONIZE_CACHE };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[16] = { 0 };
-
-		if (sdp->use_16_for_sync)
-			cmd[0] = SYNCHRONIZE_CACHE_16;
-		else
-			cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0,
-				       timeout, sdkp->max_retries, &exec_args);
-		if (res == 0)
-			break;
-	}
-
+	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+			       sdkp->max_retries, &exec_args);
 	if (res) {
 		sd_print_result(sdkp, "Synchronize Cache(10) failed", res);
 
-- 
2.25.1

