Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98211C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 17:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385334AbhLDSBF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Dec 2021 13:01:05 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28114 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231254AbhLDSBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Dec 2021 13:01:05 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B4EYC4T000598;
        Sat, 4 Dec 2021 17:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZGvUC/IAXG3se1rnLxNKodyIfuQ6wVc0CsBS5/IVnKY=;
 b=eoh1dQZvfseEuPrvjjRFwY0mlG6teMsO2+zy/5hT5n2t9o0kbDQQRuCpcoPNEx3txW6L
 Qm2WprdDje+dboL2W5xB2bmy8YH3LE7kMrdFzg2Jl+43Uv82IGSHwas8DO7SrEpNCy/9
 lt6CJ2lkTQ8M2mT0Yw6LIEEdXYvDKDm9pTYIzHzr1bbzWSY/HBY4aGqe18TpZRoqr7Q7
 GFLvJ+JMFeufmtWLCP+kG6ZPEUQYra8WS+ERar7P9e194p6TBGAI6b3g9es1Salg33xm
 +ZpnI0aEZrJkraOfF1Tuj7Hxbcko2tccQn1ICp2qXAefxn9hCWPxjMFiPUm4uU1jTWu+ pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cqyxv1hbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Dec 2021 17:57:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B4Htpwn158603;
        Sat, 4 Dec 2021 17:57:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3030.oracle.com with ESMTP id 3cqxcbakvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Dec 2021 17:57:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irMs2YzUuAaQtcs1YIWGNbBOP3OvafvF3qcEohaMSB9u2ww7+o6pNtl1wh7Cbp2NUmlum+ky5EU0vL0f6Cd5hg8J9Sldz+g9DUW8nAbg6iksWE6qtGMVR6D1gEZgGfLWOYl3Prut05Vadh/Zi3vb9OH559cD33m4Lu+k7/n3c6JWUjt+YAi48gxp7lkVw7vtDjDxe0t1cxquNZjQ8V+ErL8uPETLOTRJcCsa3nGRzmZNAvdSTjdy+xKo+Gb0KYWBSkWMybfsTXfZGh6SDGDPpFgfHITIP7XcMiKTjAcCEDTBkia2oL10PduF5Gr1DGti9+LiWyJFUGNkdG8sVdkLng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGvUC/IAXG3se1rnLxNKodyIfuQ6wVc0CsBS5/IVnKY=;
 b=F9GSML67JgLe1dp80t+TQ2WIp0SWTSZSYm+ogSq2ZsGqzZZTCiwCez2v6fKDURg64hpnejhzFpq4AXpkDDFTpB1YXzzSCCNma7z3WQHlcY0vfDGjqAvoJ7kd4Qa3/SDByREUxVNbUC+EytX040O6wJ9bLoa7ATBN3UJPjmIv6Gz9c/PT4pzyouWte3pRD1hHJJmrX6JmseJLqEwas9Ncgd265hHui8ABxjcZKU/Q0VG4LsBKiWCdnqsip2iRi8hRYDvMx+XxCUVFnoiXH3p2RQ/z3D9unMITH6+YMBWfBM4W/FjR/M+RbDX7yTBpbH9GtlWtEMZZGeYvylnNcWsdDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGvUC/IAXG3se1rnLxNKodyIfuQ6wVc0CsBS5/IVnKY=;
 b=dALS0OHGVa8r51wTHyuJFpKgwFVHvHKH73WY/YP+yyPv3oy8Ny81juAK+E94O0mT8l7JR77W4TK5jJ5vVfBFK2lSTncjcLsAibUioeukzyKc9W1d0Ar+xBeiPizyYfNrPW6bMnwvfTS51USMJrmEj3c9mVfIZ6max6W2YoHnUCg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2955.namprd10.prod.outlook.com (2603:10b6:5:66::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.28; Sat, 4 Dec 2021 17:57:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4734.024; Sat, 4 Dec 2021
 17:57:31 +0000
Message-ID: <7c2e56bd-1848-f86d-3c01-f4cb0ecdab79@oracle.com>
Date:   Sat, 4 Dec 2021 11:57:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 REPOST] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
Content-Language: en-US
To:     Manish Rangankar <mrangankar@marvell.com>,
        martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20211203095218.5477-1-mrangankar@marvell.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211203095218.5477-1-mrangankar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:610:b1::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by CH0PR13CA0007.namprd13.prod.outlook.com (2603:10b6:610:b1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Sat, 4 Dec 2021 17:57:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b514c0d-abed-410a-af3e-08d9b74f8ac4
X-MS-TrafficTypeDiagnostic: DM6PR10MB2955:
X-Microsoft-Antispam-PRVS: <DM6PR10MB29551CE53817F90BF970289EF16B9@DM6PR10MB2955.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKEdJPELJkFSsMporNiVbktxo1bIO4X7XqZnlhTicbfw27Cu0/112AvgNGzkCurQU7fN9ostJnQ2F/9kCwUWUCJJPzM5iySQ/GYRdjujX0PK+Dt2vTjVU63NNurf81vQXG5z/dSRLmP4+Ub+SZHPp3wF58CKxtTaYtLh6RBFsmXnsSqXCkhDbOo9SK1V6dvQH5ZUp/TC0FzMeddcKvo9hv5x8pLrtO6KTevOEAiMN+2hAJ5giUxecJ5lVu9mAKbl5JA5wJ7flbZNdzATc2eO4AtvGOfDNWybUocx0NUn99sP0AzslnG1wlXN67h+ovWQFMgzzS9L06Hqmk6Xx4XmhnKbhWhzJCWsnJ26MctHK+6KECAzWjhO1fM+VOBuz1YcLyxfFSyS39ZVm6fpXAGwLoX5BJRbBCzxqpKSR3nc38GJ71YT6KCFw/fVbKajyr2XiI5iC1EZZWmjUCkZ2jOI1PkiTi+ytcmz3gPiODNUHWn9MQIupG7/vqqLciuRAMb5O4GUlavJRAML905rKzfgCoJtcRoWrR+9WrXrJetjFhU4SRbShp6IF0b8Nazth9Egbyfejw2Qz6y7y8X4brHVqcyt7XBzWvIpAzUlJnjuRqt3LdgGpPxGYRmGRTiSiZWuFZEyg2s5H0SPlkbu6tDhcS0TzWs2sl8w8aQoYKADZ9OTFTwWNOqwZNXzUBWXzG4HOHXcw+aoKwhZyrWpplVWUxGuT0kvVVSjuk29jVWTZbgTn84/0HJpX3XI75DTnLhtVc9Oo8NpAB43VBOSditBwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(36756003)(8936002)(8676002)(31696002)(6706004)(5660300002)(316002)(16576012)(2906002)(508600001)(66556008)(186003)(2616005)(956004)(86362001)(4326008)(83380400001)(53546011)(66946007)(66476007)(6486002)(26005)(31686004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWQ1dnJqcnI5SVdoTklsV2JhSEc0bGJXY1JuY1VoTTNDaThhODRUaDh4OG04?=
 =?utf-8?B?VlVyZ2xoVmtIMCtEeGswL24vaXNuRkxkRHZSRVRhSnNPamVLQXZoanJrWDB0?=
 =?utf-8?B?NE1YanYrOG1mWXdob2liN2k5NFRnSW9DZU01eVlqclRJTkg2bk9CK0ZGSXFR?=
 =?utf-8?B?UENGN2xWT0hGQStuKzNySVM2U2wweko3bjk2bFhlZTZIZzRnSytSMFNHcVRT?=
 =?utf-8?B?WHpnNEhDZmhMYlVkb1RpbkVMTjBQbmQxRkxFMTE4dERmZFd5eFdxTlBDOEJY?=
 =?utf-8?B?UlllQWluQW5STW9IekdVK21IUktiTmdlYW92cTBKZG9hcHVpc0VHeXczQWY1?=
 =?utf-8?B?U3c1VnNNc05ES3ZBMWtwZHprR3NwWFA4WXBDbFFNUVIzVTFlVjdqSk5qUmg0?=
 =?utf-8?B?UFd1eU9NWHBOVjE5eGwvL0hTSzN1OHpWRkdCcHpKc3hMUmIyMmNUQnZ3czBN?=
 =?utf-8?B?Tm5Jek5FWnVWeTQ3WVVVeDJoN3k0UzJoMHRCN3VaVjM4cllLMC9PN0l4a0dV?=
 =?utf-8?B?cGpJK2dOMU9SUUc2QVRxdlBERk8wNXlhcER4clNzVlRUWGlsb1o3RXBnaG5t?=
 =?utf-8?B?TS94QlRZSEFiUThrTWlVWE9BWG4zOTdtTkU4Slp3V1J2cnVlQWFvWmNneWY2?=
 =?utf-8?B?S0I2SDd0czg2NWtkb2VWQUwxekYwajdTMHR3UnFFMWVwMzJzZ244ekphWlUz?=
 =?utf-8?B?cTVXM1N1bmJRSjhEd3NhRzNpMkdxbkJHNVlHWGhtcXJLTkZUZ2VpWlhJM3BE?=
 =?utf-8?B?bk0xUytqanNPRW1kaExVcGZnT0lUZE5hOE5zcU4xcXJTTVZhOVFiMFBWdmV0?=
 =?utf-8?B?TTdHUkl5L3hNRk9QSlo1ZGJPRnh2K2dNWFhFTEpiUGx4ZmVyMU9qVU91OVNp?=
 =?utf-8?B?SGl6aUpvakd5NzRGKzhSZG1xOGcwSUxrM0EyakY4MXU4RVdhbWg4QVdoc0NU?=
 =?utf-8?B?T25pbzFaZUNUZHU5dk5pcE5BamIvTUE5bUN1Y1dYdGwwMUNNZkFqdEhheWk4?=
 =?utf-8?B?K2tMVmU5S0MzcWE4YTl4S1graTB2eWNObnUxNStYNE4vdUx6ekpCZXUzYXVl?=
 =?utf-8?B?Z0x3elQ3czgxbXZuM0t5eGJOL2tuRzRlVEMxeGxkVWU4RU9DMEJMR1J1NDhy?=
 =?utf-8?B?MC9iT3FBNjd2UW5JTTdHU2JUNUNCdW4zc1dteEh2K3NVQlpWci80a2h5TlVF?=
 =?utf-8?B?R0VZMVd3UGxlcEhxdnczNGMvcXNyRTFKOW5ydm5RQnRXb1lISnlBMlY3di92?=
 =?utf-8?B?WmQxUTlsUEt6cDNxZ0dnQmQ4c3FvRVJtVURxbDQ2Q1pOcTloWmhOZlhEaFdL?=
 =?utf-8?B?eU1DM1g0Q2p5VnVTSWNBNms2STNsZDh6SW9oTDNuY2VMRTRuL2xwZUJOaEVB?=
 =?utf-8?B?b1FyMjQ2bTVJZENydDJob2ROeXpqODJJRU1ZYjlkU2wvV2dSSW5Cakl0RFdv?=
 =?utf-8?B?bW1yQmRZb2U0cEFSb2dld1ZzMHlOZk03anE2ZXpSQ0tRb0VNRWlNajJuazNs?=
 =?utf-8?B?U2orQWgvcU1rK2tiS3hFaFJKR0VndkZRWjdRL1d1N1pQZ2pmWVhnNkF1TG0z?=
 =?utf-8?B?em9QOERLVkxTbHZFSDhLSVppQ0dRdjlrWjFwQ2FrMUQ0T0pBN1hWeTdmNExX?=
 =?utf-8?B?RUxKYmZXRGNualVEMyt5c1Z3V2ZUUW5RNlAwNWQvckxWenYwcmVTSnE3bDQ1?=
 =?utf-8?B?OTZkM3EvakdhZU40MGovREhTd0o3YXpqbVVmcW1yYU5sMlhUNG1INTR4Z3F4?=
 =?utf-8?B?WlVDSFhaOFpMYVhtVlRXOGhDT1oyRXpPN29VSnBoNjRJbEdBaTJRY24rU2tr?=
 =?utf-8?B?d1krTjV5SUdiRERsWDRSZlFaUzFEODhhWkk5azdTS0ZHWG5BdW1pekFpK1pX?=
 =?utf-8?B?bE05UTRZMHJjS210RGt5RGkwRWZIRitPK2gyTkRGL3I4OXlMY0Q4UWJBeS9N?=
 =?utf-8?B?b1BKMzRvb3RieFg2WFI2WXRlSFRXVm5zeGxPTFhmM0J4UmZGVExYbkI3Y2w1?=
 =?utf-8?B?dFBZS2QwUHlmVW5nL1djWGV0QTkvczN3Z1JzeDJqdVU1Q1lmZG9abzhCbEpN?=
 =?utf-8?B?dVlHRnZmYnhmT0NCd0lvay9KaFgvM2c2aVEwei90RFpyTmxENTRZSlcyTGVZ?=
 =?utf-8?B?T3QyamN1YUVrdnhKYkx4RlArNEZ2bFRzRU53Rjh1azBTa2w1RVd3UkFFd2s4?=
 =?utf-8?B?a1pqZVkzekNSeUpDTmdlMzFDTVcrQjFBMk9MUlRGbjNLaU5rQVZZZ3lVNDFK?=
 =?utf-8?B?ZlhVYjVVWCsrc0F1QUpZNVAvZ1N3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b514c0d-abed-410a-af3e-08d9b74f8ac4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 17:57:30.9690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHgHVyH+0ylrPumbvy8YstYv0Ru80sAVFlLwJRQqSRH/LB1eIcVsYaloUHiURqRjqMLvLjHuXWXsY6nO/hPA4AQWU8PIjfzcoiSOCbDX5Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2955
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10188 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112040116
X-Proofpoint-ORIG-GUID: giELooln7LgWgjIHVa7WfxYBe7CH-fwi
X-Proofpoint-GUID: giELooln7LgWgjIHVa7WfxYBe7CH-fwi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/21 3:52 AM, Manish Rangankar wrote:
> When issued LUN reset under heavy i/o, we hit the qedi WARN_ON
> because of a mismatch in firmware i/o cmd cleanup request count
> and i/o cmd cleanup response count received. The mismatch is
> because of the race caused by the postfix increment of
> cmd_cleanup_cmpl.
> 
> [qedi_clearsq:1295]:18: fatal error, need hard reset, cid=0x0
> WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296 qedi_clearsq+0xa5/0xd0 [qedi]
> CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        W
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 04/15/2020
> Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
> RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
>  RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
>  RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
>  R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
>  R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff9761bf800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
>  Call Trace:
>   qedi_ep_disconnect+0x533/0x550 [qedi]
>   ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
>   ? _cond_resched+0x15/0x30
>   ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
>   iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
>   iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
>   process_one_work+0x1a7/0x360
>   ? create_worker+0x1a0/0x1a0
>   worker_thread+0x30/0x390
>   ? create_worker+0x1a0/0x1a0
>   kthread+0x116/0x130
>   ? kthread_flush_work_fn+0x10/0x10
>   ret_from_fork+0x22/0x40
>  ---[ end trace 5f1441f59082235c ]---
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> ---
> v1 -> v2:
>  - Changing cmd_cleanup_cmpl variable to atomic
>  - In completion path instead pre-increment use atomic inc.
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
