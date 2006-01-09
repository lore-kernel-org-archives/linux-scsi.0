From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Make scsi error recovery play nice with devices
	blocked by transport
Date: Mon, 09 Jan 2006 09:39:17 -0600
Message-ID: <1136821157.3364.11.camel@mulgrave>
References: <43A35498.6030903@sgi.com> <43B2B77B.20602@emulex.com>
	 <43BEE23E.8040707@sgi.com>  <43C27ABC.2020504@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6529 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964801AbWAIPjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2006 10:39:23 -0500
In-Reply-To: <43C27ABC.2020504@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Michael Reed <mdr@sgi.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeremy Higdon <jeremy@sgi.com>

On Mon, 2006-01-09 at 10:01 -0500, James Smart wrote:
> > I think letting the harder resets happen is a good thing (or at least
> > not a bad thing) as long as recovery waits for the driver to report that
> > the drive is gone (offline).
> 
> Well, in thinking through this further after my initial reply...
> 
> I think we really do want to leave scsi_eh_ready_devs() logic with the bigger
> hammer steps alone. Ultimately, they are trying to regain the resources for an
> i/o that is trying to be killed but the LLDD (or device) isn't cooperating.
> I still believe in not resetting everyone just because a device is temporarily
> blocked. However, we need to intercept it at a earlier point... Ultimately,
> to reach this path, it starts with an i/o timing out, and the eh_abort handler
> failing. In Emulex's case, we are planning on never failing the eh_abort
> handler if we're in this temporarily blocked state, even at the expense of a
> long wait. This is actually too much to ask of an LLDD - and is hokey. The
> logic really should be to intercept the timeout handler, note that the device
> is blocked, and delay the abort request until the device has been given a
> chance to return (e.g. just restart the i/o abort timer for the amount of 
> devloss_tmo that remains). Otherwise, we're always guaranteeing a failure from
> the abort handlers (for i/o and device) as there's no device to talk to.
> 
> This should remove the need for your if-blocked test in scsi_error.c,
> replacing it with the logic in the i/o timeout handler.

Actually, there is another thing you can do even earlier:  implement
scsi_eh_timer_return() in the host template (probably with a generic
routine from the fc class).  This would allow you to hold off the
timeout at least for the length of the user specified timeout and all
the retries.  Probably the routine would simply check to see if the
device is in a devloss timeout and if it is return EH_RESET_TIMER;
otherwise return EH_NOT_HANDLED.

James


