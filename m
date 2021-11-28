Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D32C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Nov 2021 13:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbhK1NKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Nov 2021 08:10:30 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:54316 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbhK1NIa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Nov 2021 08:08:30 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9740C1FCA1;
        Sun, 28 Nov 2021 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638104713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kRP5vJGGtoT2cM/U9OER82Oftwh/FqbbEJ302dxkTmI=;
        b=Ej8rSn20on3JbCSCGCOyD+te3ByQtO1pm1YVhtEfDOemtzg3Rof7dUan35VOJ71ECUdI/1
        uc5w25EkF1HCHIs/ERxB4cif3cb76PI+/gyFY9wMUaQISZKIh9fv9uNfCuYT+gkPcWLbdQ
        wYZbJOBCqjNiwDbaUECMZHRDzls4YKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638104713;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kRP5vJGGtoT2cM/U9OER82Oftwh/FqbbEJ302dxkTmI=;
        b=Nm9hfNZHIj9NWVYNXqGLj66G2IUfK7UjnKpWKWWIb47xBQYi4uHOnaHgThGG0pGf2j6tLJ
        /S3061Lj1EGU4bDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 693CE133FE;
        Sun, 28 Nov 2021 13:05:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1Ye9F4l+o2FAcAAAMHmgww
        (envelope-from <hare@suse.de>); Sun, 28 Nov 2021 13:05:13 +0000
Subject: Re: [PATCH 02/15] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-3-hare@suse.de>
 <abdf4383-23d7-d569-5aa8-92f3e3f12409@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1e20674d-a272-a207-ac5f-a6bbed31dcbe@suse.de>
Date:   Sun, 28 Nov 2021 14:05:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <abdf4383-23d7-d569-5aa8-92f3e3f12409@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/28/21 4:33 AM, Bart Van Assche wrote:
> On 11/25/21 07:10, Hannes Reinecke wrote:
>> Add helper functions to allow LLDDs to allocate and free
>> internal commands.
> 
> Are the changes for the SCSI timeout handler perhaps missing from this 
> patch? In the UFS driver we need the ability not to trigger the SCSI 
> error handler if an internal command times out.
> 
It's based on 5.17/scsi-queue; so if the SCSI timeout handler changes 
are not present in there I won't have it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
