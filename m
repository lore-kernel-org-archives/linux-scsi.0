Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426DFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EECD62064B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 17:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgLURi5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 12:38:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39586 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLURi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 12:38:57 -0500
Date:   Mon, 21 Dec 2020 18:38:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608572295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9DGEQ/Nq5WGoytqa9TEYBJawqU4/VXX/wUM7atOpeIw=;
        b=uSga2Ux/ThDWWwvI09CkWbMDPxnJGrWL30sofE3QaBPrP8QcNnvX/rqZPE8zwlA8nykRaU
        alDudvNV+6GSLCNDWOaDmCpS/T9ec/OstpGobfEI2X5PoFUKNH4aJ0exrDp54kbgZAPXH8
        d0AvBNGUY2TXd8HFZBuBzvJfYaDaR4r8L6J/DBZsh9BQbioah/zi3vXAMhcwfPhmJZrjt8
        LKFKWPsKM6qQN9mGWPm+YvNBD90P4eL9vXJrbanl/UhTIjYRNNZyU2vnc9/Owk4lpshhaz
        VK87zQusxPVC5Z+ieqd2kY+wIm9jFApGvHAnv7HvOjabs7Asw0xlbctSM05tsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608572295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9DGEQ/Nq5WGoytqa9TEYBJawqU4/VXX/wUM7atOpeIw=;
        b=AJy18+8Y2jmDN5xTd9eUKxhplOrk6gQMJ0wP8v+sRNke6xShZ5daUG3fHREp1k1fQp856L
        Ytu1JmTtBepvmzBw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH 11/11] scsi: libsas: event notifiers: Remove non _gfp()
 variants
Message-ID: <20201221173812.GA2165279@debian-buster-darwi.lab.linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
 <20201218204354.586951-12-a.darwish@linutronix.de>
 <68957d37-c789-0f0e-f5d1-85fef7f39f4f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68957d37-c789-0f0e-f5d1-85fef7f39f4f@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 21, 2020 at 05:17:13PM +0000, John Garry wrote:
> On 18/12/2020 20:43, Ahmed S. Darwish wrote:
> > All call-sites of below libsas APIs:
> >
> >    - sas_alloc_event()
> >    - sas_ha_struct::notify_port_event()
> >    - sas_ha_struct::notify_phy_event()
> >
> > have been converted to use the new _gfp()-suffixed version.
> >
>
> nit: Is it possible to have non- _gfp()-suffixed symbols at the end, i.e.
> have same as original?
>

Yes, of course. I just did not want to double-fold the patch series size
from first submission ;-)

If the overall outlook of this series is OK, in v2 I'll append patches
#12 => #20 restoring call sites to the original names without _gfp(),
then keep only the original libsas names.

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
