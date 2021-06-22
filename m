Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE560C2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D251E611AF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhFVJL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 05:11:57 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36980 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVJL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2021 05:11:57 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C562421988;
        Tue, 22 Jun 2021 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624352980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GTi1fZ4fFY9TDr+mvTPKeyUhh+e5KnToidrw4nkQKw=;
        b=vUu1xZL2itSzp3ZCm/wBz/l/nojSWRAbcmmJxENC7V+b1aT4psFz71GlOKyQZyTJhwnNtg
        2gvSFnJH8e68GA9XRjmAXz3j5O7eevZNAoANgZln7W3viAE5e5iqFpmFlEcSBcLzOqHqOa
        tadqDlzhTgchj7zyp5IZsIRi7v4OeCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624352980;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GTi1fZ4fFY9TDr+mvTPKeyUhh+e5KnToidrw4nkQKw=;
        b=n5Zzq0IG7CeBfOKrS3ztgEZSog+3N1Y6BgVoRDf2EBv4Qjw13PTRPwqu1rYbL6EdxP9So4
        Ydn4qeE7A+iAvlBA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id AC1A7118DD;
        Tue, 22 Jun 2021 09:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624352980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GTi1fZ4fFY9TDr+mvTPKeyUhh+e5KnToidrw4nkQKw=;
        b=vUu1xZL2itSzp3ZCm/wBz/l/nojSWRAbcmmJxENC7V+b1aT4psFz71GlOKyQZyTJhwnNtg
        2gvSFnJH8e68GA9XRjmAXz3j5O7eevZNAoANgZln7W3viAE5e5iqFpmFlEcSBcLzOqHqOa
        tadqDlzhTgchj7zyp5IZsIRi7v4OeCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624352980;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9GTi1fZ4fFY9TDr+mvTPKeyUhh+e5KnToidrw4nkQKw=;
        b=n5Zzq0IG7CeBfOKrS3ztgEZSog+3N1Y6BgVoRDf2EBv4Qjw13PTRPwqu1rYbL6EdxP9So4
        Ydn4qeE7A+iAvlBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id ttPZKdSo0WCYIQAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 09:09:40 +0000
Subject: Re: [PATCH 1/2] virtio_scsi: do not overwrite SCSI status
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Jiri Slaby <jslaby@suse.com>
References: <20210610135833.46663-1-hare@suse.de>
 <yq1wnqv972s.fsf@ca-mkp.ca.oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b8e015bc-7b26-80f6-4900-d11b24869b35@suse.de>
Date:   Tue, 22 Jun 2021 11:09:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <yq1wnqv972s.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/15/21 4:59 AM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>> When a sense code is present we should not override the scsi status;
>> the driver already sets it based on the response from the hypervisor.
> 
> Color me confused. The code looks like this:
> 
>         if (sc->sense_buffer) {
>                 memcpy(sc->sense_buffer, resp->sense,
>                        min_t(u32,
>                              virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>                              VIRTIO_SCSI_SENSE_SIZE));
>                 set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>         }
> 
> But sc->sense_buffer is always true, the scsi_cmnd obviously has a sense
> buffer.
> 
> Shouldn't that be looking at the returned response instead?
> 
> 	if (resp->sense_len) {
>                 memcpy(sc->sense_buffer, resp->sense,
>                        min_t(u32,
>                              virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>                              VIRTIO_SCSI_SENSE_SIZE));
>                 set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>         }
> 
> What am I missing?
> 
Indeed, you are right. Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
