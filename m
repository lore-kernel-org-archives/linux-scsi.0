Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64D8C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 21:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A81CD610C8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 21:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDOVe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 17:34:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52452 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbhDOVe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 17:34:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FLU4rP088569;
        Thu, 15 Apr 2021 21:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EPETOp8RZYT9BB0luxKRoW6g9OrdsxyNYIHYQo2HShU=;
 b=sowcb3Z25Fk4meKflP1d+OEiQ/hB/pT0JDxTpEc2d7CFGj84iKH2jG+3QESAl+jYeXvD
 Es/wgju0vYsOlSQzN7UNSnrDciu2Z17ufEV///T106xd0TzonWC/b6VeCvipu1R0B3xh
 WhnN9fYLUQOuDM3hQNRQSk9Ajaagwr2E98FjSNOVTVX8IfaE3l25s8QYh+MIeDU9nJaR
 THDLiQ5er51ZCkUsRV9Q6S8YRHeljshaF+67w9VeXDXjJfPFXXyIM8PS1JgPM5YLqv5b
 0RwBT5da1aPXdnQ/dmknyds/uPCGgBjxqgBD0ThS/RBzvuYi5GZT91a/3gf3rUDADGwz wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erqbps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 21:34:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13FLUcn7164171;
        Thu, 15 Apr 2021 21:34:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3030.oracle.com with ESMTP id 37unkt7n3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Apr 2021 21:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVBbmEKOFOtWOC60YylC8B9DQtdRxhb7YQbB0EDzpivO8FMZPtJ1rHdfviTfgpER8ix5QiLv1t8dHJ5CpoHWXd2uVEfRMIe59Ryd/Lp2MmLfQ+b46jM31er7YnM3568PO+jpQt89dg7WDln5rY3HEEkW7Ad/qGaeYRxZt6jR+QaBaZ1oyfH0W3Xm9j7sEneAVBryj+3lTj3+UjxSP9X2J2JzsQlBlp6CFvL/0iry3sDS6EWprlnMso1oUet8VhKtIIISJT3KGbvOGNl5f9fDrDFiZz+gqKeIMNqg9nbfPY1mBldbGHHXlzthgNl4YkVooDqgm3ljQHZB+r1gPFyaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPETOp8RZYT9BB0luxKRoW6g9OrdsxyNYIHYQo2HShU=;
 b=nq5BPK9Jb28gX/9d5irpd1DnGM4ZhYROE72fF4fTpPm+qx6j7BbrJCWMX7/SenFUgtkVYxwIQPLqVNvw9k65PijU4Rg4iu4JSD9NPGTuhaxAaPx4mAOjvtROKrTjkuKF7REBOgwx/4EVt8CUThyhAZ1IAK0QGkzJ97T/Q1KlOE4/CE2RAPbYupxuUl2Cz9w1pfk+PhzoFdWqM+WwgAMcQp6LIPtcg6pxT2X33Xq8mFmVJTRgl83UL9qxjnCa9q3HX9onLCaQQ2ghLk/3M78WpJHllHZcM3RkfNFbKsZ4veQ9Sz7JLvltXHL6fx9FwO1i9JCr+yazBZ/B+aEibC/eQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPETOp8RZYT9BB0luxKRoW6g9OrdsxyNYIHYQo2HShU=;
 b=q3SHVJ6r5OJiJmlondg+JOJmB/5aioGKgs7gv88ZBetxZdnQzg1OWCILs11yMX8IvJXv71EE7gtNj1ilsyUHqKVOPYXRi/KOu+DCvxf0sI++3F9anN6QKGadABEpU/HSciCCoBJ6Y3PM8Q6e07HZrsbRsevIWbsOOHIshXrRkQA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 15 Apr
 2021 21:34:17 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 21:34:17 +0000
