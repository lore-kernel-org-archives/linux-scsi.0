Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EA3C38142
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbjA0PnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjA0PnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:43:24 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB2E83247;
        Fri, 27 Jan 2023 07:43:23 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F13971F461;
        Fri, 27 Jan 2023 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674834201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6bYnmKfwFR/iJ5vYpWEJ5JO7dAylWR2n4u+iEc+HnA=;
        b=2K3Z3ueeaTZNrXm7Vf5DF8I0rAroCzr7lhejFSDczOHkhPDgwlx+3kN0E+VDIDxGU68ij6
        MZ4x8H7omrN0rkTTkgl/PJixyZ76x5HjP3R5O4TmLZvRZYcCfy/CxK3sbnx22xMBdbVJ7R
        3Gzm2OiTbnZjDxDYqIqfT01HRax+NnY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674834201;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6bYnmKfwFR/iJ5vYpWEJ5JO7dAylWR2n4u+iEc+HnA=;
        b=sUClsZhfLoYgzDFRVxWUrAJjX5CDBAoAFJerUywxKAVSaSCrwnDPZGSZJ5Zch6zkKloge8
        MwkJyvT1RRHl6MCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DEDAF138E3;
        Fri, 27 Jan 2023 15:43:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Vc5kNRnx02OibgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:43:21 +0000
Message-ID: <9f2d98ac-f602-f407-b810-182162447e78@suse.de>
Date:   Fri, 27 Jan 2023 16:43:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 17/18] ata: libata: handle completion of CDL commands
 using policy 0xD
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-18-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-18-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:03, Niklas Cassel wrote:
> A CDL timeout for policy 0xF is defined as a NCQ error, just with a CDL
> specific sk/asc/ascq in the sense data. Therefore, the existing code in
> libata does not need to be modified to handle a policy 0xF CDL timeout.
> 
> For Command Duration Limits policy 0xD:
> The device shall complete the command without error with the additional
> sense code set to DATA CURRENTLY UNAVAILABLE.
> 
> Since a CDL timeout for policy 0xD is not an error, we cannot use the
> NCQ Command Error log (10h).
> 
> Instead, we need to read the Sense Data for Successful NCQ Commands
> log (0Fh).
> 
> In the success case, just like in the error case, we cannot simply read
> a log page from the interrupt handler itself, since reading a log page
> involves sending a READ LOG DMA EXT or READ LOG EXT command.
> 
> Therefore, we add a new EH action ATA_EH_GET_SUCCESS_SENSE.
> When a command completes without error, and when the ATA_SENSE bit
> is set, this new action is set as pending, and EH is scheduled.
> 
> This way, similar to the NCQ error case, the log page will be read
> from EH context.
> 
> An alternative would have been to add a new kthread or workqueue to
> handle this. However, extending EH can be done with minimal changes
> and avoids the need to synchronize a new kthread/workqueue with EH.
> 
> Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-core.c |  88 +++++++++++++++++++++++++++++++-
>   drivers/ata/libata-eh.c   | 105 +++++++++++++++++++++++++++++++++++++-
>   drivers/ata/libata-sata.c |  92 +++++++++++++++++++++++++++++++++
>   include/linux/ata.h       |   3 ++
>   include/linux/libata.h    |  11 +++-
>   5 files changed, 295 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

