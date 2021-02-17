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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0996BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D142A64E42
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbhBQUfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:35:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235077AbhBQUbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:31:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKSusM122843;
        Wed, 17 Feb 2021 20:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=E9Wvj0H2DHQ+uysGDfmPsFtvTmQoayJyUcuQ5991k3g=;
 b=cBwv51frPbTnrA/ZyLyq3UrXZg4EMD4IxYPEEuDfc2JyyihONBKazvFKWm1VafFEDZLO
 3aLHCDz8JGLVtlvdjr8eYDG0J4H3f/dVEVmfVoLQW4bTisMDQQ+RSEqY5XBkwgmRcmZC
 9cIe+r3CI7Blm8sF1uqtIHlmC8h33lRtrUFj9zMVJXvDMyexeMPwWPuor/5cqcKXdJ2h
 BPM8kU9GVgX79Z+Bflu/LiYk2P/BsiE4R2x6dVKR8BXwn+oEPeVDSbxAxXmVeaYTnXxU
 lXvgAs251+azTB3aj7XUPcz/mvQsiOXTB/lIzEywCZjVtsD/11gjbIWgct6aD3XgV8Fu VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36p66r3sae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQDHk191745;
        Wed, 17 Feb 2021 20:29:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3020.oracle.com with ESMTP id 36prp0p6g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:29:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjiTFmbZSfTodzMNvg+9T1gnwaETrW36D8sDkv4AOGMZbzExLNnLSMfcgXJOIwT998CcDkHTeQmw1FVkXQSD35B/snHvvt14hq956ZIn+E/lhUbheQP6O78alaVYsnqtVB4wTw/vtQ/sCiXJVbCkUttuuNxriQ+FC+LdLKcpEG13Y7svold3oM7VtgUgYYfQ+2sTsVGoTywZtXLFdHosHkMF+IW7Nz6jBPhP1mAilbV6fpJG/FuwKT5aA41Zb+FKHiGeBxFxbx6+x9sPkG8ww2+8CBCpiFFvAz1ccnsyBfudXcBd2VHQo4DtFWapUvUDsUukiQKjXOaeTkndMuOpWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9Wvj0H2DHQ+uysGDfmPsFtvTmQoayJyUcuQ5991k3g=;
 b=QRP1a6oNJBTI/APSpF5wg7uIaoy3gOxGeHeQfuLh2XPbj1C6BucM6d4zGITAsspHlbMODHl9GFMDPNUhudynFmfg55s0mdqC0PFHyKzE2lfuzC02bj3aA317i9HMFvSPG9hNLeU8c58hm5bxTjp7GQQgc8GP5i9TM8B//l1LW2EsurRLminWcyzLnyZuAVo8itUGhQ6LL9LqZueRCgZkNLnDLEamvFct2tSK+uYEeHhtxRhyveTWH8aYixbdxpwTNtml07/6bZndV4aG4y0cBAZBN21Ch+B5w6LiTMBG4m7RpiGmokwla1mkstBhFc+2qgWQgc3jdRrHsaikn/fUWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9Wvj0H2DHQ+uysGDfmPsFtvTmQoayJyUcuQ5991k3g=;
 b=h98uM/zuHfd6o2SislanQqW0L/0JiL9haf1oU6vRxpPSKUFsdCNT1iHYe11tdJ5V8tlbmbmS1HRh8xuIIRC6VQzFJtf3dskL2iN1BBpYRXqxmmf41xoODsFUMqWxM3bEZmSWZxm8XFemRktoHS7N8TG1Py5Pcd4C8G1PNSIrqac=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3940.namprd10.prod.outlook.com (2603:10b6:a03:1f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 20:28:59 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 20/25] target: cleanup cmd flag bits
