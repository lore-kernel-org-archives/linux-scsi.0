Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEF6EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjGNViy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjGNVix (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8434C3585
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4Aeg004646;
        Fri, 14 Jul 2023 21:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=MXjxbiChnoKu/ylLJ1XXlVZ5TFFYhdQFYHWDQ43d54I=;
 b=r5DTij4ncHxJ7AHb0+vWc1SGt/23O7v0Z1jhBg2HFIrFSMTLMWNYSnoErbSnR0v3GYqf
 Iy6nF8OOGKaqTqjIC/y6gwGH29reJq1+7SkZujr9hSl/UBDzQDYL0m2sz8YsL/WgxyIA
 CCVEBPOXacQp8R0YRqXsB6GIxG6KncSBZtJUJhoM9o+F8qHmKWy85c7qWMI7xIJNr0NQ
 Kp5GIDb9lW+JpkCrtESZa9KCfip1eqfleb8NgI0JCFXlcRF73aK6nTCyzdhXEXavobx9
 xGxd1k54O5mf4zo/AqRKtX0SNKHzQqJ72ItTEDpd4h1kwRQRoEJszBZ/kGDR5WqORqx9 0Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptn2d4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK0JIn007621;
        Fri, 14 Jul 2023 21:35:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrwye-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR524jgnYdbxhYyPaQJ7RS1/8AeP2zDa40Y9NDG5IHxEfXE/tMR443RrRRLV48hLNa6j77Q/pbp7+CKEYz5iT58GU8p89AOSUVHjHiuw2/1cSydgOCZdC1ezhnH9Oa4GAyceMrLcHNKMQuad8b3MgK2P2bvQDFNZ6ck1PMxEmsZj5ltmS6EKFVaTJcFpGQew+Z7DzYfDVH/9iU5Uxh6ZMT3bh8LwBbAnWkfQLt52w1LMiM0Typdox5PSxxF35O5GY/+WZ2Skdz73sLqGwpCXkdI2hkyPBw4twa7ebLIZZDHWZOJ8Q+tIgbo8fDCF/YNCW31yB6kltqImO0YsRAXcOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXjxbiChnoKu/ylLJ1XXlVZ5TFFYhdQFYHWDQ43d54I=;
 b=i66i4r09im76AtT2U4v7XbD1/JKJfpLHt5PhOZW5KynTMO3NFYNQzU383cboxCLsnY28NdIh839Cbsqn0ajmclj8fMQR9eC6VmxBmRlZ2WddCxj/AjDUZ5Ox/29Mr+nm8KlBaaoRjEwos1JKejU00Lx8kuD5/6Yoo7oTJewrmLlMO3xB9lm4E5AJt41BKoMnF2sjgj0cmYBvYPBy8vJaMUZMxaEXL0iYicaN/+vLh7Pvn8J3i2X7o5vRSRDOmItaFVuka37q8SN+jSuLdsF63i+e+4eFtV7y6zZzDuKQvya3kh5mjleGIh4ntt+iOlT88aiFDnlwfTLeOU3nxg31DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXjxbiChnoKu/ylLJ1XXlVZ5TFFYhdQFYHWDQ43d54I=;
 b=rpRFeeBwLgkrkb8gOsDml8qIGHKRN8g3NvuDf4s38/icG4sg/ba6eTanqOECT0SYITthhuwZ4tAxoAHsfoF3GCMC+E9pxHOn8ZWYZIucS6hgs1jH6k8FYlPetLU6pgefi738ezcYd38Dj4cdjXeN4Q16h5IooYB8PDFMY80+si8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:43 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:42 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 32/33] scsi: sr: Fix sshdr use in sr_get_events
