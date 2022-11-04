Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7326C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiKDXWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKDXWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:22:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311F1A83F
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:22:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Khsxe027191;
        Fri, 4 Nov 2022 23:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=otDSly5fTZ9zOY/80/xSpzOAA/8d2q8LdnFcRbYp+v4=;
 b=t3AxsOVL4XncuePBcNDGIA22VAwQnpPt0lGkFQ6vMFTA/kxu/ZTm500PT0PitJ+B3EZa
 iphxaaWdSBLMfKgMlweGphUaV3YXmWbgFp1H6NonvI3VNX9vwHr5yITR9NrP0scJBDX7
 Z8YzLJro6fo+ocSFeVA5qC1EtWUc9SpgDBczvp2AEDLND6yGX0r0/J07izdS9KXLlJoi
 PKl5nKCsRvqED9Ot7LsOX6RD8Syqhz6k3kLvbc5r91KtaUE0pw5qVf6T1JXarHz5H70k
 tnDkKFigSPuhc/DRZVCEsdGgX7g70jsw4/P6s6TYfFy9EKVWH9pV8G+1T7nNuqzjZVwA dg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgust16e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4JocC2032861;
        Fri, 4 Nov 2022 23:22:01 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmq86gdm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+Dj4unzQ/FlxNp3HmLCOdsFNPilGwDFCqRBpAYtnR2ywtskXJGC5Z27d1/sUA9mlfkiINHAap44MV0ALLTvxBiSnly+e4vkItTk1MkjAvimj6jlZtSF/XC2uEOJ+BMXvKEhA16xTsVIeZieOHFa1Mj0pzFd8WXx48DId+0SeeZPwUS+Put8RTxFuCwF/pPHG0U/9G8e3de4uWMAqP0YqMvgdDl3ytw+IE3KkIVpe5kT+lByWhC+a3yhhCXj1cbYd0VNtKu8qFClsMptG09kgVPTX8DFpoX9b6G1zgES0MCCnJwqaWy1cmo3m0d6JIlFWt1MM/vJtp24oJd2/Usteg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otDSly5fTZ9zOY/80/xSpzOAA/8d2q8LdnFcRbYp+v4=;
 b=SaZoDK+b+go5448FJ20A/LMCPLAqZmxAToHxh0rnzMWgWxPfxY6joletZbUVdOzzuBDgtVGCc5qCL5cpdyIMk8hkcNxOk0i9NSE9KEn4or5Ms50F8GoLm0IP8ALHQQeJcWnldKxzglZXEkiUlDE4JEvbT7TMUycd82hCKRlAY2K8mIdNtoeK2d2tAsSDHPytqPP7xQABUMGoWgakoaZZuOuQai838/c9XLG8immZw+spIaPKDM0CJrSgDc8uXYDtSRwkC7NuDEmAGyAs7WPiebyuzagHXm9caxiSBNWN23rOa6FrugmwoiIw7e05xBRK/aLTYf+bFBQxEUFyzTxOsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otDSly5fTZ9zOY/80/xSpzOAA/8d2q8LdnFcRbYp+v4=;
 b=A81YJ5Umxi92yQk9qyEn+g1eIdegK8jhkVEfzlIT9zvIVljdgMYrEP0yybnVsZWTuy+QB3rJi+lptn2OkPWkHft67qzXvu0oKiuvQXAJP7AolQl47Y1Bhb1LJa1pSDdf34DyXGDXuEHRq3b7sZxE9lYyH/mDKKgxw1fuEbzEnMQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 18/35] scsi: Remove scsi_execute functions
