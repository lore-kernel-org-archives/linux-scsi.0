Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46A8C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 17:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B61C461019
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 17:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFJROT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 13:14:19 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:24829 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhFJROT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 13:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623345141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FR4/nfkVESGV1I+PiVyqecIQphtS4isudN89uvmFqdM=;
        b=SwNj6yN068W8LojUMHLW3p0br4tqA6JXY27KqIaAg+iEaG3+GjOThVtIqGgr7g1eE8u+cl
        ioER6N62V32JUD0Klhw2dev0Ps2VHbeWE1iS54eS3nczr9dBQlfrqd3PAiY8fOzA6I1FVM
        ol5jmBzVX5hrVIdki99zehbfxY++6Y8=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2051.outbound.protection.outlook.com [104.47.6.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-Z3eLviMwOUeCDGMnL1jHBA-1; Thu, 10 Jun 2021 19:12:20 +0200
X-MC-Unique: Z3eLviMwOUeCDGMnL1jHBA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/EUprBBqWr7CI6iCyw2S4Yi8I80cT5youFHbWJ/F39JulQduKZS+dswA3NONKw3s4LA7wcMvgj/c/DOoqlmqToBxFlQRS5fIMwL9+PDwPHrDRy7zfFS/mO5d8hbk1+n5yU26Jl5dfb4JW0N+4clPvacbVPu8MqdTh8lzBTIvhCf+8R7HEmeAFpZjQ49ydl8UfU6sHviZxBNt1Viwe3thgMK+P60jyacIZKhxd7k5PPToY+xnN5rzUXeliU6TNBhgvbHHHqeuE9shqFdglgkK4YWIS7tcIbvZIvlj5t5+A5rXYCEGKQZE4WSFcePDbhO3msfrQIPHWK+zLPyMdUJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FR4/nfkVESGV1I+PiVyqecIQphtS4isudN89uvmFqdM=;
 b=ntaHlUHi2qdLrzlLNPKQWiqCCc15KkgxPMcmRNlo9S362gDZNPDMV7E3MulxQ9bvQi4BcryDMo/qDBPXekXjdr0VNeQL/RQYoGsZFOXmlnITodZCwPO5OW5AshZsNLKPxXzErSb9QHiiEYaP6yNWQ3b+eFg3Ww6UVw5JSdENhnkw7SeBVtj9kvoXhcY6mKMaN8WgqooOq94E/ifF78PGfWqzzyJkGtLrYbR79N0pqz034/ZNPbOWJ6d0qvJwl5J5KfTRkc0xZC2f03dwzHFEYa28Qk8B2LVXKB66v6EvzsIR0kLZ+SbyLC+GwzU9Sgjzmqv4kycExOKOHHmsuP2LlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7814.eurprd04.prod.outlook.com (2603:10a6:20b:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 17:12:19 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4173.030; Thu, 10 Jun 2021
 17:12:19 +0000
From:   Lee Duncan <lduncan@suse.com>
Subject: [LSF/MM/BPF TOPIC] iSCSI network namespaces and containers [RESEND]
To:     lsf-pc@lists.linux-foundation.org,
        linux-scsi <linux-scsi@vger.kernel.org>
Message-ID: <e9f0297a-a914-ba83-f706-5a2d508c666b@suse.com>
Date:   Thu, 10 Jun 2021 10:12:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::6) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P192CA0001.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 17:12:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c92d2c1-0ff9-43ae-0846-08d92c32e747
X-MS-TrafficTypeDiagnostic: AS8PR04MB7814:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7814ED4B71F09D1095A3E5B7DA359@AS8PR04MB7814.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6oDbXFeK7aV4LMCvK4xUn+KIVbL7DUKenFnE8MewwKE3sWrocj4zmo1RS2WvNLRbj1H1dnY0Zvxa/5hKrJbS8B4vSh9oX7dcyh5OhOKsbuZuwxay+B1oG9D9rhUIefdr3tYji1l85dNwlfoyhb29J2G24ZLd6u1sF+pwr4LREPH275UsP/ExsEcbEUzm+ytaY6jXn8eYKfoQN52yk0/v56q5TMsne2ntYSb+a5WAv+VLmXlhqVUowXkMRtOE/GNbPnnQYU6kIKGRWau1q3BQXPzkeYi6FetRih+bdKgMHb7vYR2GCRiWfy86gSfBKzNn/4PUZWf4NGpnZyR30WBdEyy1Ku3fYj79edExLXD9Hy2yct2zYI2p33mAGp5po7BsIOM2ONxhOQXpggVr6zLtOU81R3ASR/Vo2NSuKxigZrSPkaV0q3u6S4kVJYSZe/YosA+7zvRl7xGJAlEwN8z5hOneT0np4qDKTHZzXvfXjD0sS8Ftv+kn6nSUR35fsWXUFUlXB+IEJzMOwS6YTXNJZz7U2k/BruXxaZtIb6K0WKXA3VisiuBiNpAIIJ29+gqepsvbND9MEOy1abrvii1Aa4djKqK0ZP/hwmcQ4XovM8HPv1y/S0nbPi1vRQ7duTBhyexQk6cRu5VAytMmI/+vsD20ixKe3R3YeXAMrmFhb3iMp0+68SF8hvnng8jqpvD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39850400004)(4744005)(2616005)(956004)(316002)(8936002)(16576012)(8676002)(31696002)(2906002)(66556008)(186003)(16526019)(26005)(478600001)(66476007)(6486002)(6666004)(6916009)(38100700002)(5660300002)(36756003)(83380400001)(86362001)(66946007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RG9DRTFKQkZXYUVnQmpQNytYVHF1RkM4eEh6T2RFcC9WeXRTTmJkRWtMalM1?=
 =?utf-8?B?RWtHVWtSaW50Si9Najgwa0lES2FxUVlqWTBYWXhBTy92TDhpRWUyMmZQVWF3?=
 =?utf-8?B?dEQwbWxJd1Q0aWN4VEUwTnBkUGJwYlorMXlQRmwzVXJwVUQvWWpMZVFwK1Fm?=
 =?utf-8?B?a3B3VTR0elI4aHJMWk93SWN4WVFHb0dXUnRLM3RRZVowVUp2dlovYlplQmtK?=
 =?utf-8?B?cExlcExkeFZRY1FkazdxMTNFb2gxazdMSEZLc2kxVUFWVUxoZVBGK3kxZmJY?=
 =?utf-8?B?em1ESXM1a3NXRDNXcDI3N1ZrYVJYaDIzdmJua2lMSU1rNnZDbFlpNi9HVlZV?=
 =?utf-8?B?enhHMExkeWI1cmc4Z2RocnhZaG1mZ3Bub2pKSEdabk1PdHhnMTNYN2tXNnlx?=
 =?utf-8?B?TURXYlBEL0lWZThPaTVCalBzRHY3YkFUUUowNXJNUHlnb2pLa2RCNDZObUJ4?=
 =?utf-8?B?OGlXQUlzV3diVjRKZmprTHg5MGRIVGVjQmlzRThYdk9KTUY3RUJTUGJOaHZp?=
 =?utf-8?B?b0JDY2RwMERiallKWkpUWDRqZVlITFEwRlMzV1NRZHNRT3kvM013a2VsaFlL?=
 =?utf-8?B?ZjhqU2NxMTN4SEU4S0RqZEtENjAwTTRnZ1RWcWVndjNDQzYxMk14b0k3dkJ2?=
 =?utf-8?B?aUpHMUUxTklEU1ZtOUFqWHprMEh1MWdJQW93dWRHVGJhZzk4dklhUVdkSTdU?=
 =?utf-8?B?ZWg4VERwcDByYkUxK29DSnpLN1k5UW94RU02KzVFWWxBby9WOS8wVEpHLzA5?=
 =?utf-8?B?dXVoWkxJVU5vamwwRDFHSm00VkorbnBwK09PZ1RRT3ZRdWczV0tDUjdla1g2?=
 =?utf-8?B?T21xYWtkS09oWlNqQUJyMDNkV0JUdjV4STI3Ry8wMnM0eGQyaE83MW9qbWRs?=
 =?utf-8?B?S2FaNU9MWGtvWGtNcDJodGpEWDBqdlRzcWc5NHRLS3lLYU9vMWN6dGc2dWJj?=
 =?utf-8?B?TFkwZHJXamxrK3E2Q3FROHQ1V0xpS3R4ZzliMzhBdG5QZmNMUFN3eGswb3pI?=
 =?utf-8?B?U2o4cG1jVm5oWlAzeXhTWGFGb2NwTVhESlZwRWhkZ3R2QjhBVldsVU4zK2cy?=
 =?utf-8?B?VU9aOXMxS0RycUU1bFhNSy9KQTdscW9RRGhTRnJWN3ZETFdoR1lQQ28zNE9M?=
 =?utf-8?B?LytoczJtRTZGTFR4ck1IUXlaVmYrUGowVkcvLy9wdFdZdWw1SVFFd3RZRUM0?=
 =?utf-8?B?RjFZNXBSRHVEenRtUFBEaGR4Y0c4Vlo5bDZvYmdsQTNRUGsvcTltVitlQ0x1?=
 =?utf-8?B?Tis4Z2ovZ0RTeE1oK3YyRzV0MW11RnplZWIyQllrVjdCWXBFaGwrYXRoRkIy?=
 =?utf-8?B?UGFNTU8zT0RkRkJLZk1aVzg5WXlxRjhBT2lDOXkwSVRpVzRqYmdOMk9lbUZZ?=
 =?utf-8?B?ZjkxUzQyS21ESFdpRTlqbkk2bFVXQlMwV2JiU0ErS1VYVnJVa1p4MVZ0VFZP?=
 =?utf-8?B?MDF6cGpkMnp2cndVV1dpK3lraUJKbG1rM2cwUVZtdzE2Sm1GejBrSU4vQ1Vj?=
 =?utf-8?B?dXAzWk5TNFRiemZWaDNOcmNJTnJ4bDhHZ05IMmNKR3RpbE1oLyt4TERMOVFZ?=
 =?utf-8?B?Vnp5VEo1MUVVVTRvQ29jYXZIVkM0SFZMbEE4Sys4SXRKRTRZa3RJNVJ5UHB4?=
 =?utf-8?B?NExaQUdPbS8wa3pTRkhTeGlaZk4rTndvTVh4aXBXY2hZZ0VKb2RZQkRsdXpP?=
 =?utf-8?B?ZEhQNVdocXNGMXpkd2JENWVzWTFsSGU3eEY2VENLR3FROE5VeDdTaVprdG83?=
 =?utf-8?Q?8CRfuCbh+S+cmxjrJZIbB1MgK084T2pqDKXoGcB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c92d2c1-0ff9-43ae-0846-08d92c32e747
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 17:12:19.0894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xKELsDtALOKNkI0R1iWYjm84nEfbO9uxiNOKrYA6Fs9bH5+ZccyvcuUEbTwBUMpOCl0FU89i4YXOS+uj3OPhzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7814
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi All:

[Resent, adding linux-scsi]

As containers attempt to take over the Linux world, open-iscsi's
limitation on working in containers gets in the way.

iSCSI needs to use network name spaces, so multiple instances don't
collide, but there are some harder questions, like what to do when a
network namespace goes away. I believe a discussion would be useful.

-- 
Lee Duncan

