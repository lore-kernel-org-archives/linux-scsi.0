Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C55EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 18:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20119207BC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 18:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ePzKtWmq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406034AbgE1SyR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 14:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405951AbgE1SyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 14:54:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07F2C08C5C6
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 11:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2cAu+dcbOiZSk99900RAbJS46/ULK7lrSg+7DzQz8qc=; b=ePzKtWmqM6u/ZCBp8d9c0VCyd7
        XLCVucl/aHl38jNSEvtQM7AaCX/+bpzVSgDmoVw87KdMaynyc5iaXvqzk0cEAmaeRCfcQYDQp+nIo
        el+d/UEYrbaFopwlYpJAUndkRKjqOOuPaA9I131Ga0kCyCJVwGPgttK8uob8a2HXaVlAXTegauutM
        LBqpEuzuf6QTTW1NIlC+mLOS054OMs3sqxuTMKF6DJnhecICKk/MF0fpSrrNQz/hzaZyJ1i3Xs98A
        J/vxzeIJKBxO92CBq/IQhsii232K2xI/FgNxbTZ5JJF0LbrdY0iPT+dgI9G/qd2n7lvb4KKbGlITh
        PmcplFqQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeNfH-00032c-0X; Thu, 28 May 2020 18:54:03 +0000
Date:   Thu, 28 May 2020 11:54:02 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
Message-ID: <20200528185402.GP17206@bombadil.infradead.org>
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 28, 2020 at 01:50:02PM -0400, Douglas Gilbert wrote:
> On 2020-05-28 12:36 p.m., Hannes Reinecke wrote:
> > Use xarray for device lookup by target. LUNs below 256 are linear,
> > and can be used directly as the index into the xarray.
> > LUNs above 256 have a distinct LUN format, and are not necessarily
> > linear. They'll be stored in indices above 256 in the xarray, with
> > the next free index in the xarray.

I don't understand why you think this is an improvement over just
using an allocating XArray for all LUNs.  It seems like more code,
and doesn't actually save you any storage space ... ?

> > +++ b/drivers/scsi/scsi.c
> > @@ -601,13 +601,14 @@ static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
> >   void starget_for_each_device(struct scsi_target *starget, void *data,
> >   		     void (*fn)(struct scsi_device *, void *))
> >   {
> > -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> >   	struct scsi_device *sdev;
> > +	unsigned long lun_id = 0;
> > -	shost_for_each_device(sdev, shost) {
> > -		if ((sdev->channel == starget->channel) &&
> > -		    (sdev->id == starget->id))
> > -			fn(sdev, data);
> > +	xa_for_each(&starget->devices, lun_id, sdev) {
> > +		if (scsi_device_get(sdev))
> > +			continue;
> > +		fn(sdev, data);
> > +		scsi_device_put(sdev);
> >   	}
> >   }

I appreciate you're implementing the API that's currently in use, but I would recommend open-coding this.  Looking at the functions called, lots of them
are two-three liners, eg:

static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
{
        sdev->was_reset = 1;
        sdev->expecting_cc_ua = 1;
}

which would just be more readable:

        if (rtn == SUCCESS) {
		struct scsi_target *starget = scsi_target(scmd->device);
		struct scsi_device *sdev;
		unsigned long index;

                spin_lock_irqsave(host->host_lock, flags);
		xa_for_each(&starget->devices, index, sdev) {
			sdev->was_reset = 1;
			sdev->expecting_cc_ua = 1;
		}
                spin_unlock_irqrestore(host->host_lock, flags);
        }

And then maybe you could make a convincing argument that the spin_lock
there could be turned into an xa_lock since that will prevent sdevs from
coming & going during the iteration of the device list.

> > @@ -1621,7 +1623,18 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
> >   	transport_setup_device(&sdev->sdev_gendev);
> >   	spin_lock_irqsave(shost->host_lock, flags);
> > -	list_add_tail(&sdev->same_target_siblings, &starget->devices);
> > +	if (sdev->lun < 256) {
> > +		sdev->lun_idx = sdev->lun;
> > +		WARN_ON(xa_insert(&starget->devices, sdev->lun_idx,
> > +				   sdev, GFP_KERNEL) < 0);
> 
> You have interrupts masked again, so GFP_KERNEL is a non-no.

Actually, I would say this is a great place to not use the host_lock.

+	int err;
...
+	if (sdev->lun < 256) {
+		sdev->lun_idx = sdev->lun;
+		err = xa_insert_irq(&starget->devices, sdev->lun_idx, sdev,
+				GFP_KERNEL);
+	} else {
+		err = xa_alloc_irq(&starget->devices, &sdev->lun_idx, sdev,
+				scsi_lun_limit, GFP_KERNEL);
+	}
+	... maybe you want to convert scsi_sysfs_device_initialize()
+	to return an errno, although honestly this should never fail ...
        spin_lock_irqsave(shost->host_lock, flags);
-       list_add_tail(&sdev->same_target_siblings, &starget->devices);
        list_add_tail(&sdev->siblings, &shost->__devices);
        spin_unlock_irqrestore(shost->host_lock, flags);


> > +	unsigned int lun_idx;		/* Index into target device xarray */
> 
> Xarray gives you _two_ choices for the type of an index :-)
> It is either u32 (as used in xa_alloc() and its variants) _or_
> unsigned long (as used everywhere else in xarray where an index
> is needed). So it's definitely 32 bits for xa_alloc() and either
> 32 or 64 bits for the rest of xarray depending on the machine
> architecture.
> Matthew Wilcox may care to explain why this is ...

Saving space in data structures, mostly.  It's not really useful to
have 4 billion things in an allocating XArray.  Indeed, it's not really
useful to have 4 billion of almost anything.  So we have XArrays which
are indexed by something sensible like page index in file, and they're
nice and well-behaved (most people don't create files in excess of 16TB,
and those who do don't expect amazing performance when seeking around
in them at random because they've lost all caching effects).  And then
you have people who probably want one scsi device.  Maybe a dozen.
Possibly a thousand.  Definitely not a million.  If you get 4 billion scsi
devices, something's gone very wrong.  You've run out of drive letters,
for a start (/dev/sdmzabcd anybody?)

It doesn't cost us anything to just use unsigned long as the index of an
XArray, due to how it's constructed.  Except in this one place where we
need to point to somewhere to store the index so that we can update the
index within an sdev before anybody iterating the data structure under
RCU can find the uninitialised index.

This patch seems decent enough ... I just think the decision to optimise
the layout for LUNs < 256 is a bit odd.  But hey, your subsystem,
not mine.
