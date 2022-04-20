Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BA9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 12:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357745AbiDTMKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345710AbiDTMKf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 08:10:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0B3D4AF
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 05:07:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D77951F380;
        Wed, 20 Apr 2022 12:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650456468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9KEoi9aQaZ5nx/RlJhpeug386NVrOUZaKKRv+4nTPzk=;
        b=FqdJZ5prFUhoIcPL6Ne3j9ia0TGksdEvlQLNW17UegFk0bqPjeIFOnAnfAZLs4Wvb16Sdb
        DlJ0zVvblawHT3davttIcnANzBrGDoJJoprmDMPW+Fsn1PSCl2irhQLIKYn2ZaXc//C44U
        h3waGF2RYSSBkbOJjEdzX2WwyuFZB38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650456468;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9KEoi9aQaZ5nx/RlJhpeug386NVrOUZaKKRv+4nTPzk=;
        b=jtjjZjkVIGS3WPaIbEE8RuId/EFlRP1oboKfqhz2wT56glq+Csw2IG/4/ekICqdQBwtb/4
        bO8WKH1iSW16OCCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B59DC13A30;
        Wed, 20 Apr 2022 12:07:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D+BaK5T3X2K7WgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 20 Apr 2022 12:07:48 +0000
Message-ID: <02ba1a4d-2bb9-5bad-985c-0324c0f7afc9@suse.de>
Date:   Wed, 20 Apr 2022 14:07:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 05/14] scsi: core: Cache VPD pages b0, b1, b2
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-6-martin.petersen@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220302053559.32147-6-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/22 06:35, Martin K. Petersen wrote:
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/scsi.c        |  6 ++++++
>   drivers/scsi/scsi_sysfs.c  | 28 ++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h |  4 ++++
>   3 files changed, 38 insertions(+)
> 
Maybe some description why these pages are important.
But otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
