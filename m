Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8772CEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjGKVro (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjGKVr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EE41718
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID3wW015528;
        Tue, 11 Jul 2023 21:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1wTSjMfIy8QXCpDXFE2/96aYobB9wTXcbqpkkz2w1BM=;
 b=aBofaUXc+RaQqVR8mX+AXYV2QXLNLoB+H5NfKgf24PylqRb0q/IVJ6xZt+2wby+TPADo
 wrMVcZg/sfsZ8OqMsQms0wHFI2MHwWIutwqPz5SanG7+kaBMMPeAdqo0dkCCNXSOJWlF
 cX4NXPvf7zkIAGAxGWVf6HhjZtf1sxe+lcdQ8sQylGcrqS285mHgrWhwtWTF7S4NCy3p
 AltiH2WZnEyyEY4+JbOI9ztmzS7ftOWvNTVo71Tw8GVUgj2nmW58ZGX1PzhqRNG9wCjg
 cbpdDmrx9VSu9E+SFzzWtJrNl2/kMAKvmowkFEGAxCWgm5851SSVaVry0F0hWdSDAKfk +A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rr8xumf27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BLQOu4007166;
        Tue, 11 Jul 2023 21:47:13 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h1jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzT8aaJUHqROrP5HRyxRi9HWSc7oQ+XZEzMgTWbgHJrk0OJk7PX/oJAGYq2psWkXQj++i3w+WnTupEXoTklb8WZuUnxH9kV5ezHkDC+CgAwhHJV0yqpe3gQClaFfsqAri5rB/sujvpr19Rbj17SDznyrPEpjZD8v8Pean2KP54tVhgo6qYWgGHzLF7ZOvgWAGGFh6+JilXHI3fIkSTr/M02PWHZdOT4rg9h5u4MX5vey2IwqTfo28X/+2Fer5M9Mcf4nmUA2QDU9zfcqo1jcTmzoxkGCWbRHjxMlUwZkLAJPWJpaca03K0UUOZWXNcFt1Qymb5z2637MulKY7X9pyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wTSjMfIy8QXCpDXFE2/96aYobB9wTXcbqpkkz2w1BM=;
 b=dGeEoYiVMUxDuv3ZVDLArQAJC7C/gCaGv5dqIBqlwkRnzDLGH7XKknbbe/bCTl9Ljo2MRTGz27JCiyu8aO9QpX1ZH056a3WpWhHdINGWc0mr6hv9iNbIZOwWsnqqd5eWvleEMYOzOMtumeUzIWcjMbR+/ErYm+5mAM+TunM5oojQaxIsw0saWNbt9thhcqQSHAFbvYnNl3lSnVByBDux/LNM7ra1+50GOfiRsuC40o6LfxNYYEI+BzM8RWXsTbosSCvM8fE5t4/5a6NDgBunft3HplxqW9lCOiDL4KMk8lXovplRY+10EX8NdA91Qgu5ehRvc25v2Yc3//cZXUFwCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wTSjMfIy8QXCpDXFE2/96aYobB9wTXcbqpkkz2w1BM=;
 b=JPa4qxayEoLDthq8dcvsd3s+fjLPwfAR7YSagOJ0yXWmgz1hqs/BB0V1iR8P8T1SrMEejl1jtazOm2iWABWEpYqv4Uy8NuIUgkpVi00Mrv8kGFQ4UkjsZlETvrVuFVIoI8A4foA+PL59a1pTMuKeM0WIMS9RKv8k3OyrZBWRLCw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7436.namprd10.prod.outlook.com (2603:10b6:610:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 21:47:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 22/33] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Date:   Tue, 11 Jul 2023 16:46:09 -0500
Message-Id: <20230711214620.87232-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0087.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 398c2840-f50d-4b89-c6a0-08db82586061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9D515+OBOuTw/1YXwE34E+Bw7G6itmsSYWpSKPOyV3nbgQLMn2Dsamj6ghjwwderCd78a568mKh8GOwiMHDWq/QnGUpDLXU8EW3KSeiyxkI5fBQ24lrnVNCMbRXqyitKHO0/Yju01yQ93+ejxrTwx4ZT/Ydt3BSrIrK/SHJGFKZdKW43r9Cqxy79RXJhu7OhpDDivMxy4BXPq1xr/C1/uHse4eI0hK/4RBANmwfzULWj+GnnAmuM/0fYQFVQBQnjiYVgiVUYBUjeBWaI25bU0wVPHJhHiq/JhvAWjKga/EvihsHlqdLpZK2dNG9obEwU6OPxDoM+raqTTODTjVEFH88fi2VpPOFxhTUNsTcsfA1ioaTXf4aQpHG3tVBjeNfmAzrVq8C2c+oikKfWlQgosOHLZiOC0vBrUhIivNIVWkpvsQY8tdoXOTh1qNcF+2WDn3miOI+cM9GX5S9WjdNZ5bp2614uwystfiY/9jEtEv7IaPNV2dH/7Z3gjGB0kul5vXg/QylNrZEXjv9Z/HWNjsJqc6Gkg15176Ge0mnsAW9ZGWGwTcJPJPN/MZVTQTv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(83380400001)(41300700001)(2616005)(8936002)(107886003)(4326008)(5660300002)(66476007)(66556008)(8676002)(316002)(1076003)(6506007)(38100700002)(26005)(6512007)(478600001)(6486002)(66946007)(86362001)(186003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4zY/K4GEmDt1NXA+yL233bAMvAJsnPBbOvtY2k06i7R79hjcTQ5DSKxFEWbI?=
 =?us-ascii?Q?O8tgpNmaGhrDg6AnTyEfWIX1OWJbxx0ef0Vioh955FnU6OdNZyA6wNWNkJqz?=
 =?us-ascii?Q?jX8xcgIIk6/kA2QIvpA2GRqkZ68dsYX/G98+au2S9eX0e3hZVDxEf/R84t9o?=
 =?us-ascii?Q?HhJmtwDbQrf+snbzam/NU0UyW6+TjgmwzyYhDe7SeWM0gYQ/cuhIP09tuJmu?=
 =?us-ascii?Q?hC9cOaxTbnhFwE7/qFzYj47TWHkffy3BbOrBtFwduKUGgkoqFbMQFChjIGVV?=
 =?us-ascii?Q?DxDU73nEbbJmxSeEnzzFIzg63v4QJjx9A7vb2cUwRkAuR97sdZlspWU8ZUXx?=
 =?us-ascii?Q?mf2w2OcXpMPgdfzTnISeasWRMgNyf9UahmTBdTzyvFraRIoIlNWIBUYTNemb?=
 =?us-ascii?Q?YnW1zlWGYQklMQBWO0UisCrksE9ljoc3OWliNmlfMX+9FBWxyBA3CfUa5NmB?=
 =?us-ascii?Q?9U3/v6k4z6+Ew57yQMDPY2piibFPbrKRHI7NTwW1VsQjJSs1NG3Ox25Mz3MW?=
 =?us-ascii?Q?X0ZuFMu52rEy+p2CKmo5rcu5tnA73YmQGRhOOfuSF6fjyWNQywZq5sSqkkdo?=
 =?us-ascii?Q?InsQe+7XgU2UZ3Zj/jb5e2mrEsgjvjlHsBSf25bsyus+Nh3MnfLdc5XEgCBS?=
 =?us-ascii?Q?EsJvjNBxgua1nM4yuneMDW/oCdYStseWqHwEmY/LlnKMzbM31aLdMYc39H0x?=
 =?us-ascii?Q?kXkvtLB5inPQ2nznp6s4k9tJYVC7mH+KwaojZ6kgT4ITrn/t3/wd6KQrrYi9?=
 =?us-ascii?Q?KtscWJwvnee+A3UA//mwRuWOHvPd4uBzroSKwAALsh9XhZpm1z7QrSJjuNpj?=
 =?us-ascii?Q?I0TOIsx2jc+sjVlyZwvep301Q1UAhkGdGDgRVw3h7LKvSfUR80o6F4wVIciR?=
 =?us-ascii?Q?9tYcGUgChKtMpgWJKaA3oqbrSntEiNxEOMNgZAWNWdRXjni2I7ODEkFpJkv0?=
 =?us-ascii?Q?GPICBBDPuuzPlU8JleH3skNoEXiK2OL5jlq+3niZJFz042zx3UBUETxzVps5?=
 =?us-ascii?Q?lxG1rCjz+p6zDbgKdMRcg/Sm6n1iQQYlf/zAv9GKMDiX/AVOptI0WfzLM2Ih?=
 =?us-ascii?Q?bSYegGfBy8WTcOdDTXhHJRhMQ4Vr3ffqmTu5JRRLVpdAcl2McN0TzmuE8kAh?=
 =?us-ascii?Q?ngyQdAzrJIwsJUa1Rg1eMSq8Ce2VT2MHKw4e0JnsXQWjqYwDZaChp2qgoMoP?=
 =?us-ascii?Q?1XhA5Rdly8C0tWhmtH0kDme353mjixY12ZHZ8DIbFMjyU/e9wjM/Ii8gGiKF?=
 =?us-ascii?Q?yU2BmBIcIGn5jDqHMPdfVeaVBsjCWUlfx6JPAYmHbgy9qGXCeJ1wuesx5icF?=
 =?us-ascii?Q?Zn442ZAhzm/ta6oiUHS6X/CWaGT/VBFh9MC3IC30qpSYEjxISdsxezZVHLbH?=
 =?us-ascii?Q?e1q3uu4e0WXEQNl7hLIjM2jX7xnoRUOfe5kdsnnce7TdkjYrxoV7Uf1Dmqp+?=
 =?us-ascii?Q?BTYDvONCq4fddWbRFbZI+MHHaR29qe4nrI2bTB536Dssd1FwB0l4iOwz+2TJ?=
 =?us-ascii?Q?m0Fhe3ydj4cyu/etRv+U95JD5GZiiAaaSOa3bc/lDNkyFgUMlFLy7qdtGGK7?=
 =?us-ascii?Q?kfJYPH3yBXivO3lgORl4seGLVxvuoc3LlI7e9PRJ3+cI0KKXhRI7vjQjD8X/?=
 =?us-ascii?Q?NA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pszPv+PkdHaPifw1IQ8bYVFv+uMb5fn/MkdMdleH02H5T7hdKR9yYGFXHapq1bvwpxeoCwMYNmZJ8yCCjx9yVWOGHXhS/4QrSmMJOgeKe3xqpM3r+aHwoDaoYCz04BwlEGnFfBh5EDMH3hb4/Vn9jPlztI6sG3Pk9fxceFu3/5/1J5YeHoKe0jav4fCKMfCQVHz9u4J0Ymwe8VuEztFZOnNEF6oMiPvzA+1ur6uACKW8pGb6LjE0ehazElGqH1y+RNRlIWzWYQ9a8S1fQevnZDawtpLIe9mkQWs5Qegv9Oko0iujQ/6zfNqVGlOVapfjp+ALQA/D7nRZkfBEZdctitGZunTpqH1f3YLaluddcDNQFmPlX35dJoTbKVQelgrQZgSd5Bj1WjDk+q97rp9ZByyQalHfODBZYBuxe39U2vwzi1FDG0AjC+yOTUOZokf6n8RY+iw2pfhJWMeyuPHTq+qxplhnGmUN3CWLxa7SFrPlZ1LSjfXL4w3kB80F3HxdYZ7fgb6SKoCEPirzn79296Eg0DswzznYqczuc7V6CZCPJIWkABR6n6IpZdpBpsDOPcAGX95Ju+umLoYJvFipwoPcMhTGMpEsOeBJq7ahTtMD7v66RZ/F/YgEHLDfCDTQ0nFTgrSF3kqX1HJrZycmswUEompp0tDsnEcS1bf3+lNz3L6qYuDfHVynGGvYnVHfzPzj/zgcH6muFGHaay/yzaCH1uEBRhqpGp28P/1zNE/JMpsXgAW/Rvp3+gHwiRJUXqEQKXFe9ZhvzwVvZLbot/FOcNTaLgBug53hAAQcV8iycMJy1VoOiJ+GwOCQMARsb/1P0zi9v4dbXyQwYPRrCZPNSF0hC9d0KQ+3m0C7dPNSEmmiAssROY7BMlFT3DF3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398c2840-f50d-4b89-c6a0-08db82586061
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:10.0729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usJw6cBV6+X1Q2CkCIFKgPDleWfKgR+vGv0iByFQpOy95S6xQAqMMVbWR0gyhM29JgMHyWrjno2Zo4YeEYMyrY3Fxy/1K2N01tNC6JTtAIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: j0Fm_F_Ko7QPMpyZmk5kut_54FNU5rlI
X-Proofpoint-ORIG-GUID: j0Fm_F_Ko7QPMpyZmk5kut_54FNU5rlI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sshdr passed into scsi_execute_cmd is only initialized if
scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
good statuses like check conditions to -EIO. This has scsi_mode_sense
callers that were possibly accessing an uninitialized sshdrs to only
access it if we got -EIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab0d6b1835be..48b727b2bf1d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2967,7 +2967,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
+	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
@@ -3015,7 +3015,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
-		if (scsi_sense_valid(&sshdr))
+		if (res == -EIO && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 		return;
-- 
2.34.1

