Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5900C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70DC7600CD
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhDBDz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:55:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44974 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbhDBDz2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:55:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323quSd157066;
        Fri, 2 Apr 2021 03:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/zl0UMNbsucSHf4K6OKOjT1ZKfK6+rR+H/t1xE70Lfo=;
 b=X4rBZzUz1/6A9k7gDdfmGqCXCBmqcSxv9G8b1BrKsaejM9VjTYPNef1ARYeWz2o/ugMT
 fyh4RmE24If8w6DnemLfGQNZNmjp0l58xP3ndBV4W7cpT5KzucFr6azDQ0JfpOuebO9b
 O48yn1+NtqJ3Mtc/7d08niWg6OxVkZCTJWlVh68SORPcgqj8sixJuIR7JaDkMAPBA/ve
 P0X6Wgkq7zXiGIxX29n34eWv1lu8NlorZX02BkpPHirfY5imjV9J22h/NRn3HGHqur/6
 UBIiIz47Bq1wyyGs0sbwVNKeYjKBTKlGZXwL2yJgwqFGE29YCjlZCD0rG4DPLfZGpO5/ 7A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37n33dumsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdpw101561;
        Fri, 2 Apr 2021 03:54:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3030.oracle.com with ESMTP id 37n2atmxf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW1nT9Iw0Zyf4Cu/5CdIzvu8vafhSW2lQvsA3mdQOPgb6VSELTAJaZ89kRiSDNAH3s3t2+EqY4+8P3FSZeTE1E9V3BKZkgADnd1wRJWNJa7aC8ALI8+dD4B3B9tiNqzslZ122BTwmFDc7T5ubFhcsRz4JW660UG0ArCQpJlMX0lHmWov/PNbu9P3mayDQgvu9ky2FRP84huEGxpRUgfW84C5iT8IMSVxEcm4FGvwQcj61CaD2ziXaak46uqNAUnzn58pRZwvZkuN3psVqbbrpdcJMfZcjCh1jyB7FbNnxWjQCQoOd1oP8SC8CAajPjJeuYgsWmho/p2na6n4y2CBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zl0UMNbsucSHf4K6OKOjT1ZKfK6+rR+H/t1xE70Lfo=;
 b=ftxk+6zGNybDoBUjUHbV9VOFlAuZtAO3r7o0jM2vlhHRSHX3Tl5TK8PGD8smWUNwrr0e2kMzRLOz0L34k/1FhfBSJhCwXqGh+QSUU5Ds0dhOvPhZrERX9/1iHs0qoF67iZt2SXPQ98SsYIyeY4L2+pWKYpLZ787NOlaFsbmG8wHBRsCVqf4WNzktZdRNJOYXuwAmBGbbRCk0y+hnXgROZZBUvrMn6FlwcecgXy/jD5M5k3J5jLBV65tB/qJrSB0jwysS9svvyEV8sPWijbEgjZbEG4VG7rp/V17jvGnqC2+cu0+DPkpN7FGoeQd+eiQJzMb4noL530e+rem2MdWmrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zl0UMNbsucSHf4K6OKOjT1ZKfK6+rR+H/t1xE70Lfo=;
 b=A3u/rDFv67Ki8V2RgmanZxPzSVMa6Y0PIlP1H3r/n/xNM2x83D0AFLhTz5XxNQ/er6Jdg3gIAZSMeqJ6mQbXcwlEE6txXO0Ba+6fhHVDKcVt67JgiPakgs5cS0s03bcg8q2nR8hVfoZ6mcxHNOR9s2Azsb2eT3Qp+lgvFsO+YMc=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 03:54:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     willy@infradead.org, hare@suse.com, qiumibaozi_1@163.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        ganjisheng <ganjisheng@yulong.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/6] Fix spelling typo of is
