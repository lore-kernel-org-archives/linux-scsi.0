Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DBC7C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357DC61364
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 06:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhEaGac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 02:30:32 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47704 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhEaGab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 02:30:31 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 34D0C1FD2F;
        Mon, 31 May 2021 06:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622442531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4WnUtCClUhVv4IlUD+BnstQaSkPByuHIVpvyNUuyJc=;
        b=pHnO2aKomCE910sZyDpeMSYC+3IIjSQmvu3a/NHf7tiIKD+sy0eKcCBF3e7W/TmVG6zmLw
        qUsBahVDmqfzFdEcBCnwryDgO5jVx0zDGOj0zm/tdshgGtd1+QpuI7u9C2DbTxWruKfb4R
        z8TPfyaZr4Mziu+6RMTuOnV2ewg4R/Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622442531;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4WnUtCClUhVv4IlUD+BnstQaSkPByuHIVpvyNUuyJc=;
        b=wCWFTT+yGbXmLAPfdQO5MUkmzP5B1cEm/2z5bfTLERsV7VhWJvD4hBceYyXYA/Zf8j5yOo
        NCFe4Eypei72tkDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 880DF118DD;
        Mon, 31 May 2021 06:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622442530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4WnUtCClUhVv4IlUD+BnstQaSkPByuHIVpvyNUuyJc=;
        b=hf+NzDOJ4xt/sf2tUgAJbBaFSyQgKGBu8BLx2VpXNQdD30RRx6I4XJLXOgiQFBtuPGvacl
        TpwFYXIcHZGYQXNO5GHmSmzS9AFiQbwOeerccFYEKsO4X5MD1TU7riKo2rgqIx2EfC4up6
        2Xg4gXN6ptakbeJqSESSZ4+u48+sq6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622442530;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4WnUtCClUhVv4IlUD+BnstQaSkPByuHIVpvyNUuyJc=;
        b=XUHFLd7EqUy3BeLKXE08YLpgonIm1dP9ILt3jvsFi2X97n/UUeqB9L3f1O3bCddBRUL5Jc
        7pCX20Rx5c5NPsDg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id tOkiICKCtGDxewAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 31 May 2021 06:28:50 +0000
Subject: Re: [PATCH V3 3/3] scsi: core: put ->shost_gendev.parent in failure
 handling path
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <20210531050727.2353973-4-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2cbcfc4a-78ae-ddc9-1386-6008fcaecb0b@suse.de>
Date:   Mon, 31 May 2021 08:28:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531050727.2353973-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spamd-Result: default: False [0.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_FIVE(0.00)[5];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 7:07 AM, Ming Lei wrote:
> get_device(shost->shost_gendev.parent) is called in
> scsi_add_host_with_dma(), but its counter pair isn't called in the failure
> path, so fix it by calling put_device(shost->shost_gendev.parent) in its
> failure path.
> 
> Reported-by: John Garry <john.garry@huawei.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/hosts.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 6cbc3eb16525..6cc43c51b7b3 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -298,6 +298,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>    out_del_dev:
>   	device_del(&shost->shost_dev);
>    out_del_gendev:
> +	put_device(shost->shost_gendev.parent);
>   	device_del(&shost->shost_gendev);
>    out_disable_runtime_pm:
>   	device_disable_async_suspend(&shost->shost_gendev);
> 
This really needs to be folded into the first patch as it's really a 
bugfix for that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
