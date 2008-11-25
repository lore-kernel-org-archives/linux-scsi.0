From: "Rhine, Jay \(Jay\)" <jrhine@alcatel-lucent.com>
Subject: RE: Devices going offline on Adaptec 29320 using driver AIC79XXafter messages "Attempting to queue an ABORT message:CDB"
Date: Tue, 25 Nov 2008 16:08:01 -0600
Message-ID: <CA39D769C8FE694788CE376026984BAB0117D26F@ILEXC1U01.ndc.lucent.com>
References: <CA39D769C8FE694788CE376026984BAB0117D222@ILEXC1U01.ndc.lucent.com> <1227650031.3415.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ihemail2.lucent.com ([135.245.0.35]:57916 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYKYWIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2008 17:08:05 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1227650031.3415.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

> The slight problem here is that no-one has a sequencer manual which
tells us what all this means.  However, it's 
> completely normal since the driver has a dump_card_state() call in the
abort routine.
>
> Why the abort was called in the first place is anyone's guess, but it
> probably came from a command timing out.   The timeout could either be
a
> sequencer error or simply a normal problem because you're hammering
the device hard and it took longer to get to the 
> command to process.
>
> You can test this latter quite easily by doubling the command
timeouts:
>
> echo 60 > /sys/class/scsi_disk/*/device/timeout
>
> And seeing if the trouble occurs with the same frequency.  If it does,
there's likely some sequencer issue;  if the 
> frequency decreases, it's device related and you can probably throttle
the device by reducing the queue depth to avoid 
> the situation.
>
> James

James,

	That sounds like a good idea.  I will try to adjust the timeout.
However, I have to ask about the "completely normal part".  I can see
the abort message occasionaly occurring normally if the drives always
recovered after the abort.  However, is it normal that the devices will
go offline the second time this situation occurs?  I'm afraid my
knowledge of SCSI does not go to this level of detail.  If it is normal,
and I can substancially reduce the frequency by some tweaking I can live
with that.  However, if this there is a real bug I would like to get it
fixed.

Thanks,

Jay


