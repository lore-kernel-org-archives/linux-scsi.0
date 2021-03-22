Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA39C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9972B6198C
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 16:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhCVQIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhCVQHr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 12:07:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3180C061574;
        Mon, 22 Mar 2021 09:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WnvXnJzljojS8tgnkv0qyX+4X9mX4IsbTi96GynIueY=; b=ArtuoRXw+MQxkBTgpMWQHo9aLO
        Bqy+gGcBB7EpHPjwSB+HJ5qYLkF0Tf48XE/eZ+hhB0+9yxlcDDMa+c8iaS/fTcHZGnbyUNhP2uPTz
        tXgNMwbNbKXU3diYnR/Vs1gdk3gtjXD4y7lCdx3jI7fVyXLBP6HMsa/SoxBj9XLPLZp5zkujykaP2
        yACZiMrg2uRbPVcwlbmObfZDRLgrLtKNCp6PjH7Sbz1z93aHQCZaGzeuV3pPiscWylmYqA8MOvuCb
        MjD8e4JWQAVY5b5glxuQ9Cma/iWupffbeA6Ib70uuoaOxOdAy/Bltik7aQuk/kAJmCrE+SSBVn9ih
        gA9NWfsA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lON4Z-008krr-Bd; Mon, 22 Mar 2021 16:06:48 +0000
Date:   Mon, 22 Mar 2021 16:06:31 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: pscsi: avoid Wempty-body warning
Message-ID: <20210322160631.GQ1719932@casper.infradead.org>
References: <20210322114441.3479365-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322114441.3479365-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 22, 2021 at 12:44:34PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building with 'make W=1' shows a harmless warning for pscsi:
> 
> drivers/target/target_core_pscsi.c: In function 'pscsi_complete_cmd':
> drivers/target/target_core_pscsi.c:624:33: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>   624 |                                 ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
>       |                                 ^
> 
> Rework the coding style as suggested by gcc to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/target/target_core_pscsi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 3cbc074992bc..913b092955f6 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -620,8 +620,9 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
>  			unsigned char *buf;
>  
>  			buf = transport_kmap_data_sg(cmd);
> -			if (!buf)
> -				; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
> +			if (!buf) {
> +				/* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */
> +			}

But why not just delete the code?

			buf = transport_kmap_data_sg(cmd);
			/* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */

I mean, this seems like a real warning here.  We're not actually
handling the failure to allocate 'buf'.  It's not marked as __must_check,
but watch the code flow:

                        buf = transport_kmap_data_sg(cmd);
                        if (!buf)
                                ; /* XXX: TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE */

                        if (cdb[0] == MODE_SENSE_10) {
                                if (!(buf[3] & 0x80))
                                        buf[3] |= 0x80;
                        } else {
                                if (!(buf[2] & 0x80))
                                        buf[2] |= 0x80;
                        }

we're about to do a NULL ptr dereference.  So this should be handled
somehow.
