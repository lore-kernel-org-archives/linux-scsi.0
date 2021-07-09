Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F126EC07E9E
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 21:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8A55613C2
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 21:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhGIV66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhGIV66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 17:58:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DAEC0613DD
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=7QZDNHaoWPxuLzief76/QGW00XGsPgI03Tlr5hMMSSI=; b=gvT1urp/S6PkI3OVlnOj6uITbT
        x7H86Fc37pAzYgL2Hg0G6w3WEWsppefA+YKwFlmscoBs8ccJZ7SCcqVhKwyKcWRa4zu8CV7UjWhB/
        VcInHqo3mmbEQ6tWjQaL0bixBW6HRxcupjI7dTxS3RxTG5zsfrdzd/xRn0IS0ktZEJD/Rl0KYFeK2
        HUXtDEg9LdHKs6M8M89/291amyd+USRkgLM5dYGWtLy1MqCFFIE2ex/RgHjA9X0S/lP1/StoJ2udT
        7GbZfTxWkmWTqb4z43c+iq4Z/9rA/iY5FDtevO/oBAjSeLP3OvT9gl31HNexPRCDK2sGyk5qF7+aa
        20o/3MgQ==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1yTa-002XX3-0k; Fri, 09 Jul 2021 21:56:02 +0000
Subject: Re: [PATCH v2 19/19] scsi: ufs: Add fault injection support
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-21-bvanassche@acm.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <251e9d94-f7ff-3be8-24ae-6b7572c11945@infradead.org>
Date:   Fri, 9 Jul 2021 14:56:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709202638.9480-21-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 7/9/21 1:26 PM, Bart Van Assche wrote:
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 2d137953e7b4..4272d7365595 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -183,3 +183,10 @@ config SCSI_UFS_CRYPTO
>  	  Enabling this makes it possible for the kernel to use the crypto
>  	  capabilities of the UFS device (if present) to perform crypto
>  	  operations on data being transferred to/from the device.
> +
> +config SCSI_UFS_FAULT_INJECTION
> +       bool "UFS Fault Injection Support"
> +       depends on SCSI_UFSHCD && FAULT_INJECTION
> +       help
> +         Enable fault injection support in the UFS driver. This makes it easier

Nit: use one tab + 2 spaces above for indentation.

> +	 to test the UFS error handler and abort handler.

thanks.
