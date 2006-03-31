From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Retry INQUIRY on power-on
Date: Fri, 31 Mar 2006 09:16:18 -0600
Message-ID: <1143818178.3375.3.camel@mulgrave.il.steeleye.com>
References: <442D2AA1.3070909@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:7886 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751323AbWCaPQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 10:16:28 -0500
In-Reply-To: <442D2AA1.3070909@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2006-03-31 at 15:12 +0200, Hannes Reinecke wrote:
> So we really should loosen that statement to do retry for all ASC 0x29
> values as a power-on might well have occured without a reset.

Actually, there's probably no reason to qualify the UNIT_ATTENTION at
all.  Any device that replies UNIT_ATTENTION to INQUIRY is out of spec,
so it's reasonable to assume that the ASC/ASCQ responses aren't in spec
either.  There doesn't seem to be a disadvantage to just retrying three
times in all unit attention cases.

Did you have time to look at the reset locking issue that turned up in
the aic7xxx backport?

James


