From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH RFC 0/3] add fc transport events
Date: Fri, 28 May 2004 09:46:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF941412B.2BD1747B-ONC1256EA2.0029BCD9@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:23200 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S265861AbUE1HrB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2004 03:47:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>





> There are still some other large outstanding issues. For example the
> kobject_hotplug function must be called from a process context. I was not
> sure if the transport class should provide this, or is it the drivers
> responsibilty (some drivers have threads for work already),
> or should SCSI ML supply this as it may have to if it is going
> to provide events too.

The zfcp lldd also deploys threads to do link recovery. But I am not sure
whether the event
notifications we have been discussing would always fit into it. Other
lldd's might have no
threads at all. I tend to say that the midlayer should make sure that the
actual hotplug
calls are done in the right context in order to avoid duplicate pain in
various lldds.
Is there really no existing way to notify hotplug in a non-process context,
i.e. to have
hotplug schedule the actual work asynchronously?

Martin

