Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1D2C43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237900AbiCIT3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbiCIT3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:29:06 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AB69549A;
        Wed,  9 Mar 2022 11:28:07 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229JOkma017381;
        Wed, 9 Mar 2022 19:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BL8Q4Mc+13eB77fffJ2ZyEQJZVzzCjGyohTqN5I72bA=;
 b=VuKc/21pdtC/lRb7EFuE0GlMdCSI04xiZmjJXajnYZ31jufia64a2a9ZAD3B/3rEZVAo
 QKmL5jJaaGdAlYTw/sg9nfjkWXXanxvItYSp8SQOxgbcpmExp1riG3JLNA6CeZs5GY4R
 3HGUaev2N/i1NdsZUSYwPqztMujVIQsoXT92CoBv+pK2OeNdVoETcE5bVU20rpB1uXOm
 /OuLwymdhfaF4NOyfxrzHj5mOHs2MQFsvAmKbgUel1H/vWvgB7GP2z2KLyRbe2UJvUDe
 DJMYfANUP1drFURNBSw7VQkpCnfGUkLBtHa3sptpHvLMKmjxWftAKWU9MY5TLiNMvbiO +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du398f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:28:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229JQ7xu113650;
        Wed, 9 Mar 2022 19:27:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by userp3020.oracle.com with ESMTP id 3envvmquje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:27:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbkZJkyWK7bxBVWIKqczHvNDQ+n7DG6JZ9hqaKJRW5MEy6QI+QcJ3/p2Yzd0oXIbgklJGwriQnQkevfJeo3pLPums4t0q5SqotDu3kLoFGKBvM5v/nieGd3UuXG60jiJ/ftNTtshVDRuBrpd6zrx1HlCc+rKeyiKXp9XB/i9hBfx/e7H347nQPF7H0jKWoWS3N0QYFTCm1VzauT5MZXZN175jRWAj09Ar0ni//qb3TvJWXSr08jQpFpay0lFfKHcM6evr4HYjzkSOsNBmb8P/KrLwkWxldgwmawAhqvz6TnTJ3u/Cqw5xl1E6/AAOqBlk/21VteeCfWWzGH2zkaGcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BL8Q4Mc+13eB77fffJ2ZyEQJZVzzCjGyohTqN5I72bA=;
 b=H1dR5238B7GJT52v6ZVWNgVaP5OoC+0xQzrd+DiYPPnYPDGNsjCQCYutRjPKNI+4f6OLuBByh+9oAVEb8Qr3sW2ZRo8sJSc6bkZMGtF3oaYPjQ/pK+gu98ukAIs9LcBtKjDvZcpllkPJY2DOm31Q8svhWJdJeauoN47AmofYg8+/WGA/h6vIuDtm+gommtBHiZHajAPt/NLysi8cfiUGHtWAM37NClEJNg6uheHQrUKk+Zn+PjRdHPcdx3y0ctTjFyT6Dz0fAkA+cvoEOT+vEs9A940h0mnYsRF3iySS38orrdkPptlLzG9zfek/gRWqhaJmW254O8908TTyDugfYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL8Q4Mc+13eB77fffJ2ZyEQJZVzzCjGyohTqN5I72bA=;
 b=V/cPE4CrmfKBu6LQgF3TzSk815xOx8UY6OKLr1smNqBdhFwlFgZ51Z0U7JtDj6x+cCXNMrBC1MOA7cnXpgfU6vPDp0SXA7kUHvtlSpALWrCKtVo1V1DXgG0efmFp+BKbVfV32vuvCiqwFhiPZ3PJvkViDWVYsPWGdr1QsymfjtM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MWHPR1001MB2160.namprd10.prod.outlook.com (2603:10b6:301:36::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 19:27:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:27:55 +0000
Message-ID: <80f4b6f4-88cc-267b-8054-8009a1092814@oracle.com>
Date:   Wed, 9 Mar 2022 13:27:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v3] target: add iscsi/cpus_allowed_list in configfs
Content-Language: en-US
To:     mingzhe.zou@easystack.cn, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
 <20220301075500.14266-1-mingzhe.zou@easystack.cn>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220301075500.14266-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0068.namprd05.prod.outlook.com
 (2603:10b6:8:57::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c160b99d-6348-4991-5297-08da0202e95f
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2160:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB216074FA1693D4576D3A0876F10A9@MWHPR1001MB2160.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WzFO6rVEK5aXrp0fAVx8ncJXicy59sEWjkvOKpOAFWqZyu0W9JYRONq4rSAXH+2w/0GiFAnKt7R1lVC1DLWlolXnplmD3wb6atYnShF6PPMsR9z4vL1jW3J+AbNARV4+YJH2MjjL0ZCnSbEBfSLBSHWEvlBeR1FeXk4j+S3S7YTrRbkyuWrm3s849x/Cu68KcHW/T15rI2/nd1MgF+70IWNiYh/A5wyJ809huHIV/V6mLDpVjB/s3VyXotuuaySs1slYdHlGi63Yyn/PdG6IjFlur/+FXPFXrUD8KST2LiNVj1UfiqXItKLU8t9YFRR9gyjTAIWdjSoc60/OYBNRrLkqHDhqTk+QZFIM/JaG68uSLJwQ2sItW42U3mrjEhrtefp583dnbAF0WJy2yOtti72MJRmy+cGkZts7MraYKT9Pt1BqpUolyTa2HJ5LoZZFDCu52wvv5fL/ymqLEqNQ3N1wcG9cxg8kVHdXCyPomd77l82qRKT4KLUtC6VZ+v+wQT9GTkVl+Po1I1jtjpdnYpBUAH8s71D47ZnQcEMfPLWGrDzUiwCfdx3bVh0T61Vqj5dJbimDfGGqCFEs28GupHit5dv1gw9NywwSKULd+nD6+RDdDE5zxm0p0fn+0fUZ4qdo9YFJgcCMEAuVNOCOE1IP4A5h9IL2lNJ6lrtD1LpH9VsiSstzN8zQsd7lV3arrZLGcKDm1O4NuVErA3wi8M/I0qSp9/nl8nhE3Jvz4z8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(316002)(86362001)(6512007)(2616005)(2906002)(31696002)(8676002)(6506007)(66946007)(4326008)(6486002)(508600001)(38100700002)(53546011)(83380400001)(186003)(26005)(4744005)(36756003)(8936002)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm5TOW9uamVGQXQ3bHk2SXV4ZTBPaFovVkVtU3p6eDM3WEoxY01SZVhUdW9N?=
 =?utf-8?B?Um1IazFOdkxqcnZDU1dRbysyVHFzcklWenV6TllGREh0bVNnWlZRdWZMdkQw?=
 =?utf-8?B?cVRZNjN4QURkREdzcnlnRGhpbHNsdGlsdHY4eW1mbHZUMVhoa2pzMlluZHRY?=
 =?utf-8?B?ZWlSV2NoQjgwdmlEek1qaEZHMjdnZU1TVVZKYmlWazVYdzhLSjdaZE5QZ0Nq?=
 =?utf-8?B?UDQ0S05jSlNEc3pyaWVmZDhlaGxjemhLV1Jpa0ZPNW00cjNGVmNnbVk1VVZQ?=
 =?utf-8?B?RlBNVzdxWXMyaUJqM3FmT2dKYklmTmkrUmZQTGZid1p2b3lBUVJQcFVKc3NC?=
 =?utf-8?B?bGN6WVpHUVZTVHdwTlZMVmw4YTc5ZTRFRURLZjk1R0h3K0lQZEdYT0pLMzI2?=
 =?utf-8?B?UzR2bFA0blhHTjFWT1V5Q1VGeEJaSTJiS3RHWk1NM3ZlZzZHQ3ZDck16di80?=
 =?utf-8?B?N1hvQTRTYWVGMW1MckpuNm8zVU05M0ROSW1KRmtiYWIxR29DWVRHZUZFQzZn?=
 =?utf-8?B?cnp0S0dXUlMzTlJScEVOeEdlYVJWZ0o2ZkJmeEQ2cnoyc0hPbUhlcHZzbTZT?=
 =?utf-8?B?QnI4VGlmTEMvaFg4K0hieW4xbGNpYzM2OWFuMEhqSTQ0c0xCQnFYblluQWkw?=
 =?utf-8?B?WktPL25Nclo2d0NCNHEzOGhzbTYzN1VjRGVrWTBEK0pNVnYyaU90bDlKRElW?=
 =?utf-8?B?RW5UdFB1R0REa2t4SlNJTVlBbHdkbGxCS3JQSVM2TnJtTHhSY0EzMXFmcEt4?=
 =?utf-8?B?VDR3U2QycmdkdkN4MXo3OElGUFpsZkthR0FvVjhTbVk5dXh3bUtqTHdnK21V?=
 =?utf-8?B?Um1LOVN4TWhjeWZsK2JJOW1XVWx4TzVvcXVTNnNHY0hxZ0J3S3VxcGcwU2Vi?=
 =?utf-8?B?WXdDeWVwRFFveWRwWVB6MmY5OEw4WW5DUlBFdFdtUkNXYmJKdGFpQkRJOEw1?=
 =?utf-8?B?Yis5RGN5Y0lMbXJEeXpkbjZ2MTU5ZHQvWnVpUFEwYUk3NEZYVGtlYURwazF0?=
 =?utf-8?B?dXRmU2RMWTZ6RHVKMzdOR2VQS2oyNHlGN3BTaklzdEwwNEU5cElpV1VJTytw?=
 =?utf-8?B?b2RvM2puTFNYNi9rdDlwcStBanREZGpZanErRllBSTM4Sisxd3RlTWdvbUhz?=
 =?utf-8?B?LzQrK2JxbElDY2FSSHRMbitnVlFVV2kxT0Y1TVo0MFhxOGpISDFTSGtSWnZ1?=
 =?utf-8?B?cWt3a0ZBcnJsSzlVR0tFdEd4ZGZ4eFdpN054Zlg0Q2duODNrN2hEMy9zUml1?=
 =?utf-8?B?Vk96WGJ2TTBNYmtUd3dvRzRuRHc3ZUlteWdyVk9WRXYwb2RZcmpMWHIvcUo4?=
 =?utf-8?B?WmdMc2FkUmdEdWlXdWRQai9DQi93T0E2RkZwUE11UGZHdGRRSVhWTVIrVU0r?=
 =?utf-8?B?SlNidm9YQ2dvS1lleXNEV3czYzFUU0lWVmVyUDJQRkFGT1dJQVl5OUF3Ky83?=
 =?utf-8?B?ZjRhR2RzZG9LRHhoS0dlVU5vTDY5b0kyeFJ3VXo3V1I0aDdWVXdSZjBrVVdj?=
 =?utf-8?B?akpIMkRjeFR4UGNHb0VtVURRNXlYK3F0ZkpuRjllRXd3bFM0RGp3NHA1MXRK?=
 =?utf-8?B?SHp1WUtBUmtGSjNiYngzaGYxcURqSzdJOHJmUGtUMlM5dmVrWTBQTlpoTjU0?=
 =?utf-8?B?a3ZIZ3hnRnBqUWZIVTVxalV5SHRyQjRWNEp6aEpXeXg3Y2dQYndqbmMxeWh5?=
 =?utf-8?B?ZGE1UzZab0N0RHlhZ3RabzJRUkxkaFVQMUFIRzhjWHpxM2ZhbXZ2eXB5S2U3?=
 =?utf-8?B?dUNZSThhSmR6cE5uWFRZeHRucGVnWmdtZjZLUVZ0UndOTklreWxuQWFMcmdp?=
 =?utf-8?B?WUR6SjArQ0Y0ZUx2eUdBb0FPSzZpaXpGSVFvNG5NR2dHdkREMUdiVXN1Snpk?=
 =?utf-8?B?TmxpdnYyK1RLY3pVYjk0ZTk0RXgxZUIvNFZNcFlpUndRSzF3TWpBcnBOWktO?=
 =?utf-8?B?ajJLLzlHZUY2aWpNV1ZZaWJqYWYxU3E3SWpTUldmVG1ETVNRNHZWVHJNd0Nx?=
 =?utf-8?B?UFdYOVlIRGRnK3RkQWRzVmNHUzR2dEhrRzhhQ2JxcGhyK090V01VU2ZtUHZW?=
 =?utf-8?B?QlVJWTlIekNjd3k1cFFOVDRVSXAwNkdYdW1uWjFnMGtwMlRlVkIrNFIzOWow?=
 =?utf-8?B?d1BjcGxzY0N0NFpySGpWNkNjM0JBaWZrS0JpcUp6TXp4bHUxQzdHMjdBd1Vu?=
 =?utf-8?B?K0ROQkY1amkveFlOSlJlbWtEUlFRczJEY3FLVVhGQlFhWEMxQ21YMjNEK0FB?=
 =?utf-8?B?YVhjaGliQ015ZTFPNlNoaFo2YWdRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c160b99d-6348-4991-5297-08da0202e95f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 19:27:55.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6uwSvNZTFimstpAnL+dfi/wDk4qQFBQiKDLI/DewQMA8YI1bjSRFyX8NRtXKOEBmG7GFoAjqpGKGJZx5FYvUHzJx6a9HSa1MviVaygB338=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2160
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090104
X-Proofpoint-ORIG-GUID: 4gHHkMylIVuyHVCUAhw22dVvbQwmVfUB
X-Proofpoint-GUID: 4gHHkMylIVuyHVCUAhw22dVvbQwmVfUB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 1:55 AM, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> The RX/TX threads for iSCSI connection can be scheduled to
> any online cpus, and will not be rescheduled.
> 
> If bind other heavy load threads with iSCSI connection
> RX/TX thread to the same cpu, the iSCSI performance will
> be worse.
> 
> This patch add iscsi/cpus_allowed_list in configfs. The
> available cpus set of iSCSI connection RX/TX threads is
> allowed_cpus & online_cpus. If it is modified, all RX/TX
> threads will be rescheduled.
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
