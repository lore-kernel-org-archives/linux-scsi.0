Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D675CE80AA4
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 07:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjI0Hqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 03:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjI0Hq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 03:46:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803E11D;
        Wed, 27 Sep 2023 00:46:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 715E121872;
        Wed, 27 Sep 2023 07:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695800784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbbQbrR06MjuXJUkpqQ4i2ColyIF9+FuLCUuRd70zN0=;
        b=cehsKSIGqrkzjvuS+YRKKGY6hP4E+LsLP4CRw76jTvsSZZDZsIf6+ENVwusqslQbcRwLlh
        YsluFvIeoz5EIfmKm1ZzA4EEfbJTIZ8dtaBwvY+my0wCg39ysRzZg+kNULIIBCUdW7gHG5
        4Alo4nDaWcdgoDR+9ULJ3n8k6mTEN10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695800784;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbbQbrR06MjuXJUkpqQ4i2ColyIF9+FuLCUuRd70zN0=;
        b=IVVBb5U0XradsI9rNxG1aZiQ1Q5NON1UR3IgDTsrpzSZB/oR0HYjzxezTaa0Q2ZuZc9U3e
        awWq63TCjs1Ti/BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C79F61338F;
        Wed, 27 Sep 2023 07:46:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NAMeLs/dE2UmUQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 27 Sep 2023 07:46:23 +0000
Message-ID: <a08aa90e-7d3b-4601-812f-64c10bb6f10d@suse.de>
Date:   Wed, 27 Sep 2023 09:46:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230926081507.69346-1-dlemoal@kernel.org>
 <20230926081507.69346-10-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230926081507.69346-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/23 10:14, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. This in turn results in a call to sd_shutdown() which
> will issue a synchronize cache command and a start stop unit command to
> spindown the disk. sd_shutdown() issues the commands only if the device
> is not already runtime suspended but does not check the power state for
> system-wide suspend/resume. That is, the commands may be issued with the
> device in a suspended state, which causes PM resume to hang, forcing a
> reset of the machine to recover.
> 
> Fix this by tracking the suspended state of a disk by introducing the
> suspended boolean field in the scsi_disk structure. This flag is set to
> true when the disk is suspended is sd_suspend_common() and resumed with
> sd_resume(). When suspended is true, sd_shutdown() is not executed from
> sd_remove().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/scsi/sd.c | 17 +++++++++++++----
>   drivers/scsi/sd.h |  1 +
>   2 files changed, 14 insertions(+), 4 deletions(-)
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

