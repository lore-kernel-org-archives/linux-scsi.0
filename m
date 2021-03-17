Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A908EC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 16:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6745E64EFC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 16:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhCQQcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:32:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42928 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbhCQQci (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 12:32:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HGEnWj163162;
        Wed, 17 Mar 2021 16:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8qqbxniewDT6d0xYpeHhcusHZ9HmbhivOf+3NFfiH38=;
 b=Cq9nFdNbTDXGb1a8231p8g9mlWlq7dAmx6GLCKcheVSdj5EJzMgX2AGtA7AGvyWTdAS4
 V0H+FzD/mPS2s8ZErVgni6r1FBwiY+JZcnx3PyW10iRWMLWdtZ/OlR5I4pek/A+yXipI
 nr79UoAMV81jJJC8pKC6Gt/jMa4DWLknTl1C2bfovL36yshF2ClXJFUWHVL4fYKyMCCy
 fL3GS3LXJ4MsEOtJKOWd0HdbPalbwMzUXXZntx577tHU/MvTYzHROSIEaG9qz+7Z+We2
 0GlakbLCGu1nQ/RoYByWv2u5tAJIl87zLTODXTeI8UmrK/FP7ApH3rdOPJOfxhe0Iiey ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 378jwbmtb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 16:32:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HGG2TT025645;
        Wed, 17 Mar 2021 16:32:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3030.oracle.com with ESMTP id 3797b1qy9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 16:32:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRQeOOJpA+phYudXcn+FIp6kOzoIAQlI3eC37fDiwxJUyIfSiqC+epsfWt+3Z0UPHNbdLefq35C1TLAHDD2OkQ93D4c8gBPhcj9M4iGGTM7lnvQLQcBZoZl3Xym0LnIbUQ4tT1a/47Gzq5dxn7tY/AUo9Jbg3XqCzA8XzLPnXTz7PMTXiK4odq22vuB1pbZN/vUNYLVexzhAFDwPPu7KSruWe+GtP5M0xdHUxpjnl3oOlmfmjXDBhmquLhrQETsXR/4m9Qmyj2npE3mI9bON8H32/sDiS4uC5Lj8n2HxSIFHq+3XmKuxCs0NL4bQ+sbkhd2jd/ly7giC8/d+mAfRSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qqbxniewDT6d0xYpeHhcusHZ9HmbhivOf+3NFfiH38=;
 b=nBa36p8G5xanttJhKqhJR60NBYu5lJCOAHs+jMyh4Z2VXrfXpqusyVQHWDlUEKtkJI0aYVheG/eEtREVFCcR4XuzeDcCniMGse2q/p1B5yLu8ucGaEuM+0FR/y58mjyljCcd4tCO4j3+tH9OnQY+x91ohhrHi8OKkrK2nbGLMlFZo6bFDMLgEFwK6YmVOWIFhqIOVQ/lhMlLA29zJX0elEe5EfkZ/rXXGZAvPMF0s3+U83pWI3GCHHiypdFeoB6eN4fAhGWocnrMG+buIjeZKhKNJC7RAQ+mZ/qmCx/g++nE/HjomyqVHMQ2SpaNIdShw+at3e2UVxd2RXYZrpcA0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qqbxniewDT6d0xYpeHhcusHZ9HmbhivOf+3NFfiH38=;
 b=MBLe1BynR62wzCQdTO8lU/4xxIJLDYW8+F3sFoHdP2HeUr2ME8rW7LaKYqw9yFJjTUXO6IUooy0NA1R3k8CxhXSfrZHxPJbrNXRNIPuuk8swcml81+mT+D7qFFlsVlL05L+zjhecSkmw1ZTS41YZcwRuDWRRPyRquESnkPmiCiE=
Authentication-Results: bootc.net; dkim=none (message not signed)
 header.d=none;bootc.net; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 16:32:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 16:32:27 +0000
Subject: Re: [PATCH 0/4] target: make tpg/enable attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>
References: <20210317104609.25236-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <03cdc625-98de-7c41-d8cf-74143b2b7446@oracle.com>
Date:   Wed, 17 Mar 2021 11:32:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210317104609.25236-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0283.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::18) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DS7PR03CA0283.namprd03.prod.outlook.com (2603:10b6:5:3ad::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 16:32:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4504d19b-a3ae-443c-2ac2-08d8e962409d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4749:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB474935AB423B234CAA5BA941F16A9@SJ0PR10MB4749.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +rGrTl+7gQ1qEqSqMutyE9GT0lCl8XTQOnlGkBOG3XNHRymzgzPBEJdxoSZO81rYyndRuFCaic7Ogr67esd043wOuafq/hJPr5b9PmRNhPD+kf3FFLL7FSLMk4dXdudnKwdKtS/IGX9BGOgYz+Wy+ifvMxf6xxt84xcUvyClk0cPBpTv+7C+vA33cEZPnC1v1ibKxwO2Y+U8jCB7K4zhj131izYw6sD2NGCQQVzshPeKaJBJe2GWA2vpweZ62RykoHg6qCkyh8IzwLgXYcKnUKWSAYESmUPiObK99FgzzK4dEFgmmR67lAMw6pj7X3Mtnc/JwhK0MdMrdk5akmgKOyorbNTTw2kwjr9cIBrnj/PCBDAh6TI4Vd7PhEiT/8gXCj5nDU2kIpeRnDp1RuP7BQJwO5AInMUaCqjUFqm9K7WJH6rk+Quy7ZMDDyIO71auSa7PsTv5gB9uXj49HLN4pijRF2WgFhOuH7DGBlNhMIXpwYUZFohLQmFyGMYEfO8lwZ606oQ/8fM6lVBM1sDH2758kn0IKYllbDRPO02WTP8EKkFTnLyzUXVE3v1xc69ZY/JJlct11JqobiKSvQ+7P9crU84y6NspCLGP9HJO5PrlLxwd4FvBLFX6ktJ0c5A+weGUz5q7Q9nXvb0hr+88qpxhcY26bl5PpQc9gqi4D8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(396003)(136003)(66556008)(53546011)(5660300002)(86362001)(6486002)(4326008)(110136005)(54906003)(4744005)(2616005)(36756003)(186003)(2906002)(6706004)(31686004)(26005)(16576012)(956004)(478600001)(8676002)(16526019)(66946007)(8936002)(316002)(66476007)(31696002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SVFsZ0w0ZTE1TGFMRHM0TWZjVUdzblhRZFJaeTRtczVqUEV5Wlh1Tmx2TGxi?=
 =?utf-8?B?a3dMVk5JOXRyc3pXcXpvMnFaNE1yYkZ5bmdZWHpqY0dLT1Q4ME02cmthL2lw?=
 =?utf-8?B?ZitUWlR0cmZ4bUJOcWNuOXVPZzlXZ20zMUdSV0l6TlRINms1dWxyREdVY1Zk?=
 =?utf-8?B?SU00a0JObDdJVUJTNGp0L3FZZFlQdUg5NG11TmloM3ZQcmpsb2RLc1RwSk4z?=
 =?utf-8?B?bkFGbXJsdTlqTklQeWlweGhIQU0wbzRKWmVhSzN6YSt4NjhSSjdHVXBzT3Fu?=
 =?utf-8?B?Y1BQckl2YlVRblRFNmJ4OVFGU0RGbktwU3BCZnZVaHQ4Z2dFQVVKRXphTWdj?=
 =?utf-8?B?NWduTVBPVkV1ZmhJVlQ3UG5KVVZ4VlV0RGgxNUIwaGRpbllsWW9oVTFYY0FB?=
 =?utf-8?B?c0xQNXZFN0pyRFBtOG5PTjJnZzZrTVlZaGZnYmtxQjh6OHl5M0xTTmc3NHAv?=
 =?utf-8?B?SFhYNWVRRStPWk9zWmJiYjhRQnJyRVJNQUpiQ3dFVXVpc2d1cTVJNjdjSWRl?=
 =?utf-8?B?NkhkSzI5ckR2YWUxL2NXSjR4b1BxNTMzK1JmLzlNLzZMLy9kbFNvQjVkMVhF?=
 =?utf-8?B?TTB2YndxMUtUL1NZNm5MS1NUdEdLK2J2SldIM1hHbXlZSFM5SjlXVkZ6dUFv?=
 =?utf-8?B?bFZvSUtUaE9KS2VwOU52VUtIZmNoUUcrUXlhUHdUN1JtYUVnek9rM3ZXaVFI?=
 =?utf-8?B?Y0tQcFhvcUx1M1RqN05Xb0MvS1pZcUd4Y1ZPeXhmYXZHUjlRTUtwZnVuOEpu?=
 =?utf-8?B?TFZKSjhWRnN4TjMyYTlPSkdCejNnS2ptTU05NHYwRGRoU3hMMko2dkg3VGtn?=
 =?utf-8?B?bmFUYnVWM0s1bWFRVXdRVk5xYnNUdnlvcWpjcSthZERrb2EzaEVEWk9EMFQz?=
 =?utf-8?B?dTFFYXY0L3JYZi9DY0NucWJCeWJ1WTRQemFFWXBUTjhlYnhLeDlKTVpZUVZM?=
 =?utf-8?B?UmE3QUtJUFovQS9iaHAvbXZYemVTK1pXWU9Td1FISVh4QWJKMHo2OFJIbmk0?=
 =?utf-8?B?TmM1eVZnWmVvZS9EYWpCTzZMK1RLR1ZSWGI5dkFoTVQ5K0F4VTd2cDd6SWRE?=
 =?utf-8?B?Uzc1QW5wVFFsak1Zc2JXSGVjb1dWR2NXYndsTEFOcUtib2pZMU96SWdUQXI1?=
 =?utf-8?B?NThuSllrc25TV1FBS0UxOHcrdWJGM1RUYjBmdlpOd1gva21MWDVsOU9SYnlx?=
 =?utf-8?B?WVVXWUhwRXB2bzNYY3R4NWZQOU82Uld3VkQ5VlIxcmFwcGlaNUFyVkt0ZW1l?=
 =?utf-8?B?T3VrQUhVSTRqZGNaSEd1c0c4dWdLZXRQZkMzYmRMR1Y0SnFwa2RlSW52cmRS?=
 =?utf-8?B?VWhzRkNpVnR1TWFtemkzNmZpVHJvM3ZKTXpuRFk3dHVyRnZ4eUtrTjJUR3dX?=
 =?utf-8?B?SVpVaHRYdms2SGtLd2tMVFVzaER1MEZhSU1XL3NZQUpMSkNwZVpQdTJHOVpT?=
 =?utf-8?B?MlJocW9BOTM3dWRlS1pod3B0N055bmh6RzNldGhMVWRmWElGeWFhV2hUaW9X?=
 =?utf-8?B?MXZERGUzMm14MGMvaGlhOEJWSE5qRENLdGxDQzNVYWZpbFZiMno4VGZ0NUF4?=
 =?utf-8?B?ZUczZmFDdVIzekl6SFV0cTFzRDZ6MVVQY3NoMXN0SVp2bmFzU0lGRER4SVYr?=
 =?utf-8?B?eFZjMEZkc2dPNFNST3ZmWjYxbG93VmpORzVVVG15QUhndkpJa2phUGx5cXlU?=
 =?utf-8?B?VGt4cVZyZWpQaUU3V2FUNFc3Mk1yN1NjaHViS0NNZzFySHZadU5SeEtydHpm?=
 =?utf-8?Q?YqHNRSO9GGhrL0W9tZ2dhFaWmjaElGKh5aWdxRJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4504d19b-a3ae-443c-2ac2-08d8e962409d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 16:32:27.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3h7/znA8c7Fitek9TqqN274URnVS73lmrdt/3mC5oHC8bNOdp4RalWwR8ghaMi4X/lqWh00Q4MhMfd7EXA/j2Y4UhCtTDBGN8yYZT8kKj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 5:46 AM, Dmitry Bogdanov wrote:
> All target transport drivers have its own 'tpg/enable' attribute
> implementation. This produces unnecessary code duplication
I don't think that is correct. Some drivers don't have en enable attr:

- vhost-scsi, xen and loop have a nexus attr that sort of leaves it in
the equivalent of enabled.

- usb has a nexus file like above, but after you write to it you still 
have to write to the enable attr.

- tcm_fc does not have an enable and has it's own initialization strategy.

For drivers that have an enable file your patches missed usb, srpt and
ibm_vscsi.

> Also it makes difficult to control that attribute and to depend on that
> attribute inside of target core module.

I agree with this :) It's a bit of mess, but I think it's sometimes due to
how the driver is implemented and how userspace has to set it up, so it's
not as simple as in this patchset due to having to support existing tools.
