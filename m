From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sat, 03 Sep 2005 09:45:01 -0400
Message-ID: <1125755101.4803.5.camel@mulgrave>
References: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:51150 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750917AbVICNpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 09:45:06 -0400
In-Reply-To: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

On Sat, 2005-09-03 at 14:30 +0200, Andreas Herrmann wrote:
> zfcp: introduce eh_timed_out handler
> 
> This handler is required to avoid offlined SCSI devices in a multipath
> setup if scsi commands time out on cable pulls lasting longer than 30
> seconds.

But that's not what the patch does.  It short circuits the error handler
globally, not just in the cable pulled case.

For any error induced timeout, you're going to follow this logic.  In
particular, if the device itself actually has an issue and genuinely
needs to be reset, that's never going to happen.

Is this really what you want to do?

James