Subject: Re: [PATCH v3 0/7] target: make tpg/enable attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Chris Boot <bootc@bootc.net>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Felipe Balbi <balbi@kernel.org>
References: <20210409123238.26671-1-d.bogdanov@yadro.com>
From:   michael.christie@oracle.com
Message-ID: <7f8000de-b3b7-8816-c1dc-d7237cdebae0@oracle.com>
Date:   Thu, 15 Apr 2021 16:34:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210409123238.26671-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0002.namprd19.prod.outlook.com
 (2603:10b6:3:151::12) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.5] (73.88.28.6) by DM5PR19CA0002.namprd19.prod.outlook.com (2603:10b6:3:151::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 21:34:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94c77465-0d12-4cd0-1d8f-08d9005638be
X-MS-TrafficTypeDiagnostic: BYAPR10MB3287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3287A58B267420D87F2C146DF14D9@BYAPR10MB3287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lc8poB+amoEumOmo0BuNSZ3842TR44YDV/DEbk+r+hoXqS2y145meSpP3ifb9TEVxUmVLRvGZD6tMPIJncrNevn645E2k6KeudT40gU51DqRrEwK5KR7y2xURNPC/4YftSBFjB+odd1sPZKSpzRTrgATL8tN200roeQpLsDvBCtw7Zi51+hKvYD+4d1tQLE4WYY5Nt20fNr5x3+du8OPRam/3Zu3qqpt6y7Jfevt4EGwHcQsAfx7muj+/Hty9N7jKUEr6D1r/GUbW3lznEjZq6safsHvVwYWOzNSRSU9lp5b3Yno/CvVXny8tiVDyUL9mSSfJie59W7++w5MpQaBajqrzgfrO0uHDg6NjyHVzHJ6nWiKmVMjUXFDTskAiOC7GOWYieKBQRK+KVnj3GyfAuRGTKJtOKuPTY5w1JOhOrcx3TgyYSEK0rc1TCyeQcp5jTiSKzbPsOY0l49oa60uRzT3Ldn7MaQPjvDJbbu2Hi/f3EIi3SxEFzJUSqsFYo3VDZO7lFUQXTHi0C88Xqyp0xhx5oN8Ha1xmFfHq2P6cbMOHWREwSkyufqJexdqRaSTnhXLyc7uzSwb6gNKT5A/IamMsGOClUe5O6dMzErveOx23OgPTh4SfhrOKAaQ+9TOvaJrAmRvNONniX2mBbzwy9ktS2pHXavwtmZCrLZOhbaEO9UykM7JhKp1rRDh8x4/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(396003)(376002)(136003)(2616005)(2906002)(36756003)(7416002)(26005)(508600001)(38100700002)(956004)(6486002)(31686004)(110136005)(6706004)(86362001)(9686003)(316002)(31696002)(66476007)(66946007)(66556008)(53546011)(5660300002)(8676002)(16576012)(4744005)(8936002)(16526019)(54906003)(186003)(4326008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UExZZG1HWlY5VEFPYVE5VjgveHVJSVptbVhLZXhoWHByNndYOVhxN0JBZkhu?=
 =?utf-8?B?MVpQejZKSnUvSnBJSXFFeFA1VmphV0UyUzBmZEV3SHk0NmxNNmNuVTFFL3Uw?=
 =?utf-8?B?TnlSTnVlR20rTXpqdEg3cmpHZ29TZnVrU0wveTNncXBzMmZFMGZzMUVIY2Zw?=
 =?utf-8?B?ZFJMdk5hRjNQRDBuR0R2czZTUFkra0lHUlNlOW1HNk5EY01oTGl5Z2k4Q3py?=
 =?utf-8?B?S25DWnNWN1BkWThNRUR2Yzc4K3I5YkdKOEVtYmN3cXA5ZjNLWHZXa3lxenpQ?=
 =?utf-8?B?UU9TVGd5ZW1FZkN0aTZBNjVWTk9lMjNTUnhlalhXN1ZNS2h5L3RjZ0g4RXc4?=
 =?utf-8?B?S0hRVHNLNEd6L01Zc2ppaW5uaUpEL3BteXpNdjRONk16SDJpbHFWYnl3YjJm?=
 =?utf-8?B?YzVxTy9aSnptb0YrVGJrcmlQVEorUDlFWlVLVlZMZVFpbTE3NjlSSnRtcFBz?=
 =?utf-8?B?c3QrRU9DOWJUN2FDdzZ6alpibDJiZ0xTNXo0OU9ScUtwTk5ad2RTRkJlYko2?=
 =?utf-8?B?Y0FnckN5MElQenZVdThSRktSK0diQnVXdWhpNUE5U1VQRythdmtsZGsvMFo2?=
 =?utf-8?B?aUdrNnpCQ3IyL3pkdHlJc0Rjcmd1M3U3TXhaSnZXUHFJMk9pc1gyOXIyQjZU?=
 =?utf-8?B?clRVcWc3OE41WjloenNSZVIvZXd3cHowdTl2MTA5N0l4MjUweGRDdXJnaVVK?=
 =?utf-8?B?NEZqREJ2VkF5clE5Zlp5Rkt1bnB1VWNONHBkWVdPaG4xZDNMeGFCblA3OG1p?=
 =?utf-8?B?Yit0S2QybENKYytOTXc0Qk04aFRTSldxWmhEV2tGdUtiQUdaeitEU2hnV0E4?=
 =?utf-8?B?alo0UXZBMnNldG9LdCszMUs4bWVtbGNodEFsWWtqeEg0TWtJY05TT1dKK0gr?=
 =?utf-8?B?Uk5Ib2h2dkx3U0V2MWJUUkdDNWxVT2dIcEE5M1dMc1hwTVpISUc0SFFUaytG?=
 =?utf-8?B?QXhTZ2tKa3FNdlFqVFVZUDVMUUozWkJuVVRQVUVqamRCc1FxZGR5WUNTeFI0?=
 =?utf-8?B?a2Q0SzI5Ym5yTUhpYVYvakpibThONWdHSVpTR09ZN04wRFFJL0k1M3JjUTMr?=
 =?utf-8?B?ankrYS9hMXhHMlVFZ24vTVlSam90dXphWGNIMEdORE1vRTVjbmk2dC9GMnFK?=
 =?utf-8?B?YWYzMXVoTkpsWThjbk9SM2pFNCtqMkhnMVo1TFhtZ0ZXZmtXd1JUT3Avb29x?=
 =?utf-8?B?bXZHM0FDa2ZHdmZMZzFPSStROHRkMjhEMnR2YXNWZ0VhM0RNKzVWd01FVnFL?=
 =?utf-8?B?cEZtZi9FMyt3bWNPODczMWQzRzJjV1dTZ1B2M0cvR01KdW9Jd2VyeFZuSWIv?=
 =?utf-8?B?N0dOS2drYzlNNE8vMTNTQ0d1NTFhV0VoWDFtU25DRXJNdmczNkJ6MnowelVS?=
 =?utf-8?B?MTliWW5hdy9yUEF6ZnpWeG5EUkZVaUJnSlhaYzhMQjVKcUYrSVlJTmEvakto?=
 =?utf-8?B?VitsN0Y0am5pR0pIejlRL2xLZ1BhbjhsK0Fjd2ZHZThjb3hkNkszMVArWGZu?=
 =?utf-8?B?L3FUQnFiamdhS0p4NzJuOVVMa0tkY1NXTDhpSEdEQlo4VzRYK3Vlb2UwS2pz?=
 =?utf-8?B?VFlTUUZxS2J0NEc1NVBzMG5oaTBRdDBXaXVkTlJYSEpZOWNFUHNHR3BqMDZ0?=
 =?utf-8?B?bk9oTzRuN29CN3lxUEtQdS85aUlucDBiaHg0alFhTUllL3Q2TWxWVzZDb0Z6?=
 =?utf-8?B?aHV4SGNYUlRuWWtKZkNoZWZLeGdyNmcyNUgrRkkxV2VKajJ3bXU3SXRWR3hl?=
 =?utf-8?Q?GBJYDzfog66/lV4OTFiFb3Q0n2iT/SUwA5m/XtW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c77465-0d12-4cd0-1d8f-08d9005638be
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 21:34:17.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lHt0bfJXZzh6lEkSbPz7WcEM5j8HYeVcwp87nHd9eu+hQ9sA5rizo8LnDkvZ5B/v8cb86PItqpzF7syUWLd3Cf8zlMwuhhb0zvAMEowKao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3287
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150133
X-Proofpoint-ORIG-GUID: WhZ7lI5DpHL-woxEF8SuvEmk2phTIyKG
X-Proofpoint-GUID: WhZ7lI5DpHL-woxEF8SuvEmk2phTIyKG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104150133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/9/21 7:32 AM, Dmitry Bogdanov wrote:
> Many fabric modules provide their own implementation of enable
> attribute in tpg.
> The change set removes the code duplication and automatically adds
> "enable" attribute for fabric modules that has an implementation of
> fabric_enable_tpg() ops.
> 
> This patchset is intended for scsi-queue.
> 

You must have cut the patches over a different branch or it changed
since you made the patches. For the 5.13 scsi-queue branch I see the
same issues as the kernel-test-robot like where ret is not defined in
target_fabric_setup_cits.

Other than the kernel-test-robot errors, patches look ok.
