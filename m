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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AE1C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A96E61953
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 03:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhCaDaG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 23:30:06 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:45745 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233520AbhCaD3z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 23:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617161394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M9EEnYffs6Axw0IBqPrYkmEufnwqzA1jjbmmMFE3rOs=;
        b=nr/ziV8qZfK0F1QM7esPq5Xp3jX9WiufcL18Xb/5RFZ8+wpjp1TpI5DzQNlsaVI28mXpKY
        HP4QNiyAUPb8E02Z5wq0PFNchERatlfgL11zJpyiw3j5t4niL6hckI1D6qoj9E4lTLB3Sv
        yrUlfN/CSTNm0wmMbMrYb1nrfwUxUJo=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2055.outbound.protection.outlook.com [104.47.8.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-1i_T-ToONtqAVS0q1eYHQQ-1; Wed, 31 Mar 2021 05:29:53 +0200
X-MC-Unique: 1i_T-ToONtqAVS0q1eYHQQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfaQY9/azSWSJyx9/HO9uHfIJKnXest6hjJ+7oY+9/QYjb+4ngU05YaRNKOKRHUDs3ObBzcouH7v34ObVngHAGUyY0z9hhJNejzjAqV+nsCpA6MwTm8qUcRlpYyX1hlzyZVa0K2YzP5NC+JgooIUyjtzw4B2XTCEH8HRtF6CuBeib2krhDhzzY/LRo7Rm+/vTc6laGvW3jDzzG3cW38w46UF1OseKvtMb8MtofutjKKOD6GvTfmoto/k7jRNjL8QntXYWTXcV5t24i3WqeqEoYXh0LN6Lvy63hCHz9GmmH5NCbB6B3rb0fm5JGWqmjkLQERdpBMHxEybmiU4h/TEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9EEnYffs6Axw0IBqPrYkmEufnwqzA1jjbmmMFE3rOs=;
 b=jbekbwjseHiiisNYcyQ3HEZz2RKYmExoGJliPYeNFpmcwwAQ/piZOcWonWRnJEuHV3TnxcGHVvvn9bkLfiCTRNpwL/R3YhoJiEj075AR+0DumvDfgA7YcoyTd0/OaN/h8jhckfJHecbZ6y1qosy8J23PoGsAZpNy8TK4b3jH1SET8aapdnYLf8Bc/g/+nzsv+LjwqCd0QGwsK9lJ1yZegAxXmftmie8K4Fg3t98fLazZyJ6P8h+OxeepnjuNf0MUa7SyixsVfHjROXjFWuOM5hmYtGUG0fX+j+ZYsj60/ldkljszxVlrYtp0GWdN0Fpd8UL71gvD/Vy2vBjrWn/3SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR04MB3030.eurprd04.prod.outlook.com (2603:10a6:6:b::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Wed, 31 Mar 2021 03:29:51 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 03:29:51 +0000
Subject: Re: [PATCH 01/15] md: remove the code to flush an old instance in
 md_open
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210330161727.2297292-1-hch@lst.de>
 <20210330161727.2297292-2-hch@lst.de>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <e74ca0f0-e9d5-1713-d714-4ac71a2f8ece@suse.com>
Date:   Wed, 31 Mar 2021 11:29:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210330161727.2297292-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.128.150]
X-ClientProxiedBy: HK2PR0302CA0006.apcprd03.prod.outlook.com
 (2603:1096:202::16) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.128.150) by HK2PR0302CA0006.apcprd03.prod.outlook.com (2603:1096:202::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Wed, 31 Mar 2021 03:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7152914-a28c-41e1-2a87-08d8f3f53e07
X-MS-TrafficTypeDiagnostic: DB6PR04MB3030:
X-Microsoft-Antispam-PRVS: <DB6PR04MB303007AEE0AC4A60D5534C5F977C9@DB6PR04MB3030.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/h7dUeeYBOW+hPRQM5d5yT7RjhsueUqi2m7LyjMBmZhTSI5QuyQbHfnzcJ//HZ7Az227rnJP+HHmO7osxMXvrUG3s+S0REOX7qP43NrkrkTpLFlnqwlyZMs46ZEoiw4xxPhL3v6Vbn8YZx7kWLngD93wAGgOzg2MemyYWA9qFVyqWzbKA8KZdTnK+HSMaz/tlio51S1libAPxUOa5L+yKv2UXKAFKIhwG0OhoqyR8bhNQe+Ua6itI2qRk17GFoUzWFIAo+Muv+Yd7oZtmsu85tUQXa03vzodVHmQq6yOX8LvakdlACDSXXKefa6QrQgXQ3nvgWWaF+hctQSa4EXhG/uSl73aoNg9aj0dytSD0sW3TimbAp5UkkEBxuSzw/u23Pj6DoTdth7Voug4BiYw2o1jhg0mtawKccRtD0tfOhD5IBfsxoPv0NcoYh0n5RLzyrIzIDOiBo8JJh0Sq+FTSy1YlIMp3eSOmdX7RCCKgkPcEMhovgdRCf0O6DwG3cOZU+Q2c783dG/BO8rcnp++14UsyouM6+fied4Z9XzsqvpBaGebiOKBLw5MsrItR4TNCV0Ie9sRqMfkg2LDG2nH1lUZ6wcrj83GMU797jVQXWbjEmmFeDCwk43od0PnspqTk8yYUgMv6YCCGlCuidcsjutevcopuGXPlvkJG/Pnpb/5v/E1/2i5VjnFUw8E6YxkqS5sxjvCf6/TClPLLGbSdmfZejYbCjwuBvQTqw9KTI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(6486002)(38100700001)(52116002)(53546011)(5660300002)(6506007)(6666004)(31686004)(8886007)(110136005)(66946007)(16526019)(54906003)(66476007)(66556008)(4326008)(36756003)(316002)(186003)(26005)(83380400001)(956004)(8676002)(2616005)(4001150100001)(86362001)(478600001)(31696002)(6512007)(2906002)(8936002)(7416002)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZXhRUmhINFdDcEdoSDdiY2ZaQXI3YTdHS3V4cVdPYS8rei8rL2FPMWttRCtN?=
 =?utf-8?B?YXYyQnAxTitIZlhmUjh5YXJnUTZTQ1YrdGkrSE8wcDViTldvclNoTDlRMmVm?=
 =?utf-8?B?TElDMWp0RGloWHhWT1F0cytRcmVvYThWdGtGT3NDWTB6ZUtSWm43SHVCZG1E?=
 =?utf-8?B?bWpNRWVJOHVsQldtK3MvWlBER0wxaStNSGhPUmpid3lRdjNUcDdNSzMvd01Q?=
 =?utf-8?B?NVdpWGliZ3U0YW41V3JPZkhoV3lHQW5kb1h1ZktPZHN1Z3ZUc01kME41Y0pF?=
 =?utf-8?B?SkZUNGtLSlBEM21KTW05bkdYVzJWQysvQmNCRE9JVkhGR04remloUGtnYlNH?=
 =?utf-8?B?S1l4MWZNWXdwcUJNN3hGZlFnM2wzODRzeVYvWC92UTNRb2U4MFpnWGJJNWw4?=
 =?utf-8?B?VVdZZkJzZG53ZTlsTG5aZWZTRFpyT3FHOUJmcTgzdDVSb0FCaWZEczA5SDRB?=
 =?utf-8?B?ekxQWFE3OE9sQ3pHZ010aEo1bm4vUEt2UU9QUEJUa0J1MU5RU2JCMEVMUVdH?=
 =?utf-8?B?ck5kTmI5ZzdYbFRGRUIrSVo3ZFVZdnJ5dkY5M2RjS013TWliYWJBaFNCNU0y?=
 =?utf-8?B?c3ExaVR6NnpMTDVPMDE3US9sTHJLcmt0RHBEMTVhUWhuMGpPQnBBMWJjb0x6?=
 =?utf-8?B?cUpuTWdGOUMwTnpMUE1BdU9iK2c2dnRQWEJyT0E2aWU4a0ExWEZZQjdhOUxE?=
 =?utf-8?B?d1pPRFYwcXNvUDVCbitVT1NOSC9jSDlHQU1mdGpteDg0dEpORVY5QytQRXQy?=
 =?utf-8?B?Q0tuaWFiWUhuRDU4RHpDYWRudng0WkdXc29aQ1BFZWpMOVdqdStBcDRiT3ps?=
 =?utf-8?B?OFFwdzcybmptNTJBL0Fkem5nWVZ5NlBnUVpZclFFWWxWT0RmbTh5eC9lY0hu?=
 =?utf-8?B?YThDU1UwK0tIcUlKQXhYaW9BKzUzSG9aY2kyMWlpR3ZxUFBkZ0tKeUg2ZnVo?=
 =?utf-8?B?V0pWSEI1Z2pTWldmVlZCMVVTSTVCbkVDUUZUazBIYm5PWitYNm9PUjU1Ynll?=
 =?utf-8?B?UHAvaVB6bGpkcE93dlJvOGRYN0piYUp0UjJkOEtwMGtUK2VIRzlhSjNVNHNO?=
 =?utf-8?B?blJpZGozMTV3NjVzejJhTS9EZE81ZE5Od25GV1VJeFNldmN4RE4rSFRJZEhi?=
 =?utf-8?B?cXFTZlFEZzUrUWFVU2VzZU9HVEw2amxUSzFoUk5EbVZxVVZnYVprcXdWem1I?=
 =?utf-8?B?L2dDdkJ0WVIvV2R2SGVYTDRCbHJDU1Q3dzlHV2JGc3M1c0NSZWhybkNUWlBQ?=
 =?utf-8?B?WHFFMDNockhwWlBaaFlRdGNqc05wMDIzZE0wOTluaUc2MzNNaE5tZUZHTXFU?=
 =?utf-8?B?NDgvTnZsRXJnNDV2TSt2bmQzQ211UE9qWFJGdG1wNnpuanM4Y3JXeTBzMXBi?=
 =?utf-8?B?QUNGVkp3QUZhd1dhRis1SFVyeWpPbFhsbEVVcVFEUWJTc3NVSDU1MXpqK2xN?=
 =?utf-8?B?MWR3WWZ2RDBocENWTXFGQmxmZ3hDQjNueTJLb1grSXZTTTVjUml0M1AyQUk4?=
 =?utf-8?B?aGczdHdXNG9jYWdac2c4c1JHbVZPTXlZWU1QdzN2ZFVsSjZCdVdSQkR4VUh5?=
 =?utf-8?B?K2wwRWlVQ0pQeG9va0pxeVhZS1JuRkROZ2NTVUF5K0RTbVpyNmwvT094bk41?=
 =?utf-8?B?RUJWemNhUklHSzVCRFRjVkREdHNwUU5QWnQ0aDNiVllYR0hSV3FqVG16OGhH?=
 =?utf-8?B?OFh4N21XejlzWjgrUHVmUTdzVUdVUDNtZmtxUFJYeVF0VGlLSit5UTBwaEJv?=
 =?utf-8?Q?TwVWQ06jcQpgderUbY9SZBeL/HTOUh06VGpxOn5?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7152914-a28c-41e1-2a87-08d8f3f53e07
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 03:29:50.9257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBc86zoqDEilMigHIVhrkMihf6HGTYGHk0hfnwDPeA2Rn7vS9Mh0f11vgIU79lyL2HkuVtgIcd6d/QNMqpXI/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/21 12:17 AM, Christoph Hellwig wrote:
> Due to the flush_workqueue() call in md_alloc no previous instance of
> mddev can still be around at this point.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 35 +++++++----------------------------
>   1 file changed, 7 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 368cad6cd53a6e..cd2d825dd4f881 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7807,43 +7807,22 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>   	 * Succeed if we can lock the mddev, which confirms that
>   	 * it isn't being stopped right now.
>   	 */
> -	struct mddev *mddev = mddev_find(bdev->bd_dev);
> +	struct mddev *mddev = bdev->bd_disk->private_data;
>   	int err;
>   
> -	if (!mddev)
> -		return -ENODEV;
> -
> -	if (mddev->gendisk != bdev->bd_disk) {
> -		/* we are racing with mddev_put which is discarding this
> -		 * bd_disk.
> -		 */
> -		mddev_put(mddev);
> -		/* Wait until bdev->bd_disk is definitely gone */
> -		if (work_pending(&mddev->del_work))
> -			flush_workqueue(md_misc_wq);
> -		/* Then retry the open from the top */
> -		return -ERESTARTSYS;
> -	}
> -	BUG_ON(mddev != bdev->bd_disk->private_data);
> -
> -	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
> -		goto out;
> -
> +	err = mutex_lock_interruptible(&mddev->open_mutex);
> +	if (err)
> +		return err;
>   	if (test_bit(MD_CLOSING, &mddev->flags)) {
>   		mutex_unlock(&mddev->open_mutex);
> -		err = -ENODEV;
> -		goto out;
> +		return -ENODEV;
>   	}
> -
> -	err = 0;
> +	mddev_get(mddev);
>   	atomic_inc(&mddev->openers);
>   	mutex_unlock(&mddev->open_mutex);
>   
>   	bdev_check_media_change(bdev);
> - out:
> -	if (err)
> -		mddev_put(mddev);
> -	return err;
> +	return 0;
>   }
>   
>   static void md_release(struct gendisk *disk, fmode_t mode)
> 

