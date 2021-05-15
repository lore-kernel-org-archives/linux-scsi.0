Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488F6C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215AE61177
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhEODLe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:11:34 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60078 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhEODLd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:11:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F30vHH140354;
        Sat, 15 May 2021 03:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=u4c2gFZtGFjL5m3FohriqLRo4Cx1wxKdO1e4xS7KowA=;
 b=qqAt32EVdAuzTi97bEOfS37bxs6wgjIBZthCxmK3v4vj3V06HjXx/SWolc14A5sQTMM3
 FUq2DvPdg7l1/HES/UqI64PldPEc+EmjTfr4zFebnwX6XgnJCtSkE0+7BIgBhcYN6+2s
 Ax8323+qyzH2H1ZS/pxnlPguEWimbGbuwzXamkFFW0T0N7Gs/LwDr18hoHYGMXGfClkZ
 3tXJJnGUzSj6s714OCaDaqqvNiHYDQqQ2mYJb8n4NmnM64KWm9T+EF1ITOl/H7Ad6I4H
 LDqrmtcJe2adN+d8dxnU8DlU+4WSs1ONXn5L0KkdjAT/HI0sztp19Pqlc3eLeWr+hHuU 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38j3tb830m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:09:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F36CVL028961;
        Sat, 15 May 2021 03:09:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3030.oracle.com with ESMTP id 38j4b9hkes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:09:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyyBKqnUyeDqkXsas1VKClP/rRfaVmr/R8n6Ber7LeiylcT9Z4XeKbDm0Ji82x+MGSJAaZlltmBDDUDh1ZZWvLPrKv7Ei97zQuEnF8vckJts4gxWfBYPbOLvP5HJo5v/4llTYShw4MI/XGUM1pNL3Er8I/ah3tcb8xzeu/ijRQgPM/N9yPwliJeUxuwX5s1cTUyOqvDItfC1+E0dC1isHju5P8ZJaUukcSCR/hH443IpHS4eArlDtgP7RWbJuxXZfJFVMQrUgrmOUc1vH8ox2QG72NTX5N+6ZVLMTlq7FQBDZ+srR1b0R48JP8DSan14sMq9HkFf+dpPcqgjkQp1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4c2gFZtGFjL5m3FohriqLRo4Cx1wxKdO1e4xS7KowA=;
 b=am5M2pIl80H9jiPQ0nSZ3jVnB9ExwUeedSpT+YLPSMwYUhQpg2RLw/bJn6mnuTvpp1u5XrbxCZk5W/7Xln1CXLZahReBt9qrdkT9mfiIfs56YxJ8djwMVztUYO1/bBb5e2cXMHpAz85z0ESD6lLgB76LNk35XZQVJcc7NiHDhm8UMTs3JtsuTnpMju2zyjO3vfRbVvlzq3P4E8kZNvYFxaRnMAO1jxH3kkA8qGrQSfSQq9sMEINBJGbvtc8OQpQvcEoiZwti3VL0r5xUvCV0FGjPgb6XiT7rIXuVJ0dx0OY1mYFhSnlyRAiSkKwJhRjMVYD4CkSALMKs0ilbnRgDtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4c2gFZtGFjL5m3FohriqLRo4Cx1wxKdO1e4xS7KowA=;
 b=BYsKQmnEM1LcNWjUb5F3QOxxTzjo8exomuPwR0yZYP4jXQzTEihqvvLhIka6J5LZ+DLi5TOmnrXTcQSgMtWeO7knHhfIAp4hvTaOqIhjWjnNzzUQ58ym6ppOZnG5xrMsUNtAAvqZfRadbhcXlruNR7SQ4/ug9U64zwOBB8raDog=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 03:09:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:09:41 +0000
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     bootc@bootc.net, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: sbp_target: Remove redundant assignment
 to pg_size
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135uoae1h.fsf@ca-mkp.ca.oracle.com>
References: <1620902977-57076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Fri, 14 May 2021 23:09:37 -0400
In-Reply-To: <1620902977-57076-1-git-send-email-jiapeng.chong@linux.alibaba.com>
        (Jiapeng Chong's message of "Thu, 13 May 2021 18:49:37 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 15 May 2021 03:09:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b225dd7-9a0d-48c7-ce31-08d9174ee18b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4501F91914FC431043A03C3A8E2F9@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBz0+P6M1NziRGf479TODEtQqcVxsocyQ5skXNKLG8l6O4h2aNoY8WVXrjW2Dy7A/x0a9mlB+dHQ/uXTK2elC92NY8/22y8T7BJD8B4Mzo7fUVGpttdEclUOQ6xSoyihzEjUn0wlwEtJYOzJGKwhEfol5IDz8WtszYrPzAK0TedNndPf82oINbYxmOhCSzjCZK0V7Kg4IckgFwzLkXwFqhSjVDuBjh57/tAm22ZenbixzQx+WKCrRcjuPzG3zMkhewxm15JhONr64t62ZnNsnVE9qAFS1Yfh43oqMLHiu16MU2S31z7splmjFsSizA7nDZ5KJBEwWRw8M0zEotzpmNRL/m/x2iWzkye2Ar4XHyU6x1VHaLBkczogobyeEzqdXWMW5fN011R2Un5W2fyUpytZdsukEHYNU5JSMzJcP3kC0zysB7E/lAH9htuMBSVwR/h6VqdsCVmZyBZdZZ60qpZ7omj1Bp4lEcu/ngQe6Gr4iiZvMNtJpG82VjceBEAvDCp2eOgaeTXSIST9avK80om8PU+E1qe2R9i9lDsW3JcFEiJxgiftsFu6cxIli7b4JYrp7o2cfXwQ7EAYRSRza5odGUAjAlaXCCRH4/JVcnOTp3FdZ1M6L10hCfBaRbsY/Xx2vhFxy+3kSavmfxQBaNV0NBa4wDYIGQafYV00rtY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(346002)(376002)(396003)(38350700002)(316002)(55016002)(38100700002)(558084003)(66946007)(5660300002)(36916002)(16526019)(86362001)(6666004)(186003)(478600001)(66476007)(8676002)(8936002)(2906002)(52116002)(66556008)(956004)(6916009)(4326008)(26005)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7e8NC6o+oo5IlVRJ2mC0/0GsohL6ARnaw43hDRESzcVZAhwYb1RSz39WqrK6?=
 =?us-ascii?Q?x9fbLUpyvozWHRspfh+EuDzkP4bvLK+udD5lCmFVwoxeWObmeJKXZeMSxuP+?=
 =?us-ascii?Q?qtVbhzvutWirb949AUiIvOGXuWBBmyZkvRsDc54EFpMWkOSSmD1mFAWff2hO?=
 =?us-ascii?Q?GPcAehY2G8+dfiaMD74Wy1SAem2NcADlYxk33t7pUmmDw9dkBHwNyqT9yo7V?=
 =?us-ascii?Q?KI1HiAzhywzexDlSipKXxG3b2Vf5T7VsXgMp41Noz2IBd3WMy5KIc7N9A9Xt?=
 =?us-ascii?Q?WCXxJA6TZzKXZq7oSF/xuONoNA0aP0X+pCimfSfBFakBsWQrTSgOPJ+I5bGX?=
 =?us-ascii?Q?HXhmPhzFf2TLj5HjTVeXM21Ou3GI1Kiuyr+E/xiRnUNVpz0M9PM9W9oxyQk/?=
 =?us-ascii?Q?t7tlkyxTvItJiophho4DLrN+jY9xLFF2LHAslk7HKaBENiw7n1bITlCZCG1X?=
 =?us-ascii?Q?gkhVquIpWcritvirkwFhcI5Hl8rRHSB0Tih9kYEdLme5XTL/guMnZpkcIqhF?=
 =?us-ascii?Q?S2hckMV1C6gBm4LkJcGjLVZauwYRG9+rfrJfoMp3HgU8goBbczUtE+ukasUl?=
 =?us-ascii?Q?N9Nk5aAOR2YXI4cSQ6l5Up5e0sySfh43rm4eQTQ3/E0a4DNy/bydVT4iWkR9?=
 =?us-ascii?Q?nJdEv7QwdMUIfx8uBG4sm0FpvXvpT0He1Wt283uTwR14/7mzMLjjwkpGxV5E?=
 =?us-ascii?Q?OeS624k2dRMjdyM2Le9OifNKDYGLFnL4kZiuuFBf1hF6T0GVaMQ1Kgavt4s4?=
 =?us-ascii?Q?RN/iub6wk4VfFt4W40jjigItFy0lgYKCqy/Z7B3SsAFqGMteA3MHj6HwNzJ1?=
 =?us-ascii?Q?Golsfxz4AUTgNhJ9WiykFvT7bePQkEYLzcoY8OYe5G/9KrBARc9Gw6HaimiK?=
 =?us-ascii?Q?k3Hd1NTGBFFYNwzdwaAgIB9puksA8vVAXgrYMo+GUM/Ni9PsRNTwzEFKy3Wj?=
 =?us-ascii?Q?SfRNj0SaOJjpttsaqVsKBNcIDQZ+zLnPerYnjXF/MfbdSqdsPKSZh7pRFdxF?=
 =?us-ascii?Q?w4inW4KqbiFHj1idag7DFNKynAkUeRr0n2PrEH/Ejsk99NzrlSnKM7frruvh?=
 =?us-ascii?Q?flebCCr54NY1j0IGCkUIjc7YBQP5ojh4wvR/Cyauj+lrDZXeyOZlVfuDZpwd?=
 =?us-ascii?Q?9VqHfeUnKHI7YzTWGvq1sngyZvj7WUTc40e9wUTwSdC2BprR9mM803zD5IGU?=
 =?us-ascii?Q?BpAIyiWZbbQdxtg17WLIKUxRb8gzsaPBn0DcrA4+lLnJaYEeUgYqEnAWtI+/?=
 =?us-ascii?Q?Mc1SwxEWkM9ElF4qiMT9HyifFYCcbSX/CeN8VCXiPyWSOlL6wknKlzP8uFC1?=
 =?us-ascii?Q?tOr0iMg8u2gTXn7cVKas6DmF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b225dd7-9a0d-48c7-ce31-08d9174ee18b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:09:41.1845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaJ/7mdoSBzCYvCb0WroZElqfcF6/m4NdijUqgFmmSXEPMTdyx02uhC4flp2gtxrG+q9uoLAEUKWXO4OBqbB3gKYlar9b/5cyb70cboTSRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150021
X-Proofpoint-ORIG-GUID: 8K9J-MH7DVez6ifjK4lH5Jesvf5_0til
X-Proofpoint-GUID: 8K9J-MH7DVez6ifjK4lH5Jesvf5_0til
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> Variable pg_size is set to '0x100 << pg_size', but this value is never
> read as it is not used later on, hence it is a redundant assignment
> and can be removed.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
