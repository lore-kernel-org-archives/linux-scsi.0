From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: 16 Jun 2004 12:21:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087406464.2796.30.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF28034F94F0@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:63655 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264239AbUFPRVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:21:14 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94F0@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-16 at 12:10, Smart, James wrote:
> I can appreciate the protectionist point of view. My only contention is -
> how do you really derive that 1 reset is any less valid than 2 ? it totally
> depends on what the original timeout was relative to whatever the duration
> is for the LLDD event that is requesting the reset. 

Who said anything about reset?

This is just early notification of something going wrong.  If the
command needs to be retried (or an event that throws the command away is
to be triggered), that's done using the EH_NOT_HANDLED and activating
the eh thread.

I'm not wedded to the current method of handling retries.  It would be
feasible to use a more normal count to not allow non-retryable commands
to be delayed.

James


