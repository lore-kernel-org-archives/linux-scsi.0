Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CDEC4707F
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C56961090
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhEVEmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:32902 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhEVEmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4em7d033392;
        Sat, 22 May 2021 04:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Yt1ttDyGosnOs5ofzCjF1g4R+eqYC8rS47jZsF+9vek=;
 b=UerTtR3MZbkG4uK0iLnqWDnYQT8nU2VQ4fKl2Kbc4h7PLuLNSo7pgGc0xnE5xBz0I5WD
 oeyGJC2r+cZseuTErLJcWdmOttVuAdUmBxv3SRX4NZgNNznJLxlb+i2fOOPPa/afRo74
 I8F8waObKJJwbNjXlfyUDzKJlmFX49LsV2BJ2JErucA236wu9IYx0pNDw/nPuuGzlQ29
 KAAQeabDhlBTtoVo3PH2AU6wy/wasMqsO7yoxHweQaMZ92hMt4p5M1CK3BuMpuDELsbp
 ZAqpi7kfHd+nrxqrMsAk0KdZcBvuswMSDzQkVyB7uaD7uywn8HZpZVcoRi3XPza4gcmg 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc846u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZiRn168410;
        Sat, 22 May 2021 04:40:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 38ps9j32fa-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdRWrS72keGL5hSjCRjP3GbmMz0H7CoulvVe9HsB4biEisslMG7YOCZeAklDRjDwfh+VTzhOpIBGayRsd58ogmC2LNeYXZrEPhq/b6Hj0ZjCpW1jCNckAfWp0DODDfYiNdZ7CuR2YYPWHl6AOXbv67LPW8Dt7AQB8VPRvo0f/pLy8kECxPjsp1XHzJi4Lz7vsyAf99p/qn6MLldxgokiC/Npx8zSqMMbia1V1gm7ZAk61iGWH5c5fWIuLVXTLI+iUdPRsZjXlTcJzSVrvw2RhqIM1jgFHlBaAlfv/m7VbCl1qdvVUoWlwrisTeFUJ3dJ1QsQSE6lJDJvxAj7+yDZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt1ttDyGosnOs5ofzCjF1g4R+eqYC8rS47jZsF+9vek=;
 b=TIyOVj7Ey8hbmdA+xcssAKc0vwsnYN+74ei3iKeU7di6KVqN/ZLSObThxQcKpwzzAJ8s70syPp2xMZOG2BaWDoQU92U/s5IUq+ubuoAeCyhy7uNvZa4EYLDzMhS+Ts55y7w1YgDDai4RVKMESpwm+NVUPX/pCVqAzbxUE1IktDn7lIhr9WMgiGKPTn3dUlynv2eJf4CHD2Xwt/auSX1w7E7OoSSlFDnw+j5eG+C1tcUJby0fC2hzqOMMTmYLeQxJ8kBwlq6LOXY/BUKmjEJHVH8cu08fugjNRfstwSRhu5yc02scDBgZD4/MUeiBkJn+cXFJfNyGJ1uRt9onwcX9zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yt1ttDyGosnOs5ofzCjF1g4R+eqYC8rS47jZsF+9vek=;
 b=lXRblvWRxHBcnkRyfy2/E0NX/khmlhD3fkVYVW9WceSC0YHxL7BRJRlBI9Be0Tc87XUiG43ZwsR5wsE84iF+oeC8JiBlsAdLWxTrWLuDz2GCfljtTG7y05TLJQd/0dsyccgIwcLYrrPnZt/f7eQuJVxpytOV2MXtX7w7/2LArbY=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     shinichiro.kawasaki@wdc.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: iblock: Fix smp_processor_id BUG messages
