From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2
Date: Wed, 21 Oct 2009 11:10:43 -0700
Message-ID: <20091021181043.71aff47a@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail96.messagelabs.com ([216.82.254.19]:14564 "EHLO
	mail96.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZJUSKl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 14:10:41 -0400
In-Reply-To: 4ADF428A.6020505@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

_____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org
Sent: Wed, 21 Oct 2009 10:19:06 -0700
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2

Jayamohan Kallickal wrote:
>  This patch
> 
>  1) Turns on msix
>  2) Adds mcc_ring support for sending FW commands
>  3) Adds Support for Ring Mode of WRB Posting
>  4) Adds sysfs for FW commands


I think msix should be a separate patch from the fw command one, and the 
ring mode changes could probably be in a separate patch too.

Will Do that

> +
> +static void beiscsi_async_link_state_process(struct beiscsi_hba *phba,
> +		struct be_async_event_link_state *evt)
> +{
> +	switch (evt->port_link_status) {
> +	case ASYNC_EVENT_LINK_DOWN:
> +		SE_DEBUG(DBG_LVL_1, "Link Down on Physical Port %d \n",
> +						evt->physical_port);
> +		break;


When you get a link down, does it cause the fw do start iscsi recovery 
or does it send the driver a notification that a command is failed due 
to the link down. For example if we were doing erl0, and the link is 
gone, would the fw return some error for each command?


For link down maybe you want to fire a iscsi conn error for each 
session/connection on the port, so that way the iscsi layer can block 
the sessions and start recovery.

 The FW will report LINKDOWN event almost immediately when the event is noticed.

Some thoughts on the implementation 

1) Rather than immediately  shutting down all the sessions , wait for a predetermined
 time ,say, 10 Secs(if the user has pulled the cable and is connecting it back ,for eg, to
connect to a different port on the switch etc). Since IO's will not exceed the Queue  Depth,  this should be fine. However, for MPIO, we may need to load with a parameter (or something  better) so that we will fail immediately and IO's can be switched over to other port faster.

2) Since this function to shutdown sessions will be used by many drivers , shall we make this
   part of libiscsi. Can do this.


2) Since this is 

2)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

