Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA1DC43219
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 19:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349785AbiCHTB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 14:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241039AbiCHTB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 14:01:58 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2C1192B2
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 11:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646766058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEESI7MmDVcI/f7NwPHv4OnlymKt5Nzyx/8TE5AYM2c=;
        b=E/RAZ9kFGk/P/KpuMDZ8YuVFiQs/3TU7Z3FLeHYzw3KFLjfUt6SQUwEXq8xynBrgTeoUM+
        j90r0I6KXxDZNHqHkZ69HVzekhWcjkOx4K1fon24jscRpQt6ThPylNe2wjuPKcCSKUJGRW
        Wsmhrz2Shz/wWEmiuxoMfYyLT2LW00A=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-nrx-f-5HPbq3FFvRZyjBQg-2; Tue, 08 Mar 2022 20:00:57 +0100
X-MC-Unique: nrx-f-5HPbq3FFvRZyjBQg-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3jz6fUH1xzCR8S8msTjjSE+g2GkYXP5d2GppSviXjFe9VVB65rlOdsgjQGOKoGbQPMTW5KqGbDMCyFo/oQAFh8Js1GN7lz/Hyed4dVuL9yuvU6yaSq3dmwe1VgN7QQCILPXTv0dqUtFOCYhOes/e/djFiaiRNsj9qSvExROBmCtVGe8H5m7IJmSWq1yb4B8pUiaUY3hNdikwag8RMdZyVCrlV3e4n+4kV+/9WG9HQ0cqffB5vQa5IxTqu0LXIFfg7UAihzYE2+Oyx2wcQPFa8GLGLh32hV6ISSyi93LUj93+U30aoIkfhgKay4tAYM5Oz5G8y52odOK+azu/ZMEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEESI7MmDVcI/f7NwPHv4OnlymKt5Nzyx/8TE5AYM2c=;
 b=mvxYqxHBoxE0rktGGfjrerE5JjJyJ5FVVCmvJjWs9eStajGD+D9OHWful73ImwNVJAg36e8ax7+adeGd7Usq4OoIsHhgoU3Bo4v3EqSRZDU8rQHswWfvQRW5YSVDknsNNSDn+q5XN2ZSfE5hODmulAMT1XwI6m9OFs2ph/99UKutJqsS5cbejCrrXxTBS4LejsUri1qySoUYxaeTe8jzkJoQlYuvdmltf46QPy4klBj+EqAmBakFhMsQdgtCaJpFteIGmk9ZvrAGTHuxg6H8aSbRSTAmyjw9CiZvIcB2SGkplDl5hRe3afUHUpaq1lk7PIeqv+HnBpdTLGEyEk1HvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by VI1PR04MB5472.eurprd04.prod.outlook.com (2603:10a6:803:d3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 19:00:56 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 19:00:56 +0000
Message-ID: <ba8faa54-f9a9-1b45-e98f-10d944072d08@suse.com>
Date:   Tue, 8 Mar 2022 11:00:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 04/12] scsi: iscsi: Allow a recv and xmit work to run
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0163.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::24) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b06207-3f26-4433-8c29-08da0135f999
X-MS-TrafficTypeDiagnostic: VI1PR04MB5472:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB547297D4E473345672E5587DDA099@VI1PR04MB5472.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YkWm27BkoD3sAJRCdjFX1H9bXqiEgIf4R1CkrjBi7/ssMHKuLfWpkxlLLlyEjbxxGdRmNoKqQfXRO8Vr1gwzS4rRld/ODEoh+1vnb3cA1MT53DeS7iZQk7o6+XjHmRXc8igesocokm5GJFl+cpRF/aDIUR5UhOFWeLKLngfQlFInxIrXuyQ5K9jK6FsrjXz0gV9wr0ZbxCMZhSsjmw9/HUuetmpZhO680EeBGsqf96MIUPfE2X/M7MUYDQ/oaTtAP5UclbM7knsd2jHFwnucSh9BdJ3iDVj9DI+4HkZNtaLKuT1IMBRQMjw7YjSxdAdUZFOh1/KFcNDNyRIxzsyvPKfQV+sO6rII/69xmopGPW3zylEvVUyfG/gR0GAyqmkxyFNdHOAvHQidO8sIMhEsWvFhOu3F6KtYyBhgbC+vgLS/3984be5na/mFGBAyz0NTs7CI+4I013wJnj/bf0A/gMrwJhLUAZf0ht+WqRsK52EtewNX1JaYZ46AtoaLAZ1zoCvBkAhb69b4mkgE694bZijNgmaoKxHoYYz2opq633elXs8hP2i3hu532X8sWQcGVUV3Zb5xev53qU4/o13/JG0Ze9tJJGd8UuwYzxyBAKsfQ80/DhF96cFiIqYRPkCXHdzNaPhFsKh/rrt9EZf+4ZzCBofbThrUzdqPJvyDSGzt22kUMN+XwEirh6yVBPehyKPpi4T+VvqpKpI/zHecxqkqEprNCY9L6GzSj0mYJgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(8936002)(5660300002)(6666004)(53546011)(6506007)(8676002)(86362001)(31686004)(38100700002)(36756003)(316002)(66476007)(4744005)(2616005)(66556008)(66946007)(83380400001)(26005)(186003)(6512007)(6486002)(508600001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0FhWHdmSjVVdjJXa1RHekNSUjRvWVBYcE9Gd2ZoT1hjdngzQ010b292bVhR?=
 =?utf-8?B?L2FYaUYwUTF6ZmNFUXBWMHpLS1lqdzQ5QUMveUJXeUdYNWRjcmZjTXNTNHEy?=
 =?utf-8?B?STM1TEhvRkZpNkFBWXF2ZjVwandET3ExMDA3NmpaNGFFbVJlNGZmUkdGVjVY?=
 =?utf-8?B?YVRSVmVxa25CZldwcEY5ZU1qWkxVVVlaa05MSzl3Mk1KaW9oMmxTZWU3Smx5?=
 =?utf-8?B?TkdYL0pwK3Fvckx2akxiTmhBNXVWZXFIVmFBMGdhcW8vTFNSQXVVbHdJRTVU?=
 =?utf-8?B?VTRrUzc4Q29lb29WVWROSkhnNjFLWFQ3eFRMekJCaEFzdjE0djZrSWJ2OHVW?=
 =?utf-8?B?T01LMC9wQVBqREl6bjkraVFWSTd3ajlnMzF0MVZYcVdpdnVOd2ZybGUxUmw4?=
 =?utf-8?B?S3c3YXJKdlM4T0JzWDhFSENmMHRiM2twYUNCdDMvMjJ5andCQWY5L1IvMFp5?=
 =?utf-8?B?dnNzbEhtNE5ibW9QR1R5SUh0eFEwZW1jM2JINVZiRFRjdTFJczlIN2RtQ1ZS?=
 =?utf-8?B?dGdDQ1NCa05SNDN1a3JxSVd5cGUvRy85c3FwRGp6UEJNc0U4Q1pQNmZNMml5?=
 =?utf-8?B?clV2MEkxMy9ZRzFjVHRVL1VsYmpzNzEvWTh4QzIrak5NNFFlK1g2M1p1dTRI?=
 =?utf-8?B?SDVhOS9LaU0xNFM0b0JwcFJtajdIUFRZV0MwbnZmN1AvT0wyaGp3ZklUYnBN?=
 =?utf-8?B?Ny90VEpqaGE5a3E4VHJtQ1B0YVh3WVVjZi9JTDNZb2ZmdmUwOEYyUGhCRjli?=
 =?utf-8?B?VDBVOURCQWt6Q0czOWVwU29GQW8zdnVVcFpyM25xQVNKaU1YaVpta09QQkZF?=
 =?utf-8?B?OG9WR1lVT0lubTBBMnYvbDdxV3kzTmovcUo3ZGdmL2o0ZWdpZklMdWd2K1NZ?=
 =?utf-8?B?UlE3YmhWMGVZNGF3blllL3owRU9jNVBXQWVaWklNeVRhVXlaTURJbkVBNFd4?=
 =?utf-8?B?ZmU0b2NMQmNjdXk3MDNkV1E3VGdJRlVCeTROenAzbSt2b0VMTFlCNlIxeU55?=
 =?utf-8?B?UlZKZmxXTFRKYmpCRktCaUJYcldZb3UwMmhheWt4MFQ0ZVZKQ3RWWDVQTlpa?=
 =?utf-8?B?TVpTMVZXRmJpSlJaUEU1ZEtveDlidk90SnBLbEJ0LzJpWnFSTW1tZGFMTkxJ?=
 =?utf-8?B?RHdZUHRkS2g3ampzZjdaRXAwaGdxZ1pZaVRhLzlsR29wRmdzQm5FOGo3K2ZE?=
 =?utf-8?B?UHQzRTVUVzJNRmI5NTJBVG5BQ0dORlVzbFd4UDNmMm5Db09ncGRKeFE5ZVk1?=
 =?utf-8?B?OEFKT2p6TE9ZMWV6SWdMemNHSlJUV2xIU2JpbXcyODZ6Y0p5Q0grSVZIUm9G?=
 =?utf-8?B?dnFnK1ZTVjVBem5DL0VBUVZuS1NQeEhYWjlQWndKYkNlVmF1QTlVb2lqZndH?=
 =?utf-8?B?NXl6RWhYSExPbG16Z3JzMVZFNkRRbHZyckZ5VUtCQTdrNG5oOEdVYityOGFn?=
 =?utf-8?B?Z0dCSU1JN2M0bnlpcWNUSG1pV1pDK2E3eGF1VTJpNXIzL1kvalEzZnlRczBN?=
 =?utf-8?B?VnF3ZVNYSHhnMWVUdzFzVVlwYWVqR3liQWRORzA1aWsxYUYxRXhiNzh0QW9q?=
 =?utf-8?B?dnZSdlVKYXNialE5T095K1NaUldmaFFkellJUHVLaGR1TVhrVWd6U25ZUjBv?=
 =?utf-8?B?WXZCWENTOGI0bmVFYnNnc2NnL1o4bWRiTUljMW1uMHY2U1VTRmF5V0RiK1FW?=
 =?utf-8?B?aUJhVHRCVE9tUnF6MEo1NGpORks2YjhUaGNzNi8zMjZDYTNQcUsvQWxGWFkv?=
 =?utf-8?B?VGNLUENjSTFIZEZrQXYrVmhZVVp6bmZwRW9EaFFRVzBrTkIwUHUzY3l0U3JK?=
 =?utf-8?B?aFU2Z2NYSXJqcXNISi9XY3VZKzNOdWVjRkpVU1Rndm5rQ2pFanJkWFVhQUVJ?=
 =?utf-8?B?VUtHMVFmNUs4a3VHUUFoS2xlRU03QXc2WFNXcERlMlI5eHNnbU5HSjM2ejAy?=
 =?utf-8?B?dE54aHAxdnBIc0MrcGJnSmFYME14SXRtcFFHV3dqS0ZUQTlYbGFaT3hNcHdU?=
 =?utf-8?B?SmFUaHMrbHR2cjdtMkNFUGtOV0FaaHNIQWs2WFZta081UlZ5RDNXVEdwT3BY?=
 =?utf-8?B?YjNJSFBHRmpLZmNZV1kvUHAyd0hqazJMNWsreWZYNjFDVkczTTc4Y29HU2RQ?=
 =?utf-8?B?bDNVSjJpeXpsS295UTgwNFBaWER3aDM3RmdMOVBROEV4c0tLeS9QZm1PMEV1?=
 =?utf-8?Q?nol1pxqRNOhNfql83Ik0J3A=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b06207-3f26-4433-8c29-08da0135f999
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 19:00:55.9924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CsGXZesQC0X1Lyf+OECpEv5QfU0dpkEpPeY6f8iKc5Thah8lIIwfODPpF3NXrrHKm7IjWtXplmmDeH+NgbsSgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5472
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> Allow the recv and xmit works to run from different threads if the user
> has set it up.
> 
> This also removes the __WQ_LEGACY since it was never needed.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index fec64cbfa4b6..0a0076144874 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2824,8 +2824,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>   
>   	if (xmit_can_sleep) {
>   		ihost->workq = alloc_workqueue("iscsi_q_%d",
> -			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> -			1, shost->host_no);
> +			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			2, shost->host_no);
>   		if (!ihost->workq)
>   			goto free_host;
>   	}

Reviewed-by: Lee Duncan <lduncan@suse.com>

