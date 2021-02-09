Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47021C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE92964EAA
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBIDrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 22:47:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45200 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhBIDpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 22:45:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1193dQV9006509;
        Tue, 9 Feb 2021 03:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ebKUckabBkKaKbrktN+a1z9aalb5q07ckO10BXOtXZQ=;
 b=qApd2qOACSxEwk7kWMrJELup+Kv6QQBAC8zlmZr+fymZXe5Essrm2MRh6XwvQEanbjBq
 Eq0u00HtLR2jMGftu3m9UY0ik922wgm79TxjuUyXRtUSwBCsjxYrE91MD6jk0Bcq6Vix
 GR/Yr6EB6bee9R2MunXZY4t9BHEPBE6RYYlnN9cgpv2UaLKQR5Z1maW/uMoHM70Gpm30
 pzwFK+kq2g+3oPhCZqbc8RlxGyA/QK8pu5XUU1/6wCCvGGq9L61fb+tJnWPTVbGVGwzZ
 iIXoHiCo2JQCGcPALTgS2YXIg9utiMF/3m3GcW1Epb2vj9Oqk8zGf1vsCCfABgMjKYvK 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36hk2ke49t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:43:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1193ZtPH145236;
        Tue, 9 Feb 2021 03:43:48 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 36j4pn5bf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:43:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmF6Ep88TxeTRYLXmznflRYMNHtwW7meNOkLXpRMWEnWV7lxMBYAbyF3ZdevbZcu5EqUWEjcRypLTdJyVFMdmlGkq6JXRSVm4qDY0zvOdSs2uQYEnSQaqHAIpN3vJ31tsBdmUJfvSU/4Z/+STapMHGUJBrdQ2nR1jGZgpyAAWFv9nWUkfIvMKURQXM90/v5+xDytQuc3Exl+C+qF4ifLTAVA0Q/6u7sNQjNYabVyx3yxEZtJ+LgJro/fiCbhpURBsUFO8OKg1WEJZNP0oMhn2GwqZcZ0nloHCyfA79h2LzRCLLiLFvbmg5uydToSn+2/2Ib2kmxzWU7IVwf9Q3tT+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebKUckabBkKaKbrktN+a1z9aalb5q07ckO10BXOtXZQ=;
 b=eTOJu3C0xJKo+kdk8ykr1JrnFfumlcKJkmL/8koVvykG1+/4DbNRmZVvOJsDo+JFQuNE06YhQ71R5f5NphHr23qJZm3HDic+lqAHH+T/UzEJqBi0JMOqET7JU8wA0yTQe/5eaCoqdGM1EvqYrP8bi52wdb42HosQEa99FR4WMSTjeIf2UETK5gPHezDB39YbNRYNd4bBK/sV6yErRs0PDW8HCm45631mlrOaILNGcLiiD2YeDO8Ix7VHv4X204/LOd4UbiCxYOXFKBIgYzRZMugDkioOBMydseP4B0pDHpB/dHetZCq2kcoPaC6uqAHZktMXcl6Hd4Cx3TCgN7xywQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebKUckabBkKaKbrktN+a1z9aalb5q07ckO10BXOtXZQ=;
 b=ZiAT4m4JddBXAdfq5Eg/j44wsEBtEBnc2LX//ucY5dO1hdgAxZ3M19h/YWUrioevLK9SzDsa1eSyO72HlPFfTktlTaYK2YANYq52xr5lxJjZfzB/ZOTaBQkY9AU+C/TvbhPd1ggvgDCKg+NFRYO8cTwHu4Eof7Gsc5ewNa0/jb4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4773.namprd10.prod.outlook.com (2603:10b6:510:3e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 03:43:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 03:43:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Maurizio Lombardi <mlombard@redhat.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        dgilbert@interlog.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: fix a memory leak.
