Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A15C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 07:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbiBQHHB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 02:07:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiBQHHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 02:07:00 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591D01A343D
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 23:06:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 84BBF1F37D;
        Thu, 17 Feb 2022 07:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645081603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfkH3W213HeSBIpcwSz3xh2KVlG8KykEKAh1aKlBFaw=;
        b=swSajMLIqWO+QzGrjeKzSc+ZbcgDtujyaZdnSb2JJODwP8Ahv12c50zDFGdX1sYLA5RU80
        eAW6CJ/AOOc736pIb/V6juo138fJ8L+xJhGSXO263V5ZF+VSbY0IITksDn17IIA1sj93J3
        laltRZEGSksPx7ZXE+j5XFsNu+yGL0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645081603;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfkH3W213HeSBIpcwSz3xh2KVlG8KykEKAh1aKlBFaw=;
        b=PkvSjVHKMV8S9zCJRAwxN5prqnT8CCO1y6DyHYfsfK2R+WBGtLUAHnmOBLuw8HjEI0H0CP
        CQQH6qYHq2cfswBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5395013B78;
        Thu, 17 Feb 2022 07:06:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9gE/EwP0DWLVcgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 17 Feb 2022 07:06:43 +0000
Message-ID: <25febc67-9ea9-aa3b-748f-6bd342310855@suse.de>
Date:   Thu, 17 Feb 2022 08:06:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 30/50] scsi: qedf: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220216210233.28774-1-bvanassche@acm.org>
 <20220216210233.28774-31-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220216210233.28774-31-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/22 22:02, Bart Van Assche wrote:
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. Remove the CMD_SCSI_STATUS() assignment because the
> assigned value is not used.
> 
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qedf/qedf.h      | 10 +++++++++-
>   drivers/scsi/qedf/qedf_io.c   | 25 ++++++++++++-------------
>   drivers/scsi/qedf/qedf_main.c |  3 ++-
>   3 files changed, 23 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
