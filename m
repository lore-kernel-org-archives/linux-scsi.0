Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F02EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjGKVrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjGKVrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF7E1736
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:12 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID95W002987;
        Tue, 11 Jul 2023 21:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=SlU/HzdxNrSha8hXwsmTHRBZVn6ykT090zItMDaTKiI=;
 b=1lGb7kFIXMz6RSr8Yd3peo3dkZXqsx7xDi6xJ5uaKqhx4gbDVB818Hdc5INKwN6NnveF
 ISiPzriJ6iaMOVv1NgTsMPQpxGrm6MM6wYPgFD8IFkSKTVn9Wq4+aTbghdS/dWchjd51
 vq1lP2cZoI0nRnkEdqyHE9beafE5dSEoM7r+rINOihHZecTew1aLYc/dg5b0zm9cy2I7
 k2ZXf8GMSqud7gW6sl4BFZcPuxNx8uib5k6Kqr3wL5CVyZQ5ZcGo/fqWSrjc/q9vo6/0
 Pl73VkU9oVQWkHQAOijKSK5MzHeobRFxqX5ahOuIyFswgw3uI+V/WDYYpXC+92d/igNG YA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud648d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJwJW7000496;
        Tue, 11 Jul 2023 21:47:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd29shbj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:47:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpvprQ+/OgDL9T1PuBRZ4O9t2A/dkg6X6MxUzTOk7ol8P9QbHGPjyfV+Kq/LxfEotmgtM17OAzsKdmoS4UfUHNOTn1geLgIUvVARr0AIvUSyGT0GZOc+j5UlRQWrKWJiT+fq4Qy8yCx3vZ8bx3oP5Aun+EVwCPCE0XjKfVVwKi8cbUmPlxw1HnLvrDyx+6E3rtBDVt64MwgUem3CxXD45p9TmLDV2cQPooHv3JWYGvbgnIPJgtBPpQhV8BweGZMkb+SHeY66Us5L1i88DIJJgbtQ49ayoc+8k3nFxIgGEHa9wVDsAcqubccaSy4vLldA+jRY+43tjXBvb+v8AXet+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlU/HzdxNrSha8hXwsmTHRBZVn6ykT090zItMDaTKiI=;
 b=hQosYSYPrJN9BCTPor2P5jvt29mA9qmI9/wHPTKidxHTpvEKLctXecZioIAGKviGpxuR4oJYx0mqh+i+zYc0tMNUJwV8hA9RBxJb47eYQOL4S9NsCUz60nMA8mpiRsGhJxwcY6xC1WsPyVJUgzX3tedNE/gLCZB0b1Rf19qTTgxaryaB2UwHbV+/IP/PigFMHFFRY9CTQ+DVyO/nRXHmx3Nz2l+FQRvNoBo2n7CIY8qTA7rvZ0ns8fnew0DDsdwr24xuMaIMNwB6aiH4oqIztrS9gVrV9eFJHwHDDP3AZmNWb7eBKJi2BVmxNttfmrXdrwFTibJ6PZJt1qUlygD8ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlU/HzdxNrSha8hXwsmTHRBZVn6ykT090zItMDaTKiI=;
 b=bqGStRprePhyx6kwUKJzcpw4ZANyXMCyQaLZWpkO1FhC6uekzO7Nnpy1SuaZ6fbs1fPMpxob9O7zfIyBsesW1XTLjYrRfaGVpHfUIGkGyYCSfiSEUb+clZF7Aci20xEUYPSTzPL0/RxCzKvV0PaNNmRIOnpLe5z9Usr3UM+Bzwc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:58 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 16/33] scsi: spi: Have scsi-ml retry spi_execute errors
