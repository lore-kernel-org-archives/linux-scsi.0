Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC78EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbjGKVsu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjGKVss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:48:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E681705
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:48:47 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDAEi010902;
        Tue, 11 Jul 2023 21:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=JBRYXZ7ZnYTj859yK3Vybweua6OchUmFVXt2i15PApE=;
 b=T4pfRtAWCKArfK3ciW78CKyxVIAShzjJLwuzoSjkuoirpkbnjp2du3DWb8M/pkhA+HGi
 Sb9PIRdio5NqrbcS7M6Vr54xTb3S6shYGr91vo+bwrfqfydH6ydWV7iueHyFrEwxhTb+
 2opkqGM8Cb3lgHpsoOMFyb/gbXi7uUEH8Q+xgOyH8MO9QqdY30xH7qORKepJ+G6zakwg
 g5GxQmIjfv6yvgAnsvekuarUQjwFZf80Hb0DFgOp+IPfpPXHyPEm2nJ7TvBslMHws2nh
 yfgChwyEj9qIKHY2TLjx2lfN6ZLa4aX2y21O3OIJNTsQ+sZ4tIR76wZHzlk28VHo5l9p tw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrfj63wtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJv6Fu004189;
        Tue, 11 Jul 2023 21:46:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bt21h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7jd8iClOJJZObKruo4KdGBQbZm02W258yWLBbH3VMrQSX056OgKD0nVbLAJmv5tN0aKMJY6KSnmhxKyNAP2dLgCexbfg9XmqqJ1KEZXG7tQhkBg/+BSUJ1dAUKZGdR+MsqRELrQkJO78p5BYrt23rR0SU9zzTIkXeQjAsfDSmCzeh1JRnLPltBDaKyUlUnVBzB2B7HfxFLRguUADaobWTuSuAdksB+Zrs2AwpCy1SPmRtepEtzxpGPzGmyNcBLVzpc95pz+6XXeka64N+47t1Q109mZbmsvypOhxkRgTiJxz/5E1rvZnqaiZllL8xlIHX1gQy95NtpGF2C2DcDJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBRYXZ7ZnYTj859yK3Vybweua6OchUmFVXt2i15PApE=;
 b=EOyOM+XKQ/GgHpGiiE5vPV2ZFOEyBh1zD4Ys6IeIULl0GQ6KPslMv7ONqXZb6QLL0N8jt6IWm198xlFnVplYMVpwWqXRKv8N3sM7v7+iNV5l6Aj78pk/T9ovX9w7nECMqPOEjgV6soORmOq5t94abKyNoNMvHBIdAB4FV1ZHlfFkMRNJumFRLw/d4UMXobcnYXasktVbGj06PTmWn9Lk4AOGYH4oLz1sEjGqrCpJ2Nq+Qe48h80AytzlannzbINZyDAZVzH5B8VOjOL9CWS3bOfwZoYwrfI9g+4P6td7FBCsifEVqmCjv3mZ13V9YthnvE8kwmAPsyX4UJfzk6JU9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBRYXZ7ZnYTj859yK3Vybweua6OchUmFVXt2i15PApE=;
 b=rRg3/cJqh2+WzXyQBP6JuaZgCTaGCPdmnszrEWyrRuKJDxXWsX9x7HqLM41/WnnFRuCJL6VwLY+nELuwsS1IDeim2sdQ0v5kVC9r0uwlp5aGvjmCtFd4v/jmhNoE03FI1a2RFOxh+V0OQvB0Rmqp7CHID+Ria9s/QQWn/9BEo6s=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:36 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 05/33] scsi: retry INQUIRY after timeout
