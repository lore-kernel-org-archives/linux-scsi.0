From: James.Smart@Emulex.Com
Subject: RE: One question about SCSI device hotplug
Date: Wed, 2 Mar 2005 10:51:47 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C1FD21D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:663 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S262333AbVCBPw2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 10:52:28 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: forrest.zhao@intel.com, Matt_Domsch@dell.com
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, ramesh.caushik@intel.com, sdake@mvista.com

> Thank you, Matt. Then I have another question:
> As we know SCSI mid-layer issue a command to LLDD by 
> host->hostt->queuecommand(cmd, scsi_done); and in the meantime a 
> timer is set. When the timer expires, SCSI mid-layer know the 
> execution of command has failed.
> My question is: when SCSI device is surprise-removed, if SCSI 
> mid-layer
> issue a command to this removed device, will mid-layer has to wait 
> a timeout before it can know the execution of command failed? Or is
> there
> any other mechanism that LLDD can notify mid-layer that execution of
> command failed without waiting for a timeout?

What we did in the FC transport - there's a transport level timeout at
the target level that controls how long we "insulate" the system from
the device's disappearance. When the device is first removed, the
transport has the midlayer suspend i/o (e.g block) the device, so no
i/o failures, other than timeouts on in-flight i/o's occur. As the
midlayer (for disk devices) typically retries i/o's, even the in-flight
errors don't result in an error to the application, as the retry get's
delayed due the blocked state of the device. If the device returns
within the insulation period, i/o resumes, and the system continues
happily along it's way. If the device does not return, the timeout
fires, and the device is restarted. The i/o then reaches the LLDD, who
is expected to fail the i/o immediately as the target doesn't exist.
The midlayer reacts accordingly and places the device into an offline
state.

If the device is readded, the LLDD sets the target to a good state, but
the midlayer keeps the devices in an offline state until steps are taken
to bring them back online. E.g. The admin takes whatever steps are
necessary to clean up the system for the previous failure of the device,
then brings the device online by writing the device state to running
and rescanning the device.

If multipath solutions are in place, they will want to set the
"insulation" timeout as low as possible so that access so that it's
alternate pathing can kick in as soon as possible.  The multipathing
solution, upon device re-addition, is required to take the steps to
bring the device back online.

-- james s 

