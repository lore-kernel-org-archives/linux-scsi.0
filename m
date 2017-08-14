From: Tejun Heo <tj@kernel.org>
Subject: Re: Spurious DISK_EVENT_MEDIA_CHANGE on USB DVD hotplug?
Date: Mon, 14 Aug 2017 11:30:30 -0700
Message-ID: <20170814183030.GA4087514@devbig577.frc2.facebook.com>
References: <c22ebffe-cf80-c3ef-2bd9-6b3b66271226@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:34323 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdHNSaf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 14:30:35 -0400
Received: by mail-qt0-f171.google.com with SMTP id s6so56470660qtc.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2017 11:30:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <c22ebffe-cf80-c3ef-2bd9-6b3b66271226@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-scsi@vger.kernel.org

Hello, Joe.

On Thu, Aug 10, 2017 at 10:45:54AM -0400, Joe Lawrence wrote:
> In the case of my USB DVD -> laptop example, there is no media in my
> device, however I still see the DISK_EVENT_MEDIA_CHANGE event.  This is
> a bit confusing, and I was wondering if there was an explanation for
> the following:
> 
> drivers/scsi/sr.c :: sr_probe()
> 
>         disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
>         ...
>         cd->media_present = 1;
> 
> DISK_EVENT_MEDIA_CHANGE events will pass through to userspace and
> for some reason cd->media_present defaults to 1?  More on that below...

I don't have any concrete ideas but I think the only thing it's trying
to do is to always generate at least one changed event no matter what.

...
> sr_check_events() compares the previous (in this case, default)
> media_present value with what the TUR returns.  If it has changed, then
> turn on the DISK_EVENT_MEDIA_CHANGE event bit.
> 
> In my laptop USB DVD case, !scsi_status_is_good and sshdr.asc == 0x3a,
> so last_present (1) and cd->media_present (0) mis-compare and the change
> event is set.  That does not seem intuitive to me, is this a bug?

It's not incorrect.  We can try to change the behavior to avoid double
notifications but given that this has been like this for a really long
time and that it isn't technically incorrect, I'm not sure changing it
is a good idea.  It might as well break other things.

> Bringing this back to the reported BMC case, which presumably does have
> "media" present in the virtual device... is it reasonable to expect a
> DISK_EVENT_MEDIA_CHANGE even for a new device that contains media?  (I
> haven't verified, but in this case GET_EVENT_STATUS_NOTIFICATION might
> be enough to set media present.)

Yeah, I think so.

> If there is documentation that explains DISK_EVENT_MEDIA_CHANGE conditions
> somewhere, feel free to point me there.

AFAIK, there isn't any.  The only thing it tries to do is generating
at least one event after media change.  Given that media is reported
present after the last notification, I think userspace should be able
to do the right thing (and must have been doing the right thing until
recently).

Thanks.

-- 
tejun
