Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD2DBC6FD1D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbjDDS44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbjDDS4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:56:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4DC4220;
        Tue,  4 Apr 2023 11:56:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 46E2321EA4;
        Tue,  4 Apr 2023 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680634610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBVBp6XXh/4w1Cs9NPpHS5q/BvJUFc2xuxmLnBgLD0E=;
        b=LDs7Dns77Y7cz4LnfqBQxk/JHLmLxVUicagXwD6KRoT82/ts9lglkuOSFX/RvIzbQRfK9e
        jYY0lc3vOhPYr7LnItEvLtgifR+yfQjJy3dHMTq4S6MLgwXhjBbRX2FmNJ10ExQ5uClSTW
        m+HxkVrinRxyPfOvfOB0ac4UKKigXec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680634610;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBVBp6XXh/4w1Cs9NPpHS5q/BvJUFc2xuxmLnBgLD0E=;
        b=6QxzjCG51yhstrf/hmioMtRUUjdi/M7uxZo8YN1v/0Kty2b2OdW7G1GDzKYR/Uq6MehuSW
        4N4sARH2RyW0VpDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B98131391A;
        Tue,  4 Apr 2023 18:56:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h5ZvLPFyLGQ/aQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 04 Apr 2023 18:56:49 +0000
Message-ID: <a309d4e4-133d-af3c-afb9-9757b10c9d81@suse.de>
Date:   Tue, 4 Apr 2023 20:56:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 11/19] scsi: sd: handle read/write CDL timeout failures
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-12-nks@flawful.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230404182428.715140-12-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/23 20:24, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Commands using a duration limit descriptor that has limit policies set
> to a value other than 0x0 may be failed by the device if one of the
> limits are exceeded. For such commands, since the failure is the result
> of the user duration limit configuration and workload, the commands
> should not be retried and terminated immediately. Furthermore, to allow
> the user to differentiate these "soft" failures from hard errors due to
> hardware problem, a different error code than EIO should be returned.
> 
> There are 2 cases to consider:
> (1) The failure is due to a limit policy failing the command with a
> check condition sense key, that is, any limit policy other than 0xD.
> For this case, scsi_check_sense() is modified to detect failures with
> the ABORTED COMMAND sense key and the COMMAND TIMEOUT BEFORE PROCESSING
> or COMMAND TIMEOUT DURING PROCESSING or COMMAND TIMEOUT DURING
> PROCESSING DUE TO ERROR RECOVERY additional sense code. For these
> failures, a SUCCESS disposition is returned so that
> scsi_finish_command() is called to terminate the command.
> 
> (2) The failure is due to a limit policy set to 0xD, which result in the
> command being terminated with a GOOD status, COMPLETED sense key, and
> DATA CURRENTLY UNAVAILABLE additional sense code. To handle this case,
> the scsi_check_sense() is modified to return a SUCCESS disposition so
> that scsi_finish_command() is called to terminate the command.
> In addition, scsi_decide_disposition() has to be modified to see if a
> command being terminated with GOOD status has sense data.
> This is as defined in SCSI Primary Commands - 6 (SPC-6), so all
> according to spec, even if GOOD status commands were not checked before.
> 
> If scsi_check_sense() detects sense data representing a duration limit,
> scsi_check_sense() will set the newly introduced SCSI ML byte
> SCSIML_STAT_DL_TIMEOUT. This SCSI ML byte is checked in
> scsi_noretry_cmd(), so that a command that failed because of a CDL
> timeout cannot be retried. The SCSI ML byte is also checked in
> scsi_result_to_blk_status() to complete the command request with the
> BLK_STS_DURATION_LIMIT status, which result in the user seeing ETIME
> errors for the failed commands.
> 
> Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/scsi_error.c | 45 +++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/scsi_lib.c   |  4 ++++
>   drivers/scsi/scsi_priv.h  |  1 +
>   3 files changed, 50 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


