From: James.Smart@Emulex.Com
Subject: RE: Mid-layer handling of NOT_READY conditions...
Date: Mon, 31 Jan 2005 14:07:32 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F329@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:31172 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261316AbVAaTH5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 14:07:57 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: patmans@us.ibm.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

> >   If the transport hits a problem, there's
> > no harm done as long as the problem is resolved within the block
> > timeout. If the timeout is hit - it's because the user dicated that
> > it wanted to know of errors within this time and if the 
> device fails,
> > it fails...
> > 
> > In the multipath solution - the "block" time used by the 
> transport gets
> > set to 0 (or 1 second), so the i/o fails quickly and the multipath
> > function can kick in.
> > 
> 
> A bit confused now, are you proposing that 
> cmd->timeout_per_command time
> be inclusive of potential transport failures resulting in a requested
> retry?  And thus not be refreshed (as it currently is) upon retry
> request.

Nope. I knew I probably said the wrong thing here...

Let the io timeout stays as is. If the block condition occurs - it's up
to the driver take the right action on whether the i/o was killed as a
result or not. If it kills it, the driver should error it right away,
then the block code will hold off the retry. If it isn't killed, it lets
the i/o timer fire normally, which may invoke the eh_abort handler
(which is not held off by the block). After the abort, the retry would
be held off by the blocked state.

You want the dev_loss timer low so that other i/o will get through, and
can fail, thus invoking the device state change (and subsequent aborts
of the pending i/o's).


> Perhaps there could be
> a combination of timing conditionals -- the 
> fc_starget_dev_loss_tmo() to
> time the overall pause in 'not-ready' plugging and a
> period-to-wakeup-and-ping-the-storage time within the window?

Agree. I assume the ping-the-storage function is something done as
part of the multipathing so that it has an accurate state of the path.

-- james
