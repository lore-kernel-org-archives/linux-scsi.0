From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 09:40:14 -0500
Message-ID: <5190FB4E.4000900@tributary.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain> <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain> <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com> <518D55FA.4080302@suse.de> <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com> <51907E45.7010409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.57]:37450 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EMOkX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 10:40:23 -0400
In-Reply-To: <51907E45.7010409@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Baruch Even <baruch@ev-en.org>, emilne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On 5/13/2013 12:46 AM, Hannes Reinecke wrote:

> True. But and the end of the day, we _do_ want to recover the failed LUN.
> If we were to disable that faulty LUN and continue running with the others
> we won't have a chance of _ever_ recovering that one LUN.

	I don't buy this. Especially for FC devices, the vast majority of errors I see
are related to zoning, SFP and cabling problems. Once one of those happens you
tend to get a lot of shotgun debugging, which injects all kinds of
further errors.	None of these errors are fixed by the linux error recovery paths.

	That said, if the admin fixes something, for FC/SAS (and potentially others)
you _WILL_ get notification that the device is online again.


> SET when the link is down). So we basically _have_ to escalate it to the
> next level. Even though that will mean to stop I/O to other, hitherto
> unaffected instances.

	And a single failure, turns into performance bubbles and further errors on
other devices. Particularly if the functional devices are stateful, and the
error recovery mechanism isn't sufficiently intelligent about that state (see
tape drives). Think about what happens when a marginal SFP on a target causes
a device to repeatably drop off and reappear at some random point in the future.


	Anyway, It is possible to make a determination about the topology and make
decisions about the likely-hood of any given portion being at fault. For
example, if one lun on a target has failed and the remainder continue to work,
then its unlikely that if abort and lun reset fail that anything higher up in
the stack is going to succeed.

	I feel pretty strongly, at that point your better off providing good
diagnostics about the failure and expecting user interaction rather than
muddying the waters by causing other device interruptions. If the user tries
everything and determines that a HBA reset is the right choice, provide that
option, don't do it for them.

	If every device attached to the HBA fails then resetting the HBA is a valid
choice, not before. Same for I_T.



