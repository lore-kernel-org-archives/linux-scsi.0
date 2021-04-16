Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC27C43460
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1ACD610FC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhDPCwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhDPCwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2nqiM047261;
        Fri, 16 Apr 2021 02:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AZCGvNlhtjPAZfpaF6xKV0GkTS0D07Zb38mvkymMxFU=;
 b=E1hrukZLz1jVGw60ojqk2BDUFe70hTIl3GMT7RyoNCeKRh3ArYgLR9QjIA0Ci7sWqAPI
 8Hx6RvORd3Z3AjKWQdlLUbpVBQv8Qz358NsAguqGORNOzdo+pawcS1W+0PHJrl1rRGGo
 1DZlm/aGbw6fpwdxma9X6F8bJ46aW1ZdDsmoulo6lwe745+JZxccGMiI0hNwxw/G43uA
 mYu5rWp8dFeF+byqofEuU54JRhGDYGwlqWh03uhmXYJsShk+fndaWP00lwgzpZcuB/9y
 Tre+EWW6kVl0tRtQPXQbZPo9GLQ4Kjk13Ju0zoI81tMyd23WV+kpAPyd+fE8rKhXPLSu uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymqpmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2pdFG045037;
        Fri, 16 Apr 2021 02:51:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 37unswhm94-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tx6R/u0Qlh/7CFVGxYBy2BxqJJGf6XDH52LH4YddkFI1IEmf3fgCeqYRCKbagAKaqfBixeRQ3cR1923IcCGj1lF86jpFK5wcek3pfe+P7ZVf1P8tmeiyjQM0f9ijmG4pUPuANFRhPrL+WjKyo6QJ/EH0J6mCMSvpzL4fTlFjP4vgTfvIkbIaf74RLvv4X9lDHBJ8l7lvNfKXcQAHpEtIuXk6hAcuvEPXMFoEQlpPlIf5sdJALVpxj4yT1jm0lvzXuawvB85Cn6UnGV3xAHUlSi/LPy3yAoKGbJz++26i8b542sdXKsvKweP5BE1pcVakMP+O0m4igR5iXVydQAAZLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZCGvNlhtjPAZfpaF6xKV0GkTS0D07Zb38mvkymMxFU=;
 b=Y5joSwVyujCaUi5+cgXZSLRMVb8wtU0ZNkOqwxKUAQGHWK+ikHc55XjXEFeWijvizfkgM28B87s9cPO9lk8+putVdZQUWz/sQ63aXRKmr1wvdrqbbPJLUZTB3TaXfS3h/IPeQW6yDn6iPly2Qkr8+tjj1ScrSOLUHOtGesQE2gv4SJ1nER/3eFSUHIfDt7jwvE7UCabGIr5B+huqDoyM5BEMOW/DBbRZBZ7KHDLp0iFRjo3QzJ7X9nQ7Z4q66EdX1c2tpYNOwcqcN5Tp993ke7pXOyPVq2eYyy9SAwApzQD+gFFCHlWjJ9fldjVcyH0EiXgkEnf+8exSLWY1gl0NKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZCGvNlhtjPAZfpaF6xKV0GkTS0D07Zb38mvkymMxFU=;
 b=Puy7+7fOmFq21UtXCzZJ3kortoOmQs361uljXo42cJGraJQ3iCHG6AbEJShRTCFt5gxiM/1ODNVLm0cWj+jQktOFxIycz/wX7sbDRTkfzNxqb5sup4BCWIjLVlXYi1939fTfhfhHV13AFwu80XgBDxZThZwn3pEWwAAIUK+k6Ro=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, kael_w@yeah.net
