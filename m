Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4027C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:53:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F693229CA
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 17:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389781AbhAKRwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:52:50 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:40252 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389737AbhAKRwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 12:52:50 -0500
Date:   Mon, 11 Jan 2021 18:52:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610387527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cVPy9CIYHjVZt0nLPho0cY7Gyw6JNwoxw+L1fIWKpKQ=;
        b=4HTQTzsYZBP196mM6oAM2A/14W35mIEIDbJOId6/+iuzHyA64c7fan3+w8MteOXQMcZGXa
        /6Moj3fCObl/hDaeeuDcFQh+UpJj+Bc1EpqP2hI039I76oY3LNwDC1ZHQ6M/CkdBRj4oaZ
        /Te9CFcspFob0/LqQij4Ri5/sSvQzrD6n0KqIyXKkmRxe6IqgwHuUQOwW3l5XMEUgW9arI
        n4M9++0u8mwTXbz/1OGdnGhKswyVZpaWAjoJlT6xIRAiU2W7VCs10G82q6kTc6i0qkMvk0
        Fe9VAB/QJA+SnEwr0hhmiy6mhUjlpDfUPsXblebbjCqzkRYmccc9uTMCAwBIYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610387527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cVPy9CIYHjVZt0nLPho0cY7Gyw6JNwoxw+L1fIWKpKQ=;
        b=0aoetZFobB4JlwzD45Q6x4+B5sm7cnXj/5GBF+r2cdaFyeflfjpYgZL5VHgqFVWpUGNSxF
        mah3iQGwO/5Dg0Cg==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        artur.paszkiewicz@intel.com, jinpu.wang@cloud.ionos.com,
        corbet@lwn.net, yanaijie@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-linux-scu@intel.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas and users: Remove notifier indirection
Message-ID: <X/yQRg4duKpDjFFC@lx-t490>
References: <1610386112-132641-1-git-send-email-john.garry@huawei.com>
 <X/yN3uNT77yy8Usi@lx-t490>
 <a056f28e-bbdc-1400-83f2-b6d76afd92b9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a056f28e-bbdc-1400-83f2-b6d76afd92b9@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 11, 2021 at 05:44:17PM +0000, John Garry wrote:
> On 11/01/2021 17:41, Ahmed S. Darwish wrote:
> > On Tue, Jan 12, 2021 at 01:28:32AM +0800, John Garry wrote:
> > ...
> > > index a920eced92ec..6a51abdc59ae 100644
> > > --- a/drivers/scsi/mvsas/mv_sas.c
> > > +++ b/drivers/scsi/mvsas/mv_sas.c
> > > @@ -230,7 +230,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
> > >   	}
> > >
> > >   	sas_ha = mvi->sas;
> > > -	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
> > > +	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
> > >
> >
> > Minor point: "sas_ha" is now not used anywhere; it should be removed.
> > .
> >
>
> ah, yes, it can be removed.
>

Similarly for drivers/scsi/pm8001/pm8001_sas.c.

(Just discovering these while integrating your patch at the top of my
 series).

> BTW, on separate topic, did intel-linux-scu@intel.com bounce for you?
>

Yup :)

--
Ahmed S. Darwish
Linutronix GmbH
