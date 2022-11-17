Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0A3C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 16:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiKQQn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 11:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiKQQn6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 11:43:58 -0500
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6D923160
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 08:43:56 -0800 (PST)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id E0CCE71495;
        Thu, 17 Nov 2022 16:43:55 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id D6DFA1211D8;
        Thu, 17 Nov 2022 16:43:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id l1DbPgrk2oMV; Thu, 17 Nov 2022 16:43:54 +0000 (UTC)
Received: from [192.168.48.17] (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 468B51211D5;
        Thu, 17 Nov 2022 16:43:54 +0000 (UTC)
Message-ID: <c39d8a14-9e9d-9a7a-1736-5fea9351f782@interlog.com>
Date:   Thu, 17 Nov 2022 11:43:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: scsi_debug: Fix possible UAF in
 sdebug_add_host_helper()
To:     Yuan Can <yuancan@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20221117084421.58918-1-yuancan@huawei.com>
Content-Language: en-CA
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20221117084421.58918-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-11-17 03:44, Yuan Can wrote:
> If device_register() fails in sdebug_add_host_helper(), it will goto clean
> and sdbg_host will be freed, but sdbg_host->host_list will not be removed
> from sdebug_host_list, then list traversal may cause UAF, fix it.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/scsi_debug.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 629853662b82..bebda917b138 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -7323,8 +7323,12 @@ static int sdebug_add_host_helper(int per_host_idx)
>   	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
>   
>   	error = device_register(&sdbg_host->dev);
> -	if (error)
> +	if (error) {
> +		spin_lock(&sdebug_host_list_lock);
> +		list_del(&sdbg_host->host_list);
> +		spin_unlock(&sdebug_host_list_lock);
>   		goto clean;
> +	}
>   
>   	++sdebug_num_hosts;
>   	return 0;

