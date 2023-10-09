Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D23AE95A91
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Oct 2023 07:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345400AbjJIHwL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjJIHwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 03:52:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BCA94
        for <linux-scsi@vger.kernel.org>; Mon,  9 Oct 2023 00:52:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4023C1F38C;
        Mon,  9 Oct 2023 07:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696837925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FF4F8qZkxKLKNyPsIaWe5vPPHHI4CCsUJG/iNcr5t6Y=;
        b=IZTKMYk7smcsAMJmpF8MsqyVnX3lKgPs308TAGHBPjMFYuDUDKbSFuh2C33h2wqVJ+QqfR
        hEGI0B+k7L31URzHlIupC0XilO0asqBME28mrcBINnxhuHBK3rXXV4MimOXzojSfC5TAyW
        rtfEgqcLJXfISETYIsnidm9ISE12K6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696837925;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FF4F8qZkxKLKNyPsIaWe5vPPHHI4CCsUJG/iNcr5t6Y=;
        b=1KVCWDXxdopD7Epd9ENEJWXoriwZRIZ2jvPRJ0wPAawMEZ5KM70riwIdpn1FS3HPK4AVkT
        8a3qJQp9ZlEoHnDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E8C5A13905;
        Mon,  9 Oct 2023 07:52:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pnA0NySxI2WzLQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 09 Oct 2023 07:52:04 +0000
Message-ID: <f2b29a56-c1ea-48ea-8aac-816497d18fe9@suse.de>
Date:   Mon, 9 Oct 2023 09:52:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/18] pmcraid: select device in
 pmcraid_eh_target_reset_handler()
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002154328.43718-1-hare@suse.de>
 <20231002154328.43718-18-hare@suse.de>
 <27bf95c8-ee43-e92d-d40d-3a7a2251a566@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <27bf95c8-ee43-e92d-d40d-3a7a2251a566@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/23 14:26, John Garry wrote:
> On 02/10/2023 16:43, Hannes Reinecke wrote:
>>   static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
>>   {
>> -    scmd_printk(KERN_INFO, scmd,
>> +    struct Scsi_Host *shost = scmd->device->host;
>> +    struct scsi_device *scsi_dev = NULL, *tmp;
>> +
>> +    shost_for_each_device(tmp, shost) {
>> +        if ((tmp->channel == scmd->device->channel) &&
>> +            (tmp->id == scmd->device->id)) {
>> +            scsi_dev = tmp;
>> +            break;
> 
> If you break out of the loop, you must call scsi_device_put(sdev) - is 
> that missing?
> 
No, you are correct. Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

