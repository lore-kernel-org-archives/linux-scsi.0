From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 10:58:40 -0500
Message-ID: <51910DB0.70009@tributary.com>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain> <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com> <1368194460.3319.40.camel@localhost.localdomain> <CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com> <518D55FA.4080302@suse.de> <CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com> <51907E45.7010409@suse.de> <5190FB4E.4000900@tributary.com> <519100A5.2060509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.57]:44512 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab3EMP6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 11:58:48 -0400
In-Reply-To: <519100A5.2060509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Baruch Even <baruch@ev-en.org>, emilne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On 5/13/2013 10:03 AM, Hannes Reinecke wrote:
> The other LUNs haven't reported an error. But how do you know whether they
> are still okay? The other LUNs might simply be idle, and no commands have
> been send to them.

	Well, how about generating std inquiry against them if they are idle and the
given HBA has a device in error state? Then you can make a rough approximation
of what has failed, and escalate the error handling if all the devices at a
particular level have failed.

	The midlayer may not even need to send the inquiries. If the individual
device drivers (sd/st/etc) are responsible for monitoring and error recovery
then they can be tasked with determining device availability as well. I think
this solves other problems too. For example, the use of TUR in the midlayer,
is a problem because it doesn't have enough knowledge about the possible check
conditions being returned to act on them appropriately.







