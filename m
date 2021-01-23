Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB0CC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C4C42376F
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhAWEZZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:25:25 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55816 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbhAWEZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:25:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4FOHt164646;
        Sat, 23 Jan 2021 04:24:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3KNGCD+0TPcblj/CjDACWjqFg4Yzf3Eew9Tebe2Q9Nk=;
 b=HRA0lrAsMagsWwKMsjzsEhnEwjbQddm3aLSbazB8gPLCvr2wnI5aPvnHQ8jFqSJPlSzV
 zkra4+faJblNPDDJITPvMylVDwP/KCRimnwlGDDvx8sAgrJATdIGblRDBmmJfQQ0DHwh
 miRx9x1TH9dEdlevRjOR5jwZjoHy6ELmgEYuBJUSP6RiKu2Wkv8vQfayieZyLLEH1Qo7
 CaevU7l6orDYF5Djb7TwYYbmYU7S8NpX3v5kExbnMh3bwHNtIfvjQVdYf628rXZuXEqU
 Lt9Ia1gIz0tVqpkTofFWzaZHvatgu+/yNWXHDzIQDRenFzeF5J6hSJfoQgl8INhjNB0x zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aa8a70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:24:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4KnPx078460;
        Sat, 23 Jan 2021 04:22:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 3689u8v0qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0pw11jVZsg77Fd14uTiXkL1HbC7P8hkAtJR+s9Ie1Ws9xTnV2iDWsMbt4EfgxHrW1FiyqKDRf5qKzy4JbDRf765CIZ4+gZJNeY4nw4fDnTFnVN2YkAuD1O5NRWXsl25xQNuTPPA0zzMn5MgIxAtfPdvCsGNqRaAjwRRFkt25L1FsEB5Im0qyBYeVmB+81cngPZ63W3/SMpBgc3+MJ9DTTY+MSclHWpRdO7ih9NFCQJ8H8VWURUIAeKdGzSe5RMtuWO4uqo/u53bMmTnGJo78uaN7xrmMXTFheHjGc3H6HINxuaOKXxEFdPmBniQoRKwUAHOYRVmLNIAh3FHSNoXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KNGCD+0TPcblj/CjDACWjqFg4Yzf3Eew9Tebe2Q9Nk=;
 b=dSQ9ygVa5YgHDC435MSKQbksYfY27UFX6mV87GddPq5bt0owQWPAxlZ4Q8H+YWBSspnr41aWYOAjgK63SbUqMbDrBJDa9XdVU54sQjBjegqleHDR9cmb3Ha+Q8m9swwp7o8YAsN38cL/H/HhyKCHOJ811ToP88CBqkHCLA4jKVz4lOJNJ4xhMGuORQpx6nUkmqD7wpxkK+il2+ex5ituy01/EQIfOCcG5R+OR3WjNsuBc9i1Vp3iNmkWvCMKdDfEI71vBxXECU6Zt4PWf2msXpc9BEGF95SxILOkI5iK9hPEPURyoX5Jf1IlRw1BSoVuO+HkzA2iT2ZOHwSsFfS0Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KNGCD+0TPcblj/CjDACWjqFg4Yzf3Eew9Tebe2Q9Nk=;
 b=dkQE1SR9wmPCnhTkQaooRMV87+2zv2MlOPy0eB1zXj659LWh5hGEK0qPxNhENAcg6k7JvUD0Uau6HkGK8WXFDeTzE6Uu0LqETbCSEtXEx1xhVmCj0PcxC80EGzYbcXXvh3f5C0+wFHB3Xp+GHMq+r3lAPUgqKtrGgNkWBS9a9wU=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     asutoshd@codeaurora.org, hy50.seo@samsung.com,
        bhoon95.kim@samsung.com, grant.jung@samsung.com,
        sc.suh@samsung.com, sh425.lee@samsung.com, alim.akhtar@samsung.com,
        beanhuo@micron.com, jejb@linux.ibm.com, bvanassche@acm.org,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v6 0/2] introduce a quirk to allow only page-aligned sg entries
