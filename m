Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1170EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjGKVrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjGKVrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8251980
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:17 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BIDGEE018425;
        Tue, 11 Jul 2023 21:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=CMWn8qmeqXrBQ9aIOu9+nUZLMY7grlTbOE6X/i6RNZc=;
 b=hifLdUHrp/Yje9kBEPxl9WLUQ+6LGq42Mu65e6bQtyLiJPlfkAtqeeYyZp6gG0Jzncuf
 32mqwl4oH05UuZ1OU4yXKbp+SaLDGiQyzCz/3D2BXMpzuCpoinDxKqYUwZFK1h65jo+f
 JiZELjAN/6T0SwMO5p1LqsCNH67HtW9hjr2r3QiLwbqZbF2wadaWmR/ZMLLp2m+JoLhY
 zswBTou7cUgKtkWLauW2SSlJgWq8ayh0AmNCZyd5a8UkThtPFG02TlpuJIQIdL+HIi11
 JeIXEB/LzKUzSEJ2hylbuGcjUyAgfpGHqRNjy3nnhN4P6jzSMojlPK2+UDQroCZNXjA7 jA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpydtwy0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJvjZA000554;
        Tue, 11 Jul 2023 21:47:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29shjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vh7BSKSjjcuGON/+aeX7RwYjccOWYZ2N8ulEZUTQO95VCBTox7iF403J6w2ft0JQ8ckdcWOBNcTL9OImnIrQBOw9++vUWOoW8vpgbGk1dn0gMozGC/2RWwoAEHsYYGzMqdySf+lX9U1oPWWZjzRCDZoFDJe9BuwPxLNZb4ZgDbRxHbsv7yyimp7QWgTj63m9QXyrbeAFhW+cMcPuXKU2uTjsv8YpfZVn0DFw1CJ5aqBGcPAYV23do4ziAnB7af7RJdbAADWR0eR17QPqAF6OzO5gslrGbjjo3ZunEnPoGvoCvs1vkV3oCWfhcZKy6yLLGK8e2z1JSvJfSYC8uYoTbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMWn8qmeqXrBQ9aIOu9+nUZLMY7grlTbOE6X/i6RNZc=;
 b=CZVc9CvTrqtgzykcoRP6xbVKyXmkK3xZXQ0ToNteUQXQgQgJtcNJMpmFFiA8Qfp16RCNSQF+r+WF81OV19n5TD+bNaJjRlUrsiDn4YLkLLWdXtFeevCPVh4uj/8XFtfJIRnfgeMljD616YxsATObLSRPNog8knV0jZv43gZOGGSQm4fJIwBRIpgsg76MZaKZcAfRh0lAPeiV7DgAksxYuECgoQKilrIuPFGqz1Lw5TPJevro37yjA7mmNzmwYM/fihCy/rQuCRWDyMN6Hh+k3cuBz68cDlaSAs7hxP91bFITAf1LYw3l7mKbANUm3aAKizh7IU4+9ZBQotGN7W3SKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMWn8qmeqXrBQ9aIOu9+nUZLMY7grlTbOE6X/i6RNZc=;
 b=grjlrmLEGt1OQ4ookBie1BzQxrYnJ9A5f3AQSNXokyzRZ6F2CraIEUXzVVMiON0THQtUetes824LHpydbhPSLaO37ke3GN9JjwPya5+l8iksJroO+/ZluebpJEeO+0waysOfH/znewDeZiVt2MYA4V9FXS3puKueeER3wBmfVlM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7436.namprd10.prod.outlook.com (2603:10b6:610:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 21:47:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:47:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 21/33] scsi: Have scsi-ml retry scsi_mode_sense UAs
