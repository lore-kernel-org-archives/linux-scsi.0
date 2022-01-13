Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562E8C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jan 2022 01:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiAMBUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jan 2022 20:20:43 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8132 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbiAMBUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jan 2022 20:20:39 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20D0UP0F011379;
        Thu, 13 Jan 2022 01:20:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tw8K8OCaWhOojgY5+Xmitc7eQlMq1B7DuKDUQygojIk=;
 b=C3XiA6WqCdl6NXglH/XqB00FVcfJiqP6JEsiRMEgYAbB+4xVGZ3bEUuqv0+5NNO5NRh6
 mcerXCDDVtjPyYCyox1x4mz5XzEKz4kjqa5sgjX9LLWDIA3EZbwQ73NNe70nAtf2avrN
 F3Rt9XTjoC/5ikBmnTajjvIvxJQ/wfjvdl3vO8edu/94dppY7TljIWOWYahf7lN3jBcT
 8puFU9nxLcdhrTHOtgliFHjlgZFmYjRFGcAY/zZ4LhPWbqLex7mLsWUcixJ16u6Q9fcK
 WZo/cPwwnnLeIOA8QLv6NnIeyshi0hcIyuqaLEIUwyMJnkE5AF9JWIArHkXYQkMff/wi 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgn74frt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 01:20:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20D1A4jE176381;
        Thu, 13 Jan 2022 01:20:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by aserp3020.oracle.com with ESMTP id 3df2e74rs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 01:20:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1+wKPMKfmOyH+Rze5xa2R53vcHrpWNjWcP6o54ZZtCymv/KtpA3F7baeMFGx+DzjB8yp+maj1c/0UrWf6g1qBylqE4weRXyKOPbC4YN5jxiPsFrmZfw8rJoSxB7cRHaSk8XdIuXhRjG20UDl+pbtlt3y6pE1XuFND5Gw5hcQP4GL2/I2Q7163Uv4ye+2o0BusCSjXWcs4mPPGPjik4cR9VmRieJojwA2RJqvs1rI/6Jk1/AB9B+yfLxmY8Bxj6+/M3XE7v1Wl2XlBED7WSMFcL0COulE6PGkrAnqpOQ5WXMFAs9UKeXbt30Dd9PeiyBnuNfYm0tKvfrVVQJUB0IjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tw8K8OCaWhOojgY5+Xmitc7eQlMq1B7DuKDUQygojIk=;
 b=jqsSTaq8CkFqIupo7atsgNwLqbyNgOyLu+X24QhuOZXFaYQr7PBbumpJAJBmPp1R0vMHCDm6kk0ZLF+bLZS13wzeU+LpWP/gIPH0VNRxsCa4E89d1TaipEUaCHzImo3OQLIxDjqLyt8wn3iw0Z8NxcO6G2zRyMmm0X63UfHdHsgYFWI/zgJ8yHOHulyASPVJziZKj6ZmP9dZYxuGljO9Ob5wJr7KCV9VEeiOgeoonvgbYjwiEKx+PxzLn91gj2HDem6yDMEp7QA3zJch0stHorbgNG+0ayyUj7OLN10g6MIqoelyNe4YpO6bax031lyMkY/sp1cO1La4XYtOg5+7cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tw8K8OCaWhOojgY5+Xmitc7eQlMq1B7DuKDUQygojIk=;
 b=hIQ9BrVhOedMVP98aSWXxFyuxDb7UokesqLpnvpTyMgTO9ac2LvACt8wx40+wHY8eXQdP00jREkzWvgL/rAlgxvLWao/PumMcrNowuPGbrIGmKA7YIf4GsrpBGHbhU8apVk6E8xzCdvraPrFjeu0QLIHdD360p2olTNej/6/9xQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3948.namprd10.prod.outlook.com (2603:10b6:5:1d0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.10; Thu, 13 Jan 2022 01:20:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::21b5:910:b965:9e6c]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::21b5:910:b965:9e6c%6]) with mapi id 15.20.4867.012; Thu, 13 Jan 2022
 01:20:30 +0000
