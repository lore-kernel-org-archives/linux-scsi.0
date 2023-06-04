Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F699C7EE29
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jun 2023 01:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjFDBpV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 3 Jun 2023 21:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFDBpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2023 21:45:20 -0400
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA51A8;
        Sat,  3 Jun 2023 18:45:19 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 06D29E17EA;
        Sun,  4 Jun 2023 01:45:18 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id E1DEB37272;
        Sun,  4 Jun 2023 01:45:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id navQ8nBG76f1; Sun,  4 Jun 2023 01:45:17 +0000 (UTC)
Received: from [192.168.48.17] (host-192.252-165-26.dyn.295.ca [192.252.165.26])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 1531A3726F;
        Sun,  4 Jun 2023 01:45:15 +0000 (UTC)
Message-ID: <b99938ff-d08f-63c2-b146-8c4e6488038b@interlog.com>
Date:   Sat, 3 Jun 2023 21:45:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 2/3] scsi: sg: increase number of devices
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230602163845.32108-1-mwilck@suse.com>
 <20230602163845.32108-3-mwilck@suse.com>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230602163845.32108-3-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-06-02 12:38, mwilck@suse.com wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Larger setups may need to allocate more than 32k sg devices, so
> increase the number of devices to the full range of minor device
> numbers.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 037f8c98a6d3..6c04cf941dac 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -71,7 +71,7 @@ static int sg_proc_init(void);
>   
>   #define SG_ALLOW_DIO_DEF 0
>   
> -#define SG_MAX_DEVS 32768
> +#define SG_MAX_DEVS (1 << MINORBITS)
>   
>   /* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
>    * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater

