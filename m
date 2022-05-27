Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E334C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 May 2022 05:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbiE0FkF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 May 2022 01:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243642AbiE0FkC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2022 01:40:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2BAEBAB6
        for <linux-scsi@vger.kernel.org>; Thu, 26 May 2022 22:39:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B945A1F916;
        Fri, 27 May 2022 05:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653629981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wj+Ywrm5oQ1q9cP0OSSSn4YwjJY7zkDZHZjv3ApSw6A=;
        b=Xf94BBE8nGdkSx9Ca2AD3ecjHxZT3qrxxMorHCaX0mrL3FOysXngLkO2c+y7loHWRl2qde
        7dNLvb5X7caUxPzLW8IwIL03PDp3VeA/Yfx4/s86h8Oj4KJMAwVgnQAcp5zCO9+G7vEm0X
        vobWmZKgAssMqnaiz9AUIYmBHff/Wcs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653629981;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wj+Ywrm5oQ1q9cP0OSSSn4YwjJY7zkDZHZjv3ApSw6A=;
        b=rsW6Ym2S8UqiR2CP3aqPbHQ7WEQClxOrzGwD8serR6zX4SwYGs9XrdKAqqfg+Y5PE6FrFO
        5Ldgj3iSppyR+sAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DEFB1346B;
        Fri, 27 May 2022 05:39:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D6R+HR1kkGJ0fgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 27 May 2022 05:39:41 +0000
Message-ID: <b3e08c9a-675a-d1d0-cd78-36b2947acbf6@suse.de>
Date:   Fri, 27 May 2022 07:39:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 06/20] qedf: use fc rport as argument for
 qedf_initiate_tmf()
Content-Language: en-US
To:     Ewan Milne <emilne@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        James Smart <james.smart@broadcom.com>
References: <20220512111236.109851-1-hare@suse.de>
 <20220512111236.109851-7-hare@suse.de>
 <CAGtn9rkR02KF8QikQ0J6MskocA6VQ385ajoz36Q7RH32VXBjGg@mail.gmail.com>
 <86d7ebc9-bb33-7f11-1e77-38b9f855d04d@suse.de>
 <CAGtn9rk_rc0x+DdPuiZZBVFexp9s41sc0zZtB0cCBJEtBFSd2A@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAGtn9rk_rc0x+DdPuiZZBVFexp9s41sc0zZtB0cCBJEtBFSd2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/22 21:06, Ewan Milne wrote:
> Well, fc_remote_port_chkready() has in the _ONLINE and _MARGINAL case:
> 
>                  if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
>                          result = 0;
>                  else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
>                          result = DID_IMM_RETRY << 16;
>                  else
>                          result = DID_NO_CONNECT << 16;
>                  break;
> 
> which fc_block_rport() does not have.  Admittedly, I would have thought that
> the rport would be blocked while devloss was pending but there is code in
> fc_timeout_deleted_rport() that indicates otherwise, maybe this only happens
> if there is a role change.
> 
Sort of. But the code in qedf only deals with FCP target ports, so we'll 
always take the first branch and the entire code is pointless.
Am I wrong?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman
