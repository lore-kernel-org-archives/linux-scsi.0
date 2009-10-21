From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Enabling MSIX and mcc_rings V2
Date: Wed, 21 Oct 2009 12:19:06 -0500
Message-ID: <4ADF428A.6020505@cs.wisc.edu>
References: <20091017011435.GA25197@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36406 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZJURTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 13:19:10 -0400
In-Reply-To: <20091017011435.GA25197@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

Jayamohan Kallickal wrote:
>  This patch
> 
>  1) Turns on msix
>  2) Adds mcc_ring support for sending FW commands
>  3) Adds Support for Ring Mode of WRB Posting
>  4) Adds sysfs for FW commands


I think msix should be a separate patch from the fw command one, and the 
ring mode changes could probably be in a separate patch too.



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
