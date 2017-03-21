From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 09:05:19 -0400
Message-ID: <1490101519.2412.13.camel@HansenPartnership.com>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36894 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756897AbdCUNFZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 09:05:25 -0400
In-Reply-To: <1490098475-21884-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hck@suse.de, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, 2017-03-21 at 13:14 +0100, Hannes Reinecke wrote:
> With the current design we're waiting for all async probes to
> finish when removing any sd device.
> This might lead to a livelock where the 'remove' call is blocking
> for any probe calls to finish, and the probe calls are waiting for
> a response, which will never be processes as the thread handling
> the responses is waiting for the remove call to finish.
> Which is completely pointless as we only _really_ care for the
> probe on _this_ device to be completed; any other probing can
> happily continue for all we care.
> So save the async probing cookie in the structure and only wait
> if this specific probe is still active.

How does this preserve ordering?  It looks like you have one cookie per
sdkp ... is there some sort of ordering guarantee I'm not seeing?

James
