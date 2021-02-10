Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB07C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 006EB64E45
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Feb 2021 04:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhBJE51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 23:57:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhBJE42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 23:56:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4sqrl034274;
        Wed, 10 Feb 2021 04:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=ZrhSxDpGiuoIC3wgDeHHH1SB/vn9aAiRH+pEFj/pm/M=;
 b=R0IrUvTYet9iTY5kJK8V8OjstnzSdbVc8i+VWmnUKmhYVagAcve8dE9ZO3rq3z8bnv7U
 dP/LbLDizWtQKS2hFGYnW7vwksMaGAz0ql5oA2dz38j66TjkQe9xx11+YC9lvcQRsPUi
 Zyb/4g4MVe+g3v1AmNl5jNWbCDTBKd5ytuhNB78dXJakzJEDT4fHmsMENTiBQDP+rH0w
 BVoqHcXkVKSTLpSrRxJUXMp8uFDkeVHbvuo0TCiUsGfaRstptGLf4fNX3gLyr7v78aPd
 E1dDhfNprRAZUAJaETJWhymixaSD5O/CH8AV+d4JEnIV8vH5mQ9V/UU3OGyxPaEDZbCv zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36hjhqswsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11A4tRB9048727;
        Wed, 10 Feb 2021 04:55:40 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 36j5126403-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 04:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOhfRCiNqj76H7QI4Ha+7tp5rjThTeLt7sIUv0+6JQQ0Iyd5D3nRp6VD+2nCRljwmmH1pj/PEUIe6Hgezv4W6aFzeBzP2+9B1EwvGfjDmRIGFhd7NDFZPVhVFd5Kl6r96T4CwyoxBI1VEtQXHuM+XTx1gF4NhOVHvrwYYsHrYUoG18gLfG5ABeEXMBsvs6efh8rYBIUCcT/z0tDph+HcnK7hBfNMEyk/vgcKpzsECmi9YN4LQcpaz0ouzIK6I0IqWGmvllJjK8O9FYpj/V2yM8o7z39WKXcJr5Zs0Ow/SNGMM2CIhw1k30x8l+FaWvkb2z1nm3cVostdT/Hz7FbIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrhSxDpGiuoIC3wgDeHHH1SB/vn9aAiRH+pEFj/pm/M=;
 b=HfI73nFHMmzAIKjh9xY0Oe6q+1AjFRgEWI8MiDmvWhpj92NKz5CZEAQoVnZBxIs+qLzFnvA1iIHqNBWpNXndGfEVv2GiAKho7Zg7K8fUwkJEUEDLU8iPrKNDLYmS/Fxuusu12GOD5Du+9u+IdEGc+vyWy1knxQzagLEieY2TW6fyNFagFPSUbTt0lPubhoJgJRcGpcRabIw/5z4mjRwC/HZM07F0Frsac5Zp4QEVa6VPSrG6foqWZ0KIxTstelv2SI2zdbg7j3y1TQ6BaAkCIxIDQikfeVMaq07+Y7iPX4+7NV4pe8EH2j2vJpzPkNYU2nvYLXqDrBZ8A1SLuBYzCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZrhSxDpGiuoIC3wgDeHHH1SB/vn9aAiRH+pEFj/pm/M=;
 b=e4mW6OLkak+MbbMpD1X19V+z5/QDYOfc90wAiKFX8539GMAHiinCI6V7EUyA9QNFJBszpUosF1L1Z7ESRtPMs/DlvOoQIJjRZnLXHYqIarC9gzglEXZUHXoegqSFOBnQ74ioI8i9yQ5JfIZqAkW67DQ1q/MYm6JLFRNPoQmxQNI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3366.namprd10.prod.outlook.com (2603:10b6:a03:14f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 10 Feb
 2021 04:55:34 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 04:55:34 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, Chaitanya.Kulkarni@wdc.com,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 07/13] target: cleanup cmd flag bits
