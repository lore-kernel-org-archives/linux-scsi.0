Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C77C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 881B02070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhA0Fim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37734 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238743AbhA0E53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:57:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4tANi099274;
        Wed, 27 Jan 2021 04:56:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=o6F4aGmWu5aOaeCtpsLuwiZOJ5ZaDy9R0ljH/eYyVC0=;
 b=UeYfqS3gxVi4xYLuzUdgnGZxRlSbaZlha8NpkiHHIthXnpaMEFXgqU6sPWoo616CPwoZ
 HgWCMLw1qBC0dGRVKfNj5A+UTvR6nipT1SF2s84KezxdgUdAt12Aobenj+8V7AlPB5Pt
 C//Beu/aYqKm+gw4OwztddtCQWdVhJSpw2weAkKhwiJrzYcIPpzO1/3W5iSn0TaNGfPY
 b03a6LCPIsh1mrUu/Aj8AbftZrar/beUpnT0Di8AaHgIJKaM6HzMx8A4QkmSuzvQmeMd
 DFoX+tq117q/+AE7dq+IVbk6ntt2pq76gw8MlPCsZ/EJEHqEUACq4oIUFa2Kpmuq/RjZ Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aanbfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:56:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p56W188801;
        Wed, 27 Jan 2021 04:54:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 368wcnsk5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJnsV6Ia3q4gN1/w5+YaZ9CADrqHBwP0sof5qU1tl345Lux4NVqzD+uEQGu059LB6QszTakdvAtMA7QmIqPft+bY+Pq9HqJ1Gfmrm3W0E7HdnZ0n3RV7xEYNkIEPq7yLxPNV8JNCobXs6DW8TXQ0OBURYbyi+a9ByEL6QK3qgUZ+4BkgTMkX0qKqzsXxUksSDhcs/57PYmMBcBq8jaghzq8kxImAudcCmVsJs9UcuV0oQhx4lf98vxebnDnvhkZlhBlU62Q9uU88Blb1k7Dpk04RA6vdwrHui3hM8eVDlsVDOnHEQgkLGnPTwcpUrpLtslEJvG0qpdKWXKE3EB+85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6F4aGmWu5aOaeCtpsLuwiZOJ5ZaDy9R0ljH/eYyVC0=;
 b=NHjGUKliEiDZmp4GLUq6WgQ2uBiABdo2QI26Mwip1p9mSk3tqA1IdoSzT3UC3xDIufvAFemFPyMvP+VZaxdcNpkVOJV22V5xJsTphQY2YXiRI7UeReFD4p81tBfGHTyY/EMAa03Blxso4g/uTeG9OuVIEdW3I4kC1P6ag/UClv2HTlx2y+1aT4zUKRm4fDuOjiG0o6wc7Uz0fNrwqmj847T5Q/YcLVoeNP3OP4XhNDpcS9e6jHFoZtspblNLyrziSK++eDbmbnpOfYuewTfPDfLyz49kZF8nnrmXJNUs9MBnusJ6CNdJSvICgscBVne0GQ/0uMQ8f/ZdpiE+qK5SpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6F4aGmWu5aOaeCtpsLuwiZOJ5ZaDy9R0ljH/eYyVC0=;
 b=szUE7pl6R9heRtGHkxyX9L7hS/QpWpHQCuZjC/8ySDiavzMKpDawT/de4jlfzfZ61w34lVMQxD9echidJKXum16HlnTupm9lzixHWJiWuFkltv4Kk7VitCnCH6u3Wa60diT9lUrtTgR92Zo9SXgiO/sivHyQp3vr8qakcEPsXMw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Eric Curtin <ericcurtin17@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "open list:EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER" 
        <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] rename lpfc_sli4_dump_page_a0 to lpfc_sli4_dump_sfp_pagea0
