Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F6EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 19:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbhKZTqx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 14:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237689AbhKZTov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 14:44:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852CBC0619ED
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 11:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=K0wsSNXGmpOd9ia5rLBe+A0MNyQHMyaJ8riH6VtTBww=; b=oXeMeCxZ4lVl7wliI+uumTr9sg
        3AKwGnyuph26g6AsYNXxcBa2c1OUZt+6PMstT3zs2FcE/BuT2hoV7aQFLBdK6l6YL58u7AuIw4pjX
        lIBEw/UQl5DYN89gsN2CEnYB3omUqK5XUgcN/KNnqn3CgqBcA/VomE/mh96gxqPvl+t3oK+t4E31g
        ublV6Uk/GMyiQarBXsKwxXYifwXtq50UYY1hYHc5SLPgXTRjUpa2yVqZiJBcO4GmHooWQHYh4I2Tf
        Z/ZgQBr+ws55j3SFT4sPxc0otZ+jifYVRXJBbKbbuIXTuROO6DzLJSxyjYjMWoBzNvbfwClXtc497
        LEfoXgzA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqgpP-00BbSM-0d; Fri, 26 Nov 2021 19:24:11 +0000
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com,
        bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <05de8598-598f-629c-a553-a363f41014db@infradead.org>
Date:   Fri, 26 Nov 2021 11:24:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211126073310.87683-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi--

On 11/25/21 11:33 PM, Yanling Song wrote:
> diff --git a/drivers/scsi/spraid/Kconfig b/drivers/scsi/spraid/Kconfig
> new file mode 100644
> index 000000000000..169412ef2299
> --- /dev/null
> +++ b/drivers/scsi/spraid/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Ramaxel driver configuration
> +#
> +
> +config RAMAXEL_SPRAID
> +	tristate "Ramaxel spraid Adapter"
> +	depends on PCI && SCSI && BLK_DEV_BSGLIB

	depends on PCI && SCSI
	select BLK_DEV_BSGLIB

should be OK since all other users of BLK_DEV_BSGLIB select it.

> +	depends on ARM64 || X86_64
> +	help
> +	  This driver supports Ramaxel spraid driver.


-- 
~Randy
