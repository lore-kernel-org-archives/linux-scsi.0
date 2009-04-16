From: James Smart <James.Smart@Emulex.Com>
Subject: Re: queue_depth tracking from LLD
Date: Thu, 16 Apr 2009 10:13:42 -0400
Message-ID: <49E73D16.9030307@emulex.com>
References: <20090416093604.GA7096@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60711 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZDPOOb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2009 10:14:31 -0400
In-Reply-To: <20090416093604.GA7096@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The mid-layer queue depth handling is really designed/optimized around 
behavior for
a JBOD. This, if it's a single-lun device, the LLDD could largely ignore 
doing anything
with adjusting the queue depth.

However, for arrays, with multiple luns, the queue depth is usually a 
target-level resource,
so the midlayer/block-layer's implementation falls on its face fairly 
quickly. I brought this
up 2 yrs ago at storage summit.  What needs to happen is the creation of 
queue ramp-down
and ramp-up policies that can be selected on a per-lun basis, and have 
these implemented
in the midlayer (why should the LLDD ever look at scsi command 
results).  What will make
this difficult is the ramp-up policies, as it can be very target 
device-specific or configuration/load
centric.

In the meantime, if you look at any LLDD that is worth its salt, and it 
will be implementing it's
own queue ramp-down and ramp-up algorithms internally. They will look 
for QUEUE_FULLs
to ramp-down, and selecting a rate and methodology for the ramp-up. They 
will use this routine
to do the queue depth changing.

-- james s


Christof Schmitt wrote:
> I just came across the SCSI midlayer function scsi_track_queue_full.
>
> If a SCSI command is returned with a status of QUEUE_FULL, then this
> is mapped to ADD_TO_MLQUEUE and "device blocked". So, there is already
> a mechanism in place. Is a LLD driver expected to additionally call
> something like this to decrease the queue depth?
>
> if (status_byte(scmd->result) == QUEUE_FULL)
> 	scsi_track_queue_full(sdev, sdev->queue_depth - 1))
>
> If a LLD does this, should it also increase the queue depth again when
> no more QUEUE_FULL status are seen? To me this looks like a
> duplication of the midlayer device blocking, but i assume there is a
> reason in having both, scsi_track_queue_full and the device blocking.
>
> --
> Christof Schmitt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
