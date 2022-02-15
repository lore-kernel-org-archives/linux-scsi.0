Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A298C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 07:02:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiBOHDD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 02:03:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiBOHDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 02:03:02 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D3D7667
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 23:02:50 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 98AF2210FC;
        Tue, 15 Feb 2022 07:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644908569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zY+DjQgvW8GS7mOrHZJonC3dQx9/TIO0qVX6hKN/f/U=;
        b=A5ZESLK9ZGFVTaivcPnTsUrAQZdDTpK5ETb1qwjs7N1gBENuxsCzdWCMUryP6JGkOtWjRw
        iTscDh7xwJQIrdkXWaErABq4IAz7MCuERmfuXojlt32vRx76d/933Ed31u/rbMbzuIGXOk
        2MACPKYXl5GYSMK5Bg09hZ+2TyJwRiI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644908569;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zY+DjQgvW8GS7mOrHZJonC3dQx9/TIO0qVX6hKN/f/U=;
        b=Gx7WY9dqo4PdI9GP32iX7fPpQYqo15fMm17NBJ+9np7WbcqOrX1Y5Fvs7J7W5nf4Hen9Vw
        D0n2n8XY6s16NcDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 135D71351D;
        Tue, 15 Feb 2022 07:02:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id n1cMBBlQC2L0OQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 15 Feb 2022 07:02:49 +0000
Message-ID: <21707ef4-58f7-4036-3792-bdb842f1f8d4@suse.de>
Date:   Tue, 15 Feb 2022 08:02:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 28/48] scsi: libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-29-bvanassche@acm.org>
 <2b079541-4333-535f-3f20-abb3feca85da@suse.de>
 <09dae05e-3e53-cd31-1538-9a715ca16774@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <09dae05e-3e53-cd31-1538-9a715ca16774@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 04:00, Bart Van Assche wrote:
> On 2/14/22 03:55, Hannes Reinecke wrote:
>> I had a closer look at the usage of SCp.ptr in the various FCoE 
>> drivers, and it turns out that all have their own private use of SCp.ptr.
>> The only 'generic' use of SCp.ptr (where it points to 'struct 
>> libfc_cmd_priv') is in fcoe/fcoe.c.
>> For the others (bnx2fc, qedf, and fnic) they point to their own, 
>> private, data structure, and there's no overlap with libfc itself.
>> So no need to have a combined structure, and each driver should use
>> their own data structure only.
>> (IE bnx2fc_priv should just have the 'bnx2fc_cmd' pointer).
> 
> How about splitting this patch into the three patches below?
> 
> Thanks,
> 
> Bart.
> 
[ .. ]

Yes, this is what I had in mind.
Although you can kill the 'status' field for bnx2fc; it's only ever set 
and never read.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
