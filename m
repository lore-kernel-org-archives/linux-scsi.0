Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4355BEB64DB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbjFNHWh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243241AbjFNHVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF5269F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jlGV012646;
        Wed, 14 Jun 2023 07:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=WhbQ+TsdeGVECXzngggvbLiEZ6YKyvCRlmU26+Rta2Y=;
 b=T6bd3uOVmH+f5XI1QpCbk4T0r3TSr9z2xoyE4Um68KhA69BsBdSByqTI7BvJtPbonGsM
 KIU5PQuNWb/Vr6eCQnNMEke6esQEYLSItZ4fRUdp5m8ySikIcw0Pqa4uAzFrjM+1Bo2F
 iqfoE+TSF/l9FczfjLYA0F9hfG8BW1itEdBR/FdWek6whK7eJFO5WQPvpwmGiOo6M8xJ
 DzJSQYwZl9oOZof1en17n7IhMo8onWkxnfbs5tHBH6D0vDBsC9QC/dn8mRaHevPSSZ4J
 yQE9CvM2NgPEVncyu/znSREN47/4wpGchq5qyTlMEaAxk9rtFZKpGiRgifYaTJdLLez0 Gw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fkdpsu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k5Ap017793;
        Wed, 14 Jun 2023 07:17:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm4wsfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c30mk7ROvLyqq3PihK3Odz7+lRjQmJrzGRyRcGI6HQoG7nBkuinrPH54e8mlCH1kEhbFe413qK+wrN8J+9Wn8y/2+8xUwf4U/qTLG9v8o3+ayh5opQC4F4QkuB/1yxEcHZYP4V3YjZ57BDZT1rST4mRJi9q/23GSFZ6jhDODs2EuOo5rOKIiG413JN0/TO4wXvHmmQDMifItqTF5BGBZA4CIitmGg22HmxkNEjZaHjYpPHNQcmNzsghbDjZzCsvyw9WLljDwEo2l3ShfRNVuA1qilH7M2zlHOl/421vnzlHeC8Mr6SS10OxNI4vA4isdN8zaYQCxUrwvleIyLksjlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhbQ+TsdeGVECXzngggvbLiEZ6YKyvCRlmU26+Rta2Y=;
 b=WMPs0Tp9MzzEqs3EpYbAlWT8wi8piJOBv4yVRkmshC3OrE0oU0ujwKnrHz9hhNaT5DkGstNbWtcc9mFz1K4gxt7BtyPkgWGckzEQaRRaFZrbL9wPmReCqogCoMAGEAHdLfggSRJCdztKEfPCO8uxIjfffA6OmhXG8H2cj6gpL2JnvARZ/ndbJGvAK9P48I4IADCrWWvoaqYuBRYWSTvPvG06Q+jOq/W/8AceWmSLMkjrzwrdtoGWmfTtCvjTqsnqNHOMkRpU8d5losfI4smxv+oOBi5SOfEFUBu+EPPTqps4O1P+8W7iOcMszpy8o/muc/KTElA+8pqxij6N181lrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhbQ+TsdeGVECXzngggvbLiEZ6YKyvCRlmU26+Rta2Y=;
 b=pXFn23P7Ib4rveNhNZciweDffDewgK/bDBEzWrgvrKryToaP1VPkPWE4y7Z7NgWhNAOBZheZYBXGNw8L1nffZm2gYsp9PYigLBPYIJEJhBB0+OcNd85bqaHYYyGPKIDi4gSthhyvv+dNiZNNr6txAmJXHUcCCPc3ywBIJxAlKmc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:56 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Wed, 14 Jun 2023 02:17:06 -0500
