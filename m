Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5D3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbiBIIfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:35:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiBIIfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:35:40 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8571C03E922;
        Wed,  9 Feb 2022 00:35:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8E41D21107;
        Wed,  9 Feb 2022 08:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644395712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H3cyaCAbTZ5sTsEbJEYtAwjOiMdsXbglAMTSql5JECI=;
        b=Hc8cYz3ZDlPhkMxMKSiyE72TUeBWlUxtco5NRHKVhTs3+8JGci1d2sMYyIy9kay5taCIUu
        3drPw++mkxQm9/kKnhiLVKMPvXx6GXUAznux094YoSp7dNT1pfyDdnF79ziRzZl9UaTgYy
        McixNV2J6QCVG2pV13LfpjrkK1Np/io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644395712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H3cyaCAbTZ5sTsEbJEYtAwjOiMdsXbglAMTSql5JECI=;
        b=4+R9OsV906SgApxKEOiwY3tAU/7nSb7U1VSa8ESMtIjeJypTPcE2+2Rcmp4Ic8SGo5Rsxb
        qiTky5kFGXZD7pCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4CBE013A7C;
        Wed,  9 Feb 2022 08:35:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7KhBD8B8A2LQJwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:35:12 +0000
Message-ID: <5331b4d0-fa00-be6a-15eb-8f6b09fe7adb@suse.de>
Date:   Wed, 9 Feb 2022 09:35:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 40/44] scsi: usb: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-41-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-41-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:25, Bart Van Assche wrote:
> Set scsi_host_template.cmd_size instead of using the SCSI pointer for
> storing driver-private data. Change the type of the argument of
> uas_add_work() from struct uas_cmd_info * into struct scsi_cmnd * because
> it is easier to convert a SCSI command pointer into a uas_cmd_info pointer
> than the other way around.
> 
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.
> 
> Cc: linux-usb@vger.kernel.org
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Oliver Neukum <oneukum@suse.com>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/usb/storage/uas.c | 43 ++++++++++++++++++---------------------
>   1 file changed, 20 insertions(+), 23 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
