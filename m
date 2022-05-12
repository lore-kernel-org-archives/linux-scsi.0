Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB64C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 09:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352264AbiELJvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 05:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352281AbiELJvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 05:51:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E92630F40
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 02:51:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D35FC1F8C9;
        Thu, 12 May 2022 09:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652349064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8JKMZ7rtPzj0GKKOUxhrwM/+Icn0awrpmJJtaPt0UVg=;
        b=nqgfjFIS0gDGADGY8IikP5OT9fYKQCQ0/Xhjqk3lkbK7oH96j8koYx9GGBpFlJqPrJqW14
        /qKnLD/473SXuVUoibkBQ7aq6KoCcMIf8rpiA5T4rGHAWW4EGZb5yzpyW4rUbnzG6/AFY+
        tGxHUZcOsWAKQHhXIkKmduJI1QGUXAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652349064;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8JKMZ7rtPzj0GKKOUxhrwM/+Icn0awrpmJJtaPt0UVg=;
        b=Ic9xdIKp05LfFYexnjm5n+cRwzFNnVuvZXlN8WhghoT4W3a4VGxyVPAikfxC0fHMNRnL1k
        vwMhsf8kyuiGWFBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD21813A84;
        Thu, 12 May 2022 09:51:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6RgcKIjYfGJiPwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 12 May 2022 09:51:04 +0000
Message-ID: <a5aa7d9e-e261-60d0-f0a8-0c1b9d6f7730@suse.de>
Date:   Thu, 12 May 2022 11:51:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 3/4] lpfc: rework lpfc_vmid_get_appid() to be protocol
 independent
Content-Language: en-US
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
 <20220510200028.37399-4-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220510200028.37399-4-jsmart2021@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/22 22:00, James Smart wrote:
> Rework lpfc_vmid_get_appid() arguments to remove scsi cmd dependency.
> It's now callable by nvme path.
> 
> Fixup scsi calling path for arg change.
> 
> Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_crtn.h | 5 +++--
>   drivers/scsi/lpfc/lpfc_scsi.c | 7 ++++---
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
