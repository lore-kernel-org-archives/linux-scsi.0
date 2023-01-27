Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1025DC38142
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 15:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjA0Pis (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 10:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjA0Pir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 10:38:47 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835531F91E;
        Fri, 27 Jan 2023 07:38:46 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D73AE2205B;
        Fri, 27 Jan 2023 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674833924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RP20uKD/HU2PYg9rOMZ/jQOfHsBH+/MuixeYqKJrc1o=;
        b=oBB/hjuQKCC5AwFIrFVyppNjSWwM2zxDN2yIRFQPVeaNkWiJ1j5kUUrC9FBbd8j4+GAxe2
        VI1Zar9TsLDhdA2howkjB6x31yz5gcVB3hNNKFlUM3pvBi1cY0+yjrMxHIR1uwiUzax0he
        t+h3boAPlXkzK0O7wIAvNsQD+QLwigY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674833924;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RP20uKD/HU2PYg9rOMZ/jQOfHsBH+/MuixeYqKJrc1o=;
        b=7Vpb9zi7bZv4asrbIybjOktRdxbdREQ+ILiUZj1VKY4hzARQBIxzyucXwvBXd6f5j6xuJy
        /0Z7i0xoW9PDuyDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9999138E3;
        Fri, 27 Jan 2023 15:38:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6oOoMATw02PfawAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 Jan 2023 15:38:44 +0000
Message-ID: <beff5610-7020-1869-e47a-f7952594b131@suse.de>
Date:   Fri, 27 Jan 2023 16:38:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 14/18] ata: libata-scsi: add support for CDL pages mode
 sense
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-15-niklas.cassel@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230124190308.127318-15-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 20:03, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Modify ata_scsiop_mode_sense() and ata_msense_control() to support mode
> sense access to the T2A and T2B sub-pages of the control mode page.
> ata_msense_control() is modified to support sub-pages. The T2A sub-page
> is generated using the read descriptors of the command duration limits
> log page 18h. The T2B sub-page is generated using the write descriptors
> of the same log page. With the addition of these sub-pages, getting all
> sub-pages of the control mode page is also supported by increasing the
> value of ATA_SCSI_RBUF_SIZE from 576B up to 2048B to ensure that all
> sub-pages fit in the fill buffer.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-scsi.c | 150 ++++++++++++++++++++++++++++++++------
>   1 file changed, 128 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