Date:   Thu,  1 Apr 2021 23:54:20 -0400
Message-Id: <161733541352.7418.421905160882961473.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326030412.1656-1-qiumibaozi_1@163.com>
References: <20210326030412.1656-1-qiumibaozi_1@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cf3cc6f-8258-4909-46a7-08d8f58b0611
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680815FD61F180364B6C5888E7A9@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n33nSep/pmGRUl7VpnprdEI5C1h5Ioqxfv7S5OtkBBt8IaBRjpJ/y5woLQA3Nfu4KjtQcut7JMj60f7qr48mjrIK/LyhyK6Mb/SNo1R0PZxbqt3aiHOJHSXq/5JMerNuCrKQ823lJU/DtLme+ZSazyw/HGzftNCJV+ik9zI1bE+kBGP3vO3mtf6kuhKf3kwGp90Yb9dDcpgBm8+l9fcZzuc8bL2PNg2oOODFuQHUweaC/mzgG8GUsixkQgbDnfq/x10nU1sDZaauPrIOXeJzx5JmKTpEXlzoGiH6/P3Yajj5q8TyTMwVqgwuSSBMWyfXmr+2H50BLhfaq2qG+TW2RwzAUo9rU5a82LZVCUoOwd4Kcf2dCJMLbpracF19DhmOaSapDLymgxQu/VI0Qp0Btsr/Mse/3dlvDFT1IPph/rfRcjeHhDAcN6HB3iHJQrOH2Z9TsDJO1wtKyPszREiBprlO7y7xAohUdsRvh36yW6ex2fVpFUUWGxqJMVlIiJuM1qzxXL4egqnSSkmZxTK8djpzvBJF7qood7psAGpdqI6AeRn+9twxFQWvJ5G46FYz+KmYSqtViHFZYYcS2hOZp5wUgwvsyz4ejYJ8JVzAKpcllIvK2CwK7074RrwpiOut7wGcbGINSzKMAnO6Y/LKFDiNrWajphS0LdoaYdnYTNkmPJnXicodr3Q/8z86OVqV8dvzXfCOg+sG8UX8h7uFBV0FdpOfPhB8WR/o7yY0TvY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(26005)(2906002)(558084003)(2616005)(38100700001)(956004)(16526019)(186003)(8676002)(36756003)(66476007)(66556008)(66946007)(86362001)(52116002)(7696005)(103116003)(6666004)(966005)(478600001)(4326008)(5660300002)(6486002)(8936002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TS9LaUNmd3ZydENyUllHVU93Zk9qTEN3QzM2QjFQR1lSSkJLWUpUQTBxWDZO?=
 =?utf-8?B?bW1jUTFQamxERXd4RGg1cDNGeWNSanVzU2p5UVY3ZDNHK2dOZVBUQmpodmpX?=
 =?utf-8?B?RHZhTkl2NWtuN2RoY3JRRGJBWmlFbWppSmhvRzNrTTVINEVXL1hiWXFRUDV4?=
 =?utf-8?B?VTZwTFNhNWZvT0t4QnloYXFJNHdwVHoxWEhOaDNPbDFmU3RWM2RqNU4xNTB1?=
 =?utf-8?B?ZDdGOXpZeXlQcmNLY002NHROM1JrdkhrYTVSS3R4MGE4WXFSOXpOU3dGOGZp?=
 =?utf-8?B?RytHQVY2SW5mMjl4bGdpVGt6eHErazFkZkFOMWc3N1g1K2wyN3lVQkRVcWs2?=
 =?utf-8?B?ZGk4eGdBQXZNYnJ5Slp5U25XelBianRob2hqbFZYTXB0Wm1WdXVkY3kxZWVR?=
 =?utf-8?B?QlZKWlRCWWJCL21rdzdBb2xhUnZ3VDFzS05OaHA0Y0c0bzBGUXUvekVJR0FF?=
 =?utf-8?B?cVdXSVFIODZmT3NYOU1wRGl6UDRGM09PaWhkeHJ0Q3lxWEFnRGdKN2JSQmxL?=
 =?utf-8?B?b3R1dGxhNTJEVDROU0p2dk5YaVppVlRwakgyRzZnWHBGNk9IbjgxK0RGM3ph?=
 =?utf-8?B?QXN3Y1ExWTVPSkNUbGVCYnh2N2p1QUFHczkwcTNTaFJVaTVBdkRGL3hJOW1j?=
 =?utf-8?B?YmI2RDJFbVJXSXRLR25wMUVVQzJnTkJmdWxMUEJXUkFqeVc1L1g5Zk5yQWNO?=
 =?utf-8?B?ZFlFOGRua1JBMFM4VWJyMCtLeDZIYzV0NWlmd3JpaTNudWR5T3hTd3dUNkZj?=
 =?utf-8?B?Zm50bnkxQnZ6L3FGZS8xbmJabHVOVWo5dWFBeG9IR0Y4aXpqZUJFT1RuSVJi?=
 =?utf-8?B?WEIyVGNnTXZhY1V2M1NQRG8xa1RhYytlY25MMXNvOWhxR01NMmpyNzZVYkEy?=
 =?utf-8?B?dnVvdG5Za3YwcUVieW5rTzNSWHM5OCtFZW55aUZEV0xvYm1tQ2NsSk1zNWln?=
 =?utf-8?B?TTB5Rm9TdzJGZFpnOHhwdHpjR1d1R3N5Yk51UGMxZEJ0L2JQUUxiVStKSlZL?=
 =?utf-8?B?SEZHVWVpNktyeGdBMmp2OEVaTkYvbmRaNXlSZEZoMWZnT2hZcE4zODNQZnRC?=
 =?utf-8?B?SExYVGtaeDJMZWZqR0xsaDRqMkdQL0lLMXJheTZoTUorRCtxNGpTb1U4NXQw?=
 =?utf-8?B?NkV5N0Ewb3JVWTZ6RTd5WGpqaGJPWGxVeHZOb1lWS2kxTG5ETzB2a2hLcnhR?=
 =?utf-8?B?dXNMaFRSNlFCZG10WXNSOUhuTkFQUzM0bktlb3RzTStYRk5sOTJ0MFVKOGh6?=
 =?utf-8?B?NDR4UzYyZHA3Z2V3OW1uekY1Mzk1VEFQRnlzR1NSNGh5L1QzNm5zN2tEU1E1?=
 =?utf-8?B?YlAwV05UYWRXR3V4cWEybzA5QnBURGVBeUltOGRhRjY3eElFV1JjTjJvd3Jn?=
 =?utf-8?B?YktJbHhTZGp0c0lOb3NQSkRIRnpxQmh1STVRQktvdUhRT3daWkJxTVppNXhQ?=
 =?utf-8?B?M1VFT3A2Mm94QlNVSWxKN3R6elpTcDI4UWRPb25rZlR2Wi9ZRno0Sjh0VENt?=
 =?utf-8?B?UytIdHhIbHhaWHBjdEVmZHJwQSswOGZjeWMrRVFzcGhyaExMR0tIeUYxWVQ5?=
 =?utf-8?B?QXZ4TndLNytMOENJd1ovcERIdG53UlFFcDlScDRySktwK1FpRW96a09xc1Nx?=
 =?utf-8?B?MVJxY1MrTG1MUTJCNzFJWTdHRWxlblJ5S2lEM0xmUDB0cHNiTVNkSHAxYUt4?=
 =?utf-8?B?RHk5SW0xYkhtTHIyWnVoeDJHbEdLY3Jnbmh0ZGpQaGJoWGNqbUpJTmgyc29k?=
 =?utf-8?Q?Wosr1srVPwZLgg3Va1J6pN79TT/ByrR22sGFdjL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf3cc6f-8258-4909-46a7-08d8f58b0611
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:32.5592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3opFo1GJTwHXXtv6MI7bFCUlqyYmN+iKhr7VmA/Cj7phgoMkHMNDlyM3CQ34P0Vu7KfbYVP57G32qU2tL8tS3kCKPnrMMb24BQNuRIafpHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: X0QM5qFyBdwRs2M9F_O7dqcp4SJKjzi5
X-Proofpoint-ORIG-GUID: X0QM5qFyBdwRs2M9F_O7dqcp4SJKjzi5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 26 Mar 2021 11:04:12 +0800, qiumibaozi_1@163.com wrote:

> 


Applied to 5.13/scsi-queue, thanks!

[6/6] Fix spelling typo of is
      https://git.kernel.org/mkp/scsi/c/ce0b6e388772

-- 
Martin K. Petersen	Oracle Linux Engineering