Date:   Tue, 26 Jan 2021 23:54:23 -0500
Message-Id: <161172309262.28139.7504973262791914699.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210119205022.40000-1-ericcurtin17@gmail.com>
References: <20210119205022.40000-1-ericcurtin17@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fff9bd5-02ee-40c9-4187-08d8c27fa908
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45847D255BC518A37D66E3988EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MrWR2tA4336yushos+eq48uxXM+lSkqSwo53x2HpKKub0HDAteLvMHP8WBT4fauIp95gVRIiwhi3a5E6uBlDy4VB+610COQoS3YRVC8y/7XudUpb5xegU3LZkdnr+0BQtldz7ienKZWu4Jz/v3Iooa9A3dUUqVJoeOypVqLUBJE1CrIzCJ2uCq7Ykw7qbROlI7zHMrP9RVvwRCXYIzmMxWfMIfq1r+fFOeeVSewefHt6GZbRzoYQMs9qzpgYz8EfJll3/sKjE5NePGWvrMcbUiilra954Pz6EhT/hRcNwQ8uDmw6PKOJGgx7GyIrWWNi4L2ayZ9C2gtRCBscBR1d5ukJz4BAP3EUKLCQ5zSOPd5iIwmWEq5moHT3PuLjbYQxI5YCIySDwVK5wYOYk2kirQRZjRurNgIX/fIlChxUs/kzpy6j1DvoijYI5wOZrxrLHZuFiQhcOHU6XeUExqGmQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(26005)(86362001)(186003)(36756003)(2906002)(6916009)(558084003)(2616005)(8936002)(5660300002)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z0IySHpoa3ZENm12bGxOa0hld0VKUU9CWEVUWUo5VWYvN3hOVFpqNk1pa0Vu?=
 =?utf-8?B?YXp0MUR4N2VRL2J3Wi9CVUVXdjlYbjBrSm5aOG53dUF5TmhnVXd3b04yK1p4?=
 =?utf-8?B?Sjl4K1ZXcW1lZ0htK0VNa25BWWwyaU10bmM5YXpYWCt6SEMrQ0dPdnM4SGlt?=
 =?utf-8?B?dCsxR3RScEZwaXErVVRqNC94OHVWMVV2TEhyRXRVVFVtaGdXb2JJVmJCZ0Ra?=
 =?utf-8?B?dXczdlJJUklqTDJRSTAwYjJZNFhNMVlZY1Z4TzNtNWNVS3VZMENpMWZhaHho?=
 =?utf-8?B?RXliL2lZeGowRjFrUUlLR2h3MWVsam04M2dGTWhYZHR6OEhnd0J1ZjZ5c2k4?=
 =?utf-8?B?VjVBdDdpMndueDBoWFoxdEh3ZkhqZGZEN2loVENNVUFtSVdod3ZpZ051c0pS?=
 =?utf-8?B?NGtCWHBXK3BLT3djNjVxbDZFQVlWN3poS29zY2ZZMTljUzU3UTR3TndwWG91?=
 =?utf-8?B?MGVaTnlDQlM4ZVQ3ME1vRVp6UVlmVnBnME1mWnhIRHI4dndsVnFNRW1xWUts?=
 =?utf-8?B?YjlnOUVBRDRYWkJPMmFMZlZQY3gxNHlkczYrNzYxVUd5OE11bVc2ZU1ZL1dN?=
 =?utf-8?B?SGxaS2VuSTlIckhvUW9pVCs1bGtRWlBRYjZmT05wOUFnU09idzhkWVpQZzNM?=
 =?utf-8?B?K0VZa29HaC90dVJIaCtIUmVNSWxYWWtLdzRaanJJR3FBVnJhUDkwQStyRDdx?=
 =?utf-8?B?WXlzL1lhajVqTjl2ZFc5ckNvMUZFMXpreElBUEszQ3h3TmRQS0xjcm1tV2lt?=
 =?utf-8?B?dVZIMEdqbmVIekxmbzMzSXllek42UUhxNndFNXU3SWxtdm8rTEZHYjErdGhp?=
 =?utf-8?B?L2gwcnhnR0w2dVJrcjlyNXBYRHdGYU9CS3lhM3RZdDZVdkdLcEVRS3dPbmZ1?=
 =?utf-8?B?TUZFbG1JeDAvdklpSHZWSDU1bVZUT2U1MFZXNDhyOStkTFJIMW1DdEV6OGRz?=
 =?utf-8?B?ZVhYNDNLaG5oMkFWOWtWQThHaGpYbC9sQllKdUsvR0NEcWNCYytJaStQOVVI?=
 =?utf-8?B?S0FjVStEenRMZ3NIU3MyUVBlVmtVNHRtb2xadkowWklqUFlleld5cUhWdU9M?=
 =?utf-8?B?U0xOQlFDOEx1YlV3d2NZa2xIWWxsT3V6YkZqV2RlRTcySmUzQklzeEdWUW1z?=
 =?utf-8?B?cENJaUFoOGZjbXpzSWNVTFlRN3N4MStMTDB5eGJFSEt4Y29TbFFtOFBaNlEv?=
 =?utf-8?B?M0ZIQ25BOVFnSXdTVk5OSTdZZEU1WldiK2xSN2x0SzlQU29RSHJBY1FCeUNQ?=
 =?utf-8?B?WkV2MldGaXFFK1Y0VnA4M3crdGRxSXVGbXRkdGlzc2JRTjJKMW5YZi90S1Fx?=
 =?utf-8?B?UWJkZ3pzN3JlQ1N4azRZSUpiQUdXbUZJN3E4VEFFQWZTdnkrcGVnR0tWRWE4?=
 =?utf-8?B?Mm92V2hnYng1Ni9ObXJ6Ly9wdTlTYlBHeDVqL3VqOFBVMHgybzJKRGJkNUVN?=
 =?utf-8?Q?tWjFD7Vs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fff9bd5-02ee-40c9-4187-08d8c27fa908
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:42.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bw5bsl7QQ5ZiHWp+1sX4fivsQi8RELLaNa/oesLp/PAH5w4Q3n0YCbNm0pfz3xZqaLY5zLQKWnErrHoUgqXHBbScG30WJTKBLNHxefLYH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 Jan 2021 20:50:22 +0000, Eric Curtin wrote:

> Comment did not match function signature.

Applied to 5.12/scsi-queue, thanks!

[1/1] rename lpfc_sli4_dump_page_a0 to lpfc_sli4_dump_sfp_pagea0
      https://git.kernel.org/mkp/scsi/c/0196e379095e

-- 
Martin K. Petersen	Oracle Linux Engineering
