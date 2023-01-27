Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79528C61DA4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbjA0Pfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjA0Pfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:35:36 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3AA81B39;
        Fri, 27 Jan 2023 07:35:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0890F1F381;
        Fri, 27 Jan 2023 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674833734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kb9943h8PeEJOZMKjfwjHahyqBnq/YsBtNI34ETia0I=;
        b=jmo7FeUiZpUCbMBvruKItld/ypNWxJeWzpDC1sbYZGBWUDvyUQtqQwoOGNjzciEh0EN70u
        910bkJmdtCDsJRWbiwlLYVkpWbgzjJ8vAlnfrcQ9DyjDvXtJBv/+/k18ql+pH/pN+jrkBI
        DdsVugvKHkTnPPcESe6+7QgqempnxTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674833734;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kb9943h8PeEJOZMKjfwjHahyqBnq/YsBtNI34ETia0I=;
        b=2uIOPVMeBzP5Xn+B9/OMk6bmtFqgJqrXR7k4eokotCMl2BWZ2CrgBwiLwtDuJkBXSBWrSm
        qbjDqazQnelJLaBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EEFB7138E3;
        Fri, 27 Jan 2023 15:35:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /wgZOkXv02PiaQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:35:33 +0000
Message-ID: <a2361042-130e-9929-e4b0-08db772377db@suse.de>
Date:   Fri, 27 Jan 2023 16:35:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 10/18] ata: libata-scsi: remove unnecessary !cmd checks
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-11-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-11-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:02, Niklas Cassel wrote:
> There is no need to check if !cmd as this can only happen for
> ATA internal commands which uses the ATA internal tag (32).
> 
> Most users of ata_scsi_set_sense() are from _xlat functions that
> translate a scsicmd to an ATA command. These obviously have a qc->scsicmd.
> 
> ata_scsi_qc_complete() can also call ata_scsi_set_sense() via
> ata_gen_passthru_sense() / ata_gen_ata_sense(), called via
> ata_scsi_qc_complete(). This callback is only called for translated
> commands, so it also has a qc->scsicmd.
> 
> ata_eh_analyze_ncq_error(): the NCQ error log can only contain a 0-31
> value, so it will never be able to get the ATA internal tag (32).
> 
> ata_eh_request_sense(): only called by ata_eh_analyze_tf(), which
> is only called when iteratating the QCs using ata_qc_for_each_raw(),
> which does not include the internal tag.
> 
> Since there is no existing call site where cmd can be NULL, remove the
> !cmd check from ata_scsi_set_sense() and ata_scsi_set_sense_information().
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-scsi.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

