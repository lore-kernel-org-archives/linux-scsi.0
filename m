Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B9DC04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56F76600EF
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 21:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhEUVDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 17:03:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhEUVDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 17:03:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKxRFg022836;
        Fri, 21 May 2021 21:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=agLe+3RBYQrGAEVBZ8sX7xOznIt1XGH0d4K9YEeEfOg=;
 b=A4sh3G01rxMF2hUSazYSVgJgPpFlWp4JUS1CCM5LRLmzyOZppJLZqHicP4mPdOYTu2ev
 03ksgEL6S/pwmGEyYwxcQKP4/GUBzYnR4rqveDNKwT5YrEHrQNkxPM3Qzxh9FGm9mJxp
 U/flNQmLPuS5wYIMkcbW3j9ItAYk3nyRhTsrXJQpQY19VwyKkXYB1s86s3og5uB0DLca
 Qt14lPBKYHwx7lB4StNjrK0oU9U/bZRx6qS3A1U8/4X/5tfsLPt3VhpdJ+9Lyx6+kdVk
 mlzIzMp5/JWrDkYhAx/oHs5Hx0xgZJhD1m26rK3yB04XLoBYlVvx1x5eZtkcduGq1sSg 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38j5qrgrs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:01:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LL0iBO098339;
        Fri, 21 May 2021 21:01:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by aserp3020.oracle.com with ESMTP id 38nry3tcy8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 21:01:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuC5DBby6YYcEjxaTKQvcAqy2AWfm78sClfoshFt/csY9FcwZ6SB/HyF4+UJr37RS5+GZ5h1+wy5ukxSJi7EXGsowjXvH3VPCr1YtciqtW9Y7oF807wmJlMfSInI/lJeXlM3X0BW0i9NHhfGX4tAItinJrd1aZzJt8tWD0zAAuuWLwOj1K497xJwRMRpSMhq2+oAhNuJsmcrbynfV7MAXs383gcrkKhJVJBZvn4BQ9SR3uwOw/SiPBMZcRSUGTc2q6OovHUtrx0aFSqc8pPlA3qf3XpzwZ/HKnNFaVF/bkJl848POijdYgCIM9eZBsfWSfe6Mlrme1J6oskLTm0SMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agLe+3RBYQrGAEVBZ8sX7xOznIt1XGH0d4K9YEeEfOg=;
 b=eHTjc2vxksN1e9d5zJo3ElMkpokj9RGskaxtu00I/nfWupaSoaOQ07tIuYJESvTVtrrcyMIbC/IXX+wr+LZSU77dKm2IgCYUCsk7m+vlS9hg5O3VM4K758M305F+xH7u7CUCeYtoCNBjFl1rAaYZVO7yoWrSy3R7qBqhaFTMofPEYi2twnTBZDyhRL55PQHbsQCyYh5sC02LXmwAYSo2YE7Yk14d8wEz49C+ovbhnNOFpAybVjxUVx8GKfNZgZSRlU0moMi3b121u9GXf4oaVOtsc+11PsChphrSHKfCf0rBmp/3b9g/JEYX0XtOWgxp+UdwZ+B/HKcL/L8kGHaM0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=agLe+3RBYQrGAEVBZ8sX7xOznIt1XGH0d4K9YEeEfOg=;
 b=adDjFFoA/z2wlXJvJoDwHAELj5H0Hld7hYVXO4N5ilWPbLxNSp4vCz93TYBbHYCZfrmw5JHtCkRnx798nGVNrQ8Fb7YIixL1o8xIKInYNaKjhVnJKOpDf3omvbbfkWehJkfPvdr+iH9653EuqZgbnP6fw9QgIhZt5hEZfEWzup8=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4550.namprd10.prod.outlook.com (2603:10b6:510:34::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 21:01:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 21:01:31 +0000
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: Fix inconsistent indenting
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bl933iot.fsf@ca-mkp.ca.oracle.com>
References: <1621590368-72041-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Fri, 21 May 2021 17:01:27 -0400
In-Reply-To: <1621590368-72041-1-git-send-email-jiapeng.chong@linux.alibaba.com>
        (Jiapeng Chong's message of "Fri, 21 May 2021 17:46:08 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0060.namprd12.prod.outlook.com
 (2603:10b6:802:20::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0060.namprd12.prod.outlook.com (2603:10b6:802:20::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 21:01:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 055f96c7-3869-4d9c-0444-08d91c9b9bf9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB455063205AF580A6D562ACE98E299@PH0PR10MB4550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RBeos8+KH/WV5/BFh3YmmIJGbS8w52BWMHtTXmaGC/bar60BSmoHjytlsYkfYy2Jfn4t+K8tkTMkE0NHIFdbrBtoeV8HaN3xojME70YevjVyYq0yDhoIeEV15mSOWHJGPGt3wLv1sCg9fS4WG7llcDxOxhn1mrrgPodR26+YdbAsquslTjysJSYmhZBtQBQBghPU2S59/D43fpBmmP3WwC5Iwt3A17N8Ov5hIurRrlenDtKUWGe/Eyv6fac/rBror79/6Bj9wgA9V9p/649PQxqEDO7lB7fIK8/F7n4BwtACtXBlAA4EYVAJOoEtn5qeR9Oi6DfuH+o8P6+8vNrV2wrm5kGkmKi5GRZreWBSy9W+5qO2BiV4Xbo72/+yZvRgMn3dzAgMxY8/gznGAB44x4svjHx0OkZHr+kPiWvOY6eZwhYd9chij2Z9cThR+dIhDf+Dw9CGZokBt2whGflkWQtdQXfOhXcflrfpZDhtnsykgoOQ9GeDNkqzvEC7ob9Nb3WbZeC1WRCxEyimR/ehLG0/GpnDvytKVw7DTn/xCKUEsM+iVC+/Et+KM8fq2f8Eim0Ycy3/Bsor3T6OpWVUGCjGyx5w0ukHHoCnbpjn53s4hIP0IlsTznsf/VQp5dUCgotL4ERH6g1jKQdMTmELHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(396003)(346002)(316002)(16526019)(186003)(66556008)(8936002)(8676002)(66946007)(66476007)(4326008)(52116002)(83380400001)(2906002)(86362001)(36916002)(55016002)(6916009)(7696005)(956004)(6666004)(558084003)(5660300002)(38100700002)(26005)(478600001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6XIPPWgrBID/mou8B56eCQaEIG6MsePMOowxKolO5VQSZ7OPS3BRMvowfbDb?=
 =?us-ascii?Q?035BDwlYQxlvpzYGVvN43mkvSGLrplKcg82AdDr8aGetgu4zVPNin7/7gsfk?=
 =?us-ascii?Q?PxKR6ufXRBCGd7W8W0MWIqru6NpAhx0q7MTeFUiI6YLYM86eItslM4GlEcM+?=
 =?us-ascii?Q?EKNruI06sgjBV0D/SQ6f0ZEB8DMBQFPTaoPJQq2aouwDGwsCkSes58CxuHmh?=
 =?us-ascii?Q?ymqDAREjcW3iNbb3Np8gEYJJO00McY8zLgeGT7Doev+27428kaJ3NejUUDpR?=
 =?us-ascii?Q?wpjpOS7eRHsbI9DNesyFOnzuikhukHjsdoRWWj3M1e48krr/Np21jhjdDarJ?=
 =?us-ascii?Q?6uDp9R3ToOg8n/ObQD3obdLoqoOaf3k1C7FbDcaL0nX/3ZRSVSijnLEi+kWg?=
 =?us-ascii?Q?vYam7KR6Obx5o/uT+FZ8RE71NUkZ6ZDP/BQoj5Vkc/r0dvtr5JE+ymwVMd+K?=
 =?us-ascii?Q?9lqLOMbTdpTr91qLcKLA7H9Kw9ycgpWCsBUvNSiNPX95Dkt/sPxWZNYseses?=
 =?us-ascii?Q?LLSHcxMX4XKOS8cPQktfMGy6x44mYGu6TQh99/ZUQZ+PI1k1bBwT7I4VfQQb?=
 =?us-ascii?Q?ivyVDAvz4R1g8/YfEmLSfxK3uQF6IniSQ0K4kJ6MZlgW4pqax+fhi9AxJUIa?=
 =?us-ascii?Q?i2Sdq7m4+dgNXkAdGRC2lS7xRn9CctgmlNCqoGdpletk7q5mu94TMcR87Orr?=
 =?us-ascii?Q?VC7a6dhh49qGNd6PqMgJlciSJk/6o/pS6d9DoAXGd5TqTbWKIlJf52S1TB6H?=
 =?us-ascii?Q?dA/XkCDIkIbjGgB2cDuV4a0sMXaa2yOXXvjJ25KNp24FPIuaGTJtDlzSwNQH?=
 =?us-ascii?Q?m8JwRLvuq6YLASuhdrZ+cqOHnw7MZ05v1prTLuj1JMEaPfwjoYFC98Ngle12?=
 =?us-ascii?Q?PhleQamVCntMl8DIUOfhHNdDdDCHXDB6kbaQFVyJFoyVBp+XM8OM1HuaLrcL?=
 =?us-ascii?Q?frl3DQdJtlZtoQsQNV77PZP3iD1x0swi3kotb+yjLvtfRteGRmmGn9CWpWUV?=
 =?us-ascii?Q?3JvMp3Ihes57jNFEu1TRakpoS7xblnA4vP4zhqEQ7duV6bBWL4tPJZ9sEmbo?=
 =?us-ascii?Q?FlCXRbWSTL2rEOMKYELhoRXXa5RFvDu2QmIn18VXYcMGfJNZCdv1+ZEHijQI?=
 =?us-ascii?Q?yQTDOiQtFd9jPzFt3yhFVFZpGC4EpXkMIHFzi0mftypx0LJqQqbSyYhlGorQ?=
 =?us-ascii?Q?7QQiO91g2EPNrBzV4xG1tUSvRumhf11kFi2gyy1dxIi1ZdsTjSatkirVNUve?=
 =?us-ascii?Q?CU/tpKVN6IY/Ptvctf0XZKO2fGP67jK4yNFka3E97nsAfWWslKNbsjoWjmys?=
 =?us-ascii?Q?x/Ba6G/W1z/XB9t7J66dUPTD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055f96c7-3869-4d9c-0444-08d91c9b9bf9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 21:01:31.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7s5hjBsS0UlgrkjlnjnbSQMicKbMW1x9XzyszX+jPcm/DbNDFQsBTbHXA2AG1Yxt6cvjTFHwrirTSb9OOz8RbWtuOgisgRmmLX3d14qKfGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4550
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=896 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210114
X-Proofpoint-GUID: HcnGK00xUbEnYrAUnPl-_gOGbPJ9aHpe
X-Proofpoint-ORIG-GUID: HcnGK00xUbEnYrAUnPl-_gOGbPJ9aHpe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> Eliminate the follow smatch warning:
>
> drivers/scsi/bfa/bfa_svc.c:3176 bfa_fcport_send_enable() warn:
> inconsistent indenting.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
