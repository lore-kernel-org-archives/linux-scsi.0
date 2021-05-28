Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C1EC4708D
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 07:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F03D611CD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 07:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhE1Hgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 03:36:42 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:13862 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhE1Hgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 03:36:41 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 03:36:40 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1622187307;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=U2XzInsQ1wxNlSLf+I1V9G/mJa5n/qLyUiHnC6XVj/k=;
  b=cefXlmDQ5Ty+IRIjDgA4b00viUEwX3/9AhPzgzyiT9t9b2Lc1GGdz88J
   4vbmMBHGl9cJsedU4B7MXvQQmSYO4ncHAwPeFUtkTX6DfcbxSyAie8WDg
   ubN81AAHP4w7+B5oeulyrB/+2tYjt5YTYbDOU2FEoFzjMoRLPWxYCACR1
   g=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: ZMMq/NMa0KgFIDHDYJJE/mVXAPQTqcxsWHLaIMRtswTNYFkgeuillHPhaR7GYYyHnWFVc64ZO+
 D3w00uLvfiRPk+HBtcjvyinJxb+hMXGDuoWQwbBdTM81atHsP3f3vN8CSjxACK3D7yBFpj8hxO
 AtaIzuRYdhzlls5nDszGDfUIGHysDXWL5GKYv8P9BxywPyrsfHwMboNL7stX9Sb2cbmIMpdq+2
 qZPBuZyA9iF4xwONsNW8tHXa41sJKuhhGO3upVZUeQUAM3b+XbRsmMJGwgJC2KguK1cy7Qu/n7
 koI=
X-SBRS: 5.1
X-MesageID: 46389474
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
IronPort-HdrOrdr: A9a23:mzNy0qMe+trdrMBcTjujsMiBIKoaSvp037BK7S1MoNJuEvBw9v
 re+MjzsCWftN9/Yh4dcLy7VpVoIkmskKKdg7NhXotKNTOO0AeVxelZhrcKqAeQeREWmNQ96U
 9hGZIOdeEZDzJB/LrHCN/TKade/DGFmprY+9s31x1WPGZXgzkL1XYDNu6ceHcGIjVuNN4CO7
 e3wNFInDakcWR/VLXAOpFUN9Kz3uEijfjdEGY7OyI=
X-IronPort-AV: E=Sophos;i="5.83,229,1616472000"; 
   d="scan'208";a="46389474"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ghR+3Iy8ezSpslzxLaErJpRiKwtC0McqUjfLaPZl0Y3JfGhFG7UTSg4SRHafQYWTsTcjVzIeDGD1BEjPLNRUt3+gXotPlWlcdR6TJBa+3MwLkjRao5oeSZN83WsHcndky5v1JxwF9oGpLCQh2MrQY4jxwSk5wuy74vZRS16W0wlZmJeOvGFr9UvDzO+ify/JK8Ko0EnY18BpWaMQfL/LGo6cwoIY/44RVLjey1zGXu4F2ZrY1Rzd7D/v6xxHdatDYuKCEljMXKrwEjiiX2UXyiegpRnEbta/kwH6Y3UREMUucDIWYVDKx1gr0mOyO9rFzJiT0IHbmp9fYFhZB3rOuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1w4tMyckBpt9XMzH1+2+KfgRy79VDLmIiZqrGSQuO4=;
 b=IFgSdooJzgyzUkuuG0e9o0kM2IYuPlMkN+swwsM7yj51kTBAjGBTQxvlbbya6IV3FAKk6hFIf5/hebv2Rd6l/MEv2nMBf5cDCy8W3k8wJjSVgEkbJ8mF2/4OmrYMguHyEZUohH4hH1IrmBZNTMj2ZMks3V6KT/OGjdF8h8lpHyIBtDaYfhqTKidPEEpMkasZyxlGGOdzO52e4wCMAnTYqxdkW4PexyjncuO1z4hyBSJjuMZ2adRGhwokKWFE6QvE41jitxteEI50C4XRzpG/jNpjkjgn1R3X/rc99BFBARE5lq/qSWvoeNR6wqJvlmAIsLexWOh+RQvic2efiFNy/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1w4tMyckBpt9XMzH1+2+KfgRy79VDLmIiZqrGSQuO4=;
 b=W4KtDv690EHts6e1C4bUtVqWiGVr7ogwzXofaEzhBrqW5wxxw2kmanKE6y8cZcECKM3jZ0cdYNHRMtVBG+P9CEs7vhlpJza1erVBzw8PtOETV7IeXDXxr4KlQyj97gMG4zuaTj91k0ydN9AmUi7++/nEIw4CcUqBdtri1gHoWnA=
Date:   Fri, 28 May 2021 09:27:42 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        <linux-block@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/8] block: move bd_mutex to struct gendisk
Message-ID: <YLCbbk6rHOYUtdnj@Air-de-Roger>
References: <20210525061301.2242282-1-hch@lst.de>
 <20210525061301.2242282-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210525061301.2242282-4-hch@lst.de>
X-ClientProxiedBy: MR2P264CA0006.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::18) To DS7PR03MB5608.namprd03.prod.outlook.com
 (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6154875f-e3eb-4baf-8c3e-08d921aa1baf
X-MS-TrafficTypeDiagnostic: DM6PR03MB5356:
X-Microsoft-Antispam-PRVS: <DM6PR03MB53565E40A87198C13A5ED89B8F229@DM6PR03MB5356.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwqKxuW3lsTJL1BCvV+k1WQujS2wrweW3pH7w1eEMBPBHGrW96OUC0JWouQRcjDUbTPiis1UHeSYJOZyQ2Ptsd8vUWoLbbsQ9dsJrda+2ogwAWkhJfGdnj26cnEypraiM7OUi88onfRSqmrSlV/1WJ3FjiVQj8LCWqtcc/zfnrxXwEgWGvj/3x0LSE6HEvti35IZZgWfmA7G462UZPiFFISaQaHsLuqflX/89Yzh1Yj/BtKRN9d6O2fCbHJhPO6wDLoltr8fW/7rHBXZelgI8/cJfHm46GXKMDU8Q7iXESJj0g6SGKsadiWvMAHFmjNT37+SO+Yg1t3NL/V18z0KfoIztOYNX22z6p4eEHcG5pbG5/bPF2pjoOoCWJdbdvxOxF9isUN6tv5G5FS0KAHAeIVSsXtXLKeowsTk92gSals8shrIubcUhGPq8IiOApdCcInw8Z1PB2YNJFlnPmKD+c4ZHXAAo9NXxbI/qZSOG+SGY4rlwdFYCOUv8G5EEqnFJ8llfOgFN5zZQhQIqBcktISiPvOJqdQNkMTfVBq0VclW6Iq8APPeLPgWGExYUHrUSlcF7KmHqAQKhAwYK/II3RsnOA1RyPdSnszb5JX0cR0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39850400004)(366004)(396003)(376002)(136003)(346002)(478600001)(8676002)(6496006)(5660300002)(2906002)(54906003)(186003)(85182001)(16526019)(66556008)(66476007)(66946007)(33716001)(316002)(6916009)(4744005)(956004)(38100700002)(6486002)(83380400001)(9686003)(6666004)(4326008)(26005)(8936002)(86362001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VURTQ3FWS2ZpdU1TTkZJdWlHWDlvb3k2enlxWUtEQmxpL2ZBdlpEbXAzT3JX?=
 =?utf-8?B?WVVTQlZvaStKRnJaanFYRndBeEo1SGhma2FDcVI0alJaOStpZ2R5TmdHalFR?=
 =?utf-8?B?ZTlUaDBMbWhIUXluY2ZlbVZZVmwzNjVNeW1jQld2NUlLUGVkR0dEbXFvTmZW?=
 =?utf-8?B?d0JlbXhsTmhKYzJjVFp1SGxlKzNwVFNHVFVabGRjcWl3QXJzcWNzbUV4STZO?=
 =?utf-8?B?a1Y3bkNMV1g4Q21VVFh6bndFZlBJbndTYWNIRlBkOERiY0RIYTVXa1BMQVZN?=
 =?utf-8?B?dDNLRTM2ZVlGaUZ6Y0hGTlZGVHVwR1U4a1NHdm83OFhaNFc4NTV4N2dBdnQw?=
 =?utf-8?B?UGdDOUZVM3pCZ0UyUmo4bDEreVQ2VVF5RVZibjVoWUdJNFNnU2lvZU9kSXNn?=
 =?utf-8?B?MW9nZjgrN2NJQU5oc1NodWl2K3FMcTNpSkZtclJyRVg3TXl5eUswVEVaTnZm?=
 =?utf-8?B?QXFXaTRsdDJ3VCtFRkp0dVY3Mjc1NXpTSlY0WGJBRXFtRjcwNU9NUCtxZVpO?=
 =?utf-8?B?dng0OXZ2UE1DQlZzTlVZdFExWkhMc245ZlZtT0xmT3JVdWdqSGlkK2VidW5P?=
 =?utf-8?B?QXRlWjBMaGlXMHd3U2ZidC8zVEk1ZTVKc1hRa1RpemJJTDFOeFV3bjB5K3E0?=
 =?utf-8?B?NmhuMTFWTFkyVE45Mm0rS3BmVTg4TmdBa0luUHZ3RktXNFZBV3JVbld2czRt?=
 =?utf-8?B?eFJsRWxLQVdQQWpGcTZsUzQ2amZ4blQ2L3ZCeTA3bnkxNTVrdzFtZWZ2ckwv?=
 =?utf-8?B?Kzl6ODNqNSs4SUdZTlBwVVVoZ09UUTMxVTl2a2VqY0hZVWh3aDk0aUZpbWVI?=
 =?utf-8?B?WE1pUHYrTEEwYlhkTW1vdTJVbFVsVHJDdFVhUlQwWWE1YnQ4YmorYjR5VXIr?=
 =?utf-8?B?b2ZXVG8wWndHWGhFOXJ6UVdWVG9MVnR4a25MQUVQNE93NUhLT2QwNGsyQ3Vs?=
 =?utf-8?B?SDd5M29NRnhsODduYkUxTnNWZmRsNEZLRko3b1BQN0RVdTluckMwa1ZFNUFP?=
 =?utf-8?B?a1NPaHcxOTZDUm4zYjl1M0k4R091bng0NDhIVGZTUjJ3TnFESFRoeW95TW84?=
 =?utf-8?B?bCt4Y2NFMGNVOUZZYWRoVE5RRXBJaEkxczJLR1lGelBnUTFabzVLMGNHempq?=
 =?utf-8?B?bU1nc1A0czhUelZKQ0hQM1NJbWZ2SFVvbWwyZU9uWGREcTk4VkQrUGV4R21x?=
 =?utf-8?B?MlVQRytCckVCeHdlTHhoWlQwbmtabW9tbStTZk5ZUkJXb1pCc2w1bUQ1TUdG?=
 =?utf-8?B?R284OUszaWtTR1hFZDBBV0VFWm5QQUdROXl0UEJpU1MweGg5MCtIbDJxM1FW?=
 =?utf-8?B?c05FZlRVbkU4cUNvVExmbmJLd2lXT1Q0Q0xRZlpSOWZMUy8vOGZmQzFHVjBJ?=
 =?utf-8?B?eU9EZGhaaFYzZ2pFZGhWbHROSExXenQ1L3lwbGtpYmdlT05NbWd1cGlsTWR0?=
 =?utf-8?B?SjVQTkN4UGcxcW0vYjJGdFhBTlFWcUZ4aFU4akRoRlNIc0VSakNlY2QrM1dv?=
 =?utf-8?B?RlU2akFFbVBjRXlCdnZVWmF6UDRlZGFJUHRMK0xrUVE4a2E2cGhSZkQrMVFQ?=
 =?utf-8?B?MjF6SEVEbmtVL0JVTUlESlBGTUw2OUM4a2lVRTJvZUJzYkxpTnR4ZG02TUl4?=
 =?utf-8?B?QXhLbHBxSU8wVkR2Z254T3V6dmJSQStvTWVrTXk1WnZzZFBzUlVjemVsblRZ?=
 =?utf-8?B?ZEhQZGk5QnJhVER6cUVNWHJhN1NHVVRPcHZrRlZsWjNoTzlwTUZmcGZIYUFm?=
 =?utf-8?Q?PFn1H6PtmVRKqBO/0eItEqhON61eGsLApJo4PLT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6154875f-e3eb-4baf-8c3e-08d921aa1baf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 07:27:54.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QT3bpwJje8Gzl/hm7co08Kg/M/+2pQ2RF0ENnESguRsrw8JH2XKy94F6hG0LwCMXEfTIuEkln1oKSH4x/K/VtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5356
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 25, 2021 at 08:12:56AM +0200, Christoph Hellwig wrote:
> Replace the per-block device bd_mutex with a per-gendisk open_mutex,
> thus simplifying locking wherever we deal with partitions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/filesystems/locking.rst |  2 +-
>  block/genhd.c                         |  7 ++---
>  block/partitions/core.c               | 24 ++++++++---------
>  drivers/block/loop.c                  | 14 +++++-----
>  drivers/block/xen-blkfront.c          |  8 +++---

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

Thanks, Roger.