Date:   Wed, 17 Feb 2021 14:28:06 -0600
Message-Id: <20210217202811.5575-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06fc5207-f442-441f-f8f0-08d8d382a7b1
X-MS-TrafficTypeDiagnostic: BY5PR10MB3940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB394002D6428337C82F58971DF1869@BY5PR10MB3940.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpJKhRT1gSGvQkaopZpcXbAvvekuWQhaLRlefB7Xs2YUuMRjQGILArmDpasU1qQnXOlRyNEGEVIO6Tnm3pefz8gAs1b1o9Cb9s1o8Vv8zbFqrXIvp1R1P+b2KPGl+ma5RjTsq2SeAgsa064FUSEZSytF1CTHMD77RzW2zL+S0QH/04zdztTSRXdPgZXw4QXHEZYw3swrqOTJ+nNk5YKNKVC2kRDXKPr622EtP+Ox17CKNDzhNpvsE96M3UXhkE2g8it1Nicoq0GSCyTkir198qoLsHRaxw/Bh/ORdqaEm+e+GPFKgOC5pcAuaGQWm+UBDd0kgXYGb5n9xSlP5ZzWNyA06bMlVnn6NookEmPaJkXncIC3N3uSw1zpb86AcuYq/oTkKI+KVf1u/cq7Q85cTbF51fX7q7xq3E/JHJ8s5uHcmTCDowMw/831sGvCIADQOEjuoAPF3HtqmOaJqK2OKkg8MeXYZkwNYzVG7oE6K6a+QT8PP0lkToYUY0wGOsCjgqdoqEkkBqo4jk+7u2UcFwqbH5e/I6fNtKdMVExyCOr+xOFuWdBJkF3zM7Zaw6sxPXWNZcnipI5Uh4hQ3WQVKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(2906002)(6486002)(956004)(86362001)(478600001)(1076003)(54906003)(69590400012)(52116002)(316002)(6512007)(4326008)(8676002)(83380400001)(66476007)(6666004)(6506007)(8936002)(66946007)(66556008)(2616005)(36756003)(5660300002)(26005)(186003)(16526019)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SLs7TimWMI8HzS2qik0erdZypOMNBCsSLDYjSgyS45bCqIVLm5fEYZOJ3Gio?=
 =?us-ascii?Q?6UbhwVq+CkN0UzRHEtDdvcSj96bpvzpFWXuCcCmaabnzC6fN0KgygMJhBlxS?=
 =?us-ascii?Q?h8F7BSBp9Fey0Ue3aFA5jiQ7Lc8qjR6utubcL9au6iJ6bNvgaDByA5BAguFR?=
 =?us-ascii?Q?JJqJtrKP/MxrFt/qBk16K0Kt5K1h/AGScyH2rsrU2CCUh+UrUVNEpChHip1i?=
 =?us-ascii?Q?EtNpEg+ZKN58ch2vHA5eo6zszbRC4mkeQfCwRG7TWmotdCYei7MPK7R1H/yL?=
 =?us-ascii?Q?ZDakX8ydNGQIy9yAKJO9frZMT/l2hziFSQKUq+1/h+gzKrvVkOqdWW4mAbsf?=
 =?us-ascii?Q?dgiGHdaBm2VXmlqv+xlqI5/Z4toThZ1GDo8bkoLS2TrRw0ST3Lquab7ER/gz?=
 =?us-ascii?Q?798oCqSFy50wQw1Kg79VP5nohy7xHMe6RqalJ948bMAPpKdhKpUVdfzLB0n5?=
 =?us-ascii?Q?P4OKF8Nshjn5fJcn0CbouJEx6wp++YpUU6EozAEyTHmzAenzFB2EDg+F5bGk?=
 =?us-ascii?Q?HDV4icWzTI1f+UcGxbwBasuINaDkPaIKPQ+uDrmHmYNvDadbIsW88rzxppBu?=
 =?us-ascii?Q?hRk2npWQo3rNId8L3f35e+BNwEO9jYs8IAFMibsmNhCFJvI2sx4KdWI8UTr4?=
 =?us-ascii?Q?WaO17wmWJneaNxaUKPTdqRPcUzG6d8QB9XNU4xnHz/YIO7dWPI+R7PtEH9/u?=
 =?us-ascii?Q?gSimlRWHC6HuHxWsCKKyHo0e7hO67jVRQeMRHABwE8hWfgRMh3Xrh+0Z3ocQ?=
 =?us-ascii?Q?iNJMfBrJ9yFcTK7LLP7QhD4pdLdPrzC9ELW3yOLBGrWhFcPQcWAWBmigf2Lt?=
 =?us-ascii?Q?34QjQ3JqFehoLBpDkyV85Hm94viY4ccz/utkAaQJz9yloAKfajaRDKplCCar?=
 =?us-ascii?Q?ASQ/iOkJpZbdjRAcASH3x9i/wCr62O0UP+hn9Y6vhyn6+7iB4GWbPf0kmN2A?=
 =?us-ascii?Q?NyBR9C4VTdducYrFAUd85amWxG9WDIcXthGwhXH/Xib9HdJ9dtbLwHLA5F5F?=
 =?us-ascii?Q?foETsvq6YBSlc4SuCAUFOLwxC46FiIST8+0sqYnmxeQQ+j47LNr8kvArtVQH?=
 =?us-ascii?Q?5QHjWNDPSvC7RgGTnX4zL7E4HL7EKJEfUfjikJZtmKou2Cl6nfCsDVT+vSMX?=
 =?us-ascii?Q?zGkOhz475CfeTnXC8qGksgcRSD7htMcAr0G0/cYlg602ebAdbGYdtr4wlKUb?=
 =?us-ascii?Q?dWQosLY054y4BFtXtH+j0dU0XcOD/I5Me5xu9SXtVaQN7iGPnIhN02asvZaF?=
 =?us-ascii?Q?/hC+kGUzF5BFAjoXVKf99WhcBqn6qsRWh8T4RgqdQWtNnGP5JO6/ujQWY7GL?=
 =?us-ascii?Q?Cde7GjZmgXW/UFQ+CdI56Xfw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06fc5207-f442-441f-f8f0-08d8d382a7b1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:58.8891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOnHSWsRBgwDED8k1ASw0h9FtYMOlFQfQxEh0R+WewSTMTJ+5u/GpNxnkXAIk8L4Q3eXtsowmCyqj5xqizdLazzogQXg4AvRwKWvr8syopI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3940
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170153
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a couple holes in the cmd flags definitions. This cleans
up the definitions to fix that and make it easier to read.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

