Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1BDC47094
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B4B7610C7
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 11:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFGLn3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 07:43:29 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36784 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhFGLn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 07:43:29 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7F11E21A98;
        Mon,  7 Jun 2021 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623066097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igDnF5ZmEG2zZLWJYgXP9VS65qJ0yD+V5kexmfG/3jc=;
        b=hmhBIOt3SUwiBBE3ToeG3QOoLPgeLKkPv16LW84R/G1X/YfOCExYUAf7pJ9+WYzoFqYjlL
        9LHScUKp8ZMPw67ZYV/EUAHIwx0Fxg26XLUR4ULpCpMxBXnAzijMtJXd2gSpfF+/NYr9Xk
        58GNXOnDHYgPXJnJWDPh8b5lodzIPIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623066097;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igDnF5ZmEG2zZLWJYgXP9VS65qJ0yD+V5kexmfG/3jc=;
        b=tC6pvjSZ+TqvbVw5HjKbQ+Pd31UfesphslC0/4InCr7EZER3OeWohDaJV4G1mw944wO4Ps
        DQcY4fLt86Gb8pDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 63BB6118DD;
        Mon,  7 Jun 2021 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623066097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igDnF5ZmEG2zZLWJYgXP9VS65qJ0yD+V5kexmfG/3jc=;
        b=hmhBIOt3SUwiBBE3ToeG3QOoLPgeLKkPv16LW84R/G1X/YfOCExYUAf7pJ9+WYzoFqYjlL
        9LHScUKp8ZMPw67ZYV/EUAHIwx0Fxg26XLUR4ULpCpMxBXnAzijMtJXd2gSpfF+/NYr9Xk
        58GNXOnDHYgPXJnJWDPh8b5lodzIPIU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623066097;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igDnF5ZmEG2zZLWJYgXP9VS65qJ0yD+V5kexmfG/3jc=;
        b=tC6pvjSZ+TqvbVw5HjKbQ+Pd31UfesphslC0/4InCr7EZER3OeWohDaJV4G1mw944wO4Ps
        DQcY4fLt86Gb8pDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id BrLZF/EFvmC2XwAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 11:41:37 +0000
Subject: Re: [PATCH 4/4] scsi: core: only put parent device if host state
 isn't in SHOST_CREATED
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-5-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <40e024d4-87d6-ca11-8b68-d15f2e772ecc@suse.de>
Date:   Mon, 7 Jun 2021 13:41:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602133029.2864069-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/21 3:30 PM, Ming Lei wrote:
> get_device(shost->shost_gendev.parent) is called after host state is
> changed to SHOST_RUNNING. So scsi_host_dev_release() shouldn't release
> the parent device if host state is still SHOST_CREATED.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/hosts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 7049844adb6b..34db5be7a562 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -350,7 +350,7 @@ static void scsi_host_dev_release(struct device *dev)
>  
>  	ida_simple_remove(&host_index_ida, shost->host_no);
>  
> -	if (parent)
> +	if (shost->shost_state != SHOST_CREATED)
>  		put_device(parent);
>  	kfree(shost);
>  }
> 
What happened to the check 'if (parent)'?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
