From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] scsi: Do not escalate failed EH command
Date: Wed, 22 Jun 2016 15:36:58 +0200
Message-ID: <20160622133658.GG6118@lst.de>
References: <1466415340-104465-1-git-send-email-hare@suse.de> <1466415340-104465-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52061 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbcFVNhb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 09:37:31 -0400
Content-Disposition: inline
In-Reply-To: <1466415340-104465-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, Jun 20, 2016 at 11:35:40AM +0200, Hannes Reinecke wrote:
> If an EH command fails there is no need to escalate; we are already
> in EH and the escalation will start anyway.

I agree with this in principle, but is this really the case for all
callers?

E.g. the call to scsi_request_sense in scsi_eh_get_sense simply
skips to the next cmd on failure.  This could use a little more
description explaining how all callers of this are indeed fine
with not escalating manually.
