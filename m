Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B5AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 821E36136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhJEEiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:38:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53312 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231393AbhJEEh4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:37:56 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19531wkP019448;
        Tue, 5 Oct 2021 04:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=I8Skc/zHUng4lQsw8lIr5dRqimRsx+movTDP1HJgyh8=;
 b=rj8fRikw7cGuAVx/4Sr6uyugALpKbNJr9ygCOqCkVzS3ctWBIykq1+/4AygqWFqmWIgu
 deN1IvYQRZetYpjGtJyKyhAtNTBmzTOJ72lMcQcbsDrAR4tqULVjOLqHY3H9tmZ9P136
 /oFLalGqSkkrw3UUcBBZ8h3VD0JsIbSciskU15qCFJX0L2uEakWLBJmFa874PPHdvLce
 C6q6+neWKtCWvGihluoTMvu7RbMfnPVk8rxcEftipntVNVddIc81JeXc6zIBLTshWwAa
 V4uaDHcZjla3G9I6Wk1xmSQF9YdNCsk3n8uP7Zvfj88keKkE4cyOHNE4cVEh1iBbxlWp YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3p5cwyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMf054346;
        Tue, 5 Oct 2021 04:34:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvM4BjtrvYDxZWE8756hlU4CKAfYZ1OZXwf3z3iXx97CFN9YLvTM34gkQO0hHuvxlrlJAHvtkaNqwZmX+ezdrXfrsqvMma6liOGWnWQzsmeGEMmn/xv2bny0FFd2XJeFLm7mL8gyS+NOhUuGN89hyV2eLApTAi12Z+c9rN/MrT7MFItFv5WXCD0yU2O5bGRJ97Iqp1llIyciLxCo+JXXivSSeJ2klV+RpWWbcGYZqkCWZA6Ej1dJhiVlnTiDQApKPL9X9aTcavJMh+Grkdvmz/Fl41Cpjl6DY/G8r7rcilfWw+jTjn8AQw3aiUezx6rC+qUNCgIutyU2gpRelujOFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8Skc/zHUng4lQsw8lIr5dRqimRsx+movTDP1HJgyh8=;
 b=coeEGbi8/xudL5VP+ADeEWeyZb1wiX6AzFCj+kuXERlMSxjvWLtkOWNu2ak8fTnv9X9QsFFIOzn3pQZO9MNKbcMG0c05vZ6V+sMvEmro54DFK40MsPETo2waAednfHYP3opp087hyQrcQak6/Ciw/lyfdfASyrvpMdfMgmlMiJwMOvPXMnY/RwTTFBoL1Ls+QuojnhVazu+WI/fCgx7gwGUwA5V6D9z9NrpCoqks4V0+l/ZRuONZFK8v/+yMbUP/JpNELIjiDpBFlWNRiNoqSjj+iITir0h+R2abcyKwPXax3vLAR1RPrKDequccGtJ/IesS2yYV8zj6FdBAAm8clg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8Skc/zHUng4lQsw8lIr5dRqimRsx+movTDP1HJgyh8=;
 b=MLcD1NzkTLPiOlmesUgyZQ7ifyYdb866hHwDavzdoVuLlj983fv/qwsU/trdpyAIiYNIIO2hF7H1X1+gRtf3bDDD4F5OA5PNIJHZUsWd1SbaCddADXxIzoTqSsu1paHG1bGKVzDa637Uwpt1WIgbQkxTW1j3vqYSMOK/gNHtAks=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:55 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-samsung-soc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] phy: samsung: unify naming and describe driver in KConfig
