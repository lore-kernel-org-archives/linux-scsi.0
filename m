From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: Use request_firmware() to provide SAS address
	if the adapter lacks one
Date: Mon, 8 Oct 2007 16:50:10 -0700
Message-ID: <20071008235009.GB16003@tree.beaverton.ibm.com>
References: <20071008212553.GI16752@tree.beaverton.ibm.com> <20071008224832.GB11993@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57887 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJHXtg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Oct 2007 19:49:36 -0400
Content-Disposition: inline
In-Reply-To: <20071008224832.GB11993@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, James Bottomley <james.bottomley@steeleye.com>

On Mon, Oct 08, 2007 at 03:48:32PM -0700, Andrew Vasquez wrote:

> So how about factoring that out to a transport-level interface.  How
> about something along the lines of the following patch, whereby the
> software driver upon detecting no valid WWPN, makes an upcall to each
> interface's 'request_wwn()'.  The data passed in from shost_gendev
> should be enough for some helper script to cull relevent device bits
> and perhaps offer some level of persistence...  Off base?

Hrm... jejb made a remark that it might be better to pass the
scsi_host's device into request_firmware() as your example does, so I'll
pitch in a patch to do likewise with libsas--the scsi_host knows the
actual device it's coming from, and userland can sort that all out later
anyway via DEVPATH.

I suppose one could also have multiple scsi_hosts per PCI device, which
means that my first patch would stumble horribly in more than a few
cases.

> Darrick, forgive the FC example, I don't do SAS...

That's ok, I don't do FC. :)  Looks mostly good to me...

--D
