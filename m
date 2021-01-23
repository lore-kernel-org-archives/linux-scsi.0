Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0174C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEAE23A74
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAWEX3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:23:29 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54606 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbhAWEXX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:23:23 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4FeJY164764;
        Sat, 23 Jan 2021 04:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YSvg8trM9ZJUYRTX72ZC+O2cI8LH6wYu4U5yFukEvJ0=;
 b=NHMyTP/4s5VICb6rNumTgV0cEuP5ovdOYXPvB26cRBwsWhrBORtjELuqH7zuObc3E9Yw
 Tw8+60bQauSpco6kHhKBiONE5hSbOQ5f/hudUzAZeSfqS6AmYZYrUB0jEoWM6oCjAa4O
 cQ99kGDcjyeRWu6oP4nVPi3tA4pRpRJB4fBa0gsUGKfCTeY+HE2kYhSLqrO/ZXKYaIdL
 ZbVS1GstMsZlzquuxYTSf9hNpxwI4qtxmnPzt3IKuWhb4WqREcCymknunORH7Suk9KIv
 NI559nWIJk3RrMaBj28MbyEtfUvGQdakpVHHQofldBU7HO9oqPLtbG4QP7UJ/plyCGDY Sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aa8a55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4K8Wb174213;
        Sat, 23 Jan 2021 04:22:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 368bm0s8qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0kiHgJwXErzKmfF+S18QwJUiwwMQMoaJF0c6fAELIBN0seaP86/CQ7Ia03ekfXcKU8B/FQezMA/4lEd+UOLdIeFA+4ih5f5qTfUuPmpW1th66pKr1XI8Pt3d3lLXkfu0jv/UapuaWPbZN0N+NZi0fR6y6lFtYh7uaP1vDB4OQSXBZ29LmJ2deFfw3Xdb/2UkApoUTPuygctHfipj+TL86tbbE61Xd1+UOgYPEpA+Evct011a/KJCj/mwwVjneVcYpecBRiC30KDyilFodtJ2IpCcwL8JT8oOaUTb/30yZVniDBe3G4oQvHjHmCD5IEEJL1U8XmcBWxz4Wya9anVbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSvg8trM9ZJUYRTX72ZC+O2cI8LH6wYu4U5yFukEvJ0=;
 b=bEDIDCVUX1ImswAlpYdPtCd7mjBZ3zQ0sMPmhJUcfUp5o+ZFIuQxEAE5xDtivfU98v6zAzZwxkM2hUgtzGkEPKXIo7/C53ZODG4LpHeXW5WgEduMqRL5YrH6d1tX8oMRPg+bEc6Yc2fms34u0aCcFVRUsl6leWDbdsFN28LHFeSg8bzXzeIaQ53HDNBQ+9c84yCU86UouJPQG+YZs8hJh8n1kO0u7SEwz9qirqm49oNA0SgxRxguK84Rz/35iIo1asIm9Hr1IuMNgOUGn18DjwaVufyXA9pQUXcwvSbXvAqBnsApUVjYs1acViB9ZGXx7Ybu02bkmjVAZ+OQ3mnmrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSvg8trM9ZJUYRTX72ZC+O2cI8LH6wYu4U5yFukEvJ0=;
 b=dRCtMm00vCmMOBI8CeXivCH9B8GdNBhRMzlh06oXORVVhVWVhLYCUDiEyM9M+oL+rnzo+bLPN7wOQqeVTg9UC5oeEf2dDy+kkxOYjCSsP4HtomIuPYHjEelIw0lK+Z+oU8tW6ywYGVHSK6r6QEEuNj8O4V7G4c+FDDP3UwwD8Lc=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        beanhuo@micron.com, jejb@linux.ibm.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org, avri.altman@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: delete redundant if statement in ufshcd_intr()
