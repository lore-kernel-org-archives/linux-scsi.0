Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652E0C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 16:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E2361289
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 16:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbhEFQxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 12:53:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:57114 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236052AbhEFQxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 12:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620319969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ul+ThRX7905cNteg4ySKc3jzpYLAT2jXbTp3n85QW8E=;
        b=Aol/2nSW8BTh4IfMe8/+5dfyB89Mm5b1qO78lqFqIFRpPjdLdYORRPBXdF8c1862+HmS/F
        mEo/cORFAHIK3lqMX6mASskJHeEk/3zGdQxGlsp+2MtZSLVFOE+WLzqpEn2pgzuwt/+sxB
        INFf+2f6wIHMJ83a8GromYwc8yegY6c=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-Kbx6ry0XP7SEgVVo8rgW5g-1; Thu, 06 May 2021 18:52:48 +0200
X-MC-Unique: Kbx6ry0XP7SEgVVo8rgW5g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl83k/JHkMnScllc4dw2coFuCaDHAJ//CoPVAmwS+t2B5pPKMAA9CSRCnL2hOejBIzqXiUh3q3tm9ZzfvPZecuAwrs+7V75VpN4NhgvzS0N2R0UiPk5nSmWnKf4SvI5V8D3f6J4CtMlq9lh+VN3a6nqusysX8Hf0zdefM4qYMlAP7cC1ZXvLqZtf83HFl2Hc3gE6dResMxtGz9ea+tQTcsvFDlgpvqRPm9gXKZnyhr72BO+BdpizekDlBFG5Iyz2TG7Rz/kPt0Cxl47+n0sLJPa94z7IDy41C7Z3dyP2g3Pb+NgOuXqHl28z0dTOzAkzt3q3segboVvAWi9tCPQNqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ul+ThRX7905cNteg4ySKc3jzpYLAT2jXbTp3n85QW8E=;
 b=ABhUga28q/kLRxKDY9WX32KhGIb1iwyM5wp8j9R3LeKmGObN4hFkZCFrMMVsGRck7mLHpaLoYZfFkkXvBLKJyRY0Rp7c/llgSIPi2gtlntOro7i0jOFeM9MpPjwEB1wuirKzcbHkbhIi3RHhkG086GtgvCfF5NUaord0w72aJgX2vetPdiE9Gj5YbNbecYfR7sIghXtMCyxd0kVJPHWCj0o8SWXBWv72m47S+sK0GNWHzkSWkp2uV4/9JVvnmIyyRHO9DnHJcUfwkZ/SQ0X/DGwgKbQtH/4xxbXmozGiDExxLXkysd9II+wGdPStHCPU1OmheDvzbcqGltbmfpjboQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6469.eurprd04.prod.outlook.com (2603:10a6:20b:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 16:52:47 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 16:52:47 +0000
Subject: Re: [PATCH 009/117] iscsi: Add a compile-time structure size check
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-10-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <a9c3f036-652d-e73c-fcbb-829662c04ce3@suse.com>
Date:   Thu, 6 May 2021 09:52:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210420000845.25873-10-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P189CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::8) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P189CA0003.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Thu, 6 May 2021 16:52:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23b961f3-f6b2-4cc9-e5af-08d910af6077
X-MS-TrafficTypeDiagnostic: AM6PR04MB6469:
X-Microsoft-Antispam-PRVS: <AM6PR04MB64695F66A4B377103C967B2CDA589@AM6PR04MB6469.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRoV3DqeZ/U5jzLB/HeWnsv0VZN79UwPF/epNsv1XwhSaocz4zofhO99iP7KRbHe2PPtRH2Ix57TPc+TTJwQ2Ms+wjJcM3nd8wN6/Hvs31ZPNNl0ZUUW3xROFPpEcmctG7iYCV1DUke4semCWLoqHqG87Mdq5JxtNL3+ZeNsHprlbIblL//HJihme6gf1VwiqV8T/F4Whhmx8YWybcXEFkaQ2VuHhvDis6f4Y/04A7eOJlzp/WJAagpsQPOnFQQrZBBiUWdvORniC3JhMHng5l+EeJwFodcz066JS7agw++1uWjtWJ2uAWpVRq/tjqZhZsZxNKSJliABaHHAGIqpl175h8V9MchzJ6EolxjGPlVamRWTV7h6UE8R4AwrkKTaJvZ4wu+uLhf1EMICoo+l95NV17MUsIbh0vA3LeEWNCnILUK/JmZSAiW2eL5m3Vf3enJfv9Omz1l16TVpiz1wp0rdlEk7a5C2CH/P7fPxQIghf6vQvn3k9FLAX9Xv915TIDpZC72AFebEKa2xjLdqxBYsZBWQTn1OOcieMARf1zPjkzPZPWL/yig5o0yNlFgG12BT1xJMfF/iYahXKmEBKXewzFJ4STJupKJ6/Ku4KnclbWPYWiuLX/xrtfVMUP+Vbq4a04e0XxQPdqqsZqE8dwB2Rr+JLBBOFdko+vMkNSUsLVUpXVYzMwzUJfGNbXy373kSN/3X9+a+hdSqb7fuggBFn4uU83IYyaS1Qa3yphI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(376002)(346002)(366004)(136003)(38100700002)(6486002)(478600001)(31686004)(4744005)(2616005)(53546011)(110136005)(66476007)(66556008)(316002)(31696002)(36756003)(186003)(38350700002)(956004)(16526019)(6666004)(66946007)(86362001)(5660300002)(8936002)(16576012)(2906002)(4326008)(8676002)(26005)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z2ZtRzRzTUlyTlVyWVVoNDBpcXJ1VlVNVkp0K3YvcXVaazJXaEhvZGFIT0tW?=
 =?utf-8?B?N0hON21KYnBsSXJ0NjB1ZmoxOXNOaTFBeTNOU05TdVU4SWFQVnorSEwxSk1Q?=
 =?utf-8?B?T3hodHpySmNlV3RTMktUSFRHeU13d3BUVnNHMzlKOEUwQVh5M09YSXRnYWJk?=
 =?utf-8?B?NU9aK0JidGNSRnNEaWpEMWQ1a05YZ0tnT0RIaldrL1ZJWGtIdUtWVGh5bnhz?=
 =?utf-8?B?b0dTUGVnYjFJYUNqRzhISHdyOVNodEFTZ2wwUVRtM3M2UG01U3R5T3dDVUZh?=
 =?utf-8?B?WkJDS1l6VXNNUzJOKy9Fbzl6Mk52Njkzdys2cXB0NWo3OWQ5OW1EUmNnQk9P?=
 =?utf-8?B?QThWUFVEeEQ2MEtuWUNWbW1hb3hIMTRRT2oxZGhuY1JPSHRJMzhBQ2pDNlp2?=
 =?utf-8?B?amNLNEpYSEtIN3lOcEtxSVIwdi9iVisvMXhQVVRHVUJ4c2dBZmRhVVdkRkRE?=
 =?utf-8?B?RldUU3IvZXNoYXBoaUFTOUdjenQ5Tkd0YlNDVldtQlZFQXMxK1JhUHk4cmp6?=
 =?utf-8?B?RXFLTHFlVU9pVUlicnVuTnRCeGVuaDZQL0cyRzZoVDFxT3lZaTc5dVUrNDF5?=
 =?utf-8?B?dmptV3k1dmF4VzBiWGJFTTZCWU1NQ3pDbEx6TEZrbWhZendzcmhGMzV2OU1J?=
 =?utf-8?B?Z1hsSW16cjB2cC9jY3cvS1I3SVYyQ3NDYm1uenhGS1d5ajh1QlNMV09nbUV5?=
 =?utf-8?B?MVJqelU5cUV0enozOWFRanRDSytudlJPYldJbHArSmx0SDl4R3BIZUJXUUdO?=
 =?utf-8?B?NGVkaEM1UTBDMXJ3Ukw4Ny95MjlZSnVick1nMVlhcmdOeG1UT3lrL2ZvbVpL?=
 =?utf-8?B?aEtBTzNwSnIrV0hlcGlucnJTVklaVFBjZDh0T0p4TEdwb0xlQWJpS1Bsemkw?=
 =?utf-8?B?aDN0NkM5bmdYck5SVWlPNndDOVh6Q1BRNS8rTVRwOWFJQ1paSTVWYk5WZzZK?=
 =?utf-8?B?SDRaRTNaS1hDbDc4Z2g4UXVobGhhd1JRdkp5bi96T2ZPdlJOaEpxNWtGcHBx?=
 =?utf-8?B?KzM0YWlGR0lpcGJkWGZpQ0J4cUZiMmlHcmJCaDNhSkV0YkpyRUZUQzBITFZR?=
 =?utf-8?B?eW9PNmFURWRVeVdaRXhKWE9VK1BDRy9QcGUxRHNDc2VEMzhCTlRpejZnalow?=
 =?utf-8?B?aUVpT09GejJuNGF4WTE5dUFsSERkdGIwNk8yenhtcFVBWThMUHVpODdjM29G?=
 =?utf-8?B?QmlGU1NFT3drTVdsT01xUnU4M3RkanhsVzcwL3hybm13TExsUG9HMHBZekVI?=
 =?utf-8?B?ZlNxMWpSdDVoT0R6NThOcjZnMGtVdGlucDRQdDFEKzl0aXZmVVU0bE9lRFR6?=
 =?utf-8?B?TDM2Mi85TmpUVWNPeFlQNVlVZHM5VFB5TkZkYnNKTWJXRVpkVXZMTzNOMkE3?=
 =?utf-8?B?bWVpMGtQWVE4bmxOM3RQYmJuZThwamZHVUxSdnhQSURHTm5SNjc4R2NWRDJY?=
 =?utf-8?B?YnIvK2ZubmNMWFJtdXlNYkV4UGRRYUlFTDU2MXlLZXRTc1dkcDhBa1FsaUtP?=
 =?utf-8?B?MnR0NWNVRlRmdmJnVkxpN2NKNWh1RllRTWZhdmZoNWFnUlVZdVBIT1ZBeUNj?=
 =?utf-8?B?MEJ6eDBpOEhmVFBaQmV2UktHd1VtT09iMTM3ZnN0enVDbXhtMU1IWWZldDRD?=
 =?utf-8?B?bEFjMXhzMEJxUHhiVlB6RjhxZE5ackF6VEZDbDh5d1dwYm5PZjBKZFhQUkdI?=
 =?utf-8?B?VEVsaEYveXJsVzVtQVRTMGV6ZkIvcWZlcUtLb3JDQkZudTJzRVorc1FHVzk4?=
 =?utf-8?Q?jlK5XJplUzSLaW34S9V3Dx1YdhmNK71AunilYx8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b961f3-f6b2-4cc9-e5af-08d910af6077
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 16:52:47.4296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6PV8JMUvIQzuAi+de9d8F3ZeQ4IUICLtJdIgL3RQLfypau1toGfOrWN16ex74HaPmpKClvcV0H31y2O1u2WrzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6469
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 5:06 PM, Bart Van Assche wrote:
> Before modifying the struct iscsi_bsg_reply definition, add a compile-time
> structure size check.
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index bebfb355abdf..4f821118ea23 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4729,6 +4729,9 @@ static __init int iscsi_transport_init(void)
>  		.groups	= 1,
>  		.input	= iscsi_if_rx,
>  	};
> +
> +	BUILD_BUG_ON(offsetof(struct iscsi_bsg_reply, reply_data) != 8);
> +
>  	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
>  		ISCSI_TRANSPORT_VERSION);
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

