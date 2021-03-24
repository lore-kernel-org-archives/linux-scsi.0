Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A75C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215E761A15
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 17:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhCXRZU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:25:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56754 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237108AbhCXRYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 13:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616606693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WTW2nRztS5j7nmK8dCHIwZIe6oRxU42WPbu3mY8mBx8=;
        b=m5TaD0xtKqH+UtbZn2hQ3kIS8ohJPf9oVrE3Eg+d1sLmMEOquT1rjb1nHN4hpXmg/IP6M1
        LmMNU4Y48iXcxjWFdwKf83L7C4coByMM2YO3FL8DAmW9949X47M1kx0yVjFzKsw0HZWn9a
        bstHGW0/3I8AHoCGNGC4J7v/+PIwDDo=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-Wdp3p_v1POu3Y3NfVKsEQg-1; Wed, 24 Mar 2021 18:24:51 +0100
X-MC-Unique: Wdp3p_v1POu3Y3NfVKsEQg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aupXiUzjySq80oQ7LkAtBlNMujsME0J+HOKml1ms9lUSJ3NRZwxb09+S/Lsa/yijgf/WKjjTSzc2RmSLRVp5EUUfdlOP982+gQGY9FrPYJgoH2r6RoKHySYs50snteNMfq72fcu+IgF040Am7/cTED8aol7Gstz2xOx8SK5socARwhyzJbAi4iHqXuAi3Mp2KY7BCnE2EXOEtxq47Bgi1VJCzAbesSIExms5/sz2/qxkn+tER52iXp4HYprv7yp9hAv+8oGfTcomxeKS8r6ItOT2BbTjMdH6DjU51JXKY5DT+54SI4l3XP4/JOt6wm6ouRoLuSOymfc1RHm6IVt3CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTW2nRztS5j7nmK8dCHIwZIe6oRxU42WPbu3mY8mBx8=;
 b=M0bLPx9oIVhh2+IEQitrVhQ3zUIoeAR/Y4YZL3qR3yLxT2et1z++lYx47mPcCSSVhetmLKmrMQLHTlV8empDzRVbjX21Pgw4TSq2XlJiK3EdM5DtWerPpQT8VMUqiCR5AQlPe+QuIMKtb55bhuLe8xEgjCs5XK4GCZ/NO6Cm2rO1gRnf4jAqP7ZeGFsMSNGW0MWW9TgQpu2aU5oSaeKI3hkXOApE3O7l9MBgjgJcv0C0SHEwHr5aLhEq9BNebHoM1yqH2kGuwDOt67b0e6z3lcvGloOFFFyQqhTV1xtOrhRAudj+s/3rt4i2PTuPI/Sn7kWUTVPm9ju26ZOlm0vRPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7765.eurprd04.prod.outlook.com (2603:10a6:20b:2ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:24:49 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:24:49 +0000
Subject: Re: [PATCH v2 2/2] target: pscsi: cleanup after failure in
 pscsi_map_sg()
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        David Disseldorp <ddiss@suse.com>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
References: <20210323212431.15306-1-mwilck@suse.com>
 <20210323212431.15306-2-mwilck@suse.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5f6daab0-cf0e-350b-26af-9345afb20fd5@suse.com>
Date:   Wed, 24 Mar 2021 10:24:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210323212431.15306-2-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR07CA0103.eurprd07.prod.outlook.com
 (2603:10a6:207:7::13) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR07CA0103.eurprd07.prod.outlook.com (2603:10a6:207:7::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Wed, 24 Mar 2021 17:24:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c59d6a00-2619-4218-c22e-08d8eee9ba5b
X-MS-TrafficTypeDiagnostic: AS8PR04MB7765:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8PR04MB7765385CA76D6B828DE3646DDA639@AS8PR04MB7765.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yab1VLpv2HxZa6YS3MXMFJKiy9M6kTrTYgd72AMhOO9SE+G4p3hAxNNndFjkcz/kFlP7Jmt2IelPKZPdO8bGo68mGsEQZ5yawYQas4FJHIdlTrKI8WoNsEvHix+KM9M0D2oHlvNNbQKevS1oKPNDpRt0VKlT/WJwU49QsjBae5WKg1u9lBVDk/Ma/fHSRHCEDMtBSQJnX1qoDs/obgNByg7qLMIcgXjCm7+GIeK0Zo7XkPzN+Cg2klJKs+VPMoURHUm7qefA34UDPkh7Kulfxp8cozTyAc3nfhqyunZ12WQms568k5M3Qub3d2tbjvQJMkZVeCzr6732RFdDZFXpPghVCyJ0AVnT0btsjg7DrNg0hr59EekG4rrS9l46cS+Gdl2DMaVIUPzdqwm2aQFKoKYIubQZZujnH7/qG0Gn/4o385F2Hp9y35o7wz1YK4+nccSYfK5UpVTmz9RkCdahtYKIwb0eq238TEt+2IAewLtZb1VxcKUT9ojasuw75ksA4n1N/8iEMRD/Fu1lfDHGOR6b280+M+6z0XJYxzChwXfC7fCB2XQNOi+tmgBKBCnfOOeq9uaIC+KrhgNeArEox7P7W6WlzCzQCizIgm+EHTeuBSPItraAjkgiz/HgyVCefGldCLpL1zO4TnUHUArn1aR4PFdZ67eRlPQI8U1JHxmjw/N/IYXuhefSiwjAf9LCvKaO+ET81HokiKI3gBRx7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(136003)(366004)(396003)(346002)(83380400001)(4326008)(8676002)(8936002)(186003)(6666004)(86362001)(31696002)(36756003)(16526019)(26005)(54906003)(66476007)(66946007)(66556008)(31686004)(110136005)(52116002)(5660300002)(38100700001)(316002)(2616005)(2906002)(478600001)(6486002)(16576012)(4744005)(53546011)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VnVhZUYrRVhFaU1pM3ZSNEtyVXFSS3FuMVpaa2dpMkJkTkw4UjVxNmVMb3U1?=
 =?utf-8?B?c1A3MnRkanFYRkg4T2pPcDV2NlkwNzF3ek9WOEYyWkpOUjMvbC9iYTg3WWp1?=
 =?utf-8?B?QVFLSE1vL3RZQlJFOEg4Z2tLNEJOdzEwOWtVN3NZSDRLOUVFQm11N3VpeVJP?=
 =?utf-8?B?Q2pFQzMreU1LSzhCeWVVMk40RXVRWE5PYVIvUitXakwxekRPOGRaR1U3bDYy?=
 =?utf-8?B?R3V3UWtKV1ZsT0hhU1JPTit0ek5YUllNa0ZZbnFZcitHaTQzaTkwa2FOaEF2?=
 =?utf-8?B?Unl5MHRoRCszd25VMWxOcld5SjVJdEk0UDdEUlZnbVE1NVRFS2pqYWJzY2tM?=
 =?utf-8?B?QXlHQ3dEUFFwYTJUYnNSOEc1OG9KUjRab1NMdExsaTAxZjBuS1ZLSldkTEtK?=
 =?utf-8?B?dThNcTBwZHpsUlV1cXJOd0hYZmRiL3RZSW9hNnVDU0lNMDJkMXRUVzNQRUNI?=
 =?utf-8?B?ejhXdTcxeDFkN3hzdTAzV2FXejYwTHBobjRzSHBUWGhGVXVQSk9wYnZpR0Nu?=
 =?utf-8?B?MmM4bEw5cFhRY3kzQU03b01kVVYyeEtQNElEWnkyVjJmVFk2eFR3UjVSVlF0?=
 =?utf-8?B?bzA1aEh3Z09aa291cFl5bVRHVTUzYkgwTnRSWmNWNFliQWRoN0NZek5Pb2hP?=
 =?utf-8?B?T0NydWZzZ1RrVDFTaEp1cjJiRnMvY1R5TmVpYXFkT2JQMTJHRzVuRXZMcEV5?=
 =?utf-8?B?ZW5GTmRaWjdZaUFSU00xbm5iOTRMcW40R2hvYkFCem9sL3JLQmZ5U1FUeVkv?=
 =?utf-8?B?TzlwZ0lUaFloSkZEb2l3WFFDOVRteFN5M0kvQkh5bzVUVGE1UHdic1k3dVFr?=
 =?utf-8?B?Ulh2UWNOLzQrOEhjOWplM0RKeGRTS1JkZngxMzVwczd0THJDekcrUDJNQk5C?=
 =?utf-8?B?ZGR4eDRlOW1IZDVWcTNsVjhsd0I1djA2MEpsdXltODg5d2swcTBDZ0NVZWhZ?=
 =?utf-8?B?ekVGMzdPZ3RSaXBvbVVoZVgzZGIxWFhnbkJLR1E1QTNmZkh5V2xRU1hTRzBL?=
 =?utf-8?B?alFhL1dma1VUbnc4NjNYYU1kUk5uM3lCeThXVzNZdExnZm8zVSs2WDJXRExu?=
 =?utf-8?B?V0hSTHpoRjVnaEpDUmhKeVl3VHhkcWJUNXpwY1gyWS9IRzdlUmtueTQzR2lO?=
 =?utf-8?B?U1RuNUNmTjQ5eS8xRVJidHFhckkxNHd3R25SdjdjMGZOdUlJSlNHUzVCMEVW?=
 =?utf-8?B?YStvZ01uLzVnUHhnd0FWelIxNTVEakI5ZGFMWmFVSGhCcDJjU0Ftck9JbmNP?=
 =?utf-8?B?cGp6alZLNGIyNS84M1p2WGgvakI2L0V6R1ZGSXNuUi9LU1ZGZEZIY3VCS2NR?=
 =?utf-8?B?L0RJejFDZzcvVzc3YklNMDlvZllnSFhBeFhhU2VkdVVlVGUwQXhSelJiZk1Y?=
 =?utf-8?B?KzZwbGl3TFN2WlY4cEN4ZFE3QWZVaDdjYWFEN2dIelZLb3lXOXVSUGxGSFIw?=
 =?utf-8?B?NWRGRU01T1psSTMwZWR2cEh4SUpGTXg1dmZ3YmZyOUJsaDZ4Z0QyRzQvOGFi?=
 =?utf-8?B?bk1ENmtpc25XSmpKM0RsUDZrMHA1MjVsUjY5Skw4Sng4TndjTm51dklOOE5k?=
 =?utf-8?B?RE10SUlEbzc1bW1zTVdTWGxZbER3OXBjNVJOcjFPSmU0b1dtNjUzeHZ6UTVr?=
 =?utf-8?B?eGdIVEpwRmFrbk8rRGFOSHY1WW1kcFZycFdBQXZFK011cXY5NHJ3c25WUWlO?=
 =?utf-8?B?cHlJc1pISkF2cXQya1ZCaVFLYVdvakF6ZHI2ZmxLQXV6MENVdktiR09DM3Zw?=
 =?utf-8?Q?ZPEhJ8ZyRp0S32xS0tI57tLLxzM6tar+yg1M2bi?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c59d6a00-2619-4218-c22e-08d8eee9ba5b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:24:49.5860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIklcnYTi+EsWdKWSuxV46ljhgMtOwuXrvcNg9nRPcKKZ1ziF/4ulSOTufe4NBin4GZdYWg58MZTuWub9iUI3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7765
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/23/21 2:24 PM, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If pscsi_map_sg() fails, make sure to drop references to already
> allocated bios.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/target/target_core_pscsi.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 977362d..1c9aeab 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -937,6 +937,14 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  
>  	return 0;
>  fail:
> +	if (bio)
> +		bio_put(bio);
> +	while (req->bio) {
> +		bio = req->bio;
> +		req->bio = bio->bi_next;
> +		bio_put(bio);
> +	}
> +	req->biotail = NULL;
>  	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  }
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

