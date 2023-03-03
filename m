Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7142BC678D4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 11:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjCCL5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 06:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCCL5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 06:57:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC95F530;
        Fri,  3 Mar 2023 03:57:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7EA3422BC1;
        Fri,  3 Mar 2023 11:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677844653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sozm/IwmKR0C29DUlDCVF+X1VjNCqo59wsCuS1B6kvo=;
        b=MthVVnKy/GK0q6fUYcI3HliqGvfc2edn81Qeu/j2/8BIzChSL1ghnQ7BPtjDXOUmLCWtiW
        sCI9iTftK6rmHPtbA/Y/BdcwiCbXf1e7Nb/ts73prYD+AFRzpIV4XjxdjfGMkT847uTbs4
        O2Z4r5D7wGEwS2I7WwPDVk7AduCWGWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677844653;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sozm/IwmKR0C29DUlDCVF+X1VjNCqo59wsCuS1B6kvo=;
        b=LNXVWAa3LJTDvx7zERGbViw99t0BNNo768r+emFj52z9WtNbKlKrE1KkcBk7jAFdpzZAFd
        hNq2uI+IRIq/DEDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A0CC1329E;
        Fri,  3 Mar 2023 11:57:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /8aBGa3gAWSYQQAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 03 Mar 2023 11:57:33 +0000
Message-ID: <ba286c08-af18-ae46-c6b1-969fc369b0df@suse.de>
Date:   Fri, 3 Mar 2023 12:57:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Khazhy Kumykov <khazhy@chromium.org>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
 <ad8b054a-26a5-ea60-9c66-4a6b63ca27ef@acm.org>
 <54fb85ac-7c45-f77f-11d7-9cb072f702fb@opensource.wdc.com>
 <569dc9d2-3e6c-0efc-560c-bfcacfbfbda7@acm.org>
 <8e3643a5-80bd-8c02-8e83-a2c1341babcc@opensource.wdc.com>
 <c719261e-203e-18f2-b72a-de0c64011efe@acm.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
In-Reply-To: <c719261e-203e-18f2-b72a-de0c64011efe@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/23 19:26, Bart Van Assche wrote:
> On 3/1/23 18:03, Damien Le Moal wrote:
>> But that is the issue: zones in the middle of each domain can be
>> activated/deactivated dynamically using zone activate command. So 
>> there is
>> always the possibility of ending up with a swiss cheese lun, full of 
>> hole of
>> unusable LBAs because the other domains (other LUN) activated some 
>> zones which
>> deactivate the equivalent zone(s) in the other domain.
>>
>> With your idea, the 2 luns would not be independent as they both would 
>> be using
>> LBAs are mapped against a single set of physical blocks. Zone activate 
>> command
>> allows controlling which domains has the mapping active. So activating 
>> a zone in
>> one domains results in the zone[s] using the same mapping in the other 
>> domain to
>> be deactivated.
> 
> Hi Damien,
> 
> Your reply made me realize that I should have provided more information. 
> What I'm proposing is the following:
> * Do not use any of the domains & realms features from ZBC-2.
> * Do not make any zones visible to the host before configuration of the 
> logical units has finished. Only make the logical units visible to the 
> host after configuration of the logical units has finished. Do not 
> support reconfiguration of the logical units while these are in use by 
> the host.
> * Only support active zones. Do not support inactive zones.
> * Introduce a new mechanism for configuring the logical units.
> 
> This is not a new idea. The approach described above is already 
> supported since considerable time by UFS devices. The provisioning 
> mechanism supported by UFS devices is defined in the UFS standard and is 
> not based on SCSI commands.
> 
That really cries out for a device-mapper target.
Providing several LUNs only make sense if the hardware supports it; 
we've learned that lesson when developing support for Multi-actuator 
HDDs. If you want to have several logical disks without hardware support 
for it device-mapper is the way to go.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

