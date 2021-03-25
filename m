Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EC9C433E5
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4AE061A1F
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCYDyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50332 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhCYDyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3oUTV193410;
        Thu, 25 Mar 2021 03:54:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bn1EAFc3o86TNYGtkTDIwP8Zk8Tm/Mgxb52Co0ITmj0=;
 b=viVp6MCEi+WdTl5stVQULkGuyHMhjohG1moueI1Ei/IBgnHCiSHaC975R809No49Otak
 s2ND57izN5KjchRlDfQA+BCwJGvBKtgWmOQNEkTvRNVGkK14EOa4LG7Dd4GAJQQreC5S
 3e3oVEY6VKwFVl3EqyWGNZehL56YsQRjr9I43NnONEbcCwi73b3fPmSlQMDv21M2E5Ag
 Cw9PSIBodpw/6Rh3i/zE1EifpndEatBdIxb24xLH3s/ATDtkNwlLus/rScXX/vLyVVr6
 51GXF8F20vmYfvaVqX1+9Ca5c+nJBg7n61xE6J12A46wGrExZIftqUQ44Sq7OCRtijZ8 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8frcwfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3oEDH041047;
        Thu, 25 Mar 2021 03:54:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 37dttu5j7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdYpEtQU4+CB4YjLvtioM/o5TnIKsa2wSyCNMZlnWN+XS9OxfZ3UOrH5D2bCJ6HO0E2AIBOt1Rmvde6locbPjW1R7Ao97YlV7Wv/17IJSHeaKskm18A0OS9mx0pxSSEcTRIdIQ11LwAuZO7EfYaYQkjZSzBbu6LiV9HC57hCk1H5XD/eFZNxNB7hznihMXiPiWkBayGgvoKV10I/HdtOWxIagqPcMpebkL6PEI6rC4oS6BG1iUlmG7NV4aWGp0X6QvSJgn+0JYx8z/x+poXCfM/d3z0Na5sX/A4KpaxqBgJFcfCd2p3HE0RXJdLFBQHuhfdvlWLQ4c4qyDYhhNXhtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bn1EAFc3o86TNYGtkTDIwP8Zk8Tm/Mgxb52Co0ITmj0=;
 b=EVWqmC3sZx4mA30c+tyQSVwVN7LP0Tx9h5eq2h1A54GTqxNx7iGISXVEwjgCBQFK4Pux33T95/0aD4YqgRpZyV0QZlmSuDtdomi4ocqNOw98kXudf6u99J3G935vJIBQTQynE4RtdShRkbxqmyntBrs1/OVtitJ+rZWCVJfQ+HB7FzotZdMuIM6WbeZq9SPCwEbY//665ppO3JnCIRTVdFmRQq0SXnv2K5BtVquYkLILtb0cLMxEM/KGccX3RMv0W+yqXNtz8B5c1UNcJWluhIviNvJQGs+iwJbfo+NkwLls1N0ir4VzRHUVhqRM+YCBBr41lYFZ9jKCPBeEv/IVZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bn1EAFc3o86TNYGtkTDIwP8Zk8Tm/Mgxb52Co0ITmj0=;
 b=EVPrMLv6FN9HoHPnDu9UK6aGucPI5l3+eOcU60etYKXl2CiYOwJ6C2zx8Qz1TMyIVx2njslHF4tusq1or+eGLNmGuohrPyweXTlSITN0uUmWUBkesXA+b0O5E4uihUdMrzkqOM91FzJ1hH6f5AyWHyp+htnY8w1nxHVsWzTcLh0=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:54:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:54:21 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, satishkh@cisco.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>, kartilak@cisco.com,
        sebaddel@cisco.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: fnic: Rudimentary spelling fixes throughout the file fnic_trace.c
