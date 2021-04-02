Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8BEC43461
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92CE1610E8
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhDBDyr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbhDBDyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323o4HL112264;
        Fri, 2 Apr 2021 03:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=m4YrAgyuqTxomvVeqgz38QCIX3xnqHHfVkDIqf0r3uY=;
 b=Yh2dbjezLs3L3bImkqFtA13r/7QKv36Nnjwm/iolxcZZ/JYvZCUkuXugw+H9rkfldh3z
 Gk0yeCRZ3D+yAxTE9/RX9vgH1pMhQz+kNvZmYM1K+SzZd0Du862Dd/wCfwTJXYv8A0xT
 WCgInkNZyZSD8UfBYXupXncaovxpMbtOi4pRSjuNgl3/BYxi8wOgXWLYDX7Lwoc4WP3q
 imD0XjLAWflVvU9Z0a5H9O3Cjg7yjobQkJP6rfIcqqL3H3fzbJQYLPUIoGkzFmPp7Phq
 Ore6LK0sZiF0jTpZyUmmL/LANNHZN9oxILi01Gdb5rHXjycGhJJXlFs2H5qW5H/qIVHF tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37n2akkq76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdq2101561;
        Fri, 2 Apr 2021 03:54:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37n2atmxf8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRF/oYV6VHb/xvfroB4Gs7YRPjQPic3fhrz/V6nXLgfUalZ9EFU8Y3UUPCNrBXfntXBdlRqq7qoMAzXUnSv8+5gv2hdu7v3XS3fvYfreH7RAeFPVftfI1IgC7DblIdVIKGfJQfJNYelJY31rcDOpl/L4omHb5e+BUZQgtEjZ2U3cJIOllerQA3vlDKceZEtCXdppPtxfflkEZVwOlH7lCbRe5Q5Jt2kdVFlAQB9+5JKAdhR2CTiRp6srmZ/iSzq2xK5Y2SFMoWdVo3WTf6HRvNulbbkJe6UJqkY+c+fMwEfgyDPxB2dQ/0IX4KmFVGXb1xEFHdqkKy1RvKI9VIyMVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4YrAgyuqTxomvVeqgz38QCIX3xnqHHfVkDIqf0r3uY=;
 b=OzF63ACMTdOC0Yk28apG+5K5QOitiRTxzhLsCK1sb95VUCpEOAZOaPIPz9trwWyHFXvdgh779tt3SiTVuWsqdfmAQXgPPJtFiO3Bj+nNHMOEqdE97aGdl3NNFao+WqsMGlF4TEsrzEcipJevnrgwWcUxr5XSgMK3DWjlQvXhfJVjRQVLnWReUELQmrpUl2DJZzLBZCBILIdsHtYE77zqeJ8UrEjiVcZDc/LJzBC7cDM1RxClzVaQrwj63ZCL+0Xc+r4hljSeJ4tYXDAAL2IAj6RaPz2nB0P090N4AVtYmJ3ijfhjIcQPHCJXq5Xw/K/n7rxpGOqLBPna3jBOxBm5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4YrAgyuqTxomvVeqgz38QCIX3xnqHHfVkDIqf0r3uY=;
 b=KdbOE2GhMfikoYQF99a1yHhGu6FIi0JWGtEiQvmo5+8oDRCbLYAoVwpnl11qOgheflVJp0rKWnArKifKcJ7YX2KfGLczwEnmLrfjYuVSZWLn3ncmmnaxa4b8KHfWYfs1pv9u1dbcmLYVmTHuPwSPEDHq8b4YT4djYH0bTGe6R1E=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 03:54:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, kael_w@yeah.net
