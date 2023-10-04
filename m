Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEA3E936E6
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbjJDVCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243986AbjJDVCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63E0DD
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIxcW027949;
        Wed, 4 Oct 2023 21:00:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=GlTbko+4an/EbVgofn2WGWqLaTtQFO/MiJUZDfDTzhw=;
 b=G/hF9uTI+toHiM3ybp5lSBU82O2qtZEsM+7MR0Ap6Hfnik1h00VewxgEmjPPd7UWAJVA
 eofrKzsg5ggpnITK9pfwp33xpjlBljZQeLn07cVRK78VvqUuPXy1mz9MyD1VRuxd2ldY
 o37UDU8lP36QonG3G9Vu7E3htZPFpkQzJSjalj8y99DU/nsejsTwkkXflBsFOcG5hCsg
 s9NNdSt1GABStaggCTS/7FzYdioFQBSRshAzqBrRzQU0mOPPtpDAwbbt9ErodLuDzeU2
 mSinkNsVMm965mK4ZrXF37vu1f8ehZq11daighW7dkVxSSSdm7Y43kuFEBEx2hN4Nm4+ Ng== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebjbyyd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394K2gw4005824;
        Wed, 4 Oct 2023 21:00:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4869j4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bq7usmchvUBphQwsSw4u/i223qLnoh18k+qrY3q2M1kk7xn/rVdcKnTJ0vB1D8Ypm64tA772wK3tTLs48R9fE4K0s0j3sA4BApI138sOJBKDOhGx3FVbc3TfKMrVOgluBDl87lCyG3k/3lNZY8oBmoyo4GpylHjXvXGZRm2VJdYpIWTwXDqa94ytyK76XgTvFZXrTqWnyFnWc/QqaVtN6uX4tCRBa5Xv5GV50ox/wSXL92Dn5/cMS685Po9wna1PK9CuovVLNO4DZlytQLz8IhAjZc4QFTpgbxASdadDjlOUQB1rEDDRoCsvWGgMAlvANMVA8+sxOXrpsnGsoK6ilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlTbko+4an/EbVgofn2WGWqLaTtQFO/MiJUZDfDTzhw=;
 b=YS2Fsjn837m3b1I8S3nSxEqXUDaB6+6CWc9yA3M5UeP+Z1njROJwNWYqMifWw+a7ccPL3YK4CijlKOaOU3KNVPOT8DfMZcG5L+Am/7c8EMRECRJBkeky0HdMJ6lYP04yHKwdjd2cVINNjbIO9Mc4orkPea1ZtylHj+hip74To4fvqfYYP5stI5OZLOagaikSbvTByYg7cBb4H8ERqBu9NDN043wKk6SAWnDiNAwDQpjY/DvsqpT2EmfYaa/gZCvXqFslck8rosVfSPqGoiQyZPENWCKR0liV2nHqqsfZk547tB89Gu4/fjgbFCHzvjQwvn0mOLqoRPItPhjvy4mlhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlTbko+4an/EbVgofn2WGWqLaTtQFO/MiJUZDfDTzhw=;
 b=Wq7lXtlMlq3NWNhjeuBHxHrMS289+xkV7m6AQi8oriOgxJcUgiuMLSIROq9fEE6XHBJiYhX3Etf4mBAq+trVy0evFaKz5YQ3/j08XkxLtt7I0tbrsd1Ivx3HdtPPhZFgHguWqU9P9UYpoEl+y/r5t5TVIsVtaQGEPwFurWD305o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7413.namprd10.prod.outlook.com (2603:10b6:610:154::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 4 Oct
 2023 21:00:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:25 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/12] scsi: rdac: Fix sshdr use
