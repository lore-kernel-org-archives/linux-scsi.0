Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F408C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Nov 2022 22:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiKBWsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKBWsD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2022 18:48:03 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89646646E
        for <linux-scsi@vger.kernel.org>; Wed,  2 Nov 2022 15:48:02 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id E00A971391;
        Wed,  2 Nov 2022 22:48:00 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id CDC4160214;
        Wed,  2 Nov 2022 22:48:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id sfZFwdK7_NEK; Wed,  2 Nov 2022 22:48:00 +0000 (UTC)
Received: from [192.168.48.17] (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 1164660211;
        Wed,  2 Nov 2022 22:48:00 +0000 (UTC)
Message-ID: <4a857868-0bee-5ce2-2969-af33d3ceeb19@interlog.com>
Date:   Wed, 2 Nov 2022 18:47:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3] scsi: scsi_debug: Make the READ CAPACITY response
 compliant with ZBC
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20221102193248.3177608-1-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20221102193248.3177608-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-11-02 15:32, Bart Van Assche wrote:
>>From ZBC-1:
> * RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
>    highest LBA of a contiguous range of zones that are not sequential write
>    required zones starting with the first zone.
> * RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
>    of the last logical block on the logical unit.
> 
> The current scsi_debug READ CAPACITY response does not comply with the above
> if there are one or more sequential write required zones. SCSI initiators
> need a way to retrieve the largest valid LBA from SCSI devices. Reporting
> the largest valid LBA if there are one or more sequential zones requires to
> set the RC BASIS field in the READ CAPACITY response to one. Hence this
> patch.
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
> Changes between v2 and v3: elaborated the comment added by this patch.
> 
> Changes between v1 and v2: simplified this patch as suggested by Damien.
> 
>   drivers/scsi/scsi_debug.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 697fc57bc711..629853662b82 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1899,6 +1899,13 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>   			arr[14] |= 0x40;
>   	}
>   
> +	/*
> +	 * Since the scsi_debug READ CAPACITY implementation always reports the
> +	 * total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
> +	 */
> +	if (devip->zmodel == BLK_ZONED_HM)
> +		arr[12] |= 1 << 4;
> +
>   	arr[15] = sdebug_lowest_aligned & 0xff;
>   
>   	if (have_dif_prot) {

