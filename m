Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FFAC77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 10:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjECKzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 06:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjECKzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 06:55:11 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2049.outbound.protection.outlook.com [40.107.6.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBBE4C15;
        Wed,  3 May 2023 03:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SxQlI/LanXbu3lDY++try448mKZdF5OB2AcbD/AzygGDHmud6k6Ap58yKgRaSVkDg5J09qA4bfbmqV8mSaoQfx3xj2VC7oB9OH31jRQnSJOZTynsN/dX3M+u5qcQloxK1ZxQv7fA+5V918FNXynG8QSyVjwHQzKZX0yQ2v+Q4s9lRSF+vrO2sofvFxti9E12DD9Uwhbrw+wEptzQniK+Ykqvk4YJal9cXQwDnh2NFKRhBaLAjVJfU34P1x8pBixHUxipew+kZh80K2YshIMD6VFNgnWEbvgig7NI40pSd1nuOheZdOmkd/oOvi1SgfRWdGnp+lYPoxrAnJJ3xOqkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWpUI/pHeTuE7misLavhjq0fFd9T5p0+byj/6Ryr9T8=;
 b=ciOesVWxBBt9esUSvwkq6ZR5eNNWk94rM8LhzP9BWaDK8bvwhK/YKqZ5I9qwtKvte5pKnE6x0vQ4Qm5IMlZC4Zq3AymB8KCaK585JZHP5/beEoDA4uIGKZ9Uae5SdYr1tNfNUXKUsNIxIpalirXFYxX8khiXtE/iFeMrK5QMJRrUqzPhW5hHxyWsZ8qwRF4KRwTbg6wsWeGgMVm2rJRmFs6q9KSQ2pYkCY2uqbg2290iAH8lxwutN7ZXXNS/XCzQWu1ehK/McWBfnxDuFbl9GVmosdAWhrZGdsT/VL/Q5owkL9sAIXwj0ZXH0O3kisgjYCUQh7Dv/O2Vz9ditfRcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWpUI/pHeTuE7misLavhjq0fFd9T5p0+byj/6Ryr9T8=;
 b=B1Y/qxTViLWnNIVC30xmkPOoIphOc/UKky9yQjJnBnmV2PMmAPgVarhJRVKXjoc2Ht+dadVJUcQu/9DUk5Rd0T5h/uZ67f6fEi6bPs/IbOkNwdc5BfGaDuX5NODsKy8NHQ6+q2xrXFHVv4jEcj36hjnNiUhPtLz10YXdTe2zO673mpt5H5f0PvSFKZQD3KJTC8eEs9CkBVq/dozLHV1sUnsi7kIepRqj8FxLrixXuFa/Eqlk6l3Rk7amgSNTc+9/g2lA1QE1xxLjbMU91Pr2fvUS3Uv9jWSmYR3rt8bUiMEfPMsHG5To6NOVsd7V97cml53IJhnLjdgzTN4RP0K0gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by AS8PR04MB8069.eurprd04.prod.outlook.com (2603:10a6:20b:3f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.21; Wed, 3 May
 2023 10:55:07 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::6c14:307b:6fd3:3bfc]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::6c14:307b:6fd3:3bfc%7]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 10:55:06 +0000
Message-ID: <941e8420-f99f-5832-2ea9-3ba5eca545ad@suse.com>
Date:   Wed, 3 May 2023 12:55:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
To:     Benjamin Block <bblock@linux.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hannes Reinecke <hare@suse.de>
Cc:     Maxime Bizon <mbizon@freebox.fr>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
 <20230503102440.GL18384@t480-pf1aa2c2.fritz.box>
