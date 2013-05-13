From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Mon, 13 May 2013 16:29:32 -0400
Message-ID: <yq18v3ibp3n.fsf@sermon.lab.mkp.net>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
	<1368189791.3319.31.camel@localhost.localdomain>
	<CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com>
	<1368194460.3319.40.camel@localhost.localdomain>
	<CAC9+anK-E2pok_eU2EdZxgaBY7-68rbj19C7G4w5rhTmZB7vzw@mail.gmail.com>
	<518D55FA.4080302@suse.de>
	<CAC9+anKxnDBYh15uwQQoTUzGZkwUe6wuV=8wf6NUVsC4+_TUgw@mail.gmail.com>
	<51907E45.7010409@suse.de> <5190FB4E.4000900@tributary.com>
	<519100A5.2060509@suse.de> <51910DB0.70009@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46031 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3EMUag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 16:30:36 -0400
In-Reply-To: <51910DB0.70009@tributary.com> (Jeremy Linton's message of "Mon,
	13 May 2013 10:58:40 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Hannes Reinecke <hare@suse.de>, Baruch Even <baruch@ev-en.org>, emilne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

>>>>> "Jeremy" == Jeremy Linton <jlinton@tributary.com> writes:

Jeremy> Well, how about generating std inquiry against them if they are
Jeremy> idle and the given HBA has a device in error state? Then you can
Jeremy> make a rough approximation of what has failed, and escalate the
Jeremy> error handling if all the devices at a particular level have
Jeremy> failed.

It's not that simple, unfortunately. Some HBAs keep more state than
others. We see cases fairly often where a misbehaving target has
confused the HBA enough that we can not bring the device back without
doing an HBA firmware reset. Despite I/O completing successfully on
other targets connected to the same HBA.

So at some point we do need to give up and escalate to a full HBA
reset. We would just like to defer that hammer until we have run out of
other options.

-- 
Martin K. Petersen	Oracle Linux Engineering