Date:   Mon,  8 Feb 2021 22:43:41 -0500
Message-Id: <161284221311.21359.6595318344553298814.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208111734.34034-1-mlombard@redhat.com>
References: <20210208111734.34034-1-mlombard@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN7PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:806:121::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN7PR04CA0082.namprd04.prod.outlook.com (2603:10b6:806:121::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Tue, 9 Feb 2021 03:43:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e9cb061-778b-413d-3308-08d8ccace705
X-MS-TrafficTypeDiagnostic: PH0PR10MB4773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47731CB19B0DBBF48A0B41D78E8E9@PH0PR10MB4773.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DNlhLMeVOl6hJNJx/YKO/P95iJFUwcccnWhJTExKu+7IRSYQnVLh6qTGn/S8U9M8jqVj8qMIMUyxJ6c9Zj4qCIWDyKpQj+/V7NTPn/8XfKGnnXVEm2c8z+YnbIdN5motv6/rH66+kNt1UfGKyU0BBVHpEW4HQUDzgWw5j/mY6lLDXRYun1qAO3saGrP4XiO04fnxaBNJ3vOUTmx/eeEqqUu396wDKgbI+qTlzjaJINWpQ/TjbBzCQAQ+4Sjee2MIY4IGY22o9vHaJPreOk6egBrwAnY2/uT+GfsH8jF9OnCNaxoG20lzvQJUMctg6uuj0RY4Wztgvhw4Puf9mFi1rBudfHod23Ei1O9k31fMpruEbWBp6rUtfjNDjvVT13EZS8h/LRYthVafwEWGDp/JlBoDHYlV73D0eC/r5kA4M2LNMAEJvP6Ij86tqX4aYdLxGfKg1TJjgg0y7mo9tdiqiLM5bK61dEtSKlELTyBd2YBJXz3/bPRvWY0qlvT0np5Z8hjQtIQJPEKXEx1VNq42ouxbc6LmqZFYZ7s/YfaYaxR7QLV5XTRlSwgHEVxDPJ6Iq6VUsXAHEtxMmNKHF0cC8HDx3Xjwet0YB3v0krI68ParhgOcyh7EePOgAYasNO3V+6MFnMYlkaDBB7PkG21kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(136003)(346002)(16526019)(186003)(36756003)(966005)(103116003)(316002)(6666004)(66556008)(7696005)(2906002)(8936002)(6486002)(66476007)(956004)(5660300002)(52116002)(2616005)(66946007)(478600001)(8676002)(26005)(86362001)(4326008)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QnptVVVqdWd6MVVZUXNxTDhmcVVsdWlRQXQreG9aeEZxM1hiQ2JSZ2FMQ2lS?=
 =?utf-8?B?VHRZR3JIQ2ZZZDZQUndSTTZCMXpTSEI5Zys4UytsbEx4aEc3ZjdkS1lwQUlT?=
 =?utf-8?B?MGYySWpYNWY3S1NBczNmRkYwWWgwWHd2cFJtMWJSdmNwU1NsdzJqZE1Gd2Ry?=
 =?utf-8?B?QUVRcXIrTEFWYlN5NnF4TUtHdmJReVM4Q1gxaUxxQVB2VDdaVFZPNk1LTXNY?=
 =?utf-8?B?U3FhN1RrL0JQbzhpdlo3dzdwZjNBcUFFdUhRQVUyN3FIcHRENUJtS2NNcjZ4?=
 =?utf-8?B?QXBnTUpYS0JHNzg5a3dJWWRkck1PL0FFNStKYlNLNUVJeEp6M1VJZVYxNGJY?=
 =?utf-8?B?clpFSXU2WlRGd1NSMUtJT2c2dWFQTXNSWWloU2liaHBPQSs3TXltOTk3WVd6?=
 =?utf-8?B?NWt1RFZ2VkR6WFNVdS9wdGhLYUZpNnlkUDVHRGZJak9zSjhoRng3cVBlZmpo?=
 =?utf-8?B?Y3FFamFNMGE0M3FodjNpbVREaHdoY29FVTVaSFRrQVRjWklvb3c2NjI3SUhs?=
 =?utf-8?B?WlNTWjF6Z0RGeHBpVUgxbzJrK3pRWTF1L3h1OW5IWDc2RjRqcmIwM3g1MWJH?=
 =?utf-8?B?Q21mWjdQWkdkL244VnIwQ2dzRk1pejgxZGVGdUtTcVZ0bFM3TW9pT3VxTGNI?=
 =?utf-8?B?ZkRPYWxPNzhmMVg2cExIQXlsaHB6Q0V6RGQ1SUVIWWo1UDl1dDZRU3JuNU1E?=
 =?utf-8?B?TjJQbi9WSFZCNjU2NW9ndTlOenErNGdXcmkyYkpBeVh1YXpNbjV0a3JJWERK?=
 =?utf-8?B?TU4zT0VpT1BmVmNnUTZodVNwcDFxVnNxUUx2NWd6ZzV0TEVDQUZEc1A5Y2xs?=
 =?utf-8?B?VzBSQ0MwOWhnbHJhSHJaempXKzFhTmFWUlk1MVFZdks5Q280amFoeFNRSk5L?=
 =?utf-8?B?L2JTK1pxWWVDRnIrcXpSVWUwekpyUnNUcTBZYU1CanppSmM3dUNBOEJKZ2hP?=
 =?utf-8?B?OUhoNWdEV2ZuSG9pWHQ4MFBabnhqK0ZIZXV3K2RBRExzUWx2eGtiTnIrNUxa?=
 =?utf-8?B?QTQxK3QvNzdnSmhudDNHWGtKWTJqTjlGLy8wRC9Xank1SVdtcjlLb29BQTJw?=
 =?utf-8?B?TEg4WGRCYTFPdGhZMDd5akhiOTM4MmV2Q3NqYzVhQmRjOThNdkRXKzJ0ZGhK?=
 =?utf-8?B?dzZ4dWIwdGlRQmUwV3hrTVJnajFRMU0zeXNKUGZXekl4Wm9qbHRObXJxRHRS?=
 =?utf-8?B?ajdwZCtDejhEOERLQnlXc29GZWFyazZCbjVJVGFaUWc2dGxDNVM4Rm4wWDNU?=
 =?utf-8?B?bGdQTktuRGFGdFBhdHFjMlhSL3BoeG43MzZjS1Z6M0NybHBVRXJRck1FamNI?=
 =?utf-8?B?ZUpqWGVlVy9CRzd4NWxrMnJEeEZHQlI0V0c5MHdtcU5xbFFib0xzaXplaFc5?=
 =?utf-8?B?MU9DRmYyMjhYSU55T1R4RGlacFpnaHNHOEFncjc0SFdGdC9vQjJLcUhCdDZt?=
 =?utf-8?B?cmh6WVJKTnpGaUlhRTM2QkwzSjFUcjN5eGZObDFhVVRLa2E5dXFJTEQxcmZR?=
 =?utf-8?B?S2V2NzZWR0xockNqck90V2F2aEE4TjN5WU9KcHdYNzd2dktvellVckxGY1Zi?=
 =?utf-8?B?eG1XdWIwSG4vWnl2cGN1RTJCTGN3VXR1d2JtUXdkMUZESThCLzNDVkoxT2Iw?=
 =?utf-8?B?c1J2U3VBMGFCa0NzS1g1NjVJTTUyVE5BaVVzcWVGQnM5T01RVGIzMXlWTkJV?=
 =?utf-8?B?Yk9kYmFZU2ZpRUdtYjdsVHo4cCt6RExtYW1ieGladDRreW5KNzYzQlA4SVZk?=
 =?utf-8?Q?f98i2PMAKdkC7CICyhOEz0VkO9htc9PHZcXEgyH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9cb061-778b-413d-3308-08d8ccace705
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 03:43:45.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9984nnSjAYCjEzBJijeR+a9GVlp7xKZgq5avVGVsLUpx2dgITJuVsco9OYDyXDasyrH7qzIU5W9NK1kzjpGQ5wRMiRca5p4E23HyraXssHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4773
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090004
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 8 Feb 2021 12:17:34 +0100, Maurizio Lombardi wrote:

> The sdebug_q_arr pointer must be freed when the module is unloaded
> 
> # cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff888e1cfb0000 (size 4096):
>   comm "modprobe", pid 165555, jiffies 4325987516 (age 685.194s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000458f4f5d>] 0xffffffffc06702d9
>     [<000000003edc4b1f>] do_one_initcall+0xe9/0x57d
>     [<00000000da7d518c>] do_init_module+0x1d1/0x6f0
>     [<000000009a6a9248>] load_module+0x36bd/0x4f50
>     [<00000000ddb0c3ce>] __do_sys_init_module+0x1db/0x260
>     [<000000009532db57>] do_syscall_64+0xa5/0x420
>     [<000000002916b13d>] entry_SYSCALL_64_after_hwframe+0x6a/0xdf
> 
> [...]

Applied to 5.11/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: fix a memory leak.
      https://git.kernel.org/mkp/scsi/c/f852c596f2ee

-- 
Martin K. Petersen	Oracle Linux Engineering
