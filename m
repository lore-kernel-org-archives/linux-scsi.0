From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic7xxx: upport all sequencer and core fixes from
	adaptec version 6.3.9
Date: Fri, 05 Aug 2005 13:16:12 -0500
Message-ID: <1123265773.5003.50.camel@mulgrave>
References: <1123194802.5026.75.camel@mulgrave>
	 <42F368DD.504@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15312 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263036AbVHESQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 14:16:17 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j75IGEA00418
	for <linux-scsi@vger.kernel.org>; Fri, 5 Aug 2005 14:16:14 -0400
In-Reply-To: <42F368DD.504@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-05 at 09:25 -0400, SCSI Mailing List wrote:
> Tremendously good work!

Thanks.  There's unfortunately still an outstanding problem I can't fix.
It seems that after a certain number of repetitions of a failing
command, the entire card locks up and the sequencer always returns
SAM_STAT_BUSY to any new commands.  This is a bit of a problem for the
scsi mid-layer because it blindly always retries SAM_STAT_BUSY and
SAM_STAT_QUEUE_FULL.  The only way to recover from this is to issue a
bus reset.

This condition, I think, is what causes some of the hang reports about
this driver.  However, I think I see the code in the sequencer which is
causing it (target_cmdphase) but I don't have enough information about
the sequencer to fix this.

James


