Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F584EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 07:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbjIKHCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbjIKHCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 03:02:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70645133;
        Mon, 11 Sep 2023 00:02:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3451B1F460;
        Mon, 11 Sep 2023 07:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694415719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WYNJsDdpSSWxVUcNcP0B1ogjiS7/iSAXTyXJCTCrRo=;
        b=EXwgz2M602M36SFupFehmL/LVQ+ApYeKN9d7CvKP5mRRl5Jro2HEkB+t1/FDGloeTfiIrd
        vANf5xIeUxDJARFY+/eAuMRMhKDTr7+UIZ0kraj90fU08zK18dEKJNteRr55FOjJ6Gf1WM
        aoqTsfkGCgPWMoLe+wIayyRcInKikvM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694415719;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WYNJsDdpSSWxVUcNcP0B1ogjiS7/iSAXTyXJCTCrRo=;
        b=K9OdhEuqmmkbG2yR9CJx6IiXQmUC6u3He+mFFTbFmkpa9CuXuNZ7mIwpKGr35OIfyBSKdt
        wQ8JHX+HHU/JTcCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DE5FE13780;
        Mon, 11 Sep 2023 07:01:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WHaYNGa7/mSIUwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 07:01:58 +0000
Message-ID: <c68599b0-a855-4e7b-9664-4ddd252ef81e@suse.de>
Date:   Mon, 11 Sep 2023 09:01:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/19] ata: libata-core: Do not resume ports that have
 been runtime suspended
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
 <20230911040217.253905-16-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-16-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> The scsi disk driver does not resume disks that have been runtime
> suspended by the user. To be consistent with this behavior, do the same
> for ata ports and skip the PM request in ata_port_pm_resume() if the
> port was already runtime suspended. With this change, it is no longer
> necessary to for the PM state of the port to ACTIVE as the PM core code
> will take care of that when handling runtime resume.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-core.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
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

