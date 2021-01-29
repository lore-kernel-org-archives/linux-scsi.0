Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71629C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BFAD64DFB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbhA2TEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:04:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54696 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhA2TED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:04:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ00DF086619;
        Fri, 29 Jan 2021 19:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/DATS+vF32u9VdTaNzv3WTwMTPck1lhy90JWI/IT9v0=;
 b=jOLtonlDCAsSziljjUg5ScXyPuJDmnOYrFzt/2SWlH1TCqflGobuDjUj+1SzZfKGpCRU
 k+em7KcCqO/IgawH/rDwTBSBS4CM7cLnhT2giNDT4L6NFot173cgAs2D0ZCP68prz32z
 R1bRYi2wlnVfOUaa1/ECZd/X5kvzZK1HK7aZc5ji9CT9bQv9jsn9EqLLuk5mILvTcuZ3
 +CYA0Z1BsvcE8W+EHq2X7Yhszpxh9Qef1ZNv7PPQxg0zNxUfFHxAyXKRhkfUouHgCUwz
 BBxPyTxWPbSN+OuXEUMI+IJAVN0a5wXTiTx/0w3Uxk3PjULoCIltmDDnaOBSsrV1mArZ Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7rauva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJ0ih0052883;
        Fri, 29 Jan 2021 19:02:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 36ceug9nrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5P9uHMEz8xU9ptdqstysLayN8ow1FBS0q+GGMVZbe5PJ2A5Qnm86ONQw926JItZ4x7HNgsfv/0kB5XKY56D5eJFRRiEOCHpOT2kuekAE6m054XbFTe3rL4oZWA1pvMG934Wjx4AsGcLK/kVIQsDskjoKp3U6GxgaCy2jp2t8fG9tDQM+y8McHV4Mtwu/VwZXqK8Jnhddjt5lKkDRgLjkJfMv/T0t5xURsbkKXevtAQ2HWHqlDHu+llkdnsKvw5gsJjSs8S43J1kASRtRvh/49G6+wqn9nzTmdEBGS73X+XPGzofIhf2IYJsisNJN8MHbNxktjvcNSh9RS093tlH9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DATS+vF32u9VdTaNzv3WTwMTPck1lhy90JWI/IT9v0=;
 b=kdrSAgd2JCRQ94BltjIC3M+UR6vGPTSYA4rkH4sROH1Cr3nqR1MclP5rC3ZFQQlSJ2JSyt5yvS3yp/vNgwcRqsFDQiMZZg/b7FkSjdg+E3QOsxP7bTmtLqjLePaJM3AdVaWRZ3S7KbDI7P0uLqI9vJi3/SXFt1KOwmVaGcUSIfFV30IOnD4ReKHxQPuN46osAsLKFPKpT5eUEgXSiOwdD9QcDFLu1xkZJTTZtpWilgGm9CHC1r9l0xzWKVywAz0qDw4dTT5xBq1pmBeuHbHz3tkeEp5bmT+2JTUT7nIqVtzD4gEhdsBrPHdqhAXj57v0Tv9DgixDQ+Mv1u9sUJo2yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DATS+vF32u9VdTaNzv3WTwMTPck1lhy90JWI/IT9v0=;
 b=v0JPetPH140292ZTDIy2rNvLr28wL9FwKEWqi2B9VEMuuBTtvOdjABPPBnk8fpZmcdYRxJ+rHPmZOKuZdMiPsOazFy4FsZ2e5J6dETbJBcbvI46f8Lt22ei4gtiaz78ACyGJkss9CCI23zdmL/xsTjadY+0De5GkLO95OamWrYA=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:02:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:02:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] hisi_sas: More misc patches
