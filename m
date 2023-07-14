Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C61EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjGNVhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjGNVhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:52 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB20E3593
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:50 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4A8j019574;
        Fri, 14 Jul 2023 21:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=GcD7zNCBsD70u8DJGJmCj4vi3ARiPBK4L5L/xdjZoT4=;
 b=kskFfdj4GMSrn8lcy802G1xGk7CyXtPyO2j2AY2WH72oqAxp9vdfENEL7BaAikvnBPJJ
 Ifywgi0pno/0wmCrzsL2dTPorB/4q6hgTt/KoJq7pQu5pE93SgfcMV3fbDyLA9xOJcx6
 qCp1F6DfcGUn1Xct/ChoSOifO+ocDOEgW0ZwCJDeisPE98IzlAaoj90gz44JXfEYNVoS
 E07nVot3s/qEYGoaalZMFPZdk29noxepGxHLOh3x9GWR2AlxzIJ2op6pPqEmwhAfyWzS
 6mEbR9cd2aswZI33JTwlJS/3a5cxLaKXgvTEps0D+xEof5EUqqCkrCfh3J/TGgHBWVf/ 1g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqgr2aq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1hjV013905;
        Fri, 14 Jul 2023 21:34:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sviwqqent/6IynJAfp4hDD5jwmdnljEVQatUlaR4sMXDD0ceeX9lMPFDBE8PqhBqYNusSUPAnlEhAZVLkSNJUB3F+knmgTot3cQOQgNy+m/zKVfIuj2GU/jhNcx4SM/d0IDjGKzaOnWjMEdd6jwDIWYyQ1tkoQZEUUFD3OjwsIE4HwSFO3kNkKKyyCEsTmYfvYOP5+V5O8WVLcV+O/eEGsZciW/nn/NFWshU4uu6LQiTG3/G3AC0AO1poZdcRGEkksCO8yZJ9ybHYo2cHRLiGWJ8YRh0MU6SNLQTJhPc19INP+YoOg8DpLeI6BpTdX7iaP78zClWAQ+ffGR8vakxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcD7zNCBsD70u8DJGJmCj4vi3ARiPBK4L5L/xdjZoT4=;
 b=SdpTJ9aTSoKaaS7YVHQ8T0RMIlVR07j9ZYXXIaBFijOdN12Kvg2al3NobpGrq8dxqo0VLl8ndvPard4ZEcUGP/CAeIDoY4Es8g5wUkw5gLhmvo0HUkCbwLckrPJZt61HcgAdQJPzQbvoT7mpo9qidBM/XfwEp14duaVofbQtFfozEOkRV0jBUWwGegWyLwJolRNO6eVXxzcYFuMsOy6+NdczhhtFOfoekIB0NtSFeHT2yChFK5cAg7FbbX4m19p4S25aCDmdlxvndBm/BNC7qPrX6XXiFwhafQ6U0OFi/LmL7ndQIs+7j77euzN4GD1gJ0P+ikwOO3wJyZoWpTCBoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcD7zNCBsD70u8DJGJmCj4vi3ARiPBK4L5L/xdjZoT4=;
 b=vO3J1f2Ax2wjx49zvuD+UvyHMTE8u9tSOorAra82c1m+bvLwICh+BPmTBMHwxXrJcDTqQ6/zsrhTEVTwZrmQRZBFHzq+SpauGjbRrXHfSY4JtssDanbUfx8Rpw5PZ6GokhjWm1W1XwWt4k8zW3t8lFUZpZFzwmy/WC+rPOHu1O8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:39 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 10/33] scsi: Have scsi-ml retry sd_spinup_disk errors
