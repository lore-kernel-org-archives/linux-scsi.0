From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: FC transport: Calling fc_remote_port_add for online port
Date: Mon, 29 Jun 2009 15:52:04 +0200
Message-ID: <20090629135204.GA12016@schmichrtp.de.ibm.com>
References: <20090626152303.GA21058@schmichrtp.de.ibm.com> <4A44FA1C.9080207@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:36525 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZF2NwF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 09:52:05 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate7.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n5TDq5xi387664
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 13:52:05 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5TDq5JI1605808
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 14:52:05 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5TDq4oc018706
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 14:52:04 +0100
Content-Disposition: inline
In-Reply-To: <4A44FA1C.9080207@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jun 26, 2009 at 12:41:00PM -0400, James Smart wrote:
> The LLD should never be calling fc_remote_port_add() twice without an  
> intervening fc_remote_port_delete(). Which is another way of saying -  
> yes, it's what you say relative to the rport state values.
>
> The idea is - the LLD is tracking an external port structure, using  
> <portid, <wwnn,wwpn>> to track identity, and is keeping a "present" and  
> "not-present" case. If a new port is deemed "present", it calls  
> fc_remote_port_add() and when connectivity  is lost (aka goes to "not  
> present") to that port, it calls fc_remote_port_delete(). It should be  
> very straight forward.
>
> The rport structure itself, to aid the midlayer,  to hide temporary  
> connectivity losses due to link bounces, controller resets, etc - may  
> stay around after the delete call, and midlayer calls may enter the  
> driver for it, but the transport via helper functions, should pick them  
> off and reject them. Eventually, when the rport exceeds its max  
> connectivity loss hide value (devloss_tmo), the devloss_tmo_callbk() is  
> made to tell the driver the rport is truly gone (if it cares), and all  
> the midlayer structures and scsi objects below the rport are terminated.  
>  After this point, for target id bindings, we keep the rport structure 
> around - but only as a generic container to hold the binding values. For 
> all intents and purposes, there's no relationship to the old rport or the 
> old rport pointer value any more.  And if a port eventually comes back 
> that matches the bindings, we flip the binding container back into a real 
> rport structure as if we had just allocated it.
>
> -- james s

Thanks for clarifying this. So a LLD has to always follow the
add-delete sequence.

BTW: I think it could be useful to have this information about the
interface between LLD and FC transport in
Documentation/scsi/scsi_fc_transport.txt

--
Christof Schmitt
