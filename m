Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD4BE95A8E
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 06:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345211AbjJIGRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 02:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345217AbjJIGRp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 02:17:45 -0400
Received: from bee.tesarici.cz (bee.tesarici.cz [77.93.223.253])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EFCCF;
        Sun,  8 Oct 2023 23:17:41 -0700 (PDT)
Received: from meshulam.tesarici.cz (dynamic-2a00-1028-83b8-1e7a-4427-cc85-6706-c595.ipv6.o2.cz [IPv6:2a00:1028:83b8:1e7a:4427:cc85:6706:c595])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by bee.tesarici.cz (Postfix) with ESMTPSA id B18BF194F40;
        Mon,  9 Oct 2023 08:17:38 +0200 (CEST)
Authentication-Results: mail.tesarici.cz; dmarc=fail (p=none dis=none) header.from=tesarici.cz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1696832258; bh=cSotfQwbGSibXtsizQ/xjKnpycVo566GkyDdz3BdcMg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=43CGV8jcblIvmjT5SYlDA948jVfgK2O5uSw35YsJ29jrMMOINc/BysNJq5ibBi67Y
         6Wm4B+OaQ1a2s7cGcGHav/VlaSUmjLq9ZTlodjB0IT/D9TBBiz/zPtxfiBe+Lqfk6a
         EQ4yXX1w0gGs7aY/sKymc+RK17c8Sq3J46lZDmBhgW/8t8lHlwmJHDTJef8tq2ce5s
         r/vcHxd6mPp7kPOSt3HXpy/CCLt5D5uaP9HkPsGN0WeG5p/nrzjRNQNGIZOnI+7OKr
         Dm7h1CNn8h7QF0gB92OqtLYvsXS6D31aeM3T5+BCwP8u56qbt8qsedayoReDZHV47j
         sqHMjUU8cgoAQ==
Date:   Mon, 9 Oct 2023 08:17:36 +0200
From:   Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] scsi: Do not rescan devices with a suspended queue
Message-ID: <20231009081736.28ddb5fe@meshulam.tesarici.cz>
In-Reply-To: <20231004085803.130722-1-dlemoal@kernel.org>
References: <20231004085803.130722-1-dlemoal@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, (adding James)

On Wed,  4 Oct 2023 17:58:03 +0900
Damien Le Moal <dlemoal@kernel.org> wrote:

> Commit ff48b37802e5 ("scsi: Do not attempt to rescan suspended devices")
> modified scsi_rescan_device() to avoid attempting rescanning a suspended
> device. However, the modification added a check to verify that a SCSI
> device is in the running state without checking if the device request
> queue (in the case of block device) is also running, thus allowing the
> exectuion of internal requests. Without checking the device request
> queue, commit ff48b37802e5 fix is incomplete and deadlocks on resume can
> still happen. Use blk_queue_pm_only() to check if the device request
> queue allows executing commands in addition to checking the SCSI device
> state.

FTR this fix is still needed for rc5. Is there any chance it goes into
fixes before v6.6 is final?

Petr T

> Reported-by: Petr Tesarik <petr@tesarici.cz>
> Fixes: ff48b37802e5 ("scsi: Do not attempt to rescan suspended
> devices") Cc: stable@vger.kernel.org
> Tested-by: Petr Tesarik <petr@tesarici.cz>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/scsi/scsi_scan.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3db4d31a03a1..b05a55f498a2 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1627,12 +1627,13 @@ int scsi_rescan_device(struct scsi_device
> *sdev) device_lock(dev);
>  
>  	/*
> -	 * Bail out if the device is not running. Otherwise, the
> rescan may
> -	 * block waiting for commands to be executed, with us
> holding the
> -	 * device lock. This can result in a potential deadlock in
> the power
> -	 * management core code when system resume is on-going.
> +	 * Bail out if the device or its queue are not running.
> Otherwise,
> +	 * the rescan may block waiting for commands to be executed,
> with us
> +	 * holding the device lock. This can result in a potential
> deadlock
> +	 * in the power management core code when system resume is
> on-going. */
> -	if (sdev->sdev_state != SDEV_RUNNING) {
> +	if (sdev->sdev_state != SDEV_RUNNING ||
> +	    blk_queue_pm_only(sdev->request_queue)) {
>  		ret = -EWOULDBLOCK;
>  		goto unlock;
>  	}

