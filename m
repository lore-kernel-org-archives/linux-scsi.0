Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4922C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E8A6121E
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 15:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbhETPKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 11:10:01 -0400
Received: from elvis.franken.de ([193.175.24.41]:41351 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243370AbhETPJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 May 2021 11:09:59 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1ljkHS-0001VG-00; Thu, 20 May 2021 17:08:10 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id DA723C101D; Thu, 20 May 2021 17:06:41 +0200 (CEST)
Date:   Thu, 20 May 2021 17:06:41 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: sni_53c710: Fix a resource leak in an error
 handling path
Message-ID: <20210520150641.GA22843@alpha.franken.de>
References: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a97774020847f6b63e161197254d15ef1d786ea.1621485792.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 20, 2021 at 06:44:25AM +0200, Christophe JAILLET wrote:
> After a successful 'NCR_700_detect()' call, 'NCR_700_release()' must be
> called to release some DMA related resources, as already done in the
> remove function.
> 
> Fixes: c27d85f3f3c5 ("[SCSI] SNI RM 53c710 driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/sni_53c710.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
> index 678651b9b4dd..f6d60d542207 100644
> --- a/drivers/scsi/sni_53c710.c
> +++ b/drivers/scsi/sni_53c710.c
> @@ -98,6 +98,7 @@ static int snirm710_probe(struct platform_device *dev)
>  
>   out_put_host:
>  	scsi_host_put(host);
> +	NCR_700_release(host);

shouldn't this done before the scsi_host_put() to avoid a use after free ?
lasi700.c has the same problem. And it looks like NCR_700_detect() will leak
dma memory, if scsi_host_alloc() failed.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
