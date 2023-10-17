Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8A1CDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 07:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbjJQHNv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 03:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbjJQHNu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 03:13:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C4FF3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 00:13:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3A3CA1FF0A;
        Tue, 17 Oct 2023 07:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697526826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kgzbm3sTrwSEtZmcVPfYlzDt6YIwYv1f1DxAls9H6Bw=;
        b=ZNYuRg5LcZIkIIeG2G1ZOC9urdf+rd2srfoEv0DW24uqnRklG4Pxj7H+xUsjfTftSFBCLw
        3eAflDqMGg/KNAjZNaPG/SozXfvfs17o5JDEwMpsvktQ2RSB01yia2p7Kcd2WRcTELnepz
        xhoaUwck12o8RV1fm7cS4AvGTH/M7FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697526826;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kgzbm3sTrwSEtZmcVPfYlzDt6YIwYv1f1DxAls9H6Bw=;
        b=XHx3wtxirHsB8IjxtuPP0FjxXY3icFoB0G1U1zgLnHZ1glCP80sumfw3/Q/HtWOQIVeeI0
        PSVqngFmYO+i1PDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C04313584;
        Tue, 17 Oct 2023 07:13:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iDJMASo0LmWWIgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 17 Oct 2023 07:13:46 +0000
Message-ID: <dec8f03a-7e99-464a-9e31-6aae23a445be@suse.de>
Date:   Tue, 17 Oct 2023 09:13:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] scsi: set host byte after EH completed
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20231016121542.111501-1-hare@suse.de>
 <20231016121542.111501-6-hare@suse.de>
 <de189b84-073d-45b1-b72a-8a2cca993a4c@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <de189b84-073d-45b1-b72a-8a2cca993a4c@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
        none
X-Spamd-Result: default: False [-6.90 / 50.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-2.81)[99.17%];
         MIME_GOOD(-0.10)[text/plain];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         RCPT_COUNT_FIVE(0.00)[5];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 15:59, Johannes Thumshirn wrote:
> On 16.10.23 14:16, Hannes Reinecke wrote:
>> -void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
>> +void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,
>> +			int host_byte)
>>    {
>> +	if (host_byte)
>> +		set_host_byte(scmd, host_byte);
> 
> I think the 'if' is not needed here.
> 
Actually, I prefer to keep it as passing in 'DID_OK' would _not_ modify
the status; leaving out the 'if' would always overwrite it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

