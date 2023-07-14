Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6468EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbjGNVig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjGNVi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880A035B0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:16 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4UnD014849;
        Fri, 14 Jul 2023 21:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=LUsnTpta+9/seOcvNpXVyv3it8SDWrVVs+QJ+dFI3Ug=;
 b=ekBePXSHdT32kbwiex48B0EY2cqWmR1xGe5BzeqYGLCjvB32ln+ddiFj9BH78+1C0Jq6
 FNiewlniS4grASW8ZcBCpxtdoOb7eKsGUf0zC7blFh/SeJE/YXE2f23jkJ5NjzU9Axhx
 QQ58UUj6BWzJ5Uvd3kUlC9G50x15seuiMJzkt3gaS3aihrSH/hkFx6baKS1wegS4Wo+e
 ZHFkUexDWq9qKOdPy2ZNVxhLDw0Ma+uh/FQqncrjtaHooFz/L1M/Fd6sUhii1GRy9sDc
 2cTZr7o5LyiU1BvcbVX02fT/CcxIhGmAVIpzH4WObVVZQGf4pH4sxVVSc67//qyrIyHh Vw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK4Y79009048;
        Fri, 14 Jul 2023 21:35:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpw0h812-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhoFrWPHAqv3TMyzxFQDpawMeK1jSAR5mbLB0K6OJiL47j3hVXpQOjPiFjtrXVsy6iwRDEI4UlBGV/ENQcFuWy5/bGhm38F2bJn1CqWJMOLKxwYJCyeulPcxjaFLuqBdPTiiWMK4J8n7K9uNzLNHkBuuYxAgvclyis4NAGr3VoBTy3cEXfbPbUxTaPXduxcTfwm8ZYKHslFVqpPNWgK/t12LHGxKl0w/r73BPWpyx6oV7/o7AkkeCqhcEe8iql3e1jqitFp/+4OBbcWkhifmfjANrSV4W2gdIAiGhUEeXlCDyGlOT2IlqHRh9XzCGc7ePmE5YyeGg0L4y4LnhNrhVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUsnTpta+9/seOcvNpXVyv3it8SDWrVVs+QJ+dFI3Ug=;
 b=ZoaYAE6GpdLkAxDR9h3WEzlrIOHd3GGPpV7+ifB7ZOeZyr+NNMiYc8XcVQSMMFVTuvPraPBbTajoil6uJ4Jm/EnUN44NrnodwWEp5UIdqy+Frn0gacTMnSDwSmc0YU6xxk78aauEx4qFQ/Shb2nRKCAV6MeLoLBwqCqmr3G4zoDJiiDTgkwNKxGhaQsuENvEAUtqOSPpZBxUlXToSCxYUYiCsgmbmPkICSN0ovemN4k5aVOOaPV6T+yTfbQzICarHXXPvXr18aMa8OB77mjzO/JH299AlvJ9kSEc7T0k40KydyNGxX7F5UqD/l/Z8Ga4edsc5LPmLW/klbVVI5WPqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUsnTpta+9/seOcvNpXVyv3it8SDWrVVs+QJ+dFI3Ug=;
 b=bPnzUEK7fLzXyVt+7hNt9TwlPzS2qNDXy2n9coaIyzScuLksSa9f7PgOdNlk21x0hXtKTLBpUQpJloJu7+muPyJ4Y0JtTiDkAllP1g01cWXe2fDhmSeSEmm6jUYjG0judNckmkdmcdGxowQpR6jKao+0TurDSpSgg8f+kXL4PUE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 25/33] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Fri, 14 Jul 2023 16:34:11 -0500
