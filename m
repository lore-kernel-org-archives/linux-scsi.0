Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4B9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 09:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbiBNJwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 04:52:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344866AbiBNJwF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 04:52:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB577B550
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 01:43:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B62E1F38A;
        Mon, 14 Feb 2022 09:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644831801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I32KPWWSnwx5gWPR+YozzFXlQtnJbnmEsSu5cWJgdeU=;
        b=rp+kVRs7cQAP2CVNmqHovemmsn4pHfjcWUvwChn3opMaHd6DypnmlB+1WLeDXDcRpr48r+
        ZA2jsMBPZnODK4ZUophCZ57bSqDA8icJkONZDZlUF6JmWIU/KsASm+Wa5LcPOfpLLtB+Gi
        XCp9ZMxhbeClqCWB1pzOgOcwwSh5BfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644831801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I32KPWWSnwx5gWPR+YozzFXlQtnJbnmEsSu5cWJgdeU=;
        b=cHbgmwcXWJvlArZ9pi7dY19Jggf6z1pqyiydTAScElud9OK9bGkeldR9HWHZIx9Gg5S8B8
        JOnZRzDHx9aTy8Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38B9C13A3C;
        Mon, 14 Feb 2022 09:43:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TsHtAzkkCmLELAAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Feb 2022 09:43:21 +0000
Message-ID: <107d0c5d-bc81-8177-afd1-2901c5d4b3fe@suse.de>
Date:   Mon, 14 Feb 2022 10:43:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 02/48] scsi: ips: Change the return type of
 ips_release() into 'void'
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-3-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220211223247.14369-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 23:32, Bart Van Assche wrote:
> ips_release() has one caller and that caller ignores the value returned by
> ips_release(). Hence change the return type of that function into 'void'.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ips.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
Nit: could be merged with the previous patch.
But nothing critical, and can be done in the next version (if such a 
thing is necessary).

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