Date:   Fri, 22 Jan 2021 23:22:09 -0500
Message-Id: <161136635066.28733.7952181879884488320.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611026909.git.kwmad.kim@samsung.com>
References: <CGME20210119034502epcas2p1b78378690bcbdc6453f657a3379ab90a@epcas2p1.samsung.com> <cover.1611026909.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32badef9-a226-4248-8c30-08d8bf567fff
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439FF433D4F5F70D850E24D8EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zh/OOpt/5P3QIKGNSEZ5lkD1/+qjoF2NC3VmHZOHKPxuD+O1xbvTm8vRnVN66RsN4dqf8pCMlaQZVCrZUqQ7d60JIn+F7PBrXuzfpb6NqB1QMCZ3lOYMaFY6DR+sF2c/ypWusW6mB0ngHhDM6YiS+8ItSMCmny6U6UeM4SjW6XMsBp1HHLGAwg1YQ4D45UnoPXyR5ir1vyPhDyA1IGamtVrWy/ysnxpy9QDFmzZxfUXWfCwtOhyXwSjkbiWti37//LPI0T3dZCefu2svYPHvQ45kkI1B+AnzQcg7PdMYtAh9obDF5IEZuf0R4V+tI9ATdG9uQzIaxIx7t/PW+7IZ16TFIXZ4bWrE4I2g28e5xliwqY3erXyElLFbIbuB8Yf2xKGhPEjrVEiE9Y9Kg2zcohOkAFh3uJCqia5cNKqEAOH5rOnP/vHvW7kPLfRPhB3Wh7QQGXn//s6MQmqH1nXoDjKK4vrFd1TTrUQ50HngQerAHjgjQwGa/AiuuNiDTMjlInJeoW4rFnqvQnfIkMZHVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(107886003)(6486002)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(4744005)(6916009)(86362001)(103116003)(966005)(66946007)(921005)(2906002)(66556008)(26005)(8936002)(7416002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q25UUUN0ZDlwV0htbGw1YjZYQXRwUmdxbm5CcklQY0wvL3d3M1paTStlU00r?=
 =?utf-8?B?eTNMNzE3Q3pqN3c5Smd3cGRrcUs1T1E0bDBNOVQrNml0bzJuSTc0Z0lEWkZu?=
 =?utf-8?B?cDFJeTJPWkpFM3pKb0lWSGhFdnNpT1phS3JYRFY0bHhGSGRJaDFTazBSTk51?=
 =?utf-8?B?RlIzTEZZRTd2WXFPbURBcjhqeWZwWjFJeE5XbGttNXc4TUtoKzZrYlVqb3Qv?=
 =?utf-8?B?cjE4Z3FZYndFMWdzNldYTTExR0lMZVBGN25mUEFpM21wMFJqNmFMNUJYdzlI?=
 =?utf-8?B?eUNkTCtIc0w3My9xWUM3bG8rdi9RV0pXcndsa205bkpOQ3h2UmZ0RSsvYWY1?=
 =?utf-8?B?STQwWG1xZld0dTE0VzVMTzhkclZPZEE3Q0pHRFRYSGdGSzhySzE5N0MzS081?=
 =?utf-8?B?b0lJS2NkS1ZsQmxndFV4Mks2aVh6bTZ4ME5FeStpclpXVUl2NHhDZnVFRnJB?=
 =?utf-8?B?YkQvMDJwSUtCKzRsQ3pqWFNQMVdia1JFV0hCS0s5VkRRSlFrcWNLQzJ1RGZj?=
 =?utf-8?B?cWwwc3YwYTdkZ1dIUzJvdXd5N2hDdjdlTUtQbGo5czJMUFFpRC9nS29TbVlO?=
 =?utf-8?B?bGphQnVRSzBRM1NHd3FUWGZ6eVlTcHJkTjlLZllMeDFweGMxaHlSS0lFbXp4?=
 =?utf-8?B?U0JndG0yZkRzSEs2aVRkTUtJbUZFT1VrV1JXMkxMYU4rdzZqSW1xa2JnK3R2?=
 =?utf-8?B?RS9Fc2U0OFYvMmg2L0RVU2RPMmZhcVR1TG5hT0Z0ZFZreUdLS2VWOUFSREhq?=
 =?utf-8?B?dnlHUG9ZQ2plc3FUdU8vQVROcS9NOXlqdVhmdjNjakRnWnVmWmZySjh6L3ZH?=
 =?utf-8?B?bThyS1RFL0ZjYjlkTGFvdVdiNFpaZkNqbVJSSURQcmx6YUFkUmd5Vm1xeTc0?=
 =?utf-8?B?SVA4ZzIvRHBWN1RSV3dzR1BJRndFSXhuQWtubjlGWDBaNXBsTndQZWpicmR5?=
 =?utf-8?B?VlAreVdnUDdtZWJDNDNURmZJa3ZEaGoyTVJQTGFhWkpsNHZuRC9LY2NPMFBD?=
 =?utf-8?B?M0RUQ1RWdE1YUXRRaXFJbkJQZElHQWVza0ltVFRyemlscjV5RVpHencyRGhy?=
 =?utf-8?B?U2I3R1V1VVcyWmVKRWMxN1hpMjBHNEt2M2phU2pUckRnS1dXQ0w4THRraTF0?=
 =?utf-8?B?eEc1cDlBcnI3ZEQxV0lTOWVab0kwZ1gyVXBrc0VtRFBQYUFDR2t0WE9PRHoz?=
 =?utf-8?B?T2FCR2ZMcWdaNk5VNllObWQyNElUamlxNmRkUUJnSmdqTXpZdG1HRmR5QU1t?=
 =?utf-8?B?bFVmZW1FSDdDdDg0VnBrWDNMd1VMUXlPampDbUxycEkyN0FzTCsyWDNzelRV?=
 =?utf-8?B?Rk90dlQ2ZHdDd1VZbjUwRTZremJJRm1uT1F0aGtnS2Q2Zmp6MUYvV3VwQ3VD?=
 =?utf-8?B?WVliT2E0VHpTRU51bm5SUTc1S2pqNnhRa01OSGtjaWVOaFByQ0ZPdGtkdkN3?=
 =?utf-8?Q?5SNSxDGH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32badef9-a226-4248-8c30-08d8bf567fff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:31.1070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+XX/l37uSkNmRp+E9RThApxuRLUaw6ze6nfhts/jCDuCVYJ1UK1BcRgqdqH2ja+WweQoiQeuquv/WtiIZsIZptkkOEVVntibzIn0Es0k5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0
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

On Tue, 19 Jan 2021 12:33:40 +0900, Kiwoong Kim wrote:

> v5 -> v6: replace the way with using a quirk
> v4 -> v5: collect received tags
> v3 -> v4: fix some typos
> v2 -> v3: rename exynos functions
> v1 -> v2: rename the vops and fix some typos
> 
> Kiwoong Kim (2):
>   ufs: introduce a quirk to allow only page-aligned sg entries
>   ufs: ufs-exynos: use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] ufs: introduce a quirk to allow only page-aligned sg entries
      https://git.kernel.org/mkp/scsi/c/2b2bfc8aa519
[2/2] ufs: ufs-exynos: use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE
      https://git.kernel.org/mkp/scsi/c/f1ef9047aaab

-- 
Martin K. Petersen	Oracle Linux Engineering
