Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E419C7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237540AbjFLPoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjFLPoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:44:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B519B10C7;
        Mon, 12 Jun 2023 08:44:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F102422724;
        Mon, 12 Jun 2023 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686584647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GdRycsSiOEQEiY7fq6URveL3vbsA2aSWAErAiK5l0M=;
        b=zaZLjJvC5xEX5I/mZoOix4aVJWk7gEeFU8rxVko0vXQQt7ARSv0v4kFXw9+uxSuwPDKDOI
        94xX1SAMcViqq3Ss+09RsowVEjvYs0c6p0wu8uF67ukYJC4lt+hQLP0+hBsRw8bu4/eJlg
        J7O64R+51WNFdesTPhE9C7Xoq4KNjnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686584647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GdRycsSiOEQEiY7fq6URveL3vbsA2aSWAErAiK5l0M=;
        b=/mQFuf8FbPYeCw34xJDN841sAWIh41SmP/MjlAV+Z212k2bc0dVh7ccg+3iJKiy9qX8Ewr
        oz7FH/Wlrgn4+BAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ACBAF138EC;
        Mon, 12 Jun 2023 15:44:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rHlXJ0c9h2QNQgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 12 Jun 2023 15:44:07 +0000
Message-ID: <1b2e7785-061e-dce3-8862-7eab656e18af@suse.de>
Date:   Mon, 12 Jun 2023 17:44:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 6/6] scsi: replace scsi_target_block() by
 scsi_block_targets()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
References: <20230612145638.16999-1-mwilck@suse.com>
 <20230612145638.16999-7-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230612145638.16999-7-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 16:56, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> All callers (fc_remote_port_delete(), __iscsi_block_session(),
> __srp_start_tl_fail_timers(), srp_reconnect_rport(), snic_tgt_del()) pass
> parent devices of scsi_target devices to scsi_target_block().
> 
> Rename the function to scsi_block_targets(), and simplify it by assuming
> that it is always passed a parent device. Also, have callers pass the
> Scsi_Host pointer to scsi_block_targets(), as every caller has this pointer
> readily available.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: Sesidhar Baddela <sebaddel@cisco.com>
> ---
>   drivers/scsi/scsi_lib.c             | 25 +++++++++++++++----------
>   drivers/scsi/scsi_transport_fc.c    |  2 +-
>   drivers/scsi/scsi_transport_iscsi.c |  3 ++-
>   drivers/scsi/scsi_transport_srp.c   |  6 +++---
>   drivers/scsi/snic/snic_disc.c       |  2 +-
>   include/scsi/scsi_device.h          |  2 +-
>   6 files changed, 23 insertions(+), 17 deletions(-)
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