Date:   Fri, 14 Jul 2023 16:34:18 -0500
Message-Id: <20230714213419.95492-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0104.namprd07.prod.outlook.com
 (2603:10b6:5:330::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: b8d9521e-b701-4f62-85c9-08db84b2363e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvSYEfdwHMdb3Tr80CtwpZ2nIhvgJ8DWpCx8d7HQP7KUSelo3tsaFlgr5vNbuo5f+IWGh3rJaFr7nxlr00WCsR/2PKeE9MYf6owjQn7pXKQKwdcKBeKCdREwDP1dwCWeBnTdtKOu/QfLN3AWZTl0vK437f4WW/SZnI9eD4p/pWLHCKeIbNV+sf4xI17BTWolW4/hQJxfcPh3H7+GSnO3ZGW8pFu/0AC6mvtOfMkuJCjIm/kLVZMpF5LM+hFwJ/1hXyp0s+Vl0otxSagDgzHzhzMi8SDbjXDUW5Qs25M7LEKvxgyZlQM3Q+oDAYLpbHLuOFAjb1HlqspNVgNSaxU7Tepzhmi8/0WilA8afFWyx/vd/mIk/LESXxCUwINPZf/PVlDAjTKXQTH7X0uClClFZNuPZ9+EQXU+i5sAlzO1+EnJ125qgGMlVja5OBIHLGskHqBxJiMMjznDvKZtNG0XW5lhOoQUjN1e3vSK7TKV4x3BkiqNhkYnbC/YXlTm1lRlnHAMEtvWIXthBzlfx84rojCQM74GnAZNwi4/FIfN3PrlCizhTGkhRBgY4MeX+9Pi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7s9jk4Dkl6kJQKEhRaRgrQj6c9cdP9/KtDLlBTlrJGI30wwqE55ss3MYQ0QJ?=
 =?us-ascii?Q?Mf2YqksVfSGsbaygt/WgptuOu3VxRYzBcBpveY/hp7aj3TGl0rZbMXUo8YrH?=
 =?us-ascii?Q?0K9NSL3VrraPd3tmjrcr+ry/ctndg4QSEjO2gQp0QqITXwGzHLoBSebEyF7Z?=
 =?us-ascii?Q?I8ITcpD7cMflcvjIIXNwvXv5GmeqCp9aq0KZMi+JUUad5K2qwwv/C5pSpuB4?=
 =?us-ascii?Q?N8Oswo5auQQnwxcNo5bMhfyVsQ3kY2j+Q0PL6dhJxUZU/od6p1HDns6Fkd94?=
 =?us-ascii?Q?iTTkkOiu9zH21vHoYKYPe7Mxuic9V7ItZ8wjLunBiTrVuUwXzUcMlq55g3CZ?=
 =?us-ascii?Q?1MGWPXZmoZuxrGVB4deZEKwZ2sgr3ysNIcWeCbd3f+MfQTv+tuyHhXDUeC/Z?=
 =?us-ascii?Q?m39DP7G/sJxpvByu4KTmGpkDTyFZi96By0BNV871Man561D4LmrtXD/RjKMh?=
 =?us-ascii?Q?CMiWaSKvwr8VFiB8gRSXb0QOZC8NksGcaztUViYYkYk9zuYrzOQV8QVceNmC?=
 =?us-ascii?Q?Q+E8o6DnZibKlmtv8bGQQwo8TfziBaZej68i1YmyXIsKzO+qELh9AOjFrVZq?=
 =?us-ascii?Q?EsJWdUfjpzVYxt7cEwUYeTsou1+Qy1V7jFC0SFkijk3VSvbWyaJB0AtDkQQK?=
 =?us-ascii?Q?00b/405l95GtUOKcxSwIJYzmnrBmkQXvgEacgSaT/e6FX8VjzgnFewiu4SBL?=
 =?us-ascii?Q?8FfpArsEbtn9WLlDpxNhInpr3GFz8w1blU3Vs559kizG2Oa01emyRpAVkdsW?=
 =?us-ascii?Q?CzXHQbO5m2gu8Ikr+Hwz/O8dkjKTGA+U/eq1emXEJmanCHseIEIistD7HNB2?=
 =?us-ascii?Q?GhPgAmPHUmyy72tlxFS85vO9niI60sguwCIRE6yrte8EleWC7vTLgZd9T3X7?=
 =?us-ascii?Q?Lei9XlMYrOyJi7T0j2tCMZ7ZU4UvAY33xpwG6bzL5OZobqC6tTPoB6ryZryS?=
 =?us-ascii?Q?yAyBeK6zw0dK8jZrB4kFjKiv/0ErLlHHGAlG+LYH95AST/IMRrU+eIqVnNZW?=
 =?us-ascii?Q?ZHJH1cQCF4id8Ktkxi39BBJYzB8/RDnAAubDtK7jT5pjLVgbOZImjUBy56/B?=
 =?us-ascii?Q?0WEVNiCsWEPV7URmbq/ewrmxbyPTm57w9M4kt1NAP2OJeeK6NRubkhcvBm/D?=
 =?us-ascii?Q?2yrTRCrntjoXQ6L6EZ8kVmY8fPElywD3BEFDU5NLAEjq/uv4u9zqxRKPoUkl?=
 =?us-ascii?Q?n5AcVQkzTGd3wNpL1rYpibL3uK+rPlxExZcaeU35kfhJ5ZPg8n4a86F8VPD5?=
 =?us-ascii?Q?g+kQRsFmjx87Qj37xYv1yil5vIbl32VA6mFaaHPjlhhITC2jTuvHDlipxm2b?=
 =?us-ascii?Q?HUPKQM/UwZD4zv++UigIvSkx5M3+Aw9xQ0TzFApEVprz7bXNjhkZ3wUfW5ig?=
 =?us-ascii?Q?9igZGMkZzlVA5Wyc74+0weRU3VaZxoK+1hZhqS5WLm1e6U8RF/LuAEk3RjuA?=
 =?us-ascii?Q?k6aCklpoFp7n3ytHZWumiidQ9jy8B873dXcuVOI/aY4ibLNmCm7TmzKG9srL?=
 =?us-ascii?Q?2N4AGsHGWn1/KWWRICLlawR4rGQWgZQKnqwgANxpNdfqSngR6CQAVSal8qcS?=
 =?us-ascii?Q?Y79lfb8/YfSiXsSmzrrTU1E2xI9LWFS6rf5ZvvjR39i9eU4NgSok/fGcE4oQ?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MUuVcuNpSHEXoI9Opabyk/3a2i7GcRUpBUde9u3G+hB9Bc47lUyDxik4+kGtvm+rEXP05/r31RSPWhiVvBakVpltdH5Br615jTyZPoDi+OLQm2ARmmgH7zBZjEbrn7kx55TiDy2V+YXmR4ZBJos+lXhft2xV/54eTqjjo7CDWJ+ANATBb3Vbs6qDLlFmUjUSlYMn8t5jbXVc53hs0APM9WfXhD56AONwjVEwe4qwlBPXvcSZIflcxTAQs7xHeu/mLHZGLmuWpyLDC0r7G+3qjqqa65Ak0v2Seco0q9eoR0v2lNqN2Qxgfp2ilw5YQsM7K2uc1qq/zE3x1owU0CfOgY+zqo8CKpgb1SHUBpqfa+pYhkPSTUIWJdJUbI6bzF4rd4Z3VY3YipZxGFy0jJ5+pa1LDW7D/Rrgg9s1P4eKKLEfhIz1JypB0sxyVqjPmvAgdFdqBEq7NGwhYa1Z1YTUyqT485XC6qVCjsc+tGG+9o5rLHT5IKa0F3hZoM60r39PzIn8JnU/xhared+iFTjiuxmtpQHNzLNTGUgiCZbCfGPHP8ueW+eORVanW9NLd2M+fSaXUxuo/65CVgwFMJ7DGudtBWYuvik2/Aw5C/72Hi/zVvzRfxytpv1MOeWp5E8dEZExTUewuY0BX6tRkhTN6TwLpH3sdebQFbeKkpbtNqsgk9E3YJ71Mk7u3uNfvM+2pb86fcKbRCylOk2dD7Bp4X/iXaXONVlNYv4hNNMPdMc5+c22/MvIv/50uk06NOasxW7rdC8rwSdWmn9Ud+LzKi9sbsdrnTF/uRD27h7qnHbGlsvc1EOE6yJeFiWrgnzThkDLO7uOiy5pPPDlJciB5TJXWKMCY+GWYkEGiZnItymxVPO7ysJr/SAVqbtdSW0K
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d9521e-b701-4f62-85c9-08db84b2363e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:15.3457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9R28VG/TOeTIvjiDi+D11Fy0ENWpYSdReMa1jMRBSK0Ogs5aGQCwkR0VHSYdfzF/HbUcjv29a5PE87VN5vEYObH2Td1RqRPgrjF9cc3Fd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: oAAGndg-gUr-TrWcz5cbgqV31iaxFNx8
X-Proofpoint-GUID: oAAGndg-gUr-TrWcz5cbgqV31iaxFNx8
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
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 100480f5bc2c..a1889709c84c 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -177,7 +177,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 
 	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
 				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
+	if (result > 0 && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
-- 
2.34.1

