Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56DBC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 16:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348165AbiCUQ72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiCUQ71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 12:59:27 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74913E0D9
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 09:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647881878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iKlIABtWEDjZp3CYdI2hLAwoGIkeAS9WL3Bjz/FZ/W8=;
        b=jogK9Sq4aDVHj2mNG8dwx0basZO2plb6SiPABq9OC3kOQsLwMNnjPKtsd1D/GI2ucRYqnl
        1M3QJ8ZPLxDPXnqlPb4y/q3PC1AyMM+XuAmgizxex/Zkawdf/wUbFdhr0yf/HzMZF0Ovg8
        Cikjs431oMCknPKhAWObUClFc4DKRgQ=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-18-mDlCCrx8PQiJFIoKwQ-f1A-2; Mon, 21 Mar 2022 17:57:56 +0100
X-MC-Unique: mDlCCrx8PQiJFIoKwQ-f1A-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibfxTl9QtvWPYmwKRA3S/o1DACz8nnykdZaDQbG0NKgqiiuHu2P7mQPob2ErylkO/L4Z7+iJJWEdotH+HllHcJ7qmH2g2YhgLbpypdCViEnzTdm63pizeCYusBwSJQTqkMA1giQ4zomcLxzTNXNkK7Zoocd+C7cXc27qL3N55i0o9eNpQKLSoVMEco6KD8EDf0bK2n5wKeVs16nJELKg1sipOd2EhyoeOkkpYzJhFzxWAhA009UvQjzquscY/nNyP+RmHJUwDChZq8yiJjCiezU3D5lHeFMEEeUe+h/Rx13T4kTENxrnb1VtYPGKGmRT3z/jaUtjEDMdr8NGC++Uww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKlIABtWEDjZp3CYdI2hLAwoGIkeAS9WL3Bjz/FZ/W8=;
 b=g2+8RkNncF6bQ+vxFzcwVnAg6ywKsLnt/PhfHu+FhB817M681q2MldNNQzJTi9dDxJqUDWhxdCQbM/Ay8xoXApqIAuz0Evbxemo+6VE4KlQPheWlUoyyt2J7dzGYJHwgQkOyJp6daD2YYsUZycDM22JWnUZ9bBq4thjTSaji3CFWM87aouojPMtwZmkq8wrT/NchrvcrhJgdSh0r/oX2cr5jKrwNa0b0c/o3XKcaa3rCNEXK/AJCL4ek9tlUZpQqxd5JTD/WxoKS0XY7Qg6sMQbe3bCf+qrUKhJbSnnfAREjJIbFmFNY9fDUX5fgeioEkdPHhRO9Bb2eJpdo1vDJRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com (2603:10a6:7:20::28) by
 AM6PR04MB4888.eurprd04.prod.outlook.com (2603:10a6:20b:12::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.22; Mon, 21 Mar 2022 16:57:55 +0000
Received: from HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::8890:ed9c:2b0d:3f6f]) by HE1PR04MB3098.eurprd04.prod.outlook.com
 ([fe80::8890:ed9c:2b0d:3f6f%3]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 16:57:54 +0000
Message-ID: <0ee6172d-f076-2501-8f69-6b105b0f438f@suse.com>
Date:   Mon, 21 Mar 2022 09:57:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V2 06/12] scsi: iscsi_tcp: Tell net when there's more data
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220320004402.6707-1-michael.christie@oracle.com>
 <20220320004402.6707-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220320004402.6707-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0243.eurprd06.prod.outlook.com
 (2603:10a6:20b:45f::6) To HE1PR04MB3098.eurprd04.prod.outlook.com
 (2603:10a6:7:20::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f094377-cdf6-476a-e872-08da0b5bf140
X-MS-TrafficTypeDiagnostic: AM6PR04MB4888:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB4888F4CEFBE32B9D3A26E398DA169@AM6PR04MB4888.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXYJNtYgebVPsbvh9HifxcsKZTs3PVoQiB+gA0LdNdKEp4T83f0Ab6rc2esElreBVa8MdGKQCl2IsJuP+zxtHpOVRbmq9N2IJ3e9pVgj2Gbv3ZK3lvs8mvmNOYbnbc69bqViHife+/ZQpV8LMIvk4AVdwLOzHaIKEjzVVU9HqeBmbPIKCUY/mqPMPyQ/5eFMiclS9drz1wM/Mh+tX20y9hWlyeCjqmWL6FdfWgWWWyg/tjgyh2QW9R/fHNT6ouOAnrte3URTU9YrQ84k1kvv9NUy0YfsNhjgkYAcR9alCtExU7Usog7tBeLmEUZx1cdEqbM9gp1e9v7CE7qn37se/bfmccdl1X+Pp0PSckQfnvE2R2dvvzOphFW9esIbLyhkMpEhHdxYTrufWTUIw6gDN9WbEwNFBCVLimomFKtO0VJON/KcXFaRHCTSJ0yFCmMM5njSzfNUOsn70+oZoyzq+wd2z+KsfMm4wsMtLovueQ6dID4aopeaLRZ9kQAiuWamLKIpV7j8fMb31UFsqHIAws8jIBndresjQhE150LP8IBujnY9OqELNQEiVacs0jgRPRLynY7k84Td+yhurBrRqdXs5xfsQzJH6ezkolyNduV6SFVM0laSsSPqEYvny/llUQiFYjmtOI9+UVLlKTxL3VhzSBJK1BlUFofHooqoJlUWSXo/rb6OmgsgqblIMDnrxZ82+z6Mpg3KbXN4TVJrOpZw1aPaRqgnJppnwcQw/RA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR04MB3098.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(86362001)(316002)(83380400001)(38100700002)(66476007)(66556008)(31696002)(26005)(4744005)(5660300002)(186003)(2616005)(8676002)(31686004)(6506007)(6666004)(6512007)(53546011)(2906002)(8936002)(36756003)(508600001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUhXY0VrdVRpWDJFRHBRQW1OS2FWcHhVazB4N2lFOUxUNVg1SStTcEJDTktx?=
 =?utf-8?B?WjRGcTVHQVZUOVpEU2F0dnBsS1BycjlXaUNFdkxSc2l4emx1OG9qek1xSy9i?=
 =?utf-8?B?Zy9QL3grdkxBbmJFWWlxbjNaOU5DWGhqbkNkRjdidkJLdUE2dFFSNGxTRDZw?=
 =?utf-8?B?SWIrTWp0WTc1NVFqdXV1R1kvdUQya1FpeWZLOGpCN3d3QlhGSU5GSmV5U3Jq?=
 =?utf-8?B?MHQzcDcvUDhIdmk0dS9kdjE5eHlWMVFRQTA3cW0vckovLzhFOTk1Z2N0ZVJX?=
 =?utf-8?B?N3hrU2JlalNscWVNYWRsK0tsUnZCb3ZaMFNObmJWSzBkR3AwUFN3UWpVVXha?=
 =?utf-8?B?bnoza1kyRlU4WjR1Z0R2OTE2QzVWaDV0VE9PMStINk56S1Z5RExFWDNpVWVp?=
 =?utf-8?B?aTdKMUlIS2dzMEhTZmxTWmZnbDl2alJZcTcwQXFhV0xtMHRLR21SUG5LZEUr?=
 =?utf-8?B?bnozbG1BR1I1Um9zcEdMbXBOUzNtQjhRR0ZuWnM1aFFRYzFnbVVXVDBNYlVC?=
 =?utf-8?B?dW1hSTRjcEtXV1MzeW1jQWNsWjkvNmVnSWxZMzNmS01yQkdiUDVGYWZycnZq?=
 =?utf-8?B?SVd6VzZxNEZCcTBkNnZFWm9wWjlMV2h5VGx6YndNM25oQ3E3c1c1dEFqV2pY?=
 =?utf-8?B?VHVUQTlFcm9kTDllckFZTmt6b2JCek9ab0owWXdScVFFVkV1UlUyMVBzRWd2?=
 =?utf-8?B?dTJhMkU4anlFVHFobFlHdFh6eW53ZFlBY0lKQ1RYckRORmIxbS9QazQ5eUcx?=
 =?utf-8?B?MnQ4d2Jrcm9nU0RZL0E0YXlMb3E0SU5hVm1mYnhESlJkOUZjNFdmSXB0V0Rs?=
 =?utf-8?B?VjVqSkpQamtNSUVnMnNQVHlTd0xhTzZZQ2NVOG1DbjF3VFkzaGZyM1hrR0wz?=
 =?utf-8?B?VTVEZzI3Zy9pVmppMTZjZ0t4MmxYcFg3M1BKRUJzWE03S3N4QThpWGFIZEZ4?=
 =?utf-8?B?SmJHVzRUQ2Y2UUluTnhFYlNDaExZMTQ5M1BHVi9UYVBVdnNOWXV2RTdmbVNL?=
 =?utf-8?B?UnQ4aVZHbldpZHpOMGNMaG9aaVQwMDZzSTM0T1JhYTFWcXNieVNqSDdqOTB1?=
 =?utf-8?B?aWE5N29aRUJNTnNHVlVUYmU3WDM3OFZJSjhhKzVsK0lraVRGaHBvaldpNnN3?=
 =?utf-8?B?QlovanNtNVRqZCtsMkRINTdQekpOYktBclMwRGpiL01NdWRhN3ZmNG54NnZS?=
 =?utf-8?B?alM4eDkrTmNEWU5QUFVTOEJXTkVEMk4va3EzR3N5SnRId3V6VUMrZzMyN2Vn?=
 =?utf-8?B?RktpalBWOWw3dFRhMHZWRkc3UWJ6VzdZWkhjZjlNQlNkQ0hFb3VUWlQ3NkJN?=
 =?utf-8?B?dmwyTStsdWwwL2hRUUlJUWI5YmpIS29SWGVhUjJLK0V4L2gxOVRHUC81SmRi?=
 =?utf-8?B?ait1d08yOGVFTllPajBITTg3QytDR0dsam8xWldlRXAxNzJjdUFMYkFmQWZM?=
 =?utf-8?B?UGZrM1hwYkd0SExwVTBzM3J3MzNnb1JudUVJV0U3aCs4M3haUWYrMXVXRjhk?=
 =?utf-8?B?M2JiRlBpTmhWRjZkUjhXVWxFVzVvc1ptVUtSamRhSytiQnRSdURPK25EeHBP?=
 =?utf-8?B?ZWRqN1JyYmxtWm5ZSjRyYXd6NmN2N3dDSzhQd2VOWVJuRU9hTUNUQWdFVFpZ?=
 =?utf-8?B?bXgwQVozamtQQ3lhUFQxQkd2UlRtTGxjVTNFWW9rdUUvekFnZGU4YXZaOEZP?=
 =?utf-8?B?YlJzU0prRzhXbStmNWYzMXYybExRbGgzOG9sV1I2N2todGZtUG1yblBoQTQ0?=
 =?utf-8?B?aWVsTkwydFg1bGUrRnZZSUl1WkdjZzFTOVVWalE5bk54bTZkZHExVEhHYUt0?=
 =?utf-8?B?L09IRUk5ZHlET0FKOE9aMDdOL2NGMVpoTFVxUHZlbndtM2p4S3hyM29vM3Bz?=
 =?utf-8?B?akFHQjlnQldWcnJrVFpudHRGRHZvOGFmUEVLM1NLQ2lOV2hXZzFsVnNoZTZD?=
 =?utf-8?Q?Yu9WG1Qjv1q+7sB62rOgEzdyfblk4Znk?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f094377-cdf6-476a-e872-08da0b5bf140
X-MS-Exchange-CrossTenant-AuthSource: HE1PR04MB3098.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 16:57:54.6494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmsfE02+1H0uoowWO0QmBvjmzHciVDKfkvuYW1GkVB/3LBGT64Z+2ttlkaIAidrksTdR3T+iHc3p41Yh/aOR3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4888
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/19/22 17:43, Mike Christie wrote:
> If we have more data set the MSG_SENDPAGE_NOTLAST in case we go down the
> sendpage path.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/iscsi_tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 4e467918f4e2..067f71a418c3 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -306,7 +306,7 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
>   		copy = segment->size - offset;
>   
>   		if (segment->total_copied + segment->size < segment->total_size)
> -			flags |= MSG_MORE;
> +			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
>   
>   		/* Use sendpage if we can; else fall back to sendmsg */
>   		if (!segment->data) {

Reviewed-by: Lee Duncan <lduncan@suse.com>

