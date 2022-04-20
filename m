Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5474CC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 12:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378393AbiDTMJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378390AbiDTMJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 08:09:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA4736B5E
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 05:06:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6C3B91F74E;
        Wed, 20 Apr 2022 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650456408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0cfp9k93YeMuDEp/nu1oTTbilCRmGGa9F3qzQHiH6LY=;
        b=XBqglc9c/A6UFq8rnSd2iTK6fTl1HPGkoQvl0QdfHSo8MUvs7JbLA7auLKPmug3fMGUiri
        NyHCcJ7hEkFmJgBXOuW6Xu68bav+lPLESy/gDpig72zZZ7qvIacuZiEAfEwV+WCdT+KziT
        uPXMezRAwt56u9XxyPEBZKquWxx//qQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650456408;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0cfp9k93YeMuDEp/nu1oTTbilCRmGGa9F3qzQHiH6LY=;
        b=g+1iuXLWN1pbiVBrMIpe7sw2gWsjB45uvEIc0Vi53RMF5aRDUa/exywgQg767bHL7E/TfZ
        772obHE0OClUDJCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 535C813A30;
        Wed, 20 Apr 2022 12:06:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UnUNElj3X2JKWgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 20 Apr 2022 12:06:48 +0000
Message-ID: <14ecedfb-a965-5862-2aff-2ea319059366@suse.de>
Date:   Wed, 20 Apr 2022 14:06:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 04/14] scsi: core: Pick suitable allocation length in
 scsi_report_opcode()
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-5-martin.petersen@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220302053559.32147-5-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/22 06:35, Martin K. Petersen wrote:
> Some devices hang when a buffer size larger than expected is passed in
> the ALLOCATION LENGTH field. For REPORT SUPPORTED OPERATION CODES we
> currently only request a single command descriptor at a time and
> therefore the actual size of the command is known ahead of time. Limit
> the ALLOCATION LENGTH to the header size plus the command length of
> the opcode we are asking about.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/scsi/scsi.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