Date:   Wed,  4 Oct 2023 16:00:06 -0500
Message-Id: <20231004210013.5601-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:4:60::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e925813-b0b4-4d59-3b69-08dbc51ceeb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmsWbvEg6oUNK33aRXah+e28Wu1M67rP0TDqKdANKXbgrtnwNkRneMsQSl029s1ccHZen5lbs+RCjmQH3oCpXgWjIbhMJVgVAGyMNMoFIf965xTM1kjQkV7UqgpnI6dh/P+un3Nrvw3Vm1UaWCsAyiJdck+iGLw4MPgYLQ5/FVh8QBP5qLYr8EN9ULwsEMzq3EOiWFKiEWb1fGpiO6fIErUGOWrFstdYwgUxnVYoYnnED/wm2WfaXH/DD4P1y0ydtfAZ5yhvg29pK3rC6v88xjk9qS0yklaZylJZp0XJNQE4tqTaU/5rN0MXLl0iRDc2YrXNnmflKDsGhWAj2wzZ4uE+f4w5KBQa3knyLG3xsLYgQq1U90Lm+WDtvkbHxuUJKVpR4INZ9VF4HJpIfP3ye2zVa4VTGUow5gfqbHHj1Pj6dhnCDsftiHjqLMZwksrViGnluJs11tUKhdufBpG8HAqDZxrDBpf3rbyEXlsHPvSXSnNT4Xvt26PcOXgB5VqyLLOKOE7IcdgaGkftx6N9yuUQz4Y/WnLaYtda17+cMy2D88n1yFLDu1luT9jQ3Ufb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6666004)(83380400001)(6486002)(6506007)(38100700002)(6512007)(2616005)(26005)(107886003)(1076003)(478600001)(86362001)(66476007)(316002)(66556008)(2906002)(66946007)(41300700001)(5660300002)(8936002)(36756003)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rTlsdNriT9Z7NltXBqquPtmVIHv8F77uim5N1joeDhL5GUbAJbfrhz0SqaiE?=
 =?us-ascii?Q?0veJsieg82Y8W05sfxWLirFXagMDYd3/auOVeA7PmC/GtNsTRTIhZLrleqzS?=
 =?us-ascii?Q?hYlY76cTjXiJuSLRwnjZ93et4Ciibg0Fs68p/Xg8GOGp6+lD65/dchd/9HP7?=
 =?us-ascii?Q?jGokaLJ3I0SzNKgDMsGT3kx4fOCEjW2fwmIv2SRmdywUew3Jr/T2vHPcq29F?=
 =?us-ascii?Q?2+P3hzD3H7C1jr7V5GafxWjzpDwv/0OGGcjcP3JevyeCBRUAZM4sU5YC4HPy?=
 =?us-ascii?Q?dXYDMPpk95hcsrmHvoOKEg5FGi1K5jt+kIyJJMZphQc7GwyVKeOWgndI2LeT?=
 =?us-ascii?Q?e3+hz1e6yUFMxc30p2sh049ijKltRme5w+/KJbQ8YnDCimERw5qQCjYnqITn?=
 =?us-ascii?Q?vz9wNUeOihm+oSLmr8FiYxEkvfIFRIP3aq7Qz5gnK94RThUlnF/a4DQA2vwd?=
 =?us-ascii?Q?J7rufco572QnBsg0P/Eb0Q7yC8YEm9mxdU2UBKCoNjszHNCjd+0LDNoadaqx?=
 =?us-ascii?Q?vtFWZMsylfo6R3meV2DaaUXhEFzfvmORVHil1e1WP0M8CuBYbnzejnbbCV2a?=
 =?us-ascii?Q?uwwHkZcZotMeGGrRTbAln7JFt9wpXsZHZEwnTlyB+xK3WO9FAd8oaD/gvsF4?=
 =?us-ascii?Q?HgC7TVnjsws+pXAyVSQQ/1DbTad3tL3EbM5nAbGOHvOErT3PuG+nH0Umj9zg?=
 =?us-ascii?Q?0cPaV3G4Z3OPKvAHKC1MTTbRQfmgg4eYyu9duAlPYLsa/8DtCWtQ5J/lzZIC?=
 =?us-ascii?Q?+MX/G3tjYw3bPnTOA5BWmx9O1IaZj9g1qwQ/u8uVEmflxBivGLaCNPyxM0eJ?=
 =?us-ascii?Q?j4QmOQz/u+yuWRlWF42J2C1nRjBpU/YzO2KFyF/1wyfIT4hL06c1hWNcm+8/?=
 =?us-ascii?Q?35j3+CtvxPOpnEj3cVDQM8hNrIQuSFMsHTxIJxTTqJKABsXD3YjJIBMLdcA1?=
 =?us-ascii?Q?ZpfxcU8+VixwL/rg9KnjbXCWr0lmCiPU7zTsrB299pAVPLBcJR1kM0rzSCK1?=
 =?us-ascii?Q?zt0VntAwk+yvf+IU1yDQwZRcADPcKuieGEioMKRJuOMNGJdd/MWGmxq9vOq3?=
 =?us-ascii?Q?2904Nf8u2wGlee+9tYoyNwKsqwp7/f3zKP6kmz7tK8pGnwy+cmbbFmzIsBKx?=
 =?us-ascii?Q?P5gN2BSOcTfFTBJG6qBYS4f3XCX5qUv04cG46MvMXA51wKIxqn9KK0m/Dkx7?=
 =?us-ascii?Q?G4wSGSe39PC/0Dtz0+1obqT+21UKB+kn5FeapL3C2KCUmQKlImd6OjJlUja/?=
 =?us-ascii?Q?pG/fKEhzjSrmn0KCmkkax4JC60knI8OIOS+OxFIPqfLuyuMm6FAqyMX7rHym?=
 =?us-ascii?Q?I7CNCdTaWQbj+FgRg+1qfoxJBI3Bd+KoD3ukP2IItkZvRiRTdZNokkZGXXLT?=
 =?us-ascii?Q?k/skNlqy2JbxR3uCeFl1PWzIjS645uRGHEOMEXr/CXyxoncKzW0cm1YUEXdj?=
 =?us-ascii?Q?AIUoUzjofxlYNxsF1CnWm0GrNLZaEtdJPF+NvD0BW8gmbAsMmibRlCRWr0yD?=
 =?us-ascii?Q?8xCcJeKqUAf0VhXL1sMkBZWaKUcjhrmrE9b4mlFcuaB/xb2yu+vSKwaqs1eO?=
 =?us-ascii?Q?5awqX5RVopfWsUig9t0Dtme4MvYClG8Kbb588qq0tnNjlcfeRZmAaKztT7pu?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: O0zZRmZcIjAgFzzIehhMSmmVjDpLDAJ8UYHqNy9Ed1D5vICiOz8ynp12AeLfdXY1WKwNUYXcPFvfWMRYa1p7IuLF2QAekGxRYqxYGUb2799aUHPtUXkKJFRgZ5d3Ms6A43MNNbXX8TvCo+vS8s/wkHTVlQWRg7OlLyBmIBiKBScUioJPVyF8+5Hj2iouZYuk9762o1D486BcVEGkm1g2biVrOj1nHVrQeO3EhQqBjzE7HelXxpctUNk2ko0M9NJ1HMKgkvkowCUkku7nq/EWUxU/g0H+xrl0pbkQ9UpJD1gAAJeGX1qI5iUDVjUh6xUpz+v0fRQX6+t27iPr6XXw10UhXqVeaWuIwi+fabHHvXUklEs3Wi5/Xw8MmwZRkgyzXUFY6I/X71JjoxX3rg60AIPw7lNHnM4g6unT7LQ8PgpMTqtVIpNLCPOza9vcOd12H5qmPTi46QcrgKc73T8S2UM7jq2Em4bsuH8cuwINMIvb5gwoHF6H1hxRbwR5LSnWMchWJt3GmDAN+TiON4gfucbzUSeWjl2PJmr/NOL+gCPKC0ed52rOC3+ymFm0+Pb61HqqfXiAQ6Zcqc1q3coyCf/Z3VvegiLeiHtubgzHe1xYsrdvUvaLdI/NviccYpt7oumgruswdIDWyJCi5oi5Nir7rtv1TAXfuY2YRtYbFq2Rd3ZOvJWvSMbwauwW1uF02kLpH7ie/HmmfSDf/K28BFwokvFGRm3inhHKkZNxErmO4ImuIjlvzrRLccnqATg3Ry2WQxaaZw6C7GzUf9v7nbqFERgT3S+sXOg3o4B7igy6HXxcVG12CLnXkzqqiS0R28HEESVS0NIWtnZ+FqfHSnixQ27bJVSY7iS/A9f8KEKGSPI+bnwcuUmuwLzCuvYb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e925813-b0b4-4d59-3b69-08dbc51ceeb2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:25.8286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOJX90qKJe4IdGyWier34CEdnexCYJa4T/ss8HTNqERfbrMBWU5LJJ5ehKKn+hTO/HebK/l6vzc4eVlp9R9fP111rUnh3KkM4Cn75s6Ef/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7413
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: h5ghPqqOsqm5gq8Og1Y4UqtYofghgh1E
X-Proofpoint-ORIG-GUID: h5ghPqqOsqm5gq8Og1Y4UqtYofghgh1E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b65586d6649c..1ac2ae17e8be 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -530,7 +530,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err, retry_cnt = RDAC_RETRY_COUNT;
+	int rc, err, retry_cnt = RDAC_RETRY_COUNT;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -558,13 +558,16 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (!scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
+	if (!rc) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 				"MODE_SELECT completed",
 				(char *) h->ctlr->array_name, h->ctlr->index);
 		err = SCSI_DH_OK;
+	} else if (rc < 0) {
+		err = SCSI_DH_IO;
 	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
-- 
2.34.1

