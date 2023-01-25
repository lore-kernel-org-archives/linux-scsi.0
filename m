Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98CCC54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 08:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbjAYISZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 03:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbjAYISY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 03:18:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4696E2ED66
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 00:18:23 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DD7CD21BDA;
        Wed, 25 Jan 2023 08:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674634701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SRzDzfJSDT/tRETR5mvBHwAZ8tlXy9+v/rnx4xMM/Y=;
        b=AvI7Vltz6j2dti7hkwZ+mDmbylEPrTRzJ5FgQ1LJyQMiMOQ8ULzIbw6gF9Q89HshAwXkKc
        WWGyv+d/Wg0fRWGSEDvwJgODjhl9i6Oy69WJ3BlSMMRoly4Wk8OE2zYXiHRnYUZL/hOgYN
        PnSBLiyBf6uwm9aeTmNvIaoA1+dLDso=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9197A1339E;
        Wed, 25 Jan 2023 08:18:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +ZPtIc3l0GNNcgAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 25 Jan 2023 08:18:21 +0000
Message-ID: <60d8f225eef9bcea1e5796a9945f310a84770c57.camel@suse.com>
Subject: Re: [PATCH v2] scsi: add non-sleeping variant of scsi_device_put()
 and use it in alua
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Date:   Wed, 25 Jan 2023 09:18:21 +0100
In-Reply-To: <Y9DQ5VEdr2fDZwic@infradead.org>
References: <20230124143025.3464-1-mwilck@suse.com>
         <Y9DQ5VEdr2fDZwic@infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-24 at 22:49 -0800, Christoph Hellwig wrote:
> On Tue, Jan 24, 2023 at 03:30:25PM +0100, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Since the might_sleep() annotation was added in scsi_device_put()
> > and
> > alua_rtpg_queue(), we have seen repeated reports of "BUG: sleeping
> > function
> > called from invalid context" [1], [2]. alua_rtpg_queue() is always
> > called
> > from contexts where the caller must hold at least one reference to
> > the scsi
> > device in question. This means that the reference taken by
> > alua_rtpg_queue() itself can't be the last one, and thus can be
> > dropped
> > without entering the code path in which scsi_device_put() might
> > actually
> > sleep.
>=20
> If there is always guaranteed to be another reference, why does this
> code even grab one?=A0 The pattern of dropping a reference that can't
> be
> the last is pretty nonsensical.
>=20

It's because the sdev is passed to the work queue to execute the RTPG.
To my understanding, the rationale is that the caller's ref may be
given up before the workqueue starts running, thus an additional ref is
needed to make sure the sdev isn't freed before the workqueue accesses
it. But if queue_delayed_work() fails (e.g. because the item is already
queued) this additional ref must be given up.

Regards,
Martin
