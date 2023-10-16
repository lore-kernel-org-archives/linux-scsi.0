Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27A7CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 14:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjJPO60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 10:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjJPO6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 10:58:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94650AB
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 07:58:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4106621C69;
        Mon, 16 Oct 2023 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697468302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m1e3SRLhwPYT7cMgcN4q6mP85Zuhr5HIKfVilWEkDTw=;
        b=IRdDS/3tnDJ/5AlQZjPjGEnWDAVuaxesDAgrB70OwxcBpdg2oXUr21JA2drVtWmOYKQglb
        d77sidopCcYTV7CjeZOpOjIjWnZqqb3k6dcRcyXjBEFEMuee5pFovyPdrj1BODrV1mLEn2
        lQR898z1O5Ls//+an+O4wMxJmUPjoOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697468302;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m1e3SRLhwPYT7cMgcN4q6mP85Zuhr5HIKfVilWEkDTw=;
        b=dPxGJjtuz+iBaY/vG5vn/86zySWK+B4V5Z9whoSxvjtTc7OLKmMWXWmlehNl4t3wxaWuGP
        tpVtuM31OhxcJHAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E71F133B7;
        Mon, 16 Oct 2023 14:58:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IgRWAo5PLWVccQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 16 Oct 2023 14:58:22 +0000
Message-ID: <3b8c7fb0-3dd6-4f99-9f58-c1e56450167a@suse.de>
Date:   Mon, 16 Oct 2023 16:58:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/17] snic: allocate device reset command
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20231016092430.55557-1-hare@suse.de>
 <20231016092430.55557-13-hare@suse.de> <20231016133856.GF28162@lst.de>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231016133856.GF28162@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [1.07 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         RCPT_COUNT_THREE(0.00)[4];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BAYES_HAM(-1.53)[91.94%];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-0.30)[-0.304];
         NEURAL_SPAM_LONG(3.00)[1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 15:38, Christoph Hellwig wrote:
> On Mon, Oct 16, 2023 at 11:24:25AM +0200, Hannes Reinecke wrote:
>> +	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
>> +				 BLK_MQ_REQ_NOWAIT);
>> +	if (!req) {
>> +		SNIC_HOST_ERR(snic->shost,
>> +			      "Devrst: TMF busy\n");
>> +		goto dev_rst_end;
> 
> So if we fail this allocation, which can easily happen, we just fail
> the reset and escalate.  If that's fine we probably want a big fat
> comment about that here.
> 
Yes, that is precisely the intention.
If scsi_alloc_request() fails it means the we're on a quite busy system,
where _all_ requests are in error (remember, this is SCSI EH where all
commands are completed except for the failed ones).
And in that case a host reset is probably the better option.

But okay, I'll be adding a warning / comment here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