Date:   Fri, 22 Jan 2021 23:22:07 -0500
Message-Id: <161136635066.28733.9013495886838267314.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118201233.3043-1-huobean@gmail.com>
References: <20210118201233.3043-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4975d51-acdc-4967-0de6-08d8bf567c4a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439B03E94681A451BCBCE088EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ey4r+PASm4XmQ9R2q//IgF2qHdrh26CQDwRXXkqPSiwr6r//hSz175J9tfV0JlJ6g5xrB2poypGAZcMtUiJQJeW7oZuJtNbX+d0CGnRsDQy0Md/eiE46sR2c/mXmkZa5aMQhpogNv8J9FllmNUs3y9ZjogaRIcN4g3DZr74f+b6hg1c8RAnnBylZ0mxbdSdtaCIP0pjJzeqJJ85X5Muw999G4ieRMVXWFRe6E+r6PgSH7S4bBeh1J1sdUpkuNsx0H86Yq+MdtJIlbA8kBF4Bk1rRKBJ/Rgt7rKAXr138EQZrH5ecmupxTJXHsY5Q7TVN1BlgwH6BM49Y03xVDzHzq15NlmWcG9Etsd3OUDOQA95e2mTMHoz9BuVdgBGdjAtGa++ViDd43YKWUgLgPpR3NRIg1Q3wPwzw/CTNd84dS5E8M0HVTZyLoLEDteobxlTrqpQd5oX/4LXwkE6MBXmPciT5cwgSVBmwtoNrbOwA7TKN29Xt39GpuV4megMDnG2kEh6NgDBOIQwq9eGhvNz8kA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(6486002)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(4744005)(86362001)(103116003)(966005)(83380400001)(66946007)(921005)(2906002)(66556008)(26005)(8936002)(7416002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1hTU3N3K2Ryb3B0UTJjUjM0ekFDTTM1Um5CV0tzQ1I4OXdjRUpld1VGTGRl?=
 =?utf-8?B?ZklpOXlwMno1K0xRYUxxSFJWangvdGZwV3dQTzVBblBod3NxRWdNV0dqb3JV?=
 =?utf-8?B?aFZPRHNjenlIOXRKa0Q2R3hZT2g3alRnMTlTTnllSDFpcjEzTENRNlV1RVdX?=
 =?utf-8?B?YmVVRDEyaTRZWUYvUGR4Z2lBUHVNYVQxTlJvaThWTFMyOHZMbWlOZ3VxaFQ5?=
 =?utf-8?B?YmJsRXJXY1ZzZk5ta0FpUGFNR05mUmFsUzBZRjV1RTBpVmtRSXFpaFdmTnVC?=
 =?utf-8?B?QUZJWWI0SEtDSm5hRi91T2t6UFJhZmpYdkJ2MFpjM1JqS29UQmpGSFVkc0tX?=
 =?utf-8?B?Z2ZJaTJRZDZqRXZadW1saktqTWxPTWxyVFE3OWhJbWZKRnVGaVB4MG5Nek03?=
 =?utf-8?B?NGlwdFh3anBQaWNnRTVzd1lpUU1FZXB5QTMrdjdNbmIweWJmNkpwVG5PUmVQ?=
 =?utf-8?B?Y052anpFY1RtZGFVMVVlem1sNGtydk0yRTRFN29VTk8zSWFaOGJXdG83L2Vh?=
 =?utf-8?B?RWlITGUzWHZZRUl5bnZyMGdpZkFmNzR5MUQ0UzlnSkhhZis1MXphbTk2NmIv?=
 =?utf-8?B?MDlXSkNRYTZOSFpOQzZUZDFJV2liZWJhMGN4K0ZHaTF0REgyZ0Yrd3dlK1ND?=
 =?utf-8?B?MEtrd29maFZwTlBaMUtob2ROMGJZb0lVeU5xaDRiazljRVhTUVNkOE5vR1V5?=
 =?utf-8?B?dk5oVmJ2bTRtdnBMUUpYM1I1OVVFTW1ydGlCNDRDbjFKUjc4WE9qMWprSEhY?=
 =?utf-8?B?K0l1ME4xOVh5Y0VIZ1BYZkNXS1FzUTJRWmJOTFdJVlhTODF3b2JSZk50QlFV?=
 =?utf-8?B?eThQanU3d3NKaFphNXdpYXlaZiswSUpUWkNjdlZXazBHSDB2SEJ3VHRpWEhO?=
 =?utf-8?B?a0JhYjBnaVlRVk1ZalVhMnh1ZVdlSUwvNCtVSVFGd2o2S0lZZXJUZDZnbDds?=
 =?utf-8?B?V0dpcWxpWElYV0loeXdjZ2JubkxhVUpNUXNUTzBuNWE0ZWJvVFhTenRKQUZl?=
 =?utf-8?B?YU5KSHBjT01QZDE4bkJOMFRheTNtVmhwNzFtUXFFZlQ2ZkN4LzF3YVJoSUZj?=
 =?utf-8?B?aHEybEdZR2ZZeDNWQXVVclgzcE5NZWw1aVBneXdhaWNMcEdVVXNZSHhJNFpi?=
 =?utf-8?B?QVhJVm00L3ZPV3pQbVZRVzFQNjJwT09UdDdWZmp3TXhJN3c1aTgwczVNR2Nw?=
 =?utf-8?B?aGRiSlo1UWdESlVIUDRpcVZwQlN1NDBzTjlELzhGdG4zbVhCNjhxamdnYmVP?=
 =?utf-8?B?c3VYR2RlOEg3VXAra0V6Si9sTnlkblhWSXFFYkFNSDJOTXNkRHE5UnF4RUtU?=
 =?utf-8?B?d3F5SXFhM1pBMkRaZk1MTXZhMDRTUHZRdFR1cXJlRDR0UTY5Sjd1M1hJaHNY?=
 =?utf-8?B?ZHpvczRWWEJHNXpYV1BxNUhnT3g0UUhmcEtFTVdFZzUwQUZIZTRzSEtBa2JP?=
 =?utf-8?Q?JSyIZgi1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4975d51-acdc-4967-0de6-08d8bf567c4a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:25.0347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjUPqrewnOwNo4zbpEpNayjS0fKyTypdN8pdUNkW33zP7aB8ZFf/M2iTNccSg38yvQhJ4BEmScnHaqm4X2NEwmOeqsOmSqDXg4+/x4s9JEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jan 2021 21:12:33 +0100, Bean Huo wrote:

> Once going into while-do loop, intr_status is already true,
> this if-statement is redundant, remove it.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: delete redundant if statement in ufshcd_intr()
      https://git.kernel.org/mkp/scsi/c/60ec37555d05

-- 
Martin K. Petersen	Oracle Linux Engineering
