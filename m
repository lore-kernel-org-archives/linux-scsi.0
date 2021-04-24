Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365FAC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5CBF61422
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhDXWHB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhDXWHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6FBp124433;
        Sat, 24 Apr 2021 22:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=tJ6uM4BFrsSwFNEsTWAAsnV9ilgB1bwaaAnec4lzKStzpKb78uHF+PHZGrH/6lSGuo2h
 bKWOTJYS8HjVMtRiYhSiwH/t0FxHJkJz2YcksolV/709vzmvK7aL/nSK3vwMMnkjVYNp
 PdQ/gxzZJ6HwPzPymTShDbjT76GJJg3D/25V5l4P7rBRJZYPwIVx6h+e2vrt1SJ2jbtP
 NCoOO8heEn+B0tSZ4AmXFFyF8I4ezBvTnvgcCXZrWCSSibeydW0fD2xwHLxzxlgNVgUq
 e7kC8BXqCU4xZ1mzwrRkBAM3/RAyIO7YEBGHaJ5u+W0OE7LC0K5RWUfnlLx6VMesReqk 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 384b9n0shg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM5Yev053539;
        Sat, 24 Apr 2021 22:06:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 384b51tykw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2VSIsZTvVq1vNNlQQK1cXxGTeWOQsMxkh+Ix5Ud4LEcEbyI5k7xoe4BuGeKk08nC0OVDTpzHh324PhpDAPi3Cpyet08h7+W8rDRDTbGgTxyLHlDH4uRLHH6uNsWdvb9SfoGaoiG6Ksv2UwbzaQvOQJEXg2PJCEL6RrrvaQ/bdsKVsxCoOjJ39ZtNYpv2iUKuX9ye7LuOVLTpYP67WRj4/Ig4tmI5j5+i+/2cRCNw2R+KPUiUHbAPXnZiSDvkxqWfB3D+sSEuSzaRx8uX2AzeZx/xBI0kPLqTvXYPhTY2BaPYhzyKm1HmPySxRp0OsX/lN0N1vnnc5baUAyOPKugWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=gM5CT1dUng8eGyFf7VN4yExrwUbKD2jwtioRxG3YW7WGZXQUZX7sVBloXW5yR24HjEaRt7542k/4w7LXo9zDvHFZHpQPqtoVG8vqXpc2yTSwGPdOxiplc1FvbrxKneBK5AOlioSctO75P3JNDWQrtwnNyPuTszCVLm2UHH2FySOeKgxzr09xk47y9WW62Qu09O9TSnKRJcPMb7+Uq+3+ZUduena+wk08EHEtHKyrYuJ4B/rliLNWFOxyWMx0QSl/gU6wGeFN6TDDjfE2JwE058A2X182nAQ6gFQo6PvI0Gks3JPma7zU0nksClWmyPAEikdr86I5D/OxytchbYD8Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36nlTOlTLMTxpspKVCPpHxZS/J4B44QEijTKxwhPzsU=;
 b=ljZXJzGiLIJCqKIbe+cCv85KTuJ/zg51YXzIV0/M+X4Ygn1Gyz+L5iaeU0gs6SVZ8wBMscxl1CJMK4Szt5wJRaCU2bi0cZQ4kDoiDs0sVlpBRSZCGjG8v2ULxV+DPbCjGa4wVAT4ZAbKA6n2S2ahr9Sbk/6TlE3I8CNU3oo4BmY=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:13 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 01/17] scsi: iscsi: add task completion helper
