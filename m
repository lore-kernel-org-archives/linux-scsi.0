Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345ECC61D9D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 20:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbjAYUDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 15:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236106AbjAYUDI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 15:03:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE1A298EF
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 12:03:06 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3A46D1FE94;
        Wed, 25 Jan 2023 20:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674676985; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uFh9bl566+ybNdNtw/MumdSVjP6L2nDslTodOi+EiWg=;
        b=VHFQTpAAUdQRMdpMxJKHb+4zKUAL4PFQTmFWspCvrpTfARER+iioEfroYzdL0iZSZxnz5/
        X4jSYLpm8KhqIeo3xtlyBHryfWK+QPeISGqYp3PFiQgerLea3etTbOREWh3MAgw5EWniuH
        vdnZu8ZKhQBk23yC7HAvvEGyiH3Fu6Y=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E7B5A1339E;
        Wed, 25 Jan 2023 20:03:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7wPHNviK0WOAdwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 25 Jan 2023 20:03:04 +0000
Message-ID: <f28ab37a5cd36476f03b63d5214cf5fb475adfca.camel@suse.com>
Subject: Re: [PATCH] scsi: core: Fix the scsi_device_put() might_sleep
 annotation
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Date:   Wed, 25 Jan 2023 21:03:04 +0100
In-Reply-To: <20230125194311.249553-1-bvanassche@acm.org>
References: <20230125194311.249553-1-bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-01-25 at 11:43 -0800, Bart Van Assche wrote:
> Although most calls of scsi_device_put() happen from non-atomic
> context,
> alua_rtpg_queue() calls this function from atomic context if
> alua_rtpg_queue() itself is called from atomic context.
> alua_rtpg_queue()
> is always called from contexts where the caller must hold at least
> one
> reference to the scsi device in question. This means that the
> reference
> taken by alua_rtpg_queue() itself can't be the last one, and thus can
> be
> dropped without entering the code path in which scsi_device_put()
> might
> actually sleep. Hence move the might_sleep() annotation from
> scsi_device_put() into scsi_device_dev_release().
>=20
> [1]
> https://lore.kernel.org/linux-scsi/b49e37d5-edfb-4c56-3eeb-62c7d5855c00@l=
inux.ibm.com/
> [2]
> https://lore.kernel.org/linux-scsi/55c35e64-a7d4-9072-46fd-e8eae6a90e96@l=
inux.ibm.com/
>=20
> Note: a significant part of the above description was written by
> Martin
> Wilck.
>=20
> Fixes: f93ed747e2c7 ("scsi: core: Release SCSI devices
> synchronously")
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Steffen Maier <maier@linux.ibm.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sachin Sant <sachinp@linux.ibm.com>
> Cc: Benjamin Block <bblock@linux.ibm.com>
> Reported-by: Steffen Maier <maier@linux.ibm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Martin Wilck <mwilck@suse.com>