Date:   Tue,  9 Feb 2021 22:55:10 -0600
Message-Id: <20210210045516.11180-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210210045516.11180-1-michael.christie@oracle.com>
References: <20210210045516.11180-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:610:4c::39) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR10CA0029.namprd10.prod.outlook.com (2603:10b6:610:4c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 04:55:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 769fbde1-8886-4fb0-5e81-08d8cd801976
X-MS-TrafficTypeDiagnostic: BYAPR10MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3366B99F1FE6B529CC77A638F18D9@BYAPR10MB3366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+pzvr+KQCK2Yms0nTUpvj1l5m3TuSOADz/x99SFF7StDarFBdpOgcQyycQRJK64kNmgyQA2xzJr2MwRzy7ML++1GkwaEILJMv6ghKtT8wlD1N9f9jYBzAznGzlZc5Xa5lTYalIdh5dOeRLYKLGnk5GY+ndx28xFnLTfzTJg2CfexQOiS+mGFk4beLiG/IK9G0SOrgJ0ZF8Z6e2s8qbnIrR18ogBbH2RxGiESqp5nD0nrDoYE1btbgvAtNCzjqR/r9J/FPSLQ3OWmur1+sK0jW/kUAop4Z7sMbN04rDUxd+2HrhAdWIDSrMA4c3o6PyLzryZvkWHwWiITRg4QYN2kFjaDmmOWXRqTFkZvIP3HicfwS2a5ARwWqCkJBabVj4TXtHJ7Ofw82oKyuxSwrZg7549oPHdpnZDvs4R3KlNfbHzy0fEf3vSdek8e817AnqBh2ig6QLmdNwtnNhWFuYA3glgTykdCaKaAWpzMin5jvrnoEScrAlCtgE93LjK5B24JfgaCwpxNObYdD47LI4Dgk3xHWicYTTtI01Jwi4e8AFy/H+MTpiJDWkSt7I+p43SuKOf/CDOQUpIevnj5tp1CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39860400002)(86362001)(26005)(5660300002)(478600001)(52116002)(1076003)(2616005)(956004)(186003)(16526019)(36756003)(6512007)(8936002)(6486002)(316002)(66946007)(66556008)(54906003)(66476007)(6506007)(6666004)(4326008)(8676002)(2906002)(69590400011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k5lI//pSk9HhZV/Hyx73yC1OLsule75ZrE2zk3et4I+oqj5unHXVVBdYFhyD?=
 =?us-ascii?Q?Hpz40pwnLIxInp3NsqcZZrHEQyMBGWXZFrahwO5ii15ZmPSdtg/RGQVICQYG?=
 =?us-ascii?Q?WAvqaogT5SFucTPluQ7dlzpQ4GlS/XHXu3zvElHyJ92O1KS3qetJ3DH5TVZY?=
 =?us-ascii?Q?D19329DvDHGi3n/rwAn60Vt/XTJ2g9EH94jIhmezEci22T9IsIhpsfcXpELh?=
 =?us-ascii?Q?Mj99Nj+hMhExMgVGPkqoyP/RfuEjf9VsyGzs0eorPSAblc6fgBWQLstNBrTo?=
 =?us-ascii?Q?G9JaQZQOZXeA27zGYcBPwbAa+O7OrQWR8l98GBAh/3BMFjUNXo7cJacV+kl6?=
 =?us-ascii?Q?Lgwqb6y18IYrKJXMd45JQCRUtbRo3M1lwdCiSEDepWlvYalnGr+6RgOiNZ9B?=
 =?us-ascii?Q?dbUwJcIBx05rOsGvWetFQpTJ8wjbfG52l/dZNvw4GYJOaZytg0TrKWx+aHBY?=
 =?us-ascii?Q?QSyniJ6JDmwApy9meNbyzmQHfCSWLQsXmESsjE5TXomJh965G7aiedHiCzLS?=
 =?us-ascii?Q?KcHS9DLXSPeOoI4oMCpNzEfiK0B1BFJOGzBe+MLzf2EnzNbldb9YVcocBBsq?=
 =?us-ascii?Q?cLpqdgStdwGiii+hrtYY7/GYwsniZ8lE2uUjrKYf0tKSmmYSmcXg+P4Bx3/U?=
 =?us-ascii?Q?jwm/Ry0pJYSzmhR1J6g9vkRVz3nOQj88noo+9i5ODj7XI0FA8Z+zv1qpSWEh?=
 =?us-ascii?Q?fTLspsg6/okuzWfmz+2L2z6mkfzKmYTjiqDibpFKQqDmQ5kULDzowbUujfbN?=
 =?us-ascii?Q?dsaan6QzJHTk1MJGsC3sn9aXI5vijSgHIBId/c2GLyL7i0BgqKf3iozyL+06?=
 =?us-ascii?Q?+hstRLp0Sk/Yk/kR1aXyOLFpYgjjEcRzjq4xQkN++QPI7h06qQuBoC2SjXOk?=
 =?us-ascii?Q?hVrD1goUaxmaGnTngKZW6so9W5bDkMy5yHphKZ5VXIezMXgz+cRoXxVEszwf?=
 =?us-ascii?Q?ttykiR+/PFMND1Cjhp+i2Q090sckqrtrE6hvRPaAwGpJv8nBV+lFhAjrObwk?=
 =?us-ascii?Q?z987ZNDaD+NHfl4EPRdwiLs3O+0K+x5CQIDukN4ay2wp7LG8aOJ0Jg2Bf7C4?=
 =?us-ascii?Q?tCHpFkKkq9MLFejNsvW8zIddQnQSBO4twugzxepbiJxj6XRSF+w5vxR5Jsge?=
 =?us-ascii?Q?XH+hPUzF443AEwQDvu++7/mGAyuy095WTzxzxzCQxvZf8a6R7bRfBapzL123?=
 =?us-ascii?Q?P4xQYr1Y0t356CV/MYnwiUaUAeQ6mVSErFvqeKp4o60OZe+ODhyurelPuwsK?=
 =?us-ascii?Q?MnAYSueEPnUruDNGQJdXZPF8lpqdtaAny0ZJlCqzxwVdrIfbUMkHSGaafX/W?=
 =?us-ascii?Q?MC6eHS7elMxt3J7tGtyf97og?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 769fbde1-8886-4fb0-5e81-08d8cd801976
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 04:55:34.1769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Qcj26UlNhQk1n0PZNjD51bNQf1VxH6+jnpmwsgOhEdUG2P+BMa4M8MytjoFd8cNzGP8hK1cfsrOQra9qzoH5vYCFhLbMnVTeCSYJ3gz0FQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3366
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9890 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a couple holes in the cmd flags definitions. This cleans
up the definitions to fix that and make it easier to read.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/target/target_core_base.h | 38 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 815de4c97230..5e6703ca102d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -127,25 +127,25 @@ enum transport_state_table {
 
 /* Used for struct se_cmd->se_cmd_flags */
 enum se_cmd_flags_table {
-	SCF_SUPPORTED_SAM_OPCODE	= 0x00000001,
-	SCF_TRANSPORT_TASK_SENSE	= 0x00000002,
-	SCF_EMULATED_TASK_SENSE		= 0x00000004,
-	SCF_SCSI_DATA_CDB		= 0x00000008,
-	SCF_SCSI_TMR_CDB		= 0x00000010,
-	SCF_FUA				= 0x00000080,
-	SCF_SE_LUN_CMD			= 0x00000100,
-	SCF_BIDI			= 0x00000400,
-	SCF_SENT_CHECK_CONDITION	= 0x00000800,
-	SCF_OVERFLOW_BIT		= 0x00001000,
-	SCF_UNDERFLOW_BIT		= 0x00002000,
-	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
-	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
-	SCF_COMPARE_AND_WRITE		= 0x00080000,
-	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
-	SCF_ACK_KREF			= 0x00400000,
-	SCF_USE_CPUID			= 0x00800000,
-	SCF_TASK_ATTR_SET		= 0x01000000,
-	SCF_TREAT_READ_AS_NORMAL	= 0x02000000,
+	SCF_SUPPORTED_SAM_OPCODE		= (1 << 0),
+	SCF_TRANSPORT_TASK_SENSE		= (1 << 1),
+	SCF_EMULATED_TASK_SENSE			= (1 << 2),
+	SCF_SCSI_DATA_CDB			= (1 << 3),
+	SCF_SCSI_TMR_CDB			= (1 << 4),
+	SCF_FUA					= (1 << 5),
+	SCF_SE_LUN_CMD				= (1 << 6),
+	SCF_BIDI				= (1 << 7),
+	SCF_SENT_CHECK_CONDITION		= (1 << 8),
+	SCF_OVERFLOW_BIT			= (1 << 9),
+	SCF_UNDERFLOW_BIT			= (1 << 10),
+	SCF_ALUA_NON_OPTIMIZED			= (1 << 11),
+	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC	= (1 << 12),
+	SCF_COMPARE_AND_WRITE			= (1 << 13),
+	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC	= (1 << 14),
+	SCF_ACK_KREF				= (1 << 15),
+	SCF_USE_CPUID				= (1 << 16),
+	SCF_TASK_ATTR_SET			= (1 << 17),
+	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
 };
 
 /*
-- 
2.25.1

