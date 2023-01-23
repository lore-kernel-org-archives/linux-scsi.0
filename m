Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11EBC05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjAWWMp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbjAWWMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:12:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD6739BB7
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:50 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhxlY012806;
        Mon, 23 Jan 2023 22:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=L7gOYP/YfkrJ688kJDqXulwemOeiUNA6XwvdqpESgIw=;
 b=AXwM1LkaZ98k7jdAkdm9YCWEBNKIV88z1gLQ4vpS8bioSq/tmEm55xPCLDMva9dEuDtZ
 mL7B3EmmhZBG8T/MQajsDr3kQXst1JL+dnvOYmBsrMQ99UV6cthnRvkRGya+BODOembw
 ioz/6XNZJRZb0Nb75iKAIKf4zKdQ+bpcSLy7lLeFmOLggbpXkfoUNoGhg6JnwIDO75Rn
 bR6bf2b/vNSss5GBIYHrONog5rt7w9kov4wvqg5V+NV+j7Aee2VQ1qPK9e+sSlX4y0rJ
 4J6gJEYnC7+MkzeubxdKkR6y1hxAzXyVd13Tlq+xWAW9V/2qNeZguvAc2W5+aAQ5B46d dA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt41d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLL02J023237;
        Mon, 23 Jan 2023 22:11:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g45er6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dghJJ9pDIQx5cedO+g7HG9h1KyaYzjX5rKGZcKG1kXIoNZ86LnUmLKyg0DYaYSGAielVhLP5f247z0Tc48H0DVlRiZNioK+j8rl9uG7nFIJ8BMqn5zHy64GLk4dGep0lYHMUsjmV0IlDjXbFKYC/kqKQW+dZttW+Gyq/nvwi6qsy+c73Rbuk5jvOdXxS+og/x1PVyec5we80OjEJlWAprPIsqV4OI8WexhOUTqP2WKP/4lTKq1NEugZL1zyXUI3R1NrZC8WwzEziUYUkUOAekoEKNXATIZOlEjnTYBdIlzyc/Us4AN+rxUtZbllaujS6BNKcoWhzOBakvLVmRif+RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7gOYP/YfkrJ688kJDqXulwemOeiUNA6XwvdqpESgIw=;
 b=b8XKe5N3icPPbo4qUyx7DtztZjeDg70/w8eMG0CBxsgVZfQwHbUj3XNS085zBHNvTjRgDyHkOmqjPG1EFE2M1I5G8rE1aM8hX+a0ioEPFAtb22lXrpNJhrM4U6IHYKRP6xdA1IKxcDu6lU+DVtbBKq4DaHnwIE6RAianvI8rJhQSqBK5wm2BUI1k65EzkS06y0xjQDpdOPCr+VnEH7SZhEGN10MO/oLdOMQq+7gOYV4lRyfdl10uVyIRJ1DbJF5Ojqsdqp4FrkbP99VlufJwsfSQ29QQRkeVm9l82xrgNGzNBO28cKVya5SKqdDIGA5bnJR0Se+aYoxvieTEJFFWnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7gOYP/YfkrJ688kJDqXulwemOeiUNA6XwvdqpESgIw=;
 b=orEFhen94PMMGCfT2hCFXvPzqMLfX6y4VJrD2iAkiq6AyQGoJzIER5Fg4MvWIW8H5ruOcjmgIf/tN98xHFAzJ4eFABapFonabDrMykT9P8bktMzfTrqo3o43N5ft1NGDoUv/YRsOmLXn0j+E09gBk0RpjLmS0vx/w7H8KQH5k1A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 19/22] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Mon, 23 Jan 2023 16:10:43 -0600
