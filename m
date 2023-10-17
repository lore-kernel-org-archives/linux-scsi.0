Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247D1CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 15:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344345AbjJQPfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343858AbjJQPfL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 11:35:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937BA92
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 08:35:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 20FF921D0F;
        Tue, 17 Oct 2023 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697556908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rbaNqRTAuAG5R1ksCvIceuFuGBg4Vt+zVl8+vWVv1mg=;
        b=d8kYlJZ1gPsPp0GNbdGKZu7KuP93raP0Zn2GKYPFzTzDm+SFIr4z+RFnHcd8OMeDh0y/vK
        L+d+YM3RgVlkcTTr+fePyBg3Hj/htmS3IRHH0ckD/A/9beHjIgDvin/ovCcZgQbGcfF+P4
        V/i7pdiFwml/nlTHuGeBQaNWIo8j8FQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697556908;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rbaNqRTAuAG5R1ksCvIceuFuGBg4Vt+zVl8+vWVv1mg=;
        b=IBofjeGRQP6qu1fhoodrB57mn2bmyKx6qGzVqmHlsYsvQGc94UJj2B7OUD3KNhgj2qufv3
        LdfSp9w9kRgTeKAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C0D113584;
        Tue, 17 Oct 2023 15:35:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oePcAaypLmX/PQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Oct 2023 15:35:08 +0000
Message-ID: <028062b3-c0fb-45c9-8283-330a2f2235bf@suse.de>
Date:   Tue, 17 Oct 2023 17:35:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: megaraid: Pass in NULL scb for host reset
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-scsi@vger.kernel.org
References: <731d9834-76a7-4e01-be8e-f2850c50b45a@moroto.mountain>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <731d9834-76a7-4e01-be8e-f2850c50b45a@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-6.72 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-2.63)[98.35%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_TWO(0.00)[2];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/17/23 15:56, Dan Carpenter wrote:
> Hello Hannes Reinecke,
> 
> The patch 5bcd3bfbda02: "scsi: megaraid: Pass in NULL scb for host
> reset" from Oct 2, 2023 (linux-next), leads to the following Smatch
> static checker warning:
> 
>      drivers/scsi/megaraid.c:1901 megaraid_reset()
>      error: NULL dereference inside function 'megaraid_abort_and_reset()'
> 
>      drivers/scsi/megaraid.c:1940 megaraid_abort_and_reset()
>      warn: variable dereferenced before check 'cmd' (see line 1928)
> 
> drivers/scsi/megaraid.c
>      1899         spin_lock_irq(&adapter->lock);
>      1900
> --> 1901         rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
>                                                             ^^^^
> The debug code dereferences this unconditionally...
> 
>      1902
>      1903         /*
>      1904          * This is required here to complete any completed requests
>      1905          * to be communicated over to the mid layer.
>      1906          */
>      1907         mega_rundoneq(adapter);
>      1908         spin_unlock_irq(&adapter->lock);
>      1909
>      1910         return rval;
>      1911 }
> 
Will be sending a patch.

Cheers,

Hannes


