Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62616C07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 13:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4243761164
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 13:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFDNFf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 09:05:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42218 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhFDNFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 09:05:33 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C46532190C;
        Fri,  4 Jun 2021 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622811826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fa/G7RM5Ec0E3YrWIJp0Xc1S2mpO8rh4kUkib61rFYI=;
        b=dC9RGg6ZBeV0ABuPFqtxU5KUgPfHALj0ftjnlAnCqQUyP13orOddGqbJYg+IvqtsMUM9Ud
        xtX5HvcgVuqtvDBjdj7wkH3Q1VEBbsiJpi236HPgvVmcq8Zl0gurYYEEsx6GrbqgiHxaYY
        IoZZgdQtYNmJrg9s/mxMxa7153xv2QY=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7D3DC118DD;
        Fri,  4 Jun 2021 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622811826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fa/G7RM5Ec0E3YrWIJp0Xc1S2mpO8rh4kUkib61rFYI=;
        b=dC9RGg6ZBeV0ABuPFqtxU5KUgPfHALj0ftjnlAnCqQUyP13orOddGqbJYg+IvqtsMUM9Ud
        xtX5HvcgVuqtvDBjdj7wkH3Q1VEBbsiJpi236HPgvVmcq8Zl0gurYYEEsx6GrbqgiHxaYY
        IoZZgdQtYNmJrg9s/mxMxa7153xv2QY=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id mtQcHbIkumCwTQAALh3uQQ
        (envelope-from <mwilck@suse.com>); Fri, 04 Jun 2021 13:03:46 +0000
Message-ID: <20d1fe70b03a74cb89c9446457eff93fe7988532.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_dh_alua: signedness bug in alua_rtpg()
From:   Martin Wilck <mwilck@suse.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Pittman <jpittman@redhat.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Fri, 04 Jun 2021 15:03:46 +0200
In-Reply-To: <YLjMEAFNxOas1mIp@mwanda>
References: <YLjMEAFNxOas1mIp@mwanda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Do, 2021-06-03 at 15:33 +0300, Dan Carpenter wrote:
> The "retval" variable needs to be signed for the error handling to
> work.
> 
> Fixes: 7e26e3ea0287 ("scsi: scsi_dh_alua: Check for negative result
> value")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 7baee18ebd03..37d06f993b76 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -518,7 +518,8 @@ static int alua_rtpg(struct scsi_device *sdev,
> struct alua_port_group *pg)
>         int len, k, off, bufflen = ALUA_RTPG_SIZE;
>         int group_id_old, state_old, pref_old, valid_states_old;
>         unsigned char *desc, *buff;
> -       unsigned err, retval;
> +       unsigned err;
> +       int retval;
>         unsigned int tpg_desc_tbl_off;
>         unsigned char orig_transition_tmo;
>         unsigned long flags;


