Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99830C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 07:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiBQHG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 02:06:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiBQHG2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 02:06:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BCB19C3D
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 23:06:14 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A4AB82177B;
        Thu, 17 Feb 2022 07:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645081573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gjpN7Z0HOXSktVHsjci3E+p7IYBS2qaaNvweCK/pM8c=;
        b=JBksoYw7fXWHnm3/9QUCq6q9ubupnw9CC1WgYRfPisZSCbl01y1KxW6IKJPgnpWWhTy1Wx
        2KMqjo9sjqJl5KPvwIqRYYVjTATNCPD+bIx0ZGFU4+CV6l4oVvbn64hjL8Tv7OKFsfP4kI
        0UtnQjI1GAHEpWLjO0lt8gdc0S1+NX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645081573;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gjpN7Z0HOXSktVHsjci3E+p7IYBS2qaaNvweCK/pM8c=;
        b=SbbkQjN0+su7BEgypHXaIt/bviYH3ZOVP3lhh6b3sou9/rMNGEb1qw/1AU+29YXdDkoB5C
        qDlkDG/5n+aNlWBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6BD3B13B78;
        Thu, 17 Feb 2022 07:06:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id atFAGeXzDWKncgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 17 Feb 2022 07:06:13 +0000
Message-ID: <f3b4075c-6331-0790-aa7b-91c50ec3f401@suse.de>
Date:   Thu, 17 Feb 2022 08:06:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 29/50] scsi: bnx2fc: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220216210233.28774-1-bvanassche@acm.org>
 <20220216210233.28774-30-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220216210233.28774-30-bvanassche@acm.org>
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
>   drivers/scsi/bnx2fc/bnx2fc.h      |  9 +++++++--
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
>   drivers/scsi/bnx2fc/bnx2fc_io.c   | 23 +++++++++++------------
>   3 files changed, 19 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
