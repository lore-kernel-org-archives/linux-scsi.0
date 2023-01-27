Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60632C38142
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbjA0Pgu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbjA0Pgt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:36:49 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B14C8240F;
        Fri, 27 Jan 2023 07:36:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 037121F74B;
        Fri, 27 Jan 2023 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674833807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Dy9teD3D2g/+6Da5pQZNfWAScKID6dJInCu16q8Eqw=;
        b=iDcqNaykpcRmbRXtoJoMV9x7VXGS0XWDYKex0MxHf7Y0JnL+OBNhwzKLj+Ng2TeonnaHOs
        NcVqyhgMkhgvKchdxsR7O6Es3fnus1QpYUYJc+DdxdA+92uHY+pEhYMBpS64soAYt4Lbjm
        q8FTcQ4zKhGiOv/xz7TyVP3yxVfTQlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674833807;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Dy9teD3D2g/+6Da5pQZNfWAScKID6dJInCu16q8Eqw=;
        b=wmx0ZoKGqKelxCUUpHX7ANj+bfAg9SZjHU0rHhCMQaPKnz92WoUt4enQkSMH5ReCtUaAE3
        W+39ImSkk8EJb2Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E5F60138E3;
        Fri, 27 Jan 2023 15:36:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gKuSN47v02OQagAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:36:46 +0000
Message-ID: <6f089f65-648e-cb38-f13e-1ea8c4ec0d84@suse.de>
Date:   Fri, 27 Jan 2023 16:36:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 11/18] ata: libata: change ata_eh_request_sense() to
 not set CHECK_CONDITION
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-12-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-12-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:02, Niklas Cassel wrote:
> Currently, ata_eh_request_sense() unconditionally sets the scsicmd->result
> to SAM_STAT_CHECK_CONDITION.
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
> Change ata_eh_request_sense() to not set SAM_STAT_CHECK_CONDITION,
> and instead move the setting of SAM_STAT_CHECK_CONDITION to the single
> caller that wants SAM_STAT_CHECK_CONDITION set, that way
> ata_eh_request_sense() can be reused in a follow-up patch that adds
> support for CDL policy 0xD.
> 
> The only caller of ata_eh_request_sense() is protected by:
> if (!(qc->flags & ATA_QCFLAG_SENSE_VALID)), so we can remove this
> duplicated check from ata_eh_request_sense() itself.
> 
> Additionally, ata_eh_request_sense() is only called from
> ata_eh_analyze_tf(), which is only called when iteratating the QCs using
> ata_qc_for_each_raw(), which does not include the internal tag,
> so cmd can never be NULL (all non-internal commands have qc->scsicmd set),
> so remove the !cmd check as well.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-eh.c | 25 ++++++++++++++++---------
>   1 file changed, 16 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

