Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FD0C10F25
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 20:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F41124655
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 20:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gy6kFMJ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCIUye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 16:54:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725992AbgCIUyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 16:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583787272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Px9SsZu4DRVl4jKcBt+p9Rk4j1Iiy0hMwUBS0LSMY8=;
        b=Gy6kFMJ9Whx9aB0GpyampFt4e+s9zC1uDeAQGFksKvB/BVYusG67ZzLx53tmOHoW08bICz
        0BKIlkXpOaQF9zPL/KgPSVSKcbQhlNpUsRnBpVnq4tJ9+lg+0KYSU51iQ+MzPeDOuvK2cT
        1iTPphfSmIWHlSu9OyZ92U1Pm90ySMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-qEU8clnvMXagVpJSHb3Cvg-1; Mon, 09 Mar 2020 16:54:30 -0400
X-MC-Unique: qEU8clnvMXagVpJSHb3Cvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FAAD800D4E;
        Mon,  9 Mar 2020 20:54:29 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7D0060C87;
        Mon,  9 Mar 2020 20:54:28 +0000 (UTC)
Message-ID: <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline
 messages
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Date:   Mon, 09 Mar 2020 16:54:28 -0400
In-Reply-To: <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
References: <20200309181416.10665-1-emilne@redhat.com>
         <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-03-09 at 12:36 -0700, Bart Van Assche wrote:
> On 3/9/20 11:14 AM, Ewan D. Milne wrote:
> > Large queues of I/O to offline devices that are eventually
> > submitted when devices are unblocked result in a many repeated
> > "rejecting I/O to offline device" messages.  These messages
> > can fill up the dmesg buffer in crash dumps so no useful
> > prior messages remain.  In addition, if a serial console
> > is used, the flood of messages can cause a hard lockup in
> > the console code.
> > 
> > Introduce a flag indicating the message has already been logged
> > for the device, and reset the flag when scsi_device_set_state()
> > changes the device state.
> > 
> > Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> > ---
> >   drivers/scsi/scsi_lib.c    | 8 ++++++--
> >   include/scsi/scsi_device.h | 2 ++
> >   2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 610ee41..d3a6d97 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
> >   		 * commands.  The device must be brought online
> >   		 * before trying any recovery commands.
> >   		 */
> > -		sdev_printk(KERN_ERR, sdev,
> > -			    "rejecting I/O to offline device\n");
> > +		if (!sdev->offline_already) {
> > +			sdev->offline_already = 1;
> > +			sdev_printk(KERN_ERR, sdev,
> > +				    "rejecting I/O to offline device\n");
> > +		}
> >   		return BLK_STS_IOERR;
> >   	case SDEV_DEL:
> >   		/*
> > @@ -2340,6 +2343,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
> >   		break;
> >   
> >   	}
> > +	sdev->offline_already = 0;
> >   	sdev->sdev_state = state;
> >   	return 0;
> >   
> > diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> > index f8312a3..72987a0 100644
> > --- a/include/scsi/scsi_device.h
> > +++ b/include/scsi/scsi_device.h
> > @@ -204,6 +204,8 @@ struct scsi_device {
> >   	unsigned unmap_limit_for_ws:1;	/* Use the UNMAP limit for WRITE SAME */
> >   	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
> >   					 * creation time */
> > +	unsigned offline_already:1;	/* Device offline message logged */
> > +
> >   	atomic_t disk_events_disable_depth; /* disable depth for disk events */
> >   
> >   	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
> 
> Bitfields are troublesome in multithreaded software. Has it been 
> considered to use rate-limiting instead of introducing a new bitfield 
> member?
> 
> Thanks,
> 
> Bart.
> 

I did but printk_ratelimited() does not do what is desired here.
What we want is only a single message per-device.  If we ratelimit
the message instance itself we lose information in the log about which
devices were affected (which makes debugging issues with multipath I/O
much harder).

The only purpose of the flag is to try to suppress duplicate messages,
in the common case it is a single thread submitting the queued I/O which
is going to get rejected.  If multiple threads submit I/O there might
be duplicated messages but that is not all that critical.  Hence the
lack of locking on the flag.

-Ewan

