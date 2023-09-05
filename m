Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E903CCF9E2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjIEXWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241424AbjIEXWQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:22:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7A69E
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:22:12 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385NLEmW030783;
        Tue, 5 Sep 2023 23:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=oxAQ3FNjkqjMOl2csKjPoDHXUWG5w43B2A78nnG3u6o=;
 b=FiuOBQHgGCZD15IX6gIqoQK6XCMJyDf0hetPn6vdGFBmevxtDMgoAJXxcwGMZEaev0dc
 D+7LwoZIT6b8ksaDREIygkJYb8t87CdRZqwjLZtzce0jCsx7gEYQIZ2aX17qj6q63qL4
 kXnH1kMuRiWaFSm+TV1mX8k2CUKdgeFM6Lf+qzh60sgB7xtgZFkSOu6KwGLxqLiY73Yd
 n3QB7fx6ccmKyXxQvoI6OobqzxnXJlJv2FgpYsUECgkGMuvX1P5odTDuuQmq+X+6eXkN
 uTYIkDpXTVGoDNVTJNcM8+LDCTQSrVHj/tYJJRXx3rkKBUmXgBKnOWyB/kAbgEOIU4YK Kw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdwu801w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:22:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385M5Hmv006596;
        Tue, 5 Sep 2023 23:16:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3suug5wywa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjFq9DEA7kbWl7uATW0S6StnnkRZNspWBwZ/chddKHjQ/WAIhCHQBycErngzwvgFJ7rcT2spd951t15S0b6bvLfM47G9f90MGuKMkz2Twb4GPzzUBvl7v18/4COUqxnFQ+rSnOozWjoIYKbvuYrNM3q5GrlSwRVc8MUmVVFYvhXhbcyoAJfo+rQ+X0EEj8yb1P3f3qtLANM/bTKSLZ7oMyMCqRiC4M/SvLb9UH4+iDSS6rNh+kycYS3cLBi9b3e2DeH8l37xiPUSFy+42eyn6isvwQMKQz3WtAZn/VlWvxb5xdqjP9t5aX/N1laZv7Bo2Frml7pp7is/MQ9zrJhwVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxAQ3FNjkqjMOl2csKjPoDHXUWG5w43B2A78nnG3u6o=;
 b=G5lc0Ufm0QjluRTwKSphb1XYzR0G92UnM2lFOdlePVPYroSQLLRNgfmrloyTYO0QH3WrUnpy6xGKZdpwB+CjiOXACV8D3Mwr75/IIfyALLMCXU7TyGprNp8o6cvtoqD5JvC+1ICSqS2vftpUas3yWRGea818zpIyQ3o+jOUM4+J5otNLHhXNpetFVC1nTF6bP/QlI3oLeOFCqkensFNpJ5t/Gb0CtY0DdWe+57t4vLI02AAIAahfAF6kSbVts3XBy3Ow6QpyBL9VIPEYcYQ4UjmeUf6niQFRfrrLLBMAkMuCmhSjmneZ2tpseXgZpo7q3z+rfEFGfZ1J+DwFPsZrUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxAQ3FNjkqjMOl2csKjPoDHXUWG5w43B2A78nnG3u6o=;
 b=b1pkgN9Dj0YDYINTGv6VXYtFB/XuIbAp1dq322OU5NsYOerkmWFIU5i7fFyDokSt8xpv+nvH8wwlLol+BEFutzMX2zP3s7Um3FHEJg0lMPVx5UqlDHmVqvoungRZ1C/rVmGYaXO43QIKqWfC9ZSryrvZVso1xbQfI+Pz2NltHfA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4849.namprd10.prod.outlook.com (2603:10b6:208:321::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.34; Tue, 5 Sep
 2023 23:15:57 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:15:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 05/34] scsi: retry INQUIRY after timeout
