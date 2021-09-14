Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921A0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CB2604D1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbhINDpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:35 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38788 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238424AbhINDp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXjv7006598;
        Tue, 14 Sep 2021 03:44:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PsHIpofhYlg9+T6DbjDnpCa+apr9ok08SfUGgAzZ1nA=;
 b=MNBXhNvERcaGp6VjBYF04l/YO5XApkQetnxzWQgpn7dAEciXPfMd2TWhxdG+TTIvCAU7
 7LljeWPYoUD3/VUpXfTYZPkQXE9u4o+as5PyYBxFLexHeWBXjG90hBIia/yWCcwJS/5o
 8N13ZG0oWN0gFnqxVyUoGEMwJVvmXKVzb0FaImcZmLWH4ImrT0409PY63vfYRmhXPwYT
 YhPs1WiZZwpQASGtZRWuxd2fYf+3g6WENLX7T7g1iHZ+Pxp6Lm0qHsuKrgvqXt8zISF3
 A8BeOX8rPLpZmiX5GLUovovfTy0TzU7O3ZGYXrM9WXCaLKmyEsA2plrdA86WcjHqNLo/ Ig== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PsHIpofhYlg9+T6DbjDnpCa+apr9ok08SfUGgAzZ1nA=;
 b=aBNHaTGK+YZ1gq3AeVRASj334CZPR/CmdG/wCO/CEYMevcjcuqPJcr05EYXyxXzmhv9m
 Yg61zHY2oChOH69l44TzWJ5trFKt8h+4674CqefLBx1cyhOVvfAqPHtds/+Wz5VVTi00
 7pm0KEBPh0gP4DCe2lU8eZDOEtoknVslnhgekm3g3r622RV+80g2puLyQqwDjUMfJPzu
 lhw/rBqMAxc0HCYmbV9xZhgfkJeWmOU5QZAvjY9q/PQfxNbniJYtLth22PC0Q04jox0R
 DdPtPnPl74xbj6ff/d/AULQNoMzvNm2IaCoseYlF16paYu32dWGHzmhojfgbB/g/XRM0 WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rw0k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f7l1097788;
        Tue, 14 Sep 2021 03:44:08 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjuesry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1cD+XkPePD3alASu8kS6JDdCPAYUjDxWmDpG6md/2rJgiADok1hUTZkL0H9IEV4iz0UtYVYIgLFf/khnY7DgMOjlbsogjf8txjm7T6hKaofulTK8+qTyNt/aZHZJTjwXguOhCaFqXrfckDJJUHTirCrmNOZdOE0tj4Bug2vACUkLDpDAq4lS/wkx4AObmpJJyVSsDaCb7uEPAMM83rX1SspCQuA/IrExEKhquM5LJy6zdiL1t5nhKVLJwdSqRvVqHux5RkV8LmNNOrB06HVtUipFT55/aXM3QDEpHTwgIcKUGx+9AzDMYNq7jlqQfnyn+LSo7w16PBattD6snMYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PsHIpofhYlg9+T6DbjDnpCa+apr9ok08SfUGgAzZ1nA=;
 b=BJzM5DtXgW8mY985EQ8DV56JEtPDCTEJAV4O9VHZPl21iZWwpFPfGI0U6DQ+OCqzK2OG+BALIUmGOybA3IX73PSTb92xkuTr6zedD6r3rl825H0WHX0p17Ry2QmNiJmvcOhsIQD14rj1FOdsn/52Bd4hgTckCwl+Bc1RLUcmHryKVPlZwJb79uWOKEo5kxkC0sZ7A0n3KLfuIYwPKAqCDYb9xAAAGL1nyvWPVerSZyYrX8N/6CGGUq+FddiemA3yfLIz6SAb3himH3z7B5KU8BzZ6hwA2xQzio8qEFVyuDCqyh6feHO2DloyC2mPtZ7eCD28JX2byuuHM4mmlwmV/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsHIpofhYlg9+T6DbjDnpCa+apr9ok08SfUGgAzZ1nA=;
 b=zI/XJ/ZNwAT/WGXpS4mrViVJqUWZk2lTPSXEHmxqbV3of3zHR5Cm2MrChFiNTMJvGImiRwUMlEZfPz3CzFivP4s5mlyjqpxx9W8Z1PgfTEzfbFVqESxe3QT9L8Zjpk3mtQ+oZlwSvuGgYlqtnKE2ugCAwKJPdkPm9wkkBx8WcZA=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Fix spelling mistake "does'nt" -> "doesn't"