Message-Id: <20230123221046.125483-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0074.namprd03.prod.outlook.com
 (2603:10b6:5:333::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 2546f28d-971a-41a7-124c-08dafd8ec12f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+ZUVaKlITREZRs0sWPEt8TgUU6Y3Ed0tWCaP+MVEqavR0kI93tosDR1fqd+GmHkOLB6C4wYLgod+i+4vSNAwHBagQiAjTowoMOEVnG9o8KKmvPSfVUHWXiLG3wgfNRkWiMiykIm2mexi5xp+ySN8hIOqtAM1b8z/1eWiP3ZuRxga5lcoOGPhdwJjD87FKSsa+XZ8c3kqyQOfJsbreBIfGBJrS62IplZx+ClL8U5/rcT4oFU4RcAaMpC5sEZskJ00S0XAnzZbXNLybNhuTzk8Uj+JBqE7CwfexUCLYEYiCa1rnf8al2Dzj7dptRMJCHRTdDcsAa85J74kMRZhDWnbcftZuWTDqgpKAszwZr897Fxo0OXuledyW5GsjrsMDq5ilUqcj8Pn0EN7SCkitnpQ0edkHJDplMwfwfcwjp3WqrSS18Nye7x//psaOP8ZtFHf7InLVifQGYdw9WE+0OOkzkrhAJ6x6IlnE1xoZAYs1XQ0G2rG+kc+bAMLgxQuEFs6EEwHFeFRTdVHA4pucy70sTFM+QKxvx5p4UTUIYpCffAQ12dtshIDBHBioztdhz77QNkpEXH3holeGwAv5q1RxYR7vIeK2CGfdfFz6JGNrgBkc4Pfuo9duxjcXZ62DQGNM+EkiR/nzpfNRPNAttXOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ilRXjv1U9Osml1yWpZp7JNdcZHzmf9w0IpxSdp92vqyWbhbKLO8/pjxfWaPh?=
 =?us-ascii?Q?MN0JOyIyWAbKweV9m/aWBKjrOd5LnU55Smtbxb+0dL6H/ICbYQePRcIr40qm?=
 =?us-ascii?Q?sTz1Razz+VgNt61t3akEID/0mAhtrcHZNIDeW5Vt9quUI8wMqEKpLEZ1ZZSV?=
 =?us-ascii?Q?voWhXr9LtgbPWbZ33kKrzGXEgly78SSDcf+8CehlZI4s72l5ACwX85wAZ19b?=
 =?us-ascii?Q?vHuaeZ2Jrhn7wb8wg9M0F/kNdAVg0MrGvIxIP53Iux5V6WAHQxxT7sxHOyrf?=
 =?us-ascii?Q?Q3xa0OQSF8YSeoAHgfnqjYRy6UabPCOYC3JUQmjcgFsBf8hN/m8alhNJ4mb1?=
 =?us-ascii?Q?QtqYg0IF8uCHuTQKbqsp8zZCA0b4isinuhqEroLWWtb+tIkIcu+ak2ZqA1lK?=
 =?us-ascii?Q?WuWxdeWrRQoLKRIxC/0A1aQfOsuBAbaR8pbmbVSs1nPb+w0tfqmdprP9IF54?=
 =?us-ascii?Q?8LKXekJPgM5DoA0gN414PEmx0SkmjI9nPwTQcBIfBEOEZnaK2BCkefQ3H9c5?=
 =?us-ascii?Q?rLN+5Kh1wtGshOTBxEKeS1cs8wsKWdNUpv4+ej4CAyYBX20G5493mOmo0AD2?=
 =?us-ascii?Q?w0qBlRY30vNm5RihTvzT9v5CEhbNhUa46j4EHwAbX2FJLiSYDppYWYfllcgv?=
 =?us-ascii?Q?MbBrPNzfsIaRd54rWfOVWmVccE4HcejBWpGAtNYDZgRIujze0GtKxDQhIL4i?=
 =?us-ascii?Q?qB7Sybz4fK7Ur91Rjqpf8HB0u902jmbMclswiGKMxYqyjuHVg2T7z97jezYF?=
 =?us-ascii?Q?9tZp8UF1VrC+jlIWZFdv8bRrfomMcju4hdfntpGeDIdBytXF/vU9zNiP1CXb?=
 =?us-ascii?Q?/IB7eWhhZih/xmTlum1+0fuLOgAbbxjVBPzMCef0YP2JJmeK6xNQYG7TAg1g?=
 =?us-ascii?Q?ZQngYLjwmA76cnpSN3HD6/yK++XtiyCwZ0BZ1BJjXi5PjEgogM93A5W5WkGn?=
 =?us-ascii?Q?TjLEKoIZ/g6m85AxsnWvwiTLpiXQdKoi8PJdlERZtEkYub8PIJSgrsFyIYfR?=
 =?us-ascii?Q?nBoDNWkGWxlU7ipHvSYk6NAnCeL9ED8EZrXmz3W+WnKN4YnNdRa7w1JGrRGU?=
 =?us-ascii?Q?TVhLcYw2FNhpx6hNytNG9CzUi70a7A8edATRSa4AKjSzJ/K0+YP7lFIQs6La?=
 =?us-ascii?Q?i25K52gJdb3ujf5H9l/7+foaBlAbXdbRZAKDb5OJPqGIs63+yrW6/2IJ0qMM?=
 =?us-ascii?Q?+NvIrVBsdzWJ+T8KoLKDjHGOuh0nsBovEi8xtD5YAA8jmFipSuj6lP5k/HzI?=
 =?us-ascii?Q?nOi4BWSrJWGMCumf4teW1m/ZX3YloaSH7XwyLIPhS1KxT8C2qdj+EUFZXSVv?=
 =?us-ascii?Q?roP36TD87A30d1lW4buDc8WAKnjJHzzRWhMKQ8hp1fG10F4kFElWGPHJmCXH?=
 =?us-ascii?Q?HIGRX8l/K1qHGNV6VyW0fMM1ZlWBgosAGy7htMPX5PrWNwx6csvObyg9RVb2?=
 =?us-ascii?Q?KuKeHN4LIhUohbSfPowrvmsGyy7sJeHyNnm3/wBbjGaSCyADq/+UYs9OO3sY?=
 =?us-ascii?Q?pF6w/jkin3q/oQk21Qt4Se8tmQV2E6eOT7byMnZv9pPANz0fF4nYhba1pKez?=
 =?us-ascii?Q?/3glqd0ubgyP0MRc2HW75UpY1rTHxDnrIZhrA3w9MSpnZBq2K6dsPQBN3v1x?=
 =?us-ascii?Q?fQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +JP7Hp1LtaHeh6ut+ps/Tz006ob4N8uvP7v59c/4pASgrMGiDfZgHHxi4eGMICsVkO+BxQgOBAa7QvXVjZk+GuFQ/9dv02cBWyKvOOlT9k+mZmxKj5nSoAf9jUSFF9vXHkF6qjuxrtJ5ZPpkGKZQK0qSejUZwkIrTLDTTdwl7wsv3Yr7+T9DFf/Uy0NN8RV8tfMfEdWFymxDNT3k46YMZdchif0Wk008wMsbSHdPLMXKPJxbiav0lZ3STJJ8f/CTj2z4OoDoQj4KC6Of4ynEgsiQbpvFdN+UPFEtc4zG5UnRlvC/8Spz9v4PU+IWm3YkMP62IXuu+W4enGTmE4/uwCQ+cdM44IHlIGMLLBnSnB1NbHv42xzqtFbL9N5libmstRaCSCYwYwsGnfciki97c9JY2ihxg0C78gxZYjr1akBG4vByzcp48HFFqlXW/m+TL8gxSncm/gzLnxwNkRkV1GqjnLZjYBy9eoJYocJyRWNbgfuQH/bwU5pWc5kAX37bmklFuPRjXi2yIieiv49522rJoWyh1pWwmnnQxTZ4nJNOcGYvFL11/zx6cjOWz0JGIqBI1CkSlq6kWNsptXykod8Xt7BSn3hjHrBhaINfFUdBK24uGqZVkk5ccJxT5wyK9CgIkyQobVFabJ106GheU+JEiIZuBXs50Vjsqf7kMubdZdP+fsEkT2IiOynhkCXbc6qTYMr/eCoh/LoH8IUfgyn17YZB425vFWZcy5oe+gYuWOc+RsNtH4h2pP5U+2RuQjpTerNunn15vF9YOAOr3NA16wquJFG1fdlNBoqI30ca682iBWCKf33LxRzbs9xb9sL15uux2QjDuXDzMuhn8DXnOhI7HVUI0UU54NmYl6LAV9QqxS1N2gCDpsoDFNNA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2546f28d-971a-41a7-124c-08dafd8ec12f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:19.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpl0ezmIkyDAO6hBE7l2ZC1krff+I47CyYPFkT932Wemd77WRkz5SqVOmnK4U5qQLhc9mMXCr/dqtWgkia5osMqX9QoFN+cfxpW5u75g8L8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: dwxaM69RVJp2Ii0HeVhYfSqmSX_zn4Yu
X-Proofpoint-GUID: dwxaM69RVJp2Ii0HeVhYfSqmSX_zn4Yu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 60 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 869ca9c7f23f..c9090ce66781 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,19 +87,29 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
-				       SES_TIMEOUT, 1, &exec_args);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+			       SES_TIMEOUT, 1, &exec_args);
 	if (unlikely(ret))
 		return ret;
 
@@ -131,19 +141,29 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
-					  bufflen, SES_TIMEOUT, 1, &exec_args);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf, bufflen,
+				  SES_TIMEOUT, 1, &exec_args);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.25.1