Date:   Sat, 22 May 2021 00:40:33 -0400
Message-Id: <162165838887.5676.11490489872740728440.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519222640.5153-1-michael.christie@oracle.com>
References: <20210519222640.5153-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9883afaf-fd24-4738-601f-08d91cdbc3c0
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5481153CF83B1189F3A9F35E8E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CwmPH6EEGi1Ax1uXWX6lHHatQatJmjNegzboleFKuLfCqQMVoycpFmC3kdskQ1gl3eF3A9SZeHWEGSYpjcy76gkjLCuoweE6D3IT5nIbcU2gEyPZrdLQFW/ySGTrL29HFz2MQt2Ptvp/8xGkppSpTmwiZ30d6riI+hcAU2gAqQ8LKsUhuR4C36wzuP6Mc+L5Zk8YBhTg41HVwRyqWBguhcCo6Z2uo2Qzi/u5psOQTUZZgWHZ5u+roIKyHtsRdVEq2QxU+IYVE1W+nk4Ge2EE7GGyXDdcFH3Lsk1p4nIGDnfRgIDBnc/BB7Jd2HvfjBzUl034XZ6XFUdRs4Jg9w7sxHFyOJMGBLzjIF0hMKhdMt4qhEP7w7qtZOTeeNnrLVDY9RvxY0gqb16I1ruaLzSFAP00d1e5KsOYfZCLaaxTDZvnw93lrlsm6e3cUJT/0gGphqhbhlbuQLcbANxfoJtUjmxn1yCTARfnudhysKFWZK8fOIy84Oh3Dg1TPXb8wcsdvB0+Pl+va0CdigMLYp7bIJbMKiRZy3I90djIU/LlMMX/gOamdyqob2aq25bPoDQJ5ASYfWlg97JTiB5DDauTSBISweBGB4m8HF5sEK2GSO39ot39ztc8btTll7hkXuXEB37zgxhvzD5n1yvGu5HCZfoCplqSovcBYfUFRujIXbcANECM2ubrluQO2hfggMS46shC3Wkfp/AcIa42CCFTbbmwhnNriK19SviJ4qkjT1Nw+zzkSn56LRdLeYPMV9QCIjM4VQxBwWRb3HGMTlG4HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(37006003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(6636002)(107886003)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(15650500001)(2616005)(86362001)(36756003)(4326008)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UnF2bC9Zb1JQK2RMYWVQSkFhekxBbU96SE5zVi9RZmszQ3B4b1hjb2s5SzU4?=
 =?utf-8?B?T3JJL3phbDgxaVROTVJNVXNqS01pWUNJdGc1RUN4SCt3ZGdpOHViNzVQNTdL?=
 =?utf-8?B?N0h1QU53OU9pN2JCZ3NkRm5GQ21oNGJ1cGpqWHRPbFp3Y3VaZ3M4OEp3VnJW?=
 =?utf-8?B?Y09WdndvSzlqa1BkRXZCZlV5ZjBuMHpkT25qN3pRcDk4RC93RXJ5UWkrQmlr?=
 =?utf-8?B?OHl5Y1dIdE8weWNrbE54ZFBUWHNDa0EvY1JmbXIyUXJuK292Tkt1WElLK2hE?=
 =?utf-8?B?czVLeDU1cEVpYjBGNmRvQSszOXZhOUE2Ti9qMS9uaFhOSEFVTG5XdjhiT2xH?=
 =?utf-8?B?RXpKaFE5WTVtOUZSTDlPV2YrVnZoU3JsamlsblFhVGYrb09LWUF5cSthQVND?=
 =?utf-8?B?d3pETUlsTlpNRG9pTkkyVzdJVEwrb1NhNXExeE11dUNldlhFYmY2NmJZVjU3?=
 =?utf-8?B?RUd5Q0I5djVHYUQ3YStKMytMRXBjbkl4cE9GOUdYdldPTTQ4TEo3c2RCazJK?=
 =?utf-8?B?L0NkcHdJdHBwVzVlNktUTnQyNEJnVktoQlJkY3ptb2VESk01SDhrVmhHbnc0?=
 =?utf-8?B?ekc0SThYNzJ0Ymk3ekxkdnFoU0NIT0loUW95bGdIYnZmRk1haDhQRGQyWVdj?=
 =?utf-8?B?cENFcE5KRnJvS1MyYnlKcjVEMmdENmxwS0Y4VVpFU2ltTXZ5VjU5S2RFVVBO?=
 =?utf-8?B?R240NkhUNnppYUJyWWxDdFh0OUxWMkg3Ty9kVnlWaW9sY2ovTGJlS0k3aG0z?=
 =?utf-8?B?Q0twSStaQWtRa2hHOGpBZnA0ZDNJeVVlL0ZIcHZ1eGZjck56bUQveFNiS09w?=
 =?utf-8?B?VWd3bVRoUDd2UVNIL21WTGk1cW1JRmo2M1RQSmdhck9kK1NuUFlFNXNjWmhm?=
 =?utf-8?B?Nkwzbjgzb0FzSTFlWmMrNm15bHFPZjNJcTB4NitwV1NUbVBodEhvcFYrZXdZ?=
 =?utf-8?B?OUhHUm01ZktJYmVTRDdwN1BrWklMcjZ3MGFhMThGQ21kNXBZQ1JRTDA5bmsr?=
 =?utf-8?B?SkFUcmRnWGhKRXkwUHVYR3huUTVhTGNxRjg1VTdoRzhQLzJZWVZUR0ZYY2Rz?=
 =?utf-8?B?U3NJRnRYY1BnQmlObDk2MXZ3MENiU1FUaWJtOVdQNGcyYUlSVi9TOWU0MEpE?=
 =?utf-8?B?bTlOdDhPYVlMYndnZVVKQUEwdGVUSkxlZ3cxUkhTRlZ1WjUvUy9BZVVFZDA4?=
 =?utf-8?B?TmtUZUR2NkFaYUNmd2U5Tzh0SEUzWjFpTXhjeWdQTFpYSlk0WVBCVU5nY2NT?=
 =?utf-8?B?ZmNKVGQ0VjV2OGt1aUFpTFZSYUtNZDIzK1g5Um8vY0V6K0dGZjJxbkdhdFVw?=
 =?utf-8?B?UFh5OFc2cmRhcXRYY0hRcHNRVU5EUVRYenJyRkZCTHlMZHdoVExYenh1RG9Q?=
 =?utf-8?B?YVg0MlZVRXh4akU4cjJMVDhmN01nVTV3UU1yTDBmbEF0d0p6cTZ5Y1ZFZ2RM?=
 =?utf-8?B?QzJoditubTJ6cUJDamRJQldxZ1JvVGIyTHMrMnJLdjZvRW4zRVVROUI1ZVor?=
 =?utf-8?B?QTRtMXJWMTFFV25kR2RUNnc1QVdZZHNaMGZacHpzOUhuK251TStmVjRpaFMz?=
 =?utf-8?B?WjJWY3dnajdHWTBvOUdqZWM0b0xuUjF6NzNkbzlBYThYbk5IWklic25EcXQ4?=
 =?utf-8?B?bkxnKzNiSFdlQmNpMDRyWHRXQzlZNXNPVFExK3phUncvSTNTQjBWYjltNEw1?=
 =?utf-8?B?dHJ3ZjIra0J0OFNIQU1hZjNpUSt5K2JJN1hLYStMdlZWQW9Ka1dOVzhzcTk3?=
 =?utf-8?Q?egTdtDRDONJsSITsBb3xV/NCc8MT6QPgK5lk06T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9883afaf-fd24-4738-601f-08d91cdbc3c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:45.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yacAOKb+IOOCxDDzfja6iVRwr3coMCr13dJ3pevASOnfvQWa1ZTadBE3rjDXVRQRSHkVs9C4feOzQ8i2JTi0wa3Tmme/h9bKB94HYiNyOD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=824 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-ORIG-GUID: X32UGogxA-rmyaMRH1OhI8B2wdiSZsg_
X-Proofpoint-GUID: X32UGogxA-rmyaMRH1OhI8B2wdiSZsg_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 17:26:40 -0500, Mike Christie wrote:

> This has us use raw_smp_processor_id in iblock's plug_device callout.
> smp_processor_id is not needed here, because we are running from a per CPU
> work item that is also queued to run on a worker thread that is normally
> bound to a specific CPU. If the worker thread did end up switching CPUs
> then it's handled the same way we handle when the work got moved to a
> different CPU's worker thread, where we will just end up sending IO from
> the new CPU.

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: target: iblock: Fix smp_processor_id BUG messages
      https://git.kernel.org/mkp/scsi/c/5aaeca258f55

-- 
Martin K. Petersen	Oracle Linux Engineering
