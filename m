From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: READ CAPACITY (16) failing
Date: Tue, 14 Apr 2009 13:23:37 -0500
Message-ID: <20090414182337.GA5999@beardog.cca.cpqcorp.net>
References: <20090408194357.GA15043@beardog.cca.cpqcorp.net> <20090408195447.GP20983@parisc-linux.org> <20090410193134.GA2615@beardog.cca.cpqcorp.net> <1239402518.3393.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:14761 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZDNSXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 14:23:38 -0400
Content-Disposition: inline
In-Reply-To: <1239402518.3393.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, mike.miller@hp.com

On Fri, Apr 10, 2009 at 03:28:38PM -0700, James Bottomley wrote:
> > 
> > Why would I never the see the command in the driver?
> 
> Because your devices are reporting compliance to a standard before RC16
> was implemented (we have a check in sd_try_rc16_first() to see if you
> comply to higher than SBC-2).  Then, after you've failed this, if you
> don't return the conventional 0xffffffff to RC10, we never retry with
> RC16.

Thanks, James, that looks like the culprit. The LUN actually reports that it
is a SCSI_SPC_3 device but the controller reports SCSI_UNKNOWN. I'll work
with the firmware guys to fix that.
Oddly enough, others here don't report seeing the same RC16 failure. Gets
better and better.

Thanks,
mikem