Date:   Fri,  4 Nov 2022 18:19:10 -0500
Message-Id: <20221104231927.9613-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0330.namprd03.prod.outlook.com
 (2603:10b6:610:118::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: d3ad14cf-59ff-4c78-3858-08dabebb5a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQmoNOzQyLpcWE9/+93hNPpFns5Ul09oOQbEEFyES61Nqo7GsYQkXz8A48OV6SCzt+1pfyGm36mY5MsTNxugiG3sNyxjNHP/m9V8cU5L4Q03zwHdB3NQBMhQ6ZCUoOwlK+rhRlDYl1NhYfNnj3TvhCYh7oCMlVSp1HEK/B5tBqcDZ0vuPJmPSOd3pLVapmmj8iHgHPiI+Q426lINn3n1Ki93CxuCOVzHxQoGJ2SgLIxICEOOTlxdqvvbVroAzbHFP4Al7vasE/Lx3+a1oy1+73KR9V+w7tMn6W08mSQ0ShivHIp6iX+E+qLE53XwDEtAY+3YSbyvZlxFmq6Ckxaz9TsGfQ5kYP9cBUGh7KgY5HFjk2+/RciRdmx4j9I8mKzYw6T9MnaoCZdtRlsuayDOroADtd6HdV+eSv9ebD9veZI65mjvrMLztgPQwpAIeT7M/nPIfjdrRPmaJL8j9GiCHLq/+GkY7H7Yye4lc1DpnCpuIUuZx0JcMSTevc5zt5eywboXc0FyzmOYeFrVXwhmh/Qq3xjm6wJEV+ejfxz674kMKCKEBSXExDLwkn2xV1V4ydB8b2fqhDK61vV09uA1hYPjpv0p9GF7p7sxACMMqXkbr8sHo1MMzDqDKzdBdmuR7H0sGgxoF89t7b/b0PPQu39//u5x6C1+0ZW0v/Qcxw85tA9yJJNoMpIM6FuRYkkusdiHDk/nf9ngMB53t1eRaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r6YCEb1pgAG8DKpADeNmlgVf2yd8EwGuc0UIhF+AMzyvPDQ0Cyyu9TANuNlb?=
 =?us-ascii?Q?Nlyg/yxcvGxakzkjxr5F1rAm9lWkLcZcBpPng6k+J4ph1rwqLK8jPQNNoZQ4?=
 =?us-ascii?Q?HGMpRV1HUxR6/4gh0iB5j55LvLW5xiGrcvSwluycsYR2zeTjM7i2KV64H/+n?=
 =?us-ascii?Q?QK9RhwDgSqlA2gMZAox9n1NDRuZ6cO1FhU5PwZO6WA+w15Dn5jLLnANtXQVg?=
 =?us-ascii?Q?deRsuKj6za3iYBWzq2riv3LtKiStupyDwmMKsVhz4hsu+9y5OWI9thH+WyAf?=
 =?us-ascii?Q?xMhbk/T6uNwGi6DUYf5Ue81wDWR/wtsUYWYH16P3peLGn716Fl2zAR4hBY1Q?=
 =?us-ascii?Q?BArKAwEwSDa99hlCEkbh924aMmlK/UK2KhxguoZW0dy9HEzGno6JrAvLK6v1?=
 =?us-ascii?Q?FeQEhxBcqffd4OD3VxozGYbXgyWUdZO+uN+Gisj63/OzD5Xt1zPbSwpCZppB?=
 =?us-ascii?Q?1+uPYnop6ohbjZWDGwqpCbBW2bmgCcxWxJtQpw6D3/x8bMaexRALf2M3DKvi?=
 =?us-ascii?Q?t42GBlF11Ifj2/JkXUyMsmq4gh2I4S8A4i4LYVg5bDgwvZklmEUe5ejoRqHQ?=
 =?us-ascii?Q?0cWMQFSJJVReXOcxaEUjUrH6SqS+ol/8zdcX2NPfYFK0sELB/aWMqcC93sRH?=
 =?us-ascii?Q?w5V26l36bw3w+mSOpWmhoB/zvFFUE0XptXeiwtpan2QOs6CnA9S5hkyrCdk3?=
 =?us-ascii?Q?T52ueGO7KP2G+Kj4+5hetqz4VLqvCPnefw0j4c9oz5eD7l5NEHZ2eFv/MA74?=
 =?us-ascii?Q?Q+P0NWiCDRHUISxzVoJkqr5iUfooqDYZxxNoOfZzq/2M22gRX/PYBTL11kCl?=
 =?us-ascii?Q?zGP1lorKAecOHpH6xMPdunhZDbC2ux3e+jMwaB/jIjELHdLf3EfG7R7T7mxR?=
 =?us-ascii?Q?64DJ/ib7SoVaas7+nwwybXiB5b/hNTZI3Rk6xs4v68TqUeNhV1LYPFGsvCdw?=
 =?us-ascii?Q?yRz4+nugg1HoKp1Jn0bAH+H4S0/0dbZWv6PS7nAv9wYEFqpxw4ArxWZge4hD?=
 =?us-ascii?Q?6yiik+8wJ/bWkuoFkiB/cDllK6JgIvLm/ohWA3I4QvPLH9NOz7Hgvl09Yc9Y?=
 =?us-ascii?Q?jptui0VtDKQz5vMV2NedXnwEOTQBkVOpp8plV87+09bJ5u3+sZDNjecSow4T?=
 =?us-ascii?Q?G/QFIxsR+MZ16/3eDBcYjdA7KU4feXtqFTHtqz5GAcgU0K7sjXxnutH4o3tD?=
 =?us-ascii?Q?umsWRid1gUjKty734gtYLqCHgHr1HFFoVkXIUNVKVs4Nj6DOVkiIxtkNaRSY?=
 =?us-ascii?Q?a+dACpt3iOCJ7vkW21QiXwCTp6Lo7fy4es79/iMum2cJagRrXztwpLVsz4D+?=
 =?us-ascii?Q?zfCLXp33oa+1u9/v16Umvnvumx2uESrYEurUa9hzQkZoL5ZiYpzFrw9NrCT7?=
 =?us-ascii?Q?jjGNyakSp0FUzcegoDMxjloiJ0db4Rc2zUvU3SGbpizlkP4BUxhAXzbZFdo6?=
 =?us-ascii?Q?all6wwPVqDS2uPRMBRk/rslpL7JW6vCgV0c4OF9Bb1tzO/YIxVNN7mCKm6om?=
 =?us-ascii?Q?dhk3XbOzeZA02kGCxvD8Ts/kJt6Kl+4VIN2XRhzQ/w/iFdm5hhEQNbGj0mgx?=
 =?us-ascii?Q?99XtAhQFdsafflEUgTI3FqcAPuqU+DpYHCnrNTsf5XCAYyDPjtBiKje6rYsP?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ad14cf-59ff-4c78-3858-08dabebb5a07
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:50.6024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEScbGGGeQqIeAmurWEIxCZFu+7xCh20jisv4j1c8IyEwpy4lBE2vX0ZL0ZBJmhWsY3QykVrHZZka20im1OnE97F7gc//sZIiWQwkv4RxvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: r-5V-rpHxDsKvevDDFgm6x_q6QFpFpNk
X-Proofpoint-GUID: r-5V-rpHxDsKvevDDFgm6x_q6QFpFpNk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_execute* functions are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_device.h | 39 --------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4ae36274b6c6..76a7a05baaa4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -481,45 +481,6 @@ extern int __scsi_exec_req(const struct scsi_exec_args *args);
 		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
 	__scsi_exec_req(&args);					\
 })
-
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_exec_req(&((struct scsi_exec_args) {			\
-				.sdev = _sdev,				\
-				.cmd = _cmd,				\
-				.data_dir = _data_dir,			\
-				.buf = _buffer,				\
-				.buf_len = _bufflen,			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.timeout = _timeout,			\
-				.retries = _retries,			\
-				.op_flags = _flags,			\
-				.req_flags = _rq_flags,			\
-				.resid = _resid, }));			\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_exec_req(&(struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = data_direction,
-					.buf = buffer,
-					.buf_len = bufflen,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = retries,
-					.resid = resid });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

