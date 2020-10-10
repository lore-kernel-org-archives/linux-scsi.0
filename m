Return-Path: <SRS0=yR1C=DR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D01BC43467
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Oct 2020 22:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14CD02080C
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Oct 2020 22:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NgfHLXdH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbgJJWvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:51:42 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:32292 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730283AbgJJSzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 10 Oct 2020 14:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1602356100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=F3rqvSo2pR+XXLTboJ/bGepwCouJVTq7fsEnnAyoqbw=;
        b=NgfHLXdHhlgt53vWEkK3VVCmrlBx7/CWmVnDbuFF4UqwcbllKlznr2jdhggtnYrmnSbIc5
        HlXfzyzupb0wd26Ee8pTpr8tWpc91Y42kzSDjVgjYrAgpkp4ueVoL8y2vRs1FxtPAfI8bc
        8NfjM4ZPx3g7F9SprcfoLlVxCnhMbDQ=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2111.outbound.protection.outlook.com [104.47.18.111])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-EAkUOhnLPeWvWZdr3ncGMA-1; Sat, 10 Oct 2020 19:31:39 +0200
X-MC-Unique: EAkUOhnLPeWvWZdr3ncGMA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qq2BISR9fikO1KRKS0I70xvwHIqa5oYDpK/HFdF5qnMbKoRJzcDotRgULoM4+o52lqfJitTujRH+fwrpTybq3Qyz/BscxtydHWu1m1B/IeDBg4fGF5dmgEf3zVfBtUxtZhMA1eGg7EBT5cfk9vZr6JTBZ/Jm/EXYY2jVSkKcdveGrxsu5pgNWO9zwZ5g0YTRrnaiQOE2DIMHUfNmQRH4YFIDD8i9UWUN3Ls1vZMRbNVET2I9TDtgHKDvfn59D9dn+ve7UTTxYDh66DLFsZZ+0hq1gVEYK0BESpnxRle58GPNn/eD4CObwkr48ByFHYaduq4J/XKap3bOl93TKDTKRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3rqvSo2pR+XXLTboJ/bGepwCouJVTq7fsEnnAyoqbw=;
 b=Ia3HNmH5rMEgNpNtBB7+ywixOKqVjTFzVGUf+ROezNQC9+O5yURV4j9rPfsmOKZoy1PvxcdLXzxSo7PeqhhFsf32yk9Gh3FgfelXlEHWdnu70uH9Nu2pTKdoaGIyMWPNO4f12wQ046rda+aJuQ/VPEI3LIs/yeNOMcfMYRipiu082ExajYKYHbTrBgTvzkXxC8teLwC28fCf7EvHeY3bq7jZ4Z83tY58Yx+5Fk5s1lEPNTOuZ12GqWkmP0+UuE71ORiTEga45uu+5qTd5JBJbvAL6+Kg4/ub4TnpK9q4aePme3Qke/N7ANm+OJFemkMqX1ljzHOz1jZMhxltg2x5cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7925.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.28; Sat, 10 Oct
 2020 17:31:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::993e:654f:399e:8230]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::993e:654f:399e:8230%6]) with mapi id 15.20.3455.028; Sat, 10 Oct 2020
 17:31:38 +0000
Subject: Re: [PATCH] scsi: core: don't start concurrent async scan on same
 host
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
References: <20201010032539.426615-1-ming.lei@redhat.com>
From:   Lee Duncan <lduncan@suse.com>
Autocrypt: addr=lduncan@suse.com; keydata=
 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
 Xd8p+B+giaT8a1b5hWuz85V0
Message-ID: <4f3e4d42-4d53-fc00-25bc-0ead15e86900@suse.com>
Date:   Sat, 10 Oct 2020 10:31:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <20201010032539.426615-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::20) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:208:d2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Sat, 10 Oct 2020 17:31:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 260eb965-4628-4c33-a5fc-08d86d425796
X-MS-TrafficTypeDiagnostic: AS8PR04MB7925:
X-Microsoft-Antispam-PRVS: <AS8PR04MB792514634F69F3B008AB4086DA090@AS8PR04MB7925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pQGqRASP/1MHsZUizlhh5rba14LeiDYXGYqilXicGgjhV6ILlojm9KnpMhltPXPn4/7dRU5kDUaWXbW9mx97597cAAJ1w2Cw2gAvWZahbwVXK0fTOO4SuUg8qGqXXXi83g8zXTrhAMkQhZgY9kU/ncROz8XPa8NR/gJqppKZdoYUIo53QfGBq6RjZI8vnkiwtJCMSIC0SdR89Vrw/Jes4nLdYqnejqbIoStwo+uH4VgKFqA/WlVD9l5gUctwz0z/YezjngweGN1JVjHtp99ilSfYfRpuiwa7fs7GHWUUsGG0NjrLmsEOcpvRbHz4CLburydPO3RYRVotRA61/VprO2T316jGOjR9K39Wa33dor39lgAIOF36cWQNVlCjMpHV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(2616005)(2906002)(956004)(36756003)(4326008)(6666004)(478600001)(83380400001)(31686004)(86362001)(8676002)(53546011)(16576012)(52116002)(31696002)(6486002)(110136005)(8936002)(316002)(66556008)(66476007)(66946007)(5660300002)(16526019)(186003)(54906003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: plIVwjFdpwtzZ1Pb2YA5Mwqbvy9j6WPY+cre+ITqfVrckOVwE4s++UaTzeseyFi31en6El32JX0V3DS3fB4gfUAd/jVHRnYdwQ4JdvecdPzpQMad9+PxXTgeCHp0E7ZWB0hn6+Qw6nNKYGX9ZZeKHX0Q+jbobPzQ3IBw8G86GrdkJcrED5Ebouf8e7Y2vpKwI4dzqO2fPhyBuP3MdlRSYjbROD+hwXv12U4GiwJQnYkmuHi4jXR+UVeEi+0fYcTXygkwRfWJYlVcrcqTzRx7nUST5ArKH7jEGq+Zav68co9S1g+hb4zTAhs+mnxaMciyUbD1SUSo0HtY7Rs6rb7SrBBQ7K8XgNIngqbh4hxOyPW4M2fqbeNMvYPnrg7Y2BfeXpkXN9/W1BHr7LkIyrBGgTdjPp9FNGP2UZY8SR3oVKUJinqaW+qpPCnF9ekznbIJwI1D+cC7x0ZCdXujuIcSsB7Ac5vMR/x/+EeByrrgN+3vBzgZYzB9zhuPbu2v2TCHXNhQ3uuiHKJVKesorQBakUHD8hlY5f3jn2IrJmzhbAha3s2p/DkHEFue/aX0MmnCaB0ACjDBy59dTA7UbKAVFXBUm++xVdi0GpNIaQ38xE7zoec1r1wL49mtKOxtlQqRYzocmY6ghot8bmLBcpJtxg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 260eb965-4628-4c33-a5fc-08d86d425796
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2020 17:31:38.0653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0osGL/ewX3qUGNyHnRHnfDEQlAatTOXNuAe00eQOv4zmKy7NNo3PypBAI2ZXn+gw9EtU5ez16pJxWyBiSHxKfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7925
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/9/20 8:25 PM, Ming Lei wrote:
> Current scsi host scan mechanism supposes to fallback into sync host
> scan if async scan is in-progress. However, this rule isn't strictly
> respected, because scsi_prep_async_scan() doesn't hold scan_mutex when
> checking shost->async_scan. When scsi_scan_host() is called
> concurrently, two async scan on same host may be started, and hang in
> do_scan_async() is observed.
> 
> Fixes this issue by checking & setting shost->async_scan atomically
> with shost->scan_mutex.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f2437a7570ce..9af50e6f94c4 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1714,15 +1714,16 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>   */
>  static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  {
> -	struct async_scan_data *data;
> +	struct async_scan_data *data = NULL;
>  	unsigned long flags;
>  
>  	if (strncmp(scsi_scan_type, "sync", 4) == 0)
>  		return NULL;
>  
> +	mutex_lock(&shost->scan_mutex);
>  	if (shost->async_scan) {
>  		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
> -		return NULL;
> +		goto err;
>  	}
>  
>  	data = kmalloc(sizeof(*data), GFP_KERNEL);
> @@ -1733,7 +1734,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  		goto err;
>  	init_completion(&data->prev_finished);
>  
> -	mutex_lock(&shost->scan_mutex);
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	shost->async_scan = 1;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> @@ -1748,6 +1748,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
>  	return data;
>  
>   err:
> +	mutex_unlock(&shost->scan_mutex);
>  	kfree(data);
>  	return NULL;
>  }
> 
Reviewed-by: Lee Duncan <lduncan@suse.com>

