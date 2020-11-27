Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2061C83011
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Nov 2020 22:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF4B2222C
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Nov 2020 22:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nl6On1uj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389484AbgK1VuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbgK0TwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2020 14:52:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AC2C08E863;
        Fri, 27 Nov 2020 11:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=euM/zmZmiU7XynopsfsNk5VEQJ/eikhYtJwXlpq8tno=; b=nl6On1ujk9wd9PEKkJgg2KJ2Am
        m8AA3an/yzFOvOzfdYyYfcRQEQMV6C+rNHKxGHpqDzm49BkSsw+5EhhU0P154qkYr9MXuNpi7PREG
        fPLa8hJsj9oN6M7qgVOHMRcPTnFhMtktGs8woTspm5p63HB4LfTCBfTY+3w6jPlLDCe5rI6brlPWe
        Wzm7YdlXRMuEt8mo+EDmAHmVkjUP3io6h5+Bil+IHytP1lZ1245P0R6S0s2IchExPIzcixOwncumC
        FhBV3gK43XgwhLQNaxt5pUzXLAu2p81YKnwCaC/q+zrjSo81jdUaUUkBqIuXwnd/oQ3fdltyGRC9o
        jz4txzgg==;
Received: from [2602:306:c5a2:a380:9e7b:efff:fe40:2b26]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kijYQ-0005Xk-FY; Fri, 27 Nov 2020 19:37:14 +0000
Subject: Re: [PATCH 1/2] ALSA: ppc: drop if block with always false condition
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Leonard Goehrs <l.goehrs@pengutronix.de>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <fdaedef8-4734-7ab3-9334-b628f8207c9e@infradead.org>
Date:   Fri, 27 Nov 2020 11:37:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Uwe,

On 11/26/20 8:59 AM, Uwe Kleine-König wrote:
> The remove callback is only called for devices that were probed
> successfully before. As the matching probe function cannot complete
> without error if dev->match_id != PS3_MATCH_ID_SOUND, we don't have to
> check this here.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

I tested your two patches plus Leonard's patch 'ALSA: ppc: remove
redundant checks in PS3 driver probe' applied to v5.9 on the PS3,
and they seem to work fine.

Thanks for both your efforts.

Tested by: Geoff Levand <geoff@infradead.org>
