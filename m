Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015F0C677F1
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 07:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbjAMHuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 02:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjAMHuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 02:50:02 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30F763185;
        Thu, 12 Jan 2023 23:49:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2B0FF5FBDC;
        Fri, 13 Jan 2023 07:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673596189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qr45SYM5k3TQ5Ca9ilptJQCk+nFtroXeKFE0zYAlz5M=;
        b=e2gk5fK+Fg8VsLy4gVxkeBjQhAKVcJg55uMbswGMHSJ38f+CWGNtnBMC350UmKUKLlIMyH
        EJzhteMm9Vm3jnCmqjl/hpn1P4FpRDN8vRkwD5r8oAmd7AO9cXEYo/vgXBkW7F4ucC1kc+
        ee1UCHBfYayFZSvLJ/u76dk9yLkpDlA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673596189;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qr45SYM5k3TQ5Ca9ilptJQCk+nFtroXeKFE0zYAlz5M=;
        b=R9MnoZYGulzb3qoGcxYMbGvLANJ6mtnQt9z2lUwPttk4iTDaC5biUBqoIu4dz9UPd+gk68
        9iYXdAYw9/+n33CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A296613913;
        Fri, 13 Jan 2023 07:49:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TuStJBwNwWN3QgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Jan 2023 07:49:48 +0000
Message-ID: <88a6a525-9922-b07e-75c3-a54a00c18950@suse.de>
Date:   Fri, 13 Jan 2023 08:49:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/18] ata: libata: allow ata_scsi_set_sense() to not
 set CHECK_CONDITION
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-2-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230112140412.667308-2-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/23 15:03, Niklas Cassel wrote:
> Current ata_scsi_set_sense() calls scsi_build_sense(), which,
> in addition to setting the sense data, unconditionally sets the
> scsicmd->result to SAM_STAT_CHECK_CONDITION.
> 
> For Command Duration Limits policy 0xD:
> The device shall complete the command without error (SAM_STAT_GOOD)
> with the additional sense code set to DATA CURRENTLY UNAVAILABLE.
> 
> It is perfectly fine to have sense data for a command that returned
> completion without error.
> 
> In order to support for CDL policy 0xD, we have to remove this
> assumption that having sense data means that the command failed
> (SAM_STAT_CHECK_CONDITION).
> 
> Add a new parameter to ata_scsi_set_sense() to allow us to set
> sense data without unconditionally setting SAM_STAT_CHECK_CONDITION.
> This new parameter will be used in a follow-up patch.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-eh.c   |  3 ++-
>   drivers/ata/libata-sata.c |  4 ++--
>   drivers/ata/libata-scsi.c | 38 ++++++++++++++++++++------------------
>   drivers/ata/libata.h      |  4 ++--
>   4 files changed, 26 insertions(+), 23 deletions(-)
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

