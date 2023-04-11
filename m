Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755B5C77B76
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjDKGoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 02:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDKGoQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 02:44:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F84E6B;
        Mon, 10 Apr 2023 23:44:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0E29E1FE01;
        Tue, 11 Apr 2023 06:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681195454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fh7zZq+f19Lvpj7PUb4GOWKwLFO9SE4q4c/44X5v+wo=;
        b=i37vfEWJDq+0b3YTBPsA0FGJCRBNiM74M7Ljd2JlsAW6zpW4NGq6YgB+fp4DCmQ2N5/4O6
        /IvQ+HhupSHQtKtn+4BX0dkBtyDIwUo6+N7849ExN3fQ1gJU2K9ZhALU+0mCs7pKjYLKYU
        orV7hYKXuWPlZv53kRv/HPUmh8nmqZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681195454;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fh7zZq+f19Lvpj7PUb4GOWKwLFO9SE4q4c/44X5v+wo=;
        b=2I4BVZdVvPFpb0/tXm4Xj40+dlMlfKQW+nuQIlGbzC0HS+3dK8Io9pLL+DixMZh7uLM1Lo
        lIQRzd9pmSfRO0Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C4C3013519;
        Tue, 11 Apr 2023 06:44:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N/CNLr0BNWSlUAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 06:44:13 +0000
Message-ID: <49b53bed-f06f-7e71-2555-54808e073b63@suse.de>
Date:   Tue, 11 Apr 2023 08:44:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230406113252.41211-10-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/6/23 13:32, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Add the sysfs scsi device attribute cdl_enable to allow a user to turn
> enable or disable a device command duration limits feature. CDL is
> disabled by default. This feature must be explicitly enabled by a user by
> setting the cdl_enable attribute to 1.
> 
> The new function scsi_cdl_enable() does not do anything beside setting
> the cdl_enable field of struct scsi_device in the case of a (real) scsi
> device (e.g. a SAS HDD). For ATA devices, the command duration limits
> feature needs to be enabled/disabled using the ATA feature sub-page of
> the control mode page. To do so, the scsi_cdl_enable() function checks
> if this mode page is supported using scsi_mode_sense(). If it is,
> scsi_mode_select() is used to enable and disable CDL.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   Documentation/ABI/testing/sysfs-block-device | 13 ++++
>   drivers/scsi/scsi.c                          | 62 ++++++++++++++++++++
>   drivers/scsi/scsi_sysfs.c                    | 28 +++++++++
>   include/scsi/scsi_device.h                   |  2 +
>   4 files changed, 105 insertions(+)
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

