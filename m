From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH as468] Retry supposedly "unrecoverable" hardware errors
Date: Thu, 17 Feb 2005 14:27:41 +1000
Message-ID: <42141D3D.9080800@torque.net>
References: <Pine.LNX.4.44L0.0502161144170.6418-100000@ida.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:25277 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262133AbVBQE1E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 23:27:04 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502161144170.6418-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Martin Peschke <mpeschke@de.ibm.com>, Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> James:
> 
> This is an updated and unmangled version of the patch sent in by Martin 
> Peschke.  Apparently some drives report Hardware Error sense for 
> problems which do improve after retrying, so the patch retries these 
> supposedly "unrecoverable" errors for such devices.

Recent SPC-3 and SBC-2 drafts treat the sense keys of
MEDIUM ERROR and HARDWARE ERROR in a similar way.
Both can return an "info" field which has the same
meaning (lba of first failure). The distinction is that
MEDIUM ERROR is a little more precise (at least for
magnetic rotating media) **. For flash ram the distinction
is moot.

I believe MEDIUM ERROR and HARDWARE ERROR should be
treated the same way in scsi_check_sense() (i.e.
both return NEEDS_RETRY). That way an extra black list
category is avoided.


** HARDWARE ERROR is returned in cases of self diagnostic
failure and lack of available blocks for reassignment.
It seems valid for a device to return a HARDWARE ERROR
sense key both for these cases and unrecoverable data
errors (and ignore MEDIUM ERROR).

Doug Gilbert
