Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CE3C7EE2E
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 06:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjE3Gkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 02:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjE3Gk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 02:40:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C25E5;
        Mon, 29 May 2023 23:40:27 -0700 (PDT)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7452221ADE;
        Tue, 30 May 2023 06:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685428825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ums/OE0NoU0xPsq2lPAiBPTLNXmJTWhJx3jwHOKTFxc=;
        b=M1mgx31aI/sWrOfL1CuAF3531nz4LpBvpGp9kHfalJnsxVIRa6wamknTuqVX25ZrE3eqZs
        dUAEF1q5tVb/uNOaPnidSjltZTOeDSGdiQEjGdL9tglX6LWRSrBayQ6Fv4pKeCWMTJcoJo
        CuQCNUU2Any8KDAwqQLdSge2lNAb+OQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685428825;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ums/OE0NoU0xPsq2lPAiBPTLNXmJTWhJx3jwHOKTFxc=;
        b=SIbJna/DzUlB69l01DqRjh69SMTlfIuqf/8naSQ0XHYFWfEEhP2aP5YM2pTBHkrzbYAD/P
        dxzlCsn9VHvsJ0DQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 369491342F;
        Tue, 30 May 2023 06:40:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id PAB0C1madWSwbAAAGKfGzw
        (envelope-from <hare@suse.de>); Tue, 30 May 2023 06:40:25 +0000
Message-ID: <bbc624f1-1569-df23-5209-c30246600fac@suse.de>
Date:   Tue, 30 May 2023 08:40:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 1/5] scsi: core: Rework scsi_host_block()
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Ye Bin <yebin10@huawei.com>
References: <20230529202157.11361-1-bvanassche@acm.org>
 <20230529202157.11361-3-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230529202157.11361-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/29/23 22:21, Bart Van Assche wrote:
> Make scsi_host_block() easier to read by converting it to the widely used
> early-return style. See also commit f983622ae605 ("scsi: core: Avoid
> calling synchronize_rcu() for each device in scsi_host_block()").
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Cc: Ye Bin <yebin10@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
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

