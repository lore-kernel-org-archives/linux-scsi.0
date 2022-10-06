Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F7AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 07:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiJFHfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 03:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiJFHfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 03:35:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22080BF5;
        Thu,  6 Oct 2022 00:35:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 59D59219D5;
        Thu,  6 Oct 2022 07:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665041737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O8DbckLKl3ACIgeTMPkNYKhRb5hT2FKBqtCkFzH0OmA=;
        b=D95DDKCOB9bfu/h7JUqbVof3gfEnYT27zOvbt8tG2A04GpZOdBhopjFqcJxLUJM1BRjDKk
        6vvEsU2DHuIlUyrDICncimwF3LKHJHReGPTQMd/XDYU8FzfUeSZSM0VGnaslsbhHft7/5A
        DxLOxj9c9c4NbFSYE4PJBgT0HPLcpxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665041737;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O8DbckLKl3ACIgeTMPkNYKhRb5hT2FKBqtCkFzH0OmA=;
        b=zVQ7ZDbAGQTku4btQl+NxejdKdg01ZylkLBedGivds8G+HqRyvqhuTN79JVmvGi4NrL1wX
        RAG+KbZRuJaKpOBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2123613AC8;
        Thu,  6 Oct 2022 07:35:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5Vd5BkmFPmOGHAAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 06 Oct 2022 07:35:37 +0000
Message-ID: <6c1f12d2-9211-85ef-dfd5-e091ea1559d7@suse.de>
Date:   Thu, 6 Oct 2022 09:35:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
To:     Brian King <brking@linux.vnet.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
 <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
 <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
 <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <5f2efa8a-8207-403c-12e8-74f43d8d8a14@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/22 19:20, Brian King wrote:
> On 9/20/22 8:07 AM, John Garry wrote:
>> On 21/06/2022 23:12, Damien Le Moal wrote:
>>>>> We still need it around for now. IBM still sells these adapters
>>>>> and they can still be ordered even on our latest Power 10 systems.
>>>> At one point I did look into modifying ipr to use an ->error_handler.
>>>> I recall I ran into some issues that resulted in this getting put
>>>> on the shelf, but its been a while. I'll go dig that code up and
>>>> see what it looks like.
>>> Thanks. It would be really great if you can convert to using
>>> error_handler. This is really the last ata/libsas driver that does not use
>>> this.
>>>
>>
>> Hi Brian,
>>
>> I am wondering if there is any update here?
>>
>> As you may have seen in [0], I think that we need to make progress on this topic first to keep the solution there a bit simpler.
>>
>> [0] https://lore.kernel.org/linux-scsi/1663669630-21333-1-git-send-email-john.garry@huawei.com/T/#mf890cb4f1627112652831524dca62cbde4a0a637
> 
> I've made some progress. I was able to dig up the code to move ipr to use error_handler
> and have gotten it to compile, but haven't gotten to trying it in the lab yet.
> 
Hmm. In which machines can I find an IPR installed? I could go hunting 
in our lab, maybe I can locate one and aid testing/development ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