Date:   Fri, 29 Jan 2021 14:01:52 -0500
Message-Id: <161194526371.12948.11419081129005645950.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
References: <1611659068-131975-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:02:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1fd4386-c033-4adc-29f7-08d8c488606d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46775F586FAFEAA9934581718EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: peUDXNxhvSTWHMH3s3zO2sz+gB6qpVZlvg+ypBtruQYu1G+s9eo5uJyWxmjNEiBVwXATX+yMho4hDTHymRhDoN2tBooizsMcMd0SIDmhEh6oESsinbouHUxyCV4A0oWfRhvQE85CG6Pd0dci1XFk4hvcReVoLIzyJQhX+UDMeJVp5NlxkVOVfoUCxenfx2Xn/kLcdq+6ytkAny+krA7XkR2LdcRiex7u9pyKHcaxAxmW1PuH8AeTqtepY/ObJ3WD1e4pnz/0ERanTO0LwtWxbo+J+ogpmysMhSM0gHNrnjGKqO+StQGAq9Gh0/PS0KkgJUTNsa0nwX07hxbqSWefjnIKoSlYEXQa1XQRld/HCfzXCrq5kkm+wE6Sq5Ok+X6oj52v48rc+vLagzWROM9d7zftbA2mNqdt87YWAjfA4PdlVAUNOmy2tYUxdQtGZKTxbKCaNGse0iPqRVOGslXXe0nE3K1aJ/0ozTpVZhc/q72Baee7jDo++2ubJFRzXs7mcTbsREYTSv1mZ51rd5rxPFFEev6KGy3NxSjS5EInElwwWkr5+EOX+6F7Sin/JBcxUasiC8fE3c6cNItztwwrDtwiPh41+T6NHWP8BuV5RSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(66476007)(2616005)(26005)(52116002)(66946007)(316002)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(83380400001)(7696005)(6916009)(478600001)(86362001)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SnRPaFE0RXA5UE5mQVFUb0F2SWQ5QlJzNXdxVW1GM0JVQStSK3lZL3RDNGhp?=
 =?utf-8?B?eEpqbmZBUm9HYnY1ajluQUV2ZEFkNzdTcjJFQjR0bHNCUUJ3b1BUMjZNM05a?=
 =?utf-8?B?SUx5UzNKSzBEdjdkYkFNUEVSNU9DWUlDYjExcXVwK2VMWkZvV3NqNW1MbEdR?=
 =?utf-8?B?b09HaHhtNW15cWE4SXp6NExuTElDMzFrM1BndG9lSXJkeGFoRGNRZVZOdUpH?=
 =?utf-8?B?TmY5eFFaNXgrVGNQaWx4Wmd1NnNNUnpmSjJXZFZWSCtHUUNwenpIdkJhMzNi?=
 =?utf-8?B?YVdhSDI5N21TUll4c25zNG9BQkE0V0lBNkYvOWpwdWNjZksrNHg2MmJBSVho?=
 =?utf-8?B?bEU3R1JjM0puODdZUWsrRmt6RHhTMkFWSkVPR1JUWTNYcUNCTzNCQmVSTGNK?=
 =?utf-8?B?d2taUFdsNFRKc25iT1JyeGxrNk5ocVkrbFBTTXhkV0k1WklCQVg4REE1VzZM?=
 =?utf-8?B?Z3JGWkFzNDRKeEdxYXRSaitEQUJLQ2VTTVlNb0dRUy85Rm5DWWZsaXFYdmMz?=
 =?utf-8?B?YjhkZTZ2Z0x3WG9OeDVEOWEvSkZlNDAzeExXYitTQ0NLRWQyeFF0ODJCNUMv?=
 =?utf-8?B?WDZibzBmQmlRUDlCRTYwV3FZSytZMjJYamVxRzk1Yk9BK283L2NWRzZtaDYx?=
 =?utf-8?B?bWsrQk80WE9XWUJTOWdydll0TTJRazF0czFqOTUxRGw1WGRCbVdLMk1ZeUlm?=
 =?utf-8?B?QXk2ZUZQdEdGUktyWks5S0RaclorRGdVaGl6QTd1Zmk1ekhRU0o5QUpRNC9H?=
 =?utf-8?B?WFJsMGlxQm5Mc2wzSjhKSDF3Ry9xWEd2NzhsT2hWcHFpRGxIeHZQd3NITWVv?=
 =?utf-8?B?OHVSQzl1amx3R0NZV3ZKMWRScGdMSm4zNUZjM0hpK2RTYnJmOVRkTE1IdWhE?=
 =?utf-8?B?VWJXaWVWMjlPa1FxMnl2dHdIZVdTczJkNWpUcGIwd2N0d1hXbDZSVHp1UENN?=
 =?utf-8?B?WEhibWRCQ3FIQ0NJcVYrQVJVWlBKRzBlemRXMng3cHM2STJ5dU8xRmVvVEoy?=
 =?utf-8?B?K2R6MlVtR0w1NVBHR1Y2cHhpUCtURlpCQkFjdVJQYnN5WUd5SGxJeGU5UmI5?=
 =?utf-8?B?QmNFNkVyc3pRcUVYc0Z6UXhyUTB4ekxPZktIZnJEeDREVzdxWGg0THlTd2Jk?=
 =?utf-8?B?TG5jTjQzM09nTmdWY0I4TFV1MCttQUZlclp5allFdGRkUEh4aEhmRWNWR1Nz?=
 =?utf-8?B?YmFyU3JWV01YZ1QxNFpTOWNzMmNxSThoQitDaHZRV0h5dFFnUXIzTll6Ymd0?=
 =?utf-8?B?SmlxMWppNW9ZWStNODg4Rmk3NHY4Q0U0RE5NQjhSblBJNlBwZzRTVFVZTFNz?=
 =?utf-8?B?UEhxS2tkbGtnbkFvOFhQbXViVHR4NjdFQml3b2daTjdSbkFVcmozNlllWktx?=
 =?utf-8?B?ekphWFhJUGhmNjJ4dGZacVozcFp2bW05eDFWZk1CSWhud3ZLek9xcGVDc0Vs?=
 =?utf-8?Q?1Fpd4FMp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fd4386-c033-4adc-29f7-08d8c488606d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:02:08.7697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Op6Y6jJkv3a+afEilEPTlAIK7PDQ049wH3keyarmMO5ct+DGUfO4CaonGFahAo/HQ03QBgGpbKfWRZmuI2gpAY2b8L6kkkxuy5+v9Bo4d5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 26 Jan 2021 19:04:23 +0800, John Garry wrote:

> This is a collection of misc patches picked up during the latest dev
> cycle, targeted at 5.12 .
> 
> Features include:
> - Some tidy-up from after recent change to expose HW queues on v2 HW
> - Add trace FIFO DFX debugfs support
> - Flush wq for driver removal
> - Add ability to enable debugfs support as a kernel config option
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/5] scsi: hisi_sas: Remove deferred probe check in hisi_sas_v2_probe()
      https://git.kernel.org/mkp/scsi/c/4d287d8bae1f
[2/5] scsi: hisi_sas: Don't check .nr_hw_queues in hisi_sas_task_prep()
      https://git.kernel.org/mkp/scsi/c/69bfa5fd7b44
[3/5] scsi: hisi_sas: Enable debugfs support by default
      https://git.kernel.org/mkp/scsi/c/1dbe61bf7d76
[4/5] scsi: hisi_sas: Flush workqueue in hisi_sas_v3_remove()
      https://git.kernel.org/mkp/scsi/c/6834ec8b23c3
[5/5] scsi: hisi_sas: Add trace FIFO debugfs support
      https://git.kernel.org/mkp/scsi/c/cd96fe600cc4

-- 
Martin K. Petersen	Oracle Linux Engineering
