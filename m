Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58E5EE57DF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbjIKGrt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234560AbjIKGrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:47:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27634130;
        Sun, 10 Sep 2023 23:47:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DF7EF1F460;
        Mon, 11 Sep 2023 06:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694414861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbRUq8M+AuJGxyK62vg5bcs2IX4Pwh8PhDGt5oLfRvI=;
        b=2QQgCOs2Iz4+NS04otJcQhqp6CrdD70j6OBz+B/OxuodNquNDTI7KjlPxB1hcxXWwpNMxh
        St1j7x3M/TcvBpQFSFIDEhzl77QRMTmQ5ArALwc1owPJAXE4NvPYCQUouqIPIR4P6KOpy6
        5cRNSjrW+SOmQNCGV8FEgZiEGmr3VpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694414861;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbRUq8M+AuJGxyK62vg5bcs2IX4Pwh8PhDGt5oLfRvI=;
        b=TdYm9CfvGG1xBAU/7f0W4nifzGnOgHTZDPjYHQFhZygP42UfUuCL5gn4jCLpTyId9e1cVQ
        1U4uWCphrW524wDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 82D9213780;
        Mon, 11 Sep 2023 06:47:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UJq7HQ24/mRuTgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 06:47:41 +0000
Message-ID: <7189b979-0baa-4134-ba7e-068e27c2268c@suse.de>
Date:   Mon, 11 Sep 2023 08:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/19] ata: libata-scsi: Fix delayed scsi_rescan_device()
 execution
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-6-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> Commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after
> device resume") modified ata_scsi_dev_rescan() to check the scsi device
> "is_suspended" power field to ensure that the scsi device associated
> with an ATA device is fully resumed when scsi_rescan_device() is
> executed. However, this fix is problematic as:
> 1) it relies on a PM internal field that should not be used without PM
>     device locking protection.
> 2) The check for is_suspended and the call to ata_scsi_dev_rescan() are
>     not atomic and a suspend PM even may be triggered between them,
>     casuing ata_scsi_dev_rescan() to be called on a suspended device,
>     resulting in that function blocking while holding the scsi device
>     lock, which would deadlock a following resume operation.
> These problems can trigger PM deadlocks on resume, especially with
> resume operations triggered quickly after or during suspend operations.
> E.g., a simple bash script like:
> 
> for (( i=0; i<10; i++ )); do
> 	echo "+2 > /sys/class/rtc/rtc0/wakealarm
> 	echo mem > /sys/power/state
> done
> 
> that triggers a resume 2 seconds after starting suspending a system can
> quickly lead to a PM deadlock preventing the system from correctly
> resuming.
> 
> Fix this by replacing the check on is_suspended with a check on the scsi
> device state inside ata_scsi_dev_rescan(), while holding the scsi device
> lock, thus making the device rescan atomic with regard to PM operations.
> Additionnly, make sure that scheduled rescan tasks are first cancelled
> before suspending an ata port.
> 
> Fixes: 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after device resume")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-core.c | 16 ++++++++++++++++
>   drivers/ata/libata-scsi.c | 36 ++++++++++++++++++------------------
>   drivers/scsi/scsi_scan.c  | 12 +++++++++++-
>   include/scsi/scsi_host.h  |  2 +-
>   4 files changed, 46 insertions(+), 20 deletions(-)
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