Date:   Wed, 24 Mar 2021 23:54:02 -0400
Message-Id: <161664421197.21435.17803687728784082928.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317092240.927822-1-unixbhaskar@gmail.com>
References: <20210317092240.927822-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Thu, 25 Mar 2021 03:54:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6eadce35-9aa7-4781-dab9-08d8ef41ac33
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB477404D65972338600B9A3CE8E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCYcJsAzxBKxhcNRr00BwralguXRekxRxlEZoy81m+x8NeXdb97qqk+VYURw3T0JZ25wr/KKe4Oy9j0nqnlYD8vPYsclpuXh32LxA+eBz/IQkg5qjszLGGtUtITLaTqnTUoMHv/aP5SMTwB4qFY0sTJ2mCwAHTsZdxpkDooEZ6xJQY/koFLnWz0DFbk5wVGxQOdNxRl74u75VxnyZelPFMjPOuzq0NW76Ry+scI+g1s4yvCxhsprfFgyjKLHpDhpCmPlj5EAQl8j1O67OWOHGdNN/KjHcs++Inet2Mvhc9sObKMMX9pe5hx0X1uE5nqxxPZlwtGpWfQIHplilehVvUzSaXAZJiInazzrsEEli9GOAiwi2hoWLhwRfLX2wjSoeORXErSR8I6ZSSaExbbpkf/+bPTYhTC0ZzDSIES1+zlWZkorIYOU6hdjMheyPgLLY/33360pz9FFkdBauYv+AioJeJkRMWCupKNaHE5+Dtw5o9bY/KT7HNgjI9glBzRnRLov4QA8PQiI0zl3UgihlI3M9RDaRU0XuC1j+zs0aqsutmTyZWm9/HwvjKrkUQUMmogV7AhKIbfykt4SvUyccpIL/rkLFSDj/pgEMmIQlYmxr9w3ip3AGRIS7y6aKZ5XspcKy+PcX5+8ilN7AzP4DrSWcTDAZY2ks3KeGZKiH13janzg2IoOMvpaEiP0sLau8ZlshJn7RcqvKNC2oZplRg0vajOgQi08bEi6yuJHKwY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(4744005)(38100700001)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(66476007)(478600001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bkVaNlp4OWRoWXIxK2IyVkdLUkRkU2hOY3lSVTlrVk9SUE16R0p4WkxtZ01M?=
 =?utf-8?B?UHV0LzUwaGFVY0k2QXkxMFM1Uk5EcUxkblltK3BGWmprTlA2SS9XWDYwOHZM?=
 =?utf-8?B?NDM0T0xWdTloc2xMY1J0SEFiVUhTZi84Z3gxM0l5ZEgybFBKOG4weU5HQ3Vk?=
 =?utf-8?B?ZDN1L3Q3RHdGOElrMzQyQnF6bEVIek9yWlRySERqSUd4eDlLR0JtOXlKY1ZC?=
 =?utf-8?B?Ti94QVVHMlZNajZ4M01KN1V0THRRMDh4SVZLZ2NxOWtRL3lwTFc1NkdKbmgx?=
 =?utf-8?B?blpNODlLTU5nS2Z0T3duRUhEakFGUkxHYTM1STdmSndEN0gyK2Q2SFhYL2FO?=
 =?utf-8?B?WWdGaUNMam5FTEJvejZ0NXk0WWkxcGxTcXQwblZHRUUya3dBRlJtK2FTUjZj?=
 =?utf-8?B?UUJNWURYMGNwUmFuYXZSUEpOTzFwKzV4cTlZdXhoMllnc0RLSUpqdUlWZlhr?=
 =?utf-8?B?TEorS0pWaDVXOUkrYkd2czFYSFlyTFh6OUR4UmtRUTVXK2xaUGg5QklPb3Zm?=
 =?utf-8?B?U2JaNldJOEVGMlpsTW8yZVdwV1VNNVhkTjBrOFQ2WTdCMXBkaksvWjFBbEFk?=
 =?utf-8?B?YldtbmhZdmlGMFhxbUsxUEhYaHUwR1psSTZhbzRyOTlGVm1hdkxaTWtEUlRq?=
 =?utf-8?B?ekdGaUp5UkhtREtJb3lPalQrZ0tlcDg4ZjlUajJrVlRzNS9yaEZIbGRzVnk4?=
 =?utf-8?B?UTJSdUJnMURqTEJzTHd2Y2t2THZtRnJsWVdIM3dXWWNpd2Qxc2czMTBhanow?=
 =?utf-8?B?bUlvUThBUlZTOXZ0Q1ZEbXY4ekJVQXU2c1AvSFB0ZVFlaGNFZmxMUFJBUUtP?=
 =?utf-8?B?R252cENxbFd5TEthMEdPbitqcC9mQ2tNRi9OekxxQjBLaVh5NzlQZk1lMXNF?=
 =?utf-8?B?WmFTYlRrNzJ4aUpMMWdiVzdOUGlOUzl0ZlczVkZ2Skp2Qk00UTE4NnRMaCs2?=
 =?utf-8?B?TnJPZ2dhRSt1S0N0V0VyQ1g0OHprWnVFRWY2RG1UMnpJSUdlUkpmYStzTEcw?=
 =?utf-8?B?OXVOS25LY1h1MGNIbzMxYTZncG8wTUQyYVVsNUUwdUFHMmJtc2VCOTFTTG8w?=
 =?utf-8?B?WThYZ3p2dVg3RGwxZ1IxaFc4T0J1NDBkUEpvU1ZiL0FoWDVYYTkxK2pVY08v?=
 =?utf-8?B?dFh0cVVuOE1zaU1VVU5Hc3pqN0NkdnBiNTJNU0g5RDZrc2JobUZaLzVOcjNv?=
 =?utf-8?B?SEFMam9TRmtSQWVVNTZWVW9YNFZaemlDeGk0QVhiejNNMWVMcFg3cWE3Yks0?=
 =?utf-8?B?MStvYktCWHhnOGhESUhXdGdqdk5hZzFnZS9kbXVuUVd0bDJlZnBrWTd0UTBB?=
 =?utf-8?B?OGgycUtkN3I3UHUrVGowcTdaN25jTDlLME1GZ2kySUk0WEZTOXd4eU1PTTVn?=
 =?utf-8?B?ZXN3Z3NuZ2g4VjRTVkZmcFR1aGxaZ2hlcjlKcThqbDZRa1REVzNsQjkwS3Qy?=
 =?utf-8?B?U01paEFLSEo4WTZjWmV6KzhZbzNId3VHYTBaWlMrWk5oV29UWC9qZHYrWmhL?=
 =?utf-8?B?Z0l6dTdWbCtyZ296SWJDSk8reURCVi9CZkpZTkFVdkg2NjJFZlA5bDlEbUhI?=
 =?utf-8?B?aGdOT01CcVI5a1E4WVF1cTFSTmRkR0ZWRUpsN01mWlVYMS9RWWE4bEdtcHpK?=
 =?utf-8?B?TnRIbDZaYzBzR0MweXJLK3MzMjFBa0NSOUJ4bVplYWc1U2V4c3ZCeUhDK3BN?=
 =?utf-8?B?YUhhWVBjaUNiang4N0lhZ2dUMjZwN2pjb2ZOS0VENVJXVUh2LzAwdlFFRGZZ?=
 =?utf-8?Q?dd+544Z8wc3Tr1qKLOflv0Pm/42R3OS4uZF/pF6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eadce35-9aa7-4781-dab9-08d8ef41ac33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:54:21.6286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcTjcg1bCIyJgZwTyOAYAG9QSlte50usZ65r/1l3lfCsATfIysHLkzXoe6BMzUUkQ75C6Rg2ANqQ5uvL1FvrgGtFH0MEXMGqXxwQAUir0qU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Mar 2021 14:52:40 +0530, Bhaskar Chowdhury wrote:

> Rudimentary typo fixes throughout the file.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: fnic: Rudimentary spelling fixes throughout the file fnic_trace.c
      https://git.kernel.org/mkp/scsi/c/bcf064bc2a3b

-- 
Martin K. Petersen	Oracle Linux Engineering
