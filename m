Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0521BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 11:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiEXL0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 07:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiEXL0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 07:26:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC106546AB
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 04:26:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 75B7921908;
        Tue, 24 May 2022 11:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653391604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/djOyUH/q6WLbA9zAT1TP0u2AmsfZPp+4HRGU/2uFo=;
        b=aNwVGh9A0JNKWENzDwe/nceNal9YXSiNGVE5pSXPnHwCmzekghN8EQToPmNkN+7SCJh/c0
        88QlGbH1f4yJKh7hzexuyMCeov09U/B+XVcn+46GHUVFGDE3cYfBjIEUUUiBbgxM3E0K12
        PVwvpynX6UA9mpCtpqr041CQ2H6rkmI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653391604;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/djOyUH/q6WLbA9zAT1TP0u2AmsfZPp+4HRGU/2uFo=;
        b=M7sTF+tKCL5WZg0HYru0Uqq4TReRxaPsWu+jEkzopR1bJ19MsJ7u0ZfNqrKn7z5AU8wXO0
        uMysSKsJuATObXCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 36CB513ADF;
        Tue, 24 May 2022 11:26:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aPc+DPTAjGIBPQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 24 May 2022 11:26:44 +0000
Message-ID: <38b4ab27-f30f-2dd1-3238-15d4dc366268@suse.de>
Date:   Tue, 24 May 2022 13:26:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 06/16] qedf: use fc rport as argument for
 qedf_initiate_tmf()
Content-Language: en-US
To:     Steffen Maier <maier@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Saurav Kashyap <skashyap@marvell.com>
References: <20220524061602.86760-1-hare@suse.de>
 <20220524061602.86760-7-hare@suse.de>
 <8e50ff48-7ad1-29a3-23ee-48559fa79919@linux.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <8e50ff48-7ad1-29a3-23ee-48559fa79919@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/22 13:16, Steffen Maier wrote:
> On 5/24/22 08:15, Hannes Reinecke wrote:
>> When sending a TMF we're only concerned with the rport and the LUN ID,
>> so use struct fc_rport as argument for qedf_initiate_tmf().
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Cc: Saurav Kashyap <skashyap@marvell.com>
>> ---
>>   drivers/scsi/qedf/qedf.h      |  3 +-
>>   drivers/scsi/qedf/qedf_io.c   | 69 ++++++++++-------------------------
>>   drivers/scsi/qedf/qedf_main.c | 19 +++++-----
>>   3 files changed, 31 insertions(+), 60 deletions(-)
> 
> 
>> @@ -2432,33 +2425,10 @@ int qedf_initiate_tmf(struct scsi_cmnd 
>> *sc_cmd, u8 tm_flags)
>>            (tm_flags == FCP_TMF_TGT_RESET) ? "TARGET RESET" :
>>            "LUN RESET");
>>
>> -    if (qedf_priv(sc_cmd)->io_req) {
>> -        io_req = qedf_priv(sc_cmd)->io_req;
>> -        ref_cnt = kref_read(&io_req->refcount);
>> -        QEDF_ERR(NULL,
>> -             "orig io_req = %p xid = 0x%x ref_cnt = %d.\n",
>> -             io_req, io_req->xid, ref_cnt);
>> -    }
>> -
>> -    rval = fc_remote_port_chkready(rport);
>> -    if (rval) {
>> -        QEDF_ERR(NULL, "device_reset rport not ready\n");
>> -        rc = FAILED;
>> -        goto tmf_err;
>> -    }
>> -
>> -    rc = fc_block_scsi_eh(sc_cmd);
>> +    rc = fc_block_rport(rport);
> 
> 
>> diff --git a/drivers/scsi/qedf/qedf_main.c 
>> b/drivers/scsi/qedf/qedf_main.c
>> index 18dc68d577b6..85ccfbc5cd26 100644
>> --- a/drivers/scsi/qedf/qedf_main.c
>> +++ b/drivers/scsi/qedf/qedf_main.c
>> @@ -773,7 +773,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
>>           goto drop_rdata_kref;
>>       }
>>
>> -    rc = fc_block_scsi_eh(sc_cmd);
>> +    rc = fc_block_rport(rport);
>>       if (rc)
>>           goto drop_rdata_kref;
>>
> 
> Why replace the fc_block helper here in the abort handler?
> Isn't the scope of the abort hander exactly the one scsi_cmnd?
> The description of this patch is about changes to TMF (so I understand 
> the change in qedf_initiate_tmf() above for device or target reset), 
> i.e. not abort.
> Admittedly, it shouldn't be a problem functional-wise, as 
> fc_block_scsi_eh() delegates internally to fc_block_rport(), but it 
> looks odd to me nonetheless.
> 
> This change seems inconsistent with the other patches in this series.
> You don't plan to get rid of fc_block_scsi_eh(), do you?
> 
> Oh, later in patch 09 you write:
> "Use fc_block_rport() instead of fc_block_scsi_eh() as the latter
> will be deprecated."
> 
> Why?

Yeah, sorry, that is misleading. I had an earlier patchset where I tried 
to phase it out, only to find out that this is not the best of ideas.

So no worries, everything will stay as-is in that area.

Will be modifying the patch (and the description) for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
