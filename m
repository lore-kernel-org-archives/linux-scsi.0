From: Maksim Rayskiy <maksim.rayskiy@gmail.com>
Subject: Re: [RFC] Deferred disk spinup during system resume
Date: Fri, 7 Jan 2011 12:46:33 -0800
Message-ID: <AANLkTimtgQsk5JTn1=NT1WfbFUuJ1A7v_wxt9NqrTrSi@mail.gmail.com>
References: <1294363626-28901-1-git-send-email-maksim.rayskiy@gmail.com>
	<20110107190644.GB7355@mtj.dyndns.org>
	<4D276989.1000501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46167 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AGUqe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 15:46:34 -0500
Received: by iwn9 with SMTP id 9so17563084iwn.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jan 2011 12:46:33 -0800 (PST)
In-Reply-To: <4D276989.1000501@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org

> The taskfile you are to pass to the hardware is created in
> atapi_start_stop_xlat(), so you should not create a new taskfile in
> ata_eh_maybe_verify()

In order for resume to proceed without waiting for START to finish I
need to complete and release READ VERIFY qc immediately. I can
schedule EH action but it will be using a new qc and a new taskfile.

> It is a clear laying violation to call out from the middle of a command
> translation, to directly execute some EH actions.  Remember, this is the
> stage at which we are QUEUEING commands.  There may be other commands in the
> queue, or currently executing.  If someone sends a READ VERIFY, we do not
> want to IMMEDIATELY schedule EH, we want to execute an EH action when the
> READ VERIFY command is ready to be executed.
>
> It is quite incorrect to assume that READ VERIFY will only be sent to libata
> for execution during system resume.  The removal of READ VERIFY translation
> from ata_scsi_start_stop_xlat() is clearly wrong.
>

There is also ata_scsi_verify_xlat() that translates READ VERIFY.
How can I tell in ata_scsi_start_stop_xlat() if this particular
request is coming from system resume? Doesn't that mean I will have
defer all START requests? Or I need a separate command instead of
START_STOP to indicate that this request can be done asynchronously?

Thanks,
Maksim.
