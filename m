From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/11] qla4xxx: set correct value in sess->recovery_tmo
Date: Tue, 22 Jun 2010 13:12:39 -0500
Message-ID: <4C20FD17.5040809@cs.wisc.edu>
References: <20100616205111.GA8149@sles11sp1b1.qlogic.org> <4C1BFA2D.6050607@cs.wisc.edu> <AC192039-EAE9-4625-8AF0-C4B9E1C8D47D@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47464 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0FVSKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2010 14:10:12 -0400
In-Reply-To: <AC192039-EAE9-4625-8AF0-C4B9E1C8D47D@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/21/2010 06:35 PM, Ravi Anand wrote:
> Mike,
>
> Actually, that's not true.
>

I think you are misunderstanding me.


> When we call iscsi_block_session(), session is already down and we are not
> sending any NOP.
>

I never said you were going to send a nop. I was saying that you guys 
said the ka_timeout is used to detemine when to send a nop.

You guys said:
<start>
It's time interval between connection keep-alive ping. When a connection
is idle for the connection keep-alive timeout interval, the ISP4xxx
sends an iSCSI NOP PDU to the other device that is part of the connection.
When the device responses to the NOP PDU, the connection remains open.
When the device fails to respond, the ISP4010 closes the connection
and informs the driver that the connection has gone down.
<end>

so I was saying if the session is down, nops cannot be sent so 
ka_timeout does not come into play at that time (it has already expired).

> FW closes connection after ka_timeout expire at FW level.  Then FW
> sends notification to driver for DDB state change which basically indicates
> that session is in failed state . After that driver mark device *missing* and call iscsi_block_sesstion().
> At this point iSCSI connection is already closed,  so FW is not sending
> any iSCSI NOP to target.

Yeah, that is what I was saying.

>
> We are just using value of ka_timeout in sess->recovery_tmo because
> we want to wait for some time for connection to comeback else
> mark device dead.

I agree 100% that you should have a timer to wait for the session to 
come back. libiscsi has the noop settings which is equivalent to your 
ka_timeout and then for the recovery_tmo we have the 
replacement/recovery_tmo setting. My point is that there is no 
requirement and no good reason to set sess->recovery_tmo based on the 
same setting.

I am saying ka_timeout is not used for the same operations as 
session->recovery_tmo. They handle two separate events, and should be 
two separate settings. Once ka_timeout has expired we have marked the 
session as down, and now we are on the recovery stage, so a new timer 
comes into play.

So ka_timeout is used to determine when we want to mark a session as bad.

session->recovery_tmo is used to determine when we want give up on the 
session.

They should be 2 different settings since testing a SAN/port can take 
different times than doing recovery of a session.
