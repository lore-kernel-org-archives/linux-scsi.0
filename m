Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCC2EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjGKVtC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjGKVs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:48:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B02E171F
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:48:52 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDDq7011193;
        Tue, 11 Jul 2023 21:46:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=blffAoYw9bIk0s3cUGSKzzokOmjGO0qntVdHSZAYeqY=;
 b=hN6XFC1UihHqdFDcU/q94aLl68iSUID+gxk3N/C+8dtFgghecvKBfnoVELdDGf9verGj
 QbYJ+9GWmqxhoTh2+77hFkb7JAxDqACX9gPV7W7+Q6mcO9Ez3AkcXdfHT1b8ZDki4Gbi
 GDoO5a8uuDAk1ivPSuT/zI1Sr9xFSAjrSDehCEFSwqB3IPi8BgbWhQIW/ykReqQPWyB4
 xiIajCodrQeXh73MiN0llPxjtjPFkehcy0DizRzpn+JrTfT/krLGpzD6JulXesyGhpwa
 k9rBB72buPWW54Gp5QW7YQVVr3wZ0u6dO+eltVbfSh1AfZaWjVU4gdvoO6rfooBlaAQS uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrfj63wtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJsAUM004364;
        Tue, 11 Jul 2023 21:46:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bt24h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDO6OSIu773GAvpaZjGd/CY36D8jSPgVyO3SdoN3ovoeYGQPO7lwrTj8U97epHGX+iAm4VXBrMk5M4E6h3NP8BBfSS2ysz5Lt+/OZsr6YmazUuL/5Fl4ZNk027P4WXpWqz/pgoYZqAbd3UW5zMRC/U3/Q4f+o9G6142NFOx4FYqxLvKUojinZpHww4MQ/Ma5Lkzfxu6QMN0bu2tNjWWshKvrmARqq0DI32g5Tv9+kU5buAXBtt09E71y+nWCS6NAYluMnhCThgY0Vyk4tzjvwTAFqi/dajn4r00SewCPW3mkbs//FHW3efSU+0M2PHkOsxELnCV2NCiO5oyzxwZXKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=blffAoYw9bIk0s3cUGSKzzokOmjGO0qntVdHSZAYeqY=;
 b=er8lT7etEjf9g+qZQI2Bh6MVFCI7e13Jt8oo9Ui18VYSRCdDDtuNOpV5FWaH6TS979ZnB/tf454wTUbzsiTJcjbvuoT89Qxu0yjgX1cvniuIA3T9drf6hhLGC45TsMr1IG1d/yPVP5PKY/sIHPPAYK2nF+jjL8qSsMcbZQYLiPX9+evBitmT7nQ/nylQyBtDitTz14Z2GEbZTenZDhjQ0rg0F6PzfkjztwpEjdlDvyVMpEYiWsjyoOVeaxJvPi4Q9vYEAo8fXaaIK3IbSdBshmyCn/KlkGcq1G4UIVR/sDcAXoEgkDHPqo9C382bjkRke6776YEMzbmRnetSIO+reA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blffAoYw9bIk0s3cUGSKzzokOmjGO0qntVdHSZAYeqY=;
 b=IplP1tDGUt/8fxaipcfGsdMa3NhOUzoCwxtFY1VtGEYpVQNrh+i0OlyffcAlH/W8FDgBKWa4VnAjmnIAAgU0Kt2t8uqsazPLuuu2u4t4Ln6BhuhIiENxS7/w2uIWIBqfXlWK8iDmR5OvX1N5Gw3dAsT4JKQ1ucLJRkTLTOqwsdk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 07/33] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date:   Tue, 11 Jul 2023 16:45:54 -0500
