From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Overlapped command error handling
Date: Fri, 03 Feb 2006 09:31:25 -0600
Message-ID: <1138980685.2830.7.camel@localhost.localdomain>
References: <43E20272.5000506@suse.de> <1138893147.3363.3.camel@mulgrave>
	 <43E323BA.8010604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14770 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750824AbWBCPbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 10:31:35 -0500
In-Reply-To: <43E323BA.8010604@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2006-02-03 at 10:34 +0100, Hannes Reinecke wrote:

> Can someone explain to my how having a queue depth of '2' in the non-TCQ
> case can be correct?
> If not, please apply the following patch. Oh, and aic7xxx suffers from
> the same problem, naturally.

Yes, the driver is supposed to be counting both the tagged and untagged
commands outstanding and return SCSI_MLQUEUE_DEVICE_BUSY if the
mid-layer tries to queue over that.

The premise of setting this to 2 is that we always have one command in
progress and one completely prepared ready to fire as soon as the
in-progress one returns.  Jens has postulated that this is no-longer
necessary; we could simply reduce the queue depth to 1 for the non-TCQ
case.  What this would do is transfer the setup work from the sending
process to the block softirq, so it might increase latency in the
non-TCQ case ... but no-one knows for sure.

James


