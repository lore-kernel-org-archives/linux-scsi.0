Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58222C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 12:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35436611AD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 12:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhFGMXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 08:23:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39336 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGMXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 08:23:11 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6FA4421A55;
        Mon,  7 Jun 2021 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623068479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTv8FvJGAe9i/xxqhZQp7RC1AYnLq1iec/GdVNOwfQ8=;
        b=1QGMerz6oqNteEpMkNpD/hAUc/Kyk91hsYzCzUjG8Ekd19iRihhawctp6olv2p+8oZ/uC8
        pp4/TVVmG+RWKVZo8lqPOlM5MsLMLc7xHpOKFM6WSemlQt8cB0h1B6Hw63XjVXJNFSCpBY
        5TVPXbv1INQqSDYvQJwIRLolQgR0Mx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623068479;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTv8FvJGAe9i/xxqhZQp7RC1AYnLq1iec/GdVNOwfQ8=;
        b=QjOagOB9aH69OoFWPwsEdRexkFO9uzorD1dC0Oarl0Si7/faxkyxMZEL7OTLoAeqR6f+r9
        VeQsNVEPn4A0RrBg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 40E79118DD;
        Mon,  7 Jun 2021 12:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623068479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTv8FvJGAe9i/xxqhZQp7RC1AYnLq1iec/GdVNOwfQ8=;
        b=1QGMerz6oqNteEpMkNpD/hAUc/Kyk91hsYzCzUjG8Ekd19iRihhawctp6olv2p+8oZ/uC8
        pp4/TVVmG+RWKVZo8lqPOlM5MsLMLc7xHpOKFM6WSemlQt8cB0h1B6Hw63XjVXJNFSCpBY
        5TVPXbv1INQqSDYvQJwIRLolQgR0Mx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623068479;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTv8FvJGAe9i/xxqhZQp7RC1AYnLq1iec/GdVNOwfQ8=;
        b=QjOagOB9aH69OoFWPwsEdRexkFO9uzorD1dC0Oarl0Si7/faxkyxMZEL7OTLoAeqR6f+r9
        VeQsNVEPn4A0RrBg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id w9qUDT8PvmDFdwAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 12:21:19 +0000
To:     Jiri Slaby <jirislaby@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
Message-ID: <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
Date:   Mon, 7 Jun 2021 14:21:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/21 8:40 AM, Jiri Slaby wrote:
> Hi,
> 
> On 21. 10. 19, 11:53, Hannes Reinecke wrote:
>> Replace the check for DRIVER_SENSE with a check for
>> SAM_STAT_CHECK_CONDITION and audit all callsites to
>> ensure the SAM status is set correctly.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
> ...
>>   drivers/scsi/virtio_scsi.c                  |  3 +-
> 
> A bisection says that this patch breaks virto_scsi for me. The (virtual)
> disk is not found by the kernel.
> 
> GOOD:
> scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK    2.5+ PQ: 0
> ANSI: 5
> 
> BAD:
> scsi 0:0:0:0: Power-on or device reset occurred
> 
> I cannot revert the patch on the top of -next as there are conflicts...
> 
> Any ideas?
> Can you enable SCSI logging via

scsi.scsi_logging_level=216

on the kernel commandline and send me the output?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