Content-Language: en-US
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20230503102440.GL18384@t480-pf1aa2c2.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::11) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|AS8PR04MB8069:EE_
X-MS-Office365-Filtering-Correlation-Id: b51425ce-c8e3-4aa6-033b-08db4bc4daf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXh6X7OuEnmk58BYKhXMUtKnd9YUnKkgknRTtSGWR/H3ZRrrEk2yULHvX4NZk1ilcoZPVZSq/4Zkaqj0ZAQPSqBLIDqaEgQGf5htpO8qaiQotP54G7S4HwSMJgMzQqRueQJZNvxIcsHBI0C0K431DELQs3TdzFkWMpuvOwx0i6BmvOJKRTQS0w9FDY/PyHT5DLv4JGPzJuiIbthr7hHlWRda2BIxJvbD9zUQvF0CaRUC5kQmo6AloMwi2ReWXll6fSRHJfjAhiNKJxyIkWrXMujv+4tPEV5VpMuxWrx02r2IVgg3/nLn6PfI5b2KPUQDlUSW/gK/FE2PjbaKt3Az+22N633ugy8hO5DGk2rYmDDZokr2GAYkgf4ffVPex7Xj2sf91ItqnEiOcH/hmJF0Wi0/dnhaFdXTvI+ID6x+4xyiJ8Iw1iS1ILXh+VcdKAsoY0pW5bq1ElecVNEhqedehqLXkf5vO+F18oVXUL29S/u4DakXc73pmMPdaOG8Gfp8JtG6lZXkxhd/oJTOtgF9Mw4OVe9ysuUkhMIsiNbEI037+DCB8IVLxrNNN4fMXGHxYVqRYnma3xOXEJii05bUGaatQtz1wTrBcLuyBMszvdkRlO+JLApAnmBe8eqGTEMicBqSGX+D8hmTlj8fxU03xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199021)(31686004)(36756003)(5660300002)(2906002)(38100700002)(86362001)(31696002)(316002)(66556008)(66946007)(66476007)(4326008)(41300700001)(8676002)(8936002)(83380400001)(54906003)(6506007)(53546011)(6512007)(186003)(6486002)(478600001)(110136005)(2616005)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amhQb3dBbG8rZ3JmY3U4VmlEdkxJWlBFNWd3VERWWUswSVVrcEVPTVhicFJj?=
 =?utf-8?B?QmFGdXlZdGs4VVRweTV4YTVtV1dHNGhNRTdrcE9KSmlRM3lWWldWUkJiazR2?=
 =?utf-8?B?SGFicU45Y0hxUnhQTUZnVG9Wcm54U21xNlJmT0RpUXdqRG1MU0NYdFlrWUt6?=
 =?utf-8?B?eHc0Y0FBb244QTBkNC9DMnVlc0hCOTJocUEyUWhCQXA0NitWL2lKeUU1TEU0?=
 =?utf-8?B?eWROTGF6QUwxaTNWa2ZndytXeU1SVVFBV3NhYUlLMDhELzNqQnU1MzBMQXo5?=
 =?utf-8?B?ekpWSVlZa2hiaVIveGRxQlExVGlwUzNnbTN4aDA0VnhmVGJrM21QOTVKNjA4?=
 =?utf-8?B?VGRkL3FMa3gxdXhTODZoL2JBY2diL1YwTG54M0F0S1NrbTFUTEpDZEZJUHp5?=
 =?utf-8?B?alpFRTR1aGpUY1RsMXJELzB3c3crR1Zxb3YwWU0rcnJJOVZkNlM4VzNRaUkx?=
 =?utf-8?B?cGdXWG14VVdRdHYzekJWWVMycUkwcVoxdDRsTlcwa2VvMVZVZXprck9Id1JW?=
 =?utf-8?B?NTZHQ1RPTVdpdnlZZHZ1UnFOZmZzbXQ3SFNpdm03Zm9EVlRpR05temN2QVg0?=
 =?utf-8?B?eWxjdXd2WlZGL2dHeWNXOTZNYnI2Q1lzQm9hSitQOGxFZHNack1jRlllalln?=
 =?utf-8?B?NGtTV1JIYzVjbU1KdENCK1ZjOG5sSHdEaEo1SFJoOWNFaVRtK29wbldZZW81?=
 =?utf-8?B?SDFVbUpKcldkcUVHOU8wNVJRR2MzSWdPSzlTcGk0VjFJeWh6eFNoM1R2cVd5?=
 =?utf-8?B?WVJ0RWpKZTBkNUcyQ08xa003UlMyUURMN3ZxQzhoK2R5aVV6eUFJaXJzanlJ?=
 =?utf-8?B?azFVaWpXQWxnTWFrcmVUUlJLeEhFcEJBYmF4NW0vZUR4NWlTVkhpcFg3TE4z?=
 =?utf-8?B?MENjVWpsSXA3MDFkQ2NzUVE2Q29aQ3JYdFQ5OHR0UUdUNjd4TnNlM1BaekJH?=
 =?utf-8?B?WnNUYXR4MzNhUnVGSnlUbkM0T1d1M2dBTEFnZFU4L0c5QTJuL2VKTjk1RzhR?=
 =?utf-8?B?azFoZ2pub0VLTnVEenVjOW40MzhNRUhVeGRJZUpOL3VJaEJBTmZlNStsODBY?=
 =?utf-8?B?M2pKL3F5OHZvTlBGaU8yMTZPdlZndW5oRFdxTUtQMG5laFpzM0lOQ1ZmMTdX?=
 =?utf-8?B?RFRCV1BkNjNoUFEvcXhMRDhIOVdSOVFVb0VnNjc0MlRFaXIwanQ4dnV1VFJs?=
 =?utf-8?B?dklhMnVRSkNMYjI4Zm1ReFpTSkwzWFRSV29FSGNEellTdFNOODdhY2IzQlpm?=
 =?utf-8?B?QlZJVXVhNzd0bnU0ekR4eTlML0RFN0VXOG1ia2ZNeVJRdmlBODFacXR1VUJT?=
 =?utf-8?B?WUt0QnpUMzRjbnEwTjVVNE9GeUxzQjViMWw3cmwxeTZEKzN0YXNJNSt1VVVk?=
 =?utf-8?B?Nk52eTJHZmFXTlhFSEVBcS95d21HSFpGWFg2bGJXb1djNEcweHh5L3Y1L0oy?=
 =?utf-8?B?dFZEV3V3aERodk9PTlhsYko1NkdPTUF3aUpNZXNSZDFGVUhrMnM1dG5ESzIr?=
 =?utf-8?B?Z0lNU2VOVFRKcmpRR3BtVUNlMjl0Qm1hcXhDTndSdVdBZDNRY2ZLamc4TVM4?=
 =?utf-8?B?b1RSRThDZ1V5bnNuMFBxVjNlUXliRHZkTk90dW9sanlCM3F1c09lZzhjM3ZY?=
 =?utf-8?B?b3BnNnVvNjY3YjVlTWh3bEloWi9FOXNhb09DSHlEOXBkdG14YmltaFhoSUN2?=
 =?utf-8?B?WUFSZGx1SkE0dFM0c2o5Q0dYUEkrOGtuNXpBUmphNms4amhnY2drTzhuaUhF?=
 =?utf-8?B?bVE5TDhMZXphTDlVUm5ZZ2liME5ZM2Jya3BlWlczd0dmSWluVEdJUkJpSFp0?=
 =?utf-8?B?NTE5RXZoRWExTU5HTTdmZGNubDJMN3hkbU5jcVkyeUdicnFBSXl0ZzhSSzJZ?=
 =?utf-8?B?T3diS3FhVXpPd3RSbnQyaTFEWE1ld2NaRVNDYm9RdW1VYUQ3YXZPdmtVdWUv?=
 =?utf-8?B?cmg5MVNueWhnbGdSRVNwWjF6Um5rZjFObFFPRTBwSmhPVHA5enN6L1l2dXVH?=
 =?utf-8?B?RG03L3hRU0tDL2toWXBxZG84a0IxdE00Z0gwZGkrd3hya1JYOXhnNkpuSlh2?=
 =?utf-8?B?b3c1bFlMZkJieDZrV0xnMGdIaUdnUUlwZEFtbWpMVnV3VFFrb2J0bE1peVdX?=
 =?utf-8?B?Q0pFZ1o2d2FycU1ya0lqMWp4VEJNRE5Oc3l0ZGRwN1BMYTROOE9aWm5KL2Rk?=
 =?utf-8?Q?9XVI1XqJDZdM0qVk9mIVIhPc6ide7DJ9amI6BlHS0Opr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b51425ce-c8e3-4aa6-033b-08db4bc4daf0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 10:55:06.3852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaC6/2PcsuX8i3DwVmQo+aJrZKdpM0akFI42iiVJzF0WkxwUg0MzISYLbjq62PeIUlWcgv+mj5n6AkbSi8mg9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8069
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03.05.23 12:24, Benjamin Block wrote:
> On Wed, Apr 26, 2023 at 03:20:07PM -0400, Alan Stern wrote:

