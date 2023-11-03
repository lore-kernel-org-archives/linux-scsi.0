Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC4AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Nov 2023 20:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376881AbjKCUaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Nov 2023 16:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjKCUae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2023 16:30:34 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 69938D48
        for <linux-scsi@vger.kernel.org>; Fri,  3 Nov 2023 13:30:30 -0700 (PDT)
Received: (qmail 862000 invoked by uid 1000); 3 Nov 2023 16:30:29 -0400
Date:   Fri, 3 Nov 2023 16:30:29 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        oneukum@suse.com
Subject: Re: [PATCH v5] usb-storage,uas: use host helper to generate driver
 info
Message-ID: <d26c884e-3505-436f-9a76-ec701fb5e2bb@rowland.harvard.edu>
References: <20231028174145.691523-1-gmazyland@gmail.com>
 <20231103201709.124372-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103201709.124372-1-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 03, 2023 at 09:17:09PM +0100, Milan Broz wrote:
> The USB mass storage quirks flags can be stored in driver_info in
> a 32-bit integer (unsigned long on 32-bit platforms).
> As this attribute cannot be enlarged, we need to use some form
> of translation of 64-bit quirk bits.
> 
> This problem was discussed on the USB list
> https://lore.kernel.org/linux-usb/f9e8acb5-32d5-4a30-859f-d4336a86b31a@gmail.com/
> 
> The initial solution to use a static array extensively increased the size
> of the kernel module, so I decided to try the second suggested solution:
> generate a table by host-compiled program and use bit 31 to indicate
> that the value is an index, not the actual value.
> 
> This patch adds a host-compiled program that processes unusual_devs.h
> (and unusual_uas.h) and generates files usb-ids.c and usb-ids-uas.c
> (for pre-processed USB device table with 32-bit device info).
> These files also contain a generated translation table for driver_info
> to 64-bit values.
> 
> The translation function is used only in usb-storage and uas modules; all
> other USB storage modules store flags directly, using only 32-bit flags.
> 
> For 64-bit platforms, where unsigned long is 64-bit, we do not need to
> convert quirk flags to 32-bit index; the translation function there uses
> flags directly.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
