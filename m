Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CF5C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 10:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344265AbiBNKCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 05:02:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344798AbiBNKBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 05:01:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F9ED41
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 01:47:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C27EB210F4;
        Mon, 14 Feb 2022 09:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644832034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kTDN4TBwp8KxKqkx3I0v6CofRHujSlx1E4tUPsdolWE=;
        b=10UItOhHSrYREsDEf+K5atPAj1oUEr7/qFGC+NDAfxDfWWSoTbMfX2zU9px/0YJtARNot5
        IKd6i/Kcls16E+QM5q77c4WPaoYJ7mmB9qN5fpn7Dgzd0df69t0k2N9zMldWtMX1CuVMTd
        Woii5GbFGozcWFKtWQ1BwdreXmGNyjg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644832034;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kTDN4TBwp8KxKqkx3I0v6CofRHujSlx1E4tUPsdolWE=;
        b=kWak2Sgv66GW5MNzj/cPLJcQLd00PS6BB4gyVxDnlO9lTHDgh/n6BbYZro+OGZr+S2gwvG
        Bekuw5jN5qM09GAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9465C13A3C;
        Mon, 14 Feb 2022 09:47:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VKgNGyIlCmIpLwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Feb 2022 09:47:14 +0000
Message-ID: <fa821ad1-4e04-b0b2-a84a-e774ea7bf8f0@suse.de>
Date:   Mon, 14 Feb 2022 10:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 09/48] scsi: NCR5380: Move the SCSI pointer to private
 command data
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Finn Thain <fthain@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-10-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220211223247.14369-10-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 23:32, Bart Van Assche wrote:
> Move the SCSI pointer into the NCR5380 private command data instead of
> using the SCSI pointer from struct scsi_cmnd. This patch prepares for
> removal of the SCSI pointer from struct scsi_cmnd. The NCR5380 drivers
> have been identified as follows:
> $ git grep -l '#include.*NCR5380.h'
> drivers/scsi/arm/cumana_1.c
> drivers/scsi/arm/oak.c
> drivers/scsi/atari_scsi.c
> drivers/scsi/dmx3191d.c
> drivers/scsi/g_NCR5380.c
> drivers/scsi/mac_scsi.c
> drivers/scsi/sun3_scsi.c
> 
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/NCR5380.c    | 89 ++++++++++++++++++++++++---------------
>   drivers/scsi/NCR5380.h    |  1 +
>   drivers/scsi/atari_scsi.c |  7 ++-
>   drivers/scsi/g_NCR5380.c  |  6 ++-
>   drivers/scsi/mac_scsi.c   |  7 ++-
>   drivers/scsi/sun3_scsi.c  |  4 +-
>   6 files changed, 72 insertions(+), 42 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
