Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81AFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 18:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbiA0SaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 13:30:18 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:33022 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbiA0SaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 13:30:17 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ECBA0210E4;
        Thu, 27 Jan 2022 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643308216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4buybw4UzacJJI2alYkIqOQF8x7BavtFLeLxphNOX6A=;
        b=KTwFTKLp+bKI0cEmxIEDvbUAaT+Wo00O/irxpO4rJ26IlP5TWMeFP/pKF5/+Y7S2l2yqWR
        +ubObx32ajsoSFwdQbdqZyfst1qlNvXfnKQLIVpt/7Y1RaOhUqG7DwxklTl9251/xO81WM
        YEW7upBxLOho5XIyGN11YENZmKy7rzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643308216;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4buybw4UzacJJI2alYkIqOQF8x7BavtFLeLxphNOX6A=;
        b=VBc9U5q3fvAC/QaAcPyMjs5GxFSaz6Q6dLz7lK2ytJO6WRaxPIGOiRDe/Ns1DLv+oanGzc
        VwoprfOt2ZYvGIDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 79D7313D4F;
        Thu, 27 Jan 2022 18:30:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IPLmGbjk8mGeOgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 27 Jan 2022 18:30:16 +0000
Message-ID: <2402a0fc-b94c-f980-2287-8aedfc2e5423@suse.de>
Date:   Thu, 27 Jan 2022 19:30:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH] scsi: make "access_state" sysfs attribute always
 visible
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220125162441.2226-1-mwilck@suse.com>
 <4aa8727e-a183-a1f9-8291-624ecb5e6d25@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <4aa8727e-a183-a1f9-8291-624ecb5e6d25@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 18:28, Bart Van Assche wrote:
> On 1/25/22 08:24, mwilck@suse.com wrote:
>> From: Martin Wilck <mwilck@suse.com>
>>
>> If a SCSI device handler module is loaded after some SCSI devices
>> have already been probed (e.g. via request_module() by dm-multipath),
>> the "access_state" and "preferred_path" sysfs attributes remain 
>> invisible for
>> these devices, although the handler is attached and live. The reason is
>> that the visibility is only checked when the sysfs attribute group is
>> first created. This results in an inconsistent user experience depending
>> on the load order of SCSI low-level drivers vs. device handler modules.
> 
> Isn't this something that should be fixed in the sysfs code rather than 
> in the SCSI core? If this issue affects SCSI I assume that it will also 
> affect other sysfs users.
> 
Urgh.
Rather not.
That particular code affects the visibility of sysfs attributes; they 
are created statically in device_add(), so it won't even be created if 
it's not visible.

Reworking that would mean a rework of the entire drivers/base code.
And not to mention a change in behaviour, as some drivers might well 
rely on the current behaviour.

But if you feel up to it ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
