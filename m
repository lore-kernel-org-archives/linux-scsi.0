Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D70C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2FB60C3E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhHSHQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 03:16:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34248 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbhHSHQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 03:16:18 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BE0FD200A2;
        Thu, 19 Aug 2021 07:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629357339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Iz4lmVJsmpO15/jUHpIZ+2CMi2qJPu473/e7qC0rLs=;
        b=GbTGGorH/o+/SAOCKk3zwImIbEnicKR/PapPVmj5KUsr0tl3oYUQq3JSWu1gG2cKQu8B8A
        3yA73gfDgbZ6Pz9g1eIK1D5WLiNh7wFLQXonZmSiGG7bwooGMrgUH43tOrIe2RbMEEiKL+
        T1NSCWJYhwxqd7Gd9V8mZw4Q7Vcni9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629357339;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Iz4lmVJsmpO15/jUHpIZ+2CMi2qJPu473/e7qC0rLs=;
        b=SOHSLHy0Xp64AsaepK9I+vh8p2Djc9frDJkjABR/p2jxaGWXY/Q3HIDFgvbl+jsxyRev5H
        6dcW5RNzzS/+L2DQ==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 78B8A136B1;
        Thu, 19 Aug 2021 07:15:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id HBmyGxsFHmHyKQAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 19 Aug 2021 07:15:39 +0000
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
To:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
 <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com>
 <e0d7ba32-2999-794e-2ccb-fdba2c847eb1@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <038ec0c6-92c9-0f2a-7d81-afb91b8343af@suse.de>
Date:   Thu, 19 Aug 2021 09:15:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e0d7ba32-2999-794e-2ccb-fdba2c847eb1@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Bart,

Thanks for this!
Really helpful.

Just a tiny wee snag:

On 8/19/21 4:41 AM, Bart Van Assche wrote:
> On 8/18/21 11:08 AM, John Garry wrote:
>> Or maybe you or Bart have a better idea?
> 
> This is how I test compilation of SCSI drivers on a SUSE system (only
> the cross-compilation prefix is distro specific):
> 
>      # Acorn RiscPC
>      make ARCH=arm xconfig
>      # Select the RiscPC architecture (ARCH_RPC)
>      make -j9 ARCH=arm CROSS_COMPILE=arm-suse-linux-gnueabi- </dev/null
> 

Acorn RiscPC is ARMv3, which sadly isn't supported anymore with gcc9.
So for compilation I had to modify Kconfig to select ARMv4:

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 8355c3895894..22ec9e275335 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -278,7 +278,7 @@ config CPU_ARM1026
  # SA110
  config CPU_SA110
         bool
-       select CPU_32v3 if ARCH_RPC
+       select CPU_32v4 if ARCH_RPC
         select CPU_32v4 if !ARCH_RPC
         select CPU_ABRT_EV4
         select CPU_CACHE_V4WB

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