Date:   Tue,  5 Oct 2021 00:34:37 -0400
Message-Id: <163340840528.12126.5919262965845250313.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
References: <20210924132658.109814-1-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c9707b0-b2e5-4f5a-d8f3-08d987b97b17
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB195009373D5EDD601A1783628EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaQqABjbuH+V62WR0C0rsLuulLiPDRAT/bkHBJ7A1XVW1GkuPsbUfaWZyG2K+igDr3ZFn6oc/yC4SLdwuAGB8jNyVr9kX+oN+wT7NpHYpYrtyQ+hMCzz+2BM83lMPAtuKdOUxlZMD0oAhsaCU2SHKgxePFLdgtLmQDYbVPCFsv6yPGi1z6jXA0uDRpqeZkXP0RTXIIOKpcaA7JsW9gKZ3Hr8Ublu2tSrGrpdbdzAt5ncO9oy52Dgd+qyGYyIJBdso4y0VjrFxov5GVVb21LLdPPd3F0Vkj0bJOlzmV+n/miNLyFqRgH+SkZdHowCDsi/ePnkQNRDxnMz0paS/Q4qCO6fDG+WnonaLa8sJSzYX1biRREQ+CWPW0gh+UFGO3r4F6kkl3IeC3hV1sYz+8LGYc0R70wLQnzMv6hkExNBISRTgA/wkmLK9nS6WZFFYTd5Qzy666CHqUKtsHT6tF3p3Dn3a7KJ7l65Co7tYo/8kbmPcT0elI3VZp73u4btzOBc5gREdH0JrHnSbBp8JVv3yHgJaM1MTpXx39GO5X0QxQP3GSqM9UWAa+5fvk+EVnETmuJscv5NNj06DjNJkjf8L+K85WeemZQKm6JE1D0pxZ528w+K1AefPQWkOkHCxWZOeNDsBJjnR6NTYtQz+rtr/2rvK24wkmeYuypQEaLyR6W+xPvE1A2+nqlPFfbZLCfC8jwI0g37UEWBWwSiMVGcjN+swWx+6IyKPPR93rOmgsSKriWW9QwCJ3+z6XkcewbrNInm40f41esRJHf0T7EQoAbqaKa+Jruc+qOc3i4mj40ucgqI7IAuN+5O41FQW1zQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(7416002)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(921005)(316002)(110136005)(107886003)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0xHSU1rL3NjY0o1bnllWVRvTTZaK1NrQXEyY0pJOEVoYWJLbGpLS0tsVGpI?=
 =?utf-8?B?ZHpIdFpjMENSclBjNEZuakZURHpvYzF3VmszV0wyZm9zMElJY2lSMit6MkVW?=
 =?utf-8?B?Z2E3Q3YwdGNCNjBQZjBUODRweVJOeG10aVpyZi9RN3ZHcWpvNUJIcUdIZSsr?=
 =?utf-8?B?aklEbDN2emNzWHRiSGdVaWErOEVqSXNab25NYXRTeXF1THB0eUQzc2NKcVNQ?=
 =?utf-8?B?S1dTdmdNMFBJY05yVG5EL3FnaTRYbDBEYkRhT241KzFFU0cxQ0I3RVNMeHJk?=
 =?utf-8?B?aDVBVjVJV082UmtYZ1oxZjQrdThlTzVpRlRHMWJBV0l3OTlKU3l1dTZrNjlF?=
 =?utf-8?B?MTF5SWwzNFVzOEd1QmNCc1p0VHFoYlU4eHpSQ0lnYWI0RWFSa0FKV0lSSDZT?=
 =?utf-8?B?bFgxWEVkREI0aHBscEpVZDJFcFRjcWhmenNJT1c5Y1NWck8rMnRPNFlnZ0xC?=
 =?utf-8?B?akRLeXJxd1NvR3F0SUl3bzFNRmtneDdyQkJvQXY3Lzc1M3Z4NWdtaXBVbTla?=
 =?utf-8?B?OEV1WmhuTWQ2VDJRVlhucjdzaFgrZENpeEhaYjBrRjFVOERsRjFObmF4MjFN?=
 =?utf-8?B?TTdNekNpbEJtSDZoVFo3enRYcVZHL2RHejVPVzhtUmpWbXlnSjczU2VvUWQ1?=
 =?utf-8?B?OVhKQkgxSFJMUkphN1BMVm1XLzZPd1Q1S3N6RHlOWWVZVEMwYUNjMjRjVjVz?=
 =?utf-8?B?UXlLVFFmeXRpRnlYTzRjQ29OQkR3UHg3TDU4K0RycVVsSFRXdTlHTnFlUXlU?=
 =?utf-8?B?aFR6RjE2NUkrdWxaQWhWNnBXcytDQmVGUFJCeWFySmUrMi81N2wwRzUwaFFY?=
 =?utf-8?B?QVBMNjYyOG5uRkQ5YkxJK0ZVSk41YmhLRHl6UFZGSGRrYmo5c25EMlNFejdR?=
 =?utf-8?B?VENTeThLOWcyWXZXZXJsTDNZdTNGZHhUcFQ1QXVhc1RIZisxRmI5bGk4dnUx?=
 =?utf-8?B?SVAxR1Y4amNNTisvNUxuU0hUWWNNcEo4KzJqR21XY2IvUEUyZFZzRUhlUzhs?=
 =?utf-8?B?QmJYN2h5QzEwTUFRcG5WTmhQVFZCNUdma2ZEejVMcEkwbVpVMXNuTkpUYnJv?=
 =?utf-8?B?bTBYdXhhc2d5aGVnR2Z4N1NiRm0vUHdaTFZQV0RLUXM3S3dUSThFWUlTSzRM?=
 =?utf-8?B?OWwraHZXekRlaWZWMUZucmV4MWVJd2lhT1VHcjNUOVc3MHo2MFQzSGh0cm1y?=
 =?utf-8?B?eXZyNVYvcmVlTndseGRldWFweDhncTRyN3Z2RmJEMURnUkUySzBmb2dDM2RU?=
 =?utf-8?B?OW9jOEYzTFFydkRBSUp3NGd2U1JNWTlPRnlzRlRDVWdHMnVQc1diL3J4bVVt?=
 =?utf-8?B?ajJSNGNDV0s2cElvd3BEZ1pIeGlGb3VBNWhGV3l3SEthckFLN1VGUVFyOU9z?=
 =?utf-8?B?R2VWcDBvbWpUTXJ5WVR3SjhWM3pNOHdYQkRRdEJGaGVPMVdBYjMwZks2SEZQ?=
 =?utf-8?B?VHRoQ0x3ZEZncTQzQytQN25HZGZCNndpdXU5a2RnQmNBWkNQbFVLME52VkVI?=
 =?utf-8?B?V0diUXpydnc0a1pTV0F6bVdzVmQrc2NISjd0Mi9ZU3h4a2laZlpSeW5lTXk3?=
 =?utf-8?B?eXlyc2NmQnB1UzUxWTRxSm1iK0ZHMnZ1VHF5YURtZDNPZ0V0SjBkVEw1dFl1?=
 =?utf-8?B?L1h0a0Q5Vk5UQnJySUUybUkyRHpieW1XNGxqT3NydjRGcUdHK3lKYllvQkZy?=
 =?utf-8?B?dG90UlhlRFg2YlUyL3kwc0dHcWFBZEVWWWFqNkNBMXAxYnJYY1NuczVrTURp?=
 =?utf-8?Q?Y9VWAMJ9Q9N3GnAdpVmKpyRfIbPd/2/o71vU/fP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9707b0-b2e5-4f5a-d8f3-08d987b97b17
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:55.6044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c7U4JCbbDU2aPfSMXw76jhwApxdryzPt/Okyc1d8W4gjOKRIGNqp17WIO2YhBxGirW6CNmZtHWaX0aheky22XVnnPDCL6YhqOl3Y7PiiTbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-ORIG-GUID: D0-qy1BP8kRhgnTA2-O4LWurhJSsyIIw
X-Proofpoint-GUID: D0-qy1BP8kRhgnTA2-O4LWurhJSsyIIw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Sep 2021 15:26:57 +0200, Krzysztof Kozlowski wrote:

> We use everywhere "Samsung" and "Exynos", not the uppercase versions.
> Describe better which driver applies to which SoC, to make configuring
> kernel for Samsung SoC easier.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[2/2] scsi: ufs: exynos: unify naming
      https://git.kernel.org/mkp/scsi/c/ce580e47e848

-- 
Martin K. Petersen	Oracle Linux Engineering