Message-Id: <20230714213419.95492-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:8:2a::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c320ae-9116-405a-02a8-08db84b22fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQWKbRxQpfgoQMLUfMtbtzYJElFzGHeI3wDPuvNE++7E+4d3eFBHkDuhbyGcwIrYgnjMkKlLntgE0vyH/QayavIAkvnMqQbFzJGDmudXmaBZPmBc71jQEHYM1dC830OsN9jgST9l55w9s3ppSiUpv701RR78SIWbYMF+2O2cyQr7ix/qYHsU4H0NhIpRg2QKiPuOKu3YVDhqA/roK4WdmsuBqzS/wvpmDfEiANQj6CWq6keUvi0HP7C0xxURHVAMOVKzI7REtBAjs/tCYHh4kq6DMhpwxSDUnBnLgdHoGGIQ0B+/QGtVNDBcDJ9l2WVvA64Xu0y/2TxOsehjmwOmb9kOEkLE9zrwXHubsWyX+yU54y8Y6OpvhqRcHi7JB8Yny+cEEvAwIlmXELU11RSiPKLHjNGV0SK9r13y2AtmCMkmwNe+wyvoIISpaTDkxBdIStS/uqJT8TGb+1XzL/5hSsKzoBakimO/hFDvWCYiEXLXZ01NT9I2M4qPryFxH9iSzd5LHQolc3PIj8BqkDPW9BTv3uFkQ8QP7Jjt4qQGZZJwMYCtlg4aJdz3Tups3hPc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ViEE05GhRG6e45ECt0KhHqJ3ZzfsDfEpdBUnY84kJh8c5QQBTc9BFX6cpSxN?=
 =?us-ascii?Q?0QRp/FotuCBh1slfAVkzIpGUq6XOCafJ14RfHy/wIEynnc7NF8x19W0WmsEt?=
 =?us-ascii?Q?TvKnbX0EHprXnaoP+Z6izMNG9PDyeCWipOX5ahTYiECTTz88TGvHaRVdqlBv?=
 =?us-ascii?Q?HOL5x7uu/zxDnwEwMGI8CsZ6KX9o+fC/LXqk1YsPzsHU9RVhFr27LgQnvlDk?=
 =?us-ascii?Q?g8GeQ1grtfs69d58R27kb9OxXueEFo8/IpEsfDkWoXxfR52g9pXlI/znfuYt?=
 =?us-ascii?Q?hDwynGL4sOxCxYFCGlJsTbYnVDjSqSkz3sXHbnb7g9586LRYf6p7mGK0r2Ri?=
 =?us-ascii?Q?Lh20NskilWL2F87tOfzlK0ZQr0vsyjMGyUChih5JxPbWfU/vbolwp6N4aJRh?=
 =?us-ascii?Q?gORDCfk8N6V/poyJZAlMgQh8jZ2P/lqP3WNlgft5pjFi9XXeIOTtOclz7TtU?=
 =?us-ascii?Q?n50ry33NzBCSlZG/EnKbvnejbg6T22kry5KL0TeYtVyQQuIg5lu25SZ8kkBK?=
 =?us-ascii?Q?d0E7l36ZuEYbbxPLSD6YR7RDYa5DiDr0lDOhDkamksojg9becUBZ6TKkP4NS?=
 =?us-ascii?Q?uSrkXzqfaKtlwRT24ppEa/4pR3/45jiaGRBDpmPrehnuyeu4cErs4yXE18i5?=
 =?us-ascii?Q?upxBAyZkh797HLb+EHo3p1YmS2Mh6QrcyZ5Dxk0nUA7OTV1mpSXKIAaLrets?=
 =?us-ascii?Q?CMsE/1GFoqvfWVYdnOVzJHDGTzVmkW2JPOkiAlk7TkRxHTk1r2pHd7t1ZoJp?=
 =?us-ascii?Q?rwbJxzVcr+Vs9/FIjCsqZr0TmTnPP3I9SLDhqHsDDnS5xXtQmsymFdkgQB/r?=
 =?us-ascii?Q?BrMSuNNgNy+Dkc+X7Vz/YBYd7wHozIy0vNa0L+myCVf4U4MwBF69ER10ehnK?=
 =?us-ascii?Q?1tylz/XU3LH+knRt2par/Pt/hPjneifbLwo/mbnSviVGGjEPwbkmutQl0eWV?=
 =?us-ascii?Q?hSM46pUG/dvQeOsTQ6/Wq5/h7x4428BX5oB9XcPcVqEuWGk1a/xTq5JV7f29?=
 =?us-ascii?Q?9EQv1SMYDczyMMQ8xa7cCf1g+Zg0tqWI3vmCzyYFIb6GPYlHMeLLRWzPCDs7?=
 =?us-ascii?Q?QSerjnj7Ae6shyrVHAOJBsDEKP+PK+LrN2ab+OpKVQ5NZ81ulDf4aldGsasQ?=
 =?us-ascii?Q?rKPXZ9YSXAhK7+LmXedRaftQiMQZLjv4QoDndqmuKggXMjnosvYLZDFc29hk?=
 =?us-ascii?Q?bZFs8ZWpp1gtInJUk/574CL/v5AVaBh6TNKYjH+JlKSNqL+P4hai6fbV/Tv/?=
 =?us-ascii?Q?owvOjNI4MDAHF6M6p1tCQMtY7KUukMrLJcZM34skURGfVHAgqbRZhksGDYzG?=
 =?us-ascii?Q?aNCj3RYdNzAag7I0Ri2/SRSDl0FMJP8zNxFwlEed5AfljjIpFn0WGYTGcbkR?=
 =?us-ascii?Q?YorOEPpXs2rVZNdl73243eFtTdbJVUIl/TC/hxZQLt0kEl822G0CeIqgU9Ag?=
 =?us-ascii?Q?FmfGCfDtSP+ERCdWi2pfCdIQACasBspOgqfNwMEbAHV5Ww3tNmPF0NFUWpcd?=
 =?us-ascii?Q?US8umqczDyhbyPMvF9uZ+uWuDrYTZb0EHdtiraWxVszhCcmU+ZmVLn4FN1Io?=
 =?us-ascii?Q?3MS65PBDf//aK9ke4GRvA9/xQSVY1pVCNED/sue6Y9OsBqTYOYJ0weoHsqbU?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 568mTiWgZWlnAjRqkU3LbQErHMBiU45u1XCcGb+I7W1wOSUYPhpqauEq3+sApeJDQ4ZdkjGDGxfOBM3tUediaa4HOuhyELUE/EZUMW72H+SoK9RSOvT2d5AXa0pDdxJMTsjrccUd1PRxXOfnuqwFmzX2xfErh/cD1osxG5WU8o/oVxWsQWb37prKC7KtC/EDmvp3+LF9GFJW60rPfEF2h131BDZHcazB5D+CSNB+56cRxfj/kO5sGFu8sy63bkLVrK+3DG8ZmtwgeM/vnSLlZzvYGgHfH6zmsoLhut2wyeBg5NlaqGaw1iLXHflQMVRz4azR/xe3OSa4IOfO5OL+/uftySNOBLmAZNH/767s9V5DHKnjYs7D2o0SIq9eBOBsofxeXRgg6fdVIK4SU5UykP/8LGtsFjWZM59V3Gr8SNlJqU2QdCt5LNMiz1xKo41d+Gsz6wWA/jLbC3l4PJq+g9qbTfUQQouyD0rEdUxbuA6vDGJzVQwa2m1qIJzWCHA5b1zo0TJqcaQLlyM2f9L64Z6FnwLlV1+OZ2qNaYKO6dFgzwr6W4h76MUG3Sgu2inxd+1FNj5Gx+tMPtcjuyMr9uNMGUlpRpCsNOkPseAfbvu/dx8AlvYBtlTMpct2TKsMDOdTG+0IVdXpB7DVBt+CwqozN3i9EFu7/iTtTQVGi11l/syGtgCUOhpshhyx49w76kHAJ6Fyw558QYE7lwDSEES+d0pX6n1viIgZ7W8Oj1uNwmIHuR9go5Y+cSpWN1ixdUvyLOJaEEzeX4lmZi/6ykIVSlDQIMzQD0EE9SEsBJ6JZcyt7/vFExGTqaWOqZTzc5X+spMeUV4wly7nofOKlQDhyBM8Q+bOEItFpozidQSlE9l+Hs2jPlcOc3JsmwB5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c320ae-9116-405a-02a8-08db84b22fd6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:04.6222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynQV1IWhTgtEMfI/Zd/Kgsb51W8AmI47HowX4KJl0in65P4/d0EU388HI0Vyz5CrDV4Sl5Z/pYv1RUJvEUI5jMFt4Ua+cmoOaU48Om+oNzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: c8zkF71O6_btgxpV0fispN3QmOEsr5BT
X-Proofpoint-GUID: c8zkF71O6_btgxpV0fispN3QmOEsr5BT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

There are two behavior changes:
1. We no longer retry when scsi_execute_cmd returns < 0, but we should be
ok. We don't need to retry for failures like the queue being removed, and
for the case where there are no tags/reqs the block layer waits/retries
for us. For possible memory allocation failures from blk_rq_map_kern we
use GFP_NOIO, so retrying will probably not help.
2. For device reset UAs, we would retry READ_CAPACITY_RETRIES_ON_RESET
times, then once those are used up we would hit the main do loops retry
counter and get 3 more retries. We now only get
READ_CAPACITY_RETRIES_ON_RESET retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 64 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c4de2f959393..34fb0f8d189e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2556,42 +2556,60 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[10] = { READ_CAPACITY };
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.ascq = 0x0,
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
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
 	unsigned sector_size;
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
+	memset(buffer, 0, 8);
 
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
-					      8, SD_TIMEOUT, sdkp->max_retries,
-					      &exec_args);
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      8, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
+
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
-
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
-
-	} while (the_result && retries);
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.34.1

