Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B00C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 06:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AD161284
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 06:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhKKG45 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 01:56:57 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58784 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhKKG45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 01:56:57 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CFF6A1FD39;
        Thu, 11 Nov 2021 06:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636613647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RPOH6bWfkgS1VX/Jdk8Xe5WLGpb1gLMABmi83XGjnhY=;
        b=mEv7lsYJQ2zx0OWPiBcesOx9zQp9YT2Yjl+YkNe87hT3in2Bxiek+EW/EkhlfNMDUNAj6o
        Mlk4+baWuqhLNoas4FCxu+3d/2OGvpG2XTwO6qbDRahfFcxg5BD/S8Q1YXz1YzIhhtbwfW
        IkIqiJHFjaXc1Ppk9rm8Rvs+OP10AqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636613647;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RPOH6bWfkgS1VX/Jdk8Xe5WLGpb1gLMABmi83XGjnhY=;
        b=l5iCsjMFMF5t/C9O4HlyofkCp1Kz3TRM0zlQLPY770LCdJPTqWDcGEgzBR5s6PN5Qd2Nvw
        5CXzTAh+RhUFUZBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A4F5313D4F;
        Thu, 11 Nov 2021 06:54:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TDn0Jg++jGH3JgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 11 Nov 2021 06:54:07 +0000
Subject: Re: [PATCH 1/2] scsi: core: Add support for reserved tags
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-2-bvanassche@acm.org>
 <139e5cb6-c91e-fa64-f261-6359b6abe376@suse.de>
 <57aa04ba-edd5-93b9-4e0d-2fda4ccbe975@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7f778b12-fe9b-f685-30f4-1c9f2ecdd571@suse.de>
Date:   Thu, 11 Nov 2021 07:54:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <57aa04ba-edd5-93b9-4e0d-2fda4ccbe975@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/21 8:19 PM, Bart Van Assche wrote:
> On 11/9/21 10:59 PM, Hannes Reinecke wrote:
>> This is essentially the same patch as I posted a while ago (cf 
>> https://lore.kernel.org/linux-scsi/20210222132405.91369-1- 
>> hare@suse.de/).
>>
>> But there had been push-back on that series as it would also try to 
>> use a scsi host device for driver-internal commands.
>>
>> Maybe we should combine our efforts; patch 2 is equivalent to your 
>> patch, and 3-5 are a conversion of the fnic driver to use those 
>> commands. So we should merge our efforts to get this thing off the 
>> ground.
>>
>> For the remainder of the patchset I'm currently working on a solution 
>> to address the upstream concerns.
> 
> Hi Hannes,
> 
> In the UFS driver we are using a request queue that is not associated 
> with any SCSI device for allocating driver-internal tags from the same 
> tags space as SCSI commands. Is this a solution that is generic enough 
> to be re-used by other SCSI drivers? See also the output of git grep -nH 
> 'hba->cmd_queue'.
> 
Ah. Even easier.
I've made a prototype for this kind of operation in
git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
branch scsi-internal.v1

That introduces a function 'scsi_host_get_internal_tag()'
to retrieve a tag from the reserved pool of the host tagset.
Would that work for you?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