>  From a cursory look at the logs above, SCSI ML does just try that:
> 
>>> [  218.089304] sd 0:0:0:0: [sda] tag#0 abort scheduled
>>> [  218.109297] sd 0:0:0:0: [sda] tag#0 aborting command
> 
> calls `hostt->eh_abort_handler()` on the late request, and retries it
> after success.
> 
>>> [  218.359964] sd 0:0:0:0: [sda] tag#0 retry aborted command
>>> [  225.129297] sd 0:0:0:0: [sda] tag#0 previous abort failed
> 
> but it times out again, then we go straight into EH:

And that is problematic to usb-storage
> 
>>> [  225.129337] scsi host0: Waking error handler thread
>>> [  225.129358] scsi host0: scsi_eh_0: waking up 0/1/1
>>> [  225.129375] scsi host0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
>>> [  225.129387] scsi host0: Total of 1 commands on 1 devices require eh work
>>> [  225.129402] sd 0:0:0:0: scsi_eh_0: Sending BDR
> 
> IIRC in the past we used to call Abort a second time from within the EH
> thread before trying the different resets, but that was removed at some
> point a couple of years ago. Now we add the command straight to the EH
> list, and start with the TMF LUN reset, which ought to implicitly abort
> the command as well on the target.

usb-storage can do a reset only on the USB device level,
which translates to a bus reset on the SCSI level.

And we are supposed to cancel any communication with the device
before that.

	Regards
		Oliver


	