Message-Id: <20230614071719.6372-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0036.namprd11.prod.outlook.com
 (2603:10b6:5:190::49) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a6a9f85-a968-4542-2f65-08db6ca77a12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEAj1+HsfVjwpKmoYLxqEyrQHpueoAF7uLc/9/Q8MK2i69AoNCKFZPoDeAl4ey/+Qu7OzVsYqu/D7nY4UjoA2Spm1DEZlI/0V0A9XbxT3GCY66Ik5+VrJFsUn2Sr0EWBmhvwKC40YTKEwtoXqg5w3E50FtnBFSfhpWztEWYUQPbTUr89qw7y1Z0xYsEUfmY2zyVs6TjHI/a3fGp//ec2f9lKH5/RZ5wohh4Bzq+vlPf1aSlHZwpgC+/f76e+4rlf5dRmSDkwlC81XrIdN12SJXwzd8J/ulADsW7FfgTt+voMmcAiG4wXlF34kQbxtHAvZ8n2iL63aHotk8IT5EG+tEJ5yGJXjjYw2Ttqo1FG9JuHiltdYx5h+WgfyHJf3gtgt8DV2CEewSZbZpMoLu3vm/oqZ5Dd/gvyn0Ykn3j8rA1z3cja8CwnOcU09WDXnTKwBbVfE3hSqvpuYjCCv5ExI+7EEeEYlAGZKqo/G5R4rt9zgLsGLyFBKkxZr3U8B6pGlGZv7tCrlkJkceYPIthW882o+Uq/IeQS/KP8ZE/xcZv4QBsu4I8pnrXBXiyOY5ot
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tM68HifQPwmpvaY9zDnuYeWn8ndzDvaM7UliFPwO59HBdoEmiv/LWZyQo9HD?=
 =?us-ascii?Q?kLqbZu5TnijAxiYVgRRnYKt1FdcUJgbmTZb57sVZgBXWkuQGRVqbIxwVT9NX?=
 =?us-ascii?Q?YAFbLzn+c4Ay7kmK+rMkhNXrekdVGE3XZ6SVMcuTFkc5MWAIftqWBLHNk3Nh?=
 =?us-ascii?Q?Im4Fk6cnfUlXi9PCNdO9RV/lmqVUsthACo7hhjB1PxBomkBgLTvEy5hnZQVo?=
 =?us-ascii?Q?n99I/IUF6eyqT/vLq1nTkzL9Qe8GsDWWcKT5bBkBRswNr0BsV0+HWUpn2L4h?=
 =?us-ascii?Q?mbk6sJCL8/fFTBeYJWmjulSA5Y+e6M6YtKakzkBfu3xW0rPitOC997OT3D8c?=
 =?us-ascii?Q?rIsVByKtX5O26bnDmSOq9CTwxtZhtFZCMciZIDuwM0DMZ1IaQgJWdB1pPzyy?=
 =?us-ascii?Q?5CCOQI3UhZldpqpMLzE8XLDgulgD1L5KPQGIPKY7T/yO3dmVTNJfrREESP9r?=
 =?us-ascii?Q?DQ/vvNHfhoFKZdVH4JMqNUsH0rhwfcrDJGuHpj/qMhUv1ws1ZyY7hOiNzMkb?=
 =?us-ascii?Q?fbaIsfs9FteEZSSPnmuchhw/D98wthjTNqunUFHkhMoQ82eKxth2GCpE8bNp?=
 =?us-ascii?Q?f6mUB6TeNH22pqdB9sxuVfuLmdD8i2qy3uhoIQPKoFuK1mFLzm34rcWrlLnZ?=
 =?us-ascii?Q?Zzxz2WPYkQWhsl8c6lJ1VeDQptUclDCRBtI/NdgIF4592MWWJlAMrshkeINt?=
 =?us-ascii?Q?Y+5Hswth5eOOAk8iLJOBiTke5IU/YzlzFDq9WQZebtx2hS9V79YrZ3GKFzxL?=
 =?us-ascii?Q?BqHJJ8A9x+shsgjanigiIS/mYnidPkaNJ60HyihZlWVsuP5Tg+jioeA5n3pi?=
 =?us-ascii?Q?ORwja20Q6Tinv9VICWCFTKfLFVY41ET+a+TW7BnWVX3bp/G+5X+hmGJrDm/U?=
 =?us-ascii?Q?u+3l3nuc7uwXhd/9GdP1IrG5aNvQOBmp5KpfkqKrHsc9clPfNOGBL5lSQ93w?=
 =?us-ascii?Q?ZpjNSWGjIet9ZG9bBpLyyl4eDW0OHJs3EzHTJ2HD0Ka5oy5c+H5EOmKksygJ?=
 =?us-ascii?Q?ckCxTQVzQE5WgYdyNvKqBjVMZf/dz/gu0uO/nMJBgIoZ8QP9AKWkh7b0hGGl?=
 =?us-ascii?Q?yJCvQLsWI3fMurJGLrjIJ3U7N1hLpMZU39QPqCDdCK8kUqPnmUvmiHpNZMJx?=
 =?us-ascii?Q?VMREv4wbg9a6fH/7DZapbXQefIgWroEnYVwwLwr7lJ9R9tjpMcQpCJadvMXG?=
 =?us-ascii?Q?LThJxpceIr/JKzJOi+pUgV9wE565zqfmDkvWGwlMHFpH7WXgJNbtwuaTr+5D?=
 =?us-ascii?Q?pC2XoPhFdZYMtVFu+/Jo+HPSDbT6WjAV1bSCyyOwn4KcMKzFVZ/dSPifVBq+?=
 =?us-ascii?Q?+uSDB8d2ur6iX2PNd1c5346AnTHtSWS54zlIdpQvq3dw6qMSqpkZnXGvUaxG?=
 =?us-ascii?Q?VprO7RhUNjDAiZVmWd2/FMi5s3d/hx0ki1yfxa59nIYgHml7FyJlgY3Pubz3?=
 =?us-ascii?Q?+TzTX4gizCJ3avttgUi89lIo6UC4YWBL7R2sfKuFquoyJDBiVS9M1RMRt3LM?=
 =?us-ascii?Q?cRJSXUul4T8cDaWM25XLDT3uU6IQoEs7aoi9hhExvn1aoL35nJAP00tu4a42?=
 =?us-ascii?Q?z3+vuxk3szWEy59KNrumi1SCWUdP8ikJH+iscbknQ4P96JkCvAbC9UrBqx8z?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Xg8I6NN5slIhBAsTDW1sPxBYwVXeg7C95qkMfmoCXo7102nIqyYeblvaK8xV6y54ZIrUkx70XxxJDal+TjKWEhuzWqD85Ci/rWTUJ5REd5sM6pd94jJCBLqMnXR1USvgT3+s/sGiADwslBdupEOMmrGtAqc4hnpuU01a8hCc4jDy+h+ke4ID2ymzoUJT8qd9mAsBbicR43HhgSbSSS37bOwVqIDRTgdN326GaNMrbzdlg2uL57gU8hBCE8q1BwM0hlbkHLVjQLFbAlObTGjogcI6fU7FppQlwYK4FR+GmIxuN9FGMohvA35m0UfI31EdOnZCUBvxwszr6iFDFljcHwFtgB/pU2D6v5Lp35IMUh4eOXWhfHnU8OWmGblHUpMkSuzyb0OiqB4zqZRBokoFNdOVAD5xH3M9W19dZL6IY1FjqgJpzWPRQYNu+FkOFimtw3gRiaEn+QWQOvy99sAAQAlrXJJCJsJTAGQ9fAkZfJtEFBuZDmbqElnW54Pc9a29hSjFMCf7wvNll9DoZQDswNhB4XGakk9jRx1DBiDOWnFeG7Kucg9KRxtT135uN/xvNC038mM7k+c0NtTgMAC0E+vE/rxbg65tDKNY4/Fge8JArsir4UkRnEtQrG0KCPCMeWc3eHztiH23927abO8q8wdWE7WsTZmfhHU2IG7bjKY7l7ryDH5S7TjMsljJlMQnEkVE3mBNkrcMad7F1mub+xKP8cqSPDr5mCB4Durjgyq7dS7nTV3EtWy/FRUdLG54XHrJDtwXPkaDRWBRtnIX0mLWdG9l0IkoI5u+X1cZ0h5U2GnN9KJGE8JFeotn3OvwamAVrorZwOEIYm628/V3MnXsQXtWeho+QdkUMEGiCeokCpPVY7394sXrHjaeb+Mm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6a9f85-a968-4542-2f65-08db6ca77a12
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:56.7414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMjdxz12fuOYYkgkeDYBI9Yw27Rr/QQ2g6+8V5nvJ3ykq5PINd0LdgUV1Vg5lKvG8tF/22ewAJ5pqY9kkDVwoMRk0G6wypllS5vXOirHbUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: wtkv4zZr39XHqTREvH3uQ6ugQOfCvaSb
X-Proofpoint-GUID: wtkv4zZr39XHqTREvH3uQ6ugQOfCvaSb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ff4a81a1b056..f2c0778afd50 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -185,16 +185,26 @@ static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned int buflength, enum req_op op)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
 				  timeout * HZ, MAX_RETRIES, &exec_args);
@@ -204,13 +214,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.25.1

