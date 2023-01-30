Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73371C636D4
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 17:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbjA3RFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 12:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbjA3RFA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 12:05:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB27ADA
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 09:04:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 825D021D4E;
        Mon, 30 Jan 2023 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1675098298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Kw+ZmRhiDG/y5mSaqDRkSBDGb2kueNM5SlvkD9HF8o=;
        b=XfdXLPRJr6dfOREmI2brhfU+UVO+s1+t+lav1H3OXsuJxdGnrtU/Ndmue5BEO9l0cijxCy
        bm20Yoflt8yhvO02jz/czYlqXPjrD4Ot3fb5zEwfcFGHjz9S2BnhvdwC9AQ/Fl9p/mCzm+
        O81ysYPsBMUn+DwSyYrfCre84L/YOMs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 389CD13444;
        Mon, 30 Jan 2023 17:04:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pHD2C7r412OQQgAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 30 Jan 2023 17:04:58 +0000
Message-ID: <263c26e91250e32cd6391533860f2fe8d39940fa.camel@suse.com>
Subject: Re: [PATCH] scsi: core: Fix the scsi_device_put() might_sleep
 annotation
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Steffen Maier <maier@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Date:   Mon, 30 Jan 2023 18:04:57 +0100
In-Reply-To: <Y9d4sfc9hCydhHwb@infradead.org>
References: <20230125194311.249553-1-bvanassche@acm.org>
         <167478903314.4070509.17553562843256554477.b4-ty@oracle.com>
         <Y9d4sfc9hCydhHwb@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2023-01-29 at 23:58 -0800, Christoph Hellwig wrote:
> On Thu, Jan 26, 2023 at 10:22:12PM -0500, Martin K. Petersen wrote:
> > On Wed, 25 Jan 2023 11:43:11 -0800, Bart Van Assche wrote:
> >=20
> > > Although most calls of scsi_device_put() happen from non-atomic
> > > context,
> > > alua_rtpg_queue() calls this function from atomic context if
> > > alua_rtpg_queue() itself is called from atomic context.
> > > alua_rtpg_queue()
> > > is always called from contexts where the caller must hold at
> > > least one
> > > reference to the scsi device in question. This means that the
> > > reference
> > > taken by alua_rtpg_queue() itself can't be the last one, and thus
> > > can be
> > > dropped without entering the code path in which scsi_device_put()
> > > might
> > > actually sleep. Hence move the might_sleep() annotation from
> > > scsi_device_put() into scsi_device_dev_release().
> > >=20
> > > [...]
> >=20
> > Applied to 6.2/scsi-fixes, thanks!
>=20
> This is a really bad idea.=A0 Instead of actually catching
> scsi_device_put
> put from a wrong context all the time, it now limits to the final put
> and thus making the annotation a lot less useful.

The other idea that we discussed was this:

https://lore.kernel.org/linux-scsi/53321793-fede-f84e-260a-9d6bc0bc2b6c@acm=
.org/T/#t

That approach would still catch other wrong call contexts (i.e. from
outside the ALUA code). But it requires adding a new exported function
in scsi.c. Would you prefer that, or do you have something completely
different in mind?

Idea #3 was to use a deferred call (e.g. a workqueue) for dropping the
additional ref that had been takein in alua_rtpg_queue().

Thanks,
Martin