Date:   Tue, 11 Jul 2023 16:46:03 -0500
Message-Id: <20230711214620.87232-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a2e332-07fa-46b1-44ee-08db8258595e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Hem1vtepuIo100crHjzNNT+8fw8buQjl6mDIiBQlC3o8VJvZ2VDjEQBc2CGc2CSFFX4Vw9mBKdWNXqqSKsR2QL6Cy81IthUQejAj1QNqQwD0q4ANqeKvc1bXCF2pLMOAVvIXEov21NtoxBbnAHW+GwHhQdKeEHJ/kcMXD7mtsY3vFsBNam6x6jzQwQ5BiC0Ey0QlU0QIIzncOcVIEnGrFVtrabA4IedCXsdOWR85higRlh0U+PqCfYRXeEUMEUcZ5+rFwuKYmKiUmXr/kcQ+kYiuKbAvjuPrsmaUQIncs1T+1OWlJwwZgQl1Dcrc3W9iuoe0oouKvgPDvBmnVJZY/1av1SHRyjrwAbcJ4AfYZeqBykRTfwULJv7oFoKZ0uPwY14qvUaS7BUtnki4xwQbmW49BvG29F1v8qN/oEQqCh648HgJsPCOpyt8wSUhibr9shpUgGkb81c4UAM57PTwnvqatvjMSt6ox7j1JCQwK8h8O0B+YnyVU6wKX5o7uiv7VpFcy6ymowGMTQ/lmlVYE1scbZZv+ZYqhogIVEJpcAh+pGML3nQPMLdT7fyOIrN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1kkWPonDRtubjXyMuqVE5JcFsA8n91Q6tHuN2rcraH+NKHMs+mtJMKH99K9Z?=
 =?us-ascii?Q?r4onOGQkRlcC1xKjr6hHSBx/6KCEQSLLqtJeijLJisa4IHOxk0IOBfmH8Qsn?=
 =?us-ascii?Q?5vvOR7LF7ZMdr2K+hCKfDmw7xbbfjk61HHEcoT3Ecn2rQYKCufo3vQVl0998?=
 =?us-ascii?Q?J2lPkXrRO040i5Z+WhxlL7o26YI8LuaH/JHyjMWRTPYCbaLVL2nwb/iQbfBV?=
 =?us-ascii?Q?YxkvBC4oFRPcVIfrT+Vjy5OE6sC6ktTNlhrl7ER2umtR61IzNUwKUPPEK2t7?=
 =?us-ascii?Q?AgHoOWfUoKDbWOixpJf6fx6RIcP5Z1055HbxvUlAG9oFsPqKynmNAaifrplb?=
 =?us-ascii?Q?7pcZZBOnC5WDS3mm4labXG3NIJOlbHA0tPpXW7wJ/KtqZSdzh7FkrSn21ZwN?=
 =?us-ascii?Q?6P5gCVzjaHo0AhvnP0gDCaEWmOJWT0YVXkpC7zSg67gqX857WOAv/6pSB8ak?=
 =?us-ascii?Q?a1TT4Y9dP2TSQ+POtKc+IFIB0vHh0aM5pfxk0ELH5xTcMkvQUosepaZzTJpz?=
 =?us-ascii?Q?5Cb3/9pxuqCusKEeHOZCAJ9MHMERDCYUYEi4ExtonuFhPJr5f7Uz8+BEu30r?=
 =?us-ascii?Q?CCBOyqauPsF+ihigpOw+ro7xelktH6x23dNpTnJOtDbsQcX+ryN4zi9B+UKY?=
 =?us-ascii?Q?apM4GX2hr8LzTqqVS+362SvqBcf6zG+welIz7ZfndjxE5uq7uRFmg4squ2Fq?=
 =?us-ascii?Q?X3ZLv58p9bAkjWV13IzbApvBsX+Qk7r/Fh20JIQ7tgtPhLSs/2EigO5ms7On?=
 =?us-ascii?Q?/Knttm4EFAV8fL6ZEWxCZN4Ek5k3D2++i2VXu8FffDuPBHJ8VexTnROEB1tG?=
 =?us-ascii?Q?HfB5Ua5oPAR7gyUwBGud3PPs9TsWDpc4guVp3sIfc9UsuUmFuoU5BfhyhswR?=
 =?us-ascii?Q?i5j68I6dsScWDBMB1jxYi+scUpfYRI1/oS77IdfFvSZQMT45qXLpk8OCckjG?=
 =?us-ascii?Q?v/r9xDmK1g26lH9gkdQ+7ZXSGvt8rASqlGMP6k0slw/TQW8e/XrQDRAdw4YV?=
 =?us-ascii?Q?+yywTJE8YyVVYSD1WjPwhAh+1AjUAgi8mJackPpbosRxS9TKvZFufYp5P+31?=
 =?us-ascii?Q?WjYryZG4dFxksIb+m2I7r7SKygKqV9I0cLnENgVZsczgZwu6pIMOjVobhLX/?=
 =?us-ascii?Q?He5IZnittrtWlunrzG+zmmjI0zX2uE6yrlySkJBe2u0iw9WTIDOGnbTkMcI9?=
 =?us-ascii?Q?5JPv7GarQhDz5rJbJ7t6iC+vOTxB3TpvsqTSMcMOs2AXg2CwoqzZMpA57EzI?=
 =?us-ascii?Q?v4YJBQRNtouFJlxaHKoymc77+9C9+Q5Yty1vt/9fsTHHQ1bMyzzQjUvw8ale?=
 =?us-ascii?Q?J//Vf8l1MlyC2tlEmrlX2JnE47f+HNfYIDKkR4ya7qUJLSwp0+2Jye5LIMT8?=
 =?us-ascii?Q?Y98ZNYmabNzuOPfQui6Tw3dUAQXaYQRQBAff4hvY5Cj5z+uKEaBal3nBcGp9?=
 =?us-ascii?Q?83CmInIxJiCf+YQZ7SiA9KhsHzMeoI5SP1hgqr0TCFFApGMeeXKH9Li8Fs5l?=
 =?us-ascii?Q?TOHM8oqelwqpA8I5zpF3+HOCAfMeWXv/RmvzuIMB7IWCXfKRrAbNNNzr7aXI?=
 =?us-ascii?Q?1c0FeGr6ZWhhc31/wpQ4EfgTmdQ/+RsyO5DZHdw+SNTgs28nfGYlydPbJ4Ig?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: CSbYHakhWbgIXlt7zPim3XRyukXDeVclvZ5SYVwpvNrZ1gFHnGT+fjQvFHp7Rq3lB4i235qldBmv5Z5PZOOGlGjruji3K94WD0buTj9lJuoV9BidC6N/ixfjWbEsyHJSoPir6vmaqYnkCc/frMjG13ylgEjZDsN50NsD5L46xczXypzCEF9WosD6lCWnYWtEfV7B/C8oRimrWELfsDBJaSX8UXZ/Q+tlAiFcnpyjjdab0uVBUx1QR85lVC7HS6gIXzrKCpqIl7rERbss1PZmBdRRh6mNRsGuH/wDqA+eonc6/8uBewcsnScn617qs6UX/fMri/NFRrKoP/GlU68jmBOTC5SmLTZ4mUgNnz39/gBcLhYO/qLFpNe7YZguxj9cBOgfDDdL954pUBGfp/bKUwzbkUbD9bZMAGBp04hiuEkFn7N9Y1mj7SBbSesYHsv+/rvgsxEI9vzJhOqV2p2qGQrTg34V/PJyKsi59E5M4UYnhdR6EeCFfXajtSe+8D0JxPk/LT6oXQ2lQsQ01KfGsXQqabVk2L/1TbzZUkRV5LMDpGiZ0h5MLU8wcSKUyWFXB11R1dmNvHeIYeHT2WJh0GDx8B284++shNM2ZK62jdqY4znKGa2SWPUhRUFsNkGxdyeSEVSbJqPW/FaQhi3FYfIkKoxSSP+2Hk3vXNb+lMx/VkcQA6StY0/7HKLTzfP3ePCJK1VNRo4qf9FMTpEMaMmEsp0xVSXXnsTo/OjzfMCR6P5JhNxzp95MohTY6sp6kmmuAQYgwnRRV7HRI5tBq31znI5YiiFKTOntZY2rNYSPzHmtW0h4JCvcFhRMDB4wnHw6+S4qeS4SlaY1Up5C32tH0ktHlk50pqnxjfnHJfVqNTpKzBORmHZDAaXPoHKv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a2e332-07fa-46b1-44ee-08db8258595e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:57.8258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDgV5At9hwUxyQ+hdr1sf9Szks6b7ZGA9kATBQiziCKGjxZM+QQf+h4fkjfn3/b0MYYWIIKHNxTm9nvDxIvjitIdC4V73IY9ucie4unmC9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: MT4b6uyFV54jWGzA9IkPgLXALupDlu8T
