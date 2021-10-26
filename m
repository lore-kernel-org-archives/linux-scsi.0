Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC1AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 389076108B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 16:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbhJZQwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 12:52:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23232 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236191AbhJZQwJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 12:52:09 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFrCJi015643;
        Tue, 26 Oct 2021 16:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=n/EIggo4a+r5LxWJNphN2fBzbTkPk0Jlv1NlAfIq5Kc=;
 b=ySDQEV2u25q48lEXfXqNVtvQeOrhEedIPT7hNnSBO3f1Qz0frh44Jyt0/CaktOjdUm/o
 s+hzYCtSKkG7TkTUB4plHn8nQjlPffymaa+Wv+emDB6FgQj0Je04GHbGcpNlfynEnl8L
 /l/LhwiCfrvK3+7Y8UN89B7xVtIpInEkNsKESN22xPzEGhS4PxlfR6Pt8XSYDwH2RRuY
 dB25lxdux1VeQhOYSvsvCQJVEihqx8h9rvTlh8qnRBZPVs4q9ch8WxA3G1UZQ+5KCSiX
 4sLdCNfINxxPjzF7/Nr5QblW2wo6eWWQHmuWFuNaSQ3R8HMX4H0AQh/BPj/4Hfn2Fx0p 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fjdjj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 16:49:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19QGjXWU188640;
        Tue, 26 Oct 2021 16:49:41 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by aserp3020.oracle.com with ESMTP id 3bx4gb9nk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Oct 2021 16:49:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXamZMizDc9YnkVEzylAxRloiOL2w9M/ak5pJSWAjbc5RY7PEL7raYq6NQ4GH0hHHImv2Y7tafz+YQjFMW89fzq5G+s0AmRTfHKt/HWKHjDvbkWIU6G1qfwpeGqc5mMYB2uiu7T4Y58yROKDe0HvW37DIQBQmuk7SZkJ2unceR8JSyd406KirTaf51p4LFjBwWPWd5w8K1BmL5qmxAlFIi+Z9Tya1EeMCzjGj7dv3mD2yHCNj05ldFo0Wupv/NJFm0O8AhKJghUUIBG6raWvQqGt+sna8L0ZHE9XuJi3FiWsWV+TwrKw3rVwsvEIpqL6XEhePkvLYzKHpafHW/wRgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/EIggo4a+r5LxWJNphN2fBzbTkPk0Jlv1NlAfIq5Kc=;
 b=TEeTiifTtsXtoX83c7kLKWmTZRYKh/v7oQ9enA2CGx8LcVWJP/fxJ87KvkVEwgHtCNxZJdHEobJJDjhUcLswG/uyZp3iRN2I3MpXVmWlYSbZ19/HEoeN22dIAJYVUlwRYRETHryw/gxPuvlawzg2cm4kur5Vbfv8lJglpHzCvP6kdV3vKDXCxaeGiwwufwz0P9AOEGL8+RIkflIdOWGNUeP40mmWYcXCmuKGEBtsv/lcpHee4F8JGDS/0eRR/2JaxQXjhAH+40maoO59zF5u3W/scQFCb/PdR6k2DRhki0rVJgk91dwE5cpMBqVlhIwzQgNJYZQQz2PdsaqfTLOsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/EIggo4a+r5LxWJNphN2fBzbTkPk0Jlv1NlAfIq5Kc=;
 b=NZUj93JbBetH7QXsvTyNLUNsnHEeVUIpAgFa+FlAEnJodCpwTBkoRPp2jigZqCIfwtcXz61vXbROvyT1rtY+gNl6C6JXmbO0B2y7t9fTbpo5tL/syEjkVCeXJq6y2rLzaJTH6BW72Bfs/MMnlMYDhd0wDwwJQMC/g36wYQcheKk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2666.namprd10.prod.outlook.com (2603:10b6:5:b1::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Tue, 26 Oct 2021 16:49:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::195:7e6b:efcc:f531%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:49:39 +0000
Message-ID: <4d33b7e1-5efb-3729-ee15-98608704f096@oracle.com>
Date:   Tue, 26 Oct 2021 11:49:37 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, stefanha@redhat.com,
        pbonzini@redhat.com, mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
 <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
From:   michael.christie@oracle.com
In-Reply-To: <8aee8f07-76bd-f111-bc5f-fc5cad46ce56@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR21CA0005.namprd21.prod.outlook.com
 (2603:10b6:5:174::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.19] (73.88.28.6) by DM6PR21CA0005.namprd21.prod.outlook.com (2603:10b6:5:174::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.2 via Frontend Transport; Tue, 26 Oct 2021 16:49:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4155daf2-f8c3-4384-c1b7-08d998a099e9
X-MS-TrafficTypeDiagnostic: DM6PR10MB2666:
X-Microsoft-Antispam-PRVS: <DM6PR10MB26666D697CAB888E6B5773E7F1849@DM6PR10MB2666.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BY4nwZtFrlQj8GxJSUKDiW8EgXjk8XFwg2XWYyjfB8swXKnwBOJfDshx41/76riDRQ0eT0dmzwCNC4MlrLatiK7EXAb3XwDyTVc9xj8cKxn1K/nehxwh1KEVT7XFDesloj43C+f8py3HzschMLJNuDXQptkoCg8bUvF8smMSvFjUC2LSmE1Ty2e07quZcoUSwVjfM/nGNyaYrsnsSxY5NBvy4tK7sdkSACN+m3UpfzUBk7ZM+Pv/BHH7oRuANwAEbQmlVPtWKqrcBmW/AhIR1kypSxrn4dnQaOP3kbjrCfOT5dTiVCb9XJCXpPo/poXK42RzH25NiaS/fp59KSuqlleKLD/nOwY1G8i/roVxfqL+3xyK+r6d8xcSMFoP8XBbl/7WhwQExD7DYAcnwFemyK36cLJ3YhgL5+kz2KNjdflSlTMvVsiWp9jZPXkNx3QNOM3QKg1kR43VjQw5iXE7I1TKv6j1Ti5C56ZD3H4ktcgMCpPF0CGfMDR3IU9rcVHVCpLhpPB9E3FumxwHqAOeXZanDHuQWPsUOdNb1fTAJfcgw27DfBuxBFnAvkV1iOAWQ0pQ5aCTs7DvwChlx4kgiT88QSN0hdIADqHavkt+SpBbIwxEE5aHT8ii/IRdfmBvO62PwVBf5TcHlsb/6+mDqlHysHqaORbcahJo0rXO3g1jxjy1x2FXXqALRR6kLcgcQ6GgvIwhjiEHb1H3tFlb09g9hHmN4BtCOM/WOWIMH+IyV/bK5gSsxqb1Cu/sQMDqTXqZ2tMfE7XPMOfEmXrpanZA7bNjwMtBaC7C6sFQ93F9A5qACAQrGrKC8UxbhZBJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(66556008)(66476007)(9686003)(53546011)(83380400001)(6486002)(6706004)(956004)(8676002)(316002)(5660300002)(186003)(26005)(966005)(2906002)(38100700002)(31696002)(508600001)(8936002)(36756003)(2616005)(16576012)(31686004)(86362001)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3Fuckl2K0szS2NxMTlRVHlmV3I1bXNxZm12enQ3Y2tGdjhoUVJXNzg1UjlY?=
 =?utf-8?B?a0dQNnJ6WE1lb094a2M5R2hCaWZxa2Y2cWpONGFlWVZ3T29TSVdXMkJwTFFt?=
 =?utf-8?B?ekMvUFJDUWdzMkc2SXZGQmpYVE9qQW9YclpuM202eFJOSUpoUmQ4MU5HNDEr?=
 =?utf-8?B?RmNFaTBCN3l6QkxPNloyUFBGbmNpZlNSK1JZZEhab0JjSU83ZmtYdXNUSmZZ?=
 =?utf-8?B?eGtzcTNWRlJrUklqTkRLVUJWQXlpdkczOE5wNlN2M1A0T1oxUHJEeWpDZ1NW?=
 =?utf-8?B?c0MvNm10b3lmZFp1aXRhdm9pWVgzNVIySVpwRkhiSnN4WHpnUTA1STFnQktY?=
 =?utf-8?B?STYxVFR5bmkvVVVsSHZNRjdBVEhkbm4rRHk0cnpaK3VzblZBMUtxdnd5VDd5?=
 =?utf-8?B?VnNQQ0JjL01ZTXV2VkJvRmlPVEJvWTR5YXkyYUR5QTBqRDFVQ3VkdXIzOW5a?=
 =?utf-8?B?dUliWmFsYURGck44d0lqOVZHenkySkpMMXNySnpaN0FnUkhGRTZnaDhWQUFa?=
 =?utf-8?B?cmVCeGIvam04bVY3RmxQc3RzZk1pVVI1Q0ZYRFNkNGFUZVlUTGl5cGNDQ1dy?=
 =?utf-8?B?aWRSdEpjQnZCcm9BU0pkOFZZazFTVUcvNFVpdUFqNkdBVEl6bGdFYlJSRjFH?=
 =?utf-8?B?K24rVytRei9PL0pFanNXN3ZramFUZ09XMTJLNmpNcVhDUzdLdkR3bHZFOWpr?=
 =?utf-8?B?YlJNaS9QdEROWUI5OGJ4QTN4aGFzNC9pRXNKcVpzZHRrTWMvZnlkRXV6TXdX?=
 =?utf-8?B?VVJqWGxqbE1HT3NSRVhva1NqOVNSY1VVVFRKanMvb3lpczBmMzBHbWhmN3lF?=
 =?utf-8?B?SVBuVk9oTnlZbVhlejUxaWVIRkpoK2p4RFcxOXVkb25uVkhSSTBraHdvN3ZH?=
 =?utf-8?B?VE5VbDFWamRDY2pGV1JiU2luVDlWWFRWV2FGOFZGQVJDdkg2TFkwWlIyeWpZ?=
 =?utf-8?B?WjdnVzZpTS9lTGRVQTBuTy8xdU9PUGw0ZUNGNUpURE5xRWhrWWpWL3ZsM0tP?=
 =?utf-8?B?Zm1BSEFPalJsWVVEamg2a2FWYlMrWEc0YUlLY0hHZmVPZ2pjQ2hIa3lsSy9k?=
 =?utf-8?B?Ui9YV1F3ajdobGc5SlNjVWxOcFRJaXVBcnFiSVB4MzJITTZGdFdGM04zMHN0?=
 =?utf-8?B?TzlFRjdGVHhiUDRQMGRPbWViWW55VzB2aHdCNFo4YTNYUmNCRG9xb0gycDRJ?=
 =?utf-8?B?T052K1p3ZDB1NGFmYS82Q290bjdYTk5meW9yZTNTU08yd3dUSkMzZkZUKzNx?=
 =?utf-8?B?VnJJT1Q5YUVvZmFKQlJQS1hTTHlNdlJDeitKQlVkM3ZFRCtCdmRnNWw5ekZB?=
 =?utf-8?B?dndvbGgxZXY1OHpKdVpVZ1Zld3N4cEFYRXc1Zk5RVGo1TlhrTXVZd1hMcjdY?=
 =?utf-8?B?VVdMYjlacEdhazd3N0NhRytMZzhsZW5uN2tNb1hLNkpISHNrZVBRbmpsODlB?=
 =?utf-8?B?U0ljS0dNaU5mVlE1bjBzcU1kSTloWGl4TnpiUm42amp6eVpTYmgvblo4TVJn?=
 =?utf-8?B?RHIzZGxhOGtqL2JhSUZ5V3FPRlAzWk1PYmJ0NFhheVhldFI2NlFJVmxpRE5i?=
 =?utf-8?B?M3l1eC9tNkl1RkxrYjlJOS9LWTRQb1lvOXZPUEQxVUttSXpaejlld2JONVBj?=
 =?utf-8?B?bmkzcGdnaGhCL3Y3TXp0aVBEZ2Nudm5FRjFPNDJnOEFscGZyRlRSeW0rMVNu?=
 =?utf-8?B?WUx2UlhPYnIxMGlReWNaK2FYcEN0QlZ4UFlOMTdobXI2dTB6eFl5MExNaG5X?=
 =?utf-8?B?dFZwSmwzQkp6L3gzblJZamdpbzhBYm5UTnNLdEhQQkthVGVlMUZGTHRic3hD?=
 =?utf-8?B?QUIwaW05bUVNdjFBMWRxWFBVa0xPbGNRbi9GUkFYV0VUSmtDYnJDa0lEbDRQ?=
 =?utf-8?B?aElROUJIZGwzZjhkTmZNb0J0K3prN25mM1A0YXl3aGZ4eG5QcDFMVVZHMG1r?=
 =?utf-8?B?cHlGZEFrTndBWW9mSC9WcjR6ODdScjJxazFFZWRsVXBkUUVmYkx1Mnp2a3po?=
 =?utf-8?B?YVEvSFdGWU5TL1h3VGRqSk1KWGIzOUVMeDd2eGlOL1VQNHFVQ2prVkRiQzNM?=
 =?utf-8?B?WEFPR2R0WlNvdXJ5NXA2NlZLc1JxSWhVaTdxWHFRdHFTVVJEeEhvY3lORWVi?=
 =?utf-8?B?L1NjcnRpaVUyTXJ3cVBYTmhJK2c0U1lvQ1Rtc2daSEl1RFlDdCtWajVYVEdr?=
 =?utf-8?B?QURwZHZnbU1SQURRQUI2c3F2TUI0N1g2dU1LSk5SZWNCRmdQRTlETUhZTS9q?=
 =?utf-8?B?WFpjcS9wM0hGUW56ZUpkVGluaHp3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4155daf2-f8c3-4384-c1b7-08d998a099e9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:49:39.5458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PtGpAnuBT5LsI6QKEtaNpHRNvZCS5cpIebwpacqdJLxh+TzGS3/u9EI5iaguYPkCT90UScIBLryl1sXKqfvBuMctyk/c73k9uIqsE3eLr54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2666
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260092
X-Proofpoint-GUID: pgdUw3w4dZwNopUBNBaaWL941-mjt7rQ
X-Proofpoint-ORIG-GUID: pgdUw3w4dZwNopUBNBaaWL941-mjt7rQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/21 12:37 AM, Jason Wang wrote:
> 
> 在 2021/10/22 下午1:19, Mike Christie 写道:
>> This patch allows userspace to create workers and bind them to vqs. You
>> can have N workers per dev and also share N workers with M vqs.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> 
> A question, who is the best one to determine the binding? Is it the VMM (Qemu etc) or the management stack? If the latter, it looks to me it's better to expose this via sysfs?

I thought it would be where you have management app settings, then the
management app talks to the qemu control interface like it does when it
adds new devices on the fly.

A problem with the management app doing it is to handle the RLIMIT_NPROC
review comment, this patchset:

https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/

basically has the kernel do a clone() from the caller's context. So adding
a worker is like doing the VHOST_SET_OWNER ioctl where it still has to be done
from a process you can inherit values like the mm, cgroups, and now RLIMITs.


>> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
>> index f7f6a3a28977..af654e3cef0e 100644
>> --- a/include/uapi/linux/vhost_types.h
>> +++ b/include/uapi/linux/vhost_types.h
>> @@ -47,6 +47,18 @@ struct vhost_vring_addr {
>>       __u64 log_guest_addr;
>>   };
>>   +#define VHOST_VRING_NEW_WORKER -1
> 
> 
> Do we need VHOST_VRING_FREE_WORKER? And I wonder if using dedicated ioctls are better:
> 
> VHOST_VRING_NEW/FREE_WORKER
> VHOST_VRING_ATTACH_WORKER


We didn't need a free worker, because the kernel handles it for userspace. I
tried to make it easy for userspace because in some cases it may not be able
to do syscalls like close on the device. For example if qemu crashes or for
vhost-scsi we don't do an explicit close during VM shutdown.

So we start off with the default worker thread that's used by all vqs like we do
today. Userspace can then override it by creating a new worker. That also unbinds/
detaches the existing worker and does a put on the workers refcount. We also do a
put on the worker when we stop using it during device shutdown/closure/release.
When the worker's refcount goes to zero the kernel deletes it.

I think separating the calls could be helpful though.

