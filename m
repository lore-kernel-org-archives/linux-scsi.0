From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Wed, 21 Oct 2009 13:11:15 -0500
Message-ID: <4ADF4EC3.6010506@cs.wisc.edu>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47222 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbZJUSLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 14:11:18 -0400
In-Reply-To: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Christof Schmitt wrote:
> I am looking again at how and when a FC LLD should call
> fc_remote_port_delete. Some help would be welcome to cover all
> requirements and to plug the holes...
> 
> One scenario i am looking at: The connection to the HBA has been
> temporarily lost and the LLD has to return all pending I/O requests to
> the upper layers, so they can be retried later. Now with the SCSI
> device being part of a multipath device, the first failed I/O request
> triggers path failover:
> 
> multipath_end_io
> do_end_io
> fail_path
> queue_work(kmultipathd, &pgpath->deactivate_path);
> 
> which then marks the following returned requests as timed out:
> 
> deactivate_path
> blk_abort_queue
> blk_abort_request
> blk_rq_timed_out
> scsi_times_out
> fc_timed_out
> 
> If the remote_port status is not BLOCKED, this will trigger the SCSI
> midlayer error handling which cannot do much during the interruption
> to the hardware and will mark the SCSI devices 'offline'. In order to
> prevent this, the rule would be: First call fc_remote_port_delete to
> set the remote port (or in the case of an HBA interruption all remote
> ports) to BLOCKED, and only after this step call scsi_done to pass the
> SCSI commands back to the upper layers.
> 

One other note when doing this.

For problems where you are deleting the rport, it is best to use 
something like DID_TRANSPORT_DISRUPTED to fail the cmd if you are 
failing it right away. If drivers block the rport, then fail commands 
immediately with DID_TRANSPORT_DISRUPTED, then they will not actually be 
failed to the block/mpath layer until the fast io fail timeout has 
fired. This will prevent very short problems from firing the mutlipath 
path offlining code.

If your driver deletes the rport and does not fail the cmd immediately 
so it can recover within the command or some other reason like the fw 
just works that way, then when the fast io fail timer fires and the 
terminate_rport_io callback is run you could actually use any error code 
since at this time when a IO is sent to the queuecommand the driver will 
call fc_remote_port_chkready and IO will be failed immediately with 
DID_TRANSPORT_FAILFAST).