Subject: Re: [PATCH] scsi: scsi_priv: Remove duplicate declaration
Date:   Thu,  1 Apr 2021 23:54:22 -0400
Message-Id: <161733541351.7418.14159423546632545045.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210327030850.918018-1-wanjiabing@vivo.com>
References: <20210327030850.918018-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6daa5f08-8078-4dee-3fe0-08d8f58b0724
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680DAA9EE58BE80B73090E68E7A9@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHYyD7Q3vld3wzNykMZ+O2MWZt7eUz42MESicxRkaEU+x9NX3Zlr+X2Qnoo5BBoLt//HMjLZoG2MsTs16OykFoybgO8xgPFP0THe+HsbHIQsDbhGP3LOJ1JFmiuKzxULIwNu3+txfNJwtp8rn32pS6pb03e4mx0HEnjQKTdC4nCdGnAILTYVZn99jvt984HGkZ3PvCuZHr4nC76mZ4CkmezHSGOOdWKhL1rME+vL5ZsI/CKB8KPvpHhClNDevKqB6kctTc7fG0koKJacbWQSmmE1fLfgf0pdN0MEoCFIMc+5mNSc3/SMqxmEEXHniCpvOGR5mEjpiHjJqh0Ua5HMiDm3EYMGumQNk/XPft6avO7TRHr/XU5JIEip5uyrLp3qzDrbSqocIt1MxiNhZTGHrIgaEXCTBP/5w2TToy3IZx1BK4kMzrWt57c790XD416Dknfddjbz3PLUvPTCl91q2Tm2uw5INJzKiopTGl079z60iOQq7MCXxAU2f9XvZAW+Y1ujA/lSsTosY9urleuEuElhLagmXuOiAB82pFTPHmdOxpkIbWRQETSzz+XvG3bBR5cOWcvIFNJCT1Rj+9ioyLjB4PwMSKEEHx16xMmaFFBGWd7hOv3V/AqvRteR9VmrAGIdUJTEb3TyXJJJcvAKOcqlPNb/A5zGv6ATr84APgNyPyWFZA98WnoWEsmGdDwkirhmQyWvoaJcqdb38VjgoKHYd8YJ/Q61Laj/2ZRlcVU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(26005)(2906002)(2616005)(38100700001)(956004)(16526019)(186003)(8676002)(36756003)(66476007)(66556008)(66946007)(86362001)(52116002)(7696005)(4744005)(103116003)(83380400001)(6666004)(966005)(478600001)(4326008)(5660300002)(6486002)(8936002)(316002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?czhEcmF6NG8yalRnOXRiemFtQXdZejF3NjNPb2tHdXg0ZVAzaElkSThvaDF1?=
 =?utf-8?B?d0wrRjg5Mno0WUE5ZHhLK1V6dXpSTUJkR3p6b0xVek1XMjJVSEovSDVEa05D?=
 =?utf-8?B?NExDVGhIeWtzT3dWZzlUQmtMZzNHZ1doWVBnQWQ2TmNDd2Z6NmxIVk5tUk44?=
 =?utf-8?B?M1F4cEI1Y1lVNXZRM2J4bnRSZVEvZ0xzdjFaVzMyTEtKMndXdHVXdCtkajZ3?=
 =?utf-8?B?dGNvWXFUYUVLL0VwdXFtWnowMnV5aWI2Mm1XcDZyMTg0YzJvZEhYT0dNWEZV?=
 =?utf-8?B?OGlEdnNZd3E2cnNzSFhRRXdhRFk0MTVjUzhmUDcvdERiRW95eUFndjJtbFRR?=
 =?utf-8?B?M1luNXBTSittcjNxbjMyWFFmUkx0d2NxY2M4UUdMaUd6TmVpdnQ0R2NOMHRX?=
 =?utf-8?B?RFNQWlUwSGVIdWNsZXA2R0M1cVM0RDI1S0N3QnFFbXFIdEtNRk5Zc0tHckNE?=
 =?utf-8?B?OWxubno1dDFUNVdLa08wM2xhUlE4aTc4TEI0V0VYZ0pVQkZ4akYvaDdGU3NT?=
 =?utf-8?B?SjNmVnFhS3E5QUd2YTJtNFZHamx6USt4MnJCWW5iSUIvb055S2psT3dzNnBS?=
 =?utf-8?B?a1g1ZThYQmJpSEIzaU1PckFlZWMvbloyeWlVOTBEZXdEajd2VkNoM3NGYUc1?=
 =?utf-8?B?MjJ3a3IxQzRNWlV2bVVhVElCcjhrT1VEOFBTVDk0SURwZWtWcStuSGhyVHFv?=
 =?utf-8?B?Qkc1R0tUU0hmWnJtVjQ5ME8yRy9Tdkc3bzl1VDBiVGtZUU1lcG82OElqclNU?=
 =?utf-8?B?a2p2L3crOEFSK240MG56NkV4OE11NVhISStwbzBuM0dHTDZhM2RuNWVRMVdM?=
 =?utf-8?B?RTE1Y2R0c25YeVV5MERzOW5VSDdoNnlhWklOVEJtK3JmeWJFMHV2SWwyaXZH?=
 =?utf-8?B?WnUyL3I4aEo5cFpyMDBqNm9FMldIaVhVeE5wTVh1d2hESitUYk5lQVZEQjFX?=
 =?utf-8?B?aVRwNEZwcHdvQ1BJNmRka0pSWG1BRTBTNlVveWovSTJsWlhXMjQxUlVMemg0?=
 =?utf-8?B?OFlUczUzL2F1VG1RYjdZQ0dhVkRLRlFYMVdHM1N1RklKVHdSd3lXNGZVRmZE?=
 =?utf-8?B?Q3BjMTl5WHdsZjlXYk5OQWlzMm1HT0p2U2d1U29mZmdNbkVTcm5mM0dVamhj?=
 =?utf-8?B?dWF1dStSdkNTbTZTQU0yOEZrZGlWU0sxMnA5dFhDakRxaHJqQWdzWUlYaDZu?=
 =?utf-8?B?S3ZVU01PQkRoVHZMM1dhcU50djYwRlRxWmdsd2d0QkV6WGtFcnFQbU5pV1Zp?=
 =?utf-8?B?a2JLUFFUaTFOa3IzeEdYc1RyOUk2bGN4UnVzR1BlR2JhdHMrMXg2aFdldVNJ?=
 =?utf-8?B?SnR5TmJabXZTdmp3anMyZWdtb3NtckNBeGUwSlJveitCNHo5N3lqdWJSdTVy?=
 =?utf-8?B?VWlRTk5XMmx5bEpsM0Z3MGhDSkVsY09JRkIySEk3S2xTSHhDSmhGdmN3Q2VK?=
 =?utf-8?B?dm1Zam1PQXlmN2phbUdnUy9YczYwY3pNS3ZaQyt6ODlqWGh5ZEhlYi9iMTBI?=
 =?utf-8?B?aHdESGEvK00wZ0JmR0VDZU9EQzVjQkhWZlVPc28yaTUzRUplQmhHbG03TkZM?=
 =?utf-8?B?Ykx5Rm5vdk0xVThYcGhMZmdBZkxoekw4RCtEbEZzUkZXb0tzN0lBbmJYSEF5?=
 =?utf-8?B?YVlrUEZVRFZaQmRqaXBSQXJIcFhyKytETGRHM0hFY3ZLQU83ZUJVa2VDOWNp?=
 =?utf-8?B?Zkk2QytubkE3bzMwRUU1SWIxYmI5T0c1RFJmTUYxMHZrMy9hZERUb3M1SXV3?=
 =?utf-8?Q?M5zDehALPsJR55k8I0Y343BcCV8R3/iTYmyDVC9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daa5f08-8078-4dee-3fe0-08d8f58b0724
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:34.3543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNXYqB5EqQwRrLEM+U9uKsaGRA5ukIvXNK8cDcFwiovNNb/KNXLWXA++1CMoobGFV0YELsrDoXoY7WcoHmXfBvyC+R07tQcjylIEkmZT9pE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-ORIG-GUID: s84QSBwGtDxaLnVIU3IDNIOp1XkWW8Ol
X-Proofpoint-GUID: s84QSBwGtDxaLnVIU3IDNIOp1XkWW8Ol
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Mar 2021 11:08:50 +0800, Wan Jiabing wrote:

> struct request and struct request_queue have been
> declared at forward struct declaration.
> Remove the duplicate and reorder the forward declaration
> to be in alphabetic order.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: scsi_priv: Remove duplicate declaration
      https://git.kernel.org/mkp/scsi/c/fe515ac82768

-- 
Martin K. Petersen	Oracle Linux Engineering
