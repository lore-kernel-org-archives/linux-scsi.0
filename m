From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] scsi : set target can_queue from devinfo flags
Date: Wed, 14 May 2008 21:21:00 -0400
Message-ID: <482B8FFC.6070701@emulex.com>
References: <1210700704.16304.1.camel@localhost.localdomain> <1210793893.3075.6.camel@localhost.localdomain> <482B5EC2.7010302@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36755 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYEOBVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2008 21:21:09 -0400
In-Reply-To: <482B5EC2.7010302@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>



James Smart wrote:
> Well, I know there are fixed limits based on the context limits in their
> interface chips. Tachyons are a good example of this, especially some of
> the older ones. There are also a lot of arrays that are sold in fixed
> configurations so they don't have the variability you mention.

forgot one more - firmware algorithms that cap the limits...

now the real reason for the reply...

> ... b) there's always questions on how/when you
> ramp up and at what rate, which is confused again if the queue full
> wasn't because of target-level resources. We also have to be careful

I realized after I wrote this, that I was implicitly assuming that you are
part of a multi-initiator (which can include multiple path) environment.
If you are the only initiator to the target, the algorithms can work fairly
well to detect the max, and you can pin it - with a short performance
reduction in the beginning.

But, if part of a multi-initiator environment, you can get wild swings on
what the ramp down moves to, which makes the ramp up more critical. It
also leads to biasing toward initiators that have high loads oustanding.
Any time your are waiting to ramp up, you are potentially at a lower
performance.   Granted, the fixed target limit doesn't work well in this
case either, but admins are more agreeable to partition the physical
target limit between the servers and let the luns share the server's
target limit.

Just a couple more reasons why, although the queue full seems a good
approach, it's far harder to make it work well, and may need a couple of
different algorithms.

-- james s
