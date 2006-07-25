From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] fc transport: extensions for fast fail and dev loss
Date: Tue, 25 Jul 2006 12:12:54 -0500
Message-ID: <44C65116.3030503@cs.wisc.edu>
References: <1150829123.16981.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53956 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932371AbWGYRMO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 13:12:14 -0400
In-Reply-To: <1150829123.16981.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Folks,
> 
> The following addresses some long standing todo items I've had in the
> FC transport. They primarily arise when considering multipathing, or
> trying to marry driver internal state to transport state. It is intended
> that this same type of functionality would be usable in other transports
> as well.
> 

I agree we need something like this. iSCSI is going to move to something
closer to FC in 2.6.19 to better integrate qla4xxx and give FC and iSCSI
a similar interface when it makes sense.

> Here's what is contained:
> 
> - dev_loss_tmo LLDD callback :
>   Currently, there is no notification to the LLDD of when the transport
>   gives up on the device returning and starts to return DID_NO_CONNECT
>   in the queuecommand helper function. This callback notifies the LLDD
>   that the transport has now given up on the rport, thereby acknowledging
>   the prior fc_remote_port_delete() call. The callback also expects the
>   LLDD to initiate the termination of any outstanding i/o on the rport.
> 

iSCSI does something like this at the lower level right now. For the
common lower level iscsi layer that software drivers share we have a
callback that allows drivers to do the same thing as your dev_loss_tmo
callback. When we move to the new model we will need something like this.

> - fast_io_fail_tmo and LLD callback:
>   There are some cases where it may take a long while to truly determine
>   device loss, but the system is in a multipathing configuration that if
>   the i/o was failed quickly (faster than dev_loss_tmo), it could be
>   redirected to a different path and completed sooner (assuming the 
>   multipath thing knew that the sdev was blocked).
>   
>   iSCSI is one of the transports that may vary dev_loss_tmo values
>   per session, and you would like fast io failure.
> 


Agree. Currently we are sort of doing this in userspace, but since
qla4xxx does more in the kernel we would like to move it there so
qla4xxxx and other HW iscsi cards do not have to jump to so many hoops
to use the functionality.


> - fast_loss_time recommendation:
>   In discussing how a admin should set dev_loss_tmo in a multipathing
>   environment, it became apparent that we expected the admin to know
>   a lot. They had to know the transport type, what the minimum setting
>   can be that still survives normal link bouncing, and they may even
>   have to know about device specifics.  For iSCSI, the proper loss time
>   may vary widely from session to session.
> 
>   This attribute is an exported "recommendation" by the LLDD and transport
>   on what the lowest setting for dev_loss_tmo should be for a multipathing
>   environment. Thus, the admin only needs to cat this attribute to obtain
>   the value to echo into dev_loss_tmo.
>  
> I have one criticism of these changes. The callbacks are calling into
> the LLDD with an rport post the driver's rport_delete call. What it means
> is that we are essentially extending the lifetime of an rport until the
> dev_loss_tmo call occurs.
> 

So is the fast_io_fail_tmo callback the terminate_rport_io callback? If
so, are we supposed to unblock the rport/session/target from
fc_timeout_fail_rport_io and call into the LLD and the LLD will set some
bit (or maybe check some rport/session/target/scsi_device bit) so that
incoming IO and IO sitting in the driver will be failed with something
like DID_BUS_BUSY so it goes to the upper layers? I think I only the
unblock happen on success or fc_starget_delete, so IO in the driver
looks like it can get failed upwards but IO sitting in the queue sits
there until fc_rport_final_delete or success.

If that is correct, what about a new device state? When the fail fast
tmo expires we can set the device to the new state, run the queue and
incoming IO or IO in the request_queue marked with FAILFAST can be
failed upwards by scsi-ml.

I just woke up though :)