Date:   Tue, 11 Jul 2023 16:46:08 -0500
Message-Id: <20230711214620.87232-22-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 823df285-117b-418e-5492-08db82585f54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GhXod6YkWMl6TVg3U83PMs3VODE3mGC/QSqh7kzJb3hfSaFxyhNrizR1ohAhTYjCgmxG9NKa+a0WipgDZ3Zact+Ttaw00LtqEhljXVZrveLtyxmBp6MeENAwsdD0EE3kGHUhKjmvmK32xbGfIIFoqCjsGcYNt/g7EVv4DNqXe/b/t1fAq0VJxPHWpDQDEbCfPLWEtfuvTBqDZzEcJKQCVA7k7HV+WF1QO5dWhtUBH0ldPFGHswTZKwzBufQoZWcq8t5KQKm0zzGa2yKr+CarWhv5v0w/Rx8CmCm1P5f3jigxZ/vaUVtr4sRtTe4W0ZmZJm5wlPeXe+xRNm6+NcglI9wE9Do8JRzCL4A5+0zV+kqMFPhxtxosoizpmWohWXSWdw1bci4q8taazRKRQSN0coFuI8EzKwVblYO92JNlin5sD5WcoEmzNLTGrWFWD8kDvaF+TJCYD0QBUHtf/LpEJACu26+Kk6++jWMktKzlDShrT9OyY4Rp7y54yNzkSTOnGKc6xkzqW7OD03WbCQvHnmLmFxkaBGiKN7Wb9HNlprCWe7zAITwcODPnWKjzQx8R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199021)(83380400001)(41300700001)(2616005)(8936002)(107886003)(4326008)(5660300002)(66476007)(66556008)(8676002)(316002)(1076003)(6506007)(38100700002)(26005)(6512007)(478600001)(6486002)(66946007)(86362001)(186003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gdpmcl6fR0dvySpjFFji3b5hneNnUSlOvHwPGOLpddCsVwuwdGd5xnH2Fquu?=
 =?us-ascii?Q?PnW6AI/cccERV7KROSuEp3JZi4d8d4w4uK9Lwsyl6mf/Jgu2xS23zsBWI271?=
 =?us-ascii?Q?c+KGzpr8wDH6aDK4TuSNflAF9COnutHQCpIy2BFVEdYrUSOEFAc5q39i82DA?=
 =?us-ascii?Q?QSeRKNE38Zf2pvv2GoTfsVDpIAH8XqqE0BpRGdtGvrTV9E/2WnnogK0yX+zi?=
 =?us-ascii?Q?jj+ONDtj2lX14OeOKxn23ZWWMl8Du/+eLfn8SkmBo8EeB8KUCx0SrVeBgzwG?=
 =?us-ascii?Q?7DgsbiFk6Ldfy1JEVZetIVZPivOEJT6vHqXT/n7EYg3wltxh+KFkx3jiZ6aw?=
 =?us-ascii?Q?zS07iepHKgXBkBDcNhRnYg+1pt8PR5kyYrTrX2fJveP6iufK7sZxj3jk+yWA?=
 =?us-ascii?Q?rP4dDOsNsalPaM5ilUWw5bIChAbrUDwULqq4PdZXzZJbpiu2G6xLZ5grDl3t?=
 =?us-ascii?Q?If0a/UkbapHge91Y/onvVLsRtatBkQYTsu1m6uLmjEuVsy0mBtkU8ozHQMcL?=
 =?us-ascii?Q?d3gAvCdZByGR11Yct+F25jEU94e6TWIYdE4h9SogXam8kOrcth4tG+huLym6?=
 =?us-ascii?Q?51ii8qEo/xCEShYXj0i6LOD0XSFTeM1zVSMHRP31vl9FV0W+gwAuO3Buu28S?=
 =?us-ascii?Q?lXILZcffTNZjVU/wJNW/lUO4cjMX4TauJ157JdFMWYGshT++O3Lfi0TyOFg8?=
 =?us-ascii?Q?xQtx/29HDeQBSQEEniKOcx2vq37QzbLePai4Lez0mZL+fm8IQouL1nFoy9vR?=
 =?us-ascii?Q?arQQDslLPSWrTfIn4+61DeJSGjTrXy0tgPT3uKhNKseeP65257fAscMLyndm?=
 =?us-ascii?Q?WyRsZOrAxid844TzUeEGMF0qTASAJcVTlCN+wfB0J52NUZXwBHkZPCJwEvuR?=
 =?us-ascii?Q?C731jtDUl4ub2UHLXBgh1ymRePpEdWxUPDOmkIH1iTJot7TilwEED6czBodC?=
 =?us-ascii?Q?U+VL3YmvGk9lxCZpfkLtjrJ3pOlIMbqnVGUs/lMqvPcL2dKu8+/6pEDmgy7o?=
 =?us-ascii?Q?nrXlFixeD5IhvxnTqlviKCnq95wabCTTDNR+pL2UvWumIuEbholZKyouObf7?=
 =?us-ascii?Q?QYK2mgQMHqIQZrbdgJhpaI6K7+WSyHavdU+TrXTwT7Mc7vjkb+MM+qXtsMfU?=
 =?us-ascii?Q?0mlJomXBWfuR1J+amzJUY9yp74DdmpJ7hpIfRvgp1txLXwaC+Klncc69m1Vb?=
 =?us-ascii?Q?8nRNBm/T7XesTAcyJL2UjxwDItuXhmdTQUkBeV6VXkN7Mys6Kcb0bl0AmG34?=
 =?us-ascii?Q?r2sl/zJZJtV5m8nsyDCzpCaxgMf42xHdHU7bCP2d+fyjHNCkkZ6ARSR9DfbB?=
 =?us-ascii?Q?9bVn1HyLv7ckXYDvkZqTzyYBoSLD5ChSXwZ8Nm7skhLPZmY3HnVhUbVjx7AL?=
 =?us-ascii?Q?uzkNMyruGeOB5olx8jmYyvbsv9jHcU1n3ACX98cgLk9NNjZd4/ixgLOiwL59?=
 =?us-ascii?Q?ao6u1ln2s81vo7d5QHaXcC+wpM/g0xWDp7eQyoUfdsdQD30C0+B26r/a9gVV?=
 =?us-ascii?Q?frb5gVK5jnI2BXrwTNEO9wbqaYe+qCtv8ZMXDx1yTNVbPLCeB9ChkQwL9/Fp?=
 =?us-ascii?Q?IaQO5LaqCmFzy9i5A2q/5MFLH6Jox5yPav+f755tACRccaMFb9zG3fmsuPyP?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +/dvPkPOx3W9cAjDdlrbb2oFnk6YsP+yaEB/mg9OTeXDk9Opm/nO/Ug/rXyQht16jKBTXGTbm14Y238EpsNp3StPjenYtQ8F1Ej9lMmkW7kSGncUesuQ1ctDfJQexERhRBqDAoKwjJMZXawGLCabd9pF/geLJPpDSl85P45L9ov/q2sxipOPf+l1AZC1SprANHuwB/y6GWJgHQBtzGj2+r2kT2TWfVleZXVG6qOyB8moRWnd0nShZtFD0RGKOvts3f2xrfvXyS/py6spki/TsmX+UBibR3mvyVqPEG8l7OoQVVYXkpnLz4LGtyF4ONISH92Yjt/P18VCTiN1k9ubacxdL9VN7b9u2miTkD/hVDuNdU+lDtEZLIPLh/mNmqSalEIPCXh0hwFaLPa1mOn4tnALoWLlQYQp4M9sAc9BY30QNQQ1ZrnfckydBnc4XCyCGRoYahrhkOeiUz4gI2hvk4+CSO3RKmX7zqxBRxOI3PjMo55LIHwwep1kok/ByGBEUVT5f0xk+uunQFwYBl8SX9Bjc+mBXQMxYfa6hJh6ELJkwVPpTDqKoejHdoPu+0E7ktGyMSwR84htLv5mlyeYIWTC/LPqvxsmM0hhZtVm+ieR6ruPFVZ+rzMAy2DGvuCmXyeQ6J8P0seY3y/LJbI6/TwunIt85uQmCZshmyC/50m/QPcu0a3DdYGNCpUTvZSK7UXnOQm4OCzsrDe2jqsJ1qbkDkyB2PX7tJhhuEFVVLJVE2eB5IvH4WydBM8UC08FpDEqZphN6wxuYw+urGMiLqgGhq4D1xhcp2X3hpKKaRC85N84mXPgPx6ZQ/L2LVjP+HQOGAueU7fvOCoJ1T+kORepiSWgE5RS7hf5rkSQkC8vVV2p7EYQTlPreTbmN8v5
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823df285-117b-418e-5492-08db82585f54
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:47:07.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpPMGS+bAM4Ke6Y2suy4aw6Z3E6jaHO/UAsau8feViGWz78lD0GboyZHAZJX3ZJOJV9F/94sS5ugd7OreeIqc/P1e+oPjm8yoCyhHQzrLBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7436
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-GUID: BxNz_JwVC3eBtv6Tcub3wgtMdh3g6rf9
X-Proofpoint-ORIG-GUID: BxNz_JwVC3eBtv6Tcub3wgtMdh3g6rf9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_mode_sense have scsi-ml retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f539fc4b7148..0d28920d088c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2186,11 +2186,22 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	int result;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = retries,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		/* caller might not be interested in sense, but we need it */
 		.sshdr = sshdr ? : &my_sshdr,
+		.failures = failures,
 	};
 
 	memset(data, 0, sizeof(*data));
@@ -2252,12 +2263,6 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage, int subpage,
 					goto retry;
 				}
 			}
-			if (scsi_status_is_check_condition(result) &&
-			    sshdr->sense_key == UNIT_ATTENTION &&
-			    retry_count) {
-				retry_count--;
-				goto retry;
-			}
 		}
 		return -EIO;
 	}
-- 
2.34.1

