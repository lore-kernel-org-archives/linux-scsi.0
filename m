Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A8BC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 16:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbiERQEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 12:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiERQEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 12:04:35 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECED195BDE
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 09:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1652889872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W263Sd6tchkWX7R0j98DywFvn0I53v/zu+vPBte9SMU=;
        b=QOGezEd8GnIBS0+hwoKyAM0N9QRjAxx9ajXn2+eMtOfKOLa9WzR+zU0pC9ffsi998VDzG3
        Q78Qp1F2ABcnzswmy1JIQ64x/62SoqcHuolSDQBpKCKsxMDnMV1EmsCYO2z0lr32n+iej6
        k2Z7zZNTUdIwzneYaUfxuT6ge0ZPJ4c=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-Mb301OQFNouK8L6jfAJt1A-1; Wed, 18 May 2022 18:04:31 +0200
X-MC-Unique: Mb301OQFNouK8L6jfAJt1A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUQ3gbPpnikWPs6uDJWP2bGZAjTCpsb2ercjMnsrG1Dt0V+tMz9ck6oM0JnJKeA1EM3N1LerExVdS+0BNU9mWYC301G5TlhEmVaQawFW8X6M1Cjgf2kWZnOadinY5zChSmzZ+ajF8eFKnVyGEnJhQj7l/ozYf/Xe7v1MZr1nMNyzW9mdcQJlnW1b4RxHo9Gbhsm+Drzu7p5q5WfR7NRCahcvzHfWC6LBbaSs1kZvsulPfUPBrIcSkMfiaSiTkLLQtspwTEJyRnC5r1cyoY0orjLa3XCICK1immKah1wT268MK1sql5qedG+b79fRB+lTUxismU62Gg3fetPiND+LYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W263Sd6tchkWX7R0j98DywFvn0I53v/zu+vPBte9SMU=;
 b=SGXAmfWLotoa0NidoRLFhu0oXFtu3kO8ueMDVWiapUQoUBxzHt5wphkv19VHFl8b/ZFGIUxLgViwk1XAATWS/MyMRKgUAGh94ftGUrpVwSzvO/AF5GAltBbXCzIFDCGjI0yPAzmWdhn2Vox2Basb8C5SSlOw4rgJxW0j7Ke+/qu4jYwR4VWlrwcBKnU6qq31Bs/c6s7UZYU+SMSjnK5hlKYPvi9rymgroleHKOgHn126lAMxp+oSruevQh2J6AgOBWxdsFIxapCHq4qCxrkGWxGDa86UGg92km/HxrqBTwN6Lmo4C/qxdIeL5LyfXadgEKiZfXQ8caz3ATle6raPTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM8PR04MB7810.eurprd04.prod.outlook.com (2603:10a6:20b:237::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 16:04:30 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 16:04:30 +0000
Message-ID: <91fb1cd4-c8bc-9e08-2b7b-5c78c9f665bc@suse.com>
Date:   Wed, 18 May 2022 09:04:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 03/13] scsi: qedi: Use QEDI_MODE_NORMAL for error handling
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220517222448.25612-1-michael.christie@oracle.com>
 <20220517222448.25612-4-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220517222448.25612-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0098.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::39) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d387430d-0134-4ef0-db94-08da38e8176a
