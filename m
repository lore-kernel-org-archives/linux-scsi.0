From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Tue, 19 Jan 2016 17:03:29 -0800
Message-ID: <1453251809.2320.56.camel@HansenPartnership.com>
References: <568FE922.9090004@sandisk.com>
	 <yq1oachqehs.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55580 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748AbcATBDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 20:03:31 -0500
In-Reply-To: <yq1oachqehs.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sebastian Herbszt <herbszt@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote:
> > > > > > "Bart" == Bart Van Assche <bart.vanassche@sandisk.com>
> > > > > > writes:
> 
> Bart> Instead of representing the states "visible in sysfs" and "has
> Bart> been removed from the target list" by a single state variable,
> use
> Bart> two variables to represent this information.
> 
> James: Are you happy with the latest iteration of this? Should I
> queue
> it?

Well, I'm OK with the patch: it's a simple transformation of the
enumerated state to a two bit state.  What I can't see is how it fixes
any soft lockup.

The only change from the current workflow is that the DEL transition
(now the reaped flag) is done before the spin lock is dropped which
would fix a tiny window for two threads both trying to remove the same
target, but there's nothing that could possibly fix an iterative soft
lockup caused by restarting the loop, which is what the changelog says.

James

