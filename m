Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C76C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 17:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CDE3613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 17:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhFJRTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 13:19:01 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:46785 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230514AbhFJRS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 13:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623345422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kOtFSLUmGR0nZODvxyvwa0TZKgX3PyiRLjhZDz4IGC4=;
        b=KWlo5zOkQ9VwrTzSHfhfVuIALNhj5fHlrq5vRUHcsTyHo1pgOirpO+tGQm4pYdJ4qtdf2Y
        PB5YkuIfVrzXQqNulOnWP9tYXMAzdiLm13BGAB2QwWhkBGil68sCK4Au7wWzEWMPBwDuYr
        yEZV/y/+nDdytSK8/cmk0optO1CwMo4=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-FsM-KSXuPaqGyeTezpfYcQ-1;
 Thu, 10 Jun 2021 19:17:01 +0200
X-MC-Unique: FsM-KSXuPaqGyeTezpfYcQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBQyNTTDOsWo716mfeHqDz7eNgbrxVO6wMSooNJJkalARQM/3ePLPAxibfJPVAec4x/7ermGMovyP5N2fzj5LKcqlwHvM5KMAzFV7LiWgqaov7+f62qVocKXVQDVNthYyQHin65yTQDh+x8nAgdUyd5Wwd8jnpVKhd5N2frUzeoCArAo1FVHr+CR2PGlepILjL7suUx39wQ3G6kvA8z8UXr5x03Hmm1j9fVMK3MfT9IJXb6uwiyJNQjhNd5N1RMyjHSfS4kM7k1yzMwdtV+JdtGGRLpqpgaVQ87hlWehdV88VJheEqQy9p9qA4KaJtp/4BDPD9WdaQx0g52BJNkAgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOtFSLUmGR0nZODvxyvwa0TZKgX3PyiRLjhZDz4IGC4=;
 b=jGHLFen8Z3LeA7hO1yBPTuqmnZn7i8DMsMs9R+rWQ3bTJ9GX2FtR2TyD5GCeHPMFBZhTd/eKiiPnq+dlRTRZn07jcFiGgmBDqpE0SpbPvYi5FqiXR3vd4yiCPc20uA0yUh7cnfl4lFsR+nHCTWb0PMffdT7UxbFjvic0e063I2g5j2UA1GEAR0U++gmgOV/CsQRz1dcx45UUsLlT3pS2ga5rUIMielVMSGTFptfA1IYfmFHn6a9PE/5uV5QouEDMqbyJxYqRrdqCxTNmRKlw5szqvQk/4JO921UfX20IWuYfeNjtRN3rqDS3f2eoqrL2qxTRPK+qchEzE2JoQ2HIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8279.eurprd04.prod.outlook.com (2603:10a6:20b:3f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.30; Thu, 10 Jun
 2021 17:17:00 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4173.030; Thu, 10 Jun 2021
 17:17:00 +0000
To:     lsf-pc@lists.linux-foundation.org, Hannes Reinecke <hare@suse.de>,
        linux-scsi <linux-scsi@vger.kernel.org>
From:   Lee Duncan <lduncan@suse.com>
Subject: [LSF/MM/BPF TOPIC] discovering network iSCSI storage devices:
 zeroconf?
Message-ID: <de7c2464-687c-f1d2-bf07-9d3c20571b0f@suse.com>
Date:   Thu, 10 Jun 2021 10:16:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::14) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0057.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 17:16:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f288064a-0fd5-4b1e-7933-08d92c338e98
X-MS-TrafficTypeDiagnostic: AS8PR04MB8279:
X-Microsoft-Antispam-PRVS: <AS8PR04MB8279877DA0423C1B2B64BD4CDA359@AS8PR04MB8279.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xaokphE7be567ZWz0SMD7QdFN2I86v2Unxr7HBJ1afKV6BnGByhLpti3QfrRu2x/ZQiJBd1VRS7pFxk36vWmcUwQzpBlhMaJeX0+ZlTF9ka1o+tpFaG6wHyVicnwnsbUlGWimCMklox5GpI47Gcsep6tM/6vGbqIJI6dPn+vINDAhIPjuUPv1BIDBZP/Aaytb0RzXU3o6CMJZaS8qWqvApzDt/iZ2gy6f88z9kYV7DHORS7B+lhARI1OnaNfazEDyYeLg49GZz9MchdDWASgEYuoADsODYz65aIK+1X7Lc/RXNlNpCIHhM6xHfjC4KrsnoCoTyQ9JjOwmNCVYwOZRg+t+RvEQjvAOYqx6M+cU57SMauXINP1N8BgjqpAE9mhs+B4EEFJk7ZrkZKA/aTHSEkUtIcMoLCta/Pa8MpTDZWfKJfG5J1oq1yzuNYiiaNV7bqmshKTbcEEaqaV9uFi7JY+BLgXIpM5XME5vuK9l6bN6FpF0LjSptq/O8BKJMJoDxNOGhSYoGfPwHvjLVd8drAG/CjOd9YoJxE/0pMBvYBjD/hc2D1bOTU5hoNUZs+VxwH2rGJ/rrPuhmKVytAtnT/a12tAgEuqGTRv6gS0zZLcKxlEqdd5KouKs7xoF28dabLiv5eKILTp5bpg8N0WG9pU9POMLt9QI3M4CpTJygTDhm3IwtwCcr0EAhrHkYLk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(376002)(366004)(346002)(136003)(396003)(5660300002)(478600001)(66476007)(83380400001)(26005)(6666004)(16526019)(66556008)(31686004)(66946007)(316002)(956004)(36756003)(38100700002)(110136005)(8936002)(16576012)(2616005)(31696002)(2906002)(86362001)(4744005)(6486002)(8676002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UVZEWi9MRGZRcm5TUWpOeHFCWUliZ0RqQlNhdS9kU0dMZ3NZaUtSdGtpRTI5?=
 =?utf-8?B?R1BzdElpRDV5NkF5RmJRWHdETkt0bTNDRWJKdEJkUU9aQzBLQ09Va3RsSWtL?=
 =?utf-8?B?TWJHdVZLSEFWU3ROR1JGdDdHYitvVzdUalE3SkFMQlRKa1pSQzZUU1l5cUZR?=
 =?utf-8?B?b2RUV3lMaWY2NDJZcVZVRHFqdEVoUjJ0R1hpczIyOHhIUHEyMjd4T0pyWUJG?=
 =?utf-8?B?b1dxY3RQNy9TdXlIbk9reE1KSWZLQ3pacHVWVTVZZU5iQUJnZkZKeTd0N0RT?=
 =?utf-8?B?N3lSTmpXNTZUaG8xcjJyRklVZFJDTzMwNThUTFlZRUVlcTR4VVVkVUhpc2tr?=
 =?utf-8?B?YkIrVkZoWTdKUW5qdmpXRmxsSGtaUEZrUXlKbVVJSEg2K2Y5d1VKSVdpeXhR?=
 =?utf-8?B?N1FiamdQYUJnQU12aWcrTGdwMmVtRVM2cXZ6VEpJMm1zSHZiMElBVzIxWXZ3?=
 =?utf-8?B?dDN4dFR5M3pCUnNrUi9DYUNQZlZNQ0dPTk1LeWNaVXVxb3A3dXlsRWkxSW14?=
 =?utf-8?B?YStaNzZUeEZRNmVoODM5T0Jrb3lwT3hKQlpsY1FHcFBZblpRZFc5WDJXSWZo?=
 =?utf-8?B?RVFjY0lERXBJbUdLaGpmN3hnNWtZY2ZMSGlrbzNTSVc5MTUyb0pTc1dqeHJk?=
 =?utf-8?B?b3VwRFRid05hNU5JdE81MzY3K1NzT2xUTXZhQUtyWW1ERDVpc2dWWnpvKzRK?=
 =?utf-8?B?bS9IVUdaYm5OOURWMmQxZ1N1QjVaNnlkQjRaUzczRXlaUTROMWYwQmZEbkFq?=
 =?utf-8?B?bDA2ZFU1UlVjRnpTM2FFR0w5SFJ5SFB2UCszUUpQdFF1SXhTTU1PaDg1THo1?=
 =?utf-8?B?LzJLU3FzZ0k4V1pQOTN5c2VtSGZOZkdZUkYyTmQ5bjVXR2YwRWpMUXhRTXh4?=
 =?utf-8?B?QmNJdHliQXVsbkRuT2liZXg5elFsVFV5Y0VQVWxrdW4wSEdrSHRCcUkxejhx?=
 =?utf-8?B?WHpIc2xCSmdKWXZ1bFVQTDdNWm5mSVJTcWVLTHZkOFoyUEJmRllkRGJRQ0VR?=
 =?utf-8?B?ZlMwU2ZNOElQaTBYRm1hSFAvSVVtVWZCbHh4ME10WXVMTWRPRnN2MnBEK0lX?=
 =?utf-8?B?ZFdtcXpzNW9adXJvb0Vna210OVFXc2NMZHVOdXNadmJESlhFRjhWR3VlOEFr?=
 =?utf-8?B?M0IxNCt6clAreUo5Rzcyd00rVVVnbVRDcEhTYzVFZDh3czhES0RKd2gwbG1a?=
 =?utf-8?B?aUZEU0FEVk1NMTNNM0xxdDlPazRaOS9QWVpwVWJ3emFJME5pWlJvU0d0VUY4?=
 =?utf-8?B?RkpLZHE5aVoxd0RvNVFiQSs1SlFydUEvOThRcWFuSi83UWpDTjREK3dJaUZI?=
 =?utf-8?B?VGhGQitLbFJIbWhNTFVjamlkcVE1MWwwZVFDR0FpcWtQangzMW9Wa1diK0R2?=
 =?utf-8?B?dlRudDVOWEtXOUNta1dzR2tOQ3NjMGF4MXptWS9lVVF2bnMwWXpJbGVuY20r?=
 =?utf-8?B?UGFTMXlkdWhrMkRaWDJMMlZ4S0xNdmVpa3pubFFDVmIwV2o1ZUhQbVBXekx3?=
 =?utf-8?B?QzNJa2VicTFZU2F1VHdCWVFQeWJQWTJYS0pnT2l2UkdMaTF6T2RNTXVzZ0NG?=
 =?utf-8?B?bFkrOHlraHQ5Sko4NWhpNUxpNzF0SFNuS3pjQWt3b1R0K2xjVGVBdlBkWTNm?=
 =?utf-8?B?NlJERFZ3YUtMaXRHSUw5V2RJUGdvQ25STkhzbU9rOXFGc2ljUlZWekF2SFpC?=
 =?utf-8?B?dTJDYTA5cUMwSDJQYkxibjVKRVdHQU5XTmtVY3FoOGNHNXhJR3UxZStXUnlj?=
 =?utf-8?Q?8nVdN7z87QxOhRGYyvqM5KDorj+F5KxWocgcZJl?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f288064a-0fd5-4b1e-7933-08d92c338e98
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 17:17:00.1894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGczeVxHJH8IMiCBx8rjsS/1mxO3zCQFh+oMjuz9pW1HDAZYxMpf2QqjIKwGOSCJ9VRbhdSe/8QjyF1SmISs0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8279
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The current technology for discovering network iSCSI devices is not
good. Most administrators just have to "know" the name and location of
remote storage, but this becomes problematic when there are a log of
devices (or the administrator has a bad memory).

The current "solution" for this is supposed to be open-isns, but it's
overly complicated and so generally not used.

Hannes suggesting using zeroconf (bonjour) to make storage devices
easily discoverable, but questions remain. Is this feasable? Should
open-isns be modified to also broadcast via zeroconf, or is a new daemon
needed? Does anyone else care? (Honestly, I can't judge actual demand
for this very well.)

Thanks.
-- 
Lee Duncan

