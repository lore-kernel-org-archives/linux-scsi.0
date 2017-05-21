From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/18] scsi: storvsc: Initialize driver-private command
        before using it
Date: Sun, 21 May 2017 08:51:34 +0200
Message-ID: <20170521065134.GF12891@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-16-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42824 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdEUGvg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 May 2017 02:51:36 -0400
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-16-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Long Li <longli@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>

On Fri, May 19, 2017 at 11:30:13AM -0700, Bart Van Assche wrote:
> The storvsc driver is the only SCSI LLD that uses driver-private
> command data and that does not zero-initialize that data before
> reading it. Make this driver consistent with the other SCSI LLDs
> that use driver-private command data.

Well.  Either we add zeroing to storvsc and remove it from common
code, or we remove the zeroing from the drivers.

We shouldn't do both.  Given that we already zero the remaining
command it seems to me like keeping the zeroing in common code
would be preferred, but I'm open to discussion.
