Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E919CEE4996
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 06:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjHVGve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 02:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbjHVGvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 02:51:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B49AFB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 23:51:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D1E5922C03;
        Tue, 22 Aug 2023 06:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692687090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJRZWX4JjeCMg72T7GT1udjmy2fDi22EL3wNM21oJog=;
        b=H5WqN33S/CA2bE/HYSt7YpZwdCU7nTTLH/ADChPlBDsdhnxSypoU61qc3QmrVIBT52rmnS
        7bI+bugYu36jjBFS8j/4r5sHBzANMe0xbrtz+Jpx9UCBe+gUYfFmhNR2esKxDwEBlsg4Hr
        bjxpd2tyBDMClJUGZ4zKvcJJVMtJJdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692687090;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJRZWX4JjeCMg72T7GT1udjmy2fDi22EL3wNM21oJog=;
        b=3A0kACyMJQF9fdIL57OYOnuv3Xb0YwUFEM29Ggz8IJf7YPeIy2HWWzqggKKVi7XIBK5AC/
        X5ZAwFcu+d3gkiBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A8A1813919;
        Tue, 22 Aug 2023 06:51:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6QzKH/Ba5GQSRwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 22 Aug 2023 06:51:28 +0000
Message-ID: <285cd051-b7eb-be27-0d84-b4f2844cf1d7@suse.de>
Date:   Tue, 22 Aug 2023 08:51:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] scsi: core: Improve type safety of scsi_rescan_device()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20230821204009.3601639-1-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230821204009.3601639-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/21/23 22:40, Bart Van Assche wrote:
> Most callers of scsi_rescan_device() have the scsi_device pointer
> available. Pass a struct scsi_device pointer to scsi_rescan_device()
> instead of a struct device pointer. This change prevents that a
> pointer to another struct device pointer would be passed accidentally to
> scsi_rescan_device().
> 
> Remove the scsi_rescan_device() declaration from the scsi_priv.h header
> file since it duplicates the declaration in <scsi/scsi_host.h>.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ata/libata-scsi.c             | 2 +-
>   drivers/scsi/aacraid/commsup.c        | 2 +-
>   drivers/scsi/mvumi.c                  | 2 +-
>   drivers/scsi/scsi_lib.c               | 2 +-
>   drivers/scsi/scsi_priv.h              | 1 -
>   drivers/scsi/scsi_scan.c              | 4 ++--
>   drivers/scsi/scsi_sysfs.c             | 4 ++--
>   drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
>   drivers/scsi/storvsc_drv.c            | 2 +-
>   drivers/scsi/virtio_scsi.c            | 2 +-
>   include/scsi/scsi_host.h              | 2 +-
>   11 files changed, 12 insertions(+), 13 deletions(-)
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

