From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Fri, 15 Mar 2013 17:22:29 -0400
Message-ID: <51439115.806@interlog.com>
References: <1363340771-46925-1-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57273 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531Ab3COVWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 17:22:48 -0400
In-Reply-To: <1363340771-46925-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, George Martin <marting@netapp.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

On 13-03-15 05:46 AM, Hannes Reinecke wrote:
> SAM advertises the use of a Well-known LUN (W_LUN) for scanning.
> As this avoids exposing LUN 0 (which might be a valid LUN) for
> all initiators it is the preferred method for LUN scanning on
> some arrays.
> So we should be using W_LUN for scanning, too. If the W_LUN is
> not supported we'll fall back to use LUN 0.
> For broken W_LUN implementations a new blacklist flag
> 'BLIST_NO_WLUN' is added.

There are proposals at T10 for feature sets to be added to
SCSI (similar to what ATA devices have). Perhaps we could
have something similar at the OS level: an opaque call
that makes some general decisions based on what we know
about the transport, HBA and possibly target/LU. So if
we are looking at a USB transport not doing UASP, then
prefer to probe LUN 0 rather than the to probe via
REPORT LUNS W_LUN. Many other (somewhat) advanced SCSI
techniques could be filtered in a similar way (e.g. if
it's a USB device assume badly implemented SCSI-2
compliance).

We could still keep the blacklist and, if we don't already
have it, add whitelist logic (e.g. for 0.001% of well-behaved
USB devices).

Doug Gilbert


