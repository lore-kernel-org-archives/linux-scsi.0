Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F1FCDB474
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 06:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345092AbjJTGSZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 02:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjJTGSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 02:18:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAFBD46
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 23:18:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DD1FA21A58;
        Fri, 20 Oct 2023 06:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697782699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIUqYIzcjBt4HOVemEDP0e0swY+no4Sai+1kQky1opA=;
        b=zv9NtsT9FTjeKT0shDnBp4aj4lYcvpVtlnCKPzbYa0lxKCIA6RVj1g8q1n8xHK3dMVa+Rs
        oFeJFUrprSfUiSQUBjiuAw6MJzFCOyLAWiNqcT57vHBi6KiGZYUvdvYszy+Zb4iIfc3l4p
        bD/48GRoI9IzzRngGgJoDZ5UkcACKhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697782699;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIUqYIzcjBt4HOVemEDP0e0swY+no4Sai+1kQky1opA=;
        b=MPsseKTAIjss9tTVY4foSiC2QXgG2+aBXjODxA6T9LgB8u94gDNsZAwtEL2Gqm21vhZfcl
        bT5AIb61o6ThErDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE3F2138E2;
        Fri, 20 Oct 2023 06:18:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +7gwJ6sbMmUNbwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 20 Oct 2023 06:18:19 +0000
Message-ID: <069d306a-adc1-4582-a42f-9fc15a050cfe@suse.de>
Date:   Fri, 20 Oct 2023 08:18:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/16] zfcp: do not wait for rports to become unblocked
 after host reset
Content-Language: en-US
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>
References: <20231017100729.123506-1-hare@suse.de>
 <20231017100729.123506-2-hare@suse.de>
 <20231019174426.GA1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231019174426.GA1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-7.09 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         RCPT_COUNT_FIVE(0.00)[6];
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

On 10/19/23 19:44, Benjamin Block wrote:
> Hey Hannes,
> 
> On Tue, Oct 17, 2023 at 12:07:14PM +0200, Hannes Reinecke wrote:
>> zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
>> wait for all rports to become unblocked after host reset.
>> But after host reset it might happen that the port is gone, hence
>> fc_block_rport() might fail due to a missing port.
>> But that's a perfectly legal operation; on FC remote ports might
>> come and go.
>> So this patch removes the call to fc_block_rport() after host
>> reset. But with that rports may still be in blocked state after
>> host reset, so we need to return FAST_IO_FAIL from host reset
>> to avoid SCSI EH to fail commands prematurely if the rports
>> are still blocked.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Cc: Steffen Maier <maier@linux.ibm.com
>> Cc: Benjamin Block <bblock@linux.ibm.com>
>> ---
>>   drivers/s390/scsi/zfcp_scsi.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
>> index b2a8cd792266..b1df853e6f66 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -375,7 +375,7 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
>>   {
>>   	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
>>   	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
>> -	int ret = SUCCESS, fc_ret;
>> +	int ret = FAST_IO_FAIL;
> 
> One thing I noticed, `scsi_ioctl_reset()` doesn't handle FAST_IO_FAIL at all;
> it just considers that a failure, and returns EIO to userspace. I wonder if
> this is appropriate after what we've discussed. In our case FAST_IO_FAIL
> doesn't mean the host reset failed.
> 
Hmm. Indeed, that is not quite correct. EIO indicates an IO error, 
whereas FAST_IO_FAIL signal more something like 'operation in progress, 
couldn't complete in time'. So I guess EAGAIN is more appropriate here.

> I don't think we need to adapt this patch for that - couldn't really - but
> maybe there should be an extra change for that. Not exactly sure what even
> uses that IOCTL interface, and how it'd react to an EIO.
> 
Yes, we should be fixing that one. After all, FAST_IO_FAIL is a 
perfectly legit return value for the EH functions, and we should
be handling it properly.

Will be adding a patch for it.
Thanks for the heads-up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

