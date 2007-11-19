From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI dynamic power management
Date: Mon, 19 Nov 2007 12:18:49 -0700
Message-ID: <20071119191849.GF12494@parisc-linux.org>
References: <1195491182.3283.17.camel@localhost.localdomain> <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56094 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXKSTSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 14:18:51 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711191405160.3005-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 19, 2007 at 02:16:12PM -0500, Alan Stern wrote:
> Regarding this thread's original question, the best idea I've come up
> with so far is to store an extra flag in the scsi_device structure
> indicating that a suspend or resume transition is underway.  When the
> flag is set, commands with REQ_PREEMPT would be accepted.  If the
> device is "suspended" and the flag is clear, then commands would be
> delayed or killed in the prep function regardless of REQ_PREEMPT.  This 
> scheme could potentially let unwanted commands go through, but I 
> haven't been able to think of anything more suitable.

You could allow only START_STOP and TUR to go through?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