Date:   Sat, 24 Apr 2021 17:05:47 -0500
Message-Id: <20210424220603.123703-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 896691f6-a908-437c-eb91-08d9076d2cc1
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317E99E4A59C5572B8B05E1F1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPulxCi/RCZayH6aeYGPUwZTPpsXLbDjFxEChsY2onqGznU2+27b6CdECFxmFpmGHDSJT32BMAdU2I8jGDmHiozJgOlXJgP533aTjkNN9Aj6Xiy3rpx4DEFMI8+DqBF+3zW/Ypx1ZlWdUUQKfP12jqHqgyWRDrZGqAnBnnZ4ph4wzJ4YUsdif1o0+E6aYemMCaZ1OARCe692OWkEyGEnT5bdMPicTR8/Zuowbo5FYe24BQFtu1isos+Bgz1yp59kLieOAH8rmZpLkSn30Q61fyQx0wFdpSIrTKjgov27095Fafb9VCxrKJNa8yF/uMl4XBTovHv4YpP/tCCW9xv4IeQsK1ET/YvERZ/ZfGO95fhfSc0FfWknP9qmRkeSsvJTJik79bQ4PVINkStsz3Zt8RZC8humxHX0xYfWo1pDXGfz1yq0vgmRyJ3pPICPRZkIxzFQSIaEcqEKN7P3HAtkFgp3P+xUanTxRuLuiSi6OVzrEr0ghoFlCgbzCy9gl2G3rIAwdXox3h1TXxi9CDm17pCCYhCekWSiPReDxMLYlkWYSklhbg20HAbhayUKJrYLq3kDTCuFq9t1ZgrnJVPdnqLMtLskwiFXzCi3kl70S3GB+jcT3+AHL8imU3heRmBP3l2uNz4XtahUK65usp60+CGZUdH8gGzQCpahEra9MTH0J+2CqRZqNsaagXsuUM55
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(4744005)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DQ7wCY9YC3EdTq7DfZPKqz/K4gQCTtv9/m17vcxVtuf23vVz7yEBcjwSvaVv?=
 =?us-ascii?Q?TcntqDO1/KIaMo9Eaim/hWnCaYuzikOJjfFCifB1pcWso1tLMcUxmQnYuWih?=
 =?us-ascii?Q?nxHJatNBlC0mU+lakQb8UjpxHFA33fGMsLJaYd8Q4BVWamv+HsQJ+dDJjEM6?=
 =?us-ascii?Q?qmqSCgMB6e8KF05GfIOIkPBfnwfM4qX9niGJJft7cBqAX3uo/u26HKr/Pchj?=
 =?us-ascii?Q?ZZXxIyrSKqmGzSeYUwnL3D3W4nWs+A4najaeMpjdgGFOYqB9L0xLPxxHIJCB?=
 =?us-ascii?Q?BRJ4qB2Ir/5qsWzTU9xwoOqq8ugdR92ATaPaJkBpF1vY5siOzFyalhLUtCjM?=
 =?us-ascii?Q?hDLZSAGaNlAGUHjdNcLvyvpivOxHuKTEFNmjKJl6CfDZdi0kEugZmAMlbXyJ?=
 =?us-ascii?Q?X6f7fTRfChpLmB7hucivkqAwRo7jd7dxMFFkBR6Yts6kTJKO0AVMroyX0FLO?=
 =?us-ascii?Q?pDiJTtHGOZZEvtqhN3bfmc1MNEMBTM/ObUeBZOduEOpNXBhT/QqKzBHIC1+t?=
 =?us-ascii?Q?v4azduPGPBBJlQhSS0WyMkW9DMEWyexoMAjTpNyzjd/TFgv6qy7PqUpTXKy8?=
 =?us-ascii?Q?ePEV47GVDnR+UW7TZkn6xatpXLKGjz94qGD3UbFNrxeqfVXf/JqYSPwXqGZH?=
 =?us-ascii?Q?ylPx7PPMGs3vwETTqpFxUnxtNQrwnvwXbPfDS38hu8qD6MqQq+duzVu8Q9E8?=
 =?us-ascii?Q?JZ0DOaPp+hjXe/WRTjwbyfByazoMywePQw8pG9wk0szfidu/y5MQjmyTwooH?=
 =?us-ascii?Q?MZu3Y3CGMxq8l6+z0u5/PJ83yKWgl90bI4Ta38QYAe7GyjIKhTiHJbnBgeK3?=
 =?us-ascii?Q?rh9BMW+7lxJ7bqfyxlcDLW5aWZv+7M+9NlfYqyZLGg9lld5eyliFWoQ4VLvR?=
 =?us-ascii?Q?fXwvaHl8afN56CDGEKx7E1ybP/ayAwS9tLYMVPFdhYXpGGVDmKNQTE5+VNxu?=
 =?us-ascii?Q?qLlvdWy9U7HX7oextfSxPGoeCetLXBVkTkjvOVkFGrAQ4q74cuSymcqod7Gf?=
 =?us-ascii?Q?oiE6im0LjmJLnAlTV6BVWReDebqfS9LenO3TXsfanuu+C9UpkS75JsFh1ebt?=
 =?us-ascii?Q?Kp/htWbWXL3TEr1MNnqQbxN7TmzQMFGV6yjb3lSSfu2jC+D3Z3gnOFwTMDBg?=
 =?us-ascii?Q?nDru3qlW9kRZaD8Tm2/comBXP/CLIFrSLr6s7OrXzHF3410W3VT67KwTHV1Y?=
 =?us-ascii?Q?VMnXg7W17gBvFEGQccI0tzzrDdi/kDqdwGOq2BWErvWxCBfBEMRvg3rCNout?=
 =?us-ascii?Q?93rCY/KOUysfntqeoXTDy1FSaE/ZOlVLkBHkltLoa5vjH8yXibve+A4wDpAw?=
 =?us-ascii?Q?c+utQm8UCYpYQwGXI6G7W9xt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896691f6-a908-437c-eb91-08d9076d2cc1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:13.5850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GeZEDLYYyptR4wjWu7lyJJ8aPn6Vc/6Oc27yKKUFH/XGjOxYex00P1nJU81dTXrhSKWVmfcPTpl48Q8ksxE4QMXLzjYTxyMQOBOC03TAIfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: VR91zMDsZPy3UyQy0yIlUbuyje8H2hN0
X-Proofpoint-GUID: VR91zMDsZPy3UyQy0yIlUbuyje8H2hN0
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds a helper to detect if a cmd has completed but not yet freed.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/libiscsi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..8c6d358a8abc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -145,6 +145,13 @@ static inline void* iscsi_next_hdr(struct iscsi_task *task)
 	return (void*)task->hdr + task->hdr_len;
 }
 
+static inline bool iscsi_task_is_completed(struct iscsi_task *task)
+{
+	return task->state == ISCSI_TASK_COMPLETED ||
+	       task->state == ISCSI_TASK_ABRT_TMF ||
+	       task->state == ISCSI_TASK_ABRT_SESS_RECOV;
+}
+
 /* Connection's states */
 enum {
 	ISCSI_CONN_INITIAL_STAGE,
-- 
2.25.1

