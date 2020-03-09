Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D815C10F25
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 20:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0623A24654
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 20:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cn8rQNds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCIUuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 16:50:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32219 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725992AbgCIUuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 16:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583787001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ytGvBYrE0Xlaz079I30zXNTkLHpOvvkxbmxTZq6cDo4=;
        b=Cn8rQNdsYGqYjklrDLMnSXVvMvHPM96iBqzJChGjD0B5Lr2mxLtxn6nZPTSdp4ROilDKkI
        dWeY7WKwCVJlbLY3yQwRXvpSZZVONwlt1A7KcERTZe6QfiU3jh0ncwRiSMGMQm+QDa6qFd
        FUjGzq+knuyRhbxwBrPPYy2+Kf4mxLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-U_dw3aMNOxu_iMiQ0IWj3g-1; Mon, 09 Mar 2020 16:49:59 -0400
X-MC-Unique: U_dw3aMNOxu_iMiQ0IWj3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E687107ACC7;
        Mon,  9 Mar 2020 20:49:58 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03CFA5C3F8;
        Mon,  9 Mar 2020 20:49:57 +0000 (UTC)
Message-ID: <9407d2f1dd538d2b5eb8663a44bab049eb6917dd.camel@redhat.com>
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline
 messages
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 09 Mar 2020 16:49:57 -0400
In-Reply-To: <1583780754.3429.26.camel@HansenPartnership.com>
References: <20200309181416.10665-1-emilne@redhat.com>
         <1583780754.3429.26.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-03-09 at 12:05 -0700, James Bottomley wrote:
> On Mon, 2020-03-09 at 14:14 -0400, Ewan D. Milne wrote:
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
> >  drivers/scsi/scsi_lib.c    | 8 ++++++--
> >  include/scsi/scsi_device.h | 2 ++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 610ee41..d3a6d97 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device
> > *sdev, struct request *req)
> >  		 * commands.  The device must be brought online
> >  		 * before trying any recovery commands.
> >  		 */
> > -		sdev_printk(KERN_ERR, sdev,
> > -			    "rejecting I/O to offline device\n");
> > +		if (!sdev->offline_already) {
> > +			sdev->offline_already = 1;
> > +			sdev_printk(KERN_ERR, sdev,
> > +				    "rejecting I/O to offline
> > device\n");
> > +		}
> 
> Offline->online is a legal transition, so you'll need to clear this
> flag when that happens so we get another offline message if it goes
> offline again.
> 
> James
> 

That's what resetting the flag in scsi_device_set_state() does.
The only thing that worries me is if some driver manipulates the
sdev->sdev_state value directly.

-Ewan

