From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 16:01:30 -0500
Message-ID: <519154AA.5010500@tributary.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain> <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain> <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com> <518D55FA.4080302@suse.de> <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com> <51907E45.7010409@suse.de> <5190FB4E.4000900@tributary.com> <519100A5.2060509@suse.de> <51910DB0.70009@tributary.com> <yq18v3ibp3n.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.57]:10742 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3EMVBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 17:01:34 -0400
In-Reply-To: <yq18v3ibp3n.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Baruch Even <baruch@ev-en.org>, emilne <emilne@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On 5/13/2013 3:29 PM, Martin K. Petersen wrote:

> others. We see cases fairly often where a misbehaving target has
> confused the HBA enough that we can not bring the device back without
> doing an HBA firmware reset. Despite I/O completing successfully on
> other targets connected to the same HBA.

	This would seem to indicate a HBA/driver bug...

> So at some point we do need to give up and escalate to a full HBA
> reset. We would just like to defer that hammer until we have run out of
> other options.

	Except that I've seen the linux error recovery cause more problems than it
solves on a fairly regular basis. I would rather have a solution designed to
isolate failures, than one that makes a lot of mistakes and causes further
problems (sometimes with other machines). I'm pretty convinced that attempting
everything possible to recover a device when the underlying problem is unknown
is a bad strategy.

	I think maybe its a perspective difference. If the device that is failing is an
OS disk, then giving up is paramount to crashing the machine. On the other hand,
if the failing device is some shared tape drive in a SAN with a few hundred
alternatives then killing the OS in an attempt to recover that drive is a problem.

	Maybe, the super aggressive recovery paths should be reserved for devices
marked critical to system operation.