Subject: Re: [PATCH] scsi: isci/phy.h: Remove unnecessary struct declaration
Date:   Thu, 15 Apr 2021 22:51:22 -0400
Message-Id: <161853823947.16006.18116158202131817903.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210406105913.676746-1-wanjiabing@vivo.com>
References: <20210406105913.676746-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7fcf3c7-5114-4bad-ab70-08d9008291be
X-MS-TrafficTypeDiagnostic: PH0PR10MB5466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5466698C063462B4741743F88E4C9@PH0PR10MB5466.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ENqZPBTig0NGJXfe6E2ulCRIYcmuMyeC1NWw2j0xlg76rcKbAY5H7BdbSNUeW+rBlwMDFClv0V7Az2fsrE+AI2PN1C9YZ/p1cwXhCJZzRGJDjpEu7+Y8PZUk6wVr3l2vuO4X0JBy4UdS8JV1I97ZmuQAfgntKTayVlMUzqwpv8mcr6MhloTRv8bJLrGHYgvb9BxzMa+qVKo6gPgAPjbDeKtAtihgwyc6J6y8zkjRKAwEBBak4ODpglErYU7Ew0i8hh6s9eDVfKv483Cx0y0rjW8eWg8+ruishoQZh9L3TihlCH2Z4y3tC8QPKUPGTv1MwP1FS1TxMVI4IB4FDune2Ini31sw4qVHzdWJXAXnDriD45RlEXsr8OzjXN0bMexVXXsfqc2ySn36kEdCYFaiGzCl5ukaaB1CJHqk9/PsgwBU2WYNwePjKHOUBO48//vSHFKBaM6kkAsAeOhMeYjyn1zKWF90ktLWqszIxpNsbh4rijiWkfZFYW9uGl+ooFBSYl1jpuHRUcyIjSIDk32NsiF/yDFwY8ijo5sdEvTT1mNqpq0XmqL9JddJsgv3WXw4qBz3pTwjtUgipkhelrDb74nwYPAORhnhe8ctT/HSlqbiukAr5Hx+EaU0tPKSljj7HBN9/S79kEYC6HCNX1xlaRVuII3chOtxFb4vnyUw7UdlICscFak/TEiQ+fozk0p/yRCs3oWWO8AXKgyGAm3LvPwjOX7d8vIgnRolO7Bv6Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(7696005)(2906002)(36756003)(956004)(4326008)(6486002)(6666004)(5660300002)(2616005)(103116003)(52116002)(966005)(508600001)(316002)(66476007)(186003)(110136005)(16526019)(66946007)(4744005)(66556008)(8936002)(38100700002)(8676002)(86362001)(26005)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bFdVdjFHVlVvVkVwOGpLQXBnN3IzNXNzRGM1dmpHN1JucGwxTldUMHBRbENQ?=
 =?utf-8?B?RTB6eG5nNnVxNkRiRERCMk5QWlVpSndBVkwzK1duQkdPYW1jWFdYVnVPUk9Z?=
 =?utf-8?B?UEg4R2xEL1N6UjVUVnZScEp1NU9TUUhJUUsyeU1CRjI5TmtWR0JFazZXMGE3?=
 =?utf-8?B?NkJyRU5obUo1ZWtFbHBWVm13RXMwUFdMc0wraVJnQ0pmblVwSG9kd0U1YWJp?=
 =?utf-8?B?QUNKeWEvV1NNbmRENHNBWGp0dGMzMXRoWmo3cmczNUhVRTRKdytaNUtURW1x?=
 =?utf-8?B?MjNuenhWMVNFMXIrZTlRcFhTZWZ0Vzk4S2thejdDK3NwSnpCTHV1SENOUTNq?=
 =?utf-8?B?MWhkTmNvaVg2UHh4NUxqdElOSkp3T3BmN2pWZFRCamhndXdFbFhBWGlPWEVu?=
 =?utf-8?B?ZGVCaEphWmNYZ0FEVWthakhRL3JqajY0SklnWXAvbFRxamxsaTZCckhNWWdX?=
 =?utf-8?B?cTBvbDlEelc5TGlhVWM0eEJNbGFPcUxXQWY1eS9OTm5zL3RyTFFXQWJLUHB3?=
 =?utf-8?B?OEd2SWpsUEU1K1FpK2RhbUZLNDJVcVNSU05ydW9FQXg1U2s3ZmZHVURWZ1l3?=
 =?utf-8?B?NFIySXpaUitpZHpvc0R2emNGKzFOVnlnOWpwQWxyWTlBTkI4NEVsYUJmeWxL?=
 =?utf-8?B?N1RlTDZRMG5jeFRjSGlBdW9aUlFzM0U4TUppWjY0blQzM1EyWnR4bDQxQ2tX?=
 =?utf-8?B?anB4YmxCZytLNWkxb1BGbzFFb3ZyeUd2aUNxRmlNcXorZmpUMTQxdmNqNUlX?=
 =?utf-8?B?djAwWVQvSkVFalVrQUczcitoU3dFUDQ1cHN1cXNDWWJ6Q2xjWWZMSVZhQTZL?=
 =?utf-8?B?bng2azZXeFoyTXRyeXdBVjVPOGtZLzM4Nk9pU0VUVzdHOG1TU3hqKzdkaEQ2?=
 =?utf-8?B?Zm1xbjBBRSt3TWJLczk3VEJSQ2hObmVKQk94Y3Q3WDFacmFYQVlwNnJVTldq?=
 =?utf-8?B?Z0dpM3l6WEQ4enVEc1g1cWlUdERUbVMzZmRONGo1ODZrRnUxUnZjUnJoWWZN?=
 =?utf-8?B?S0FjM2hzbmxVYmZTNVpZU2ZyeDBLd05VRGRzVHdWWDNSbTZySWxZYi9hQkcx?=
 =?utf-8?B?YUhoQVhUZ3RzY1RHVElpSUhRWE5KWW1HZUx1VWtlVExqS3lXREhZaSsxczlB?=
 =?utf-8?B?QTJOb3NtZVIwdlJZVE1KRVZreW5MckwrWFYyZmV6NHp6Ym1lcVdVQkN4TVFu?=
 =?utf-8?B?ZGkzdGxnOHk5MkRHQmM2VVJqeFFzL05YdTArc1F2ZkxFTjI4d0tJUllvd0l2?=
 =?utf-8?B?akdveFRUZGFGcWErd0ZzcFhLSDErd2tza3Fack1jVEdHNkhidXJkM056Vitt?=
 =?utf-8?B?b0VHdlJVSDZpY3FRaXV5U0FVVFBtWm5IQTJkRzBpdDBMQXJWeFROL2lKMUJQ?=
 =?utf-8?B?MnJlN252N0pJR2w0M3NlU01iekwyUnEyZk1nS1RZbDNTcU1kc2lpMGFBMlJv?=
 =?utf-8?B?aC9uVDNTd0k2Ulgvc2RYU2FKTkJmb0tKYXIzNUN3Y2l5endZNDFtQS8xQkFR?=
 =?utf-8?B?U25aWjMyQ2RBaEw5M3l1VUxXc2N1SmJSVWNPeWVGQk1EcXBMV1hEOC9BdHVC?=
 =?utf-8?B?RWgvNlpjS25hL0VNbCtFSXVwUExRamttaVNoUmtnMjkyRExJcGlxeC9sc0Ns?=
 =?utf-8?B?TDY0VFpvTmhncENKQ0htNTJKM3QwbXJOMWo3aFRkODZWekxTbFNKZ2dDMGwx?=
 =?utf-8?B?Vkk5ZFYzNkhJYWZ1RjZDbWhpVDBHZ3N5SC9Iem4rUHhhTWYyWTNuNXI1UEFr?=
 =?utf-8?Q?SvvUxowl54N9vtYpdMbk9plyhDLT0TXDBgpSJue?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fcf3c7-5114-4bad-ab70-08d9008291be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:44.2368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5rQ8VBTgJkog4X+lL0spiSJAuLGtvGRLrzf/QTCUprKLM50h6edYxJ/2akFSxGTRdfFIgm8X3wti8wo0gq/HzHwQpAOykT1EO9Lrycesmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=974 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-GUID: r8lOMVCLjNdiajOd-ZPcKag-JywMxdVf
X-Proofpoint-ORIG-GUID: r8lOMVCLjNdiajOd-ZPcKag-JywMxdVf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Apr 2021 18:59:13 +0800, Wan Jiabing wrote:

> struct sci_phy_proto is defined at 142nd line.
> The declaration here is unnecessary. Remove it.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: isci/phy.h: Remove unnecessary struct declaration
      https://git.kernel.org/mkp/scsi/c/8350e19658c1

-- 
Martin K. Petersen	Oracle Linux Engineering
