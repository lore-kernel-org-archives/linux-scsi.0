Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C972C10F25
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FA6B206D7
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DpC9dV5Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCHCKr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 21:10:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34146 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgCHCKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 21:10:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=o9PMCdphnssUI8eZPdG9rfPatCRgqgqv7N16xqtSJao=; b=DpC9dV5Zekk0+v+Dya/vb1pMJ5
        WrZ+AQh1ZgNQqkQKLWoQ3YmdFYSm7XF+kMN/GxfPM/NhEmeEaXA3fAWtp7JMAR4Smul9oOKenSCno
        iXGqvz9p+8Pv6a1hf43HSUtK503te67HXe1BGqAJ3CPKF8gvdmE9fr0QVctsWJ4sQ5Fi1kAqJlkav
        9Nzr3nRLUUEYewnuuAhEDgnA9nrYgo5noJl1CDq8ZCEVXBJhYWyOsk7udBOx/HHg9sejV1Pe84Cdd
        SZxoosnfr6pWS4rR72qCI4ZwXdQ5w30e4OVKFmxIuC+lOOAj2J5C9UzCo9d5VYQH024pUFf7MrUi9
        DnU1HiNw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAlOt-0003BL-66; Sun, 08 Mar 2020 02:10:43 +0000
Subject: Re: [PATCH] fusion: fix if-statement empty body warning
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <ce2233a7-e470-0fc2-f908-75f52c6ec3e1@infradead.org>
Message-ID: <d9dbd9ac-4f48-eb3d-b2ff-2cceb255f9e9@infradead.org>
Date:   Sat, 7 Mar 2020 18:10:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ce2233a7-e470-0fc2-f908-75f52c6ec3e1@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 6:12 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> When driver debugging is not enabled, make the debug print macros
> be empty do-while loops.
> 
> This fixes a gcc warning when -Wextra is set:
> ../drivers/message/fusion/mptlan.c:266:39: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
> 
> I have verified that there is no object code change (with gcc 7.5.0).

Hi,

Would you (anyone) rather see something different here,
such as using pr_debug() or no_printk() instead of an
empty do-while loop?

I went with a minimal change, but I can do something else
if that is preferred.

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: MPT-FusionLinux.pdl@broadcom.com
> Cc: linux-scsi@vger.kernel.org
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> ---
>  drivers/message/fusion/mptlan.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20200225.orig/drivers/message/fusion/mptlan.h
> +++ linux-next-20200225/drivers/message/fusion/mptlan.h
> @@ -111,13 +111,13 @@ MODULE_DESCRIPTION(LANAME);
>  #ifdef MPT_LAN_IO_DEBUG
>  #define dioprintk(x)  printk x
>  #else
> -#define dioprintk(x)
> +#define dioprintk(x)  do {} while (0)
>  #endif
>  
>  #ifdef MPT_LAN_DEBUG
>  #define dlprintk(x)  printk x
>  #else
> -#define dlprintk(x)
> +#define dlprintk(x)  do {} while (0)
>  #endif
>  
>  #define NETDEV_TO_LANPRIV_PTR(d)	((struct mpt_lan_priv *)netdev_priv(d))
> 

thanks.
-- 
~Randy