Date:   Tue, 11 Jul 2023 16:45:52 -0500
Message-Id: <20230711214620.87232-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 3785a02e-4bea-45b4-624b-08db82584c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9lnC6Eyv4JkTo7NwdApouTN+TW/VCi/x2VkQo6xkqwSnh+OtctcztWmjdpiyr4hammQz/sGcyepgsnkOespG/qjY5HxfnbTkKdH3uCPnf1xaVi2NiZNLPfu2Fyi0qpp7z61ofLZeKzTNVfervT4uuSRqulYa8rcwYYoma8OOyHGogwyGpGApDkbv4QnohShjZthmQTTaQvs6FxXukwJUMk7nNtmmANcNVJ8moVkYr0UgMkFELjDDJt5vkHw/mYTkQznhrQwnwbDULo3cIpR8NEYYo0ac4Sm01wWUxAZesaIoSjgvwH9Wkbn/OIJA4Dja6lthn2c2EUq0smH2DQxTBVbCtJH9VUAYuqyOiRn3OU/S2AU9AiFQLByItKYtbDjH8G4yE6HiuK3eHEZuwuZLwUV010Ii4yA0dEseFjF/YWYoVCTIh/FjRm8uWW2nV4jCNgmv30LFXcVAp+vtfo3x0fFW/lM27b9UkWe6fv7FT9JaIYo3ZNa27Oof94A7EYqliw+46InrjCaJxz9GQMKytGu9cGOhrGTKf8nigLlxVD+VSKScZOHVNMM8FX6l8ZG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(4744005)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hli7sUxbXiRe9m326NR9gtxNCA/f16NvNffVdC8lSohSjRUsmFiLsvLvoC7L?=
 =?us-ascii?Q?ePgh0Hysj6wvKUW+Jluz1ReprxrAKs0Bit5gxswWWdN1+6/6debmzEHpTGNq?=
 =?us-ascii?Q?mgpsiXKdGX74eJH1qlICkvuNDz8fdKkQ/L8hPs7q4OaHNHPPmeEt6uNNc0oT?=
 =?us-ascii?Q?q5XlC/MtnBfOvtv7eG4WhGw/0wiPzF8t7zeJEXfePHOKPXrTh99sCN55bzE8?=
 =?us-ascii?Q?m6d0UckYPIliq/d9WMD+pXUGWYoyWXQMFZBJCpFirdk+I9erSjI7UrTeLJEd?=
 =?us-ascii?Q?kwYokC6+9u7EqWW6wpk3qZQ7aOUWvfzfAZsiQnXjWtg9fA39PssN7LooiOwu?=
 =?us-ascii?Q?5Q6RgMxR/dcxJeF3waMgrWpag1CwF9UMxPwCNw4r0h9lX4aiVWxl3ziGu+6l?=
 =?us-ascii?Q?sVowH3wvYZWVuL2D/vItuowLHxt7AOZS6S/Lc2CbfnPvp8cPzj6a3AjqpVZq?=
 =?us-ascii?Q?TrnH2Aj3meVqZhsLxP1cn6Y8daRGsLDd4fUKEmyBSi3ikHQ7QMx2Zi2KjjHD?=
 =?us-ascii?Q?6EEcfVAtxqO41ztZ6U483N3KRxIGhqjWqinv2zlDTsvgEjEDWsJw6ebKk6sk?=
 =?us-ascii?Q?yPb7ge2hefjN6EX7WiVdAImPzMgv4PdBBeNDZf6Z60gutFmOehDEd03fR9OJ?=
 =?us-ascii?Q?/PmLfY0oonlNX94Z1iOOsH0uq/Gvm1VhEDNASXpN2bYdb0jtlZUZB1eOoYV4?=
 =?us-ascii?Q?iccE2hLM8+abDaCR2PYIbeO18NazMPfMSl70Ryv9RlIGMSjwUHqIEsSZzF6z?=
 =?us-ascii?Q?Cr3YuvGo9iz8zFJSCW7rEOmJTwzwZ+/TlQcFjVqxXKJUanxq1sQ5GXSofivv?=
 =?us-ascii?Q?O4Y7vtV0voVQS34t3a1rR78NR6QGrvyo4/Ff4ECKMk9rQtuTxFs1p0hY2ZuR?=
 =?us-ascii?Q?iY0n7W5XR9ZGyZ8VzCLc1U1khkvqHzettxhAsTg6m8vq+eWMDcUClawOZHZ3?=
 =?us-ascii?Q?4qGsAkykSGDEF8sQs3/5ztBXyCor8iVIq6H/a+P18Y74ln3fhTy9MIr16/Nx?=
 =?us-ascii?Q?cOTjyYvp7gPc8OxpVARkoQZY6nSgQxh1BhX6yk0P7mGCfcetqmOSZFNoeKcT?=
 =?us-ascii?Q?P7zeHg3aT5P06X+1RA49edHsE0Hxbf3IZByacJdCmBWknbGCLVgpDftsk9a7?=
 =?us-ascii?Q?wf3DnZvJTTXVqCRYWHg+MbVTryFad7c+6iPKzrhjdEnXddB5y2zuFGSXoh5X?=
 =?us-ascii?Q?JVjEPev5ll4nHiUIaVKLU+lnyP/O5+JaqCbLXDWLB7JEhpzSTDdIud/4nq0o?=
 =?us-ascii?Q?QG8Kwd9yxoKJjmzkRHarNMBL9JSSrtcRmkkH+Q6sr/zZ+p2oEfLM+jHxCYi3?=
 =?us-ascii?Q?fDovwUEYn7YR54Mu7y6jai9YqiDRyrTpU7/Yv/2yPdP99hAKvHuLifibls8U?=
 =?us-ascii?Q?KMB99wUNlXNVg5wUP4ZPkDz/mM8l2sXfW1KlziCEn/f8dhnBQd4NDf5QtPf5?=
 =?us-ascii?Q?37KMUZJLrl7AKAzCSBC5P8TjbOqHCGVaQTIsM+MHNE3Ha3UkF0DopbHKirhH?=
 =?us-ascii?Q?r40RuSpGYOcDzeIW3ih5rwb5Pyj3iYc2drH4gmj/PCDlLiRJEDEJ3rJgKlqx?=
 =?us-ascii?Q?YLx0gyp0hlcraEnClXjyTf0lRKqOXr+IUnrA7/eJEw7Qpym5sqZk/wwXFU5+?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: t+nEiedb/J0JjFG0u2U9FxqDIefQJ7ub+n9CBeEh1Cdt51MORwKykieV+FIpr+TvROIgBUcSSHVqpGeluKkcDy8uqujT4PEXwXu1W8lGpbNoDGxQLHi3beff1gjcMgFHGVh1oXywOSbzF48oceU5rGVSWTPwwiNrpNgRCwAjyyHwcxW+fnH+Azstl7c75IYElOSboLUmOnhtH4H7rlmeUkKbgxwrKTrKhpOYcPReBM7y+8pt/cmk/NvuiCEL7eMroyN2Ir1GmneuMpD/Dt9ZA4IKuQNsR5Sj3kjbyV7wkaiXH+HPT17psmPcARD8M9LhW6aQ3ryc/pfi4gyPIiGjQJEvBeF7o1fup+e2mJUtLFTVRiqSoHW5Ix8+yHqYYhYulMWIFkw4k9r3WQieu9l6lvZIel9uHj9r0Xscbmh/rZZRbSDDlBu/EXluY7i9fBd6RQReljax+umaV7hUDDtTcDEX6VcDJL1QNoWbX8HhRWP8Os8xjhK22wjxedD5cj0VdMM16+FtN5zmkcb0W/KG3tHAtBr1PW2JarNliBAlr4xlqgkBxxy3qKB4uzCdA9yMTLIGFeTEwrZGIbhEA0x3hYeW8cDTL7UYay6dD7B7IKY7O/h5LdZMtuMhvs/bulw0Up0StyfLS9JIy5zG6mxFaMpAvLOBlYsMajJWQn7TDPIeBO5JYtTXxConVsRArOKohrWKIqPPSuwLI7boVTnk2S8JblV6zx9TZ2HzFkRd+Q/r0WzdRXhd8haXiFtPKDqQWlk7qAIvOQWy9ZRI8lDHUMEIyL7CCdocNa91sG3or0mYEDG4i7ZsxsA7ercD6+hY5SwyokjG3+gtz0DPsuF+Sc5TersKDegULIVzKb4yooZe/t8N9EHBwvI/lNvQ/NKM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3785a02e-4bea-45b4-624b-08db82584c94
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:35.8662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KeSz7J4cenHp8Is/RTl+7xToTo0P0CQoikANxC9bOQuihgB5J25yHEIoH+hLfroxGDFH1/mXtY50EiBrSMR7esZg0scNfJRZbgA7OomItE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110198
X-Proofpoint-GUID: gCerNUWYQtZ9pyDRvcOc9ZY5OBGOuj_t
X-Proofpoint-ORIG-GUID: gCerNUWYQtZ9pyDRvcOc9ZY5OBGOuj_t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 519755952254..eeaefba6c9a9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -665,6 +665,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 	const struct scsi_exec_args exec_args = {
-- 
2.34.1

