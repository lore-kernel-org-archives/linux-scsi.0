Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A75CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 08:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjJMIzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 04:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjJMIzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 04:55:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0399DC9;
        Fri, 13 Oct 2023 01:54:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 12F34219C8;
        Fri, 13 Oct 2023 08:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697187297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bSZO1kPM9lPaXy1xWBoUSWAeqCn6Y/mYv2Cx0QW4GII=;
        b=AajSiYTj/WaigpxrJWQ+KGiwEc0OJzZvqI9Q/T6+arm9m212NbMBGk2gzRkBATJwapymNn
        k/iCiZmH91sofCr5K4Qq4Fb/8EfWADhwVDaTcnH7wElXzUDOvZB37chRV1rGWi6NB9OzVG
        PgNKcmMQTMl470hIUZn1Cu3rtdSPvKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697187297;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bSZO1kPM9lPaXy1xWBoUSWAeqCn6Y/mYv2Cx0QW4GII=;
        b=QVPJLmwkB8i8yQDjirQJrlCCg2MYA5kGtqKgka9aNEyr6h9r1EfUit+KERv6mZbKLtvPMx
        VCrCfhQcfKvLwZCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D2FA7138EF;
        Fri, 13 Oct 2023 08:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KqB5MuAFKWXIAgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Oct 2023 08:54:56 +0000
Message-ID: <bed3f2d9-362a-40f7-802d-172f1e32bde5@suse.de>
Date:   Fri, 13 Oct 2023 10:54:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] Add support for Bayhub SD/MMC controller
To:     liuchang_125125@163.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     mark.tao@bayhubtech.com, shaper.liu@bayhubtech.com,
        thomas.hu@bayhubtech.com, chevron.li@bayhubtech.com,
        charl.liu@bayhubtech.com
References: <20231013083242.10227-1-liuchang_125125@163.com>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20231013083242.10227-1-liuchang_125125@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [-8.25 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[163.com];
         MIME_GOOD(-0.10)[text/plain];
         TO_DN_NONE(0.00)[];
         REPLY(-4.00)[];
         BAYES_HAM(-0.16)[69.52%];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_SEVEN(0.00)[10];
         FREEMAIL_TO(0.00)[163.com,linux.ibm.com,oracle.com,vger.kernel.org];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/23 10:32, liuchang_125125@163.com wrote:
> From: Charl Liu <liuchang_125125@163.com>
> 
> The Bayhub's SD/MMC Card interface driver implements card detection,
> card initialization, and other application level functions. The whole
> project is divided into 9 patches to commit. Patch [1/9] and patch
> [2/9] commit the Kconfig and Makefile, and the other code is divided
> into 7 patches (patch [3/9] to patch [9/9]) by function.
> 
Errm.

We have a perfectly fine MMC subsystem under drivers/mmc.
And I would have expected any new SD/MMC card drivers to be
implemented there.

Why do you think a SCSI driver is the right model here?

Cheers,

Hannes