Date:   Tue,  5 Sep 2023 18:15:18 -0500
Message-Id: <20230905231547.83945-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:5:333::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4849:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d9070a-f980-43af-8df4-08dbae660f54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrnJbPDa1bRnk6IDhOO/gdx64N+H9CYTXqXnnG6K3MnYs6tCQWaZhEQQlpFqvfavzozebBOd3zh3vVui7W0bYOoZ6sgz7/2KJ7IMajduFEUbUAP9mUhkXfY9M+UHxSXp1ddR36IfqV8gPXloqVPS3BoqB1+nKD8klwCx90s8wYKFkO3VTbPtkg2H3OCbaPW12RWEPm/fh1Iiei5q2XfFHlXj6hcR8+WdE0LKIAPzyEYgqTXeU8+hUsGOmZeDaKhFGPurx3oiNg4Srpl6dip5tBbP/c1C09jjCw/g6zK5OhS0gQf6u2tukceaM19OQGyLsQml/ZBuElrps3A+agCHQAHSDVGkjaLJ2O+UOfAIFnGPDF/Aez0kYTbX3vAsUMazdpNKyBTijuRpqCgtJoA3yXEbVx6ejHfl4Ps6vIcVxapx5REuCYgpD3T4PEEAqjKiA8N9FMSHIPXr1j/CJoVL3wBl/zzXkCZ268ifeOxwjKuabPJujJnZmmFvSehpb3wDPVYGiwABiyTPjmeObXrY4o3emJti5JFJJnLcajCcUJ5Fo+FgBAMf4WKSuGbgGtps
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199024)(186009)(1800799009)(41300700001)(36756003)(8936002)(8676002)(4326008)(86362001)(38100700002)(66556008)(66946007)(66476007)(316002)(5660300002)(4744005)(478600001)(2906002)(6666004)(6512007)(6506007)(6486002)(1076003)(2616005)(107886003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xrrMIGQOSA5QmnHlHHfs6EGVvnwW+okcOFLFNMi/iCbaXDHROalMYZoP2j2s?=
 =?us-ascii?Q?bdOFg3BRgDkiflKNEnyaAIvRXALki025F3yFTSrBt3GpnGqaabOTfjRzt+Y+?=
 =?us-ascii?Q?FfcgGyOMGy4Bxl8wvfS4F07wkgtOFt4L7s1W0Q0kWrEkOZ5XCvmzicaEktto?=
 =?us-ascii?Q?05VmHiffTw/da5tqgKCjLh958Ob8h98hK4GUBbvkwdJyy5RIjxTyw5UuogiP?=
 =?us-ascii?Q?fQVlbAKaH4AYxprWcAX9jV42uzb0hjTylh4NqIl2VVMYMuOTBpfVLRPvBMBL?=
 =?us-ascii?Q?hSpalitu9XPC516iIiqfoMsph74YkuG755etSjA8XdLQL3KnFfuT5Ee0Akmr?=
 =?us-ascii?Q?ELvyEapqKivg2MWNFqJvE5A1ywAS7mzCW1zsU/xNgxamfm6O9aXlUmyxjG1s?=
 =?us-ascii?Q?D2Kjdgtz5OwbW7GC4inqSpg1deLy7Ib9lxtorxYa1wosImBFKn7ecuuXOV1o?=
 =?us-ascii?Q?jpbxQgVVYbK1+WpmOkKKTLelAvDnTCn+jgzUP7cZtmPY/0XWzpAwR/67IjNX?=
 =?us-ascii?Q?KbLBTb8rYi19kgCZu1IGx291ARaxv4zY26voDg+3ykdY0FUbtP5DhabQIHg4?=
 =?us-ascii?Q?UdTRrONUzEhe3ZJ7vf+Inq1bhvF2+Z63dgUtCzeoKNdGnrfbOvp95ol3nGfc?=
 =?us-ascii?Q?EPIptzHzw6KkSIdd4rIi4TkE0wcb0djlXpXxa5l56EU01KK4bLsYMe8b2MIc?=
 =?us-ascii?Q?/PKSwrbWnPEYWEhdGWHKT+DtGpdKjKCjwN+rmUdkKd+gdXZZKI6M4bSIanpR?=
 =?us-ascii?Q?NrQYxlOy9TTrEn7kNKhHwFHoSUAgtpVygHZmyHhSBa1IC4aZCO1CGsJLRdo5?=
 =?us-ascii?Q?BDVxMaPlwUr/2MmA1zu4WYAS+gpHJ/HcM/jqhjkijUTFUmxaLjzG69po3Tov?=
 =?us-ascii?Q?tFrN5uYjqCl5sgM9XGtGVLLCrftzsC0c55Ere0a8DkMbHu3+0q+8njBslZaV?=
 =?us-ascii?Q?m8Z7VrWBy2NQ6eYBkeK4QFEa+fpLZNAPPXhemumCwviClhpuIJcliml9o9D4?=
 =?us-ascii?Q?/n7KB3oHiNhyXiyqIbUTwsd6BLMHVf10+L4FUTJn0h19yfvinCHv3wMcEI9z?=
 =?us-ascii?Q?hkO0c1LluqTnKlPDnGKMGxi0HUxz4x/FEFXTKA12pt2N6uiFfbyVHLj/oU4T?=
 =?us-ascii?Q?4Ptxn+KlsPzjhloidpAilG0nA8UN4dbnkNxaA2oIJi2BWdi5th+b5T+Rcxi2?=
 =?us-ascii?Q?rsbQTDptfS+uQmttjybAwaTpezilyw/ZtOBrWjTZSQZGKF1ta0y4xzJx4JRK?=
 =?us-ascii?Q?p5cJX6gQa8//tuexFmVFO/ailh+k1PJSmnwdsoh09+pNS6Y/yBdXsBctckFJ?=
 =?us-ascii?Q?dCcJEDCWgVQxTj015Kh+5gNtntNmxsE7fozqCJxXI+hh2iHoq9vLgMBKaeok?=
 =?us-ascii?Q?ujqfi4pAjhmxhs/7eXtBD9hHVkyjnMMCpbBMC3S2owX9Cv1YBnodYxAdh21a?=
 =?us-ascii?Q?xy+Jn5eGQ/2psUSmLLA7kCtqMWTQKVgVJprMH2CvUmGxFr3Ykba0zJcMYnv9?=
 =?us-ascii?Q?utzGxESSGOV1BA22hbGLg+LGbh9tY4vmeABh/XqYh919Gkke4LNSEEEtg6aG?=
 =?us-ascii?Q?/Tb5DK7NGvpS8HV+G5r0mPbpkNpGDiuZkYj9ViyscSiJ6fmsQOwxeOncduYX?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qetTBuUSD311zY/Q9OtG1D79VT58cY78bR7paYRoXjYYTnfNWuHQklyVjL5ntLC5I7o1m4og7T21tPuCTn1OjAB1FTkV8FxMuteDULj0TTtr7XHjIoP8Dqg5p5vSKBzYR6RY8V7pC0qSm+z4FbKa1nrRame5xp144SrgB0GO9C5EqCTQN4+WtUL3fdxzXSKKMpcwPY9qJDtddbqy9bIQQJp89svbWqFcVnmO9jWJphC7acmyv6FEAV4EJPqNf7yJQNmUhQvZLW6dluzBJwVIKF+vC8AQeeDVFsIEnFqEsms7IIozHzRU82EITNPJ7cwetuHr2VbOcskgHYfFUXkZlrae12B6Jbn02tClZEaJVIzlZeD5lDxzfzXvekBbu6CHNd2JRWZ/M8lenRYr/lQaCEIPfyFyU55pPuugWM8HLsWbpVvXOlosidtHPZMOCrFNHKlWsQ6kcBKxoAKn1aFLZAtL/k/VDGD4STTklc+RZhjRGR0EkEcKwo5npPpll6YU4i6uVOa6ShUlQlsZvhXnS2TZeqcZH3WFMUta+9TtLDmLESa0EbyPR4uj97v+6IRwyW278O+SA0AI3xPe/VWfOCy5FKPgh9zjVCX9ivDqkkIC8scvbpSaSq+DfxMl4hGakHH3AFCYi1gfQ2aRmX/QsXz5HhQQYDB4lyYjN2cTMB6Fnq+enGzf3dXbmiyUKXQQF4YC2pVQ0TOqlUODI85qgTDmao/+ayoDWjf7O1ZaxfsaONmMaJbiQtL9qYgkocCaOKfB3c2lercLaf66ZUwqePtXFUbqNajUH4fB/A+zAk1k6RrjyiJDDvxtzpUGvard1Ub/Y58Rbn21MLnOCOlI77fTVClLdVORWIe9sk1IEhyjemLRKPYfOoyyNYH+gtRi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d9070a-f980-43af-8df4-08dbae660f54
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:15:57.1694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1GIdxS9CR3RcZu2RY0iCakRoolKi3OjOweLj2LrFM1mYQRNwFBcg0RA/8EbitoERmwq9uQO5JzuVx3IQNFuBWH6aNpvABRlihCIBYvY7Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4849
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-ORIG-GUID: NurYix2dwdLn_V1H1WEbCju6oHkzD4mx
X-Proofpoint-GUID: NurYix2dwdLn_V1H1WEbCju6oHkzD4mx
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
index 0accd2f0f295..c27b64a1b239 100644
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
 		{}
 	};
 	const struct scsi_exec_args exec_args = {
-- 
2.34.1