Date:   Mon, 13 Sep 2021 23:43:44 -0400
Message-Id: <163159094722.20733.16851858182204651885.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210826115714.11844-1-colin.king@canonical.com>
References: <20210826115714.11844-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be66a3e0-2cd8-4adf-6895-08d97731e708
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450222649BDBFFDEB41BAF3D8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rN+roy8iuovgqdVloz9cImDIBz6CdLj+q2kCIFQrH5ZKCroETpx85JGqvk6PosB8L1ipUK8hygaLLjjGXGZKEMdGQ3yC5Bgb2aZRzXTAlt7yA0z8dZOwpqk63rjjj2HmM3ndypNjclTWF1D9Xb4ktazhNkRqUGvuSrgHY0XU/HPMOEzKSFPeB/CJDwb1H+v6hLf3pVAVZwdpyiFVASacs6SCGqL7sRY1b4gXK+fSovRQwGCiIRT85Xd2BkM51pVAGASYPODsBjPSle4J8qs5VvWavqHZsGir/xEnuN9RJ7jrtPCMy77TWIYhpZMrCZNaatcFEcpwodUiKh/Rj68trLlK1AHTAihd6GL0DSF192yBrUUXkHHTQkWsq04xEG+7cK7gRs/m/PztHcTeOMPMi6NzA1uHdNnjbaNxlQ/WIsaK+bVBQ/71P4cviklGAyGOsqTzINK5D3SeAidS662KXjkwwVfBqMv0V/aIhCn2LrD6usqRRuXcq/UWMn8qwn4ces3f1TxeNdmg4ZHGjrXZ0vQjAE2Lvhv+4quiEvVmAuMHnI/8f66PYOs4zc+WlMbjT9U+8SE7jY72nliAwEBUr56zZ0cMBxoRpE61RxrCVeUrHiiNNzXBeN2AOfMjd3SPK6YIy4OvmlgCgm6ttepNT9Qjfu+hXNUQv827h4FGiKR9jOyIq3nxPamDf0mIng9CSZVSHCPXZVzPEf8myF0HoFh69nzxDHMY0bF9GMjjkFvFBtdDmUcmhz9e1+mABvMl3vKml2E2nSqo0JVtHvs9rxAg/6Z/hNJcA3FsMs6VKes=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(110136005)(38100700002)(2906002)(956004)(8676002)(36756003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amtEWGs4cTRwTVlDZDBtbm9PNnBpR0Jzcy8rUDdTcW1OdEhXc3pPcy9qR2Zm?=
 =?utf-8?B?WWJNWWlWd0Q3VllzZ2xwWjhOUUk5RUJrNHp1M1U0Yk1kWnA1Q3BSbEZ3WHFi?=
 =?utf-8?B?ODNlQXlqdjZ1bjYxZXEvbTVnYk9CWGlwb1dtWXFseDZreEFtVnNnTk1vbzdx?=
 =?utf-8?B?NjZCVVkzNnR5WHhpbmFmRGpZTytpSEZlUXdVZWQwM2JUZGFFWlJlU0VPUXoz?=
 =?utf-8?B?cTd3Qm5NYWwwT3M5UStBUjRSNWRZS0NjY3EvS1RmSXZZK2lQMUdVQVhMZWZX?=
 =?utf-8?B?YnNHUUo1NU1xS0RMSEcxMFlvY05BMTdMOTJNL21FWHNBS3JQU1VndlFEbDlN?=
 =?utf-8?B?NEtzaytJaXd4a0xpK3BqbEJSWjRQTDZ6RUo0TUFBa3JOc0hmTEI4ZlJud1lo?=
 =?utf-8?B?S1NPQzZRSm1ZaHVNOG5wOGdkSVN5bjYyU1ZRSFZ1QXNkbGp5eUZYYU1pQ3FX?=
 =?utf-8?B?NkdiRURnUmhCVGdtWGxtZkdvODBJaXExZGFRSjFyMmVYU3RWUHNEdUtQZVdW?=
 =?utf-8?B?NmNzWUdRckVxVzYxSlNZRWZIOUJ1MitCUE0xaWQyVFlKTFJUZTRaUE9RWk4w?=
 =?utf-8?B?UTVES3JuZXhDUTR2ZjhiVXVwOFRRZFI5aHVnSE9BaDhTU1RqSDlRYlZoVGMy?=
 =?utf-8?B?QjlLcWl2ZmtvRTZSYTFtb0YwS2RubGtQWHhWcFlhT2s5RDJtU2dLUHFUb1E3?=
 =?utf-8?B?T092VW5EVXZVSzg4T3pGYmtrVGR3a2J3bDA2TnlkSklmYytPSURYNDArQjVs?=
 =?utf-8?B?M1lvaVJyWUZKeDB3M0UwZWlwdGVsZkdRV3QwczFEYVZtT0FWbTBOcm4ySUts?=
 =?utf-8?B?RllWdTQ1L1ZZelF4OXRkd0xLQjVBMERMRFdRMFp3U1kyekN3bGFGM0U0MW1u?=
 =?utf-8?B?aEMzUkduZEowUGlHOFUxNTRTb3JVL04vMHhMS214eFBtY0RJLzZ4b2U4OHBp?=
 =?utf-8?B?YU5rT2pjeWFrd1dVM0JCUExPUlJ4QlN6TlRyaXpxbGVFam4xMGVBaER0ZHVT?=
 =?utf-8?B?VWNhd2VUbW40aEt3bExxellIY1dMQXBmdXJTSmFRd0N1WFVIZ3VXa1B0ZUs3?=
 =?utf-8?B?MytBNnBmd2pCY1hueXh4T011YWpwRC8rT3FTdHhHZjFOUC8vWEl5bjdGRG1G?=
 =?utf-8?B?NHNIUmJWclJqT2pLVUpHOHBMR1o0UUZkNlJRcDhIb1QwbVZXZTNrb0orVktJ?=
 =?utf-8?B?dXpzaE1aUGoxVE5oSHBnRHRUZy91blFlUExHbUhBQzJOYmhjbGR3TmdUNkYx?=
 =?utf-8?B?MjkzZWJXWEJ1ZU1aTzU4REp5VVp4Z0dvcFo1U3p1ZGRUeTd6U2MwVGdNZ1V3?=
 =?utf-8?B?b3huRFM1SmhFQVQ3YlpyQlp3Q1U3SFBObzhxZVhwMjF3L3d6c0lnUGN6K2hN?=
 =?utf-8?B?T2FySlRxbkUzQWZQc1hwU2Vscmd4VHM2blFYN3U3Y1NvdTU3d3lad1FYRUNl?=
 =?utf-8?B?WHJDMzZzbG9mK3ZJcWVHWEhVMzNZM1lqcVJvRHY5dUNnK0duOWlIbWhWZngz?=
 =?utf-8?B?M2xNSEpDQnZkUzUwVVBMb0FKL0tlWERoQ2R5TkJWS01ScDlLMHJzREJXNXBD?=
 =?utf-8?B?dFhjY084K0NFSS9GdUxSd2lmMERFcVZGR3FNRVVXSTlhWS9tZVdtQzg1OXBr?=
 =?utf-8?B?amk0bGhPWnB1eUk1eFlBM2gvbi9kdnRWSHpablUwM29uOUI5M2k1NVdFWnRz?=
 =?utf-8?B?TWVtbmxEeFVsSGFYWDNLVEtTeVA1ZnJtMHBZWXZBQkhoaXZuK252TWpUWUsy?=
 =?utf-8?Q?VvYPhJQ8/Ce66fEBfSNQKKHHNkuolkRvqjzq9oL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be66a3e0-2cd8-4adf-6895-08d97731e708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:06.4827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksa8HQW2043/UplzKfaKLMUz9fDLJtDrbjnl9rzpZaz0XqCUNqin5IY/GjriECviOyYso0rydZb2B/Cup22NZisjjHFcupCsHuImmIP3NOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: u_kRdUWeNl2uyvw4-fc_Yie5NIxTr7qm
X-Proofpoint-GUID: u_kRdUWeNl2uyvw4-fc_Yie5NIxTr7qm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 26 Aug 2021 12:57:14 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a literal string. Fix it.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: core: Fix spelling mistake "does'nt" -> "doesn't"
      https://git.kernel.org/mkp/scsi/c/e699a4e1d373

-- 
Martin K. Petersen	Oracle Linux Engineering
