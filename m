From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] sdd scsi-ml event wq
Date: Thu, 3 Jun 2004 12:46:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF4949B6A8.0EE8EFCA-ONC1256EA8.0039AF13@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:65269 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S263174AbUFCKqx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2004 06:46:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>





> For the short term would it be best to harden the SCSI side of the API
then
> worry about the API we are using, or is the kobject_hotplug/userspace
route not
> looking to be the best option?

I am not sure for what other events this interface is going to be used.
However, for link down/up events there might be a feasible solution.
The minimum requirement is to ensure that paths are re-enabled on
link-up. If we use a flag in scsi_device for the link status, a flag in
scsi_device that indicates whether an event could be propagated,
and one spare buffer for an event then there should always be a way
to report a link-up event. If the spare buffer is being used when a
link-up event occurs, just set the scsi_device->linkup flag as well as
the scsi_device->lostevent flag and report the event later when the
spare buffer has been freed, provided that scsi_device->lostevent
was set. Which means that we might skip a few events in case of a
rapidly changing link status. But we would always report - with a minor
delay - the last, and therewith most important link event.

Martin

