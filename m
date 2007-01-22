From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Mon, 22 Jan 2007 17:47:40 +0100
Message-ID: <45B4EAAC.5000008@s5r6.in-berlin.de>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org> <b43c8fc9882e65d397a6465e6cb7c998@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:33467 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXAVQrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 11:47:42 -0500
In-Reply-To: <b43c8fc9882e65d397a6465e6cb7c998@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aboo <aboo@aboo.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

aboo wrote:
> Can I use the following method safely to know if a scsi_device is
> open or not?
> 
> if ( atomic_read(&sdev->sdev_gendev.kobj.kref.refcount) > 14 ) {
>   //sdev is in use
> }

No, this too relies far too much on implementation details of upper
layers. (Besides, what if the device is opened right after that? The
atomic refcount is not enough, something mutex-like would be necessary
to do anything useful with the information "open"/"not open".) Ideally,
your LLD sticks with what the Linux SCSI mid-low API has to offer. Thus
your LLD is only aware of this API, but *not* of implementation details
of the SCSI core, let alone SCSI high-level drivers or block I/O
subsystem or whatever other upper layer.

And in the end, why should vscsihba care whether a scsi_device is in use
or not? If a userspace device server quits or got killed or crashed,
"simply" let vscsihba request the removal of the scsi_device (or the
entire host if there is only one device per host). Whoever opened the
device cannot do anything useful with it anymore anyway when there is no
device server.

Of course it is not entirely as "simple" as it sounds. As mentioned, if
vscsihba becomes aware that a device server quit or crashed, let your
queuecommand hook finish all newly incoming commands immediately instead
of enqueueing them. Dequeue and finish all outstanding commands. Make
sure the eh hooks don't wait for something that can't happen anymore.
Note that when the removal of a device is requested, shutdown methods of
high-level drivers like sd become active and may try to issue new
commands (such as to synchronize disk caches). Therein lies potential
for deadlocks or, less critically, for minutes and minutes spent in
futile error recovery attempts.

So, I said you should ignore the in-use state of a scsi_device. Of
course that way you cannot give the userspace device server a status
notification from vscsihba which says "keep running for now, somebody is
using your device", or vice versa: "your last user went away, you can
safely quit now if you feel like it". But in my opinion you don't really
need such status notification in foreseeable future. vscsihba would
primarily or exclusively be used in controlled setups where the
administrator knows very well when it is safe to terminate a userspace
device server. Besides, you have to take into account anyway that a
userspace device server is killed or crashed when its device was in use.

As I wrote before, deal with it like with hot-unplug. A kernel driver
cannot prevent the user from pulling a cable.
-- 
Stefan Richter
-=====-=-=== ---= =-==-
http://arcgraph.de/sr/
