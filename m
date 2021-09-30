Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9A6C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 10:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD51761882
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 10:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349954AbhI3K2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 06:28:32 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:20875 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349983AbhI3K2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 06:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1632997607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4lE8Oao467BH8VTHMkTPuXaaCCs0hAvb4pMN+uFpXEM=;
        b=GbDhGN4vbtvME+IQB67ZXxUbwspyUm27OZ+ExmET5UfAsAfeMR5cfPVKjVMSPnIRpUeBQv
        CbCSd7svCdO3Zjoje0UCVEYIsWyx2ImOoUDPn7KmI02LTcGRXGW9lqg2Uk0y7EthBaSA5w
        P7yTCI3Rh1CqgW0J3xRNCXmhfFmqVck=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-ark5q906N5OZDuPvNcMPow-1; Thu, 30 Sep 2021 12:26:46 +0200
X-MC-Unique: ark5q906N5OZDuPvNcMPow-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INrLQv3BnL+Ae7v8d0CepY5PRxcawtkP87D4VQYQ+Nl6pZcXw0vyF6QHvroJend6egVeKfWJK1W/oZC/Vw8YNgfYOkhq3L8szwWNxfADTTY5pgPENTAC4HYNc6oRdgS2tjy+OvmLG5yl6k0qTpaBOOMwLNtNi20GtjLPktJJ8sYKbsem5o1aRqOcArFunAQTb8I70JqdxmTK/1FNqFGLO98H/tqSKfgwPQvnujtHvjYUp2ar0oEF8ga/wDQ03qRR5S5ENDJA4oPuwryEdPBt8bE171KAKvA/D5zk4UYxqjW+mzGOcqkIFvDZ+AUgjtItZ3TYiHzj7aJkIM8F6CstrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kMpeEgqc7AqeXUyMUO23G1Mtumjx5ZC4X8voPM1e5pk=;
 b=VlTPxGUwsZsjKwA13ezW6pd9uEDbckosaICAGCtPe5svWzhsvgS5e4xSUVOGIIJDNEAsN9bMVgyRwuSfbR8+2c3KGuPS+vpxPgp8o42q54436+f50ty39P1++ZnAaJHRUFEy1KOYLCwju908fA4TAFbAqTbaEws1QU15VsOtiNf7utW4Qsx4JG7usyupn5TkH3DMzBscAites3YWohItRuKe3zxFBTPw9wRIm+3ndIAREas3929QqJCMzLF85j2AT5Csreplbtl0xE14CJE3YqRIu9HJtjEaJ9OI7zGFMJJAn5RFG4YxT77+pl5KjurdIu1cuWp5JNSa26GPH8bBrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB8PR04MB6763.eurprd04.prod.outlook.com (2603:10a6:10:10b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Thu, 30 Sep
 2021 10:26:45 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 10:26:44 +0000
Subject: Re: [PATCH v2 28/84] dc395x: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     linux-scsi@vger.kernel.org, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-29-bvanassche@acm.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <0b774aaf-1981-2934-adfa-c1d50e43386d@suse.com>
Date:   Thu, 30 Sep 2021 12:26:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210929220600.3509089-29-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM5PR1001CA0057.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::34) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM5PR1001CA0057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 10:26:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a91330e-d68d-4655-6de4-08d983fccd0e
X-MS-TrafficTypeDiagnostic: DB8PR04MB6763:
X-Microsoft-Antispam-PRVS: <DB8PR04MB6763C834B2F6CBE1FE36AC29C7AA9@DB8PR04MB6763.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OXGgBuKcC3qRyvsH2yMT2UhUXJWDTA3Dg/ojaohmCW35Du614NsX0pkeAWdH9kB9ymsqDzer8poWL+QP+nPDbJ0fDA4Xwa/5VsXHgNF8ZXp8RQnEwg7sdifJN0y/MHbd1RLq36vVvHPmooKhc0Ejip8YCZKPKrIVvMBEaa6swbeRyvaUO0anyVhlVQJAeUtTuFUcpZR40NS1qsUXC14FABBoFqwOWvJSHsAR088LLgs2LaMiS1swk9T+V930XP0U+FsbLQ/H2gVAacXYfcep3LzHIv0wbqiFw0d+i3yR7nOxckH2sPu+TGeUTcvVrZKbyfzz+sA9GGXLJh03fWqVTOBjTtVrpB1LcAim1so/v6Wfp7btv1hPphgnfwm39l9JqPGdhfha+SD79QdAonngmRDpC+VbbALN+EHhHu1sUYzbIs4oY7g1x391lDH5oENODGQ8BF1ECbptewMKB8slaBfsJNyha5KS/OLviaPLuVUE+aznLqe5vnGtXKwqLjAp7dVXYsrWvT9YKXO/Le7seSr+fBGThTAc3A65huzYoGxoIj9kNse/K2d4D5pIbY3BtaAYlfe061qau5KNZN1T5Sxe/MGrqW4Gtu9PDudCtgRHsEsS/6YiEtHvZ7xOEpcyLqvrAObOjIUmJTajQ2q8unr4VNi/t3emlvfgP4Y5SuLCFKeW1+x0jXEHX5HmrW/jq/6s+H39xDNj8Ep9qclDuwFJ/4CGi17PVikd48Jc63s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(558084003)(2906002)(316002)(8676002)(8936002)(53546011)(6506007)(66946007)(508600001)(186003)(66556008)(66476007)(31686004)(6512007)(2616005)(5660300002)(4326008)(38100700002)(31696002)(54906003)(110136005)(6486002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZHWldMXEmrtgPak66wkWPORY2NA6rYUHzDUfyhe/OmatCpMHYrz5HkcmOVKo?=
 =?us-ascii?Q?guybBCJ6mTlXoI/KvasiOLsHMUZiUc2Aw6DkxTFQrCtBQbsn+qX4+DnbGZKZ?=
 =?us-ascii?Q?eRPQJYCGJW6/n88LJck9jpe1ksBlO8leYJhi93sQlwgXQU/ncmjvJdCNGD3L?=
 =?us-ascii?Q?K5XoaoNa7f5vL83tmBc/vEoXKrFcDSSpOQaIKm2ER75GO9/Shco0W2g8062n?=
 =?us-ascii?Q?6hOR7NQ8sTZkbbQcaE5Gv09TeXMB2lyByKcuTYAWY18kQ4notFh7dhLf+y2N?=
 =?us-ascii?Q?1JNHlyLy4YsDtmQ1EzgapE8NLhXRDqWZVOJrI+zMABNr+e9a+dW3Puxfzrax?=
 =?us-ascii?Q?orV8kBs3yUpGSDF1pIfEnT1Pv7Ee5ovyJJtuTTZ3ckeHCaCu6GOdguiDR/Lr?=
 =?us-ascii?Q?XP+M+SYvbsnAYH5bb3n0ZgNk57dbI1un6oxqNLUQJ7aLfiw5kjxf3yjuPydg?=
 =?us-ascii?Q?RsHgcPnFr6gTbwGGnfLiMozcwJIVs+OS15OfMCst1WAHTQ2iezDLRYBW1i2m?=
 =?us-ascii?Q?s8ebXfhgDNUKBotNT+FoZyb7xPguttUH4Qg51LYSoxjYGD8FGp0sz3exLjnT?=
 =?us-ascii?Q?/OwOb/8VUZniWp0H8lxnF3WQ59QW5RlYFyMUjN9iUvaWs1TL1Fu3dAxLz0O+?=
 =?us-ascii?Q?4aFw1hqycdoYDQg9mqRqDDO9uY9bMYitSd1/i+V3y5m/810fJ/dAmaWEPkt0?=
 =?us-ascii?Q?PMS7SdNPpGv6c07Masl/OkY67FySxfJoC5X9ZI6KhNw91fB8uFwyIKhSZVKY?=
 =?us-ascii?Q?xix5UQHh78NVSkRQM9WZrKROYnzhCh2WQuyvWwDCYMPcPUR2E41ymVpO/MhG?=
 =?us-ascii?Q?Q7HaVF5V2uis7PHsXWVINjMNaWWcmII4UxTKA40JxHnRqoOHdYpQLl1yI24k?=
 =?us-ascii?Q?wZV6hDYEsU9acHb3C1CaBB8HEJCL38T8s8bAqJN4UFgTcbZA2Ap0xp1coJe/?=
 =?us-ascii?Q?98FtlJJEJlk4rpq1R92ribLgXBoXZ+6euDe9uNK3vi184auClTHc441fvCG6?=
 =?us-ascii?Q?6PwIp+nYI7/vdQi/BQ5lVirI+WF8LnOlsDiXS5d9EUcsI4jpMqDQD6hBLvA+?=
 =?us-ascii?Q?jW4n3WAG7TuUCAL6EY75pQecVRnc1BQxutyqwSfzPUn9RCXAfZE8SgVw+PHX?=
 =?us-ascii?Q?/xZR6IiKnHySjGOriGm7KmtN/0Qx/G7msflEAIU9O38QttkALxfSEJmi5U49?=
 =?us-ascii?Q?67VIg982y/vQzhAHiHzj49M63K2qric2+myW2xK737CaPMVd6aT7TmWITXFV?=
 =?us-ascii?Q?zQ1/imE8tubepbOxftWinncY5p94IHfMfLuzDtnLANgUFdte2a00d9URZQ4p?=
 =?us-ascii?Q?ZK+gqhgol8C4ebAldGcz/gghbg0yci+wueI5jsrPA7ktDy407MDMePapFJaw?=
 =?us-ascii?Q?WoY1EVPl0IZPv5rV6xGt35jqJacO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a91330e-d68d-4655-6de4-08d983fccd0e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 10:26:44.7906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f84OmXezGko3sSGwFDfK3QuxbwEHlHMo74BlADAJeeE6Ipguv1Ng/PGA6eoXhEQgK14QwCceQGKTatp+VqhvYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6763
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 30.09.21 00:05, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.

Hi,

as you are doing this to multiple drivers, is there really a need to
pass the
the function pointer at all?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