Hello Christoph,

After applying your patch, the md_open() will be:
```
static int md_open(struct block_device *bdev, fmode_t mode)
{
     /* ...  */
     struct mddev *mddev = bdev->bd_disk->private_data;
     int err;

     err = mutex_lock_interruptible(&mddev->open_mutex);
     if (err)
         return err;

     if (test_bit(MD_CLOSING, &mddev->flags)) {
         mutex_unlock(&mddev->open_mutex);
         return -ENODEV;
     }

     mddev_get(mddev);
     atomic_inc(&mddev->openers);
     mutex_unlock(&mddev->open_mutex);

     bdev_check_media_change(bdev);
     return 0;
}
```

in clean path, MD_CLOSING only lives a very short time, then be cleaned in md_clean:
```
ioctl
  + test_and_set_bit(MD_CLOSING, &mddev->flags)
  + do_md_stop //case STOP_ARRAY
     md_clean
      mddev->flags = 0;
```

when userspace "mdadm -Ss" finish (the ioctl STOP_ARRAY returns),
mddev->flags will be zero. and you can see my patch email (date: 2021-3-30).
At this time, userspace will execute "mdadm --monitor" to scan the
closing md device. the md_open will trigger very soon. at this time,
bdev->bd_disk->private_data is only a skeleton, your shouldn't trust & use it.

So mddev with MD_CLOSING protection, the md_open is not safety.

PS:
Neil Brown legacy commit d3374825ce57ba2214d37502397 also describes this condition.

Thanks,
heming

