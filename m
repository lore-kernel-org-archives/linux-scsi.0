Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2195C4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 07:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 751D0207C3
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 07:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601451537;
	bh=dKx7zotX7jRA1uJHnJb99FbL3A5ZVBq5tyMAbHV3svI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SWAUWWrA0/WOJJ+IPcCysVfiFNYWuLEEJy+G2Scs6V2E3phQQyAp2H+fPNP9hbSaq
	 0eno/rSYXA3rfCVIfh+YAZkWNHHtP9icPQ1x3LD+CznYaVBMF6enBb6lNl8Q5RxMMy
	 sNJ/y/mtSWMCD+0aWBcbQ3AHIEVKc+NhOoEKVVUg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgI3Hi4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 03:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgI3Hi4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 03:38:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25882075F;
        Wed, 30 Sep 2020 07:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601451535;
        bh=dKx7zotX7jRA1uJHnJb99FbL3A5ZVBq5tyMAbHV3svI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dnMiR5p3XeHNr4MDMtAO/at2k7IOeGkQVoWuNknVIISMxupfqjcAhoQoGXTIdgM/g
         qZ/Ib5Yn8h6XvggiCiv/Y4tIPF2iLD2d/t6GC+BGQ8LDefjWolc440bHSPgnTzoz8c
         05p2PfdtqfiVLFqTfjnmFvrQZbdNTi9qbQo6GKS8=
Date:   Wed, 30 Sep 2020 09:38:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tony Asleson <tasleson@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [v5 01/12] struct device: Add function callback durable_name
Message-ID: <20200930073859.GA1509708@kroah.com>
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-2-tasleson@redhat.com>
 <20200929175102.GA1613@infradead.org>
 <20200929180415.GA1400445@kroah.com>
 <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20e220a6-4bde-2331-6e5e-24de39f9aa3b@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 29, 2020 at 05:04:32PM -0500, Tony Asleson wrote:
> On 9/29/20 1:04 PM, Greg Kroah-Hartman wrote:
> > On Tue, Sep 29, 2020 at 06:51:02PM +0100, Christoph Hellwig wrote:
> >> Independ of my opinion on the whole scheme that I shared last time,
> >> we really should not bloat struct device with function pointers.
> 
> Christoph, thank you for sharing a bit more of your concerns and
> bringing Greg into the discussion.  It's more productive.
> 
> >>
> >> On Fri, Sep 25, 2020 at 11:19:18AM -0500, Tony Asleson wrote:
> >>> Function callback and function to be used to write a persistent
> >>> durable name to the supplied character buffer.  This will be used to add
> >>> structured key-value data to log messages for hardware related errors
> >>> which allows end users to correlate message and specific hardware.
> >>>
> >>> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> >>> ---
> >>>  drivers/base/core.c    | 24 ++++++++++++++++++++++++
> >>>  include/linux/device.h |  4 ++++
> >>>  2 files changed, 28 insertions(+)
> > 
> > I can't find this patch anywhere in my archives, why was I not cc:ed on
> > it?  It's a v5 and no one thought to ask the driver core
> > developers/maintainers about it???
> 
> You were CC'd into v3, ref.
> 
> https://lore.kernel.org/linux-ide/20200714081750.GB862637@kroah.com/

Yeah, and I rejected that patch too, no wonder you didn't include me in
further patch reviews, you didn't want me to reject them either :)

> > {sigh}
> > 
> > And for log messages, what about the dynamic debug developers, why not
> > include them as well?  Since when is this a storage-only thing?
> 
> Hannes Reinecke has been involved in the discussion some and he's
> involved in dynamic debug AFAIK.

From the maintainers file:
	DYNAMIC DEBUG
	M:      Jason Baron <jbaron@akamai.com>
	S:      Maintained
	F:      include/linux/dynamic_debug.h
	F:      lib/dynamic_debug.c

Come on, you know this, don't try to avoid the people who have to
maintain the code you are wanting to change, that's not ok.

> If others have a need to identify a specific piece of hardware in a
> potential sea of identical hardware that is encountering errors and
> logging messages and can optionally be added and removed at run-time,
> then yes they should be included too.  There is nothing with this patch
> series that is preventing any device from registering a callback which
> provides this information when asked.

But that's not what the kernel is supposed to be doing, it doesn't care
about tracking things outside of the lifetime from when it can see a
device.  That's what userspace is for.

> >>> diff --git a/include/linux/device.h b/include/linux/device.h
> >>> index 5efed864b387..074125999dd8 100644
> >>> --- a/include/linux/device.h
> >>> +++ b/include/linux/device.h
> >>> @@ -614,6 +614,8 @@ struct device {
> >>>  	struct iommu_group	*iommu_group;
> >>>  	struct dev_iommu	*iommu;
> >>>  
> >>> +	int (*durable_name)(const struct device *dev, char *buff, size_t len);
> > 
> > No, that's not ok at all, why is this even a thing?
> > 
> > Who is setting this?  Why can't the bus do this without anything
> > "special" needed from the driver core?
> 
> I'm setting it in the different storage subsystems.  The intent is that
> when we go through a common logging path eg. dev_printk you can ask the
> device what it's ID is so that it can be logged as structured data with
> the log message.  I was trying to avoid having separate logging
> functions all over the place which enforces a consistent meta data to
> log messages, but maybe that would be better than adding a function
> pointer to struct device?  My first patch tried adding a call back to
> struct device_type, but that ran into the issue where struct device_type
> is static const in a number of areas.
> 
> Basically for any piece of hardware with a serial number, call this
> function to get it.  That was the intent anyway.

That's not ok, again, if you really want something crazy like this, then
modify your logging messages to provide it.  But I would strongly argue
that you do not really need this, as you have this information at
runtime, in userspace, already.

> > We have a mapping of 'struct device' to a unique hardware device at a
> > specific point in time, why are you trying to create another one?
> 
> I don't think I'm creating anything new.  Can you clarify this a bit
> more?  I'm trying to leverage what is already in place.
> 
> > What is wrong with what we have today?
> 
> I'm trying to figure out a way to positively identify which storage
> device an error belongs to over time.

"over time" is not the kernel's responsibility.

This comes up every 5 years or so. The kernel provides you, at runtime,
a mapping between a hardware device and a "logical" device.  It can
provide information to userspace about this mapping, but once that
device goes away, the kernel is free to reuse that logical device again.

If you want to track what logical devices match up to what physical
device, then do it in userspace, by parsing the log files.  All of the
needed information is already there, you don't have to add anything new
to it.

Again, this comes up every few years for some reason, because people
feel it is eaasier to modify the kernel than work with userspace
programs.  Odd...

> > So this is a HARD NAK on this patch for now.
> 
> Thank you for supplying some feedback and asking questions.  I've been
> asking for suggestions and would very much like to have a discussion on
> how this issue is best solved.  I'm not attached to what I've provided.
> I'm just trying to get towards a solution.

Again, solve this in userspace, you have the information there at
runtime, why not use it?

> We've looked at user space quite a bit and there is an inherit race
> condition with trying to fetch the unique hardware id for a message when
> it gets emitted from the kernel as udev rules haven't even run (assuming
> we even have the meta-data to make the association).

But one moment later you do have the information, so you can properly
correlate it, right?

> The last thing
> people want to do is delay writing the log message to disk until the
> device it belongs to can be identified.  Of course this patch series
> still has a window from where the device is first discovered by the
> kernel and fetches the needed vpd data from the device.  Any kernel
> messages logged during that time have no id to associate with it.

No need to delay logging, you are looking at things way later in time,
so there's no issue of race conditions or anything else.

thanks,

greg k-h