X-Proofpoint-GUID: MT4b6uyFV54jWGzA9IkPgLXALupDlu8T
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has spi_execute have scsi-ml retry errors instead of driving them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_transport_spi.c | 35 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f668c1c0a98f..3a7a61d47910 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -108,29 +108,30 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       enum req_op op, void *buffer, unsigned int bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
-	struct scsi_sense_hdr sshdr_tmp;
 	blk_opf_t opf = op | REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = DV_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		.sshdr = sshdr ? : &sshdr_tmp,
+		.sshdr = sshdr,
+		.failures = failures,
 	};
 
-	sshdr = exec_args.sshdr;
-
-	for(i = 0; i < DV_RETRIES; i++) {
-		/*
-		 * The purpose of the RQF_PM flag below is to bypass the
-		 * SDEV_QUIESCE state.
-		 */
-		result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
-					  DV_TIMEOUT, 1, &exec_args);
-		if (result < 0 || !scsi_sense_valid(sshdr) ||
-		    sshdr->sense_key != UNIT_ATTENTION)
-			break;
-	}
-	return result;
+	/*
+	 * The purpose of the RQF_PM flag below is to bypass the
+	 * SDEV_QUIESCE state.
+	 */
+	return scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen, DV_TIMEOUT, 1,
+				&exec_args);
 }
 
 static struct {
-- 
2.34.1

