Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04EFC47095
	for <linux-scsi@archiver.kernel.org>; Sun, 30 May 2021 08:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 849B0611AB
	for <linux-scsi@archiver.kernel.org>; Sun, 30 May 2021 08:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhE3IL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 May 2021 04:11:59 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37770 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3IL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 May 2021 04:11:58 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 56B2921918;
        Sun, 30 May 2021 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622362220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Xb2DkGsSALc5EaPomznF8PNBm5nIHOVIb5pHgAgX3E=;
        b=GqoIkCoynUNAchwmxwJjNBq/EAIHmHxM3sTCZ4JLL7x/ZzFobgAXBGUzBpAoPwEjGU+hut
        BBWHRjj8faecidTOLkaq+1iByayAd3tOxAfbXi/WgOS7waalSYQs/OaLUq/PgTjRVcK+Qh
        R49riZ5DGxDqoq8EX1RuQdnFSj1rXKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622362220;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Xb2DkGsSALc5EaPomznF8PNBm5nIHOVIb5pHgAgX3E=;
        b=l3JZiyleX6r5f+m0hy9iGUQ0srmLuJkQMnF6Fp9ZyB/503N9C1N11USLHZhOPmvFmYCFc6
        YhBeb8IP0OiEzMDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BF31E118DD;
        Sun, 30 May 2021 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622362218; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Xb2DkGsSALc5EaPomznF8PNBm5nIHOVIb5pHgAgX3E=;
        b=lM9ODM1iviPy7sLpXd8bVbPyqwbjsSvJplaIfrLINjEkKDQDvfNEjwx6A7bmcfSGkhoUJw
        v+AfEyu2pLSb7x+deYW8DT2TeXalglz6FfQjf/8HujxFX6IM4yPiiASFoRo1l9/PAPBlvs
        ZCr5NOReWGsaUH3lEjY6sIwF7PEtr10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622362218;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Xb2DkGsSALc5EaPomznF8PNBm5nIHOVIb5pHgAgX3E=;
        b=HzcCmDtrZDqVRe+DTEBd/TAP8ItCS6vbCCFOK+m8zxFthnY9aJ6LJMEUcJZqV0/5Q31Kpx
        d46hyB+dG/PVzFDg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id foI4LWpIs2AoTwAALh3uQQ
        (envelope-from <hare@suse.de>); Sun, 30 May 2021 08:10:18 +0000
Subject: Re: [PATCH] SCSI: FlashPoint: rename si_flags field
To:     Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Khalid Aziz <khalid@gonehiking.org>
References: <20210529234857.6870-1-rdunlap@infradead.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b631c661-44fa-57f5-6540-1721f3df61e8@suse.de>
Date:   Sun, 30 May 2021 10:10:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210529234857.6870-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Authentication-Results: imap.suse.de;
        none
X-Spamd-Result: default: False [0.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCPT_COUNT_SEVEN(0.00)[9];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/30/21 1:48 AM, Randy Dunlap wrote:
> The BusLogic driver has build errors on ia64 due to a name collision
> (in the #included FlashPoint.c file).
> Rename the struct field in struct sccb_mgr_info from si_flags to
> si_mflags (manager flags) to mend the build.
> 
> This is the first problem. There are 50+ others after this one:
> 
> In file included from ../include/uapi/linux/signal.h:6,
>                   from ../include/linux/signal_types.h:10,
>                   from ../include/linux/sched.h:29,
>                   from ../include/linux/hardirq.h:9,
>                   from ../include/linux/interrupt.h:11,
>                   from ../drivers/scsi/BusLogic.c:27:
> ../arch/ia64/include/uapi/asm/siginfo.h:15:27: error: expected ':', ',', ';', '}' or '__attribute__' before '.' token
>     15 | #define si_flags _sifields._sigfault._flags
>        |                           ^
> ../drivers/scsi/FlashPoint.c:43:6: note: in expansion of macro 'si_flags'
>     43 |  u16 si_flags;
>        |      ^~~~~~~~
> In file included from ../drivers/scsi/BusLogic.c:51:
> ../drivers/scsi/FlashPoint.c: In function 'FlashPoint_ProbeHostAdapter':
> ../drivers/scsi/FlashPoint.c:1076:11: error: 'struct sccb_mgr_info' has no member named '_sifields'
>   1076 |  pCardInfo->si_flags = 0x0000;
>        |           ^~
> ../drivers/scsi/FlashPoint.c:1079:12: error: 'struct sccb_mgr_info' has no member named '_sifields'
> 
> Fixes: 391e2f25601e ("[SCSI] BusLogic: Port driver to 64-bit.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Khalid Aziz <khalid.aziz@oracle.com>
> Cc: Khalid Aziz <khalid@gonehiking.org>
> ---
>   drivers/scsi/FlashPoint.c |   32 ++++++++++++++++----------------
>   1 file changed, 16 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
