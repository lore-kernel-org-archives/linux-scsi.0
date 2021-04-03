Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977E1C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F0E61360
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 23:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhDCXYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Apr 2021 19:24:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45028 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbhDCXYZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Apr 2021 19:24:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NJnFA097178;
        Sat, 3 Apr 2021 23:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=CnSpttLA/ZirQpqalclYb5twhGs410sfRKIPyzcvmOI=;
 b=V5wub5AHEf0WiaXuxEm2pnsqoQpMScJ+DCxSXZUoulVRO2CK15vfW9EiUlihjZnx4/dW
 aqDtFH9L+UOR1BrniwYlNQqPbg4BNmbttG1eJuaA7AvocgPsZw8MZzws3k4zJtk+VILn
 kt5485Tn3mA51yF6h+JWmOP70kaq78SFNGDH1SkRuZbUrFgeHyzWHi2c11rxpzL2LT2P
 4GcXiXTnvzba/FKA9AMyA3TIFqGvlYqTR7M7BmBXpjOHwperd7HkZHB3Fu0AhUMfxRi8
 wLONK2cM8tgD5zTwMcE+Uc5jDVq4atBtMq+SQuFc9ILcHkam0ruNBafgToT271cXni2p xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37pdvb8v6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 133NL6x1130144;
        Sat, 3 Apr 2021 23:24:12 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by aserp3020.oracle.com with ESMTP id 37pg61huas-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Apr 2021 23:24:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTrgqfkbBD5qHokipKijxoWzw6G27zONH/3pKD4hMvEz6PHPyjaDDohGUZI39OFgvJGehF5ueWqwavAYxnkZVOfQMp2C2+Yx4PeKGYtYEvoZxi4T8asi94zGBUoPGfRKipnVq2rzciqrNof5dq4UkBBk8ngix3Bad/UoaViIvjZNOvZiQerjobyjmRzYUxLrm+KWLdjA1T/asVekNwseWBlG5e5DfRBUAu5q2liT6/+B9oh/jVuFWsWHHVvrH8TWmh3BM5YhydQDdrV51ks93NT+l3TehbXHBMk4W3SAxxVqqxhM1AkUrQ5yBIaA5gMWXfLexVPdP7nua5jg4ZAZSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnSpttLA/ZirQpqalclYb5twhGs410sfRKIPyzcvmOI=;
 b=VUHsDmIugzRskGXrYsLdpowJvVTbG/GS3C20+D0BJGX7NqH1lGTRuWH7wmhMoQb3qxookj0h/FRcx0p/hfILxYlMSrNxyRxCaafcW5FgIQ/whvaK9WcC1qgFNExV8HPR9RxHqQnBLSRiopuIiTikEJnmTTEs5vHJ2fozXtTGrwLY2S7JAwuZkbq/P3Kh9yWMMbfjw3+0K0nMvVzBqUBQ6yHSJfUflz+ino8B2RLCGq7kY+DiA19+5JobwswCGlwZ1dMDKKY9PSRvQmb9i7KoMfhJ99fvZ+xUnq8HvBSTVBtOCuorfJDofGoAXHNFyCRVEmlV0l0F90HfUng3Ipad2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnSpttLA/ZirQpqalclYb5twhGs410sfRKIPyzcvmOI=;
 b=coguoGFCfOn9tuDjy2C2iepcbFCXzJE83ssQH2dRTaxGqU+GG0Gn1LkcVecVdBsCJQVvOoEiya76F/bwe2v7bblh0nAV9i23kS8Ot03Qwm12DeZXRWQhxTE3kws4TJu1WG5kI0fWNz0+vv0PdDXR5v9VM0wNopU0IB1uhhAHhio=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3526.namprd10.prod.outlook.com (2603:10b6:a03:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Sat, 3 Apr
 2021 23:24:10 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Sat, 3 Apr 2021
 23:24:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, subbu.seetharaman@broadcom.com,
        ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 20/40] scsi: qedi: rm unused nr_hw_queues
Date:   Sat,  3 Apr 2021 18:23:13 -0500
Message-Id: <20210403232333.212927-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210403232333.212927-1-michael.christie@oracle.com>
References: <20210403232333.212927-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0137.namprd03.prod.outlook.com (2603:10b6:5:3b4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 23:24:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eec19f62-6ca2-410b-30c3-08d8f6f795c4
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526B72564815B2B76F51F99F1799@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhBt2SOAv+zZDzfzNr/F4TUqKBY8JymGuq0Dp79VceLwkMnh/qVKgb9mVybrwqwGO1vFIldteTdz8RDUe+xZnrOq9g/Dtnq5XVIF9m2BUbwqMSTPx1mkN6rW61Vr/7T6OFjnQy7RzCKogBLp/w8Zp+Bb3AxO0IT24MUrQackS1ZSmhIFVsF2VHF4HbiP1XXMl5Q+G3U/AtuKwZ2JdCg3O3GpqMxEJzZ414o8WWddlHLUSFDMLXGO7bdg1GAH/Duf/X8WSLaSRYd+4dt9Y53pWw9c+eTrdyb5Pcb97qKlq/VIIo7dKgBz1jyMQt49wBT8/7Ff7Dc+pXg3C8EBtpR06V/wb8qfENLagJZIEIe8U/lJ93Ral9qgOFObEZJebGVtKNKxUDsa5Mj8pYk1kUwqryWAvfV0GbTrK046DQHt/oyX7UDUmXmme6jQgVUtaL2+XXD7nAfpmMSHX2krOGOd95PzhSrTE3qjveTUWqppKwp6RQrWDHwNHMIXEpfpgSLQCEG9vhz418MfXAZ8Oc7tNN81DHy9rYNJ7qXvagbLyY/ofaLp80HBK4VOAhTN3SDtCZN0G1AfcBMxl74MRV7ezQIk/W4iUco/qbhLEDv4L9xTa0v/uFKDNj5zl9G2RV2kGqjbHhlykH65nWu6LLtiyfv0F6eyZ9beudimNi8jXGFCTRfx8AepaZnxSWfPURhmQgODSknxRK9YXbaybgh3Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(478600001)(5660300002)(69590400012)(921005)(86362001)(6486002)(107886003)(1076003)(4744005)(186003)(52116002)(16526019)(2906002)(26005)(83380400001)(6506007)(36756003)(956004)(2616005)(7416002)(6666004)(4326008)(316002)(8676002)(6512007)(8936002)(66946007)(66556008)(38100700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/0oShcDT5LkGESFYwlpwr2qlEqUrucQQNIM+LnfOR0LzANwi2B4akAVJvXzE?=
 =?us-ascii?Q?X6X+hdVhCPodCRhEn8IteUPDJ/96PoP4SfEUbZNqfSiOG1xsl3zaNPJWOQE7?=
 =?us-ascii?Q?Mkeasq3gzaApKRDJ7SwBJ3ISvjg5grrepbIMeb14yWdKiZzDi9ctparFrBW/?=
 =?us-ascii?Q?q7ltto4eQiCDxIiXDncICInQyEFF/L6lrS3HuTohVyX1EZua9JFlRhsAb9nH?=
 =?us-ascii?Q?IRJF6aq4wFu42jheBYw+62tiu1E4s+9HUdhtt3T5ZG8dh6mhm4PYoLBUvWBu?=
 =?us-ascii?Q?CtlBfXMCrsTokRCBogJrDCorOd5rbCm9PCmXh3XIjMgyJtts8BW5eJ9LlnFm?=
 =?us-ascii?Q?jtUDYZYNOUKcKn17PXvm+OCLu/hAh0xJ7MN6hgtKv/h1EvoFVIHwwAiRFFw0?=
 =?us-ascii?Q?AETSvFRFkBPRUoOdiSm0TbIMAw28LFBwrbYvpvVMj4MNKd8WyidMKARwsmr3?=
 =?us-ascii?Q?2kha7OO5MNJFugYVivn1l3U0or8IjQ+Q/0jug712G3YNLk3rWBYRswx04Ahh?=
 =?us-ascii?Q?IPKqqiffgJAHSsVh7YlegeIc4BG9FgKjXdurCX64A2gYhyB1Y0bp/VxMbwSm?=
 =?us-ascii?Q?BUkilbYV0J5SaIRI4MWfvpQixzpSS3oIy6N2sIz/FCH7A0gJU6Vk6qq6aNhS?=
 =?us-ascii?Q?4A9Ml3cBTcyYTaNCT7rbpNOSpmNiF3FEah8yrjKiaUPoS8/ePHgaWebSTGA6?=
 =?us-ascii?Q?M4P9CuVPBt1mXy3mP0uCpaz1iICyWHi7aJqK6q6CVH8354qMPr83zBTJaUaj?=
 =?us-ascii?Q?7bNRHiX+Sh4biVMmjFZh7FLiwe5wZQolanQnKb1Jjdfxbzb9UGMuC+GrCpqx?=
 =?us-ascii?Q?cFXEtMrC3f/YXr7ULADKU4+v8zEMiBBuXW9DKdqztkNNqC9kimpl1jJcunuW?=
 =?us-ascii?Q?Pi7XmrlLXsp7/ViGUgSQBOJQ9uaYeoztWoJSY/HhSM6BR2S+57jEjJSf9eXO?=
 =?us-ascii?Q?sUCa4la2sdEoiFvFgdVM7Kq09H5Rx34a/ALSwTKEgr8fINkb25TdNnJsiNdr?=
 =?us-ascii?Q?xDlbIX5WDOWjfWbzV6/uLHw2S+Uoc5AliWTGR4Mv5X3dCoY6y54W7H/1/4aD?=
 =?us-ascii?Q?RvyBBwGMtbdIP3w/ewYcAwyvlorqS2rJomyPOZU+Q8sOWGjRjpeHjqFGVlQ7?=
 =?us-ascii?Q?4qDcyqQhJaZTrz8yTyGrczakXHAmy50ezVEmvvd7RGj7jEDObLvZB+ekzP+p?=
 =?us-ascii?Q?Xoi4QetwLkFfeVDbDcG4ZA0Q6I/MTuA/nGXqjxRaMz6jAScczYEmuqRHPFy9?=
 =?us-ascii?Q?VwZsyKSF3qFa4IinUAiUEKCVc8LoIp+Mohfa5HtPGt5+swDIbO1rnYxr1lM6?=
 =?us-ascii?Q?hcC8TslD4Kq+lYgqDxqbtRR7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec19f62-6ca2-410b-30c3-08d8f6f795c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 23:24:10.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2F2tiJOr+u90i6FBwh8YWJXb+uRp61YUdOg49gsyJ49VlTjpasCGRo6rR3pnnQu52QSob8kVYJHPTv1oE841on1jpOtd5OtIfSYiy528jls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
X-Proofpoint-GUID: gzPKGUfAb9ZWA0nJIA82E84-Ps1VQuQV
X-Proofpoint-ORIG-GUID: gzPKGUfAb9ZWA0nJIA82E84-Ps1VQuQV
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9943 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104030165
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

nr_hw_queues is always 1, because qedi set the num cqs after
qedi_host_alloc. It's a simple change to move this to before we do
scsi_add_host, but setting it seems to drop performance. It looks like the
problem is that there 3 locks in the main IO path, so we bash on them even
when nr_hw_queues > 1.

This patch just drops it for now why we work on removing those locks.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index f10739148080..cb792020b8be 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -656,8 +656,6 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 	qedi->max_active_conns = ISCSI_MAX_SESS_PER_HBA;
 	qedi->max_sqes = QEDI_SQ_SIZE;
 
-	shost->nr_hw_queues = MIN_NUM_CPUS_MSIX(qedi);
-
 	pci_set_drvdata(pdev, qedi);
 
 exit_setup_shost:
-- 
2.25.1