X-MS-TrafficTypeDiagnostic: AM8PR04MB7810:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB781038100E6908B6AA76E4B1DAD19@AM8PR04MB7810.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNH2RaJnXIkww4QUsC+pMTe6tfdnLq58Y/GdKhDqw5DtmAwgP4AqgGHTHdaQxBf9CHsGgkbsVmyiiCwe58Rg/4SI5w8iP5FW6waiLibP0rLt3Q6f38c+oR6vnjJ8o4C5qiIrVMKopTYmppyqw0ihGyTMeCXTYqI4nUxQBFI82n+LTm86eMC3481ghOSwP5JGt18paaRzGYe8gGeMRdg9iuqAzsRib1tJIUiR73BKXfngbC1gdulzM4d046X1QUrlfH2Od9oP0UyYABm94oRI8YUG/2RXRf2x3mCL17e4wizrrAmJXIXqW7ID3kTuGUo2ig4rt9CA44ZIzoQJtRI6wRwufMF6EPaOKeaQR0a06NMq5tWVUyQ/hjwmIEDVsV/upv2yuBHKqF70my1fjXhGoPIIEZQgY4ebPV/IwptHPnBNZDbcOgs5WzeqNrkNnKJC5bgg3oS/jIbwgUOLhjGj47Vgh1+G6o+Yjv013v50do5LAW2f12LfBUnHZ+VLs6BSlPGhcUkU2+Pc2fXONrlKxrpxSxtlAJ08SK2HNJ1N8/G7k2XORxiJph5PxCtRvxESEpeOsUwiKmQLr0vqqavEMXC5KqhK9Bdq0WqJ4cTGD1UHnQUwUvYA3smTEsTHW9QNujt7mXEzEa7kRz5TmEXotWNguGwWgdjvCghgO5OBVkSdQwV20SjKRnCjL6j0/4ZJtwMkJqkgJ8lBP+RNgffb+p4vKp1XgPEPoBzT9F7aRn8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(36756003)(31686004)(316002)(2906002)(5660300002)(8936002)(86362001)(66946007)(66476007)(66556008)(31696002)(508600001)(2616005)(38100700002)(6506007)(6666004)(186003)(6512007)(26005)(6486002)(83380400001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk05TWlJMWxQTHhlSml5bnNuUVZZVUwxTFZxN0g3dVg3Ym0rN21IMjNTckwz?=
 =?utf-8?B?MUZscEF5a3R4VlBFZ3IrWmI1Z3hKVVZjS05lVTRhMy9PVExvWnU4NjZWVXNo?=
 =?utf-8?B?M3lvTlJ4N0R2U3hjWGNSOU9DUm13SytxdTlENHJOc0NQb2tXMXd5bm8xMlE3?=
 =?utf-8?B?QXNKNDFTUlhmUUFpcDJnaGVDeTd0ZTJMTGhaR2xkVGhETmZvekgxc0d6TzNX?=
 =?utf-8?B?MWM3N1VFc1Bwdm9SbU9qQUxaRzVmUFRsTld6dkMwMkxaeUNwK3BOeU1UdHNL?=
 =?utf-8?B?VXd2UjlWcUkxeUwvZHZ2SmFvK1JUaVRkVW5ZeVZFZnhNSFFrQ2dWYVdpZkov?=
 =?utf-8?B?T1dORERMMnRmYlpZbHBZVXhYM0ZvdWxnZ3JaTktEdE5iQk1WSFhHbGpOMmxs?=
 =?utf-8?B?Y3Q1Q0V2MzhyKzNVaVpIR0xrcWJnNkR4RHBvSUZSN1NlVWZoRHFNTGJGUXF1?=
 =?utf-8?B?NnRDcUx6bXFTeEVpbTErcDFaQkFDWnFEMjkwbHNlWHcyZGUrT2xaVkFSQnJK?=
 =?utf-8?B?K0FjZnRQK1NHVitya2F5SlBIYUV5Sm85Z0tnc25WYXp3UWV6UFUrODlaRDl4?=
 =?utf-8?B?d1VoQTFaRFgxYXkxTExleFRCUXRkWWJNMU5ScTFyajZqZ1JZdXVkSTEzRDZO?=
 =?utf-8?B?TUJHdUJ1NzNPR2FPa2NKMW5KdFc0UlRrY1JrSis4SEhUWFZnYWYrcGNwTTZm?=
 =?utf-8?B?KytZa1lGVHBzUzMrMFYydDNKcjlvbGpiOUVrWUwrYmVqcWY0V2tQcEE3a0Ez?=
 =?utf-8?B?LzRRTW5YMUpZTzBHeXJXdXViakJjK2xLS2pOZklpU3Jtb1l0aWJjNGdSWVRP?=
 =?utf-8?B?R3VUcFhjVmU5cmRia29HMVpmbXN4UlJHL3ZJaXJPc3RzbEg4bnFlSXY2MmJS?=
 =?utf-8?B?T0FrdmpuZ1RDOXh4M2RuVGVuRytMZ3piNVRLQjhaZ0JRMGgxQnFoRCtPNEJ5?=
 =?utf-8?B?cEJ5MjVIb3kxbWpBTWxMKzR5S0RVVWQ2S0NTM3FNSzhKMkpkMWszUlV2dGpW?=
 =?utf-8?B?M2h0bjgvZEpNVXNESzBIT1hwMTJNeGZqWkN6TDUxTnU1NjJ6UzhvQ2pwazJU?=
 =?utf-8?B?ZU45aFNyNkdkbHd4ckV1THZmMTRQalpuZkRJODBlbEZuR2cvc3RIaytscGM2?=
 =?utf-8?B?ODB2azF4QThjTXMwOWhrampDREl4V3ptTXVzeDFRRm96SXhZQ0Nocmk5cnB2?=
 =?utf-8?B?ZmpRelpaWWt4RzVIZnczblBodWFLQUNLOHJLWTBRYzRoYnM0bitjUDAwd0V1?=
 =?utf-8?B?QlhaK043anlqNG9RdVFuY3lrZ3ExUWk1eHNxakZMUmI5VTREYzdOMVJBL2gw?=
 =?utf-8?B?UXBmdHhkMmlKMDU0N0ZUMGZFNjQzUXRnQ2dLZWxVaW4zMXhyQlFVZGZyejNS?=
 =?utf-8?B?WVF4aTdRMlpVdjRxcks4OGd2NXJwK1ljREt5U1J5eFc2dlM3eGNuRjdJS25E?=
 =?utf-8?B?cmdzNzZYa2krWWVpeHQybWhOSXNsWXJZaVZNSVp4YlFtckgrTnJVZnJ1Q3dl?=
 =?utf-8?B?ajF2NmhFVk8wTEJNbTFQOEppTjdQR2JtbDdZMkdpNlZBTk1ScWtoZmx5VjVE?=
 =?utf-8?B?dnF3VUlRS0FSdXFyUGFRdTRqRFJXM1VXT2tZVVRhK1lGdFU5aHNmaWRZa3lq?=
 =?utf-8?B?WWF3ZlVGSXBjNytnSkk4NklsRzNYY1BTL3g0V1Zubk5PdXlJU2hjOC9SLzQ1?=
 =?utf-8?B?d0UzbmcwbG5pdy9rMzNTeXMyZUg2YzdYeFdPODJwUnEvKzcvZHFKT3NZT0Ro?=
 =?utf-8?B?NEx0dCsxc2YxSGNNUXZoTml4QjhHSEp2akNhcFRqUU1MSFpFYVRTVGs2MzZM?=
 =?utf-8?B?akpWTk9UQ3AxZFhpYlBpb3BTanNKVmZWeDRpeGhiVlA0cm5NcnJPWXlmbkJt?=
 =?utf-8?B?cStpSFg5eURrOUppa1V3eE0rZlVZTE45RzJqcGMxSnRhWEFRQTlmWCtaaCtQ?=
 =?utf-8?B?dk85aWdUMHAzYmJsYmVmWVZIdVdQMFNMUE1TL3JxYjNNUllodVVGMGxSVHpl?=
 =?utf-8?B?ZUErUTZXenBSamYxYWxtUFdoWTVmRzFGTkdxcTcrQW53WndDOS9RRU4rbXZm?=
 =?utf-8?B?TDFpUm84T2VZRC9ON3c0VVhXOUtUUGx0Z3h2T0Y2UjlGbHQzYmJpNnpWZzlU?=
 =?utf-8?B?VVQzWkc4NnNWaXVNbTY2RGZGUzBMdUdBeDhJRDU1QTZKQWcvSHNEVnRXdmMy?=
 =?utf-8?B?T1RHSkV1bFl5MWgrd2tlRFZzZnRtZGZLUkZ6blFvQnlpcHpVVTZCQTZpNFVl?=
 =?utf-8?B?MFhBSHRZeHFxYVlzNGt4Q3htUE5CWG9ZVjRvczFMQzJ5SmtHQjFXTXlHNk9M?=
 =?utf-8?B?cFFEcFpGdFhJaEJ1RTFDZFBncEVSK2pMczlNVXRkeHg0VlU0WHQ5UT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d387430d-0134-4ef0-db94-08da38e8176a
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:04:30.4824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TN/x+B9ZwyWNmaI9mjA/Zo1LsHPL5gje0AFEYQ4A07fABf4TWJOkxcHXWGeiDOUiAoJYnNccyW4Esf/y5SCrug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7810
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/22 15:24, Mike Christie wrote:
> When handling errors that lead to host removal use QEDI_MODE_NORMAL. There
> is currently no difference in behavior between NORMAL and SHUTDOWN, but in
> the next patch we will want to know when we are called from the pci_driver
> shutdown callout vs remove/err_handler so we know when userspace is up.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/qedi/qedi_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 83ffba7f51da..deebe62e2b41 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2491,7 +2491,7 @@ static void qedi_board_disable_work(struct work_struct *work)
>   	if (test_and_set_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
>   		return;
>   
> -	__qedi_remove(qedi->pdev, QEDI_MODE_SHUTDOWN);
> +	__qedi_remove(qedi->pdev, QEDI_MODE_NORMAL);
>   }
>   
>   static void qedi_shutdown(struct pci_dev *pdev)

Reviewed-by: Lee Duncan <lduncan@suse.com>

