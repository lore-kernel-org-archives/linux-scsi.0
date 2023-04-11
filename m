Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D599C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 06:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjDKGRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 02:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjDKGRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 02:17:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA3198D;
        Mon, 10 Apr 2023 23:17:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 77949219F2;
        Tue, 11 Apr 2023 06:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681193855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBkn98/x5NQjXTPRFEc0jqYcLmbLmMu9oG4I0PfZFnk=;
        b=w2Nd77bV0akcicO16AFecpO+ETzUfazbPWxFSjD20lE6fXmxzPqk/h1wqgvTQ2J2DxoC7Z
        EXr0+Hq6vQlwj3h6tfYY7chxHMAV9MWOQhzLKE4t9toddslgbJk/K4LQwKj8PVGFEg3LQ4
        eq3VwByeA9ih92tcWzF60pWOP3GmnVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681193855;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBkn98/x5NQjXTPRFEc0jqYcLmbLmMu9oG4I0PfZFnk=;
        b=t0+mDbFlRUrYxC380Vsl9sItECAGw35Flq1XrJEA5TEHdLwbch4S5cs55SHym6pqEaKhai
        eaFNM7JscQvY41AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4EB6C13519;
        Tue, 11 Apr 2023 06:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pEYKEn/7NGRwSAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 06:17:35 +0000
Message-ID: <0288a1cb-d2a0-6493-eae0-1d1b1fe9209c@suse.de>
Date:   Tue, 11 Apr 2023 08:17:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 10/11] iscsi: make session and connection lists per-net
Content-Language: en-US
To:     Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, Lee Duncan <leeman.duncan@gmail.com>,
        netdev@vger.kernel.org
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
 <20230410191033.1069293-2-cleech@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230410191033.1069293-2-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/10/23 21:10, Chris Leech wrote:
> Eliminate the comparisions on list lookups, and it will make it easier
> to shut down session on net namespace exit in the next patch.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 104 ++++++++++++++++------------
>   1 file changed, 61 insertions(+), 43 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