Date:   Fri, 14 Jul 2023 16:33:56 -0500
Message-Id: <20230714213419.95492-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0047.namprd14.prod.outlook.com
 (2603:10b6:5:18f::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: b27e9da4-47a8-46cb-54a6-08db84b220a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xk/k7Q3znl2HFU8sga7S1vohm5Avc3ZbjfjGbEpbv95WDO80bdKVTcVzW7vtTtMQ+IGYW1nMLu+Fpmwlyg6q4MXsDinQdc/1sO24vLc5SYC9bq6vagr68or/WOGNty1R5fbjcLoaVn1vEhanBe/wma8KMx77cqG2dB5Vb4/41BnnqA9hKyVh+9HGLwOfyToAm6U26X1FH6Y1yVcV2s6Ltx27kZqLg/099aRNJetm7bJhFONST9hJHykJI0Lfa5v2Hwkwr3cU3SEVKzjuGungFF2pLdaVlzhu9YpXA6zb03mKr1dOtlBARkpMb4tLMi52GgVPygGRuA0Bl5A341vAKZkyUS7TKDHZjKjlF3DgKimTE3RbZKqFWMyHbyufOxaZRRfGR9Qfb8qICrMdTal3YDKtUsdbZCcZ9WmBcpuQTn91dTpMjNgNh+7sQ1YuaKnZWtrNRuclMJr/wjwWVUFE9CMM5J4VYupq7AVtgZwrS+Yvf0jYPJek6xdYM4D6PB5n1D44stP1tfEj9oJCWotpBBgQsUkiHbzuQaCDqUWBzDHXOsv2Rd8neiih7NQl3Z7k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6512007)(36756003)(316002)(8676002)(8936002)(83380400001)(5660300002)(38100700002)(2616005)(41300700001)(66556008)(66946007)(478600001)(107886003)(4326008)(186003)(66476007)(2906002)(6666004)(86362001)(6486002)(26005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z4Pm0BqZtG4urIaUBSB+/A0DSi4FE5Vs6Hpi0+6XNDG2I/v7h9wA4JXyIzkB?=
 =?us-ascii?Q?UluaXfo1BBW1NsTPN1Abv4TdcKa5UjFo8tgN4/FxMxVCnJBYshJcp1siAsOF?=
 =?us-ascii?Q?Wu0zJmTdnt0SOU6mjVpVT3Aj7d/TN6hkWfJrAbH+t8ZHHOsrom2GQo8cJx7p?=
 =?us-ascii?Q?HbxuRybAwbX3ziebrxe/OKSP346NO5OwY+CFGG1M8W0gCCFRo+iv/7FKuX6N?=
 =?us-ascii?Q?TwvZxXAm0jejt//11lDAV2m84Lc7+l30iSIkRDTzd0u0pCRLsiw2IbThFmcY?=
 =?us-ascii?Q?zuhKdLoRsP+TkhyV006RQSrsThX7X0tjjGgqbETPK96XNf1n0b2VfDs1GfNi?=
 =?us-ascii?Q?ha3YbJit6tX0MNlus9PSMF0/KmXtyCT811e9y+tKzJx9Gm9cJF4M9XEla9Sh?=
 =?us-ascii?Q?W0dtXNW9iQYDnuHY42pxqZ1J4YnojCDXc5rUlTcxEUHPanFuxVkuuduUCfvn?=
 =?us-ascii?Q?w0rwYcAMx15N4n1Bl6KZRWmNG9vphbNeWCbUzBMZbhvipFl0hlHzTzlmkZHN?=
 =?us-ascii?Q?StP4wizk4EANmrKj6YZ90xyLzmNuYBT00DMgEEu4V99bME8uqwm6z3ms+X3A?=
 =?us-ascii?Q?Oy8bUr0PqdpLurCVjX9kLXxdmaXCl4yFxFSSsVI5PIpFHL6qoi2BjqIv3/5V?=
 =?us-ascii?Q?eObUTdtX1U7HZEVGC1jOgXZMF0jzSiyUQJ2d66Z1uLlXPDeO3c3YIow+j2+V?=
 =?us-ascii?Q?nEFMDrgyLaT+IuXMV/H+0jqynuOuCrcno+zsfh2HGxOag0V1pg7fiw9oxbae?=
 =?us-ascii?Q?9rNXhQlqQoIDBGF2OB+ULXILPBqPZM6nzpGGDuqUciZGtR0uOMev5Jh6PHzb?=
 =?us-ascii?Q?maqkGDubrmxS0NdEUG7TK36Y/kiT0XQmePVPKwFQOE6Jl8FYTUocZ9p6Uvh5?=
 =?us-ascii?Q?UUrIJLGOOnbrH5ccps3sRugMys8eG8g62Lpve5fx0j1J73ThJ11zx/Y5efCl?=
 =?us-ascii?Q?E/viPylr6NCROP30oXYu5I5LD2WTDIGSxXLcKRlpy4Y21CTnbhJ8MVxXL6n3?=
 =?us-ascii?Q?/ulGNrjtZyg92AwXVgNsBj/SX5isadbM+xmD5BjR/35fDOONHWcuLRsXCFBg?=
 =?us-ascii?Q?qW4o1aC2q2x3kiimdXQOSxflyOPIGLIZcajHR8sD0WkPvu6S89t18OIKzCn3?=
 =?us-ascii?Q?ZFrzg5f3Uz7aYnWztSXZsNWoj1gc2q/BSt8jfDBdRluISa+l13tmdfe2f1Xb?=
 =?us-ascii?Q?JT8nzkBTN5FOZ7hfiVupqCFBWXcd+4e8PHsrw6HKcGgaahBz3u4cPK831AnC?=
 =?us-ascii?Q?dluJO9mQZm2UmkD2H6UsFx+pCFeSyBPJFgWatcG1f6brSnPoILJjX/nZS8Ru?=
 =?us-ascii?Q?2pI7bYyqmb6tmjBKS8CJUVEszjt/P7E3pCiAK/ImIUoYKHiK3B+9ctKOc57R?=
 =?us-ascii?Q?k656JGLxTM8oYUI043QZFUEnWH4m5kT1qEPaZ2gE9YzzO4E6eKLefhHaeci/?=
 =?us-ascii?Q?aGzErcfcwO5jll15W7MI048aTxAEgldzfibgqa/xAA8+5/rlucH0FmdF8ZoD?=
 =?us-ascii?Q?YLAR/09/uZoOJ9aSHS0cLDG2jhm/cTkBzlXS9ftAnV8XNTfIHl3bWbPR1k5z?=
 =?us-ascii?Q?ZgbrCI/RzI+2NpE6s5w/OoDEBrteqcFyRA6FppP2OaMP/AQFWa1Pi6NJAFbx?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mP0mNGlECUuDvWmY4ZxM8ldl3Ou9kLb6MTwPQkJ052QejxU2TmglfRevQ77/x1psi5C/ikH1EvsFnd0OzGL0OEjBU5AUo4JceaVshYuFzOUeTJVDGBr1TRYWX6qUo3gMp8GQh7CFjMHDtooeTKihMk6+1+hsdqt7xk/qc6Io3+pCCTjE8uVQn7Vrja3AUCAk5EzXO3WYiwNhvlZvItgTizehRZXCbeJgUs4vB9WbfTpaRZREHbM6v0L8/VMXHRxhKvlo37WnYnAnGPI/LiN8zgmhWYtELYh/DzwvJRRRb0iWkzQh9c/1tilLy+tORmIYvwJbCrkZRw+A+0YUZXoCDxbexZJVm4MV9cESFIhCv2gbWEROHk/cmNMIgyoQXFMmvPiOzjHnsxTC0tllM0ByhkrPvhoK6q87hV+d/LhfXEiRxgQXGR49vQwAfM75GZJMRqyjblXoLcJA+h8PTw1N0FBmdDc99k1RFpEP4NTVh8FuAvc+/DEJlxJCXvrzrbsgYGztl3t9fq6aC8XQYs1Ao75s61nkbjugD/vSY1uX9zPNbbuq6adD+PMNh9ozYjeaSHGk6sHc+czQOezHxhQvXWrgY5FYLMgVzzvmYpDYP/mqnWmygLefxcDwquWHueYZFSVvFYXix/+CEwcCN1G4nrT71KS7ZlhD+tOKKQ/R0MDTDbuABgdIWJwC4WhLx0wRw63Zt1z8mvWopr4xLNNOnRF+9xkbDV5gnK9Z/dQ3WEsHosmdHZ6rK3yWVhxctU5XSXmZkxsCw3O2dj07Fc7Zhy2eM3bvW7rU3V3Wn0RPQatQ4mjbK4sH3N3nvReiaQiQtKzoSu6mmVLDDqHVlNhUxnDZz1NO0WizmF0CX/e3N/aKEHU/ac0KHKPzNT/88qRZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b27e9da4-47a8-46cb-54a6-08db84b220a7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:39.1781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mkxf+K2wQscekuLCwPYy88aONj1zBbXJxzrBvvIw/A3jwS2Hnf4aMNsNas6jKWA44F3dSgoJnj2/s/9vBPgRgPGt2z+eDIX18VMhavhWvco=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: rQl6KHjACGZytpCiThTzn5gRyE2CfMHA
X-Proofpoint-GUID: rQl6KHjACGZytpCiThTzn5gRyE2CfMHA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This simplifies sd_spinup_disk so scsi-ml retries errors for it. Note that
we retried specifically on a UA and also if scsi_status_is_good returned
failed which would happen for all check conditions. In this patch we use
SCMD_FAILURE_STAT_ANY which will trigger for the same conditions as
when scsi_status_is_good returns false. This will cover all CCs including
UAs so there is no explicit failures arrary entry for UAs.

We do not handle the outside loop's retries because we want to sleep
between tries and we don't support that yet.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 73 ++++++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 753f18457ea1..34a1149bfff2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2190,55 +2190,64 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 static void
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
-	unsigned char cmd[10];
+	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
-	int retries, spintime;
+	int spintime, sense_valid = 0;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
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
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
-	int sense_valid = 0;
 
 	spintime = 0;
 
 	/* Spin up drives, as required.  Only do this at boot time */
 	/* Spinup needs to be done for module loads too. */
 	do {
-		retries = 0;
-
-		do {
-			bool media_was_present = sdkp->media_present;
+		bool media_was_present = sdkp->media_present;
 
-			cmd[0] = TEST_UNIT_READY;
-			memset((void *) &cmd[1], 0, 9);
+		scsi_reset_failures(failures);
 
-			the_result = scsi_execute_cmd(sdkp->device, cmd,
-						      REQ_OP_DRV_IN, NULL, 0,
-						      SD_TIMEOUT,
-						      sdkp->max_retries,
-						      &exec_args);
+		the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN,
+					      NULL, 0, SD_TIMEOUT,
+					      sdkp->max_retries, &exec_args);
 
-			if (the_result > 0) {
-				/*
-				 * If the drive has indicated to us that it
-				 * doesn't have any media in it, don't bother
-				 * with any more polling.
-				 */
-				if (media_not_present(sdkp, &sshdr)) {
-					if (media_was_present)
-						sd_printk(KERN_NOTICE, sdkp,
-							  "Media removed, stopped polling\n");
-					return;
-				}
 
-				sense_valid = scsi_sense_valid(&sshdr);
+		if (the_result > 0) {
+			/*
+			 * If the drive has indicated to us that it doesn't
+			 * have any media in it, don't bother with any more
+			 * polling.
+			 */
+			if (media_not_present(sdkp, &sshdr)) {
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp,
+						  "Media removed, stopped polling\n");
+				return;
 			}
-			retries++;
-		} while (retries < 3 &&
-			 (!scsi_status_is_good(the_result) ||
-			  (scsi_status_is_check_condition(the_result) &&
-			  sense_valid && sshdr.sense_key == UNIT_ATTENTION)));
+			sense_valid = scsi_sense_valid(&sshdr);
+		}
 
 		if (!scsi_status_is_check_condition(the_result)) {
 			/* no sense, TUR either succeeded or failed
-- 
2.34.1