Message-Id: <20230711214620.87232-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0010.namprd21.prod.outlook.com
 (2603:10b6:5:174::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b0f014-46b7-4ce0-6ca1-08db82584f13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0gN1oPDTz75fvUIo0B/w3/luKUNkt1JUv/ClzNiaovYJ5o/XVLC7jJ6U3LXicbimmrRbB8e7xgSQJV+cXLmDSNSXdqv+U+WFLDXTJlJqfJ+TfxXhy5/HI7brVBU+QcX3Cx7mF4Is5cWlNMELaqAoKGVE/elvQf+pVC7cvR0REz1tgrTbwaEQdvNylk7dJuCZkpOremJM+u40EaAi/L6+KGQdw8D+kwBMlE8E/UUuR7I2OQmITWTj4QpDk4FJC1naOjiNczfRtwA3jXP3M9vFDVMXpTHhyaSHYZpYgYrqr1/sgvrm8WxtEmWpn9AS6AIhz592T9s5bCOIEcOiyJgjwNyjeO6dxCUaS61hyaLBPBi6RMVtK7T3JqWwio5JukqzYWFWD5g97KBOPCncefGtNYDUSkx0jZDdClHtzwrR6KD9jl90nIvsMpWuqO0Z41Ox12Saxl9NagUUvmWP2QDkSro0jaSjohsV7/0GkxBUyccsINEel9y/JQrF9O9PiUNSITHtghs4VLNya6s911imbz1wZ1l+kWuhRybj1JW6ZhEvH0ROQWiw6y1agBnUMhN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T6LvV0d6XIX5Dp2VzXTHgbclawtozY701fREcxGi9WeAMFz6p8sug62+vbdS?=
 =?us-ascii?Q?MAVvG5Ghy05VBZtciYn4gLOfevON5TP2vKrV0ZMNmf3Bo8JeZlrSvnhA0f9C?=
 =?us-ascii?Q?tENF4MJnCpOXeTvKNeQGibvRT8HycXFfPFe7XBew62h5EcCqa6I5nwM66ZWD?=
 =?us-ascii?Q?33AKLXGUokTZLFKA6sBE0vxB/InXhYlka67Oc/Yqve6aHu97DUqthN5mnC6+?=
 =?us-ascii?Q?JVrVXjADzldX8w+6H5GEjqC7mdszSoSygd6wappoqkr2Rdusnqvn6utIxpgC?=
 =?us-ascii?Q?WisJQdpyLdnaCyj/ZgWeZH7Pjk1L7ajXIQ5lXSqneYcJC0tQL9R8dovLbvbU?=
 =?us-ascii?Q?/D3cE8LIdsTePeyJw6du0yd4ioMbY09LKP6Su91xZJlRV6QSGJB/1AgjvYdd?=
 =?us-ascii?Q?g+F1GzXrgFEk5gUmQ12sVUT5F+P0GrZAklAmtl+8mExo5GLM1bDoe/0vmW9I?=
 =?us-ascii?Q?Pc+4yOQlbAeG2Rda7EyOZtkHCi+jCxbvcZcCgNTgDDmhP0qzXrOiAoNzWQ+I?=
 =?us-ascii?Q?iSew4U7XwDt+yU4Xn+nn2ysGhc/8fQs8GbS3oYJGXyTlZruFmfwSmoLyaXuZ?=
 =?us-ascii?Q?u1J38IDhqrqrkbwIRBEyit5Rbym8tCT84rPSLqNMhTX9GcwEotik8PeoTNBr?=
 =?us-ascii?Q?W3PhOm5kPRlbyPPCDwsSqy8ZFSOYBsRyCd2dvDODEuAZUuzMJbcSrDLS5qDV?=
 =?us-ascii?Q?I9+NAgzyn0GdAqbSpmBJMIqm4nkw2ENu1Fg8esokiB1LL7tLp/cqGn3cXCV4?=
 =?us-ascii?Q?EbI9Jo+nDIJqBIMtTn3lRKMfwzsgHCFS8u9v5doPY1iRfHXgvpd9vgmB81hW?=
 =?us-ascii?Q?d1gJRw1bIGiYePX8K+cd26K9Bvht2khIEB0zugniNpVcNLIO/GsW0cFFHWK9?=
 =?us-ascii?Q?682Nn5P6eZJj1Df+l7AsOO/0+Zj0bL1rrYJSFolgSCb/ox6WBz1zzxXW9zZB?=
 =?us-ascii?Q?1N96HFSTBA9UBuMqkg9AzO6fHolRE/CmbiEdc5kwHQo95mCK9d6fhI67Upp2?=
 =?us-ascii?Q?bpD1AJxlw/53dGqrbV3PUJ/OuF1/9UxmThZnaIDAhAHjBSMcRRX4ACQ5a+Pe?=
 =?us-ascii?Q?IeiaDakpIYh/B/kSjV/c4bu+1ssUXaBu7kS2qyRgrNDHtUgmFwThbrH3xlay?=
 =?us-ascii?Q?uIbgV36EqNUD97P9zTSWt+ebumew9K/WaiYeePGSCTw6Pm5OGF5n4zoysnOR?=
 =?us-ascii?Q?nMbaZvfxkCVNoNcZjl3mwhy05RsBom5M6yWRrRawT9rvtaRdb0GaNx+96M5a?=
 =?us-ascii?Q?18EBXAITdK4pHXAvE6td2sTwA5Jpz49UFIrbYLrio3GmUbR64ScWG8u+etX0?=
 =?us-ascii?Q?OMHFfJpM+3sv1EXVLRM4V74rsVIc7Fq7SgaWNY+Z6KmfZx4RmFKAjoZYe6od?=
 =?us-ascii?Q?HM/dg9depIkXfTom4TIL9mWltF2ytmS+GMqJBCWSrs+OMwz4ZFLC/ZgG1ZKb?=
 =?us-ascii?Q?BNyjwyhWPti4IiJXmeT7UrJsnVlYmANC38tRfJbrvADvXPFDEbghEPdSdjeB?=
 =?us-ascii?Q?c5Xu0gZGFS7yKJ7ORp2YUmCIjMSjgTWKm9K5dlgIizqlMmSrSHWs9ssHSCss?=
 =?us-ascii?Q?0csnyOPe9oyIBm7aw5asnr6STJ8/Dlw9BdM3urKaRlKTS2Daep8maNdcW9a7?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: C0sBZtDfCyMrGMDVOTCTIJrcCw3vw857hOYqvYD9OiBUaDMsla3Sj6e61YzBndSKOD9KSgU8WXLLWD//0rJFOaWL5frSdqMfO39kELSbBtfZKporFEzXoYX6XUDa5hfbhHaICHn2j/8MvuVSms6MkTcksOgAe8C1neNj20zFxcilgid1PQ6UTsjSF/fX87AsBTunwqC/rc22+LAYvOUngxitZXrv5V7p9bwF8Cf+/R3qtVdIqmZT8K2oyDkPLOyjOyeFOXaSBECRpRSlBo7eSaVW7w92/WmhZlkcgzlAybv2hChogeO62S/bwWYUvbwEPkyU35GpQMEKYVw/q/4G6+IKgQN9K3V2FFAs0i61UERZZoSyPYa0qMzbCCNs776Mto6gGRp3xsJTfhJnR09vgC1keI6SCy7aV5605hCI2P1GdQvVYYxZtuMy8lqSphRwsJD6AtlMocqOld9lilnkVWR+efsD4h1jc8uC9ZyzsMDSwGNV9MK71bYVwqy2cb/pzqedn6yNmzJuD6yDkan50R7D0AWMygY77piGCElY0JMZbApYuglyDrOQwdcEFYntiEEvwzkSusCgQXTSoLE2tuk/sfZa9TQtMRZrQqXyZCi5kRGjqPTsejuPYHzeY0mCFn2jdW0f1NYoUCLnyEBk22kHnNyzdZh4lfq4wsJ0GaUE0W++frm9aYhvkxIcEOpKCv40YPT6k3Cdf1fB6VMV8058em1RwikZxzaJLsS44xeW+HigHYOk2UED9Vnsz8VlefvLXlj2XZ+35bUQ1LLyGluCidQMwRc1s31ILmyawu6T2pGVRhaTgUPH5NxGAhA8bUFXCkGbgALZuROFRMz2TXrtnf6Nf0oamgWOjzlDGuavbvI03w45oO6933xszuve
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b0f014-46b7-4ce0-6ca1-08db82584f13
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:40.5871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CfXWB4rc6LSAaG78fZliLgeBQMJTT9dYutbUO7gMEdowFIYk49DtSejEqteKozx6Pm6LeDgSwKwtnye/l4usc4JeSQacr6kJRbJXIPD2X+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-GUID: 7wOP16_gFuNj6Fg2WS6zGe5URSboYYYj
X-Proofpoint-ORIG-GUID: 7wOP16_gFuNj6Fg2WS6zGe5URSboYYYj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the loop's retries. Each UA now gets READ_CAPACITY_RETRIES_ON_RESET
reties, and the other errors (not including medium not present) get up
to 3 retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 106 ++++++++++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a2daa96e5c87..f2edf1d79cc2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2403,55 +2403,87 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
-	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
-		if (the_result > 0) {
-			if (media_not_present(sdkp, &sshdr))
-				return -ENODEV;
+	memset(buffer, 0, RC16_LEN);
 
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.34.1