Message-ID: <5cb996de-0475-9339-946a-b7c57c91963c@oracle.com>
Date:   Wed, 12 Jan 2022 19:20:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] target: make sure the np under each tpg is unique
Content-Language: en-US
To:     mingzhe.zou@easystack.cn, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220111054548.19479-1-mingzhe.zou@easystack.cn>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220111054548.19479-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5517254-d2bd-4bcf-70fd-08d9d632e38f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3948:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB39486BB431CCA3B37A3EAF18F1539@DM6PR10MB3948.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3lNQo2SWZB4Mxw6njpN6ngXGJ2gifiDjcmbQ2RsV2ELi994rfPrUvvj/qmBdSneKxMw1JNQ9JeZaYkGJDXBl++rmfdnV46M2sHzouAzvn5Fp7Go6sLkLqzXvQQIVOB8TBIXY1SEZIVTvw3OFREAopRThz6W0y8wZwJSv1USxXcvDpLgKUIZ3KkbXbVtK9reT/vmryhapowHy5Ec/ij9SLyB7etB2dsknOnNrDXDjYtVz0i790QZlLGROjtICKCM/A8Hi64dvCMdmn0LRNJ7B2K1L9enwDe+hGqI52UbeMgJiJoao86gGjqX4sJwOgM1o42f2TJB4WpNeKzOXSEZLxjROwCoh8LxphQmGisIGzi+o6x83g+vvJNPVA5HuaHg2KWVp9vfU8hpbvaYQe4pLieonUR15UJAPjY7N3/6e5540+9rMQiJkvn8ijFnJ7px2ypOPVwKPo0J8nRUBUfd3DvbOU5xYSQ0CsmpzG8BRhHjMTJJOJ70dfXJY1/G5ACfBWlliKpxTSSmbJQt4lqIwn2r6d/C3cqYCCe3N/S3SxH/eyeQhj+NKmxWxCGUEpOPMluza7CQ95H/3nkmWSdRGbWUDJdMo5dNMqs+LorpUEtnU4o4TXR7NKXYTi+4w981WyNviv4WrBam/ZHbKsmABPXhzouKKn4y3lkK0H9m3Lklkhac6OoTxd7Q0nJoBysjY3/cXArbEdY9F1KAjKZxbvDFRznFNf+PtwYRfxSKaC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(31686004)(5660300002)(8676002)(86362001)(36756003)(186003)(66556008)(31696002)(6636002)(66476007)(66946007)(508600001)(26005)(6506007)(53546011)(6512007)(316002)(8936002)(83380400001)(2616005)(4326008)(6486002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGdaTDEyU1pYQUdIQVhYSjBCemMvelNGSit0RXYvdDNCUDBSN2QxbUpURUdV?=
 =?utf-8?B?cDlGeDhRVm0yVk1SQWJBd3ZHVXlvb09weHJweitUczJNL3ZNcU1GQzNGbzBx?=
 =?utf-8?B?RUNoOXlabHlwSzFyQXN0MzF6bGdTd1d6U1VpaXoyMGMxQWYyOGEycXhnSnpH?=
 =?utf-8?B?eE1MZ1hoM25oL1pjWGhqbkJpWTZFSzlqNzVJTUk4cGlkRUt0NDNxV2QvTzdQ?=
 =?utf-8?B?L013a3FZdFNwY1JGeVdEZEx6R3A5SEd1MHpGT2h5RTl5RVlxWlJwa29LQXVG?=
 =?utf-8?B?eFFobHZyTkRmQkd5aFdISlpIVmwzOWxocDZsQjdRR0VYNWprQXBBMiswV0lu?=
 =?utf-8?B?TWJWU1RnQldzLzFMOUNid09tL2RhZ25hZVFhL2ZHZWh1ZFhKR3pjNCtGTUZk?=
 =?utf-8?B?K0p5Nk04dHlkZTVFUGdEem90L3djcE5BT2c0ai9mOXNpMWlUL29hVWs0b0la?=
 =?utf-8?B?aTRzdUhMdHVaTXVoNEN2aHlad0o0U2VFQXM5TkNmak83VHIxdEdZLzI4L0p4?=
 =?utf-8?B?MXlIanBVaVpqWXRpZGxQcFdCcU12ODlPdUlUek95VFdiVzVqNy91UW1WUDV5?=
 =?utf-8?B?bDFRekg5MjR1Z1ZEMFY0TEFwamUrS3puWE5TTzZZM0ErM2hQQmMxSFlkWlFU?=
 =?utf-8?B?dXU2Q0ptbUxsT1pPUVgxMEwyTDVkOGhYSmdyOU11MlFuM2R2OVU0aThMalAy?=
 =?utf-8?B?N0FGbjMrYzFyWThQcEdQY2F4Y1JMQlEwMEZReGN1b2RGWlA5eGUyZXZCT3M4?=
 =?utf-8?B?VkRsMmJpbWhzS1RicnlCQ2xlRjF3OTJ1NGQ5RXZka0dtR1BZOWJWbFp2ZCtt?=
 =?utf-8?B?ZEVQK1N3eEdXNXpocFhQOUQ2ZWkxUTZQWU1YMFlzODdxOUg1ZXVSWUpGUC9i?=
 =?utf-8?B?OEw5aWVZekpNaUhjdkdOTXhQNGxqKzFwUHFOM2VsZUQySGxma0Q0S3loN1ho?=
 =?utf-8?B?NTFBR2JvUzBRRzV3Wk5vNEV4TU5qK1lQWDlhR21JZVZCRjVlekhUUmtMclo3?=
 =?utf-8?B?STBPaGZaVnZjN01wQ3dUdFJ2d1JDcTE0VS8vaUdZMG95Vi95N2R0dndlcmJl?=
 =?utf-8?B?ZHNKZjhSd1l1TW10WmRYTmEybGR0NDZ5ZlJDN3FORDVxTjA0a2czSDdqM2M2?=
 =?utf-8?B?NHFFeEhUSm1MMlRjbkdZZzlNc3NQbno2R2RDNnhZS3ErTjRsVWlyNzl5VVpr?=
 =?utf-8?B?ZGllWFJhTXhzUlVFT2xjOGtoeU03WDV3YiszSnRnaDRBR3BQdW8vZHVSS3Av?=
 =?utf-8?B?WTlqYjVYZFJWM2E0M0hkYklnUGJ3SnNYNTYwN2p4NGR1NnhqUHd3c1NtZ2Jk?=
 =?utf-8?B?WS9SQnJmVzVSWmZpaXpzOXgvaFdxaUpybDhaNE5Fd1d1YWZ5ZmlRTGI5TjZm?=
 =?utf-8?B?NG9iVk03Y3NkRHVnd01kNmEwS3MwTDNCdHRzU212WXUzeXkyaFBlUU1SMUQ0?=
 =?utf-8?B?ZU1JTG1Mb253ZFVNcmQxTExIN2RPYyt5dUs4bzhNelhsYm0rbi9TRlVxS0hY?=
 =?utf-8?B?aHRObk5ZdHlLcUdhSGVJWHlBQmJlUlRoTzQrd3dRYlEwaG9EdEtqRkYwYklq?=
 =?utf-8?B?QS85M2pZUmd6U0tDblc3TjIwSHN4dEdSVGZwZ1c2TytvVHU5VXNzaEJzWW8y?=
 =?utf-8?B?WUhteUZpYURXaGo5U2xXTFZxZWg0bzVRSzJFSGNPaXNxcjNlOXBBZ2dEQkxa?=
 =?utf-8?B?UGxKRWVhcUNkRjdKRkRiaE5LdDJ6UURCVkR4SnpZZStIcThhcEhPM0Jsc3gw?=
 =?utf-8?B?WmhYMG91TXBEcS9OWk1ET2NxWFA1OHg1V1RlM0JTY3JwblQwSDBIbjN5RnNU?=
 =?utf-8?B?UnpwZE1RSUkrWm1RUkJLSnpNN3M5QitxZnRFNkdZK2kyb2g4VzAzaTZ0Ym8z?=
 =?utf-8?B?MTFDallkTWhSRXZ0QTAxSXlnbUVkVGhxSmZzdU5mcnZPOU84U2NzeUI4UExk?=
 =?utf-8?B?ZHRzajROTWZlUmk1eWx3dTI1VERweWNqdVVUS0R2UjdJdG1SbG56RzVLNnlY?=
 =?utf-8?B?WEp3bDRoSnJQVklueE5Dd2R1QTd5UUh4UUVDWVdPZEpHYWN3TDJiM0dkUlI4?=
 =?utf-8?B?a1p3YmIweUVaS2J6RWpsTUFIWGZWK3BkMWZuWDVVekJQT2VtNWo4c3BnNlFm?=
 =?utf-8?B?OFNQajA5anhwVVBOK1ZoNzV2ZnNFVGk4L25ibEdsTUM4eGF2NlBlZWl0b2JN?=
 =?utf-8?B?RXdIam12SUg5emtvcXg4Ymw1aElZelJiLzVRR0JpZmkxb2lqTS9ncE9ySTRz?=
 =?utf-8?B?Q09oOFF0dURpOHZNLzMwZnBHTGxBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5517254-d2bd-4bcf-70fd-08d9d632e38f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 01:20:30.6673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxZAipobwi9z+7vGuhXUBRGYgqjoR1wKoUggpUCgJfeZXBWHQS7CcGVQomAvFT3TpVVV61G3uAAshH5chzeIX3BUcdzTskp/nkWQOh/ROEo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3948
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10225 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201130003
X-Proofpoint-ORIG-GUID: iTBkONNgvghDJWA6dxLzBDzsg_t1YUvf
X-Proofpoint-GUID: iTBkONNgvghDJWA6dxLzBDzsg_t1YUvf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/10/22 11:45 PM, mingzhe.zou@easystack.cn wrote:
> From: ZouMingzhe <mingzhe.zou@easystack.cn>
> 
> iscsit_tpg_check_network_portal() has two-layer for loop, and
> should return true When a match is found. Then, the tpg loop
> will still continue after break the tpg_np loop. If this tpg_np
> is not the last, the match value will be changed.
> 
> This patch break all loops after finding a match, and make sure
> the np under each tpg is unique.
> 
> Signed-off-by: ZouMingzhe <mingzhe.zou@easystack.cn>
> ---
>  drivers/target/iscsi/iscsi_target_tpg.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
> index 8075f60fd02c..2d5cf1714ae0 100644
> --- a/drivers/target/iscsi/iscsi_target_tpg.c
> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> @@ -443,6 +443,9 @@ static bool iscsit_tpg_check_network_portal(
>  				break;
>  		}
>  		spin_unlock(&tpg->tpg_np_lock);
> +
> +		if (match)
> +			break;
>  	}
>  	spin_unlock(&tiqn->tiqn_tpg_lock);
>  

Reviewed-by: Mike Christie <michael.christie@oracle.com>
